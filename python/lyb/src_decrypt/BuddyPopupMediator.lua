require "main.view.buddy.ui.HaoyouPopup";

BuddyPopupMediator=class(Mediator);

function BuddyPopupMediator:ctor()
  self.class=BuddyPopupMediator;
	self.viewComponent=HaoyouPopup.new();
end

rawset(BuddyPopupMediator,"name","BuddyPopupMediator");

function BuddyPopupMediator:addBuddy(userName)

end

function BuddyPopupMediator:buddyDeletedRefreshPannelTip(chatNum, chatBuddyNum)
  self:getViewComponent():buddyDeletedRefreshPannelTip(chatNum,chatBuddyNum);
end

--删除好友
function BuddyPopupMediator:deleteBuddy(userName, userID)
	self:getViewComponent():deleteBuddy(userName,userID);
end

--添加好友
function BuddyPopupMediator:onChatAddBuddy(event)
  self:sendNotification(ChatNotification.new(ChatNotifications.CHAT_ADD_BUDDY,event.data));
end

--删除好友
function ChatPopupMediator:onChatDeleteBuddy(event)
  self:sendNotification(ChatNotification.new(ChatNotifications.CHAT_DELETE_BUDDY,event.data));
end

function BuddyPopupMediator:onChatLookInto(event)
  self:sendNotification(ChatNotification.new(ChatNotifications.CHAT_LOOK_INTO,event.data));
end

function BuddyPopupMediator:onChatMsgState(event)
  self:sendNotification(ChatNotification.new(ChatNotifications.CHAT_MSG_STATE,event.data));
end

function BuddyPopupMediator:onChatView(event)
  self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_LOOK_INTO_PLAYER,event.data));
end

function BuddyPopupMediator:onDeleteBuddy(event)
  self:sendNotification(ChatNotification.new(ChatNotifications.CHAT_DELETE_BUDDY,event.data));
end

function BuddyPopupMediator:onPrivateToPlayer(userName)
  self:getViewComponent():onPrivateToPlayer(userName);
end

function BuddyPopupMediator:onPrivateToBuddy(userName)
  self:getViewComponent():onPrivateToBuddy(userName);
end

function BuddyPopupMediator:onRefreshMainSceneIcon(event)
  self:sendNotification(ChatNotification.new(ChatNotifications.BUDDY_DELETED_TO_REFRESH_MAIN_SCENE_ICON,event.data));
end

--发送
function BuddyPopupMediator:onSend(event)
  self:sendNotification(ChatNotification.new(ChatNotifications.CHAT_SEND,event.data));
end

function BuddyPopupMediator:onInviteFamily(event)
  self:sendNotification(FamilyNotification.new(FamilyNotifications.FAMILY_INVITE,event.data));
end

function BuddyPopupMediator:onGetEXP(event)
  self:sendNotification(ChatNotification.new(ChatNotifications.CHAT_BUDDY_FEED_GET_EXP,event.data));
end

function BuddyPopupMediator:onRequestCommend(event)
  self:sendNotification(ChatNotification.new(ChatNotifications.CHAT_REQUEST_BUDDY_COMMEND,event.data));
end

function BuddyPopupMediator:onPlayerReport(event)
  self:sendNotification(ChatNotification.new(ChatNotifications.CHAT_PLAYER_REPORT,event.data));
end

function BuddyPopupMediator:onToAutoGuide(event)
  self:sendNotification(OpenFunctionNotification.new(OpenFunctionNotifications.OPEN_UI_BY_FUNCTION_ID,event.data));
end

function BuddyPopupMediator:closeTip(event)
  self:sendNotification(TipNotification.new(TipNotifications.REMOVE_TIP_COMMOND));
end

function BuddyPopupMediator:popTip(event)
  self:sendNotification(TipNotification.new(TipNotifications.OPEN_TIP_COMMOND,event.data));
end

function BuddyPopupMediator:onClose(event)
  self:sendNotification(ChatNotification.new(ChatNotifications.BUDDY_CLOSE,event.data));
end

function BuddyPopupMediator:order4Record()
  self:getViewComponent():order4Record();
end

--加好友
function BuddyPopupMediator:refreshAddBuddy(userName, level, userID)
  self:getViewComponent():refreshAddBuddy(userName,level,userID);
end

--更新好友留言
function BuddyPopupMediator:refreshBuddyChatRecord(chatListProxy)
  self:getViewComponent():refreshBuddyChatRecord(chatListProxy);
end

--更新好友
function BuddyPopupMediator:refreshBuddyData()
	self:getViewComponent():refreshBuddyData();
