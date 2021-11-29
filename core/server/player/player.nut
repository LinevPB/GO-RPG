const RECEIVE_PACKET = 997;
const LOAD_PACKET = 998;
const ADD_ITEM = 444;
const REMOVE_ITEM = 555;
const DECREASE_AMOUNT = 5554;
const ON_DAMAGE = 123843;

enum eq {
	armor = 1,
	melee = 2,
	ranged = 3,
	magic = 4,
	meal = 5,
	other = 6,
	none = 7
}

function starter(pid)
{
	player.setGold(pid, player.getGold(pid) + 20);
}

local function load_packet(pid, packet)
{
	switch(packet.readInt32()) {
		case LOAD_PACKET:
			player.load(pid, packet.readInt32());
		break;
		
		case DECREASE_AMOUNT:
			player.decreaseAmount(pid, packet.readInt32(), packet.readInt32());
		break;
		
		case REMOVE_ITEM:
			player.removeItem(pid, packet.readInt32());
		break;
		
		case ON_DAMAGE:
			player.onDamage(pid, packet.readInt32());
		break;
		
		case 1234567123:
			starter(pid); // Just for tests
		break;
	}
}

addEventHandler("onPacket", load_packet);

class player_functions extends quests
{
	function sendPacket(pid, val1, val)
	{
		local packet = Packet();
		
		packet.writeInt32(RECEIVE_PACKET);
		packet.writeString(val1);
		
		switch(typeof val) {
			case "string":
				packet.writeString(val);
			break;
			
			case "integer":
				packet.writeInt32(val);
			break;
			
			case "float":
				packet.writeInt32(val.tointeger());
			break;
			
			case "bool":
				packet.writeBool(val);
			break;
		}
		
		packet.send(pid, RELIABLE_ORDERED);
		
		return packet;
	}
	
	function setHealth(pid, valz)
	{
		local val = valz;
		if (player.get(pid).health != null){
			if (valz <= 0)
				val = 0;
				
			if (valz >= player.get(pid).max_health)
				val = player.get(pid).max_health;
		}
		
		setPlayerHealth(pid, val);
		player.get(pid).health = val;
		sendPacket(pid, "health", val);
	}
	
	function setMaxHealth(pid, val)
	{
		setPlayerMaxHealth(pid, val);
		player.get(pid).max_health = val;
		sendPacket(pid, "max health", val);
	}
	
	function setStrength(pid, val)
	{
		setPlayerStrength(pid, val);
		player.get(pid).strength = val;
		sendPacket(pid, "strength", val);
	}
	
	function setDexterity(pid, val)
	{
		setPlayerDexterity(pid, val);
		player.get(pid).dexterity = val;
		sendPacket(pid, "dexterity", val);
	}
	
	function setIntelligence(pid, val)
	{
		player.get(pid).intelligence = val;
		sendPacket(pid, "intelligence", val);
	}
	
	function setConstitution(pid, val)
	{
		player.get(pid).constitution = val;
		sendPacket(pid, "constitution", val);
	}
	
	function setProtection(pid, val)
	{
		player.get(pid).protection = val;
		sendPacket(pid, "protection", val);
	}
	
	function setAttack(pid, val)
	{
		player.get(pid).attack = val;
		sendPacket(pid, "attack", val);
	}
	
	function setDefence(pid, val)
	{
		player.get(pid).defence = val;
		sendPacket(pid, "defence", val);
	}
	
	function setHitrate(pid, val)
	{
		player.get(pid).hitrate = val;
		sendPacket(pid, "hit rate", val);
	}
	
	function setEvasion(pid, val)
	{
		player.get(pid).evasion = val;
		sendPacket(pid, "evasion", val);
	}
	
	function setCritical(pid, val)
	{
		player.get(pid).critical = val;
		sendPacket(pid, "critical", val);
	}
	
	function setMana(pid, val)
	{
		player.get(pid).mana = val;
		sendPacket(pid, "mana", val);
	}
	
	function setMaxMana(pid, val)
	{
		player.get(pid).max_mana = val;
		sendPacket(pid, "max mana", val);
	}
	
