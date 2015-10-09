
require "main.model.GeneralListProxy";

Handler_6_17 = class(Command);

function Handler_6_17:execute()
  local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
  heroHouseProxy.Shengxing_Bool = nil;
  -- local heroBankMediator=self:retrieveMediator(HeroBankMediator.name);
  --         if heroBankMediator then
  --             local heroBankProxy = self:retrieveProxy(HeroBankProxy.name);
  --             heroBankProxy.refreshBankType = HeroConfig.Hero_bank_state_1
  --             if heroBankProxy.lighterName == "2" then
  --                 heroBankMediator:refreshHeroBankData();
  --             end
  --             heroBankMediator:bankShiftToSkill();
  --         end
  -- local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
  -- heroHouseProxy:refreshDataBySkillLevelUp();
  -- sharedTextAnimateReward():animateStartByString("升星成功~");
  -- self:retrieveMediator(HeroProPopupMediator.name):getViewComponent():setData();
  self:retrieveMediator(HeroProPopupMediator.name):getViewComponent():refreshEffect4Shengxing();
  -- self:retrieveMediator(HeroProPopupMediator.name):getViewComponent():refreshDataByShengxing();
end

Handler_6_17.new():execute();