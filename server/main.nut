function onPlayerJoin(pid)
{
	spawnPlayer(pid);
}

addEventHandler("onPlayerJoin", onPlayerJoin);

function onPlayerRespawn(pid)
{
	spawnPlayer(pid);
}

addEventHandler("onPlayerRespawn", onPlayerRespawn);

function onPlayerMessage(pid, message)
{
	print(getPlayerName(pid) + " said: " + message);
	sendPlayerMessageToAll(pid, 255, 255, 255, message);
}

addEventHandler("onPlayerMessage", onPlayerMessage);