	function setExperience(pid, val)
	{
		player.get(pid).experience = val;
		sendPacket(pid, "experience", val);
	}
	
	function setExperienceNextLevel(pid, val)
	{
		player.get(pid).next_lvl_exp = val;
		sendPacket(pid, "exp next lvl", val);
	}
	
	function setSkillPoints(pid, val)
	{
		player.get(pid).skill_points = val;
		sendPacket(pid, "skill points", val);
	}
	
	function setLevel(pid, val)
	{
		player.get(pid).level = val;
		sendPacket(pid, "level", val);
	}
	
	function setWeaponMastery(pid, val)
	{
		player.get(pid).weapon_mastery = val;
		sendPacket(pid, "weapon mastery", val);
	}
	
	function setTrophyCollecting(pid, val)
	{
		player.get(pid).trophy = val;
		sendPacket(pid, "trophy collecting", val);
	}
	
	function setCrafting(pid, val)
	{
		player.get(pid).crafting = val;
		sendPacket(pid, "crafting", val);
	}
	
	function setTitle(pid, val)
	{
		player.get(pid).title = val;
		sendPacket(pid, "title", val);
	}
	
	function setNickname(pid, val)
	{
		player.get(pid).nickname = val;
		setPlayerName(pid, val);
		sendPacket(pid, "nickname", val);
	}
	
	function setClan(pid, val)
	{
		player.get(pid).clan = val;
		sendPacket(pid, "clan", val);
	}
	
	function setClanRank(pid, val)
	{
		player.get(pid).clan_rank = val;
		sendPacket(pid, "clan rank", val);
	}
	
	function setGuild(pid, val)
	{
		player.get(pid).guild = val;
		sendPacket(pid, "guild", val);
	}
	
	function setGold(pid, val)
	{
		player.get(pid).gold = val;
		sendPacket(pid, "gold", val);
	}
	
	function setCash(pid, val)
	{
		player.get(pid).cash = val;
		sendPacket(pid, "cash", val);
	}
	
	function setLogin(pid, val)
	{
		player.get(pid).login = val;
	}
	
	function getHealth(pid)
	{
		return player.get(pid).health;
	}
	
	function getMaxHealth(pid)
	{
		return player.get(pid).max_health;
	}
	
	function getGold(pid)
	{
		return player.get(pid).gold;
	}
	
	function getLogin(pid)
	{
		return player.get(pid).login;
	}
	
	function getNickname(pid)
	{
		return player.get(pid).nickname;
	}
	
	function getStrength(pid)
	{
		return player.get(pid).strength;
	}
	
	function getDexterity(pid)
	{
		return player.get(pid).dexterity;
	}
	
	function getIntelligence(pid)
	{
		return player.get(pid).intelligence;
	}
	
	function getConstitution(pid)
	{
		return player.get(pid).constitution;
	}
	
	function getProtection(pid)
	{
		return player.get(pid).protection;
	}
	
	function getAttack(pid)
	{
		return player.get(pid).attack;
	}
	
	function getDefence(pid)
	{
		return player.get(pid).defence;
	}
	
	function getHitrate(pid)
	{
		return player.get(pid).hitrate;
	}
	
	function getEvasion(pid)
	{
		return player.get(pid).evasion;
	}
	
	function getCritical(pid)
	{
		return player.get(pid).critical;
	}
	
	function getMana(pid)
	{
		return player.get(pid).mana;
	}
	
	function getMaxMana(pid)
	{
		return player.get(pid).max_mana;
	}
	
	function getExperience(pid)
	{
		return player.get(pid).experience;
	}
	
	function getExperienceNextLevel(pid)
	{
		return player.get(pid).next_lvl_exp;
	}
	
	function getSkillPoints(pid)
	{
		return player.get(pid).skill_points;
	}
	
	function getLevel(pid)
	{
		return player.get(pid).level;
	}
	
	function getWeaponMastery(pid)
	{
		return player.get(pid).weapon_mastery;
	}
	
	function getTrophyCollecting(pid)
	{
		return player.get(pid).trophy;
	}
	
