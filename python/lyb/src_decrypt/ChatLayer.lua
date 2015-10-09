require "core.controls.Button";
require "core.events.DisplayEvent";
require "core.controls.CommonPopup";
require "core.controls.TextLineInput";
require "main.view.chat.ui.chatPopup.ChatTalkerScrollList";
require "main.view.chat.ui.chatPopup.ChatContent";
require "core.controls.CommonScrollList";
require "core.utils.RefreshTime";

ChatLayer=class(Layer);

function ChatLayer:ctor()
  self.class=ChatLayer;
end

function ChatLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	ChatLayer.superclass.dispose(self);
  self.armature4dispose:dispose();
end

function ChatLayer:initialize(context)
  self:initLayer();
  self.context=context;
  self.skeleton=self.context.skeleton;
  self.const_chat_content_item_num=10;
  
  self.channel_buttons={};
  self.channel_button_select=nil;
  self.channel_panels={};
  self.channel_panel_select=nil;


  --骨骼
  local armature=self.skeleton:buildArmature("chat_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  -- self.armature:getChildByName("bag_background"):getChildByName("bag_background_img_sub_4_2"):setScaleX(-1);
  -- self.armature:getChildByName("bag_background"):getChildByName("bag_background_img_sub_2_1_2"):setScaleX(-1);
  -- self.armature:getChildByName("bag_background"):getChildByName("bag_background_img_sub_2_2_2"):setScaleX(-1);
  -- self.armature:getChildByName("bag_background"):getChildByName("bag_background_img_sub_2_3_2"):setScaleX(-1);
  -- self.armature:getChildByName("bag_background"):getChildByName("bag_background_img_sub_4_4"):setScaleY(-1);
  -- self.armature:getChildByName("bag_background"):getChildByName("bag_background_img_sub_3_1_2"):setScaleY(-1);
  -- self.armature:getChildByName("bag_background"):getChildByName("bag_background_img_sub_3_2_2"):setScaleY(-1);
  -- self.armature:getChildByName("bag_background"):getChildByName("bag_background_img_sub_4_3"):setScaleX(-1);
  -- self.armature:getChildByName("bag_background"):getChildByName("bag_background_img_sub_3_1_2_copy_1"):setScaleY(-1);
  -- self.armature:getChildByName("bag_background"):getChildByName("bag_background_img_sub_3_2_2_copy"):setScaleY(-1);
  -- self.armature:getChildByName("bag_background"):getChildByName("bag_background_img_sub_3_1_2_copy_2"):setScaleY(-1);
  -- self.armature:getChildByName("bag_background"):getChildByName("bag_background_img_sub_4_3"):setScaleY(-1);

  local chat_channel_button=self.armature:getChildByName("channel_button");
  local chat_channel_button_1=self.armature:getChildByName("channel_button_1");
  local chat_channel_button_pos=convertBone2LB4Button(chat_channel_button);
  local chat_channel_button_text_data=armature:findChildArmature("channel_button"):getBone("channel_button").textData;
  local chat_channel_button_skew=chat_channel_button_1:getPositionY()-chat_channel_button:getPositionY();
  self.armature:removeChild(chat_channel_button);
  self.armature:removeChild(chat_channel_button_1);

  local a=1;
  local s={"界\n世","派\n帮"};
  while 3>a do
    chat_channel_button=CommonButton.new();
    chat_channel_button:initialize("channel_button_normal","channel_button_down",CommonButtonTouchable.CUSTOM,self.skeleton);
    -- chat_channel_button:initializeText(chat_channel_button_text_data,s[a],nil,nil,makePoint(15,0));
    chat_channel_button:initializeBMText(s[a],"anniutuzi");
    chat_channel_button:setPositionXY(chat_channel_button_pos.x,(-1+a)*chat_channel_button_skew+chat_channel_button_pos.y);
    chat_channel_button:addEventListener(DisplayEvents.kTouchTap,self.onChannelButtonTap,self,1==a and ConstConfig.SUB_TYPE_WORLD or ConstConfig.SUB_TYPE_FACTION);
    self.armature:addChild(chat_channel_button);
    table.insert(self.channel_buttons,chat_channel_button);
    a=1+a;
  end

  -- self.closeButton = Button.new(self.armature4dispose:findChildArmature("common_close_button"), false);
  -- self.closeButton:addEventListener(Events.kStart, self.context.closeUI, self.context);
  local closeButton =self.armature4dispose.display:getChildByName("common_close_button");
  SingleButton:create(closeButton);
  closeButton:addEventListener(DisplayEvents.kTouchTap, self.context.closeUI, self.context);
  self.closeButton = closeButton;

  self:addEventListener(DisplayEvents.kTouchTap,self.onSelfTap,self);
end

function ChatLayer:onInitChatLayerPop()
  self.pop_armature=ChatLayerPop.new();
  self.pop_armature:initialize(self.context, self);
  self.textInput=self.pop_armature.textInput;

  self:addChild(self.pop_armature);
  self.closeButton.parent:removeChild(closeButton,false);
  self:addChild(closeButton);

  self:onChannelButtonTap(nil, ConstConfig.SUB_TYPE_WORLD);
end

function ChatLayer:onRemoveChatLayerPop()
  self:removeChild(self.pop_armature);
  self.pop_armature = nil;
end

--频道
function ChatLayer:onChannelButtonPopupTap(num)
  if self.channel_panel_select then
    self.channel_panel_select:setVisible(false);
    self.channel_panel_select=nil;
  end
  self.channel_panel_select=self:getChannelPanel(num);
  self.channel_panel_select:setVisible(true);
  self.armature:addChild(self.channel_panel_select);
end

--频道
function ChatLayer:onChannelButtonTap(event, num)
  print(event);
  if event then
    MusicUtils:playEffect(7,false);
  end
  if self:getSubType()==num then
    return;
  end
  
  if num == ConstConfig.SUB_TYPE_FACTION and not self.context.userProxy:getHasFamily() then
    sharedTextAnimateReward():animateStartByString("还没有帮派哟 ~");
    return;
  end
  if self.channel_button_select then
    self.channel_button_select:select(false);
    self.channel_button_select=nil;
  end
  self.channel_button_select=self.channel_buttons[ConstConfig.SUB_TYPE_WORLD == num and ConstConfig.SUB_TYPE_WORLD or 2];
  self.channel_button_select:select(true);
  self.channel_button_select.parent:removeChild(self.channel_button_select,false);
  self.armature:addChild(self.channel_button_select);
  self:onChannelButtonPopupTap(num);
end

function ChatLayer:getChannelPanel(num)
  if not self.channel_panels[num] then
    self.channel_panels[num]=ChatContent.new();
    self.channel_panels[num]:initialize(self.context);
    self.channel_panels[num]:initializeData(self.context.chatListProxy:getChatData(num));
    self.channel_panels[num]:setPosition(makePoint(126,205));
  end
  return self.channel_panels[num];
end

function ChatLayer:onSendButtonTap(event)
  if ConstConfig.SUB_TYPE_PRIVATE==self:getSubType() and ""==self:getUserName() then
    sharedTextAnimateReward():animateStartByString("木有说话的对象哦 !");
    return;
  elseif ConstConfig.SUB_TYPE_FACTION==self:getSubType() and 0==self.context.userProxy:getFamilyID() then
    sharedTextAnimateReward():animateStartByString("您还木有帮派哦 !");
    return;
  elseif ConstConfig.SUB_TYPE_NEAR==self:getSubType() and GameConfig.STATE_TYPE_2==self.context.userProxy.state then
    sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_210));
    return;
  elseif ConstConfig.SUB_TYPE_INFLUENCE==self:getSubType() then
    sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_207));
    return;
  else
    local a={};
    a.UserId=self:getUserID();
    a.UserName=self:getUserName();
    a.MainType=self:getMainType();
    a.SubType=self:getSubType();
    a.ChatContentArray=self:getContent();
    self.context:onMsgSend(a);
    
  end
  self.textInput:setInputText("");
