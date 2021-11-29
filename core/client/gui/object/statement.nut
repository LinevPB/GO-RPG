local __statement_blockade = false;
local __statement_time = 0;
local __statements = [];
local __statements_queue = [];

local __y = 7000;
local __range = 1200;
local __rate = 10;

local function __statement_render()
{
	if (__statement_time < getTickCount())
	{
		foreach(i, v in __statements) {
			local pos = v.draw.getPosition();
			
			v.draw.setPosition(pos.x, pos.y - __rate);
			
			////////////////
			if ((i + 1) == __statements.len()) {
				if (pos.y < (__y - 200)) {
					if (__statements_queue.len() > 0) {
						__statement_blockade = true;
						__statements.append(__statements_queue.remove(0));
					} else {
						__statement_blockade = false;
					}
				}
			}
			
			///////////////
			
			if (pos.y >= (__y - __range + 255 - __rate)) {
				if ((v.draw.getAlpha() + __rate) > (255 - __rate)) {
					v.draw.setAlpha(255);
				} else {
					v.draw.setAlpha(v.draw.getAlpha() + __rate);
				}
			} else {
				if ((v.draw.getAlpha() - __rate) < 0) {
					v.draw.setAlpha(0);
				} else {
					v.draw.setAlpha(v.draw.getAlpha() - __rate);
				}
			}
			
			if (pos.y <= (__y - __range))
				__statements.remove(i);
		}
		
		__statement_time = getTickCount() + 40;
	}
}

addEventHandler("onRender", __statement_render);

class statement
{
	constructor(r,g,b,text)
	{
		draw = Draw(100, __y, text);
		draw.setAlpha(0);
		draw.setColor(r,g,b);
		draw.visible = true;
			
		if (__statement_blockade == false) {
			__statement_blockade = true;
			__statements.append(this);
		} else {
			__statements_queue.append(this);
		}
	}
	
	draw = null;
}

function reexecute_statement(r,g,b,text)
{
	statement(r,g,b,text);
}

const STATEMENT_PACKET = 9970911;

local function statement_packet(packet)
{
	if (packet.readInt32() == STATEMENT_PACKET) {
		statement(packet.readInt32(), packet.readInt32(), packet.readInt32(), packet.readString());
	}
}

addEventHandler("onPacket", statement_packet);