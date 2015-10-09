Handler_6_11 = class(Command);

function Handler_6_11:execute()
  local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
  -- uninitializeSmallLoading(heroHouseProxy.smallLoadingKey);
  -- heroHouseProxy.smallLoadingKey = nil;
  heroHouseProxy.Shengji_Bool = nil;

  local generalID;
  local level;
  local level_up;
  local heroProPopupMediator = self:retrieveMediator(HeroProPopupMediator.name);
  if heroProPopupMediator then
  	generalID = heroProPopupMediator:getViewComponent().selectedData.GeneralId;
  	level = heroProPopupMediator:getViewComponent().selectedData.Level;
  end
  heroHouseProxy:refreshDataByShengji();

  if heroProPopupMediator then
  	level_up = heroHouseProxy:getGeneralData(generalID).Level;
  	heroProPopupMediator:getViewComponent():refreshDataByShengji();--level==level_up);
  end
end

Handler_6_11.new():execute();