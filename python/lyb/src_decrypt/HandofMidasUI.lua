require "main.view.handofMidas.ui.HandofMidasEffect"
HandofMidasUI = class(LayerPopableDirect)

function HandofMidasUI:ctor()
	self.class = HandofMidasUI;
  self.state = nil;
  self.bool = true;
end

function HandofMidasUI:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  HandofMidasUI.superclass.dispose(self);
  if self.cdTime1Listener then
    self.cdTime1Listener:dispose();
    self.cdTime1Listener = nil;
  end
  self.armature:dispose()
end
function HandofMidasUI:onDataInit()

  self.userCurrencyProxy=self:retrieveProxy(UserCurrencyProxy.name);
  self.countControlProxy=self:retrieveProxy(CountControlProxy.name);
  self.userProxy=self:retrieveProxy(UserProxy.name);

  self.skeleton = self.userProxy:getHandofMidasSkeleton()

  local layerPopableData = LayerPopableData.new();
  layerPopableData:setHasUIBackground(false);
  layerPopableData:setHasUIFrame(false);
  layerPopableData:setArmatureInitParam(self.skeleton,"handofMidas_ui");
  layerPopableData:setVisibleDelegate(false)
  if self.bool then
    layerPopableData:setShowCurrency(true);
  else
    layerPopableData:setShowCurrency(false);
  end
  self:setLayerPopableData(layerPopableData);

end

function HandofMidasUI:initialize()
  self:initLayer();
  hecDC(3,15,1)

  self.mainSize = Director:sharedDirector():getWinSize();

  self.childLayer = LayerColor.new();
  self.childLayer:initLayer();
  self.childLayer:setColor(ccc3(0,0,0));
  self.childLayer:setOpacity(125);
  self:addChild(self.childLayer)
  self.childLayer.sprite:setContentSize(CCSizeMake(self.mainSize.width, self.mainSize.height));
  -- self.childLayer:setPositionXY(-GameData.uiOffsetX,  -GameData.uiOffsetY)    
  
  self.sprite:setContentSize(CCSizeMake(self.mainSize.width, self.mainSize.height));
  self:setPositionXY(-GameData.uiOffsetX,  -GameData.uiOffsetY)    


end

function HandofMidasUI:onUIInit()

  self:addChild(self.armature.display);
  print("function HandofMidasUI:onUIInit()")


  local exchange_txtTextData = self.armature:getBone("exchange_txt").textData;
  self.exchange_txt = createTextFieldWithTextData(exchange_txtTextData, "花点儿元宝就能换银两咯");
  self.armature.display:addChild(self.exchange_txt);

  local count_txtDescData = self.armature:getBone("count_txt").textData;
  self.count_txt = createTextFieldWithTextData(count_txtDescData, "今日点金剩余次数(4/10)");
  self.armature.display:addChild(self.count_txt);

  local baoji_desc_txtTextData = self.armature:getBone("baoji_desc_txt").textData;
  self.baoji_desc_txt = createTextFieldWithTextData(baoji_desc_txtTextData, "VIP等级越高暴击倍率越高");
  self.armature.display:addChild(self.baoji_desc_txt);


  local gold_txtData = self.armature:getBone("gold_txt").textData;
  self.gold_txt = createTextFieldWithTextData(gold_txtData, "0");
  self.armature.display:addChild(self.gold_txt);


  local silver_txtData = self.armature:getBone("silver_txt").textData;
  self.silver_txt = createTextFieldWithTextData(silver_txtData, "0");
  self.armature.display:addChild(self.silver_txt);


  self.cur_silver_txtData = self.armature:getBone("cur_silver_txt").textData;
  self.cur_silver_txt = createTextFieldWithTextData(self.cur_silver_txtData, "0");
  self.armature.display:addChild(self.cur_silver_txt);

  local background_img = self.armature.display:getChildByName("background_img");

  local confirm_button = self.armature.display:getChildByName("confirm_button");
  local confirm_button_pos=convertBone2LB4Button(confirm_button);
  self.armature.display:removeChild(confirm_button);

  confirm_button=CommonButton.new();
  confirm_button:initialize("common_small_blue_button_normal", nil, CommonButtonTouchable.BUTTON);
  confirm_button:initializeBMText("点金","anniutuzi");
  confirm_button:setPosition(confirm_button_pos);
  confirm_button:addEventListener(DisplayEvents.kTouchTap,self.onConfirm,self);
  self.armature.display:addChild(confirm_button);
 
  local cancel_button = self.armature.display:getChildByName("cancel_button");
  local cancel_button_pos=convertBone2LB4Button(cancel_button);
  self.armature.display:removeChild(cancel_button);

  -- cancel_button=CommonButton.new();
  -- cancel_button:initialize("common_small_blue_button_normal",nil, CommonButtonTouchable.BUTTON);
  -- cancel_button:initializeBMText("取消","anniutuzi");
  -- cancel_button:setPosition(cancel_button_pos);
  -- cancel_button:addEventListener(DisplayEvents.kTouchTap,self.onCancel,self);
  -- self.armature.display:addChild(cancel_button);


  print("self.sprite:getcontentsize()", self.sprite:getContentSize().width, self.sprite:getContentSize().height)
  local armatureSize = self.armature.display:getGroupBounds().size;
  local xPos, yPos;
  xPos = (self.mainSize.width - armatureSize.width/CommonUtils:getGameUIScaleRate())/2;
  yPos = (self.mainSize.height - armatureSize.height/CommonUtils:getGameUIScaleRate())/2;
  self.armature.display:setPositionXY(xPos, yPos);
  self:refreshData(0);
