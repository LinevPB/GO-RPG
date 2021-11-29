local function onDie(pid)
{
	if (pid == heroId) {
		player.startDieDraw();
		
		callServerFunc("onDie", heroId);
	}
}

//////// RENDER

local DIED = false;

local function ondie_render()
{
	if (isPlayerDead(heroId)) {
		if (DIED == false) {
			DIED = true;
			onDie(heroId);
		}
	} else {
		if (DIED == true) {
			DIED = false;
		}
	}
}

addEventHandler("onRender", ondie_render);