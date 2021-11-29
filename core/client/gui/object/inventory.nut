enum eq {
	armor = 1,
	melee = 2,
	ranged = 3,
	magic = 4,
	meal = 5,
	other = 6,
	none = 7,
	
	GIVE_ITEM = 8721,
	EQUIP_ITEM = 8722
}

class inventoryGUI
{
	constructor()
	{
		frame = Texture(1000, 800, 6192, 6592, "MENU_INGAME.TGA");
		frame.visible = false;
		
		rect = { x = 1200, y = 1500, w = 5700, h = 1750 };
		
		items_frame = Texture(rect.x, rect.y, rect.w, rect.h, "MENU_INGAME.TGA");
		items_frame.visible = false;
		
		lid_1 = Texture(rect.x, rect.y - 475, rect.w, 500, "LOG_PAPER.TGA");
		lid_1.visible = false;
		
		lid_2 = Texture(rect.x, rect.y + rect.h  - 10, rect.w, 525, "LOG_PAPER.TGA");
		lid_2.visible = false;
		
		title = Draw(0, 0, "Inventory");
		title.font = "FONT_OLD_20_WHITE_HI.TGA";
		title.setColor(250,220,0);
		title.setPosition(lid_1.getPosition().x + lid_1.getSize().width / 2 - title.width / 2, lid_1.getPosition().y + lid_1.getSize().height / 2 - title.height / 2);
		title.visible = false;
		
		_slider = questslider(rect.x + rect.w, lid_1.getPosition().y, lid_1.getSize().height + lid_2.getSize().height + items_frame.getSize().height, 0, 0, 0, 0);
		
		slots = [];
		visible_lines = [];
		
		createSlots(60);
		
		item_frame = Texture(rect.x, lid_2.getPosition().y + lid_2.getSize().height + 100, rect.w, 2900, "MENU_INGAME.TGA");
		item_frame.visible = false;
		
		item_title = Draw(0,0,"ITEM_NAME");
		item_title.font = "FONT_OLD_20_WHITE_HI.TGA";
		item_title.setColor(255,255,255);
		item_title.setPosition(item_frame.getPosition().x + item_frame.getSize().width / 2 - item_title.width / 2, item_frame.getPosition().y + 200);
		item_title.visible = false;
		
		item_frame_tex = Texture(item_frame.getPosition().x + item_frame.getSize().width / 2 - 1000 / 2,
			item_frame.getPosition().y + item_frame.getSize().height / 2 - 1000 / 2, 1000, 1000, "MENU_CHOICE_BACK.TGA");
		item_frame_tex.visible = false;
		
		item_stat1 = Draw(item_frame.getPosition().x + 200, item_frame.getPosition().y + item_frame.getSize().height / 2, "ITEM STAT1");
		item_stat1.font = "FONT_OLD_10_WHITE_HI.TGA";
		item_stat1.setColor(255,255,255);
		item_stat1.visible = false;
		
		item_stat2 = Draw(item_frame.getPosition().x + 200, item_stat1.getPosition().y + item_stat1.height + 100, "ITEM STAT2");
		item_stat2.font = "FONT_OLD_10_WHITE_HI.TGA";
		item_stat2.setColor(255,255,255);
		item_stat2.visible = false;
		
		item_stat3 = Draw(item_frame.getPosition().x + 200, item_stat2.getPosition().y + item_stat2.height + 100, "ITEM STAT3");
		item_stat3.font = "FONT_OLD_10_WHITE_HI.TGA";
		item_stat3.setColor(255,255,255);
		item_stat3.visible = false;
		
		item_desc1 = Draw(0, 0, "(ITEM DESCRIPTION 1)");
		item_desc1.font = "FONT_OLD_10_WHITE_HI.TGA";
		item_desc1.setColor(255,255,255);
		item_desc1.setPosition(item_frame.getPosition().x + item_frame.getSize().width / 2 - item_desc1.width / 2, item_stat3.getPosition().y + item_stat3.height + 200);
		item_desc1.visible = false;
		
		item_desc2 = Draw(0, 0, "(ITEM DESCRIPTION 2)");
		item_desc2.font = "FONT_OLD_10_WHITE_HI.TGA";
		item_desc2.setColor(255,255,255);
		item_desc2.setPosition(item_frame.getPosition().x + item_frame.getSize().width / 2 - item_desc1.width / 2, item_desc1.getPosition().y + item_desc1.height + 50);
		item_desc2.visible = false;
		
		nav_menu = menu({ x = 2800, y = item_frame.getPosition().y + item_frame.getSize().height + 100, width = 2600, height = 300, align = align.none, texture = ""});
		
		use_button = nav_menu.add({
			x = 0,
			y = 0,
			width = 600,
			height = 300,
			text = "Use",
			texture = "MENU_CHOICE_BACK.TGA"
		}, "INV_TITEL.TGA");
		
		throw_button = nav_menu.add({
			x = 800,
			y = 0,
			width = 1000,
			height = 300,
			text = "Throw away",
			texture = "MENU_CHOICE_BACK.TGA"
		}, "INV_TITEL.TGA");
		
		exit_button = nav_menu.add({
			x = 2000,
			y = 0,
			width = 600,
			height = 300,
			text = "Close",
			texture = "MENU_CHOICE_BACK.TGA"
		}, "INV_TITEL.TGA");
		
		gold_draw = Draw(0,0,"Gold: ");
		gold_draw.font = "FONT_OLD_10_WHITE_HI.TGA";
		gold_draw.setColor(255,255,255);
		gold_draw.visible = false;
		
		goldamount_draw = Draw(0,0,"-1");
		goldamount_draw.font = "FONT_OLD_10_WHITE_HI.TGA";
		goldamount_draw.setColor(255,255,0);
		goldamount_draw.visible = false;
	}
	
