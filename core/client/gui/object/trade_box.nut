class tradeBox
{
	constructor(_text)
	{
		visible = false;
		
		n_menu = menu({
			x = 0,
			y = 3000,
			width = 2000,
			height = 1500,
			align = align.center,
			texture = "LOG_PAPER.TGA"});
			
		ok_btn = n_menu.add({
			x = 350,
			y = 1000,
			width = 600,
			height = 300,
			text = "Ok",
			texture = "MENU_CHOICE_BACK.TGA"
		}, "INV_TITEL.TGA");
		
		close_btn = n_menu.add({
			x = 1050,
			y = 1000,
			width = 600,
			height = 300,
			text = "Cancel",
			texture = "MENU_CHOICE_BACK.TGA"
		}, "INV_TITEL.TGA");
		
		amount_box = n_menu.addTextbox({ x = 500, y = 550, text = "", texture = "MENU_CHOICE_BACK.TGA", width = 1000, height = 250});
		n_menu.addInput( { x = 0, y = 200, center = true, text = _text } );
	}
	
	function show()
	{
		n_menu.show();
		visible = true;
	}
	
	function hide()
	{
		n_menu.hide();
		visible = false;
	}
	
	function getOkButton()
	{
		return ok_btn;
	}
	
	function getCloseButton()
	{
		return close_btn;
	}
	
	function getText()
	{
		return amount_box.getText().tointeger();
	}
	
	function setText(text)
	{
		amount_box.setText(text);
	}
	
	n_menu = null;
	ok_btn = null;
	close_btn = null;
	visible = null;
	amount_box = null;
}

function onBoxRelease(a)
{
}