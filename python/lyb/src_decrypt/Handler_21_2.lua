--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-17

	yanchuan.xie@happyelements.com
]]

Handler_21_2 = class(Command);

function Handler_21_2:execute()
  uninitializeSmallLoading();
  
  print(".21.2..");
  print(".21.2.",recvTable["UserRelationArray"]);

  local buddyListProxy=self:retrieveProxy(BuddyListProxy.name);
  buddyListProxy:addBuddys(recvTable["UserRelationArray"]);
  buddyListProxy:refreshHaoyouIDsByUserRelationArray(recvTable["UserRelationArray"]);

  local buddyPopupMediator=self:retrieveMediator(BuddyPopupMediator.name);
  if nil~=buddyPopupMediator then
    buddyPopupMediator:getViewComponent():refreshAddBuddys(recvTable["UserRelationArray"]);
  end

  sharedTextAnimateReward():animateStartByString("成功添加对方为好友啦 ~");
end

Handler_21_2.new():execute();