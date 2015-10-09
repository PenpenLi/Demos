

HButtonGroupUI=class(LayerProxyRetrievable);

function HButtonGroupUI:ctor()
  self.class=HButtonGroupUI;
  self.effect_containers = {};
    self.menuButtonMap = {}
end

function HButtonGroupUI:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	HButtonGroupUI.superclass.dispose(self);
end

function HButtonGroupUI:initialize()
  self:initLayer();


  local movieClip1 = MovieClip.new();
  movieClip1:initFromFile("main_ui", "menuHGroup");
  movieClip1:gotoAndPlay("f1");
  self:addChild(movieClip1.layer);
  movieClip1:update();
  self.movieClip1 = movieClip1;

  self.juqingDO = movieClip1.armature:getBone("juqing"):getDisplay()
  local juqingFunctionImage = Image.new()
  --bangpaiFunctionImage:loadByArtID(analysis("Gongnengkaiqi_Gongnengkaiqi",FunctionConfig.FUNCTION_ID_8,"icon"))
  juqingFunctionImage:loadByArtID(906)
  self.juqingDO:addChildAt(juqingFunctionImage,0)    
  self:setImageScale(juqingFunctionImage, self.juqingDO)
  self.effect_containers[FunctionConfig.FUNCTION_ID_24] = movieClip1.armature:findChildArmature("juqing"):getBone("effect"):getDisplay();

  self.menuButtonMap[FunctionConfig.FUNCTION_ID_24] = self.juqingDO


  self.yingxiongzhiDO = movieClip1.armature:getBone("yingxiongzhi"):getDisplay()
  local yingxiongzhiFunctionImage = Image.new()
  yingxiongzhiFunctionImage:loadByArtID(913)
 -- yingxiongzhiFunctionImage:loadByArtID(analysis("Gongnengkaiqi_Gongnengkaiqi",FunctionConfig.FUNCTION_ID_8,"icon"))
  self.yingxiongzhiDO:addChildAt(yingxiongzhiFunctionImage,0)    
  self:setImageScale(yingxiongzhiFunctionImage, self.yingxiongzhiDO)
  self.effect_containers[FunctionConfig.FUNCTION_ID_22] = movieClip1.armature:findChildArmature("yingxiongzhi"):getBone("effect"):getDisplay();
 
  self.menuButtonMap[FunctionConfig.FUNCTION_ID_22] = self.yingxiongzhiDO

  
  self.shiliDO = movieClip1.armature:getBone("shili"):getDisplay()
  local shiliFunctionImage = Image.new()
  shiliFunctionImage:loadByArtID(912)
  --shiliFunctionImage:loadByArtID(analysis("Gongnengkaiqi_Gongnengkaiqi",FunctionConfig.FUNCTION_ID_8,"icon"))
  self.shiliDO:addChildAt(shiliFunctionImage,0)    
  self:setImageScale(shiliFunctionImage, self.shiliDO)
  self.effect_containers[FunctionConfig.FUNCTION_ID_32] = movieClip1.armature:findChildArmature("shili"):getBone("effect"):getDisplay();

  self.menuButtonMap[FunctionConfig.FUNCTION_ID_32] = self.shiliDO


  
  self.shilianDO = movieClip1.armature:getBone("shilian"):getDisplay()
  local shilianFunctionImage = Image.new()
  shilianFunctionImage:loadByArtID(1050)
  --shiliFunctionImage:loadByArtID(analysis("Gongnengkaiqi_Gongnengkaiqi",FunctionConfig.FUNCTION_ID_8,"icon"))
  self.shilianDO:addChildAt(shilianFunctionImage,0)    
  self:setImageScale(shilianFunctionImage, self.shilianDO)
  self.effect_containers[FunctionConfig.FUNCTION_ID_36] = movieClip1.armature:findChildArmature("shilian"):getBone("effect"):getDisplay();

  self.menuButtonMap[FunctionConfig.FUNCTION_ID_36] = self.shilianDO


  self.lunjianDO = movieClip1.armature:getBone("lunjian"):getDisplay()
  local lunjianFunctionImage = Image.new()
  lunjianFunctionImage:loadByArtID(908)
  --lunjianFunctionImage:loadByArtID(analysis("Gongnengkaiqi_Gongnengkaiqi",FunctionConfig.FUNCTION_ID_8,"icon"))
  self.lunjianDO:addChildAt(lunjianFunctionImage,0)    
  self:setImageScale(lunjianFunctionImage, self.lunjianDO)
  self.effect_containers[FunctionConfig.FUNCTION_ID_26] = movieClip1.armature:findChildArmature("lunjian"):getBone("effect"):getDisplay();

  self.menuButtonMap[FunctionConfig.FUNCTION_ID_26] = self.lunjianDO



  
  self.huanjingDO = movieClip1.armature:getBone("huanjing"):getDisplay()
  local huanjingFunctionImage = Image.new()
  huanjingFunctionImage:loadByArtID(1574)
  --shiliFunctionImage:loadByArtID(analysis("Gongnengkaiqi_Gongnengkaiqi",FunctionConfig.FUNCTION_ID_8,"icon"))
  self.huanjingDO:addChildAt(huanjingFunctionImage,0)    
  self:setImageScale(huanjingFunctionImage, self.huanjingDO)
  self.effect_containers[FunctionConfig.FUNCTION_ID_44] = movieClip1.armature:findChildArmature("huanjing"):getBone("effect"):getDisplay();
  
  self.menuButtonMap[FunctionConfig.FUNCTION_ID_44] = self.huanjingDO

  for k, v in pairs(self.effect_containers) do
    v:setVisible(false);
  end

  self.gap = self.huanjingDO:getPositionX() - self.lunjianDO:getPositionX() - 10; 
  self.firstMenuX = self.huanjingDO:getPositionX()
  self.firstMenuY = self.huanjingDO:getPositionY()

  self:refreshShilian()
