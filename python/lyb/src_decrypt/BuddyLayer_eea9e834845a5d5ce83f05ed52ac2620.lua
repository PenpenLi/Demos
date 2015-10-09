--[[
  Copyright @2009-2013 www.happyelements.com, all rights reserved.
  Create date: 2013-4-15

  yanchuan.xie@happyelements.com
]]

require "core.controls.Button";
require "core.events.DisplayEvent";
require "core.utils.Scheduler";
require "core.controls.CommonPopup";
require "main.view.chat.ui.chatPopup.BuddyItem";
require "main.config.XiShuConfig";

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

function BuddyLayer:initialize(skeleton, container_parent)
  self:initLayer();
  self.skeleton=skeleton;
  self.chatListProxy=container_parent.chatListProxy;
  self.buddyListProxy=container_parent.buddyListProxy;
  self.container_parent=container_parent;
  self.const_buddy_item_num=5.2;

  --骨骼
  local armature=skeleton:buildArmature("buddy_panel");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  --buddy_number
  local text="";
  self.buddy_number_descb=createTextFieldWithTextData(armature:getBone("buddy_number").textData,text);
  self.armature:addChild(self.buddy_number_descb);

  local button=Button.new(armature:findChildArmature("common_copy_blueround_button"),false);
  button.bone:initTextFieldWithString("common_copy_blueround_button","添加");
  button:addEventListener(Events.kStart,self.onAddBuddyTap,self);
  
  --buddy_item_over
  local buddy_item_over=self.skeleton:getCommonBoneTextureDisplay("common_inner_tab_button_down");
  self.buddy_list_item_size=buddy_item_over:getContentSize();
  self.buddy_list_view_size=makeSize(self.buddy_list_item_size.width,self.buddy_list_item_size.height*self.const_buddy_item_num);
  buddy_item_over:dispose();
  
  --common_copy_button_bg_1
  self.common_copy_button_bg_1=self.armature:getChildByName("common_copy_button_bg_1");
  self.common_copy_button_bg_1_pos=self.common_copy_button_bg_1:getPosition();
  self.common_copy_button_bg_1_pos.y=self.common_copy_button_bg_1_pos.y-self.buddy_list_view_size.height;

  --scroll
  self.chatTalkerScrollList=ChatTalkerScrollList.new();
  self.chatTalkerScrollList:initialize(self.skeleton,
                                       self,
                                       self.onChatTalkerScrollListItemTap,
                                       self.onMsgState,
                                       self.const_buddy_item_num,
                                       self.buddy_list_item_size
                                       );
  self.chatTalkerScrollList:setPosition(self.common_copy_button_bg_1_pos);
  self.armature:addChild(self.chatTalkerScrollList);

  self.pop_armature=ChatLayerPop.new();
  self.pop_armature:initialize(self.skeleton,self);
  self.pop_armature.armature:removeChild(self.private_textInput);
  self.pop_armature.armature:removeChild(self.private_name);
  self.textInput=self.pop_armature.textInput;
  self.pop_armature.armature:addChild(self.textInput);
  self:addChild(self.pop_armature);

  self:refreshBuddyNumber();
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