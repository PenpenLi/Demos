-- FileName: WonderfulActModel.lua
-- Author: 精彩活动数据模块
-- Date: 2014-04-00
-- Purpose: function description of module
--[[TODO List]]

module("WonderfulActModel", package.seeall)

require "script/module/wonderfulActivity/mysteryCastle/MysteryCastleData"
require "script/module/wonderfulActivity/supply/SupplyModel"
require "script/module/registration/MainRegistrationCtrl"
require "script/module/accSignReward/AccSignModel"
require "script/module/wonderfulActivity/growthFund/GrowthFundModel"
require "script/module/wonderfulActivity/growthFund/EveryoneWelfareModel"
require "script/module/wonderfulActivity/spendAccumulate/SpendAccumulateModel"
require "script/module/wonderfulActivity/rechargeBack/RechargeBackModel"
require "script/module/wonderfulActivity/vipcard/VipCardModel"
require "script/module/wonderfulActivity/share/ShareModel"
require "script/module/wonderfulActivity/vipGift/VipGiftModel"
require "script/module/wonderfulActivity/roulette/RouletteModel"
require "script/module/wonderfulActivity/saleBox/SaleBoxModel"
require "script/module/wonderfulActivity/rechargeBonus/RechargeBonusModel"
require "script/module/wonderfulActivity/AccumulateLogin/AccLoginModel"
require "script/module/wonderfulActivity/discount/DiscountData"


tbShowType = {
	kShowDefault = "accReward", --签到
	kShowSupply = "supply", -- 喝可乐
	-- kShowBuyBox        = "buyBox", -- 购买宝箱
	kShowBuyMoney        = "buyMoney", -- 购买贝里
	kRegistration        = "registration", -- 签到
	kLevelReward        = "levelReward", -- 等级礼包
	kAccReward       	= "accReward", -- 开服礼包
	kShareReward		= "shareReward",	-- 每日分享
	kSpendAccumulate	= "spendAccumulate", --消费累积
	kRechargeBack		= "rechargeBack", --充值回馈
	kGrowthFund			= "growthfund", -- 成长基金
	kVipCard			= "vipcard", --月卡
	kFirstGift			= "firstGift", --首充
	kVipGift			= "vipGift", -- vip礼包
	kRoulette			= "roulette", -- 幸运轮盘
	kSaleBox			= "saleBox",  -- 限时宝箱
	kRechargeBonus		= "rechargeBonus", -- 充值红利
	kChallengeWelfare	= "challengeWelfare", --挑战福利
	kDisEquip			= "discountEquip", 		--挑战福利
	kDisConch			= "discountConch", 		--挑战福利
	kDisTreas			= "discountTreas", 		--挑战福利
	kDisExcl			= "discountExcl",  		--挑战福利
	kDisProps			= "discountProps",  	--挑战福利
	kAccLogin			= "accLogin",
	kStaWelShop			= "staWelShop",		-- 静态福利商店
	kDynWelShop			= "dynWelShop",		-- 动态福利商店
	kLuxSign			= "luxSign",		-- 豪华签到
	kLimitWeal			= "limitWeal",		-- 限时福利
}

local function isShowBellyRed()
	do return false end
	if(not SwitchModel.getSwitchOpenState(ksSwitchBuyBox,false)) then
		return false
	end
	require "script/module/shop/ShopUtil"
	-- local cacheInfo = DataCache.getShopCache()
	-- logger:debug("canch INfo:")
	-- logger:debug(cacheInfo)
	-- if (not cancheInfo) then
	-- 	return false
	-- end
	local price = ShopUtil.getSiliverPriceBy( ShopUtil.getBuyNumBy(11)+1 )
	if (tonumber(price)==0) then
		return true
	end
	return false
