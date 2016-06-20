-- FileName: MainWonderfulActCtrl.lua
-- Author: huxiaozhou
-- Date: 2014-05-19
-- Purpose: 精彩活动 滑动列表控制器
--[[TODO List]]

module("MainWonderfulActCtrl", package.seeall)

require "script/module/wonderfulActivity/MainWonderfulActView"

require "script/module/wonderfulActivity/WonderfulActModel"

-- UI控件引用变量 --

-- 模块局部变量 --
local m_activityList 
local m_curAct
local m_i18n = gi18n


local function init(...)
	m_activityList = nil
	m_curAct = nil
end

function destroy(...)
	MainWonderfulActView.destroy()
	package.loaded["MainWonderfulActCtrl"] = nil
end

function moduleName()
    return "MainWonderfulActCtrl"
end


-- 获取当前有的活动列表
function getHasActivityList(  )
	--
	local tbActivityList = {}
	-- 检查现在可以有几个活动图标  有可能需要排序 那个在前那个在后

	return tbActivityList
end

function create( _showType)
     -- RequestCenter.levelfund_getLevelfundInfo(rewardInfoCallback, nil)

	-- local showType = _showType or WonderfulActModel.tbShowType.kShowDefault
	init()
	local tbBtnEvent = {}

	--[[
	优先级 活动名称
1 开服礼包7天
2 幸运轮盘
3 每日签到
4 豪华签到【新】
5 累计登陆
6 首充活动
7 福利商店【新】【那个跟新服有关的活动（游戏里的现有名字是道具折扣）】
8 充值红利（累充-需要购买）
9 充值回馈（累充-直接领取）
10 消费累计（消费-领取奖励）
11 折扣活动（分为装备、道具、饰品、宝物、空岛贝5类）
12 限时抢购
13 节日福利【新】
14 资源兑换 【新】
15 购买贝里
16 vip周礼包
17 等级礼包
18 喝可乐(领体力)
19 成长基金
20 挑战小福利
21 月卡
22 分享有礼
	--]]

	-- local tbItem = {"accReward", "vipGift",  "registration", "growthfund", "levelReward", "supply", 
	-- 				"buyBox", "buyMoney", "spendAccumulate","rechargeBack", "shareReward", "vipcard", 
	-- 				"firstGift", "roulette" ,"saleBox" , "rechargeBonus" , "challengeWelfare" , 
	-- 				"discountEquip","discountConch","discountTreas","discountExcl","discountProps",
	--				"accLogin","staWelShop", "dynWelShop", "luxSign"}

	local tbItem = {"accReward",			-- 1 开服礼包7天
					"roulette",  			-- 2 幸运轮盘
					"registration",			-- 3 每日签到
					"luxSign",				-- 4 豪华签到
					"accLogin",             -- 5 累计登陆
					"firstGift", 			-- 6 首充活动
					"staWelShop" ,	"dynWelShop", 		-- 7 静态福利商店（开服福利商店）-- 动态福利商店（运营福利商店）
					"rechargeBonus", 		-- 8 充值红利（累充-需要购买）
					"rechargeBack", 		-- 9 充值回馈（累充-直接领取）
					"spendAccumulate",      -- 10 消费累计（消费-领取奖励）
					"discountEquip", "discountProps","discountTreas","discountExcl", "discountConch",    --11 折扣活动（分为装备、道具、饰品、宝物、空岛贝5类顺序以此为准）
					"saleBox", 				-- 12 限时抢购
					"limitWeal",		 	-- 13 节日福利【新】
					 					    -- 14 资源兑换 【新】
					"buyMoney", 			-- 15 购买贝里
					"vipGift",				-- 16 vip礼包
					"levelReward", 			-- 17 等级礼包
					"supply",               -- 18 喝可乐(领体力)
					"growthfund",           -- 19 成长基金
					"challengeWelfare",     -- 20 挑战小福利
					"vipcard", 				-- 21 月卡
					"shareReward",          -- 22 分享有礼
					 }

	local function removeValue( sValue )
		for i,v in ipairs(tbItem) do
			if v == sValue then
				table.remove(tbItem, i)
				break
			end
		end
	end

	--移除挑战福利
	require "script/module/wonderfulActivity/challengeWelfare/ChaWelModel"
	if (ChaWelModel.getCurActitveDbInfo()==nil) then
		removeValue("challengeWelfare")
	end

	local tCurRewardInfo = LevelRewardCtrl.getCurRewardInfo() 

	-- AppStore审核
	if (Platform.isAppleReview()) then
		removeValue("accReward")	-- 开服礼包
		removeValue("vipGift")		-- vip礼包
		removeValue("growthfund")	-- 成长基金
		removeValue("vipcard")		-- 金币袋
		removeValue("saleBox")		-- 限时打折
		removeValue("firstGift")	-- 首充礼包
		removeValue("rechargeBonus") -- 充值红利
		removeValue("rechargeBack") -- 充值回馈
		removeValue("luxSign") -- 豪华签到
	end

	-- 如果等级礼包全部领取完毕 则屏蔽入口
	if not tCurRewardInfo then 
		removeValue("levelReward")
    end	

	-- 如果开服礼包全部领取完毕 则屏蔽入口
	if  not AccSignModel.accIconNeedShow() then 
		removeValue("accReward")
    end

    -- 如果成长基金全部领取完毕 则屏蔽入口
    if not GrowthFundModel.needShowGrowthFund() then 
		removeValue("growthfund")
    end

    --如果消费累积不在活动时间 则屏蔽入口
    if not SpendAccumulateModel.isInTime() then
    	removeValue("spendAccumulate")
    end

	--如果充值回馈不在活动时间 则屏蔽入口
    if not RechargeBackModel.isInTime() then
    	removeValue("rechargeBack")
    end

    --如果静态福利商店（开服福利商店）不在活动时间 则屏蔽入口
    if not StaticWelfareShopCtrl.getIsActivityOn() then
    	removeValue("staWelShop")
    end

    -- 如果动态福利商店（运营福利商店）不在活动时间 则屏蔽入口
    if not DynamicWelShopCtrl.getIsActivityOn() then
    	removeValue("dynWelShop")
    end

    --如果平台不能分享 则屏蔽入口
    --if (Platform.getWxShare() == "false" or g_system_type == kBT_PLATFORM_ANDROID) then
    -- 暂时完全关闭分享功能
    if (1) then
    	removeValue("shareReward")
    end

    if not FirstGiftData.isShowFirstGifts() then
    	removeValue("firstGift")
    end

    if not RouletteModel.bShowIconBtn() then
    	removeValue("roulette")
    end

    if not SaleBoxModel.bShowBtnIcon() then
    	removeValue("saleBox")
    end

    -- 如果不在活动时间或者已经购买所有档次的奖品，则屏蔽充值红利入口
    if ((not RechargeBonusModel.isActivityInTime()) or (RechargeBonusModel.isAllHaveBought())) then
    	removeValue("rechargeBonus")
    end

    -- 累计登录
    if (AccLoginModel.isClosed()) then
    	removeValue("accLogin")
    end

    -- begin zhangjunwu 2015-11-16
    -- 装备折扣
    if (not DiscountData.isDiscountActivityOpenInTime("equipmentDiscount")) then
    	removeValue("discountEquip")
    end
    -- 空岛贝折扣
    if (not DiscountData.isDiscountActivityOpenInTime("conchDiscount")) then
    	removeValue("discountConch")
    end
    -- 道具折扣
    if (not DiscountData.isDiscountActivityOpenInTime("propertyDiscount")) then
    	removeValue("discountProps")
    end
    -- 饰品折扣
    if (not DiscountData.isDiscountActivityOpenInTime("treasureDiscount")) then
    	removeValue("discountTreas")
    end
    -- 宝物折扣
    if (not DiscountData.isDiscountActivityOpenInTime("exclusiveDiscount")) then
    	removeValue("discountExcl")
    end
    --end

	if not LimitWelfareModel.isLimitWelfareOpen() then
    	removeValue("limitWeal")
    end

    -- 豪华签到
    if (not LuxurySignModel.isLevelEnough()) then
    	removeValue("luxSign")
    end

    WonderfulActModel.setActList(tbItem)
    local showType = _showType or tbItem[1]

	-- 按钮 喝可乐按钮
	tbBtnEvent.onPower = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()

			if(sender:getTag() ~= MainWonderfulActView.getSelectedBtnTag()) then
				showPower()
			end
			MainWonderfulActView.btnSelectFunc(sender)
		end
	end

	-- 按钮 买宝箱按钮
	tbBtnEvent.onBox = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()

			if(not SwitchModel.getSwitchOpenState(ksSwitchBuyBox,true)) then
				return
			end
			if(sender:getTag() ~= MainWonderfulActView.getSelectedBtnTag()) then
				showBuyBox()
			end
			MainWonderfulActView.btnSelectFunc(sender)
		end
	end
		-- 按钮 买贝里按钮
	tbBtnEvent.onBuyMoney = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()

			if(not SwitchModel.getSwitchOpenState(ksSwitchBuyBox,true)) then
				return
			end
			if(sender:getTag() ~= MainWonderfulActView.getSelectedBtnTag()) then
				showBuyBelly()
			end
			MainWonderfulActView.btnSelectFunc(sender)
		end
	end
			-- 按钮 等级礼包按钮
	tbBtnEvent.onLevelReward = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()

			if(not SwitchModel.getSwitchOpenState(ksSwitchLevelGift,true)) then
				return
			end
			if(sender:getTag() ~= MainWonderfulActView.getSelectedBtnTag()) then
				showLevelReward()
			end
			MainWonderfulActView.btnSelectFunc(sender)
		end
	end
			-- 按钮 签到
	tbBtnEvent.onRegistration = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()

			if (not SwitchModel.getSwitchOpenState(ksSwitchSignIn,true)) then
				return
			end
			if(sender:getTag() ~= MainWonderfulActView.getSelectedBtnTag()) then
				showRegistration()
			end
			MainWonderfulActView.btnSelectFunc(sender)
		end
	end		

	-- 按钮开服礼包
	tbBtnEvent.onAccReward = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			if(sender:getTag() ~= MainWonderfulActView.getSelectedBtnTag()) then
				showAccReward()
			end
			MainWonderfulActView.btnSelectFunc(sender)
		end
	end

	-- 按钮成长基金
	tbBtnEvent.onGrowthFund = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			if(sender:getTag() ~= MainWonderfulActView.getSelectedBtnTag()) then
				showGrowthFund()
			end
			MainWonderfulActView.btnSelectFunc(sender)
		end
	end

	-- 每日分享
	tbBtnEvent.onShareReward = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			if(sender:getTag() ~= MainWonderfulActView.getSelectedBtnTag()) then
				showShareReward()
			end
			MainWonderfulActView.btnSelectFunc(sender)
		end
	end

	-- 按钮消费累积
	tbBtnEvent.onSpendAccumulate = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			if(sender:getTag() ~= MainWonderfulActView.getSelectedBtnTag()) then
				require "script/model/utils/ActivityConfigUtil"
				if (ActivityConfigUtil.isActivityOpen( "spend" )) then
					showSpendAccumulate()
				else
					ShowNotice.showShellInfo(m_i18n[6605])
					return
				end
			end
			MainWonderfulActView.btnSelectFunc(sender)
		end
	end

	-- 按钮充值回馈
	tbBtnEvent.onRechargeBack = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			if(sender:getTag() ~= MainWonderfulActView.getSelectedBtnTag()) then
				require "script/model/utils/ActivityConfigUtil"
				if (ActivityConfigUtil.isActivityOpen( "topupFund" )) then
					showRechargeBack()
				else
					ShowNotice.showShellInfo(m_i18n[6605])
					return
				end
			end
			MainWonderfulActView.btnSelectFunc(sender)
		end
	end

	-- 按钮月卡
	tbBtnEvent.onVipCard = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			if(sender:getTag() ~= MainWonderfulActView.getSelectedBtnTag()) then
				showVipCard()
			end
			MainWonderfulActView.btnSelectFunc(sender)
		end
	end

	-- 按钮月卡
	tbBtnEvent.onFirstGift = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			if(sender:getTag() ~= MainWonderfulActView.getSelectedBtnTag()) then
				showFirstGift()
			end
			MainWonderfulActView.btnSelectFunc(sender)
		end
	end

	-- 按钮VIP礼包
	tbBtnEvent.onVipGift = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			if (SwitchModel.getSwitchOpenState(ksSwitchShop, true)) then
				if(sender:getTag() ~= MainWonderfulActView.getSelectedBtnTag()) then
					showVipGift()
				end
				MainWonderfulActView.btnSelectFunc(sender)
			end
		end
	end

	-- 按钮幸运轮盘
	tbBtnEvent.onRoulette = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			if(sender:getTag() ~= MainWonderfulActView.getSelectedBtnTag()) then
				showRoulette()
			end
			MainWonderfulActView.btnSelectFunc(sender)
		end
	end

	-- 按钮限时宝箱
	tbBtnEvent.onSaleBox = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			if(sender:getTag() ~= MainWonderfulActView.getSelectedBtnTag()) then
				showSaleBox()
			end
			MainWonderfulActView.btnSelectFunc(sender)
		end
	end

	-- 按钮充值红利
	tbBtnEvent.onRechargeBonus = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			if(sender:getTag() ~= MainWonderfulActView.getSelectedBtnTag()) then
				require "script/model/utils/ActivityConfigUtil"
				if (ActivityConfigUtil.isActivityOpen( "chargeWeal" )) then
					showRechargeBonus()
				else
					ShowNotice.showShellInfo(m_i18n[6605])
					return
				end
			end
			MainWonderfulActView.btnSelectFunc(sender)
		end
	end
	
	-- 按钮挑战福利
	tbBtnEvent.onChallengeWelfare = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			if(sender:getTag() ~= MainWonderfulActView.getSelectedBtnTag()) then
				showChallengeWelfare()
			end
			MainWonderfulActView.btnSelectFunc(sender)
		end
	end	
	-- 按钮装备折扣
	tbBtnEvent.onDiscountEquip = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			if(sender:getTag() ~= MainWonderfulActView.getSelectedBtnTag()) then
				showDisCountByName("equipmentDiscount",sender)
			end
			-- MainWonderfulActView.btnSelectFunc(sender)
		end
	end	
	-- 按钮空岛贝折扣
	tbBtnEvent.onDiscountConch = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			if(sender:getTag() ~= MainWonderfulActView.getSelectedBtnTag()) then
				showDisCountByName("conchDiscount",sender)
			end
			-- MainWonderfulActView.btnSelectFunc(sender)
		end
	end	
	-- 按钮饰品折扣
	tbBtnEvent.onDiscountTreas = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			if(sender:getTag() ~= MainWonderfulActView.getSelectedBtnTag()) then
				showDisCountByName("treasureDiscount",sender)
			end
			-- MainWonderfulActView.btnSelectFunc(sender)
		end
	end
	-- 按钮宝物折扣
	tbBtnEvent.onDiscountExcl = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			if(sender:getTag() ~= MainWonderfulActView.getSelectedBtnTag()) then
				showDisCountByName("exclusiveDiscount",sender)
			end
			-- MainWonderfulActView.btnSelectFunc(sender)
		end
	end	
	-- 按钮道具折扣
	tbBtnEvent.onDiscountProps = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			if(sender:getTag() ~= MainWonderfulActView.getSelectedBtnTag()) then
				showDisCountByName("propertyDiscount",sender)
			end
			-- MainWonderfulActView.btnSelectFunc(sender)
		end
	end

	tbBtnEvent.onAccLogin = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			if(sender:getTag() ~= MainWonderfulActView.getSelectedBtnTag()) then
				showAccLogin()
			end
			MainWonderfulActView.btnSelectFunc(sender)
		end
	end

	-- 按钮 静态福利商店（开服福利商店）
	tbBtnEvent.onStaWelShop = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			if (StaticWelfareShopCtrl.getIsActivityOn()) then
				if(sender:getTag() ~= MainWonderfulActView.getSelectedBtnTag()) then
					showStaWelShop()
				end
				MainWonderfulActView.btnSelectFunc(sender)
			else
				ShowNotice.showShellInfo(m_i18n[6605])
				return
			end
		end
	end

	-- 按钮 动态福利商店（运营福利商店）
	tbBtnEvent.onDynWelShop = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			if (DynamicWelShopCtrl.getIsActivityOn()) then
				if(sender:getTag() ~= MainWonderfulActView.getSelectedBtnTag()) then
					showDynWelShop()
				end
				MainWonderfulActView.btnSelectFunc(sender)
			else
				ShowNotice.showShellInfo(m_i18n[6605])
				return
			end
		end
	end

	-- 按钮 豪华签到
	tbBtnEvent.onLuxSign = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			if(sender:getTag() ~= MainWonderfulActView.getSelectedBtnTag()) then
				showLuxSign()
			end
			MainWonderfulActView.btnSelectFunc(sender)
		end
	end

	-- 按钮 限时福利
	tbBtnEvent.onLimitWeal = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			if (LimitWelfareModel.isLimitWelfareOpen()) then
				if (sender:getTag() ~= MainWonderfulActView.getSelectedBtnTag()) then
					showLimitWeal()
				end
				MainWonderfulActView.btnSelectFunc(sender)
			else
				ShowNotice.showShellInfo(m_i18n[6605])
				return
			end
		end
	end

	-- 其他 按钮
	-----------------------------------------------------


	-- 此处添加各种按钮 事件

	-----------------------------------------------------

	local tbEvent = {
		["supply"] = tbBtnEvent.onPower,
		-- ["buyBox"] = tbBtnEvent.onBox,
		["buyMoney"] = tbBtnEvent.onBuyMoney,
		["registration"] = tbBtnEvent.onRegistration,
		["levelReward"] = tbBtnEvent.onLevelReward,
		["accReward"] = tbBtnEvent.onAccReward,
		["growthfund"] = tbBtnEvent.onGrowthFund,
		["shareReward"] = tbBtnEvent.onShareReward,
		["spendAccumulate"] = tbBtnEvent.onSpendAccumulate,
		["rechargeBack"] = tbBtnEvent.onRechargeBack,
		["vipcard"] = tbBtnEvent.onVipCard,
		["firstGift"] = tbBtnEvent.onFirstGift,
		["vipGift"] = tbBtnEvent.onVipGift,
		["roulette"] = tbBtnEvent.onRoulette,
		["saleBox"] = tbBtnEvent.onSaleBox,
		["rechargeBonus"] = tbBtnEvent.onRechargeBonus,
		["challengeWelfare"] = tbBtnEvent.onChallengeWelfare,
		["discountEquip"] = 	tbBtnEvent.onDiscountEquip,
		["discountConch"] = 	tbBtnEvent.onDiscountConch,
		["discountTreas"] = 	tbBtnEvent.onDiscountTreas,
		["discountExcl"]  = 	tbBtnEvent.onDiscountExcl,
		["discountProps"]  = 	tbBtnEvent.onDiscountProps,
		["accLogin"] = tbBtnEvent.onAccLogin,
		["staWelShop"] = tbBtnEvent.onStaWelShop,
		["dynWelShop"] = tbBtnEvent.onDynWelShop,
		["luxSign"] = tbBtnEvent.onLuxSign,
		["limitWeal"] = tbBtnEvent.onLimitWeal,
	}

  	m_activityList = MainWonderfulActView.create(tbEvent)

 	if(showType == WonderfulActModel.tbShowType.kShowSupply) then
  		showPower( ) --吃烧鸡
  	elseif(showType == WonderfulActModel.tbShowType.kShowBuyBox) then
  		showBuyBox( ) --买宝箱
  	elseif(showType == WonderfulActModel.tbShowType.kShowBuyMoney) then
  		showBuyBelly( ) --买贝里
  	elseif(showType == WonderfulActModel.tbShowType.kLevelReward) then
  		showLevelReward( ) --显示等级礼包  	
  	elseif(showType == WonderfulActModel.tbShowType.kAccReward) then
  		showAccReward( ) --显示开服礼包
  	elseif(showType == WonderfulActModel.tbShowType.kRegistration) then
  		showRegistration( ) --签到
  	elseif(showType == WonderfulActModel.tbShowType.kGrowthFund) then
  		showGrowthFund( ) --成长基金
   	elseif(showType == WonderfulActModel.tbShowType.kSpendAccumulate) then
  		showSpendAccumulate( ) --消费累积
   	elseif(showType == WonderfulActModel.tbShowType.kRechargeBack) then
  		showRechargeBack( ) --充值回馈
  	elseif(showType == WonderfulActModel.tbShowType.kVipCard) then
  		showVipCard( ) --月卡
  	elseif(showType == WonderfulActModel.tbShowType.kShareReward) then
  		showShareReward( ) -- 分享有礼
  	elseif (showType == WonderfulActModel.tbShowType.kFirstGift) then
  		showFirstGift() -- 首充
  	elseif (showType == WonderfulActModel.tbShowType.kVipGift) then
  		showVipGift()  -- vip礼包
  	elseif (showType == WonderfulActModel.tbShowType.kRoulette) then
  		showRoulette() -- 幸运轮盘
  	elseif (showType == WonderfulActModel.tbShowType.kSaleBox) then
  		showSaleBox()  -- 限时宝箱
  	elseif (showType == WonderfulActModel.tbShowType.kRechargeBonus) then
  		showRechargeBonus()  -- 充值红利
  	elseif (showType == WonderfulActModel.tbShowType.kAccLogin) then
  		showAccLogin()  -- 累计登录
  	elseif (showType == WonderfulActModel.tbShowType.kStaWelShop) then
  		showStaWelShop()
  	elseif (showType == WonderfulActModel.tbShowType.kDynWelShop) then
  		showDynWelShop()
  	elseif (showType == WonderfulActModel.tbShowType.kLuxSign) then
  		showLuxSign()
  	elseif (showType == WonderfulActModel.tbShowType.kLimitWeal) then
  		showLimitWeal()
  	end
  	MainWonderfulActView.btnSelectFunc(MainWonderfulActView.tbBtn[showType])
  	return m_activityList
