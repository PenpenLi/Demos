-- FileName: ArenaBuyCtrl.lua
-- Author: huxiaozhou
-- Date: 2014-05-18
-- Purpose: 耐力不够后调用的提示购买面板 ,竞技场次数不足后购买面板
--[[TODO List]]

module("ArenaBuyCtrl", package.seeall)
require "script/module/arena/ArenaBuyView"
require "script/module/shop/ShopUtil"
require "script/network/PreRequest"

-- require "db/DB_Goods"
-- UI控件引用变量 --

local m_i18n = gi18n
local m_i18nString = gi18nString
-- 模块局部变量 --
local m_pillId = 10042

local m_fnDelegate

local m_updateStaminaCallback -- zhangqi, 2014-12-29, 保存刷新其他UI上体力值的回调方法
local m_updateGoldCallback

local function init(...)
	m_updateStaminaCallback = nil
	m_updateGoldCallback = nil
end

function destroy(...)
	package.loaded["ArenaBuyCtrl"] = nil
end

function moduleName()
    return "ArenaBuyCtrl"
end

-- 更新背包数据后回调
function updateUI( )
	if(m_fnDelegate~=nil and type(m_fnDelegate)  == "function") then
		m_fnDelegate()
	end
	logger:debug(UserModel.getStaminaNumber())
	ArenaBuyView.updateUI()
	LayerManager.removeLayout()
	PreRequest.removeBagDataChangedDelete()
end

--使用加耐力 增加竞技场次数
function usePillsAddSta( tid ,callback)
	local cacheInfo = ItemUtil.getCacheItemInfoBy(tid)

	local function useItemCallback( cbFlag, dictData, bRet )
		logger:debug(dictData)
		local itemInfo = ItemUtil.getItemById(cacheInfo.item_template_id)
		ShowNotice.showShellInfo(m_i18nString(2225,itemInfo.endurance))
		ArenaBuyView.updateStamina()
		if (m_updateStaminaCallback) then -- zhangqi, 2014-12-29
			m_updateStaminaCallback()
		end
	end

	if (cacheInfo==nil and tonumber(tid) ~= 10002) then
		AudioHelper.playCommonEffect()
		ShowNotice.showShellInfo(m_i18n[2224])
		return
	end
	if (cacheInfo==nil and tonumber(tid) == 10002) then
		AudioHelper.playCommonEffect()
		ShowNotice.showShellInfo(m_i18n[2241])
		return
	end
	AudioHelper.playBtnEffect("shiyong_yaoshui.mp3")
	if callback then
		PreRequest.setBagDataChangedDelete(updateUI1)
	else
		PreRequest.setBagDataChangedDelete(updateUI)
	end
	LayerManager.addLayoutNoScale(Layout:create())

    local args = Network.argsHandler(cacheInfo.gid, cacheInfo.item_id, 1)
    RequestCenter.bag_useItem( callback or useItemCallback, args)
end

function buyPillsCallback( cbFlag, dictData, bRet )
	logger:debug(dictData)
	 local cacheInfo = DataCache.getShopCache()
	 logger:debug(cacheInfo)
	require "script/network/PreRequest"
	ArenaBuyView.updateGold()
	local cacheInfo = DataCache.getShopCache()
	logger:debug(cacheInfo)
	DataCache.addBuyNumberBy(2,1)
 	ShowNotice.showShellInfo(m_i18n[2227])
	if (m_updateGoldCallback) then -- zhangqi, 2014-12-29, 刷新角色详情面板的金币数值
		m_updateGoldCallback()
	end
end

-- 刷新 购买 竞技场item 界面
function useItemCallback1( cbFlag, dictData, bRet )
	local cacheInfo = ItemUtil.getCacheItemInfoBy(10002)
	local itemInfo = ItemUtil.getItemById(cacheInfo.item_template_id)
	ShowNotice.showShellInfo(m_i18nString(2225,itemInfo.add_challenge_times))
	
	ShowNotice.showShellInfo(m_i18n[2247])
	require "script/network/PreRequest"
	ArenaData.addTodayChallengeNum(1)
end

