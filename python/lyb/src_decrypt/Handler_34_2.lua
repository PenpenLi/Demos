require "main.model.FriendInviteProxy"
require "main.view.friendInvite.FriendInviteMediator"

Handler_34_2 = class(Command)

function Handler_34_2:execute()
	local inviterGiftInfo = recvTable["BeInvitedArray"]	--我的可发送礼包列表
	local userID = recvTable["UserId"]	--邀请我的人的UserID
	local userName = recvTable["UserName"]	--邀请我的人的UserName
	local level = recvTable["Level"]	--邀请我的人的Level
	local career = recvTable["Career"]	--邀请我的人的Level

	local inviterInfo = {};
	inviterInfo.Name = userName;
	inviterInfo.Level = level;
	inviterInfo.UserID = userID;
	inviterInfo.Career = career;

	local friendInviteProxy = self:retrieveProxy(FriendInviteProxy.name);
	friendInviteProxy:setInviterInfo(inviterInfo);
	friendInviteProxy:setInviterGiftInfo(inviterGiftInfo);
	friendInviteProxy.currentDay = 1;

	local friendInviteMediator = self:retrieveMediator(FriendInviteMediator.name);
	friendInviteMediator:updateInviterInfo();
	friendInviteMediator:updateInviterGiftInfo();

	sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_280));
	uninitializeSmallLoading();
end

Handler_34_2.new():execute()