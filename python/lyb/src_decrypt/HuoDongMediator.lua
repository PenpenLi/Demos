require "main.view.huoDong.ui.HuoDongPopup";
HuoDongMediator=class(Mediator);

function HuoDongMediator:ctor()
  self.class = HuoDongMediator;
  
end

rawset(HuoDongMediator,"name","HuoDongMediator");

function HuoDongMediator:initialize()
    self.viewComponent=HuoDongPopup.new();
    self:getViewComponent():initialize();
end

function HuoDongMediator:onRegister()
  self:initialize();
  self:getViewComponent():addEventListener("HuoDongClose", self.onHuoDongClose, self);
  self:getViewComponent():addEventListener("ON_ITEM_TIP", self.onItemTip, self);
  self:getViewComponent():addEventListener("huoDonggoToChongzhi", self.gotochongzhi, self);
end

function HuoDongMediator:initializeUI()

end

function HuoDongMediator:setData()
 self:getViewComponent():setData();
end

function HuoDongMediator:refreshData()
 self:getViewComponent():refreshData();
end


function HuoDongMediator:refreshRedDot(id)
 self:getViewComponent():refreshRedDot(id);
end

function HuoDongMediator:refreshRedDot2(id)
  self:getViewComponent():refreshRedDot2(id);
end


function HuoDongMediator:refreshBangDing(phoneNumber)
 self:getViewComponent():refreshBangDing(phoneNumber);
end

function HuoDongMediator:onHuoDongClose(event)
  self:sendNotification(HuoDongNotification.new(HuoDongNotifications.HUODONG_UI_CLOSE));
end
function HuoDongMediator:onRemove()
  if self:getViewComponent().parent then
    self:getViewComponent().parent:removeChild(self:getViewComponent());  
  end
end
function HuoDongMediator:onItemTip(event)
  print("ssss")
  self:sendNotification(TipNotification.new(TipNotifications.OPEN_TIP_COMMOND, event.data));
end

function HuoDongMediator:gotochongzhi(event)
  print("test  goToChongzhi")
  -- self:sendNotification(MainSceneNotification.new(MainSceneNotifications.OPEN_PLATFORM_CHARGE_UI_COMMAND));
  self:sendNotification(OpenFunctionNotification.new(OpenFunctionNotifications.OPEN_UI_BY_FUNCTION_ID,{functionid=2}));
end