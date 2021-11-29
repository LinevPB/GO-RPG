local _menu = [];

function _getNpcMenus()
{
	return _menu;
}

local _tick = 0 ;

local function _npc_menu_render()
{
	if (_menu != false) {
		if (_tick < getTickCount()) {
			foreach(v in _menu) {
				if (v.visible == true)
					v._checkHovering();
			}
			
			_tick = _tick + 20;
		}
	}
}

addEventHandler("onRender", _npc_menu_render);

local function _on_release(btn)
{
	if (btn == MOUSE_LMB) {
		if (_menu != false) {
			foreach(v in _menu) {
				if (v.active != false && v.visible == true) {
					v.onRelease(btn);
				}
			}
			
			return false;
		}
		
		return false;
	}
	
	return false;
}

addEventHandler("onMouseRelease", _on_release);

local function _on_click(btn)
{
	if (btn == MOUSE_LMB) {
		if (_menu != false) {
			foreach (v in _menu) {
				if (v.visible == true) {
					foreach(b in v.draws) {
						if (v.isInside(b.draw)) {
							v.onClick(btn, b.draw);
							return true;
						}
					}
				}
			}
			
			return false;
		}
		
		return false;
	}
	
	return false;
}

addEventHandler("onMouseClick", _on_click);

class npcMenu
{
	constructor(_id, params)
	{	
		draws = [];
		hover = false;
		current = -1;
		active = false;
		txt = false;
		visible = false;
		menu_id = _id;
		id = this;
		
		txt = Texture(2596, 6400, 3000, 1400, "DLG_CONVERSATION.TGA");
		txt.visible = false;
		
		foreach(i, v in params) {
			local parameters = {};
			parameters.draw <- Draw(txt.getPosition().x + 50, txt.getPosition().y + 50 + i * 200, v);
			parameters.draw.setColor(255,255,255);
			parameters.draw.visible = false;
			draws.append(parameters);
		
			if (i == 0) {
				parameters.draw.setColor(255,255,0);
				hover = parameters.draw;
				current = 1;
			}
		}
		
		_menu.append(this);
	}
	
	function show()
	{
		foreach(i, v in draws) {
			v.draw.visible = true;
		}
		
		txt.visible = true;
		visible = true;
		setCursorVisible(true);
	}
	
	function close()
	{
		foreach(i, v in draws) {
			v.draw.visible = false;
		}
		
		txt.visible = false;
		visible = false;
		setCursorVisible(false);
	}
	
	function toggle()
	{
		active ? show() : close();
	}
	
	function isInside(dr)
	{
		local border =  60;
		local _c = getCursorPosition();
		local _dr = dr;
		local _d = dr.getPosition();
		local _t =  txt.getSize();
			
		if (_c.x >= _d.x && _c.x <= (_d.x + _t.width) && _c.y >= _d.y - border / 4 && _c.y <= (_d.y + _dr.height) + border / 4) {	
			return _dr;
		}
	}
	
	function getHovering()
	{
		foreach(v in draws) {
			if (isInside(v.draw)) {
				return v.draw;
			}
		}
		
		return false;
	}
	
	function _checkHovering()
	{
		if (active == false) {
			local _hov = getHovering();
			
			if (hover != false) {
				if (hover != _hov && _hov != false) {
					hover.setColor(255,255,255);
				}
			}
			
			if (_hov != false) {
				if (_hov != hover) {
					_hov.setColor(255,255,0);
					hover = _hov;
					
					foreach (i, v in draws) {
						if (v.draw == _hov) {
							current = i + 1;
						}
					}
					
					return;
				}
			}
		}
	}
	
	function getCurrentOption()
	{
		return current;
	}
	
	function onClick(btn, draw)
	{
		active = draw;
		active.setColor(240, 190, 20);
		onClickNpcMenu(this);
	}
	
	function onRelease(btn)
	{
		if (hover == active)
			active.setColor(255,255,0);
		else
			active.setColor(255,255,255);
		
		active = false;
		onReleaseNpcMenu(menu_id, current);
		
		_checkHovering();
	}
	
	menu_id = null;
	draws = null;
	hover = null;
	current = null;
	active = null;
	id = null;
	txt = null;
	visible = null;
}

function _closeNpcMenu(id)
{
	if (_menu != false) {
		foreach(v in _menu) {
			if (v.menu_id == id) {
				v.close();
				
				return true;
			}
		}
		
		return false;
	}
	
	return false;
}

function _showNpcMenu(id)
{
	if (_menu != false) {
		foreach(v in _menu) {
			if (v.menu_id == id) {
				v.show();
				
				return true;
			}
		}
		
		return false;
	}
	
	return false;
}