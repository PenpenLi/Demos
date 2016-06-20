-- FileName: BuyPropsCtrl.lua
-- Author:zjw
-- Date: 2014-04-00
-- Purpose: 用于购买道具和兑换声望的控制
--[[
 tbInfo ={
    id = "id"                -- 装备id
    propName = "招财符",      -- 显示的道具名字
    gainPropName = "贝里",    -- 兑换后获取的名字
    maxLimitNum = ""         -- 兑换的最多数量
    hasNumber =              --  "现在拥有的个数"
    goldNum =                --"需要的金币或者声望"
    type =                   --"0为声望，1为道具"
    cost_gold_add_siliver =  -- "声望0传即可，用来表示购买价格随着数量增多而提高"
    hero_id =                 --"声望穿0即可" 
}
--]]
--[[TODO List]]

module("BuyPropsCtrl", package.seeall)

require "script/model/utils/HeroUtil"
require "db/DB_Arena_shop"
require "script/module/shop/BuyPropsView"

-- 模块局部变量 --
local ccs = ccs or {}
ccs.CreateType = {
	createTypePrestige = 1, -- 从兑换声望过来
	createTypeProps= 2,  -- 从购买道具列表来
}
local m_i18n = gi18n
local m_type
local m_nCurNum      = nil
local m_tbPrestigeInfo  = nil     --声望信息
local m_tbPropsInfo    = nil      --道具信息
local tbInfo = {}                 --自己构造的信息
local m_nTotalPrice  = nil        --总价

local function init(...)
	m_nCurNum      = nil
	m_tbPrestigeInfo = nil
	m_tbPropsInfo = nil
	m_nTotalPrice = nil
	tbInfo = {}
end

function destroy(...)
	package.loaded["BuyPropsCtrl"] = nil
end

function moduleName()
	return "BuyPropsCtrl"
end

-- 声望信息
local function getPrestigeData( tbItemData)
	-- 得到兑换物品的 物品类型，物品id，物品数量
	local itemType, item_id, item_num = ArenaData.getItemData( tbItemData.items )
	logger:debug( )
	-- 表中物品数据,物品图标
	local item_data = nil
	local itemName = nil
	local itemQuality = nil
	local hasNum = 0
	if(tonumber(itemType) == 1)then
		-- DB_Arena_shop表中每条数据中的 物品数据
		require "script/module/public/ItemUtil"

		item_data = ItemUtil.getCacheItemInfoBy(item_id)
		if( not table.isEmpty(item_data))then
			hasNum = item_data.item_num
		end
		local itemInfo =  ItemUtil.getItemById(item_id)
		itemName = itemInfo.name
		itemQuality = itemInfo.quality
		if(itemInfo.isFragment or itemInfo.isHeroFragment or itemInfo.isTreasureFragment) then
			itemName = itemName .. m_i18n[2448]
		end
	elseif(tonumber(itemType) == 2)then
		-- -- DB_Arena_shop表中每条数据中的 英雄数据
		item_data = HeroModel.getAllByHtid(tostring(item_id))
		if( not table.isEmpty(item_data))then
			hasNum = table.count(item_data)
		end
		local heroInfo = HeroUtil.getHeroLocalInfoByHtid(item_id)
		itemName = heroInfo.name
		itemQuality = heroInfo.quality
	end

	--限购次数
	local maxLimitNum =  tonumber(tbItemData.baseNum) - ArenaData.getBuyNumBy(tbItemData.id)
	logger:debug(maxLimitNum)
	--当前声望可购买的个数
	local canBuyNum = math.floor(UserModel.getPrestigeNum() / tbItemData.costPrestige)
	tbInfo.maxLimitNum = maxLimitNum

	tbInfo.id = item_id
	tbInfo.propName = itemName
	tbInfo.gainPropName = itemName
	tbInfo.canBuyNum = canBuyNum
	tbInfo.hasNumber = hasNum
	tbInfo.goldNum =  tonumber(tbItemData.costPrestige)
	tbInfo.cost_gold_add_siliver = 0
	tbInfo.hero_id = 0
	tbInfo.quality = itemQuality
	return tbInfo
