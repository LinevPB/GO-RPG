local npc_draw = null;
local vis = false;
local d3d_render = 0;

addEventHandler("onRender", function() {
	if (d3d_render < getTickCount()) {
		if (npc_draw != null) {
			local pos = getPlayerPosition(focus.getId());
			npc_draw.setWorldPosition(pos.x, pos.y + 130, pos.z);
		}
	}
	
	d3d_render += 50;
});

function onFocus(fid, old_fid)
{
	if (vis == true) {
		npc_draw.visible = false;
		npc_draw = null;
		vis = false;
	}
	
	if (isBot(fid)) {
		if (npc_draw != false) {
			if (fid != -1 ) {
				local pos = getPlayerPosition(focus.getId());
				
				npc_draw = Draw3d(0, 0, 0);
				npc_draw.font = "Font_Old_10_White_Hi.TGA";
				npc_draw.setWorldPosition(pos.x, pos.y + 130, pos.z);
				vis = true;

				if (getClientBot(fid).aggressive == true) {
					npc_draw.insertText("Monster");
					npc_draw.setColor(255,0,0);
				} else {
					npc_draw.insertText("Friendly");
					npc_draw.setColor(0,220,0);
				}
				
				npc_draw.visible = true;
			}
		}	
	}
}

addEventHandler("onFocus", onFocus);

local function cmdHandler(cmd, params)
{
	if (cmd == "pos")
	{
		params = sscanf("fff", params)
		if (params)
		{
			local pos = getPlayerPosition(heroId);
			chat.send(255, 255, 0, "X: " + pos.x + " Y: " + pos.y + " Z: " + pos.z);
		}
		else
			chat.send(0, 255, 0, "Wrong parameters!");
	}
}

addEventHandler("onCommand", cmdHandler);
