require "main.view.battleScene.ui.BattleSceneUI";

BattleSceneMediator = class(Mediator);

function BattleSceneMediator:ctor()
  self.class = BattleSceneMediator;
end

rawset(BattleSceneMediator,"name","BattleSceneMediator");

function BattleSceneMediator:onRegister()
  self.viewComponent = BattleSceneUI.new();
	self:getViewComponent():initScene();
  
  self.viewComponent:addEventListener("Attack_Type_3_4",self.attackTypeDeley,self);
  self.viewComponent:addEventListener("UnitID_Dead",self.unitIDDead,self);
  self.viewComponent:addEventListener("UnitID_Hurt",self.unitIDHurt,self);
end

function BattleSceneMediator:attackTypeDeley(event)
  self:sendNotification(BattleSceneNotification.new(BattleSceneNotifications.Battle_BeAttack, event.data));
end

function BattleSceneMediator:intializeUI(skeleton,battleProxy,userProxy,generalProxy,openFunProxy,operatonProxy,storyLineProxy)
	self.viewComponent:intializeUI(skeleton,battleProxy,userProxy,generalProxy,openFunProxy,operatonProxy,storyLineProxy)
end

function BattleSceneMediator:attackAction(battleUnitID)
    self:getViewComponent():attackAction(battleUnitID);
end

function BattleSceneMediator:refreshSkillCDTime(battleUnitID)
    self:getViewComponent():refreshSkillCDTime(battleUnitID);
end

function BattleSceneMediator:waitingBackgroundVisible(bool,battleUnitID)
  self:getViewComponent():waitingBackgroundVisible(bool,battleUnitID)
end

function BattleSceneMediator:unitIDDead(event)
    self:sendNotification(BattleSceneNotification.new(BattleSceneNotifications.Battle_UnitID_Dead, event.data));
end

function BattleSceneMediator:playSkillSuccess(battleUnitID,attackSkillId,faceDirect)
    self:getViewComponent():playSkillSuccess(battleUnitID,attackSkillId,faceDirect);
end

function BattleSceneMediator:skillSuccess(skillId,bool)
    self:getViewComponent():skillSuccess(skillId,bool);
end

function BattleSceneMediator:autoSuccess(bool)
    self:getViewComponent():autoSuccess(bool);
end

function BattleSceneMediator:playBeginAttackEffect(battleUnitID,attackSkillId)
  self:getViewComponent().fightUI:playBeginAttackEffect(battleUnitID,attackSkillId)
end

function BattleSceneMediator:refreshDropDaoju(dropDaojuArray,position)
  self:getViewComponent().fightUI:refreshDropDaoju(dropDaojuArray,position)
end

function BattleSceneMediator:onActionUI()
  if not self:getViewComponent().fightUI then return end
  self:getViewComponent().fightUI:onActionUI()
end

function BattleSceneMediator:refreshGoBotton()
    self:getViewComponent():refreshGoBotton();
end
function BattleSceneMediator:testShowBossEffect()
    self:getViewComponent():testShowBossEffect();
end
function BattleSceneMediator:refreshYuanFen(battleUnitID1,battleUnitID2)
    self:getViewComponent():refreshYuanFen(battleUnitID1,battleUnitID2);
end

function BattleSceneMediator:refreshRoleListener(newRoleArray)
    self:getViewComponent():refreshRoleListener(newRoleArray)
end

function BattleSceneMediator:unitIDHurt(event)
    self:sendNotification(BattleSceneNotification.new(BattleSceneNotifications.Battle_UnitID_Hurt, event.data));
end

function BattleSceneMediator:addPauseTime(addTime)
    self:getViewComponent():addPauseTime(addTime)
end

function BattleSceneMediator:onRemove()
	self:getViewComponent():dispose();
  self.viewComponent = nil
end

function BattleSceneMediator:stopAllNodeAction()
  self:getViewComponent():stopAllNodeAction()
end

