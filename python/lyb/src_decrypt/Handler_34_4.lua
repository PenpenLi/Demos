Handler_34_4 = class(Command)

function Handler_34_4:execute()
	local day = recvTable["Count"]
	local friendInviteProxy = self:retrieveProxy(FriendInviteProxy.name);
	local inviterGiftInfo = friendInviteProxy:getInviterGiftInfo(day);
	if inviterGiftInfo then
		inviterGiftInfo.isGiven = true;
	end
	local friendInviteMediator = self:retrieveMediator(FriendInviteMediator.name);
	-- print("34_4",day,type(day));
	friendInviteMediator:updateInviterGiftInfo(day);
	sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_286));
	uninitializeSmallLoading();
end

Handler_34_4.new():execute()