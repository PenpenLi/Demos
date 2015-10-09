require "main.view.modalDialog.ui.ModalDialogUI";

ModalDialogMediator=class(Mediator);

function ModalDialogMediator:ctor()
  self.class = ModalDialogMediator;
  self.viewComponent = ModalDialogUI.new();
end

rawset(ModalDialogMediator,"name","ModalDialogMediator");

function ModalDialogMediator:onOpenBagUI(event) 
  self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_AVATAR))
end

function ModalDialogMediator:onOpenUI(event)
	self:sendNotification(OpenFunctionNotification.new(OpenFunctionNotifications.OPEN_UI_BY_FUNCTION_ID, event.data))
end

function ModalDialogMediator:onBattleField(event)
  self:sendNotification(TaskNotification.new(TaskNotifications.MODAL_DIALOG_CLOSE_COMMOND))
  if event.data.isTutorAfterBattle then
    self:sendNotification(BattleSceneNotification.new(BattleSceneNotifications.TO_MAINSCENE, {battleType = BattleConfig.BATTLE_TYPE_13}));
  else
    if event.data.isGreenHand then
      self:sendNotification(BattleSceneNotification.new(BattleSceneNotifications.BATTLE_DIALOG_OVER,event.data))
    end
    -- self:sendNotification(BattleSceneNotification.new(BattleSceneNotifications.BATTLE_DIALOG_OVER,event.data))
  end
end

function ModalDialogMediator:refreshModalDialog(data)
		self:getViewComponent():refreshModalDialog(data);
end

function ModalDialogMediator:refreshModalDialogForBattle(data)
    self:getViewComponent():refreshModalDialogForBattle(data);
end

function ModalDialogMediator:onRegister()
  self:getViewComponent():initialize();
  self:getViewComponent():addEventListener("MODAL_DIALOG_CLOSE", self.onModalDialogClose, self);
  self:getViewComponent():addEventListener("OPEN_UI_EVENT", self.onOpenUI, self);
  self:getViewComponent():addEventListener("BATTLE_DIALOG_EVENT", self.onBattleField, self);
  self:getViewComponent():addEventListener("ENTER_BATTLE_EVENT",self.onEnterBattle,self)
end
function ModalDialogMediator:onEnterBattle(event)
  print("event.data.strongPointId",event.data.strongPointId)
  local storyLineId = math.floor(event.data.strongPointId/100);
  self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_BATTLE, {StrongPointId = event.data.strongPointId, storyLineId = storyLineId,battleType = event.data.battleType}));
end
function ModalDialogMediator:onModalDialogClose(event)
    self:getViewComponent():closeUI()
    self:sendNotification(TaskNotification.new(TaskNotifications.MODAL_DIALOG_CLOSE_COMMOND))
end

function ModalDialogMediator:onRemove()
    if self:getViewComponent().parent then
    self:getViewComponent().parent:removeChild(self:getViewComponent());
    end
end