function BattleSceneMediator:hanZiPop(attackResult,battleUnitID)
	self:getViewComponent():hanZiPop(attackResult,battleUnitID);
end

function BattleSceneMediator:removeFightUI()
	-- self:getViewComponent().fightUI:disposeUI();
end
function BattleSceneMediator:setRangeData(battleUnitID,currentRage)
   self:getViewComponent().fightUI:setRangeData(battleUnitID,currentRage)
end

function BattleSceneMediator:refreshDeadHeadImgGray(battleUnitID)
   self:getViewComponent().fightUI:refreshDeadHeadImgGray(battleUnitID)
end

function BattleSceneMediator:fightUIActivite()
   self:getViewComponent().fightUI:fightUIActivite()
end

function BattleSceneMediator:refreshHpData(roleVO)
  if not self:getViewComponent().fightUI then return;end
   self:getViewComponent().fightUI:refreshHpData(roleVO)
end

function BattleSceneMediator:refreshRangeData(roleVO)
  if not self:getViewComponent().fightUI then return;end
   self:getViewComponent().fightUI:refreshRangeData(roleVO)
end

function BattleSceneMediator:setTiaoGuoVisible(bool)
  if not self:getViewComponent().fightUI then return;end
   self:getViewComponent().fightUI:setTiaoGuoVisible(bool)
   self:sendNotification(TaskNotification.new(TaskNotifications.MODAL_DIALOG_CLOSE_COMMOND));
end

function BattleSceneMediator:refreshSkillCard(isScript)
  if not self:getViewComponent().fightUI then return;end
   self:getViewComponent().fightUI:initSkillCard(isScript)
end

function BattleSceneMediator:stopTimer()
   if not self:getViewComponent().fightUI then return;end
   self:getViewComponent().fightUI:stopTimer()
end

function BattleSceneMediator:setBattleUIData()
	self:getViewComponent():setBattleUIData()
end

function BattleSceneMediator:setTimerNumber()
  if not self:getViewComponent().fightUI then return;end
  self:getViewComponent().fightUI:setTimerNumber()
end

function BattleSceneMediator:refreshTimer()
	self:getViewComponent().fightUI:refreshTimer()
end

function BattleSceneMediator:refreshFriend(handlerData)
  self:getViewComponent().fightUI:refreshFriend(handlerData)
end

function BattleSceneMediator:setWaitingDisVisible()
	self:getViewComponent().fightUI:setWaitingVisible(false)
end

-- refreshMoster count
function BattleSceneMediator:refreshMonsterCount(battleType,monsterCount)
    self:getViewComponent().fightUI:refreshLeftMonsterCount(battleType,monsterCount)
end

function BattleSceneMediator:initFightUI()
    self:getViewComponent():initFightUI()
    self:getViewComponent().fightUI:addEventListener("CLOSE_BATTLE_OVER",self.onRemoveUI,self);
    self:getViewComponent().fightUI:addEventListener("Middle_Dialog_Event",self.onMidddleDialog,self);
end

function BattleSceneMediator:onRemoveUI(event)
  self:sendNotification(BattleSceneNotification.new(BattleSceneNotifications.BATTLE_EXIT));
  self:sendNotification(BattleSceneNotification.new(BattleSceneNotifications.CLOSE_BATTLEOVER_MEDIATOR));
  self:sendNotification(BattleSceneNotification.new(BattleSceneNotifications.TO_MAINSCENE, event.data));
end

function BattleSceneMediator:onMidddleDialog()
    self:sendNotification(BattleSceneNotification.new(BattleSceneNotifications.BATTLE_MIDDLE_DIALOG));
end

function BattleSceneMediator:onTutorBattle(event)

end

function BattleSceneMediator:refreshBossInjureRank()
  self:getViewComponent():refreshBossInjureRank();
end

function BattleSceneMediator:movieClipAnimation(backfunction)
  self:getViewComponent().fightUI:movieClipAnimation(backfunction)
end
