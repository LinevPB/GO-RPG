addEvent("onClickButton");
addEvent("onReleaseButton");
addEvent("onHoverButton");
addEvent("onUnhoverButton");

class button
{
	constructor(params, tex = -1)
	{
		draw = Draw(params.x, params.y, params.text);
		draw.font = "FONT_OLD_10_WHITE_HI.TGA";
		draw.setColor(255,255,255);
		visible = false;
		hovered = false;
		active = false;
		_type = type.button;

		texture = Texture(params.x, params.y, params.width, params.height, params.texture);
		
		centerDraw();
		draw.top();
		
		normal_tex = params.texture;
		
		if (tex == -1)
			hover_tex = params.texture;
		else
			hover_tex = tex;
	}
	
	function isHovered()
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
	
	function show()
	{
		visible = true;
		draw.visible = true;
		texture.visible = true;
	}
	
	function hide()
	{
		visible = false;
		draw.visible = false;
		texture.visible = false;
	}
	
	function centerDraw()
	{
		local pos = texture.getPosition();
		local size = texture.getSize();
		draw.setPosition(pos.x + size.width / 2 - draw.width / 2, pos.y + size.height / 2 - draw.height / 2);
	}
	
	function changeText(text)
	{
		draw.text = text;
		centerDraw();
	}
	
	function onClick()
	{
		draw.setColor(190,180,30);
		onClickButton(this);
		callEvent("onClickButton", this);
	}
	
	function onRelease()
	{
		if (isHovered() == true)
			draw.setColor(255,255,0);
		else
			draw.setColor(255,255,255);
			
		onReleaseButton(this);
		
		inventory.onReleaseNaviButton(this);
		quests.onReleaseNavi(this);
		onTradeRelease(this);
		npcSale.onReleaseNavi(this);
		onBoxRelease(this);
	}
	
	function onHover()
	{
		texture.file = hover_tex;
		onHoverButton(this);
	}
	
	function onUnhover()
	{
		texture.file = normal_tex;
		onUnhoverButton(this);
	}
	
	function changeColor(r,g,b)
	{
		draw.setColor(r,g,b);
	}
	
	function getColor()
	{
		return draw.getColor();
	}
	
	draw = null;
	visible = false;
	hovered = false;
	active = false;
	texture = null;
	_type = null;
	normal_tex = null;
	hover_tex = null;
}

function onHoverButton(id)
{	
}

function onUnhoverButton(id)
{	
}