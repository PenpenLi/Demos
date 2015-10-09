

LeftButtonGroupUI=class(LayerProxyRetrievable);

function LeftButtonGroupUI:ctor()
  self.class=LeftButtonGroupUI;
  self.effect_containers = {};
  self.menuButtonMap = {}
end

function LeftButtonGroupUI:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	LeftButtonGroupUI.superclass.dispose(self);
end

function LeftButtonGroupUI:initialize()
  self:initLayer();
  local movieClip1 = MovieClip.new();
  movieClip1:initFromFile("main_ui", "menuLeftVGroup");
  movieClip1:gotoAndPlay("f1");
  self:addChild(movieClip1.layer);
  movieClip1:update();
  self.movieClip1 = movieClip1;

  self.langyalingDO = movieClip1.armature:getBone("langyaling"):getDisplay()
  local langyalingFunctionImage = Image.new()
  langyalingFunctionImage:loadByArtID(747)
 -- langyalingButtonFunctionImage:loadByArtID(analysis("youjiankaiqi_youjiankaiqi",FunctionConfig.FUNCTION_ID_8,"icon"))
  self.langyalingDO:addChildAt(langyalingFunctionImage,0)    
  self:setImageScale(langyalingFunctionImage, self.langyalingDO)
  self.effect_containers[FunctionConfig.FUNCTION_ID_12] = movieClip1.armature:findChildArmature("langyaling"):getBone("effect"):getDisplay();

  self.menuButtonMap[FunctionConfig.FUNCTION_ID_12] = self.langyalingDO;

  
  self.youjianDO = movieClip1.armature:getBone("youjian"):getDisplay()
  local youjianFunctionImage = Image.new()
  youjianFunctionImage:loadByArtID(629)
  --youjianFunctionImage:loadByArtID(analysis("youjiankaiqi_youjiankaiqi",FunctionConfig.FUNCTION_ID_8,"icon"))
  self.youjianDO:addChildAt(youjianFunctionImage, 0)    
  self:setImageScale(youjianFunctionImage, self.youjianDO)
  self.effect_containers[FunctionConfig.FUNCTION_ID_5] = movieClip1.armature:findChildArmature("youjian"):getBone("effect"):getDisplay();

  self.menuButtonMap[FunctionConfig.FUNCTION_ID_5] = self.youjianDO;

  
  self.qiandaoDO = movieClip1.armature:getBone("qiandao"):getDisplay()
  local qiandaoFunctionImage = Image.new()
  qiandaoFunctionImage:loadByArtID(909)
  --qiandaoButtonFunctionImage:loadByArtID(analysis("youjiankaiqi_youjiankaiqi",FunctionConfig.FUNCTION_ID_8,"icon"))
  self.qiandaoDO:addChildAt(qiandaoFunctionImage, 0)    
  self:setImageScale(qiandaoFunctionImage, self.qiandaoDO)
  self.effect_containers[FunctionConfig.FUNCTION_ID_29] = movieClip1.armature:findChildArmature("qiandao"):getBone("effect"):getDisplay();

  self.menuButtonMap[FunctionConfig.FUNCTION_ID_29] = self.qiandaoDO;
  
  self.haoyouDO = movieClip1.armature:getBone("haoyou"):getDisplay()
  local haoyouFunctionImage = Image.new()
  haoyouFunctionImage:loadByArtID(1070)
  --qiandaoButtonFunctionImage:loadByArtID(analysis("youjiankaiqi_youjiankaiqi",FunctionConfig.FUNCTION_ID_8,"icon"))
  self.haoyouDO:addChildAt(haoyouFunctionImage, 0)    
  self:setImageScale(haoyouFunctionImage, self.haoyouDO)
  self.effect_containers[FunctionConfig.FUNCTION_ID_10] = movieClip1.armature:findChildArmature("haoyou"):getBone("effect"):getDisplay();

  self.menuButtonMap[FunctionConfig.FUNCTION_ID_10] = self.haoyouDO;


  self.shangchengDO = movieClip1.armature:getBone("shangcheng"):getDisplay()
  local shangchengFunctionImage = Image.new()
  shangchengFunctionImage:loadByArtID(911)
  --shiliFunctionImage:loadByArtID(analysis("Gongnengkaiqi_Gongnengkaiqi",FunctionConfig.FUNCTION_ID_8,"icon"))
  self.shangchengDO:addChildAt(shangchengFunctionImage,0)    
  self:setImageScale(shangchengFunctionImage, self.shangchengDO)
  self.effect_containers[FunctionConfig.FUNCTION_ID_3] = movieClip1.armature:findChildArmature("shangcheng"):getBone("effect"):getDisplay();
  
  self.menuButtonMap[FunctionConfig.FUNCTION_ID_3] = self.shangchengDO;

  for k, v in pairs(self.effect_containers) do
    v:setVisible(false);
  end

  self.gap = self.haoyouDO:getPositionY() -  self.qiandaoDO:getPositionY() - 6; 
  self.firstMenuX = self.qiandaoDO:getPositionX()
  self.firstMenuY = self.qiandaoDO:getPositionY() - 27

  self:refreshLangyaling()
  self:refreshMail()
  self:refreshHaoyou();