end

--添加到 MainView上
function addLayChild( child )
	if (child ~= nil and m_activityList~=nil) then
		if(m_curAct ~= nil) then
			m_curAct:removeFromParent()
			m_curAct = nil
			m_curAct = child
  			m_activityList:addChild(m_curAct,-1) 
  		else 
  			m_curAct = child
  			m_activityList:addChild(m_curAct,-1) 
  		end
	end
	
end

-- 显示吃烧鸡
function showPower( )
	MainWonderfulActView.updateLSVPos(WonderfulActModel.tbShowType.kShowSupply)
	require "script/module/wonderfulActivity/supply/MainSupplyCtrl"
	MainSupplyCtrl.create()
end

--显示购买宝箱
function showBuyBox( ... )
	MainWonderfulActView.updateLSVPos(WonderfulActModel.tbShowType.kShowBuyBox)
	require "script/module/wonderfulActivity/buyBox/BuyBoxCtrl"
	BuyBoxCtrl.create()
end
--显示购买贝里
function showBuyBelly( ... )
	MainWonderfulActView.updateLSVPos(WonderfulActModel.tbShowType.kShowBuyMoney)
	require "script/module/wonderfulActivity/shop/ShopCtrl"
	ShopCtrl.create()
end
--显示等级礼包
function showLevelReward( ... )
	MainWonderfulActView.updateLSVPos(WonderfulActModel.tbShowType.kLevelReward)
	require "script/module/levelReward/LevelRewardCtrl"
	LevelRewardCtrl.create(3)
