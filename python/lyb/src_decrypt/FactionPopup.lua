require "main.view.faction.ui.FactionCurrencyUI";
FactionPopup = class(LayerPopableDirect);
function FactionPopup:ctor()
	self.class = FactionPopup;
  self.bgImage = nil;
  self.materialLayer = nil;
  self.nameLayer = nil;
  self.layerCloor_alpha = 0;
end

function FactionPopup:dispose()

	self:removeAllEventListeners();
	self:removeChildren();
	FactionPopup.superclass.dispose(self);
end

function FactionPopup:initialize()
    self:initLayer();

    local mainSize = Director:sharedDirector():getWinSize();

    self.childLayer = LayerColor.new();
    self.childLayer:initLayer();
    self.childLayer:setContentSize(makeSize(mainSize.width, mainSize.height));
    self.childLayer:setPositionXY(-GameData.uiOffsetX,  -GameData.uiOffsetY);

    self:addChild(self.childLayer)

    self.bgImage = Image.new();
    self.bgImage:loadByArtID(621)
    self.bgImage:setAnchorPoint(makePoint(0.5, 0.5));
    self.bgImage:setPositionXY(mainSize.width/2, mainSize.height/2);
    self.childLayer:addChild(self.bgImage)



    self.materialLayer = Layer.new();
    self.materialLayer:initLayer();
    self:addChild(self.materialLayer);

    self.backLayer = Layer.new();
    self.backLayer:initLayer();
    self:addChild(self.backLayer);

    self.nameLayer = Layer.new();
    self.nameLayer:initLayer();
    self:addChild(self.nameLayer);


    self:setContentSize(makeSize(mainSize.width, mainSize.height));

end
function FactionPopup:onDataInit()

  self.storyLineProxy = self:retrieveProxy(StoryLineProxy.name);
  local layerPopableData = LayerPopableData.new();
  
  self:setLayerPopableData(layerPopableData);

end

