

ButtonGroupUI=class(LayerProxyRetrievable);

function ButtonGroupUI:ctor()
  self.class=ButtonGroupUI;
  self.effect_containers = {};
  self.menuButtonMap = {}
end

function ButtonGroupUI:dispose()
  -- log("----------------------ButtonGroupUI:dispose()")
  self:removeAllEventListeners();
  self:removeChildren();
	ButtonGroupUI.superclass.dispose(self);
end

function ButtonGroupUI:initialize()
  self:initLayer();
  local movieClip1 = MovieClip.new();
  movieClip1:initFromFile("main_ui", "menuVGroup");
  movieClip1:gotoAndPlay("f1");
  self:addChild(movieClip1.layer);
  movieClip1:update();
  self.movieClip1 = movieClip1;

  self.renwuButtonDO = movieClip1.armature:getBone("renwu"):getDisplay()

  local renwuButtonFunctionImage = Image.new()
  --renwuButtonFunctionImage:loadByArtID(analysis("Gongnengkaiqi_Gongnengkaiqi",FunctionConfig.FUNCTION_ID_8,"icon"))
  renwuButtonFunctionImage:loadByArtID(870)
  self.renwuButtonDO:addChildAt(renwuButtonFunctionImage,0)    
  self:setImageScale(renwuButtonFunctionImage, self.renwuButtonDO)
  self.menuButtonMap[FunctionConfig.FUNCTION_ID_8] = self.renwuButtonDO;

  self.effect_containers[FunctionConfig.FUNCTION_ID_8] = movieClip1.armature:findChildArmature("renwu"):getBone("effect"):getDisplay();

  
  self.yingxiongDO = movieClip1.armature:getBone("yingxiong"):getDisplay()
  local yingxiongFunctionImage = Image.new()
  yingxiongFunctionImage:loadByArtID(753)
  --yingxiongButtonFunctionImage:loadByArtID(analysis("Gongnengkaiqi_Gongnengkaiqi",FunctionConfig.FUNCTION_ID_8,"icon"))
  self.yingxiongDO:addChildAt(yingxiongFunctionImage, 0)    
  self:setImageScale(yingxiongFunctionImage, self.yingxiongDO)
  self.effect_containers[FunctionConfig.FUNCTION_ID_13] = movieClip1.armature:findChildArmature("yingxiong"):getBone("effect"):getDisplay();
  self.menuButtonMap[FunctionConfig.FUNCTION_ID_13] = self.yingxiongDO;

  self.beibaoDO = movieClip1.armature:getBone("beibao"):getDisplay()
  local beibaoFunctionImage = Image.new()
  beibaoFunctionImage:loadByArtID(740);
  --beibaoButtonFunctionImage:loadByArtID(analysis("Gongnengkaiqi_Gongnengkaiqi",FunctionConfig.FUNCTION_ID_8,"icon"))
  self.beibaoDO:addChildAt(beibaoFunctionImage, 0)    
  self:setImageScale(beibaoFunctionImage, self.beibaoDO)
  self.effect_containers[FunctionConfig.FUNCTION_ID_6] = movieClip1.armature:findChildArmature("beibao"):getBone("effect"):getDisplay();
  self.menuButtonMap[FunctionConfig.FUNCTION_ID_6] = self.beibaoDO;


  self.bangpaiDO = movieClip1.armature:getBone("bangpai"):getDisplay()
  local bangpaiFunctionImage = Image.new()
  --bangpaiFunctionImage:loadByArtID(analysis("Gongnengkaiqi_Gongnengkaiqi",FunctionConfig.FUNCTION_ID_8,"icon"))
  bangpaiFunctionImage:loadByArtID(905)
  self.bangpaiDO:addChildAt(bangpaiFunctionImage,0)    
  self:setImageScale(bangpaiFunctionImage, self.bangpaiDO)
  self.effect_containers[FunctionConfig.FUNCTION_ID_30] = movieClip1.armature:findChildArmature("bangpai"):getBone("effect"):getDisplay();
  
  self.menuButtonMap[FunctionConfig.FUNCTION_ID_30] = self.bangpaiDO

  for k, v in pairs(self.effect_containers) do
    v:setVisible(false);
  end

  self.gap = self.beibaoDO:getPositionY() - self.bangpaiDO:getPositionY() - 5; 
  self.firstMenuX = self.bangpaiDO:getPositionX()
  self.firstMenuY = self.bangpaiDO:getPositionY()

  self:setRedDotByHero();
