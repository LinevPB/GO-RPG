function onConsume(pid, inst)
{
	local item = returnItem(inst);
	
	if (item.event != false) {
		item.event(pid);
	}
}

const ON_CONSUME = 123997;

local function consume_packet(pid, packet)
{
	if (ON_CONSUME == packet.readInt32()) {
		onConsume(pid, packet.readString());
	}
}

addEventHandler("onPacket", consume_packet);