	function updateGoldDraws()
	{
		if (goldamount_draw.text != player.gold.tostring()) {
			goldamount_draw.text = player.gold;
			gold_draw.setPosition(lid_2.getPosition().x + lid_2.getSize().width / 2 - (gold_draw.width + goldamount_draw.width) / 2,
				lid_2.getPosition().y + lid_2.getSize().height / 2 - ((gold_draw.height + goldamount_draw.height) / 2) / 2);
			goldamount_draw.setPosition(gold_draw.getPosition().x + gold_draw.width, gold_draw.getPosition().y);
		}
		
		if (gold_draw.visible == false)
			gold_draw.visible = true;
		if (goldamount_draw.visible == false)
			goldamount_draw.visible = true;
	}
	
	function show()
	{
		frame.visible = true;
		items_frame.visible = true;
		_slider.show();
		
		foreach(v in slots) {
			v.texture.visible = true;
			v.visible = true;
			v.item_texture.visible = true;
		}
			
		updatePosition();
		
		lid_1.visible = true;
		lid_2.visible = true;
		title.visible = true;
		item_frame.visible = true;
		item_title.visible = true;
		
		nav_menu.show();
		updateGoldDraws();
	}
	
	function hide()
	{
		frame.visible = false;
		items_frame.visible = false;
		_slider.hide();
		
		foreach(v in slots) {
			v.texture.visible = false;
			v.visible = false;
			v.item_texture.visible = false;
			v.amount_draw.visible = false;
		}
			
		lid_1.visible = false;
		lid_2.visible = false;
		title.visible = false;
		item_frame.visible = false;
		item_title.visible = false;
		item_frame_tex.visible = false;
		item_stat1.visible = false;
		item_stat2.visible = false;
		item_stat3.visible = false;
		item_desc1.visible = false;
		item_desc2.visible = false;
		gold_draw.visible = false;
		goldamount_draw.visible = false;
		
		nav_menu.hide();
		last_high = null;
		item_highlight = null;
		
		if (highlighted != null)
			onUnhighlight(highlighted);
		
		if (selected != null)
			onUnselect(selected);
	}
	
	function createSlots(number)
	{
		local line = 1;
		local in_line = 0;
		
		for(local i = 1; i <= 60; ++i) {
			if (i > 10 * line) {
				line++;
				in_line = 0;
			}
			
			local params = {};
			params.line <- line - 1;
			params.slot <- i - 1;
			params.texture <- Texture(rect.x + 100 + in_line * 550, rect.y + 100 + 550 * (line - 1), 500, 500, "INV_SLOT.TGA");
			params.item_params <- {type = eq.none};
			params.free <- true;
			params.visible <- false;
			params.item_id <- -1;
			params.amount <- -1;
			params.item_texture <- Texture(params.texture.getPosition().x + params.texture.getSize().width / 2 - 400 / 2,
									params.texture.getPosition().y + params.texture.getSize().height / 2 - 400 / 2, 400, 400, "");
			params.amount_draw <- Draw(0,0,"-1");
			params.amount_draw.font = "FONT_OLD_10_WHITE_HI.TGA";
			params.amount_draw.setColor(255,255,255);
			params.amount_draw.visible = false;
			
			slots.append(params);
			
			in_line++;
		}
	}
	
