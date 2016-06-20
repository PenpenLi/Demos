-- FileName: LevelRewardCopyView.lua
-- Author: menghao
-- Date: 2014-07-01
-- Purpose: 副本处的等级礼包view


module("LevelRewardCopyView", package.seeall)


-- UI控件引用变量 --
local m_UIMain

local m_imgBG

local m_btnClose
local m_btnGet
local m_btnPreview

local m_tfdLimit
local m_tfdProgress
local m_loadProgress
local m_tfdLevelOwn
local m_tfdLevelLimit

local m_imgFrame
local m_tfdName
local m_tfdDesc


-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_tbItems


local function init(...)

end


function destroy(...)
	package.loaded["LevelRewardCopyView"] = nil
end


function moduleName()
	return "LevelRewardCopyView"
end


-- add by huxiaozhou
-- 默认的关闭按钮事件
local function onConfirm(  )
	LayerManager.removeLayout()
end



local function receiveCallback(rid)
	local tbItem = {}
	for i=1,#m_tbItems do
		local tb = {}
		tb.icon = UIHelper.getItemIconAndUpdate(m_tbItems[i].icon.reward_type, m_tbItems[i].icon.reward_values)
		tb.name = m_tbItems[i].name
		tb.quality = m_tbItems[i].quality
		table.insert(tbItem, tb)
	end
	local layReward = UIHelper.createGetRewardInfoDlg( gi18n[1904], tbItem, onConfirm)
	LayerManager.addLayout(layReward)

	require "script/module/levelReward/LevelRewardCtrl"
	LevelRewardCtrl.setRewardStatus(rid)
	upUIByInfo(LevelRewardCtrl.getCurRewardInfo())
	MainShip.fnSetBtnLevel()
	-- itemCopy.initBtnLevel(LevelRewardCtrl.getCurRewardInfo())
end


-- 领取按钮的回调函数
local function btnGetCallback(rid)
	for i=1,#m_tbItems do
		-- 判断背包是否已满
		local rewardType = tonumber(m_tbItems[i].icon.reward_type)
		if (rewardType == 4 or rewardType == 5 or rewardType == 6 or rewardType == 7) then
			if (ItemUtil.isBagFullExPartner(true)) then
				return
			end
		end
		if (rewardType == 10) then
			if ItemUtil.isPartnerFull(true) then
				return
			end
		end
	end

	local args = CCArray:create()
	args:addObject(CCInteger:create(rid))
	RequestCenter.levelfund_gainLevelfundPrize(
		function (cbFlag, dictData, bRet)
			if(dictData.err ~= "ok")then
				return
			end
			-- LayerManager.removeLayout()
			receiveCallback(rid)
		end, args)
end


function upUIByInfo( tbInfo )
	if tbInfo == nil then
		m_btnGet:setTouchEnabled(false)
		m_btnGet:setGray(true)
		return
	end

	if tbInfo.status == 0 then
		m_btnGet:setTouchEnabled(false)
		m_btnGet:setGray(true)
	end
	m_btnGet:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			btnGetCallback(tbInfo.rid)
		end
	end)

	UIHelper.labelEffect(m_tfdLimit, tbInfo.level)
	UIHelper.labelEffect(m_tfdProgress, gi18n[2502])
	UIHelper.labelEffect(m_tfdLevelOwn, UserModel.getHeroLevel())
	UIHelper.labelEffect(m_tfdLevelLimit, tbInfo.level)

	m_loadProgress:setPercent(math.floor(UserModel.getHeroLevel() / tbInfo.level * 100))

	m_tbItems = tbInfo.item

	local button = UIHelper.getItemIcon(m_tbItems[1].icon.reward_type, m_tbItems[1].icon.reward_values)
	m_imgFrame:removeAllChildren()
	m_imgFrame:addChild(button)
	UIHelper.labelEffect(m_tfdName, m_tbItems[1].name)
	m_tfdName:setColor(g_QulityColor2[m_tbItems[1].quality])
	m_tfdDesc:setText(m_tbItems[1].desc)

	for i=1,4 do
		local imgFrame = m_fnGetWidget(m_UIMain, "IMG_FRAME" .. i)
		local tfdName = m_fnGetWidget(m_UIMain, "TFD_GOODS_NAME" .. i)

		local item = m_tbItems[i]
		if item then
			local button = UIHelper.getItemIcon(item.icon.reward_type, item.icon.reward_values)
			imgFrame:removeAllChildren()
			imgFrame:addChild(button)
			UIHelper.labelEffect(tfdName, item.name)
			tfdName:setColor(g_QulityColor2[item.quality])

			imgFrame:setEnabled(true)
			tfdName:setEnabled(true)
		else
			imgFrame:setEnabled(false)
			tfdName:setEnabled(false)
		end
	end
end


function create( tbInfo )
	m_UIMain = g_fnLoadUI("ui/reward_level_copy.json")

	m_imgBG = m_fnGetWidget(m_UIMain, "IMG_BG")
	m_imgBG:setScale9Enabled(true)

	m_btnClose = m_fnGetWidget(m_UIMain, "BTN_CLOSE")
	m_btnGet = m_fnGetWidget(m_UIMain, "BTN_GET")
	m_btnPreview = m_fnGetWidget(m_UIMain, "BTN_PREVIEW")

	m_tfdLimit = m_fnGetWidget(m_UIMain, "TFD_LIMIT")
	m_tfdProgress = m_fnGetWidget(m_UIMain, "tfd_progress")
	m_loadProgress = m_fnGetWidget(m_UIMain, "LOAD_PROGRESS")
	m_tfdLevelOwn = m_fnGetWidget(m_UIMain, "TFD_LEVEL_OWN")
	m_tfdLevelLimit = m_fnGetWidget(m_UIMain, "TFD_LEVEL_LIMIT")

	m_imgFrame = m_fnGetWidget(m_UIMain, "IMG_FRAME")
	m_tfdName = m_fnGetWidget(m_UIMain, "TFD_GOODS_NAME")
	m_tfdDesc = m_fnGetWidget(m_UIMain, "TFD_DES")

	-- 控件初始化
	m_btnClose:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCloseEffect()
			LayerManager.removeLayout()
		end
	end)
	UIHelper.titleShadow(m_btnGet, gi18n[2628])

	m_btnPreview:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()

			LevelRewardCtrl.create(2) -- 传2进入列表
		end
	end)

	m_imgBG:setScale(g_fScaleX)

	upUIByInfo(tbInfo)
	return m_UIMain
end

