enum MENU {
	open = 907,
	close = 908,
	release = 909
}

enum DIALOGUE {
	start = 9910,
	finish = 9911
}

enum TRADE {
	open = 4023,
	close = 4024
}

const SELL_OPEN = 4023133;

////////////////

function openMenu(pid, menu_id)
{
	local packet = Packet();
	packet.writeInt32(MENU.open);
	packet.writeInt32(menu_id.id);
	packet.writeInt32(menu_id.options.len());
	
	foreach(v in menu_id.options) {
		packet.writeString(v);
	}
	
	packet.send(pid, RELIABLE_ORDERED);
}

function closeMenu(pid, menu_id)
{
	local packet = Packet();
	packet.writeInt32(MENU.close);
	packet.writeInt32(menu_id.id);
	
	packet.send(pid, RELIABLE_ORDERED);
}

/////////////

function openSale(pid)
{
	local packet = Packet();
	packet.writeInt32(SELL_OPEN);
	packet.writeInt32(player.getItems(pid).len());
	
	foreach(v in player.getItems(pid)) {
		packet.writeInt32(v.id);
		packet.writeString(v.inst);
		packet.writeInt32(v.amount);
		packet.writeInt32(returnItem(v.inst).price);
		packet.writeInt32(v.upgrade);
	}
	
	packet.send(pid, RELIABLE_ORDERED);
}

/////////////

function openTrade(pid, trade_id)
{
	local packet = Packet();
	packet.writeInt32(TRADE.open);
	packet.writeInt32(trade_id.id);
	packet.writeInt32(trade_id.options.len());
	
	foreach(v in trade_id.options) {
		packet.writeString(v.inst);
		packet.writeInt32(v.price);
	}
	
	packet.send(pid, RELIABLE_ORDERED);
}

/////////////

function startInteraction(pid)
{
	callClientFunc(pid, "start_interaction");
}

function endInteraction(pid)
{
	callClientFunc(pid, "end_interaction");
}

///////////////

function startDialogue(pid, dlg)
{
	local packet = Packet();
	packet.writeInt32(DIALOGUE.start);
	packet.writeInt32(dlg.id);
	packet.writeInt32(dlg.options.len());
	
	foreach(v in dlg.options) {
		packet.writeString(v);
	}
	
	packet.send(pid, RELIABLE_ORDERED);
}

///////////////

local function son_menu_packet(pid, packet)
{
	if (packet.readInt32() == MENU.release) {
		local hid = packet.readInt32();
		local id = packet.readInt32();
		local curr = packet.readInt32();
		
		onReleaseNpcMenuOption(pid, _getNpcMenu(id), curr);
	}
}

addEventHandler("onPacket", son_menu_packet);

///////////////

local function son_dialogue_packet(pid, packet)
{
	if (packet.readInt32() == DIALOGUE.finish) {
		local id = packet.readInt32();
		
		onFinishDialogue(pid, _getNpcDialogue(id));
	}
}

addEventHandler("onPacket", son_dialogue_packet);