local crid = -1;

class focus
{	
	function setId(fid)
	{
		crid = fid;
	}
	
	function getId()
	{
		return crid;
	}
}

function onfocus_structure(fid, old_fid)
{
	if (fid != -1) {
		focus.setId(fid);
	} else {
		focus.setId(-1);
	}
}

addEventHandler("onFocus", onfocus_structure);