BattleDialogMiddleCommand=class(MacroCommand);

function BattleDialogMiddleCommand:ctor()
	self.class=BattleDialogMiddleCommand;
end

function BattleDialogMiddleCommand:execute(notification)

	-- local battleProxy = self:retrieveProxy(BattleProxy.name);
	
	-- battleProxy.AIBattleField.isNeedDialogue(true)

	-- self:removeMediator(ModalDialogMediator.name);
	-- self:unobserve(BattleDialogMiddleCommand);
	-- -- 新手脚本用
	-- local table_green = {type = "GreenHandBattle"};
	-- if notification.type == "GreenHandBattle" then
	-- 	self:addSubCommand(GreenHandBattle)		
	-- 	self:complete(table_green)		
	-- 	return
	-- end

	-- local table = {type = "BattleDialogMiddleCommand"};
	-- local tableMid = {type = "BattleDialogMidOverCommand"};
	-- local battleProxy = self:retrieveProxy(BattleProxy.name);

	-- if battleProxy.dialogType == BattleConfig.Battle_Dialog_Inter then
	-- 		self:addSubCommand(BattleInitCommand)
	-- 		self:complete(table) 
	-- elseif battleProxy.dialogType == BattleConfig.Battle_Dialog_Middle then
	-- 		self:addSubCommand(BattleInitCommand)
	-- 		self:complete(tableMid) 
	-- elseif battleProxy.dialogType == BattleConfig.Battle_Dialog_Leave then
	-- 		self:addSubCommand(BattleOverCommand)
	-- 		self:complete(table) 
	-- elseif battleProxy.dialogType == BattleConfig.Battle_Dialog_GREEN then
	-- 		self:addSubCommand(GreenHandBattle)		
	-- 		self:complete(table_green)
	-- end
	-- --self:removeCommand(BattleSceneNotifications.BATTLE_DIALOG_OVER,BattleDialogMiddleCommand);
	-- self.battleProxy = self:retrieveProxy(BattleProxy.name);
	-- self:initDialogMiddleUI()

end

-- function BattleDialogMiddleCommand:ToDialog(enterDialog)
--     -- self:registerCommand(TaskNotifications.OPEN_MODAL_DIALOG_COMMOND, ModalDialogCommand);
--     -- self:registerCommand(BattleSceneNotifications.BATTLE_OVER_COMMADN, BattleMoveCommand);
    
--     -- self:registerCommand(BattleSceneNotifications.BATTLE_DIALOG_OVER, BattleDialogOverCommand); 
--     local data = {isBattleDialog = true, dialog = enterDialog}
--     self:addSubCommand(ModalDialogCommand)
--     self:complete(TaskNotification.new(TaskNotifications.OPEN_MODAL_DIALOG_COMMOND, data));
-- end


-- function BattleDialogMiddleCommand:initDialogMiddleUI()
--     local hasBool = analysisHas("Juqing_Zhandouduihua",self.battleProxy.battleFieldId);
--     if hasBool then--防止没有
--             local storyLineProxy = self:retrieveProxy(StoryLineProxy.name);
--             if self.battleProxy.strongPointId == nil or storyLineProxy:getStrongPointState(self.battleProxy.strongPointId) ~= 1 then--判断是否通关
--             	local dialogPO = analysis("Juqing_Zhandouduihua", self.battleProxy.battleFieldId)
--             	   if tonumber(dialogPO.boshu1) == self.battleProxy.waveNumber+1 then
--                 		if dialogPO.boduihua1 ~= "" then--对话内容是否为空
--                 			    if nil == self.battleProxy.dialogType then
--     	                        self.battleProxy.dialogType = BattleConfig.Battle_Dialog_Middle;
--     	                    end
--     	                    self:ToDialog(dialogPO.boduihua1)
--                 		end
--                 -- else
--                 --     self:sendDialogMessage()
--                 end
--             -- else
--             --     self:sendDialogMessage()
--             end
--     -- else
--     --    self:sendDialogMessage()
--     end
-- end

-- function BattleDialogMiddleCommand:sendDialogMessage()
--     if self.battleProxy.battleStatus == BattleConfig.Battle_Status_1 then
--       self.battleProxy.dialogType = nil
--       sendMessage(7,26);
--     elseif self.battleProxy.battleStatus == BattleConfig.Battle_Status_3 then
--       -- local battleMediator = self:retrieveMediator(BattleSceneMediator.name);
--       -- battleMediator:refreshGoBotton()
--       print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
--       -- local myGeneralVO = self.battleProxy:getGeneralVOByUnitID(self.battleProxy.myBattleUnitID)     
--       -- battleunit
--       -- self.battleProxy:playerPosition(self.userProxy.userId,ccp(myGeneralVO.coordinateX, myGeneralVO.coordinateY))
--     end
-- end