	function addToSlot(islot, params)
	{
		if (islot != false) {
			local slot = slots[slots.find(islot)];
			
			slot.item_texture.file = params.texture;
			slot.item_params = params;
			slot.item_id = params.item_id;
			slot.amount = params.amount;
			slot.free = false;
		}
	}
	
	function swapItems(item1, item2)
	{
		local index1 = slots.find(item1);
		local index2 = slots.find(item2);
		
		local free = {};
		free.item_texture <- item1.item_texture.file;
		free.item_id <- item1.item_id;
		free.amount <- item1.amount;
		free.free <- item1.free;
		free.item_params <- item1.item_params;
		free.texture <- item1.texture.file;
		
		slots[index1].item_texture.file = item2.item_texture.file;
		slots[index1].item_id = item2.item_id;
		slots[index1].amount = item2.amount;
		slots[index1].free = item2.free;
		slots[index1].item_params = item2.item_params;
		slots[index1].texture.file = item2.texture.file;
		
		slots[index2].item_texture.file = free.item_texture;
		slots[index2].item_id = free.item_id;
		slots[index2].amount = free.amount;
		slots[index2].free = free.free;
		slots[index2].item_params = free.item_params;
		slots[index2].texture.file = free.texture;
		
		if (getArmor() == slots[index1])
			setArmor(slots[index2]);
		else if (getMelee() == slots[index1])
			setMelee(slots[index2]);
		else if (getRanged() == slots[index1])
			setRanged(slots[index2]);
		else if (getArmor() == slots[index2])
			setArmor(slots[index1]);
		else if (getMelee() == slots[index2])
			setMelee(slots[index1]);
		else if (getRanged() == slots[index2])
			setRanged(slots[index1]);
	}
	
	function removeItem(slot)
	{
		foreach(v in slots) {
			if (v.item_id == slot.item_id) {
				slot.item_texture.file = "";
				slot.item_params = {type = eq.none};
				slot.item_id = -1;
				slot.amount = -1;
				slot.free = true;
				
				if (selected != null)
					return updateItemFrame(selected);
				
				if (highlighted != null)
					return updateItemFrame(highlighted);
			}
		}
	}
	
	function increaseAmount(slot, item_amount)
	{
		foreach(v in slots) {
			if (v.item_id == slot.item_id) {
				v.amount = v.amount + item_amount;
				
				if ((highlighted || selected) == v)
					updateItemTitle(v.item_params.name + " (x" + v.amount + ")");
				
				return true;
			}
		}
		
		return false;
	}
	
	function decreaseAmount(slot, item_amount) {
		foreach(v in slots) {
			if (v.item_id == slot.item_id) {
				v.amount = v.amount - item_amount;
				
				if (v.amount <= 0)
					return removeItem(slot);
				
				if ((highlighted || selected) == v)
					updateItemTitle(v.item_params.name + " (x" + v.amount + ")");
				
				return true;
			}
		}
		
		return false;
	}
	
	function updateItemTitle(text)
	{
		item_title.text = text;
		item_title.setPosition(item_frame.getPosition().x + item_frame.getSize().width / 2 - item_title.width / 2, item_title.getPosition().y);
	}
	
	function hideLine(linen)
	{
		foreach(v in slots) {
			if (v.line == linen) {
				if (v.visible == true) {
					v.texture.visible = false;
					v.item_texture.visible = false;
					v.visible = false;
					v.amount_draw.visible = false;
				}
			}
		}
	}
	
	function showLine(linen)
	{
		foreach(v in slots) {
			if (v.line == linen) {
				if (v.visible == false) {
					v.texture.visible = true;
					v.item_texture.visible = true;
					v.visible = true;
					v.amount_draw.visible = true;
				}
			}
		}
	}
	
