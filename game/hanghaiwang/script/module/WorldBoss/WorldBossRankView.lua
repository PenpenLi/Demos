-- FileName: WorldBossRankView.lua
-- Author: zhangqi
-- Date: 2015-01-22
-- Purpose: 世界Boss伤害排行榜UI
--[[TODO List]]

-- module("WorldBossRank", package.seeall)

-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString 	= gi18nString
local m_fnGetWidget = g_fnGetWidgetByName

WorldBossRankView = class("WorldBossRankView")

function WorldBossRankView:ctor()
	self.layMain = g_fnLoadUI("ui/world_boss_rank.json")
end

function WorldBossRankView:create( ... )
	local layRoot = self.layMain
	layRoot.BTN_CLOSE:addTouchEventListener(UIHelper.onClose)
	layRoot.TFD_LINE2:setText(m_i18n[6033])
	layRoot.TFD_LINE1:setText(m_i18n[6034])
	layRoot.TFD_LINE3:setText(m_i18n[6035])

	-- 列表
	local lsvList = layRoot.LSV_MAIN
	-- 初始化listview
	UIHelper.initListView(lsvList)
	-- 开启裁切
	lsvList:setClippingEnabled(true)
	lsvList:removeAllItems() -- 清除列表

	local tbRank = WorldBossModel.getAttackRank()
	logger:debug({tbRank = tbRank})
	if (not table.isEmpty(tbRank)) then
		lsvList:setTouchEnabled(true)
		local nIdx, cell = -1, nil
		-- LAY_RANK[IMG_RANK_BG, LABN_RANK, img_photo, TFD_NAME, TFD_LV, TFD_LEGION_NAME[军团名称]，TFD_DPS_INFO["伤害血量："], TFD_DPS_NUM]
		for i, item in ipairs(tbRank) do
			lsvList:pushBackDefaultItem()
			nIdx = nIdx + 1
			cell = lsvList:getItem(nIdx)  -- cell 索引从 0 开始

			-- 判断显示哪个底板
			local img_bg = {cell.IMG_RANK_BG1, cell.IMG_RANK_BG2, cell.IMG_RANK_BG3, cell.IMG_RANK_BG4}
			local rankLevel = i > 4 and 4 or i
			for k,v in pairs(img_bg) do
				v:setVisible(false)
			end
			img_bg[rankLevel]:setVisible(true)

			-- 名次的不同颜色
			local tColors = {
				ccc3(0xc8, 0x50, 0x00),
				ccc3(0x6c, 0x6a, 0x68),
				ccc3(0x9f, 0x4f, 0x36),
				ccc3(0x82, 0x57, 0x00),
			}
			cell.TFD_LV_INFO:setColor(tColors[rankLevel])
			cell.TFD_DPS_INFO:setColor(tColors[rankLevel])

			cell.LABN_RANK:setStringValue(i)
			--cell.TFD_LEGION_NAME:setText(tbRank[i].guild_name or "")
			cell.TFD_LV:setText(tbRank[i].level or "1")
			cell.TFD_NAME:setText(tbRank[i].name or "")
			local nameColor = UserModel.getPotentialColor({htid = tbRank[i].figure}) -- 2015-07-29
			cell.TFD_NAME:setColor(nameColor)
			cell.TFD_DPS_NUM:setText(tbRank[i].hpCost or "0")
			
			local imgHead = HeroUtil.createHeroIconBtnByHtid(tbRank[i].figure)
			local img_photo = m_fnGetWidget(cell , "img_photo")
			img_photo:addChild(imgHead)
			img_photo:setZOrder(2)
			-- 头像 
			UIHelper.titleShadow(cell.BTN_FORMATION , m_i18n[2215])
			cell.BTN_FORMATION:addTouchEventListener(function ( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					AudioHelper.playCommonEffect()
					require "script/module/formation/FormationCtrl"
					FormationCtrl.loadFormationWithUid(tbRank[i].uid)
				end	
			end)	
		end
	end

	return self.layMain
end