enum eq {
	armor = 1,
	melee = 2,
	ranged = 3,
	magic = 4,
	meal = 5,
	other = 6,
	none = 7
}

class information_box
{
	constructor()
	{
		draws = [];
		visible = false;
		
		texture = Texture(0,0,0,0,"LOG_PAPER.TGA");
		
		title = Draw(0,0,"");
		title.font = "FONT_OLD_10_WHITE_HI.TGA";
		title.setColor(255,255,0);
	}
	
	function show(params)
	{
		local item = returnItem(params.inst);
		
		local draw = null;
		
		switch(item.type) {
			case eq.armor:
				draw = Draw(0,400, "Level: " + item.level);
				draws.append(draw);
				
				draw = Draw(0, 600, "Defence: " + item.defence);
				draws.append(draw);
				
				draw = Draw(0, 800, "Protection: " + item.protection);
				draws.append(draw);
				
				draw = Draw(0, 1000, "Evasion: " + item.evasion);
				draws.append(draw);
			break;
			
			case (eq.melee || eq.ranged || eq.magic):
				draw = Draw(0,400, "Level: " + item.level);
				draws.append(draw);
				
				draw = Draw(0, 600, "Attack: " + item.attack);
				draws.append(draw);
				
				draw = Draw(0, 800, "Hit rate: " + item.hitrate);
				draws.append(draw);
				
				draw = Draw(0, 1000, "Critical: " + item.critical);
				draws.append(draw);
			break;
			
			case eq.meal:
				draw = Draw(0,400, item.desc1);
				draws.append(draw);
				
				if (item.desc2 != "") {
					draw = Draw(0,600, item.desc2);
					draws.append(draw);
				}
			break;
			
			case eq.other:
				draw = Draw(0, 400, "Unusable item");
				draw.setColor(250,220,180);
				draws.append(draw);
			break;
			
			default:
				print("lol");
		}
		
		draw = null;
		
		foreach(v in draws) {
			v.font = "FONT_OLD_10_WHITE_HI.TGA";
			v.visible = true;

			if (draw == null)
				draw = v.width;
			else if (draw < v.width)
				draw = v.width;
		}
		
		texture.setSize(draw + 200, draws[draws.len() - 1].getPosition().y + draws[draws.len() - 1].height + 200);
		texture.visible = true;
		
		title.text = item.name;
		title.setPosition(texture.getPosition().x + texture.getSize().width / 2 - title.width / 2, texture.getPosition().y + 100);
		title.visible = true;
		
		visible = true;
	}
	
	function top()
	{
		texture.top();
		foreach(v in draws)
			v.top();
			
		title.top();
	}
	
	function hide()
	{
		foreach(v in draws) {
			v.visible = false;
		}
		
		draws.clear();
		
		texture.visible = false;
		visible = false;
		title.visible = false;
	}
	
	function render()
	{
		if (isCursorVisible() == true && visible == true) {
			texture.setPosition(getCursorPosition().x, getCursorPosition().y);
			texture.top();
			
			foreach(i, v in draws) {
				v.setPosition(getCursorPosition().x + 100, getCursorPosition().y + 400 + i * 200);
				v.top();
			}
			
			title.setPosition(texture.getPosition().x + texture.getSize().width / 2 - title.width / 2, texture.getPosition().y + 100);
			title.top();
		}
	}
	
	function isVisible()
	{
		return visible;
	}
	
	texture = null;
	title = null;
	item_texture = null;
	draws = null;
	
	visible = null;
}

