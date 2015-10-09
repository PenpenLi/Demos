--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

RankListRequestDataCommand=class(Command);

function RankListRequestDataCommand:ctor()
	self.class=RankListRequestDataCommand;
end

function RankListRequestDataCommand:execute(notification)
  local data=notification:getData();
	print("RankListRequestDataCommand",data.Type);
  if(connectBoo) then
    sendMessage(25,1,data);
  end
end