const STATEMENT_PACKET = 9970911;

function statement(pid, r, g, b, text)
{
	local packet = Packet();
	
	packet.writeInt32(STATEMENT_PACKET);
	packet.writeInt32(r);
	packet.writeInt32(g);
	packet.writeInt32(b);
	packet.writeString(text);
	
	packet.send(pid, RELIABLE_ORDERED);
}