function FactionPopup:initializeUI()

 
  self.shiGuoZhengZhan = Image.new();
  self.shiGuoZhengZhan:loadByArtID(993)
  self.shiGuoZhengZhan.name = "shiGuoZhengZhan"
  self.materialLayer:addChild(self.shiGuoZhengZhan)
  self.shiGuoZhengZhan:setPositionXY(0, 219);
  self.shiGuoZhengZhan:addEventListener(DisplayEvents.kTouchBegin, self.onTouchBegin, self);
  
  self.shiGuoZhengZhan_zi = Image.new();
  self.shiGuoZhengZhan_zi:loadByArtID(998)
  self.shiGuoZhengZhan_zi.touchEnabled = false;
  self.nameLayer:addChild(self.shiGuoZhengZhan_zi)
  self.shiGuoZhengZhan_zi:setPositionXY(180, 390);

  -- self.shiGuoZhengZhan_zi = BitmapTextField.new("十\n十\n十\n十","yingxiongmingzi");--BitmapTextField.new("十\n国\n征\n证","anniutuzi");
  -- self.shiGuoZhengZhan_zi.touchEnabled = false;
  -- self.nameLayer:addChild(self.shiGuoZhengZhan_zi)
  -- self.shiGuoZhengZhan_zi:setPositionXY(90 + 220, 306 + 110);



  -- self.chaoTang_zi = BitmapTextField.new("十\n十\n十\n十","yingxiongmingzi");--BitmapTextField.new("朝\n堂\n争\n辩","anniutuzi");
  -- self.chaoTang_zi.touchEnabled = false;
  -- self.nameLayer:addChild(self.chaoTang_zi)
  -- self.chaoTang_zi:setPositionXY(400 + 320, 276 + 110);

  self.langYaShiLian = Image.new();
  self.langYaShiLian:loadByArtID(991)
  self.langYaShiLian.name = "langYaShiLian"
  self.materialLayer:addChild(self.langYaShiLian)
  self.langYaShiLian:setPositionXY(847, 268);
  self.langYaShiLian:addEventListener(DisplayEvents.kTouchBegin, self.onTouchBegin, self);

  self.langYaShiLian_zi = Image.new();
  self.langYaShiLian_zi:loadByArtID(997)
  self.langYaShiLian_zi.touchEnabled = false;
  self.nameLayer:addChild(self.langYaShiLian_zi)
  self.langYaShiLian_zi:setPositionXY(964, 370);




  self.chaoTang = Image.new();
  self.chaoTang:loadByArtID(987)
  self.chaoTang.name = "chaoTang"
  self.materialLayer:addChild(self.chaoTang)
  self.chaoTang:setPositionXY(377, 44);
  self.chaoTang:addEventListener(DisplayEvents.kTouchBegin, self.onTouchBegin, self);
  
  self.chaoTang_zi = Image.new();
  self.chaoTang_zi:loadByArtID(995)
  self.chaoTang_zi.touchEnabled = false;
  self.nameLayer:addChild(self.chaoTang_zi)
  self.chaoTang_zi:setPositionXY(510, 260);


  self.langYaShiLian_layerColor = LayerColor.new();
  self.langYaShiLian_layerColor:initLayer();
  self.materialLayer:addChild(self.langYaShiLian_layerColor)
  self.langYaShiLian_layerColor.name = "langYaShiLian_layerColor"
  self.langYaShiLian_layerColor:setPositionXY(930,309)
  self.langYaShiLian_layerColor:changeWidthAndHeight(290, 213)
  self.langYaShiLian_layerColor:addEventListener(DisplayEvents.kTouchBegin, self.onTouchBegin, self);
  self.langYaShiLian_layerColor:setColor(ccc3(0,0,0));
  self.langYaShiLian_layerColor:setOpacity(self.layerCloor_alpha);

  -- self.langYaShiLian_zi = BitmapTextField.new("十\n十\n十\n十","yingxiongmingzi");--BitmapTextField.new("琅\n琊\n试\n炼","anniutuzi");
  -- self.langYaShiLian_zi.touchEnabled = false;
  -- self.nameLayer:addChild(self.langYaShiLian_zi)
  -- self.langYaShiLian_zi.touchEnabled = false;
  -- self.langYaShiLian_zi:setPositionXY(520 + 367, 20);

  self.huangChengShangDian = Image.new();
  self.huangChengShangDian:loadByArtID(989)
  self.huangChengShangDian.name = "huangChengShangDian"
  self.materialLayer:addChild(self.huangChengShangDian)
  self.huangChengShangDian:setPositionXY(15, -38);
  self.huangChengShangDian:addEventListener(DisplayEvents.kTouchBegin, self.onTouchBegin, self);

  self.huangChengShangDian_zi = Image.new();
  self.huangChengShangDian_zi:loadByArtID(996)
  self.huangChengShangDian_zi.touchEnabled = false;
  self.nameLayer:addChild(self.huangChengShangDian_zi)
  self.huangChengShangDian_zi:setPositionXY(130, 72);






  self.shiGuoZhengZhan_layerColor = LayerColor.new();
  self.shiGuoZhengZhan_layerColor:initLayer();
  self.materialLayer:addChild(self.shiGuoZhengZhan_layerColor)
  self.shiGuoZhengZhan_layerColor.name = "shiGuoZhengZhan_layerColor"
  self.shiGuoZhengZhan_layerColor:setPositionXY(193,304)
  self.shiGuoZhengZhan_layerColor:changeWidthAndHeight(285, 155)
  self.shiGuoZhengZhan_layerColor:addEventListener(DisplayEvents.kTouchBegin, self.onTouchBegin, self);
  self.shiGuoZhengZhan_layerColor:setColor(ccc3(0,0,0));
  self.shiGuoZhengZhan_layerColor:setOpacity(self.layerCloor_alpha);


  self.shiGuoZhengZhan_layerColor2 = LayerColor.new();
  self.shiGuoZhengZhan_layerColor2:initLayer();
  self.materialLayer:addChild(self.shiGuoZhengZhan_layerColor2)
  self.shiGuoZhengZhan_layerColor2.name = "shiGuoZhengZhan_layerColor2"
  self.shiGuoZhengZhan_layerColor2:setPositionXY(0,271)
  self.shiGuoZhengZhan_layerColor2:changeWidthAndHeight(285, 155)
  self.shiGuoZhengZhan_layerColor2:addEventListener(DisplayEvents.kTouchBegin, self.onTouchBegin, self);
  self.shiGuoZhengZhan_layerColor2:setColor(ccc3(0,0,0));
  self.shiGuoZhengZhan_layerColor2:setOpacity(self.layerCloor_alpha);

  self.shiGuoZhengZhan_layerColor3 = LayerColor.new();
  self.shiGuoZhengZhan_layerColor3:initLayer();
  self.materialLayer:addChild(self.shiGuoZhengZhan_layerColor3)
  self.shiGuoZhengZhan_layerColor3.name = "shiGuoZhengZhan_layerColor3"
  self.shiGuoZhengZhan_layerColor3:setPositionXY(566,411)
  self.shiGuoZhengZhan_layerColor3:changeWidthAndHeight(97, 100)
  self.shiGuoZhengZhan_layerColor3:addEventListener(DisplayEvents.kTouchBegin, self.onTouchBegin, self);
  self.shiGuoZhengZhan_layerColor3:setColor(ccc3(0,0,0));
  self.shiGuoZhengZhan_layerColor3:setOpacity(self.layerCloor_alpha);


  self.shiGuoZhengZhan_layerColor4 = LayerColor.new();
  self.shiGuoZhengZhan_layerColor4:initLayer();
  self.materialLayer:addChild(self.shiGuoZhengZhan_layerColor4)
  self.shiGuoZhengZhan_layerColor4.name = "shiGuoZhengZhan_layerColor4"
  self.shiGuoZhengZhan_layerColor4:setPositionXY(479,459)
  self.shiGuoZhengZhan_layerColor4:changeWidthAndHeight(97, 100)
  self.shiGuoZhengZhan_layerColor4:addEventListener(DisplayEvents.kTouchBegin, self.onTouchBegin, self);
  self.shiGuoZhengZhan_layerColor4:setColor(ccc3(0,0,0));
  self.shiGuoZhengZhan_layerColor4:setOpacity(self.layerCloor_alpha);

  self.chaoTang_layerColor = LayerColor.new();
  self.chaoTang_layerColor:initLayer();
  self.materialLayer:addChild(self.chaoTang_layerColor)
  self.chaoTang_layerColor.name = "chaoTang_layerColor"
  self.chaoTang_layerColor:setPositionXY(817,399)
  self.chaoTang_layerColor:changeWidthAndHeight(100, 213)
  self.chaoTang_layerColor:addEventListener(DisplayEvents.kTouchBegin, self.onTouchBegin, self);
  self.chaoTang_layerColor:setColor(ccc3(0,0,0));
  self.chaoTang_layerColor:setOpacity(self.layerCloor_alpha);

  -- self.huangChengShangDian_zi =  BitmapTextField.new("皇\n城\n商\n店","yingxiongmingzi");--BitmapTextField.new("皇\n城\n商\n店","anniutuzi");
  -- self.nameLayer:addChild(self.huangChengShangDian_zi)
  -- self.huangChengShangDian_zi:setPositionXY(0, 0);

  local closeButton=CommonButton.new();
  closeButton:initialize("common_close_button_normal","common_close_button_down",CommonButtonTouchable.BUTTON);
  closeButton:setPositionXY(1200, 645);
  closeButton:addEventListener(DisplayEvents.kTouchTap,self.closeUI,self);
  self:addChild(closeButton);
  if GameData.isMusicOn then
    MusicUtils:play(1005,true)
  end

  -- reddot
  local countControlProxy = self:retrieveProxy(CountControlProxy.name);
  local userProxy = self:retrieveProxy(UserProxy.name);
  self.userProxy = userProxy;
  local userCurrencyProxy = self:retrieveProxy(UserCurrencyProxy.name);
  self.userCurrencyProxy = userCurrencyProxy;
  local openFunctionProxy=self:retrieveProxy(OpenFunctionProxy.name);
  self.openFunctionProxy = openFunctionProxy;
  -- local shengwanggou
  -- if analysisHas("Shili_Guanzhi",userProxy:getNobility() + 1) then
  --   shengwanggou = analysis("Shili_Guanzhi",userProxy:getNobility() + 1,"prestige") <= userCurrencyProxy:getPrestige()
  -- end

  -- local guanzhiCanRed = not GameData.clickRedDotArr[FunctionConfig.FUNCTION_ID_33] and shengwanggou

  local shiguoCount = countControlProxy:getRemainCountByID(CountControlConfig.TEN_COUNTRY,CountControlConfig.Parameter_0)
  local shiguoCanRed = not GameData.clickRedDotArr[FunctionConfig.FUNCTION_ID_34] and shiguoCount > 0

  local chaotangCount = countControlProxy:getRemainCountByID(CountControlConfig.CHAOTANGZHENGBIAN,CountControlConfig.Parameter_0)
  local chaotangCanRed = not GameData.clickRedDotArr[FunctionConfig.FUNCTION_ID_35] and chaotangCount > 0

  -- local shilianCount1 = countControlProxy:getRemainCountByID(CountControlConfig.TreasuryCount,CountControlConfig.Parameter_1)
  -- local shilian1CanRed = not GameData.clickRedDotArr[FunctionConfig.FUNCTION_ID_33] and shilianCount1 > 0

  -- local shilianCount2 = countControlProxy:getRemainCountByID(CountControlConfig.TreasuryCount,CountControlConfig.Parameter_2)
  -- local shilian2CanRed = not GameData.clickRedDotArr[FunctionConfig.FUNCTION_ID_36] and shilianCount2 > 0

  self.redDot1 = CommonSkeleton:getBoneTextureDisplay("commonImages/common_redIcon");
  self.redDot1:setPositionXY(29,182)    
  self.redDot1:setVisible(false)
  self.shiGuoZhengZhan_zi:addChild(self.redDot1);
  self.redDot2 = CommonSkeleton:getBoneTextureDisplay("commonImages/common_redIcon");
  self.redDot2:setPositionXY(29,182)    
  self.redDot2:setVisible(false)
  self.chaoTang_zi:addChild(self.redDot2);  
  self.redDot3 = CommonSkeleton:getBoneTextureDisplay("commonImages/common_redIcon");
  self.redDot3:setPositionXY(29,182)    
  self.redDot3:setVisible(false)
  self.langYaShiLian_zi:addChild(self.redDot3);

  if shiguoCanRed and openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_34) then
    self.redDot1:setVisible(true)
  end
  if chaotangCanRed then
    self.redDot2:setVisible(true)
  end

  self:refreshXiaohongdian();

