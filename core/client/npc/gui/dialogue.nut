enum DIALOGUE {
	start = 9910,
	finish = 9911
};

local ss = {};

function startDialogue(id, lines)
{
	ss[id] <- npcDialogue(id, lines);
	ss[id].show();
}

local function on_dialogue_packet(packet)
{
	local packetid = packet.readInt32();
	
	if (packetid == DIALOGUE.start) {
		local id = packet.readInt32();
		local amount = packet.readInt32();
		
		local lines = [];
		
		for(local i = 1; i <= amount; ++i) {
			lines.append(packet.readString());
		}
		
		startDialogue(id, lines);
	}
}

addEventHandler("onPacket", on_dialogue_packet);