require "main.view.mainScene.component.ui.LeftButtonGroupUI";

LeftButtonGroupMediator = class(Mediator)

function LeftButtonGroupMediator:ctor()
	self.class = LeftButtonGroupMediator
end

rawset(LeftButtonGroupMediator,"name","LeftButtonGroupMediator")

function LeftButtonGroupMediator:onRegister()
	self.viewComponent = LeftButtonGroupUI.new()

end

function LeftButtonGroupMediator:initialize()
  self.viewComponent:initialize();

  self.viewComponent:setScale(0.8)
	--
	self.viewComponent.langyalingDO:addEventListener(DisplayEvents.kTouchBegin,self.onTipsBegin,self);
	self.viewComponent.youjianDO:addEventListener(DisplayEvents.kTouchBegin,self.onTipsBegin,self);
	self.viewComponent.qiandaoDO:addEventListener(DisplayEvents.kTouchBegin,self.onTipsBegin,self);
  self.viewComponent.shangchengDO:addEventListener(DisplayEvents.kTouchBegin,self.onTipsBegin,self);
  self.viewComponent.haoyouDO:addEventListener(DisplayEvents.kTouchBegin,self.onTipsBegin,self);
end
function LeftButtonGroupMediator:onTipsBegin(event)
  event.target:addEventListener(DisplayEvents.kTouchEnd,self.onTipsEnd,self);
  
  if event.target.imageButton then
    event.target.imageButton:setScale(0.88);
  else
    local targetName = event.target.name
    if targetName ~= "tiliProgressBar" and targetName ~= "liaotiandi" then
        event.target:setScale(0.88);
    else
        event.target:setScale(0.99);
    end
  end
  local effect = event.target:getChildByName("effect");
  if effect then
    effect:setScale(0.88)
  end
end

function LeftButtonGroupMediator:onTipsEnd(event)

  local targetName = event.target.name
  print("MainSceneMediator:onTipsEnd",targetName)
  if targetName == "langyaling" then

    self:sendNotification(LangyalingNotification.new(LangyalingNotifications.POPUP_UI_LANGYALING))
  elseif targetName == "youjian" then
    -- ToAddFunctionOpenCommand.new():execute(MainSceneNotification.new(MainSceneNotifications.TO_ADD_FUNCTION_OPEN_UI, {functionId = 12}))
    self:sendNotification(MainSceneNotification.new(MainSceneNotifications.MAIN_SCENE_TO_MAIL));
  elseif targetName == "qiandao" then
    sendMessage(24,4)
    self:sendNotification(QianDaoNotification.new(QianDaoNotifications.OPEN_QIANDAO_UI));  
  elseif targetName == "shangcheng" then
      -- self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_TIANXIANG_UI_COMMAND))
    self:sendNotification(ShopTwoNotification.new(ShopTwoNotifications.OPEN_SHOPTWO_UI));  
  elseif targetName == "haoyou" then
    self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_BUDDY));            
  end
  
  if event.target.imageButton then
    event.target.imageButton:setScale(1);
  else
    event.target:setScale(1);
  end

  local effect = event.target:getChildByName("effect");
  if effect then
    effect:setScale(1)
  end

  MusicUtils:playEffect(7,false)

  event.target:removeEventListener(DisplayEvents.kTouchEnd,self.onTipsEnd,self,data);
end
function LeftButtonGroupMediator:openButtons(displayMenuVTable)
  print("+++++++++++++++++displayMenuVTable's lenght is ", Utils:getItemCount(displayMenuVTable))
  self:getViewComponent():openButtons(displayMenuVTable);
end
function LeftButtonGroupMediator:onRemove()
	if self:getViewComponent().parent then
    	self:getViewComponent().parent:removeChild(self:getViewComponent());
  	end
  	--self:getViewComponent():dispose4End();
end
function LeftButtonGroupMediator:getTargetButtonPosition(functionId)
  local returnData = self:getViewComponent():getTargetButtonPosition(functionId);
  print("returnData.x, returnData.y", returnData.x, returnData.y)
  return returnData;
end

-- 刷新琅琊令
function LeftButtonGroupMediator:refreshLangyaling()
  self:getViewComponent():refreshLangyaling();
end
function LeftButtonGroupMediator:refreshMail(value)
  self:getViewComponent():refreshMail(value);
end



function LeftButtonGroupMediator:refreshQianDao()
  self:getViewComponent():refreshQianDao();
end

function LeftButtonGroupMediator:refreshRedDot()
  self:refreshQianDao();
  self:refreshLangyaling();
end