end
tbTipVisible = {
	["supply"] =   SupplyModel.isOnTime, --吃烧鸡显示不显示
	["buyBox"] = 	function() 
						return false
					end, 
	["registration"] = 	MainRegistrationCtrl.fnCheckRegistrationTip, -- 签到红点显示不显示
	["levelReward"] = 	function() 
						 local rewardNum = LevelRewardCtrl.getRewardNum() 
						    if rewardNum > 0 then 
							  return true
						    else
							  return false
						    end
					    end, -- 等级礼包红点显示不显示
	["accReward"] = function() 
						 local rewardNum = AccSignModel.getCanGotRewardNum()   -- 开服礼包红点显示不显示
						    if rewardNum > 0 then 
							  return true
						    else
							  return false
						    end
					    end, -- 等级礼包红点显示不显示
	["buyMoney"] =	isShowBellyRed,
					
	["growthfund"] = function (  )
						if (GrowthFundModel.getUnprizedNumByTime() == 0 and EveryoneWelfareModel.getNumStillCanReceive() == 0)then 
							return false
						else
							return true
						end
					end,
	["vipcard"] = function (  )
						if VipCardModel.getRedPoint() == 0 then 
							return false
						else
							return true
						end
					end,

	["spendAccumulate"] = SpendAccumulateModel.needShowRedPoint,

	["rechargeBack"] = RechargeBackModel.needShowRedPoint,

	["firstGift"] = FirstGiftData.getShowRedPoint,

	["vipGift"] = function ( )
		return VipGiftModel.getRedPoint()
	end,

	["roulette"] = function ( ... )
		return RouletteModel.bShowRedPoint()
	end,

	["saleBox"] = function ( ... )
		return SaleBoxModel.bShowRedPoint()
	end,

	["rechargeBonus"] = function ( ... )
		return RechargeBonusModel.needShowRedPoint()
	end,

	["challengeWelfare"] = function ()
			if (ChaWelModel.getRedTipStatus()<=0) then
				return false
			else
				return true
			end
			-- if (tonumber(ChaWelModel.getNewAniState()) == 1) then
			--  	if (ChaWelModel.getRedTipStatus()<=0) then
			-- 		return false
			-- 	else
			-- 		return true
			-- 	end
			-- else
			-- 	return false
			-- end
		end,

	["discountEquip"] 	= function ()return false end,
	["discountTreas"] = function ()return false end,
	["discountConch"] = function ()return false end,
	["discountExcl"] = function ()return false end,
	["discountProps"] = function ()return false end,

	["discountAct"] = function ( ... )
		return DiscountData.getDiscountRedState()   -- 五个打折活动是否需要红点
	end,

	["accLogin"] = function ( ... )
		return AccLoginModel.getTipCount() > 0
	end,

	["staWelShop"] = function ( ... )
		if (StaticWelfareShopCtrl.getIsActivityOn() and (tonumber(StaticWelfareShopCtrl.getNewAniState()) ~= 1)) then
			return true
		else
			return false
		end
	end,

	["dynWelShop"] = function ( ... )
		if (DynamicWelShopCtrl.getIsActivityOn() and (tonumber(DynamicWelShopCtrl.getNewAniState()) ~= 1)) then
			return true
		else
			return false
		end
	end,

	["luxSign"] = function ( ... )
		-- 如果有红点，或者有new，则为true
		if (LuxurySignModel.isHaveCanGain() or (not LuxurySignModel.isLoginLuxurySign())) then
			return true
		else
			return false
		end
	end,

	["limitWeal"] = function ( ... )
		if (LimitWelfareModel.isLimitWelfareOpen()) and (tonumber(LimitWelfareModel.getNewAniState()) ~= 1) then
			return true
		else
			return false
		end
	end
}

tbBtnActList = {
	
}



local tbActList = {
}

function setActList( _tbActList )
	tbActList = _tbActList
end

function getActList(  )
	return tbActList
end
-- 

-- 判断主界面上精彩活动按钮是不是应该有红点
function hasTipInActive( )
	local bRed = false
    for k,fuc in pairs(tbTipVisible) do
    	if fuc() then
    		-- logger:debug("hhhhhhhh" .. k)
    		bRed = true
    		break
    	end
    end
    return bRed
end


