q <- {
	get = 1,
	kill = 2,
	done = 3,
	addit = 4
}

function initQuests()
{
	createQuest({
		inst = "ZIRVAN_QUEST",
		name = "Zirvan's command",
		desc = "Collect all 5 heads of scavenger!",
		type = q.get,
		addit = {
			code = "MEAL_BACON",
			amount = 5,
			current = 0
		}
	});
}

addEventHandler("onInit", initQuests);