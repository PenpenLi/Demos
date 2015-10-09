require "main.view.chat.ChatPopupMediator";

MainSceneToChatCommand=class(Command);

function MainSceneToChatCommand:ctor()
	self.class=MainSceneToChatCommand;
end

function MainSceneToChatCommand:execute(notification)  
  self:require();
  --ChatPopupMediator
  self.chatPopupMediator=self:retrieveMediator(ChatPopupMediator.name);
  if self.chatPopupMediator then
    return;
  end
  if nil==self.chatPopupMediator then
    self.chatPopupMediator=ChatPopupMediator.new();
    self:registerMediator(self.chatPopupMediator:getMediatorName(),self.chatPopupMediator);
    
    self:registerChatCommands();
  end
  LayerManager:addLayerPopable(self.chatPopupMediator:getViewComponent());
  
  --setButtonGroupVisible(false);
end

function MainSceneToChatCommand:registerChatCommands()
  self:registerCommand(ChatNotifications.CHAT_ADD_BUDDY,ChatAddBuddyCommand);
  self:registerCommand(ChatNotifications.CHAT_DELETE_BUDDY,ChatDeleteBuddyCommand);
  self:registerCommand(ChatNotifications.CHAT_SEND,ChatSendCommand);
  self:registerCommand(ChatNotifications.CHAT_MSG_STATE,ChatMsgStateCommand);
  self:registerCommand(ChatNotifications.CHAT_PRIVATE_TO_PLAYER,ChatPrivateToPlayerCommand);
  self:registerCommand(ChatNotifications.CHAT_BUDDY_ONLINE,ChatBuddyOnlineCommand);
  self:registerCommand(ChatNotifications.BUDDY_DELETED_TO_REFRESH_MAIN_SCENE_ICON,BuddyDeletedRefreshCommand);
  self:registerCommand(ChatNotifications.CHAT_LOOK_INTO,ChatLookIntoCommand);
  self:registerCommand(ChatNotifications.CHAT_BUDDY_FEED_GET_EXP,ChatBuddyFeedGetEXPCommand);
  self:registerCommand(ChatNotifications.CHAT_REQUEST_BUDDY_COMMEND,ChatRequestBuddyCommendCommand);
  self:registerCommand(ChatNotifications.CHAT_PLAYER_REPORT,ChatPlayerReportCommand);
  self:registerCommand(ChatNotifications.CHAT_CLOSE,ChatCloseCommand);
  self:registerCommand(FamilyNotifications.FAMILY_APPLY,FamilyApplyCommand);
end

function MainSceneToChatCommand:require()
  require "main.controller.notification.ChatNotification";
  require "main.controller.command.chat.ChatAddBuddyCommand";
  require "main.controller.command.chat.ChatDeleteBuddyCommand";
  require "main.controller.command.chat.ChatSendCommand";
  require "main.controller.command.chat.ChatMsgStateCommand";
  require "main.controller.command.chat.ChatPrivateToPlayerCommand";
  require "main.controller.command.chat.ChatBuddyOnlineCommand";
  require "main.controller.command.chat.BuddyDeletedRefreshCommand";
  require "main.controller.command.chat.ChatLookIntoCommand";
  require "main.controller.command.chat.ChatBuddyFeedGetEXPCommand";
  require "main.controller.command.chat.ChatRequestBuddyCommendCommand";
  require "main.controller.command.chat.ChatPlayerReportCommand";
  require "main.controller.command.chat.ChatCloseCommand";
  require "main.controller.command.family.FamilyApplyCommand";
end