	function getCrafting(pid)
	{
		return player.get(pid).crafting;
	}
	
	function getTitle(pid)
	{
		return player.get(pid).title;
	}
	
	function getClan(pid)
	{
		return player.get(pid).clan;
	}
	
	function getClanRank(pid)
	{
		return player.get(pid).clan_rank;
	}
	
	function getGuild(pid)
	{
		return player.get(pid).guild;
	}
	
	function getCash(pid)
	{
		return player.get(pid).cash;
	}
	
	//////////
	
	function addItem(pid, id, amount = 1)
	{
		local item = null;
		
		local packet = Packet();
		
		if (typeof id == "string")
			item = returnItem(id);
		else
			item = id;
		
		giveItem(pid, Items.id(item.code), amount);
		
		packet.writeInt32(ADD_ITEM);
		packet.writeInt32(item.type);
		
		local params = {};
		
		if (item.type == (eq.meal || eq.other)) {
			foreach(v in player.get(pid).items) {
				if (v.inst == item.inst) {
					v.amount += amount;
					
					packet.writeInt32(v.id);
					packet.writeInt32(amount);
					packet.send(pid, RELIABLE_ORDERED);
					
					return;
				}
			}
		} else {
			params.amount <- amount;
		}
		
		params.id <- player.get(pid).items_id;
		params.inst <- item.inst;
		params.type <- item.type;
		params.code <- item.code;
		params.desc1 <- item.desc1;
		params.desc2 <- item.desc2;
		params.name <- item.name;
		params.texture <- item.texture;
		
		packet.writeInt32(params.id);
		packet.writeString(params.inst);
		packet.writeString(params.name);
		packet.writeString(params.code);
		packet.writeString(params.desc1);
		packet.writeString(params.desc2);
		packet.writeString(params.texture);
		
		switch(item.type) {
			case eq.armor:
				params.defence <- item.defence;
				params.protection <- item.protection;
				params.evasion <- item.evasion;
				params.level <- item.level;
				params.upgrade <- 0;
				
				packet.writeInt32(params.defence);
				packet.writeInt32(params.protection);
				packet.writeInt32(params.evasion);
				packet.writeInt32(params.level);
				packet.writeInt32(params.upgrade);
			break;
			
			case (eq.melee || eq.ranged || eq.magic):
				params.attack <- item.attack;
				params.hitrate <- item.hitrate;
				params.critical <- item.critical;
				params.level <- item.level;
				params.upgrade <- 0;
				
				packet.writeInt32(params.attack);
				packet.writeInt32(params.hitrate);
				packet.writeInt32(params.critical);
				packet.writeInt32(params.level);
				packet.writeInt32(params.upgrade);
			break;
			
			case (eq.meal || eq.other):
				params.amount <- amount;
				params.upgrade <- 0;
				packet.writeInt32(params.amount);
			break;
		}
		
		packet.send(pid, RELIABLE_ORDERED);
		
		
		player.get(pid).items.append(params);
		
		player.get(pid).items_id = player.get(pid).items_id + 1;
		
		return player.get(pid).items_id - 1;
	}
	
	function removeItem(pid, id)
	{
		foreach(i, v in player.get(pid).items) {
			if (v.id == id) {
				player.get(pid).items.remove(i);
			}
		}
	}
	
	function getItemsAmount(pid)
	{
		return player.get(pid).items.len();
	}
	
	function getItems(pid)
	{
		return player.get(pid).items;
	}
	
	function getItemById(pid, id)
	{
		foreach(v in player.get(pid).items) {
			if (v.id == id) {
				return v;
			}
		}
	}
	
	function getItemAmount(pid, item_id) {
		local item = getItemById(pid, item_id);
		
		if (item.type == (eq.meal || eq.other))
			return item.amount;
		
		return 1;
	}
	
	function decreaseAmount(pid, item_id, amount)
	{
		foreach(v in player.get(pid).items) {
			if (v.id == item_id) {
				v.amount = v.amount - amount;
			}
		}
	}
	
