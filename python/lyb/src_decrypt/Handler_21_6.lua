--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-17

	yanchuan.xie@happyelements.com
]]

Handler_21_6 = class(Command);

function Handler_21_6:execute()
  print(".21.6..");
  print(".21.6.",recvTable["FlowerHistoryArray"]);
  for k,v in pairs(recvTable["FlowerHistoryArray"]) do
    print("..21.6.",v.UserId,v.UserName,v.TargetUserId,v.TargetUserName,v.Experience,v.Time);
  end

  if BuddyPopupMediator then
    local buddyPopupMediator = self:retrieveMediator(BuddyPopupMediator.name);
    if buddyPopupMediator then
      buddyPopupMediator:refreshFlowerHistoryData(recvTable["FlowerHistoryArray"]);
    end
  end
end

Handler_21_6.new():execute();