	function updatePosition()
	{
		foreach(v in slots) {
			v.texture.setPosition(v.texture.getPosition().x, _slider.getSliderPos() + v.line * 550 + (lid_1.getSize().height + 75) - _slider.getDistance() * 1.70);
			v.item_texture.setPosition(v.texture.getPosition().x + v.texture.getSize().width / 2 - v.item_texture.getSize().width / 2,
									v.texture.getPosition().y + v.texture.getSize().height / 2 - v.item_texture.getSize().height / 2);
			if(v.item_params.type == (eq.meal || eq.other)) {
				if (v.amount_draw.text != v.amount.tostring())
					v.amount_draw.text = v.amount;
				
				v.amount_draw.setPosition(v.texture.getPosition().x + v.texture.getSize().width - v.amount_draw.width - 25,
					v.texture.getPosition().y + v.texture.getSize().height - v.amount_draw.height - 25);
					
				if (v.amount_draw.visible == false) {
					if (v.amount >= 1 && v.visible == true)
						v.amount_draw.visible = true;
				} else {
					if (v.amount <= 1)
						v.amount_draw.visible = false;
				}
			} else {
				if (v.amount_draw.visible == true)
					v.amount_draw.visible = false;
			}
			
			if (v.texture.getPosition().y + v.texture.getSize().height - 50 <= rect.y || v.texture.getPosition().y >= rect.y + rect.h)
				hideLine(v.line);
			else
				showLine(v.line);
		}
		
		lid_1.top();
		lid_2.top();
		title.top();
		gold_draw.top();
		goldamount_draw.top();
	}
	
	function inRect(x,y,x1,y1)
	{
		local pos = getCursorPosition();
		
		if (pos.x >= x && pos.y >= y && pos.x <= x1 && pos.y <= y1) {
			return true;
		}
		
		return false;
	}
	
	function onHighlight(slot)
	{
		if (slot.visible == true) {
			highlighted = slot;
			
			if (isEquipped(slot)) {
				slot.texture.file = "INV_SLOT_EQUIPPED_HIGHLIGHTED.TGA";
			} else {
				slot.texture.file = "INV_SLOT_HIGHLIGHTED.TGA";
			}
			
			last_high = slot;
		}
	}
	
	function onUnhighlight(slot)
	{
		if (isEquipped(slot)) {
			if (selected != null) {
				if (selected.item_id == slot.item_id)
					slot.texture.file = "INV_SLOT_EQUIPPED_HIGHLIGHTED.TGA";
				else
					slot.texture.file = "INV_SLOT_EQUIPPED.TGA";
			} else {
				slot.texture.file = "INV_SLOT_EQUIPPED.TGA";
			}
		} else {
			if (selected != null) {
				if (selected.item_id == slot.item_id && slot.amount >= 1)
					slot.texture.file = "INV_SLOT_HIGHLIGHTED.TGA";
				else
					slot.texture.file = "INV_SLOT.TGA";	
			}
			else
				slot.texture.file = "INV_SLOT.TGA";
		}
		
		last_high = slot;
		highlighted = null;
	}
	
	function onEquip(slot)
	{
		if (selected != null) {
			if (slot.item_id == selected.item_id) {
				slot.texture.file = "INV_SLOT_EQUIPPED_HIGHLIGHTED.TGA";
			}
		}
	}
	
	function onUnequip(slot)
	{
		if (selected != null) {
			if (slot.item_id == selected.item_id) {
				slot.texture.file = "INV_SLOT_HIGHLIGHTED.TGA";
				
				return;
			}
		}
		
		slot.texture.file = "INV_SLOT.TGA";
	}
	
	function onSelect(slot)
	{
		if (slot.visible == true) {
			selected = slot;
			
			if (isEquipped(slot)) {
				slot.texture.file = "INV_SLOT_EQUIPPED_HIGHLIGHTED.TGA";
			} else {
				slot.texture.file = "INV_SLOT_HIGHLIGHTED.TGA";
			}
		}
	}
	
	function onUnselect(slot)
	{
		if (isEquipped(slot)) {
			if (slot == highlighted) {
				slot.texture.file = "INV_SLOT_EQUIPPED_HIGHLIGHTED.TGA";
			} else {
				slot.texture.file = "INV_SLOT_EQUIPPED.TGA";
			}
		} else {
			if (slot == highlighted) {
				slot.texture.file = "INV_SLOT_HIGHLIGHTED.TGA";
			} else {
				slot.texture.file = "INV_SLOT.TGA";
			}
		}
		
		selected = null;
	}
	
	function highlightingRender()
	{
		foreach(v in slots) {
			if (inRect(v.texture.getPosition().x, v.texture.getPosition().y,
				v.texture.getPosition().x + v.texture.getSize().width,
				v.texture.getPosition().y + v.texture.getSize().height) == true) {
				
				if (highlighted == null)
					onHighlight(v);
				else {
					onUnhighlight(highlighted);
					onHighlight(v);
				}
				
				return;
			}
		}
		
		if (highlighted != null)
			onUnhighlight(highlighted);
	}
	
