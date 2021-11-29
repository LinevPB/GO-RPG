local panel = {};
local login_panel = {};
local register_panel = {};
local ch_select = {};
local ch_creator = {};

function openMainPanel()
{
	clearMultiplayerMessages();
	
	Camera.enableMovement(false);
	Camera.setPosition(30070, 5251, -14750);
	Camera.setRotation(0,15,0);
	
	setPlayerPosition(heroId, 29906, 5246, -15717);
	setPlayerAngle(heroId, 20);
	
	enable_NicknameId(false);
	showPlayerStatus(false);
	enableKeys(false);
	setCursorVisible(true);
	setFreeze(true);
	disableControls(false);
	
	////////////////MAIN
	
	panel.menu <- menu({ x = 3346, y = 2600, width = 1500, height = 2600, align =  align.center, texture = "MENU_INGAME.TGA"});
	panel.login <- panel.menu.add({ x = 200, y = 500, text = "Log in", texture = "MENU_CHOICE_BACK.TGA", width = 1100, height = 300}, "INV_TITEL.TGA");
	panel.signup <- panel.menu.add({ x = 200, y = 1100, text = "Sign up", texture = "MENU_CHOICE_BACK.TGA", width = 1100, height = 300}, "INV_TITEL.TGA");
	panel.exit <- panel.menu.add({ x = 200, y = 1700, text = "Exit", texture = "MENU_CHOICE_BACK.TGA", width = 1100, height = 300}, "INV_TITEL.TGA");
	panel.menu.addInput({ x = 100, y = 100, text = "Server name", center = true });
	panel.menu.show();
	
	//////////////LOGIN
	
	login_panel.menu <- menu({ x = 3371, y = 3000, width = 1450, height = 2400, align = align.center, texture = "MENU_INGAME.TGA"});
	login_panel.menu.addInput({ x = 100, y = 100, text = "Log in", center = true });
	
	login_panel.menu.addInput({ x = 200, y = 350, text = "Nickname", center = false });	
	login_panel.nickname <- login_panel.menu.addTextbox({ x = 200, y = 600, text = " ", texture = "MENU_CHOICE_BACK.TGA", width = 950, height = 250});
	
	login_panel.menu.addInput({ x = 200, y = 1050, text = "Password", center = false });
	login_panel.password <- login_panel.menu.addPasswordbox({ x = 200, y = 1300, text = " ", texture = "MENU_CHOICE_BACK.TGA", width = 950, height = 250});
	
	login_panel.login <- login_panel.menu.add({ x = 150, y = 1800, text = "Log in", texture = "MENU_CHOICE_BACK.TGA", width = 500, height = 350}, "INV_TITEL.TGA");
	login_panel.back <- login_panel.menu.add({ x = 750, y = 1800, text = "Back", texture = "MENU_CHOICE_BACK.TGA", width = 500, height = 350}, "INV_TITEL.TGA");
	
	//////////////REGISTER
	
	register_panel.menu <- menu({ x = 3371, y = 3000, width = 1450, height = 3000, align = align.center, texture = "MENU_INGAME.TGA"});
	register_panel.menu.addInput({ x = 100, y = 100, text = "Sign in", center = true });
	
	register_panel.menu.addInput({ x = 200, y = 350, text = "Nickname", center = false });	
	register_panel.nickname <- register_panel.menu.addTextbox({ x = 200, y = 600, text = " ", texture = "MENU_CHOICE_BACK.TGA", width = 950, height = 250});
	
	register_panel.menu.addInput({ x = 200, y = 1050, text = "Password", center = false });
	register_panel.password <- register_panel.menu.addPasswordbox({ x = 200, y = 1300, text = " ", texture = "MENU_CHOICE_BACK.TGA", width = 950, height = 250});
	
	register_panel.menu.addInput({ x = 200, y = 1650, text = "Confirm password", center = false });
	register_panel.confirm_password <- register_panel.menu.addPasswordbox({ x = 200, y = 1900, text = " ", texture = "MENU_CHOICE_BACK.TGA", width = 950, height = 250});
	
	register_panel.login <- register_panel.menu.add({ x = 150, y = 2400, text = "Log in", texture = "MENU_CHOICE_BACK.TGA", width = 500, height = 350}, "INV_TITEL.TGA");
	register_panel.back <- register_panel.menu.add({ x = 750, y = 2400, text = "Back", texture = "MENU_CHOICE_BACK.TGA", width = 500, height = 350}, "INV_TITEL.TGA");
	
	///////////////// CHARACTER SELECTING
	
	ch_select.character <- {};
	ch_select.menu <- menu({ x = 3346, y = 2300, width = 1500, height = 2900, align =  align.left, texture = "MENU_INGAME.TGA"});
	ch_select.selector <- ch_select.menu.addSelector();
	ch_select.character[1] <- ch_select.selector.addOption({ x = 200, y = 400, text = "SLOT_1", texture = "MENU_CHOICE_BACK.TGA", width = 1100, height = 300});
	ch_select.character[2] <- ch_select.selector.addOption({ x = 200, y = 1000, text = "SLOT_2", texture = "MENU_CHOICE_BACK.TGA", width = 1100, height = 300});
	ch_select.character[3] <- ch_select.selector.addOption({ x = 200, y = 1600, text = "SLOT_3", texture = "MENU_CHOICE_BACK.TGA", width = 1100, height = 300});
	
	ch_select.select <- ch_select.menu.add({ x = 200, y = 2200, text = "Select", texture = "MENU_CHOICE_BACK.TGA", width = 500, height = 300}, "INV_TITEL.TGA");
	ch_select.logout <- ch_select.menu.add({ x = 800, y = 2200, text = "Log out", texture = "MENU_CHOICE_BACK.TGA", width = 500, height = 300}, "INV_TITEL.TGA");
	
	ch_select.menu.addInput({ x = 100, y = 100, text = "Characters", center = true });
	
	//////////////////////// CHARACTER CREATOR
	
	ch_creator.menu <- menu({ x = 3346, y = 2300, width = 1500, height = 2900, align =  align.left, texture = "MENU_INGAME.TGA"});
	
	ch_creator.menu.addInput({ x = 200, y = 350, text = "Name", center = false });	
	ch_creator.nickname <- ch_creator.menu.addTextbox({ x = 200, y = 600, text = "", texture = "MENU_CHOICE_BACK.TGA", width = 1100, height = 250});
	
	ch_creator.create <- ch_creator.menu.add({ x = 200, y = 2200, text = "Create", texture = "MENU_CHOICE_BACK.TGA", width = 500, height = 300}, "INV_TITEL.TGA");
	ch_creator.back <- ch_creator.menu.add({ x = 800, y = 2200, text = "Back", texture = "MENU_CHOICE_BACK.TGA", width = 500, height = 300}, "INV_TITEL.TGA");
	
	ch_creator.menu.addSwitch({
		x = 200,
		y = 1050,
		width = 1100,
		height = 200,
		texture = "MENU_CHOICE_BACK.TGA",
		items = [
		"Warrior",
		"Archer",
		"Wizard"]
	});
	
	ch_creator.menu.addInput({ x = 100, y = 100, text = "Character Creator", center = true });
}

