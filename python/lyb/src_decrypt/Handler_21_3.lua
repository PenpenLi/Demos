--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-17

	yanchuan.xie@happyelements.com
]]

Handler_21_3 = class(Command);

function Handler_21_3:execute()
  uninitializeSmallLoading();
  
  print(".21.3..");
  print(".21.3.",recvTable["UserId"]);

  local buddyListProxy=self:retrieveProxy(BuddyListProxy.name);
  buddyListProxy:deleteBuddy(nil,recvTable["UserId"]);
  buddyListProxy:deleteHaoyouID(recvTable["UserId"]);

  local buddyPopupMediator=self:retrieveMediator(BuddyPopupMediator.name);
  if nil~=buddyPopupMediator then
    buddyPopupMediator:getViewComponent():deleteBuddy(recvTable["UserId"]);
  end
end

Handler_21_3.new():execute();