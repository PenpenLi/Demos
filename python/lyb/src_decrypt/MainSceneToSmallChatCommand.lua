--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

require "main.view.smallChat.SmallChatMediator";

MainSceneToSmallChatCommand=class(Command);

function MainSceneToSmallChatCommand:ctor()
	self.class=MainSceneToSmallChatCommand;
end

function MainSceneToSmallChatCommand:execute()
  self:require();
  --SmallChatMediator
  self.smallChatMediator=self:retrieveMediator(SmallChatMediator.name);
  if nil==self.smallChatMediator then
    self.smallChatMediator=SmallChatMediator.new();
    self:registerMediator(self.smallChatMediator:getMediatorName(),self.smallChatMediator);
    
    self:refreshUI();
    self:registerCommands();
  end  
  sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_UI):addChild(self.smallChatMediator:getViewComponent());
end

--更新AvatarUI
function MainSceneToSmallChatCommand:refreshUI()
  local smallChatProxy=self:retrieveProxy(SmallChatProxy.name);
  local openFunctionProxy=self:retrieveProxy(OpenFunctionProxy.name);
  self.smallChatMediator:intializeAvatarUI(smallChatProxy:getSkeleton(),smallChatProxy,openFunctionProxy);
end

function MainSceneToSmallChatCommand:registerCommands()
  self:registerCommand(SmallChatNotifications.SMALL_CHAT_MENU,SmallChatMenuCommand);
  self:registerCommand(SmallChatNotifications.SMALL_CHAT_CLOSE,SmallChatCloseCommand);
end

function MainSceneToSmallChatCommand:require()
  require "main.controller.notification.SmallChatNotification";
  require "main.controller.command.smallChat.SmallChatMenuCommand";
  require "main.controller.command.smallChat.SmallChatCloseCommand";
end