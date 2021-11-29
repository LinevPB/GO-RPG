const MEAL = 5;
const OTHER = 6;

class npc_Sale_GUI
{
	constructor()
	{
		elements = [];
		
		frame = Texture(1000, 850, 6192, 6350, "MENU_INGAME.TGA");
		frame.visible = false;
		
		square = {};
		square.x <- frame.getPosition().x + 500;
		square.y <- frame.getPosition().y + 600;
		square.x1 <- square.x + frame.getSize().width - 1000;
		square.y1 <- square.y + frame.getSize().height - 1700;
		square.texture <- Texture(square.x, square.y, square.x1 - square.x, square.y1 - square.y, "MENU_INGAME.TGA");
		square.texture.visible = false;
		
		_slider = questslider(square.x1 + 25, square.y - 500, square.y1 - square.y + 1000, 0, 0, 0, 0);
		
		lid_1 = Texture(square.x, square.y - 375, square.x1 - square.x, 525, "LOG_PAPER.TGA");
		lid_2 = Texture(square.x, square.y1 - 125, square.x1 - square.x, 550, "LOG_PAPER.TGA");
		
		sale_title = Draw(0,0,"Selling to shopkeeper");
		sale_title.font = "FONT_OLD_20_WHITE_HI.TGA";
		sale_title.setColor(250, 220, 0);
		sale_title.setPosition(lid_1.getPosition().x + lid_1.getSize().width / 2 - sale_title.width / 2, lid_1.getPosition().y + lid_1.getSize().height / 2 - sale_title.height / 2);
		sale_title.visible = false;
		
		nav_menu = menu({ x = square.x + (square.x1 - square.x) / 2 - 1500 / 2, y = lid_2.getPosition().y + lid_2.getSize().height + 100, width = 1500, height = 300, align = align.none, texture = ""});
		
		sell_btn = nav_menu.add({
			x = 0,
			y = 0,
			width = 600,
			height = 300,
			text = "Sell",
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
	}
	
	function show()
	{
		frame.visible = true;
		square.texture.visible = true;
		_slider.show();
		lid_1.visible = true;
		lid_2.visible = true;
		sale_title.visible = true;
		nav_menu.show();
		updateGoldDraws();
	}
	
	function hide()
	{
		frame.visible = false;
		square.texture.visible = false;
		_slider.hide();
		lid_1.visible = false;
		lid_2.visible = false;
		sale_title.visible = false;
		nav_menu.hide();
		ygold_draw.visible = false;
		ygoldamount_draw.visible = false;
		
		if (focused != null)
			onUnfocus(focused);
		if (selected != null)
			onUnselect(selected);
		
		////////////////
		foreach(v in elements) {
			v.texture.visible = false;
			v.item_texture.visible = false;
			v.gold_draw.visible = false;
			v.draw.visible = false;
			v.visible = false;
		}
		
		elements.clear();
	}
	
	function addElement(params)
	{
		local option = {};
		
		option.visible <- false;
		option.id <- params.id;
		option.inst <- params.inst;
		option.amount <- params.amount;
		option.price <- params.price;
		option.type <- returnItem(params.inst).type;
		
		local texture = Texture(1200, 0, 5292, 500, "INV_SLOT.TGA");
		texture.setPosition(square.x + 100, square.y + elements.len() * 550 + 100);
		texture.setSize(square.x1 - square.x - 200, 500);
		texture.visible = false;
		option.texture <- texture;
		
		local item_texture = Texture(0,0, 400, 400, returnItem(params.inst).texture);
		item_texture.setPosition(square.x + 200, square.y + elements.len() * 550 + 150);
		item_texture.visible = true;
		option.item_texture <- item_texture;
		
		local draw = Draw(0,0, "");
		draw.font = "FONT_OLD_10_WHITE_HI.TGA";
		if (option.type == (MEAL || OTHER) && option.amount > 1) 
			draw.text = returnItem(params.inst).name + " (x" + option.amount + ")";
		else
			draw.text = returnItem(params.inst).name;
		draw.setColor(255,255,255);
		draw.setPosition(texture.getPosition().x + 600, texture.getPosition().y + texture.getSize().height / 2 - draw.height / 2);
		draw.visible = false;
		option.draw <- draw;
		
		local gold_draw = Draw(0,0,"");
		gold_draw.font = "FONT_OLD_10_WHITE_HI.TGA";
		gold_draw.text = "(" + params.price + " gold)";
		gold_draw.setPosition(draw.getPosition().x + draw.width + 100, draw.getPosition().y);
		gold_draw.setColor(255,255,0);
		gold_draw.visible = true;
		option.gold_draw <- gold_draw;
		
		elements.append(option);
	}
	
	function removeElement(id)
	{
		foreach(i, v in elements) {
			if (v.id == id) {
				v.texture.visible = false;
				v.item_texture.visible = false;
				v.draw.visible = false;
				v.gold_draw.visible = false;
				v.visible = false;
				
				return elements.remove(i);
			}
		}
	}
	
	function onSell(id, amount)
	{
		foreach(i, v in elements) {
			if (v.id == id) {
				if (amount == true)
					return removeElement(id);
				
				v.amount = v.amount - amount;
				
				if (v.amount <= 0)
					return removeElement(id);
				
				if (v.type == (MEAL || OTHER) && v.amount > 1)
					v.draw.text = returnItem(v.inst).name + " (x" + v.amount + ")";
				else
					v.draw.text = returnItem(v.inst).name;
			}
		}
	}
	
	function addItems(items)
	{
		foreach(v in items) {
			addElement({ inst = v.inst, amount = v.amount, id = v.id, price = v.price });
		}	
		
		updateElements();
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
	
	function updateElements()
	{
		foreach(v in elements) {
			if (v.texture.getPosition().y + v.texture.getSize().height - 150 < square.y || v.texture.getPosition().y > square.y1 - 100) {
				v.texture.visible = false;
				v.item_texture.visible = false;
				v.draw.visible = false;
				v.gold_draw.visible = false;
				v.visible = false;
			} else {
				if (v.texture.visible == false)
					v.texture.visible = true;
				if (v.item_texture.visible == false)
					v.item_texture.visible = true;
				if (v.draw.visible == false)
					v.draw.visible = true;
				if (v.gold_draw.visible == false)
					v.gold_draw.visible = true;
				if (v.visible == false)
					v.visible = true;
			}
		}
		lid_1.top();
		lid_2.top();
		sale_title.top();
		ygold_draw.top();
		ygoldamount_draw.top();
	}
	
	function onRender()
	{
		_slider.onRender();
		
		foreach(i, v in elements) {
			v.texture.setPosition(v.texture.getPosition().x, _slider.getSliderPos() + 150 + i * 550 - _slider.getDistance() * 6.4 + 500);
			v.item_texture.setPosition(v.item_texture.getPosition().x, v.texture.getPosition().y + 50);
			v.draw.setPosition(v.draw.getPosition().x, v.texture.getPosition().y + v.texture.getSize().height / 2 - v.draw.height / 2);
			v.gold_draw.setPosition(v.draw.getPosition().x + v.draw.width + 100, v.texture.getPosition().y + v.texture.getSize().height / 2 - v.gold_draw.height / 2);
		}
		
		updateElements();
		updateGoldDraws();
		
		/////////////////////////
		
		foreach(v in elements) {
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
	}
	
	function onUnfocus(slot)
	{
		if (slot != selected) {
			focused.texture.file = "INV_SLOT.TGA";
			focused = null;
		} else {
			focused.texture.file = "INV_SLOT_HIGHLIGHTED.TGA";
		}
	}
	
	function onClick(key)
	{
		_slider.onClick(key);
		
		foreach(v in elements) {
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
					inRect(_slider.getPosition().x, _slider.getPosition().y, _slider.getPosition().x + _slider.getSize().width, _slider.getPosition().y + _slider.getSize().height)))
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
		_slider.onRelease(key);
	}
	
	function onWheel(key)
	{
		if (key == -1)
			_slider.slide(50);
		else if (key == 1)
			_slider.slide(-50);
	}
	
	function inRect(x,y,x1,y1)
	{
		local pos = getCursorPosition();
		
		if (pos.x >= x && pos.y >= y && pos.x <= x1 && pos.y <= y1) {
			return true;
		}
		
		return false;
	}
	
	function getSellButton()
	{
		return sell_btn;
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
	
	frame = null;
	square = null;
	_slider = null;
	elements = null;
	lid_1 = null;
	lid_2 = null;
	sale_title = null;
	nav_menu = null;
	sell_btn = null;
	close_btn = null;
	ygold_draw = null;
	ygoldamount_draw = null;
	focused = null;
	selected = null;
}