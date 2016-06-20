-- FileName: TreaShopCtrl.lua
-- Author: huxiaozhou
-- Date: 2015-01-08
-- Purpose: 宝物商店控制
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变  
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /


module("TreaShopCtrl", package.seeall)
require "script/module/treaShop/TreaShopData"
require "script/module/treaShop/TreaShopView"
require "script/module/treaShop/TreaAlert"
require "script/module/treaShop/TreaFlagAlert"

local m_i18n = gi18n
local m_i18nString = gi18nString
local m_bShowAlert = false
local _copyId = 0
local _fnCallBack = nil
local _args = nil
local function init(...)
	m_bShowAlert = false
	_fnCallBack = nil
	_args = nil
end

function destroy(...)
	package.loaded["TreaShopCtrl"] = nil
end

function moduleName()
    return "TreaShopCtrl"
end
-- 获得神秘商店信息的网络回调函数
function shopInfoCallBack( cbFlag, dictData, bRet )
	if(dictData.err ~= "ok") then
		return 
	end
	
	logger:debug(dictData.ret)
	TreaShopData.setShopInfo(dictData.ret)

	createView()
end

function rfrShopInfoCallBack( cbFlag, dictData, bRet )
	if(dictData.err ~= "ok") then
		return 
	end
	logger:debug(dictData.ret)
	TreaShopData.setShopInfo(dictData.ret)
	TreaShopView.updateUI()
end

function rfrCallBack(  )
	TreaShopView.updateUI()
	LayerManager.removeLayout()
end




-- 金币刷新 1 
-- 物品刷新 2
-- 系统免费刷新  3

function onRfrGoods( sender,eventType,_alert)
	if (eventType == TOUCH_EVENT_ENDED) then

		local alert = _alert or false
		if (not alert) then
			logger:debug(m_bShowAlert)
			LayerManager.removeLayout()
			m_bShowAlert = true
		end

		local rfrType = 1
		local rfrNum= TreaShopData.getItemNum() -- 拥有道具
		if(rfrNum>0) then
			rfrType =2
		end	
		---  是不是应该 == 3  免费刷新
		local freeTimes = TreaShopData.getFreeTimes()
		if (tonumber(freeTimes)>0) then
			rfrType = 3
		end


		if(TreaShopData.isRfrMax() and rfrType~=2 and rfrType ~= 3) then --判断是不是达到最大刷新
			ShowNotice.showShellInfo(m_i18nString(2078))
			return 
		end


		if(rfrNum <=0 and UserModel.getGoldNumber()< tonumber(TreaShopData.getRfrGoldNum()) and rfrType==1) then
	  		local noGoldAlert = UIHelper.createNoGoldAlertDlg()
			LayerManager.addLayout(noGoldAlert)
			return
		end

		if(rfrType== 1) then
			UserModel.addGoldNumber(-tonumber( TreaShopData.getRfrGoldNum()))
		end

		local args = CCArray:create()
		args:addObject(CCInteger:create(rfrType))
		local function changeBagCallBack( cbFlag, dictData, bRet )
			if dictData.err ~= "ok" then
				LayerManager.removeLayout()
				return
			end
			TreaShopData.setShopInfo(dictData.ret)	
			PreRequest.setBagDataChangedDelete(rfrCallBack)
		end
		if (rfrType==2) then
			RequestCenter.treasureShop_playerRfrGoodsList(changeBagCallBack,args)
			LayerManager.addLayoutNoScale(Layout:create())
		else
			RequestCenter.treasureShop_playerRfrGoodsList(rfrShopInfoCallBack,args)
		end
	end
end
--- 进行兑换
function onBuy( sender )
logger:debug({sendertData = sender.tData})
	local tData = sender.tData
	local goods = tData
	if not goods then
		return
	end
	local goodsId = goods.id
	
	 --兑换回调
	local function buyCallBack( cbFlag, dictData, bRet )
		if(dictData.err ~= "ok") then
			return 
		end
		if (goods.costType==1) then --
			UserModel.addRimeNum(-goods.costNum)
		else  -- 金币
			UserModel.addGoldNumber(-goods.costNum)
		end
		TreaShopData.changeCanBuyNumByid(goodsId,1)
	
		ShowNotice.showShellInfo(m_i18nString(6931, sender.tItem.name, tData.num))
	
		LayerManager.addLayoutNoScale(Layout:create())

		if sender.tItem.isTreasureFragment then
			GlobalNotify.addObserver(GlobalNotify.TREAS_FRAG_CHANGED, function ( ... )
				TreaShopView.updateUI()
				LayerManager.removeLayout()
			end, true, GlobalNotify.TREAS_FRAG_CHANGED)
		else
			PreRequest.setBagDataChangedDelete(function ( ... )
				TreaShopView.updateUI()
				LayerManager.removeLayout()
			end)
		end

		
	end

	 -- 如果有item_template_id检测此类物品所属背包满, 2014-07-22, zhangqi。武魂背包没有上线，不做检测
	if (goods.tid and ItemUtil.bagIsFullWithTid(goods.tid, true)) then
		return
	end

	--花费 1：花费类型为结晶 , 2：花费类型为金币
	if(goods.costType == 1 and UserModel.getRimeNum() < goods.costNum ) then
		AudioHelper.playCommonEffect()
		ShowNotice.showShellInfo(m_i18n[6924])
		return
	end
	if(goods.costType == 2 and UserModel.getGoldNumber() < goods.costNum ) then
		AudioHelper.playCommonEffect()
		local noGoldAlert = UIHelper.createNoGoldAlertDlg()
		LayerManager.addLayout(noGoldAlert)
		return
	end

	AudioHelper.playBtnEffect("buttonbuy.mp3")
	local args = CCArray:create()
	args:addObject(CCInteger:create(goodsId))
	RequestCenter.treasureShop_buyGoods(buyCallBack,args)
