function ai_onhit(kid, pid, dmg)
{
	if (kid != -1) {
		if (isBot(pid)) {
			if (getBot(getBotServerId(pid)).isDead() == false) {
				callServerFunc("onHitMonster", kid, getBotServerId(pid), dmg);
				
				if ((getPlayerHealth(pid) - dmg)  <= 0) {
					callServerFunc("onKillMonster", kid, getBotServerId(pid), dmg);
				}
				
				if (getBot(getBotServerId(pid)).aggressive == false) {
					chat.send(255,255,255,"Nie uderzaj npc!");
					setPlayerHealth(pid, getPlayerMaxHealth(pid));
				}
			}
		}
		
	} else {
		///////
	}
}

function ai_ondead(pid)
{
	
}

addEventHandler("onPlayerHit", ai_onhit);

addEventHandler("onPlayerDead", ai_ondead);

function onHitMonster(kid, pid, dmg)
{	
}

function onKillMonster(kid, pid, dmg, exp)
{
}