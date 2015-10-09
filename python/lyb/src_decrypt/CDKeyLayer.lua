--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

require "main.view.activity.ui.SignInLayerItem";

CDKeyLayer=class(TouchLayer);

function CDKeyLayer:ctor()
  self.class=CDKeyLayer;
end

function CDKeyLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	CDKeyLayer.superclass.dispose(self);
  self.armature4dispose:dispose();
end

function CDKeyLayer:initialize(skeleton, parent_container)
  self:initLayer();
  self.skeleton=skeleton;
  self.parent_container=parent_container;
  
  --骨骼
  local armature=skeleton:buildArmature("cd_key_bonus_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self.armature:removeChildAt(1);
  self:addChild(self.armature);

  self.send_text_data=armature:getBone("text_bg").textData;

  --descb_1
  local text="亲爱的，如果有礼包兑换码，输入号码马上可以获得礼包了啦！";
  local text_data=armature:getBone("descb_1").textData;
  local descb_1=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(descb_1);

  --descb_2
  text="小贴士啦：\n1、一个兑换码只可以使用一次哟！\n2、过期了就不能用咯！\n3、可以复制粘贴什么的啦，我知道你记性好啦！";
  text_data=armature:getBone("descb_2").textData;
  local descb_2=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(descb_2);

  --descb_3
  text="输入兑换码吧！";
  text_data=armature:getBone("descb_3").textData;
  local descb_3=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(descb_3);

  local text="请输入...";
  self.textInput=TextLineInput.new(text,self.send_text_data.size,makeSize(self.send_text_data.width,self.send_text_data.height));
  self.textInput:setMaxChars(50);
  self.textInput:setPositionXY(self.send_text_data.x,self.send_text_data.y);
  self.armature:addChild(self.textInput);

  --common_copy_bluelonground_button
  self.common_copy_bluelonground_button=Button.new(armature:findChildArmature("common_copy_bluelonground_button"),false);
  self.common_copy_bluelonground_button.bone:initTextFieldWithString("common_copy_bluelonground_button","领取奖励");
  self.common_copy_bluelonground_button:addEventListener(Events.kStart,self.onFetchTap,self);
end

--移除
function CDKeyLayer:onCloseButtonTap(event)
  
end

function CDKeyLayer:onFetchTap(event)
  if ""==self.textInput:getInputText() then
    sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_122));
    return;
  end
  self.parent_container:dispatchEvent(Event.new(ActivityNotifications.CD_KEY_GET_BONUS,{CDKey=self.textInput:getInputText()},self.parent_container));
end