end

-- 购买道具信息
local function getPropsData( tbGoodsData)
	local itemName = ""
	local hasNumber = 0
	local gainName = ""
	local itemQuality = nil

	if (tbGoodsData.item_id ~= nil) then
		local itemDesc = ItemUtil.getItemById(tbGoodsData.item_id)
		itemName = itemDesc.name
		if(itemDesc.isFragment or itemDesc.isHeroFragment or itemDesc.isTreasureFragment) then
			itemName = itemName .. m_i18n[2448]
		end
		
		gainName = itemDesc.name
		itemQuality = itemDesc.quality
		local cacheInfo = ItemUtil.getCacheItemInfoBy(tbGoodsData.item_id)
		if( not table.isEmpty(cacheInfo))then
			hasNumber = cacheInfo.item_num
		end

	elseif (tbGoodsData.hero_id ~= nil) then

		local heroDesc = HeroUtil.getHeroLocalInfoByHtid(tbGoodsData.hero_id)
		itemName = heroDesc.name
		hasNumber = HeroUtil.getHeroNumByHtid(tbGoodsData.hero_id)
		gainName = heroDesc.name
		itemQuality = heroDesc.quality

	end

	local maxNum = 999999
	-- 是否限购
	if(ShopUtil.getAddBuyTimeBy(UserModel.getVipLevel(), tbGoodsData.id) > 0) then
		maxNum = - ShopUtil.getBuyNumBy(tbGoodsData.id) + ShopUtil.getAddBuyTimeBy(UserModel.getVipLevel(), tbGoodsData.id)
	end

	tbInfo.gainPropName = gainName
	tbInfo.propName = itemName
	tbInfo.hasNumber = hasNumber
	tbInfo.maxLimitNum = maxNum
	tbInfo.canBuyNum = maxNum
	tbInfo.id = tbGoodsData.id
	tbInfo.heroId = tbGoodsData.heroId
	tbInfo.type = 1
	tbInfo.quality = itemQuality

	if(tbGoodsData.cost_gold_add_siliver) then
		tbInfo.cost_gold_add_siliver = 1
	else
		tbInfo.cost_gold_add_siliver = 0
	end

	return tbInfo
end

--声望兑换道具回调
local function presitigeCallBack( ... )
	--删除兑换面板
	LayerManager.removeLayout()
	--判断背包是否满
	local itemType, item_id, item_num = ArenaData.getItemData( m_tbPrestigeInfo.items )

	if(m_tbPrestigeInfo.id)then

		local idata = ItemUtil.getItemById(item_id)
		local bagIsFull = idata.fnBagFull(true)
		if(bagIsFull == true) then
			return
		end
	end

	local _goodsData = DB_Arena_shop.getDataById(tonumber(m_tbPrestigeInfo.id))
	m_nTotalPrice = tonumber(m_tbPrestigeInfo.costPrestige) * m_nCurNum

	if(m_nTotalPrice <= UserModel.getPrestigeNum()) then
		-- 下一步创建与数据有关UI
		local function createNext( cbFlag, dictData, bRet )
			-- 减去声望
			UserModel.addPrestigeNum(-m_nTotalPrice)
			-- 得到物品的个数
			ShowNotice.showShellInfo(m_i18n[2236] .. "," .. m_i18n[2237] .. m_nCurNum*item_num .. m_i18n[1422] .. tbInfo.gainPropName )
			-- 更新购买次数
			ArenaData.addBuyNumberBy( _goodsData.id, m_nCurNum )
			m_tbPrestigeInfo.callBack()
		end
		-- 参数
		local args = CCArray:create()
		args:addObject(CCInteger:create(_goodsData.id))
		args:addObject(CCInteger:create(tonumber(m_nCurNum)))
		RequestCenter.arena_buy(createNext,args)
		AudioHelper.playBuyGoods()
	else
		ShowNotice.showShellInfo(m_i18n[2254]) --声望不足
		AudioHelper.playCommonEffect()
	end
end

