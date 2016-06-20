-- FileName: DiscountData.lua
-- Author: zhangjunwu
-- Date: 2015-11-12
-- Purpose: function description of module
--[[TODO List]]

module("DiscountData", package.seeall)

-- UI控件引用变量 --
local _userDefault  = g_UserDefault
local _tbCurCell 	= {}
 local m_i18n = gi18n
-- 模块局部变量 --
 T_EQUIP_DIS 		= 1
 T_CONCH_DIS 		= 2
 T_TREAS_DIS 		= 3
 T_EXCL_DIS		 	= 4
 T_PROPS_DIS 		= 5
tbTitleImg = {
	["equipmentDiscount"] = "images/wonderfullAct/title_equipment.png", 
	["conchDiscount"] = "images/wonderfullAct/title_conch.png", 
	["treasureDiscount"] = "images/wonderfullAct/title_treasure.png", 
	["exclusiveDiscount"] = "images/wonderfullAct/title_exclusive.png", 
	["propertyDiscount"] = "images/wonderfullAct/title_property.png", 
	}

tbWonderfullName = {
	["discountEquip"] = "equipmentDiscount", 
	["discountConch"] = "conchDiscount", 
	["discountTreas"] = "treasureDiscount", 
	["discountExcl"] = "exclusiveDiscount", 
	["discountProps"] = "propertyDiscount", 
	}


function destroy(...)
	package.loaded["DiscountData"] = nil
end

function moduleName()
    return "DiscountData"
end

function create(...)

end

function isDiscountActivityOpenInTime(_disCountName)
	logger:debug({awef = ActivityConfigUtil.isActivityOpen( _disCountName )})
	return ActivityConfigUtil.isActivityOpen( _disCountName ) 
end

local _tbEquipDicInfo 		= {}
local _tbTreasDicInfo 		= {}
local _tbConchDicInfo 		= {}
local _tbExclusiveDicInfo	= {}
local _tbPropsDicInfo		= {}
local _tbAllDisAciInfo 		= {}


function setDisCountDataByName(tbInfo)
	logger:debug(tbInfo)
	for k,v in pairs(_tbAllDisAciInfo) do
		logger:debug(k)
		logger:debug(tbInfo.name)
		if(k == tbInfo.name) then
			logger:debug(v)
			for i,info in pairs(v) do
				if(tonumber(info.id) == tonumber(tbInfo.rowId)) then
					info.selfBought = tbInfo.selfBuy or 0
					info.AllBought = tbInfo.allBuy or 0
					logger:debug(info)
					return info
				end
			end
		end
	end
end

local function getDisDataByDbData( v )
	-- logger:debug(v)
	local tb = {}
	local str_items = v.items
	local tbItems = string.split(str_items,"|")
	tb.items = str_items
	tb.id 				= v.id
	tb.tid 				= tbItems[2]
	tb.num 				= tbItems[3]
	tb.current_price 	= v.current_price
	tb.original_price 	= v.original_price
	tb.selfBought 		= 0    		--个人已经买了多少个了
	tb.AllBought 		= 0 		--全服已经买了多少个了
	tb.global_limit 	= tonumber(v.global_limit)
	tb.self_limit 		= tonumber(v.self_limit)
	tb.array_type		= v.array_type
	local dd = intPercent(tonumber(v.current_price) ,tonumber(v.original_price))
	logger:debug(dd)
	local sTen = dd/10
	tb.nDisPer = sTen --todo
	return tb
end

--对数据进行排序
local function sortData(tbInfo)
	table.sort( tbInfo, function (count1,count2)
		return tonumber(count1.id) < tonumber(count2.id)
	end )
