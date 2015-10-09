Handler_24_34 = class(Command);

function Handler_24_34:execute()
  --过七天的24时，主动隐藏七天按钮
  local firstSevenProxy = self:retrieveProxy(FirstSevenProxy.name)
  firstSevenProxy:setData(nil);
  
  if FirstSevenMediator then
  	self:removeMediator(FirstSevenMediator.name);
  end
  sharedTextAnimateReward():animateStartByString("七天已过，无法再领取七天礼包");
  local mainSceneMediator = self:retrieveMediator(MainSceneMediator.name)
  mainSceneMediator:setFirstSevenButtonVisible(false)
end

Handler_24_34.new():execute();