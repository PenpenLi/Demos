-- FileName: WorldBossPreview.lua
-- Author: zhangqi
-- Date: 2015-01-22
-- Purpose: 世界Boss信息预览UI
--[[TODO List]]

-- module("WorldBossPreview", package.seeall)

-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString 	= gi18nString
local m_fnGetWidget = g_fnGetWidgetByName
local m_worldModel  = WorldBossModel

WorldBossPreview = class("WorldBossPreview")

function WorldBossPreview:ctor()
	self.layMain = g_fnLoadUI("ui/world_boss_tip.json")
end

function WorldBossPreview:createBossTime(bossInfo)
	------- 创建富文本 --------
	local tbWdays = {}
	local dayStr = {m_i18n[1956], m_i18n[1957], m_i18n[1958], m_i18n[1959], m_i18n[1960], m_i18n[1961], m_i18n[4321]}	-- 一..日
	for i, num in ipairs(string.strsplit(bossInfo.week, "|")) do
		tbWdays[i] = dayStr[tonumber(num)]
	end
	--local tTxt = {"每周", table.concat(tbWdays, ","), string.match(bossInfo.beginTime, "(%d%d)(%d%d)(%d%d)")}
 	--local strTxt = string.format("每周%s %s:%s开启", table.concat(tbWdays, ","), string.match(bossInfo.beginTime, "(%d%d)(%d%d)(%d%d)"))
 	local tTxt = {m_i18n[6028], table.concat(tbWdays, ","), m_i18n[4007]}

	local colors = {ccc3(0x7f, 0x5f, 0x20), ccc3(0x57, 0x1e, 0x01), ccc3(0x7f, 0x5f, 0x20)}
	local tbColor = {}
	for k,v in pairs(colors) do
		local data = {color = v, font = g_sFontCuYuan, size = 22}
		table.insert(tbColor, data)
	end

 	-- 数据源
 	local richStr =  UIHelper.concatString(tTxt)
 	local textInfo = {richStr, tbColor}

 	local richText = BTRichText.create(textInfo, nil, nil)
 	return richText
end

function WorldBossPreview:create( ... )
	local layRoot = self.layMain
	local btnClose = m_fnGetWidget(layRoot, "BTN_CLOSE") -- 关闭按钮
	btnClose:addTouchEventListener(UIHelper.onClose)

	-- Boss 列表
	local lsvList = layRoot.LSV_MAIN
	-- 初始化listview
	UIHelper.initListView(lsvList)
	-- 开启裁切
	lsvList:setClippingEnabled(true)
	lsvList:removeAllItems() -- 清除列表

	local tbBoss = m_worldModel.getAllBossDb()
	logger:debug({tbBoss = tbBoss})
	if (not table.isEmpty(tbBoss)) then
		local nIdx, cell = -1, nil
		
		for i, boss in ipairs(tbBoss) do
			lsvList:pushBackDefaultItem()
			nIdx = nIdx + 1
			cell = lsvList:getItem(nIdx)  -- cell 索引从 0 开始

			-- IMG_BOSS, TFD_NAME, TFD_DPS, TFD_TIME, TFD_REWARD_TYPE
			local imgBoss = m_fnGetWidget(cell, "IMG_BOSS") -- Boss 形象
			-- local pName = string.format("%sbig%s.png",m_worldModel.getBossImageParth(),boss.model)
			local pName = string.format("%sbody_elite_jinhaizhiwang.png", WorldBossModel.getBossImageParth())
			imgBoss:loadTexture(pName)

			local labName = m_fnGetWidget(cell, "TFD_NAME") -- 名称
			labName:setText(boss.name)

			cell.TFD_DPS:setText(boss.desc) -- 描述

			-- 开启时间
			local richText = self:createBossTime(boss)
			richText:setSize(CCSize(cell.TFD_DPS:getSize().width, 0))
			richText:setAnchorPoint(ccp(cell.TFD_TIME:getAnchorPoint().x, cell.TFD_TIME:getAnchorPoint().y))
			richText:setPosition(ccp(0, cell.TFD_TIME:getContentSize().height/2))
			cell.TFD_TIME:addChild(richText)
			cell.TFD_TIME:setText("")
			--cell.TFD_TIME:setText(string.format("每周%s %s:%s开启", table.concat(tbWdays, ","), string.match(boss.beginTime, "(%d%d)(%d%d)(%d%d)")))

			local labReward = m_fnGetWidget(cell, "TFD_REWARD_TYPE") -- 奖励类型描述
		end
	end

	return self.layMain
end
