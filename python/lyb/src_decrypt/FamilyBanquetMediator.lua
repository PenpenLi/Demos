
require "main.view.family.ui.familyBanquet.FamilyBanquetPopup";

FamilyBanquetMediator=class(Mediator);

function FamilyBanquetMediator:ctor()
  self.class=FamilyBanquetMediator;
  self.viewComponent=FamilyBanquetPopup.new();
end

rawset(FamilyBanquetMediator,"name","FamilyBanquetMediator");

function FamilyBanquetMediator:intialize(type, banquetID)
  self.banquetID = banquetID;
  self.type = type;
end

function FamilyBanquetMediator:setTypeID(type, banquetID)
  self.banquetID = banquetID;
  self.type = type;
end

function FamilyBanquetMediator:initializeViewComponent()
  
  self:getViewComponent():initialize(self.type, self.banquetID);

  if self.type ==1 or self.type ==2 then
    LayerManager:addLayerPopable(self.viewComponent);
    end
end

--FamilyBanquetCommand里的self:registerCommand(FamilyNotifications.FAMILY_BANQUET_CLOSE_COMMAND,FamilyBanquetCloseCommand)让此方法执行
function FamilyBanquetMediator:onRegister()
  self:getViewComponent():addEventListener("FamilyBanquetClose",self.onClose,self,index);
  self:getViewComponent():addEventListener("FamilyBanquetToChongZhi",self.gotoChongZhi,self);
end

function FamilyBanquetMediator:gotoChongZhi()
  self:sendNotification(OpenFunctionNotification.new(OpenFunctionNotifications.OPEN_UI_BY_FUNCTION_ID,{functionid=2}));
end

--点击关闭按钮时候，在popUp里执行
function FamilyBanquetMediator:onClose(event,index)
  self:sendNotification(FamilyNotification.new(FamilyNotifications.FAMILY_BANQUET_CLOSE_COMMAND));
end

function FamilyBanquetMediator:onRemove()
  if self:getViewComponent().parent then
    self:getViewComponent().parent:removeChild(self:getViewComponent());
  end
end

function FamilyBanquetMediator:refreshMediatorviewComponentWithUHIU(UserIdNameArray, HeatWineArray, ID, UserId)

   self.viewComponent:refreshUserHeadAndHeatRecord(UserIdNameArray, HeatWineArray, ID, UserId);
end

function FamilyBanquetMediator:refreshMediatorviewComponentWithUI(UserIdNameArray, ID)

   self.viewComponent:refreshUserHead(UserIdNameArray, ID);
end

function FamilyBanquetMediator:refreshMediatorviewComponentWithRPI(remainSeconds, physicalPower, ID)
   
   self.viewComponent:refreshTimeAndPhysicalPower(remainSeconds, physicalPower, ID);
   
end