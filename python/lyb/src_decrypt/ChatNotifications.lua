--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-16

	yanchuan.xie@happyelements.com
]]

ChatNotifications={CHAT_ADD_BUDDY="chatAddBuddy",
                   CHAT_DELETE_BUDDY="chatDeleteBuddy",
                   CHAT_SEND="chatSend",
                   CHAT_MSG_STATE="chatMsgState",
                   CHAT_PRIVATE_TO_PLAYER="chatPrivateToPlayer",
                   CHAT_BUDDY_ONLINE="chatBuddyOnline",
                   CHAT_CLOSE="chatClose",
                   BUDDY_DELETED_TO_REFRESH_MAIN_SCENE_ICON="buddyDeletedToRefreshMainSceneIcon",
                   CHAT_LOOK_INTO="chatLookInto",
                   CHAT_REQUEST_BUDDY_COMMEND="chatRequestBuddyCommend",
                   CHAT_BUDDY_FEED_GET_EXP="chatBuddyFeedGetExp",
                   CHAT_PLAYER_REPORT="chatPlayerReport",
                   BUDDY_CLOSE="buddyClose"};

ChatNotification=class(Notification);

function ChatNotification:ctor(type_string,data)
	self.class = ChatNotification;
	self.type = type_string;
  self.data = data;
end

function ChatNotification:getData()
  return self.data;
end