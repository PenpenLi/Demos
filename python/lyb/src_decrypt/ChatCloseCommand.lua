ChatCloseCommand=class(MacroCommand);

function ChatCloseCommand:ctor()
  self.class=ChatCloseCommand;
end

function ChatCloseCommand:execute(notification)
  self:removeMediator(ChatPopupMediator.name);
  --self:removeCommand(ChatNotifications.CHAT_ADD_BUDDY,ChatAddBuddyCommand);
  self:removeCommand(ChatNotifications.CHAT_DELETE_BUDDY,ChatDeleteBuddyCommand);
  --self:removeCommand(ChatNotifications.CHAT_SEND,ChatSendCommand);
  self:removeCommand(ChatNotifications.CHAT_MSG_STATE,ChatMsgStateCommand);
  --self:removeCommand(ChatNotifications.CHAT_PRIVATE_TO_PLAYER,ChatPrivateToPlayerCommand);
  self:removeCommand(ChatNotifications.CHAT_BUDDY_ONLINE,ChatBuddyOnlineCommand);
  self:removeCommand(ChatNotifications.BUDDY_DELETED_TO_REFRESH_MAIN_SCENE_ICON,BuddyDeletedRefreshCommand);
  self:removeCommand(ChatNotifications.CHAT_LOOK_INTO,ChatLookIntoCommand);
  self:removeCommand(ChatNotifications.CHAT_BUDDY_FEED_GET_EXP,ChatBuddyFeedGetEXPCommand);
  self:removeCommand(ChatNotifications.CHAT_REQUEST_BUDDY_COMMEND,ChatRequestBuddyCommendCommand);
  self:removeCommand(ChatNotifications.CHAT_PLAYER_REPORT,ChatPlayerReportCommand);
  self:removeCommand(ChatNotifications.CHAT_CLOSE,ChatCloseCommand);
  self:removeCommand(FamilyNotifications.FAMILY_APPLY,FamilyApplyCommand);


end