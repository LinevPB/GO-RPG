enum MENU {
	open = 907,
	close = 908,
	release = 909
}

local npc_menu = {};

function openNpcMenu(id, options)
{
	foreach(v in _getNpcMenus()) {
		if (id == v.menu_id) {
			_showNpcMenu(id);
			
			return;
		}
	}
	
	npc_menu[id] <- npcMenu(id, options);
	_showNpcMenu(id);
}

function closeNpcMenu(id)
{
	_closeNpcMenu(id);
}

function onChangeNpcMenuOption(menu)
{
	local menu_id = menu.menu_id;
	local current = menu.current;

	
}

function onClickNpcMenu(menu)
{
	local menu_id = menu.menu_id;
	local current = menu.current;

	//callServerFunc("onClickNpcMenu", heroId, menu_id, current);
}

function onReleaseNpcMenu(id, current)
{
	local packet = Packet();
	packet.writeInt32(MENU.release);
	packet.writeInt32(heroId);
	packet.writeInt32(id);
	packet.writeInt32(current);
	
	packet.send(RELIABLE_ORDERED);
}

local function on_menu_packet(packet)
{
	local packetid = packet.readInt32();
	if (packetid == MENU.open) {
		local id = packet.readInt32();
		local amount = packet.readInt32();

		local options = [];
		
		for(local i = 1; i <= amount; ++i) {
			options.append(packet.readString());
		}
		
		openNpcMenu(id, options);
	}
	
	if (packetid == MENU.close) {
		local id = packet.readInt32();
		
		closeNpcMenu(id);
	}
}

addEventHandler("onPacket", on_menu_packet);