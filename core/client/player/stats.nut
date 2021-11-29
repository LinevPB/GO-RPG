class stats_table extends stats_gui
{
	constructor()
	{
		base.constructor();
		
		opened = false;
	}
	
	function onKey(key)
	{
		if (key == KEY_P && chatInputIsOpen() == false) {
			if (player.logged == true && inventory.opened == false && quests.opened == false && player.interacting == false)
				toggle();
		}
		
		if (key == KEY_ESCAPE) {
			if (opened == true)
				close();
		}
	}
	
	function toggle()
	{
		opened ? close() : open();
	}
	
	function open()
	{
		base.show();
		
		opened = true;
	}
	
	function close()
	{
		base.hide();
		
		opened = false;
	}
	
	function onRender()
	{
		base.onRender();
	}
	
	opened = false;
}

stats <- stats_table();

local function statsKeyHandler(key) {
	if (player.logged == true)
		stats.onKey(key);
}

addEventHandler("onKey", statsKeyHandler);

local stats_tick = 0;

local function statsRender() {
	if (stats_tick < getTickCount()) {
		stats.onRender();
	}
	
	stats_tick += 200;
}

addEventHandler("onRender", statsRender);