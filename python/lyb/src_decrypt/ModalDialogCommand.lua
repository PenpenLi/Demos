
ModalDialogCommand=class(Command);

function ModalDialogCommand:ctor()
  self.class=ModalDialogCommand;
end

function ModalDialogCommand:execute(notification)

  require "main.view.modalDialog.ModalDialogMediator";
  require "main.model.UserProxy";
   require "main.controller.command.task.ModalDialogCloseCommand";
  local modalDialogMed=self:retrieveMediator(ModalDialogMediator.name);
  local taskProxy=self:retrieveProxy(TaskProxy.name);
  local userProxy = self:retrieveProxy(UserProxy.name)
  local bagProxy=self:retrieveProxy(BagProxy.name);
  local itemUseQueueProxy=self:retrieveProxy(ItemUseQueueProxy.name);

  if nil == modalDialogMed then
    modalDialogMed=ModalDialogMediator.new();
    self:registerMediator(modalDialogMed:getMediatorName(),modalDialogMed);
  end
  self:observe(ModalDialogCloseCommand);

  notification.data.career = userProxy.career
  notification.data.userName = userProxy.userName


  if not notification.data.isBattleDialog then
      print("taskId", notification.data.taskId)
      local dialogData = {strongPointId = notification.data.strongPointId, enterBattle = notification.data.enterBattle, battleType = notification.data.battleType, dialogTaskId = notification.data.dialogTaskId, doNotSendToServer = notification.data.doNotSendToServer}
      modalDialogMed:refreshModalDialog(dialogData);
      LayerManager:addLayerPopable(modalDialogMed:getViewComponent());
      local tempStage = GameVar.tutorStage
      if GameVar.tutorStage ~= TutorConfig.STAGE_99999 then
        closeTutorUI(false);
      end
      GameVar.tutorStage = tempStage;
  else
      modalDialogMed:refreshModalDialogForBattle(notification.data);
      if not notification.data.isBattleScript then
        if not sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_ASSIST) then return end
        sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_ASSIST):addChild(modalDialogMed:getViewComponent());
      else
        if not sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_SHIFT_SCENE) then return end
        sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_SHIFT_SCENE):addChild(modalDialogMed:getViewComponent());
      end
  end
  self:registerTaskCommands();

end

function ModalDialogCommand:registerTaskCommands()
  self:registerCommand(TaskNotifications.MODAL_DIALOG_CLOSE_COMMOND, ModalDialogCloseCommand);
end