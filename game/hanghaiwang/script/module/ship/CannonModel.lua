-- FileName: CannonModel.lua
-- Author: 
-- Date: 2014-04-00
-- Purpose: function description of module
--[[TODO List]]

module("CannonModel", package.seeall)


-- UI控件引用变量 --

-- 模块局部变量 --
local _allCannonAndBall = {}
local _cannonFightValue = 0

local function init(...)

end

function destroy(...)
	package.loaded["CannonModel"] = nil
end

function moduleName()
    return "CannonModel"
end


function getCannonFightValue( ... )
	return _cannonFightValue
end

-- 获取炮所有的信息
function getAllCannonAndBallInfo( ... )
	return _allCannonAndBall
end


function setAllCannonAndBallInfo( allCannon )
	logger:debug("setAllCannonAndBallInfo")
	-- _allCannonAndBall = allCannon
	table.hcopy(allCannon, _allCannonAndBall)
	_allCannonAndBall.unuse_bullet = {}
	for k, bid in pairs(allCannon.unuse_bullet) do
		table.insert(_allCannonAndBall.unuse_bullet, tonumber(bid))
	end
	logger:debug(_allCannonAndBall)
end

-- 获取所有炮的信息
function getAllCannon( ... )
	return _allCannonAndBall.gun_bar_info
end

-- 获取所有使用中的的炮弹信息
function getAllUsedCannonball( ... )
	local use_bullet = {}
	for cannontid,cannonInfo in pairs(_allCannonAndBall.gun_bar_info or {}) do
		if (tonumber(_allCannonAndBall.gun_bar_info[2]) ~= 0) then
			local usedCannonballId = tonumber(_allCannonAndBall.gun_bar_info[2])
			table.insert(use_bullet,usedCannonballId)
		end
	end
	return use_bullet
end

-- 获取所有未使用的炮弹信息
function getAllUNusedCannonball( ... )
	return _allCannonAndBall.unuse_bullet
end

-- 通过itemid查找datacache中的 炮的信息
function getCannonInfoById( cannonId )

	for cannontid,cannonInfo in pairs(_allCannonAndBall.gun_bar_info or {}) do
		if (tonumber(cannontid) == tonumber(cannonId)) then
			return cannonInfo
		end
	end

end

-- 获取主船激活的炮弹
function getActiveBullet( shipId )
	return DB_Super_ship.getDataById(tonumber(shipId)).shell_id
end


--  通过炮弹的id查找datacache中的 炮的信息
function getCannonInfoByBallId( ballId )
	local _,cannnonId = ShipBulletBagModel.isBulletLoad(ballId)
	if (cannnonId and tonumber(cannnonId) ~= 0) then
		 return getCannonInfoById(cannnonId)
	end
	return 0
end

-- 设置炮的强化等级
function setCannonReinforceLevelBy( cannonId,newLel )
	for cannontid,cannonInfo in pairs(_allCannonAndBall.gun_bar_info or {}) do
		if(tonumber( cannontid ) == tonumber(cannonId)) then
			cannonInfo[1] = tonumber(newLel)
			break
		end
	end
end

-- 更换或者卸下炮弹 cannonBallId 为0 为卸下
function setCannonBallBy( cannonId,loadCannonBallId )
	local oldBulletId = ShipBulletBagModel.getBulletIdByGunId(cannonId)
	for cannontid,cannonInfo in pairs(_allCannonAndBall.gun_bar_info or {}) do
		if(tonumber( cannontid ) == tonumber(cannonId)) then
			cannonInfo[2] = loadCannonBallId and tonumber(loadCannonBallId) or 0
			break
		end
	end
	-- 卸下或者更换
	logger:debug("oldBulletId:"..oldBulletId)
	if (tonumber(oldBulletId) ~= 0) then
		table.insert(_allCannonAndBall.unuse_bullet, oldBulletId)
	end
	logger:debug("loadCannonBallId:"..loadCannonBallId)
	-- 装上
	if (tonumber(loadCannonBallId)~= 0) then
		for cannonBallIndex,cannonballid in pairs(_allCannonAndBall.unuse_bullet or {}) do
			if (tonumber(loadCannonBallId) == tonumber(cannonballid)) then
				table.remove( _allCannonAndBall.unuse_bullet, tonumber(cannonBallIndex) )
				break
			end
		end
	end
	logger:debug({_allCannonAndBall = _allCannonAndBall})
end

function insertCannonBall( bulletId )
	if (bulletId and tonumber(bulletId) ~= 0) then
		table.insert(_allCannonAndBall.unuse_bullet, bulletId)
	end
end


-- 计算船炮升级战斗力
function setFightValue( ... )
	_cannonFightValue = 0
	local shipInfo = ShipData.getAllShipInfo()
	logger:debug({_cannonFightValue = shipInfo})

	if (shipInfo and tonumber(shipInfo.nowShipId) == 0) then
		return
	end

	logger:debug({_cannonFightValue_shipInfo = shipInfo})


	local userLel = UserModel.getHeroLevel()
	local cannonCacheInfoTb = _allCannonAndBall.gun_bar_info or {}

	local allCannonId = {}
	local allCannonDB = DB_Ship_cannon.Ship_cannon


	for cannonId,cannonDB in pairs(allCannonDB) do
		table.insert(allCannonId,cannonDB[1])
	end

	table.sort( allCannonId, function ( v1,v2 )
		return tonumber(v1) < tonumber(v2)
	end )



	for i,cannnonId in ipairs(allCannonId) do
		local perCannonFightValue = 0
		local cannnonCache = cannonCacheInfoTb[cannnonId .. ""]
		if (not cannnonCache) then
			break
		end
		local cannonDB = DB_Ship_cannon.getDataById(cannnonId)

		local fightLelFeild= cannonDB.fight_force_perlevel
		local fightLelTb = lua_string_split(fightLelFeild, ",")
		local fightLelMap = {}
		for i,v in ipairs(fightLelTb) do
			local perFight = lua_string_split(v, "|")
			table.insert(fightLelMap,perFight)
		end

		local function getPerUpLelForce( level )
			local tLevel = 0
			for i,v in ipairs(fightLelMap) do
				if (level >= tonumber(v[1])) then
					tLevel = tonumber(v[2])
				else
					break
				end
			end
			return tLevel

		end 


		if (userLel >= tonumber(cannonDB.need_lv) ) then
			perCannonFightValue = perCannonFightValue + tonumber(cannonDB.base_fight_force)
			local cannnonLel = cannnonCache and tonumber(cannnonCache[1]) or 0
			-- 炮弹等级影响
			if (cannnonLel <= 0) then
				
			else
				for i=1,cannnonLel do
					perCannonFightValue = perCannonFightValue + getPerUpLelForce(i)
				end
			end
				logger:debug({perCannonFightValue1 = perCannonFightValue})

			-- 炮弹系数影响
			if (cannnonCache[2] and tonumber(cannnonCache[2]) ~= 0) then
				local shellDB = DB_Shell.getDataById(cannnonCache[2]) 
				local factor = shellDB.shell_fight_ratio and tonumber(shellDB.shell_fight_ratio) or 1

				perCannonFightValue = math.floor( perCannonFightValue * factor / 10000)
				logger:debug({perCannonFightValue2 = perCannonFightValue})

			else
				perCannonFightValue = math.floor( perCannonFightValue * 0 / 10000)
			end
		else
			break
		end
		_cannonFightValue = _cannonFightValue + perCannonFightValue
	end
	logger:debug({_cannonFightValue = _cannonFightValue})
end	


function create(...)

end