end
function FactionPopup:refreshXiaohongdian()
  local shengwanggou
  if analysisHas("Shili_Guanzhi",self.userProxy:getNobility() + 1) then
    shengwanggou = analysis("Shili_Guanzhi",self.userProxy:getNobility() + 1,"prestige") <= self.userCurrencyProxy:getPrestige()
  end
  local guanzhiCanRed = not GameData.clickRedDotArr[FunctionConfig.FUNCTION_ID_33]
                       and shengwanggou
                       and self.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_33)

  if guanzhiCanRed then
    self.redDot3:setVisible(true)
  else
    self.redDot3:setVisible(false)
  end
end
function FactionPopup:onCloseButtonTap(event)

end
function FactionPopup:onUIClose()
  self:dispatchEvent(Event.new("CLOSE_FACTION_UI",nil,self));
  if GameData.isMusicOn then
    if 1 == self.storyLineProxy:getStrongPointState(10001011) then
      MusicUtils:play(1003,GameData.isMusicOn);
    else
      MusicUtils:play(1002,GameData.isMusicOn);
    end
  end
end
function FactionPopup:onTouchBegin(event)
  event.target:addEventListener(DisplayEvents.kTouchEnd,self.onTouchEnd,self);
  self.beginPos_x,self.beginPos_y=event.globalPosition.x,event.globalPosition.y;
  if event.target.name == "shiGuoZhengZhan" or event.target.name == "shiGuoZhengZhan_layerColor" or event.target.name == "shiGuoZhengZhan_layerColor2"  or event.target.name == "shiGuoZhengZhan_layerColor3" or event.target.name == "shiGuoZhengZhan_layerColor4" then
    if not self.currentEffect then
      self.currentEffect = Image.new();
      self.currentEffect:loadByArtID(994);
      self.currentEffect.touchEnabled = false
      self.currentEffect:setPositionXY(self.shiGuoZhengZhan:getPositionX(), self.shiGuoZhengZhan:getPositionY());

      self.backLayer:addChild(self.currentEffect)
    end
    self.currentZiEffect = self.shiGuoZhengZhan_zi
  elseif event.target.name == "chaoTang" then
    if not self.currentEffect then
      self.currentEffect = Image.new();
      self.currentEffect:loadByArtID(988);
      self.currentEffect.touchEnabled = false
      self.currentEffect:setPositionXY(self.chaoTang:getPositionX(), self.chaoTang:getPositionY());

      self.backLayer:addChild(self.currentEffect)
    end
    self.currentZiEffect = self.chaoTang_zi
  elseif event.target.name == "langYaShiLian" or event.target.name == "langYaShiLian_layerColor"  then
      if not self.currentEffect then
        self.currentEffect = Image.new();
        self.currentEffect:loadByArtID(992);
        self.currentEffect.touchEnabled = false
        self.currentEffect:setPositionXY(self.langYaShiLian:getPositionX(), self.langYaShiLian:getPositionY());

        self.backLayer:addChild(self.currentEffect)
      end
      self.currentZiEffect = self.langYaShiLian_zi
  elseif event.target.name == "huangChengShangDian" then
      if not self.currentEffect then
        self.currentEffect = Image.new();
        self.currentEffect:loadByArtID(990);
        self.currentEffect.touchEnabled = false
        self.currentEffect:setPositionXY(self.huangChengShangDian:getPositionX(), self.huangChengShangDian:getPositionY());

        self.backLayer:addChild(self.currentEffect)
      end
      self.currentZiEffect = self.huangChengShangDian_zi
  end

