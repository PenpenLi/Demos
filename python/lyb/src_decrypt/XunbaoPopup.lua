
XunbaoPopup=class(LayerPopableDirect);

local _currentPlace = 0
local _reRollPrice = 20
local _jumpPrice = 20
local _confirmReroll = false --一次打开只弹一次确认花钱
local _confirmJump = false


function XunbaoPopup:ctor()
  self.class=XunbaoPopup;
  self.pointPositionTable = {}
  self.singalIconTable = {}
  _confirmReroll = false --一次打开只弹一次确认花钱
  _confirmJump = false 
  self.lastRollValue = 0 
end

function XunbaoPopup:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  XunbaoPopup.superclass.dispose(self);
  self.armature:dispose()
end

function XunbaoPopup:onDataInit()
  self.userCurrencyProxy = self:retrieveProxy(UserCurrencyProxy.name);
  self.xunbaoProxy = self:retrieveProxy(XunbaoProxy.name);
  self.userProxy = self:retrieveProxy(UserProxy.name);
  self.bagProxy = self:retrieveProxy(BagProxy.name);

  self.xunbaoData = self.xunbaoProxy:getData()
  self.skeleton = self.xunbaoProxy:getSkeleton();

  local layerPopableData=LayerPopableData.new();
  layerPopableData:setHasUIBackground(true)
  layerPopableData:setHasUIFrame(false)
  layerPopableData:setPreUIData(StaticArtsConfig.XUNBAO_BG, nil, true);
  layerPopableData:setArmatureInitParam(self.skeleton,"xunbao_ui")
  layerPopableData:setShowCurrency(false);
  self:setLayerPopableData(layerPopableData)

end

function XunbaoPopup:initialize()
  self:initLayer();
end

