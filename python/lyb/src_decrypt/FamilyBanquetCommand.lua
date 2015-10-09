
FamilyBanquetCommand=class(Command);

function FamilyBanquetCommand:ctor()
	self.class=FamilyBanquetCommand;
end

function FamilyBanquetCommand:execute(notification)
  require "main.view.family.ui.familyBanquet.FamilyBanquetMediator";

  require "main.controller.command.family.FamilyBanquetCloseCommand";
  
  local data=notification:getData();

  local familyBanquetMediator=self:retrieveMediator(FamilyBanquetMediator.name);
  
  if nil == familyBanquetMediator then

    familyBanquetMediator=FamilyBanquetMediator.new();
    
    self:registerMediator(familyBanquetMediator:getMediatorName(),familyBanquetMediator);

  end
  familyBanquetMediator:setTypeID(data.Type, data.ID);
  --放在tabel里，进战场
  self:observe(FamilyBanquetCloseCommand);

  --在这里让FamilyBanquetMediator:onRegister()执行
  self:registerCommand(FamilyNotifications.FAMILY_BANQUET_CLOSE_COMMAND,FamilyBanquetCloseCommand)

end


