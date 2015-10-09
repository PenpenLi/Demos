--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-17

	yanchuan.xie@happyelements.com
]]

Handler_21_1 = class(Command);

function Handler_21_1:execute()
  print(".21.1..");
  for k,v in pairs(recvTable["UserRelationArray"]) do
    print("");
    for k_,v_ in pairs(v) do
      print(".21.1.",k_,v_);
    end
  end

  uninitializeSmallLoading();
  
  local buddyListProxy=self:retrieveProxy(BuddyListProxy.name);
  buddyListProxy:refresh(recvTable["UserRelationArray"],recvTable["Flower"]);
  buddyListProxy:refreshHaoyouIDsByUserRelationArray(recvTable["UserRelationArray"]);

  if BuddyPopupMediator then
    self.buddyPopupMediator=self:retrieveMediator(BuddyPopupMediator.name);
    if nil~=self.buddyPopupMediator then
      self.buddyPopupMediator:refreshBuddyData();
      -- self.buddyPopupMediator:order4Record();
    end
  end
end

Handler_21_1.new():execute();