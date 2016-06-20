
-- FileName: RobTreasureCtrl.lua
-- Author: zjw
-- Date: 2014-05-09
-- Purpose: 夺宝界面
--[[TODO List]]

module("RobTreasureCtrl", package.seeall)
require "script/module/copy/ExplorData"
require "script/module/grabTreasure/RobTreasureView"
-- UI控件引用变量 --

-- 模块局部变量 --
local m_nFragId = nil      			-- 要抢夺的模板id
local m_layRobView = nil
local m_updateTimer               	-- 定时器
local m_tbRobberData = nil 			--抢夺对手信息
local m_i18nString 					= gi18nString
-- 模块局部变量 --
local m_nFragId = nil
local m_roberId = nil
local m_curRobData = nil
local function init(...)
	m_nFragId = nil
end

function destroy(...)
	package.loaded["RobTreasureCtrl"] = nil
end

function moduleName()
	return "RobTreasureCtrl"
end

--背包的推送之后更新本界面的数据
local function robFragFromBagDeleget( ... )
	logger:debug("robFragFromBagDeleget")
	--重置数据
	--设置夺宝指针的个数
	TreasureData.setRobItemNum()
	logger:debug("夺宝指针的个数为:" .. TreasureData.nRobItemNum)
	RobTreasureView.updateRobItemLabel()
end

function robByData( tbEnemyData, fragID, isNPC )
	if(tonumber(TreasureData.seizerInfoData.curSeizeNum) <= 0)then
		require "script/module/grabTreasure/GrabBuyCtrl"
		local buyView = GrabBuyCtrl.create()
		return
	end

	m_curRobData = tbEnemyData
	m_curRobData.npc = isNPC
	m_nFragId = fragID

	onGrabTreasure(fnStartPlayRobBattle)
end

function onGrabTreasure(  callbackFunc )
	if(ItemUtil.isBagFull(true) == true )then
		LayerManager.begainRemoveUILoading()
		return
	end
	local npc = m_curRobData.npc

	local robFunc = function ( ... )
		local function requestFunc( cbFlag, dictData, bRet )
			logger:debug(dictData)
			if(bRet == true) then
				if(dictData.ret == "fail") then
					PreRequest.setIsCanShowAchieveTip(true) -- add by huxiaozhou 20141126
					ShowNotice.showShellInfo(m_i18nString(2449))--"对方碎片不足,无法抢夺")
					LayerManager.begainRemoveUILoading()
				elseif(dictData.ret == "white") then
					PreRequest.setIsCanShowAchieveTip(true) -- add by huxiaozhou 20141126
					ShowNotice.showShellInfo(m_i18nString(2450))--"该玩家处于免战状态，不能抢夺")
					LayerManager.begainRemoveUILoading()

				else

					if(TreasureData.isShieldState() and tonumber(npc) == 0) then

						TreasureData.clearShieldTime()
						RobTreasureView.updateShieldTime()
					end


					callbackFunc(dictData)
				end
			else
				PreRequest.setIsCanShowAchieveTip(true) -- add by huxiaozhou 20141126
				ShowNotice.showShellInfo(m_i18nString(1940)) --"数据异常",
				--callbackFunc(false)
				return
			end
		end

		-- local args = Network.argsHandler(m_roberId, m_nFragId, npc, BTUtil:getGuideState())
		local args = CCArray:create()
		args:addObject(CCInteger:create(m_curRobData.uid))
		args:addObject(CCInteger:create(m_nFragId))
		args:addObject(CCInteger:create(npc))
		-- if (BTUtil:getGuideState() == true) then
		-- 	args:addObject(CCInteger:create(1))
		-- end

		PreRequest.setIsCanShowAchieveTip(false) -- add by huxiaozhou 20141126
		if(TreasureData.nRobItemNum > 0) then
			logger:debug("减少一次夺宝指针")
			PreRequest.setBagDataChangedDelete(robFragFromBagDeleget)
		end

		RequestCenter.fragseize_seizeRicher(requestFunc,args)
	end

	--是否处于免战状态
	if(TreasureData.isShieldState() and tonumber(npc) == 0) then
		local  function onConfirm (sender, eventType)
			if (eventType == TOUCH_EVENT_ENDED) then
				--清除免战状态
				logger:debug("you confirm to rob")
				LayerManager:removeLayout()
				robFunc()
			end
		end
		-- [2452] = "免战期间内抢夺其他玩家将会解除免战时间，是否继续抢夺？",
		local sTips = m_i18nString(2452)
		local dlg = UIHelper.createCommonDlg(sTips, nil, onConfirm)
		LayerManager.addLayout(dlg)
	else
		robFunc()
	end

end

