--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

OfficialServerForceUpdateCommand=class(Command);

function OfficialServerForceUpdateCommand:ctor()
	self.class=OfficialServerForceUpdateCommand;
end

function OfficialServerForceUpdateCommand:execute(notification)
  require "core.utils.UserInfoUtil";
  require "core.utils.CommonUtil";
  require "main.controller.command.openFunction.OpenFunctionUICommand";
  require "main.controller.command.tutor.OpenTutorUICommand";
  require "main.controller.notification.OpenFunctionNotification";
  if true then return; end
  --if GameData.platFormID ~= GameConfig.PLATFORM_CODE_WAN then
  if CommonUtils:getCurrentPlatform()~=CC_PLATFORM_ANDROID then
  	return;
  end

  local function popForceToDownload()

      GameData.forceToUpdate=true;

      local activityProxy=self:retrieveProxy(ActivityProxy.name);
      activityProxy:checkData4DownLoadForce();

      local winSize = Director:sharedDirector():getWinSize();
      uiOffsetX = (winSize.width - GameConfig.STAGE_WIDTH) / 2

      OpenFunctionUICommand.new():execute(OpenFunctionNotification.new(OpenFunctionNotifications.OPEN_UI_BY_FUNCTION_ID,{ID=FunctionConfig.FUNCTION_ID_100,FORCE_UPDATE=true}));

  end

  if "2"~=UserInfoUtil:public_getDownLoadGiftSign(2) then
    if self:retrieveProxy(GeneralListProxy.name):getLevel() >= 30 then
      popForceToDownload()
    else
    
    end
  end
end