const TRY_LOGIN = 333330;

function onTryLogIn(nickname, password)
{
	player.login = nickname;
	player.password = password;
	
	local packet = Packet();
	packet.writeInt32(TRY_LOGIN);
	packet.writeString(nickname);
	packet.writeString(password);
	packet.send(RELIABLE_ORDERED);
}

function onLogIn(val, ...)
{
	if (val == true) {
		for(local i = 1; i <= 3; ++i) {
			player.character[i] = vargv[i - 1];
			if (vargv[i - 1] != "n/a")
				ch_select.character[i].setText(vargv[i - 1]);
			else
				ch_select.character[i].setText("Empty slot");
		}
		
		login_panel.menu.change(ch_select.menu);
		Camera.setPosition(29974, 5260, -15524);
		Camera.setRotation(0,190,0);
	} else {
		statement(255, 0, 0, "Could not logged in!");
	}
}

const TRY_REGISTER = 333338;

function onTrySignUp(nickname, password, confirm)
{
	player.login = nickname;
	player.password = password;
	
	if (password == confirm) {
		if (nickname != "") {
			if (nickname.len() <= 25) {
				local packet = Packet();
				packet.writeInt32(TRY_REGISTER);
				packet.writeString(nickname);
				packet.writeString(password);
				packet.send(RELIABLE_ORDERED);
			} else {
				statement(255, 0, 0, "Login has to contain max. 25 characters!");
			}
		} else {
			statement(255,0,0, "Login cannot be empty!");
		}
	} else {
		statement(255,0 ,0, "Passwords have to be the same!");
	}
}

function onSignUp(val)
{
	if (val == true) {
		for(local i = 1; i <= 3; ++i) {
			player.character[i] = "n/a";
			ch_select.character[i].setText("Empty slot");
		}
		
		register_panel.menu.change(ch_select.menu);
				
		Camera.setPosition(29974, 5260, -15524);
		Camera.setRotation(0,190,0);
	} else {
		statement(255, 0, 0, "Account already exists!");
	}
}

