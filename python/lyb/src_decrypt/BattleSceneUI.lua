require "main.view.battleScene.BattleLayerManager"
BattleSceneUI = class(Scene);
function BattleSceneUI:ctor()
	require "main.common.transform.CompositeActionAllPart"
	require "main.config.BattleConfig"
	require "core.display.Scene";
	require "main.view.battleScene.function.TextAnimateUpAndUp"
	require "main.view.battleScene.function.TextAnimationPopAndUp"
	require "main.view.battleScene.function.TextAnimationSkill"
	require "main.view.battleScene.function.TextAnimationSkillG"
	require "main.view.battleScene.ui.FightUI"
	self.class = BattleSceneUI;
	self.name = GameConfig.BATTLE_SCENE;
	self.battleProxy = nil;
	self.effectNumber = 0
end
function BattleSceneUI:dispose()
	self.fightUI = nil;
	self:removeAllEventListeners();
	BattleSceneUI.superclass.dispose(self);
	self:disposeScene();
end
function BattleSceneUI:onInit()

end

function BattleSceneUI:intializeUI(skeleton,battleProxy,userProxy,generalProxy,openFunProxy,operatonProxy,storyLineProxy)
	self.battleProxy = battleProxy;
  	self.skeleton = skeleton;
  	self.userProxy=userProxy;
  	self.generalProxy= generalProxy;
  	self.openFunProxy = openFunProxy;
  	self.operatonProxy = operatonProxy;
  	self.storyLineProxy = storyLineProxy;
    sharedBattleLayerManager():disposeBattleLayerManager()
    sharedBattleLayerManager():addLayers(self);
end

function BattleSceneUI:getBattleProxy()
	return self.battleProxy;
end

function BattleSceneUI:getBankPO(skillId)
	if not skillId then return;end
	return self.bankArray[skillId];
end

function BattleSceneUI:initFightUI()
    self.fightUI = FightUI.new();
    self.fightUI.name = "fightUI"
    self.fightUI:onInit(self.skeleton,self.battleProxy,self.userProxy,self.openFunProxy,self.operatonProxy,self.storyLineProxy)
    sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_UI):addChild(self.fightUI);
end

function BattleSceneUI:hanZiPop(attackResult,battleUnitID)
	local aiEngin = self.battleProxy.aiEnginMap[battleUnitID];
	if not aiEngin then return end
	local roleVO = self.battleProxy.battleGeneralArray[battleUnitID];
    aiEngin:hanZiPop(roleVO,attackResult);
end

function BattleSceneUI:attackAction(attackResultArray,battleUnitID)
	local aiEngin = self.battleProxy.aiEnginMap[battleUnitID];
	if not aiEngin then return end
    aiEngin:attackAction(attackResultArray);
end

function BattleSceneUI:playSkillSuccess(battleUnitID,attackSkillId,faceDirect)
	self.fightUI:playSkillSuccess(battleUnitID,attackSkillId,faceDirect)
end

function BattleSceneUI:autoSuccess(bool)
	self.fightUI:autoSuccess(bool)
end

function BattleSceneUI:waitingBackgroundVisible(bool,battleUnitID)
	self.fightUI:waitingBackgroundVisible(bool,battleUnitID)
end

function BattleSceneUI:refreshAutoSkill(attackSkillId)
	self.fightUI:refreshAutoSkill(attackSkillId)
end

-- function BattleSceneUI:refreshDropPower(dropItemPO,position,faceDirect)
-- 	self.fightUI:refreshDropPower(dropItemPO,position,faceDirect)
-- end

function BattleSceneUI:stopAllNodeAction()
  self.fightUI:stopAllNodeAction()
end

function BattleSceneUI:refreshRoleListener(newRoleArray)
	self.fightUI:refreshRoleListener(newRoleArray)
end

function BattleSceneUI:refreshGoBotton()
	self.fightUI:refreshGoBotton()
end

function BattleSceneUI:refreshSkillCDTime(battleUnitID)
    self.fightUI:refreshSkillCDTime(battleUnitID)
end

function BattleSceneUI:testShowBossEffect()
	self.fightUI:testShowBossEffect()
end

function BattleSceneUI:refreshFriend(handlerData)
  self:getViewComponent():refreshFriend(handlerData)
end

-- function BattleSceneUI:refreshLianji()
-- 	self.fightUI:refreshLianji()
-- end

function BattleSceneUI:refreshYuanFen(battleUnitID1,battleUnitID2)
    self.fightUI:refreshYuanFen(battleUnitID1,battleUnitID2);
end

function BattleSceneUI:setBattleUIData()
	-- 设定剩余怪物数
	-- self.fightUI:refreshLeftMonsterCount()
end

function BattleSceneUI:cleanSceneAllChildren()
	  local childNumber = self:getNumOfChildren()
	  while(childNumber > 0) do
	    self:removeChildAt(0);
	    childNumber = childNumber - 1;
	  end
end

function BattleSceneUI:refreshBossInjureRank()
	if self.battleProxy.battleType ~= BattleConfig.BATTLE_TYPE_24 then
		if self.fightUI then
			self.fightUI:refreshBossInjureRank();
		end
	end
end

function BattleSceneUI:cardRotationAnimation(skillId)
	self.fightUI:cardRotationAnimation(skillId)
end

function BattleSceneUI:addPauseTime(addTime)
	self.fightUI:addPauseTime(addTime)
end