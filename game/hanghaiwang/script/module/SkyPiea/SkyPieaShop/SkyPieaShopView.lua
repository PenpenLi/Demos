-- FileName: SkyPieaShopView.lua
-- Author: huxiaozhou
-- Date: 2015-01-12
-- Purpose: 空岛爬塔商店显示
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /


module("SkyPieaShopView", package.seeall)

-- UI控件引用变量 --
local json = "ui/air_shop.json"
-- 模块局部变量 --
local m_mainWidget
local m_fnGetWidget = g_fnGetWidgetByName
local m_tbEvent
local m_tbLabs = {} -- 金币 贝里 空岛币 时间lab的table
local m_scheduleId = nil -- 定时器id
local m_layRfrItem  -- 物品刷新的layout
local m_labItemNum 	-- 物品的个数 label
local m_layRfrGold  -- 金币刷新的layout
local m_labGoldNum  -- 消耗金币数 label
local m_bReSize
local listView  

local m_i18n = gi18n
local m_i18nString = gi18nString

local function init(...)
	m_tbLabs = {}
	m_scheduleId = nil
end

function destroy(...)
	package.loaded["SkyPieaShopView"] = nil
end

function moduleName()
	return "SkyPieaShopView"
end


-- 刷新显示 时间的lab
local function updateTimeLab(  )
	local time = SkyPieaModel.getRefreshCdTime()
	if time <= 0 then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(m_scheduleId)
		m_scheduleId = nil
		RequestCenter.skyPieaGetShopInfo(function(cbFlag, dictData, bRet)
												SkyPieaModel.setShopInfo(dictData.ret)
												updateUI()
										 end)
	end
	local strTime = TimeUtil.getTimeString(time)
	m_tbLabs.labRfr:setText(strTime )
end


-- 注册定时器 与 消除定时器
local function schedule( ... )
	UIHelper.registExitAndEnterCall(m_mainWidget,
							function (  )
								if m_scheduleId ~= nil then
									CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(m_scheduleId)
									m_scheduleId = nil	
								end
							end,
							function (  )
								if( m_scheduleId  == nil )then
									m_scheduleId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(updateTimeLab, 1, false)
								end
							end)
end


-- 初始化 每个cell
local function loadCell(cell, cellData, index)
	-- local
	logger:debug(cellData)
	local layCell = cell
	if not m_bReSize then
		local oldSize = layCell:getSize()
		layCell:setSize(CCSizeMake(oldSize.width*g_fScaleX, oldSize.height*g_fScaleX))
	end
	
	local img_cellbg = m_fnGetWidget(layCell, "img_cellbg")
	img_cellbg:setScale(g_fScaleX)
	local LAY_GOODS = m_fnGetWidget(layCell, "LAY_GOODS")
	local TFD_NAME = m_fnGetWidget(layCell, "TFD_NAME")
	local goodsItem = RewardUtil.parseRewards(cellData.items)[1]
	LAY_GOODS:removeAllChildren()
	LAY_GOODS:addChild(goodsItem.icon)
	local size = LAY_GOODS:getSize()
	goodsItem.icon:setPosition(ccp(size.width*.5,size.height*.5))
	TFD_NAME:setText(goodsItem.name)
	TFD_NAME:setColor(g_QulityColor[tonumber(goodsItem.quality)])

	local i18ntfd_needlv_des = m_fnGetWidget(layCell, "tfd_needlv_des") -- 兑换需要等级：

	local TFD_NEEDLV = m_fnGetWidget(layCell, "TFD_NEEDLV")
	TFD_NEEDLV:setText(cellData.needLvl)
	local i18ntfd_times = m_fnGetWidget(layCell, "tfd_times") -- 兑换次数：
	local TFD_TIMES_NUM = m_fnGetWidget(layCell, "TFD_TIMES_NUM") --
	TFD_TIMES_NUM:setText(cellData.canBuyNum)

	local BTN_EXCHANGE = m_fnGetWidget(layCell, "BTN_EXCHANGE")
	BTN_EXCHANGE:setTag(index)
	UIHelper.titleShadow(BTN_EXCHANGE, m_i18n[2203])
	BTN_EXCHANGE:addTouchEventListener(m_tbEvent.onBuy)
	if(cellData.canBuyNum<=0) then
		BTN_EXCHANGE:setGray(true)
		BTN_EXCHANGE:setTouchEnabled(false)
	else
		BTN_EXCHANGE:setTouchEnabled(true)
		BTN_EXCHANGE:setGray(false)
	end

	local layGold = m_fnGetWidget(layCell, "LAY_COST_GOLD")
	local layBelly = m_fnGetWidget(layCell, "LAY_COST_BELLY")
	local laySky = m_fnGetWidget(layCell, "LAY_COST_SKY")
	local labNum = nil
	if tonumber(cellData.costType) == 1 then -- 空岛币
		laySky:setEnabled(true)
		layBelly:setEnabled(false)
		layGold:setEnabled(false)
		labNum = m_fnGetWidget(laySky, "TFD_SKY")
		local i18nlab =  m_fnGetWidget(laySky, "tfd_sky_txt")
		i18nlab:setText(m_i18n[5439])
	elseif tonumber(cellData.costType) == 2 then -- 金币
		layGold:setEnabled(true)
		layBelly:setEnabled(false)
		laySky:setEnabled(false)
		labNum = m_fnGetWidget(layGold, "TFD_GOLD")
		local i18nlab =  m_fnGetWidget(layGold, "tfd_gold_txt")
		i18nlab:setText(m_i18n[5438])
	elseif tonumber(cellData.costType) == 3 then -- 贝里
		layBelly:setEnabled(true)
		layGold:setEnabled(false)
		laySky:setEnabled(false)
		labNum = m_fnGetWidget(layBelly, "TFD_BELLY")
		local i18nlab =  m_fnGetWidget(layBelly, "tfd_belly_txt")
		i18nlab:setText(m_i18n[1521])
	end
	if labNum then
		labNum:setText(cellData.costNum)
	end
