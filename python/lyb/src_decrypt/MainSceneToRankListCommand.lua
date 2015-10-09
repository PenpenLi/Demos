MainSceneToRankListCommand=class(Command);

function MainSceneToRankListCommand:ctor()
	self.class=MainSceneToRankListCommand;
end

function MainSceneToRankListCommand:execute()
  self:require();
  --RankListMediator
  self.rankListMediator=self:retrieveMediator(RankListMediator.name);
  if self.rankListMediator then
    return;
  end
  if nil==self.rankListMediator then
    self.rankListMediator=RankListMediator.new();
    self:registerMediator(self.rankListMediator:getMediatorName(),self.rankListMediator);
    
    self:registerCommands();
    -- self:refreshUI();
  end

  LayerManager:addLayerPopable(self.rankListMediator:getViewComponent());
  -- sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(self.rankListMediator:getViewComponent());
  -- self:observe(RankListCloseCommand);
  hecDC(3,11,1);
end

--更新UI
-- function MainSceneToRankListCommand:refreshUI()
--   local rankListProxy=self:retrieveProxy(RankListProxy.name);
--   local chatListProxy=self:retrieveProxy(ChatListProxy.name);
--   local buddyListProxy=self:retrieveProxy(BuddyListProxy.name);
--   local userProxy=self:retrieveProxy(UserProxy.name);
--   self.rankListMediator:intializeUI(rankListProxy:getSkeleton(),rankListProxy,chatListProxy,buddyListProxy,userProxy);
-- end

function MainSceneToRankListCommand:registerCommands()
  self:registerCommand(RankListNotifications.RANK_LIST_REQUEST_DATA,RankListRequestDataCommand);
  self:registerCommand(RankListNotifications.RANK_LIST_CLOSE,RankListCloseCommand);
end

function MainSceneToRankListCommand:require()
  require "main.view.rankList.RankListMediator";
  require "main.controller.command.rankList.RankListRequestDataCommand";
  require "main.controller.command.rankList.RankListCloseCommand";
  require "main.controller.notification.RankListNotification";
end