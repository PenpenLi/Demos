-------------------------
--BattleInitCommand handler_7_15 handler_7_16
-------------------------

BattleToMainCommand=class(MacroCommand);

function BattleToMainCommand:ctor()
	self.class=BattleToMainCommand;
end

--------------------------
--角色移动数据
--------------------------
function BattleToMainCommand:execute(notification)
	require "main.config.BattleConfig"
	require "main.view.battleScene.BattleLayerManager"
	-- require "main.controller.command.battleScene.OutBattleStuffCommand";
    --ScreenShake:dispose();
    --ScreenScale:dispose();
    sharedTextAnimateReward():disposeTextAnimateReward()
    -- InitMainSceneCommand:new():execute();
    Director:sharedDirector():setAnimationInterval(1.0/30)
    local userProxy = self:retrieveProxy(UserProxy.name);
    if notification and notification.data and notification.data.battleType == BattleConfig.BATTLE_TYPE_13 then
        userProxy.isTutorBattle = true
    else
		userProxy.isTutorBattle = false;
    end
    userProxy.outFromBattle = true

    --print("*************************>>userProxy.sceneType", userProxy.sceneType)
    if userProxy.sceneType == GameConfig.SCENE_TYPE_1 or userProxy.isTutorBattle then --
        EnterCityCommand.new():execute();

    else

        EnterCityCommand.new():execute();
        -- self:handleBattleClose();
    end
end

function BattleToMainCommand:handleBattleClose()
    -- sharedBattleLayerManager():disposeBattleLayerManager()
	-- local battleProxy = self:retrieveProxy(BattleProxy.name);
    -- if not battleProxy.isContinueBattle then
          -- BitmapCacher:removeAllCache(false)
    -- end
	-- local loopFunction
	-- local function localFun()
		
		-- if loopFunction then
			-- Director:sharedDirector():getScheduler():unscheduleScriptEntry(loopFunction)
		-- end
		-- OutBattleStuffCommand.new():execute();--����ս�������������	
	-- end
	-- loopFunction = Director:sharedDirector():getScheduler():scheduleScriptFunc(localFun, 0.2, false)

end