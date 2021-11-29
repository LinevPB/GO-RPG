local events = [];

function AddEvent(function_name)
{
	events.append({ name = function_name, executive = [] });
}

function CallEvent(func_name, ...)
{
	foreach(v in events) {
		if (v.name == func_name) {
			foreach(k in v.executive) {
				local un = k + "(";
				for (local i = 0; i <= vargv.len() - 1; ++i) {
					if (typeof vargv[i] != "string") {
						un += vargv[i];
					} else {
						un += "\"" + vargv[i] + "\"";
					}
					if (i < vargv.len() - 1)
						un += ",";
				}
				un += ")";
				
				local compiledScript = compilestring(un);
				compiledScript();
			}
		}
	}
}

function AddEventHandler(func_name, executive_func)
{
	foreach(v in events) {
		if (v.name == func_name) {
			v.executive.append(executive_func);
		}
	}
}