	function onDamage(pid, dmg)
	{
		if (player.get(pid).health - dmg < 0)
			player.setHealth(pid, 0);
		else
			player.setHealth(pid, player.get(pid).health - dmg);
	}
}

class player extends player_functions
{
	
	function create(pid)
	{
		local params = {
			id = pid,
			
			strength = null,
			dexterity = null,
			intelligence = null,
			constitution = null,
			
			protection = null,
			attack = null,
			defence = null,
			evasion = null,
			hitrate = null,
			critical = null,
			
			health = null,
			max_health = null,
			mana = null,
			max_mana = null,
			
			experience = null,
			next_lvl_exp = null,
			
			level = null,
			
			title = null,
			nickname = null,
			
			login = null,
			password = null,
			
			chat_visibility = null,
			
			logged = null,
			permission = null,
			
			character = null,
			current_character = -1,
			
			interacting = false,
			
			gold = null,
			cash = null,
			
			clan = null,
			clan_rank = null,
			guild = null,
			skill_points = null,
			
			weapon_mastery = null,
			trophy = null,
			crafting = null,
			
			items = [],
			quests = [],
			quest_id = 0,
			
			items_id = 0,
			logged = false
		};
		
		players.append(params);
		
		setPlayerRespawnTime(pid, 5000);
	}
	
	function destroy(pid)
	{
		foreach(i, v in players) {
			if (v.id == pid) {
				players.remove(i);
				
				return true;
			}
		}
		
		return false;
	}
	
	function onJoin(pid)
	{
		player.create(pid);
	}
	
	function onExit(pid, reason)
	{
		player.save(pid, true);
	}
	
	function get(pid)
	{
		foreach(v in players) {
			if (v.id == pid)
				return v;
		}
		
		return false;
	}
	
	function load(pid, index)
	{
		local brfile = File(path + "characters/" + player.getLogin(pid) + "_char_" + index + ".txt");
		brfile.open("r+");
		local br = null;
		
		br = brfile.readLine();
		player.setNickname(pid, br);
		
		br = brfile.readLine();
		player.setTitle(pid, br);
		
		br = brfile.readLine();
		player.setClan(pid, br);
		
		br = brfile.readLine();
		player.setClanRank(pid, br);
		
		br = brfile.readLine();
		player.setGuild(pid, br);
		
		br = brfile.readLine();
		player.setHealth(pid, br.tointeger());
		
		br = brfile.readLine();
		player.setMaxHealth(pid, br.tointeger());
		
		br = brfile.readLine();
		player.setMana(pid, br.tointeger());
		
		br = brfile.readLine();
		player.setMaxMana(pid, br.tointeger());
		
		br = brfile.readLine();
		player.setExperience(pid, br.tointeger());
		
		br = brfile.readLine();
		player.setExperienceNextLevel(pid, br.tointeger());
			
		br = brfile.readLine();
		player.setLevel(pid, br.tointeger());
		
		br = brfile.readLine();
		player.setStrength(pid, br.tointeger());

		br = brfile.readLine();
		player.setDexterity(pid, br.tointeger());
		
		br = brfile.readLine();
		player.setIntelligence(pid, br.tointeger());
		
		br = brfile.readLine();
		player.setConstitution(pid, br.tointeger());
		
		br = brfile.readLine();
		player.setSkillPoints(pid, br.tointeger());
		
		br = brfile.readLine();
		player.setWeaponMastery(pid, br.tointeger());
		
		br = brfile.readLine();
		player.setTrophyCollecting(pid, br.tointeger());
		
		br = brfile.readLine();
		player.setCrafting(pid, br.tointeger());
		
		br = brfile.readLine();
		player.setGold(pid, br.tointeger());
		
		brfile.close();
		
		/* Those would be connected with stats and equipment */
		
		br = 10;
		player.setProtection(pid, br);
		
		br = 10;
		player.setAttack(pid, br);
		
		br = 10;
		player.setDefence(pid, br);
		
		br = 10;
		player.setEvasion(pid, br);
		
		br = 10;
		player.setHitrate(pid, br);
		
		br =  10;
		player.setCritical(pid, br);
		
		/*                       */
		
		br = 0;
		player.setCash(pid, br);
		
		player.get(pid).logged = true;
		player.get(pid).current_character = index;
		
		brfile = File(path + "characters/items/" + player.getLogin(pid) + "_char_" + player.get(pid).current_character + ".txt");
		if (brfile.exists() == true) {
			brfile.open("r+");
			br = null;
			
			do {
				br = brfile.readLine();
				
				if (br != "") {
					if (returnItem(br).type == eq.meal || returnItem(br).type == eq.other) {
						player.addItem(pid, br, brfile.readLine().tointeger());
					} else {
						player.addItem(pid, br, 1);
						brfile.readLine(); // to later weapon upgrade
					}
				}
					
			} while(br != "");
			
			brfile.close();
		}
		
		local LOADED = 777345;
		local packet = Packet();
		packet.writeInt32(LOADED);
		packet.send(pid, RELIABLE_ORDERED);
	}
	
