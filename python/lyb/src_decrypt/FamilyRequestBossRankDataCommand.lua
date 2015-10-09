--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

FamilyRequestBossRankDataCommand=class(Command);

function FamilyRequestBossRankDataCommand:ctor()
	self.class=FamilyRequestBossRankDataCommand;
end

function FamilyRequestBossRankDataCommand:execute(notification)
  local data=notification:getData();
  if(connectBoo) then
  	sendMessage(27,47,data);
  end
end