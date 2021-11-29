class section
{
	constructor(x, y, width, height, text)
	{
		frame = Texture(x, y, width, height, "LOG_PAPER.TGA");
		
		title = Draw(0,0,"TITLE");
		title.font = "FONT_OLD_10_WHITE_HI.TGA";
		title.text = text;
		
		title_frame = Texture(0,0, title.width + 300, 250, "MENU_CHOICE_BACK.TGA");
		title_frame.setPosition(x + frame.getSize().width / 2 - title_frame.getSize().width / 2, y - 75);
		
		title.setPosition(title_frame.getPosition().x + title_frame.getSize().width / 2 - title.width / 2,
							title_frame.getPosition().y + title_frame.getSize().height / 2 - title.height / 2);
		title.setColor(255,255,255);
		
		frame.visible = false;
		title.visible = false;
		title_frame.visible = false;
		
		inputs = [];
		inputs_amount = 0;
	}
	
	function add(text, val)
	{
		local params = {};
		
		params.draw <- Draw(0, 0, "");
		params.draw.font = "FONT_OLD_10_WHITE.TGA";
		
		params.draw.text = text + ": ";
		params.draw.setColor(255,255,255);
		params.draw.setPosition(frame.getPosition().x + 100, title_frame.getPosition().y + title_frame.getSize().height + 100 + inputs_amount * 150);
		params.draw.visible = false;
		
		params.draw1 <- Draw(0, 0, "");
		params.draw1.font = "FONT_OLD_10_WHITE_HI.TGA";
		
		params.draw1.text = val;
		params.draw1.setColor(255,255,255);
		params.draw1.setPosition(params.draw.getPosition().x + params.draw.width, params.draw.getPosition().y);
		params.draw1.visible = false;
		
		params.value <- val;
		params.text <- text;
		
		params.changeVal <- function(val) {
			params.value = val;
			params.draw1.text = val;
		}
		
		inputs.append(params);
		
		inputs_amount++;
		
		return inputs[inputs.find(params)];
	}
	
	function show()
	{
		frame.visible = true;
		title.visible = true;
		title_frame.visible = true;
		
		title_frame.top();
		title.top();
		
		foreach(v in inputs) {
			v.draw.visible = true;
			v.draw1.visible = true;
		}
	}
	
	function hide()
	{
		frame.visible = false;
		title.visible = false;
		title_frame.visible = false;
		
		foreach(v in inputs) {
			v.draw.visible = false;
			v.draw1.visible = false;
		}
	}
	
	function space()
	{
		inputs_amount++;
	}
	
	function getPosition()
	{
		return frame.getPosition();
	}
	
	function getSize()
	{
		return frame.getSize();
	}
	
	function getInputs()
	{
		return inputs;
	}
	
	frame = null;
	title_frame = null;
	title = null;
	inputs = [];
	inputs_amount = 0;
}

