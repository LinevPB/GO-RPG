function onHitMonster(kid, pid, dmg)
{
	print(getPlayerName(kid) + " hit BOT " + getBot(pid).set.name + " with damage of " + dmg); 
	getBot(pid).setHealth(getBot(pid).getHealth() - dmg);
}

function onKillMonster(kid, pid, dmg)
{
	print(getPlayerName(kid) + " killed BOT " + getBot(pid).set.name + " with last damage of " + dmg); 
	getBot(pid).die();
	
	if (getBot(pid).set.drop != false) {
		getBot(pid).set.drop(kid);
	}
	
	dropExp(kid, getBot(pid).set.experience);
}

function monster_ai_init()
{
	setTimer(monster_timer, 100, 0);
}

addEventHandler("onInit", monster_ai_init);

function monster_timer()
{
	local hPos;
	local bPos;
	local dist;
	
	foreach(v in getBots()) {
		if (v.isDead() == false && v.isSpawned() == true) {
			if (v.set.aggressive == true) {
				foreach(k in getPlayers()) {
					if (isPlayerDead(k) == false) {
						hPos = getPlayerPosition(k);
						bPos = v.getPosition();
						dist = getDistance3d(hPos.x, hPos.y, hPos.z, bPos.x, bPos.y, bPos.z);
						local angle = getVectorAngle(bPos.x, bPos.z, hPos.x, hPos.z);
						if (dist <= 600) {
							v.setAngle(angle);
							
							if (v.isFocused(k) == false)
								v.addFocus(k);

							if (dist <= 250) {
								v.set.timer += 100;
								if (v.set.timer >= 2000) {
									v.playAnimation("S_FISTATTACK");
									hitBot(v, k, v.set.strength);
									v.set.timer = 0;
								} else {
									v.playAnimation("S_RUN");
								}
							} else {
								v.playAnimation("S_FISTRUNL");
								v.set.attacking = true;
							}
						}  else if (dist <= 1000) {
								v.setAngle(angle);
								v.addFocus(k);
						} else {
								v.unfocus(k);
						}
					} else {
						if (v.isFocused(k)) {
							v.unfocus(k);
						}
					}
				}
			}
		}
	}
}

