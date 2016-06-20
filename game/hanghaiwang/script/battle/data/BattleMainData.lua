
module("BattleMainData",package.seeall)

 
	------------------ properties ----------------------
	copyId						= 0						-- 副本id
	copyType 					= 1						-- 当前副本类型 -副本类型,1普通，2精英，3活动
	strongholdId				= 0						-- 据点id
	hardLevel					= 0						-- strongHold难度
	activeCopyHardLevel			= 1 					-- 活动副本难度

	strongholdData 				= nil					-- 据点数据
	displayStrongholdData 		= nil 					-- 创建只用于显示人物的stronghold数据
														-- 策划需求:探险战斗人物显示状态要读取人物

	gridData					= nil					-- 网格数据
 
    callbackFunc				= nil					-- 回调

    teamMembersData 			= nil					-- 战斗队伍数据

    totalRound					= 0						-- 总回合数
    currentRound				= 0						-- 当前回合数
  
  	scPlayerFormation			= {}					-- 从服务器获取的阵型分布（位置 ->id？）

  	-- player 						= {}					-- 玩家数据 ：hid，htid

  	selfTeamDisplayData			= nil 					-- 自己队伍的显示数据

  	armyTeamDisplayData 		= nil 					-- 敌军队伍的显示数据

  	background 					= "daohuacun.jpg" 		-- 背景


    -- copy_id  					= nil 					-- 副本id
    -- copyType 					= nil					-- 副本类型
    -- level    					= nil					-- 难度
    -- base_id  					= nil					-- baseid

    csDoBattleFormation 		= nil 					-- 请求战斗时 携带的阵型信息

    fightRecord 				= nil 					-- BattleFightRecordData 
    backGroundStartIndex 		= 0						-- 背景出现位置索引

	revivedTime 				= 0     				--复活次数
	revivedCost 				= 200   				--复活消费

	selfTeamHeroDeadList		= nil 					--队伍人物死亡状态
	
	local isAutoFight	    	= false 					-- 是否是托管

	followRole 					= false					-- 结果是否要以玩家所在队伍为准(玩家在team2的话,那么胜利就是失败)

	skillHandleMap				= {}
	local timeSpeed				= 1 					-- 1,1.5,2
	-- local timeMap   			= {1,2,3}
	bgRealScale 				= nil
	screenScale					= nil
	winType 					= BATTLE_CONST.WINDOW_COPY

	singleBattleResultData 		= nil 				-- 单场战斗结束面板数据

	isMoving 					= nil 				-- 是否在移动过程

	rewardRetList 				= {}

	canSkipBattle 				= true
	canSpeedUp 					= true

	isPlaying					= false

	extra_rewardRet				=nil  --天降宝物

	backgroundInstance 			= nil -- 背景实例

	canJumpBattle 				= false -- 是否可以跳过战斗
	showSkipBattleButton 		= true -- 是否可以跳过战斗

	jumpRefuseTip				= nil -- 拒绝跳过战斗提示

	useSceneChangeEffect 		= true -- 是否使用转场特效

	isEliteCopy					= false -- 是否是精英副本
	isActiveCopy				= false -- 是否是活动副本


	team1LeaderName 			= nil -- 队伍1队长名字
	team2LeaderName 			= nil -- 队伍2队长名字

	replayed 					= false -- 是否重播过(当前战斗)

	copyType 					= -1  	-- 活动副本类型
	
	maxRound 					= nil 	-- 战斗最大回合数


	roundBuffRageCount 			= 0
	roundBuffHpCount			= 0
	effectsMapCount 			= {}

	battleType 					= nil -- 战斗类型(战斗回放用)
	isTeam1ShowedShipInfo 			= false
	isTeam2ShowedShipInfo 			= false
	------------------ functions -----------------------
	function resetEffectsMap( ... )
		effectsMapCount = {}
	end

	function upCountEffectAndGetDelay( effName )
		if(effName == nil) then return end
		
		if(effectsMapCount[effName] == nil) then
			effectsMapCount[effName] = 1
			return 0
		else
			local result = effectsMapCount[effName]
			effectsMapCount[effName] = effectsMapCount[effName] + 1
			if(effectsMapCount[effName]>= 6) then
				effectsMapCount[effName] = 0
			end
			return result * 4
		end
	end
	function downCountEffect( effName )
		if(effName == nil) then return end
		
		if(effectsMapCount[effName] ~= nil and effectsMapCount[effName] > 0) then
			effectsMapCount[effName] = effectsMapCount[effName] - 1
			if(effectsMapCount[effName] <= 0) then
				effectsMapCount[effName] = nil
			end 
		end
	end


	function resetBuffCount( ... )
		roundBuffRageCount=0	
		roundBuffHpCount=0	
	end

	function upRageCount( ... )
		roundBuffRageCount = roundBuffRageCount + 1
		if(roundBuffRageCount >= 6) then
			roundBuffRageCount = 0
		end
	end

	function upHpCount( ... )
		roundBuffHpCount = roundBuffHpCount + 1
		if(roundBuffHpCount >= 6) then
			roundBuffHpCount = 0
		end
	end
	-- 为战斗录像
	function iniBattleMaxRoundFromBattleType( ... )
		if(battleType ~= nil) then
			-- 初始化最大回合数
			if(battleType == BATTLE_CONST.BATTLE_TYPE_COPY_GUIDE) then
				maxRound = db_normal_config_util.getGuideCopyBattleMaxRound()
			elseif(battleType == BATTLE_CONST.BATTLE_TYPE_COPY_EVENT_BELLY) then
				maxRound = db_normal_config_util.getBellyCopyBattleMaxRound()
			else
				maxRound  = BATTLE_CONST.MAX_ROUND
			end
		end

		
	end
	-- 初始化战斗最大回合数参数
	function iniBattleMaxRound()
		if(BATTLE_CONST.WINDOW_GUIDE == winType) then
			maxRound = db_normal_config_util.getGuideCopyBattleMaxRound()
		elseif(BATTLE_CONST.WINDOW_EVENT_BELLY == winType) then
			maxRound = db_normal_config_util.getBellyCopyBattleMaxRound()
		else
			maxRound  = BATTLE_CONST.MAX_ROUND
		end
		
	end

	function releaseData( ... )
		isTeam1ShowedShipInfo  = false
		isTeam2ShowedShipInfo  = false
		
		displayStrongholdData = nil
		fightRecord = nil
		selfTeamDisplayData = nil
		selfTeamHeroDeadList = nil
		skillHandleMap = {}
		scPlayerFormation = {}
		strongholdData = nil
		isMoving = nil
		rewardRet = nil
		rewardRetList = {}
		canSkipBattle = true
		canSpeedUp = true
		isPlaying = false
		showSkipBattleButton = true
		backgroundInstance = nil
		copyId 				 = nil
		copyType 			 = nil
		hardLevel 			 = nil
		strongholdId 		 = nil
		useSceneChangeEffect = true
		isEliteCopy 		 = false
		canJumpBattle 		 = false
		isActiveCopy 		 = false
		copytype 			 = -1
		battleType  		 = nil
		  			 
	end
	-- 获取复活的请求参数
	function getRevivedRequestArgs( hid )
		local args 
		if(copyType==1)then
        	args = Network.argsHandler(strongholdId,hardLevel,hid)
        elseif(copyType==2)then
            args = Network.argsHandler(strongholdId,hid)
        elseif(copyType==4)then
            args = Network.argsHandler(strongholdId,hid)
        else
            args = Network.argsHandler(strongholdId,hardLevel,hid)
        end
        return args
	end

	function playBackGroundMusic( ... )
		local musicName = ""
		if(strongholdData) then
			-- Logger.debug("strongholdData.backgroundMusic:"..strongholdData.backgroundMusic)
			musicName = strongholdData.backgroundMusic
		else
			-- Logger.debug("backgroundMusic:"..backgroundMusic)
			musicName = backgroundMusic
		end
		Logger.debug("playBackGroundMusic:"..musicName)
		if(musicName and musicName ~= "") then
		local  musicURL = BattleURLManager.getBGMusicURL(musicName)
		
			AudioHelper.saveAudioState()
			-- if(AudioHelper.isMusicOn() ~= true) then
			-- 	AudioHelper.setMusic(true)
			-- end
			-- AudioHelper.resumeMusic()

			if(not file_exists( musicURL )) then
				Logger.debug("backGroundMusic is not exist:"..musicURL)
		        -- ObjectTool.showTipWindow( musicName .." 不存在", nil, false, nil)
	        else

		        require "script/module/config/AudioHelper"
		        AudioHelper.playMusic(musicURL)
	        end
	     end
	end
	-- 重置复活次数
	function resetRevived( ... )
		revivedTime = 0
	end
	-- 计数复活次数
	function countRevivedTime( ... )
		revivedTime = revivedTime + 1
		require "script/model/user/UserModel"
	end
	-- 获取复活花费
	function getRevivedCost( ... )
		return  tonumber(-revivedTime*revivedCost)
	end
	--是否是自动战斗
	function isAutoFightNow( ... )
		return isAutoFight 
	end
    -- 复活文字描述
	function getRevivedInfo( ... )
		return "复活需要" .. preGetRevivedCost() .. "贝里"
	end
	-- 复活费用(下次的)
	function preGetRevivedCost( ... )
		return (revivedTime+1)*revivedCost
	end

	function getAutoFightText( )
		if(isAutoFight) then
			return "取消托管"
		end
		return "托  管"
	end
	function autoFightNextState( ... )
		if(isAutoFight) then
			isAutoFight = false
		else
			isAutoFight = true
		end
	end
	function setAutoFight( value )
		isAutoFight = value
	end

	-- 初始化屏幕参数
	function iniScreenParameter( ... )
		-- --print("iniEvn complete1")
		local size 							= CCDirector:sharedDirector():getWinSize()
		-- --print("iniEvn complete2")
		bgRealScale 						= size.width/640
		-- --print("iniEvn complete3")
		BattleGridPostion.initGrid(640 * bgRealScale,bgRealScale)
		
		screenScale 						= MainScene.elementScale
		-- --print("iniEvn complete4")
	end
	function getTimeSpeed( ... )
		return timeSpeed
	end

	function getUidMD5( ... )
		local uid = tostring(UserModel.getUserInfo().uid) or "0"
		return CCCrypto:md5(uid,string.len(uid),false)
	end
	function cacheBattleSpeedUp()
	 
		-- print("-- cache speed to cache:",getUidMD5(),tostring(timeSpeed))
		CCUserDefault:sharedUserDefault():setStringForKey( getUidMD5() .. ":battleSpeed" ,tostring(timeSpeed))
		CCUserDefault:sharedUserDefault():flush()
	end

	-- 从硬盘上读取加速值(会判断合法性)
	function readBattleSpeed( ... )
		-- print("-- cache speed to cache:",getUidMD5(),tostring(timeSpeed))
		local speedInfo = tonumber(CCUserDefault:sharedUserDefault():getStringForKey( getUidMD5() .. ":battleSpeed"))

		local maxSpeed = db_vip_util.speedUpMax()
		-- maxSpeed = 3
		-- 如果缓存最大加速档 小于当前用户最大加速档->第一次开启新加速挡的战斗
		local cacheMaxSpeed = tonumber(CCUserDefault:sharedUserDefault():getStringForKey( getUidMD5() .. ":battleMaxSpeed"))
		-- cacheMaxSpeed = 1
		-- print("------readBattleSpeed ",cacheMaxSpeed,maxSpeed)
		if(cacheMaxSpeed == nil or maxSpeed > cacheMaxSpeed) then
			cacheMaxSpeed = maxSpeed
			-- 如果是第一次max更改,那么我们就将当前速度值改为最大速度挡(策划需求)
			speedInfo = cacheMaxSpeed
			CCUserDefault:sharedUserDefault():setStringForKey( getUidMD5() .. ":battleMaxSpeed" ,tostring(cacheMaxSpeed))
			CCUserDefault:sharedUserDefault():flush()
		end

		-- CCUserDefault:sharedUserDefault():setStringForKey( getUidMD5() .. ":battleMaxSpeed" ,tostring(0))
		-- 	CCUserDefault:sharedUserDefault():flush()
		

		-- print("-- load speed from cache:",getUidMD5(),tostring(speedInfo))
		if(speedInfo == nil) then
			speedInfo = 1
		end

		-- local speedLevel = (speedInfo - 1)/0.5 + 1
		
		-- if(speedInfo > maxSpeed or speedInfo < 1) then
		-- 	speedInfo = maxSpeed
		-- end

		timeSpeed = 3
		cacheBattleSpeedUp()
		-- print("-- readBattleSpeed complete")
	end


	function resetTimeSpeed( ... )
		timeSpeed = 1
	end
	function maxTimeSpeed( ... )
		return 2
	end
	function nextTimeSpeed( ... )
		 local nextSpeed = timeSpeed + 1
		 if(nextSpeed > 3) then
		 	nextSpeed = 1
		 end
		 timeSpeed = nextSpeed
		 return timeSpeed
	end

	function currentSpeedLevel( ... )
		-- return (timeSpeed - 1)/0.5 + 1
		return timeSpeed
	end

	-- function runCompleteCallBack( ... )
	-- 	--print("callbackFunc:",callbackFunc,fightRecord.copyCallBackData,fightRecord.isWin,fightRecord.extra_reward)
	-- 	Logger.debug("runCompleteCallBack:" .. tostring(callbackFunc))
	-- 	 if(callbackFunc ~=nil) then
 -- 			if(fightRecord == nil)  then fightRecord = {} end
 --        	callbackFunc(newcopyorbaseRet,fightRecord.isWin,extra_rewardRet)
 -- 		 	callbackFunc = nil
 -- 		 end
	-- end

	function getCallBackRequest( ... )
		Logger.debug("runCompleteCallBack:" .. tostring(callbackFunc))
		 if(callbackFunc ~=nil) then
 			if(fightRecord == nil)  then fightRecord = {} end
 			local callback = callbackFunc
 			local ret  = newcopyorbaseRet
 			local isWin = fightRecord.isWin
 			local ext = extra_rewardRet
 			callbackFunc = nil
 			return function ( ... )
 				callback(ret,isWin,ext)
 			end
 		 	
 		 end
	end


	-- 是否可以配置阵型
	function canConfigFormation( ... )
		return copyType == BATTLE_CONST.BTYPE_COPY_JY
	end
	-- 是否需要配置阵型
	function needConfigFormation( ... )
		-- return true
		if(copyType == BATTLE_CONST.BTYPE_COPY_JY) then
			return isAutoFight == false
		end
		return false
	end


	function printState()
		if(strongholdData) then

		 	--print("############## StrongHoldMediator 场次 ",strongholdData.index,":",strongholdData.total)
		 	return strongholdData.index .. ":" .. strongholdData.total
	 	end
	 	return "nil"
	end
	-- -- 缓存己方状态:死亡状态 
	-- function cacheBattleSelfState( ... )
	-- 	assert(fightRecord)
	-- 	assert(fightRecord.team1Info)
	-- 	if(selfTeamHeroDeadList) then
	-- 		local map = fightRecord.team1Info:getDeadList()
	-- 		for k,index in pairs(map or {}) do
	-- 			selfTeamHeroDeadList[k] = index
	-- 		end
	-- 	else
	-- 		selfTeamHeroDeadList	= fightRecord.team1Info:getDeadList()
	-- 	end
		
		
	-- 	-- return selfTeamHeroDeadList
	-- end
	-- -- 删除死亡状态
	-- function removeDeadRecord( id )
	-- 	if(selfTeamHeroDeadList) then
	-- 		for k,index in pairs(selfTeamHeroDeadList or {}) do
	-- 			if(index == id) then
	-- 				selfTeamHeroDeadList[k] = nil
	-- 				return 
	-- 			end
	-- 		end
			
	-- 	end
	-- end

	function getBackGroudName( )
		if(strongholdData) then
			return strongholdData.background
		elseif strongholdId and tonumber(strongholdId) > 0 then
			return db_stronghold_util.getBackGroundImageName(strongholdId) 
		else
			return background
		end
	end

	function linkAndRefreshHeroesDisplay( )
		-- if(strongholdData) then

		-- else
		-- 	assert(fightRecord)
		-- 	fightRecord:refreshHeroesDisplay()
		-- end

		fightRecord:linkAndRefreshHeroesDisplay()
	end
	function resetSingleRecordData( data , callback ,backgroundImg,music,follow,jumpBattle,showSkipBattle)
		if(showSkipBattle == nil) then
			showSkipBattleButton  		= true
		else
			showSkipBattleButton 		= showSkipBattle
		end
		readBattleSpeed()
		replayed 					= false
		if(jumpBattle == nil) then
			jumpBattle 				= true
		end
		
		followRole 					= follow or false
		fightRecord 				= require(BATTLE_CLASS_NAME.BattleDataADT).new()
        fightRecord:reset(data)
        if(followRole) then
        	fightRecord:followRole()
        end
        skillHandleMap				= {}
        callbackFunc				= callback
		background 					= backgroundImg
		backgroundMusic 			= music
		strongholdData 				= nil
		canJumpBattle 				= jumpBattle
		
		iniBattleMaxRound()
		iniBattleMaxRoundFromBattleType()
	end
	-- stronghold请求完战斗数据后 刷新战斗数据的接口
	function resetBattleRecordData( data,newcopyorbase,reward,extra_reward)
		-- for k,v in pairs(data) do
		-- 	--print("resetBattleRecordData:",k," value:",v)
		-- end
		newcopyorbaseRet 			= newcopyorbase or {}
		newcopyorbaseRet.normal 	= newcopyorbaseRet.normal or {} -- 打补丁 .norl 

		rewardRet 					= reward
		extra_rewardRet 			= extra_reward
		getScore					= newcopyorbaseRet.getscore or false
		fightRecord 				= require(BATTLE_CLASS_NAME.BattleDataADT).new()
        fightRecord:reset(data)
        skillHandleMap				= {}
        table.insert(rewardRetList,reward)
        cheakData()
        fightRecord:setDropList(reward)
        if(strongholdData and strongholdData:getCurrentArmyData()) then
        	strongholdData:getCurrentArmyData().dataRequested = true
        end
        -- fightRecord:setDropList(getAllReawrdData())
        
	end

	function getTotalRewardHeroPartNum( ... )
		local num = 0
		for _,v in pairs(rewardRetList or {}) do
			if(v.hero ~= nil) then
		 		for key1,heroitem in pairs(v.hero) do
		 			num = num + tonumber(heroitem.num or 0)
		 		end
		 	end
		end
		return num
	end

	function getTotalRewardHeroPartTypeNum( ... )
		local num = 0
		for _,v in pairs(rewardRetList or {}) do
			if(v.hero ~= nil) then
		 		for key1,heroitem in pairs(v.hero) do
		 			if(heroitem.num ~= nil) then
		 				num = num + 1
		 			end
		 		end
		 	end
		end
		return num
	end

	function getTotalRewardItemTypeNum( ... )
		local num = 0
		for _,v in pairs(rewardRetList or {}) do
			if(v.item ~= nil) then
		 		for key1,item in pairs(v.item) do
		 			if(item.item_num ~= nil) then
		 				num = num + 1
		 			end
		 		end
		 	end
		end
		return num
	end

	function getTotalRewardItemNum( ... )
		local num = 0
		for _,v in pairs(rewardRetList or {}) do
			if(v.item ~= nil) then
		 		for key1,item in pairs(v.item) do
		 			num = num + tonumber(item.item_num or 0)
		 		end
		 	end
		end
		return num
	end
	function getAllReawrdData()
		local result = {}
		result.exp 				= 0
		result.silver 			= 0
		result.soul 			= 0
		result.hero    			= {}
		result.item 			= {}
		result.cur_drop_item 	= {}

		for _,v in pairs(rewardRetList) do
		 	if(v.exp ~= nil) then
		 		result.exp = result.exp + v.exp
		 	end

		 	if(v.silver ~= nil) then
		 		result.silver = result.silver + v.silver
		 	end

			if(v.soul ~= nil) then
				result.soul = result.soul + v.soul
		 	end

		 	if(v.hero ~= nil) then
		 		local heroMap = {}
		 		for key1,heroitem in pairs(v.hero) do
		 			if(heroMap[heroitem.htid] ~= nil) then
						result.hero[heroMap[heroitem.htid]].num = result.hero[heroMap[heroitem.htid]].num + tonumber(heroitem.num or 0)
		 			else
						table.insert(result.hero,{htid=heroitem.htid or 0,num = tonumber(heroitem.num or 0)})
						heroMap[heroitem.htid] = #result.hero
		 			end
		 			-- if(result.hero[heroitem.htid] ~= nil) then
		 			-- 	result.hero[heroitem.htid].num = result.hero[heroitem.htid].num + tonumber(heroitem.num or 0)
		 			-- else
		 			-- 	result.hero[heroitem.htid] = {htid=heroitem.htid or 0,num = tonumber(heroitem.num or 0)}
		 			-- end
		 		end
		 	end
		 	
		 	if(v.item ~= nil) then
		 		local itemMap = {}
		 		for key2,oneItem in pairs(v.item) do
		 			if(itemMap[oneItem.item_template_id] ~= nil) then
		 				result.item[itemMap[oneItem.item_template_id]].num = result.item[itemMap[oneItem.item_template_id]].num + tonumber(oneItem.item_num or 0)
		 			else
		 				table.insert(result.item,{item_template_id=oneItem.item_template_id or 0,num = tonumber(oneItem.item_num or 0)})
						itemMap[oneItem.item_template_id] = #result.item
		 				-- result.item[oneItem.item_template_id] = {item_template_id = oneItem.item_template_id or 0,num = tonumber(oneItem.num or 0)}
		 			end
		 		end
		 	end

		 	-- print("===== reward:")
   	-- 		print_table("reward:",v)

		 	if(v.cur_drop_item) then
		 		-- local dropMap = {}
		 		
		 		for item_templ_id,item_num in pairs(v.cur_drop_item) do
		 			if(result.cur_drop_item[item_templ_id] ~= nil) then
		 				result.cur_drop_item[item_templ_id] = result.cur_drop_item[item_templ_id] + tonumber(item_num or 0)
		 			else
		 				result.cur_drop_item[item_templ_id] = tonumber(item_num)
		 			end
		 		end
		 	end
		 	-- print("===== getItem:")
   			-- print_table("getItem:",result)
		 end -- for end
		 return result 
	end

	function cheakData( ... )
		if(fightRecord and strongholdData) then
			local localTeam1 = strongholdData:getCurrentArmyData().selfTeamDataArray
			local team1 = fightRecord.team1Info.list
			
			-- for postion,data in pairs(team1) do
			-- 	if(localTeam1[data.positionIndex] == nil) then
			-- 		for k,v in pairs(localTeam1) do
			-- 			--print("localTeam1:",k,v)
			-- 		end

			-- 		for k,v in pairs(team1) do
			-- 			--print("team1:",k,v)
			-- 		end
					
			-- 		error("前后端数据不一致 armyid:",strongholdData:getCurrentArmyData().id)

			-- 	end
			-- end

			local team2 = fightRecord.team2Info.list
			local localTeam2 = strongholdData:getCurrentArmyData().armyTeamDataArray
				for postion,data in pairs(team2) do
				if(localTeam2[data.positionIndex] == nil) then
					ObjectTool.showTipWindow( "前后端数据不一致 armyid:" .. strongholdData:getCurrentArmyData().id, nil, false, nil)
				end
			end
		end
	end
	-- 获取获得物品数量
	function getRewardItemNum( )
		local count = 0
		if(rewardRet) then
			for _, v in ipairs(tbItem or {}) do
				count = count + 1 
			end
		end
		return count
	end
	-- 当前战斗获得钱
	function getRewarMoney( ... )
		if(rewardRet) then
			 return rewardRet.silver or 0
		end
		return 0
	end
	-- -- 当前战斗获得soul
	-- function getRewarSoul( ... )
	-- 	if(rewardRet) then
	-- 		 return rewardRet.soul or 0
	-- 	end
	-- 	return 0
	-- end
	-- 当前战斗获得经验
	function getRewarExp( ... )
		if(rewardRet) then
			 return rewardRet.exp or 0
		end
		return 0
	end

	function getEnterLevelArgs()
		local args 
			if(copyType== COPY_TYPE_NORMAL)then
	            args = CCArray:create()
	            args:addObject(CCInteger:create(copyId))
	            args:addObject(CCInteger:create(strongholdId))
	            args:addObject(CCInteger:create(hardLevel))
			elseif(copyType == COPY_TYPE_AWAKE) then
				-- string enterBaseLevel ( $copyId, int $baseId)
				args = CCArray:create()
	            args:addObject(CCInteger:create(copyId))
	            args:addObject(CCInteger:create(strongholdId))
				
            elseif (copyType == COPY_TYPE_ECOPY) then
             	args = Network.argsHandler(copyId)         
            elseif (copyType == COPY_TYPE_EVENT or copyType == COPY_TYPE_EVENT_BELLT) then
            	args = Network.argsHandler(copyId,activeCopyHardLevel)
            	print("==getEnterLevelArgs",copyId,activeCopyHardLevel)
            end

        return args
	end -- function end
	-- function resetStrongHold(id)
	-- 	strongholdId 			= id
	-- 	strongholdData			= require("script/battle/data/StrongholdADT").new()
	-- 	strongholdADT:reset(id)
	-- end
 

	function reset( copyid,copytype,strongholdid,level,callback)

		fightRecord 		 = nil
		copyId 				 = copyid
		copyType 			 = copytype
		hardLevel 			 = level
		strongholdId 		 = strongholdid
		callbackFunc		 = callback
        skillHandleMap		 = {}
        selfTeamHeroDeadList = {}
        rewardRetList        = {}
        readBattleSpeed()
        -- local isChallenged 			= DataCache.isStrongHoldChallenged(tonumber(strongholdId),hardLevel)
       
		-- print(" == isChallenged:",self.isChallenged,self.isFirstChallenged)
		-- if(currentStar <= self.hardLevel) then
		-- 普通副本 vip and level
		if(ObjectTool.isNormalCopy(tonumber(copyId))) then
		 	local isChallenged 			= itemCopy.fnGetAttStausByCopyBaseHard(tonumber(strongholdId),hardLevel) --DataCache.isStrongHoldChallenged(tonumber(strongholdId),hardLevel)
			showSkipBattleButton  		= isChallenged
			canJumpBattle 			= db_vip_util.canJumpNormalCopyBattle(isChallenged)
			jumpRefuseTip 			= BATTLE_CONST.LABEL_7
            --普通副本	通关该据点，或达到vip表中normal_skip的配置 
            showSkipBattleButton  	= isChallenged or canJumpBattle
			Logger.debug("canJumpBattle info: is normal copy")
		-- 精英本 vip or level
		elseif(ObjectTool.isEliteCopy(tonumber(copyId))) then
			showSkipBattleButton    = true
			isEliteCopy 			= true
			canJumpBattle 			= db_vip_util.canJumpEliteCopyBattle()
			jumpRefuseTip 			= BATTLE_CONST.LABEL_8
			Logger.debug("canJumpBattle info: is elite copy")
		-- 活动副本类型
		elseif(ObjectTool.isActiveCopy(tonumber(copyId))) then
		    showSkipBattleButton 	= true
			isActiveCopy 			= true
			canJumpBattle 			= db_vip_util.canJumpACopy(tonumber(copyId))
			jumpRefuseTip 			= BATTLE_CONST.LABEL_9
			Logger.debug("--info-- canJumpBattle info: is active copy")
            --活动副本-日常副本	永久显示
            showSkipBattleButton    = true
		else
			showSkipBattleButton 	= false
			canJumpBattle 			= false
            showSkipBattleButton    = canJumpBattle
		end	
		-- showSkipBattleButton    = canJumpBattle
		-- if(isActiveCopy == true) then
			-- showSkipBattleButton = true
		-- end
		-- 如果是觉醒
		if(copyType == COPY_TYPE_AWAKE) then
			isChallenged 			= copyAwakeModel.isACopyChanlage(copyId,strongholdId)
			canJumpBattle 			= isChallenged or db_vip_util.canJumpDCopyBattle(isChallenged)
			jumpRefuseTip 			= BATTLE_CONST.LABEL_10
			showSkipBattleButton 	= canJumpBattle
		end
		-- debug模式随意
		-- canJumpBattle = canJumpBattle --or g_debug_mode
		iniBattleMaxRound()
		iniBattleMaxRoundFromBattleType()
	end

	-- 是否可以加速到下一档
	function canSpeepUpNext( ... )

		 -- debug模式尽情加速
		-- if(g_debug_mode) then return true end

		local maxSpeed = db_vip_util.speedUpMax()
 
	    local nextSpeed = 1
	    local currentSpeedLevel = currentSpeedLevel()

	    -- Logger.debug("== maxSpeed:%d,currentSpeedLevel:%d" , maxSpeed,currentSpeedLevel)
	   
	    if(maxSpeed < 3 and currentSpeedLevel >= maxSpeed) then
	    	 return false	
	    end

	    return true
	end

	function createStrongHoldData()
		strongholdData 		= require("script/battle/data/BattleStrongHoldData").new()
        strongholdData:reset(strongholdId,hardLevel)
        backGroundStartIndex = strongholdData.startIndex
        refreshBattleTeamDisplayData()

	end

	-- 创建只用于显示人物的stronghold数据
	function createDisplayStrongHoldData( strongholdId,hardLevel,battleIndex)
		
		
		displayStrongholdData 		= require("script/battle/data/BattleStrongHoldData").new()
        displayStrongholdData:reset(strongholdId,hardLevel,battleIndex)
        -- backGroundStartIndex = displayStrongholdData.startIndex
        refreshBattleTeamDisplayData()

	end
	
	-- -- 刷新自己队伍成员信息(因为阵型可以配置)
	-- function refreshSelfTeamInfo()
	-- 	if(strongholdData) then
	-- 		strongholdData:getCurrentArmyData():refresh()
	-- 	-- else

	-- 	end
	-- 	-- refreshBattleTeamDisplayData()
	-- end

	function refreshBattleTeamDisplayData( )
		if(strongholdData) then
			assert(strongholdData)
			--print("refreshBattleTeamDisplayData strongholdData")
			-- 和阵型数据同步
			if(strongholdData) then
				strongholdData:getCurrentArmyData():refresh()
			end


		  	selfTeamDisplayData = strongholdData:getCurrentArmyData().selfTeamDataArray
		  	armyTeamDisplayData = strongholdData:getCurrentArmyData().armyTeamDataArray
		
		-- 如果是探索
		elseif(displayStrongholdData) then
			-- 和阵型数据同步
			if(displayStrongholdData) then
				displayStrongholdData:getCurrentArmyData():refresh()
			end



			if(fightRecord) then
				selfTeamDisplayData = fightRecord.team1Info:getCardDisplayDataList()
			else
				selfTeamDisplayData = displayStrongholdData:getCurrentArmyData().selfTeamDataArray
			end


		  	-- selfTeamDisplayData = displayStrongholdData:getCurrentArmyData().selfTeamDataArray
		  	armyTeamDisplayData = displayStrongholdData:getCurrentArmyData().armyTeamDataArray

		else
			--print("refreshBattleTeamDisplayData fightRecord")
			assert(fightRecord)
			selfTeamDisplayData = fightRecord.team1Info:getCardDisplayDataList()
			armyTeamDisplayData = fightRecord.team2Info:getCardDisplayDataList()
		end
	end
 	



	function getTargetData( id )
		if fightRecord ~= nil then 
			return fightRecord:getTargetData(id)
		end
	end

	function isTeam1PostionHasPerson(p)
		local result = fightRecord:isTeam1PostionHasPerson(p)
		--print("isTeam1PostionHasPerson:",p," result:",result)
		return result
	end
	
	function isTeam2PostionHasPerson(p)
		local result = fightRecord:isTeam2PostionHasPerson(p)
		--print("isTeam2PostionHasPerson:",p," result:",result)
		return result
	end


	-- 获取攻击对应难度
	function getCSEnterLevelRequestData()
  ---[[
  			local args  = CCArray:create()
  			if(copyType==1)then
		        args:addObject(CCInteger:create(copyId))       
		        args:addObject(CCInteger:create(strongholdId))
		        args:addObject(CCInteger:create(hardLevel))
            elseif copyType==2 then
              args 		= Network.argsHandler(copyId)
            elseif copyType==4 then
              args 		= Network.argsHandler(copyId)
            else
              args 		= Network.argsHandler(copyId,strongholdId)
            end

        return args
	end	-- function end


	function getDoBattleData()

		assert(strongholdData)
		assert(strongholdData:getCurrentArmyData())
		local args = CCArray:create()

		local formation = CCDictionary:create()

		-- local formation = CCArray:create()
		local isNpc 	= strongholdData:getCurrentArmyData().isNpc
		local armyid    = strongholdData:getCurrentArmyData().id
		if(isNpc ~= true) then
			 	
				-- 2016.1.13 因为暂时不会有修改阵型的功能,所以这里不再提供修改
				-- 此处由于修改了战斗流程(据点的),导致阵型填充数据出现了问题(hid为0)
				-- 如果要开启改变阵型功能,请解决这个问题
				
				-- 2016.2.1 策划就是这么多变,又该回去了
				-- 云鹏那边也回忆不起 hid为零引发的为题了 囧
				
			 	local fData 
			 	local changed = BattleTeamDisplayModule.isFormationChanged()
			 	if(changed == true) then
			 		-- print("========formation change=========")
			 		fData= BattleTeamDisplayModule.getFormationRequestData()

				    for i=0,5 do
				         local hid = tonumber(fData[tostring(i)])--scPlayerFormation[i]
				         -- print("setFormation:",i,hid)
				          if hid and hid > 0 then
				         	-- formation:addObject(CCString:create(hid));
				         	formation:setObject(CCInteger:create(hid), "" .. i)
				          else
				          	fData[tostring(i)] = nil
				          end
				    end

				    FormationModel.setFormationInfo(fData)
			    end

				if(copyType==COPY_TYPE_NORMAL)then
							
							args:addObject(CCInteger:create(copyId))
							args:addObject(CCInteger:create(strongholdId))
							args:addObject(CCInteger:create(hardLevel))
							args:addObject(CCInteger:create(armyid))
							if(changed == true) then
								args:addObject(formation)
							end
				elseif(copyType == COPY_TYPE_AWAKE) then
				-- array doBattle ( $copyId, int $baseId, int $armyId)
					args:addObject(CCInteger:create(copyId))
					args:addObject(CCInteger:create(strongholdId))
					args:addObject(CCInteger:create(armyid))
					
			    elseif(copyType==COPY_TYPE_ECOPY)then
			        args = Network.argsHandler(copyId,armyid)
			        if(changed == true) then
			        	args:addObject(formation)
			        end
			    elseif(copyType==COPY_TYPE_EVENT or
			    	   copyType==COPY_TYPE_EVENT_BELLT)then

			        args = Network.argsHandler(copyId,activeCopyHardLevel,armyid)
			        if(changed == true) then
			        	args:addObject(formation)
			    	end
			    else
			    	error("BattleDataproxy: wrong copytype:" .. tostring(copyType))
				end -- if end
		-- 是npc队伍
		else 	
				Logger.debug("----- team is NPC  armyid:" .. tostring(armyid) .. "  copyid:"..tostring(copyId))
				formation = CCArray:create()

				args:addObject(CCInteger:create(copyId))

			    args:addObject(CCInteger:create(strongholdId))
			    args:addObject(CCInteger:create(hardLevel))
			    args:addObject(CCInteger:create(armyid))
			    -- CCLuaLog("copy_id = " .. m_copy_id .. " base_id = " .. m_base_id .. " level = " .. m_level .. "army_id = " .. m_currentArmyId)
			    args:addObject(CCArray:create())

			    -- 后端说 :npc不用传阵型 -> 骗纸... 不传报错ToT
			    local selfNpc = strongholdData:getCurrentArmyData().selfNpcToServerArray
				-- CCLuaLog("is npc team:".. selfNpc)

				for i=0,5 do
			       local hid = selfNpc[i]
			       formation:addObject(CCInteger:create((hid or 0)))
			    end
			    --print_table("tb",formation)
			    args:addObject(formation)

		end
	   
 
    

	return args

	end

	function restGridData( bgWidth ,bgScale )
		
		gridData 				= BattleGridPositon
	end