class npc_tradeGUI extends information_box
{
	constructor(_params)
	{
		frame = Texture(1000, 850, 6192, 6350, "MENU_INGAME.TGA");
		frame.visible = false;
		
		square = {};
		square.x <- frame.getPosition().x + 500;
		square.y <- frame.getPosition().y + 600;
		square.x1 <- square.x + frame.getSize().width - 1000;
		square.y1 <- square.y + frame.getSize().height - 1700;
		square.texture <- Texture(square.x, square.y, square.x1 - square.x, square.y1 - square.y, "MENU_INGAME.TGA");
		square.texture.visible = false;
		
		slider = questslider(square.x1 + 25, square.y - 500, square.y1 - square.y + 1000, 0, 0, 0, 0);
		
		params = _params;
		
		lid_1 = Texture(square.x, square.y - 375, square.x1 - square.x, 525, "LOG_PAPER.TGA");
		lid_2 = Texture(square.x, square.y1 - 125, square.x1 - square.x, 550, "LOG_PAPER.TGA");
		
		trade_title = Draw(0,0,"Trading with shopkeeper");
		trade_title.font = "FONT_OLD_20_WHITE_HI.TGA";
		trade_title.setColor(250, 220, 0);
		trade_title.setPosition(lid_1.getPosition().x + lid_1.getSize().width / 2 - trade_title.width / 2, lid_1.getPosition().y + lid_1.getSize().height / 2 - trade_title.height / 2);
		trade_title.visible = false;
		
		nav_menu = menu({ x = square.x + (square.x1 - square.x) / 2 - 1500 / 2, y = lid_2.getPosition().y + lid_2.getSize().height + 100, width = 1500, height = 300, align = align.none, texture = ""});
		
		buy_btn = nav_menu.add({
			x = 0,
			y = 0,
			width = 600,
			height = 300,
			text = "Buy",
			texture = "MENU_CHOICE_BACK.TGA"
		}, "INV_TITEL.TGA");
		
		close_btn = nav_menu.add({
			x = 900,
			y = 0,
			width = 600,
			height = 300,
			text = "Close",
			texture = "MENU_CHOICE_BACK.TGA"
		}, "INV_TITEL.TGA");
		
		ygold_draw = Draw(0,0,"Your gold: ");
		ygold_draw.font = "FONT_OLD_10_WHITE_HI.TGA";
		ygold_draw.setColor(255,255,255);
		ygold_draw.visible = false;
		
		ygoldamount_draw = Draw(0,0,"-1");
		ygoldamount_draw.font = "FONT_OLD_10_WHITE_HI.TGA";
		ygoldamount_draw.setColor(255,255,0);
		ygoldamount_draw.visible = false;
		
		base.constructor();
	}
	
	function show()
	{
		frame.visible = true;
		square.texture.visible = true;
		
		foreach(i, v in params) {
			local option = { draw = null, texture = null, gold_draw = null,  item_texture = null, id = i };
			
			local texture = Texture(1200, 0, 5292, 500, "INV_SLOT.TGA");
			texture.setPosition(square.x + 100, square.y + i * 550 + 100);
			texture.setSize(square.x1 - square.x - 200, 500);
			texture.visible = true;
			option.texture = texture;
			
			local item_texture = Texture(0,0, 400, 400, returnItem(v.inst).texture);
			item_texture.setPosition(square.x + 200, square.y + i * 550 + 150);
			item_texture.visible = true;
			option.item_texture <- item_texture;
			
			local draw = Draw(0,0, "");
			draw.font = "FONT_OLD_10_WHITE_HI.TGA";
			draw.text = returnItem(v.inst).name;
			draw.setColor(255,255,255);
			draw.setPosition(texture.getPosition().x + 600, texture.getPosition().y + texture.getSize().height / 2 - draw.height / 2);
			draw.visible = true;
			option.draw = draw;
			
			local gold_draw = Draw(0,0,"");
			gold_draw.font = "FONT_OLD_10_WHITE_HI.TGA";
			gold_draw.text = "(" + v.price + " gold)";
			gold_draw.setPosition(draw.getPosition().x + draw.width + 100, draw.getPosition().y);
			gold_draw.setColor(255,255,0);
			gold_draw.visible = true;
			option.gold_draw = gold_draw;
			
			option.price <- v.price;
			option.instance <- v.inst;
			
			options.append(option);
		}
		
		slider.show();
		updateVisibility();
		lid_1.visible = true;
		lid_2.visible = true;
		trade_title.visible = true;
		nav_menu.show();
		updateGoldDraws();
	}
	
	function hide()
	{
		frame.visible = false;
		square.texture.visible = false;
		
		foreach(v in options) {
			v.draw.visible = false;
			v.texture.visible = false;
			v.gold_draw.visible = false;
			v.item_texture.visible = false;
		}
		
		options.clear();
		slider.hide();
		
		if (base.isVisible() == true)
			base.hide();
		
		lid_1.visible = false;
		lid_2.visible = false;
		trade_title.visible = false;
		nav_menu.hide();
		ygold_draw.visible = false;
		ygoldamount_draw.visible = false;
		selected = null;
	}
	
	function updateGoldDraws()
	{
		if (ygoldamount_draw.text != player.gold.tostring()) {
			ygoldamount_draw.text = player.gold;
			ygold_draw.setPosition(lid_2.getPosition().x + lid_2.getSize().width / 2 - (ygold_draw.width + ygoldamount_draw.width) / 2,
				lid_2.getPosition().y + lid_2.getSize().height / 2 - ((ygold_draw.height + ygoldamount_draw.height) / 2) / 2);
			ygoldamount_draw.setPosition(ygold_draw.getPosition().x + ygold_draw.width, ygold_draw.getPosition().y);
		}
		
		if (ygold_draw.visible == false)
			ygold_draw.visible = true;
		if (ygoldamount_draw.visible == false)
			ygoldamount_draw.visible = true;
	}
	
	function onWheel(key)
	{
		if (key == -1)
			slider.slide(50);
		else if (key == 1)
			slider.slide(-50);
	}
	
