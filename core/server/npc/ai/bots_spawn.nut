function on_join_spawn(pid)
{
	if (getBotsAmount() > 0) {
		foreach (v in getBots()) {
			v.playersBotSpawn();
		}
	}
}

addEventHandler("onPlayerJoin", on_join_spawn);