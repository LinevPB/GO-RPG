const SEND_PACKET = 997;
const LOAD_PACKET = 998;
const ON_DAMAGE = 123843;

enum perm {
	player,
	mod,
	admin
}


local function playerPacket(packet)
{
	local ID = packet.readInt32();
	
	if (ID == SEND_PACKET) {
		switch(packet.readString().tolower()) {
			case "health":
				player.health = packet.readInt32();
			break;
			
			case "max health":
				player.max_health = packet.readInt32();
			break;
			
			case "strength":
				player.strength = packet.readInt32();
			break;
			
			case "dexterity":
				player.dexterity = packet.readInt32();
			break;
			
			case "intelligence":
				player.intelligence = packet.readInt32();
			break;
			
			case "constitution":
				player.constitution = packet.readInt32();
			break;
			
			case "protection":
				player.protection = packet.readInt32();
			break;
			
			case "attack":
				player.attack = packet.readInt32();
			break;
			
			case "defence":
				player.defence = packet.readInt32();
			break;
			
			case "hit rate":
				player.hitrate = packet.readInt32();
			break;
			
			case "evasion":
				player.evasion = packet.readInt32();
			break;
			
			case "critical":
				player.critical = packet.readInt32();
			break;
			
			case "mana":
				player.mana = packet.readInt32();
			break;
			
			case "max mana":
				player.max_mana = packet.readInt32();
			break;
			
			case "experience":
				player.experience = packet.readInt32();
			break;
			
			case "exp next lvl":
				player.next_lvl_exp = packet.readInt32();
			break;
			
			case "skill points":
				player.skill_points = packet.readInt32();
			break;
			
			case "level":
				player.level = packet.readInt32();
			break;
			
			case "weapon mastery":
				player.weapon_mastery = packet.readInt32();
			break;
			
			case "trophy collecting":
				player.trophy = packet.readInt32();
			break;
			
			case "crafting":
				player.crafting = packet.readInt32();
			break;
			
			case "title":
				player.title = packet.readString();
			break;
			
			case "nickname":
				player.nickname = packet.readString();
			break;
			
			case "clan":
				player.clan = packet.readString();
			break;
			
			case "clan rank":
				player.clan_rank = packet.readString();
			break;
			
			case "guild":
				player.guild = packet.readString();
			break;
			
			case "gold":
				player.gold = packet.readInt32();
			break;
			
			case "cash":
				player.cash = packet.readInt32();
			break;
		}
	}
}

addEventHandler("onPacket", playerPacket);

class playerFunctions
{
	
	function sendPacket(val1, val)
	{
		local packet = Packet();
		
		packet.writeInt32(SEND_PACKET);
		packet.writeString(val1);
		
		switch(typeof val) {
			case "string":
				packet.writeString(val);
			break;
			
			case "integer":
				packet.writeInt32(val);
			break;
			
			case "float":
				return sendPacket(val.tointeger());
			break;
			
			case "bool":
				packet.writeBool(val);
			break;
		}
		
		packet.send(RELIABLE_ORDERED);
		
		return packet;
	}
	
	function setHealth(val)
	{
		sendPacket("health", val);
	}
	
	function setMaxHealth(val)
	{
		sendPacket("max health", val);
	}
	
	function setStrength(val)
	{
		sendPacket("strength", val);
	}
	
	function load(index)
	{
		local packet = Packet();
		
		packet.writeInt32(LOAD_PACKET);
		packet.writeInt32(index);
		
		packet.send(RELIABLE_ORDERED);
		
		return packet;
	}
	
	function startDieDraw()
	{
		player.DIE_DRAW_TIME = 5;
		player.DIE_DRAW_TICK = getTickCount() + 1000;
		player.DIE_DRAW_ACTIVE = true;
		player.DIE_DRAW.text = "Respawn in 5 seconds";
		player.DIE_DRAW.visible = true;
	}
	
	function onRender()
	{
		if (player.DIE_DRAW_ACTIVE == true) {
			if (player.DIE_DRAW_TICK < getTickCount()) {
				player.DIE_DRAW_TIME = DIE_DRAW_TIME - 1;
				player.DIE_DRAW.text = "Respawn in " + DIE_DRAW_TIME + " seconds";
				
				if (player.DIE_DRAW_TIME <= 0) {
					player.DIE_DRAW_ACTIVE = false;
					player.DIE_DRAW.visible = false;
				}
				
				player.DIE_DRAW_TICK += 1000;
			}
		}
	}
}

class playerStructure extends playerFunctions
{
	
	constructor()
	{
		character = {
			[1] = false,
			[2] = false,
			[3] = false
		};
		
		current_character = false;
		
		permission = perm.player;
		logged = false;
		
		strength = 0;
		dexterity = 0;
		intelligence = 0;
		constitution = 0;
		
		health = 0;
		max_health = 0;
		
		mana = 0;
		max_mana = 0;
		
		experience = 0;
		next_lvl_exp = 0;
		
		level = 0;
		
		title = "";
		nickname = "";
		
		login = "";
		password = "";
		
		chat_visibility = false;
		
		gold = 0;
		cash = 0;
		
		clan = "";
		clan_rank = ""
		guild = "";
		
		protection = 0;
		attack = 0;
		evasion = 0;
		hitrate = 0;
		critical = 0;
		defence = 0;
		
		weapon_mastery = 0;
		
		skill_points = 0;
		trophy = 0;
		crafting = 0;
		
		DIE_DRAW = Draw(0,0,"Respawn in 5 seconds");
		DIE_DRAW.font = "FONT_OLD_20_WHITE_HI.TGA";
		DIE_DRAW.setColor(255,0,0);
		DIE_DRAW.setPosition(8192 / 2 - DIE_DRAW.width / 2, 3000);
		DIE_DRAW.visible = false;
		
		DIE_DRAW_TIME = 0;
		DIE_DRAW_ACTIVE = false;
		DIE_DRAW_TICK = 0;
	}
	
	function getNickname()
	{
		return nickname;
	}
	
	strength = null;
	dexterity = null;
	intelligence = null;
	constitution = null;
	
	protection = null;
	attack = null;
	defence = null;
	evasion = null;
	hitrate = null;
	critical = null;
	
	health = null;
	max_health = null;
	mana = null;
	max_mana = null;
	
	experience = null;
	next_lvl_exp = null;
	
	level = null;
	
	title = null;
	nickname = null;
	
	login = null;
	password = null;
	
	chat_visibility = null;
	
	logged = null;
	permission = null;
	
	character = null;
	current_character = null;
	
	interacting = false;
	
	gold = null;
	cash = null;
	
	clan = null;
	clan_rank = null;
	guild = null;
	skill_points = null;
	
	weapon_mastery = null;
	trophy = null;
	crafting = null;
	
	DIE_DRAW = null;
	DIE_DRAW_TIME = null;
	DIE_DRAW_ACTIVE = null;
	DIE_DRAW_TICK = null;
}

player <- playerStructure();

function getPlayerNickname()
{
	return player.nickname;
}

local function playerRender()
{
	player.onRender();
}

addEventHandler("onRender", playerRender);

local function dmgHandler(dmg, type)
{
    local packet = Packet();
	
	packet.writeInt32(ON_DAMAGE);
	packet.writeInt32(dmg);
	packet.send(RELIABLE_ORDERED);
}

addEventHandler("onDamage", dmgHandler);