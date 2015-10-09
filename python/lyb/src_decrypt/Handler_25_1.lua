--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-2-19

	yanchuan.xie@happyelements.com
]]

Handler_25_1 = class(Command);

function Handler_25_1:execute()
   print(".25.1.");
   for k,v in pairs(recvTable["RankArray"]) do
   	  print(".25.1..",v.ID,v.Ranking,v.ParamStr1,v.ParamStr2,v.ParamStr3,v.ParamStr4);
   end
   print(".25.1.",recvTable["Type"],#recvTable["RankArray"]);

   local function sort(data_a, data_b)
    if data_a.Zhanli and data_b.Zhanli then
      return data_a.Zhanli > data_b.Zhanli;
    end
    if data_a.Level < data_b.Level then
      return false;
    elseif data_a.Level > data_b.Level then
      return true;
    elseif data_a.StarLevel < data_b.StarLevel then
      return false;
    elseif data_a.StarLevel > data_b.StarLevel then
      return true;
    end
    return data_a.Grade > data_b.Grade;
   end
   for k,v in pairs(recvTable["RankArray"]) do
    table.sort(v.RankGeneralArray,sort);
   end

   local rankListProxy=self:retrieveProxy(RankListProxy.name);
   rankListProxy:refresh(recvTable["Type"],recvTable["RankArray"]);

   --RankListMediator
   if recvTable["Type"] == GameConfig.Ranking_Type_6 then
      local arenaProxy = self:retrieveProxy(ArenaProxy.name)
      arenaProxy.rankArray = recvTable["RankArray"];
      local arenaMediator=self:retrieveMediator(ArenaMediator.name);
      if arenaMediator then
          arenaMediator:refreshRankingData();
      end
   else
      require "main.view.rankList.RankListMediator";
      local rankListMediator=self:retrieveMediator(RankListMediator.name);
      if nil~=rankListMediator then
        rankListMediator:refresh(recvTable["Type"],recvTable["RankArray"]);
      end
   end


  -- local arenaMediator=self:retrieveMediator(ArenaMediator.name);
  -- if nil~=arenaMediator then
  --   arenaMediator:refreshRankingData();
  -- end
end

Handler_25_1.new():execute();