require "core.utils.MathUtils"
Handler_7_31 = class(Command)

function Handler_7_31:execute()
	local battleProxy = self:retrieveProxy(BattleProxy.name)
	battleProxy:cleanAIBattle();
	local battleUnitPropertyArray;
	local itemIdArray;
	if not battleProxy.handlerType then
		battleProxy.battleId = recvTable["BattleId"];
		MathUtils:setSeed(recvTable["RandomSeed"])
		--log("====================Battle_Status_3======================01")
		battleProxy.battleUnitIDArray = recvTable["BattleUnitIDArray"]
		battleUnitPropertyArray = recvTable["BattleUnitPropertyArray"]
		battleProxy.itemIdArray = recvTable["ItemIdArray"]
	elseif battleProxy.handlerType == "BattlePlaybackCommond" then
        local handlerData = battleProxy.handlerData;
        battleProxy.battleId = handlerData.BattleId;
        MathUtils:setSeed(1)
		battleProxy.battleUnitIDArray = handlerData.BattleUnitIDArray
		battleUnitPropertyArray = handlerData.BattleUnitPropertyArray
        battleProxy.needDebug = false
        battleProxy.handlerData = nil;
        battleProxy.handlerType = nil;
        package.loaded["main.controller.handler.Handler_7_31"] = nil
	end
	battleProxy.battleStatus = BattleConfig.Battle_Status_3;
	for key,unitVO in pairs(battleUnitPropertyArray) do
		local generalVO = battleProxy.battleGeneralArray[unitVO.BattleUnitID];
		generalVO.attackDistance = unitVO.AttackDistance
		generalVO.unitPropertyArray = unitVO.UnitPropertyArray;
		if generalVO.type == BattleConfig.BATTLE_OWER then
			local userVO = battleProxy.battleUserArray[generalVO.userID]
			userVO.attackDistance = unitVO.AttackDistance
			userVO.unitPropertyArray = unitVO.UnitPropertyArray;
			userVO.level = generalVO.level;
			local totalSkillMap = {}
			for skillKey,skillValue in pairs(generalVO.skillMap) do
				totalSkillMap[skillValue.id] = copyTable(skillValue)
			end
			userVO.totalSkillMap = totalSkillMap
		elseif generalVO.type == BattleConfig.BATTLE_PET or generalVO.type == BattleConfig.BATTLE_FRIEND or generalVO.type == BattleConfig.BATTLE_YONGBING then
			local tempUserVO = battleProxy.battleUserArray[generalVO.userID]
			local propertyTable = {}
			propertyTable.petConfigId = generalVO.generalID;
			propertyTable.petLevel = unitVO.Level;
			propertyTable.petPropertyArray = unitVO.UnitPropertyArray;
			propertyTable.petUnitId = unitVO.BattleUnitID
			propertyTable.petSkillMap = generalVO.skillMap
			propertyTable.petAttackDistance = unitVO.AttackDistance
			tempUserVO.heroPropertyArray[unitVO.BattleUnitID] = propertyTable
		end
	end
	self:removeTimeOutHandle()
	local function timeOutHandle()
		self:removeTimeOutHandle()
		--log("====================Battle_Status_3======================02")
		self:init_Battle_AI(battleProxy)
	end
	self.timeOutHandle = Director:sharedDirector():getScheduler():scheduleScriptFunc(timeOutHandle, 0, false)
end

function Handler_7_31:removeTimeOutHandle()
    if self.timeOutHandle then
        Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.timeOutHandle);
        self.timeOutHandle = nil
    end
end

function Handler_7_31:init_Battle_AI(battleProxy)
	local function playbackFun(playData)
		battleProxy.handlerData = playData;
		battleProxy.handlerType = "BattlePlaybackCommond";
		recvMessage(1007,playData.SubType);
		-- if playData.SubType == 24 then
		-- 	--log("=====Handler_7_24====")
		-- 	recvMessage(1007,24);
		-- elseif playData.SubType == 44 then
		-- 	--log("=====Handler_7_44====")
		-- 	recvMessage(1007,44);
		-- elseif playData.SubType == 15 then
		-- 	--log("=====Handler_7_15====")
		-- 	recvMessage(1007,15);
		-- elseif playData.SubType == 16 then
		-- 	--log("=====Handler_7_16====")
		-- 	recvMessage(1007,16);
		-- elseif playData.SubType == 19 then
		-- 	--log("=====Handler_7_19====")
		-- 	recvMessage(1007,19);
		-- elseif playData.SubType == 21 then
		-- 	--log("=====Handler_7_21====")
		-- 	recvMessage(1007,21);
		-- elseif playData.SubType == 4 then
		-- 	--log("=====Handler_7_4====")
		-- 	recvMessage(1007,4);
		-- elseif playData.SubType == 12 then
		-- 	--log("=====Handler_7_12====")
		-- 	recvMessage(1007,12);
		-- elseif playData.SubType == 29 then
		-- 	--log("=====Handler_7_29====")
		-- 	recvMessage(1007,29);
		-- elseif playData.SubType == 9 then
		-- 	--log("=====Handler_7_9====")
		-- 	recvMessage(1007,9);
		-- elseif playData.SubType == 5 then
		-- 	--log("=====Handler_7_5====")
		-- 	recvMessage(1007,5);
		-- elseif playData.SubType == 7 then
		-- 	--log("=====Handler_7_7====")
		-- elseif playData.SubType == 45 then
		-- 	--log("=====Handler_7_45====")
		-- 	recvMessage(1007,45);
		-- elseif playData.SubType == 46 then
		-- 	--log("=====Handler_7_46====")
		-- 	recvMessage(1007,46);
		-- elseif playData.SubType == 47 then
		-- 	--log("=====Handler_7_47====")
		-- 	recvMessage(1007,47);
		-- elseif playData.SubType == 49 then
		-- 	-- log("=====Handler_7_49====")
		-- 	recvMessage(1007,49);
		-- elseif playData.SubType == 50 then
		-- 	-- log("=====Handler_7_50====")
		-- 	recvMessage(1007,50);
		-- elseif playData.SubType == 51 then
		-- 	-- log("=====Handler_7_50====")
		-- 	recvMessage(1007,51);
		-- elseif playData.SubType == 66 then
		-- 	-- log("=====Handler_7_66====")
		-- 	recvMessage(1007,66);
		-- elseif playData.SubType == 67 then
		-- 	recvMessage(1007,67);
		-- elseif playData.SubType == 68 then
		-- 	recvMessage(1007,68);
		-- end
	end
	--log("====================Battle_Status_3======================03")
	local storyLineProxy = self:retrieveProxy(StoryLineProxy.name);
	local userProxy = self:retrieveProxy(UserProxy.name);
	local operatonProxy = self:retrieveProxy(OperationProxy.name);
	local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
	local generalListProxy = self:retrieveProxy(GeneralListProxy.name);
	battleProxy:initBattleAI(storyLineProxy,playbackFun,userProxy,operatonProxy,heroHouseProxy,generalListProxy)
end

Handler_7_31.new():execute();