end

function ChatLayer:getContent()
  local s;
  if ConstConfig.SUB_TYPE_PRIVATE==self:getSubType() then
    s=self.private_textInput:getInputText();
  else
    s=self.textInput:getInputText();
  end
  s=string.sub(s,10,-11);

  local defaultContent
  if GameData.platFormID == GameConfig.PLATFORM_CODE_GOOGLE then
    defaultContent = getLuaCodeTranslated('<font color="#808080">请输入...</font>')
  else
    defaultContent = '<font color="#808080">请输入...</font>'
  end
  if defaultContent==s or ''==s then
    s={};
  else
    s=StringUtils:getContentData(s);
  end
  return s;
end

function ChatLayer:getMainType()
  return ConstConfig.MAIN_TYPE_CHAT;
end

function ChatLayer:getSubType()
  for k,v in pairs(self.channel_buttons) do
    if self.channel_button_select==v then
      if 1 == k then
        return ConstConfig.SUB_TYPE_WORLD;
      elseif 2 == k then
        return ConstConfig.SUB_TYPE_FACTION;
      end
    end
  end
  return 0;
end

function ChatLayer:getUserID()
  if ConstConfig.SUB_TYPE_PRIVATE==self:getSubType() then
    if self.private_name.data then
      return self.private_name.data;
    end
  end
  return 0;