-- 刷新 购买 竞技场item 界面
function updateUI1( )
	if(m_fnDelegate~=nil and type(m_fnDelegate)  == "function") then
		m_fnDelegate()
	end
	ArenaBuyView.loadUI()
	LayerManager.removeLayout()
	PreRequest.removeBagDataChangedDelete()
end

-- 刷新 购买 竞技场item 界面
function buyPillsCallback1( cbFlag, dictData, bRet )
	logger:debug(dictData)
	 local cacheInfo = DataCache.getShopCache()
	 logger:debug(cacheInfo)
	require "script/network/PreRequest"
	ArenaBuyView.updateGold()
	local cacheInfo = DataCache.getShopCache()
	logger:debug(cacheInfo)
	DataCache.addBuyNumberBy(15,1)
 	ShowNotice.showShellInfo(m_i18n[2227])
end


function buyPills( tid ,callfunc)
	 require "db/DB_Goods"
    local goodsData = DB_Goods.getDataById(tonumber(tid))

    if(goodsData.vip_needed and tonumber(goodsData.vip_needed)>tonumber(UserModel.getVipLevel())) then
        ShowNotice.showShellInfo(m_i18nString(2235,goodsData.vip_needed))
        return
    end
    if(goodsData.user_lv_needed and  tonumber(goodsData.user_lv_needed)> tonumber( UserModel.getHeroLevel())) then
        ShowNotice.showShellInfo(m_i18nString(2234,goodsData.user_lv_needed))
        return
    end
	--购买
	local m_gold =  ShopUtil.getNeedGoldByGoodsAndTimes(tid,ShopUtil.getBuyNumBy(tid)+1)
	if(m_gold> UserModel.getGoldNumber()) then
			local noGoldAlert = UIHelper.createNoGoldAlertDlg()
			LayerManager.addLayout(noGoldAlert)

		return
	end
	 local limitNum = ShopUtil.getAddBuyTimeBy(UserModel.getVipLevel(),tid) - ShopUtil.getBuyNumBy(tid)
	 if(limitNum<=0) then
	  	ShowNotice.showShellInfo(m_i18n[2226])
		return
	 end

	 LayerManager.addLayoutNoScale(Layout:create())
	 if callfunc then
	 	PreRequest.setBagDataChangedDelete(updateUI1)
	 else
	 	PreRequest.setBagDataChangedDelete(updateUI)
	 end
	 
    local args = Network.argsHandler(tid, 1)
    RequestCenter.shop_buyGoods(callfunc or buyPillsCallback, args)
    
end

function createForArena(fnDelegate)
	init()

	m_fnDelegate = fnDelegate
	local tbBtnEvent = {}
	-- buy
	tbBtnEvent.onBuy = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			buyPills(sender:getTag())
		end
	end
	-- use
	tbBtnEvent.onUse = function( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			-- AudioHelper.playCommonEffect()
			AudioHelper.playBtnEffect("shiyong_yaoshui.mp3")
			usePillsAddSta(sender:getTag())
		end	
	end

	local buyLayOut = ArenaBuyView.create(m_pillId,tbBtnEvent)
	return buyLayOut
end

function create( fnDelegate )
	init()
	
	m_fnDelegate = fnDelegate
	local tbBtnEvent = {}
	-- buy
	tbBtnEvent.onBuy = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			buyPills(sender:getTag(),buyPillsCallback1)
			logger:debug(sender:getTag())

		end
	end
	-- use
	tbBtnEvent.onUse = function( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			usePillsAddSta(sender:getTag(), useItemCallback1)
		end	
	end

	local buyLayOut = ArenaBuyView.createBuyArenaItem(10002,tbBtnEvent)
	return buyLayOut
end

-- zhangqi, 2014-12-29
function setUpdateCallback( fnUpdateStamina, fnUpdateGold )
	if (fnUpdateStamina and type(fnUpdateStamina) == "function") then
		logger:debug("setUpdateCallback")
		m_updateStaminaCallback = fnUpdateStamina
	end
	if (fnUpdateGold and type(fnUpdateGold) == "function") then
		m_updateGoldCallback = fnUpdateGold
	end
end

