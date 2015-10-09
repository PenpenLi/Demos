require "main.view.arena.JingjichangPopup";
JingjichangMediator=class(Mediator);

function JingjichangMediator:ctor()
  self.class = JingjichangMediator;
	self.viewComponent=JingjichangPopup.new();
end

rawset(JingjichangMediator,"name","JingjichangMediator");


--更新初始化
function JingjichangMediator:refreshDefData()
  self:getViewComponent():refreshDefData();
end

function JingjichangMediator:refreshData()
  self:getViewComponent():refreshData();
end

function JingjichangMediator:refreshUserData()
  self:getViewComponent():refreshUserData();
end

function JingjichangMediator:refreshTimesData(countControlProxy)
  self:getViewComponent():refreshTimesData(countControlProxy);
end

function JingjichangMediator:refreshUpdateTimesData()
  self:getViewComponent():refreshUpdateTimesData();
end

function JingjichangMediator:refreshTimeData()
  self:getViewComponent():refreshTimeData();
end

function JingjichangMediator:refreshRankingData()
  self:getViewComponent():refreshRankingData();
end

function JingjichangMediator:refreshHeroDetailData(userId, formationId, placeIDArray)
  self:getViewComponent():refreshHeroDetailData(userId, formationId, placeIDArray);
end

function JingjichangMediator:onRecharge(event)
  self:sendNotification(MainSceneNotification.new(MainSceneNotifications.OPEN_PLATFORM_CHARGE_UI_COMMAND));
end

function JingjichangMediator:onRegister()
    self:getViewComponent():addEventListener("ENTER_BATTLE_FIELD",self.enterBattleField,self)
    self:getViewComponent():addEventListener("closeNotice",self.onArenaClose,self);
    self:getViewComponent():addEventListener("TO_SHOP_TWO",self.toShopTwoTap,self);
    self:getViewComponent():addEventListener("to_Attack_Team",self.toAttackTeam,self);
    self:getViewComponent():addEventListener("to_Defense_Team",self.toDefenseTeam,self);
    -- self:getViewComponent():addEventListener("TO_REFRESH_REDDOT",self.onRefreshReddot,self);
    self:getViewComponent():addEventListener("TO_MAINSCENE_VIP",self.onOpenVIPUI,self);
    self:getViewComponent():addEventListener("vip_recharge",self.onRecharge,self);
end

function JingjichangMediator:enterBattleField(event)
  self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_BATTLE, event.data));
end

function JingjichangMediator:onRemove()
  if self:getViewComponent().parent then
	   self:getViewComponent().parent:removeChild(self:getViewComponent());
  end
end

function JingjichangMediator:onOpenVIPUI(event)
  self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_VIP));
end

function JingjichangMediator:onArenaClose()

  if GameVar.tutorStage == TutorConfig.STAGE_1016 then
    sendServerTutorMsg({})
    closeTutorUI();
  end
  self:sendNotification(ArenaNotification.new(ArenaNotifications.ARENA_CLOSE_COMMOND));
end

function JingjichangMediator:toShopTwoTap()
    self:sendNotification(ShopTwoNotification.new(ShopTwoNotifications.OPEN_SHOPTWO_UI,{shopType = 4}));
end

function JingjichangMediator:toAttackTeam(event)
    self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_HEROTEAMSUB,event.data));
end

function JingjichangMediator:toDefenseTeam(event)
    self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_HEROTEAMSUB,event.data));
end

-- function JingjichangMediator:onRefreshReddot(event)
--   self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_REFRESH_REDDOT,{type=FunctionConfig.FUNCTION_ID_26}));
-- end
