class selector_option
{
	constructor(params)
	{
		field = { x = params.x,
			y = params.y,
			width = params.width,
			height = params.height
		};
		
		draw = Draw(params.x, params.y, params.text);
		texture = Texture(params.x, params.y, params.width, params.height, params.texture);
		
		draw.setColor(255,255,255);
		draw.font = "FONT_OLD_10_WHITE_HI.TGA";
		
		local offsetX = params.x + ((params.width - draw.width) / 2);
		local offsetY = params.y + ((params.height - draw.height) / 2);
		
		draw.setPosition(offsetX, offsetY);
		
		draw.top();
		
		visible = false;
		active = false;
		
		turn = params.amount;
		selected = false;
	}
	
	function setText(text)
	{
		draw.text = text;
		draw.setPosition(field.x + field.width / 2 - draw.width / 2, field.y + field.height / 2 - draw.height / 2);
	}
	
	function show()
	{
		draw.visible = true;
		texture.visible = true;
		visible = true;
	}
	
	function hide()
	{
		draw.visible = false;
		texture.visible = false;
		visible = false;
		selected = false;
	}
	
	function isInside()
	{
		local pos = getCursorPosition();
		local dpos = texture.getPosition();
		local dheight = texture.getSize().height;
		local dwidth = texture.getSize().width;
		
		if (pos.x >= dpos.x && pos.y >= dpos.y && pos.x <= dpos.x + dwidth && pos.y <= dpos.y + dheight) {
			return true;
		} else {
			return false;
		}
	}
	
	function getTurn()
	{
		return turn;
	}
	
	function select()
	{
		draw.setColor(255,0,0);
		
		selected = true;
	}
	
	function unselect()
	{
		draw.setColor(255,255,255);
		
		selected = false;
	}
	
	function hover()
	{
		if (selected == false) {
			draw.setColor(255, 255, 0);
		}
		
		texture.file = "INV_TITEL.TGA";
		
		hovered = true;
	}
	
	function unhover()
	{
		if (selected == false) {
			draw.setColor(255, 255, 255);
		}
		
		texture.file = "MENU_CHOICE_BACK.TGA";
		
		hovered = false;
	}
	
	draw = null;
	texture = null;
	visible = false;
	field = {};
	active = false;
	turn = -1;
	selected = false;
	hovered = false;
}

class selector
{

	constructor(params)
	{
		amount = 0;
		list = [];
		selected = -1;
		visible = false;
		_type = type.selector;
		
		selector_field = {
			x = params.x,
			y = params.y,
			width = params.width,
			height = params.height
		};
		
		hovered = null;
	}

	function addOption(params)
	{
		amount++;
		
		params.amount <- amount;
		params.x = params.x + selector_field.x;
		params.y = params.y + selector_field.y;
		
		local option = selector_option(params);
		
		list.append(option);
		
		return option;
	}
	
	function toggle()
	{
		visible ? show() : hide();
	}
	
	function show()
	{
		foreach (v in list) {
			v.show();
		}
		
		visible = true;
	}
	
	function hide()
	{
		foreach (v in list) {
			v.hide();
		}
		
		visible = false;
		selected = -1;
	}
	
	function getOption(turn)
	{
		foreach (v in list) {
			if (v.turn == turn) {
				return v;
			}
		}
		
		return false;
	}
	
	function checkHovering()
	{
		foreach  (v in list) {
			if (v.isInside() == true && v.hovered == false) {
				v.hover();
				onHoverOption(v, this);
			} else if (v.isInside() == false && v.hovered == true) {
				v.unhover();
				onUnhoverOption(v, this);
			}
		}
	}
	
	function onClick()
	{
		foreach(v in list) {
			if (v.isInside() == true) {
				if (selected != v.getTurn()) {
					if (selected != -1) {
						getOption(selected).unselect();
					}
					
					selected = v.getTurn();
					v.select();
					
					onSelectOption(v, this, v.turn);
				}
			}
		}
	}
	
	function onRelease()
	{
	}
	
	function getSelection()
	{
		return selected;
	}
	
	function reset()
	{
		foreach(v in list) {
			if (selected == v.getTurn()) {
				v.unselect();
			}
		}
	}
	
	list = [];
	selected = -1;
	visible = false;
	_type = null;
	selector_field = {};
	hovered = null;
	amount = 0;
}

function onHoverOption(option, menu)
{
}

function onUnhoverOption(option, menu)
{
}

function onSelectOption(option, menu, option_id)
{
}