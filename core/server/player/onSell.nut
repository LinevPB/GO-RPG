const REMOVE_ITEM = 555;
const DECREASE_AMOUNT = 5554;

function onSell(pid, item_id, amount)
{
	if (amount > 0) {
		local it = player.getItemAmount(pid, item_id)
		
		if (it - amount == 0) {
			local packet = Packet();
			packet.writeInt32(REMOVE_ITEM);
			packet.writeInt32(item_id);
			packet.send(pid, RELIABLE_ORDERED);
		} else if (it - amount > 0) {
			local packet = Packet();
			packet.writeInt32(DECREASE_AMOUNT);
			packet.writeInt32(item_id);
			packet.writeInt32(amount);
			packet.send(pid, RELIABLE_ORDERED);
		} else if (it - amount < 0) {
			return statement(pid, 255, 0, 0, "Not enough amount!");
		}
		local item = returnItem(player.getItemById(pid, item_id).inst);
		player.setGold(pid, player.getGold(pid) + item.price * amount);
		statement(pid, 255, 255, 0, item.name + " x" + amount + " sold!");
	} else {
		statement(pid, 255, 0, 0, "Amount has to be more than 0!");
	}
}

////////////////////////////

const ON_SELL = 493294;

local function sell_packet(pid, packet)
{
	if (packet.readInt32() == ON_SELL) {
		onSell(pid, packet.readInt32(), packet.readInt32());
	}
}

addEventHandler("onPacket", sell_packet);