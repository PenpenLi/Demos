-- FileName: RapidSaleCtrl.lua
-- Author: sunyunpeng
-- Date: 2015-04-10
-- Purpose: 快速出售控制逻辑
--[[TODO List]]

module("RapidSaleCtrl", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --
local m_tbBagInfo  --所有背包物品
local m_tbRapidSacleInfo  --所有可快捷出售的物品
local m_i18nString = gi18nString
local m_nTotalSilver
local m_nDelCellNum
local m_btnStr


local function init(...)

end

function destroy(...)
	package.loaded["RapidSaleCtrl"] = nil
end

function moduleName()
	return "RapidSaleCtrl"
end


-- 获取背包中可以快捷出售的物品 并计算总价和总数
local function getRapidSaleData( m_tbBagInfo )
	m_nTotalSilver = 0
	m_nDelCellNum = 0
	local tbSaleGroup = {}
	local tbItem = {}
	local tbEnd = false
	for i, v in ipairs(m_tbBagInfo.props or {}) do
		if (i == #m_tbBagInfo.props) then
			tbEnd=true
		end
		if (tonumber(v.itemDesc.isSellDirect) == 1) then -- 可快捷出售
			local item = {}
			item.id = v.itemDesc.id
			item.name = v.itemDesc.name
			item.num = v.item_num
			item.sellnum = v.itemDesc.sell_num
			item.type = v.itemDesc.sell_type
			item.quality = v.nQuality
			item.gid = v.gid
			item.itemid = v.item_id

			table.insert(tbItem, item)
			m_nDelCellNum = m_nDelCellNum + 1
			m_nTotalSilver = m_nTotalSilver + tonumber(item.num) * item.sellnum

		end

        if (((#tbItem ==4 ) or (tbEnd)) and (#tbItem>0))then
			   table.insert(tbSaleGroup, tbItem)
			   tbItem = {}
		end
		
	end

	return tbSaleGroup
end

-- 出售按钮回调
local function onRapidSale(sender, eventType )
	-- 更新当前UI
	local function funcSellCallback( cbFlag, dictData, bRet  )
		require "script/module/bag/MainBagCtrl"
	    MainBagCtrl.setCallBackBag(m_nDelCellNum)
		UserModel.addSilverNumber(m_nTotalSilver)
		ShowNotice.showShellInfo(m_i18nString(1508,m_nTotalSilver)) -- TDDO
	end



	-- 向服务器端发送请求
	local function funcRapidSaleCall()
		LayerManager.removeLayout()
		local tempArgs = CCArray:create()
		for i, saleGroupd in ipairs(m_tbRapidSacleInfo) do

			for k, v in pairs(saleGroupd) do
				local arrItems = CCArray:create()
				logger:debug(v)
				arrItems:addObject(CCInteger:create(v.gid))
				arrItems:addObject(CCInteger:create(v.itemid))
				arrItems:addObject(CCInteger:create(v.num))
				tempArgs:addObject(arrItems)
			end
		end
		local arrArgs = CCArray:create()
		arrArgs:addObject(tempArgs)
		RequestCenter.bag_sellItems(funcSellCallback, arrArgs)
	end



	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playBuyGoods()
		funcRapidSaleCall()
		LayerManager.removeLayout()
	end
end


function  filterModule( moduleName )
	logger:debug({filterModule_moduleName = moduleName})
	if (moduleName == "MainEquipmentCtrl") then -- 装备背包
		return true
	elseif (moduleName == "MainBagCtrl") then   -- 道具背包
		return true
	elseif (moduleName == "MainTreaBagCtrl") then -- 饰品背包
		return true
	elseif (moduleName == "SBListCtrl") then    -- 宝物背包
		return true
	elseif (moduleName == "MainConchCtrl") then  -- 空岛被背包
		return true
	elseif (moduleName == "ImpelShopCtrl") then  -- 装备商店
		return true
	elseif (moduleName == "MysteryCastleCtrl") then  -- 神秘商店
		return true
	elseif (moduleName == "GuildShopCtrl") then  -- 公会商店
		return true
	elseif (moduleName == "TreaShopCtrl") then  -- 宝物商店
		return true
	elseif (moduleName == "SkyPieaShopCtrl") then  -- 空岛被商店
		return true
	end

	return false
end

-- 特殊地方 1 酒馆道具叶签MainShopCtrl  2 竞技场商店ArenaCtrl
function create( moduleName)
	if (moduleName and not filterModule(moduleName) ) then
		return 
	end
	m_tbBagInfo = DataCache.getBagInfo()

	m_tbRapidSacleInfo=getRapidSaleData( m_tbBagInfo )
    
	require "script/module/rapidSale/RapidSaleView"
	if ( #m_tbRapidSacleInfo > 0) then
		local layMain=RapidSaleView.create({closeEvent = UIHelper.onClose, rapidSaleEvent = onRapidSale, tbData = m_tbRapidSacleInfo,totalSilver = m_nTotalSilver})
		LayerManager.addLayout(layMain)
	end
end
