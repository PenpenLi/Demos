
require "core.utils.LayerColorBackGround";
require "main.config.StaticArtsConfig";
require "core.controls.Button"
require "core.controls.TextInput"


OfficialServerPopup=class(TouchLayer);

function OfficialServerPopup:ctor()
  self.class=OfficialServerPopup;
end

function OfficialServerPopup:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	OfficialServerPopup.superclass.dispose(self);
  
  self.armature4dispose:dispose();
end

--
function OfficialServerPopup:initializeUI(serverMergeProxy, serverMediator)
  self:initLayer();
  self.skeleton=serverMergeProxy:getOfficialSkeleton();
  self.serverMergeProxy=serverMergeProxy;
  self.serverMediator=serverMediator;


  -- local uiBackImage=Image.new();
  -- uiBackImage:loadByArtID(StaticArtsConfig.BACKGROUD_COMMON_BG)
  -- self:addChild(uiBackImage);
  --骨骼
  local armature=self.skeleton:buildArmature("log_ui");
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
  
  local bind_button_bone = self.armature:getChildByName("bind_button");
  local bind_buttonP = convertBone2LB4Button(bind_button_bone);
  self.armature:removeChild(bind_button_bone);

  local sign_button_bone = self.armature:getChildByName("sign_button");
  local sign_buttonP = convertBone2LB4Button(sign_button_bone);
  self.armature:removeChild(sign_button_bone);

  self.bind_button = CommonButton.new();
  self.bind_button:initialize("commonButtons/common_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
  self.bind_button:initializeBMText("绑定账号","anniutuzi");
  self.bind_button:setPosition(bind_buttonP);
  self:addChild(self.bind_button);
  self.bind_button:addEventListener(DisplayEvents.kTouchTap,self.onBindButtonTap,self);

  -- self.bind_button=Button.new(armature:findChildArmature("bind_button"),false);
  -- self.bind_button.bone:initTextFieldWithString("common_blue_button","绑定帐号");
  -- self.bind_button:addEventListener(Events.kStart,self.onBindButtonTap,self);
  self.sign_button = CommonButton.new();
  self.sign_button:initialize("commonButtons/common_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
  self.sign_button:initializeBMText("注册新号","anniutuzi");
  self.sign_button:setPosition(sign_buttonP);
  self:addChild(self.sign_button);
  self.sign_button:addEventListener(DisplayEvents.kTouchTap,self.onSignButtonTap,self);

  local imageBone = armature:getBone("logo"):getDisplay();
  local logoImage = Image.new()
  logoImage:loadByArtID(StaticArtsConfig.IMAGE_1063)
  logoImage:setScale(0.8)
  logoImage:setPosition(imageBone:getPosition())
  self:addChild(logoImage)


  -- self.sign_button=Button.new(armature:findChildArmature("sign_button"),false);
  -- self.sign_button.bone:initTextFieldWithString("common_blue_button","注册新号");
  -- self.sign_button:addEventListener(Events.kStart,self.onSignButtonTap,self);

  -- local interButtonData = armature:findChildArmature("common_copy_bluelonground_button"):getBone("common_blue_button").textData;
  --   local interButton=armature_d:getChildByName("common_copy_bluelonground_button");
  -- local commonReturnButton = armature_d:getChildByName("common_return_button");
  
  -- local interButtonP = convertBone2LB4Button(interButton);
  -- armature_d:removeChild(interButton);


  -- local interButton = CommonButton.new();
  -- interButton:initialize("common_blue_button_normal","common_blue_button_down",CommonButtonTouchable.BUTTON);
  -- interButton:initializeText(interButtonData,"绑定帐号");
  -- interButton:setPosition(interButtonP);
  -- self:addChild(interButton);
  -- self.interButton=interButton;
  -- self.interButton:addEventListener(DisplayEvents.kTouchTap,self.popUp.interButtonHandler,self.popUp);

  -- local interButton = CommonButton.new();
  -- interButton:initialize("common_blue_button_normal","common_blue_button_down",CommonButtonTouchable.BUTTON);
  -- interButton:initializeText(interButtonData,"注册新号");
  -- interButton:setPosition(interButtonP);
  -- self:addChild(interButton);
  -- self.interButton=interButton;
  -- self.interButton:addEventListener(DisplayEvents.kTouchTap,self.popUp.interButtonHandler,self.popUp);

  -- self.log_button=Button.new(armature:findChildArmature("common_big_blue_button"),false);
  -- -- self.log_button.bone:initTextFieldWithString("common_blue_button","进入游戏");
  -- self.log_button:addEventListener(Events.kStart,self.onLogButtonTap,self);
  local beginGameButton = self.armature:getChildByName("common_big_blue_button");
  local beginGameButtonP = convertBone2LB4Button(beginGameButton);
  self.armature:removeChild(beginGameButton);

  self.log_button = CommonButton.new();
  self.log_button:initialize("commonButtons/common_big_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
  self.log_button:setPosition(beginGameButtonP);
  self:addChild(self.log_button);
  self.log_button:addEventListener(DisplayEvents.kTouchTap,self.onLogButtonTap,self);
  self.log_button:addEventListener(DisplayEvents.kTouchBegin,self.onLogButtonBegin,self);

  self.back_button=Button.new(armature:findChildArmature("back_button"),false);
  -- self.back_button.bone:initTextFieldWithString("common_copy_orringeroundbutton","返回");
  self.back_button:addEventListener(Events.kStart,self.onBackButtonTap,self);
  local function callBack()
    if self.input_2 then
      self.input_2:openIME();
    end
  end
  local function input_1End()
    Tweenlite:delayCallS(0.5,callBack);
  end
  local input_1Data=armature:getBone("input_1").textData;
  self.input_1=TextInput.new("点这儿输入账号啦",input_1Data.size,makeSize(input_1Data.width,80));
  self.input_1:setPositionXY(input_1Data.x,input_1Data.y);
  self.input_1:setColor(ccc3(0,0,0))
  self.armature:addChild(self.input_1);
  if CommonUtils:getCurrentPlatform() == CC_PLATFORM_IOS then
    self.input_1:addIMECloseHandler(input_1End)
  end
  local function input_2End()
    self:onLogButtonTap();
  end
  local input_2Data=armature:getBone("input_2").textData;
  self.input_2=TextInput.new("$点这儿输入密码啦",input_2Data.size,makeSize(input_2Data.width,80));
  self.input_2:setPositionXY(input_2Data.x,input_2Data.y);
  self.input_2:setColor(ccc3(0,0,0))
  self.armature:addChild(self.input_2);
  if CommonUtils:getCurrentPlatform() == CC_PLATFORM_IOS then
    self.input_2:addIMECloseHandler(input_2End)
  end

  self.input_1:setString(GameData.local_account);
  self.input_2:setString(GameData.local_passWord);

  -- self.beginGamePic = self.armature:getChildByName("common_copy_begin_game");
  -- self.beginGamePic.touchEnabled = false;
  -- self.beginGamePic.touchChildren = false;

  self.beginGamePic = self.armature:getChildByName("common_copy_begin_game");
  local contentSize = self.beginGamePic:getContentSize()
  self.beginGamePic:setAnchorPoint(CCPointMake(0.5, 0.5));
  self.beginGamePic:setPositionXY(self.beginGamePic:getPositionX() + contentSize.width / 2, self.beginGamePic:getPositionY() - contentSize.height / 2);
  self.beginGamePic.touchEnabled = false;
    self.beginGamePic.touchChildren = false;
  self:addChild(self.beginGamePic);
  self.armature:removeChild(self.beginGamePic);  

  if WANGetHasValidAccount() then
    self.bind_button:refreshText("修改密码");
  else
    local text_data=armature:getBone("descb_3").textData;
    local text="您当前使用游客身份登录~为防止账号遗忘或丢失，快使用绑定帐号吧~";
    self.descb_3=createTextFieldWithTextData(text_data,text,true);
    self.armature:addChild(self.descb_3);
  end

  AddUIFrame(self)
end

--移除
function OfficialServerPopup:onCloseButtonTap(event)
  self:dispatchEvent(Event.new(OfficialServerNotifications.CLOSE_OFFICIAL_SERVER,nil,self));
end

function OfficialServerPopup:onBindButtonTap(event)
  --[[if WANGetHasValidAccount() then
      local officialServerSignPopup=OfficialServerSignPopup.new();
      officialServerSignPopup:initializeUI(self.serverMergeProxy,true);
      self:addChild(officialServerSignPopup);
      self.officialServerSignPopup=officialServerSignPopup;

      self.input_1:setVisible(false);
      self.input_2:setVisible(false);
  elseif self:onConfirmTap() then
      WANBindAccount(self.input_1:getInputText(),self.input_2:getInputText());
  end]]
  --sign
  --change
  --bind
  local officialServerSignPopup=OfficialServerSignPopup.new();
  officialServerSignPopup:initializeUI(self.serverMergeProxy,WANGetHasValidAccount() and 2 or 3);
  self:addChild(officialServerSignPopup);
  self.officialServerSignPopup=officialServerSignPopup;

  self.input_1:setVisible(false);
  self.input_2:setVisible(false);
end

function OfficialServerPopup:onSignButtonTap(event)
  local officialServerSignPopup=OfficialServerSignPopup.new();
  officialServerSignPopup:initializeUI(self.serverMergeProxy,1);
  self:addChild(officialServerSignPopup);
  self.officialServerSignPopup=officialServerSignPopup;

  self.input_1:setVisible(false);
  self.input_2:setVisible(false);
end

function OfficialServerPopup:onLogButtonTap(event)

  local input_1 = self.input_1:getInputText();
  local input_2 = self.input_2:getInputText();

  saveAccount(input_1,input_2);

  -- self.input_1:setVisible(false);
  -- self.input_2:setVisible(false);  

  self:refreshCheckAccountComplete();

end

function OfficialServerPopup:onLogButtonBegin(event)
  self.log_button:addEventListener(DisplayEvents.kTouchEnd,self.onLogButtonEnd,self);  
  self.beginGamePic:setScale(0.9)
end

function OfficialServerPopup:onLogButtonEnd(event)
  self.beginGamePic:setScale(1)
end

function OfficialServerPopup:onBackButtonTap(event)
  local input_1=self.input_1:getInputText();
  local input_2=self.input_2:getInputText();

  saveAccount(input_1,input_2);  
  self.input_2 = nil;
  self:onCloseButtonTap();
end

function OfficialServerPopup:onConfirmTap()
  local input_1=self.input_1:getInputText();
  local input_2=self.input_2:getInputText();
  local len_1 = CommonUtils:calcCharCount(input_1);
  local len_2 = CommonUtils:calcCharCount(input_2);
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
  return true;
end

function OfficialServerPopup:refreshBindComplete()
  self:onCloseButtonTap();
end

function OfficialServerPopup:refreshCheckAccountComplete()
  -- self.input_1:setVisible(false);
  -- self.input_2:setVisible(false);
  -- self:setVisible(false);
  self.serverMediator:getViewComponent():interButtonHandler();
end

function OfficialServerPopup:refreshChangeComplete()
  if self.officialServerSignPopup then
    self:removeChild(self.officialServerSignPopup);
    self.officialServerSignPopup=nil;
  end
  self.input_1:setString(GameData.local_account);
  self.input_2:setString(GameData.local_passWord);
  self.bind_button:refreshText("修改密码");

  self.input_1:setVisible(true);
  self.input_2:setVisible(true);
end

function OfficialServerPopup:refreshSignComplete()
  if self.officialServerSignPopup then
    self:removeChild(self.officialServerSignPopup);
    self.officialServerSignPopup=nil;
  end
  self.input_1:setString(GameData.local_account);
  self.input_2:setString(GameData.local_passWord);
  self.bind_button:refreshText("修改密码");

  self.input_1:setVisible(true);
  self.input_2:setVisible(true);
end

function OfficialServerPopup:onWanError()
  if self.officialServerSignPopup then
    self.officialServerSignPopup.input_1:setVisible(true);
    self.officialServerSignPopup.input_2:setVisible(true);
    self.officialServerSignPopup.input_3:setVisible(true);
  else
    self.input_1:setVisible(true);
    self.input_2:setVisible(true);
  end
end