end

function ChatLayer:getUserName()
  if ConstConfig.SUB_TYPE_PRIVATE==self:getSubType() then
    return self.private_name:getString();
  end
  return "";
end

--更新聊天
function ChatLayer:refreshChatContent(data)
  if ConstConfig.SUB_TYPE_WORLD==data.SubType then

  elseif ConstConfig.SUB_TYPE_BROAD==data.SubType then
    
  else
    -- if ""==self.private_name:getString() or ConstConfig.SUB_TYPE_PRIVATE==data.SubType then
    --   self.private_name:setString(self.context.userProxy:getUserID()==data.UserId and data.TargetUserName or data.UserName,self.context.userProxy:getUserID()==data.UserId and data.TargetUserId or data.UserId);
    -- end
    if self.channel_panels[data.SubType] then
      self:getChannelPanel(data.SubType):addContentItem(data);
    else
      self:getChannelPanel(data.SubType);
    end
  end
  if self.channel_panels[ConstConfig.SUB_TYPE_WORLD] then
    self:getChannelPanel(ConstConfig.SUB_TYPE_WORLD):addContentItem(data);
  else
    self:getChannelPanel(ConstConfig.SUB_TYPE_WORLD);
  end
end








function ChatLayer:onPrivateToPlayer(userName, userID)
  self:onChannelButtonTap(nil,ConstConfig.SUB_TYPE_PRIVATE);
  self:onChannelButtonPopupTap(ConstConfig.SUB_TYPE_PRIVATE,userName,userID);
end





function ChatLayer:refreshPopArmature()
  self.pop_armature:refreshPopArmature();
end





function ChatLayer:onChatLayerPopButtonTap(pop)
  if self.chatLayerPopTapLayer then
    self:removeChild(self.chatLayerPopTapLayer);
    self.chatLayerPopTapLayer=nil;
  end
  if pop then
    self.chatLayerPopTapLayer=LayerColorBackGround:getOpacityBackGround();
    self:addChildAt(self.chatLayerPopTapLayer,-2+self:getNumOfChildren());
  end
  if self.channel_panel_select then
    self.channel_panel_select.listScrollViewLayer:setMoveEnabled(not pop);
  end
end

function ChatLayer:refreshPrivateChatValid(state)
  self.pop_armature:refreshPrivateChatValid(state);
end