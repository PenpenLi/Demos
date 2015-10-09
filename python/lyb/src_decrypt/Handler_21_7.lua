Handler_21_7 = class(Command);

function Handler_21_7:execute()
	uninitializeSmallLoading();
	log("888");
	local buddyPopupMediator = self:retrieveMediator(BuddyPopupMediator.name);
  if buddyPopupMediator then
  	log("999");
  	buddyPopupMediator:getViewComponent():refreshSongtiliBTN();
  end
  sharedTextAnimateReward():animateStartByString("送体力成功啦 ~");
end

Handler_21_7.new():execute();