function XunbaoPopup:onPrePop()

  local pointGroup = self.armature:findChildArmature("pointGroup")

  -- title
  local titleDO = self.armature:getBone("title"):getDisplay()
  local titlePos = titleDO:getPosition()
  titleDO:setPositionXY(titlePos.x,titlePos.y + GameData.uiOffsetY)

  local textTips = BitmapTextField.new("寻宝","anniutuzi")
  textTips:setPositionXY(600,665 + GameData.uiOffsetY)
  textTips.touchEnable = false
  self:addChild(textTips)

  self.pointPositionTable[0] = pointGroup:getBone("point_0"):getDisplay():getPosition()

  -- floor
  for k1,v1 in pairs(self.xunbaoData.hunkTaskArray) do

    local xunbaoVO = analysis("Xunbao_Renwushuaxin",v1.ID)
    local pointType = xunbaoVO.type
    if 1 == v1.BooleanValue then -- 问号
      pointType = 5
    end

    local singalPointPos
    if pointType == 6 then -- boss
      singalPointPos = pointGroup:getBone("point_"..v1.Place):getDisplay():getPosition()
      self.bossAnimation = getCompositeRole(xunbaoVO.eventType2)
      self.bossAnimation.bodyIcon:setScale(0.75)
      self.bossAnimation:setPositionXY(singalPointPos.x + 90,singalPointPos.y + 665)
      self:addChild(self.bossAnimation)

      local roleShadow = Image.new()
      roleShadow:loadByArtID(StaticArtsConfig.IMAGE_HERO_SHADOW)
      roleShadow:setPositionXY(0,10)
      roleShadow:setAnchorPoint(CCPointMake(0.5,0.75));
      roleShadow.touchEnabled = false
      roleShadow.touchChildren = false
      self.bossAnimation:addChildAt(roleShadow,0);     

    else
        local singalBack = self.skeleton:getBoneTextureDisplay("back_"..xunbaoVO.quality)
        if pointType == 9 then
          pointType = 2
        end

        singalPointPos = pointGroup:getBone("point_"..v1.Place):getDisplay():getPosition()
        singalBack:setPositionXY(singalPointPos.x,singalPointPos.y + 630)
        
        local singalIcon          
        singalIcon = self.skeleton:getBoneTextureDisplay("type_"..pointType)
        singalIcon:setPositionXY(45,15)  
        singalBack:addChild(singalIcon)
        self.singalIconTable[v1.Place] = singalIcon
  
        self:addChild(singalBack)

    end

    self.pointPositionTable[v1.Place] = singalPointPos
  end


  local beginDO = pointGroup:getBone("point_0"):getDisplay()
  beginDO:setScale(0.75)

  -- person stand
  local transforId
  if self.userProxy.transforId == 0 then
    if self.userProxy:getCareer() == 1 then
      transforId = 1
    else
      transforId = 2
    end
  else
    transforId = self.userProxy.transforId
  end

  local huanHuaPo = analysis("Zhujiao_Huanhua", transforId) 
  self.roleHold = getCompositeRole(huanHuaPo.body)  

  -- 跑步动画先隐藏
  local roleRunTable = AvatarUtil:getCompositeRoleTable(huanHuaPo.body, nil, BattleConfig.RUN);
  self.roleRun  = CompositeActionAllPart.new();
  self.roleRun:initLayer();
  self.roleRun:transformPartCompose(roleRunTable);

  local roleShadow = Image.new()
  roleShadow:loadByArtID(StaticArtsConfig.IMAGE_HERO_SHADOW)
  roleShadow:setAnchorPoint(CCPointMake(0.5,0.75));
  roleShadow.touchEnabled = false
  roleShadow.touchChildren = false
  self.roleRun:addChildAt(roleShadow,0);  

  local roleShadow1 = Image.new()
  roleShadow1:loadByArtID(StaticArtsConfig.IMAGE_HERO_SHADOW)
  roleShadow1:setAnchorPoint(CCPointMake(0.5,0.75));
  roleShadow1.touchEnabled = false
  roleShadow1.touchChildren = false
  self.roleHold:addChildAt(roleShadow1,0); 

  self.roleHold.bodyIcon:setScale(0.75)
  self.roleRun.bodyIcon:setScale(0.75)
  local rolePointPos = pointGroup:getBone("point_"..self.xunbaoData.place):getDisplay():getPosition()  

  self:addChild(self.roleRun)  
  self:addChild(self.roleHold)

  -- local shadowImage = Image.new()
  -- shadowImage:loadByArtID(19)
  -- shadowImage:setAnchorPoint(CCPointMake(0.5,0.5))

  -- self.roleHold:addChildAt(shadowImage,0)
  -- self.roleRun:addChildAt(shadowImage,0)

  self:refreshData(true)

  for i=1,26 do
    local pointDO = pointGroup:getBone("point_"..i):getDisplay()
    pointGroup.display:removeChild(pointDO)
  end

  _reRollPrice = analysis("Xishuhuizong_Xishubiao",1085,"constant");
  _jumpPrice = analysis("Xishuhuizong_Xishubiao",1086,"constant");

  self.askButton =self.armature.display:getChildByName("ask_btn");
  SingleButton:create(self.askButton);

  local askPos = self.askButton:getPosition()
  self.askButton:setPositionXY(askPos.x,askPos.y + GameData.uiOffsetY)
  self.askButton:addEventListener(DisplayEvents.kTouchTap, self.askTap, self);  

  local closeBtn =self.armature.display:getChildByName("common_copy_close_button")
  local closeBtnPos = closeBtn:getPosition()
  closeBtn:setPositionXY(closeBtnPos.x,closeBtnPos.y + GameData.uiOffsetY)
end

function XunbaoPopup:refreshData(isFirstOpen)

  if self.killTips then
      self:removeChild(self.killTips)
      self.killTips = nil
  end

  local function walkCallBack()

    if self.xunbaoData.place == 27 then
      self.bossAnimation:setVisible(false)
    end

    -- state
    self.currentState = self.xunbaoData.state
    local eventId,eventParam = self:getCurrentPointId()
    if self.currentState == 0 then --任务已完成未开始摇骰子
      self:rollUI()
    elseif self.currentState == 1 then--摇骰子了但没有确认
      self:rollUI(self.xunbaoData.rollCount)
    elseif self.currentState == 2 then -- 任务未完成
      local xunbaoVO = analysis("Xunbao_Renwushuaxin",eventId)
      if (xunbaoVO.type == 1 
        or xunbaoVO.type == 2
        or xunbaoVO.type == 9) then
        self:taskUI(xunbaoVO,1,eventParam)
      elseif (xunbaoVO.type == 3 
        or xunbaoVO.type == 4
        or xunbaoVO.type == 6) then
        self:tipsUI(xunbaoVO)
      elseif (xunbaoVO.type == 7 
        or xunbaoVO.type == 8) then
        self:jumpTipsUI(xunbaoVO)
      end
    elseif self.currentState == 3 then  -- 任务完成未领奖励
      local xunbaoVO = analysis("Xunbao_Renwushuaxin",eventId)
      if xunbaoVO.type == 6 then
        -- boss 宝箱
        self:bossReward()
      else
        self:taskUI(xunbaoVO,2,eventParam)
      end
    elseif self.currentState == 4 then   -- 寻宝完成
      self:tipsOver()
    end
  end 

  self:walkStuff(isFirstOpen,walkCallBack)

