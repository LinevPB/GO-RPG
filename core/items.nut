local __items = [];

local function __getItem(__code)
{
	foreach(__v in __items) {
		if (__v.inst.tolower() == __code.tolower()) {
			return __v;
		}
	}
	
	return false;
}

class __createItem
{
	constructor(__params)
	{
		__items.append(__params);
	}
}

createItem <- __createItem;
returnItem <- __getItem;

