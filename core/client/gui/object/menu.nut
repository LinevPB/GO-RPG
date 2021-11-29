addEvent("onOpenMenu");
addEvent("onCloseMenu");

enum align {
	left,
	center,
	right,
	none
};

class menu extends object
{
	constructor (params)
	{
		config = {
			x = params.x,
			y = params.y,
			width = params.width,
			height = params.height,
		}
		
		switch(params.align) {
			case align.left:
				config.x = 10;
			break;
			
			case align.center:
				config.x = 8192.0 /  2 - config.width / 2;
			break;
			
			case align.right:
				config.x = 8192.0 - config.width;
			break;
			
			case align.none:
				config.x = config.x;
			break;
		
		}
		
		frame = Texture(config.x, config.y, config.width, config.height, params.texture);
		items = [];
		visible = false;
		active = false;
		
		base.constructor(this);
	}
	
	function getConfig()
	{
		return {
			x = config.x,
			y = config.y,
			width = config.width,
			height = config.height
		};
	}
	
	function add(params, tex = -1)
	{
		params.x = params.x + config.x;
		params.y = params.y + config.y;
		
		local btn = button(params, tex);
		
		items.append(btn);
		
		return btn;
	}
	
	function show()
	{
		visible = true;
		
		frame.visible = true;
		
		foreach(item in items) {
			item.show();
		}
		
		onOpenMenu(this);
	}
	
	function hide()
	{
		visible = false;
		
		frame.visible = false;
		
		foreach(item in items) {
			item.hide();
		}
		
		onCloseMenu(this);
	}
	
	function toggle()
	{
		visible ? show() : hide();
	}
	
	function checkHovering()
	{
		if (isCursorVisible()) {
			foreach (item in items) {
				if (item.visible == true) {
					if (item._type == type.button) {
						if (item.isHovered() == true && item.hovered == false) {
							onHover(item);
						}
						
						if (item.isHovered() ==  false && item.hovered == true) {
							onUnhover(item);
						}
					}
					
					if (item._type == type.selector || item._type == type.switcher) {
						item.checkHovering();
					}
				}
			}
		}
	}
	
	function onHover(item)
	{
		item.hovered = true;
		item.draw.setColor(255,255,0);
		item.onHover();
	}
	
	function onUnhover(item)
	{
		item.hovered = false;
		item.draw.setColor(255,255,255);
		item.onUnhover();
	}
	
	function onClick()
	{
		foreach (item in items) {
			if (item._type != type.selector && item._type != type.switcher) {
				if (item.active == false) {
					if (item._type == type.button) {
						if (item.isHovered() == true) {
							if (item.visible == true) {
								item.active = true;
								item.onClick();
							}
						}
					}
					else if (item._type == type.textbox || item._type == type.passwordbox) {
						if (isTextboxActive() == true) {
							if (getTextbox().isHovered() == false)
								getTextbox().deactivate();
						}
			
						if (item.isHovered() == true) {
							if (item.active == false) {
								setTextboxParent(this);
								item.activate();
							}
						}
					}
				}
			} else {
				item.onClick();
			}
		}
	}
	
	function onRelease()
	{
		foreach (item in items) {
			if (item._type != type.selector && item._type != type.switcher) {
				if (item.active == true) {
					item.active = false;
					
					if (item._type == type.button)
						item.onRelease();
				}
			} else {
				item.onRelease();
			}
		}
	}
	
	function addInput(params)
	{
		params.x = params.x + config.x;
		params.y = params.y + config.y;
		params.center_x <- config.x + config.width / 2;
		
		local inp = input(params);
		
		items.append(inp);
		
		return inp;
	}
	
	function change(id)
	{
		this.hide();
		id.show();
	}
	
	function addTextbox(params)
	{
		params.x = params.x + config.x;
		params.y = params.y + config.y;
		params._type <- type.textbox;
		
		local txtb = textbox(params);
		
		items.append(txtb);
		
		return txtb;
	}
	
	function addPasswordbox(params)
	{
		params.x = params.x + config.x;
		params.y = params.y + config.y;
		params._type <- type.passwordbox;
		
		local txtb = textbox(params);
		
		items.append(txtb);
		
		return txtb;
	}
	
	function addSelector()
	{
		local params = {};
		
		params.x <- config.x;
		params.y <- config.y;
		params.width <- config.width;
		params.height <- config.height
		params._type <- type.selector;
		
		local selec = selector(params);
		
		items.append(selec);
		
		return selec;
	}
	
	function addSwitch(params)
	{	
		params.x <- config.x + params.x;
		params.y <- config.y + params.y;
		params.width <- params.width;
		params.height <- params.height
		params._type <- type.switcher;
		
		local swit = switcher(params);
		
		items.append(swit);
		
		return swit;
	}
	
	config = null;
	frame = null;
	items = null;
	visible = false;
	active = false;
}

function onOpenMenu(id)
{	
}

function onCloseMenu(id)
{	
}