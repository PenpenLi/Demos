-- FileName: MysteryCastleCtrl.lua
-- Author: huxiaozhou
-- Date: 2014-05-19
-- Purpose: 神秘商店 控制模块
--[[TODO List]]

module("MysteryCastleCtrl", package.seeall)
require "script/module/wonderfulActivity/mysteryCastle/MysteryCastleView"
require "script/module/wonderfulActivity/mysteryCastle/MysteryCastleData"
require "script/module/treaShop/TreaAlert"
require "script/module/treaShop/TreaFlagAlert"

-- UI控件引用变量 --

-- 模块局部变量 --
local  m_bShowAlert
local m_i18n = gi18n
local m_i18nString = gi18nString

local _fnCallBack = nil
local _args = nil

local function init(...)
	m_bShowAlert = false
	_fnCallBack = nil
	_args = nil
end

function destroy(...)
	package.loaded["MysteryCastleCtrl"] = nil
end

function moduleName()
    return "MysteryCastleCtrl"
end


-- 获得神秘商店信息的网络回调函数
function shopInfoCallBack( cbFlag, dictData, bRet )
	if(dictData.err ~= "ok") then
		return 
	end
	
	logger:debug(dictData.ret)

	MysteryCastleData.setShopInfo(dictData.ret)	
	createView()
end

function rfrCallBack(  )
	MysteryCastleView.updateUI()	
	LayerManager.removeLayout()
end

function create(fnCallBack, args)
	m_bShowAlert = false
	_fnCallBack = fnCallBack
	_args = args
	RequestCenter.mysteryShop_getShopInfo(shopInfoCallBack)
end



function onRfr( sender,eventType,_alert)
	if (eventType == TOUCH_EVENT_ENDED) then
		local alert = _alert or false
		if (not alert) then
			logger:debug(m_bShowAlert)
			LayerManager.removeLayout()
			m_bShowAlert = true
		end
		local rfrType = 1
		local rfrNum= MysteryCastleData.getItemNum()
		if(rfrNum>0) then
			rfrType =2
		end	
		--- 添加处理 是不是应该 == 3 
		local freeTimes = MysteryCastleData.getFreeTimes()
		if (tonumber(freeTimes)>0) then
			rfrType = 3
		end

		logger:debug("MysteryCastleData.isRfrMax() = %s", MysteryCastleData.isRfrMax())
		if(MysteryCastleData.isRfrMax() and rfrType ~= 3) then
			ShowNotice.showShellInfo(m_i18nString(2078))
			return 
		end


		if(rfrNum <=0 and UserModel.getGoldNumber()< tonumber(MysteryCastleData.getRfrGoldNum()) and rfrType==1) then
	  		local noGoldAlert = UIHelper.createNoGoldAlertDlg()
			LayerManager.addLayout(noGoldAlert)
			return
		end

		if(rfrType== 1) then
			UserModel.addGoldNumber(-tonumber( MysteryCastleData.getRfrGoldNum()))
		end

		local args = CCArray:create()
		args:addObject(CCInteger:create(rfrType))
		local function changeBagCallBack( cbFlag, dictData, bRet )
			if dictData.err ~= "ok" then
				LayerManager.removeLayout()
				return
			end
			MysteryCastleData.setShopInfo(dictData.ret)	
			require "script/network/PreRequest"
			PreRequest.setBagDataChangedDelete(rfrCallBack)
		end
		if (rfrType==2) then
			TimeUtil.timeStart("rfrReqItem")
			RequestCenter.mysteryShop_playerRfrGoodsList(changeBagCallBack,args)
			LayerManager.addLayoutNoScale(Layout:create())
		else
			-- 获得神秘商店信息的网络回调函数
			function rfrShopInfoCallBack( cbFlag, dictData, bRet )
				if(dictData.err ~= "ok") then
					return 
				end
				MysteryCastleData.setShopInfo(dictData.ret)
				TimeUtil.timeEnd("rfrReq")
				MysteryCastleView.updateUI()
				TimeUtil.timeEnd("onRfr")	
			end
			TimeUtil.timeStart("rfrReq")
			RequestCenter.mysteryShop_playerRfrGoodsList(rfrShopInfoCallBack,args)
		end
	end
end

function showDlg( )
	local rfrNum= MysteryCastleData.getItemNum()
	local freeTimes = MysteryCastleData.getFreeTimes()
	logger:debug(rfrNum)
	logger:debug(m_bShowAlert)

	if(MysteryCastleData.isRfrMax() and tonumber(freeTimes) <=0) then
		ShowNotice.showShellInfo(m_i18nString(2078))
		return 
	end

	if(rfrNum<=0 and not m_bShowAlert and tonumber(freeTimes) == 0) then
		require "script/module/public/UIHelper"
		local strMsg = m_i18nString(1924,MysteryCastleData.getRfrGoldNum())
		local layDlg = UIHelper.createCommonDlg(strMsg, nil, onRfr)
    	 LayerManager.addLayout(layDlg)
	else 
		onRfr(nil,TOUCH_EVENT_ENDED,true)
	end
	
