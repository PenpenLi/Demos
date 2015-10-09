BattleOverMediator = class(Mediator);

function BattleOverMediator:ctor()
    self.class = BattleOverMediator;
    require "main.view.battleScene.ui.BattleOverUI"
    self.viewComponent = BattleOverUI.new();
end

rawset(BattleOverMediator,"name","BattleOverMediator");


function BattleOverMediator:onRegister()
  self.viewComponent:addEventListener("CLOSE_BATTLE_OVER", self.onRemoveUI, self);
  self.viewComponent:addEventListener("TO_LOTTERY", self.toLottery, self);
  self.viewComponent:addEventListener("Continue_Battle", self.continueBattle, self);
  self.viewComponent:addEventListener("TO_FAILURE", self.onClickHelpButton, self);
  self.viewComponent:addEventListener("CLOSE_BATTLE_OVER_COMMAND", self.closeBattleOver, self);
  self.viewComponent:addEventListener("CLICK_FUNC_BTN", self.onClickButton, self);
  self.viewComponent:addEventListener("ON_ITEM_TIP", self.onItemTip, self);
end
function BattleOverMediator:onItemTip(event)
  self:sendNotification(TipNotification.new(TipNotifications.OPEN_TIP_COMMOND, event.data));
end
function BattleOverMediator:closeBattleOver(event)
	self:sendNotification(BattleSceneNotification.new(BattleSceneNotifications.CLOSE_BATTLEOVER_MEDIATOR));
end
function BattleOverMediator:onClickHelpButton(event)
	self:sendNotification(OpenFunctionNotification.new(OpenFunctionNotifications.OPEN_UI_BY_FUNCTION_ID,event.data));

end

function BattleOverMediator:onInit(lastAttackData_7_6,battleProxy)
  self.battleProxy = battleProxy;
  self.viewComponent:onInitData(lastAttackData_7_6,battleProxy);--,userCurrencyProxy,countProxy,bagProxy,userProxy);
  
end

function BattleOverMediator:onRemoveUI(event)
  -- print("BattleOverMediator")
  self:sendNotification(BattleSceneNotification.new(BattleSceneNotifications.TO_MAINSCENE, event.data));
  
end

function BattleOverMediator:onRemove()
  if self.viewComponent.parent then
      self.viewComponent.parent:removeChild(self.viewComponent);  
  end
end

function BattleOverMediator:continueBattle(event)
	self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_BATTLE, event.data));
end

function BattleOverMediator:toLottery(event)

	self:sendNotification(BattleSceneNotification.new(BattleSceneNotifications.TO_LOTTERY, event.data));
end
