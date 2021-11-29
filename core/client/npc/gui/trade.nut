const ON_BUY = 60623;
const TRADE_OPEN = 4023;
const MEAL = 5;
const OTHER = 6;

local trades = [];

class npcTrade extends npc_tradeGUI
{
	constructor(_id, params)
	{
		base.constructor(params);
		id = _id;
		trades.append(this);
	}
	
	function open()
	{
		base.show();
		setCursorVisible(true);
		setFreeze(true);
		Camera.enableMovement(false);
		opened = true;
	}
	
	function close()
	{
		base.hide();
		setCursorVisible(false);
		setFreeze(false);
		Camera.enableMovement(true);
		opened = false;
		end_interaction();
	}
	
	function toggle()
	{
		opened ? close() : open();
	}
	
	function onRender()
	{
		if (box == null)
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
		if (box == null)
			base.onClick(key);
	}
	
	function onRelease(key)
	{
		if (box == null)
			base.onRelease(key);
	}
	
	function onWheel(key)
	{
		if (box == null)
			base.onWheel(key);
	}
	
	function onReleaseNavi(btn)
	{
		if (btn == base.getCloseButton()) {
			close();
		}
		
		if (btn == base.getBuyButton()) {
			if (base.getSelected() != null) {
				local inst = base.getSelected().instance;
				local price = base.getSelected().price;
				
				if (returnItem(inst).type == OTHER || returnItem(inst).type == MEAL) {
					box_selected = base.getSelected();
					box = tradeBox(returnItem(base.getSelected().instance).name);
					box.show();
					box.setText(1);
					base.navMenu().hide();
					return;
				}
				
				local packet = Packet();
				packet.writeInt32(ON_BUY);
				packet.writeString(inst);
				packet.writeInt32(price);
				packet.writeInt32(1);
				packet.send(RELIABLE_ORDERED);
			}
		}
		
		if (box != null) {
			if (btn == box.getCloseButton()) {
				box.hide();
				box = null;
				box_selected = null;
				base.navMenu().show();
			}
			
			if (btn == box.getOkButton()) {
				local packet = Packet();
				packet.writeInt32(ON_BUY);
				packet.writeString(box_selected.instance);
				packet.writeInt32(box_selected.price);
				packet.writeInt32(box.getText());
				packet.send(RELIABLE_ORDERED);
				box.hide();
				box = null;
				box_selected = null;
				base.navMenu().show();
			}
		}
	}
	
	opened = false;
	id = null;
	box = null;
	box_selected = null;
}

/////////////////////////

local trade_render = 0;

addEventHandler("onRender", function(){
	if (trade_render < getTickCount()) {
		foreach(v in trades) {
			if (v.opened == true) {
				v.onRender();
			}
		}
	}
	
	trade_render += 100;
});

addEventHandler("onMouseClick", function(key){
	foreach(v in trades) {
		if (v.opened == true) {
			v.onClick(key);
		}
	}
});

addEventHandler("onKey", function(key){
	foreach(v in trades) {
		if (v.opened == true && player.logged == true) {
			v.onKey(key);
		}
	}
});

addEventHandler("onMouseRelease", function(key){
	foreach(v in trades) {
		if (v.opened == true) {
			v.onRelease(key);
		}
	}
});

addEventHandler("onMouseWheel", function(key){
	foreach(v in trades) {
		if (v.opened == true) {
			v.onWheel(key);
		}
	}
});

function onTradeRelease(btn)
{
	foreach(v in trades) {
		if (v.opened == true) {
			v.onReleaseNavi(btn);
		}
	}
}

local function trade_packet(packet)
{
	if (packet.readInt32() == TRADE_OPEN) {
		local id = packet.readInt32();
		
		foreach(v in trades) {
			if (v.id == id) {
				return v.open();
			}
		}
		
		local length = packet.readInt32();
		local params = [];
		
		for(local i = 1; i <= length; ++i) {
			params.append({ inst = packet.readString(), price = packet.readInt32() });
		}
		
		local x = npcTrade(id, params);
		x.open();
	}
}

addEventHandler("onPacket", trade_packet);