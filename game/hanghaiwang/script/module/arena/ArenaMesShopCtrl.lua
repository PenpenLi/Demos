-- FileName: ArenaMesShopCtrl.lua
-- Author: huxiaozhou
-- Date: 2014-12-15
-- Purpose: 竞技场神秘商店 控制
--[[TODO List]]


module("ArenaMesShopCtrl", package.seeall)

require "script/module/arena/ArenaMesShopView"

-- 模块局部变量 --
local m_bShowAlert
local m_i18n = gi18n
local m_i18nString = gi18nString

function init(...)
	m_bShowAlert = false
end

local m_index

function destroy(...)
	package.loaded["ArenaMesShopCtrl"] = nil
end

function moduleName()
    return "ArenaMesShopCtrl"
end


function rfrCallBack(  )
	ArenaCtrl.showArenaTab(1)
end

function updateShopView(  )
	-- require "script/module/arena/MainArenaCtrl"
	-- MainArenaCtrl.showArenaShopView()
	ArenaMesShopView.updateAfterBuy(m_index)
end

-- 获得神秘商店信息的网络回调函数
function shopInfoCallBack( cbFlag, dictData, bRet )
	ArenaData.setArenaMesShopInfo(dictData.ret)
	ArenaCtrl.showArenaTab(1)
end

function onRfr( sender,eventType,_alert)
	if (eventType == TOUCH_EVENT_ENDED) then
		local alert = _alert or false
		if (not alert) then
			logger:debug(m_bShowAlert)
			LayerManager.removeLayout()
			m_bShowAlert = true
		end
		--  物品刷新 1  金币刷新  2 
		local rfrType = 2
		local rfrNum= ArenaData.getRfrItemNum()
		if(rfrNum>0) then
			rfrType =1
		end	

		if rfrNum <= 0 and rfrType == 2 and  ArenaData.isRfrMax() then
			ShowNotice.showShellInfo(m_i18n[2252])
			return
		end

		if(rfrNum <=0 and UserModel.getGoldNumber()< tonumber(ArenaData.getRfrGoldNum()) and rfrType==2) then
	  		local noGoldAlert = UIHelper.createNoGoldAlertDlg()
			LayerManager.addLayout(noGoldAlert)
			return
		end

		if(rfrType== 2) then
			UserModel.addGoldNumber(-tonumber( ArenaData.getRfrGoldNum()))
		end

		local args = CCArray:create()
		args:addObject(CCInteger:create(rfrType))
		local function changeBagCallBack( cbFlag, dictData, bRet )
			ArenaData.setArenaMesShopInfo(dictData.ret)	
			require "script/network/PreRequest"
			PreRequest.setBagDataChangedDelete(rfrCallBack)
		end
		if (rfrType==1) then
			RequestCenter.arenamystshop_rfrGoodsList(changeBagCallBack,args)
		else
			RequestCenter.arenamystshop_rfrGoodsList(shopInfoCallBack,args)
		end
	end
end

function showDlg( )
	local rfrNum= ArenaData.getRfrItemNum()
	if(rfrNum<=0) then --  and not m_bShowAlert ) then -- 修改为每次都提示
		
		if ArenaData.isRfrMax() then
			ShowNotice.showShellInfo(m_i18n[2252])
			return
		end

		require "script/module/public/UIHelper"
		local strMsg = m_i18nString(2239,ArenaData.getRfrGoldNum())
		local layDlg = UIHelper.createCommonDlg(strMsg, nil, onRfr)
    	LayerManager.addLayout(layDlg)
	else 
		onRfr(nil,TOUCH_EVENT_ENDED,true)
	end
	
end



