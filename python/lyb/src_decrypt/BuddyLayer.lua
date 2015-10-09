--[[
  Copyright @2009-2013 www.happyelements.com, all rights reserved.
  Create date: 2013-4-15

  yanchuan.xie@happyelements.com
]]

require "core.controls.Button";
require "core.events.DisplayEvent";
require "core.utils.Scheduler";
require "core.controls.CommonPopup";
require "main.config.XiShuConfig";
require "main.view.buddy.ui.buddyPopup.BuddyItemPageView";
require "main.view.buddy.ui.buddyPopup.BuddyFlowerLayer";
require "main.view.buddy.ui.buddyPopup.BuddyAddPanel";
require "main.view.buddy.ui.buddyPopup.BuddySendFlower";
require "core.display.BitmapTextField";

BuddyLayer=class(Layer);

function BuddyLayer:ctor()
  self.class=BuddyLayer;
end

function BuddyLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  BuddyLayer.superclass.dispose(self);
  self.armature4dispose:dispose();
end

function BuddyLayer:initialize(context)
  self:initLayer();
  self.context=context;
  self.skeleton=self.context.skeleton;
  self.const_chat_content_item_num=10;
  
  self.channel_buttons={};
  self.channel_button_select=nil;
  self.channel_panels={};
  self.channel_panel_select=nil;


  --骨骼
  local armature=self.skeleton:buildArmature("buddy_ui");
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
  local chat_channel_button_text_data=armature:findChildArmature("channel_button"):getBone("common_channel_button").textData;
  local chat_channel_button_skew=chat_channel_button_1:getPositionY()-chat_channel_button:getPositionY();
  self.armature:removeChild(chat_channel_button);
  self.armature:removeChild(chat_channel_button_1);
  self.armature:removeChild(self.armature:getChildByName("channel_button_2"));

  local a=1;
  local s={"好友","鲜花","查找"};
  while 4>a do
    chat_channel_button=CommonButton.new();
    chat_channel_button:initialize("commonButtons/common_channel_button_normal","commonButtons/common_channel_button_down",CommonButtonTouchable.CUSTOM);
    chat_channel_button:initializeText(chat_channel_button_text_data,s[a]);
    -- chat_channel_button:initializeBMText("0\n1","MSYH_huang_30","2\n3","MSYH_huang_30",ccp(20,30),ccp(20,30));
    chat_channel_button:setPositionXY(chat_channel_button_pos.x,(-1+a)*chat_channel_button_skew+chat_channel_button_pos.y);
    chat_channel_button:addEventListener(DisplayEvents.kTouchTap,self.onChannelButtonTap,self,a);
    self:addChild(chat_channel_button);
    table.insert(self.channel_buttons,chat_channel_button);
    a=1+a;
  end

  -- self.closeButton = Button.new(self.armature4dispose:findChildArmature("common_close_button"), false);
  -- self.closeButton:addEventListener(Events.kStart, self.context.closeUI, self.context);
  local closeButton =self.armature4dispose.display:getChildByName("common_close_button");
  SingleButton:create(closeButton);
  closeButton:addEventListener(DisplayEvents.kTouchTap, self.context.closeUI, self.context);
end