--调用战斗模块
function fnStartPlayRobBattle(dictData)
	logger:debug(dictData)
	require "script/module/guide/GuideCtrl"
	GuideCtrl.removeGuideView()
	-- 刷新数据
	local reward= dictData.ret.reward
	UserModel.addSilverNumber(tonumber(reward.silver))
	-- UserModel.addExpValue(tonumber(reward.exp),"treasureservice")
	--增加一次抢夺次数
	TreasureData.setSeizeNum()
	--减少一次夺宝次数
	TreasureData.setCurGrabNum()


	-- 如果抽取的是抢夺或贝里 加贝里
	if(dictData.ret.card ~= nil)then
		for k,v in pairs(dictData.ret.card) do
			if(k == "real")then
				for i,j in pairs(v) do
					if(i == "rob")then
						UserModel.addSilverNumber(tonumber(j))
					elseif(i == "silver")then
						UserModel.addSilverNumber(tonumber(j))
						-- elseif(i == "soul")then -- zhangqi, 2015-01-10, 去经验石
						-- 	UserModel.addSoulNum(tonumber(j))
					elseif(i == "gold")then
						UserModel.addGoldNumber(tonumber(j))
					end
				end
			end
		end
	end
	--结算面板
	local afterBattleLayer
	--碎片信息
	local fragmentInfo = DB_Item_treasure_fragment.getDataById(m_nFragId)
	local fragmentName = nil
	if(string.lower(dictData.ret.appraisal) ~= "e" and string.lower(dictData.ret.appraisal) ~= "f"  and dictData.ret.reward.fragNum ~= nil ) then
		fragmentName = fragmentInfo.name 			--抢到碎片了
		TreasureData.addFragment(m_nFragId, 1)
	end

	-- if(BTUtil:getGuideState()) then
	-- 	fragmentName = fragmentInfo.name 			--抢到碎片了
	-- 	TreasureData.addFragment(m_nFragId, 1)
	-- end

	local function afterOKcallFun()
		-- UserModel.addExpValue(tonumber(reward.exp),"treasureservice")
		-- ExplorData.addExploreProgress()

		require "script/module/guide/GuideModel"
		require "script/module/guide/GuideRobView"
		if (GuideModel.getGuideClass() == ksGuideRobTreasure and GuideRobView.guideStep == 6) then
			require "script/module/guide/GuideCtrl"
			GuideCtrl.createRobGuide(7,0,nil, function (  )
				GuideCtrl.removeGuide()
			end)
		end

	end



	local tb = {}
	tb.enemyData = m_curRobData				--抢夺对手的信息
	tb.exp = reward.exp 					--获得得经验
	tb.coin = reward.silver 				--获得的贝里
	tb.flopData = dictData.ret.card 		--三张卡片信息
	tb.fragmentName = fragmentName 			--碎片名字
	tb.afterOKcallFun = afterOKcallFun 		--结算面板点击确定后的回调
	tb.fightFrc  = dictData.ret.fightFrc 	--对手的战斗力
	tb.appraisal = dictData.ret.appraisal	--战斗评价等级
	tb.fragId 	=  m_nFragId 				--宝物碎片id
	tb.costStamina = -1

	-- if(TreasureData.nRobItemNum > 0) then
	-- 	logger:debug("减少一次夺宝指针")
	-- 	tb.costStamina = -0    				--夺宝消耗的耐力

	-- else
	-- 	-- UserModel.addStaminaNumber(-(TreasureData.getEndurance()))
	-- 	-- tb.costStamina = -2
	-- end
	logger:debug(tb)
	require "script/battle/BattleModule"
	BattleModule.PlayRobBattle( dictData.ret.fightStr,afterOKcallFun,tb)

	LayerManager.begainRemoveUILoading()
	--抢夺界面更新耐力值
	updateInfoBar() -- 新信息条统一刷新方法
end
--再抢一次的回调
function grabTreasureAgain( ... )

	if(tonumber(TreasureData.seizerInfoData.curSeizeNum) <= 0)then
		require "script/module/grabTreasure/GrabBuyCtrl"
		local buyView = GrabBuyCtrl.create()
		return
	end
	--防止数据未准备好的时候点击换对手
	LayerManager.addUILoading()
	onGrabTreasure(fnStartPlayRobBattle)
end

