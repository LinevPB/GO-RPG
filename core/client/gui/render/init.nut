local function initHandler() 
{     
	enableEvent_Render(true);
	Camera.modeChangeEnabled = false;
}   

addEventHandler("onInit", initHandler);