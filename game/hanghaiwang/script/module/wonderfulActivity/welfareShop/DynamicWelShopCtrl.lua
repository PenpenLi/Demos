-- FileName: DynamicWelShopCtrl.lua
-- Author: Xufei
-- Date: 2015-12-26
-- Purpose: 动态福利商店控制模块 配置拉取自web端
--[[TODO List]]

module("DynamicWelShopCtrl", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --

local _welfareShopViewInstance = nil
local _welfareModelIns = nil

local sPath = "images/wonderfullAct/"

local _dbWelfareShopStart = DB_Welfare_shop_kaifu
local _dbWelfareShopGoods = DB_Welfare_shop_goods
local _nOpenServerTime = g_tbServerInfo.openDateTime
local _nowActivityDB = {}
local _tbBackendInfo = {}
local _startTime = 0
local _endTime = 0

local function init(...)
	if (_welfareModelIns == nil) then
		_welfareModelIns = WelfareShopModel:new()
		_welfareModelIns:setDynOrSta("dynamic")
	end
end

function destroy(...)
	_welfareModelIns:setCell(nil)
	package.loaded["DynamicWelShopCtrl"] = nil
end

function setCellNil( ... )
	_welfareModelIns:setCell(nil)
end

function moduleName()
    return "DynamicWelShopCtrl"
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
	local iconOfAct, iconOfName = getIconActAndName()
	iconOfAct:loadTexture(sPath .. getWelActIcon())
	iconOfName:loadTexture(sPath .. getWelActNamePic())

	logger:debug("getIsActiviOn and is On")
	logger:debug({nowSeeStartTime = _startTime, 
		nowSeeEndTime = _endTime, 
		nowSeeDB = _nowActivityDB})
	
	function getWelfareShopInfoCallback( cbFlag, dictData, bRet )
		if (bRet) then
			if (getIsActivityOn()) then
				logger:debug("is_on_and_got_data_in_GetIsActivityAndShow_dynamic")
				setWelfareShopInfo(dictData.ret)
				_welfareShopViewInstance = WelfareShopView:new()
				removeNew()
				MainWonderfulActCtrl.addLayChild(_welfareShopViewInstance:create(setCellNil, _welfareModelIns, "dynamic"))
			else
				ShowNotice.showShellInfo("活动已结束！") -- TODO
			end
		end
	end			
	RequestCenter.dynamic_welfareshop_getInfo(getWelfareShopInfoCallback)
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

-- 先通过activityConfig判断是否在活动期间，如是，则记录下当前轮次的DB，返回true并保存下当前轮次的开始和结束时间，否则DB表赋空，返回false
function getIsActivityOn( ... )
	if (ActivityConfigUtil.isActivityOpen( "actwelfareshop" )) then
		local completeDB = ActivityConfigUtil.getDataByKey( "actwelfareshop" )
		logger:debug({dynamic_welfare_shop_complete_db = completeDB})
		local configNum = table.count(completeDB.data)
		for i = 1, configNum do
			_nowActivityDB = completeDB.data[i]
			local splitConfigDays = lua_string_split(_nowActivityDB.activity_time, "|")
			local _,nowTime = TimeUtil.getServerDateTime()
			_startTime = TimeUtil.getTimestampByTimeStr( splitConfigDays[1] )		-- 开启时间，是配置的具体时间
			_endTime = TimeUtil.getTimestampByTimeStr( splitConfigDays[2] )			-- 结束时间，是配置的具体时间

			local needServerTime = TimeUtil.getTimestampByTimeStr(_nowActivityDB.server_time)
			logger:debug({needServerTime  =  needServerTime } )

			if (_startTime<=nowTime and _endTime>=nowTime and needServerTime>=_nOpenServerTime) then
				break
			else
				_nowActivityDB = {}	-- 没在时间范围内，则把DB改为空
			end
		end	
	end
	logger:debug({dynamic_welfare_shop_StartTime = _startTime,
		dynamic_welfare_shop_EndTime = _endTime,
		realServerTimeeee = _nOpenServerTime
		})
	init()
	_welfareModelIns:setDBandTime( _startTime, _endTime, _nowActivityDB )
	if (not table.isEmpty(_nowActivityDB)) then
		logger:debug({Dynamic_welfareShopIsOn = _nowActivityDB})
		return true
	else
		logger:debug("Dynamic_welfareShopIsClose")
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
	logger:debug({dynamic_activityiconwelfare = nowActivityDB.activity_icon})
	return nowActivityDB.activity_icon
end

-- 获得活动名字(活动列表中)
function getWelActNamePic( ... )
	local nowActivityDB = _nowActivityDB
	logger:debug({dynamic_activityNameiconwelfare = nowActivityDB.activity_name})
	return nowActivityDB.activity_name
end

-- 获得活动名字（活动界面中）
function getWelActNameBigPic( ... )
	local nowActivityDB = _nowActivityDB
	logger:debug({dynamic_TuBiaoInActList = nowActivityDB.activity_title})
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



