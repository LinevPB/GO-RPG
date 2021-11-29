class questGUI
{
	constructor()
	{
		frame = Texture(1500, 1500, 5192, 5192, "MENU_INGAME.TGA");
		frame.visible = false;
		
		quests_list = Texture(1700, 2150, 1800, 4000, "MENU_INGAME.TGA");
		quests_list.visible = false;
		
		quests_desc = Texture(3800, 2150, 2500, 4000, "MENU_INGAME.TGA");
		quests_desc.visible = false;
		
		l_slider = questslider(quests_list.getPosition().x + quests_list.getSize().width + 25, quests_list.getPosition().y, quests_list.getSize().height, 0, 0, 0, 0);
		d_slider = questslider(quests_desc.getPosition().x + quests_desc.getSize().width + 25, quests_desc.getPosition().y, quests_desc.getSize().height, 0, 0, 0, 0);
		
		q_title = Draw(0,0,"Quests");
		q_title.setColor(250,200,20);
		q_title.font = "FONT_OLD_20_WHITE_HI.TGA";
		q_title.setPosition(frame.getPosition().x + frame.getSize().width / 2 - q_title.width / 2, frame.getPosition().y + 150);
		
		ls.x = quests_list.getPosition().x;
		ls.y = quests_list.getPosition().y;
		ls.width = l_slider.getPosition().x + l_slider.getSize().width;
		ls.height = l_slider.getPosition().y + l_slider.getSize().height;
		
		rs.x = quests_desc.getPosition().x;
		rs.y = quests_desc.getPosition().y;
		rs.width = d_slider.getPosition().x + d_slider.getSize().width;
		rs.height = d_slider.getPosition().y + d_slider.getSize().height;
		
		nav_menu = menu({ x = 1500, y = 6200, width = 5192, height = 300, align = align.none, texture = ""});
		
		close_btn = nav_menu.add({
			x = (5192) / 2 - 600 / 2,
			y = 0,
			width = 600,
			height = 300,
			text = "Close",
			texture = "MENU_CHOICE_BACK.TGA"
		}, "INV_TITEL.TGA");
	}
	
	function show()
	{
		frame.visible = true;
		quests_list.visible = true;
		quests_desc.visible = true;
		l_slider.show();
		d_slider.show();
		q_title.visible = true;
		
		nav_menu.show();
		
		updateVisibility();
	}
	
	function updateVisibility()
	{
		local Y = quests_list.getPosition().y + quests_list.getSize().height;
		
		foreach(v in quest_draws) {
			if ((v.draw.getPosition().y + v.draw.height) <= Y - 100 && v.draw.getPosition().y >= (quests_list.getPosition().y + 100))
				v.draw.visible = true;
			else
				v.draw.visible = false;
		}
		
		if (selected != false) {
			Y = quests_desc.getPosition().y + quests_desc.getSize().height - 100;
			
			foreach (v in selected.desc_draw){
				if ((v.getPosition().y + v.height) <= Y && v.getPosition().y >= (quests_desc.getPosition().y + 100))
					v.visible = true;
				else
					v.visible = false;
			}
		}
	}
	
	function hide()
	{
		frame.visible = false;
		quests_list.visible = false;
		quests_desc.visible = false;
		l_slider.hide();
		d_slider.hide();
		q_title.visible = false;
		
		foreach(v in quest_draws)
		{
			v.draw.visible = false;
		}
		
		if (highlighted != false)
			onUnhighlight(highlighted);
		
		if (selected != false)
			unselect(selected);
		
		nav_menu.hide();
	}
	
	function onRender()
	{
		l_slider.onRender();
		d_slider.onRender();
		
		local hl = false;
		
		foreach(i, v in quest_draws) {
			v.draw.setPosition(v.draw.getPosition().x, l_slider.getSliderPos() + i * 200 - l_slider.getDistance() * 2 + 200);
			
			if (inRect(v.draw.getPosition().x - 40,
					v.draw.getPosition().y - 40,
					v.draw.getPosition().x + v.draw.width + 40,
					v.draw.getPosition().y + v.draw.height + 40) == true) {
						
				if (highlighted != v)
					hl = v;
				else
					hl = true;
			}
		}

		if (hl != false && hl != true) {
			if (highlighted != false)
				onUnhighlight(highlighted);
			
			onHighlight(hl);
		} else {
			if (highlighted != false && hl != true) {
				onUnhighlight(highlighted);
			}
		}
		
		if (selected != false) {
			foreach(i, v in selected.desc_draw) {
				v.setPosition(v.getPosition().x, 200 + d_slider.getSliderPos() + i * 150 - d_slider.getDistance() * 2);
				
				if(v == selected.progress_draw)
					v.setPosition(v.getPosition().x, v.getPosition().y + 250);
			}
		}
		
		updateVisibility();
	}
	
	function onKey(key)
	{
		
	}
	
	function onMouseClick(key)
	{
		l_slider.onClick(key);
		d_slider.onClick(key);
		
		if (key == MOUSE_LMB) {
			foreach(v in quest_draws) {
				if (inRect(v.draw.getPosition().x - 40,
							v.draw.getPosition().y - 40,
							v.draw.getPosition().x + v.draw.width + 40,
							v.draw.getPosition().y + v.draw.height + 40) == true) {
								
					if (selected != false && selected != v)
						unselect(selected);
					
					if (selected != v)
						select(v);
					else
						unselect(selected);
					
					return;
				}
			}
			
			if (selected != false) {
				if (!inRect(quests_desc.getPosition().x,
						quests_desc.getPosition().y,
						d_slider.getPosition().x + d_slider.getSize().width + (d_slider.getSliderWidth() - d_slider.getSize().width),
						quests_desc.getPosition().y + quests_desc.getSize().height)) {
					if (!inRect(l_slider.getPosition().x,
						l_slider.getPosition().y,
						l_slider.getPosition().x + l_slider.getSize().width + (l_slider.getSliderWidth() - l_slider.getSize().width),
						l_slider.getPosition().y + l_slider.getSize().height))
							unselect(selected);
				}
			}
		}
	}
	
	function onRelease(key)
	{
		l_slider.onRelease(key);
		d_slider.onRelease(key);
	}
	
	function inRect(x,y,x1,y1)
	{
		local pos = getCursorPosition();
		
		if (pos.x >= x && pos.y >= y && pos.x <= x1 && pos.y <= y1) {
			return true;
		}
		
		return false;
	}
	
	function onScroll(key)
	{
		if (inRect(ls.x,ls.y,ls.width,ls.height) == true) {
			switch(key) {
				case -1:
					l_slider.slide(50);
				break;
				
				case 1:
					l_slider.slide(-50);
				break;
			}
		}
		
		if (inRect(rs.x,rs.y,rs.width,rs.height) == true) {
			switch(key) {
				case -1:
					d_slider.slide(50);
				break;
				
				case 1:
					d_slider.slide(-50);
				break;
			}
		}
	}
	
	function resetPosition()
	{
		foreach(i, v in quest_draws) {
			v.draw.setPosition(quests_list.getPosition().x + 100, quests_list.getPosition().y + 150 + i * 200);
		}
		
		updateVisibility();
	}
	
	function addQuestDraw(params)
	{
		local quest = {};
		
		quest.quest <- params;
		quest.draw <- Draw(0,0,"");
		
		quest.draw.text = params.name;
		quest.draw.font = "FONT_OLD_10_WHITE_HI.TGA";
		quest.draw.setColor(255,255,255);
		
		if (quest_draws.len() == 0)
			quest.draw.setPosition(quests_list.getPosition().x + 100, quests_list.getPosition().y + 200);
		else
			quest.draw.setPosition(quests_list.getPosition().x + 100, quest_draws.top().draw.getPosition().y + 200);
		
		quest.temp_draw <- Draw(0,0,"");
		quest.temp_draw.text = params.desc;
		quest.temp_draw.font = "FONT_OLD_10_WHITE_HI.TGA";
		quest.temp_draw.setColor(255,255,255);
		quest.temp_draw.setPosition(quests_desc.getPosition().x + 100, quests_desc.getPosition().y + 100);
		
		quest.desc_draw <- [];
		
		//////////////////
		
		local times = 0;
		local text_part = "";
		
		do {
			if ((quest.temp_draw.width) > (quests_desc.getSize().width - 200)) {
				quest.temp_draw.text = quest.temp_draw.text.slice(0, quest.temp_draw.text.len() - 1);
			} else {
				local _draw = Draw(quests_desc.getPosition().x + 100, quests_desc.getPosition().y + 100 + times * 150, quest.temp_draw.text);
				quest.desc_draw.append(_draw);
				text_part = text_part + quest.temp_draw.text;
				
				if (text_part == params.desc)
					break;
				else {
					quest.temp_draw.text = params.desc.slice(text_part.len(), params.desc.len());
					times++;
				}
			}
		} while(true);
		
		/////////////////
		
		quest.progress_draw <- Draw(0,0,"");
		quest.progress_draw.text = "Progress 0%";
		quest.progress_draw.font = "FONT_OLD_10_WHITE_HI.TGA";
		quest.progress_draw.setColor(255,220,178);
		quest.progress_draw.setPosition(quests_desc.getPosition().x + 100, quests_desc.getPosition().y + 500 + times * 150);
		
		quest.desc_draw.append(quest.progress_draw);
		
		quest_draws.append(quest);
	}
	
	function resetListColors()
	{
		foreach ( v in quest_draws ) {
			v.draw.setColor(255,255,255);
		}
		
		if (selected != false)
			selected.draw.setColor(250,0,0);
	}
	
	function onHighlight(d)
	{
		resetListColors();
		
		if (d != selected)
			d.draw.setColor(255,255,0);
		
		highlighted = d;
		
		d.draw.setPosition(d.draw.getPosition().x + 50, d.draw.getPosition().y);
	}
	
	function onUnhighlight(d)
	{
		if (d != selected)
			d.draw.setColor(255,255,255);
		
		d.draw.setPosition(d.draw.getPosition().x - 50, d.draw.getPosition().y);
		
		highlighted = false;
	}
	
	function select(lq)
	{
		selected = lq;
		
		foreach(v in lq.desc_draw) {
			v.visible = true;
		}
		
		lq.draw.setColor(250,0,0);
	}
	
	function unselect(lq)
	{
		lq.draw.setColor(255,255,255);
		
		foreach(v in lq.desc_draw) {
			v.visible = false;
		}
		
		selected = false;
		
		if (lq == highlighted)
			lq.draw.setColor(255,255,0);
	}
	
	function updateProgress(dq, text)
	{
		foreach(v in quest_draws) {
			if (dq.id == v.quest.id) {
				v.progress_draw.text = text;
			}
		}
	}
	
	function removeQuest(id)
	{
		local det = false;
		
		foreach(i, v in quest_draws) {
			if (v.quest.id == id) {
				if (selected == v)
					selected = false;
					
				if (highlighted == v)
					highlighted = false;
					
				quest_draws.remove(i);
				
				det = true;
			}
			
			if (det == true) {
				v.draw.setPosition(v.draw.getPosition().x, v.draw.getPosition().y - 150);
			}
		}
	}
	
	frame = null;
	quests_list = null;
	quests_desc = null;
	
	l_slider = null;
	d_slider = null;
	
	q_title = null;
	
	ls = {
		x = 0, y = 0, width = 0, height = 0
	};
	
	rs = {
		x = 0, y = 0, width = 0, height = 0
	};
	
	quest_draws = [];
	
	highlighted = false;
	selected = false;
	
	nav_menu = null;
	close_btn = null;
}