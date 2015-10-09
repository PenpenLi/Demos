require "main.controller.command.scriptCartoon.GameScript"
BattleScript = class(GameScript);

function BattleScript:ctor()
	require "main.controller.command.tutor.TutorCloseCommand";
	self.class = BattleScript;
end

function BattleScript:cleanSelf()
	self.class = nil
end

function BattleScript:dispose()
	self:removeStopBattleTimer()
    self:cleanSelf();
end

function BattleScript:initScript(battleField)
	self.battleProxy = Facade.getInstance():retrieveProxy(BattleProxy.name);
	self.battleField = battleField;
	self.gameScriptLayer = sharedBattleLayerManager().layer
	self.mapLayer = sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_MAP)
	self.playerLayer = sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_PLAYERS)
	self.effectLayer = sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_SHIFT_SCENE)
	self.UILayer = sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_UI)
	self.mapImage = self.mapLayer.mapBatchLayer:getChildByName(BattleConfig.Battle_Map_Name)
	self.isBattleScript = true
end

function BattleScript:beginScript(currentScriptStep,isOverScript)
	closeTutorUI()
	self.isOnTiaoGuo = nil
	self.isOverScript = isOverScript
	self.hasEndCurrentScript = nil
	self.guideSkillArray = nil
	self.guildSkillStep = 1
	self.currentScriptStep = currentScriptStep
	local scriptId = self.battleProxy.battleScriptArr[currentScriptStep]
	if not scriptId then self:battleContinue() return end
	BattleScript.superclass.beginScript(self,scriptId);
	self:twoTeamVisible(false)
	self:setUIVisible(false)
	self.battleField.battleSceneMediator:setTiaoGuoVisible(true)

	self.isDelayTiaoguo = true
	local function startFun()
		self.isDelayTiaoguo = nil
	end
	Tweenlite:delayCallS(1.5,startFun);
end

function BattleScript:setUIVisible(bool)
	self.mapImage:setVisible(bool)
	self.UILayer:setVisible(bool)
end

function BattleScript:twoTeamVisible(bool)
	self:teamVisible(self.battleField.secondTeam.bornUnitMap,bool)
	self:teamVisible(self.battleField.firstTeam.bornUnitMap,bool)
end

function BattleScript:teamVisible(bornUnitMap,bool)
	for buk,buv in pairs(bornUnitMap) do
		if buv.battleIcon then
			buv.battleIcon:setVisible(bool);
			buv.roleShadow:setVisible(bool);
		end
	end
end

function BattleScript:readyEndScript()
	if self.hasEndCurrentScript then return end
	self.hasEndCurrentScript = true
	self:setUIVisible(true)
	self:twoTeamVisible(true)
	BattleScript.superclass.readyEndScript(self);
	self.battleField.battleSceneMediator:setTiaoGuoVisible(false)
	self:battleContinue()
	self.battleField.battleSceneMediator:refreshSkillCard(self.hasGuildSkill)
	self.hasGuildSkill = nil
	if self.battleProxy.battleType == BattleConfig.BATTLE_TYPE_4 and self.currentScriptStep == 6 then
		self:script_Battle_Over()
	end
end

function BattleScript:battleContinue()
	if self.isOverScript then
		self.battleField:scriptFourBattleContinue()
		self.isOverScript = nil
		return
	end
	if self.currentScriptStep == 1 then--战斗开始的脚本
		self.battleField:playBattleStart()
	elseif self.currentScriptStep == 2 or self.currentScriptStep == 4 then
		self.battleField:scriptTwoBattleContinue()
	elseif self.currentScriptStep == 3 or self.currentScriptStep == 5 then
		self.battleField:scriptThreeBattleContinue()
	end
end

local function sortOnIndex(a, b) return a.stepid < b.stepid end
function BattleScript:guildSkillClick(flag)
	if self.guildSkillStep and not flag then
		if self.battleProxy.guideHecDCNumber then 
			hecDC(5,self.battleProxy.guideHecDCNumber)
		end
	end
	if self.guideSkillArray and self.guideSkillArray[1] then 
		table.sort(self.guideSkillArray,sortOnIndex)
		self:guildSkillItem(self.guideSkillArray[1],flag)
		table.remove(self.guideSkillArray,1)
		self.guildSkillStep = self.guildSkillStep + 1
	end
end

