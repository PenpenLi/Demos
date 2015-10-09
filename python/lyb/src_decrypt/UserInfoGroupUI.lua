UserInfoGroupUI=class(Layer);

function UserInfoGroupUI:ctor()
  self.class=UserInfoGroupUI;
end

function UserInfoGroupUI:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  UserInfoGroupUI.superclass.dispose(self);
end

function UserInfoGroupUI:initialize()

    self.effect_containers = {};
    self.menuButtonMap = {}
    self:initLayer();
    
    self.winSize = Director:sharedDirector():getWinSize();

    local proxyRetriever  = ProxyRetriever.new();
    self.userCurrencyProxy=proxyRetriever:retrieveProxy(UserCurrencyProxy.name);
    self.userProxy=proxyRetriever:retrieveProxy(UserProxy.name);
    self.heroHouseProxy=proxyRetriever:retrieveProxy(HeroHouseProxy.name);
    self.huodongProxy = proxyRetriever:retrieveProxy(HuoDongProxy.name);


    local userInfoGroup = MovieClip.new();
    userInfoGroup:initFromFile("main_ui", "userInfoGroup");
    userInfoGroup:gotoAndPlay("f1");


    userInfoGroup.layer:setPositionXY(0,self.winSize.height - 134 -GameData.uiOffsetY)    

    self:addChild(userInfoGroup.layer);
    userInfoGroup:update();
    self.userInfoGroup = userInfoGroup;
  
    self.mainui_vip = userInfoGroup.armature:getBone("common_copy_mainui_vip"):getDisplay()
    self.mainui_vip.name = "mainui_vip"

    local head_lv_bg = userInfoGroup.armature:getBone("head_lv_bg"):getDisplay()
    userInfoGroup.layer:removeChild(head_lv_bg, false)


    userInfoGroup.layer:addChild(head_lv_bg)

    self.userLvTextBone = userInfoGroup.armature:getBone("userLvText")
    self.userNameTextBone = userInfoGroup.armature:getBone("userNameText")

    self.redIconDO = userInfoGroup.armature:getBone("redIcon"):getDisplay()
    self.redIconDO:setVisible(false)

    self:refreshHeadImage()

    self:setUserInfoText();

    self:refreshVip();

    self.effect = cartoonPlayer("1096",161,100,0)
    -- self.effect:setAnchorPoint(transLayerAnchor(0.7, 0));
    userInfoGroup.layer:addChild(self.effect);

    self:initializeButtons()
end

-- refresh  redicon
function UserInfoGroupUI:refreshRedIcon(value)
  self.redIconDO:setVisible(value)
end

function UserInfoGroupUI:refreshHeadImage()
  if self.headImageDO then
    self.userInfoGroup.layer:removeChild(self.headImageDO);
    self.headImageDO = nil;
  end
  local headArtId;
  -- if self.userProxy.transforId == 0 then
  --   headArtId = analysis("Zhujiao_Zhujiaozhiye",self.userProxy:getCareer(),"art3") 
  -- else
    headArtId = analysis("Zhujiao_Huanhua",self.userProxy.transforId,"head")  
  -- end
  self.head_bgDO = self.userInfoGroup.armature:getBone("head_bg"):getDisplay()
  self.headImageDO = Image.new();
  self.headImageDO.name = "headImage"
  self.headImageDO:loadByArtID(headArtId);
  self.userInfoGroup.layer:addChild(self.headImageDO);
  self.headImageDO:setAnchorPoint(CCPointMake(0.5, 0.5));
  self.headImageDO:setPositionXY(76,79)
end
function UserInfoGroupUI:setUserInfoText()

 if not self.userNameText then
    self.userNameText = createStrokeTextFieldWithTextData(self.userNameTextBone.textData,self.userProxy.userName,nil,1,ccc3(0,0,0));
    self.userNameText.touchEnabled = false;
    self.userInfoGroup.layer:addChild(self.userNameText)
  else
    self.userNameText:setString(self.userProxy.userName);
  end
  
  local level = self.userProxy.level
  print("+++++++++++++level", level)
  if not self.userLvText then
    self.userLvText = createStrokeTextFieldWithTextData(self.userLvTextBone.textData,level,nil,1,ccc3(0,0,0));
    self.userLvText.touchEnabled = false;
    self.userInfoGroup.layer:addChild(self.userLvText)
  else
    self.userLvText:setString(level);
    self.userInfoGroup.layer:addChild(self.userLvText)
  end

