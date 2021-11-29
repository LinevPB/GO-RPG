__bots <- [];
__bots_id <- 0;

class botCounter
{
	function add(id)
	{
		__bots.append(id);
	}
	
	function getBots()
	{
		return __bots;
	}
	
	function getBotsAmount()
	{
		return __bots.len();
	}
	
	function incrementId()
	{
		__bots_id++;
	}
	
	function getId()
	{
		return __bots_id;
	}
	
	function getBot(id)
	{
		foreach(v in __bots) {
			if (v.set.id == id) {
				return v;
			}
		}
	}
}

function isBot(id)
{
	foreach(v in __bots) {
		if (v == id) {
			return true;
		}
	}
	
	return false;
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

class createNPC extends botCounter
{
	constructor(params)
	{
		base.add(this);
		base.incrementId();
		
		set = {};
		set.id <- base.getId();
		set.name <- params.name;
		set.spawned <- params.spawn;
		set.position <- params.position;
		set.angle <- params.angle;
		
		id = set.id;
		
		if (params.aggressive == false) {
			set.health <- 28970;
			set.maxhealth <- 28970;
			set.strength <- 500;
			set.experience <- 0;
			set.drop <- false;
		} else {
			set.health <- params.health;
			set.maxhealth <- params.health;
			set.strength <- params.strength;
			set.experience <- params.exp;
			set.drop <- params.drop;
		}
		
		set.animation <- params.animation;
		
		set.movable <- false;
		set.curr_pos <- params.position;
		set.curr_angle <- params.angle;
		set.curr_anim <- params.animation;
		set.dead <- false;
		set.respawn_time <- params.respawn;
		set.aggressive <- params.aggressive;
		set.attacking <- false;
		set.focused <- [];
		set.instance <- params.instance;
		set.timer <- 0;
		
		if (params.spawn == true)
			spawn();
	
		print("BOT: " + params.name + " created successfuly!");
	}
	
	function spawn()
	{
		if (set.spawned == false) {
			set.spawned = true;
			playersBotSpawn();
		}
	}
	
	function isSpawned()
	{
		return set.spawned;
	}
	
	function addFocus(id)
	{
		set.focused.append(id);
	}
	
	function unfocus(id)
	{
		if (set.focused.find(id)) {
			set.focused.remove(set.focused.find(id));
			
			if (set.focused.len() == 0) {
				set.attacking = false;
				set.curr_anim = "S_RUN";
			}
		}
	}
	
	function isFocused(id)
	{
		foreach (v in set.focused) {
			if (v == id) {
				return true;
			}
		}
		
		return false;
	}
	
	function getFocus()
	{
		return set.focused;
	}
	
	function spawnPlayerBot(pid)
	{
		local packet = Packet();
		packet.writeChar(PacketId.botSpawn);
		packet.writeInt32(set.id);
		packet.writeString(set.name);
		packet.writeBool(set.spawned);
		packet.writeFloat(set.curr_pos.x);
		packet.writeFloat(set.curr_pos.y);
		packet.writeFloat(set.curr_pos.z);
		packet.writeInt32(set.curr_angle);
		packet.writeBool(set.movable);
		packet.writeInt32(set.health);
		packet.writeInt32(set.maxhealth);
		packet.writeBool(set.dead);
		packet.writeInt32(set.respawn_time);
		packet.writeBool(set.aggressive);
		packet.writeBool(set.attacking);
		packet.writeString(set.instance);
		packet.writeInt32(set.strength);
		packet.writeInt32(set.experience);
		
		packet.send(pid, RELIABLE_ORDERED);
	}
	
	function playersBotSpawn()
	{
		if (set.spawned == true) {
			if (getPlayersAmount() > 0 ) {
				foreach(v in getPlayers()) {
					spawnPlayerBot(v);
				}
			}
		}
	}
	
	function playAnimation(ani_name)
	{
		set.curr_anim = ani_name;
	}
	
	function setPosition(x, y, z)
	{
		set.curr_pos.x = x;
		set.curr_pos.y = y;
		set.curr_pos.z = z;
	}
	
	function getPosition()
	{
		return {x = set.curr_pos.x,
			y = set.curr_pos.y,
		z = set.curr_pos.z};
	}
	
	function setAngle(angle)
	{
		set.curr_angle = angle;
	}
	
	function getAngle()
	{
		return set.curr_angle;
	}
	
	function setHealth(health)
	{
		set.health = health;
	}
	
	function getHealth()
	{
		return set.health;
	}
	
	function setMaxHealth(val)
	{
		set.maxhealth = val;
	}
	
	function getMaxHealth()
	{
		return set.maxhealth;
	}
	
	function isDead()
	{
		return set.dead;
	}
	
	function die()
	{
		set.dead = true;
		set.health = 0;
		playAnimation("T_DEADB");
		respawn();
	}
	
	function respawn()
	{
		setTimer(respawnNPC, set.respawn_time * 1000, 1, set.id);
	}
	
	function setDead(val)
	{
		set.dead = val;
	}
	
	set = null;
	id = null;
}

function respawnNPC(id)
{
	local bot = getBot(id);
	
	bot.setDead(false);
	
	bot.setHealth(bot.getMaxHealth());
	bot.setPosition(bot.set.position.x, bot.set.position.y, bot.set.position.z);
	bot.setAngle(bot.set.angle);
	
	if (bot.set.animation == false) {
		bot.playAnimation("S_FISTRUN");
	} else {
		bot.playAnimation(bot.set.animation);
	}
}