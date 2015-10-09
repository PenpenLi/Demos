require "main.model.FriendInviteProxy"
require "main.view.friendInvite.FriendInviteMediator"

Handler_34_3 = class(Command)

function Handler_34_3:execute()
	local userID = recvTable["UserId"]	--我领取的礼包对应的受邀请玩家ID
	local friendInviteProxy = self:retrieveProxy(FriendInviteProxy.name);
	friendInviteProxy:updateInviteeInfo(userID, 4);

	local friendInviteMediator = self:retrieveMediator(FriendInviteMediator.name);
	friendInviteMediator:updateInviteeInfo();

	sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_282));
	uninitializeSmallLoading();
end

Handler_34_3.new():execute()