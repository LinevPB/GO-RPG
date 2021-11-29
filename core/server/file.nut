local function loadFile(src)
{
	local row = [];
	local content = "";
	local e_file = file(src, "r+");
	
	while(!e_file.eos()) {
		content += e_file.readn('b').tochar();
	}
	
	e_file.close();
	
	local line = "";
	
	foreach(v in content) {
		if (v.tochar() != "\n") {
			line += v.tochar();
		} else {
			if (line != "") {
				row.append(line);
				line = "";
			}
		}
	}
	
	return row;
}

function loadDialogue(src)
{
	return loadFile(src);
}