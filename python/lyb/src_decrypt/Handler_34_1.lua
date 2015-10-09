Handler_34_1 = class(Command)

function Handler_34_1:execute()
	local key = recvTable["Key"]
	local inviteArray = recvTable["InviteArray"] --我邀请的人列表
	local inviterGiftInfo = recvTable["BeInvitedArray"]	--我的可发送礼包列表
	local userID = recvTable["UserId"]	--邀请我的人的UserID
	local userName = recvTable["UserName"]	--邀请我的人的UserName
	local level = recvTable["Level"]	--邀请我的人的Level
	local career = recvTable["Career"]	--邀请我的人的Level
	local currentDay = recvTable["Count"]	--我的受邀天数

	local inviterInfo = {};
	inviterInfo.Name = userName;
	inviterInfo.Level = level;
	inviterInfo.UserID = userID;
	inviterInfo.Career = career;

	local friendInviteProxy = self:retrieveProxy(FriendInviteProxy.name);
	friendInviteProxy:setKey(key);
	friendInviteProxy:setInviteeInfo(inviteArray);
	friendInviteProxy:setInviterInfo(inviterInfo);
	friendInviteProxy:setInviterGiftInfo(inviterGiftInfo);
	friendInviteProxy.currentDay = currentDay;

	local friendInviteMediator = self:retrieveMediator(FriendInviteMediator.name);
	sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(friendInviteMediator:getViewComponent());
	friendInviteMediator:update();

	uninitializeSmallLoading();
end

Handler_34_1.new():execute()