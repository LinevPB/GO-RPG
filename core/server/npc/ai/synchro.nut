function position_render()
{
	local timer = setTimer(callSynchro, 50, 0);
}

function callSynchro()
{
	if (getPlayersAmount() > 0) {
		foreach(v in getBots()) {
			foreach(pid in getPlayers()) {
				callClientFunc(pid, "npc_synchro", v.set.id, v.set.curr_pos.x, v.set.curr_pos.y, v.set.curr_pos.z, v.set.curr_angle, v.set.curr_anim, v.set.health, v.isDead(), v.set.aggressive, v.set.attacking, -1);
			}
		}
	}
}

function update_npc_pos(id, x,y,z)
{
	local bot = getBot(id);
	
	if (bot.isDead() == false) {
		bot.set.curr_pos.x = x;
		bot.set.curr_pos.y = y;
		bot.set.curr_pos.z = z;
	} else  {
		bot.set.curr_pos.x = bot.set.position.x;
		bot.set.curr_pos.y = bot.set.position.y;
		bot.set.curr_pos.z = bot.set.position.z;
	}
}

addEventHandler("onInit", position_render);