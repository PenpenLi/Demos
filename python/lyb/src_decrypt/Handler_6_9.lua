
require "main.model.GeneralListProxy";

Handler_6_9 = class(Command);

function Handler_6_9:execute()
	uninitializeSmallLoading();
  -- sharedTextAnimateReward():animateStartByString("技能升级成功呢~");

  local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
  local skillLevelUpGeneralIDCache = heroHouseProxy.skillLevelUpGeneralIDCache;
  local skillLevelUpSkillIDCache = heroHouseProxy.skillLevelUpSkillIDCache;
  local skillLevelUpIncreaseCache = heroHouseProxy.skillLevelUpIncreaseCache;
  heroHouseProxy:refreshDataBySkillLevelUp();
  heroHouseProxy.Jinengshengji_Bool = nil;

  self:retrieveMediator(HeroProPopupMediator.name):refreshDataBySkillLevelUp(skillLevelUpGeneralIDCache, skillLevelUpSkillIDCache);
end

function Handler_6_9:bankShiftToSkill()
  local heroBankMediator=self:retrieveMediator(HeroBankMediator.name);
  heroBankMediator:bankShiftToSkill();
end

Handler_6_9.new():execute();