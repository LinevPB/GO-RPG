class switcher
{
	constructor(params)
	{	
		visible = false;
		left_active = false;
		right_active = false;
		left_hovered = false;
		right_hovered = false;
		
		_type = params._type;
		items = params.items;
		
		field = {};
		field.x <- params.x;
		field.y <- params.y;
		field.width <- params.width;
		field.height <- params.height;
		
		////////
		
		textures = {};
		textures.left <- Texture(params.x, params.y, 200, params.height, params.texture);
		textures.right <- Texture(params.x + params.width - 200, params.y, 200, params.height, params.texture);
		textures.main <- Texture(params.x + 200, params.y, params.width - 200 * 2, params.height, params.texture);
		
		/////////
		
		draws = {};
		draws.left <- Draw(params.x, params.y, "<");
		draws.right <- Draw(params.x, params.y, ">");
		draws.main <- Draw(params.x, params.y, "DOJCZLAND");
		
		draws.left.font = "FONT_OLD_20_WHITE_HI.TGA";
		draws.right.font = "FONT_OLD_20_WHITE_HI.TGA";
		
		local offsetX, offsetY;
		
		///////
		offsetY = params.y + ((params.height - draws.main.height) / 2);
		offsetX = params.x + 200 + ((params.width - 200 * 2 - draws.main.width) / 2);
		draws.main.setPosition(offsetX, offsetY);
		///////
		offsetY = params.y + ((params.height - draws.left.height) / 2);
		offsetX = params.x + ((200 - draws.left.width) / 2);
		draws.left.setPosition(offsetX, offsetY);
		///////
		offsetY = params.y + ((params.height - draws.right.height) / 2);
		offsetX = params.x + params.width - 200 + ((200 - draws.right.width) / 2);
		draws.right.setPosition(offsetX, offsetY);
	}
	
	function toggle()
	{
		visible ? show() : hide();
	}
	
	function show()
	{
		textures.left.visible = true;
		textures.right.visible = true;
		textures.main.visible = true;
		
		draws.left.visible = true;
		draws.right.visible = true;
		draws.main.visible = true;
		
		visible = true;
		
		if (current == -1)
			current = 0;
		
		updateText();
	}
	
	function hide()
	{
		textures.left.visible = false;
		textures.right.visible = false;
		textures.main.visible = false;
		
		draws.left.visible = false;
		draws.right.visible = false;
		draws.main.visible = false;
		
		visible = false;
		current = -1;
	}
	
	function isInside(id)
	{
		local pos = getCursorPosition();
		local dpos = id.getPosition();
		local dheight = id.getSize().height;
		local dwidth = id.getSize().width;
		
		if (pos.x >= dpos.x && pos.y >= dpos.y && pos.x <= dpos.x + dwidth && pos.y <= dpos.y + dheight) {
			return true;
		} else {
			return false;
		}
	}
	
	function onClick()
	{
		if (isInside(textures.left) == true) {
			draws.left.setColor(255, 185, 0);
			left_active = true;
		} else if (isInside(textures.right) == true) {
			draws.right.setColor(255, 185, 0);
			right_active = true;
		}
	}
	
	function onRelease()
	{
		if (left_active == true) {
			left_active = false;
			draws.left.setColor(255,255,255);
			switchLeft();
		} else if (right_active == true) {
			right_active = false;
			draws.right.setColor(255,255,255);
			switchRight();
		}
	}
	
	function checkHovering()
	{
		if (isInside(textures.left) == true && left_active == false) {
			left_hovered == true;
			draws.left.setColor(255,255,0);
		}
		
		if (isInside(textures.right) == true && right_active == false) {
			right_hovered == true;
			draws.right.setColor(255,255,0);
		}
		
		///////////
		
		if (isInside(textures.left) == false && left_active == false) {
			draws.left.setColor(255,255,255);
			left_hovered = false;
		}
		
		if (isInside(textures.right) == false && right_active == false) {
			draws.right.setColor(255,255,255);
			right_hovered = false;
		}
	}
	
	function updateText()
	{
		foreach(i, v in items) {
			if (current == i) {
				draws.main.text = v;
				break;
			}
		}
		
		local offsetY = field.y + ((field.height - draws.main.height) / 2);
		local offsetX = field.x + 200 + ((field.width - 200 * 2 - draws.main.width) / 2);
		draws.main.setPosition(offsetX, offsetY);
	}
	
	function makeSwitch(val)
	{
		current = current + val;
		
		if (current >= items.len()) {
			current = 0;
		}
		
		if (current < 0) {
			current = items.len() - 1;
		}
		
		updateText();
	}
	
	function switchLeft()
	{
		makeSwitch(-1);
	}
	
	function switchRight()
	{
		makeSwitch(1);
	}
	
	draws = {};
	textures = {};
	field = {};
	visible = false;
	items = [];
	_type = false;
	left_active = false;
	right_active = false;
	left_hovered = false;
	right_hovered = false;
	current = -1;
}