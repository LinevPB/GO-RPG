function onInteractNPC(pid, bid)
{
	zirvan_oninteract(pid, bid);
	CallEvent("onInteractNPC",pid, bid);
}

function onReleaseNpcMenuOption(pid, menu, option)
{
	zirvan_menu_release(pid, menu, option);
	CallEvent("onReleaseNpcMenuOption",pid, menu, option);
}

function onFinishDialogue(pid, dlg)
{
	zirvan_dlg_finish(pid, dlg);
	CallEvent("onFinishDialogue",pid, dlg);
}

function onChangeNpcMenuOption(pid, menu, option)
{	
	CallEvent("onChangeNpcMenuOption",pid, menu, option);
}