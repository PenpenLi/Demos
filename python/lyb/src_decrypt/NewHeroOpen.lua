
NewHeroOpen=class(LayerPopableDirect);

function NewHeroOpen:ctor()
  self.class = NewHeroOpen;
end

function NewHeroOpen:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  NewHeroOpen.superclass.dispose(self);
  self.armature:dispose()

end

function NewHeroOpen:onDataInit()

  self.shadowProxy=self:retrieveProxy(ShadowProxy.name)

  self.skeleton = self.shadowProxy:getSkeleton();

  local layerPopableData = LayerPopableData.new();
  layerPopableData:setHasUIBackground(false);
  layerPopableData:setHasUIFrame(false);
  layerPopableData:setVisibleDelegate(false)
  layerPopableData:setShowCurrency(false)
  layerPopableData:setArmatureInitParam(self.skeleton,"noticeHero_ui");
  self:setLayerPopableData(layerPopableData);

end

function NewHeroOpen:onPrePop()

  self.mainSize = Director:sharedDirector():getWinSize();

  local armature_dSize =  self.armature.display:getGroupBounds().size
  
  self.armature_d_x = (self.mainSize.width - armature_dSize.width)/2
  self.armature_d_y = (self.mainSize.height - armature_dSize.height)/2
  self.armature.display:setPositionXY(self.armature_d_x, self.armature_d_y)


  local layerColor = LayerColor.new();
  layerColor:initLayer();
  layerColor:changeWidthAndHeight(self.mainSize.width, self.mainSize.height);
  layerColor:setColor(ccc3(0,0,0));
  layerColor:setOpacity(150);
  self:addChildAt(layerColor,0)  

  layerColor:setPositionXY(-GameData.uiOffsetX, -GameData.uiOffsetY)

  -- local layerColor1 = LayerColor.new();
  -- layerColor1:initLayer();
  -- layerColor1:changeWidthAndHeight(self.mainSize.width, self.mainSize.height);
  -- layerColor1:setColor(ccc3(0,0,0));
  -- layerColor1:setOpacity(150);
  -- layerColor1:setPositionXY(0,0)
  -- self:addChildAt(layerColor1,1)   

end

function NewHeroOpen:initialize()
  self:initLayer();
end

function NewHeroOpen:onUIInit()

end

function NewHeroOpen:initializeUI(strongPointId)

  self.strongPointId = strongPointId;
  local yxzPo = analysis("Juqing_Yingxiongzhi", strongPointId);

  local gotoHeroButton = Button.new(self.armature:findChildArmature("common_copy_blue_button"), false);
  gotoHeroButton:setLable("前往")
  gotoHeroButton:addEventListener(Events.kStart, self.gotoHero,self);

  local yingxiongkaiqi = self.skeleton:getBoneTextureDisplay("yingxiongkaiqi");
  yingxiongkaiqi:setAnchorPoint(ccp(0.5,0.5))
  yingxiongkaiqi:setScale(2);
  yingxiongkaiqi:setPositionXY(self.mainSize.width/2, self.mainSize.height/2);
  self:addChildAt(yingxiongkaiqi, 2)

  local str = "";
  local name = yxzPo.name;
  local _count = -1;
  while (-1-string.len(name)) < _count do
    str = str .. string.sub(name, -2 + _count, _count) .. "\n";
    _count = -3 + _count;
  end

  local nameImg = BitmapTextField.new(name,"yingxiongzhi");
  local size = nameImg:getContentSize();
  self.armature.display:addChild(nameImg)
  nameImg:setPositionXY(530,607);


  local heroIds = StringUtils:lua_string_split(yxzPo.heroId, ",")
  for k,v in pairs(heroIds) do
    local render = ShadowHeroImageRender.new();
    render:initializeUI(self, tonumber(v));
    render:setPositionXY((k - 1) * 200 + 344, 86);
    self:addChild(render);
  end


  local newHeroOpenImage = Image.new();
  newHeroOpenImage:loadByArtID(807);
  self:addChild(newHeroOpenImage);
  newHeroOpenImage:setPositionXY(640,300)
  newHeroOpenImage:setAnchorPoint(ccp(0.5,0.5))

  newHeroOpenImage:setScale(15);
  newHeroOpenImage:setOpacity(0)

  local function playComplete()
    self:removeChild(newHeroOpenImage)
  end

  local num = 0.3
  local ccArray = CCArray:create();
  local fadeArray = CCArray:create();
  local upCallBack = CCCallFunc:create(playComplete);
  local upDelay = CCDelayTime:create(num);
  local fadeTo = CCFadeIn:create(0.2, 1);
  local scale = CCScaleTo:create(0.2,1);
  local scaleEaseOut = CCEaseSineIn:create(scale,0.2);
  local fadeToEaseOut = CCEaseSineIn:create(fadeTo,0.2);
  fadeArray:addObject(scaleEaseOut);
  fadeArray:addObject(fadeToEaseOut);

  local fade = CCSpawn:create(fadeArray);
  ccArray:addObject(upDelay);
  ccArray:addObject(fade);
  local upDelay2 = CCDelayTime:create(0.3);
  ccArray:addObject(upDelay2);
  local moveBy = CCMoveBy:create(0.5, ccp(0,500));
  ccArray:addObject(moveBy);
  ccArray:addObject(upCallBack);
  newHeroOpenImage:runAction(CCSequence:create(ccArray));

  -- local sequArr = CCArray:create()
  -- local moveBy = CCMoveBy:create(1.2, ccp(0,500))

  -- sequArr:addObject(moveBy);
  -- sequArr:addObject(CCFadeTo:create(1.2, 0));--CCFadeTo:create(time, alpha)


  -- local function playComplete()
  --   self:removeChild(newHeroOpenImage)
  -- end
  -- local actions = CCSequence:createWithTwoActions(CCSpawn:create(sequArr), CCCallFunc:create(playComplete));
 
  -- newHeroOpenImage:runAction(actions)
  -- local function callBackFun()
  --   if self.boneCartoon then
  --     self:removeChild(self.boneCartoon)
  --     self.boneCartoon = nil
  --   end
  -- end
  -- self.boneCartoon = cartoonPlayer("1550",self.mainSize.width/2-30,self.mainSize.height/2,1,callBackFun,nil,nil)
  -- self:addChild(self.boneCartoon)

end

function NewHeroOpen:onUIClose()
  self:dispatchEvent(Event.new("ON_CLOSE_UI",nil,self)) 
end
function NewHeroOpen:gotoHero(event)
  self:dispatchEvent(Event.new("ON_GOTO_HERO", {strongPointId = self.strongPointId},self)) 
end