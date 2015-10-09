-- CommonInput  
require "core.display.Layer";
require "core.controls.CommonButton";
require "core.events.DisplayEvent";
require "core.skeleton.SkeletonFactory";
require "core.controls.TextInput"

-- CommonPopupCloseButtonPram={};
-- CommonPopupCloseButtonPram.DEFAULT = 1;
-- CommonPopupCloseButtonPram.CONFIRM = 2;
-- CommonPopupCloseButtonPram.CANCLE = 3;

CommonInput=class(LayerColor);

function CommonInput:ctor()
  self.class=CommonInput;
end

function CommonInput:dispose()
  self:removeChildren();
	self:removeAllEventListeners();
	CommonInput.superclass.dispose(self);
  self.armature4dispose:dispose();
end

function CommonInput:initialize(inputString,text_string, context, onConfirm, confirmData, onCancel, cancelData, confirm_boolean, text_table, isColorLabel, allsceenMiddle,onCloseClick)
  -- if not isJustClose then 
  --   isJustClose = CommonPopupCloseButtonPram.DEFAULT;
  -- end
  self.onCloseClick = onCloseClick
  self:initLayer();

  self:setTouchEnabled(true)
  
  if nil==text_table then
    text_table={"确定","取消"};
  end

  if inputString == nil then
    inputString = "请输入(不区分大小写)"
  end

  local armature=CommonSkeleton:buildArmature("common_input_panel");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose = armature;
  
  armatureDisPlay=armature.display;
  self:addChild(armatureDisPlay);

  local textData=armature:getBone("common_descb").textData;
  local confirmTextArm=armature:findChildArmature("common_blueround_button");
  local confirmTextData = confirmTextArm:getBone("common_blue_button").textData

  local inputTextData = armature:getBone("common_input").textData;
  self.inputText = TextInput.new(inputString,inputTextData.size,makeSize(inputTextData.width,inputTextData.height));
  self.inputText:setPositionXY(inputTextData.x,inputTextData.y);
  self.inputText:setColor(ccc3(255,255,255))
  armatureDisPlay:addChild(self.inputText);
  
  local commonInputBg = armatureDisPlay:getChildByName("common_input_bg");
  -- commonInputBg:setScale(0.68)

  --confirmButton
  local confirmButton=armatureDisPlay:getChildByName("common_blueround_button");
  local confirmButton_pos=convertBone2LB4Button(confirmButton);
  armatureDisPlay:removeChild(confirmButton);

  --cancelButton
  local cancelButton=armatureDisPlay:getChildByName("common_blueround_button_1");
  local cancelButton_pos=convertBone2LB4Button(cancelButton);
  armatureDisPlay:removeChild(cancelButton);
  
  -- closebutton
  -- local closeButton=armature:getChildByName("common_close_button");
  -- local closeButton_pos=convertBone2LB4Button(closeButton);
  -- armature:removeChild(closeButton);

  --common_descb
  local text=text_string;

  if isColorLabel then
    self.common_descb=createMultiColoredLabelWithTextData(textData,text);
    self.common_descb:setPositionY(self.common_descb:getPositionY() + 140)
  else
    self.common_descb=createTextFieldWithTextData(textData,text);
    self.common_descb:setColor(ccc3(0,0,0))
    self.common_descb:setPositionY(self.common_descb:getPositionY())
  end
  armatureDisPlay:addChild(self.common_descb);
    
  --confirmButton
  confirmButton=CommonButton.new();
  confirmButton:initialize("commonButtons/common_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
  confirmButton:initializeBMText(text_table[1],"anniutuzi");
  -- confirmButton:initializeText(confirmTextData,text_table[1]);
  if confirm_boolean then
    confirmButton:setPositionXY(math.floor(confirmButton_pos.x/2+cancelButton_pos.x/2),math.floor(confirmButton_pos.y/2+cancelButton_pos.y/2));
  else
    confirmButton:setPosition(confirmButton_pos);
  end
  confirmButton:addEventListener(DisplayEvents.kTouchTap,self.onConfirmButtonTap,self);
  armatureDisPlay:addChild(confirmButton);
  
  --cancelButton
  if confirm_boolean then
    
  else
    cancelButton=CommonButton.new();
    cancelButton:initialize("commonButtons/common_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
    --cancelButton:initializeText(confirmTextData,text_table[2]);
    cancelButton:initializeBMText(text_table[2],"anniutuzi");
    cancelButton:setPosition(cancelButton_pos);
    cancelButton:addEventListener(DisplayEvents.kTouchTap,self.onCloseButtonTap,self);
    armatureDisPlay:addChild(cancelButton);
    self.cancelButton = cancelButton
  end
  
  -- closeButton=CommonButton.new();
  -- closeButton:initialize("commonButtons/common_close_button_normal","commonButtons/common_close_button_down",CommonButtonTouchable.BUTTON);
  -- -- cancelButton:initializeText(closeTextData,"");
  -- closeButton:setPosition(closeButton_pos);
  -- closeButton:addEventListener(DisplayEvents.kTouchTap,self.onSmallCloseButtonTap,self);
  -- armature:addChild(closeButton);

  local closeButton =self.armature4dispose.display:getChildByName("common_close_button");
  SingleButton:create(closeButton);
  closeButton:addEventListener(DisplayEvents.kTouchTap, self.onSmallCloseButtonTap, self);

  local size=Director:sharedDirector():getWinSize();
  self:changeWidthAndHeight(size.width,size.height);


  --armature:setPositionXY(450,300);
  local popupSize=armatureDisPlay:getChildByName("common_copy_panel_4"):getContentSize();

  if allsceenMiddle then
    armatureDisPlay:setPositionXY(math.floor((size.width-popupSize.width)/2),math.floor((size.height-popupSize.height)/2));
  else
    armatureDisPlay:setPositionXY(math.floor((GameConfig.STAGE_WIDTH-popupSize.width)/2),math.floor((GameConfig.STAGE_HEIGHT-popupSize.height)/2));
  end
  
  self:setColor(ccc3(0,0,0));
  self:setOpacity(125);
  self.context=context;
  self.onConfirm=onConfirm;
  self.confirmData=confirmData;
  self.onCancel=onCancel;
  self.cancelData=cancelData;
	
	-- uninitializeSmallLoading()

end

function CommonInput:setDescbXY(x, y)
  self.common_descb:setPositionXY(x, y)
end

function CommonInput:onCloseButtonTap(event)
  -- self:removePopup();
  if self.onCancel then
    self.onCancel(self.context,self.cancelData);
  end
end

function CommonInput:onSmallCloseButtonTap(event)
  -- if CommonPopupCloseButtonPram.DEFAULT == self.isJustClose then

  -- elseif CommonPopupCloseButtonPram.CONFIRM == self.isJustClose then
  --   if self.onConfirm then
  --     self.onConfirm(self.context,self.confirmData);
  --   end
  -- elseif CommonPopupCloseButtonPram.CANCLE == self.isJustClose then
  --   if self.onCancel then
  --     self.onCancel(self.context,self.cancelData);
  --   end
  -- end

  self:removePopup();
  if self.onCloseClick then
    self.onCloseClick(self.context)
  end
  
end

function CommonInput:onConfirmButtonTap(event)
  -- self:removePopup();
  if self.onConfirm then
    self.onConfirm(self.context,self.confirmData);
  end
end

function CommonInput:removePopup()
  self.parent:removeChild(self);
end
function CommonInput:getInputText()
  -- local inputText = self.inputText:setString("fffff")
  -- return inputText
  -- self.inputText:setString("fffff")
end
