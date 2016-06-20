-- FileName: MainGrabTreaView.lua
-- Author: menghao
-- Date: 2014-12-26
-- Purpose: 改版后的夺宝主界面view


module("MainGrabTreaView", package.seeall)



-- UI控件引用变量 --
local m_UIMain

local m_tfdAvoidTxt
local m_tfdAvoidTime
local m_lsvGrab


-- 模块局部变量 --
local m_i18n = gi18n
local m_fnGetWidget = g_fnGetWidgetByName

local m_layTitleForCopy
local m_layTreasForCopy

local m_nOffsetY
local m_nCurTreasureID
local m_isShowGuideUI = nil
local m_nGuideTreaID = 503301


local function init(...)

end


function destroy(...)
	package.loaded["MainGrabTreaView"] = nil
end


function moduleName()
	return "MainGrabTreaView"
end


function upAllLsv( treaTid )
	m_lsvGrab:removeAllItems()
	-- 策划说排列顺序要是 生命 攻击 物防 魔防
	local tbType = {5, 3, 2, 4, 1}
	if BTUtil:getGuideState() then
		tbType = {3, 2, 4, 1, 5}
	end
	local tbAllTreaIds = TreasureData.getTreasureList()
	for i=1,#tbType do
		upLsvByIDs(tbAllTreaIds[tbType[i]], tbType[i])
	end

	-- if (m_nOffsetY) then
	-- 	-- local offSetY = 0 - layTreas:getPositionY() - layTreas:getSize().height - layTitle:getSize().height
	-- 	m_lsvGrab:setContentOffset(ccp(0, - m_nOffsetY - m_lsvGrab:getSize().height), false)
	-- 	m_nOffsetY = nil
	-- end

	performWithDelay(m_UIMain, function ( ... )
		if (m_nOffsetY) then
			local tHeight = (m_lsvGrab:getInnerContainerSize().height - m_lsvGrab:getSize().height)
			if (tHeight > 0) then
				local nPercent = (m_nOffsetY - m_lsvGrab:getSize().height) / tHeight * 100
				m_lsvGrab:scrollToPercentVertical(nPercent, 0.33, true)
			end
			m_nOffsetY = nil
		end
	end, 1 / 60)
end


local function update( ... )
	local tfdRewardProgress = m_fnGetWidget(m_UIMain, "tfd_reward_progress")
	local loadProgress = m_fnGetWidget(m_UIMain, "LOAD_PROGRESS")
	local labnLeft = m_fnGetWidget(m_UIMain, "LABN_LEFT")
	local labnRight = m_fnGetWidget(m_UIMain, "LABN_RIGHT")
	local tfdDesc = m_fnGetWidget(m_UIMain, "tfd_desc")
	local btnReward = m_fnGetWidget(m_UIMain, "BTN_REWARD")

	local min,max = ExplorData.getExploreProgress()
	labnLeft:setStringValue(tostring(min))
	labnRight:setStringValue(tostring(max))
	local npercent = min/max * 100
	loadProgress:setPercent((npercent > 100) and 100 or npercent)

	btnReward:removeAllChildrenWithCleanup(true)
	btnReward:removeAllNodes()

	if (min >= max) then
		local armature = UIHelper.createArmatureNode({
			filePath = "images/effect/qiandao_lingqu/qiandao_lingqu.ExportJson",
			animationName = "qiandao_lingqu",
		})
		btnReward:addNode(armature)
	end
	btnReward:addChild(ExploreProgressRewardCtrl.create(update))
end


local function afterSynthetic( bValue )
	if bValue then
		-- 弹出宝物信息
		require "script/module/treasure/NewTreaInfoCtrl"
		local layTreaInfo = NewTreaInfoCtrl.createBtTid(m_nCurTreasureID)
		LayerManager.addLayout(layTreaInfo)

		require "script/module/grabTreasure/ShowGetCtrl"
		local treaName = DB_Item_treasure.getDataById(m_nCurTreasureID).name
		layTreaInfo:addChild(ShowGetCtrl.create(m_nCurTreasureID, treaName, upAllLsv), 100)

		m_nCurTreasureID = nil
		-- 合成完刷新界面
		-- performWithDelay(m_UIMain, upAllLsv, 0.)
	else
		-- 合成失败提示
		LayerManager.addLayout(UIHelper.createCommonDlg(m_i18n[2439], nil, function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCloseEffect()
				LayerManager.removeLayout()
			end
		end, 1))
		-- 合成失败后重新拉数据再刷新界面
		TreasureService.getSeizerInfo( function ( ... )
			upAllLsv()
		end )
	end
	m_nCurTreasureID = nil
end


