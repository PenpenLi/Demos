-- FileName: AdvSingleBoxView.lua
-- Author: zhangjunwu
-- Date: 2015-04-00
-- Purpose: 奇遇事件：奇遇宝箱 界面模块

module("AdvSingleBoxView", package.seeall)

-- UI控件引用变量 --
local m_UIMain 		= nil 
local TFD_TIME_NUM = nil 
-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_i18nString  = gi18nString
local m_tbAdvData = nil
local tbInfo =nil 
local m_nTimeToOpen = 0 
local m_tbEvent = nil
local m_timeStr = "00:00:00"
local function init(...)

end

function destroy(...)
	package.loaded["AdvSingleBoxView"] = nil
end

function moduleName()
    return "AdvSingleBoxView"
end



function getCDTime()
	return TFD_TIME_NUM:getStringValue()
end


function updateCD(stime)
	logger:debug(stime)
    local nSecond = TimeUtil.getSecondByTime(stime)
    local nTotleTime = tbInfo.time
    local nTimePassed = nTotleTime - nSecond
    local nTimeCanOpen = m_nTimeToOpen - nTimePassed
    -- logger:debug("距离奇遇结束的时间为:" .. nSecond)
    -- logger:debug("表中配的奇遇持续的时间为:" .. nTotleTime)
    -- logger:debug("从开始奇遇到现在已经过去的的时间为:" .. nTimePassed)
    -- logger:debug("距离可以开启宝箱的的时间为:" .. nTimeCanOpen)
    nTimeCanOpen = nTimeCanOpen < 0 and 0 or nTimeCanOpen

    local strTime = TimeUtil.getTimeString(nTimeCanOpen)
   	-- logger:debug(strTime)
   	-- logger:debug(TimeUtil.getTimeString(nTimeCanOpen))
    TFD_TIME_NUM:setText(strTime)

    setBtnEvent()
end

function setBtnEvent( )
	local btnOpenedBox = m_fnGetWidget(m_UIMain,"BTN_BOX_1_1")
	local btnEmptyBox = m_fnGetWidget(m_UIMain,"BTN_BOX_1_2")
	local btnCloseBox = m_fnGetWidget(m_UIMain,"BTN_BOX_1_3")

	btnOpenedBox:setEnabled(false)
	btnEmptyBox:setEnabled(false)
	btnCloseBox:setEnabled(false)


	logger:debug(getCDTime())
	logger:debug(m_timeStr)
	if(getCDTime() ~= m_timeStr)then 
		btnCloseBox:setEnabled(true)
		btnCloseBox:addTouchEventListener(m_tbEvent.onOpenBox)
		return
	end 

	if(m_tbAdvData.complete == nil) then
		btnOpenedBox:setEnabled(true)
		btnOpenedBox:addTouchEventListener(m_tbEvent.onOpenBox)
	else
		btnEmptyBox:setEnabled(true)
	end
end

function create(tbEvent,tbAdvBoxData)
	m_UIMain = g_fnLoadUI("ui/magical_thing_box.json")
	m_tbAdvData = tbAdvBoxData
	logger:debug(tbAdvBoxData)
	m_tbEvent 	= tbEvent
	tbInfo = DB_Exploration_things.getDataById(tbAdvBoxData.etid)

	m_nTimeToOpen = tonumber(tbInfo.qiyuTime)
	logger:debug("此次奇遇时间的剩余时间为:" .. m_nTimeToOpen)
	-- qiyuTime
	local img_bg = m_fnGetWidget(m_UIMain,"img_bg")
	img_bg:setScale(g_fScaleX)	

	local img_desc_bg = m_fnGetWidget(m_UIMain,"img_desc_bg")
	-- img_desc_bg:setScaleX(g_fScaleX)

	local img_info_bg = m_fnGetWidget(m_UIMain,"img_info_bg")
	-- img_info_bg:setScaleX(g_fScaleX)
	--声明远播
	local tfd_title = m_fnGetWidget(m_UIMain,"TFD_TITLE")
	tfd_title:setText(tbInfo.title)
	UIHelper.labelNewStroke(tfd_title, ccc3(0x28,0,0),2)

	
	--船长，你敢信？前进的路上竟然莫
	local tfd_des = m_fnGetWidget(m_UIMain,"TFD_DESC")
	tfd_des:setText(tbInfo.desc)
	--宝箱消失时间:
	local tfd_time = m_fnGetWidget(m_UIMain,"tfd_time")
	tfd_time:setText(m_i18nString(4362))
	TFD_TIME_NUM 	= m_fnGetWidget(m_UIMain,"TFD_TIME_NUM")

	UIHelper.labelNewStroke(TFD_TIME_NUM, ccc3(0x28,0,0),2)
	UIHelper.labelNewStroke(tfd_time, ccc3(0x28,0,0),2)
	UIHelper.labelNewStroke(tfd_title, ccc3(0x28,0,0),2)
	UIHelper.labelNewStroke(tfd_des, ccc3(0x28,0,0),2)
	--todo 国际化

	--可能获得奖励:
	local tfd_probability = m_fnGetWidget(m_UIMain,"tfd_probability")
	--todo 国际化


	logger:debug(tbInfo.qiyuBoxView)
	local tbReward = lua_string_split(tbInfo.qiyuBoxView ,"|")

	local btn_item  =  nil
	local btn_name  = nil
	for i=1,6 do
		btn_item = m_fnGetWidget(m_UIMain,"BTN_ITEM_BG_" .. i)
		btn_item:setEnabled(false)

	 	btn_name = m_fnGetWidget(m_UIMain,"tfd_item_name_" .. i) 
	 	btn_name:setEnabled(false)
	end

	local itemData = nil 
	for i,v in ipairs(tbReward) do
		btn_item = m_fnGetWidget(m_UIMain,"BTN_ITEM_BG_" .. i)
		btn_item:setEnabled(true)

		local btn_name = m_fnGetWidget(m_UIMain,"tfd_item_name_" .. i)
		btn_name:setEnabled(true)

		local itemInfo = ItemUtil.getItemById(tonumber(v))
		btn_name:setText(itemInfo.name)
		btn_name:setColor(g_QulityColor[itemInfo.quality])

		local icon = ItemUtil.createBtnByTemplateId(v,
						function ( sender, eventType )  -- 道具图标按钮事件，弹出道具信息框
							if (eventType == TOUCH_EVENT_ENDED) then
								PublicInfoCtrl.createItemInfoViewByTid(v,nil)
							end
						end) 
		btn_item:addChild(icon)
	end

	logger:debug(tbInfo)

	return m_UIMain
end
