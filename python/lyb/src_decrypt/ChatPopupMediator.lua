require "main.view.chat.ui.ChatPopup";

ChatPopupMediator=class(Mediator);

function ChatPopupMediator:ctor()
  self.class=ChatPopupMediator;
	self.viewComponent=ChatPopup.new();
end

rawset(ChatPopupMediator,"name","ChatPopupMediator");

function ChatPopupMediator:addBuddy(userName)

end

function ChatPopupMediator:buddyDeletedRefreshPannelTip(chatNum, chatBuddyNum)
  self:getViewComponent():buddyDeletedRefreshPannelTip(chatNum,chatBuddyNum);
end

--删除好友
function ChatPopupMediator:deleteBuddy(userName, userID)
	self:getViewComponent():deleteBuddy(userName,userID);
end

--添加好友
function ChatPopupMediator:onChatAddBuddy(event)
  self:sendNotification(ChatNotification.new(ChatNotifications.CHAT_ADD_BUDDY,event.data));
end

--删除好友
function ChatPopupMediator:onChatDeleteBuddy(event)
  self:sendNotification(ChatNotification.new(ChatNotifications.CHAT_DELETE_BUDDY,event.data));
end

function ChatPopupMediator:onChatLookInto(event)
  self:sendNotification(ChatNotification.new(ChatNotifications.CHAT_LOOK_INTO,event.data));
end

function ChatPopupMediator:onChatMsgState(event)
  self:sendNotification(ChatNotification.new(ChatNotifications.CHAT_MSG_STATE,event.data));
end

function ChatPopupMediator:onChatView(event)
  self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_LOOK_INTO_PLAYER,event.data));
end

function ChatPopupMediator:onDeleteBuddy(event)
  self:sendNotification(ChatNotification.new(ChatNotifications.CHAT_DELETE_BUDDY,event.data));
end

function ChatPopupMediator:onPrivateToPlayer(userName)
  self:getViewComponent():onPrivateToPlayer(userName);
end

function ChatPopupMediator:onPrivateToBuddy(userName)
  self:getViewComponent():onPrivateToBuddy(userName);
end

function ChatPopupMediator:onRefreshMainSceneIcon(event)
  self:sendNotification(ChatNotification.new(ChatNotifications.BUDDY_DELETED_TO_REFRESH_MAIN_SCENE_ICON,event.data));
end

--发送
function ChatPopupMediator:onSend(event)
  self:sendNotification(ChatNotification.new(ChatNotifications.CHAT_SEND,event.data));
end

function ChatPopupMediator:onInviteFamily(event)
  self:sendNotification(FamilyNotification.new(FamilyNotifications.FAMILY_INVITE,event.data));
end

function ChatPopupMediator:onGetEXP(event)
  self:sendNotification(ChatNotification.new(ChatNotifications.CHAT_BUDDY_FEED_GET_EXP,event.data));
end

function ChatPopupMediator:onRequestCommend(event)
  self:sendNotification(ChatNotification.new(ChatNotifications.CHAT_REQUEST_BUDDY_COMMEND,event.data));
end

function ChatPopupMediator:onPlayerReport(event)
  self:sendNotification(ChatNotification.new(ChatNotifications.CHAT_PLAYER_REPORT,event.data));
end

function ChatPopupMediator:onToAutoGuide(event)
  self:sendNotification(OpenFunctionNotification.new(OpenFunctionNotifications.OPEN_UI_BY_FUNCTION_ID,event.data));
end

function ChatPopupMediator:closeTip(event)
  self:sendNotification(TipNotification.new(TipNotifications.REMOVE_TIP_COMMOND));
end

function ChatPopupMediator:popTip(event)
  self:sendNotification(TipNotification.new(TipNotifications.OPEN_TIP_COMMOND,event.data));
end

function ChatPopupMediator:onClose(event)
  self:sendNotification(ChatNotification.new(ChatNotifications.CHAT_CLOSE,event.data));
end

function ChatPopupMediator:order4Record()
  self:getViewComponent():order4Record();
end

--加好友
function ChatPopupMediator:refreshAddBuddy(userName, level, userID)
  self:getViewComponent():refreshAddBuddy(userName,level,userID);
end

--更新好友留言
function ChatPopupMediator:refreshBuddyChatRecord(chatListProxy)
  self:getViewComponent():refreshBuddyChatRecord(chatListProxy);
end

--更新好友
function ChatPopupMediator:refreshBuddyData()
	self:getViewComponent():refreshBuddyData();
end

--更新聊天
function ChatPopupMediator:refreshChatContent(data)
  self:getViewComponent():refreshChatContent(data);
end

function ChatPopupMediator:refreshPopArmature()
  self:getViewComponent():refreshPopArmature();
end

function ChatPopupMediator:setTextInputResponsable(bool)
  self:getViewComponent():setTextInputResponsable(bool);
end

function ChatPopupMediator:refreshChatEquipDetailLayer(skeleton, data)
  self:getViewComponent():refreshChatEquipDetailLayer(skeleton,data);
end

function ChatPopupMediator:refreshChatHeroDetailLayer(skeleton, data)
  self:getViewComponent():refreshChatHeroDetailLayer(skeleton,data);
end

function ChatPopupMediator:refreshFeed(data)
  self:getViewComponent():refreshFeed(data);
end

function ChatPopupMediator:refreshFeedEXP()
  self:getViewComponent():refreshFeedEXP();
end

function ChatPopupMediator:refreshBuddyCommend(data)
  self:getViewComponent():refreshBuddyCommend(data);
end

function ChatPopupMediator:refreshPrivateChatValid(state)
  self:getViewComponent():refreshPrivateChatValid(state);
end

function ChatPopupMediator:changeTab(tabID, openBuddyFeed)
  self:getViewComponent():changeTab(tabID,openBuddyFeed);
end

function ChatPopupMediator:onRegister()
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

  self:getViewComponent():addEventListener(ChatNotifications.CHAT_CLOSE,self.onClose,self);
end

function ChatPopupMediator:onRemove()
	if self:getViewComponent().parent then
    self:getViewComponent().parent:removeChild(self:getViewComponent());
  elseif not self:getViewComponent().isDisposed then
    self:getViewComponent():dispose();
  end
end

function ChatPopupMediator:duelOtherPlayer(evt)
  self:sendNotification(MainSceneNotification.new(MainSceneNotifications.DUEL_OTHER_PLAYER,{UserId = evt.data.UserId, UserName = evt.data.UserName}));
end

function ChatPopupMediator:applyFamily(evt)
  self:sendNotification(FamilyNotification.new(FamilyNotifications.FAMILY_APPLY,{FamilyId = evt.data, FamilyName = "", UserId = 0,UserName = "", BooleanValue = 1}));
end

function ChatPopupMediator:refreshTrumpet()
  if self:getViewComponent().chatLayer and self:getViewComponent().chatLayer.pop_armature then
    self:getViewComponent().chatLayer.pop_armature:refreshTrumpet();
  end
end