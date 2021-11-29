const ON_CONSUME = 123997;
const ADD_ITEM = 444;
const REMOVE_ITEM = 555;
const DECREASE_AMOUNT = 5554;

enum eq {
	armor = 1,
	melee = 2,
	ranged = 3,
	magic = 4,
	meal = 5,
	other = 6,
	none = 7,
}

function percentage(x, y)
{
	for(local i = 1; i <= 100; ++i) {
		if (y * 0.01 * i >=x) {
			return i;
		}
	}
	
	return (x/y * 100).tointeger();
}

local test_id = 0;

class inventorySystem extends inventoryGUI
{
	constructor()
	{
		base.constructor();
	}
	
	function keyHandler(key)
	{
		if (key == KEY_I && chatInputIsOpen() == false) {
			toggle();
		}
		
		if (key == KEY_ESCAPE) {
			if (opened == true) {
				close();
			}
		}
		
		if (key == KEY_O) {
			local packet = Packet();
			packet.writeInt32(1234567123);
			packet.send(RELIABLE_ORDERED);
		}
	}
	
	function open()
	{
		opened = true;
		base.show();
		setCursorVisible(true);
		setFreeze(true);
		Camera.enableMovement(false);
	}
	
	function close()
	{
		opened = false;
		base.hide();
		setCursorVisible(false);
		setFreeze(false);
		Camera.enableMovement(true);
	}
	
	function toggle()
	{
		if (player.logged == true && player.interacting == false && quests.opened == false && stats.opened == false)
			opened ? close() : open();
	}
	
	function onRender()
	{
		if (opened == true) {
			base.onRender();
			
			nameChanging(base.getSelectedSlot());
		}
	}
	
	function nameChanging(dn)
	{	
		local select = dn;
		
		if (select != null) {
			switch(select.item_params.type) {
				case eq.melee:
					if (melee == false || (melee != false && melee!= select)) {
						base.changeUseText("Equip");
					} else if (melee != false && melee == select) {
						base.changeUseText("Unequip");
					}
				break;
				
				case eq.armor:
					if (armor == false || (armor != false && armor!= select)) {
							base.changeUseText("Equip");
						} else if (armor != false && armor == select) {
							base.changeUseText("Unequip");
						}
				break;
				
				case eq.ranged:
					if (ranged == false || (ranged != false && ranged!= select)) {
							base.changeUseText("Equip");
						} else if (ranged != false && ranged == select) {
							base.changeUseText("Unequip");
						}
				break;
				
				default:
					base.changeUseText("Use");
				break;
			}
		} else {
			base.changeUseText("Use");
		}
	}
	
	function onClick(btn)
	{
		if (opened == true)
			base.onClick(btn);
	}
	
	function onRelease(btn)
	{
		if (opened == true)
			base.onRelease(btn);
	}
	
	function addItem(_params, amount = -1, item_id = -1)
	{
		local params;
		
		if (typeof _params == "string")
			params = returnItem(_params);
		else
			params = _params;
		
		if (amount == -1)
			params.amount <- 1;
		else
			params.amount <- amount;
		
		///////
			if (params.type == (eq.meal || eq.other)) {
				foreach(v in items) {
					if(v.inst == params.inst) {
						base.increaseAmount(v, params.amount);
						v.amount += params.amount;
						base.sortByAmount(params.type);
						
						return;
					}
				}
			}
		///////
		
		params.event <- false;
		
		if (getFirstFreeSlot() != false) {
			if (item_id == -1)
				params.item_id <- 100 + items_id;
			else
				params.item_id <- item_id;
			
			items_id++;
			
			local item = params;
			
			item.slot <- getFirstFreeSlot();
			
			items.append(item);
			
			base.addToSlot(item.slot, params);
			base.sortItems();
			
			if (params.type == (eq.meal || eq.other))
				base.sortByAmount(params.type);
			
			return params.item_id;
		}
		
	}
	
	function removeItem(slot)
	{
		local packet = Packet();
		
		packet.writeInt32(REMOVE_ITEM);
		packet.writeInt32(slot.item_id);
		packet.send(RELIABLE_ORDERED);
		
		switch(slot) {
			case armor:
				unequipArmor(heroId);
				armor = false;
			break;
			
			case melee:
				unequipMeleeWeapon(heroId);
				melee = false;
			break;
				
			case ranged:
				unequipRangedWeapon(heroId);
				ranged = false;
			break;
		}
		
		foreach(i, v in items) {
			if (v.item_id == slot.item_id) {
				items.remove(i);
				
				break;
			}
		}
		
		base.removeItem(slot);
		base.sortItems();
	}
	