end


-- 初始化以及刷新 下面显示道具或者金币 显示UI 
function initRfrLab(  )
	local itemNum = SkyPieaModel.getRfrItemNum()

	if itemNum >0 then
		m_labItemNum:setText(itemNum)
		m_layRfrGold:setEnabled(false)
		m_layRfrItem:setEnabled(true)
	else
		m_layRfrGold:setEnabled(true)
		m_layRfrGold:setVisible(true)
		m_layRfrItem:setEnabled(false)
		m_labGoldNum:setText(tostring(SkyPieaModel.getRfrGoldNum()))
	end
end

-- 刷新 整个UI
function updateUI( ... )
	if m_scheduleId ~= nil then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(m_scheduleId)
		m_scheduleId = nil	
	end
	if( m_scheduleId  == nil )then
		m_scheduleId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(updateTimeLab, 1, false)
	end
	loadUI()
end
-- 加载商店UI
function loadUI( )
	local img_bg = m_fnGetWidget(m_mainWidget, "img_bg")
	img_bg:setScale(g_fScaleX)
	local lay_info_shop = m_fnGetWidget(m_mainWidget, "lay_info_shop")
	local btnBack = m_fnGetWidget(lay_info_shop, "BTN_BACK")
	UIHelper.titleShadow(btnBack, m_i18n[1019])
	btnBack:addTouchEventListener(m_tbEvent.onBack)

	local lay_bottom = m_fnGetWidget(m_mainWidget, "lay_bottom")

	local btnRfr = m_fnGetWidget(lay_bottom, "BTN_REFRESH")
	UIHelper.titleShadow(btnRfr, m_i18nString(5467," "))
	btnRfr:addTouchEventListener(m_tbEvent.onRfr)

	m_tbLabs.labRfr = m_fnGetWidget(lay_bottom, "TFD_REFRESH")
	updateTimeLab()
	

	m_layRfrItem = m_fnGetWidget(m_mainWidget, "LAY_REFRESH_ITEM")
	-- local i18ntfd_own = m_fnGetWidget(m_layRfrItem, "tfd_own") --拥有某某道具：
	m_labItemNum = m_fnGetWidget(m_layRfrItem, "tfd_own_num") 

	m_layRfrGold = m_fnGetWidget(m_mainWidget, "LAY_REFRESH_GOLD")
	-- local i18ntfd_gold_cost = m_fnGetWidget(m_layRfrGold, "tfd_gold_cost") -- 花费金币：
	m_labGoldNum = m_fnGetWidget(m_layRfrGold, "tfd_gold_cost_num")

	initRfrLab()

	listView = m_fnGetWidget(m_mainWidget, "LSV_MAIN")

	local tbGoodsData = SkyPieaModel.getSkyPieaGoodsList()
	if listView:getItems():count() >0 then
		UIHelper.initListView(listView)
	end
	
	local nIdx
	for i,cellData in ipairs( tbGoodsData or {}) do
		listView:pushBackDefaultItem()
		nIdx = i - 1
		local cell = listView:getItem(nIdx)  -- cell 索引从 0 开始
		loadCell(cell,cellData,i)
		local lay = m_fnGetWidget(cell, "LAY_TEST")
        UIHelper.startCellAnimation(lay, i, function ( ... )
        	logger:debug("动画播放完成了")
        end, 1)
	end
	m_bReSize = true


end

-- 获取当前兑换的cell 
function getCellItemById( nIdx )
	return listView:getItem(nIdx-1)
end

-- 更新当前兑换的cell 以及UI显示的金币 等
function updateCellAndLabs( nIdx, goods )
	loadCell(getCellItemById(nIdx),goods, nIdx, true)
end

--[[
	@desc: 创建
    @param 	tbEvent  type:  table 按钮 绑定事件
    @return: m_mainWidget  type: userdata air_shop 主画布
—]]
function create(tbEvent)
	m_bReSize = false
	m_tbEvent = tbEvent
	m_mainWidget = g_fnLoadUI(json)
	loadUI()
	schedule()

	return m_mainWidget
end