end
function UserInfoGroupUI:refreshUserLevel()
  print("self.userProxy.level", self.userProxy.level)
  self.userLvText:setString(self.userProxy.level);
end
function UserInfoGroupUI:refreshUserName()
  self.userNameText:setString(self.userProxy.userName);
end
function UserInfoGroupUI:refreshVip()
  if self.vipLevelIcon then
    self.userInfoGroup.layer:removeChild(self.vipLevelIcon);
  end
  if self.highVipLevelIcon then
    self.userInfoGroup.layer:removeChild(self.highVipLevelIcon);
  end
  print("self.userProxy.vipLevel", self.userProxy.vipLevel)
  if self.userProxy.vipLevel >= 10 then
    local low = self.userProxy.vipLevel%10;
    local high = math.floor(self.userProxy.vipLevel/10);
    self.highVipLevelIcon = CommonSkeleton:getCommonBoneTextureDisplay("commonNumbers/common_mainui_vip" .. high);
    self.highVipLevelIcon.touchEnabled = false;
    self.highVipLevelIcon:setPositionXY(194,41+46)
    self.userInfoGroup.layer:addChild(self.highVipLevelIcon);

    self.vipLevelIcon = CommonSkeleton:getCommonBoneTextureDisplay("commonNumbers/common_mainui_vip" .. low);
    self.vipLevelIcon.touchEnabled = false;
    self.vipLevelIcon:setPositionXY(217,41+46)
    self.userInfoGroup.layer:addChild(self.vipLevelIcon);
  else
    self.vipLevelIcon = CommonSkeleton:getCommonBoneTextureDisplay("commonNumbers/common_mainui_vip" .. self.userProxy.vipLevel);
    self.vipLevelIcon.touchEnabled = false;
    self.vipLevelIcon:setPositionXY(194,41+46)
    self.userInfoGroup.layer:addChild(self.vipLevelIcon);
  end
end