end


function showDlg()
	local rfrNum= TreaShopData.getItemNum()
	local freeTimes = TreaShopData.getFreeTimes()

	if(TreaShopData.isRfrMax() and tonumber(freeTimes)<=0) then --判断是不是达到最大刷新
		ShowNotice.showShellInfo(m_i18nString(2078))
		return 
	end



	if(rfrNum<=0 and not m_bShowAlert and tonumber(freeTimes) == 0) then
		local strMsg = m_i18nString(1924,TreaShopData.getRfrGoldNum())
		local layDlg = UIHelper.createCommonDlg(strMsg, nil, onRfrGoods)
    	 LayerManager.addLayout(layDlg)
	else 
		onRfrGoods(nil,TOUCH_EVENT_ENDED,true)
	end
	
end


function createView( ... )

	local tbBtnEvent = {}
	-- 按钮 
	tbBtnEvent.onGet = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			-- 云鹏 往这里加获取途径
			PublicInfoCtrl.createItemDropInfoViewByTid(60030)  -- 宝物精华不足引导界面
		end
	end

	-- 按钮 兑换按钮
	tbBtnEvent.onBuy = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("tbBtnEvent.onBuy")

			if sender.tData.canBuyNum <= 0 then
				ShowNotice.showShellInfo(m_i18n[2077])
				return
			end

			if sender.tItem.isSpeTreasureFragment and sender.tData.costType == 2 and UserModel.getGoldNumber() > sender.tData.costNum then
				AudioHelper.playCommonEffect()
				TreaFlagAlert.create(sender.tData,function ( senderConfirm, eventType )
					if (eventType == TOUCH_EVENT_ENDED) then
						LayerManager.removeLayout()
						logger:debug({senderUsertData = sender.tData})
						onBuy(sender)
					end
				end, 1)
			elseif sender.tItem.isSpeTreasure and sender.tData.costType == 2 and UserModel.getGoldNumber() > sender.tData.costNum then
				AudioHelper.playCommonEffect()
				TreaAlert.create(sender.tData,function ( senderConfirm, eventType )
					if (eventType == TOUCH_EVENT_ENDED) then
						LayerManager.removeLayout()
						logger:debug({senderUsertData = sender.tData})
						onBuy(sender)
					end
				end)
			elseif sender.tData.costType == 2 and UserModel.getGoldNumber() > sender.tData.costNum then
				AudioHelper.playCommonEffect()
				TreaAlert.create(sender.tData,function ( senderConfirm, eventType )
					if (eventType == TOUCH_EVENT_ENDED) then
						LayerManager.removeLayout()
						logger:debug({senderUsertData = sender.tData})
						onBuy(sender)
					end
				end)
			else
				onBuy(sender)
			end
		end
	end

	-- 按钮 刷新
	tbBtnEvent.onRfr = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("tbBtnEvent.onRfr")
			AudioHelper.playCommonEffect()
			showDlg()
		end
	end

	-- 按钮 返回
	tbBtnEvent.onBack = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("tbBtnEvent.onBack")
			AudioHelper.playBackEffect()
			local explorMain = ExplorMainCtrl.create(_copyId)
			LayerManager.changeModule(explorMain, ExplorMainCtrl.moduleName(), {1,3}, true)
			PlayerPanel.addForExplorNew()

		end
	end

	if _fnCallBack  and type(_fnCallBack) == "function" then
		tbBtnEvent.onBack = _fnCallBack
	end 
	local view = TreaShopView.create(tbBtnEvent)
	LayerManager.changeModule( view, moduleName(), {1, 3}, true, _args)
	PlayerPanel.addForPartnerStrength()
end



function create( nCopyId, fnCallBack, args)
	init()
	_copyId = nCopyId
	_fnCallBack = fnCallBack
	_args = args
	RequestCenter.treasureShop_getShopInfo(shopInfoCallBack)
end

