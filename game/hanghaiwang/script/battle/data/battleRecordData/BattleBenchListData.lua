
-- 战斗替补数据
local BattleBenchListData = class("BattleBenchListData")


 
	------------------ properties ----------------------
	BattleBenchListData.list 					= nil
	BattleBenchListData.BENCH_KEY 				= "arrBench"
	BattleBenchListData.teamid					= nil
	BattleBenchListData.num						= nil
	------------------ functions -----------------------
	function BattleBenchListData:release( ... )
		for k,targetData in pairs(self.list or {}) do
			targetData:release()
		end
		self.list = {}
		self.num = 0
	end
	function BattleBenchListData:reset( data ,teamid)
		self.teamid = teamid
		if(data[self.BENCH_KEY] ~= nil) then
			self.list = {}
			self.num = 0
			for k,heroData in pairs(data[self.BENCH_KEY] or {}) do
				 local hero = require(BATTLE_CLASS_NAME.BattleObjectData).new()
				 -- table.insert(self.list,hero)
				 hero:reset(heroData,teamid,true)
				 self.list[tonumber(hero.id)] = hero
				 self.num = self.num + 1
			end
		else
			self.list = nil

		end
	end
	-- 获取可用替补数量
	function BattleBenchListData:getAliveNum( ... )
		local result = 0
		for k,targetData in pairs(self.list or {}) do
			if( targetData:isDead() == false) then
				result = result + 1
			end
		end
		return result
	end
	function BattleBenchListData:indexByHid( value )
		if(self.list) then return self.list[tonumber(value)] end
	end

	function BattleBenchListData:getDisplayList( ... )
 		local result = {}
 		for k,targetData in pairs(self.list or {}) do
 			-- local info = {}
 			-- info.isDead = targetData:isDead()
 			-- 获取英雄等级背景图
 			-- 获取英雄头像
 			-- ???
 			-- info.imgURL = 
 			local db_hero 		= DB_Heroes.getDataById(tonumber(targetData.htid))
			local sHeadIconImg	= "images/base/hero/head_icon/" .. db_hero.head_icon_id
			local grade 		= BattleDataUtil.getGrade(targetData.id,targetData.htid)
			local gradeName 	= "officer_" .. grade .. ".png"
			local bgURL  		= BattleURLManager.getBenchIconBG(gradeName)
			if(not file_exists(bgURL)) then
				error("替补资源头像不存在:" .. tostring(gradeName))
				return 
			end
 			table.insert(result,{id=targetData.id,headURL=sHeadIconImg,bgURL=bgURL,isDead=targetData:isDead()})
 		end
 		return result
 	end
return BattleBenchListData
