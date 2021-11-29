local s_id = 0;
local _menu = [];

class npcMenu
{
	constructor(params)
	{
		s_id++;
		id = s_id;
		options = params;
		_menu.append(this);
	}
	
	id = null;
	options = null;
}

function _getNpcMenu(id)
{
	foreach (v in _menu) {
		if (v.id == id) {
			return v;
		}
	}
}