	function hideElements(...)
	{
		foreach(v in vargv) {
			if (v.visible == true)
				v.visible = false;
		}
	}
	
	function showElements(...)
	{
		foreach(v in vargv) {
			if (v.visible == false)
				v.visible = true;
		}
	}
	
	function updateItemFrame(slot)
	{
		if (inventory.opened == true) {
			if (slot.item_params.type != eq.none) {
				showElements(item_desc1, item_desc2, item_stat1, item_stat2, item_stat3, item_frame_tex);
				item_title.text = slot.item_params.name;
				item_title.setPosition(item_frame.getPosition().x + item_frame.getSize().width / 2 - item_title.width / 2, 
					item_frame.getPosition().y + 200);
				item_frame_tex.file = slot.item_params.texture;
				
				item_desc1.text = slot.item_params.desc1;
				item_desc2.text = slot.item_params.desc2;
				
				item_desc1.setPosition(item_frame.getPosition().x + item_frame.getSize().width / 2 - item_desc1.width / 2, item_desc1.getPosition().y);
				item_desc2.setPosition(item_frame.getPosition().x + item_frame.getSize().width / 2 - item_desc2.width / 2, item_desc2.getPosition().y);
						
				switch(slot.item_params.type) {	
					case eq.armor:
						item_stat1.text = "Level: " + slot.item_params.level;
						item_stat2.text = "Defence: " + slot.item_params.defence;
						item_stat3.text = "Evasion: " + slot.item_params.evasion;
					break;
					
					case (eq.melee || eq.ranged || eq.magic):
						item_stat1.text = "Level: " + slot.item_params.level;
						item_stat2.text = "Attack: " + slot.item_params.attack;
						item_stat3.text = "Hit rate: " + slot.item_params.hitrate;
					break;
					
					case (eq.melee || eq.ranged || eq.magic):
						item_stat1.text = "Level: " + slot.item_params.level;
						item_stat2.text = "Attack: " + slot.item_params.attack;
						item_stat3.text = "Hit rate: " + slot.item_params.hitrate;
					break;
					
					case (eq.meal || eq.other):
						updateItemTitle(slot.item_params.name + " (x" + slot.amount + ")");
						hideElements(item_stat1, item_stat2, item_stat3);
					break;
				}
			} else {
				hideElements(item_desc1, item_desc2, item_stat1, item_stat2, item_stat3, item_frame_tex);
				item_title.text = "Slot empty";
				item_title.setPosition(item_frame.getPosition().x + item_frame.getSize().width / 2 - item_title.width / 2,
					item_frame.getPosition().y + item_frame.getSize().height / 2 - item_title.height / 2);
			}
		}
	}
	
	function itemFrameRender()
	{
		local slot = null;
		
		if (highlighted != null)
			slot = highlighted;
		
		if (selected != null || highlighted == (selected || null))
			slot = selected;
		
		if (selected == null && highlighted == null) {
			if (last_high != null)
				slot = last_high;
			else {
				hideElements(item_desc1, item_desc2, item_stat1, item_stat2, item_stat3, item_frame_tex);
				item_title.text = "Slot empty";
				item_title.setPosition(item_frame.getPosition().x + item_frame.getSize().width / 2 - item_title.width / 2,
					item_frame.getPosition().y + item_frame.getSize().height / 2 - item_title.height / 2);
					
				return;
			}
		}
		
		if (slot != item_highlight) {
			item_highlight = slot;
			last_high = slot;
			
			updateItemFrame(slot);
		}
	}
	
	function onRender()
	{
		_slider.onRender();
		
		updatePosition();
		
		highlightingRender();
		itemFrameRender();
		updateGoldDraws();
	}
	
	function onClick(btn)
	{
		_slider.onClick(btn);
		
		foreach(v in slots) {
			if (inRect(v.texture.getPosition().x, v.texture.getPosition().y,
				v.texture.getPosition().x + v.texture.getSize().width,
				v.texture.getPosition().y + v.texture.getSize().height) == true) {
				
				if (selected != null) {
					if (selected == v)
						onUnselect(selected);
					else {
						onUnselect(selected);
						onSelect(v);
					}
				} else {
					onSelect(v);
				}
				
				return;
			}
		}
		
		if (selected != null) {
			if (!(inRect(nav_menu.getConfig().x, nav_menu.getConfig().y, nav_menu.getConfig().x + nav_menu.getConfig().width, nav_menu.getConfig().y + nav_menu.getConfig().height) == true || 
					inRect(_slider.getPosition().x, _slider.getPosition().y, _slider.getPosition().x + _slider.getSize().width, _slider.getPosition().y + _slider.getSize().height) == true)) {
				onUnselect(selected);
			}
		}
	}
	
