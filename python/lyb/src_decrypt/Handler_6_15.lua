
require "main.model.GeneralListProxy";

Handler_6_15 = class(Command);

function Handler_6_15:execute()
  -- sharedTextAnimateReward():animateStartByString("天赋升级成功呢~");
  -- local heroBankMediator=self:retrieveMediator(HeroBankMediator.name);
  --         if heroBankMediator then
  --             local heroBankProxy = self:retrieveProxy(HeroBankProxy.name);
  --             heroBankProxy.refreshBankType = HeroConfig.Hero_bank_state_1
  --             if heroBankProxy.lighterName == "2" then
  --                 heroBankMediator:refreshHeroBankData();
  --             end
  --             heroBankMediator:bankShiftToSkill();
  --         end
  local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
  heroHouseProxy:refreshDataBySkillLevelUp();
  heroHouseProxy.Jinengshengji_Bool = nil;

  self:retrieveMediator(HeroProPopupMediator.name):refreshDataBySkillLevelUp();
end

function Handler_6_15:bankShiftToSkill()
  local heroBankMediator=self:retrieveMediator(HeroBankMediator.name);
  heroBankMediator:bankShiftToSkill();
end

Handler_6_15.new():execute();