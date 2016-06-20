-- FileName: copyUsePills.lua
-- Author: xianghuiZhang
-- Date: 2014-04-13
-- Purpose: 显示使用体力丹界面

module("copyUsePills", package.seeall)

require "script/module/copy/copyData"
require "script/module/public/ItemUtil"
require "db/DB_Goods"
require "db/DB_Vip"
-- UI控件引用变量 --
local powerWidget -- 主界面

-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString = gi18nString
local m_fnGetWidget = g_fnGetWidgetByName

local nenergyPills_tid = 10031 --小力丸
local nenergy_tid = 10032 --体力丹
local nenergy_goods_id = 1 --商品id
-- local ngoodsItemid = 1 --购买的商品id
local ncurUsePillTid --当前使用的增加体力物品tid
local ncurUseNum --当前可使用数量
local blBuyPillLay = false --是否为使用体力丹界面
-- local nBuyGoldNum = 0 --当前金币购买次数
local nBuyNeedGold = 0 --当前购买金币数量

local m_updatePowerCallback -- zhangqi, 2014-12-29, 保存刷新其他UI上体力值的回调方法
local m_updateGoldCallback

function moduleName()
	return "copyUsePills"
end

-- 初始函数，加载UI资源文件，
function create( ... )
	--加载主背景UI
	powerWidget = g_fnLoadUI("ui/copy_buypower.json")
	if (powerWidget) then
		UIHelper.registExitAndEnterCall(powerWidget,
				function()
					powerWidget=nil
				end,
				function()
				end
			)
		init()
	end

	return powerWidget
end

--显示购买体力丹药
local function fnBuyPills( ... )
	ncurUsePillTid = nenergy_tid
	local layS = m_fnGetWidget(powerWidget, "LAY_S")
	local btnUseS = m_fnGetWidget(powerWidget, "BTN_USE_S")
	if (layS) then
		layS:setVisible(false)
		btnUseS:setTouchEnabled(false)
	end

	local layB = m_fnGetWidget(powerWidget, "LAY_B")
	local btnUseB = m_fnGetWidget(powerWidget, "BTN_USE_B")
	local btnBuyB = m_fnGetWidget(powerWidget, "BTN_BUY")
	if (layB) then
		layB:setVisible(true)
		btnUseB:setTouchEnabled(true)
		btnBuyB:setTouchEnabled(true)
	end


	local powerLayB = m_fnGetWidget(powerWidget, "LAY_POWER_B")
	if (powerLayB) then
		local goodsItem,goodsInfo = ItemUtil.createBtnByTemplateId(ncurUsePillTid)
		goodsItem:setPosition(ccp(powerLayB:getContentSize().width/2,powerLayB:getContentSize().height/2))
		powerLayB:addChild(goodsItem)
	end
	ncurUseNum = ItemUtil.getCacheItemNumBy(ncurUsePillTid)
	fnUpdateBuyLayer()
end

--获取不同vip等级的购买物品次数
local function fnGetVipBuyNum( itemTid )
	local vipNum = 0

	local vipInfo = DB_Vip.getDataById(UserModel.getVipLevel()) -- vip等级从0开始，按id查表需要加1
	if (vipInfo) then
		local splitTemp = lua_string_split(vipInfo.day_buy_goods,",")
		for k,v in pairs(splitTemp) do
			local goodsTemp = lua_string_split(v,"|")
			if (goodsTemp[1] and tonumber(goodsTemp[1]) == tonumber(itemTid)) then
				vipNum = goodsTemp[2] and tonumber(goodsTemp[2]) or 0
			end
		end
	end
	return vipNum
end

--获取当前服务端纪录的购买次数
local function fnGetCacheNum( ... )
	local buyNum = 0
	local shopCache = DataCache.getShopCache()
	if (shopCache) then
		local buyGoodsInfo = shopCache.goods[tostring(nenergy_goods_id)]
		if (buyGoodsInfo ~= nil) then
			buyNum = tonumber(buyGoodsInfo.num)
		end
	end

	return buyNum
end

--获取当前购买丹药所需金币数量
local function fnGetBuyGold( ... )
	local curGoodsInfo = DB_Goods.getDataById(nenergy_goods_id)
	local buyNum = fnGetCacheNum()
	require "script/module/shop/ShopUtil"
	local useGolds = ShopUtil.getPriceByTimes(curGoodsInfo,buyNum+1)
	return useGolds
end

--判断是否可购买金币数量
local function fnConfirmBuy( ... )
	local confirm = true
	local curGoodsInfo = DB_Goods.getDataById(nenergy_goods_id)
	if (UserModel.getVipLevel() < curGoodsInfo.vip_needed) then
		ShowNotice.showShellInfo(m_i18n[1947])
		confirm = false
	end

	if (UserModel.getHeroLevel() < curGoodsInfo.user_lv_needed) then
		ShowNotice.showShellInfo(m_i18n[1948])
		confirm = false
	end

	local buyNum = fnGetCacheNum()
	local vipnum = fnGetVipBuyNum(nenergy_goods_id)
	if (buyNum >= vipnum) then
		local tmpStr = m_i18n[1949]
		ShowNotice.showShellInfo(string.format(tmpStr,tonumber(UserModel.getVipLevel()),tonumber(vipnum)))
		confirm = false
	end

	return confirm
