--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-2-19

	yanchuan.xie@happyelements.com
]]

Handler_24_35 = class(Command);

function Handler_24_35:execute()
  uninitializeSmallLoading();
  local firstSevenProxy=self:retrieveProxy(FirstSevenProxy.name);
  firstSevenProxy:setFetched();

  local firstSevenMediator=self:retrieveMediator(FirstSevenMediator.name);
  if firstSevenMediator then
    firstSevenMediator:refresh();
  end

  local mainSceneMediator=self:retrieveMediator(MainSceneMediator.name);
  if mainSceneMediator then
    mainSceneMediator:refreshIcon();
    mainSceneMediator:setIconEffectFirstSeven(firstSevenProxy:hasFetchable())
  end
end

Handler_24_35.new():execute();