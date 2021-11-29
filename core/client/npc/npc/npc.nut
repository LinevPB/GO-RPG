class botCounter
{
	function add(id)
	{
		bots.append(id);
	}
	
	function getBots()
	{
		return bots;
	}
	
	function getBotsAmount()
	{
		return bots.len();
	}
	
	function getBot(id)
	{
		foreach(v in bots) {
			if (v.bot_id == id) {
				return v;
			}
		}
	}
	
	function getBotServerId(id)
	{
		foreach(v in bots) {
			if (v.id == id) {
				return v.bot_id;
			}
		}
	}
	
	function getBotClientId(id)
	{
		foreach(v in bots) {
			if (v.bot_id == id) {
				return v.id;
			}
		}
	}
	
	function isSpawned(id)
	{
		foreach (v in bots) {
			if (v.bot_id == id) {
				return true;
			}
		}
		
		return false;
	}
	
	bots = [];
}

function getBots()
{
	return botCounter.getBots();
}

function getBotsAmount()
{
	return botCounter.getBotsAmount();
}

function getBot(id)
{
	return botCounter.getBot(id);
}

function getBotServerId(id)
{
	return botCounter.getBotServerId(id);
}

function getBotClientId(id)
{
	return botCounter.getBotById(id);
}

function isBot(id)
{
	foreach(v in getBots()) {
		if (id == v.id) {
			return true;
		}
	}
	
	return false;
}

function getClientBot(id)
{
	foreach(v in getBots()) {
		if (id == v.id) {
			return v;
		}
	}
}

function isBotSpawned(id)
{
	return botCounter.isSpawned(id);
}

class createNPC extends botCounter
{
	constructor(params)
	{
		base.add(this);
		id = createNpc(params.name);
		bot_id = params.bot_id;
		name = params.name;
		position = params.position;
		spawned = params.spawned;
		movable = params.movable;
		angle = params.angle;
		health = params.health;
		maxhealth = params.maxhealth;
		dead = params.dead;
		respawn_time = params.respawn;
		aggressive = params.aggressive;
		attacking = false;
		focus = -1;
		instance = params.instance;
		strength = params.strength;
		experience = params.experience;
		
		if (dead == false) {
			spawnNpc(id);
			
			setPlayerInstance(id, instance);
			setPlayerPosition(id, position.x, position.y, position.z);
			setPlayerVisual(id, "Hum_Body_Naked0", 3, "Hum_Head_Psionic", 59);
			setPlayerHealth(id, health);
			setPlayerMaxHealth(id, maxhealth);
			setPlayerStrength(id, params.strength);
		}
	}
	
	function setHealth(val)
	{
		health = val;
		setPlayerHealth(id, val);
	}
	
	function getHealth()
	{
		return health;
	}
	
	function setMaxHealth(val)
	{
		maxhealth = val;
		setPlayerMaxHealth(id, val);
	}
	
	function getMaxHealth()
	{
		return maxhealth;
	}
	
	function isDead()
	{
		return dead;
	}
	
	function setDead(val)
	{
		dead = val;
		if (val == true) {
			setHealth(0);
		}
	}
	
	function deathAnimation()
	{
		playAni(id, "T_DEADB");
	}
	
	id = null;
	bot_id = null;
	spawned = null;
	position = null;
	name = null;
	movable = null;
	angle = null;
	streamed = null;
	health = null;
	maxhealth = null;
	dead = null;
	respawn_time = null;
	aggressive = null;
	attacking = null;
	focus = null;
	instance = null;
	strength = null;
	experience = null;
}

function testCall(text)
{
	chat.send(140,190,240,text);
}

function spawn_npc_packet(packet)
{
	local id = packet.readChar();
	if (id == PacketId.botSpawn * -1) {
		local set = {};
		set.bot_id <- packet.readInt32();
		set.name <- packet.readString();
		set.spawned <- packet.readBool();
		set.position <- {};
		set.position.x <- packet.readFloat();
		set.position.y <- packet.readFloat();
		set.position.z <- packet.readFloat();
		set.angle <- packet.readInt32();
		set.movable <- packet.readBool();
		set.health <- packet.readInt32();
		set.maxhealth <- packet.readInt32();
		set.dead <- packet.readBool();
		set.respawn <- packet.readInt32();
		set.aggressive <- packet.readBool();
		set.attacking <- packet.readBool();
		set.instance <- packet.readString();
		set.strength <- packet.readInt32();
		set.experience <- packet.readInt32();
		createNPC(set);
	}
}

function npc_synchro(id, x, y, z, angle, anim, health, dead, aggressive, attacking, focus)
{
	if (isBotSpawned(id) == true) {
		local bot = getBot(id);
		
		setPlayerAngle(bot.id, angle);
			
		if (dead == false && bot.isDead() == true) {
			bot.setDead(false);
			setPlayerPosition(bot.id, bot.position.x, bot.position.y, bot.position.z);
			setPlayerAngle(bot.id, bot.angle);
		}
			
		if (isPlayerStreamed(bot.id) == true) {
			local pos = getPlayerPosition(bot.id);
		
			callServerFunc("update_npc_pos", getBot(id).bot_id, pos.x, pos.y, pos.z);
			
			if (bot.streamed == false) {
				bot.streamed = true;
				setPlayerPosition(bot.id, x, y, z);
			}
		} else {
			if (bot.streamed == true) {
				bot.streamed = false;
			}
			
			setPlayerPosition(bot.id, x, y, z);
		}
		
		if (bot.isDead() == false && dead == true) {
				bot.setDead(true);
				playAni(bot.id, anim);
		}
		
		if (bot.isDead() == false)
			playAni(bot.id, anim);
		
		bot.setHealth(health);
		bot.aggressive = aggressive;
		bot.attacking = attacking;
		bot.focus = focus;
	}
}

function deathAnimation(id)
{
	getBot(id).deathAnimation();
}

function npc_onkey(key)
{
	if (key  == KEY_LCONTROL && chatInputIsOpen() == false && player.logged == true) {
		if (player.interacting == false && inventory.opened == false && quests.opened == false && stats.opened == false) {
			local fid = focus.getId();
			
			if (isBot(fid) == true) {
				callServerFunc("onInteractNPC", heroId, getBotServerId(fid));
			}
		}
	}
	
	if (key == KEY_RCONTROL) {
		callServerFunc("endInteraction", heroId); // do testu
	}
}

function start_interaction()
{
	setFreeze(true);
	player.interacting = true;
}

function end_interaction()
{
	setFreeze(false);
	player.interacting = false;
	Camera.setMode("CAMMODNORMAL");
}

addEventHandler("onKey", npc_onkey);

addEventHandler("onPacket", spawn_npc_packet)