--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-2-19

	yanchuan.xie@happyelements.com
]]

Handler_7_65 = class(MacroCommand);

function Handler_7_65:execute()
  --print(".7.65.",recvTable["Type"],recvTable["GloableDataArray"]);
  --for k,v in pairs(recvTable["GloableDataArray"]) do
    --print(".7.65..");
    --print(v.ID,v.UserId,v.UserName,v.Level);
  --end
  local challengeMediator=self:retrieveMediator(ChallengeMediator.name);
  if challengeMediator then
    challengeMediator:refreshText4Top(recvTable["Type"],recvTable["GloableDataArray"]);
  end
end

Handler_7_65.new():execute();