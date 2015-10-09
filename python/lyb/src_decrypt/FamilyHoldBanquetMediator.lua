
require "main.view.family.ui.familyBanquet.FamilyHoldBanquetPopup";

FamilyHoldBanquetMediator=class(Mediator);

function FamilyHoldBanquetMediator:ctor()
  self.class=FamilyHoldBanquetMediator;
  self.viewComponent=FamilyHoldBanquetPopup.new();
end

rawset(FamilyHoldBanquetMediator,"name","FamilyHoldBanquetMediator");

function FamilyHoldBanquetMediator:intialize()
  self:getViewComponent():initialize();
end

--FamilyBanquetCommand里的self:registerCommand(FamilyNotifications.FAMILY_BANQUET_CLOSE_COMMAND,FamilyBanquetCloseCommand)让此方法执行
function FamilyHoldBanquetMediator:onRegister()

  self:getViewComponent():addEventListener("FamilyHoldBanquetClose",self.onClose,self);
  self:getViewComponent():addEventListener("FamilyHoldBanquetEnterBanquet",self.setBanqueType,self);
  self:getViewComponent():addEventListener("FamilyHoldBanquetToChongZhi",self.gotoChongZhi,self);
end

--进入到充值界面
function FamilyHoldBanquetMediator:gotoChongZhi()
  self:sendNotification(OpenFunctionNotification.new(OpenFunctionNotifications.OPEN_UI_BY_FUNCTION_ID,{functionid=2}));
end

--进入到温酒界面
function FamilyHoldBanquetMediator:holdBanquet()
  
  self:sendNotification(FamilyNotification.new(FamilyNotifications.FAMILY_BANQUET_COMMAND,self.eventData));
  hecDC(3, 25, 1, {banquetType = self.eventData.Type});
  self.viewComponent:closeUI();
end


-- function FamilyHoldBanquetMediator:refreshjuBanCount()
--   self.viewComponent:refreshjuBanCount();
-- end

function FamilyHoldBanquetMediator:setBanqueType(event)
  self.eventData = event.data;
end

--点击关闭按钮时候，在popUp里执行
function FamilyHoldBanquetMediator:onClose()

  self:sendNotification(FamilyNotification.new(FamilyNotifications.FAMILY_HOLD_BANQUET_CLOSE_COMMAND));
end

function FamilyHoldBanquetMediator:onRemove()
  if self:getViewComponent().parent then
    self:getViewComponent().parent:removeChild(self:getViewComponent());
  end
end



-- function FamilyHoldBanquetMediator:refreshMediatorviewComponentWithCount(count)
--    print("FamilyHoldBanquetMediator:refreshMediatorviewComponentWithCount count",count);
--     self.viewComponent:refreshHoldCount(count);
-- end