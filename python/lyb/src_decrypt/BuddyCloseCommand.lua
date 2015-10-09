BuddyCloseCommand=class(MacroCommand);

function BuddyCloseCommand:ctor()
  self.class=BuddyCloseCommand;
end

function BuddyCloseCommand:execute(notification)
  self:removeMediator(BuddyPopupMediator.name);
  self:removeCommand(ChatNotifications.CHAT_ADD_BUDDY,ChatAddBuddyCommand);
  self:removeCommand(ChatNotifications.CHAT_DELETE_BUDDY,ChatDeleteBuddyCommand);
  self:removeCommand(ChatNotifications.CHAT_BUDDY_ONLINE,ChatBuddyOnlineCommand);
  self:removeCommand(ChatNotifications.CHAT_LOOK_INTO,ChatLookIntoCommand);
  self:removeCommand(ChatNotifications.CHAT_PLAYER_REPORT,ChatPlayerReportCommand);
  self:removeCommand(ChatNotifications.BUDDY_CLOSE,BuddyCloseCommand);
end