end

--显示签到
function showRegistration( ... )
	MainWonderfulActView.updateLSVPos(WonderfulActModel.tbShowType.kRegistration)
	require "script/module/registration/MainRegistrationCtrl"
	MainRegistrationCtrl.create()
end
--开服礼包
function showAccReward( ... )
	MainWonderfulActView.updateLSVPos(WonderfulActModel.tbShowType.kAccReward)
	require "script/module/accSignReward/MainAccSignCtrl"
	MainAccSignCtrl.create()
end
--显示成长基金
function showGrowthFund( ... )
	MainWonderfulActView.updateLSVPos(WonderfulActModel.tbShowType.kGrowthFund)
	require "script/module/wonderfulActivity/growthFund/GrowthFundCtrl"
	GrowthFundCtrl.create(1)
end

--显示每日分享
function showShareReward( ... )
	MainWonderfulActView.updateLSVPos(WonderfulActModel.tbShowType.kShareReward)
	require "script/module/wonderfulActivity/share/ShareCtrl"
	ShareCtrl.create()
end
--消费累积
function showSpendAccumulate( ... )
	MainWonderfulActView.updateLSVPos(WonderfulActModel.tbShowType.kSpendAccumulate)
	require "script/module/wonderfulActivity/spendAccumulate/SpendAccumulateCtrl"
	SpendAccumulateCtrl.create()
