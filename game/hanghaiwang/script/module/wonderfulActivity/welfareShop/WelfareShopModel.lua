-- FileName: WelfareShopModel.lua
-- Author: Xufei
-- Date: 2015-12-22
-- Purpose: 福利商店
--[[TODO List]]

WelfareShopModel = class("WelfareShopModel")

-- UI控件引用变量 --

-- 模块局部变量 --
WelfareShopModel._nowActivityDB = {}
WelfareShopModel._tbBackendInfo = {}
WelfareShopModel._startTime = nil
WelfareShopModel._endTime = nil
WelfareShopModel._iconAct = nil
WelfareShopModel._iconActName = nil
WelfareShopModel._staOrDynFlag = nil
WelfareShopModel._selfCell = nil

-- 保存后端数据
function WelfareShopModel:setWelfareShopInfo( backendInfo )
	self._tbBackendInfo = backendInfo
	self._tbBackendInfo.effectiveTime = self._startTime..self._endTime
	logger:debug({welfareShopBackend = self._tbBackendInfo})
end

----------------------------------------------------------

-- 保存当前的轮次的开启时间和结束时间，以及本轮次的DB
function WelfareShopModel:setDBandTime( startTime, endTime, welfareDB )
	self._startTime = startTime
	self._endTime = endTime
	self._nowActivityDB = welfareDB
end

-- 判断是否保存了后端数据
function WelfareShopModel:getIsNotPullBackend( ... )
	return table.isEmpty(self._tbBackendInfo) 
end


--[[desc:功能简介
    arg1: 参数说明
    return: items = {}, itemID, itemDB, type, personBuyTime, globalBuyTime
—]]
function WelfareShopModel:getListViewData( ... )
	local nowActivityDB = self._nowActivityDB
	local strGoodsIds = nowActivityDB.goods_list
	local tbGoodsIds = lua_string_split(strGoodsIds, "|")
	local listViewData = {}
	logger:debug({lookat_tbGoodsIds = tbGoodsIds})
	for k,v in ipairs (tbGoodsIds) do
		local goodsDB = DB_Welfare_shop_goods.getDataById(tonumber(v))
		local strItems = goodsDB.items
		local cellData = {}
		cellData.items = {}
		cellData.itemID = goodsDB.id
		cellData.itemDB = goodsDB
		local splitChar = nil
		if (tonumber(goodsDB.goods_type) == 2) then
			cellData.type = "selectOne"
			splitChar = ","
		elseif (tonumber(goodsDB.goods_type) == 1) then
			cellData.type = "single"
			splitChar = ","
		end
		local splitStrItems = lua_string_split(strItems, splitChar)
		for k1,v1 in ipairs(splitStrItems) do
			local itemInfo = RewardUtil.parseRewards(v1)
			table.insert(cellData.items, itemInfo)
		end
		for k1,v1 in pairs(self._tbBackendInfo.selfBuy) do
			if (tostring(cellData.itemID)==tostring(k1)) then
				cellData.personBuyTime = tonumber(v1)
			end
		end
		for k1,v1 in pairs(self._tbBackendInfo.globalLimitGoods) do
			if (tostring(cellData.itemID)==tostring(k1)) then
				cellData.globalBuyTime = tonumber(v1)
			end
		end
		table.insert(listViewData, cellData)
	end
	logger:debug({listViewDataLetsSee = listViewData})
	return listViewData
end

-- 获得本轮（已经保存的）的倒计时
function WelfareShopModel:getCountDownTime( ... )
	local nowTime = TimeUtil.getSvrTimeByOffset()
	if (self._endTime > nowTime) then
		return TimeUtil.getTimeDesByInterval( self._endTime - nowTime )
	else
		return "本轮活动已经结束" -- TODO
	end
end

-- 判断当前保存（显示）的轮次是否在开启中
function WelfareShopModel:getIsNowShowedActivityOpen( ... )
	local nowTime = TimeUtil.getSvrTimeByOffset()
	logger:debug({
		open = TimeUtil.getTimeFormatYMDHM(self._startTime),
		endt = TimeUtil.getTimeFormatYMDHM(self._endTime),
		nowTimeeeeeeee = TimeUtil.getTimeFormatYMDHM(nowTime),
		openservertim = TimeUtil.getTimeFormatYMDHM(g_tbServerInfo.openDateTime)
	})

	if (self._staOrDynFlag == "dynamic") then
		local needServerTime = TimeUtil.getTimestampByTimeStr(self._nowActivityDB.server_time)
		local realServerTime = g_tbServerInfo.openDateTime
		if (needServerTime<realServerTime) then
			return false
		end
	end
	return (self._tbBackendInfo.effectiveTime == self._startTime..self._endTime) and (self._endTime>nowTime and self._startTime<nowTime)
end

-- 更新购买后的数据
function WelfareShopModel:updateBuyData(buyInfo, itemId)
	if (buyInfo.selfBuy) then
		self._tbBackendInfo.selfBuy[tostring(itemId)] = buyInfo.selfBuy
	end
	if (buyInfo.global) then
		self._tbBackendInfo.globalLimitGoods[tostring(itemId)] = buyInfo.global
	end
end

-- 获得活动图标
function WelfareShopModel:getWelActIcon( ... )
	local nowActivityDB = self._nowActivityDB
	logger:debug({activityiconwelfare = nowActivityDB.activity_icon})
	return nowActivityDB.activity_icon
end

-- 获得活动名字(活动列表中)
function WelfareShopModel:getWelActNamePic( ... )
	local nowActivityDB = self._nowActivityDB
	logger:debug({activityNameiconwelfare = nowActivityDB.activity_name})
	return nowActivityDB.activity_name
end

-- 获得活动名字（活动界面中）
function WelfareShopModel:getWelActNameBigPic( ... )
	local nowActivityDB = self._nowActivityDB
	return nowActivityDB.activity_title
end

-- 在手机中存储是否曾经访问过这个按钮
function WelfareShopModel:setNewAniState( nState )
	g_UserDefault:setIntegerForKey(self._staOrDynFlag.."_welfare_shop_visible"..g_tbServerInfo.groupid..UserModel.getUserUid()..self._startTime..self._endTime, nState)
end

-- 获取是否访问过这个按钮的状态
function WelfareShopModel:getNewAniState()
	return g_UserDefault:getIntegerForKey(self._staOrDynFlag.."_welfare_shop_visible"..g_tbServerInfo.groupid..UserModel.getUserUid()..self._startTime..self._endTime)
end

function WelfareShopModel:setCell( cell )
	self._selfCell = cell
end

function WelfareShopModel:getCell( ... )
	return self._selfCell
end


function WelfareShopModel:setIconActAndName( icon, iconName )
	self._iconAct = icon
	self._iconActName = iconName
end

function WelfareShopModel:getIconActAndName( ... )
	return self._iconAct, self._iconActName
end

function WelfareShopModel:setDynOrSta( staOrDynFlag )
	self._staOrDynFlag = staOrDynFlag
end

--------------------------------------
function WelfareShopModel:init(...)

end

function WelfareShopModel:destroy(...)
	package.loaded["WelfareShopModel"] = nil
end

function WelfareShopModel:moduleName()
    return "WelfareShopModel"
end

function WelfareShopModel:ctor()
end

function WelfareShopModel:create(...)

end
