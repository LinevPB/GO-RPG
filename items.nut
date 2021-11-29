enum eq {
	armor = 1,
	melee = 2,
	ranged = 3,
	magic = 4,
	meal = 5,
	other = 6,
	none = 7
}

function initItems() {
	
	createItem({
		inst = "A_ROYAL",
		
		type = eq.armor,
		name = "Royal",
		code = "ITAR_PAL_H",
		desc1 = "The armor of a true royal warrior!",
		desc2 = "Testing second line of the description",
		defence = 100,
		protection = 120,
		evasion = 50,
		level = 0,
		
		texture = "A_ROYAL.TGA",
		price = 500
	});
		
	createItem({
		inst = "MW_DAGGER",
		
		type = eq.melee,
		name = "Dagger",
		code = "ITMW_1H_VLK_DAGGER",
		desc1 = "Just a primitive weapon of rogues..",
		desc2 = "",
		attack = 120,
		hitrate = 200,
		critical = 10,
		level = 0,
		
		texture = "MW_DAGGER.TGA",
		price = 50
	});
		
	createItem({
		inst = "MEAL_BACON",
		
		type = eq.meal,
		name = "Bacon",
		code = "ITFO_BACON",
		desc1 = "Recovers you 20 HP",
		desc2 = "",
		event = function(pid) {
			player.setHealth(pid, player.getHealth(pid) + 20);
		},
		
		texture = "MEAL_BACON.TGA",
		price = 5
	});
	
}

addEventHandler("onInit", initItems);