end
--充值回馈
function showRechargeBack( ... )
	MainWonderfulActView.updateLSVPos(WonderfulActModel.tbShowType.kRechargeBack)
	require "script/module/wonderfulActivity/rechargeBack/RechargeBackCtrl"
	RechargeBackCtrl.create()
end
--显示月卡
function showVipCard( ... )
	MainWonderfulActView.updateLSVPos(WonderfulActModel.tbShowType.kVipCard)
	require "script/module/wonderfulActivity/vipcard/VipCardCtrl"
	VipCardCtrl.create()
end
--  显示首充
function showFirstGift( ... )
	MainWonderfulActView.updateLSVPos(WonderfulActModel.tbShowType.kFirstGift)
	require "script/module/wonderfulActivity/firstGift/FirstGiftCtrl"
	FirstGiftCtrl.create()
end
-- vip礼包
function showVipGift( ... )
	MainWonderfulActView.updateLSVPos(WonderfulActModel.tbShowType.kVipGift)
	require "script/module/wonderfulActivity/vipGift/VipGiftCtrl"
	VipGiftCtrl.create()
end
-- 幸运轮盘
function showRoulette( ... )
	MainWonderfulActView.updateLSVPos(WonderfulActModel.tbShowType.kRoulette)
	require "script/module/wonderfulActivity/roulette/RouletteCtrl"
	RouletteCtrl.create()
