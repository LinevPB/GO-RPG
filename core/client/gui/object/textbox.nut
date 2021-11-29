addEvent("onOpenTextbox");
addEvent("onCloseTextbox");
addEvent("onUpdateTextbox");

local textbox_param = {
	active = false,
	parent_id = -1,
	id = -1
};

function isTextboxActive()
{
	return textbox_param.active;
}

function getTextboxParent()
{
	return textbox_param.parent_id;
}

function getTextbox()
{
	return textbox_param.id;
}

function setTextboxId(id)
{
	textbox_param.id = id;
}

function setTextboxParent(id)
{
	textbox_param.parent_id = id;
}

function setTextboxActivity(value)
{
	textbox_param.active = value;
}

class textbox
{
	constructor(params)
	{
		margin = 60;
		
		draw = Draw(params.x + margin, params.y, params.text + "Hello world");
		draw.font = "FONT_OLD_10_WHITE_HI.TGA";
		draw.setColor(255,217,197);
		draw.setPosition(draw.getPosition().x, draw.getPosition().y - draw.height / 2 + params.height / 2);
		draw.text = params.text;
		visible = false;
		active = false;
		text = "";
		prov_text = params.text;
		writing_mark = "_";
		sliced_time = 0;
		_type = params._type;
		
		texture = Texture(params.x, params.y, params.width, params.height, params.texture);
		draw.top();
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
	
	function activate()
	{
		active = true;
		setTextboxActivity(true);
		setTextboxId(this);
		sliced_time = 0;
		updateTextbox("");
		onOpenTextbox(this);
	}
	
	function deactivate()
	{
		active = false;
		setTextboxActivity(false);
		setTextboxId(false);
		setTextboxParent(false);
		sliced_time = 0;
		updateTextbox("");
		onCloseTextbox(this);
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
		active = false;
		setTextboxActivity(false);
		setTextboxParent(-1);
		setTextboxId(-1);
		setText("");
	}
	
	function setText(_text)
	{
		text = _text;
		password = _text;
		updateTextbox("");
	}
	
	function getText()
	{
		return text;
	}
	
	function updateTextbox(letter)
	{
		if (letter == "slice") {
			if (text.len() > 0)
				text = text.slice(0, text.len() - 1);
		} else {
			text = text + letter;
		}
		
		local _text;
		
		if (_type == type.passwordbox) {
			if (letter.len() > 0) {
				if (letter != "slice") {
					if (letter != "")
						password = password + "#";
				} else {
					if (password.len() > 0)
						password = password.slice(0, password.len() - 1);
				}
			}
			_text = password;
		} else {
			_text = text;
		}
		
		if (isTextboxActive() == true) {
			prov_text = _text + writing_mark;
		} else {
			prov_text = _text;
		}
		
		draw.text = (prov_text);
		
		while(draw.width + margin > texture.getSize().width - margin / 2) {
			sliced_time++;
			
			prov_text = _text.slice(sliced_time, _text.len());
			
			if (isTextboxActive() == true)
				prov_text = prov_text + writing_mark;
		
			draw.text = prov_text;
		}
		
		sliced_time = 0;
		
		onUpdateTextbox(this);
	}
	
	function sliceText()
	{
		updateTextbox("slice");
	}
	
	draw = null;
	visible = false;
	active = false;
	texture = null;
	_type = null;
	text = "";
	prov_text = "";
	writing_mark = "";
	sliced_time = -1;
	margin = 0;
	password = "";
}

function textbox_key(key)
{
	//print(key);
	
	if (isTextboxActive() == true) {
		if ((key >= 2 && key <= 11) ||
			(key >= 16 && key <= 25) ||
			(key >= 30 && key <= 38) ||
			(key >= 44 && key <= 50) ||
			key == 57) {
				if (isKeyPressed(42) || isKeyPressed(54)) {
					getTextbox().updateTextbox(getKeyLetter(key).toupper());
				} else {
					getTextbox().updateTextbox(getKeyLetter(key));
				}
		}
		
		if (key == 1 || key == 28) {
			getTextbox().deactivate();
		}
		
		if (key == 14) {
			getTextbox().sliceText();
		}
	}
}

addEventHandler("onKey", textbox_key);

function onOpenTextbox(id)
{	
}

function onCloseTextbox(id)
{	
}

function onUpdateTextbox(id)
{	
}