class stats_gui
{
	constructor()
	{
		frame = Texture(2000, 1950, 4192, 4292, "MENU_INGAME.TGA");
		
		title = Draw(0,0,"TITLE");
		title.font = "FONT_OLD_20_WHITE_HI.TGA";
		title.text = "Statistics";
		title.setPosition(frame.getPosition().x + frame.getSize().width / 2 - title.width / 2, frame.getPosition().y + 100);
		title.setColor(250,180,20);
		
		frame.visible = false;
		title.visible = false;
		
		character_sec = section(2000 + 200, 2000 + 600, 1800, 900, "Character");
		character_sec.add("Name", player.nickname);
		character_sec.add("Guild", player.guild);
		character_sec.add("Level", player.level);

		clan_sec = section(2000 + 200, character_sec.getPosition().y + character_sec.getSize().height + 200, 1800, 800, "Clan");
		clan_sec.add("Clan", player.clan);
		clan_sec.add("Rank", player.clan_rank);
		
		status_sec = section(2000 + 200, clan_sec.getPosition().y + clan_sec.getSize().height + 200, 1800, 1000, "Status");
		status_sec.add("Health", player.health + "/" + player.max_health);
		status_sec.add("Mana", player.mana + "/" + player.max_mana);
		status_sec.add("Experience", player.experience + "/" + player.next_lvl_exp);
		status_sec.add("Skill points", player.skill_points);
		
		attributes_sec = section(character_sec.getPosition().x + character_sec.getSize().width + 200, 2000 + 600, 1800, 1700, "Attributions");
		attributes_sec.add("Strength", player.strength);
		attributes_sec.add("Dexterity", player.dexterity);
		attributes_sec.add("Intelligence", player.intelligence);
		attributes_sec.add("Constitution", player.constitution);
		attributes_sec.space();
		attributes_sec.add("Weapon mastery", "10%");
		attributes_sec.add("Trophy collecting", "No");
		attributes_sec.add("Crafting", "No");
		
		fight_stats_sec = section(character_sec.getPosition().x + character_sec.getSize().width + 200, attributes_sec.getPosition().y + attributes_sec.getSize().height + 200, 1800, 1500, "Combat statistics");
		fight_stats_sec.add("Attack", player.attack);
		fight_stats_sec.add("Defence", player.defence);
		fight_stats_sec.add("Hit rate", player.hitrate);
		fight_stats_sec.add("Evasion", player.evasion);
		fight_stats_sec.space();
		fight_stats_sec.add("Protection", player.protection);
		fight_stats_sec.add("Critical", player.critical);
		
		sections.append(character_sec);
		sections.append(status_sec);
		sections.append(attributes_sec);
		sections.append(fight_stats_sec);
		sections.append(clan_sec);
	}
	
	function show()
	{
		frame.visible = true;
		title.visible = true;
		
		character_sec.show();
		clan_sec.show();
		status_sec.show();
		attributes_sec.show();
		fight_stats_sec.show();
	}
	
	function hide()
	{
		frame.visible = false;
		title.visible = false;
		
		character_sec.hide();
		clan_sec.hide();
		status_sec.hide();
		attributes_sec.hide();
		fight_stats_sec.hide();
	}
	
	function onRender()
	{
		foreach(v in sections) {
			foreach(k in v.getInputs()) {
				switch(k.text.tolower()) {
					case "name":
						k.changeVal(player.nickname);
					break;
					
					case "guild":
						k.changeVal(player.guild);
					break;
					
					case "level":
						k.changeVal(player.level);
					break;
					
					//////////////////
					
					case "clan":
						k.changeVal(player.clan);
					break;
					
					case "rank":
						k.changeVal(player.clan_rank);
					break;
					
					/////////////////
					
					case "health":
						k.changeVal(player.health + "/" + player.max_health);
					break;
					
					case "mana":
						k.changeVal(player.mana + "/" + player.max_mana);
					break;
					
					case "experience":
						k.changeVal(player.experience + "/" + player.next_lvl_exp);
					break;
					
					case "skill points":
						k.changeVal(player.skill_points);
					break;
					
					////////////////////
					
					case "strength":
						k.changeVal(player.strength);
					break;
					
					case "dexterity":
						k.changeVal(player.dexterity);
					break;
					
					case "intelligence":
						k.changeVal(player.intelligence);
					break;
					
					case "constitution":
						k.changeVal(player.constitution);
					break;
					
					case "weapon mastery":
						k.changeVal(player.weapon_mastery);
					break;
					
					case "trophy collecting":
						k.changeVal(player.trophy);
					break;
					
					case "crafting":
						k.changeVal(player.crafting);
					break;
					
					///////////////////////
					
					case "attack":
						k.changeVal(player.attack);
					break;
					
					case "defence":
						k.changeVal(player.defence);
					break;
					
					case "hit rate":
						k.changeVal(player.hitrate);
					break;
					
					case "evasion":
						k.changeVal(player.evasion);
					break;
					
					case "protection":
						k.changeVal(player.protection);
					break;
					
					case "critical":
						k.changeVal(player.critical);
					break;

				}
			}
		}
	}
	
	frame = null;
	title = null;
	
	character_sec = null;
	clan_sec = null;
	status_sec = null;
	attributes_sec = null;
	fight_stats_sec = null;
	
	sections = [];
}