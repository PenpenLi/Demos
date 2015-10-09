--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

require "core.utils.LayerColorBackGround";

ServerMergeNamePopup=class(TouchLayer);

function ServerMergeNamePopup:ctor()
  self.class=ServerMergeNamePopup;
end

function ServerMergeNamePopup:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	ServerMergeNamePopup.superclass.dispose(self);
  
  self.armature4dispose:dispose();
end

--
function ServerMergeNamePopup:initialize(serverMergeProxy, bagProxy, data)
  self:initLayer();
  self.skeleton=serverMergeProxy:getSkeleton();
  self.serverMergeProxy=serverMergeProxy;
  self.bagProxy=bagProxy;
  self.data=data;
    
  local uiBackImage=Image.new();
  uiBackImage:loadByArtID(StaticArtsConfig.SERVER_MERGE);
  self:addChild(uiBackImage);

  --骨骼
  local armature=self.skeleton:buildArmature("name_select_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  local item=ServerMergeAvatarItem.new();
  item:initialize(self.serverMergeProxy,self.bagProxy,self.data);
  item:setPosition(self.armature:getChildByName("pos"):getPosition());
  self:addChild(item);

  local inputTextData=armature:getBone("input_bg").textData;
  self.textInput=TextInput.new("请输入...",inputTextData.size,makeSize(inputTextData.width,inputTextData.height));
  self.textInput:setPositionXY(inputTextData.x,inputTextData.y);
  self:addChild(self.textInput);

  self.common_copy_blueround_button=Button.new(armature:findChildArmature("common_copy_blueround_button"),false);
  self.common_copy_blueround_button.bone:initTextFieldWithString("common_copy_blueround_button","进入");
  self.common_copy_blueround_button:addEventListener(Events.kStart,self.onConfirmTap,self);

  self.common_copy_greenroundbutton=Button.new(armature:findChildArmature("common_copy_greenroundbutton"),false);
  self.common_copy_greenroundbutton.bone:initTextFieldWithString("common_copy_greenroundbutton","取消");
  self.common_copy_greenroundbutton:addEventListener(Events.kStart,self.onCancelTap,self);

  local button=Button.new(armature:findChildArmature("common_copy_close_button"),false);
  button:addEventListener(Events.kStart,self.onCancelTap,self);

  button=Button.new(armature:findChildArmature("createrole_random_button"),false);
  button:addEventListener(Events.kStart,self.onNameButtonTap,self);
end

function ServerMergeNamePopup:onCancelTap(event)
  self.parent.serverMergeNamePopup=nil;
  self.parent.item_layer:setMoveEnabled(true);
  self.parent:removeChild(self);
end

function ServerMergeNamePopup:onConfirmTap(event)
  local a=self.textInput:getInputText();
  local len = CommonUtils:calcCharCount(a);
  if len == 0 then
    sharedTextAnimateReward():animateStartByString("名字不能为空!");
  elseif len < 2 then
    sharedTextAnimateReward():animateStartByString("名字不能少于两个字!");
  elseif len > 5 then
    sharedTextAnimateReward():animateStartByString("名字不能多于五个字!");
  elseif self.data.UserName == a then
    sharedTextAnimateReward():animateStartByString("和现在的名字一样的思密达~");
  else
    self.parent:confirmToLogin(a,self.data.PlatformId);
  end
end

function ServerMergeNamePopup:onNameButtonTap(event)
  initializeSmallLoading();
  sendMessage(2,12,{UserGender=analysis("Wujiang_Wujiangzhiye",self.data.Career,"xingbie")});
end

function ServerMergeNamePopup:refreshUserName(userName)
  self.textInput:setString(userName);
end