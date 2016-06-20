-- FileName: ShipBulletBagModel.lua
-- Author: yucong
-- Date: 2015-02-14
-- Purpose: function description of module
--[[TODO List]]

module("ShipBulletBagModel", package.seeall)

local _bagType = nil
local _bulletType = nil
local _tbAllBullets = {} 	-- 登录时设置数据并排序，之后不做操作
local _tbUnuseBullets = {} 	-- 每次打开选择列表重新构造数据

-- 背包类型
function setBagType( type )
	_bagType = type
end

function getBagType( ... )
	return _bagType
end

-- 炮弹类型
function setBulletType( num )
	_bulletType = num or ShipBulletConst.E_BULLET_ATTACK
end

function getBulletType( ... )
	return _bulletType
end

function getDBBulletById( id )
	return DB_Ship_skill.getDataById(tonumber(id))
end

function setAllBullets( bullets )
	-- _tbUnuseBullets = bullets.unuse_bullet
	_tbAllBullets = {}
	table.hcopy(bullets.unuse_bullet, _tbAllBullets)
	for k, gunBarInfo in pairs(bullets.gun_bar_info) do
		if (tonumber(gunBarInfo[2]) ~= 0) then
			table.insert(_tbAllBullets, gunBarInfo[2])
		end
	end
	logger:debug({setAllBullets = _tbAllBullets})
	handleBullets()
end


function getAllBullets( ... )
	return _tbAllBullets or {}
end

-- 获取指定炮弹类型的数据，为空则使用当前类型
function getDatasByType( type )
	type = type or _bulletType
	if (_bagType == ShipBulletConst.E_BAG) then
		return _tbAllBullets[type]
	elseif (_bagType == ShipBulletConst.E_BAG_LOAD) then
		return _tbUnuseBullets[type]
	end
end

-- 炮弹是否已装备
-- @return 是否在装备，炮筒id，没在装备返回0
function isBulletLoad( bulletId )
	local gun_bar_info = CannonModel.getAllCannon()
	for k, gunBarInfo in pairs(gun_bar_info or {}) do
		if (tonumber(gunBarInfo[2]) ~= 0 and tonumber(gunBarInfo[2]) == tonumber(bulletId)) then
			return true, k
		end
	end
	return false, 0
end

-- 添加新炮弹数据到背包数据中
function addBullet( bulletId )
	if (not bulletId) then
		return
	end
	local db_bullet = getDBBulletById(tonumber(bulletId))
	local type = db_bullet.skill_type
	if (not _tbAllBullets[type]) then
		_tbAllBullets[type] = {}
	end
	local index = table.count(_tbAllBullets[type])
	for i = 1, table.count(_tbAllBullets[type]) + 1 do
		index = i
		local data = _tbAllBullets[type][i]
		if (not data) then
			index = nil
			break
		end
		if (db_bullet.quality > data.quality) then
			break
		else
			if (db_bullet.id > data.id) then
				break
			end
		end
	end
	if (index) then
		table.insert(_tbAllBullets[type], index, db_bullet)
	else
		table.insert(_tbAllBullets[type], db_bullet)
	end
	logger:debug({addBullet = _tbAllBullets})
end

-- 从背包数据中删除炮弹数据
function removeFromBullets( bulletId )
	for type, bullets in pairs(_tbAllBullets or {}) do
		for k, dbBullet in pairs(bullets) do
			if (dbBullet.id == tonumber(bulletId)) then
				table.remove(bullets, k)
				return
			end
		end
	end
end

-- 处理背包数据
function handleBullets( ... )
	local tbBullets = {}
	for k, bid in pairs(_tbAllBullets or {}) do
		local db_bullet = getDBBulletById(bid)
		local type = db_bullet.skill_type
		if (not tbBullets[type]) then
			tbBullets[type] = {}
		end
		table.insert(tbBullets[type], db_bullet)
	end
	_tbAllBullets = tbBullets
	sortBullets(_tbAllBullets)
	logger:debug({_tbAllBullets = _tbAllBullets})
end

-- 处理选择列表数据
function handleUnuseBullets( ... )
	local data = CannonModel.getAllUNusedCannonball()
	logger:debug(data)
	local tbBullets = {}
	for k, bid in pairs(data or {}) do
		local db_bullet = getDBBulletById(bid)
		local type = db_bullet.skill_type
		if (not tbBullets[type]) then
			tbBullets[type] = {}
		end
		table.insert(tbBullets[type], db_bullet)
	end
	_tbUnuseBullets = tbBullets
	sortBullets(_tbUnuseBullets)
	logger:debug({_tbUnuseBullets = _tbUnuseBullets})
end

-- 排序
function sortBullets( tbData )
	for type, bullets in pairs(tbData) do
		table.sort(bullets, function ( data1, data2 )
			if (data1.quality ~= data2.quality) then
				return data1.quality > data2.quality
			else
				return data1.id > data2.id
			end
		end)
	end
end

-- 获取指定炮弹的属性描述
function getBulletAttrib( bulletId )
	local tbAttrib = ArmShipData.getCannonBallAttrByLel(bulletId)
	logger:debug({tbAttrib = tbAttrib})
	local sAttrib = ""
	local attribName = ""
	local attribValue = ""
	for k, info in pairs(tbAttrib.attr or {}) do
		sAttrib = sAttrib..info.name..":"..info.beforValue.."\n"
		attribName = info.name
		attribValue = info.beforValue
		break
	end
	logger:debug("sAttrib:"..sAttrib)
	return sAttrib, attribName, attribValue
end

-- 根据炮台id获取装备的炮弹id
function getBulletIdByGunId( gunId )
	local gunInfo = CannonModel.getCannonInfoById(tonumber(gunId))
	return tonumber(gunInfo[2])
end

-- 创建炮弹icon
function createBulletIcon( bulletId, event )
	return ArmShipData.createCannonAndBallBtnByTid(bulletId, event, 1)
end

function destroy(...)
	package.loaded["ShipBulletBagModel"] = nil
end

function moduleName()
    return "ShipBulletBagModel"
end

function create(...)

end
