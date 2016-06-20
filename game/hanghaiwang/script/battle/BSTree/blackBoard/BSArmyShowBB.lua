
require (BATTLE_CLASS_NAME.class)
local BSArmyShowBB = class("BSArmyShowBB",require(BATTLE_CLASS_NAME.BSBlackBoard))
   
  	------------------ properties ----------------------
  	BSArmyShowBB.des 							= "BSArmyShowBB"
  	BSArmyShowBB.index							= nil -- 战斗当前场次
  	BSArmyShowBB.total							= nil -- 战斗总场次

  	BSArmyShowBB.showTalk						= false -- 是否播放对话

  	BSArmyShowBB.showEffect1 					= nil -- 第一个显示特效名字
  	BSArmyShowBB.showEffect2					= nil -- 第二个显示特效名字

  	BSArmyShowBB.showStyle 						= nil -- 出现方式
  	
  	BSArmyShowBB.team1Members					= nil -- 队伍1成员(position->BattleObjectCardUIData)
  	BSArmyShowBB.team2Members					= nil -- 队伍2成员(position->BattleObjectCardUIData)
  	
  	-- todo 看看对话改变是什么时候
  	BSArmyShowBB.afterTalkBackGround 			= nil -- 对话后背景改变为

  	BSArmyShowBB.startTalk 						= nil -- 开始前对话
  	--BSArmyShowBB.completeTalk					= nil -- 战斗结束对话
  	
  	BSArmyShowBB.team2Boss						= nil -- team2的boss列表		(position->BattleObjectCardUIData)
  	BSArmyShowBB.team2Soldiers					= nil -- team2除boss外的小兵	(position->BattleObjectCardUIData)	

  	BSArmyShowBB.team1Show						= nil -- team1再显示列表 (position->BattleObjectCardUIData)



  	BSArmyShowBB.talk1							= nil -- 对话1
  	BSArmyShowBB.talk2 							= nil -- 对话2
  	BSArmyShowBB.talk3 							= nil -- 对话3

  	BSArmyShowBB.team2SpecifyBoss				= nil -- team2指定的boss 				(position->BattleObjectCardUIData)
  	BSArmyShowBB.team2BossExceptSpecial			= nil -- team2中除了指定boss之外的boss		(position->BattleObjectCardUIData)

  	BSArmyShowBB.backGrounds 					= nil 
 	BSArmyShowBB.strongHoldName 				= nil

 	-- todo 看看这两个参数怎么传进来(放到armyData中?stronghold中)
 	BSArmyShowBB.currentNum						= nil
 	BSArmyShowBB.totalNum 						= nil

 	-- todo 这两个参数从maindata中获取?
 	BSArmyShowBB.moveTime						= nil
 	BSArmyShowBB.moveDistence					= nil
 	-- 延迟时间
 	BSArmyShowBB.delayTime 						= 0.2
  	------------------ functions -----------------------
  	function BSArmyShowBB:reset( armyData ,lastArmayData)
 	  	self.index								= armyData.index
 	  	self.total 								= armyData.total

 	  	self.strongHoldName						= BattleMainData.strongholdData.displayName

 	  	self.showTalk 							= BattleMainData.strongholdData.isFirstChallenged == true

 	  	self.showEffect1 						= BATTLE_CONST.BSE_EFFECT1
 	  	self.showEffect2						= BATTLE_CONST.BSE_EFFECT2
 	  	-- 出场方式
 	  	self.showStyle 							= armyData.playerShowWay
 	  	-- 背景
 	  	self.backGrounds						= {}
 	  	local mediator = EventBus.getMediator("BattleBackGroundMediator")
 	  	assert(mediator)
 	  	self.backGrounds 						= mediator.img
 	  	-- if(mediator.backImg1) then
 	  	-- 	table.insert(self.backGrounds,mediator.backImg1)
 	  	-- else
 	  	-- 	error("BSArmyShowBB:reset  backGround is nil")
 	  	-- end
 	  	-- if(mediator.backImg2) then
 	  	-- 	table.insert(self.backGrounds,mediator.backImg2)
 	  	-- end

 
 	  	-- 当前对战索引
 	  	self.currentNum 						= BattleMainData.strongholdData.index
 	  	-- 总所索引
 	  	self.totalNum 							= BattleMainData.strongholdData.total

 	  	-- 没有值就按默认值
 	  	if(self.showStyle == nil) then self.showStyle = 0 end
 	  	if(self.showStyle > 2) then error("BSArmyShowBB:reset  showStyle is:",self.showStyle," not support") end


 	  	-- 队伍显示对象
 	  	self.team1Members 						= BattleTeamDisplayModule.selfDisplayListByPostion
 	  	self.team2Members						= BattleTeamDisplayModule.armyDisplayListByPostion

 	  	-- 移动时间
 	  	self.moveTime							= BATTLE_CONST.HERO_MOVE_COST_TIME
 	  	-- 移动距离
 	  	self.moveDistence 						= BattleMainData.moveDistence
 	  	--print("BSArmyShowBB:reset moveDistence:",self.moveDistence)
 	  	-- 对话后
 	  	self.afterTalkBackGround 				= armyData.afterTalkBackGround
 	  	self.startTalk							= armyData.startTalkid
 	  	--self.completeTalk						= armyData.completeTalkid
 
 	 	-- 获取boss的显示列表
 	 	if(armyData.armyTeamBosses) then
 	  	 		self.team2Boss 					= {}
 	  		 	self:fillDisplaysFromCardUIDataes(armyData.armyTeamBosses,self.team2Boss,self.team2Members)
 	  	else
 	  			self.team2Boss 					= nil
 	  	end

 	  	-- 获取小兵显示列表	 
 	  	if(armyData.armyTeamSoldiers) then
 	  	 		self.team2Soldiers 				= {}
 	  		 	self:fillDisplaysFromCardUIDataes(armyData.armyTeamSoldiers,self.team2Soldiers,self.team2Members)
 	  	else
 	  			self.team2Soldiers 				= nil
 	  	end

 	  	-- 获取 己方新上场的人
 	  	if(lastArmayData) then 
 	  		-- --print("BSArmyShowBB:reset ->lastArmayData")

 	  		-- lastArmayData:printSelfNpcList()
 	  		-- --print("									")
 	  		-- --print("BSArmyShowBB:reset ->lastArmayData")
 	  		-- armyData:printSelfNpcList()

 	  		
 	  		self.team1Show 						= {}
	 	  	for k,v in pairs(armyData.selfNpcList or {}) do
	 	  		-- 如果上一场没有该英雄
	 	  		if(lastArmayData:team1HasActionId(v.heroImgName) == false and 
	 	  			BattleMainData.strongholdData:isExtraNPCHasHeroImgName(v.heroImgName) == false) then
	 	  			-- 插入新队员
	 	  			--print("上一场没有:",v.heroImgName)
	 	  			self:fillDisplayFromCardUIData(v,self.team1Show,self.team1Members)
	 	  		end	
	 	  	end
	 	  	-- 没有数据就删了
	 	  	if(#self.team1Show == 0) then self.team1Show = nil end
	 	end

	 	if(self.showStyle == 2) then
	 		self.moveDistence = -self.moveDistence 
	 	end
	 	--[todo] 看了下配置表只配置了0,1两种
	 	-- -- 根据显示类型,初始化参数

	 	-- local showWayPara  								= armyData.showWayPara
	 	-- if		(self.showStyle == 0 or  -- 正常出现
	 	-- 		 self.showStyle == 1 or  -- 闪光出现
	 	-- 		 self.showStyle == 2 ) then -- 怪物主动出现 
	 	-- 		-- nothing to do :)

	 	-- elseif	(self.showStyle == 3) then --原地Boss先出现然后对话然后小怪出现 
	 	-- 	-- 对话
	 	-- 	if(showWayPara) then
	 			
	 	-- 		if(showWayPara[2]) then
			-- 		self.talk1 								= tonumber(showWayPara[2])
			-- 	end

			-- 	if(showWayPara[3]) then
			-- 		self.talk2 								= tonumber(showWayPara[3])
			-- 	end
			-- end
	 	
	 	-- elseif	(self.showStyle == 4) then --原地Boss出现然后撤退然后对话然后出现小怪
	 	-- 	-- 对话
	 	-- 	if(showWayPara) then

	 	-- 		if(showWayPara[2]) then
			-- 		self.talk1 								= tonumber(showWayPara[2])
			-- 	end

			-- 	if(showWayPara[3]) then
			-- 		self.talk2 								= tonumber(showWayPara[3])
			-- 	end

			-- 	if(showWayPara[4]) then
			-- 		self.talk3 								= tonumber(showWayPara[4])
			-- 	end
			-- end
	 	
	 	-- elseif	(self.showStyle == 5) then --原地Boss出现然后变身然后出现小怪
	 	-- 	-- 对话
	 	-- 	if(showWayPara) then
	 			
	 	-- 		if(showWayPara[3]) then
			-- 		self.talk1 								= tonumber(showWayPara[3])
			-- 	end

			-- 	if(showWayPara[4]) then
			-- 		self.talk2 								= tonumber(showWayPara[4])
			-- 	end

			-- 	if(showWayPara[5]) then
			-- 		self.talk3 								= tonumber(showWayPara[5])
			-- 	end
			-- end
			-- -- 必要参数
			-- if(showWayPara[2] == nil or showWayPara[2] == "") then 
			-- 	error("BSArmyShowBB:reset,army id:,[",armyData.id,"]-> appear_style is not right,we need first show targets")
			-- end
			-- -- 获取特殊指定的boss
			-- local specials = lua_string_split(showWayPara[2],",")
			-- self.team2SpecifyBoss 						= {}
			-- for k,hid in pairs(specials or {}) do
			-- 	local target  = armyData:indexTeam2ByHid(tonumber(hid))
			-- 	if(target == nil ) then
			-- 	 	error("BSArmyShowBB:reset,army id:,[",armyData.id,"]  from appear_style[2] can't find:",tonumber(hid))
			-- 	else
			-- 		self:fillDisplayFromCardUIData(target,self.team2SpecifyBoss,self.team1Members)
			-- 		-- table.insert(self.team2SpecifyBoss,target)
			-- 	end

			-- end
			-- -- 获取非指定的boss
			-- self:getBossLeft(armyData)

	 	-- else
	 	-- 	error("BSArmyShowBB:reset showStyle is error value:",self.showStyle)
 		-- end -- if end
 	end -- function end


 	function BSArmyShowBB:fillDisplaysFromCardUIDataes(fromList,to,allDisplays)
 		for k,from in pairs(fromList) do
 			 self:fillDisplayFromCardUIData(from,to,allDisplays)
 		end
 	end

 	function BSArmyShowBB:fillDisplayFromCardUIData(from,to,allDisplays)

		if(from.positionIndex and 
		   allDisplays[from.positionIndex]) then
			table.insert(to,allDisplays[from.positionIndex])
		else
			error("armyData has hero:",from.hid," but battle data not contain it")
		end
 	end



 	function BSArmyShowBB:getBossLeft( armyData )
 		self.team2BossExceptSpecial  	 = {}
 		local  list  = {}
 		for k,cardData in pairs(self.team2SpecifyBoss or {}) do
 			list[tostring(cardData.hid)] = 1
 		end

 		for k,cardData in pairs(self.team2Boss or {}) do
 		 	if(list[tostring(cardData.hid)] == nil) then
 		 		self:fillDisplaysFromCardUIDataes(cardData,self.team2BossExceptSpecial,self.team2Members)
 		 		table.insert(self.team2BossExceptSpecial,cardData)
 		 	end
 		end
 	end
 	function BSArmyShowBB:release()
 		
 	end
return BSArmyShowBB