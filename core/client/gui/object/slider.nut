class slider
{
	constructor(x, y, range, squares, rows, squares_limit, square_height)
	{
		slider_frame = Texture(x, y, 150, range, "LOG_PAPER.TGA");
		
		slider_txt = Texture(x - 25, y, 200 + 25, 300, "MENU_MASKE.TGA");
		
		slider_visible = false;
		slider_pressed = false;
		
		this.squares = squares;
		this.squares_limit = squares_limit;
		this.square_height = square_height;
		this.rows = rows;
		
		//y + range / square_height * square_limit
	}
	
	function getPosition()
	{
		return {
			x = slider_frame.getPosition().x,
			y = slider_frame.getPosition().y
		};
	}
	
	function getSize()
	{
		return {
			width = slider_frame.getSize().width,
			height = slider_frame.getSize().height
		};
	}
	
	function show()
	{
		slider_txt.visible = true;
		slider_frame.visible = true;
		slider_visible = true;
		slider_txt.top();
	}
	
	function hide()
	{
		slider_txt.visible = false;
		slider_frame.visible = false;
		slider_visible = false;
	}
	
	function onRender()
	{
		if (slider_visible == true && slider_pressed == true) {
			local c = getCursorPosition();
			
			local offsetY = c.y + y_clicked;
			
			c.y = offsetY;
			
			if (c.y > (slider_frame.getPosition().y + slider_frame.getSize().height - slider_txt.getSize().height)) {
				offsetY = (slider_frame.getPosition().y + slider_frame.getSize().height - slider_txt.getSize().height)
			} else if (c.y < slider_frame.getPosition().y) {
				offsetY = slider_frame.getPosition().y;
			}
			
			slider_txt.setPosition(slider_txt.getPosition().x, offsetY);
			
			this.event();
		}
	}
	
	function slide(val)
	{
		if ((slider_txt.getPosition().y + slider_txt.getSize().height + val) > (slider_frame.getPosition().y + slider_frame.getSize().height)) {
			slider_txt.setPosition(slider_txt.getPosition().x, slider_frame.getPosition().y + slider_frame.getSize().height - slider_txt.getSize().height);
		} else if ((slider_txt.getPosition().y + val) < slider_frame.getPosition().y) {
			slider_txt.setPosition(slider_txt.getPosition().x, slider_frame.getPosition().y);
		} else {
			slider_txt.setPosition(slider_txt.getPosition().x, slider_txt.getPosition().y + val);
		}
		
		this.event();
	}
	
	function onClick(btn)
	{
		if (btn == MOUSE_LMB) {
			if (slider_visible == true) {
				local c = getCursorPosition();
				
				if (c.x >= slider_txt.getPosition().x &&
					c.x <= (slider_txt.getSize().width + slider_txt.getPosition().x) &&
					c.y >= slider_txt.getPosition().y &&
					c.y <= (slider_txt.getSize().height + slider_txt.getPosition().y)) {
							
					slider_pressed = true;
					
					y_clicked = slider_txt.getPosition().y - c.y;
					
					return true;
				}
			}
		}
		
		return false;
	}
	
	function onRelease(btn)
	{
		if (btn == MOUSE_LMB) {
			if (slider_pressed == true) {
				slider_pressed = false;
			}
		}
	}
	
	function event()
	{
		local f_y = slider_frame.getPosition().y;
		local f_h = slider_frame.getSize().height;
		
		local t_y = slider_txt.getPosition().y;
		local t_h = slider_txt.getSize().height;
		
		slider_percentage = percentage((t_y - f_y), (f_h - t_h));
	}
	
	function getSliderPercentage()
	{
		return slider_percentage;
	}
	
	slider_txt = null;
	slider_frame = null;
	slider_pressed = false;
	slider_visible = false;
	y_clicked = 0;
	squares = 0;
	squares_limit = 0;
	square_height = 0;
	rows = 0;
	slider_percentage = 0;
}