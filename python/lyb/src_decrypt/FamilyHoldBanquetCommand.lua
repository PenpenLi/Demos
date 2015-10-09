
FamilyHoldBanquetCommand=class(Command);

function FamilyHoldBanquetCommand:ctor()
	self.class=FamilyHoldBanquetCommand;
end

function FamilyHoldBanquetCommand:execute(notification)
  log("------------FamilyHoldBanquetCommand")
  require "main.view.family.ui.familyBanquet.FamilyHoldBanquetMediator";

  require "main.controller.command.family.FamilyHoldBanquetCloseCommand";
  local familyHoldBanquetMediator=self:retrieveMediator(FamilyHoldBanquetMediator.name);


  if nil == familyHoldBanquetMediator then
    familyHoldBanquetMediator = FamilyHoldBanquetMediator.new();
    familyHoldBanquetMediator:intialize()
    self:registerMediator(familyHoldBanquetMediator:getMediatorName(),familyHoldBanquetMediator);
  end
  --放在tabel里，进战场
  self:observe(FamilyHoldBanquetCloseCommand);

  self:registerCommand(FamilyNotifications.FAMILY_HOLD_BANQUET_CLOSE_COMMAND,FamilyHoldBanquetCloseCommand)
  --将popUp层添加到界面上
  LayerManager:addLayerPopable(familyHoldBanquetMediator:getViewComponent());
end
