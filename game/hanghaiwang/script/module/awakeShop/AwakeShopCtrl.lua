-- FileName: AwakeShopCtrl.lua
-- Author: huxiaozhou
-- Date: 2015-11-16
-- Purpose: 觉醒商店控制器
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变  
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /


module("AwakeShopCtrl", package.seeall)

local m_i18n = gi18n
local m_i18nString = gi18nString
local m_bShowAlert = false
local _fnCallBack = nil
local _args = nil
local function init(...)
	m_bShowAlert = false
	_fnCallBack = nil
	_args = nil
end

function destroy(...)
	package.loaded["AwakeShopCtrl"] = nil
end

function moduleName()
    return "AwakeShopCtrl"
end
-- 获得神秘商店信息的网络回调函数
function shopInfoCallBack( cbFlag, dictData, bRet )
	if(dictData.err ~= "ok") then
		return 
	end
	
	logger:debug(dictData.ret)
	AwakeShopModel.setShopInfo(dictData.ret)

	createView()
end

-- 免费刷新，金币刷新回调
function rfrShopInfoCallBack( cbFlag, dictData, bRet )
	if(dictData.err ~= "ok") then
		return 
	end
	logger:debug(dictData.ret)
	AwakeShopModel.setShopInfo(dictData.ret)
	AwakeShopView.updateUI()
end

-- 道具刷新背包推送回调
function rfrCallBack(  )
	AwakeShopView.updateUI()
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
		local rfrNum= AwakeShopModel.getItemNum() -- 拥有道具
		if(rfrNum>0) then
			rfrType =2
		end	
		---  是不是应该 == 3  免费刷新
		local freeTimes = AwakeShopModel.getFreeTimes()
		if (tonumber(freeTimes)>0) then
			rfrType = 3
		end


		if(AwakeShopModel.isRfrMax() and rfrType~=2 and rfrType ~= 3) then --判断是不是达到最大刷新
			ShowNotice.showShellInfo(m_i18nString(2078))
			return 
		end


		if(rfrNum <=0 and UserModel.getGoldNumber()< tonumber(AwakeShopModel.getRfrGoldNum()) and rfrType==1) then
			AudioHelper.playCommonEffect()
	  		local noGoldAlert = UIHelper.createNoGoldAlertDlg()
			LayerManager.addLayout(noGoldAlert)
			return
		end

		if(rfrType== 1) then
			AudioHelper.playBtnEffect("buttonbuy.mp3")
			UserModel.addGoldNumber(-tonumber( AwakeShopModel.getRfrGoldNum()))
		end

		local args = CCArray:create()
		args:addObject(CCInteger:create(rfrType))
		-- 道具刷新
		local function changeBagCallBack( cbFlag, dictData, bRet )
			if dictData.err ~= "ok" then
				LayerManager.removeLayout()
				return
			end
			AwakeShopModel.setShopInfo(dictData.ret)	
			PreRequest.setBagDataChangedDelete(rfrCallBack)
		end

		if (rfrType==2) then
			RequestCenter.awakeCopy_refreshGoodsList(changeBagCallBack,args)
			LayerManager.addLayoutNoScale(Layout:create())
		else
			RequestCenter.awakeCopy_refreshGoodsList(rfrShopInfoCallBack,args)
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
			UserModel.addAwakeRimeNum(-goods.costNum)
		else  -- 金币
			UserModel.addGoldNumber(-goods.costNum)
		end
		AwakeShopModel.changeCanBuyNumByid(goodsId,1)
	
		ShowNotice.showShellInfo(m_i18nString(6931, sender.tItem.name, tData.num))
	
		LayerManager.addLayoutNoScale(Layout:create())

		if sender.tItem.isTreasureFragment then
			GlobalNotify.addObserver(GlobalNotify.TREAS_FRAG_CHANGED, function ( ... )
				AwakeShopView.updateUI()
				LayerManager.removeLayout()
			end, true, GlobalNotify.TREAS_FRAG_CHANGED)
		else
			PreRequest.setBagDataChangedDelete(function ( ... )
				AwakeShopView.updateUI()
				LayerManager.removeLayout()
			end)
		end

		
	end

	 -- 如果有item_template_id检测此类物品所属背包满, 
	if (goods.tid and ItemUtil.bagIsFullWithTid(goods.tid, true)) then
		return
	end

	--花费 1：花费类型为结晶 , 2：花费类型为金币
	if(goods.costType == 1 and UserModel.getAwakeRimeNum() < goods.costNum ) then
		ShowNotice.showShellInfo(m_i18n[7418])
		return
	end
	if(goods.costType == 2 and UserModel.getGoldNumber() < goods.costNum ) then
		local noGoldAlert = UIHelper.createNoGoldAlertDlg()
		LayerManager.addLayout(noGoldAlert)
		return
	end

	local args = CCArray:create()
	args:addObject(CCInteger:create(goodsId))
	RequestCenter.awakeCopy_buyGoods(buyCallBack,args)
end


function showDlg()
	local rfrNum= AwakeShopModel.getItemNum()
	local freeTimes = AwakeShopModel.getFreeTimes()

	if(AwakeShopModel.isRfrMax() and tonumber(freeTimes)<=0) then --判断是不是达到最大刷新
		ShowNotice.showShellInfo(m_i18nString(2078))
		return 
	end

	if(rfrNum<=0 and not m_bShowAlert and tonumber(freeTimes) == 0) then
		local strMsg = m_i18nString(1924,AwakeShopModel.getRfrGoldNum())
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
			-- 觉醒结晶
			AudioHelper.playCommonEffect()
			PublicInfoCtrl.createItemDropInfoViewByTid(60032,nil,true)  -- 不足引导界面
		end
	end

	-- 按钮 兑换按钮
	tbBtnEvent.onBuy = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("tbBtnEvent.onBuy")
			AudioHelper.playCommonEffect()

			if sender.tData.canBuyNum <= 0 then
				ShowNotice.showShellInfo(m_i18n[2077])
				return
			end

			if sender.tData.costType == 2 and UserModel.getGoldNumber() > sender.tData.costNum then
				TreaAlert.create(sender.tData,function ( senderConfirm, eventType )
					if (eventType == TOUCH_EVENT_ENDED) then
						AudioHelper.playBtnEffect("buttonbuy.mp3")
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
			AudioHelper.playCommonEffect()
		end
	end

	if _fnCallBack  and type(_fnCallBack) == "function" then
		tbBtnEvent.onBack = _fnCallBack
	end 
	local view = AwakeShopView.create(tbBtnEvent)
	LayerManager.changeModule( view, moduleName(), {1, 3}, true, _args)
	PlayerPanel.addForPartnerStrength()
end



function create(fnCallBack, args)
	init()
	_fnCallBack = fnCallBack
	_args = args
	RequestCenter.awakeCopy_getShopInfo(shopInfoCallBack)
end