function create(  )
	-- m_bShowAlert = false
	local tbBtnEvent = {}
	-- 兑换按钮
	tbBtnEvent.onExChange = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then

			local _allGoods = ArenaData.getArenaMesShopInfo()
			m_index = sender:getTag()
			local itemInfo = _allGoods[sender:getTag()]
			logger:debug(itemInfo)
			  --限购次数
			local maxLimitNum =  itemInfo.canBuyNum
			if(tonumber(maxLimitNum) <= 0 ) then
			   -- ShowNotice.showShellInfo(m_i18n[2253]) -- 支持 #35969
			else

				local itemType, item_id, item_num = ArenaData.getItemData(itemInfo.items)
				 -- 如果有item_template_id检测此类物品所属背包满。武魂背包没有上线，不做检测
				if (item_id and ItemUtil.bagIsFullWithTid(item_id, true)) then
					AudioHelper.playCommonEffect()
					return
				end

				--花费 1：花费类型为声望 , 2：花费类型为金币
				if(tonumber(itemInfo.costType) == 1 and UserModel.getPrestigeNum() < itemInfo.costNum ) then
					AudioHelper.playCommonEffect()
					ShowNotice.showShellInfo(m_i18n[2254])
					return
				end
				if(tonumber(itemInfo.costType) == 2 and UserModel.getGoldNumber() < itemInfo.costNum ) then
					AudioHelper.playCommonEffect()
					local noGoldAlert = UIHelper.createNoGoldAlertDlg()
					LayerManager.addLayout(noGoldAlert)
					return
				end

				local function onSure( num )
					AudioHelper.playBtnEffect("buttonbuy.mp3")
					local args = CCArray:create()
					args:addObject(CCInteger:create(itemInfo.id))
					args:addObject(CCInteger:create(num or 1))
					local function callback( cbFlag, dictData, bRet )
						if tonumber(itemInfo.costType) == 2 then
							UserModel.addGoldNumber(-itemInfo.costNum * (num or 1))
						elseif(tonumber(itemInfo.costType) == 1)then
							UserModel.addPrestigeNum(-itemInfo.costNum*(num or 1))
						end
						ArenaData.addMesGoodsBuyNum(m_index, -(num or 1))
						updateShopView()
						local tbDrop = {}
						local itemType, item_id, item_num = ArenaData.getItemData( itemInfo.items )
						tbDrop.item = {{[item_id] = item_num * (num or 1) }}
						local tItem = ItemUtil.getItemById(item_id)
						ShowNotice.showShellInfo(m_i18nString(6931, tItem.name, item_num*(num or 1)))
						-- UIHelper.showDropItemDlg(tbDrop, m_i18n[2251])
					end
					RequestCenter.arenamystshop_buyGoods(callback, args)
					LayerManager.removeLayout()
				end


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

					local itemDesc = ItemUtil.getItemById(item_id)
					itemName = itemDesc.name
					itemQuality = itemDesc.quality
				elseif(tonumber(itemType) == 2)then
					-- -- DB_Arena_shop表中每条数据中的 英雄数据
					item_data = HeroModel.getAllByHtid(tostring(item_id))
					if( not table.isEmpty(item_data))then
						hasNum = table.count(item_data)
					end

					local heroDesc = HeroUtil.getHeroLocalInfoByHtid(item_id)
					itemName = heroDesc.name
					itemQuality = heroDesc.quality
				end

					AudioHelper.playCommonEffect()
					local tbData = {onSure = onSure,hasNumber = hasNum ,itemName = itemName, canBuyNum = maxLimitNum,
					 costType = itemInfo.costType, costNum = itemInfo.costNum, quality = itemQuality}
					require "script/module/arena/ArenaMesBatchBuy"
					local batchBuy = ArenaMesBatchBuy:new()
					local batchDlg = batchBuy:create(tbData)
					LayerManager.addLayout(batchDlg)

			end

		end
	end

	-- 刷新
	tbBtnEvent.onRfrShop = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			showDlg()
		end
	end


	local arenaShopInfo = ArenaMesShopView.create(tbBtnEvent)
	return arenaShopInfo
end