function upLsvByIDs( tbTreaIds, nType )
	if #tbTreaIds > 0 then
		local layTitle = m_layTitleForCopy:clone()
		local imgTitle = m_fnGetWidget(layTitle, "IMG_TITLE")
		imgTitle:loadTexture("images/item/equipinfo/card/title_grab_" .. nType .. ".png")
		m_lsvGrab:pushBackCustomItem(layTitle)

		for i=1,math.ceil(#tbTreaIds / 4) do
			local layTreas = m_layTreasForCopy:clone()

			local bTemp = false
			for j=1,4 do
				local imgItemBG = m_fnGetWidget(layTreas, "img_item_bg" .. j)
				local btnTrea = m_fnGetWidget(imgItemBG, "BTN_TREASURE_BG")
				local tfdGrab = m_fnGetWidget(imgItemBG, "tfd_grab")
				local tfdGrabNum = m_fnGetWidget(imgItemBG, "TFD_GREB_NUM")
				local tfdAllNum = m_fnGetWidget(imgItemBG, "TFD_ALL_NUM")
				local tfdItemName = m_fnGetWidget(imgItemBG, "TFD_ITEM_NAME")
				local btnGrab = m_fnGetWidget(imgItemBG, "BTN_GRAB")
				local btnSynthetic = m_fnGetWidget(imgItemBG, "BTN_SYNTHETIC")

				local treaID = tbTreaIds[4 * i - 4 + j]
				if treaID then
					if (tonumber(treaID) == tonumber(m_nCurTreasureID)) then
						bTemp = true
						m_nCurTreasureID = nil
					end
					local dbTreaInfo = DB_Item_treasure.getDataById(treaID)

					local itemIcon = ItemUtil.createBtnByTemplateId(treaID, function ( sender, eventType )
						if (eventType == TOUCH_EVENT_ENDED) then
							AudioHelper.playCommonEffect()
							require "script/module/treasure/NewTreaInfoCtrl"
							LayerManager.addLayout(NewTreaInfoCtrl.createBtTid(treaID))
						end
					end)
					btnTrea:addChild(itemIcon)

					local itemFragArr = string.split(dbTreaInfo.fragment_ids, "|")
					local fragmentID = itemFragArr[1]
					local numNeed = tonumber(itemFragArr[2])
					local numHave = TreasureData.getFragmentNum(fragmentID)

					local isGuide = BTUtil:getGuideState() and tonumber(treaID) == m_nGuideTreaID
					if (isGuide) then
						-- bTemp = true
						if (m_isShowGuideUI) then
							numHave = 2
						end
					end

					tfdGrab:setText(m_i18n[2420])
					tfdGrabNum:setText(numHave)
					tfdAllNum:setText("/" .. numNeed)

					tfdItemName:setText(dbTreaInfo.name)
					tfdItemName:setColor(g_QulityColor2[dbTreaInfo.quality])

					if (numHave < numNeed or (isGuide and m_isShowGuideUI)) then
						tfdGrabNum:setColor(ccc3(255,0,0))
						btnSynthetic:setEnabled(false)
						btnGrab:addTouchEventListener(function ( sender, eventType )
							if (eventType == TOUCH_EVENT_ENDED) then
								AudioHelper.playCommonEffect()

								local min,max = ExplorData.getExploreProgress()
								if (min >= max) then
									-- ShowNotice.showShellInfo(m_i18n[3342])
									ExploreProgressRewardCtrl.autoClickGetReward(update)
									return
								end

								function createView( ... )
									require "script/module/grabTreasure/RobTreasureCtrl"
									local layGrabTreasure = RobTreasureCtrl.create(fragmentID)
									LayerManager.changeModule(layGrabTreasure, RobTreasureCtrl.moduleName(), {1, 3}, true)
									-- m_nCurTreasureID = treaID
									PlayerPanel.addForActivity()
								end

								if (isGuide) then
									m_isShowGuideUI = false
								else
									m_nOffsetY = m_lsvGrab:getContentOffset()
									logger:debug({m_nOffsetY = m_nOffsetY})
								end
								TreasureService.getRecRicher(createView,fragmentID)
							end
						end)
					else
						btnGrab:setEnabled(false)
						btnSynthetic:addTouchEventListener(function ( sender, eventType )
							if (eventType == TOUCH_EVENT_ENDED) then
								AudioHelper.playCommonEffect()

								--是否背包满
								if(ItemUtil.isTreasBagFull(true, nil) == true) then
									return
								end
								m_nCurTreasureID = treaID
								TreasureService.fuse(treaID, afterSynthetic)
							end
						end)
					end
				else
					imgItemBG:setEnabled(false)
				end
			end

			m_lsvGrab:pushBackCustomItem(layTreas)

			if (bTemp) then
				performWithDelay(m_lsvGrab, function ( ... )
					performWithDelay(m_lsvGrab, function ( ... )
						local posY = layTreas:getPositionY()
						local tHeight = m_lsvGrab:getInnerContainerSize().height - m_lsvGrab:getSize().height
						local offsetY = m_lsvGrab:getInnerContainerSize().height - posY - layTreas:getSize().height - layTitle:getSize().height
						-- local offsetY = posY - m_lsvGrab:getSize().height + layTreas:getSize().height + layTitle:getSize().height

						offsetY = (offsetY > 0) and offsetY or 0
						local nPercent = offsetY / tHeight * 100
						m_lsvGrab:scrollToPercentVertical(nPercent, 0.33, true)

						--[[
						local curOffset = m_lsvGrab:getContentOffset()
						local offSetY = 0 - layTreas:getPositionY() - layTreas:getSize().height - layTitle:getSize().height

						logger:debug(curOffset)
						logger:debug(m_lsvGrab:getSize().height)
						logger:debug(m_lsvGrab:getInnerContainerSize().height)
						logger:debug(offSetY)

						m_lsvGrab:setContentOffset(ccp(0, curOffset + offSetY), false)
						--]]
					end, 1 / 60)
				end, 1 / 60)
			end
		end
	end
end


function updateAvoidTime(  )
	local nAvoidTime = TreasureData.getHaveShieldTime()
	if tonumber(nAvoidTime) >= 1 then
		m_tfdAvoidTxt:setEnabled(true)
		m_tfdAvoidTime:setEnabled(true)
		UIHelper.labelEffect(m_tfdAvoidTime, TimeUtil.getTimeString(nAvoidTime))
	else
		m_tfdAvoidTxt:setEnabled(false)
		m_tfdAvoidTime:setEnabled(false)
	end
end


function setTouchEnabled(enable)
	m_lsvGrab:setTouchEnabled(enable)
end


function create( tbEvents, treaTid )
	m_UIMain = g_fnLoadUI("ui/grab_treasure.json")

	if (m_isShowGuideUI == nil) then
		m_isShowGuideUI = BTUtil:getGuideState()
	end
	if (treaTid) then
		m_nCurTreasureID = treaTid
	end

	-- 适配
	local layInfomation = m_fnGetWidget(m_UIMain, "lay_easy_information")
	layInfomation:setSize(CCSizeMake(layInfomation:getSize().width * g_fScaleX, layInfomation:getSize().height * g_fScaleX))

	-- 消耗相关
	local tfdCost = m_fnGetWidget(m_UIMain, "tfd_cost")
	local imgCostItem = m_fnGetWidget(m_UIMain, "img_cost_item")
	local tfdCostItem = m_fnGetWidget(m_UIMain, "tfd_cost_item")
	local tfdCostNum = m_fnGetWidget(m_UIMain, "tfd_cost_num")
	local tfdCostEndurance = m_fnGetWidget(m_UIMain, "tfd_cost_endurance")
	local tfdCostEnduranceNum = m_fnGetWidget(m_UIMain, "tfd_cost_endurance_num")
	local tfdOwn = m_fnGetWidget(m_UIMain, "tfd_own")
	local imgOwnItem = m_fnGetWidget(m_UIMain, "img_own_item")
	local tfdOwnNum = m_fnGetWidget(m_UIMain, "tfd_own_num")

	tfdCost:setText(m_i18n[2409])
	tfdCostItem:setText("1")
	tfdCostNum:setText(m_i18n[5520])
	tfdCostEndurance:setText("2")
	tfdCostEnduranceNum:setText(m_i18n[5521])
	tfdOwn:setText(m_i18n[5522])
	tfdOwnNum:setText(TreasureData.nRobItemNum)

	-- 惊喜奖励相关
	local tfdRewardProgress = m_fnGetWidget(m_UIMain, "tfd_reward_progress")
	local loadProgress = m_fnGetWidget(m_UIMain, "LOAD_PROGRESS")
	local labnLeft = m_fnGetWidget(m_UIMain, "LABN_LEFT")
	local labnRight = m_fnGetWidget(m_UIMain, "LABN_RIGHT")
	local tfdDesc = m_fnGetWidget(m_UIMain, "tfd_desc")
	local btnReward = m_fnGetWidget(m_UIMain, "BTN_REWARD")

	tfdRewardProgress:setText(m_i18n[5523])
	tfdDesc:setText(m_i18n[5524])

	update()

	-- 免战相关
	m_tfdAvoidTxt = m_fnGetWidget(m_UIMain, "tfd_avoid_txt")
	m_tfdAvoidTime = m_fnGetWidget(m_UIMain, "TFD_AVOID_TIME")
	local btnAvoidWar = m_fnGetWidget(m_UIMain, "BTN_AVOID_WAR")

	m_tfdAvoidTxt:setText(m_i18n[2408])
	updateAvoidTime()
	btnAvoidWar:addTouchEventListener(tbEvents.onAvoid)
	schedule(m_UIMain, updateAvoidTime, 1)

	-- 列表
	m_lsvGrab = m_fnGetWidget(m_UIMain, "LSV_GRAB")

	local layTitle = m_fnGetWidget(m_lsvGrab, "lay_title")
	m_layTitleForCopy = layTitle:clone()
	-- m_layTitleForCopy:retain()

	local layTreas = m_fnGetWidget(m_lsvGrab, "LAY_GRAB_TREASURE")
	m_layTreasForCopy = layTreas:clone()
	-- m_layTreasForCopy:retain()

	upAllLsv()
	return m_UIMain
end

