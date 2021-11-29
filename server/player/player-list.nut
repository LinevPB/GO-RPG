local players = [];

function getPlayers()
{
	return players;
}

function getPlayersAmount()
{
	return players.len();
}

function on_join_list(pid)
{
	players.append(pid);
}

addEventHandler("onPlayerJoin", on_join_list);

function on_disconnect_list(pid, reason)
{
	players.remove(players.find(pid));
}

addEventHandler("onPlayerDisconnect", on_disconnect_list);