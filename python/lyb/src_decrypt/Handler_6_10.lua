Handler_6_10 = class(Command);

function Handler_6_10:execute()
	-- sharedTextAnimateReward():animateStartByString("英雄进阶成功~");
  local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
  heroHouseProxy.Jinjie_Bool = nil;
  heroHouseProxy:refreshDataByJinjie();

  self:retrieveMediator(HeroProPopupMediator.name):refreshDataByJinjie();
end

Handler_6_10.new():execute();