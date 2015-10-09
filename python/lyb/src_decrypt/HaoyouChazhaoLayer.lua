HaoyouChazhaoLayer=class(Layer);

function HaoyouChazhaoLayer:ctor()
  self.class=HaoyouChazhaoLayer;
end

function HaoyouChazhaoLayer:dispose()
	self.armature4dispose:dispose();
	HaoyouChazhaoLayer.superclass.dispose(self);
end

function HaoyouChazhaoLayer:initialize(context)
	self.context = context;
	self.buddyListProxy = self.context.buddyListProxy;

	self.skeleton = self.context.skeleton;
	self:initLayer();

	--骨骼
  local armature=self.skeleton:buildArmature("buddy_tab_3_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  local title_1=createTextFieldWithTextData(armature:getBone("title_1").textData,"输入玩家名字添加好友");
  self.armature:addChild(title_1);

  local title_2=createTextFieldWithTextData(armature:getBone("title_2").textData,"输入玩家ID添加好友");
  self.armature:addChild(title_2);

  local input_1_data=armature:getBone("input_1").textData;
  local text="请输入...";
  self.textInput1=RichTextLineInput.new(text,input_1_data.size,makeSize(input_1_data.width,30+input_1_data.height));
  self.textInput1:initialize();
  self.textInput1:setMaxChars(30);
  self.textInput1:setSingleline(true);
  self.textInput1:setPositionXY(input_1_data.x,input_1_data.y);
  self.armature:addChild(self.textInput1);

  local input_2_data=armature:getBone("input_2").textData;
  local text="请输入...";
  self.textInput2=RichTextLineInput.new(text,input_2_data.size,makeSize(input_2_data.width,30+input_2_data.height));
  self.textInput2:initialize();
  self.textInput2:setMaxChars(30);
  self.textInput2:setSingleline(true);
  self.textInput2:setPositionXY(input_2_data.x,input_2_data.y);
  self.armature:addChild(self.textInput2);

  local chat_channel_button=self.armature4dispose.display:getChildByName("btn");
  local chat_channel_button_pos=convertBone2LB4Button(chat_channel_button);
  self.armature4dispose.display:removeChild(chat_channel_button);

  chat_channel_button=CommonButton.new();
  chat_channel_button:initialize("commonButtons/common_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
  -- chat_channel_button:initializeText(chat_channel_button_text_data,s[a]);
  chat_channel_button:initializeBMText("添加好友","anniutuzi");
  chat_channel_button:setPosition(chat_channel_button_pos);
  chat_channel_button:addEventListener(DisplayEvents.kTouchTap,self.onChannelButtonTap,self,a);
  self.armature4dispose.display:addChild(chat_channel_button);
end

function HaoyouChazhaoLayer:onChannelButtonTap(event)
  local a=self.textInput1:getInputText();
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
  
  local b=self.textInput2:getInputText();
  b=string.sub(b,10,-11);

  local defaultContent
  if GameData.platFormID == GameConfig.PLATFORM_CODE_GOOGLE then
    defaultContent = getLuaCodeTranslated('<font color="#808080">请输入...</font>')
  else
    defaultContent = '<font color="#808080">请输入...</font>'
  end

  if defaultContent==b or ''==b then
    b='';
  else
    b=string.sub(b,23,-8);
  end

  if ''==a and ''==b then
    sharedTextAnimateReward():animateStartByString("输入玩家名字或ID吧 ~");
    return;
  end
  
  if "" ~= a then
    if self.context.userProxy:getUserName() == a then
      sharedTextAnimateReward():animateStartByString("知道你会加自己的,O(∩_∩)O哈哈 ~!");
      return;
    end
  end
  
  local id;
  if "" ~= b then
    id = tonumber(b);
    if nil == id then
      sharedTextAnimateReward():animateStartByString("玩家ID无效哦 ~");
      return;
    end
    id = id - analysis("Xishuhuizong_Xishubiao",1092,"constant");
    if 0 > id then
      sharedTextAnimateReward():animateStartByString("玩家ID无效哦 ~");
      return;
    end
    if self.context.userProxy:getUserID() == id then
      sharedTextAnimateReward():animateStartByString("知道你会加自己的,O(∩_∩)O哈哈 ~!");
      return;
    end
  end
  if self.context.buddyListProxy:getBuddyNumFull() then
    sharedTextAnimateReward():animateStartByString("好友数量已达上限哦 ~");
    return;
  end
  sendMessage(21,4,{UserId = id,UserName = a});
end