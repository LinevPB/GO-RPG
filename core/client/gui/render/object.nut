local objects = [];

enum type {
	button,
	input,
	textbox,
	passwordbox,
	selector,
	switcher
};

class object
{
	constructor(id)
	{
		objects.push(id);
	}
}

local object_render_time = 0;

function object_render()
{
	if (object_render_time < getTickCount())
	{
		foreach(v in objects) {
			if (v.visible == true) {
				v.checkHovering();
			}
		}
		
		object_render_time = getTickCount() + 100;
	}
}

addEventHandler("onRender", object_render);

function mouse_click(btn)
{
	
	switch (btn)
	{
	case MOUSE_LMB:
		foreach (v in objects) {
			if (v.visible == true) {
				v.onClick();
			}
		}
		break;
		
	case MOUSE_RMB:
		
		break;
		
	case MOUSE_MMB:
		
		break;
	}
}

addEventHandler("onMouseClick", mouse_click);

function mouse_release(btn)
{
	switch (btn)
	{
	case MOUSE_LMB:
		foreach (v in objects) {
			if (v.visible == true) {
				v.onRelease();
			}
		}
		break;
		
	case MOUSE_RMB:
		
		break;
		
	case MOUSE_MMB:
		
		break;
	}
}

addEventHandler("onMouseRelease", mouse_release);