end

--更新聊天
function BuddyPopupMediator:refreshChatContent(data)
  self:getViewComponent():refreshChatContent(data);
end

function BuddyPopupMediator:refreshPopArmature()
  self:getViewComponent():refreshPopArmature();
end

function BuddyPopupMediator:setTextInputResponsable(bool)
  self:getViewComponent():setTextInputResponsable(bool);
end

function BuddyPopupMediator:refreshChatEquipDetailLayer(skeleton, data)
  self:getViewComponent():refreshChatEquipDetailLayer(skeleton,data);
end

function BuddyPopupMediator:refreshFeed(data)
  self:getViewComponent():refreshFeed(data);
end

function BuddyPopupMediator:refreshFeedEXP()
  self:getViewComponent():refreshFeedEXP();
end

function BuddyPopupMediator:refreshBuddyCommend(data)
  self:getViewComponent():refreshBuddyCommend(data);
end

function BuddyPopupMediator:refreshPrivateChatValid(state)
  self:getViewComponent():refreshPrivateChatValid(state);
end

function BuddyPopupMediator:changeTab(tabID, openBuddyFeed)
  self:getViewComponent():changeTab(tabID,openBuddyFeed);
end

function BuddyPopupMediator:onChatBuddyOnline(event)
  self:sendNotification(ChatNotification.new(ChatNotifications.CHAT_BUDDY_ONLINE,event.data));
end

function BuddyPopupMediator:refreshFlowerHistoryData(flowerHistoryArray)
  self:getViewComponent().panels[2]:refreshFlowerHistoryData(flowerHistoryArray);
end

function BuddyPopupMediator:onRegister()
  self:getViewComponent():addEventListener("chatAddBuddy",self.onChatAddBuddy,self);
  self:getViewComponent():addEventListener("chatDeleteBuddy",self.onDeleteBuddy,self);
  self:getViewComponent():addEventListener("chatSend",self.onSend,self);
  self:getViewComponent():addEventListener("chatMsgState",self.onChatMsgState,self);
  self:getViewComponent():addEventListener("chatView",self.onChatView,self);
  self:getViewComponent():addEventListener("buddyDeletedToRefreshMainSceneIcon",self.onRefreshMainSceneIcon,self);
  self:getViewComponent():addEventListener("invite_family",self.onInviteFamily,self);
  self:getViewComponent():addEventListener(ChatNotifications.CHAT_LOOK_INTO,self.onChatLookInto,self);
  self:getViewComponent():addEventListener(ChatNotifications.CHAT_BUDDY_FEED_GET_EXP,self.onGetEXP,self);
  self:getViewComponent():addEventListener(ChatNotifications.CHAT_REQUEST_BUDDY_COMMEND,self.onRequestCommend,self);
  self:getViewComponent():addEventListener(ChatNotifications.CHAT_PLAYER_REPORT,self.onPlayerReport,self);

  self:getViewComponent():addEventListener(TipNotifications.OPEN_TIP_COMMOND,self.popTip,self);
  self:getViewComponent():addEventListener(TipNotifications.REMOVE_TIP_COMMOND,self.closeTip,self);

  self:getViewComponent():addEventListener("TO_AUTO_GUIDE",self.onToAutoGuide,self);
  self:getViewComponent():addEventListener("DUEL_OTHER_PLAYER",self.duelOtherPlayer,self);
  self:getViewComponent():addEventListener("APPLY_FAMILY",self.applyFamily,self);

  self:getViewComponent():addEventListener(ChatNotifications.CHAT_BUDDY_ONLINE,self.onChatBuddyOnline,self);

  self:getViewComponent():addEventListener(ChatNotifications.BUDDY_CLOSE,self.onClose,self);
end

function BuddyPopupMediator:onRemove()
	if self:getViewComponent().parent then
    self:getViewComponent().parent:removeChild(self:getViewComponent());
  elseif not self:getViewComponent().isDisposed then
    self:getViewComponent():dispose();
  end
end

function BuddyPopupMediator:duelOtherPlayer(evt)
  self:sendNotification(MainSceneNotification.new(MainSceneNotifications.DUEL_OTHER_PLAYER,{UserId = evt.data.UserId, UserName = evt.data.UserName}));
end

function BuddyPopupMediator:applyFamily(evt)
  self:sendNotification(FamilyNotification.new(FamilyNotifications.FAMILY_APPLY,{FamilyId = evt.data, FamilyName = "", UserId = 0,UserName = "", BooleanValue = 1}));
end