function UserInfoGroupUI:initializeButtons()
  print("function UserInfoGroupUI:initializeButtons()")
  local menuHGroup2 = MovieClip.new();
  menuHGroup2:initFromFile("main_ui", "menuHGroup2");
  menuHGroup2:gotoAndPlay("f1");

  menuHGroup2.layer:setScale(0.8)

  menuHGroup2.layer:setPositionXY(143,self.winSize.height - 167 -GameData.uiOffsetY)    

  self:addChild(menuHGroup2.layer);
  menuHGroup2:update();

  self.huodongDO = menuHGroup2.armature:getBone("huodong"):getDisplay()

  local huodongFunctionImage = Image.new()
  huodongFunctionImage:loadByArtID(746)
  self.huodongDO:addChildAt(huodongFunctionImage,0)    
  self:setImageScale(huodongFunctionImage, self.huodongDO)

  self.huodongDot = menuHGroup2.armature:findChildArmature("huodong"):getBone("effect"):getDisplay();
  self.huodongDot:setVisible(false)
  local size = huodongFunctionImage:getContentSize();
  self.cartoon = cartoonPlayer("1387", size.width / 2, - size.height / 2, 0,nil, 1, nil, 1);
  self.cartoon:setAnchorPoint(ccp(0, 0))

  self.huodongDO:addChild(self.cartoon)
  self.effect_containers[FunctionConfig.FUNCTION_ID_41] = self.cartoon;
  self.menuButtonMap[FunctionConfig.FUNCTION_ID_41] = self.huodongDO;




  self.langyabangDO = menuHGroup2.armature:getBone("langyabang"):getDisplay()
  local langyabangFunctionImage = Image.new()
  langyabangFunctionImage:loadByArtID(907);
  self.langyabangDO:addChildAt(langyabangFunctionImage, 0)    
  self:setImageScale(langyabangFunctionImage, self.langyabangDO)
  self.effect_containers[FunctionConfig.FUNCTION_ID_11] = menuHGroup2.armature:findChildArmature("langyabang"):getBone("effect"):getDisplay();
  self.menuButtonMap[FunctionConfig.FUNCTION_ID_11] = self.langyabangDO;

  self.gap = self.huodongDO:getPositionX() - self.langyabangDO:getPositionX() - 10; 
  self.firstMenuX = self.langyabangDO:getPositionX()
  self.firstMenuY = self.langyabangDO:getPositionY()



  self.monthCardDO = menuHGroup2.armature:getBone("monthcard"):getDisplay()
  local monthCardImage = Image.new()
  monthCardImage:loadByArtID(1765);
  self.monthCardDO:addChildAt(monthCardImage, 0)    
  self:setImageScale(monthCardImage, self.monthCardDO)
  self.effect_containers[FunctionConfig.FUNCTION_ID_53] = menuHGroup2.armature:findChildArmature("monthcard"):getBone("effect"):getDisplay();
  self.monthCardDO.effect = menuHGroup2.armature:findChildArmature("monthcard"):getBone("effect"):getDisplay();
  self.effect_containers[FunctionConfig.FUNCTION_ID_53]:setVisible(false)
  self.menuButtonMap[FunctionConfig.FUNCTION_ID_53] = self.monthCardDO;
  


  self.firstPayDO = menuHGroup2.armature:getBone("firstpay"):getDisplay()
  self.firstPayImage = Image.new()
  self.firstPayImage:loadByArtID(161);
  self.firstPayDO:addChildAt(self.firstPayImage, 0)    
  self:setImageScale(self.firstPayImage, self.firstPayDO)
  self.effect_containers[FunctionConfig.FUNCTION_ID_56] = menuHGroup2.armature:findChildArmature("firstpay"):getBone("effect"):getDisplay();
  self.firstPayDO.effect = menuHGroup2.armature:findChildArmature("firstpay"):getBone("effect"):getDisplay();

  -- local cartoonShouchong = cartoonPlayer("1387", 50, -50, 0,nil, 1, nil, 1);
  -- self.firstPayDO:addChild(cartoonShouchong)
  -- self.effect_containers[FunctionConfig.FUNCTION_ID_56] = cartoonShouchong;
  self.effect_containers[FunctionConfig.FUNCTION_ID_56]:setVisible(false)
  self.menuButtonMap[FunctionConfig.FUNCTION_ID_56] = self.firstPayDO;
  self.firstPayImage:setVisible(false);

 --开服七天
   -- menuHGroup2.layer:setScale(1/0.8)
  self.sevendays = menuHGroup2.armature:getBone("sevendays"):getDisplay();
  local sevendaysImg = Image.new();
  sevendaysImg:loadByArtID(725);
  self.sevendays:addChildAt(sevendaysImg, 0);
  self:setImageScale(sevendaysImg, self.sevendays);
  self.effect_containers[FunctionConfig.FUNCTION_ID_73] = menuHGroup2.armature:findChildArmature("sevendays"):getBone("effect"):getDisplay();
  self.sevendays.effect = menuHGroup2.armature:findChildArmature("sevendays"):getBone("effect"):getDisplay();
  self.effect_containers[FunctionConfig.FUNCTION_ID_73]:setVisible(false);
  local size = sevendaysImg:getContentSize();
  self.sevendaysCartoon = cartoonPlayer("1387", size.width / 2, -size.height / 2, 0,nil, 1, nil, 1);
  self.sevendaysCartoon:setAnchorPoint(ccp(0, 0))
  self.sevendays:addChild(self.sevendaysCartoon)
  self.effect_containers[FunctionConfig.FUNCTION_ID_73] =  self.sevendaysCartoon;
  self.menuButtonMap[FunctionConfig.FUNCTION_ID_73] = self.sevendays;
  self.sevendays:setVisible(false);
  -- self.menuButtonMap[FunctionConfig.FUNCTION_ID_73]:setVisible(false);
  -- self.sevendaysImg = sevendaysImg;
  -- self.sevendaysImg:setVisible(false);

  for k,v in pairs(self.menuButtonMap) do
    v:setVisible(false);
  end


  -- print("\n\n\n\n----------------------effect_containers")
  for k, v in pairs(self.effect_containers) do
    -- print(k,v)
    v:setVisible(false);
  end
  self:refreshHuoDong();

end



function UserInfoGroupUI:openButtons(displayMenuHTable)
  print("function UserInfoGroupUI:openButtons(displayMenuHTable)")

  if self.huodongProxy.boolOpenButton == false then
    -- add by mohai.wu 第一次登陆的时候在huodongproxy里面来打开
    return;
  end

  if displayMenuHTable then
    self.displayMenuHTable = displayMenuHTable
  end

  if not self.displayMenuHTable then
    return;
  end

  for k,v in pairs( displayMenuHTable) do
    print(k,v)
  end