end
function ButtonGroupUI:openButtons(displayMenuVTable)

  if displayMenuVTable then
    self.displayMenuVTable = displayMenuVTable
  end

  if not self.displayMenuVTable then
    return;
  end

  local vCount = 0
  for k3,v3 in pairs(self.displayMenuVTable) do
    vCount = vCount + 1
  end
  local curIndex = 0;

  for i_k, i_v in ipairs(FunctionConfig.menu_Vfunctions) do
   if self.displayMenuVTable[i_v] then
       curIndex = curIndex + 1;
       self.menuButtonMap[i_v]:setPositionXY(self.firstMenuX,self.firstMenuY + (curIndex-1) * self.gap)
       self.menuButtonMap[i_v]:setVisible(true)
     else
    self.menuButtonMap[i_v]:setVisible(false)
     end
  end

  self:setRedDotByStrengthen();
end
--打开
function ButtonGroupUI:openMenu(boo)
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
    local moveTo2 = CCMoveTo:create(0.4, ccp(winSize.width- 112, -GameData.uiOffsetY+116))
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
    local moveTo2 = CCMoveTo:create(0.4, ccp(winSize.width- 112, -GameData.uiOffsetY - 437 - 108))
    local action2 = CCEaseElasticInOut:create(moveTo2,0.4)
    ccActionArray:addObject(action2);
    ccActionArray:addObject(CCCallFunc:create(rollBack2));
    self:runAction(CCSequence:create(ccActionArray))
  end
end


function ButtonGroupUI:refreshRenwu()
  self.openFunctionProxy = self:retrieveProxy(OpenFunctionProxy.name)
  local openType;
  if self.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_28) and self.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_40) then
    openType = 3;
  elseif self.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_28) then--日常,2
    openType = 2;
  elseif self.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_40) then--目标，1
    openType = 1;
  end


  local datas = {};
  for k,v in pairs(self:retrieveProxy(TaskProxy.name).tasks) do
      local taskPo=analysisByName("Mubiaorenwu_Mubiaorenwu","task",v.ID)
      for k2,v2 in pairs(taskPo) do
        table.insert(datas, {data=v2,condition=v.TaskConditionArray, TaskState = v.TaskState, type = v2.type});
      end
  end
  for k,v in pairs(datas) do
      if v.TaskState==3 and (v.type == openType or openType == 3)then
        self.effect_containers[FunctionConfig.FUNCTION_ID_8]:setVisible(true) 
        return   
      end
  end
  self.effect_containers[FunctionConfig.FUNCTION_ID_8]:setVisible(false)   
end

function ButtonGroupUI:setImageScale(image,buttonDO, funImage)
  image:setAnchorPoint(ccp(0.5,0.5))
  local size = image:getContentSize()
  image:setPositionXY(size.width/2,size.height/2 - 100)
  buttonDO.imageButton = image
end


function ButtonGroupUI:getTargetButtonPosition(functionId)
  local returnData = {};
  local function callBack()
    print("ButtonGroupUI:getTargetButtonPosition call back")
  end
  local  curIndex = 0;
  self.displayMenuVTable[functionId] = functionId;
  for i_k, i_v in ipairs(FunctionConfig.menu_Vfunctions) do
    if self.displayMenuVTable[i_v] then
        curIndex = curIndex + 1;
        self.menuButtonMap[i_v]:setPositionXY(self.firstMenuX,self.firstMenuY + (curIndex-1) * self.gap)
        self.menuButtonMap[i_v]:setVisible(true)
    else
        self.menuButtonMap[i_v]:setVisible(false)
    end
  end
  local pos = self.menuButtonMap[functionId]:getPosition();

  local parentPos = self:getPosition();
  pos.x = pos.x + parentPos.x;
  pos.y = pos.y*0.9 + parentPos.y - self.gap;

  print("parentPos.x, parentPos.y", parentPos.x, parentPos.y)
  print("pos.x, pos.y", pos.x, pos.y)
  returnData["x"] = pos.x + 16;
  returnData["y"] = pos.y+21;
  returnData["callBack"] = callBack;
  return returnData;
end

function ButtonGroupUI:setRedDotByHero()
  local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
  self.effect_containers[FunctionConfig.FUNCTION_ID_13]:setVisible(heroHouseProxy:getRedDotMain());
end

function ButtonGroupUI:setRedDotByStrengthen()
  if self.menuButtonMap[FunctionConfig.FUNCTION_ID_23] and self.menuButtonMap[FunctionConfig.FUNCTION_ID_23]:isVisible() then
    local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
    self.effect_containers[FunctionConfig.FUNCTION_ID_23]:setVisible(heroHouseProxy:getRedDotMain4Strengthen());
  end
end

function ButtonGroupUI:setRedDotByBangpai()
  if self.menuButtonMap[FunctionConfig.FUNCTION_ID_30] and self.menuButtonMap[FunctionConfig.FUNCTION_ID_30]:isVisible() then
    local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
    local userProxy = self:retrieveProxy(UserProxy.name);
    self.effect_containers[FunctionConfig.FUNCTION_ID_30]:setVisible(heroHouseProxy.Hongidan_Huoyuedu or (heroHouseProxy.Hongidan_Shenqingdu and userProxy:getHasQuanxian(1)));
  end
end