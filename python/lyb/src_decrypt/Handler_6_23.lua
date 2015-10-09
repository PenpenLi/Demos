Handler_6_23 = class(Command);

function Handler_6_23:execute()
    for k,v in pairs(recvTable["GeneralFateArray"]) do
    	print("..",v.GeneralId);
    	for k_,v_ in pairs(v.FateLevelArray) do
    		print(v_.ID,v_.Level);
    	end
    end
    local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
  	heroHouseProxy:refreshYuanfenShengji(recvTable["GeneralFateArray"]);

  	if HeroProPopupMediator then
	    local heroProPopupMediator=self:retrieveMediator(HeroProPopupMediator.name);
	    if heroProPopupMediator then
	      heroProPopupMediator:getViewComponent():refreshYuanfenShengji(recvTable["GeneralFateArray"]);
	    end
	  end

    heroHouseProxy.Yuanfen_Jinjie_Bool = nil;
    for k,v in pairs(recvTable["GeneralFateArray"]) do
        heroHouseProxy:setHongdianData(v.GeneralId,7);
    end
    if HeroRedDotRefreshCommand then
        HeroRedDotRefreshCommand.new():execute();
    end
end

Handler_6_23.new():execute();