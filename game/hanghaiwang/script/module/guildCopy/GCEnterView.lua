-- FileName: GCEnterView.lua
-- Author: liweidong
-- Date: 2015-06-01
-- Purpose: 进入据点预览
--[[TODO List]]

module("GCEnterView", package.seeall)

-- UI控件引用变量 --
local _layoutMain=nil
-- 模块局部变量 --
local _copyID=nil
local _copyDb=nil
local m_i18n=gi18n

local function init(...)

end

function destroy(...)
	package.loaded["GCEnterView"] = nil
end

function moduleName()
    return "GCEnterView"
end
--创建奖励列表
function createRewardList()
	local tbRewardData = RewardUtil.getItemsDataByStr(_copyDb.reward_id)
	local _tbItems = RewardUtil.parseRewardsByTb(tbRewardData)
	UIHelper.initListView(_layoutMain.LSV_REWARD_BIG)
	local tbSortData = {}
	local tbSub = {}
	for i,v in ipairs(_tbItems) do
		table.insert(tbSub,v)
		if(table.maxn(tbSub)>=4) then
			table.insert(tbSortData,tbSub)
			tbSub = {}
		elseif(i==table.maxn(_tbItems)) then
			table.insert(tbSortData,tbSub)
			tbSub = {}
		end
	end

	local cell = nil
	for i, itemInfo in ipairs(tbSortData) do
		_layoutMain.LSV_REWARD_BIG:pushBackDefaultItem()
		cell = _layoutMain.LSV_REWARD_BIG:getItem(i-1)  -- cell 索引从 0 开始
		for s,item in ipairs(itemInfo) do
			local itemlay=g_fnGetWidgetByName(cell,"lay_recruit_bg"..s)
			local img = g_fnGetWidgetByName(itemlay,"IMG_SHOP_RECRUIT_PREVIEW_HEAD_BG")
			img:addChild(item.icon)
			local labName = g_fnGetWidgetByName(itemlay, "TFD_SHOP_RECRUIT_PREVIEW_NAME") -- 名称
			labName:setText(item.name)
			if (item.quality ~= nil) then
				local color =  g_QulityColor2[tonumber(item.quality)]
				if(color ~= nil) then
					labName:setColor(color)
				end
			end
			if (s == table.maxn(itemInfo) and s < 4) then --移除剩余的
				for j=s+1,4 do
					local itemlay=g_fnGetWidgetByName(cell,"lay_recruit_bg"..j)
					itemlay:removeFromParent()
				end
			end	
		end

	end
end
--国际化
function setUIStyleAndI18n(base)
	-- base.TFD_LIMIT:setText("需通关阿拉巴斯坦普通副本并达到50级才可以进入")
	base.LAY_BTN_1.BTN_ENTER:setTitleText(m_i18n[3104])--TODO
	base.LAY_BTN_2.BTN_RESET:setTitleText(m_i18n[4377])--TODO
	base.LAY_BTN_2.BTN_ENTER:setTitleText(m_i18n[3104])--TODO

	UIHelper.titleShadow(base.LAY_BTN_1.BTN_RESET)
	UIHelper.titleShadow(base.LAY_BTN_1.BTN_ENTER)
	UIHelper.titleShadow(base.LAY_BTN_2.BTN_ENTER)
	UIHelper.titleShadow(base.BTN_CLOSE)
	
	UIHelper.labelNewStroke( base.TFD_LIMIT, ccc3(0x28,0x00,0x00), 2 )
	UIHelper.labelNewStroke( base.TFD_COPY_NAME, ccc3(0x28,0x00,0x00), 2 )
end
--初始化UI
function initUI()
	_layoutMain = g_fnLoadUI("ui/union_copy_preview.json")
	UIHelper.registExitAndEnterCall(_layoutMain,
			function()
				_layoutMain=nil
			end,
			function()
			end
		) 
	setUIStyleAndI18n(_layoutMain)
	_layoutMain.TFD_COPY_NAME:setText(_copyDb.name)
	--创建列表
	createRewardList()
	--隐藏按钮
	local identity = GuildDataModel.getUserGuildIdentity()
	if (tonumber(identity)==0) then --普通成员
		_layoutMain.BTN_RESET:setEnabled(false)
		_layoutMain.LAY_BTN_2.BTN_ENTER:setEnabled(false)
	else --会长或副会长
		_layoutMain.LAY_BTN_1.BTN_ENTER:setEnabled(false)
	end
	--显示进入条件
	require "script/module/guildCopy/GuildCopyModel"
	local enterStatus,enterStr = GuildCopyModel.isCanEnterGuildCopy(_copyID)
	if (enterStatus) then
		_layoutMain.TFD_LIMIT:setVisible(false)
	else
		_layoutMain.TFD_LIMIT:setText(enterStr)
	end
	--按钮事件
	local function onEnter(sender, eventType )
		if (eventType ~= TOUCH_EVENT_ENDED) then
			return
		end
		AudioHelper.playCommonEffect()
		GCEnterCtrl.onEnterCopyHold(_copyID)
	end
	_layoutMain.LAY_BTN_1.BTN_ENTER:addTouchEventListener(onEnter)
	_layoutMain.LAY_BTN_2.BTN_ENTER:addTouchEventListener(onEnter)
	_layoutMain.BTN_CLOSE:addTouchEventListener(UIHelper.onClose)
	--重置事件
	local function onReset(sender, eventType )
		if (eventType ~= TOUCH_EVENT_ENDED) then
			return
		end
		AudioHelper.playCommonEffect()
		GCEnterCtrl.onResetCopy(_copyID)
	end
	_layoutMain.BTN_RESET:addTouchEventListener(onReset)

	return _layoutMain
end

function create(id)
	_copyID=id
	require "db/DB_Legion_newcopy"
	_copyDb=DB_Legion_newcopy.getDataById(id)
	return initUI()
end
