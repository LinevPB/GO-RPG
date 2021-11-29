local t_id = 0;
local _npcTrade = [];

class npcTrade
{
	constructor(params)
	{
		t_id++;
		id = t_id;
		options = params;
		
		_npcTrade.append(this);
	}
	
	id = null;
	options = null;
}

function getNpcTrade(id)
{
	foreach(v in _npcTrade) {
		if (v.id == id) {
			return v;
		}
	}
}