end

function XunbaoPopup:walkStuff(isFirstOpen,callBack)

  log("_currentPlace===".._currentPlace)
  log("self.xunbaoData.place==="..self.xunbaoData.place)

  if isFirstOpen then -- 打开UI

    _currentPlace = self.xunbaoData.place

    for i=1,_currentPlace do
      if i > 0 and i < 27 then
        self.singalIconTable[i]:setVisible(false)
      end
    end

    if _currentPlace >= 18 then
      self.roleHold:setScaleX(-1)
    else
      self.roleHold:setScaleX(1)
    end

    self.roleHold:setVisible(true)
    self.roleRun:setVisible(false)
    
    local pos = self.pointPositionTable[_currentPlace]
    self.roleHold:setPositionXY(pos.x + 80,pos.y + 680)
    self.roleRun:setPositionXY(pos.x + 80,pos.y + 680)

    callBack()
  else -- 刷新UI
    if _currentPlace < self.xunbaoData.place then -- 打过的图标就不显示了 

      self:walkTo(callBack)

    elseif  _currentPlace == self.xunbaoData.place then

      self.roleHold:setVisible(true)
      self.roleRun:setVisible(false)
      
      local pos = self.pointPositionTable[_currentPlace]
      self.roleHold:setPositionXY(pos.x + 80,pos.y + 680)
      self.roleRun:setPositionXY(pos.x + 80,pos.y + 680)

      callBack()
    else
      if _currentPlace > 0 and _currentPlace < 27 then
        self.singalIconTable[_currentPlace]:setVisible(true)
      end       
      self:walkTo(callBack)
    end 

  end
  
end

function XunbaoPopup:walkTo(callBack)

  log("walkTo-----_currentPlace===".._currentPlace)
  log("walkTo-----self.xunbaoData.place==="..self.xunbaoData.place)

  local zhengfu = 1
  if _currentPlace > self.xunbaoData.place then
    zhengfu = -1
  end

  local pos = self.pointPositionTable[_currentPlace]
  self.roleRun:setPositionXY(pos.x + 80,pos.y + 680)

  local function walkCallBackFunc()

    log("walkCallBackFunc---_currentPlace===".._currentPlace)
    log("walkCallBackFunc---self.xunbaoData.place==="..self.xunbaoData.place)

    if _currentPlace < self.xunbaoData.place then -- 打过的图标就不显示了  
      if _currentPlace > 0 and _currentPlace < 27 then
        self.singalIconTable[_currentPlace]:setVisible(false)
      end 

      self:walkTo(callBack)
    elseif  _currentPlace == self.xunbaoData.place then
      if _currentPlace > 0 and _currentPlace < 27 then
        self.singalIconTable[_currentPlace]:setVisible(false)
      end
      self.roleHold:setVisible(true)
      self.roleRun:setVisible(false)

      local pos = self.pointPositionTable[_currentPlace]
      self.roleHold:setPositionXY(pos.x + 80,pos.y + 680)

      callBack()
    else
      if _currentPlace > 0 and _currentPlace < 27 then
        self.singalIconTable[_currentPlace]:setVisible(true)
      end 
      self:walkTo(callBack)
    end   

    if _currentPlace >= 18 then
      self.roleHold:setScaleX(-1)
    else
      self.roleHold:setScaleX(1)
    end
  end

  self.roleRun:setVisible(true)
  self.roleHold:setVisible(false)


  _currentPlace = _currentPlace + 1 * zhengfu
  if _currentPlace < 0 then
    _currentPlace = 0
  end

  if _currentPlace >= 18 then
    self.roleRun:setScaleX(-1)
  else
    self.roleRun:setScaleX(1)
  end

  local pos1 = self.pointPositionTable[_currentPlace]
  local spawnTwoArray = CCArray:create();
  spawnTwoArray:addObject(CCMoveTo:create(0.5, ccp(pos1.x + 80,pos1.y + 680))); 
  spawnTwoArray:addObject(CCCallFunc:create(walkCallBackFunc));
  self.roleRun:runAction(CCSequence:create(spawnTwoArray));
  
