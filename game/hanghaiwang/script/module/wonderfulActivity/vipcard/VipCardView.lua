-- FileName: VipCardView.lua
-- Author: LvNanchun
-- Date: 2015-07-01
-- Purpose: 月卡功能界面
--[[TODO List]]

VipCardView = class("VipCardView")
--module("VipCardView", package.seeall)
require "script/module/wonderfulActivity/vipcard/VipCardModel"
require "script/model/user/UserModel"

-- UI控件引用变量 --
local _layMain

-- 模块局部变量 --
local _i18n = gi18n
local _scheduleRefreshView = nil

function destroy(...)
	package.loaded["VipCardView"] = nil
	if (_scheduleRefreshView) then 
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(_scheduleRefreshView)
		_scheduleRefreshView = nil
	end
end

function moduleName()
    return "VipCardView"
end

function VipCardView:ctor()
	self.layMain = g_fnLoadUI("ui/activity_vip_card.json")
end

--[[desc:刷新月卡界面,目前看起来没有人用
    arg1: 无
    return: 无
—]]
function VipCardView:reloadView()
	local nRemainDays = VipCardModel.getRemainDays()
	local btnGet = _layMain.BTN_GET
	local btnBuy = _layMain.BTN_MAIN
	local tfdRemainTime = _layMain.TFD_REMAIN_TIME
	tfdRemainTime:setText(_i18n[5703] .. tostring(nRemainDays) .. _i18n[1937])
	UIHelper.labelNewStroke(tfdRemainTime)
	btnGet:setTouchEnabled(true)
	btnGet:setVisible(true)
	btnBuy:setVisible(false)
	btnBuy:setTouchEnabled(false)
	tfdRemainTime:setVisible(true)
	local nRedPoint = VipCardModel.getRedPoint()
	local mainActivity = WonderfulActModel.tbBtnActList.vipcard
	mainActivity:setVisible(true)
	mainActivity.LABN_TIP_EAT:setStringValue(nRedPoint + 1)

	if not (nRedPoint > 0) then
		mainActivity.IMG_TIP:setEnabled(false)
	end
end