	function decreaseAmount(slot, amount)
	{
		local packet = Packet();
		
		packet.writeInt32(DECREASE_AMOUNT);
		packet.writeInt32(slot.item_id);
		packet.writeInt32(amount);
		
		packet.send(RELIABLE_ORDERED);
		
		base.decreaseAmount(slot, amount);
	}
	
	function onReleaseNaviButton(id)
	{
		if (opened == true) {
			if (id == base.getCloseButton()) {
				close();
			}
			
			if (id == base.getThrowAwayButton()) {
				if (getSelectedSlot() != null) {
					if (getSelectedSlot().amount > 0) {
						removeItem(getSelectedSlot());
					}
				}
			}
			
			if (id == base.getUseButton()) {
				local slot = base.getSelectedSlot();
				
				if (slot != null) {
					switch(slot.item_params.type) {
						case eq.armor:
							if (armor != false) {
								if (armor == slot) {
									unequipArmor(heroId);
									base.onUnequip(armor);
									armor = false;
								} else {
									unequipArmor(heroId);
									base.onUnequip(armor);
									equipArmor(heroId, Items.id(slot.item_params.code));
									armor = slot;
									base.onEquip(armor);
								}
							} else {
								equipArmor(heroId, Items.id(slot.item_params.code));
								armor = slot;
								base.onEquip(armor);
							}
						break;
						
						case eq.melee:
							if (melee != false) {
								if (melee == slot) {
									unequipMeleeWeapon(heroId);
									base.onUnequip(melee);
									melee = false;
								} else {
									unequipMeleeWeapon(heroId);
									base.onUnequip(melee);
									equipMeleeWeapon(heroId, Items.id(slot.item_params.code));
									melee = slot;
									base.onEquip(melee);
								}
							} else {
								equipMeleeWeapon(heroId, Items.id(slot.item_params.code));
								melee = slot;
								base.onEquip(melee);
							}
						break;
							
						case eq.ranged:
							if (ranged != false) {
								if (ranged == slot) {
									unequipRangedWeapon(heroId);
									base.onUnequip(ranged);
									ranged = false;
								} else {
									unequipRangedWeapon(heroId);
									base.onUnequip(ranged);
									equipRangedWeapon(heroId, Items.id(slot.item_params.code));
									ranged = slot;
									base.onEquip(ranged);
								}
							} else {
								equipRangedWeapon(heroId, Items.id(slot.item_params.code));
								ranged = slot;
								base.onEquip(ranged);
							}
						break;
							
						case eq.meal:
							if (isPlayerDead(heroId) == false)  {
								local packet = Packet();
								
								packet.writeInt32(ON_CONSUME);
								
								packet.writeString(slot.item_params.inst);
								
								packet.send(RELIABLE_ORDERED);
								
								if (slot.amount <= 1) {
									removeItem(slot);
								} else {
									decreaseAmount(slot, 1);
								}
							}
							
						break;
					}
				}
			}
		}
	}
	
	function onMouseWheel(val)
	{
		if (opened == true) {
			if (val == -1) {
				base.slide(70);
			}
			
			if (val == 1) {
				base.slide(-70);
			}
		}
	}
	
	function getMelee()
	{
		return melee;
	}
	
	function getRanged()
	{
		return ranged;
	}
	
	function getArmor()
	{
		return armor;
	}
	
	function setMelee(arg)
	{
		melee = arg;
	}
	
	function setRanged(arg)
	{
		ranged = arg;
	}
	
	function setArmor(arg)
	{
		armor = arg;
	}
	
	function getMagic()
	{
		return magic;
	}
	
	function getItemSlot(_code)
	{
		foreach(v in base.getSlots()) {
			if (v.free == false) {
				if (v.item_params.inst.tolower() == returnItem(_code).inst.tolower())
					return v;
			}
		}
		
		return false;
	}
	