end

--- 进行兑换
function onBuy( Id )
	
	local goodsList = MysteryCastleData.getGoodsListData()
	local goods = goodsList[Id]
	local goodsId = goods.id
	local tItem = ItemUtil.getItemById(goods.tid)
	 --兑换回调
	local function buyCallBack( cbFlag, dictData, bRet )
		if(dictData.err ~= "ok") then
			return 
		end
		if (goods.costType==1) then --  海魂
			UserModel.addJewelNum(-goods.costNum)
		else  -- 金币
			UserModel.addGoldNumber(-goods.costNum)
		end
		MysteryCastleData.changeCanBuyNumByid(goodsId,1)
		
		LayerManager.addLayoutNoScale(Layout:create())


		if tItem.isTreasureFragment then
			GlobalNotify.addObserver(GlobalNotify.TREAS_FRAG_CHANGED, function ( )
				LayerManager.removeLayout()
				MysteryCastleView.updateUI()
				performWithDelayFrame(nil, function (  )
					ShowNotice.showShellInfo(m_i18nString(6931, tItem.name, goods.num))
				end, 1)
			end, true, GlobalNotify.TREAS_FRAG_CHANGED)
		else
			PreRequest.setBagDataChangedDelete(function (  )
				LayerManager.removeLayout()
				MysteryCastleView.updateUI()

				performWithDelayFrame(nil, function (  )
					ShowNotice.showShellInfo(m_i18nString(6931, tItem.name, goods.num))
				end, 1)

			end)
		end

	

		
	end

	 -- 如果有item_template_id检测此类物品所属背包满, 2014-07-22, zhangqi。武魂背包没有上线，不做检测
	if (goods.tid and ItemUtil.bagIsFullWithTid(goods.tid, true)) then
		AudioHelper.playCommonEffect()
		return
	end

	--花费 1：花费类型为魂玉 , 2：花费类型为金币
	if(goods.costType == 1 and UserModel.getJewelNum() < goods.costNum ) then
		AudioHelper.playCommonEffect()
		ShowNotice.showShellInfo(m_i18nString(2074))
		 -- 海魂不足，请前往分解屋分解影子
		return
	end
	if(goods.costType == 2 and UserModel.getGoldNumber() < goods.costNum ) then
		AudioHelper.playCommonEffect()
		local noGoldAlert = UIHelper.createNoGoldAlertDlg()
		LayerManager.addLayout(noGoldAlert)
		return
	end

	
	local function buyReq( ... )
		AudioHelper.playBtnEffect("buttonbuy.mp3")
		local args = CCArray:create()
		args:addObject(CCInteger:create(goodsId))
		RequestCenter.mysteryShop_buyGoods(buyCallBack,args)
	end
	if goods.costType == 2 and not tItem.isHeroFragment then
		AudioHelper.playCommonEffect()
		TreaAlert.create(goods,function ( sender, eventType )
					if (eventType == TOUCH_EVENT_ENDED) then
						LayerManager.removeLayout()
						buyReq()
					end
				end)
	elseif goods.costType == 2 and tItem.isHeroFragment then
		AudioHelper.playCommonEffect()
		TreaFlagAlert.create(goods,function ( sender, eventType )
					if (eventType == TOUCH_EVENT_ENDED) then
						LayerManager.removeLayout()
						buyReq()
					end
				end)
	else
		buyReq()
	end

end


function createView( )
	local tbBtnEvent = {}
	-- 按钮 去分解按钮
	tbBtnEvent.onResolve = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("tbBtnEvent.onResolve")
			AudioHelper.playCommonEffect()
				
			    if (SwitchModel.getSwitchOpenState( ksSwitchResolve,true)) then
			        require "script/module/resolve/MainRecoveryCtrl"
			        local layResolve = MainRecoveryCtrl.create(ResolveTabType.E_Parnter)
			        if (layResolve) then
			            LayerManager.changeModule(layResolve, MainRecoveryCtrl.moduleName(), {1,3}, true)
			            PlayerPanel.addForPublic()
			        end
			    end
		end
	end

	-- 按钮 兑换按钮
	tbBtnEvent.onBuy = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("tbBtnEvent.onBuy")
			onBuy(sender:getTag())
		end
	end

	-- 按钮 刷新
	tbBtnEvent.onRfr = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("tbBtnEvent.onRfr")
			AudioHelper.playCommonEffect()
			TimeUtil.timeStart("onRfr")
			showDlg()

		end
	end


	if _fnCallBack  and type(_fnCallBack) == "function" then
		tbBtnEvent.onBack = _fnCallBack
	end 

	local mystertCastleLay = MysteryCastleView.create(tbBtnEvent)

	LayerManager.changeModule( mystertCastleLay, moduleName(), {1, 3}, true, _args)
	PlayerPanel.addForPartnerStrength()
end