-- 购买道具的网络后端回调
function buyPropsCallback( cbFlag, dictData, bRet )
	logger:debug("buyPropsCallback")
	if(bRet) then
		if (m_tbPropsInfo.item_id ~= nil) then
			UserModel.addGoldNumber(-m_nTotalPrice)
			local itemInfo = ItemUtil.getItemById(m_tbPropsInfo.item_id)
			ShowNotice.showShellInfo(m_i18n[2227] .. "," .. m_i18n[2237] .. m_nCurNum .. m_i18n[1422] .. itemInfo.name )
		elseif (m_tbPropsInfo.hero_id ~= nil) then
			--武魂
			UserModel.addGoldNumber(-m_nTotalPrice)
			local heroDesc = HeroUtil.getHeroLocalInfoByHtid(m_tbPropsInfo.hero_id)
			ShowNotice.showShellInfo(m_i18n[2227] .. "," .. m_i18n[2237] .. m_nCurNum .. m_i18n[1422] .. heroDesc.name )
		end
		--更新购买次数
		DataCache.addBuyNumberBy( m_tbPropsInfo.id, m_nCurNum )
		--刷新公共面板
		updateInfoBar() -- 新信息条统一更新方法
		--刷新道具列表
		Props.refreshPropsListView()
		--删除购买面板
		LayerManager.removeLayout()
	end
end

--购买道具的回调
local function propsGetCallBack( ... )
	logger:debug(m_tbPropsInfo.id)
	m_nCurNum = m_nCurNum < 1 and 1 or m_nCurNum
	m_nTotalPrice = nil
	if(m_tbPropsInfo.id == 11 )then
		m_nTotalPrice = ShopUtil.getBuySiliverTotalPriceBy(ShopUtil.getBuyNumBy(11)+1, m_nCurNum)
	elseif( m_tbPropsInfo.id == 10) then
		m_nTotalPrice = ShopUtil.getBuySoulTotalPriceBy(ShopUtil.getBuyNumBy(10)+1, m_nCurNum)
	else
		m_nTotalPrice = ShopUtil.getNeedGoldByMoreGoods( m_tbPropsInfo.id, ShopUtil.getBuyNumBy(m_tbPropsInfo.id)+1, m_nCurNum)

		if(ItemUtil.isPropBagFull(true) == true)then
			return
		end
	end

	if(m_nTotalPrice <= UserModel.getGoldNumber()) then
		AudioHelper.playBuyGoods()
		-- 参数
		local args = CCArray:create()
		logger:debug(m_tbPropsInfo.id)
		args:addObject(CCInteger:create(m_tbPropsInfo.id))
		args:addObject(CCInteger:create(tonumber(m_nCurNum)))

		RequestCenter.shop_buyGoods(buyPropsCallback, args)
	else
		--金币不足
		AudioHelper.playCommonEffect()
		require "script/module/public/UIHelper"
		local noGoldAlert = UIHelper.createNoGoldAlertDlg()
		LayerManager.addLayout(noGoldAlert)
	end
end

--设置按钮事件
local function setEvent(tbData)
	-- 确认按钮
	tbData.onSure = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			m_nCurNum = sender:getTag()
			-- AudioHelper.playCommonEffect()
			if(m_type == ccs.CreateType.createTypePrestige)then
				presitigeCallBack()

			else
				propsGetCallBack()
			end
			--      LayerManager.removeLayout()
		end
	end
	-- 取消按钮
	tbData.onClose = function( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCloseEffect()
			LayerManager.removeLayout()
		end
	end
end

-- 兑换声望的界面
function createForPrestige( tbItemInfo )
	init()

	m_tbPrestigeInfo = tbItemInfo
	m_type = ccs.CreateType.createTypePrestige
	tbInfo = getPrestigeData(tbItemInfo)

	setEvent(tbInfo)

	return BuyPropsView.create(tbInfo)
end

-- 购买道具的界面
function createForProps( tbItemInfo )
	init()

	m_type = ccs.CreateType.createTypeProps
	tbInfo = getPropsData(tbItemInfo)
	m_tbPropsInfo = tbItemInfo

	setEvent(tbInfo)

	return BuyPropsView.create(tbInfo)
end
