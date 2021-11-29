spawn <- {
	x = 0,
	y = 0,
	z = 0
}

local function onRespawn()
{
	if (player.logged == true) {
		if (inventory.melee != false)
			equipMeleeWeapon(heroId, Items.id(inventory.melee.item_params.code));
		
		if (inventory.ranged != false)
			equipRangedWeapon(heroId, Items.id(inventory.ranged.item_params.code));
		
		if (inventory.magic != false)
			equipRangedWeapon(heroId, Items.id(inventory.magic.item_params.code));
		
		if (inventory.armor != false)
			equipArmor(heroId, Items.id(inventory.armor.item_params.code));
	}
	
	setPlayerPosition(heroId, spawn.x, spawn.y, spawn.z);
	
	callServerFunc("onRespawn", heroId);
}

addEventHandler("onRespawn", onRespawn);