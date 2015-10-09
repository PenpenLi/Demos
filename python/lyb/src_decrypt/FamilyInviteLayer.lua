--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

FamilyInviteLayer=class(LayerColor);

function FamilyInviteLayer:ctor()
  self.class=FamilyInviteLayer;
end

function FamilyInviteLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	FamilyInviteLayer.superclass.dispose(self);

  BitmapCacher:removeUnused();
  self.armature4dispose:dispose();
end

--
function FamilyInviteLayer:initialize(skeleton, familyProxy, parent_container)
  self:initLayer();
  self.skeleton=skeleton;
  self.familyProxy=familyProxy;
  self.parent_container=parent_container;
  
  --骨骼
  local armature=skeleton:buildArmature("invite_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  local text="输入一个玩家名字吧~";
  local text_data=armature:getBone("descb").textData;
  self.descb=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.descb);

  self.send_text_data=armature:getBone("text_input_bg").textData;
  text="请输入...";
  self.textInput=RichTextLineInput.new(text,self.send_text_data.size,makeSize(self.send_text_data.width,self.send_text_data.height));
  self.textInput:initialize();
  self.textInput:setMaxChars(5);
  self.textInput:setSingleline(true);
  self.textInput:setPositionXY(self.send_text_data.x,self.send_text_data.y);
  self.armature:addChild(self.textInput);

  local button=Button.new(armature:findChildArmature("common_copy_greenroundbutton"),false);
  button.bone:initTextFieldWithString("common_copy_greenroundbutton","取消");
  button:addEventListener(Events.kStart,self.onCancelTap,self);

  button=Button.new(armature:findChildArmature("common_copy_blueround_button"),false);
  button.bone:initTextFieldWithString("common_copy_blueround_button","确定");
  button:addEventListener(Events.kStart,self.onConfirmTap,self);

  local size=Director:sharedDirector():getWinSize();
  self:changeWidthAndHeight(size.width,size.height);
  local popupSize=self.armature:getChildByName("common_copy_background_inner_1"):getContentSize();
  self.armature:setPositionXY(math.floor((size.width-popupSize.width)/2),math.floor((size.height-popupSize.height)/2));
  
  self:setColor(ccc3(0,0,0));
  self:setOpacity(125);
end

function FamilyInviteLayer:onCancelTap(event)
  self.parent:removeChild(self);
end

function FamilyInviteLayer:onConfirmTap(event)
  local a=self.textInput:getInputText();
  a=string.sub(a,10,-11);

  
  local defaultContent
  if GameData.platFormID == GameConfig.PLATFORM_CODE_GOOGLE then
    defaultContent = getLuaCodeTranslated('<font color="#808080">请输入...</font>')
  else
    defaultContent = '<font color="#808080">请输入...</font>'
  end
  if defaultContent==a or ''==a then
    a='';
  else
    a=string.sub(a,23,-8);
  end
  if ''==a then
    sharedTextAnimateReward():animateStartByString("输入一个名字吧~");
    return;
  end
  self.parent_container:dispatchEvent(Event.new(FamilyNotifications.FAMILY_INVITE,{UserName=a},self));
  self:onCancelTap();
end