function create(fragId)
	m_nFragId = fragId
	--设置夺宝指针的个数
	TreasureData.setRobItemNum()

	local tbFragData = {}
	-- View里面的按钮事件
	tbFragData.onBack = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("refresh clicked")
			AudioHelper.playCloseEffect()
			require "script/module/grabTreasure/MainGrabTreasureCtrl"
			MainGrabTreasureCtrl.create()
		end
	end
	--换一批对手
	tbFragData.onRefresh = function ( sender, eventType )
		local effectNode = sender:getNodeByTag(100)

		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("back btn clicked")
			AudioHelper.playCommonEffect()
			--特效
			effectNode:getAnimation():play("refresh", -1, -1, 0)

			-- 获取可抢夺用户信息
			local function requestFunc( cbFlag, dictData, bRet )
				if(bRet ) then
					TreasureData.robberInfo = dictData.ret
					m_tbRobberData = TreasureData.getRobberList()
					RobTreasureView.updateRobPlayerInfo()
				end
			end
			TreasureData.tbRobberInfo = nil
			local args = CCArray:create()
			args:addObject(CCInteger:create(fragId))
			args:addObject(CCInteger:create(4))
			Network.rpc(requestFunc, "fragseize.getRecRicher", "fragseize.getRecRicher", args, true)
		elseif (eventType == TOUCH_EVENT_CANCELED) then

			effectNode:getAnimation():play("refresh", -1, -1, 0)
			effectNode:getAnimation():gotoAndPause(40)
		elseif(eventType == TOUCH_EVENT_MOVED) then

			local bFocus = sender:isFocused()
			if(bFocus) then

				effectNode:getAnimation():play("refresh", -1, -1, 0)
				effectNode:getAnimation():gotoAndPause(1)
			else

				effectNode:getAnimation():play("refresh", -1, -1, 0)
				effectNode:getAnimation():gotoAndPause(40)
			end
			-- RobTreasureView.m_btnItemShopBg[btnTag]:setFocused(bFocus)
			-- RobTreasureView.m_btnItemShop[btnTag]:setFocused(bFocus)

		elseif (eventType == TOUCH_EVENT_BEGAN) then

			effectNode:getAnimation():play("refresh", -1, -1, 0)
			effectNode:getAnimation():gotoAndPause(1)
		end
	end
	--抢夺
	tbFragData.onFrag = function ( sender, eventType )
		local btnTag = sender:getTag()
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			m_tbRobberData = TreasureData.getRobberList()
			m_curRobData= m_tbRobberData[btnTag]
			logger:debug({m_curRobData = m_curRobData})

			RobTreasureView.m_btnItemShopBg[btnTag]:setFocused(false)
			RobTreasureView.m_btnItemShop[btnTag]:setFocused(false)

			if(tonumber(TreasureData.seizerInfoData.curSeizeNum) <= 0)then
				require "script/module/grabTreasure/GrabBuyCtrl"
				local buyView = GrabBuyCtrl.create()
				return
			end

			onGrabTreasure(fnStartPlayRobBattle)

		elseif (eventType == TOUCH_EVENT_CANCELED) then
			logger:debug("cancle")
			RobTreasureView.m_btnItemShopBg[btnTag]:setFocused(false)
			RobTreasureView.m_btnItemShop[btnTag]:setFocused(false)
		elseif(eventType == TOUCH_EVENT_MOVED) then

			local bFocus = sender:isFocused()
			RobTreasureView.m_btnItemShopBg[btnTag]:setFocused(bFocus)
			RobTreasureView.m_btnItemShop[btnTag]:setFocused(bFocus)

		elseif (eventType == TOUCH_EVENT_BEGAN) then
			RobTreasureView.m_btnItemShopBg[btnTag]:setFocused(true)
			RobTreasureView.m_btnItemShop[btnTag]:setFocused(true)
		end

	end

	tbFragData.fragId = fragId
	m_layRobView = RobTreasureView.create(tbFragData)

	-- m_layRobView:registerScriptHandler(onNodeEvent)
	UIHelper.registExitAndEnterCall(m_layRobView,function()
			stopScheduler()
			m_layRobView = nil
		end,
		function()
			startScheduler()
		end)
	return m_layRobView
end
--更新耐力面板
function updateStamina()
	logger:debug(UserModel.getStaminaNumber())
	if(m_layRobView) then
		RobTreasureView.updateStaminaLabel()
	end
end

local function updateTime( ... )
	RobTreasureView.updateShieldTime()
end
-- 启动scheduler
function startScheduler()

	if(TreasureData.getHaveShieldTime() > 0 and m_updateTimer == nil) then
		m_updateTimer = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(updateTime, 1, false)
	end

end

-- 停止scheduler
function stopScheduler()
	if(m_updateTimer)then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(m_updateTimer)
		m_updateTimer = nil
	end
end


-- -- 生命周期事件
-- function onNodeEvent(eventType )
-- 	if(eventType == "enter") then
-- 		startScheduler()
-- 	elseif(eventType == "exit") then
-- 		stopScheduler()
-- 		m_layRobView = nil
-- 	end
-- end
