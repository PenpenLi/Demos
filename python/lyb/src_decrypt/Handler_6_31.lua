

Handler_6_31 = class(Command);

function Handler_6_31:execute()
	local heroBankMediator=self:retrieveMediator(HeroBankMediator.name);
	if nil~=heroBankMediator then
		  local heroBankProxy = self:retrieveProxy(HeroBankProxy.name);
		  heroBankProxy.booleanValue = recvTable["BooleanValue"];
		  sharedTextAnimateReward():animateStartByString("吞噬成功！");
		  heroBankProxy.isNeedRefreshSkill = true;
		  heroBankProxy.isNeedRefreshLevelUp = true;
		  heroBankProxy.isNeedRefreshDebris = true;

		  heroBankMediator:refreshTheWorkBoolData();
		  heroBankMediator:refreshBankDetailNoData();
		  if heroBankProxy.lighterName == "1" then
		      heroBankMediator:refreshSkillData();
		  elseif heroBankProxy.lighterName == "4" then
		      heroBankMediator:refreshLevelUpData();
		  end
	end
end


Handler_6_31.new():execute();