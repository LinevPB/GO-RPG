talking <- false;
current_dlg <- false;

class npcDialogue
{
	constructor(_id, lines)
	{
		id = _id;
			
		_row = [];	
		
		texture = Texture(8192 / 2 - 2000, 3000, 4000, 2000, "DLG_CONVERSATION.TGA");
		
		local started = false;
		local cnt = 0;
		local draws = [];
		local ddraw;
		
		foreach(i, v in lines) {
			if (started == true) {
				if (v.tolower() != "[end]" && v.tolower() != "[next]") {
				
					ddraw = Draw(8192 / 2 + 60 - 2000, 3000 + 200 + i * 150 - cnt * 150, v);
					ddraw.font = "FONT_OLD_10_WHITE_HI.TGA";
					ddraw.setColor(255,217,197);
					ddraw.top();
					if (cnt == i) {
						ddraw.font = "FONT_OLD_20_WHITE_HI.TGA";
						ddraw.setColor(255,180,22);
						
						local offsetX = ((8192 / 2) - ddraw.width / 2)
						
						ddraw.setPosition(offsetX, 3000 + 40);
					}
						
					draws.append(ddraw);
				} else {
					
					if (v.tolower() == "[next]") {
						_row.append(draws);
						draws = [];
					}
					
					if (v.tolower() == "[end]") {
						_row.append(draws);
						draws = [];
						
						break;
					}
				}
			}
			
			if (v.tolower() == "[begin]" || v.tolower() == "[next]") {
				started = true;
				cnt = i + 1;
			}
		}
	}
	
	function show()
	{
		start();
		
		texture.visible = true;
		
		foreach(i, v in _row) {
			if (i == c_row) {
				foreach(j in v) {
					j.visible = true;
				}
			}
		}
		
		talking = true;
	}
	
	function hide()
	{
		talking = false;
		c_row = 0;
		current_dlg = false;
		
		texture.visible = false;
		
		foreach(v in _row) {
			foreach(j in v) {
				j.visible = false;
			}
		}
		_row.clear();
	}
	
	function begin()
	{
		foreach(i, v in _row) {
			if (i == c_row) {
				foreach(j in v) {
					j.visible = false;
				}
				
				c_row++;
				
				break;
			}
		}
		
		foreach (a, b in _row) {
			if (a == c_row) {
				foreach(c in b) {
					c.visible = true;
				}
			}
		}
		
		if (c_row >= _row.len()) {
			onFinishDialogue(this);
		}
	}
	
	function start()
	{
		c_row = 0;
		active = true;
		current_dlg = this;
	}
	
	id = -1;
	c_row = -1;
	texture = -1;
	_row = [];
	active = false;
}

local function _on_dialogue_key(key)
{
	if (key == KEY_SPACE) {
		if (talking == true){
			current_dlg.begin();
		}
	}
}

addEventHandler("onKey", _on_dialogue_key);

local function _on_dialogue_release(key)
{
	if (key == MOUSE_LMB) {
		if (talking == true){
			current_dlg.begin();
		}
	}
}

addEventHandler("onMouseRelease", _on_dialogue_release);

function onFinishDialogue(did)
{
	did.hide();
	
	local packet = Packet();
	packet.writeInt32(DIALOGUE.finish);
	packet.writeInt32(did.id);
	
	packet.send(RELIABLE_ORDERED);
}