
 
-- demon 	魔王(2倍黑卡,三国遗留,暂时不用)
-- boss  	2x2的boss
-- outLine 	3x3无边框卡牌

local BattleObjectCardUIData = class("BattleObjectCardUIData")
 
	------------------ properties ----------------------
	BattleObjectCardUIData.backImgURL					= nil				--	背景图片(可能为nil)
	BattleObjectCardUIData.heroImgURL					= nil				--	英雄图像URL
	BattleObjectCardUIData.heroImgName					= nil				-- 	英雄图像名
	BattleObjectCardUIData.imgOffset 					= nil 				--  英雄图像偏移量 {x,y}
	-- 不用背景阴影了,可以节省内粗你和 drawcall
	-- BattleObjectCardUIData.backShadowURL				= nil				--	背景阴影(可能为nil)

	BattleObjectCardUIData.rageHead						= nil				--	怒气头像图片
	BattleObjectCardUIData.isBigCard					= nil				--  是否使用大牌

	BattleObjectCardUIData.isDemon						= nil				--	是否是魔王   (从team中读取）
	BattleObjectCardUIData.isBoss						= nil				-- 	是否是boss  (从team中读取）
	BattleObjectCardUIData.isOutline					= nil				--	是否不用卡牌 (从team中读取）
	BattleObjectCardUIData.isSuperCard					= nil				--	是否超级卡牌 (从team中读取）

 	BattleObjectCardUIData.cardGrade 					= nil					--	品质

 	BattleObjectCardUIData.hpBarBaseName				= nil				--	人物血条底名字
 	BattleObjectCardUIData.hpBarProgressName			= nil				--	进度条皮肤

 	BattleObjectCardUIData.printDebug					= nil
 	BattleObjectCardUIData.teamId 						= nil 				--	队伍id
 	BattleObjectCardUIData.rawPostion 					= nil				--  位置
	BattleObjectCardUIData.positionIndex 				= nil 				--  位置所以in
	BattleObjectCardUIData.zOder 						= nil
	BattleObjectCardUIData.hid 							= nil				--
	BattleObjectCardUIData.htid							= nil
	BattleObjectCardUIData.name 						= nil
 	BattleObjectCardUIData.nameColor		= nil -- 名字颜色(cc3)
 	BattleObjectCardUIData.cardSizeType						= nil 				-- 牌大小类型
	------------------ functions -----------------------
	function BattleObjectCardUIData:ctor()
		self.cardGrade 		= 0
		self.isBigCard 		= false
		self.isDemon 		= false
		self.isBoss 		= false
		self.isOutline 		= false
		self.printDebug 	= false
		self.isSuperCard 	= false
 	end
	-- function BattleObjectCardUIData:reset(hid,htid,isBoss,isDemon,isOutline)
	function BattleObjectCardUIData:resetFromData( data ,team)
		self:reset(tonumber(data.hid),tonumber(data.htid),tonumber(data.position),team)
	end
	function BattleObjectCardUIData:toString()
		return " htid:" .. self.htid.." img:" .. self.heroImgName .. "  url:" .. tostring(self.heroImgURL)
	end
	function BattleObjectCardUIData:refreshName( ... )
		self.name 										= BattleDataUtil.getHeroName(self.hid,self.htid,self.teamId)
		assert(self.name,self.hid .. "," .. self.htid .. " name is nil")
	end
	function BattleObjectCardUIData:reset(hid,htid,postion,teamid,name)
		-- Logger.debug("== BattleObjectCardUIData heroName:" .. tostring(name))
		--print("BattleObjectCardUIData:reset hid:",hid," htid:",htid, " postion:",postion," teamid:",teamid)
		-- local objectTeamdata 							= BattleMainData.strongholdData:getObjectTeamData(teamid,postion)
		-- if objectTeamdata == nil then
		-- 	objectTeamdata = {}
		-- end
		self.hid 										= hid
		self.htid 										= htid
		self.positionIndex 								= tonumber(postion)

		self.teamId 									= teamid
		self.name 										= BattleDataUtil.getHeroName(self.hid,self.htid,self.teamId)
		-- assert(self.name,self.hid .. "," .. self.htid .. " name is nil")
		if self.teamId == BATTLE_CONST.TEAM2 then
		
			self.rawPostion			= BattleGridPostion.getEnemyPointByIndex(self.positionIndex)
			--print("-------- TEAM2:",self.teamId," pIndex:",self.positionIndex, " postion:",self.rawPostion.x," ",self.rawPostion.y)
		else
			self.rawPostion			= BattleGridPostion.getPlayerPointByIndex(self.positionIndex)
			--print("-------- TEAM1:",self.teamId," pIndex:",self.positionIndex, " postion:",self.rawPostion.x," ",self.rawPostion.y)
		end
		self.zOder = self.teamId * 20 + self.positionIndex

		if self.teamId == BATTLE_CONST.TEAM1 then

		else
			self.hpBarBaseName							= nil
			self.hpBarProgressName						= nil
		end


		-- self.isBoss = true
		-- 如果是boss 或者 是 魔王 则使用大牌模式(2x2)
		if self.isBoss == true or self.isDemon == true then 
			self.isBigCard								= true
		else
			self.isBigCard								= false
		end
		
		-- Logger.debug(self.hid .. " ,htid= ".. self.htid .."  ".. tostring(self.isBoss) )
		-- if(self.isBigCard ) then
		-- 	Logger.debug(self.hid .. " ,htid= ".. self.htid .." isBigCard:true")
		-- end
		--牌身等级
		self.cardGrade = 0
		-- 如果是无边框
		if self.isOutline == true then
			self.cardGrade								= BATTLE_CONST.CARD_DEMON_GRADE
		else
			self.cardGrade 								= BattleDataUtil.getGrade(hid,htid)
		end

		self.nameColor									= BattleDataUtil.getGradeColor(self.cardGrade)
		-- self.backImgURL									= BattleURLManager.getCardPathImageURL(self.cardGrade ,false,false,true)
		-- if self.isOutline == false then 
		-- 		self.backShadowURL						= BattleURLManager.getCardShadowURL(self.isBigCard)
		-- else
		-- 		self.backShadowURL						= nil
		-- 		self.backImgURL							= nil
		-- end
		-- 	local printaction =  self.printDebug and --print("														")
		-- local printaction =  self.printDebug and --print("----------------------------------------------------------------------------------------------------------")
		-- print("---- carddisplay : ",self.hid , " htid= ", self.htid ,"isboss:", tostring(self.isBoss) ,"isOutline:",self.isOutline,"isDemon:",self.isDemon )
 		
 		self.heroImgName								= BattleDataUtil.getActionImage(hid,htid,self.isBoss,self.isOutline,self.isSuperCard)
		-- -- print("--------- ",self.heroImgName)
		-- if self.teamId == BATTLE_CONST.TEAM2 then
		-- 	self.isBigCard = true
		-- 	self.isSuperCard = false --false
		-- 	self.isOutline = false
		-- 	-- self.heroImgName = "body_elite_jiaxishen.png"
		-- end
		self.backImgURL									= BattleURLManager.getCardPathImageURL(self.cardGrade ,self.isBigCard,self.isOutline,self.isSuperCard)
		
		
		self.cardSizeType = 1
		if(self.isBigCard == true ) then
			self.cardSizeType = 2
		end

		if(self.isSuperCard == true) then
			self.cardSizeType =3
		end

		if(self.isOutline == true) then
			self.cardSizeType = 4
		end

		
		self.imgOffset 									= db_hero_offset_util.getHeroImgOffset(self.heroImgName,self.cardSizeType)
		-- local printaction =  self.printDebug and --print("-----------------------------------------------------heroImgName:",self.heroImgName)
		assert(self.heroImgName,"英雄动作为空:htid "..htid .. " isboss:" .. tostring(self.isBoss == true) .. " isOutline:" .. tostring(self.isOutline == true))
		
		self.heroImgURL									= BattleURLManager.getActionImageURL(self.heroImgName,self.isBigCard,self.isOutline,self.isSuperCard)


		-- self.heroImgURL									= BattleURLManager.getActionImageURL(self.heroImgName,self.isBigCard,self.isOutline,true)
		-- print("--------- carddisplay end  ---------")
		-- print("---------  				  ---------")
		-- local printaction =  self.printDebug and --print("-----------------------------------------------------object:",hid," htid:",htid," postion:",postion," teamid:",teamid)
		-- local printaction =  self.printDebug and --print("-----------------------------------------------------cardGrade：",self.cardGrade," isBigCard:",self.isBigCard," isOutLine:",self.isOutline," isBoss:",self.isBoss)
		-- local printaction =  self.printDebug and --print("-----------------------------------------------------heroImgURL:",self.heroImgURL)
		-- local printaction =  self.printDebug and --print("-----------------------------------------------------backImgURL:",self.backImgURL)
		-- -- local printaction =  self.printDebug and --print("-----------------------------------------------------backShadowURL:",self.backShadowURL)
		-- local printaction =  self.printDebug and --print("----------------------------------------------------------------------------------------------------------")
		-- local printaction =  self.printDebug and --print("														")
	end
return BattleObjectCardUIData
