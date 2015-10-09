require "main.view.arena.ui.ArenaPopup";
ArenaMediator=class(Mediator);

function ArenaMediator:ctor()
  self.class = ArenaMediator;
	self.viewComponent=ArenaPopup.new();
end

rawset(ArenaMediator,"name","ArenaMediator");

function ArenaMediator:intializeArenaUI()

end


--更新初始化
function ArenaMediator:refreshDefData()
  self:getViewComponent():refreshDefData();
end

function ArenaMediator:refreshData()
  self:getViewComponent():refreshData();
end

function ArenaMediator:refreshUserData()
  self:getViewComponent():refreshUserData();
end

function ArenaMediator:refreshTimesData(countControlProxy)
  self:getViewComponent():refreshTimesData(countControlProxy);
end

function ArenaMediator:refreshUpdateTimesData()
  self:getViewComponent():refreshUpdateTimesData();
end

function ArenaMediator:refreshTimeData()
  self:getViewComponent():refreshTimeData();
end

function ArenaMediator:refreshRankingData()
  self:getViewComponent():refreshRankingData();
end

function ArenaMediator:refreshHeroDetailData(userId)
  self:getViewComponent():refreshHeroDetailData(userId);
end

function ArenaMediator:onRegister()
    self:getViewComponent():addEventListener("ENTER_BATTLE_FIELD",self.enterBattleField,self)
    self:getViewComponent():addEventListener("closeNotice",self.onArenaClose,self);
    self:getViewComponent():addEventListener("TO_SHOP_TWO",self.toShopTwoTap,self);
    self:getViewComponent():addEventListener("to_Attack_Team",self.toAttackTeam,self);
    self:getViewComponent():addEventListener("to_Defense_Team",self.toDefenseTeam,self);
    -- self:getViewComponent():addEventListener("TO_REFRESH_REDDOT",self.onRefreshReddot,self);
    self:getViewComponent():addEventListener("TO_MAINSCENE_VIP",self.onOpenVIPUI,self);
end

function ArenaMediator:enterBattleField(event)
  self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_BATTLE, event.data));
end

function ArenaMediator:onRemove()
  if self:getViewComponent().parent then
	   self:getViewComponent().parent:removeChild(self:getViewComponent());
  end
end

function ArenaMediator:onOpenVIPUI(event)
  self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_VIP));
end

function ArenaMediator:onArenaClose()
  self:sendNotification(ArenaNotification.new(ArenaNotifications.ARENA_CLOSE_COMMOND));
end

function ArenaMediator:toShopTwoTap()
    self:sendNotification(ShopTwoNotification.new(ShopTwoNotifications.OPEN_SHOPTWO_UI,{shopType = 4}));
end

function ArenaMediator:toAttackTeam(event)
    self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_HEROTEAMSUB,event.data));
end

function ArenaMediator:toDefenseTeam(event)
    self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_HEROTEAMSUB,event.data));
end

-- function ArenaMediator:onRefreshReddot(event)
--   self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_REFRESH_REDDOT,{type=FunctionConfig.FUNCTION_ID_26}));
-- end
