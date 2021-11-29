const ON_SELL = 493294;
const MEAL = 5;
const OTHER = 6;

class npc_Sale extends npc_Sale_GUI
{
	constructor()
	{
		base.constructor();
		
		opened = false;
	}
	
	function open(params)
	{
		base.show();
		base.addItems(params);
		setFreeze(true);
		Camera.enableMovement(false);
		setCursorVisible(true);
		opened = true;
	}
	
	function close()
	{
		base.hide();
		setFreeze(false);
		Camera.enableMovement(true);
		setCursorVisible(false);
		opened = false;
		end_interaction();
	}
	
	function onRender()
	{
		if (opened == true && box == null)
			base.onRender();
	}
	
	function onKey(key)
	{
		if (key == KEY_ESCAPE) {
			if (box == null)
				close();
			else {
				box.hide();
				box = null;
				base.navMenu().show();
			}
		}
		
		if (key == KEY_RETURN) {
			if (box != null) {
				onReleaseNavi(box.getOkButton());
			}
		}
	}
	
	function onClick(key)
	{
		if (opened == true && box == null)
			base.onClick(key);
	}
	
	function onRelease(key)
	{
		if (opened == true && box == null)
			base.onRelease(key);
	}
	
	function onWheel(key)
	{
		if (opened == true && box == null)
			base.onWheel(key);
	}
	
	function onReleaseNavi(btn)
	{
		if (btn == base.getCloseButton())
			close();
		
		if (btn == base.getSellButton()) {
			if (base.getSelected() != null) {
				if (base.getSelected().type == OTHER || base.getSelected().type == MEAL) {
					box_selected = base.getSelected();
					box = tradeBox(returnItem(base.getSelected().inst).name);
					box.show();
					box.setText(1);
					base.navMenu().hide();
					return;
				}
				
				local item = base.getSelected();
				local packet = Packet();
				
				packet.writeInt32(ON_SELL);
				packet.writeInt32(item.id);
				packet.writeInt32(1);
				packet.send(RELIABLE_ORDERED);
			}
		}
		
		if (box != null) {
			if (btn == box.getCloseButton()) {
				box.hide();
				box = null;
				base.navMenu().show();
			}
			
			if (btn == box.getOkButton()){
				local packet = Packet();
				
				packet.writeInt32(ON_SELL);
				packet.writeInt32(box_selected.id);
				packet.writeInt32(box.getText());
				packet.send(RELIABLE_ORDERED);
				
				box.hide();
				box = null;
				base.navMenu().show();
			}
		}
	}
	
	function onSell(id, amount)
	{
		base.onSell(id, amount);
	}
	
	opened = null;
	box = null;
	box_selected = null;
}

npcSale <- npc_Sale();

local npcsale_render = 0;

addEventHandler("onRender", function() {
	if (npcsale_render < getTickCount()) {
		npcSale.onRender();
		npcsale_render += 100;
	}
});

addEventHandler("onKey", function(key) {
	if(player.logged == true)
		npcSale.onKey(key);
});

addEventHandler("onMouseClick", function(key) {
	npcSale.onClick(key);
});

addEventHandler("onMouseRelease", function(key) {
	npcSale.onRelease(key);
});

addEventHandler("onMouseWheel", function(key) {
	npcSale.onWheel(key);
});

const SELL_OPEN = 4023133;

local function npcsale_packet(packet)
{
	if (packet.readInt32() == SELL_OPEN) {
		local length = packet.readInt32();
		
		if (length < 1)
			return npcSale.open([]);
		
		local params = [];
		
		for (local i = 1; i <= length; ++i) {
			params.append({ id = packet.readInt32(), inst = packet.readString(), amount = packet.readInt32(), price = packet.readInt32(), upgrade = packet.readInt32() });
		}
		
		npcSale.open(params);
	}
}

addEventHandler("onPacket", npcsale_packet);