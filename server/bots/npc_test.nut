bots <- {};

function init_npc()
{
	bots.graham <- createNPC({
		name = "Graham",
		position = { x = 29672, y = 5246, z = -15501 },
		angle = 100,
		animation = false,
		spawn = true,
		respawn = 1,
		aggressive = false,
		instance = "PC_HERO"
	});
	
	bots.wilk <- createNPC({
		name = "Pimpek",
		position = { x = 29662, y = 5246, z = -15501 },
		angle = 100,
		animation = false,
		spawn = false,
		respawn = 5,
		instance = "WOLF",
		
		// if is aggressive then health, strength and exp are required
		aggressive = true,
		health = 50,
		strength = 10,
		exp = 5,
		
		
		drop = false
	});
}

addEventHandler("onInit", init_npc);