end

function FactionPopup:onTouchEnd(event)
  if self.currentEffect then
    self.backLayer:removeChild(self.currentEffect)
    self.currentEffect = nil;
  end
  if math.abs(self.beginPos_x - event.globalPosition.x) < 20 and math.abs(self.beginPos_y - event.globalPosition.y) < 20 then
    if event.target.name == "chaoTang" then
     --  sharedTextAnimateReward():animateStartByString("尚未开启");
     self:dispatchEvent(Event.new("Open_Meeting"));
     MusicUtils:playEffect(7,false)
    elseif event.target.name == "huangChengShangDian" then
     self:dispatchEvent(Event.new("Open_Shop"));
     MusicUtils:playEffect(7,false)
    elseif event.target.name == "langYaShiLian" or  event.target.name == "langYaShiLian_layerColor" then   
      self:dispatchEvent(Event.new("Open_Treasury"));
      MusicUtils:playEffect(7,false)
    elseif event.target.name == "shiGuoZhengZhan" or event.target.name == "shiGuoZhengZhan_layerColor" or event.target.name == "shiGuoZhengZhan_layerColor2"  or event.target.name == "shiGuoZhengZhan_layerColor3" or event.target.name == "shiGuoZhengZhan_layerColor4"  then
      self:dispatchEvent(Event.new("Open_Ten_Country"));
      --MusicUtils:playEffect(7,false)十国不要加
    end
  end
end

function FactionPopup:clean()

end
