require "main.view.buddy.BuddyPopupMediator";

MainSceneToBuddyCommand=class(Command);

function MainSceneToBuddyCommand:ctor()
	self.class=MainSceneToBuddyCommand;
end

function MainSceneToBuddyCommand:execute(notification)  
  self:require();
  --BuddyPopupMediator
  self.buddyPopupMediator=self:retrieveMediator(BuddyPopupMediator.name);
  if nil==self.buddyPopupMediator then
    self.buddyPopupMediator=BuddyPopupMediator.new();
    self:registerMediator(self.buddyPopupMediator:getMediatorName(),self.buddyPopupMediator);
    
    self:registerCommands();
  end
  LayerManager:addLayerPopable(self.buddyPopupMediator:getViewComponent());
end

function MainSceneToBuddyCommand:registerCommands()
  self:registerCommand(ChatNotifications.CHAT_ADD_BUDDY,ChatAddBuddyCommand);
  self:registerCommand(ChatNotifications.CHAT_DELETE_BUDDY,ChatDeleteBuddyCommand);
  self:registerCommand(ChatNotifications.CHAT_BUDDY_ONLINE,ChatBuddyOnlineCommand);
  self:registerCommand(ChatNotifications.CHAT_LOOK_INTO,ChatLookIntoCommand);
  self:registerCommand(ChatNotifications.CHAT_PLAYER_REPORT,ChatPlayerReportCommand);
  self:registerCommand(ChatNotifications.BUDDY_CLOSE,BuddyCloseCommand);
end

function MainSceneToBuddyCommand:require()
  require "main.controller.notification.ChatNotification";
  require "main.controller.command.chat.ChatAddBuddyCommand";
  require "main.controller.command.chat.ChatDeleteBuddyCommand";
  require "main.controller.command.chat.ChatBuddyOnlineCommand";
  require "main.controller.command.chat.ChatLookIntoCommand";
  require "main.controller.command.chat.ChatPlayerReportCommand";
  require "main.controller.command.chat.BuddyCloseCommand";
end