end

function HButtonGroupUI:openButtons(displayMenuHTable)

  if displayMenuHTable then
    self.displayMenuHTable = displayMenuHTable
  end

  if not self.displayMenuHTable then
    return;
  end

  local  curIndex = 0;
  local len = #FunctionConfig.menu_Hfunctions1
  for i = len, 1, -1 do
    local i_v = FunctionConfig.menu_Hfunctions1[i];
    if self.displayMenuHTable[i_v] then
        curIndex = curIndex + 1;
        local xPos = self.gap * 5 - (curIndex-1) * self.gap + 40;
        self.menuButtonMap[i_v]:setPositionXY(xPos, self.firstMenuY)
        self.menuButtonMap[i_v]:setVisible(true)
    else
        self.menuButtonMap[i_v]:setVisible(false)
    end
  end

end
--打开
function HButtonGroupUI:openMenu(boo)
  -- CCActionInterval* pActionInterval = CCMoveTo::create(5.0f, ccp(500.0f, 100.0f));
  -- CCSpeed* pSpeed= CCSpeed::create(pActionInterval, 1.5f); --1.5倍速运行
  -- CCSpeed* pSpeed1 = CCSpeed::create(pActionInterval, 0.2f);--0.2倍速运行
  -- pSprite->runAction(pSpeed);
  local winSize = Director:sharedDirector():getWinSize();
  if boo then
    if GameData.isHMenuOpen or self.isMoving then
      return;
    end
    
    local function rollBack()
      GameData.isHMenuOpen = true;
      self.isMoving = false;
    end
    self.isMoving = true;
    local ccActionArray = CCArray:create()
    local moveTo2 = CCMoveTo:create(0.4, ccp(winSize.width-675 - 58, -GameData.uiOffsetY))
    local action2 = CCEaseElasticInOut:create(moveTo2,0.4)
    ccActionArray:addObject(action2);
    ccActionArray:addObject(CCCallFunc:create(rollBack));
    self:runAction(CCSequence:create(ccActionArray))
  else
    if not GameData.isHMenuOpen or self.isMoving then
      return;
    end
    local function rollBack2()
      GameData.isHMenuOpen = false;
      self.isMoving = false;
    end

    self.isMoving = true;
    local ccActionArray = CCArray:create()
    local moveTo2 = CCMoveTo:create(0.4, ccp(winSize.width + 50, -GameData.uiOffsetY))
    local action2 = CCEaseElasticInOut:create(moveTo2,0.4)
    ccActionArray:addObject(action2);
    ccActionArray:addObject(CCCallFunc:create(rollBack2));
    self:runAction(CCSequence:create(ccActionArray))
  end
end
--收缩
function HButtonGroupUI:closeMenu()
  
end
function HButtonGroupUI:setImageScale(image,buttonDO, funImage)
  image:setAnchorPoint(ccp(0.5,0.5))
  local size = image:getContentSize()
  image:setPositionXY(size.width/2,size.height/2 - 100)
  buttonDO.imageButton = image
end

