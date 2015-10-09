
require "main.model.UserProxy";
require "core.display.Director";


Handler_4_3 = class(Command);

function Handler_4_3:execute()  

	-- if QuickBattleMediator then
	-- 	local quickBattleMediator=self:retrieveMediator(QuickBattleMediator.name);
	-- 	if quickBattleMediator then
	-- 		quickBattleMediator:refreshCount(Count)
	-- 	end
	-- end

    local Count = recvTable["Count"];
    local StrongPointId = recvTable["StrongPointId"];
     
	local storyLineProxy = self:retrieveProxy(StoryLineProxy.name);
    local key = "key_" .. StrongPointId;
    local strongPointData = storyLineProxy.strongPointArray[key]
    if not strongPointData then
    	strongPointData = {StrongPointId = StrongPointId, Count = Count}
    	storyLineProxy.strongPointArray[key] = strongPointData;
    end
    strongPointData.Count = Count;

	if StrongPointInfoMediator then
		local strongPointInfoMediator=self:retrieveMediator(StrongPointInfoMediator.name);
		if strongPointInfoMediator then

			strongPointInfoMediator:refreshCount(Count, 0)
		end
	end
	if ShadowHeroImageMediator then    
		local shadowHeroImageMediator=self:retrieveMediator(ShadowHeroImageMediator.name);
		print("StrongPointId, Count", StrongPointId, Count)
		if shadowHeroImageMediator then
			shadowHeroImageMediator:refreshCount(Count, 0)
		end
	end
end

Handler_4_3.new():execute();