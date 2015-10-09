require "main.controller.notification.FriendInviteNotification"
require "main.controller.command.friendInvite.FriendInviteSendKeyCommand"
require "main.controller.command.friendInvite.FriendInviteSendGiftCommand"
require "main.controller.command.friendInvite.FriendInviteGetGiftCommand"
require "main.controller.command.friendInvite.FriendInviteCloseCommand"
require "main.model.FriendInviteProxy"
require "main.view.friendInvite.FriendInviteMediator"

ToFriendInviteCommand=class(Command);

function ToFriendInviteCommand:ctor()
	self.class=ToFriendInviteCommand;
end

function ToFriendInviteCommand:execute()
	self:registerCommand(FriendInviteNotifications.ON_CLOSE, FriendInviteCloseCommand);
	self:registerCommand(FriendInviteNotifications.ON_SEND_GIFT, FriendInviteSendGiftCommand);
	self:registerCommand(FriendInviteNotifications.ON_SEND_KEY, FriendInviteSendKeyCommand);
	self:registerCommand(FriendInviteNotifications.ON_GET_GIFT, FriendInviteGetGiftCommand);

	local generalListProxy = self:retrieveProxy(GeneralListProxy.name);	

	local friendInviteProxy = self:retrieveProxy(FriendInviteProxy.name);
	if not friendInviteProxy then
		friendInviteProxy = FriendInviteProxy.new();
		self:registerProxy(FriendInviteProxy.name, friendInviteProxy);
	end
	local friendInviteMediator = self:retrieveMediator(FriendInviteMediator.name);
	if not friendInviteMediator then
		friendInviteMediator = FriendInviteMediator.new();
		self:registerMediator(FriendInviteMediator.name, friendInviteMediator);
	end
	friendInviteMediator:initialize(friendInviteProxy, generalListProxy);

	-- sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(friendInviteMediator:getViewComponent());
  self:observe(FriendInviteCloseCommand);
  initializeSmallLoading();
  sendMessage(34, 1);
end