	function save(pid, destroy)
	{
		if (player.get(pid).logged == true) {
			local br = File(path + "characters/" + player.getLogin(pid) + "_char_" + player.get(pid).current_character + ".txt");
			br.open("w+");
			br.writeLine(player.getNickname(pid));
			br.writeLine(player.getTitle(pid));
			br.writeLine(player.getClan(pid));
			br.writeLine(player.getClanRank(pid));
			br.writeLine(player.getGuild(pid));
			br.writeLine(player.getHealth(pid));
			br.writeLine(player.getMaxHealth(pid));
			br.writeLine(player.getMana(pid));
			br.writeLine(player.getMaxMana(pid));
			br.writeLine(player.getExperience(pid));
			br.writeLine(player.getExperienceNextLevel(pid));
			br.writeLine(player.getLevel(pid));
			br.writeLine(player.getStrength(pid));
			br.writeLine(player.getDexterity(pid));
			br.writeLine(player.getIntelligence(pid));
			br.writeLine(player.getConstitution(pid));
			br.writeLine(player.getSkillPoints(pid));
			br.writeLine(player.getWeaponMastery(pid));
			br.writeLine(player.getTrophyCollecting(pid));
			br.writeLine(player.getCrafting(pid));
			br.writeLine(player.getGold(pid));
			br.close();
			
			br = File(path + "characters/items/" + player.getLogin(pid) + "_char_" + player.get(pid).current_character + ".txt");
			br.open("w+");
			foreach(v in player.getItems(pid)) {
				br.writeLine(v.inst);
				if (returnItem(v.inst).type == eq.meal || returnItem(v.inst).type == eq.other)
					br.writeLine(v.amount);
				else
					br.writeLine(v.upgrade);
			}
			br.close();
		}
		
		if (destroy == true)
			player.destroy(pid);
	}
	
	players = [];
}

addEventHandler("onPlayerJoin", player.onJoin);
addEventHandler("onPlayerDisconnect", player.onExit);

function onRespawn(pid)
{
	player.setMaxHealth(pid, player.getMaxHealth(pid));
	player.setHealth(pid, player.getMaxHealth(pid) / 2);
}

function onDie(pid)
{
}

function dropItem(pid, inst, amount)
{
	player.addItem(pid, inst, amount);
	statement(pid, 200, 200, 200, returnItem(inst).name + " +" + amount);
}

function dropGold(pid, amount)
{
	player.setGold(pid, player.getGold(pid) + amount);
	statement(pid, 200, 200, 200, "Gold +" + amount);
}

function dropExp(pid, amount)
{
	player.setExperience(pid, player.getExperience(pid) + amount);
	statement(pid, 200, 200, 200, "Experience +" + amount);
	
	if (player.getExperience(pid) >= player.getExperienceNextLevel(pid)) {
		player.setLevel(pid, player.getLevel(pid) + 1);
		player.setExperience(pid, player.getExperience(pid) - player.getExperienceNextLevel(pid));
		player.setExperienceNextLevel(pid, (player.getExperienceNextLevel(pid) * 1.5).tointeger());
		statement(pid, 255, 255, 0, "Level up!");
	}
}