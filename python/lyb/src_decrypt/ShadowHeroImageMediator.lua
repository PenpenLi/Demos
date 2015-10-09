require "main.view.shadow.ui.heroImage.ShadowHeroImagePopup";

ShadowHeroImageMediator=class(Mediator);

function ShadowHeroImageMediator:ctor()
  self.class = ShadowHeroImageMediator;
	self.viewComponent=ShadowHeroImagePopup.new();
end

rawset(ShadowHeroImageMediator,"name","ShadowHeroImageMediator");

function ShadowHeroImageMediator:initializeUI(strongPointId)
  self:getViewComponent():initializeUI(strongPointId);
end

function ShadowHeroImageMediator:onRegister()
  self:getViewComponent():initialize();
  self:getViewComponent():addEventListener("CLOSE_JUANZHOU_PARENT", self.onHerobiogClose, self);
  self:getViewComponent():addEventListener("HEROBIOG_QUICK_BATTLE", self.onHerobiogQuickBattle, self);
  self:getViewComponent():addEventListener("ON_ITEM_TIP", self.onItemTip, self);
  self:getViewComponent():addEventListener("ENTER_BUTTON_CLICK", self.onStrongPointInfo, self);
  self:getViewComponent():addEventListener("ON_ADD_TILI", self.onAddTili, self);
  self:getViewComponent():addEventListener(MainSceneNotifications.TO_HEROTEAMSUB, self.openSubNotice, self);
  self:getViewComponent():addEventListener("gotochongzhi", self.goToChongzhi, self);
end
function ShadowHeroImageMediator:goToChongzhi()
  print("goToChongzhi")
  self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_VIP));
end
function ShadowHeroImageMediator:onItemTip(event)
  self:sendNotification(TipNotification.new(TipNotifications.OPEN_TIP_COMMOND, event.data));
end
function ShadowHeroImageMediator:onStrongPointInfo(event)
  -- if GameVar.tutorStage == TutorConfig.STAGE_1007 then
  --   sendServerTutorMsg({BooleanValue = 0})
  -- end
  local strongPointId = event.data.strongPointId;

  -- local strongPointState = self.viewComponent.storyLineProxy:getStrongPointState(strongPointId);
  -- if strongPointState == 3 then
  --   local duiguaPos = analysisByName("Juqing_Guankaduihua", "paramId",strongPointId);
  --   for k, v in pairs(duiguaPos)do
  --      if v.weizhi == 1 then
  --       print("function ShadowHeroImageMediator:onStrongPointInfo v.id", v.id)
  --       self:sendNotification(TaskNotification.new(TaskNotifications.OPEN_MODAL_DIALOG_COMMOND, {isBattleDialog = false, strongPointId = strongPointId, dialogTaskId = v.id, enterBattle = true, battleType = BattleConfig.BATTLE_TYPE_10}));
  --      end
  --   end
  -- else
    print("battleType = 10, strongPointId", strongPointId)
    self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_BATTLE, {StrongPointId = strongPointId,battleType = BattleConfig.BATTLE_TYPE_10}));
  -- end
end
function ShadowHeroImageMediator:refreshData(RoundItemIdArray, StrongPointId)
    self.viewComponent:refreshData(RoundItemIdArray, StrongPointId);
end
function ShadowHeroImageMediator:refreshCount(Count, saoDangQuanCount)
  self:getViewComponent():refreshCount(Count, saoDangQuanCount)
end
function ShadowHeroImageMediator:onHerobiogClose(event)
  self:sendNotification(ShadowNotification.new(ShadowNotifications.CLOSE_HEROIMAGE_UI_COMMAND));
end
function ShadowHeroImageMediator:onOpenHeroBiog(event)
  self:sendNotification(ShadowNotification.new(ShadowNotifications.OPEN_HEROIMAGE_UI_COMMAND, {heroId = event.data.ID}));
end

function ShadowHeroImageMediator:onRemove()
	self:getViewComponent().parent:removeChild(self:getViewComponent());
end

function ShadowHeroImageMediator:refreshTili()
  self:getViewComponent():refreshTili()
end
function ShadowHeroImageMediator:refreshInfo()
  self:getViewComponent():refreshInfo()
end
function ShadowHeroImageMediator:openSubNotice(event)
  print("+++++++++++++++++++++++openSubNotice")
  self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_HEROTEAMSUB,event.data));
end
function ShadowHeroImageMediator:onAddTili()

  if GameVar.tutorStage ~= TutorConfig.STAGE_99999 then
    sendServerTutorMsg({})
    closeTutorUI();
  end
  onHandleAddTili({type = 2})
end
function ShadowHeroImageMediator:showNewHeroEffect()
  self:getViewComponent():showNewHeroEffect();
end
