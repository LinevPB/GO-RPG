local s_id = 0;
local _dialogue = [];

class npcDialogue
{
	constructor(src)
	{
		s_id++;
		id = s_id;
		options = [];
		options = load(src);

		_dialogue.append(this);
	}
	
	function load(src)
	{
		return loadDialogue(src);
	}
	
	id = -1;
	options = [];
}

function _getNpcDialogue(id)
{
	foreach (v in _dialogue) {
		if (v.id == id) {
			return v;
		}
	}
}