	function onRelease(btn)
	{
		_slider.onRelease(btn);
	}
	
	function slide(val)
	{
		_slider.slide(val);
	}
	
	function changeUseText(text)
	{
		use_button.changeText(text);
	}
	
	function getFirstFreeSlot()
	{
		foreach(v in slots) {
			if (v.free == true)
				return v;
		}
		
		return false;
	}
	
	function sortItems()
	{
		if (selected != null)
			onUnselect(selected);
		if (highlighted != null)
			onUnhighlight(highlighted);
		
		local a = slots.len() - 1;
		
		do {
			for (local b = 0; b < a; ++b) {
				if (slots[b].item_params.type > slots[b + 1].item_params.type) {
					swapItems(slots[b], slots[b + 1]);
				}
			}
			
			a = a - 1;
		} while(a > 1)
			
		local a = slots.len() - 1;
		
		do {
			for (local b = 0; b < a; ++b) {
				if (slots[b + 1].item_params.type == eq.armor) {
					if (slots[b].item_params.type == eq.armor && slots[b].item_params.defence < slots[b + 1].item_params.defence) {
						swapItems(slots[b], slots[b + 1]);
					}
				}
			}
			
			a = a - 1;
		} while(a > 1)
			
		a = slots.len() - 1;
		
		do {
			for (local b = 0; b < a; ++b) {
				if (slots[b + 1].item_params.type == eq.melee) {
					if ((slots[b].item_params.type == eq.melee || slots[b].item_params.type == eq.ranged || slots[b].item_params.type == eq.magic) && slots[b].item_params.attack < slots[b + 1].item_params.attack) {				
						swapItems(slots[b], slots[b + 1]);				
					}
				}
			}
			
			a = a - 1;
		} while(a > 1)
	}
	
	function sortByUpgrade(type)
	{	
		if (selected != null)
			onUnselect(selected);
		if (highlighted != null)
			onUnhighlight(highlighted);
		
		local a = slots.len() - 1;
		
		do {
			for (local b = 0; b <a; ++b) {
				if (slots[b + 1].item_params.type == type) {
					if (slots[b].item_params.type == type && slots[b].item_params.upgrade < slots[b + 1].item_params.upgrade) {		
						swapItems(slots[b], slots[b + 1]);
					}
				}
			}
			
			a = a - 1;
		} while (a > 1);
	}
	
	function sortByAmount(type)
	{	
		if (selected != null)
			onUnselect(selected);
		if (highlighted != null)
			onUnhighlight(highlighted);
		
		local a = slots.len() - 1;
		
		do {
			for (local b = 0; b <a; ++b) {
				if (slots[b + 1].item_params.type == type) {
					if (slots[b].item_params.type == type && slots[b].amount < slots[b + 1].amount) {
						swapItems(slots[b], slots[b + 1]);					
					}
				}
			}
			
			a = a - 1;
		} while (a > 1);
	}
	
	function onUpgrade(s)
	{
		sortByUpgrade(s.item_params.type);
	}
	
	function getSelectedSlot()
	{
		return selected;
	}
	
	function getHighlightedSlot()
	{
		return highlighted;
	}
	
	function getSlots()
	{
		return slots;
	}
	
	function getUseButton()
	{
		return use_button;
	}
	
	function getThrowAwayButton()
	{
		return throw_button;
	}
	
	function getCloseButton()
	{
		return exit_button;
	}
	
	_slider = null;
	frame = null;
	items_frame = null;
	slots = null;
	rect = null;
	visible_lines = null;
	lid_1 = null;
	lid_2 = null;
	title = null;
	gold_draw = null;
	goldamount_draw = null;
	
	/////
	item_frame = null;
	item_title = null;
	item_stat1 = null;
	item_stat2 = null;
	item_stat3 = null;
	item_desc1 = null;
	item_desc2 = null;
	item_frame_tex = null;
	
	/////
	selected = null;
	highlighted = null;
	last_high = null;
	item_highlight = null;
	
	////
	nav_menu = null;
	use_button = null;
	throw_button = null;
	exit_button = null;
}