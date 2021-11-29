class chatText
{
	constructor(r, g, b, _text)
	{
		text = Draw(0, 0, _text);
		text.setColor(r, g, b);
	}

	function show()
	{
		text.visible = true;
	}

	function hide()
	{
		text.visible = false;
	}

	function update(x, y)
	{
		text.setPosition(x, y);
	}

	function offset()
	{
		return text.height;
	}

	text = null;
}

class chatNickname extends chatText
{
	constructor(pid, r, g, b, _text)
	{
		base.constructor(r, g, b, _text);
		
		local color = getPlayerColor(pid);
		nickname = Draw(0, 0, getPlayerName(pid) + " : ");
		nickname.setColor(color.r, color.g, color.b);
	}

	function show()
	{
		base.show();
		nickname.visible = true;
	}

	function hide()
	{
		base.hide();
		nickname.visible = false;
	}

	function update(x, y)
	{
		base.update(nickname.width + x, y);
		nickname.setPosition(x, y);
	}

	function offset()
	{
		return nickname.height;
	}

	nickname = null;
}

class chatStructure
{
	x = 50;
	y = 50;
	visible = false;
	
	lines = queue();
	maxLines = 15;
	
	function toggle()
	{
		visible ? hide() : show();
	}
	
	function show()
	{
		if (player.chat_visibility == true) {
			visible = true;
			
			foreach (v in lines) {
				v.show();
			}
		}
	}
	
	function hide()
	{
		visible = false;
		
		foreach (v in lines) {
			v.hide();
		}
	}
	
	function calculatePosition()
	{
		local offset = 0;
		
		foreach (v in lines)
		{
			v.update(x, y + offset);
			offset += v.offset();
		}

		chatInputSetPosition(x, y + offset);
	}
	
	function printLine(line)
	{
		if (visible == true) {
			line.show();
		}
		
		lines.push(line);

		if (lines.len() > maxLines)
		{
			local _line = lines.front();
			_line.hide();

			lines.pop();
		}
		
		calculatePosition();
	}
	
	function printPlayerNickname(pid, r, g, b, text)
	{
		printLine(chatNickname(pid, r, g, b, text));
	}
	
	function printText(r, g, b, text)
	{
		printLine(chatText(r, g, b, text));
	}
	
	function send(r, g, b, text)
	{
		printText(r, g, b, text);
	}
	
}

//////
chat <- chatStructure();
//////

function chat_key(key)
{
	if (player.logged == true && player.chat_visibility == true) {
		if (chatInputIsOpen()) {
			playGesticulation(heroId);

			switch(key) {
				
			case KEY_RETURN:
				
				chatInputSend();
				disableControls(true);
				
				break;

			case KEY_ESCAPE:
			
				chatInputClose();
				disableControls(true);
				
				break;
			}
		} 
		else {
			switch (key) {
				
			case KEY_T:
			
				if (player.chat_visibility == true) {
					chatInputOpen();
					disableControls(false);
				}
				
				break;
					
			case KEY_F7:
			
				chat.toggle();
				
				break;
			}
		}
	}
}

addEventHandler("onKey", chat_key);

function chat_message(pid, r, g, b, text)
{
	if (player.logged == true && player.chat_visibility == true) {
		if (pid != -1) {
			chat.printPlayerNickname(pid, r, g, b, text);
		}
		else {
			chat.printText(r, g, b, text);
		}
	}
}

addEventHandler("onPlayerMessage", chat_message);