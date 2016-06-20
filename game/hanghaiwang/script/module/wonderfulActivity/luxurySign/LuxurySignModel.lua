-- FileName: LuxurySignModel.lua
-- Author: Xufei
-- Date: 2016-01-07
-- Purpose: function description of module
--[[TODO List]]

module("LuxurySignModel", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --
local _luxurySignBackendInfo = nil
local _luxurySignDB = DB_Sign_charge
-- local _haveLogin = "0"
local _selfCell = nil

function isLevelEnough()
	local userLv = UserModel.getHeroLevel()
	local needUserLv = DB_Normal_config.getDataById(1).sign_charge_lv
	return (tonumber(userLv)>=tonumber(needUserLv))
end

--在充值后更新显示红点
function updateRedPointInActivity()
	if (LayerManager.curModuleName() == "MainWonderfulActCtrl") then
		if (getCanGetNum() > 0) then
			WonderfulActModel.tbBtnActList.luxSign:setVisible(true)
			WonderfulActModel.tbBtnActList.luxSign.IMG_TIP:setEnabled(true)
			local numberLab = WonderfulActModel.tbBtnActList.luxSign.LABN_TIP_EAT
			numberLab:setStringValue(getCanGetNum())

			local listCell = getCell()
			if (listCell) then
				listCell:removeNodeByTag(100)
				setCell(nil)
			end
		end
	end
end

function updateChargeData( goldNum )
	if (notPullLuxuryBack()) then
		return
	else
		_luxurySignBackendInfo.hadRechargeGold = tostring ( tonumber(_luxurySignBackendInfo.hadRechargeGold) + tonumber(goldNum) )
		updateRedPointInActivity()
		GlobalNotify.postNotify("LuxurySignView_refresh_view_when_charge")
	end
end

function updateBuyData( gearId )
	_luxurySignBackendInfo.rewardInfo[tostring(gearId)].ifHadBuy = "1"
end

function setLuxurySignInfo( backendInfo )
	_luxurySignBackendInfo = backendInfo
end

function notPullLuxuryBack( ... )
	return table.isEmpty(_luxurySignBackendInfo)
end

function getLusurySignListViewData( ... )
	local luxuryDb = _luxurySignDB
	local backendInfo = _luxurySignBackendInfo
	local rewardInfoTable = {}
	for k,v in pairs ( backendInfo.rewardInfo ) do
		local tbRet = {}
		tbRet.haveBought = v.ifHadBuy
		tbRet.nowGold = tonumber(backendInfo.hadRechargeGold)
		tbRet.DB = _luxurySignDB.getDataById(v.rewardId)
		tbRet.CanBuy = (tonumber(tbRet.DB.charge)<=tbRet.nowGold)
		tbRet.gearId = tonumber(k)
		table.insert(rewardInfoTable, tbRet)
	end
	table.sort (rewardInfoTable, function (a, b)
		return a.gearId < b.gearId
	end)
	return rewardInfoTable
end

-- 获得还能领的数目，即红点数字
function getCanGetNum(  )
	if (notPullLuxuryBack()) then
		return 0
	elseif (not isLevelEnough()) then
		return 0
	else
		local nowState = getLusurySignListViewData()
		local counter = 0
		for k,v in pairs(nowState) do
			if (v.haveBought == "0" and v.CanBuy) then
				counter = counter + 1
			end
		end
		return counter
	end
end

-- 是否有未领取
function isHaveCanGain( ... )
	if (notPullLuxuryBack()) then
		return false
	elseif (not isLevelEnough()) then
		return false
	else
		return (getCanGetNum() > 0)
	end
end

-- 返回后端数据中是否全部被领取了
function ifAllHadGet( ... )
	local backendInfo = _luxurySignBackendInfo
	for k,v in pairs(backendInfo.rewardInfo) do
		if (v.ifHadBuy == "0") then
			return false
		end
	end
	return true
end

-- 返回是否进入过活动，如果全领过了就返回true
function isLoginLuxurySign( ... )
	if (notPullLuxuryBack()) then
		if (isLevelEnough()) then
			return false
		else
			return true
		end
	elseif (ifAllHadGet()) then
		return true
	else
		return (getNewAniState() == 1)
	end
end

-- 设置进入过活动
function setLoginLuxurySign( ... )
	-- _haveLogin = "1"
	setNewAniState( 1 )
end

function setNewAniState( nState )
	local _,nowTime = TimeUtil.getServerDateTime()
	local strDate = TimeUtil.getTimeFormatYMD( nowTime )
	g_UserDefault:setIntegerForKey("LUXURY_SIGN"..g_tbServerInfo.groupid..UserModel.getUserUid()..strDate, nState)
end

function getNewAniState( ... )
	local _,nowTime = TimeUtil.getServerDateTime()
	local strDate = TimeUtil.getTimeFormatYMD( nowTime )
	return g_UserDefault:getIntegerForKey("LUXURY_SIGN"..g_tbServerInfo.groupid..UserModel.getUserUid()..strDate)
end

function setCell( cell )
	_selfCell = cell
end

function getCell( ... )
	return _selfCell
end

local function init(...)

end

function destroy(...)
	package.loaded["LuxurySignModel"] = nil
end

function moduleName()
    return "LuxurySignModel"
end

function create(...)

end
