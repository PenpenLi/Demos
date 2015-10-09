--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-2-19

	yanchuan.xie@happyelements.com
]]

require "main.model.ItemUseQueueProxy";
require "main.controller.command.bagPopup.BagFullEffectCommand";

Handler_9_4 = class(MacroCommand);

function Handler_9_4:execute()
  print(".9.4.",recvTable["ItemId"],recvTable["ConfigId"]);
  
  if 1227==math.floor(recvTable["ItemId"]/1000) then

      local a=CommonPopup.new();
      a:initialize(StringUtils:getString4Popup(PopupMessageConstConfig.ID_108,{recvTable["ConfigId"]}),self,self.oncbf,nil,nil,nil,false,StringUtils:getButtonString4Popup(PopupMessageConstConfig.ID_108),true);
      sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(a);

  end
end

function Handler_9_4:oncbf()
  self:addSubCommand(OpenFunctionUICommand);
  self:complete(OpenFunctionNotification.new(OpenFunctionNotifications.OPEN_UI_BY_FUNCTION_ID,FunctionConfig.FUNCTION_ID_35));
end

Handler_9_4.new():execute();