function HButtonGroupUI:getTargetButtonPosition(functionId)
  local returnData = {};
  local function callBack()
    print("HButtonGroupUI:getTargetButtonPosition call back")
  end
  local  curIndex = 0;
  self.displayMenuHTable[functionId] = functionId;

  local  curIndex = 0;
  local len = #FunctionConfig.menu_Hfunctions1
  for i = len, 1, -1 do
    local i_v = FunctionConfig.menu_Hfunctions1[i];
    if self.displayMenuHTable[i_v] then
        curIndex = curIndex + 1;
        local xPos = self.gap * 5 - (curIndex-1) * self.gap + 40;
        self.menuButtonMap[i_v]:setPositionXY(xPos, self.firstMenuY)
        self.menuButtonMap[i_v]:setVisible(true)
    else
        self.menuButtonMap[i_v]:setVisible(false)
    end
  end
  local pos = self.menuButtonMap[functionId]:getPosition();

  local parentPos = self:getPosition();
  pos.x = pos.x*0.9 + parentPos.x;
  pos.y = -GameData.uiOffsetY;

  returnData["x"] = pos.x + 10;
  returnData["y"] = pos.y+10;
  returnData["callBack"] = callBack;
  return returnData;
end

function HButtonGroupUI:refreshLunjian()
  if GameData.clickRedDotArr[FunctionConfig.FUNCTION_ID_26] then
    self.effect_containers[FunctionConfig.FUNCTION_ID_26]:setVisible(false)
    GameData.hasRedDotArr[FunctionConfig.FUNCTION_ID_26] = false
    return
  end

  local countControlProxy = self:retrieveProxy(CountControlProxy.name);
  local areaProxy = self:retrieveProxy(ArenaProxy.name);
  local lunjianCount = countControlProxy:getRemainCountByID(CountControlConfig.ARENA_COUNT,CountControlConfig.Parameter_1)
  local areaTimer = areaProxy:getTimeValue()
  
  if lunjianCount and areaTimer == 0 then
    self.effect_containers[FunctionConfig.FUNCTION_ID_26]:setVisible(lunjianCount > 0 and areaTimer == 0)
    GameData.hasRedDotArr[FunctionConfig.FUNCTION_ID_26] = lunjianCount > 0 and areaTimer == 0
  end
end

function HButtonGroupUI:refreshShili()
  local openFunctionProxy = self:retrieveProxy(OpenFunctionProxy.name);
  if openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_32) then

      if GameData.clickRedDotArr[FunctionConfig.FUNCTION_ID_33]
     and GameData.clickRedDotArr[FunctionConfig.FUNCTION_ID_34]
     and GameData.clickRedDotArr[FunctionConfig.FUNCTION_ID_35]
     then
        self.effect_containers[FunctionConfig.FUNCTION_ID_32]:setVisible(false)
        GameData.hasRedDotArr[FunctionConfig.FUNCTION_ID_32] = false
        return
      end

      local countControlProxy = self:retrieveProxy(CountControlProxy.name);
      local userProxy = self:retrieveProxy(UserProxy.name);
      local userCurrencyProxy = self:retrieveProxy(UserCurrencyProxy.name);

      --
      local shengwanggou
      if analysisHas("Shili_Guanzhi",userProxy:getNobility() + 1) then
        shengwanggou = analysis("Shili_Guanzhi",userProxy:getNobility() + 1,"prestige") <= userCurrencyProxy:getPrestige()
      end

      local guanzhiCanRed = openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_33) and not GameData.clickRedDotArr[FunctionConfig.FUNCTION_ID_33] and shengwanggou

      local shiguoCount = countControlProxy:getRemainCountByID(CountControlConfig.TEN_COUNTRY,CountControlConfig.Parameter_0)
      local shiguoCanRed = openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_34) and not GameData.clickRedDotArr[FunctionConfig.FUNCTION_ID_34] and shiguoCount > 0

      local chaotangCount = countControlProxy:getRemainCountByID(CountControlConfig.CHAOTANGZHENGBIAN,CountControlConfig.Parameter_0)
      local chaotangCanRed = openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_35) and not GameData.clickRedDotArr[FunctionConfig.FUNCTION_ID_35] and chaotangCount > 0

      -- local shilianCount1 = countControlProxy:getRemainCountByID(CountControlConfig.TreasuryCount,CountControlConfig.Parameter_1)
      -- local shilian1CanRed = openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_36) and not GameData.clickRedDotArr[FunctionConfig.FUNCTION_ID_36] and shilianCount1 > 0

      -- local shilianCount2 = countControlProxy:getRemainCountByID(CountControlConfig.TreasuryCount,CountControlConfig.Parameter_2)
      -- local shilian2CanRed = openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_36) and  not GameData.clickRedDotArr[FunctionConfig.FUNCTION_ID_36] and shilianCount2 > 0
            
      if guanzhiCanRed
      or shiguoCanRed
      or chaotangCanRed then
        self.effect_containers[FunctionConfig.FUNCTION_ID_32]:setVisible(true)
        GameData.hasRedDotArr[FunctionConfig.FUNCTION_ID_32] = true
      else
        self.effect_containers[FunctionConfig.FUNCTION_ID_32]:setVisible(false)
        GameData.hasRedDotArr[FunctionConfig.FUNCTION_ID_32] = false    
      end
  else

  end