end

--购买按钮点击
local function fnBuyListener( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		if(fnConfirmBuy()) then
			local needGold = fnGetBuyGold()
			if (needGold ~= nil) then
				if(UserModel.getGoldNumber() >= needGold ) then
					nBuyNeedGold = needGold
					buyPillsAddEny()
					AudioHelper.playBtnEffect("buttonbuy.mp3")
				else
					AudioHelper.playCommonEffect()
					-- ShowNotice.showShellInfo(m_i18n[1950])
					local noGoldAlert = UIHelper.createNoGoldAlertDlg()
					LayerManager.addLayout(noGoldAlert)
				end
			end
		else
			AudioHelper.playCommonEffect()
		end
	end
end

--更新购买体力丹界面
function fnUpdateBuyLayer( ... )
	local tfdNumB = m_fnGetWidget(powerWidget, "TFD_NUM_B")
	if (tfdNumB) then
		local useItemInfo = DB_Item_direct.getDataById(ncurUsePillTid)
		tfdNumB:setText(useItemInfo.energy .. "")
		UIHelper.labelEffect(tfdNumB)
	end

	local btnUse = m_fnGetWidget(powerWidget, "BTN_USE_B")
	if (btnUse) then
		UIHelper.titleShadow(btnUse, m_i18nString(1375, ncurUseNum)) -- 2015-10-09
		btnUse:addTouchEventListener(function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				if (ncurUseNum > 0) then
					AudioHelper.playBtnEffect("shiyong_yaoshui.mp3")
					local useItem = ItemUtil.getCacheItemInfoBy(ncurUsePillTid)
					usePillsAddEny(useItem)
				else
					AudioHelper.playCommonEffect()
					ShowNotice.showShellInfo(m_i18n[1344])
				end
			end
		end)
	end

	local needGold = fnGetBuyGold()
	local goldNum = m_fnGetWidget(powerWidget, "TFD_GOLD")
	if (goldNum and needGold ~=nil ) then
		goldNum:setText(needGold.."")
		UIHelper.labelEffect(goldNum)
	end

	local powerBuy = m_fnGetWidget(powerWidget, "BTN_BUY")
	if (powerBuy) then
		powerBuy:addTouchEventListener(fnBuyListener)
	end

end

--更新使用体力丹界面
function fnUpdateUseLayer( ... )
	logger:debug("ncurUseNum"..ncurUseNum)

	local tfdNumS = m_fnGetWidget(powerWidget, "TFD_NUM_S")
	if (tfdNumS) then
		local useItemInfo = DB_Item_direct.getDataById(ncurUsePillTid)
		tfdNumS:setText(useItemInfo.energy .. "")
		UIHelper.labelEffect(tfdNumS)
	end

	local btnUse = m_fnGetWidget(powerWidget, "BTN_USE_S")  
	if (btnUse) then
		UIHelper.titleShadow(btnUse, m_i18nString(1375, ncurUseNum)) -- 2015-10-09
		btnUse:addTouchEventListener(function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				if (ncurUseNum > 0) then
					local useItem = ItemUtil.getCacheItemInfoBy(ncurUsePillTid)
					usePillsAddEny(useItem)
					AudioHelper.playBtnEffect("shiyong_yaoshui.mp3")
				else
					 AudioHelper.playCommonEffect()
					ShowNotice.showShellInfo(m_i18n[1344])
				end
			end
		end)
	end
end

--显示使用体力丹药
local function fnUsePills( tid )
	ncurUsePillTid = tid

	local powerLayB = m_fnGetWidget(powerWidget, "LAY_B")
	local btnUseB = m_fnGetWidget(powerWidget, "BTN_USE_B")
	local btnBuyB = m_fnGetWidget(powerWidget, "BTN_BUY")
	if (powerLayB) then
		powerLayB:setVisible(false)
		btnBuyB:setTouchEnabled(false)
		btnUseB:setTouchEnabled(false)
	end

	local powerLayS = m_fnGetWidget(powerWidget, "LAY_S")
	local btnUseS = m_fnGetWidget(powerWidget, "BTN_USE_S")
	if (powerLayS) then
		powerLayS:setVisible(true)
		btnUseS:setTouchEnabled(true)
		local powerLay = m_fnGetWidget(powerLayS, "LAY_POWER_S")
		if (powerLay) then
			powerLay:setVisible(true)
			local goodsItem,goodsInfo = ItemUtil.createBtnByTemplateId(tid)
			goodsItem:setPosition(ccp(powerLay:getContentSize().width/2,powerLay:getContentSize().height/2))
			powerLay:addChild(goodsItem)
		end
	end

	ncurUseNum = ItemUtil.getCacheItemNumBy(ncurUsePillTid)
	fnUpdateUseLayer()

end

-- 提示是否需要购买体力丹
local function fnShowEnergy( ... )
	local btnClose = m_fnGetWidget(powerWidget, "BTN_CLOSE")
	btnClose:addTouchEventListener(UIHelper.onClose)

	local labBuy = m_fnGetWidget(powerWidget, "TFD_BUY") -- 2015-10-09
	UIHelper.labelShadowWithText(labBuy, m_i18n[1435])

	local vipContent = m_fnGetWidget(powerWidget, "TFD_VIP_STAMINA")
	vipContent:removeFromParentAndCleanup(true)

	local i18n_tfd_tip = m_fnGetWidget(powerWidget, "tfd_tip")
	i18n_tfd_tip:setText(m_i18n[1317])
	
	local notice = m_fnGetWidget(powerWidget, "TFD_TIP_INFO")
	if (notice) then
		notice:setText(m_i18n[1318])
	end

	local tfdtili = m_fnGetWidget(powerWidget, "tfd_tili")
	UIHelper.labelEffect(tfdtili,m_i18n[1304])

	blBuyPillLay = false
	if (ItemUtil.isItemInBagBy(nenergyPills_tid)) then
		fnUsePills(nenergyPills_tid)
	else
		blBuyPillLay = true
		fnBuyPills()
	end
end


function init( ... )
	m_updatePowerCallback = nil
	m_updateGoldCallback = nil
	fnShowEnergy()
end

-- zhangqi, 2014-12-29
function setUpdateCallback( fnUpdatePower, fnUpdateGold )
	if (fnUpdatePower and type(fnUpdatePower) == "function") then
		logger:debug("setUpdateCallback")
		m_updatePowerCallback = fnUpdatePower
	end
	if (fnUpdateGold and type(fnUpdateGold) == "function") then
		m_updateGoldCallback = fnUpdateGold
	end
end

function showLackTips( bShow )
	local tip = m_fnGetWidget(powerWidget, "tfd_tip")
	tip:setEnabled(bShow)
end

-----------数据请求返回处理
local function useItemCallback( cbFlag, dictData, bRet )
	if (bRet) then
		local useItem = ItemUtil.getCacheItemInfoBy(ncurUsePillTid)
		if (useItem) then
			ItemUtil.reduceItemByGid(useItem.gid,1)
		end
		require "db/DB_Item_direct"
		local useItemInfo = DB_Item_direct.getDataById(ncurUsePillTid)
		ShowNotice.showShellInfo(string.format(m_i18n[1345],tostring(useItemInfo.energy)))
		UserModel.addEnergyValue(tonumber(useItemInfo.energy))
		-- zhangqi, 2014-12-29, 增加刷新角色详情面板上体力值的回调方法
		if (m_updatePowerCallback) then
			m_updatePowerCallback()
		end

		if (ncurUseNum - 1 > 0) then
			ncurUseNum = ncurUseNum - 1
		else
			ncurUseNum = 0
		end
		
		--liweidong 使用完小体力丹之后显示使用大体力丹
		blBuyPillLay = false
		if (ItemUtil.isItemInBagBy(nenergyPills_tid)) then
			fnUsePills(nenergyPills_tid)
			fnUpdateUseLayer()
		else
			blBuyPillLay = true
			fnBuyPills()
			fnUpdateBuyLayer()
		end
		-- LayerManager.removeLayout()
	end
end

--使用体力丹增加体力
function usePillsAddEny( tbEnergyInfo )
	print("tbEnergyInfo")
	print_t(tbEnergyInfo)
	if (tbEnergyInfo) then
		local args = Network.argsHandler(tbEnergyInfo.gid, tbEnergyInfo.item_id, 1)
		RequestCenter.bag_useItem(useItemCallback, args)
	end
end

local function buyPillsCallback( cbFlag, dictData, bRet )
	if (dictData.err == "ok") then
		UserModel.addGoldNumber(-nBuyNeedGold)
		DataCache.addBuyNumberBy(nenergy_goods_id, 1 )
		nBuyNeedGold=0
		ncurUseNum = ncurUseNum + 1
		fnUpdateBuyLayer()
		-- LayerManager.removeLayout()
		-- zhangqi, 2014-12-29, 增加刷新其他UI(例如角色详情面板)上的金币数值
		if (m_updateGoldCallback) then
			m_updateGoldCallback()
		end
		ShowNotice.showShellInfo(m_i18n[2227])
	elseif(dictData.err == "overflow") then
		ShowNotice.showShellInfo(m_i18n[1951])
	end
end

--购买体力丹增加体力
function buyPillsAddEny( ... )
	local args = Network.argsHandler(nenergy_goods_id, 1)
	RequestCenter.shop_buyGoods(buyPillsCallback, args)
end

-- 析构函数，释放纹理资源
function destroy( ... )

end
