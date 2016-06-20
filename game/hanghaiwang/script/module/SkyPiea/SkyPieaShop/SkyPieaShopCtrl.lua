-- FileName: SkyPieaShopCtrl.lua
-- Author: huxiaozhou
-- Date: 2015-01-12
-- Purpose: 空岛商店 控制
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /


module("SkyPieaShopCtrl", package.seeall)
require "script/module/SkyPiea/SkyPieaShop/SkyPieaShopView"

local m_fnCallback
-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString = gi18nString
local m_bShowAlert

local function init(...)
	m_fnCallback = nil
	m_bShowAlert = false
end

function destroy(...)
	package.loaded["SkyPieaShopCtrl"] = nil
end

function moduleName()
	return "SkyPieaShopCtrl"
end

--[[
	@desc: 获取要绑定的function
    @return: tb  type: table
—]]
function getBtnBindingFuctions(  )
	local tbEvent = {}

	-- 返回按钮事件
	tbEvent.onBack = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playBackEffect()
			MainSkyPieaCtrl.createView()
		end
	end
	if m_fnCallback then
		tbEvent.onBack = m_fnCallback
	end

	-- 刷新按钮事件
	tbEvent.onRfr = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			showDlg()
		end
	end

	-- 兑换按钮事件
	tbEvent.onBuy = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()

			local tbGoodsData = SkyPieaModel.getSkyPieaGoodsList()
			local tbReward = tbGoodsData[sender:getTag()]
			local costType = tonumber(tbReward.costType)
			local costNum = tonumber(tbReward.costNum)
			if costType == 1 then
				if UserModel.getSkyPieaBellyNum() < costNum then
					ShowNotice.showShellInfo(m_i18n[5405])
					return
				end
			elseif costType == 2 then
				if UserModel.getGoldNumber() < costNum then
					LayerManager.addLayout(UIHelper.createNoGoldAlertDlg())
					return
				end
			elseif costType == 3 then
				if UserModel.getSilverNumber() < costNum then
					ShowNotice.showShellInfo(m_i18n[1617])
					PublicInfoCtrl.createItemInfoViewByTid(60406,nil,true)  -- 贝里不足引导界面
					return
				end
			end

			-- 判断背包满没满
			if (tbReward.tid and ItemUtil.bagIsFullWithTid(tbReward.tid, true)) then
				return
			end

			buyGoods(tbReward.id, function ( )
				if costType == 1 then
					UserModel.addSkyPieaBellyNum(-costNum)
				elseif costType == 2 then
					UserModel.addGoldNumber(-costNum)
				elseif costType == 3 then
					UserModel.addSilverNumber(-costNum)
				end

				SkyPieaModel.changeCanBuyNumByid(tbReward.id,1)
				local tbGoods = SkyPieaModel.getSkyPieaGoodsList()[sender:getTag()]
				SkyPieaShopView.updateCellAndLabs(sender:getTag(),tbGoods)
				local tbRewards = RewardUtil.parseRewards(tbReward.items)
				LayerManager.addLayoutNoScale(UIHelper.createRewardDlg(tbRewards))
			end)

		end
	end

	return tbEvent
end



--兑换 
-- goods_id : 物品id
-- fnCallBack : 处理完成后的回调
function buyGoods( goods_id,fnCallBack )

	local function requestFunc( cbFlag, dictData, bRet )
		if(bRet == true)then
			local dataRet = dictData.ret.ret
			if(dataRet == "ok")then
				if fnCallBack then
					fnCallBack()
				end
        	end
		end
	end
	local arg = CCArray:create()
	arg:addObject(CCInteger:create(goods_id))
	RequestCenter.skyPieaBuyGoods(requestFunc, arg)
end

-- 背包刷新后回调
function rfrCallBack(  )
	SkyPieaShopView.loadUI()
	LayerManager.removeLayout()
end
-- 获得神秘商店信息的网络回调函数
function shopInfoCallBack( cbFlag, dictData, bRet )
	UserModel.addGoldNumber(-SkyPieaModel.getRfrGoldNum())
	SkyPieaModel.setShopInfo(dictData.ret)
	SkyPieaShopView.loadUI()
end


--刷新
--_alert : 显示 提示框 花费多少金币
function rfrShopInfo( sender,eventType,_alert)
	if (eventType == TOUCH_EVENT_ENDED) then
		local alert = _alert or false
		logger:debug("alert = %s", alert)
		if (not alert) then
			logger:debug(m_bShowAlert)
			LayerManager.removeLayout()
			m_bShowAlert = true
		end

		-- rfrType : 1 表示道具刷新 2 金币刷新 3 预留 贝里刷新
		local rfrType = 1
		local itemNum = SkyPieaModel.getRfrItemNum()
		if itemNum > 0 then
			rfrType = 1
		else
			rfrType = 2
		end

		-- 金币不足
		if(SkyPieaModel.getRfrGoldNum() > UserModel.getGoldNumber() and rfrType == 2) then
			LayerManager.addLayout(UIHelper.createNoGoldAlertDlg())
			return 
		end

		-- 最大金币刷新次数
		if(SkyPieaModel.isRfrMax() and rfrType == 2) then
			ShowNotice.showShellInfo(m_i18n[5462])
			return 
		end


		local arg = CCArray:create()
		arg:addObject(CCInteger:create(rfrType))
		local function changeBagCallBack( cbFlag, dictData, bRet )
			SkyPieaModel.setShopInfo(dictData.ret)	
			require "script/network/PreRequest"
			PreRequest.setBagDataChangedDelete(rfrCallBack)
		end
		if (rfrType==1) then
			RequestCenter.skyPieaRfrGoodsList(changeBagCallBack, arg)
			LayerManager.addLayoutNoScale(Layout:create())
		else
			RequestCenter.skyPieaRfrGoodsList(shopInfoCallBack,arg)
		end
	end
end

-- 刷新 提示框
function showDlg( )
	local itemNum= SkyPieaModel.getRfrItemNum()
	if(itemNum<=0 and not m_bShowAlert) then

			-- 最大金币刷新次数
		if(SkyPieaModel.isRfrMax()) then
			ShowNotice.showShellInfo(m_i18n[5462])
			return 
		end

		require "script/module/public/UIHelper"
		local strMsg = m_i18nString(5463,SkyPieaModel.getRfrGoldNum())
		local layDlg = UIHelper.createCommonDlg(strMsg, nil, rfrShopInfo)
    	 LayerManager.addLayout(layDlg)
	else 
		rfrShopInfo(nil,TOUCH_EVENT_ENDED,true)
	end
	
end

-- 拉取商店信息回调
local function getShopInfoCallBack(cbFlag, dictData, bRet)
	logger:debug(dictData)
	SkyPieaModel.setShopInfo(dictData.ret)
	createView()
end

function create(fnCallBack)
	init()
	m_bShowAlert = false
	m_fnCallback = fnCallBack
	RequestCenter.skyPieaGetShopInfo(getShopInfoCallBack)
end

function createView(  )
	local tbEvent = getBtnBindingFuctions()
	local view = SkyPieaShopView.create(tbEvent)
	if view then
		LayerManager.changeModule(view, moduleName(), {1}, true)
	end
	
	PlayerPanel.addForSkyPiea()
end