end

function XunbaoPopup:getCurrentPointId()
  for k,v in pairs(self.xunbaoData.hunkTaskArray) do
    if self.xunbaoData.place == v.Place then
      return v.ID,v.Param
    end
  end
end

function XunbaoPopup:rollUI(value)

  if self.rollUILayer then
    self:removeChild(self.rollUILayer)
    self.rollUILayer = nil
  end

  self.rollUILayer = Layer.new()
  self.rollUILayer:initLayer()  

  -- local backHalfAlphaLayer = LayerColorBackGround:getBackGround()
  -- backHalfAlphaLayer:setPositionXY(-1 * GameData.uiOffsetX, -1 * GameData.uiOffsetY)
  -- self.rollUILayer:addChild(backHalfAlphaLayer)    

  -- 初始化roll UI
  local armature1 = self.skeleton:buildArmature("roll_ui");
  armature1.animation:gotoAndPlay("f1");
  armature1:updateBonesZ();
  armature1:update();

  self.rollUILayer:addChild(armature1.display);

  self.button1 = Button.new(armature1:findChildArmature("common_blue_button1"),nil,"重掷");
  self.button2 = Button.new(armature1:findChildArmature("common_blue_button2"),nil,"确定");
  self.button3 = Button.new(armature1:findChildArmature("common_blue_button3"),nil,"掷骰");

  self.button1:setVisible(true)
  self.button2:setVisible(true)
  self.button3:setVisible(true)

  local displayValue
  if value then -- 已经ROLL过了
    displayValue = value
    self.lastRollValue = value
    self.button3:setVisible(false)
    self.button1:addEventListener(Events.kStart, self.onReRoll, self);
    self.button2:addEventListener(Events.kStart, self.onConfirmRoll, self);
  else -- 去ROLL
    if self.lastRollValue == 0 then
      displayValue = math.random(1,6)
    else
      displayValue = self.lastRollValue
    end

    self.button1:setVisible(false)
    self.button2:setVisible(false)
    self.button3:addEventListener(Events.kStart, self.onRoll, self);
  end
  
  self.rollicon = self.skeleton:getBoneTextureDisplay("roll_"..displayValue)
  self.rollicon:setPositionXY(600,320)
  self.rollUILayer:addChild(self.rollicon)

  self:addChild(self.rollUILayer)


  if GameVar.tutorStage == TutorConfig.STAGE_1020 then--1020是寻宝
    openTutorUI({x=676, y=200, width = 192, height = 60});
  end

end

function XunbaoPopup:onEnterCallBack()
  sendMessage(8,9) -- 确认完成事件
end

