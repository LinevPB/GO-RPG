function hit(kid, pid, dmg)
{
	_onHit(kid, pid, dmg);
}

function hitBot(bot, pid, dmg)
{
	_onHit(bot, pid, dmg);
}

function _onHit(kid, pid, dmg)
{
	local offset = dmg;
	player.setHealth(pid, player.getHealth(pid) - offset);
	
	if(isBot(kid) == true) {
		if (player.getHealth(pid) <= 0) {
			kid.unfocus(pid);
		}
	}
	
	if (kid != -1) {
		if (player.getHealth(pid) <= 0) {
			_onKill(kid, pid, dmg);
		}
	}
}

function _onKill(kid, pid, dmg)
{
	
}