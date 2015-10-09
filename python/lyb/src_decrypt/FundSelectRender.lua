
FundSelectRender=class(Layer);

function FundSelectRender:ctor()
  self.class=FundSelectRender;
end

function FundSelectRender:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  FundSelectRender.superclass.dispose(self);
end


function FundSelectRender:initialize(skeleton,fundType,userCurrencyProxy,userProxy)
  self:initLayer();
  self.skeleton=skeleton;
  self.fundType=fundType;
  self.userCurrencyProxy = userCurrencyProxy;
  self.userProxy = userProxy;

  --骨骼
  local armature=skeleton:buildArmature("fund_select_render"..fundType);
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);
  
  local tableData = analysis("Yunying_Jijinleixing",fundType);
  
  --text1
  text="价格:"..tableData.money.."元宝";
  text_data = armature:getBone("text1").textData;
  self.text1 = createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.text1);
  --text2
  text="总收益";
  text_data = armature:getBone("text2").textData;
  self.text2 = createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.text2);
  --text_gold
  text=tableData.awardClinet;
  local tt = StringUtils:lua_string_split(text,",");
  text = tt[1];
  text_data = armature:getBone("text_gold").textData;
  self.text_gold = createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.text_gold);
  --text_silver
  text = tt[2];
  text_data = armature:getBone("text_silver").textData;
  self.text_silver = createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.text_silver);


  local ranData=armature:findChildArmature("common_copy_bluelonground_button"):getBone("common_bluelonground_button").textData;
  --common_copy_bluelonground_button
  local button=self.armature:getChildByName("common_copy_bluelonground_button");
  local button_pos = convertBone2LB4Button(button);
  self.armature:removeChild(button);
  button=CommonButton.new();
  button:initialize("common_bluelonground_button_normal","common_bluelonground_button_down",CommonButtonTouchable.BUTTON);
  button:initializeText(ranData,"立即购买");
  button:setPosition(button_pos);
  button:addEventListener(DisplayEvents.kTouchTap,self.onBuy,self);
  self.button = button;
  self.armature:addChild(button);


end


function FundSelectRender:onDetail(event)
  local detail
  if 1==self.fundType then
    detail = FundDetailSilver.new()
    detail:initializeUI(self.skeleton,self.fundType)
  elseif 2==self.fundType then
    detail = FundDetailGold.new()
    detail:initializeUI(self.skeleton,self.fundType)
  elseif 3==self.fundType then
    detail = FundDetailGold.new()
    detail:initializeUI(self.skeleton,self.fundType)
  end
  sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(detail);
  --self.armature:addChild(detail)
end

function FundSelectRender:onBuy(event)
  if self.userProxy.vipLevel<1 then
    local str =analysis("Tishi_Tishineirong",248,"captions");
    local commonPopup=CommonPopup.new();
    commonPopup:initialize(str,self,self.jumpVIP);
    sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(commonPopup);
    return
  else
    local str =analysis("Tishi_Tishineirong",249,"captions");
    local commonPopup=CommonPopup.new();
    --str = "是否购买价值#元宝的#,获得#和#?确认之后不可更换哦"
    local tableData = analysis("Yunying_Jijinleixing",self.fundType);
    local tt = StringUtils:lua_string_split(tableData.awardClinet,",");
    str = StringUtils:getString4Popup(PopupMessageConstConfig.ID_289,{tableData.money,tableData.type,tt[1],tt[2]})
    commonPopup:initialize(str,self,self.onBuySure);
    sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(commonPopup);
  end
end

function FundSelectRender:jumpVIP()
  if self.parent and self.parent.parent then
    self.parent.parent:dispatchEvent(Event.new("OPEN_VIP_UI",nil,self));
  end
end

function FundSelectRender:onBuySure()
  local costGold = analysis("Yunying_Jijinleixing",self.fundType,"money");
  if self.userCurrencyProxy.gold<costGold then
    local str =analysis("Tishi_Tishineirong",5,"captions");
    sharedTextAnimateReward():animateStartByString(str);
    if self.parent and self.parent.parent then
      self.parent.parent:dispatchEvent(Event.new("OPEN_RECHARGE_UI",nil,self));
    end
  else
    --<param main="24" sub="41" desc="请求 购买基金">Type</param>
    local msg = {Type = self.fundType};
    sendMessage(24,41,msg);

    -- print(" llollkk1",self.parent,self.parent.parent);
    -- print(" llollkk2",self.parent.name);
    -- print(" llollkk3",self.parent.parent.name);
    if self.parent and self.parent.parent then
      self.parent.parent:dispatchEvent(Event.new(ActivityNotifications.FUND_CLOSE,nil,self));
    end
  end
end

function FundSelectRender:setButtonVisible(boo)
  self.button:setVisible(boo);
end