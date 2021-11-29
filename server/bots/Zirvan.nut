Zirvan <- createNPC({
	name = "Zirvan",
	position = { x = 11124, y = 998, z = -2984 },
	angle = 180,
	animation = "S_HGUARD",
	spawn = true,
	respawn = 1,
	aggressive = false,
	instance = "PC_HERO"
});

local scav_pos = {
	[1] = { x = 7079, y = 510, z = -8448 },
	[2] = { x = 8032, y = 500, z = -9079 },
	[3] = { x = 7561, y = 590, z = -9832 },
	[4] = { x = 6478, y = 540, z = -9918 },
	[5] = { x = 5905, y = 480, z = -9185 }
}

for(local i = 1; i <= 5; ++i) {
	createNPC({
		name = "Scavenger",
		position = scav_pos[i],
		angle = 100,
		animation = false,
		spawn = true,
		respawn = 10,
		instance = "SCAVENGER",
		
		// if is aggressive then health, strength and exp are required
		aggressive = true,
		health = 50,
		strength = 5,
		exp = 500,
		
		drop = function(pid) {
			dropItem(pid, "MEAL_BACON", 1);
			dropGold(pid, 5);
		}
	});
}

local TALK = npcMenu(["Buy", "Sell", "Mission", "End"]);
local TALK1 = npcMenu(["About mission...", "Back"]);
local CHOICE = npcMenu(["Yes", "No"]);
local TRADE = npcTrade([
	{ inst = "A_ROYAL", price = 150 },
	{ inst = "MW_DAGGER", price = 50 },
	{ inst = "MEAL_BACON", price = 2 }]);
local DLG_ZIRVAN_001 = npcDialogue("gamemodes/project/server/dialogues/DLG_ZIRVAN_001.dlg");
local DLG_ZIRVAN_002 = npcDialogue("gamemodes/project/server/dialogues/DLG_ZIRVAN_002.dlg");
local DLG_ZIRVAN_003 = npcDialogue("gamemodes/project/server/dialogues/DLG_ZIRVAN_003.dlg");
local DLG_ZIRVAN_003_01 = npcDialogue("gamemodes/project/server/dialogues/DLG_ZIRVAN_003_01.dlg");
local DLG_ZIRVAN_003_02 = npcDialogue("gamemodes/project/server/dialogues/DLG_ZIRVAN_003_02.dlg");
local DLG_ZIRVAN_004 = npcDialogue("gamemodes/project/server/dialogues/DLG_ZIRVAN_004.dlg");

local QUEST = false;

function zirvan_oninteract(pid, bid)
{
	if (bid == Zirvan.id) {
		startInteraction(pid);
		return openMenu(pid, TALK);
	}
}

function zirvan_menu_release(pid, menu, option)
{
	if (menu.id == TALK.id) {
		switch(option) {
			case 1:
				startDialogue(pid, DLG_ZIRVAN_001);
				closeMenu(pid, TALK);
			break;
			
			case 2:
				startDialogue(pid, DLG_ZIRVAN_002);
				closeMenu(pid, TALK);
			break;
			
			case 3:
				if (player.hasQuest(pid, "ZIRVAN_QUEST") == false) {
					startDialogue(pid, DLG_ZIRVAN_003);
					closeMenu(pid, TALK);
				} else {
					closeMenu(pid, TALK);
					openMenu(pid, TALK1);
				}
			break;
			
			case 4:
				startDialogue(pid, DLG_ZIRVAN_004);
				closeMenu(pid, TALK);
			break;
		}
	}
	
	if (menu.id == CHOICE.id) {
		switch(option) {
			case 1:
				closeMenu(pid, CHOICE);
				startDialogue(pid, DLG_ZIRVAN_003_01);
			break;
			
			case 2:
				closeMenu(pid, CHOICE);
				startDialogue(pid, DLG_ZIRVAN_003_02);
			break;
		}
	}
	
	if (menu.id == TALK1.id) {
		if (option == 1 || option == 2) {
			closeMenu(pid, TALK1);
			openMenu(pid, TALK);
		}
	}
}

function zirvan_dlg_finish(pid, dlg)
{
	switch(dlg.id) {
		case DLG_ZIRVAN_001.id:
			openTrade(pid, TRADE);
		break;
		
		case DLG_ZIRVAN_002.id:
			openSale(pid);
		break;
		
		case DLG_ZIRVAN_003.id:
			openMenu(pid, CHOICE);
		break;
		
		case DLG_ZIRVAN_004.id:
			endInteraction(pid);
		break;
		
		case DLG_ZIRVAN_003_01.id:
			dropQuest(pid, "ZIRVAN_QUEST");
			openMenu(pid, TALK);
		break;
		
		case DLG_ZIRVAN_003_02.id:
			endInteraction(pid);
		break;
	}
}