print("--------------")
  for k,v in pairs(FunctionConfig.menu_Hfunctions2) do
    print(k,v)
  end
  local  curIndex = 0;
  local len = #FunctionConfig.menu_Hfunctions2
  for i = len, 1, -1 do
    local i_v = FunctionConfig.menu_Hfunctions2[i];
    -- and (i_v ~= FunctionConfig.FUNCTION_ID_73 or (i_v == FunctionConfig.FUNCTION_ID_73 and ))
    if self.displayMenuHTable[i_v]  then
        curIndex = curIndex + 1;
        local xPos = (curIndex-1) * self.gap - 20;
        self.menuButtonMap[i_v]:setPositionXY(xPos, self.firstMenuY)
        self.menuButtonMap[i_v]:setVisible(true)
    else
        self.menuButtonMap[i_v]:setVisible(false)
    end
  end

  if self.huodongProxy.IsOpenFisrtSecondPay == true then
    self:refreshFirstPayToSecondPay();
  end
  self:refreshAllReddot();
end

function UserInfoGroupUI:closeButtonsByFunctionID( FUNCTION_ID )
  print("function UserInfoGroupUI:closeButtonsByFunctionID( FUNCTION_ID ) = ", FUNCTION_ID);
  -- if OpenFunctionProxy ~= nil then
    -- local openFunctionProxy = Facade.getInstance():retrieveProxy(OpenFunctionProxy.name);
    -- if openFunctionProxy ~= nil then
    --   print("FUNCTION_ID = ", FUNCTION_ID)
    --   openFunctionProxy.openedFunctionTable[FUNCTION_ID] = nil;
    -- end
  -- end
  -- print("--------------------============================")
  -- for k,v in pairs(openFunctionProxy.openedFunctionTable) do
  --   print(k,v)
  -- end
  -- print("end--------------------======================")



  if self.displayMenuHTable ~= nil then
    len = #FunctionConfig.menu_Hfunctions2;
    self.displayMenuHTable[FUNCTION_ID] = nil;

    local curIndex = 0;
    for i=len, 1, -1 do
      local index = FunctionConfig.menu_Hfunctions2[i];
      if self.displayMenuHTable[index] ~= nil then
        curIndex = curIndex + 1;
        local xPos = (curIndex -1) * self.gap -20;
        self.menuButtonMap[index]:setPositionXY(xPos, self.firstMenuY);
        self.menuButtonMap[index]:setVisible(true);
        print("FUNCTION_ID = ", index);
      else
        self.menuButtonMap[index]:setVisible(false);
        -- FunctionConfig.menu_Hfunctions2[i] = nil;

      end
    end
  end


  local openFunctionProxy = Facade.getInstance():retrieveProxy(OpenFunctionProxy.name);
  if openFunctionProxy ~= nil then
    print("FUNCTION_ID = ", FUNCTION_ID)
    openFunctionProxy:closeButton(FUNCTION_ID);
  end

end

function UserInfoGroupUI:setImageScale(image,buttonDO, funImage)
  image:setAnchorPoint(ccp(0.5,0.5))
  local size = image:getContentSize()
  image:setPositionXY(size.width/2,size.height/2 - 100)
  buttonDO.imageButton = image
end


function UserInfoGroupUI:refreshHuoDongLogin(value)
  print("function UserInfoGroupUI:refreshHuoDongLogin(value)")
    local arr=self.huodongProxy:getData()
    for i,v in ipairs(arr) do
      
      if(v.BooleanValue == 1) and
        (v.ID == 1 or   
        (v.ID == 5)  or  
        (v.ID == 6)  or  
        (v.ID == 14) or 
        (v.ID == 16))
        then
        print(" v.ID = ", v.ID, v.BooleanValue);
        self.effect_containers[FunctionConfig.FUNCTION_ID_41]:setVisible(true)
        return 
      end
    end
    -----
    self.effect_containers[FunctionConfig.FUNCTION_ID_41]:setVisible(false)
end


function UserInfoGroupUI:refreshFirstPayLogin(booleanValue)
  -- print("\n\n\n\n\n-------------------------function UserInfoGroupUI:refreshFirstPayLogin(booleanValue) = ", booleanValue)

  if booleanValue == 1 then
    self.effect_containers[FunctionConfig.FUNCTION_ID_56]:setVisible(true)
  else
    self.effect_containers[FunctionConfig.FUNCTION_ID_56]:setVisible(false)
  end
end

function UserInfoGroupUI:refreshFirstPayToSecondPay(booleanValue)
  booleanValue = booleanValue or self.huodongProxy.IsFirstPay;

  if booleanValue == true then
    --首充
   self.firstPayImage:setVisible(true);
  else
    --累充
    self.firstPayDO:removeChild(self.firstPayImage);
    self.firstPayImage = Image.new();
    self.firstPayImage:loadByArtID(1670)
    self.firstPayDO:addChildAt(self.firstPayImage, 0);
    self:setImageScale(self.firstPayImage, self.firstPayDO)
  end
