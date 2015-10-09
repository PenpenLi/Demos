--
-- Copyright @2009-2013 www.happyelements.com, all rights reserved.
-- Create date: 2013-5-2

-- yanchuan.xie@happyelements.com


require "core.utils.LayerColorBackGround";
require "main.config.StaticArtsConfig";

OfficialServerSignPopup=class(TouchLayer);

function OfficialServerSignPopup:ctor()
  self.class=OfficialServerSignPopup;
end

function OfficialServerSignPopup:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	OfficialServerSignPopup.superclass.dispose(self);
  
  self.armature4dispose:dispose();
end

--
function OfficialServerSignPopup:initializeUI(serverMergeProxy, type)
  self:initLayer();
  self.skeleton=serverMergeProxy:getOfficialSkeleton();
  self.serverMergeProxy=serverMergeProxy;
  self.type=type;

  -- local uiBackImage=Image.new();
  -- uiBackImage:loadByArtID(StaticArtsConfig.BACKGROUD_CREAT_ROLE);
  -- self:addChild(uiBackImage);
  --骨骼
  local armature=self.skeleton:buildArmature("sign_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;

  AddUIBackGround(self,StaticArtsConfig.BACKGROUD_COMMON_BG,nil,true);
 
  local cartoon1 = cartoonPlayer(StaticArtsConfig.FRAME_EFFECT_129,440,495,0,nil,2,nil,false)
  local cartoon2 = cartoonPlayer(StaticArtsConfig.FRAME_EFFECT_128,1200,440,0,nil,2,nil,false)

  self:addChild(cartoon1)
  self:addChild(cartoon2)

  self:addChild(self.armature);

  self.armature:getChildByName("img_1"):setVisible(1==type and true or false);
  self.armature:getChildByName("img_2"):setVisible(2==type and true or false);
  self.armature:getChildByName("img_3"):setVisible(3==type and true or false);

  -- self.log_button=Button.new(armature:findChildArmature("log_button"),false);
  -- -- self.log_button.bone:initTextFieldWithString("common_copy_blueroundbutton","完成");
  -- self.log_button:addEventListener(Events.kStart,self.onLogButtonTap,self);

  self.back_button=Button.new(armature:findChildArmature("back_button"),false);
  -- self.back_button.bone:initTextFieldWithString("common_copy_orringeroundbutton","返回");
  self.back_button:addEventListener(Events.kStart,self.onBackButtonTap,self);
  
  local beginGameButton = self.armature:getChildByName("log_button");
  local beginGameButtonP = convertBone2LB4Button(beginGameButton);
  self.armature:removeChild(beginGameButton);

  self.log_button = CommonButton.new();
  self.log_button:initialize("commonButtons/common_big_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
  self.log_button:setPosition(beginGameButtonP);
  self:addChild(self.log_button);
  self.log_button:addEventListener(DisplayEvents.kTouchTap,self.onLogButtonTap,self);
  self.log_button:addEventListener(DisplayEvents.kTouchBegin,self.onLogButtonBegin,self);

  -- local beginGamePic = self.armature:getChildByName("common_copy_begin_game");
  -- beginGamePic.touchEnabled = false;
  -- beginGamePic.touchChildren = false;

  self.beginGamePic = self.armature:getChildByName("common_copy_begin_game");
  local contentSize = self.beginGamePic:getContentSize()
  self.beginGamePic:setAnchorPoint(CCPointMake(0.5, 0.5));
  self.beginGamePic:setPositionXY(self.beginGamePic:getPositionX() + contentSize.width / 2, self.beginGamePic:getPositionY() - contentSize.height / 2);
  self.beginGamePic.touchEnabled = false;
    self.beginGamePic.touchChildren = false;
  self:addChild(self.beginGamePic);
  self.armature:removeChild(self.beginGamePic);  

  local input_1Data=armature:getBone("input_1").textData;
  local texts={"点这儿输入账号啦","点这儿输入当前密码啦","点这儿输入绑定账号啦"};
  self.input_1=TextInput.new(texts[self.type],input_1Data.size,makeSize(input_1Data.width + GameData.uiOffsetY,input_1Data.height));
  self.input_1:setPositionXY(input_1Data.x,input_1Data.y);
  self.input_1:setColor(ccc3(0,0,0))
  self.armature:addChild(self.input_1);

  local input_2Data=armature:getBone("input_2").textData;
  self.input_2=TextInput.new("点这儿输入密码啦",input_2Data.size,makeSize(input_2Data.width,input_2Data.height));
  self.input_2:setPositionXY(input_2Data.x,input_2Data.y);
  self.input_2:setColor(ccc3(0,0,0))
  self.armature:addChild(self.input_2);

  local input_3Data=armature:getBone("input_3").textData;
  self.input_3=TextInput.new("点这儿再次输入密码啦",input_3Data.size,makeSize(input_3Data.width,input_3Data.height));
  self.input_3:setPositionXY(input_3Data.x,input_3Data.y);
  self.input_3:setColor(ccc3(0,0,0))
  self.armature:addChild(self.input_3);

  local text_data=armature:getBone("descb_1").textData;
  local text="5~12个字符，可由数字、字母组成";
  self.descb_1=createTextFieldWithTextData(text_data,text,true);
  self.armature:addChild(self.descb_1);

  text_data=armature:getBone("descb_2").textData;
  text="5~12个字符，可由数字、字母组成";
  self.descb_2=createTextFieldWithTextData(text_data,text,true);
  self.armature:addChild(self.descb_2);

  if 1==self.type then
    text_data=armature:getBone("descb_3").textData;
    text="新建帐号可能会造成现有帐号信息遗失，请提前绑定现有帐号信息";
    self.descb_3=createTextFieldWithTextData(text_data,text,true);
    self.armature:addChild(self.descb_3);
  end
  
  local imageBone = armature:getBone("logo"):getDisplay();
  local logoImage = Image.new()
  logoImage:loadByArtID(StaticArtsConfig.IMAGE_1063)
  logoImage:setScale(0.8)
  logoImage:setPosition(imageBone:getPosition())
  self:addChild(logoImage)

  AddUIFrame(self)
end

function OfficialServerSignPopup:onLogButtonBegin(event)
  self.log_button:addEventListener(DisplayEvents.kTouchEnd,self.onLogButtonEnd,self);  
  self.beginGamePic:setScale(0.9)
end

function OfficialServerSignPopup:onLogButtonEnd(event)
  self.beginGamePic:setScale(1)
end

function OfficialServerSignPopup:onLogButtonTap(event)
  local input_1=self.input_1:getInputText();
  local input_2=self.input_2:getInputText();
  local input_3=self.input_3:getInputText();
  if 3==self.type then
    if self:onConfirmTap4Sign() then
      WANBindAccount(input_1,input_2);
    end
  elseif 2==self.type then
    if self:onConfirmTap4Change() then
      WANChangePWD(input_1,input_2,input_3);
    end
  elseif 1==self.type then
    local function cb()
      self.input_1:setVisible(true);
      self.input_2:setVisible(true);
      self.input_3:setVisible(true);
      WANSign(input_1,input_2,input_3);
    end
    local function cb_cancel()
      self.input_1:setVisible(true);
      self.input_2:setVisible(true);
      self.input_3:setVisible(true);
    end
    if self:onConfirmTap4Sign() then
      self.input_1:setVisible(false);
      self.input_2:setVisible(false);
      self.input_3:setVisible(false);
      local tips=CommonPopup.new();
      tips:initialize("创建新帐号会造成现有帐号信息遗失，确定创建新帐号吗？",nil,cb,nil,cb_cancel);
      self:addChild(tips);
    end
  end
end

function OfficialServerSignPopup:onBackButtonTap(event)
  self.parent.input_1:setVisible(true);
  self.parent.input_2:setVisible(true);

  self.parent:removeChild(self);
end

function OfficialServerSignPopup:onConfirmTap4Sign()
  local input_1=self.input_1:getInputText();
  local input_2=self.input_2:getInputText();
  local input_3=self.input_3:getInputText();
  local len_1 = CommonUtils:calcCharCount(input_1);
  local len_2 = CommonUtils:calcCharCount(input_2);
  local len_3 = CommonUtils:calcCharCount(input_3);
  if len_1 == 0 then
    sharedTextAnimateReward():animateStartByString("输入帐号哦~");
    return;
  elseif len_1 < 5 or len_1 >12 or string.find(input_1," ") or string.find(input_1,"&") then
    sharedTextAnimateReward():animateStartByString("帐号不符合规范哦~");
    return;
  end
  if len_2 == 0 then
    sharedTextAnimateReward():animateStartByString("输入密码哦~");
    return;
  elseif len_2 < 5 or len_2 >12 or string.find(input_2," ") or string.find(input_2,"&") then
    sharedTextAnimateReward():animateStartByString("密码不符合规范哦~");
    return;
  end
  if len_3 == 0 then
    sharedTextAnimateReward():animateStartByString("再次输入密码哦~");
    return;
  elseif len_3 < 5 or len_3 >12 or string.find(input_3," ") or string.find(input_3,"&") then
    sharedTextAnimateReward():animateStartByString("再次输入密码不符合规范哦~");
    return;
  end
  if input_2~=input_3 then
    sharedTextAnimateReward():animateStartByString("密码不一致哦~");
    return;
  end
  return true;
end

function OfficialServerSignPopup:onConfirmTap4Change()
  local input_1=self.input_1:getInputText();
  local input_2=self.input_2:getInputText();
  local input_3=self.input_3:getInputText();
  local len_1 = CommonUtils:calcCharCount(input_1);
  local len_2 = CommonUtils:calcCharCount(input_2);
  local len_3 = CommonUtils:calcCharCount(input_3);
  if len_1 == 0 then
    sharedTextAnimateReward():animateStartByString("输入当前密码哦~");
    return;
  elseif len_1 < 5 or len_1 >12 or string.find(input_1," ") or string.find(input_1,"&") then
    sharedTextAnimateReward():animateStartByString("当前密码不符合规范哦~");
    return;
  end
  if len_2 == 0 then
    sharedTextAnimateReward():animateStartByString("输入新密码哦~");
    return;
  elseif len_2 < 5 or len_2 >12 or string.find(input_2," ") or string.find(input_2,"&") then
    sharedTextAnimateReward():animateStartByString("新密码不符合规范哦~");
    return;
  end
  if len_3 == 0 then
    sharedTextAnimateReward():animateStartByString("再次输入新密码哦~");
    return;
  elseif len_3 < 5 or len_3 >12 or string.find(input_3," ") or string.find(input_3,"&") then
    sharedTextAnimateReward():animateStartByString("再次输入新密码不符合规范哦~");
    return;
  end
  if input_2~=input_3 then
    sharedTextAnimateReward():animateStartByString("新密码不一致哦~");
    return;
  end
  return true;
end