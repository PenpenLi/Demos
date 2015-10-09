
require "main.model.GeneralListProxy";

Handler_3_6 = class(Command);

function Handler_3_6:execute()
      local shopMediator=self:retrieveMediator(ShopMediator.name);
	  if heroBankMediator then
		  local heroBankProxy = self:retrieveProxy(HeroBankProxy.name);
		  heroBankProxy.refreshBankType = HeroConfig.Hero_bank_state_1
		  if heroBankProxy.lighterName == "2" then
              heroBankMediator:refreshHeroBankData();
		  end
		  heroBankMediator:bankShiftToSkill();
	  end
end

function Handler_3_6:bankShiftToSkill()
  local heroBankMediator=self:retrieveMediator(HeroBankMediator.name);
  heroBankMediator:bankShiftToSkill();
end

Handler_3_6.new():execute();