function BuddyLayer:initializeGallery()
  local buddyData = self.context.buddyListProxy:getData();
  local layer = Layer.new();
  layer:initLayer();
  self.scrollView=BuddyItemPageView.new(CCPageView:create());
  self.scrollView:initialize(self.context,{{UserId=1,UserName="asdfads1",Career=21,Level=1,Zhanli=12312,BooleanValue=1},
                                    {UserId=1,UserName="asdfads2",Career=21,Level=1,Zhanli=12312,BooleanValue=1},
                                    {UserId=1,UserName="asdfads3",Career=21,Level=1,Zhanli=12312,BooleanValue=1},
                                    {UserId=1,UserName="asdfads4",Career=21,Level=1,Zhanli=12312,BooleanValue=1},
                                    {UserId=1,UserName="asdfads5",Career=21,Level=1,Zhanli=12312,BooleanValue=1},
                                    {UserId=1,UserName="asdfads6",Career=21,Level=1,Zhanli=12312,BooleanValue=1},
                                    {UserId=1,UserName="asdfads7",Career=21,Level=1,Zhanli=12312,BooleanValue=1},
                                    {UserId=1,UserName="asdfads8",Career=21,Level=1,Zhanli=12312,BooleanValue=1},
                                    {UserId=1,UserName="asdfads9",Career=21,Level=1,Zhanli=12312,BooleanValue=1},
                                    {UserId=1,UserName="asdfads10",Career=21,Level=1,Zhanli=12312,BooleanValue=1},
                                    {UserId=1,UserName="asdfads11",Career=21,Level=1,Zhanli=12312,BooleanValue=1},
                                    {UserId=1,UserName="asdfads12",Career=21,Level=1,Zhanli=12312,BooleanValue=1},
                                    {UserId=1,UserName="asdfads13",Career=21,Level=1,Zhanli=12312,BooleanValue=1},
                                    {UserId=1,UserName="asdfads14",Career=21,Level=1,Zhanli=12312,BooleanValue=1},
                                    {UserId=1,UserName="asdfads15",Career=21,Level=1,Zhanli=12312,BooleanValue=1},
                                    {UserId=1,UserName="asdfads16",Career=21,Level=1,Zhanli=12312,BooleanValue=1},
                                    {UserId=1,UserName="asdfads17",Career=21,Level=1,Zhanli=12312,BooleanValue=1},
                                    {UserId=1,UserName="asdfads18",Career=21,Level=1,Zhanli=12312,BooleanValue=1},
                                    {UserId=1,UserName="asdfads19",Career=21,Level=1,Zhanli=12312,BooleanValue=1},
                                    {UserId=1,UserName="asdfads20",Career=21,Level=1,Zhanli=12312,BooleanValue=1},
                                    {UserId=1,UserName="asdfads21",Career=21,Level=1,Zhanli=12312,BooleanValue=1},});
  self.scrollView:setPositionXY(21,-35);
  local pageControl = self.scrollView.pageViewControl;
  if pageControl then
    pageControl:setPositionXY(511-pageControl:getGroupBounds().size.width/2,45);
    layer:addChild(pageControl);
  end
  self.buddy_count_text=TextField.new(CCLabelTTF:create("好友数:100/100",FontConstConfig.OUR_FONT,26));
  self.buddy_count_text:setPositionXY(811,75);
  layer:addChild(self.buddy_count_text);
  layer:addChild(self.scrollView);
  return layer;
end

function BuddyLayer:initializeFlowerLayer()
  local layer = BuddyFlowerLayer.new();
  layer:initialize(self.context);
  layer:setPositionXY(21,55);
  return layer;
end

function BuddyLayer:initializeAddBuddyLayer()
  local layer = BuddyAddPanel.new();
  layer:initialize(self.context);
  layer:setPositionXY(231,210);
  return layer;
end

--频道
function BuddyLayer:onChannelButtonTap(event, num)
  print(num);
  if self.channel_button_select==self.channel_buttons[num] then
    return;
  end
  if self.channel_button_select then
    self.channel_button_select:select(false);
    self.channel_button_select=nil;
  end
  if self.channel_panel_select then
    self.channel_panel_select:setVisible(false);
    self.channel_panel_select=nil;
  end
  if 0 == num then
    return;
  end
  self.channel_button_select=self.channel_buttons[num];
  self.channel_button_select:select(true);

  self.channel_panel_select=self:getPannelByNum(num);
  if self.channel_panel_select then
    self.channel_panel_select:setVisible(true);
    self.armature:addChild(self.channel_panel_select);
  end

  if self.pLabelFont then
    self.pLabelFont:setString("3");
    return;
  end  
  self.pLabelFont=BitmapTextField.new("方太十","yingxiongmingzi");
  self:addChild(self.pLabelFont);
end

function BuddyLayer:getPannelByNum(num)
  if not self.channel_panels[num] then
    local layer;
    if 1 == num then
      layer = self:initializeGallery();
    elseif 2 == num then
      layer = self:initializeFlowerLayer();
    elseif 3 == num then
      layer = self:initializeAddBuddyLayer();
    end
    self.channel_panels[num]=layer;
  end
  return self.channel_panels[num];
end









function BuddyLayer:order4Record()
  self.chatTalkerScrollList:order4Record();
end

--加好友
function BuddyLayer:refreshAddBuddy(userName, level, userID)
  self.chatTalkerScrollList:refreshAddBuddy(userName,level,userID);
  self:refreshBuddyNumber();
end

--更新好友
function BuddyLayer:refreshBuddyData()
  self.chatTalkerScrollList:refreshBuddyData();
end