end
function LeftButtonGroupUI:openButtons(displayMenuLeftTable)

  if displayMenuLeftTable then
    self.displayMenuLeftTable = displayMenuLeftTable
  end

  if not self.displayMenuLeftTable then
    return;
  end

  local vCount = 0
  for k3,v3 in pairs(self.displayMenuLeftTable) do
    vCount = vCount + 1
  end
  curIndex = 0;

  for i_k, i_v in ipairs(FunctionConfig.menu_Leftfunctions) do
   if self.displayMenuLeftTable[i_v] then
       curIndex = curIndex + 1;
       self.menuButtonMap[i_v]:setPositionXY(self.firstMenuX,self.firstMenuY + (curIndex-1) * self.gap)
       self.menuButtonMap[i_v]:setVisible(true)
     else
       self.menuButtonMap[i_v]:setVisible(false)
     end
  end
end


function LeftButtonGroupUI:setImageScale(image,buttonDO, funImage)
  image:setAnchorPoint(ccp(0.5,0.5))
  local size = image:getContentSize()
  image:setPositionXY(size.width/2,size.height/2 - 100)
  buttonDO.imageButton = image
end


function LeftButtonGroupUI:getTargetButtonPosition(functionId)
  local returnData = {};
  local function callBack()
    print("LeftButtonGroupUI:getTargetButtonPosition call back")
  end
  local  curIndex = 0;
  self.displayMenuLeftTable[functionId] = functionId;
  for i_k, i_v in ipairs(FunctionConfig.menu_Leftfunctions) do
    if self.displayMenuLeftTable[i_v] then
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
  pos.y = pos.y*0.8 + parentPos.y - self.gap;

  returnData["x"] = pos.x + 15;
  returnData["y"] = pos.y+25;
  returnData["callBack"] = callBack;
  return returnData;
end

function LeftButtonGroupUI:refreshLangyaling()
  if GameData.clickRedDotArr[FunctionConfig.FUNCTION_ID_12] then
    self.effect_containers[FunctionConfig.FUNCTION_ID_12]:setVisible(false)
    GameData.hasRedDotArr[FunctionConfig.FUNCTION_ID_12] = false
    return
  end

  local bagProxy = self:retrieveProxy(BagProxy.name);
  local yingxionglingCount = bagProxy:getItemNum(1009001)
  local langyalingCount = bagProxy:getItemNum(1009002)

  if yingxionglingCount ~= 0 or langyalingCount ~= 0 then
    self.effect_containers[FunctionConfig.FUNCTION_ID_12]:setVisible(true)
    GameData.hasRedDotArr[FunctionConfig.FUNCTION_ID_12] = true
  end
end

function LeftButtonGroupUI:refreshMail(value)
  if value then
    self.effect_containers[FunctionConfig.FUNCTION_ID_5]:setVisible(true)
    GameData.hasRedDotArr[FunctionConfig.FUNCTION_ID_5] = true
    GameData.clickRedDotArr[FunctionConfig.FUNCTION_ID_5] = false
  else
    local mailProxy = self:retrieveProxy(MailProxy.name);
    local hasRedDotBoo = mailProxy:isRedDotVisible()
    local hasRedDotBoo1 = false
    if hasRedDotBoo then
      hasRedDotBoo1 = true
    else
      if GameData.hasRedDotArr[FunctionConfig.FUNCTION_ID_5] 
     and not GameData.clickRedDotArr[FunctionConfig.FUNCTION_ID_5] then
        hasRedDotBoo1 = true
      else
        hasRedDotBoo1 = false
      end
    end
    self.effect_containers[FunctionConfig.FUNCTION_ID_5]:setVisible(hasRedDotBoo1)
    GameData.hasRedDotArr[FunctionConfig.FUNCTION_ID_5] = hasRedDotBoo1
  end
end


function LeftButtonGroupUI:refreshQianDao(value)

    local visible = GameData.hasRedDotArr[FunctionConfig.FUNCTION_ID_29] and true or false;
    self.effect_containers[FunctionConfig.FUNCTION_ID_29]:setVisible(visible)
end

function LeftButtonGroupUI:refreshHaoyou()
  self.effect_containers[FunctionConfig.FUNCTION_ID_10]:setVisible(GameData.hasRedDotArr[FunctionConfig.FUNCTION_ID_10])
end