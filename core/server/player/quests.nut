const QUEST_PACKET = 892374;

local __quests = [];

function createQuest(params)
{
	return __quests.append(params);
}

function returnQuest(inst)
{
	foreach(v in __quests) {
		if (v.inst == inst) {
			return v;
		}
	}
	
	return false;
}

class quests
{
	function sendQuestPacket(pid, params)
	{
		local packet = Packet();
		packet.writeInt32(QUEST_PACKET);
		packet.writeString(params.inst);
		packet.writeString(params.name);
		packet.writeString(params.desc);
		packet.writeInt32(params.type);
		
		if (params.addit == false)
			packet.writeBool(false);
		else {
			packet.writeBool(true);
			packet.writeString(params.addit.code);
			packet.writeInt32(params.addit.amount);
			packet.writeInt32(params.addit.current);
		}
		
		packet.writeInt32(params.id);
		
		packet.send(pid, RELIABLE_ORDERED);
	}
	
	function addQuest(pid, params)
	{
		get(pid).quest_id += 1;
		
		if (typeof params == "string")
			params = returnQuest(params);
		
		params.id <- get(pid).quest_id;
		
		sendQuestPacket(pid, params);
		
		return get(pid).quests.append(params);
	}
	
	function removeQuest(pid, id)
	{
		foreach(i, v in get(pid).quests) {
			if (v.id == id) {
				return get(pid).quests.remove(i);
			}
		}
		
		return false;
	}
	
	function getQuest(pid, id)
	{
		foreach(i, v in get(pid).quests) {
			if (v.id == id) {
				return v;
			}
		}
		
		return false;
	}
	
	function hasQuest(pid, inst)
	{
		foreach(i, v in get(pid).quests) {
			if (v.inst == inst)
				return true;
		}
		
		return false;
	}
}

function dropQuest(pid, params)
{
	player.addQuest(pid, params);
	statement(pid, 200, 200, 200, "New quest!");
}