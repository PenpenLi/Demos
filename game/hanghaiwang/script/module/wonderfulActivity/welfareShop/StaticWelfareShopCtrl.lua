-- FileName: StaticWelfareShopCtrl.lua
-- Author: Xufei
-- Date: 2015-12-22
-- Purpose: 福利商店
--[[TODO List]]

module("StaticWelfareShopCtrl", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --
local _welfareShopViewInstance = nil
local _welfareModelIns = nil
local sPath = "images/wonderfullAct/"
local _btnEvent = {}

local _dbWelfareShopStart = DB_Welfare_shop_kaifu
local _dbWelfareShopGoods = DB_Welfare_shop_goods
local _nOpenServerTime = g_tbServerInfo.openDateTime
local _nowActivityDB = {}
local _tbBackendInfo = {}
local _startTime = nil
local _endTime = nil


local function init(...)
	logger:debug("init_static_welfareShop_model_if_not_have")
	if (_welfareModelIns == nil) then
		_welfareModelIns = WelfareShopModel:new()
		_welfareModelIns:setDynOrSta("static")
	end
end

function destroy(...)
	_welfareModelIns:setCell(nil)
	package.loaded["StaticWelfareShopCtrl"] = nil
end

function setCellNil( ... )
	_welfareModelIns:setCell(nil)
end

function moduleName()
    return "StaticWelfareShopCtrl"
end

function removeNew( ... )
	-- 移除new
	local listCell = _welfareModelIns:getCell()
	if (listCell) then
		listCell:removeNodeByTag(100)
	end
	_welfareModelIns:setNewAniState( 1 )
end

function getWelShopBackendAndShow( ... )
	local iconAct, iconName = getIconActAndName()
	iconAct:loadTexture(sPath .. getWelActIcon())
	iconName:loadTexture(sPath .. getWelActNamePic())
	function getWelfareShopInfoCallback( cbFlag, dictData, bRet )
		if (bRet) then
			if (getIsActivityOn()) then
				logger:debug("is_on_and_got_data_in_GetIsActivityAndShow")
				setWelfareShopInfo(dictData.ret)
				_welfareShopViewInstance = WelfareShopView:new()
				removeNew()
				MainWonderfulActCtrl.addLayChild(_welfareShopViewInstance:create(setCellNil, _welfareModelIns, "static"))
			else
				ShowNotice.showShellInfo("活动已结束！") -- TODO
			end
		end
	end			
	RequestCenter.welfareShop_getInfo(getWelfareShopInfoCallback)
end

function create(...)
	if (not getIsActivityOn()) then
		ShowNotice.showShellInfo("活动已结束！")	-- TODO
	elseif (_welfareModelIns:getIsNotPullBackend()) then
		logger:debug("dont_have_data_GetIsActivityAndShow")
		getWelShopBackendAndShow()
	elseif (not _welfareModelIns:getIsNowShowedActivityOpen()) then
		logger:debug("data_is_old_GetIsActivityAndShow")
		getWelShopBackendAndShow()
	else
		logger:debug("is_is_not_old_just_show")
		-- _welfareShopViewInstance = WelfareShopView:new()
		-- removeNew()
		-- MainWonderfulActCtrl.addLayChild(_welfareShopViewInstance:create(destroy, _welfareModelIns))
		getWelShopBackendAndShow()
	end
end

-----------------------------------------------

function setWelfareShopInfo( backendInfo )
	init()
	_welfareModelIns:setWelfareShopInfo(backendInfo)
end



-- 获得当前距离开服已经过了几天
function getNowDay( ... )
	local day = TimeUtil.getDifferDay(_nOpenServerTime) + 1
	return day
end

-- 先获取当前的开服天数，再遍历start表，确定是否在活动期间，并记录下活动的DB，返回是否有活动开启；根据当前的时间刷新了保存的轮次
function getIsActivityOn( ... )
	local openSerVerTime = _nOpenServerTime
	logger:debug({openServerTimeWelFare = TimeUtil.getTimeFormatYMDHM(_nOpenServerTime)})
	local configNum = table.count(_dbWelfareShopStart.Welfare_shop_kaifu)
	for i = 1, configNum do
		_nowActivityDB = _dbWelfareShopStart.getDataById(i)
		local nowOpenServerDays = getNowDay()
		local splitConfigDays = lua_string_split(_nowActivityDB.activity_time, "|")
		local oneDayScends = 24*60*60
		local openServerTimeZero = TimeUtil.getZeroClockTime(_nOpenServerTime) 
		_startTime = openServerTimeZero + (tonumber(splitConfigDays[1])-1)*oneDayScends       	-- 开启时间，是从当天0点开始
		_endTime = openServerTimeZero + (tonumber(splitConfigDays[2]))*oneDayScends				-- 结束时间，是到当天24点结束
		if ((tonumber(splitConfigDays[1])<=nowOpenServerDays) and (tonumber(splitConfigDays[2])>=nowOpenServerDays)) then
			break
		else
			_nowActivityDB = {}	-- 没在时间范围内，则把DB改为空
		end
	end	
	init()
	_welfareModelIns:setDBandTime( _startTime, _endTime, _nowActivityDB )
	if (not table.isEmpty(_nowActivityDB)) then
		logger:debug({welfareShopIsOn = _nowActivityDB})
		return true
	else
		logger:debug("welfareShopIsClose")
		return false
	end
end




function getNewAniState( ... )
	return _welfareModelIns:getNewAniState()
end

function setCell(cell)
	return _welfareModelIns:setCell(cell)
end

-- 获得活动图标
function getWelActIcon( ... )
	local nowActivityDB = _nowActivityDB
	logger:debug({static_activityiconwelfare = nowActivityDB.activity_icon})
	return nowActivityDB.activity_icon
end

-- 获得活动名字(活动列表中)
function getWelActNamePic( ... )
	local nowActivityDB = _nowActivityDB
	logger:debug({static_activityNameiconwelfare = nowActivityDB.activity_name})
	return nowActivityDB.activity_name
end

-- 获得活动名字（活动界面中）
function getWelActNameBigPic( ... )
	local nowActivityDB = _nowActivityDB
	logger:debug({static_TuBiaoInActList = nowActivityDB.activity_title})
	return nowActivityDB.activity_title
end

-- 保存在活动列表中的图标
function setIconActAndName( icon, iconName )
	_welfareModelIns:setIconActAndName( icon, iconName )
end

-- 获得保存的图标
function getIconActAndName( ... )
	return _welfareModelIns:getIconActAndName()
end



