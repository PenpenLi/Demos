
Handler_7_58 = class(MacroCommand)

function Handler_7_58:execute()
   local data =recvTable["RoundItemIdArray"];
   local StrongPointId=recvTable["StrongPointId"];
   for k, v in pairs(data) do
   		for k1, v1 in pairs(v["ItemIdArray"]) do
   			print("v1, ItemId, Count", v1["ItemId"], v1["Count"])
   		end
   end
   local bool;
   if QuickBattleMediator then
      
	   local quickBattleMed = self:retrieveMediator(QuickBattleMediator.name);
	   if quickBattleMed then
		   quickBattleMed:refreshData(data, StrongPointId);
         bool = true
	   end
   end
   if StrongPointInfoMediator and not bool then
	   local strongPointInfoMediator = self:retrieveMediator(StrongPointInfoMediator.name);
	   if strongPointInfoMediator then
	   		strongPointInfoMediator:refreshData(data, StrongPointId);
	   end
   end
   if ShadowHeroImageMediator and not bool then
      local shadowHeroImageMediator = self:retrieveMediator(ShadowHeroImageMediator.name);
      if shadowHeroImageMediator then
            shadowHeroImageMediator:refreshData(data, StrongPointId);
      end
   end
end

Handler_7_58.new():execute();