function BuddyLayer:refreshPopArmature()
  self.pop_armature:refreshPopArmature();
end

--好友Item
function BuddyLayer:onChatTalkerScrollListItemTap(buddyItem)
  if self.common_scroll_list then
    self.common_scroll_list:setVisible(false);
    self.common_scroll_list=nil;
  end
  if buddyItem then
    self.common_scroll_list=buddyItem:getCommonScrollList();
    self.common_scroll_list:setVisible(true);
    self.armature:addChild(self.common_scroll_list);
  end
end

function BuddyLayer:refreshBuddyNumber()
  self.buddy_number_descb:setString(self.buddyListProxy:getBuddyNum() .. "/" .. analysis("Xishuhuizong_Xishubiao",XiShuConfig.TYPE_91,"constant"));
end

--更新聊天
function BuddyLayer:refreshChatContent(data)
  self.chatTalkerScrollList:refreshChatContent(data);
end

--移除好友
function BuddyLayer:deleteBuddy(userName, userID)
  self.chatTalkerScrollList:deleteBuddy(userName,userID);
  self:refreshBuddyNumber();
end

--移除好友
function BuddyLayer:onDeleteTap(event)
  local buddyItem=self.chatTalkerScrollList:getItemSelected();
  if buddyItem then
    local a={UserName=buddyItem:getUserName()};
    self.container_parent:onDeleteBuddyButtonTap(a);
  end
end

--添加好友
function BuddyLayer:onAddBuddyTap(event)
  self.container_parent:onAddBuddyButtonTap();
end

function BuddyLayer:onMsgState(data)
  self.container_parent:onMsgState(data);
end

--发送
function BuddyLayer:onSendButtonTap(event)
  if nil==self.chatTalkerScrollList:getItemSelected() then
    sharedTextAnimateReward():animateStartByString("木有说话的对象哦 !");
    return;
  else
    local a={};
    a.UserId=self:getUserID();
    a.UserName=self:getUserName();
    a.MainType=self:getMainType();
    a.SubType=self:getSubType();
    a.ChatContentArray=self:getContent();
    self.container_parent:onMsgSend(a);

    -- 好友聊天打点
    hecDC(3,15,7)
  end
  self.textInput:setInputText("");
end

function BuddyLayer:onViewTap(event)
  local buddyItem=self.chatTalkerScrollList:getItemSelected();
  if buddyItem then
    self.container_parent:onView(buddyItem:getUserName(),buddyItem:getUserId());
  end
end

function BuddyLayer:getMainType()
  return ConstConfig.MAIN_TYPE_BUDDY;
end

function BuddyLayer:getSubType()
  return 0;
end

function BuddyLayer:getUserID()
  if self.chatTalkerScrollList and self.chatTalkerScrollList:getItemSelected() then
    return self.chatTalkerScrollList:getItemSelected():getUserId();
  end
  return 0;
end

function BuddyLayer:getUserName()
  if self.chatTalkerScrollList and self.chatTalkerScrollList:getItemSelected() then
    return self.chatTalkerScrollList:getItemSelected():getUserName();
  end
  return "";
end

function BuddyLayer:getContent()
  local s=string.sub(self.textInput:getInputText(),10,-11);

  local defaultContent
  if GameData.platFormID == GameConfig.PLATFORM_CODE_GOOGLE then
    defaultContent = getLuaCodeTranslated('<font color="#808080">请输入...</font>')
  else
    defaultContent = '<font color="#808080">请输入...</font>'
  end
  
  if defaultContent==s then
    s="";
  else
    s=StringUtils:getContentData(s);
  end
  return s;
end

function BuddyLayer:onPrivateToBuddy(userName)
  local item=self.chatTalkerScrollList:getItem(userName);
  if item==self.chatTalkerScrollList:getItemSelected() then

  else
    self.chatTalkerScrollList:onBuddyItemTap(item);
  end
end

function BuddyLayer:onChatLayerPopButtonTap(pop)
  if self.chatLayerPopTapLayer then
    self:removeChild(self.chatLayerPopTapLayer);
    self.chatLayerPopTapLayer=nil;
  end
  if pop then
    self.chatLayerPopTapLayer=LayerColorBackGround:getTransBackGround();
    self:addChildAt(self.chatLayerPopTapLayer,-1+self:getNumOfChildren());
  end
  if self.common_scroll_list then
    self.common_scroll_list.listScrollViewLayer:setMoveEnabled(not pop);
  end
end