end
-- 限时宝箱
function showSaleBox( ... )
	MainWonderfulActView.updateLSVPos(WonderfulActModel.tbShowType.kSaleBox)
	require "script/module/wonderfulActivity/saleBox/SaleBoxCtrl"
	SaleBoxCtrl.create()
end
-- 充值红利
function showRechargeBonus( ... )
	MainWonderfulActView.updateLSVPos(WonderfulActModel.tbShowType.kRechargeBonus)
	require "script/module/wonderfulActivity/rechargeBonus/RechargeBonusCtrl"
	RechargeBonusCtrl.create()
end
--挑战福利
function showChallengeWelfare()
	MainWonderfulActView.updateLSVPos(WonderfulActModel.tbShowType.kChallengeWelfare)
	require "script/module/wonderfulActivity/challengeWelfare/ChaWelCtrl"
	ChaWelCtrl.create()
end

function showAccLogin( ... )
	MainWonderfulActView.updateLSVPos(WonderfulActModel.tbShowType.kAccLogin)
	require "script/module/wonderfulActivity/AccumulateLogin/AccLoginCtrl"
	AccLoginCtrl.create()
end

function showStaWelShop( ... )
	MainWonderfulActView.updateLSVPos(WonderfulActModel.tbShowType.kStaWelShop)
	StaticWelfareShopCtrl.create()