-- with reward ui
function XunbaoPopup:taskUI(dataVO,type,eventParam)
  if self.rollUILayer then
    self:removeChild(self.rollUILayer)
    self.rollUILayer = nil
  end
  local eventType = dataVO.type
  local function doAction()
    if type == 1 then 
      if eventType == 1 then -- 追杀  弹出配兵界面
        self:dispatchEvent(Event.new(MainSceneNotifications.TO_HEROTEAMSUB,{context = self, onEnter = self.onEnterCallBack,funcType = "XunBao"},self))
      elseif eventType == 2 then -- 关卡 弹关卡信息界面
        self.xunbaoProxy.isFromXunbao = true
        self:dispatchEvent(Event.new("TO_STRONGPOINT", {strongPointId = eventParam},self));
      elseif eventType == 9 then -- 英雄志，弹英雄志界面
        self.xunbaoProxy.isFromXunbao = true
        OpenHeroImageUICommand.new():execute(ShadowNotification.new(ShadowNotifications.OPEN_HEROIMAGE_UI_COMMAND, {strongPointId = eventParam,unvisibleMenu = true}))
      end
    else
      sendMessage(8,11) -- 领取奖励
    end    
  end

  self.killTips=CommonPopup.new();
  local function onJump() -- 花钱消灾
  
    if _jumpPrice > self.userCurrencyProxy:getGold() then
      sharedTextAnimateReward():animateStartByString("亲~元宝不够了哦")
      -- sharedTextAnimateReward():animateStartByString("元宝不足".._jumpPrice)
      self:dispatchEvent(Event.new("TO_VIP"));
      return
    end
    _confirmJump = true
    self.killTips:onSmallCloseButtonTap();

    hecDC(3,27,4)
    sendMessage(8,10)
  end

  local function onJumpConfirm()
    local castWord = "是否确定花费" .. _jumpPrice .. "元宝跳过本事件?"
    local tips1 = CommonPopup.new();
    tips1:initialize(castWord,self,onJump,nil,nil,nil,true,nil,nil,true,1);    
    if _confirmJump then
      onJump()
    else
      self:addChild(tips1)
    end

  end

  local anniuStr = ""
  local desStr = dataVO.description
  if type == 1 then 
    if eventType == 2 or eventType == 9 then
      anniuStr = "前往"
      
      local replaceStr = analysis("Juqing_Guanka",eventParam,"scenarioName");
      replaceStr = "["..replaceStr.."]"
      desStr = StringUtils:stuff_string_replace(desStr,"&",replaceStr)

    elseif eventType == 1 then
      anniuStr = "追杀"
    end
  else  
    if eventType == 2 or eventType == 9 then   

      local replaceStr = analysis("Juqing_Guanka",eventParam,"scenarioName");
      replaceStr = "["..replaceStr.."]"
      desStr = StringUtils:stuff_string_replace(desStr,"&",replaceStr)

    end

    anniuStr = "领取"

  end

  local textTable = {}
  textTable[1] = anniuStr
  if type == 1 then 
    textTable[2] = "放弃"
    self.killTips:initialize(desStr,self,doAction,nil,onJumpConfirm,nil,false,textTable,nil,true,1);
    self.killTips:isAutoCloseUI(false)
  elseif type == 2 then
    self.killTips:initialize(desStr,self,doAction,nil,onJumpConfirm,nil,true,textTable,nil,true,1);
  end
  
  self.killTips:initializeTitle(dataVO.name)
  self.killTips:closeButtonVisible(false)
  self.killTips:isBackModal(false)  
  self:addChild(self.killTips)

  local viewList = ListScrollViewLayer.new();
  viewList:initLayer();
  viewList:setScale(0.75)
  viewList:setPositionXY(440,290 + GameData.uiOffsetY)
  viewList:setDirection(kCCScrollViewDirectionHorizontal);
  viewList:setViewSize(makeSize(400,180));
  viewList:setItemSize(makeSize(120,150));
  self.armature.display:addChild(viewList);

  local itemTable = StringUtils:lua_string_split(dataVO.item,";")
  for k,v in pairs(itemTable) do
    local singalItemTable = StringUtils:lua_string_split(v,",")
    local common_grid=CommonSkeleton:getBoneTextureDisplay("commonGrids/common_grid");
    require "main.view.bag.ui.bagPopup.BagItem"
    local itemImage = BagItem.new(); 
    itemImage:initialize({ItemId = singalItemTable[1], Count = singalItemTable[2]});
    itemImage:setPositionXY(6.8,7.8)

    local itemLayer = Layer.new()
    itemLayer:initLayer()
    itemLayer:addChild(common_grid)
    itemLayer:addChild(itemImage)
    itemImage.touchEnabled=true;
    itemImage.touchChildren=true;
    itemImage:addEventListener(DisplayEvents.kTouchTap,self.onTap,self);
    viewList:addItem(itemLayer)
  end  

  self.killTips:addChild(viewList)
end
function XunbaoPopup:onTap(event)
  self:dispatchEvent(Event.new("ON_ITEM_TIP", {item = event.target},self));
