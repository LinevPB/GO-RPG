enum q
{
	get = 1,
	kill = 2,
	done = 3,
	addit = 4
}

local test = null;

class questSystem extends questGUI
{
	constructor()
	{
		base.constructor();
	
		opened = false;
	}
	
	function onKey(key)
	{
		if (key == KEY_O && chatInputIsOpen() == false) {
			if (inventory.opened == false && player.interacting == false && player.logged == true && stats.opened == false) {
				toggle();
			}			
		}
		
		if (key == KEY_ESCAPE) {
			if (opened == true)
				close();
		}
		
		base.onKey(key);
	}
	
	function onClick(key)
	{
		if (opened == true)
			base.onMouseClick(key);
	}
	
	function onRelease(key)
	{
		if (opened == true)
			base.onRelease(key);
	}
	
	function onScroll(key)
	{
		if (opened == true)
			base.onScroll(key);
	}
	
	function toggle()
	{
		opened ? close() : open();
	}
	
	function open()
	{
		base.show();
		opened = true;
		setCursorVisible(true);
		setFreeze(true);
		Camera.enableMovement(false);
	}
	
	function close()
	{
		base.hide();
		opened = false;
		setCursorVisible(false);
		setFreeze(false);
		Camera.enableMovement(true);
	}
	
	function addQuest(params)
	{
		if (quests_amount <= quests_limit) {
			local quest = {};
			
			quests_id++;
			
			quest.id <- params.id;
			quest.complete <- false;
			quest.name <- params.name;
			quest.desc <- params.desc;
			quest.type <- params.type;
			quest.addit <- params.addit;
			
			quests.append(quest);
			
			base.addQuestDraw(quest);
			
			quests_amount++;
			
			return quest;
		}
		
		return false;
	}
	
	function removeQuest(quest)
	{
		if (quest != null) {
			foreach(i, v in quests) {
				if (v.id == quest.id) {
					base.removeQuest(quest.id);
					
					quests.remove(i);
					
					quests_amount = quests_amount - 1;
					
					return true;
				}
			}
		}
		
		return false;
	}
	
	function updateQuest(mq, complete, amount)
	{
		foreach(v in quests) {
			if (mq == v.id) {
				v.complete = complete;
				v.addit.current = amount;
			}
		}
	}
	
	function onRender()
	{
		foreach(v in quests) {
			switch(v.type) {
				case q.get:				
					local item = inventory.getItemSlot(v.addit.code);
					
					if (item != false) {
						v.addit.current = item.amount;
						
						local isComplete = false;
						
						if (item.amount >= v.addit.amount)
							isComplete = true;
						
						updateQuest(v.id, isComplete, item.amount);
					} else {
						updateQuest(v.id, false, 0);
					}
					
					updateProgress(v, returnItem(v.addit.code).name + ": " + v.addit.current + "/" + v.addit.amount);
				break;
				
				case q.kill:
					updateProgress(v, v.addit.code + " killed" + ": " + v.addit.current + "/" + v.addit.amount);
				break;
				
				case q.done:
					updateProgress(v, "Mission complete!");
				break;
			}
		}
		
		if (opened == true)
			base.onRender();
	}
	
	function onReleaseNavi(id)
	{
		if (id == close_btn) {
			close();
		}
	}
	
	opened = false;
	quests = [];
	quests_amount = 0;
	quests_limit = 30;
	quests_id = 0;
}

quests <- questSystem();

local quests_render = 0;

addEventHandler("onRender", function(){
	if (quests_render < getTickCount()) {
		quests.onRender();
	}
	
	quests_render += 50;
});

addEventHandler("onMouseClick", function(btn) {
	quests.onClick(btn);
});

addEventHandler("onMouseRelease", function(btn) {
	quests.onRelease(btn);
});

addEventHandler("onMouseWheel", function(btn) {
	quests.onScroll(btn);
});

addEventHandler("onKey", function(btn) {
	if (player.logged == true)
		quests.onKey(btn);
});

const QUEST_PACKET = 892374;

addEventHandler("onPacket", function(packet) {
	if (packet.readInt32() == QUEST_PACKET) {
		local params = {
			inst = null,
			name = null,
			desc = null,
			type = null,
			addit = null
		};
		
		params.inst = packet.readString();
		params.name = packet.readString();
		params.desc = packet.readString();
		params.type = packet.readInt32();
		if (packet.readBool() == false) {
			params.addit = false;
		} else { 
			params.addit = {
				code = null,
				amount = null,
				current = null
			};
			
			params.addit.code = packet.readString();
			params.addit.amount = packet.readInt32();
			params.addit.current = packet.readInt32();
		}
		params.id <- packet.readInt32();
		
		quests.addQuest(params);
	}
});