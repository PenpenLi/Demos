Handler_34_5 = class(Command)

function Handler_34_5:execute()
	local userID = recvTable["UserId"]	--我领取的礼包对应的受邀请玩家ID
	local friendInviteProxy = self:retrieveProxy(FriendInviteProxy.name);
	friendInviteProxy:updateInviteeInfo(userID, 2);

	local friendInviteMediator = self:retrieveMediator(FriendInviteMediator.name);
	friendInviteMediator:updateInviteeInfo();
	uninitializeSmallLoading();
end

Handler_34_5.new():execute()