const ON_CREATE_CHARACTER = 22224;

local function onCreateCharacter(id)
{
	if (ch_creator.nickname.getText().len() >= 3 && ch_creator.nickname.getText().len() <= 20) {
		local packet = Packet();
		packet.writeInt32(ON_CREATE_CHARACTER);
		packet.writeString(ch_creator.nickname.getText());
		packet.writeString(player.login);
		packet.writeInt32(player.current_character);
		packet.send(RELIABLE_ORDERED);
	} else {
		statement(255, 0, 0, "Nickname has to contain 3-20 characters!");
	}
}

const ON_CHOOSE_CHARACTER = 22225;

local function onChooseCharacter(id)
{
	local packet = Packet();
	packet.writeInt32(ON_CHOOSE_CHARACTER);
	packet.writeString(player.login);
	packet.writeInt32(player.current_character);
	packet.send(RELIABLE_ORDERED);
	//loadCharacter(index)
}

const LOADED = 777345;

local function LOG_PLAYER()
{
	showPlayerStatus(true)
	enableKeys(true);
	setCursorVisible(false);
	setFreeze(false);
	Camera.enableMovement(true);
	panel.menu.hide();
	register_panel.menu.hide();
	login_panel.menu.hide();
	ch_creator.menu.hide();
	ch_select.menu.hide();
	disableControls(true);
	
	player.logged = true;
	setPlayerColor(heroId, 190, 190, 255);
	
	player.chat_visibility = true;
	chat.show();
	
	chat.send(255, 0, 0, "Welcome to the server!");
	setPlayerPosition(heroId, 12140, 998, -3325);
}

local function loadCharacter(index)
{
	player.load(index);
}

local function login_packet(packet)
{
	local ID = packet.readInt32();
	if (ID == TRY_LOGIN) {
		local success = packet.readBool();
		if (success == true)
			onLogIn(success, packet.readString(), packet.readString(), packet.readString());
		else
			onLogIn(success);
	}
	else if (ID == TRY_REGISTER)
		onSignUp(packet.readBool());
	else if (ID == ON_CREATE_CHARACTER) {
		local success = packet.readBool();
		if (success == true) {
			local index = packet.readInt32();
			loadCharacter(index);
		}
		else
			statement(pid, 255, 0, 0, "Nickname is already taken!");
	} else if (ID == LOADED) {
		LOG_PLAYER();
	} else if (ID == ON_CHOOSE_CHARACTER) {
		local success = packet.readBool();
		if (success == true) {
			local index = packet.readInt32();
			loadCharacter(index);
		} else {
			statement(pid, 255, 0, 0, "Something went wrong!");
		}
	}
}

addEventHandler("onPacket", login_packet);

function onReleasePanelButton(id)
{
	switch(id) {
	
		/* PANEL */
		case panel.login:
			panel.menu.change(login_panel.menu);
		break;
		
		case panel.signup:
			panel.menu.change(register_panel.menu);
		break;
			
		case panel.exit:
			exitGame();
		break;
			
		/* LOGIN */
		case login_panel.login:
			onTryLogIn(login_panel.nickname.getText(), login_panel.password.getText());
		break;
		
		case login_panel.back:
			login_panel.menu.change(panel.menu);
		break;
		
		/* REGISTER */
		case register_panel.back:
			register_panel.menu.change(panel.menu);
			
			Camera.setPosition(30070, 5251, -14750);
			Camera.setRotation(0,15,0);
		break;
		
		case register_panel.login:
			onTrySignUp(register_panel.nickname.getText(), register_panel.password.getText(), register_panel.confirm_password.getText());
		break;
			
		/* CHARACTER SELECTION */
		case ch_select.logout:
			ch_select.menu.change(panel.menu);
			
			Camera.setPosition(30070, 5251, -14750);
			Camera.setRotation(0,15,0);
		break;
		
		case ch_select.select:
			if (ch_select.selector.getSelection() != -1) {
				player.current_character = ch_select.selector.getSelection();
				
				if (player.character[player.current_character] == "n/a") { 
				
				ch_select.selector.reset();
				ch_select.menu.change(ch_creator.menu);
				
				Camera.setPosition(29974, 5260, -15524);
				Camera.setRotation(0,190,0);
				} else {
					onChooseCharacter(player.current_character);
				}
			}
		break;
			
		/* CHARACTER CREATION */
		case ch_creator.create:
			onCreateCharacter(player.current_character);
		break;
		
		case ch_creator.back:
			ch_creator.menu.change(ch_select.menu);
		break;
	}
}