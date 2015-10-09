--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-1-31

	yanchuan.xie@happyelements.com
]]

require "main.view.achievement.AchievementMediator";
require "main.controller.command.achievement.AchievementGetBonusCommand";
require "main.controller.command.achievement.AchievementRequestDataCommand";
require "main.controller.command.achievement.AchievementCloseCommand";
require "main.controller.notification.AchievementNotification";

HomeToAchievementCommand=class(Command);

function HomeToAchievementCommand:ctor()
	self.class=HomeToAchievementCommand;
end

function HomeToAchievementCommand:execute(notification)
  --AchievementMediator
  
  self.achievementMediator=self:retrieveMediator(AchievementMediator.name);
  if nil==self.achievementMediator then
    self.achievementMediator=AchievementMediator.new();
    self:registerMediator(self.achievementMediator:getMediatorName(),self.achievementMediator);
    
    self:registerCommands();
    self:refreshUI(notification);
  end

  sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(self.achievementMediator:getViewComponent());
  self:observe(AchievementCloseCommand);
end

--更新UI
function HomeToAchievementCommand:refreshUI(notification)
  local achievementProxy=self:retrieveProxy(AchievementProxy.name);
  local bagProxy=self:retrieveProxy(BagProxy.name);
  local itemUseQueueProxy=self:retrieveProxy(ItemUseQueueProxy.name);
  self.achievementMediator:intializeUI(achievementProxy:getSkeleton(),achievementProxy,bagProxy,itemUseQueueProxy,notification);
end

function HomeToAchievementCommand:registerCommands()
  self:registerCommand(AchievementNotifications.ACHIEVEMENT_GET_BONUS,AchievementGetBonusCommand);
  self:registerCommand(AchievementNotifications.ACHIEVEMENT_REQUEST_DATA,AchievementRequestDataCommand);
  self:registerCommand(AchievementNotifications.ACHIEVEMENT_CLOSE,AchievementCloseCommand);
end