end

function UserInfoGroupUI:refreshSecondPay( booleanValue )
  -- add by mohai.wu 刷新累充小红点
  self:refreshFirstPayLogin(booleanValue);
end

function UserInfoGroupUI:refreshSevenDays( booleanValue )
  -- if booleanValue == 1 then
  self.effect_containers[FunctionConfig.FUNCTION_ID_73]:setVisible(booleanValue);
  -- else
  --   self.effect_containers[FunctionConfig.FUNCTION_ID_73]:setVisible(false);
  -- end
end

function UserInfoGroupUI:openSevenDaysIcon()
  self.sevendaysImg:setVisible(true);
end

function UserInfoGroupUI:refreshHuoDong()
   print("function UserInfoGroupUI:refreshHuoDong(value)")
    -- local arr=self.huodongProxy:getRedDotTab()
    -- --0 不能领奖 1可以领奖
    -- for i,v in ipairs(arr) do
    --   print("--===============v.BooleanValue = ", v.BooleanValue);
    --     if v.BooleanValue == 1 then
    --       self.effect_containers[FunctionConfig.FUNCTION_ID_41]:setVisible(true);
    --       return;
    --     end
    -- end
    
    -- self.effect_containers[FunctionConfig.FUNCTION_ID_41]:setVisible(false)
end
function UserInfoGroupUI:refreshHuoDongReddot(boolean)
  -- add by mohai.wu 去除上面更新小红点函数
  print("function UserInfoGroupUI:refreshHuoDongReddot(  )")
  self.effect_containers[FunctionConfig.FUNCTION_ID_41]:setVisible(boolean)
end

function UserInfoGroupUI:refreshMonthCard()
   
    local visible = GameData.hasRedDotArr[FunctionConfig.FUNCTION_ID_53] and true or false;
    self.effect_containers[FunctionConfig.FUNCTION_ID_53]:setVisible(visible)
    print("UserInfoGroupUI:refreshmonthCard(),visible", visible)
end


function UserInfoGroupUI:getTargetButtonPosition(functionId)
  local returnData = {};
  local function callBack()
    print("UserInfoGroupUI:getTargetButtonPosition call back")
  end
  local  curIndex = 0;
  self.displayMenuHTable[functionId] = functionId;

  local  curIndex = 0;
  local len = #FunctionConfig.menu_Hfunctions2
  for i = len, 1, -1 do
    local i_v = FunctionConfig.menu_Hfunctions2[i];
    if self.displayMenuHTable[i_v] then
        curIndex = curIndex + 1;
        local xPos = (curIndex-1) * self.gap - 20;
        self.menuButtonMap[i_v]:setPositionXY(xPos, self.firstMenuY)
        self.menuButtonMap[i_v]:setVisible(true)
    else
        self.menuButtonMap[i_v]:setVisible(false)
    end
  end
  local pos = self.menuButtonMap[functionId]:getPosition();

  local parentPos = self:getPosition();
  pos.x = pos.x*0.8 + parentPos.x + 138- GameData.uiOffsetX
  pos.y =  self.winSize.height - 164 - GameData.uiOffsetY

  returnData["x"] = pos.x + 10;
  returnData["y"] = pos.y;
  returnData["callBack"] = callBack;
  return returnData;
end

function UserInfoGroupUI:refreshAllReddot()
  -- add by mohai.wu 
  --刷新主界面时候刷新活动小红点
  local sevendaysId = {7,8,9,10,11,12,13};
  local huodongId = {1,5,6,14,16}
  local firstSecondPayId = {4,17}
  
  local boolean = self.huodongProxy:getReddotState(nil, sevendaysId);
  if boolean == nil then 
    return
  end
  if boolean == 1 then
    self:refreshSevenDays(true);
  else
    self:refreshSevenDays(false)
  end

  boolean = self.huodongProxy:getReddotState(nil, huodongId);
  if boolean == nil then 
    return
  end
  if boolean == 1 then
    self:refreshHuoDongReddot(true);
  else
    self:refreshHuoDongReddot(false);
  end

  boolean = self.huodongProxy:getReddotState(nil, firstSecondPayId);
  if boolean == nil then 
    return
  end
  self:refreshFirstPayLogin(boolean);
end