	function upgradeItem(s, val)
	{
		foreach (v in base.getSlots()) {
			if (v.item_id == s) {
				v.upgrade = val;
				
				base.onUpgrade(v);
				
				return v;
			}
		}
	}
	
	function getUpgrade(s)
	{
		foreach(v in base.getSlots()) {
			if (v.item_id == s) {
				return v.upgrade;
			}
		}
		
		return false;
	}
	
	function isEquipped(slot)
	{
		if (melee != false) {
			if (melee.item_id == slot.item_id)
				return true;
		}
		
		if (ranged != false) {
			if (ranged.item_id == slot.item_id)
				return true;
		}
		
		if (magic != false) {
			if (magic.item_id == slot.item_id)
				return true;
		}
		
		if (armor != false) {
			if (armor.item_id == slot.item_id)
				return true;
		}
		
		return false;
	}
	
	function getItems()
	{
		return items;
	}
	
	function getItemSlots()
	{
		return base.getSlots();
	}
	
	opened = false;
	items = [];
	melee = false;
	ranged = false;
	armor = false;
	meal = false;
	magic = false;
	items_id = 0;
}

inventory <- inventorySystem();

local function inventoryKeyHandler(key)
{
	if (player.logged == true)
		inventory.keyHandler(key);
}

addEventHandler("onKey", inventoryKeyHandler);

local slider_render = 0;

addEventHandler("onRender", function(){
	if (slider_render < getTickCount()) {
		inventory.onRender();
	}
	
	slider_render += 50;
});

addEventHandler("onMouseClick", function(btn) {
	inventory.onClick(btn);
});

addEventHandler("onMouseRelease", function(btn) {
	inventory.onRelease(btn);
});

addEventHandler("onMouseWheel", function(btn) {
	inventory.onMouseWheel(btn);
});

local function item_packet(packet)
{
	local packet_id = packet.readInt32();
	if (packet_id == ADD_ITEM) {
		local item_type = packet.readInt32();
		local item_id = packet.readInt32();
		
		switch(item_type) {
			case (eq.meal || eq.other):
				foreach(v in inventory.getSlots()) {
					if (v.item_id == item_id) {
						local item_amount = packet.readInt32();
						
						v.amount += item_amount;
					
						inventory.sortByAmount(item_type);
						
						return;
					}
				}
				
				inventory.addItem({
					type = item_type,
					inst = packet.readString(),
					name = packet.readString(),
					code = packet.readString(),
					desc1 = packet.readString(),
					desc2 = packet.readString(),
					texture = packet.readString()
				}, packet.readInt32(), item_id);
			break;
			
			case (eq.armor):
				inventory.addItem({
					type = item_type,
					inst = packet.readString(),
					name = packet.readString(),
					code = packet.readString(),
					desc1 = packet.readString(),
					desc2 = packet.readString(),
					texture = packet.readString(),
					defence = packet.readInt32(),
					protection = packet.readInt32(),
					evasion = packet.readInt32(),
					level = packet.readInt32(),
					upgrade = packet.readInt32()
				}, 1, item_id);
			break;
			
			case (eq.melee || eq.ranged || eq.magic):
				inventory.addItem({
					type = item_type,
					inst = packet.readString(),
					name = packet.readString(),
					code = packet.readString(),
					desc1 = packet.readString(),
					desc2 = packet.readString(),
					texture = packet.readString(),
					attack = packet.readInt32(),
					hitrate = packet.readInt32(),
					critical = packet.readInt32(),
					level = packet.readInt32(),
					upgrade = packet.readInt32()
				}, 1, item_id);
			break;
		}
	} else if (packet_id == REMOVE_ITEM) {
		local item_id = packet.readInt32();
		
		foreach(v in inventory.getItemSlots()) {
			if(v.item_id == item_id) {
				inventory.removeItem(v);
				if (npcSale.opened == true) {
					npcSale.onSell(item_id, true);
				}
			}
		}
	} else if (packet_id == DECREASE_AMOUNT) {
		local item_id = packet.readInt32();
		
		foreach(v in inventory.getItemSlots()) {
			if (v.item_id == item_id) {
				local amount = packet.readInt32();
				inventory.decreaseAmount(v, amount);
				if (npcSale.opened == true) {
					npcSale.onSell(item_id, amount);
				}
			}
		}
	}
}

addEventHandler("onPacket", item_packet);