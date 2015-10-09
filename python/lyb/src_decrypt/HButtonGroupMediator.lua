require "main.view.mainScene.component.ui.HButtonGroupUI";

HButtonGroupMediator = class(Mediator)

function HButtonGroupMediator:ctor()
	self.class = HButtonGroupMediator
end

rawset(HButtonGroupMediator,"name","HButtonGroupMediator")

function HButtonGroupMediator:onRegister()
	self.viewComponent = HButtonGroupUI.new()

end

function HButtonGroupMediator:initialize()
    self.viewComponent:initialize();
  self.viewComponent.juqingDO:addEventListener(DisplayEvents.kTouchBegin,self.onTipsBegin,self);
  self.viewComponent.yingxiongzhiDO:addEventListener(DisplayEvents.kTouchBegin,self.onTipsBegin,self);
  self.viewComponent.lunjianDO:addEventListener(DisplayEvents.kTouchBegin,self.onTipsBegin,self);

  self.viewComponent.shiliDO:addEventListener(DisplayEvents.kTouchBegin,self.onTipsBegin,self);
  self.viewComponent.huanjingDO:addEventListener(DisplayEvents.kTouchBegin,self.onTipsBegin,self);
  self.viewComponent.shilianDO:addEventListener(DisplayEvents.kTouchBegin,self.onTipsBegin,self);
  self.viewComponent:setScale(0.9)


  local proxyRetriever  = ProxyRetriever.new();
  self.storyLineProxy =  proxyRetriever:retrieveProxy(StoryLineProxy.name);
  self.userProxy =  proxyRetriever:retrieveProxy(UserProxy.name);
end
function HButtonGroupMediator:onTipsBegin(event)
  event.target:addEventListener(DisplayEvents.kTouchEnd,self.onTipsEnd,self);
  
  if event.target.imageButton then
    event.target.imageButton:setScale(0.88);
  else
    event.target:setScale(0.99);
  end
  local effect = event.target:getChildByName("effect");
  if effect then
    effect:setScale(0.88)
  end
end

function HButtonGroupMediator:onTipsEnd(event)

  local targetName = event.target.name
  print("MainSceneMediator:onTipsEnd",targetName)
  if targetName == "juqing" then
      -- print("CommonUtils:getGameMetaScaleRate()", CommonUtils:getGameMetaScaleRate())
      -- print("CommonUtils:getGameUIScaleRate()", CommonUtils:getGameUIScaleRate())
    self:sendNotification(StrongPointInfoNotification.new(StrongPointInfoNotifications.OPEN_STORYLINE_UI_COMMOND,{storyLineId = self.storyLineProxy.storyLineId}));

    -- require "main.controller.command.scriptCartoon.MainSceneScript"
    -- self.mainSceneScript = MainSceneScript.new()
    -- self.mainSceneScript:initScript(self)
    -- self.mainSceneScript:beginScript(1003)

  elseif targetName == "yingxiongzhi" then
    self:sendNotification(ShadowNotification.new(ShadowNotifications.OPEN_HEROIMAGE_UI_COMMAND));
  elseif targetName == "lunjian" then
    self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_ARENA));
    if not GameData.clickRedDotArr[FunctionConfig.FUNCTION_ID_26] 
       and GameData.hasRedDotArr[FunctionConfig.FUNCTION_ID_26] then
      GameData.clickRedDotArr[FunctionConfig.FUNCTION_ID_26] = true
      self:getViewComponent():refreshLunjian();
    end

  elseif targetName == "shili" then
     self:sendNotification(FactionNotification.new(FactionNotifications.OPEN_FACTION_UI));
  elseif targetName == "shilian" then
    self:sendNotification(FactionNotification.new(FactionNotifications.TO_TREASURY_COMMAND));
    if not GameData.clickRedDotArr[FunctionConfig.FUNCTION_ID_36] 
       and GameData.hasRedDotArr[FunctionConfig.FUNCTION_ID_36] then
      GameData.clickRedDotArr[FunctionConfig.FUNCTION_ID_36] = true
      self:getViewComponent():refreshShilian();
    end
  elseif targetName == "huanjing" then
    sendMessage(8,6)
    -- self:sendNotification(MainSceneNotification.new(FiveEleBtleNotifications.TO_FIVEELEBTLE_COMMAND));
  end

  MusicUtils:playEffect(7,false)

  if event.target.imageButton then
    event.target.imageButton:setScale(1);
  else
    event.target:setScale(1);
  end

  local effect = event.target:getChildByName("effect");
  if effect then
    effect:setScale(1)
  end

  event.target:removeEventListener(DisplayEvents.kTouchEnd,self.onTipsEnd,self,data);

end
function HButtonGroupMediator:openButtons(displayMenuVTable)
  print("+++++++++++++++++HButtonGroupMediator displayMenuVTable's lenght is ", Utils:getItemCount(displayMenuVTable))
  self:getViewComponent():openButtons(displayMenuVTable);
end
function HButtonGroupMediator:openMenu(boo)
  self:getViewComponent():openMenu(boo);
end
function HButtonGroupMediator:closeMenu()
  self:getViewComponent():closeMenu();
end
function HButtonGroupMediator:onRemove()
	if self:getViewComponent().parent then
    	self:getViewComponent().parent:removeChild(self:getViewComponent());
  end
end
function HButtonGroupMediator:getTargetButtonPosition(functionId)
  return self:getViewComponent():getTargetButtonPosition(functionId);
end
function HButtonGroupMediator:refreshLunjian()
  return self:getViewComponent():refreshLunjian();
end
function HButtonGroupMediator:refreshShili()
  return self:getViewComponent():refreshShili();
end
function HButtonGroupMediator:refreshYingXiongZhi()
  return self:getViewComponent():refreshYingXiongZhi();
end
function HButtonGroupMediator:addTutorEffect()
  self:getViewComponent():addTutorEffect();
end

function HButtonGroupMediator:removeTutorEffect()
  self:getViewComponent():removeTutorEffect();
end

function HButtonGroupMediator:refreshRedDot()
  self:refreshLunjian();
  self:refreshShili();
  self:refreshYingXiongZhi();
  self:refreshShili();
end
function HButtonGroupMediator:refreshShilian()
  return self:getViewComponent():refreshShilian();
end
