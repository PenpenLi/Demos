-- FileName: ChaWelView.lua
-- Author: liweidong
-- Date: 2015-10-19
-- Purpose: function description of module
--[[TODO List]]

module("ChaWelView", package.seeall)

-- UI控件引用变量 --
local _layoutMain = nil
-- 模块局部变量 --
local _endTime = 0 --结束时间点
local m_i18n = gi18n


local function init(...)

end

function destroy(...)
	package.loaded["ChaWelView"] = nil
end

function moduleName()
    return "ChaWelView"
end

--国际化
function setUIStyleAndI18n(base)
	base.tfd_time:setText(m_i18n[6601])
	local cell = tolua.cast(base.LSV_TOTAL:getItem(0),"Widget")
	cell.tfd_jindu:setText(m_i18n[6603])
	cell.BTN_TOGO:setTitleText(m_i18n[4388])
	cell.BTN_GET_REWARD:setTitleText(m_i18n[4342])
	-- base.BTN_TAB1:setTitleText(m_i18n[6905])
	-- base.BTN_TAB2:setTitleText(m_i18n[6906])

	-- UIHelper.titleShadow(base.BTN_RECORD)
	-- UIHelper.titleShadow(base.BTN_BACK)
	UIHelper.labelNewStroke( base.tfd_time, ccc3(0x28,0x00,0x00), 2 )
	UIHelper.labelNewStroke( base.tfd_time_num, ccc3(0x28,0x00,0x00), 2 )
	
end
--加载UI
function loadUI()
	_layoutMain = g_fnLoadUI("ui/activity_challenge_welfare.json")
	UIHelper.registExitAndEnterCall(_layoutMain,
			function()
				_layoutMain=nil
			end,
			function()
			end
		)
	setUIStyleAndI18n(_layoutMain)
	local chawelDb = ChaWelModel.getCurActitveDbInfo()
	logger:debug("images/challengewel/" .. chawelDb.title)
	logger:debug({chawelDb=chawelDb})
	_layoutMain.img_title:loadTexture("images/challengewel/" .. chawelDb.title)
	_layoutMain.TFD_DESC:setText(chawelDb.desc)
	_layoutMain.img_main_bg:setScale(g_fScaleX)
	UIHelper.initListView(_layoutMain.LSV_TOTAL)
	

	updateReMainTimes()
	updateUI()
	-- _layoutMain.BTN_TAB1:addTouchEventListener(function ( sender, eventType )
	-- 	if (eventType == TOUCH_EVENT_ENDED) then
	-- 		AudioHelper.playMainUIEffect()
	-- 		SBListCtrl.onclickItemTag()
	-- 	end
	-- end)
	-- _layoutMain.BTN_TAB2:addTouchEventListener(function ( sender, eventType )
	-- 	if (eventType == TOUCH_EVENT_ENDED) then
	-- 		AudioHelper.playMainUIEffect()
	-- 		SBListCtrl.onclickFragTag()
	-- 	end
	-- end)
	-- _layoutMain.BTN_EXPANG:addTouchEventListener(function ( sender, eventType )
	-- 	if (eventType == TOUCH_EVENT_ENDED) then
	-- 		AudioHelper.playMainUIEffect()
	-- 		SBListCtrl.onExpand(_listType)
	-- 	end
	-- end)
end
--更新界面
function updateUI()
	local listData = ChaWelModel.getListData()
	UIHelper.initListWithNumAndCell(_layoutMain.LSV_TOTAL,#listData)
	for i=1,#listData do
		local cell = tolua.cast(_layoutMain.LSV_TOTAL:getItem(i-1),"Widget")
		local item = listData[i]
		cell.tfd_cell_1:setText(item.db.task_desc)
		cell.TFD_CELL_2:setText(item.needNum)
		cell.tfd_cell_3:setText(item.timeUnit)
		cell.TFD_LEFT:setText(item.haveNum)
		cell.TFD_RIGHT:setText(item.needNum)
		cell.BTN_GET_REWARD:setTag(i)
		cell.BTN_TOGO:setTag(i)
		cell.BTN_GET_REWARD:addTouchEventListener(function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				-- AudioHelper.playMainUIEffect()
				ChaWelCtrl.onClickGetReward(sender:getTag())
			end
		end)
		cell.BTN_TOGO:addTouchEventListener(function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playMainUIEffect()
				ChaWelCtrl.onToComplet(sender:getTag())
			end
		end)
		if (item.rewardStatus==1) then
			cell.BTN_GET_REWARD:setEnabled(false)
			cell.BTN_TOGO:setEnabled(false)
			cell.img_already_got:setVisible(true)
		else
			cell.img_already_got:setVisible(false)
			if (tonumber(item.haveNum)>=tonumber(item.needNum)) then
				cell.BTN_GET_REWARD:setEnabled(true)
				UIHelper.titleShadow(cell.BTN_GET_REWARD)
				cell.BTN_TOGO:setEnabled(false)
			else
				cell.BTN_GET_REWARD:setEnabled(false)
				cell.BTN_TOGO:setEnabled(true)
				UIHelper.titleShadow(cell.BTN_TOGO)
			end
		end
		local rewardData = RewardUtil.parseRewards(item.reward)
		logger:debug({rewardData = rewardData})
		-- local rewards = lua_string_split(item.reward,",")
		for i=1,4 do
			cell["img_reward"..i]:removeAllChildrenWithCleanup(true)
			if (rewardData[i]) then
				cell["img_reward"..i]:addChild(rewardData[i].icon)
				cell["tfd_name"..i]:setText(rewardData[i].name)
				cell["tfd_name"..i]:setColor(g_QulityColor[rewardData[i].quality])
				cell["LAY_CLONE"..i]:setVisible(true)
			else
				cell["LAY_CLONE"..i]:setVisible(false)
			end
		end
	end
end
--更新剩余时间
function updateReMainTimes()
	local nowTime = TimeUtil.getSvrTimeByOffset()
	-- local format = "%Y%m%d%H%M%S"
	local times = _endTime-nowTime
	_layoutMain.tfd_time_num:setText(TimeUtil.getTimeDesByInterval(times))
end
--判断活动是否已经结束
function isActiveEnd()
	local nowTime = TimeUtil.getSvrTimeByOffset()
	return _endTime-nowTime<0
end
function create(...)
	_endTime = ChaWelModel.getActitiveyRemainTimes() --进入界面时只调用一次 防止在界面停留跨天无法判断任务已经结束
	loadUI()
	schedule(_layoutMain,updateReMainTimes,1)
	return _layoutMain
end
