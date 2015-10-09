--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-15

	yanchuan.xie@happyelements.com
]]

require "core.controls.Button";
require "core.events.DisplayEvent";
require "core.utils.Scheduler";
require "core.controls.CommonPopup";

ChatTalkerScrollList=class(Layer);

function ChatTalkerScrollList:ctor()
  self.class=ChatTalkerScrollList;
end

function ChatTalkerScrollList:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	ChatTalkerScrollList.superclass.dispose(self);
end

function ChatTalkerScrollList:initialize(skeleton, context, onItemTap, onMsgState, const_item_num, buddy_item_size)
  self:initLayer();

  self.skeleton=skeleton;
  self.chatListProxy=context.chatListProxy;
  self.buddyListProxy=context.buddyListProxy;
  self.context=context;
  self.onItemTap=onItemTap;
  self.onMsgState=onMsgState;
  self.const_talker_item_num=const_item_num;
  self.const_buddy_item_size=buddy_item_size;

  self.talkerListParam=talkerListParam;
  
  self.talker_items={};
  self.talker_item_tap=nil;

  --scroll
  self.listScrollViewLayer=ListScrollViewLayer.new();
  self.listScrollViewLayer:initLayer();
  self.listScrollViewLayer:setViewSize(makeSize(self.const_buddy_item_size.width,
                                  self.const_buddy_item_size.height*self.const_talker_item_num));
  self.listScrollViewLayer:setContentSize(makeSize(self.const_buddy_item_size.width,
                                  self.const_buddy_item_size.height*self.const_talker_item_num));
  self.listScrollViewLayer:setItemSize(self.const_buddy_item_size);
  self:addChild(self.listScrollViewLayer);

  self:refreshAllBuddyData();
end

local function sfun(a, b)
  if a.Level<b.Level then
    return true;
  end
  return false;
end

function ChatTalkerScrollList:addBuddyItem(userRelation, is_online, pos)
  if self:getItem(userRelation.UserName) then
    
  else
    local item=BuddyItem.new();
    item:initialize(self.skeleton,userRelation,self,self.onBuddyItemTap,self.context,self.onMsgState);
    item:setOnline(is_online);
    if pos then
      self.listScrollViewLayer:addItemAt(item,-1+pos,false);
      table.insert(self.talker_items,pos,item);
    else
      self.listScrollViewLayer:addItem(item);
      table.insert(self.talker_items,item);
    end
  end
end

function ChatTalkerScrollList:order4Record()
  local data=self.chatListProxy:getRecord();
  if data then
    for k,v in pairs(data) do
      self:scrollBuddyItem(v.UserName);
    end
  end
  --self:onBuddyItemTap(self.talker_items[1]);
end

--移除好友
function ChatTalkerScrollList:deleteBuddy(userName, userID)
  for k,v in pairs(self.talker_items) do
    if v:isEqualUserName(userName) then
      self:refreshMainSceneIcon(v);

      if self.talker_item_tap==v then
        if 1==table.getn(self.talker_items) then
          self:onBuddyItemTap(nil);
        elseif self.talker_items[1]==self.talker_item_tap then
          self:onBuddyItemTap(self.talker_items[2]);
        else
          self:onBuddyItemTap(self.talker_items[1]);
        end
      end

      self.listScrollViewLayer:removeItemAt(-1+k);
      table.remove(self.talker_items,k);
      break;
    end
  end
end

function ChatTalkerScrollList:refreshAllBuddyData()
  local userRelationArray=self.buddyListProxy:getData();
  if nil==userRelationArray then
    return;
  end
  for k,v in pairs(userRelationArray) do
    self:addBuddyItem(v);
  end
end

--更新好友
function ChatTalkerScrollList:refreshBuddyData()
  for k,v in pairs(self.talker_items) do
    v:refreshBuddyData();
    v:setOnline(self.buddyListProxy:getBuddyOnlineData(v:getUserName()));
  end
  local userRelationArray=self.buddyListProxy:getDataOnline();
  if nil==userRelationArray then
    return;
  end
  table.sort(userRelationArray,sfun);
  for k,v in pairs(userRelationArray) do
    self:scrollBuddyItem(v.UserName);
  end
end

function ChatTalkerScrollList:refreshMainSceneIcon(buddyItem)
  -- local chatNum=self.context.container_parent.tab_tips[1]:getNum();
  -- local chatBuddyNum=-buddyItem.pannel_tip:getNum();
  -- for k,v in pairs(self.talker_items) do
  --   chatBuddyNum=v.pannel_tip:getNum()+chatBuddyNum;
  -- end
  -- self.context.container_parent:dispatchEvent(Event.new("buddyDeletedToRefreshMainSceneIcon",{ChatNumber=chatNum,ChatBuddyNumber=chatBuddyNum},self.context.container_parent));
end

function ChatTalkerScrollList:onBuddyItemTap(buddy_item, event)
  if self.talker_item_tap==buddy_item then
    local buddyItemPopup=BuddyItemPopup.new();
    buddyItemPopup:initialize(self.skeleton,{UserId=self.talker_item_tap:getUserId(),UserName=self.talker_item_tap:getUserName()},self.context.container_parent,self.context.container_parent.onViewTap,
                                                                                               self.context.container_parent.onChallenge,
                                                                                               self.context.container_parent.onPrivateTap,
                                                                                               self.context.container_parent.onAddTap,
                                                                                               self.context.container_parent.onInviteTap,
                                                                                               event.globalPosition,
                                                                                               true,
                                                                                               0~=self.context.container_parent.userProxy:getFamilyID(),
                                                                                               nil,
                                                                                               true,
                                                                                               self.context.container_parent.onDeleteBuddyButtonTap);
    self.context.container_parent:addChild(buddyItemPopup);
    return;
  end
  if self.talker_item_tap then
    self.talker_item_tap:select(false);
    self.talker_item_tap=nil;
  end
  if buddy_item then
    self.talker_item_tap=buddy_item;
    self.talker_item_tap:select(true);
    self.chatListProxy:deleteRecordByUserName(self.talker_item_tap:getUserName());

    if self.context and self.onItemTap then
      self.onItemTap(self.context,self.talker_item_tap);
    end
  end
end

--加好友
function ChatTalkerScrollList:refreshAddBuddy(userName, level, userID)
  local userRelation=self.buddyListProxy:getBuddyData(userName);
  local a=1;
  for k,v in pairs(self.talker_items) do
    if false==v:getIsOnline() then
      a=k;
      break;
    end
  end
  self:addBuddyItem(userRelation,true,a);
end

--更新聊天
function ChatTalkerScrollList:refreshChatContent(data)

  local isUserName=data.UserName==ConstConfig.USER_NAME;
  local name=nil;
  if isUserName then
    name=data.TargetUserName;
  else
    name=data.UserName;
  end

  local a=self:getItem(name);
  if a then
    a:refreshChatContent(data);
    self:scrollBuddyItem(name);
  end
end

function ChatTalkerScrollList:scrollBuddyItem(userName)
  for k,v in pairs(self.talker_items) do
    if v:isEqualUserName(userName) then
      self.listScrollViewLayer:removeItemAt(-1+k,false);
      table.remove(self.talker_items,k);
      self.listScrollViewLayer:addItemAt(v,0,true);
      table.insert(self.talker_items,1,v);
      break;
    end
  end
end

function ChatTalkerScrollList:getItem(userName)
  for k,v in pairs(self.talker_items) do
    if v:isEqualUserName(userName) then
      return v;
    end
  end
end

function ChatTalkerScrollList:getItemSelected()
  return self.talker_item_tap;
end