end

function HButtonGroupUI:refreshYingXiongZhi()
  local storyLineProxy = self:retrieveProxy(StoryLineProxy.name);
  for k, v in pairs(storyLineProxy.strongPointArray) do
    -- print("v.ID", v.ID)
    if analysisHas("Juqing_Yingxiongzhi", v.StrongPointId) and v.TotalCount == 0 and v.State == 3 and not GameData.clickRedDotArr[FunctionConfig.FUNCTION_ID_22 .. "_" .. v.StrongPointId] then
         print("self.effect_containers[5]:setVisible(true)")
        self.effect_containers[FunctionConfig.FUNCTION_ID_22]:setVisible(true)
        return;
    end
  end
  self.effect_containers[FunctionConfig.FUNCTION_ID_22]:setVisible(false)
end
function HButtonGroupUI:addTutorEffect()
    -- local pos = self:getTargetButtonPosition(FunctionConfig.FUNCTION_ID_24);
    -- print("++++++++++++++++++++++++++------pos.x, pos.y", pos.x, pos.y)
    if not self.boneLightCartoon then
      self.boneLightCartoon = BoneCartoon.new()
      self.boneLightCartoon:create(StaticArtsConfig.BONE_EFFECT_STORYLINE_BUTTON,0);
      self.boneLightCartoon:setMyBlendFunc()
      self.juqingDO:addChild(self.boneLightCartoon);

      self.boneLightCartoon:setPositionXY(60, -38)
    end

    -- if not self.personItem then
    --   self.personItem = GuideImageLayer.new()
    --   self.personItem:initLayerData1(1034, "通关剧情，快速升级~", self.juqingDO:getPositionX()-300, self.juqingDO:getPositionY())
    --   self:addChild(self.personItem)
    --   self.personItem:startAnimation()
    -- end
    -- self.boneLightCartoon:setPositionXY(pos.x, pos.y)
end

function HButtonGroupUI:removeTutorEffect()
    -- local pos = self:getTargetButtonPosition(FunctionConfig.FUNCTION_ID_24);
    -- print("++++++++++++++++++++++++++------pos.x, pos.y", pos.x, pos.y)
    if self.boneLightCartoon then
      self.juqingDO:removeChild(self.boneLightCartoon);
      self.boneLightCartoon = nil;
    end

    -- if self.personItem then
    --   self:removeChild(self.personItem);
    --   self.personItem = nil;
    -- end
end

function HButtonGroupUI:refreshShilian()
  
  local openFunctionProxy = self:retrieveProxy(OpenFunctionProxy.name);

  if openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_36) then

    if GameData.clickRedDotArr[FunctionConfig.FUNCTION_ID_36] then
      self.effect_containers[FunctionConfig.FUNCTION_ID_36]:setVisible(false)
      GameData.hasRedDotArr[FunctionConfig.FUNCTION_ID_36] = false
      return
    end

    local countControlProxy = self:retrieveProxy(CountControlProxy.name);

    local shilianCount1 = countControlProxy:getRemainCountByID(CountControlConfig.TreasuryCount,CountControlConfig.Parameter_1)
    local shilian1CanRed = openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_36) and not GameData.clickRedDotArr[FunctionConfig.FUNCTION_ID_36] and shilianCount1 > 0

    local shilianCount2 = countControlProxy:getRemainCountByID(CountControlConfig.TreasuryCount,CountControlConfig.Parameter_2)
    local shilian2CanRed = openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_36) and  not GameData.clickRedDotArr[FunctionConfig.FUNCTION_ID_36] and shilianCount2 > 0

    if shilian1CanRed or shilian2CanRed then
      self.effect_containers[FunctionConfig.FUNCTION_ID_36]:setVisible(true)
      GameData.hasRedDotArr[FunctionConfig.FUNCTION_ID_36] = true
    else
      self.effect_containers[FunctionConfig.FUNCTION_ID_36]:setVisible(false)
      GameData.hasRedDotArr[FunctionConfig.FUNCTION_ID_36] = false  
    end
  end  
end
