-- FileName: ArmShipCtrl.lua
-- Author: sunyunpeng
-- Date: 2016-02-04
-- Purpose: function description of module
--[[TODO List]]

module("ArmShipCtrl", package.seeall)
local _allCannonDB
local _allCannonId = {}
local _shipId

-- UI控件引用变量 --

-- 模块局部变量 --

local function init(...)

end

function destroy(...)
	package.loaded["ArmShipCtrl"] = nil
end

function moduleName()
    return "ArmShipCtrl"
end

-- 返回按钮
function onReturn( ... )
	logger:debug({ArmShipCtrl__shipId = _shipId})
	-- ShipMainCtrl.create(_shipId, "bag")
	ShipMainCtrl.create(_shipId, "main")
end

-- 显示战斗力动画
function showFightValue( ... )
	UserModel.setInfoChanged(true) -- zhangqi, 标记需要刷新战斗力
	CannonModel.setFightValue()
    UserModel.updateFightValueByValue()
    -- 更新信息条
    updateInfoBar()
	MainFormationTools.removeFlyText()
	MainFormationTools.fnShowFightForceChangeAni()
end

-- 装载炮弹
function lcoadCannonBall( cannonIndex ,cannonId)
	logger:debug({lcoadCannonBall = cannonId})
	ShipBulletBagCtrl.createSelectList(cannonId, function ( bulletId )
		LayerManager.removeLayout()
		resetCannonView(cannonIndex,cannonId)
		showFightValue()
	end)
end


-- 更换炮弹
function changeCannonBall( cannonIndex ,cannonId)
	ShipBulletBagCtrl.createSelectList(cannonId, function ( bulletId )
		LayerManager.removeLayout()
		resetCannonView(cannonIndex,cannonId)
		showFightValue()
	end)
end


-- 卸下炮弹
function relaondCannonBall( cannonIndex ,cannonId)
	logger:debug({lcoadCannonBall = cannonId})
	ShipBulletRequest.wearBullet(cannonId, 0, function ( bulletId )
		LayerManager.removeLayout()
		resetCannonView(cannonIndex,cannonId)
		showFightValue()
	end)
end

--  重置炮的信息
function resetCannonView( cannonIndex ,cannonId )
	initData()
	ArmShipView.initCannonData()
	ArmShipView.setCannonAndBallByIndex(cannonIndex,cannonId)
end


-- 炮强化界面
function gotoCannonStren( cannonIndex,cannonId )
	CannonStrenCtrl.create(cannonId,cannonIndex)
end

-- 炮弹信息界面
function creatCannonBallInfo( cannonId,cannonBallId,cannonLel,cannonIndex )
	local cannonBallInfo = CannonBallInfo:new()
	cannonBallInfo:create(cannonId,cannonBallId,cannonLel,cannonIndex)
end

-- 炮弹库
function gotoCannonBallBag( ... )
	ShipBulletBagCtrl.createBag()
end


-- 所有炮的缓存信息
function getAllCannonCacheInfo( ... )
	return _allCannonCacheInfo
end

-- 所有炮的DB信息
function getAllCannonData( ... )
	return _allcannonDB
end

function getAllCannonDBId( ... )
	return _allCannonId
end


function initData( ... )
	_allCannonId = {}
	_allCannonDB = {}
	
	local userLel = UserModel.getHeroLevel
	_allCannonDB = DB_Ship_cannon.Ship_cannon

	for cannonId,cannonDB in pairs(_allCannonDB) do
		table.insert(_allCannonId,cannonDB[1])
	end

	table.sort( _allCannonId, function ( v1,v2 )
		return tonumber(v1) < tonumber(v2)
	end )

	_allCannonCacheInfo = CannonModel.getAllCannon()

end


-------------------------------------------------------  通知 ---------------------------------------------
----------------------------------------------------------------------------------------------------------
-- 强化成功
function strenOberver( cannonIndex,cannonId )
	resetCannonView( cannonIndex ,cannonId )
end

-- 更换炮弹ok
local function changeBallOberver( cannonIndex,cannonId,changType )
	if (changType == 1) then -- 更换
		changeCannonBall(cannonIndex,cannonId)
	elseif (changType == 2) then -- 卸下
		relaondCannonBall(cannonIndex,cannonId)
	end
end

-- 添加所需要的观察
function addAllObserver( ... )
    GlobalNotify.addObserver("strenOberver", strenOberver, nil,"strenOberver")
    GlobalNotify.addObserver("changeBallOberver", changeBallOberver, nil,"changeBallOberver")
end

-- 删除所需要的观察
function removeAllObserver( ... )
	PreRequest.removeBagDataChangedDelete()
    GlobalNotify.removeObserver("strenOberver","strenOberver")
    GlobalNotify.removeObserver("changeBallOberver", "changeBallOberver")
	-- body
end


function create(shipId)
	_shipId = shipId
	initData()
	local armShipView = ArmShipView.create()
	LayerManager.changeModule(armShipView, moduleName(), {}, true)
	LayerManager.setPaomadeng(armShipView)
	PlayerPanel.addForPartnerStrength()
end
