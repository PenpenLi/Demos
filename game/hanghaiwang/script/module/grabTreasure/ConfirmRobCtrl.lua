-- FileName: ConfirmRobCtrl.lua
-- Author: zjw
-- Date: 2014-5-11
-- Purpose: 点击船只后进入夺宝确定界面


module("ConfirmRobCtrl", package.seeall)


require "script/module/grabTreasure/ConfirmRobView"
require "script/module/grabTreasure/TreasureService"


-- UI控件引用变量 --

-- 模块局部变量 --
local m_fragId = nil
local m_roberId = nil
local m_curRobData = nil
local m_i18nString 					= gi18nString


local function init(...)
	m_fragId = nil
	m_roberId = nil
end

function destroy(...)
	package.loaded["ConfirmRobCtrl"] = nil
end

function moduleName()
	return "ConfirmRobCtrl"
end



function onGrabTreasure(  callbackFunc )
	if(ItemUtil.isBagFull(true) == true )then
		-- ShowNotice.showShellInfo("背包已满")
		return
	end
	--print("当前耐力：",UserModel.getStaminaNumber())

	local robberData = TreasureData.getRobberList()
	local npc =0
	-- 本次抢夺对手的阵容
	for k, v in pairs(robberData) do
		if(tonumber(v.uid ) == tonumber(m_roberId) ) then
			npc = v.npc
			m_curRobData = v
			break
		end
	end

	local robFunc = function ( ... )

		local function requestFunc( cbFlag, dictData, bRet )
			logger:debug(dictData)
			if(bRet == true) then
				if(dictData.ret == "fail") then
					PreRequest.setIsCanShowAchieveTip(true) -- add by huxiaozhou 20141126
					ShowNotice.showShellInfo(m_i18nString(2449))--"对方碎片不足,无法抢夺")
					--callbackFunc(false)
				elseif(dictData.ret == "white") then
					PreRequest.setIsCanShowAchieveTip(true) -- add by huxiaozhou 20141126
					ShowNotice.showShellInfo(m_i18nString(2450))--"该玩家处于免战状态，不能抢夺")
					--callbackFunc(false)
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
		logger:debug("BTUtil:getGuideState()")
		logger:debug(BTUtil:getGuideState())
		-- local args = Network.argsHandler(m_roberId, m_fragId, npc, BTUtil:getGuideState())
		local args = CCArray:create()
		args:addObject(CCInteger:create(m_roberId))
		args:addObject(CCInteger:create(m_fragId))
		args:addObject(CCInteger:create(npc))
		if (BTUtil:getGuideState() == true) then
			args:addObject(CCInteger:create(1))
		end
		PreRequest.setIsCanShowAchieveTip(false) -- add by huxiaozhou 20141126

		PreRequest.setBagDataChangedDelete(enchantFromBagDeleget)

		RequestCenter.fragseize_seizeRicher(requestFunc,args)
	end

	--是否处于免战状态
	if(TreasureData.isShieldState() and tonumber(npc) == 0) then
		local  function onConfirm (sender, eventType)
			if (eventType == TOUCH_EVENT_ENDED) then
				--清除免战状态
				logger:debug("you confirm to rob")
				LayerManager:removeLayout()
				-- TreasureData.clearShieldTime()
				-- RobTreasureView.updateShieldTime()
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

--开始抢夺
function fnStartRob(dictData)
	logger:debug(dictData)
	-- 刷新数据
	local reward= dictData.ret.reward
	UserModel.addSilverNumber(tonumber(reward.silver))
	UserModel.addExpValue(tonumber(reward.exp),"treasureservice")

	if(TreasureData.nRobItemNum > 0) then
		logger:debug("减少一次夺宝指针")
	else
		UserModel.addStaminaNumber(-(TreasureData.getEndurance()))
	end

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
	local fragmentInfo = DB_Item_treasure_fragment.getDataById(m_fragId)
	local fragmentName = nil
	if(string.lower(dictData.ret.appraisal) ~= "e" and string.lower(dictData.ret.appraisal) ~= "f"  and dictData.ret.reward.fragNum ~= nil ) then
		fragmentName = fragmentInfo.name 			--抢到碎片了
		TreasureData.addFragment(m_fragId, 1)
	end

	if(BTUtil:getGuideState()) then
		fragmentName = fragmentInfo.name 			--抢到碎片了
		TreasureData.addFragment(m_fragId, 1)
	end

	local function afterOKcallFun()

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
	tb.fragId 	=  m_fragId 				--宝物碎片id
	logger:debug(tb)
	require "script/battle/BattleModule"
	BattleModule.PlayRobBattle( dictData.ret.fightStr,afterOKcallFun,tb)

	--抢夺界面更新耐力值
	require "script/module/grabTreasure/RobTreasureCtrl"
	RobTreasureCtrl.updateStamina()
end
--再抢一次的回调
function starGrabTreasure( ... )
	--判断耐力是否满足

	if( (UserModel.getStaminaNumber()-2)  < 0 and TreasureData.nRobItemNum <= 0)then

		require "script/module/arena/ArenaBuyCtrl"
		--刷新抢夺界面的耐力面板的函数回调
		local  fnupdateRobViewStamina =  function (...)
			RobTreasureCtrl.updateStamina()
		end

		local buyView = ArenaBuyCtrl.createForArena(fnupdateRobViewStamina)
		LayerManager.addLayout(buyView)
		return
	end

	onGrabTreasure(fnStartRob)
end
--[[desc:功能简介,碎片table添加按钮回调
    arg1: tbCurRobData抢夺玩家信息，tbFragInfo碎片信息,m_nFragid碎片id
    return: 是否有返回值，返回值说明  
—]]
function create(tbCurRobData,tbFragInfo)
	m_fragId = tbFragInfo.tid --碎片id
	m_roberId = tbCurRobData.uid

	onGrabTreasure(fnStartRob)
end
