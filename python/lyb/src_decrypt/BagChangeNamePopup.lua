require "core.display.Layer";
require "core.controls.CommonButton";
require "core.events.DisplayEvent";
require "core.skeleton.SkeletonFactory";

BagChangeNamePopup=class(LayerColor);

function BagChangeNamePopup:ctor()
  self.class=BagChangeNamePopup;
end

function BagChangeNamePopup:dispose()
  self:removeChildren();
	self:removeAllEventListeners();
	BagChangeNamePopup.superclass.dispose(self);
end

function BagChangeNamePopup:initialize(bagProxy, userCurrencyProxy, shopProxy, context, onConfirm, onCancel, onToCharge, itemId)
  self:initLayer();
  self.bagProxy=bagProxy;
  self.userCurrencyProxy=userCurrencyProxy;
  self.shopProxy=shopProxy;
  self.context=context;
  self.onConfirm=onConfirm;
  self.onCancel=onCancel;
  self.onToCharge=onToCharge;
  self.const_id= itemId and itemId or 1219001;
  local money,price=self.shopProxy:getTypeAndPriceByItemID(self.const_id);
  self.const_charge=price;
  self.const_name=analysis("Daoju_Daojubiao",self.const_id,"name") .. "x1";
  self.hasGold=self.const_charge<=self.userCurrencyProxy:getGold();
  self.hasItem=0<self.bagProxy:getItemNum(self.const_id);
  
  local armature=CommonSkeleton:buildArmature("common_name_change_popup");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();

  local button=Button.new(armature:findChildArmature("common_close_button"),false);
  button:addEventListener(Events.kStart,self.onCloseButtonTap,self);
  
  local textData=armature:getBone("common_descb").textData;
  local inputTextData=armature:getBone("common_background_input").textData;
  local confirmTextData=armature:findChildArmature("common_blueround_button"):getBone("common_blueround_button").textData;
  local cancelTextData=armature:findChildArmature("common_blueround_button_1"):getBone("common_blueround_button").textData;
  armature=armature.display;
  self:addChild(armature);
  
  
  --confirmButton
  local confirmButton=armature:getChildByName("common_blueround_button");
  local confirmButton_pos=convertBone2LB4Button(confirmButton);
  armature:removeChild(confirmButton);
  
  --cancelButton
  local cancelButton=armature:getChildByName("common_blueround_button_1");
  local cancelButton_pos=convertBone2LB4Button(cancelButton);
  armature:removeChild(cancelButton);
  
  
  --common_descb
  local text="<content><font color='#FFFFFF'>名字很重要哦!只要</font><font color='#" .. (self.hasItem and "00FF00" or "FF0000") .. "'>" .. self.const_name .. "</font><font color='#FFFFFF'>就好了啦~</font></content>";
  local common_descb=createMultiColoredLabelWithTextData(textData,text)
  armature:addChild(common_descb);

  self.textInput=TextInput.new("请输入...",inputTextData.size,makeSize(inputTextData.width,inputTextData.height));
  self.textInput:setPositionXY(inputTextData.x,inputTextData.y);
  armature:addChild(self.textInput);
    
  --confirmButton
  confirmButton=CommonButton.new();
  confirmButton:initialize("common_blueround_button_normal","common_blueround_button_down",CommonButtonTouchable.BUTTON);
  confirmButton:initializeText(confirmTextData,"改名");
  confirmButton:setPosition(confirmButton_pos);
  confirmButton:addEventListener(DisplayEvents.kTouchTap,self.onConfirmButtonTap,self);
  armature:addChild(confirmButton);
  
  cancelButton=CommonButton.new();
  cancelButton:initialize("common_blueround_button_normal","common_blueround_button_down",CommonButtonTouchable.BUTTON);
  cancelButton:initializeText(cancelTextData,"取消");
  cancelButton:setPosition(cancelButton_pos);
  cancelButton:addEventListener(DisplayEvents.kTouchTap,self.onCloseButtonTap,self);
  armature:addChild(cancelButton);
  
  --local size=Director:sharedDirector():getWinSize();
  self:changeWidthAndHeight(GameConfig.STAGE_WIDTH,GameConfig.STAGE_HEIGHT);
  local popupSize=armature:getChildByName("common_background_inner_3"):getContentSize();
  armature:setPositionXY(math.floor((GameConfig.STAGE_WIDTH-popupSize.width)/2),math.floor((GameConfig.STAGE_HEIGHT-popupSize.height)/2));
  self:setColor(ccc3(0,0,0));
  self:setOpacity(125);
end

function BagChangeNamePopup:onCloseButtonTap(event)
  self:removePopup();
  if self.onCancel then
    self.onCancel(self.context);
  end
end

function BagChangeNamePopup:onConfirmButtonTap(event)
  if self.hasItem then
    self:onConfirmed();
  elseif self.const_charge then
    local text="<content><font color='#FFFFFF'>哎呀没道具啦~要不花</font><font color='#" .. (self.hasGold and "00FF00" or "FF0000") .. "'>" .. self.const_charge .. "元宝</font><font color='#FFFFFF'>购买</font><font color='" .. getColorByQuality(analysis("Daoju_Daojubiao",self.const_id,"color"),true) .. "'>" .. self.const_name .. "</font><font color='#FFFFFF'>完成名字修改呢~</font></content>";
    local commonPopup=CommonPopup.new();
    commonPopup:initialize(text,self,self.onConfirmedByGold,nil,self.removePopup,nil,nil,nil,true);
    self:addChild(commonPopup);
  else
    sharedTextAnimateReward():animateStartByString("亲~道具不够了哦!");
  end
end

function BagChangeNamePopup:onConfirmed()
  if self.onConfirm then
    local a=self.textInput:getInputText();
    local len = CommonUtils:calcCharCount(a);
    if len == 0 then
      sharedTextAnimateReward():animateStartByString("名字不能为空!");
    elseif len < 2 then
      sharedTextAnimateReward():animateStartByString("名字不能少于两个字!");
    elseif len > 5 then
      sharedTextAnimateReward():animateStartByString("名字不能多于五个字!");
    elseif ConstConfig.USER_NAME == a then
      sharedTextAnimateReward():animateStartByString("和现在的名字一样的思密达~");
    else
      self.onConfirm(self.context,a);
      self:removePopup();
    end
  end
end

function BagChangeNamePopup:onConfirmedByGold()
  if self.hasGold then
    self:onConfirmed();
  else
    if self.onToCharge then
      self.onToCharge(self.context);
    end
    sharedTextAnimateReward():animateStartByString("亲~元宝不够了哦!");
    self:removePopup();
  end
end

function BagChangeNamePopup:removePopup()
  self.parent:removeChild(self);
end