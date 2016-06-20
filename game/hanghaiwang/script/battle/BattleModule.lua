


 
--                    _ooOoo_
--                   o8888888o
--                   88" . "88
--                   (| -_- |)
--                   O\  =  /O
--                ____/`---'\____
--              .'  \\|     |//  `.
--             /  \\|||  :  |||//  \
--            /  _||||| -:- |||||-  \
--            |   | \\\  -  /// |   |
--            | \_|  ''\---/''  |   |
--            \  .-\__  `-`  ___/-. /
--          ___`. .'  /--.--\  `. . __
--       ."" '<  `.___\_<|>_/___.'  >'"".
--      | | :  `- \`.;`\ _ /`;.`/ - ` : | |
--      \  \ `-.   \_ __\ /__ _/   .-` /  /
-- ======`-.____`-.___\_____/___.-`____.-'======
--                    `=---='
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--          佛祖保佑       永无BUG


-- /
module ("BattleModule",package.seeall)
 
NAME 						= "BattleModule"

-- local callbackFun 			= nil -- 回调
local state  				= nil -- 状态
local hasInit				= nil

local STATE_IDLE  			= 1	-- 空闲
local STATE_PLAYING			= 2 -- 正在播放

local originalFormat = nil

---------------- module ----------------
local function init(...)
	--print("BattleModule init")
	 
	 require "script/battle/BattleModuleRequire"
	 require "script/module/switch/SwitchCtrl"
	 -- local startTime =  os.clock()
     BattleModuleRequire.requireAllModules()
      -- local endTime =  os.clock()

      -- print("------------------- require cost:",endTime - startTime)
	 
				  -- local animation = CCArmature:create(shineAnimation)
	 ObjectTool.loadRoleAnimation()
     hasInit 				= true
end

function destroy(...)
	-- Logger.debug("---------------- BattleModule destory")
	--recoverTexturePixcelFormat()
	if(hasInit) then
		-- Logger.debug("---------------- 1 BattleModule destory")
		CCDirectorAnimationinterval:getInstance():resumeAnimationInterval()
		BattleActionRender.stop()
		
		if(BattleMainData.fightRecord) then
			BattleMainData.fightRecord:release()
		end
		
	 	EventBus.removeMediator("BattleBackGroundMediator")
	    EventBus.removeMediator("BattleRecordPlayMediator")
	    EventBus.removeMediator("BattleResultWindowMediator")
	    EventBus.removeMediator("BattleFormationMediator")
	  
	    EventBus.removeMediator("BattleTeamShowMediator")
	    EventBus.removeMediator("BattleInfoUIMediator")
	    EventBus.removeMediator("BattleTalkMediator")
		EventBus.removeMediator("SingleBattleMediator")
		EventBus.removeMediator("StrongHoldMediator")

		BattleSoundMananger.reset()
		BattleActionRender.removeAll()
		BattleTeamDisplayModule.removeAll()
		BattleLayerManager.release()
		EventBus.removeAllMediator()
		EventBus.release()
		BattleMainData.releaseData()
		BattleMainData.isPlaying = false
		
		BattleDataProxy.removeEvent()
		ObjectSharePool.release()
	end
	BattleState.setPlayRecordState(false)
	BattleState.setPlaying(false)
	SpriteFramesManager.release()
	setIdleState()


	if(g_debug_mode) then
		print("---------end dump--------- destroy")
  		CCTextureCache:sharedTextureCache():dumpCachedTextureInfo()
	end


	-- CCTexture2D:setDefaultAlphaPixelFormat(originalFormat)
	-- package.loaded[NAME] = nil

end

function moduleName()
    return NAME
end


---------------- state ----------------
function isPlaying()
	return state == STATE_PLAYING
end

 function setIdleState( ... )
	state = STATE_IDLE
end 

 function setPlayingState( ... )
	state = STATE_PLAYING
end 


---------------- function  ----------------
function setTexturePixcelFormat( ... )
	originalFormat = CCTexture2D:defaultAlphaPixelFormat()
	CCTexture2D:setDefaultAlphaPixelFormat(kCCTexture2DPixelFormat_RGBA4444)
end
function recoverTexturePixcelFormat( ... )
	if (originalFormat) then -- zhangqi, 2014-09-22
		CCTexture2D:setDefaultAlphaPixelFormat(originalFormat)
	end
end


-- 播放boss战
function PlayBossRecord(strongholdid,level,battleString,callBack,data)




	-- print("&&&&& PlayBossRecord:")
		assert(callBack,"callBack is nil")
		assert(battleString,"battleString is nil")
		assert(strongholdid,"strongholdid:" .. tostring(strongholdid).. " is nil")

		if(level == nil) then
			level = 1
		end

		require "script/battle/BattleModuleRequire"
		-- print("=== start boss:",strongholdid,level)
		BattleModuleRequire.requireAllModules()
		reset()

 		BattleState.setBattleRecordInfo(BATTLE_CONST.BATTLE_API_STRONGHOLD_SINGLE,
 										BATTLE_CONST.BATTLE_TYPE_COPY_SINGLE,strongholdid,level)

		-- BattleModuleRequire.requireAllModules()
		-- get background image
		local background 			= db_stronghold_util.getBackGroundImageName(strongholdid)
	   	-- get background music
		local backgroundMusic  		= db_stronghold_util.getBackGroundMusic(strongholdid)
		
		
		assert(backgroundMusic,"strongholdid:" .. tostring(strongholdid).. "未找到背景音乐")
		assert(background,"strongholdid:" .. tostring(strongholdid).. "未找到背景图片")
		-- print(" ==== boss :",background,backgroundMusic)
		BattleMainData.createDisplayStrongHoldData(strongholdid,level)
	 
		-- local canJumpBattle = db_vip_util.canJumpICopyBattle()
		-- BattleMainData.jumpRefuseTip = gi18nString(BATTLE_CONST.ICOPY_BATTLE_NOT_JUMP_TIP)

		BattleMainData.useSceneChangeEffect = false
		PlayNormalRecord(battleString,callBack,data,false,
						background,
						backgroundMusic,
						BATTLE_CONST.WINDOW_BOSSS,true,
                        true --世界BOSS战斗	永久显示
                        )
 
end
-- 播放竞技场排行录像
function PlayBillBoardRecord( battleString,callBack,data )
	-- print("&&&&& PlayBillBoardRecord:")
		-- CCTextureCache:sharedTextureCache():dumpCachedTextureInfo()
		assert(battleString)
		assert(callBack)
		local closure = function( ... )
			callBack()
			destory()
		end

		require "script/battle/BattleModuleRequire"
		BattleModuleRequire.requireAllModules()
		reset()
		-- BattleState.setBattleRecordInfo(BATTLE_CONST.BATTLE_TYPE_ARENA)
 		BattleState.setBattleRecordInfo(BATTLE_CONST.BATTLE_API_TYPE_SINGLE,
 										BATTLE_CONST.BATTLE_TYPE_ARENA)

		if(BattleState.isPlaying() == false) then
			-- CCDirectorAnimationinterval:getInstance():setAnimationInterval(1/30)
			BattleState.setPlaying(true)

			BattleMainData.winType = BATTLE_CONST.WINDOW_ARENA_BILLBOARD
			BattleMainData.singleBattleResultData = data
	    	EventBus.regestMediator(require("script/battle/mediator/SingleBattleMediator"))
	    	BattleMainData.useSceneChangeEffect = false
	    	-- EventBus.regestMediator(require("script/battle/mediator/BattleRecordShowSecondMediator"))
	    	-- EventBus.regestMediator(require("script/battle/mediator/BattleRecordShowFirstMediator"))
	        BattleMainData.resetSingleRecordData(
	        	battleString,
	        	callBack,
	        	BATTLE_CONST.ROB_BACKGROUND,
	        	BATTLE_CONST.ROB_BACKMUSIC)
	        EventBus.sendNotification(NotificationNames.EVT_SINGLE_BATTLE_INI)
	        SwitchCtrl.postBattleNotification("BEGIN_BATTLE")
	    end
		    
end


-- 公会副本
function playGuideCopyBattle( strongholdid,level,battleString,callBack,data)
	if(level == nil) then
		level = 1
	end
	-- print("&&&&& playGuideCopyBattle:",strongholdid,level)
	assert(strongholdid,"strongholdid:" .. tostring(strongholdid).. " is nil")
	require "script/battle/BattleModuleRequire"
	--setTexturePixcelFormat()
	BattleModuleRequire.requireAllModules()
	-- get background image
	local background 			= db_stronghold_util.getBackGroundImageName(strongholdid)
   	-- get background music
	local backgroundMusic  		= db_stronghold_util.getBackGroundMusic(strongholdid)
	

	BattleState.setBattleRecordInfo(BATTLE_CONST.BATTLE_API_STRONGHOLD_SINGLE,
									BATTLE_CONST.BATTLE_TYPE_COPY_GUIDE,strongholdid,level)

	
	assert(backgroundMusic,"strongholdid:" .. tostring(strongholdid).. "未找到背景音乐")
	assert(background,"strongholdid:" .. tostring(strongholdid).. "未找到背景图片")
	
	BattleMainData.createDisplayStrongHoldData(strongholdid,level)
 
	local canJumpBattle = db_vip_util.canJumpICopyBattle()
	-- BattleMainData.jumpRefuseTip = gi18nString(BATTLE_CONST.ICOPY_BATTLE_NOT_JUMP_TIP)

	PlayNormalRecord(battleString,callBack,data,false,
					background,
					backgroundMusic,
					BATTLE_CONST.WINDOW_GUIDE,canJumpBattle,
                    true -- 公会副本战斗	永久显示
                    )

	BattleMainData.jumpRefuseTip = gi18nString(BATTLE_CONST.ICOPY_BATTLE_NOT_JUMP_TIP)
end

-- 探索奇遇
-- strongholdid : id
-- level : 难度等级
function playAdventure( strongholdid,level,battleString,callBack,data)

	if(level == nil) then
		level = 1
	end
	-- print("&&&&& playAdventure:",strongholdid,level)
	assert(strongholdid,"strongholdid:" .. tostring(strongholdid).. " is nil")
	require "script/battle/BattleModuleRequire"
	--setTexturePixcelFormat()
	BattleModuleRequire.requireAllModules()
	-- get background image
	local background 			= db_stronghold_util.getBackGroundImageName(strongholdid)
   	-- get background music
	local backgroundMusic  		= db_stronghold_util.getBackGroundMusic(strongholdid)
	
	
	assert(backgroundMusic,"strongholdid:" .. tostring(strongholdid).. "未找到背景音乐")
	assert(background,"strongholdid:" .. tostring(strongholdid).. "未找到背景图片")
	
	BattleMainData.createDisplayStrongHoldData(strongholdid,level)
	BattleState.setBattleRecordInfo(BATTLE_CONST.BATTLE_API_STRONGHOLD_SINGLE,
									BATTLE_CONST.BATTLE_TYPE_COPY_SINGLE,strongholdid,level)

	-- 2015.5.25 测试王晓静需求 这一类型战斗不能直接跳过战斗
	-- 1.第一次战斗，不允许玩家跳过战斗，点击跳过战斗，提示文字：奇遇战斗无法跳过，请耐心等待！，i18id为4383
	-- 2.战斗重播允许玩家跳过
	-- 3.无论玩家vip达到任何等级、或角色等级达到任何等级，都无法跳过战斗
	
	PlayNormalRecord(battleString,callBack,data,false,
					background,
					backgroundMusic,
					BATTLE_CONST.WINDOW_ADVENTURE,false,
                    false --探索奇遇战斗	不显示
                    )
end
-- 资源矿战斗
function playMineBattle( battleString,callBack,data,followRole)
	require "script/battle/BattleModuleRequire"
	BattleModuleRequire.requireAllModules()

	local bg,music = db_battleConfig_util.getMineBackAndMusic()
	if(bg == nil) then
		bg = BATTLE_CONST.MINE_BACKGROUND
	end
	if(music == nil) then
		music = BATTLE_CONST.MINE_BACKMUSIC
	end

	BattleState.setBattleRecordInfo(BATTLE_CONST.BATTLE_API_TYPE_SINGLE,
									BATTLE_CONST.BATTLE_TYPE_MINE)

    --资源岛战斗	永久显示 可以跳过，无条件
	PlayNormalRecord(battleString,callBack,data,followRole,
					bg,
					music,
					BATTLE_CONST.WINDOW_MINE,true,true)
end
-- 神秘空岛
function playSkyPiea( battleString,callBack,data,followRole )
	require "script/battle/BattleModuleRequire"
	BattleModuleRequire.requireAllModules()

	BattleState.setBattleRecordInfo(BATTLE_CONST.BATTLE_API_TYPE_SINGLE,
									BATTLE_CONST.BATTLE_TYPE_SKYPIE)

	--10	神秘空岛战斗	永久显示	可以跳过，无条件
	PlayNormalRecord(battleString,callBack,data,followRole,
					BATTLE_CONST.TOWER_BACKGROUND,
					BATTLE_CONST.TOWER_BACKMUSIC,
					BATTLE_CONST.WINDOW_SEA_PIEA,true,true)
 
end
function PlayTowerFightRecord(battleString,callBack,data,followRole)
	local bg,music = db_battleConfig_util.getTowerBackAndMusic()
	if(bg == nil) then
		bg = BATTLE_CONST.TOWER_BACKGROUND
	end
	if(music == nil) then
		music = BATTLE_CONST.TOWER_BACKMUSIC
	end

	BattleState.setBattleRecordInfo(BATTLE_CONST.BATTLE_API_TYPE_SINGLE,
									BATTLE_CONST.BATTLE_TYPE_TOWER)
	 PlayNormalRecord(battleString,callBack,data,followRole,
	 				  bg,music,
	 				  BATTLE_CONST.WINDOW_SEA_PIEA)
end
-- 深海监狱
-- canJumpImpelBattle 是否通关过该战斗 
function playImpelBattle( strongholdid , level , battleString , callBack , data , canJumpImpelBattle  )
	if not (level) then
		level = 1
	end


	

	require "script/battle/BattleModuleRequire"
	BattleModuleRequire.requireAllModules()


	BattleState.setBattleRecordInfo(BATTLE_CONST.BATTLE_API_STRONGHOLD_SINGLE,
								BATTLE_CONST.BATTLE_TYPE_IMPEL,strongholdid,level)

	local background 			= db_stronghold_util.getBackGroundImageName(strongholdid)
	local backgroundMusic  		= db_stronghold_util.getBackGroundMusic(strongholdid)
	
	assert(backgroundMusic,"strongholdid:" .. tostring(strongholdid).. "未找到背景音乐")
	assert(background,"strongholdid:" .. tostring(strongholdid).. "未找到背景图片")

	BattleMainData.createDisplayStrongHoldData(strongholdid,level)

	if canJumpImpelBattle == nil then
		canJumpImpelBattle = db_vip_util.canJumpNormalCopyBattle()
	end
    
	PlayNormalRecord( battleString,callBack,data,false,
					background,backgroundMusic,
					BATTLE_CONST.WINDOW_IMPEL, canJumpImpelBattle,
                    ----深海监狱战斗	通关该监狱层，或达到vip表中normal_skip的配置
                    canJumpImpelBattle)

	BattleMainData.jumpRefuseTip = gi18nString(BATTLE_CONST.IMPELDOWN_JUMP_BATTLE_TIP_ID)
	
end
-- 一般战斗录像入口: 邮件战报
function PlayNormalRecord(battleString,callBack,data,followRole,backGround,backGroundMusic,winType,skipBattle,showSkipButton)
		-- print("&&&&& PlayNormalRecord:")
		CCTextureCache:sharedTextureCache():removeUnusedTextures()
	 	assert(battleString)
		assert(callBack)

		if(hasInit ~= true) then
			init()
		end
		 
		require "script/battle/BattleModuleRequire"
		--setTexturePixcelFormat()
		BattleModuleRequire.requireAllModules()

		if(BattleState.isPlaying() == false) then
			-- CCDirectorAnimationinterval:getInstance():setAnimationInterval(1/30)
			BattleState.setPlaying(true)

			-- BattleMainData.
			
			BattleMainData.singleBattleResultData = data
			EventBus.regestMediator(require("script/battle/mediator/SingleBattleMediator"))
			-- Logger.debug(" ->followRole:" .. tostring(followRole))
			backGround = backGround or BATTLE_CONST.ARENA_BACKGROUND
			backGroundMusic = backGroundMusic or BATTLE_CONST.ARENA_BACKMUSIC
			winType = winType or BATTLE_CONST.WINDOW_NORMAL

			BattleMainData.winType = winType
		    BattleMainData.resetSingleRecordData(
		    					
		    										battleString,
		    										callBack,
		    										backGround,
		    										backGroundMusic,followRole,skipBattle,showSkipButton
		    									)
	 		BattleMainData.jumpRefuseTip = gi18nString(BATTLE_CONST.ADVENTURE_JUMP_BATTLE_TIP_ID)
		     
		    EventBus.sendNotification(NotificationNames.EVT_SINGLE_BATTLE_INI)
		    SwitchCtrl.postBattleNotification("BEGIN_BATTLE")
		end
end

-- 竞技场
function PlayArenaBattle(battleString,callBack,data)

			-- showTopSecondBattle(callBack)
			-- showTopFirstBattle(callBack)
			assert(battleString)
			assert(callBack)
			
			require "script/battle/BattleModuleRequire"
			if(hasInit ~= true) then
				init()
			end
			BattleModuleRequire.requireAllModules()

			BattleState.setBattleRecordInfo(BATTLE_CONST.BATTLE_API_TYPE_SINGLE,
										BATTLE_CONST.BATTLE_TYPE_ARENA)

			reset()
			if(BattleState.isPlaying() == false) then
				BattleState.setPlaying(true)
				BattleMainData.winType = BATTLE_CONST.WINDOW_ARENA
				BattleMainData.singleBattleResultData = data
		    	EventBus.regestMediator(require("script/battle/mediator/SingleBattleMediator"))

		    	local canJumpBattle,debugInfo = db_vip_util.canJumpArena() --or g_debug_mode 
		    	local bg,music = db_battleConfig_util.getArenaBackAndMusic()
		    	if(bg == nil) then
		    		bg = BATTLE_CONST.ARENA_BACKGROUND
		    	end
		    	if(music == nil) then
		    		music = BATTLE_CONST.ARENA_BACKMUSIC
		    	end

		        BattleMainData.resetSingleRecordData(
		        									 battleString,
		        									 callBack,
		        									 bg,
		        									 music,
		        									 false,
		        									 canJumpBattle,
                                                     true --竞技场战斗	永久显示
		        									 )
				BattleMainData.jumpRefuseTip = gi18nString(BATTLE_CONST.ARENA_JUMP_BATTLE_TIP_ID)
		        EventBus.sendNotification(NotificationNames.EVT_SINGLE_BATTLE_INI)
		        SwitchCtrl.postBattleNotification("BEGIN_BATTLE")
		    end

end

-- 巅峰对决(海盗激斗)!!!

function playWABattleRecord(battleString,callBack,data)
            if(hasInit ~= true) then
				init()
			end
			assert(battleString)
			assert(callBack)
			--setTexturePixcelFormat()
			
			require "script/battle/BattleModuleRequire"
			BattleModuleRequire.requireAllModules()
			reset()

			BattleState.setBattleRecordInfo(BATTLE_CONST.BATTLE_API_TYPE_SINGLE,
										BATTLE_CONST.BATTLE_TYPE_WA)

			if(BattleState.isPlaying() == false) then
				-- CCDirectorAnimationinterval:getInstance():setAnimationInterval(1/30)
				BattleState.setPlaying(true)

				BattleMainData.winType = BATTLE_CONST.WINDOW_WA
				BattleMainData.singleBattleResultData = data
		    	EventBus.regestMediator(require("script/battle/mediator/SingleBattleMediator"))
		    	BattleMainData.useSceneChangeEffect = true
            	local bg,music = db_battleConfig_util.getWABackAndMusic()
            	 if(bg == nil or bg == "") then
            	 	bg = BATTLE_CONST.WA_BACKGROUND
            	 end

            	 if(music == nil or music == "") then
		            music = BATTLE_CONST.WA_BACKMUSIC
		         end
		        BattleMainData.resetSingleRecordData(
		        	battleString,
		        	callBack,bg,music
		        	,true,true)
		        EventBus.sendNotification(NotificationNames.EVT_SINGLE_BATTLE_INI)
		        SwitchCtrl.postBattleNotification("BEGIN_BATTLE")
		    end

end
-- 打劫,夺宝
function PlayRobBattle(battleString,callBack,data)
			-- playTutorial1(callBack,function ( ... )
			-- 	
			-- end)
			if(hasInit ~= true) then
				init()
			end
			assert(battleString)
			assert(callBack)
			--setTexturePixcelFormat()
			
			require "script/battle/BattleModuleRequire"
			BattleModuleRequire.requireAllModules()
			reset()

				BattleState.setBattleRecordInfo(BATTLE_CONST.BATTLE_API_TYPE_SINGLE,
										BATTLE_CONST.BATTLE_TYPE_ROB)

			if(BattleState.isPlaying() == false) then
				CCDirectorAnimationinterval:getInstance():setAnimationInterval(1/30)
				BattleState.setPlaying(true)

				BattleMainData.winType = BATTLE_CONST.WINDOW_ROB
				BattleMainData.singleBattleResultData = data
		    	EventBus.regestMediator(require("script/battle/mediator/SingleBattleMediator"))
		    	BattleMainData.useSceneChangeEffect = true
		    	-- EventBus.regestMediator(require("script/battle/mediator/BattleRecordShowSecondMediator"))
		    	-- EventBus.regestMediator(require("script/battle/mediator/BattleRecordShowFirstMediator"))
                -- 夺宝战斗	永久显示	可以跳过，无条件
		        BattleMainData.resetSingleRecordData(
		        	battleString,
		        	 
		        	callBack,
		        	BATTLE_CONST.ROB_BACKGROUND,
		        	BATTLE_CONST.ROB_BACKMUSIC,true,true)
		        EventBus.sendNotification(NotificationNames.EVT_SINGLE_BATTLE_INI)
		        SwitchCtrl.postBattleNotification("BEGIN_BATTLE")
		    end

end

-- 活动副本
function playActiveCopyBattle( copy_id,base_id,strongHoldHardLevel,copyHardlevel,callbackFunc,copyType)
	if(hasInit ~= true) then
		init()
	end
	-- print("&&&&& PlayNormalRecord:",copy_id,base_id)
	assert(copyHardlevel,"BattleModule.playActiveCopyBattle: copyHardlevel为空")
	-- print("copyHardlevel",copyHardlevel)
	BattleMainData.activeCopyHardLevel = copyHardlevel
	BattleMainData.activeRadio = OutputMultiplyUtil.getDailyCopyRateNum( copy_id ) /10000
	-- print("-- activeRadio:",BattleMainData.activeRadio)
	playCopyStyleBattle(copy_id,base_id,strongHoldHardLevel,callbackFunc,copyType)
end


--[[desc:播放觉醒副本战斗
    arg1: 
    return: 无  
—]]
function playAwakeCopyBattle( copy_id,base_id,callbackFunc )
	if(hasInit ~= true) then
		init()
	end

	BattleMainData.activeCopyHardLevel = 1
	playCopyStyleBattle(copy_id,base_id,1,callbackFunc,COPY_TYPE_AWAKE)
end

-- local originalFormat = nil
-- 播放副本类型战斗
-- copy_id		:副本id
-- base_id		:strongHold id
-- level  		:难度等级
-- callbackFunc	:回调
-- copyType 	:副本类型
-- useSceneChangeEffect: 是否使用转场特效
function playCopyStyleBattle(copy_id,base_id,level,callbackFunc,copyType,useSceneChangeEffect)

	

	-- Logger.debug("g_network_status:" .. g_network_status)
	-- print("&&&&& playCopyStyleBattle:",copy_id,base_id,level)
	CCTextureCache:sharedTextureCache():removeUnusedTextures()
	if(g_debug_mode) then
		print("---------start dump--------- playCopyStyleBattle")
  		CCTextureCache:sharedTextureCache():dumpCachedTextureInfo()
	end


	


	-- 保存原来的格式
	-- originalFormat = CCTexture2D:defaultAlphaPixelFormat()
	-- CCTexture2D:setDefaultAlphaPixelFormat(kCCTexture2DPixelFormat_RGBA4444)
	--setTexturePixcelFormat()
	-- 如果没有初始化
	if(hasInit ~= true) then
		init()
	end
	reset()

	if(BattleState.isPlaying() == false) then
 
		if(useSceneChangeEffect == nil) then
			useSceneChangeEffect = true
		end
		BattleState.setPlaying(true)
		assert(callbackFunc,"BattleModule.playCopyStyleBattle: callbackFunc(回调函数)为空")
		assert(copy_id,"BattleModule.playCopyStyleBattle: copy_id为空")
		assert(base_id,"BattleModule.playCopyStyleBattle: base_id为空")
		assert(level,"BattleModule.playCopyStyleBattle: level为空")
		assert(copyType,"BattleModule.playCopyStyleBattle: copyType为空")

		BattleMainData.winType = BATTLE_CONST.WINDOW_COPY
		
		
		BattleState.setBattleRecordInfo(BATTLE_CONST.BATTLE_API_STRONGHOLD_SINGLE,
									BATTLE_CONST.BATTLE_TYPE_COPY_SINGLE,base_id,level)

		-- 正常副本
		if(copyType == COPY_TYPE_NORMAL) then
			assert(DB_Copy.getDataById(copy_id),"BattleModule.playCopyStyleBattle: 未检测到copyid:",copy_id)
		-- 精英本
		elseif(copyType == COPY_TYPE_ECOPY) then
 			assert(DB_Elitecopy.getDataById(copy_id),"BattleModule.playCopyStyleBattle: 未检测到DB_Elitecopy id:",copy_id)
		-- 活动本
		elseif(copyType == COPY_TYPE_EVENT) then

			

			BattleMainData.winType = BATTLE_CONST.WINDOW_EVENT
			Logger.debug("== hard level:" .. tostring(level))
			useSceneChangeEffect = false
		-- 贝里活动本
		elseif(copyType == COPY_TYPE_EVENT_BELLT) then
			BattleMainData.winType = BATTLE_CONST.WINDOW_EVENT_BELLY
			BattleState.setBattleRecordInfo(BATTLE_CONST.BATTLE_API_STRONGHOLD_SINGLE,
									BATTLE_CONST.BATTLE_TYPE_COPY_EVENT_BELLY,base_id,level)

			Logger.debug("== hard level:" .. tostring(level))
		-- 觉醒
		elseif(copyType == COPY_TYPE_AWAKE) then
			BattleMainData.winType = BATTLE_CONST.WINDOW_AWAKING
		else
			error("copyType error:"..copyType)
		end
		BattleMainData.copyType = copyType
		assert(DB_Stronghold.getDataById(base_id),"BattleModule.playCopyStyleBattle: 未检测到base_id:",base_id)


		BattleMainData.useSceneChangeEffect = useSceneChangeEffect
		-- callbackFun = callbackFunc
		-- 设置状态
		setPlayingState()
		-- 回调
		BattleMainData.callbackFunc = callbackFun
		-- 注册管理器
		EventBus.regestMediator(require("script/battle/mediator/StrongHoldMediator"))
	    -- 重置数据
	    BattleMainData.reset(copy_id,copyType,base_id,level,callbackFunc)
	    -- 开始初始化
	    EventBus.sendNotification(NotificationNames.EVT_STRONGHOLD_INI,function ( ... )
	    	onBattleQuit()
	    end)

	    SwitchCtrl.postBattleNotification("BEGIN_BATTLE")
	else
		error("当前战斗正在播放")
	end
            
end
-- pvp 切磋
function playPVP( battleString , callBack ,data)
	
			assert(battleString)
			assert(callBack)
			
			require "script/battle/BattleModuleRequire"
			if(hasInit ~= true) then
				init()
			end

			BattleModuleRequire.requireAllModules()
			BattleState.setBattleRecordInfo(BATTLE_CONST.BATTLE_API_TYPE_SINGLE,
										BATTLE_CONST.BATTLE_TYPE_PVP)


			reset()
			if(BattleState.isPlaying() == false) then
				-- CCDirectorAnimationinterval:getInstance():setAnimationInterval(1/30)
				BattleState.setPlaying(true)
				BattleMainData.winType = BATTLE_CONST.WINDOW_PVP
				BattleMainData.singleBattleResultData = data

		    	EventBus.regestMediator(require("script/battle/mediator/SingleBattleMediator"))
		    	 
		        BattleMainData.resetSingleRecordData(
		        									 battleString,
		        									 callBack,
		        									 BATTLE_CONST.ARENA_BACKGROUND,
		        									 BATTLE_CONST.ARENA_BACKMUSIC,
		        									 false,
		        									 true,
                                                     true--玩家切磋战斗	永久显示
		        									 )
				-- BattleMainData.jumpRefuseTip = gi18nString(BATTLE_CONST.ARENA_JUMP_BATTLE_TIP_ID)
		        EventBus.sendNotification(NotificationNames.EVT_SINGLE_BATTLE_INI)
		        -- SwitchCtrl.postBattleNotification("BEGIN_BATTLE")
		    end

end

-- 单场战斗专用播录像
function playSingleReplay(battleString,callBack,data,battleType)
	require "script/battle/BattleModuleRequire"
	BattleModuleRequire.requireAllModules()
			battleType = tonumber(battleType)
			assert(battleString)
			assert(callBack)
			
			require "script/battle/BattleModuleRequire"
			if(hasInit ~= true) then
				init()
			end
			BattleModuleRequire.requireAllModules()

			BattleState.setBattleRecordInfo(BATTLE_CONST.BATTLE_API_TYPE_SINGLE,
										battleType)

			reset()

			if(BattleState.isPlaying() == false) then
				BattleState.setPlaying(true)
				BattleMainData.winType = BATTLE_CONST.WINDOW_NORMAL
				BattleMainData.singleBattleResultData = data
		    	EventBus.regestMediator(require("script/battle/mediator/SingleBattleMediator"))

		    	local bg,music
		    		if(battleType == BATTLE_CONST.BATTLE_TYPE_ARENA) then
						bg,music = db_battleConfig_util.getArenaBackAndMusic()
					elseif(battleType == BATTLE_CONST.BATTLE_TYPE_MINE) then
						bg,music = db_battleConfig_util.getMineBackAndMusic()
					elseif(battleType == BATTLE_CONST.BATTLE_TYPE_ROB) then
						bg,music = db_battleConfig_util.getMineBackAndMusic()
					elseif(battleType == BATTLE_CONST.BATTLE_TYPE_PVP) then
						bg,music = db_battleConfig_util.getMineBackAndMusic()
					elseif(battleType == BATTLE_CONST.BATTLE_TYPE_WA) then
						bg,music = db_battleConfig_util.getWABackAndMusic()
					else
						bg,music = db_battleConfig_util.getDefaultBackAndMusic()
					end
				PlayNormalRecord(battleString,callBack,data,false,backGround,backGroundMusic,winType,true)
		    	
		    	if(bg == nil) then
		    		bg = BATTLE_CONST.ARENA_BACKGROUND
		    	end
		    	if(music == nil) then
		    		music = BATTLE_CONST.ARENA_BACKMUSIC
		    	end

		        BattleMainData.resetSingleRecordData(
		        									 battleString,
		        									 callBack,
		        									 bg,
		        									 music,
		        									 false,
		        									 true,
                                                     true --竞技场战斗	永久显示
		        									 )
				-- BattleMainData.jumpRefuseTip = gi18nString(BATTLE_CONST.ARENA_JUMP_BATTLE_TIP_ID)
		        EventBus.sendNotification(NotificationNames.EVT_SINGLE_BATTLE_INI)
		        -- SwitchCtrl.postBattleNotification("BEGIN_BATTLE")
		    end


end


-- 副本用
function playCopyStyleReplay( battleString,callBack,data,battleType,strongholdid,level,battleIndex)
		assert(battleString,"battleString is nil")
		assert(callBack,"callBack is nil")
		assert(level,"level is nil")
		assert(strongholdid,"strongholdid:" .. tostring(strongholdid).. " is nil")

		if(level == nil) then
			level = 1
		end

		BattleMainData.battleType = battleType
		battleType = tonumber(battleType)
		level = tonumber(level)
		strongholdid = tonumber(strongholdid)
		level = tonumber(level)
		if(battleIndex == "" or battleIndex == nil)then
			battleIndex = 1
		else
			battleIndex = tonumber(battleIndex)
		end
		require "script/battle/BattleModuleRequire"
		-- print("=== start boss:",strongholdid,level)
		BattleModuleRequire.requireAllModules()
		reset()

		-- -- 初始化最大回合数
		-- if(battleType == BATTLE_CONST.BATTLE_TYPE_COPY_GUIDE) then
		-- 	BattleMainData.maxRound = db_normal_config_util.getGuideCopyBattleMaxRound()
		-- elseif(battleType == BATTLE_CONST.BATTLE_TYPE_COPY_EVENT_BELLY) then
		-- 	BattleMainData.maxRound = db_normal_config_util.getBellyCopyBattleMaxRound()
		-- else
		-- 	BattleMainData.maxRound  = BATTLE_CONST.MAX_ROUND
		-- end

 		BattleState.setBattleRecordInfo(BATTLE_CONST.BATTLE_API_STRONGHOLD_SINGLE,
 										battleType,strongholdid,level,battleIndex)

		-- BattleModuleRequire.requireAllModules()
		-- get background image
		local background 			= db_stronghold_util.getBackGroundImageName(strongholdid)
	   	-- get background music
		local backgroundMusic  		= db_stronghold_util.getBackGroundMusic(strongholdid)
		
		
		assert(backgroundMusic,"strongholdid:" .. tostring(strongholdid).. "未找到背景音乐")
		assert(background,"strongholdid:" .. tostring(strongholdid).. "未找到背景图片")
		-- print(" ==== boss :",background,backgroundMusic)
		BattleMainData.createDisplayStrongHoldData(strongholdid,level,battleIndex)
	 
		-- local canJumpBattle = db_vip_util.canJumpICopyBattle()
		-- BattleMainData.jumpRefuseTip = gi18nString(BATTLE_CONST.ICOPY_BATTLE_NOT_JUMP_TIP)

		BattleMainData.useSceneChangeEffect = false
		PlayNormalRecord(battleString,callBack,data,false,
						background,
						backgroundMusic,
						BATTLE_CONST.WINDOW_NORMAL,true,
                        true
                        )

end

-- 顶上战争第1场
 
function showTopFirstBattle(callBack)
	 
	battleString = 'eJytVk1sG0UU9q5f7WyMSd2QBEIU2hPJpcRpmz9FIUqtKI2qEjlV1QNSO/aO463XXrNeh0TiwFJEQaqK4FIQB0QLEUJIVWsfkBAIKEhISNzgAD0hOPBXTggESOHNjL2edbNOkTjsat+8+ea99837dqY7psQzxHFMqh1QumNKAr9JtkBtePrb364ndJqjJR2tD74eiZOsY1gleO7WRsy2qiUdlAFi22kqxjWN4UHg7MYgKN7gjXskoyYbdWYwS7PJGoXt7e1/VL4MsLARuLjcBUq3FmVTeoqkpFtPlsLM9zACezGFFCkiUAuzCX06N05ulinmJ4xTxKxSOP/uIR5lL8eOIHafgNwHSn+bd3QnL7PuBUWFv745J+qMwJXTPDepdhkZ7oc/5/wUyL6fhvyMyL7vH/ETJPt+OSslw9YFllIELnXxZMINHx9tg7pvPabgJtv20bxh6sLhX0NrkR3PVHM5aotZCWEc0+HFrOYweoc0nTgE984rnM0bFNOHcNowDO1vumud3aIHJIYLHsNjuzG8Eczwr/Fghn/oC2b49rSf4RpjpxCBq7Mtdu6gF/vk50eVpqvQ5vpxznOZba7buq900ys9xaPtCSzdffV4cH3uM5v+Iuo8dgS29rbaZKd03PpBAWyqkJeOsu8CtX0j/ou8m3k0V7w4zxeU27WdNPdlbyPEb0GWXmaHfHwEfPl4cGe416IdqLuWDu4N96MHg+Wn7iK/d5YV5f4A2amNxgqQyP8nsCaVLY3N7EblF/0dqHz/oQ5U3jjXgcqbw1JOf/ultthiZCepuTdpoNbcD0cCxeZ+bAWrTe2otjdzd6U2rxRPcIOtxmDny51JPft7D6J7SblsE6NCzEh0dXVVy6zh3zY0DGpPsVoxsszQMrahw/lb44mqbZ5hRuTA9OSh3FRyYnJ68vB08kjmSMyhpJhk52mJFGlES46NJ6NVhLlvTMRMuk5NmB1wLIeYS+WjVsWBy68VE0ZlxSSb1A734OGwRG1LdEM0jzjGhZZ3Gl+JslUxxOE+BcoDdN0y1+kZsW4oViQbS2V44btQIlvFywE70KGXPlE1ysdKOUsTh89qwTBN/O5lBz438JAfEFePhjnfp1Pi5IUVYqnM895b4O8UhDH2IoSWWKhlUI/jaifwWYFL+9KoxJMSpsYxtRRAEObqYhp/7TKmzjH1FOwJwmwNpvFPyjCsogVayuZxvC9nrOWdRcvOUth6SuFbMY6LjkfCyQlGmD4DL311eFad0+IiGF5jFtgrBaFmqNf3+yJ9kk7D2ytednh3YYCRFOefAy5P+QCfHkSALgFGGWA0BerdRUCxLbCXxPKFz8/6EFcyabz7SIgCQxQkji/8seJHzCBiTEKYDGFKDD//WVuME4hIMcQptE/DK+85ivIvcmlefw=='	
 	armyid = 1
 
 	require "script/battle/BattleModuleRequire"
	BattleModuleRequire.requireAllModules()
 	
 	local bg,music = db_battleConfig_util.getTopShow1BackAndMusic()
	if(bg == nil) then
		bg = BATTLE_CONST.TOPSHOW1_BACKGROUND
	end
	if(music == nil) then
		music = BATTLE_CONST.TOPSHOW1_BACKMUSIC
	end

	BattleMainData.winType = BATTLE_CONST.WINDOW_BOSSS
	BattleMainData.singleBattleResultData = data
	EventBus.regestMediator(require("script/battle/mediator/BattleTopStaticBattleMediator"))
	BattleMainData.useSceneChangeEffect = true

	
 	-- backGround = BATTLE_CONST.TOPSHOW1_BACKGROUND
 	-- backGroundMusic = BATTLE_CONST.TOPSHOW1_BACKMUSIC
 
	BattleMainData.topShowBackGroundStartIndex = 1

	BattleMainData.resetSingleRecordData(
		    										-- "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",
		    										battleString,
		    										callBack,
		    										bg,
		    										music,false,true
		    									)
	EventBus.sendNotification(NotificationNames.EVT_SINGLE_BATTLE_INI,1)
end



-- 顶上战争第2场
-- eJyNVM9PE0EU7myfC9sKda1APHojHgitSPmxGFIJKQ0hhBLjDae7U7phu1u3uwgJUYFEOMDFP8DEcFCvhnjzYtSzJw7qyYM3Y2JISIwJvJldpCVUOexk33zzfd+8N/MmFidtRep5FlOSJBYnikvnGRweHv5RcZbqC8yFx19+flANVmK2gdHbPa2N6p7p2LCTjruObxtAuqjrzrBgWlG4UKJCbcN5YEdlZAyrbggCSeLSMVpBGyXKF3YYIphdrjLUCYI71PIZrO1PEb6iXWhol4BcDihXgHTC2ne1Dh05jX7LClSG358fnsJWfySIACUgwHFZpNgKGysxIBeVCyEWTNeTo53wywp1Eft4Ctt/FOiCAIV1Kzz5unSi+leyQSPcDK96A3UrL5jRZoms7Tp1iXDlkLjTHQPpH8TV16XmFZD+U4GDseYVOMg0q4B0ngo08rZGT7IQmzkjkad6nWF9+tGQyK/HGbzdWeQlabXqUrNGLbmlUCgoxfkJAyKKx6+ilKj4NVMXE0XXNGB9j6q+a83xQL7WZwymbmQMmrmpD/ZnSsW4x2glxRvIphUmK6nedKrFR9rq8/64xRaZBcNdnuNRK1e97dQ8lCupZm3aosvMjSawJ3LMdYIStZSRx9NRyl74p1admhn0Ty+Qq2zRsRbZXKAbiVfoUq4K22/uqbqPfcg7GJLsvm9WJ+ySoxCion5hwbQs/E/yDhcB9m9X0ORh2N1hMOqVgyjCtzIgzmNIjBoAet+CyCi3ygKModo4fjm8qHk8rUnkcKcss/UyzneUzPmyN+64Ovbyp3YiapRG1etyNN0DUi8Yadh8drdP6g/ejAH+VAzxQYPIsdeL1ixIJ1bvZvLwcnryeHv4LnCCponCnEV434MEo44wwgkjGvc/jwNeniE+1KW/8Wq0gbEp57FzOGMK42nYXl8h5Agwdk+t
-- armyid 2
function showTopSecondBattle( callBack )
	 
	battleString = "eJyNlEtP1FAUgOe2hw6dEbGOONGdiQsWxjDlEcUyIUDIQAghDDHu8E57h2notGOnHSEhKhKFRIj/wMSQ+FiaGHZujLh340KIf8ENKyXB+xikA4Nh0abnnPudV8+5iSRqK+AgcIiaQokkUn08R+Dg4GBfo1pszhMfnuz82tYsUiSuRaVP3402bAa258KmnvS90LUApbHvTxOhVlXmqL2MXct76MoKJe5oft0IKEWPjuAyDaPK7GCHxYWZxQqhfoRwFzshgac71xE7cZ77MC4AuiiQS4AuH7MOHLf+rHKrAr9/PDpmW/5jIW6UeKHAjii8ylZYUxKAzqktgmW6KCxT+Fsa/TN+PWGUENJogcMl27GEodF9nLuXo6mJXID747pWeL670CSNhrANBUTQ9fGTERoa82H+kBUxt+vgZmcCpP+Ayx9nImCkptUlDrbUbU27tied3rS9x6d1QDpLBxq59cGjKngyTQp5WYsEjJYv10E2Uk24rWHKpXCl4mO7ih0lns/n1cLcmAUxNWDjK7WXw6ptckXBty1Y2e3WQt+ZZYJyrXA706v3kL5ixix2W704GRBczrClc3GZKGqmS8/EQ4otv+5LOqRGHDDSgRdgJ1cZ9qoBPHtxVbOrUw5eJL7cTscsR3xPtCheohwrRy0F9S+t4lVtsXM6oCuk5jk1Miv8xpJlvJCrwMbWfc0M6e6yrYcUeRDalTG36KlijPPztuPQ7xS7FbhAdz4tLoa62NlhERyUhBRjqfTz/2HwdxaAxh6E2BALNQIwSr3l6DNOB3WC/q1JyrBIQ8Q1S1TfUbTnSsGo55sE3iwh3iKdOr2hyHoXSDpYPbD26l6fdEtcM/3sdjHYKwuxw1BvW0dAOor0eXoC3k1NHmZHrxIGGFnel2bAl5sUsCLAAAMGsiz+WSLQ2THYK1L96vvBhurXlAm6OIyYovI0bKwsIfQXgNRfIw=="
    armyid = 2
 
 	require "script/battle/BattleModuleRequire"
	BattleModuleRequire.requireAllModules()
 
	
	BattleMainData.winType = BATTLE_CONST.WINDOW_BOSSS
	BattleMainData.singleBattleResultData = data
	EventBus.regestMediator(require("script/battle/mediator/BattleTopStaticBattleMediator"))
	BattleMainData.useSceneChangeEffect = false
	BattleMainData.topShowBackGroundStartIndex = 3

	local bg,music = db_battleConfig_util.getTopShow2BackAndMusic()
	if(bg == nil) then
		bg = BATTLE_CONST.TOPSHOW1_BACKGROUND
	end
	if(music == nil) then
		music = BATTLE_CONST.TOPSHOW1_BACKMUSIC
	end


	-- backGround = BATTLE_CONST.TOPSHOW2_BACKGROUND
 -- 	backGroundMusic = BATTLE_CONST.TOPSHOW2_BACKMUSIC
     									 
	
	BattleMainData.resetSingleRecordData(
		    										battleString,
		    										callBack,
		    										bg,
		    										music,false,true
		    									)
	EventBus.sendNotification(NotificationNames.EVT_SINGLE_BATTLE_INI,2)

end


function reset( ... )
	if(BattleState.isPlaying() == true) then
		destroy()
	end
end

function onBattleQuit( ... )
	setIdleState()
	BattleState.setPlaying(false)
	-- CCTexture2D:setDefaultAlphaPixelFormat(originalFormat)
end


-- 停止战斗,目前没有需求
-- todo 
function stopBattle( )
	
end
 
 