function VipCardView:create()
	_layMain = self.layMain

	logger:debug(VipCardModel.getTbOfPrizeById(1))
	local nPrizeNum = VipCardModel.getTbOfPrizeById(1)[3]
	local nRemainDays = VipCardModel.getRemainDays()

	local tfdRemainTime = _layMain.TFD_REMAIN_TIME
	local imgGet = _layMain.IMG_ALREADY_GET
	local tfdGet = imgGet.TFD_ALREADY_GET
	local btnGet = _layMain.BTN_GET
	local btnBuy = _layMain.BTN_MAIN
	local imgBg = _layMain.img_bg

	_layMain.BTN_RECHARGE:addTouchEventListener(function (sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			require "script/module/IAP/IAPCtrl"
			LayerManager.addLayout(IAPCtrl.create())
		end 
	end)

	imgBg:setScaleX(g_fScaleX)
	imgBg:setScaleY(g_fScaleY)
	UIHelper.titleShadow(btnGet , _i18n[4342])
	UIHelper.labelShadowWithText(tfdGet , _i18n[4372] , CCSizeMake(1, -2))
	UIHelper.labelNewStroke(tfdRemainTime)

	local function viewUpdate()
		if (VipCardModel.bGetOrNotToday()) then
			btnGet:setVisible(true)
			btnGet:setTouchEnabled(true)
			imgGet:setVisible(false)
			if (_scheduleRefreshView) then
				CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(_scheduleRefreshView)
				_scheduleRefreshView = nil
			end
			local nRedPoint = VipCardModel.getRedPoint()
			local mainActivity = WonderfulActModel.tbBtnActList.vipcard
			mainActivity:setVisible(true)
			mainActivity.LABN_TIP_EAT:setStringValue(nRedPoint + 1)
		
			if not (nRedPoint > 0) then
				mainActivity.IMG_TIP:setEnabled(false)
			end
		end
	end

	--typeOfBtn的值为0表示领取按钮，1表示图片，2表示购买按钮
	if (VipCardModel.bBuyOrNot()) then
		if (VipCardModel.bGetOrNotToday()) then 
			typeOfBtn = 0
		else
			typeOfBtn = 1
		end
		tfdRemainTime:setText(_i18n[5703] .. tostring(nRemainDays) .. _i18n[1937])      
	else
		typeOfBtn = 2
		tfdRemainTime:setVisible(false)
	end

	local function btnBuyCallBack( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playBtnEffect("buttonbuy.mp3")
			require "script/module/IAP/IAPCtrl"
			LayerManager.addLayout(IAPCtrl.create())
		end
	end

	local function btnGetCallBack( sender , eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			local function getRewardCallBack( cbFlag, dictData, bRet )
				if (bRet) then
					logger:debug({dictData = dictData.ret})
					if (dictData.ret == "ok") then 
						btnGet:setVisible(false)
						btnGet:setTouchEnabled(false)
						imgGet:setVisible(true)
						
						local layReward = UIHelper.createGetRewardInfoDlg(_i18n[3739],{{icon = ItemUtil.getGoldIconByNum(nPrizeNum), name = _i18n[2220], quality = 5}})			
						LayerManager.addLayout(layReward)
						UserModel.addGoldNumber(nPrizeNum)

						if (VipCardModel.bBuyOrNot()) then
							_scheduleRefreshView = UIHelper.getAutoReleaseScheduler(_layMain , viewUpdate , 1)
						end
		
						VipCardModel.setRedPoint(VipCardModel.getRedPoint() - 1)
		
						local nRedPoint = VipCardModel.getRedPoint()
						logger:debug({nRedPoint = nRedPoint})

						local mainActivity = WonderfulActModel.tbBtnActList.vipcard
						mainActivity:setVisible(true)
						mainActivity.LABN_TIP_EAT:setStringValue(nRedPoint)
					
						if not (nRedPoint > 0) then
							mainActivity.IMG_TIP:setEnabled(false)
						end

						VipCardModel.changeLastBuyTime()

						tfdRemainTime:setText(_i18n[5703] .. tostring(nRemainDays - 1) .. _i18n[1937])  
					end
				end
			end

			RequestCenter.vipCard_getReward(getRewardCallBack)  
		end
	end

	btnBuy:addTouchEventListener(btnBuyCallBack)
	btnGet:addTouchEventListener(btnGetCallBack)

	VipCardModel.setRedPoint()
	local nRedPoint = VipCardModel.getRedPoint()
	local mainActivity = WonderfulActModel.tbBtnActList.vipcard
	mainActivity:setVisible(true)
	mainActivity.LABN_TIP_EAT:setStringValue(nRedPoint)

	logger:debug({nRedPoint = nRedPoint})
	
	if not (nRedPoint > 0) then
		mainActivity.IMG_TIP:setEnabled(false)
	else 
		mainActivity.IMG_TIP:setEnabled(true)
	end

	if (typeOfBtn == 0) then
		imgGet:setVisible(false)
		btnGet:setVisible(true)
		btnGet:setTouchEnabled(true)
		btnBuy:setVisible(false)
		btnBuy:setTouchEnabled(false)
	elseif (typeOfBtn == 2) then 
		imgGet:setVisible(false)
		btnGet:setVisible(false)
		btnGet:setTouchEnabled(false)
		btnBuy:setVisible(true)
		btnBuy:setTouchEnabled(true)
	elseif (typeOfBtn == 1) then
		imgGet:setVisible(true)
		btnGet:setVisible(false)
		btnGet:setTouchEnabled(false)
		btnBuy:setVisible(false)
		btnBuy:setTouchEnabled(false)
		_scheduleRefreshView = UIHelper.getAutoReleaseScheduler(_layMain , viewUpdate , 1)
	end

	return _layMain
end