end
-- just tips
function XunbaoPopup:tipsUI(dataVO)
  if self.rollUILayer then
    self:removeChild(self.rollUILayer)
    self.rollUILayer = nil
  end
  local eventType = dataVO.type

  local tips=CommonPopup.new();
  local function doAction()
    if dataVO.type == 3 then -- 上缴判断钱够不够
      local itemCount = 0
      if dataVO.eventType == 2 then
        itemCount = self.userCurrencyProxy:getSilver()
      elseif dataVO.eventType == 3 then
        itemCount = self.userCurrencyProxy:getGold()
      else
        itemCount = self.bagProxy:getItemNum(dataVO.eventType)
      end

      -- log("itemCount=="..itemCount)
      if itemCount < dataVO.eventType2 then
        local itemName = analysis("Daoju_Daojubiao", dataVO.eventType,"name");
          if dataVO.eventType == 2 then
            sharedTextAnimateReward():animateStartByString("亲~银两不足了哦")
            self:dispatchEvent(Event.new("TO_DIANJINSHOU"));
          elseif dataVO.eventType == 3 then
            sharedTextAnimateReward():animateStartByString("亲~元宝不够了哦")
            -- sharedTextAnimateReward():animateStartByString(itemName.."不足"..dataVO.eventType2)
            self:dispatchEvent(Event.new("TO_VIP"));
          end

        return 
      end

      sendMessage(8,9) -- 确认完成事件
      
      sharedTextAnimateReward():animateStartByString("伤心的上缴完毕")
            
      self:removeChild(tips)
    elseif dataVO.type == 4 then -- BOSS
      sendMessage(8,9) -- 确认完成事件
      self:removeChild(tips)
    elseif dataVO.type == 6 then -- BOSS
      self:dispatchEvent(Event.new(MainSceneNotifications.TO_HEROTEAMSUB,{context = self, onEnter = self.onEnterCallBack,funcType = "XunBao"},self))
      -- self:removeChild(tips)
    end
  end

  local anniuStr = ""

  if eventType == 3 then
    anniuStr = "上缴"
  elseif eventType == 4 then
    anniuStr = "捡起来"
  elseif eventType == 6 then
    anniuStr = "追杀"
  end
  local textTable = {}
  textTable[1] = anniuStr
  tips:initialize(dataVO.description,self,doAction,nil,nil,nil,true,textTable,nil,true,1);
  tips:initializeTitle(dataVO.name)
  tips:isAutoCloseUI(false)
  tips:closeButtonVisible(false)
  tips:isBackModal(false)  
  self:addChild(tips)
end

-- can jump tips
function XunbaoPopup:jumpTipsUI(dataVO)
  if self.rollUILayer then
    self:removeChild(self.rollUILayer)
    self.rollUILayer = nil
  end

  local eventType = dataVO.type


  local tips = CommonPopup.new();
  local tips1

  local function onConfirm()
    sendMessage(8,9) -- 确认完成事件

    self:removeChild(tips)
    self:removeChild(tips1)    
  end

  local function onJump() -- 花钱消灾

    if _jumpPrice > self.userCurrencyProxy:getGold() then
      sharedTextAnimateReward():animateStartByString("亲~元宝不够了哦")
      self:dispatchEvent(Event.new("TO_VIP"));
      return
    end
    hecDC(3,27,4)
    sendMessage(8,10)

    self:removeChild(tips)
    self:removeChild(tips1)
  end

  local function onJumpConfirm()

    -- if tips1 then
    --   self:removeChild(tips1)
    -- end

    tips1 = CommonPopup.new();
    local castWord = "是否确定花费" .. _jumpPrice .. "元宝跳过本事件?"
    tips1:initialize(castWord,self,onJump,nil,nil,nil,true,nil,nil,true,1);
    -- tips1:closeButtonVisible(false)
    -- tips1:isBackModal(false)
    self:addChild(tips1)
  end

  local textTable = {"确定","放弃"}
  tips:initialize(dataVO.description,self,onConfirm,nil,onJumpConfirm,nil,false,textTable,nil,true,1);
  tips:initializeTitle(dataVO.name)
  tips:isAutoCloseUI(false)
  tips:closeButtonVisible(false)
  tips:isBackModal(false)  
  self:addChild(tips)  
end

function XunbaoPopup:askTap(event)
  local functionStr = analysis("Tishi_Guizemiaoshu",16,"txt");
  
  TipsUtil:showTips(event.target,functionStr,nil,0);
end

function XunbaoPopup:onRoll()
  if self.rollicon then
    self.rollUILayer:removeChild(self.rollicon)
  end

  self.button3:setVisible(false)

  -- roll动画播放完毕
  local rollEffect
  local function rollComplete()
    self:removeChild(rollEffect)
    sendMessage(8,7)

    self.rollEffect1 = cartoonPlayer("724",640,360,2,rollComplete,1,nil,nil)
    self.rollUILayer:addChild(self.rollEffect1)    
  end

  rollEffect = cartoonPlayer("724",640,360,1,rollComplete,1,nil,nil)
  self:addChild(rollEffect)

  if GameVar.tutorStage == TutorConfig.STAGE_1020 then--1020是寻宝
    closeTutorUI(false)
  end
end