end
-- 设置装备打折配置表数据
function setEquipConfigData( ... )
	if(#_tbEquipDicInfo > 0)then
		return 
	end

	_tbEquipDicInfo = {}
	local EquipDicData = ActivityConfigUtil.getDataByKey("equipmentDiscount")
	for k,v in pairs(EquipDicData.data) do 
		local tb = {}
		tb = getDisDataByDbData(v)
		-- logger:debug(tb)
		table.insert(_tbEquipDicInfo, tb)

	end
	sortData(_tbEquipDicInfo)

	_tbAllDisAciInfo.equipmentDiscount = _tbEquipDicInfo

end

-- 设置空岛贝打折配置表数据
function setConchConfigData( ... )
	if(#_tbConchDicInfo > 0)then
		return 
	end

	_tbConchDicInfo = {}
	local conchDicData = ActivityConfigUtil.getDataByKey("conchDiscount")
	for k,v in pairs(conchDicData.data) do 
		local tb = {}
		tb = getDisDataByDbData(v)
		table.insert(_tbConchDicInfo, tb)
	end
	sortData(_tbConchDicInfo)

	_tbAllDisAciInfo.conchDiscount = _tbConchDicInfo
end

-- 设置饰品打折配置表数据
function setTreasConfigData( ... )
	if(#_tbTreasDicInfo > 0)then
		return 
	end

	_tbTreasDicInfo = {}
	local treasDicData = ActivityConfigUtil.getDataByKey("treasureDiscount")
	for k,v in pairs(treasDicData.data) do 
		local tb = {}
		tb = getDisDataByDbData(v)
		table.insert(_tbTreasDicInfo,tb)
	end
	sortData(_tbTreasDicInfo)

	_tbAllDisAciInfo.treasureDiscount = _tbTreasDicInfo
end

-- 设置宝物打折配置表数据
function setExclusiveConfigData( ... )
	if(#_tbExclusiveDicInfo > 0)then
		return 
	end

	_tbExclusiveDicInfo = {}
	local exclusiveDicData = ActivityConfigUtil.getDataByKey("exclusiveDiscount")
	for k,v in pairs(exclusiveDicData.data) do 
		local tb = {}
		tb = getDisDataByDbData(v)
		table.insert(_tbExclusiveDicInfo, tb)
		
	end
	sortData(_tbExclusiveDicInfo)
	_tbAllDisAciInfo.exclusiveDiscount = _tbExclusiveDicInfo
end

-- 设置道具打折配置表数据
function setPropsConfigData( ... )
	if(#_tbPropsDicInfo > 0)then
		return 
	end

	_tbPropsDicInfo = {}
	local propsDicData = ActivityConfigUtil.getDataByKey("propertyDiscount")
	for k,v in pairs(propsDicData.data) do 
		local tb = {}
		tb = getDisDataByDbData(v)
		table.insert(_tbPropsDicInfo, tb)

	end
	sortData(_tbPropsDicInfo)
	_tbAllDisAciInfo.propertyDiscount = _tbPropsDicInfo
end

function initDbData()
	setEquipConfigData()
	setConchConfigData()
	setExclusiveConfigData()
	setTreasConfigData()
	setPropsConfigData()
end

function getListDataByDisName( _name )
	if(_tbAllDisAciInfo == {}) then
		initDbData()
	end
	for k,v in pairs(_tbAllDisAciInfo) do
		if(k == _name) then
			return  v
		end
	end
	return {}
end

-- 得到活动结束时间
function getActivityEndTime(_name)
	local activityConfigData = ActivityConfigUtil.getDataByKey(_name)
	return activityConfigData.end_time
end

--得到活动结束的剩余时间
function getActivityLastTime( _name)
	local endTime = getActivityEndTime(_name)
	require "script/utils/TimeUtil"
	local time,nowTime = TimeUtil.getServerDateTime()
	local timeRemain = endTime - nowTime
	return timeRemain
end

-- 得到倒计时的字符串
function getLastTimeByName( _name )
	local timeRemain = getActivityLastTime(_name)
	if (timeRemain<=0) then
		return "0".. m_i18n[1981]
	else
		return TimeUtil.getTimeDesByInterval(timeRemain)
	end
end



-- local tbDiscountOpenFn = {
-- 	["equipmentDiscount"] = function ()  
-- 		print("nihao")
-- 		return  isEquipDisActivityInTime() 
-- 	end , 
-- 	["conchDiscount"] = function () return  isConchDisActivityInTime() end ,
-- 	["treasureDiscount"] = function () return  isExclDisActivityInTime() end ,
-- 	["exclusiveDiscount"] = function () return  isExclDisActivityInTime() end , 
-- 	["propertyDiscount"] = function () return  isPropsDisActivityInTime() end ,
-- 	}

--[[desc:在手机中存储是否曾经访问过这个按钮
    arg1: 访问状态
    return: 无  
—]]
function setDiscountNewAniState( discountName,nState )
	local db  = ActivityConfigUtil.getDataByKey(discountName)
	if (db==nil) then
		return 
	end
	_userDefault:setIntegerForKey(discountName .. UserModel.getUserUid()  .. db.start_time, nState)
end

--[[desc:获取是否访问过这个按钮的状态
    arg1: 无
    return: 储存的状态  
—]]
function getDiscountNewAniState(discountName)
	logger:debug(discountName)
	local db  = ActivityConfigUtil.getDataByKey(discountName)
	-- logger:debug("getDiscountNewAniState")
	-- logger:debug({db = db})
	if (db==nil) then
		return 1
	end
	return _userDefault:getIntegerForKey(discountName .. UserModel.getUserUid() .. db.start_time)
end

--主界面判断活动红点的时候 打折模块的逻辑红点逻辑处理
function getDiscountRedState()
	logger:debug({tbWonderfullName = tbWonderfullName})
	for k,v in pairs(tbWonderfullName) do
		local nState = getDiscountNewAniState(v)
		if(isDiscountActivityOpenInTime(v) == true and nState ~= 1) then
			return true
		end
	end
	return false
end


--保存顶部cell
function setCellByname(_name,cell)
	_tbCurCell[_name] = cell
	logger:debug(_tbCurCell)
	-- _curCell = cell
end
--返回顶部cell
function getCellByName(_name)
	logger:debug(_tbCurCell)
	for k,v in pairs(_tbCurCell) do
		if(k == _name) then
			return v
		end
	end
end