	function inRect(x,y,x1,y1)
	{
		local pos = getCursorPosition();
		
		if (pos.x >= x && pos.y >= y && pos.x <= x1 && pos.y <= y1) {
			return true;
		}
		
		return false;
	}
	
	function updateVisibility()
	{
		foreach(v in options) {
			if (v.texture.getPosition().y + v.texture.getSize().height - 150 < square.y || v.texture.getPosition().y > square.y1 - 100) {
				v.texture.visible = false;
				v.item_texture.visible = false;
				v.draw.visible = false;
				v.gold_draw.visible = false;
			} else {
				if (v.texture.visible == false)
					v.texture.visible = true;
				if (v.item_texture.visible == false)
					v.item_texture.visible = true;
				if (v.draw.visible == false)
					v.draw.visible = true;
				if (v.gold_draw.visible == false)
					v.gold_draw.visible = true;
			}
		}
		lid_1.top();
		lid_2.top();
		trade_title.top();
		ygold_draw.top();
		ygoldamount_draw.top();
		
		if (base.isVisible() == true)
			base.top();
	}
	
	function onRender()
	{
		base.render();
		
		if (slider != null)
			slider.onRender();
		
		foreach(i, v in options) {
			v.texture.setPosition(v.texture.getPosition().x, slider.getSliderPos() + 150 + i * 550 - slider.getDistance() * 5.5 + 500);
			v.item_texture.setPosition(v.item_texture.getPosition().x, v.texture.getPosition().y + 50);
			v.draw.setPosition(v.draw.getPosition().x, v.texture.getPosition().y + v.texture.getSize().height / 2 - v.draw.height / 2);
			v.gold_draw.setPosition(v.gold_draw.getPosition().x, v.texture.getPosition().y + v.texture.getSize().height / 2 - v.gold_draw.height / 2);
		}
		
		updateVisibility();
		updateGoldDraws();
		
		/////////////////////////
		
		foreach(v in options) {
			if (inRect(v.texture.getPosition().x, v.texture.getPosition().y,
				v.texture.getPosition().x + v.texture.getSize().width,
				v.texture.getPosition().y + v.texture.getSize().height) == true) {
				
				if (focused != v && v.texture.visible == true) {
					if (focused != null) {
						onUnfocus(focused);
					}
					
					onFocus(v);
					return;
				}
				
				return;
			}
		}
		
		if (focused != null)
			onUnfocus(focused);
	}
	
	function onFocus(slot)
	{
		focused = slot;
		slot.texture.file = "INV_SLOT_HIGHLIGHTED.TGA";
		base.show(params[slot.id]);
	}
	
	function onUnfocus(slot)
	{
		if (slot != selected) {
			focused.texture.file = "INV_SLOT.TGA";
			focused = null;
		} else {
			focused.texture.file = "INV_SLOT_HIGHLIGHTED.TGA";
		}
		
		base.hide();
	}
	
	function onClick(key)
	{
		if (slider != null)
			slider.onClick(key);
		
		foreach(v in options) {
			if (inRect(v.texture.getPosition().x, v.texture.getPosition().y,
				v.texture.getPosition().x + v.texture.getSize().width,
				v.texture.getPosition().y + v.texture.getSize().height) == true) {
				
				if (selected != v && v.texture.visible == true) {
					if (selected != null) {
						onUnselect(selected);
					}
					
					onSelect(v);
					return;
				}
				
				if (selected == v)
					return onUnselect(selected);
			}
		}
		
		if (selected != null) {
			if (!(inRect(nav_menu.getConfig().x, nav_menu.getConfig().y, nav_menu.getConfig().x + nav_menu.getConfig().width, nav_menu.getConfig().y + nav_menu.getConfig().height) ||
					inRect(slider.getPosition().x, slider.getPosition().y, slider.getPosition().x + slider.getSize().width, slider.getPosition().y + slider.getSize().height)))
			onUnselect(selected);
		}
	}
	
	function onSelect(slot)
	{
		selected = slot;
	}
	
	function onUnselect(slot)
	{
		if (selected != focused)
			selected.texture.file = "INV_SLOT.TGA";
		else
			selected.texture.file = "INV_SLOT_HIGHLIGHTED.TGA";
		
		selected = null;
	}
	
	function onRelease(key)
	{
		if (slider != null)
			slider.onRelease(key);
	}
	
	function getBuyButton()
	{
		return buy_btn;
	}
	
	function getCloseButton()
	{
		return close_btn;
	}
	
	function getSelected()
	{
		return selected;
	}
	
	function navMenu()
	{
		return nav_menu;
	}
	
	options = [];
	frame = null;
	params = null;
	slider = null;
	square = null;
	focused = null;
	selected = null;
	lid_1 = null;
	lid_2 = null;
	trade_title = null;
	ygold_draw = null;
	ygoldamount_draw = null;
	
	nav_menu = null;
	buy_btn = null;
	close_btn = null;
}