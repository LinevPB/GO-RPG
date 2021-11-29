function onBuy(pid, inst, cost, amount)
{
	if (amount > 0) {
		if (player.getItemsAmount(pid) >= 60) {
			statement(pid, 255, 0, 0, "Insufficient inventory space!");
		} else {
			if (player.getGold(pid) - cost  * amount < 0) {
				statement(pid, 255, 0, 0, "Not enough gold!");
			} else {
				player.setGold(pid, player.getGold(pid) - cost * amount);
				player.addItem(pid, inst, amount);
				statement(pid, 0, 255, 0, "Bought " + returnItem(inst).name + " x" + amount + "!");
			}
		}
	} else {
		statement(pid, 255, 0, 0, "Amount has to be more than 0!");
	}
}

const ON_BUY = 60623;

local function onbuy_handler(pid, packet)
{
	if (packet.readInt32() == ON_BUY) {
		onBuy(pid, packet.readString(), packet.readInt32(), packet.readInt32());
	}
}

addEventHandler("onPacket", onbuy_handler);