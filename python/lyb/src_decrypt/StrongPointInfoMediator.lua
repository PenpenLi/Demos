require "main.view.strongPointInfo.ui.StrongPointInfoPopup";

StrongPointInfoMediator=class(Mediator);

function StrongPointInfoMediator:ctor()
  self.class = StrongPointInfoMediator;
	self.viewComponent=StrongPointInfoPopup.new();
end

rawset(StrongPointInfoMediator,"name","StrongPointInfoMediator");

function StrongPointInfoMediator:initializeUI()
  self:getViewComponent():initializeUI();
end

function StrongPointInfoMediator:refreshEmployArrayData(battleEmployArray)
  self:getViewComponent():refreshEmployArrayData(battleEmployArray);
end

function StrongPointInfoMediator:onRegister()
  self:getViewComponent():initialize();
  self:getViewComponent():addEventListener("CLOSE_STORY_LINE_INFO", self.onStrongPointInfoClose, self);
  self:getViewComponent():addEventListener("ENTER_BUTTON_CLICK", self.onBattleButton, self);
  self:getViewComponent():addEventListener("MOP_UP_BUTTON", self.onMopUpButton, self);
  self:getViewComponent():addEventListener("openProNotice", self.onOpenPro, self);
  self:getViewComponent():addEventListener(MainSceneNotifications.TO_HEROTEAMSUB, self.openSubNotice, self);
  self:getViewComponent():addEventListener("ON_ITEM_TIP", self.onItemTip, self);
  self:getViewComponent():addEventListener("ON_ADD_TILI", self.onAddTili, self);
  self:getViewComponent():addEventListener("gotochongzhi", self.goToChongzhi, self);

  local proxyRetriever  = ProxyRetriever.new();

  self.userCurrencyProxy=proxyRetriever:retrieveProxy(UserCurrencyProxy.name);
  self.userProxy = proxyRetriever:retrieveProxy(UserProxy.name);
  self.bagProxy=proxyRetriever:retrieveProxy(BagProxy.name);
  self.countControlProxy=proxyRetriever:retrieveProxy(CountControlProxy.name);
end
function StrongPointInfoMediator:goToChongzhi()
  print("goToChongzhi")
  self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_VIP));
end
function StrongPointInfoMediator:onItemTip(event)
  self:sendNotification(TipNotification.new(TipNotifications.OPEN_TIP_COMMOND, event.data));
end
function StrongPointInfoMediator:onOpenPro(event)
  print("openSubNotice+++++++++++++++++")
  if HeroProPopupMediator and Facade.getInstance():retrieveMediator(HeroProPopupMediator.name) then
    sharedTextAnimateReward():animateStartByString("当前不能打开此界面");
  else
    local items = event.data;
    self:sendNotification(HeroHouseNotification.new(MainSceneNotifications.TO_HEROPRO,items));
  end
  --self:onClose();
  -- print("??????????????");
end
function StrongPointInfoMediator:refreshStrongPointInfo(strongPointId)
  self:getViewComponent():refreshStrongPointInfo(strongPointId);
end
function StrongPointInfoMediator:onStrongPointInfoClose(event)
  print("onStrongPointInfoClose");
  self:sendNotification(ShadowNotification.new(ShadowNotifications.CLOSE_STORYLINE_INFO_UI_COMMAND));
end
function StrongPointInfoMediator:onBattleButton(event)

  if GameVar.tutorStage ~= 0 and GameVar.tutorStage ~= TutorConfig.STAGE_99999 then
    if GameVar.tutorStage >= TutorConfig.STAGE_1012 then
      sendServerTutorMsg({})
    end
    -- GameVar.tutorStage = GameVar.tutorStage + 1;
    -- GameVar.tutorSmallStep = 0;
    -- sendServerTutorMsg({BooleanValue = 1})
  end

  local strongPointId = self:getViewComponent().strongPointId;

  print("onBattleButton, strongPointId", strongPointId);
  local storyLineId = analysis("Juqing_Guanka", strongPointId, "storyId")
  self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_BATTLE, {StrongPointId = strongPointId, storyLineId = storyLineId,battleType = BattleConfig.BATTLE_TYPE_1}));
end

function StrongPointInfoMediator:onMopUpButton(event)
  print("onMopUpButton");
  self:sendNotification(StrongPointInfoNotification.new(StrongPointInfoNotifications.OPEN_QUICK_BATTLE_UI_COMMOND, event.data));
end

function StrongPointInfoMediator:onRemove()
	self:getViewComponent().parent:removeChild(self:getViewComponent());
end

function StrongPointInfoMediator:openSubNotice(event)

    self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_HEROTEAMSUB,event.data));

end
function StrongPointInfoMediator:refreshData(RoundItemIdArray, StrongPointId)
    self.viewComponent:refreshData(RoundItemIdArray, StrongPointId);
end
function StrongPointInfoMediator:refreshCount(count, saoDangQuanCount)
  self:getViewComponent():refreshCount(count, saoDangQuanCount)
end
function StrongPointInfoMediator:refreshTili()
  self:getViewComponent():refreshTili()
end

function StrongPointInfoMediator:onAddTili()

  if GameVar.tutorStage ~= TutorConfig.STAGE_99999 then
    sendServerTutorMsg({})
    closeTutorUI();
  end
  onHandleAddTili({type = 2})
end
