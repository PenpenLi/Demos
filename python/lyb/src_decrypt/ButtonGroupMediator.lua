require "main.view.mainScene.component.ui.ButtonGroupUI";

ButtonGroupMediator = class(Mediator)

function ButtonGroupMediator:ctor()
	self.class = ButtonGroupMediator
end

rawset(ButtonGroupMediator,"name","ButtonGroupMediator")

function ButtonGroupMediator:onRegister()
	self.viewComponent = ButtonGroupUI.new()
end

function ButtonGroupMediator:initialize()
  self.viewComponent:initialize();
  self.viewComponent:setScale(0.9)

	self.viewComponent.renwuButtonDO:addEventListener(DisplayEvents.kTouchBegin,self.onTipsBegin,self);

	self.viewComponent.yingxiongDO:addEventListener(DisplayEvents.kTouchBegin,self.onTipsBegin,self);
	self.viewComponent.beibaoDO:addEventListener(DisplayEvents.kTouchBegin,self.onTipsBegin,self);
  self.viewComponent.bangpaiDO:addEventListener(DisplayEvents.kTouchBegin,self.onTipsBegin,self);
  
  local proxyRetriever  = ProxyRetriever.new();
  self.userProxy =  proxyRetriever:retrieveProxy(UserProxy.name);
end

function ButtonGroupMediator:onTipsBegin(event)
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

function ButtonGroupMediator:onTipsEnd(event)

  local targetName = event.target.name
  print("MainSceneMediator:onTipsEnd",targetName)
  if targetName == "beibao" then
    MusicUtils:playEffect(7,false)
    ---- test spine cartoon
    -- local mainSize = Director:sharedDirector():getWinSize();
    -- local backHalfAlphaLayer = LayerColorBackGround:getBackGround()
    -- sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_EFFECTS):addChild(backHalfAlphaLayer)    

    -- require "core.utils.SpineCartoon"
    -- local aaa = SpineCartoon.new()
    -- local function endcallBackFunc()
    --   -- sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_EFFECTS):removeChild(aaa)
    --   -- log("endcallBackFunc--------------")
    -- end

    -- aaa:create("skeleton",endcallBackFunc,1)
    -- aaa.sprite:setAnchorPoint(CCPointMake(0.5, 0.5));      
    -- aaa:setPositionXY(mainSize.width/2,mainSize.height/2 -100)
    -- sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_EFFECTS):addChild(aaa)

    self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_BAG));
    
  elseif targetName == "yingxiong" then
    MusicUtils:playEffect(7,false)

    self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_HEROHOUSE));
    self:sendNotification(MainSceneNotification.new(HeroHouseNotifications.HERO_RED_DOT_REFRESH));
  elseif targetName == "qianghua" then
    self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_STRENGTHEN));
  elseif targetName == "renwu" then
    MusicUtils:playEffect(7,false)
    -- recvTable["Level"]=13;
    -- recvTable["Vip"]=0;
    -- recvTable["Experience"]=100;
    -- recvMessage(1003,17);

    self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_TASK));    
  elseif targetName == "bangpai" then

    if self.coldTimer then
      return;
    end
    local function reviseTimer()
      CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.coldTimer);
      self.coldTimer = nil;
    end
    self.coldTimer = Director:sharedDirector():getScheduler():scheduleScriptFunc(reviseTimer, 2, false)

    MusicUtils:playEffect(7,false)
    if self.userProxy:getHasFamily() then
      sendMessage(27,2)
    else
      self:sendNotification(MainSceneNotification.new(MainSceneNotifications.MAIN_SCENE_TO_FAMILY));
    end
  end

  local effect = event.target:getChildByName("effect");
  if effect then
    effect:setScale(1)
  end

  if event.target.imageButton then
    event.target.imageButton:setScale(1);
  else
    event.target:setScale(1);
  end
  event.target:removeEventListener(DisplayEvents.kTouchEnd,self.onTipsEnd,self,data);
end

function ButtonGroupMediator:openMenu(boo)
  self:getViewComponent():openMenu(boo);
end

function ButtonGroupMediator:openButtons(displayMenuVTable)
  print("+++++++++++++++++ButtonGroupMediator displayMenuVTable's lenght is ", Utils:getItemCount(displayMenuVTable))
  self:getViewComponent():openButtons(displayMenuVTable);
end

function ButtonGroupMediator:onRemove()
	if self:getViewComponent().parent then
    	self:getViewComponent().parent:removeChild(self:getViewComponent());
  end
end

function ButtonGroupMediator:getTargetButtonPosition(functionId)
  return self:getViewComponent():getTargetButtonPosition(functionId);
end

function ButtonGroupMediator:refreshRenwu()
  self.viewComponent:refreshRenwu()
end