end

function showDynWelShop( ... )
	MainWonderfulActView.updateLSVPos(WonderfulActModel.tbShowType.kDynWelShop)
	DynamicWelShopCtrl.create()
end

function showLuxSign( ... )
	MainWonderfulActView.updateLSVPos(WonderfulActModel.tbShowType.kLuxSign)
	LuxurySignCtrl.create()
end

function showDisCountByName( _name,_sender)
	local KshowType = WonderfulActModel.tbShowType.kDisEquip
	if(_name == "equipmentDiscount") then
		KshowType = WonderfulActModel.tbShowType.kDisEquip
	elseif(_name == "conchDiscount") then
		KshowType = WonderfulActModel.tbShowType.kDisConch
	elseif(_name == "exclusiveDiscount") then
		KshowType = WonderfulActModel.tbShowType.kDisExcl
	elseif(_name == "propertyDiscount") then
		KshowType = WonderfulActModel.tbShowType.kDisProps
	elseif(_name == "treasureDiscount") then
		KshowType = WonderfulActModel.tbShowType.kDisTreas
	end
	if(not DiscountData.isDiscountActivityOpenInTime(_name) ) then
		ShowNotice.showShellInfo("本活动已结束，谢谢参与！") ----todo
	else
		MainWonderfulActView.updateLSVPos(KshowType)
		require "script/module/wonderfulActivity/discount/DiscountCtrl"
		DiscountCtrl.createByName(_name)
		MainWonderfulActView.btnSelectFunc(_sender)
	end
end

function showLimitWeal( ... )
	MainWonderfulActView.updateLSVPos(WonderfulActModel.tbShowType.kLimitWeal)
	LimitWelfareCtrl.create()
end