function BattleScript:guildSkillItem(clickSkillData,flag)
	local skillItem = self:getSkillItem(clickSkillData.objectparameter)
	local position = skillItem:getPosition()
	require "main.controller.command.tutor.OpenTutorUICommand";
	local lastTime = 0
	if clickSkillData.event == self.EVENT_101 then
		lastTime = skillItem:getSkillOneTime()+1000
	elseif clickSkillData.event == self.EVENT_102 then
		lastTime = skillItem:getSkillTwoTime()
	end
	BattleUtils:setGuideHecDCNumber(self.battleProxy)
	self:removeStopBattleTimer()
	local function startFun()
		if clickSkillData.event == self.EVENT_101 then
			openTutorUI({x=position.x-GameData.uiOffsetX+10, y=position.y-GameData.uiOffsetY+10, width = 120, height = 120, alpha = 125,isBattle = true,step=clickSkillData.objectparameter});
			skillItem:setFlagScript(1)
			skillItem:refreshSkillCDTime()
			BattleUtils:sendUpdateHRValue(skillItem.heroVO,0,-99999);
		elseif clickSkillData.event == self.EVENT_102 then
			skillItem:setFlagScript(2)
			BattleUtils:sendUpdateHRValue(skillItem.heroVO,0,999999);
			openTutorUI({x=position.x-GameData.uiOffsetX+10, y=position.y-GameData.uiOffsetY+10, width = 120, height = 300, alpha = 125,isBattle = true,x2=position.x-GameData.uiOffsetX+85,y2=position.y-GameData.uiOffsetY,x3=position.x-GameData.uiOffsetX+85,y3=position.y-GameData.uiOffsetY+220,step=clickSkillData.objectparameter});
			skillItem:setUpEffectVisible(true)
			skillItem:setItemNormal()
		end
		self.battleProxy.AIBattleField:onPauseScript()
		self:removeStopBattleTimer()
		self:removeMask()
	end
	self:addMask()
	if flag then
		startFun()
	else
		self.stopBattleTimer = Director:sharedDirector():getScheduler():scheduleScriptFunc(startFun, lastTime/1000, false)
	end
end

function BattleScript:addMask()
	self:removeMask()
	self.maskScreen = LayerColorBackGround:getBackGround()
	self.maskScreen:setScale(2)
	self.maskScreen:setAlpha(0)
	self.maskScreen:setPositionXY(-GameData.uiOffsetX,-GameData.uiOffsetY)
	self.effectLayer:addChild(self.maskScreen);
end

function BattleScript:removeMask()
	self.effectLayer:removeChild(self.maskScreen);
	self.maskScreen = nil
end

function BattleScript:removeStopBattleTimer()
    if self.stopBattleTimer then
        Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.stopBattleTimer);
        self.stopBattleTimer = nil
    end
end

function BattleScript:getSkillItem(objectparameter)
	local heroID = analysis("Xinshouyindao_Xinshou",objectparameter,"heroID")
	for place,skillItem in pairs(self.battleProxy.skillItemArrayScriptTemp) do
		if skillItem:getGeneralID() == heroID then
			return skillItem
		end
	end
	for place,skillItem in pairs(self.battleProxy.skillItemArrayScriptTemp) do
		return skillItem
	end
end

function BattleScript:onTiaoGuoTap()
	if self.isDelayTiaoguo then return end
	self.isOnTiaoGuo = true
	self:tiaoGuoDC()
	self:endScriptData()
end

function BattleScript:tiaoGuoDC()
	-- 打点
    local extensionTable = {}
    extensionTable["tiaoguoID"] = self.scriptId
    hecDC(6, 3, nil, extensionTable)
end

function BattleScript:endScriptData()
	BattleScript.superclass.endScriptData(self)
	if self.isOnTiaoGuo then
		self:readyEndScript()
		BattleScript.superclass.removeBlackScreen(self)
	end
	self:removeStopBattleTimer()
end

function BattleScript:scriptBattleOver()
	if self.battleProxy.battleScriptArr[6] then
		self:beginScript(6)
		return
	end
	self:script_Battle_Over()
end

function BattleScript:script_Battle_Over()
	self.battleProxy:cleanBattleOverData()
	self:setUIVisible(false)
    require "main.controller.command.battleScene.ScriptToMainsceneCommand"
    ScriptToMainsceneCommand:new():execute();
end