end

function HandofMidasUI:setShowCurrency(bool)
  self.bool = bool;
end
function HandofMidasUI:refreshData(usedCount)
  self.usedCount = usedCount;
  self.totalTable = analysisTotalTableArray("Qianzhuang_Qianzhuang")
  local function sortFun(a, b)
    if a.id < b.id then
      return true;
    elseif a.id < b.id then
      return false;
    else
      return false;
    end
  end
  table.sort(self.totalTable, sortFun);

  self.maxCount = 0;
  for k, v in ipairs(self.totalTable) do
    self.maxCount = self.maxCount + v.kycs
    if self.userProxy.vipLevel <= v.vipdj then
      self.qianzhuangPo = v;
      break;
    end
  end
  if self.qianzhuangPo == nil then
    self.qianzhuangPo = self.totalTable[#self.totalTable]
  end

  self.count_txt:setString("今日点金剩余次数(" .. (self.maxCount-usedCount) .. "/" .. self.maxCount .. ")");
  local nextCount = usedCount + 1;
  for k, v in ipairs(self.totalTable) do
    if nextCount <= v.kycs then
      self.curQianzhuangPo = v;
      break;
    end
    nextCount = nextCount - v.kycs;
  end
  print("self.curQianzhuangPo.id, nextCount", self.curQianzhuangPo.id, nextCount)
  self.gold_txt:setString(self.curQianzhuangPo.xhyb);
  self.silver_txt:setString(self.curQianzhuangPo.yls);

  self.cur_silver_txt:setString(self.userCurrencyProxy.silver);

  -- if not self.cur_silver_txt.sprite then
  --   self.cur_silver_txt = createTextFieldWithTextData(self.cur_silver_txtData, "0");
  --   self.armature.display:addChild(self.cur_silver_txt);
  -- else
  --   self.cur_silver_txt:setString(self.userCurrencyProxy.silver);
  -- end
end

function HandofMidasUI:callBack()
  self:removeChild(self.childLayer2);
  self.childLayer2 = nil;
end
function HandofMidasUI:onConfirm(event)
  if self.usedCount == self.maxCount then
    sharedTextAnimateReward():animateStartByString("次数已用完");
  else
    if self.curQianzhuangPo.xhyb > self.userCurrencyProxy.gold then
      sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_514));
      self:dispatchEvent(Event.new("OPEN_VIP_UI",nil,self))
    else
      print("self.curQianzhuangPo.id", self.curQianzhuangPo.id)
      sendMessage(24, 48, {ID = self.curQianzhuangPo.id})
      if GameData.isMusicOn then
         MusicUtils:playEffect(9,false)
      end
    end
  end
end
function HandofMidasUI:onCancel(event)
   self:dispatchEvent(Event.new("CLOSE_HAND_OF_MIDAS",nil,self));
end


function HandofMidasUI:onUIClose()
   self:dispatchEvent(Event.new("CLOSE_HAND_OF_MIDAS",nil,self));
end

function HandofMidasUI:onChildLayerTouch(event)
  print("dddd")
end

function HandofMidasUI:setBaojiEffect(type)

  self.childLayer2 = TouchLayer.new();
  self.childLayer2:initLayer();

  self:addChild(self.childLayer2)
  self.childLayer2.sprite:setContentSize(CCSizeMake(self.mainSize.width, self.mainSize.height)); 
  self.childLayer2:addEventListener(DisplayEvents.kTouchTap,self.onChildLayerTouch,self);

   print("HandofMidasUI:setBaojiEffect")
   self.handofMidasEffect = HandofMidasEffect.new();
   self.handofMidasEffect:textAnimation(type, self.skeleton, self)
   self.handofMidasEffect:setPositionXY(640,360)

   self:addChild(self.handofMidasEffect)
end
