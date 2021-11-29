class input
{
	constructor(params)
	{
		_type = type.input;
		draw = Draw(params.x, params.y, params.text);
		draw.font = "FONT_OLD_10_WHITE_HI.TGA";
		draw.setColor(255,255,255);
		visible = false;
		hovered = false;
		active = false;
		original_x = params.x;
		center_x = params.center_x;
		
		if (params.center == true) {
			center();
		}
		
		draw.top();
	}
	
	function center()
	{
		draw.setPosition(center_x - draw.width / 2, draw.getPosition().y);
	}
	
	function uncenter()
	{
		draw.setPosition(original_x, draw.getPosition().y);
	}
	
	function show()
	{
		visible = true;
		draw.visible = true;
	}
	
	function hide()
	{
		visible = false;
		draw.visible = false;
	}
	
	draw = null;
	visible = false;
	hovered = false;
	active = false;
	_type = null;
	original_x = 0;
	center_x = 0;
}