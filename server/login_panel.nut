const TRY_LOGIN = 333330;
const TRY_REGISTER = 333338;
const ON_CREATE_CHARACTER = 22224;
const ON_CHOOSE_CHARACTER = 22225;

local characters = [];
path <- "gamemodes/project/temp_base/"

local function sendLoginAnswer(pid, id, val, ...)
{
	local packet = Packet();
	packet.writeInt32(id);
	packet.writeBool(val);
	
	foreach(v in vargv) {
		if (typeof v == "string")
			packet.writeString(v);
		else
			packet.writeInt32(v);
	}
		
	packet.send(pid, RELIABLE_ORDERED);
}

local function getPlayerCharacters(login)
{
	local chars = {};
	
	for(local i = 1; i <= 3; ++i) {
		local c_file = File(path + "characters/" + login + "_char_" + i + ".txt");
		
		if (c_file.exists() == true) {
			c_file.open("r+");
			chars[i] <- c_file.readLine();
			c_file.close();
		} else {
			chars[i] <- "n/a";
		}
	}
	
	return chars;
}

local STAT = {
	[0] = "No title", // title
	[1] = "No clan", // clan
	[2] = "No rank", // clan rank
	[3] = "No guild", // guild
	[4] = 200, // hp
	[5] = 200, // max hp
	[6] = 100, // mp
	[7] = 100, // max mp
	[8] = 0, // xp
	[9] = 1000, // xp lvl
	[10] = 1, // lvl
	[11] = 10, // str
	[12] = 10, // dex
	[13] = 10, // intel
	[14] = 10, // const
	[15] = 0, // sp
	[16] = 1, // wm
	[17] = 1, // tc
	[18] = 1, // craft
	[19] = 50 // gold
};

function createCharacterFile(login, index, nickname)
{
	local c_file = File(path + "characters/" + login + "_char_" + index + ".txt");
	c_file.open("w+");
	c_file.writeLine(nickname);
	foreach(v in STAT) {
		c_file.writeLine(v.tostring());
	}
	c_file.close();
}

local function login_packet(pid, packet)
{
	local ID = packet.readInt32();
	
	if (ID == TRY_LOGIN) {
		local login = packet.readString();
		local password = packet.readString();
		
		local l_file = File(path + login + ".txt");
		
		if (l_file.exists() == true) {
			l_file.open("r+");
			
			if (password == l_file.readLine()) {
				l_file.close();
				
				local player_chars = getPlayerCharacters(login);
				
				return sendLoginAnswer(pid, TRY_LOGIN, true, player_chars[1], player_chars[2], player_chars[3]);
			}
			
			l_file.close();
		}
		
		return sendLoginAnswer(pid, TRY_LOGIN, false);
		
	} else if (ID == TRY_REGISTER) {
		local login = packet.readString();
		local password = packet.readString();
		
		local l_file = File(path + login + ".txt");
		
		if (l_file.exists() == false) {
			l_file.open("w+");
			l_file.writeLine(password);
			l_file.close();
			
			return sendLoginAnswer(pid, TRY_REGISTER, true);
		}
		
		sendLoginAnswer(pid, TRY_REGISTER, false);
	} else if (ID == ON_CREATE_CHARACTER) {
		local nickname = packet.readString();
		local login = packet.readString();
		local index = packet.readInt32();
		
		foreach(v in characters) {
			if (v == nickname)
				return sendLoginAnswer(pid, ON_CREATE_CHARACTER, false);
		}
		
		player.setLogin(pid, login);
		createCharacterFile(login, index, nickname);
		
		return sendLoginAnswer(pid, ON_CREATE_CHARACTER, true, index);
	} else if (ID == ON_CHOOSE_CHARACTER) {
		local login = packet.readString();
		local index = packet.readInt32();
		
		player.setLogin(pid, login);
		sendLoginAnswer(pid, ON_CHOOSE_CHARACTER, true, index);
	}
}

addEventHandler("onPacket", login_packet);

local function load_characters_list()
{
	local cfile = File(path + "_characters.list");
	local name = null;
	cfile.open("r+");
	
	do {
		name = cfile.readLine();
		if (name != "")
			characters.append(name);
	} while(name != "");
}

addEventHandler("onInit", load_characters_list);