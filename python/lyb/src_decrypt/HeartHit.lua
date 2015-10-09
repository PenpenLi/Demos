HeartHit = class();

-- 断线重连    
function HeartHit:heartHitBack()
		
	-- 关闭网络连接
--	closeSocket()	
	-- 清理mvc		
	gameStart:stop()
	
	-- 清理全局性的数据
	gameSceneIns = nil
	GameVar:dispose()
    
    ParticleSystem:dispose()
    ScreenShake:dispose()
    sharedMainLayerManager():disposeMainLayerManager()
    sharedBattleLayerManager():disposeBattleLayerManager()
    sharedTextAnimateReward():disposeTextAnimateReward()
	if ScreenScale then
	    ScreenScale:dispose()
	end

	disposeAllScheduler()

	GameData.connectType = 1

	BitmapCacher:dispose()

	-- local main = "main"
	-- package.loaded[main] = nil
	-- require(main)
	package.loaded["RunGame"] = nil
	local loaded = require ("RunGame");
	if loaded then
	  RunGameStart();
	end
end

-- 关闭游戏    
function HeartHit:closeGame()
		
		-- closeSocket()			
		-- gameStart:stop()
		
		-- sharedBattleLayerManager():clear();
		-- sharedMainLayerManager():clear();
		-- sharedTextAnimateReward():clear();
		Director:sharedDirector():endGame();

end
	
function HeartHit:execute()

	
	local function heartHit()
		--心跳次数大于3判定为掉线
		if GameData.heartHitCount >= 3 and GameData.isConnect then
			
			GameData.isConnect = false
			
			local textTable = {}
			textTable[1] = "重连";
			textTable[2] = "退出";
	        local tips=CommonPopup.new();
			tips:initialize("亲！你已经不幸掉线了，是否重连?",self,self.heartHitBack,nil,self.closeGame,nil,nil,textTable);
			
			local scene = Director.sharedDirector():getRunningScene();
			if scene then
			    if scene.name == GameConfig.MAIN_SCENE then
				    sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_EFFECTS):addChild(tips);
			    elseif  scene.name == GameConfig.BATTLE_SCENE then
				    sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_SHIFT_SCENE):addChild(tips);
			    end			
			end	

			Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.heartHitFunctionID)  

		else
			sendMessage(1,6);
			GameData.heartHitCount = GameData.heartHitCount + 1
		end
	end

	self.heartHitFunctionID = Director:sharedDirector():getScheduler():scheduleScriptFunc(heartHit, 6, false)
end

HeartHit.new():execute();