function XunbaoPopup:onReRoll()

  local function onConfirmReroll()

    if _reRollPrice > self.userCurrencyProxy:getGold() then
      sharedTextAnimateReward():animateStartByString("亲~元宝不够了哦")
      -- sharedTextAnimateReward():animateStartByString("元宝不足".._reRollPrice)
      self:dispatchEvent(Event.new("TO_VIP"));
      return
    end

   if self.rollicon then
      self.rollUILayer:removeChild(self.rollicon)
    end

    self.button1:setVisible(false)
    self.button2:setVisible(false)

    -- roll动画播放完毕
    local rollEffect
    local function rollComplete()
      self:removeChild(rollEffect)
      sendMessage(8,7)
      hecDC(3,27,2)
      _confirmReroll = true
      self.rollEffect1 = cartoonPlayer("724",640,360,0,rollComplete,1,nil,nil)
      self.rollUILayer:addChild(self.rollEffect1)    
    end

    rollEffect = cartoonPlayer("724",640,360,1,rollComplete,1,nil,nil)
    self:addChild(rollEffect)
  end

  if _confirmReroll then
    onConfirmReroll()
  else
    local tips1 = CommonPopup.new();
    local castWord = "是否确定花费" .. _reRollPrice .. "元宝重掷一次骰子?"
    tips1:initialize(castWord,self,onConfirmReroll,nil,nil,nil,true,nil,nil,true,1);
    self:addChild(tips1)  
  end

end

function XunbaoPopup:onConfirmRoll()
  if self.rollUILayer then
    self:removeChild(self.rollUILayer)
    self.rollUILayer = nil
  end
  sendMessage(8,8)
  if GameVar.tutorStage == TutorConfig.STAGE_1020 then--1020是寻宝
    sendServerTutorMsg({})
    closeTutorUI();
  end
end

function XunbaoPopup:onGetBox()
  
  MusicUtils:playEffect(501,false);

  if self.getEffect then
    self:removeChild(self.getEffect)
  end

  local overEffect = cartoonPlayer("854",640,360,1,nil,2,nil,nil)
  self:addChild(overEffect)   

  require "main.view.xunbao.ui.RewardBoxShow";
  local starBoxUI = RewardBoxShow.new()
  LayerManager:addLayerPopable(starBoxUI);  
  starBoxUI:initialize(self);
end

function XunbaoPopup:bossReward()

  self.boxImage = Image.new()
  self.boxImage:loadByArtID(1245)
  self.boxImage:setPositionXY(640,320)
  self.boxImage:setAnchorPoint(CCPointMake(0.5,0.5));
  self:addChild(self.boxImage)
  self.boxImage:addEventListener(DisplayEvents.kTouchBegin, self.onGetBox, self);

  self.getEffect = cartoonPlayer("867",640,320,0,rollComplete,2,nil,nil)
  self:addChild(self.getEffect)  

  self.roleHold:setPositionXY(545,445)
end

function XunbaoPopup:onTellTips()
  sharedTextAnimateReward():animateStartByString("本次寻宝已完成")
end

function XunbaoPopup:tipsOver()
  if self.boxImage then
    self:removeChild(self.boxImage)
    self.boxImage = nil
  end
  self.boxImage = Image.new()
  self.boxImage:loadByArtID(1244)
  self.boxImage:setPositionXY(640,320)
  self.boxImage:setAnchorPoint(CCPointMake(0.5,0.5));
  self:addChild(self.boxImage)
  self.boxImage:addEventListener(DisplayEvents.kTouchBegin, self.onTellTips, self);

  self.roleHold:setPositionXY(545,445)

end

function XunbaoPopup:stopRolling()

  local displayValue = 1
  if self.lastRollValue == 0 then
    displayValue = math.random(1,6)

    if self.button1 then
      self.button1:setVisible(false)
    end
    if self.button2 then
      self.button2:setVisible(false)
    end
    if self.button3 then
      self.button3:setVisible(true)
    end       
  else
    displayValue = self.lastRollValue

    if self.button1 then
      self.button1:setVisible(true)
    end
    if self.button2 then
      self.button2:setVisible(true)
    end
    if self.button3 then
      self.button3:setVisible(false)
    end       
  end

  self.rollicon = self.skeleton:getBoneTextureDisplay("roll_"..displayValue)
  self.rollicon:setPositionXY(600,320)

  if self.rollUILayer then
    self.rollUILayer:addChild(self.rollicon)
    self.rollUILayer:removeChild(self.rollEffect1)
  end
end

function XunbaoPopup:onUIClose()
  self:dispatchEvent(Event.new("CLOSE_XUNBAO",nil,self));
end
