-- FileName: WABetTip.lua
-- Author: 
-- Date: 2015-03-00
-- Purpose: 押注确定弹窗
--[[TODO List]]

WABetTip = class("WABetTip")

-- UI控件引用变量 --

-- 模块局部变量 --

local _i18n = gi18n
local _i18nString 	= gi18nString
local _fnGetWidget = g_fnGetWidgetByName
local _gColor = g_QulityColor

local _bellyMaxLimit = nil
local _goldMaxLimit = nil


function WABetTip:addBtnEvent( ... )
	self.layMain.BTN_CLOSE:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCloseEffect()
			LayerManager.removeLayout()
		end
	end)

	self.layMain.BTN_BUY_CANCEL:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCloseEffect()
			LayerManager.removeLayout()
		end
	end)

	local fnAddNum1 = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			self:addNum(1)
		end
	end

	local fnAddNum10 = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			self:addNum(10)
		end
	end	

	local fnReduceNum1 = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			self:addNum(-1)
		end
	end

	local fnReduceNum10 = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			self:addNum(-10)
		end
	end	

	self.layMain.BTN_ADD:addTouchEventListener(fnAddNum1)

	self.layMain.BTN_ADD_TEN:addTouchEventListener(fnAddNum10)

	self.layMain.BTN_MINUS:addTouchEventListener(fnReduceNum1)

	self.layMain.BTN_MINUS_TEN:addTouchEventListener(fnReduceNum10)

	self.layMain.BTN_ADD_WAN:addTouchEventListener(fnAddNum1)

	self.layMain.BTN_ADD_TEN_WAN:addTouchEventListener(fnAddNum10)

	self.layMain.BTN_MINUS_WAN:addTouchEventListener(fnReduceNum1)

	self.layMain.BTN_MINUS_TEN_WAN:addTouchEventListener(fnReduceNum10)	

	self.layMain.BTN_BUY_SURE:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug({
				table_bet_args = self.tbData
			})
			local betCallback = function ( ... )
				logger:debug("betSuccess")
				if (self.tbData.type == "1") then -- silver
					UserModel.addSilverNumber(-tonumber(self.tbData.num))
				else
					UserModel.addGoldNumber(-tonumber(self.tbData.num))
				end
				WABetCtrl.updateBetData(self.tbData)
				WABetModel.addPreBetInfo(self.tbData)
				LayerManager.removeLayout()
				ShowNotice.showShellInfo("押注成功，请期待最终结果。")
			end
			if (tonumber(self.tbData.num)>0) then
				AudioHelper.playBuyGoods()
				local nState = WAUtil.getCurState()
				if (nState == WAUtil.WA_STATE.attack) then
					if (self.tbData.type == "1") then -- silver
						self.tbData.num = tonumber(self.tbData.num)*10000
						WAService.bet(self.tbData.serverId, self.tbData.pid, self.tbData.rankType, 
							self.tbData.type, self.tbData.num, betCallback)
					else
						WAService.bet(self.tbData.serverId, self.tbData.pid, self.tbData.rankType, 
							self.tbData.type, self.tbData.num, betCallback)
					end
				end
			else
				AudioHelper.playCommonEffect()
				ShowNotice.showShellInfo("请增加押注金额")
			end
		end
	end)
	
end


function WABetTip:refreshNum( ... )
	if (self.tbData.type == "1") then
		self.layMain.TFD_PLAYER_BUY_NUM:setText(self.tbData.num.."万")
	else
		self.layMain.TFD_PLAYER_BUY_NUM:setText(self.tbData.num)
	end
end

function WABetTip:refreshView( ... )
	self:refreshNum()
	self.layMain.lay_price_num:setVisible(true)
	self.layMain.LAY_GOLD_BTN:setVisible(self.tbData.type == "2")
	self.layMain.LAY_GOLD_BTN:setTouchEnabled(self.tbData.type == "2")
	self.layMain.LAY_BELLY_BTN:setVisible(self.tbData.type == "1")
	self.layMain.LAY_BELLY_BTN:setTouchEnabled(self.tbData.type == "1")
	self.layMain.img_gold:setVisible(self.tbData.type == "2")
	self.layMain.img_silver:setVisible(self.tbData.type == "1")
	if (self.tbData.type == "1") then
		self.layMain.LAY_BELLY_BTN:setZOrder(999)
		self.layMain.LAY_GOLD_BTN:setZOrder(0)
		if (_bellyMaxLimit) then
			self.layMain.TFD_PRICE_NUM:setText(tostring(tonumber(_bellyMaxLimit)/10000).."万")
		else
			self.layMain.lay_price_num:setVisible(false)
		end
	else
		self.layMain.LAY_BELLY_BTN:setZOrder(0)
		self.layMain.LAY_GOLD_BTN:setZOrder(999)
		if (_goldMaxLimit) then
			self.layMain.TFD_PRICE_NUM:setText(_goldMaxLimit)
		else
			self.layMain.lay_price_num:setVisible(false)
		end
	end
end

function WABetTip:addNum( addNum )
	self.tbData.num = tonumber(self.tbData.num) + tonumber(addNum)

	if (self.tbData.num < 0) then
		self.tbData.num	= 0
	end

	if (self.tbData.type == "1") then			-- 用贝里
		if ((_bellyMaxLimit) and ( self.tbData.num > (tonumber(_bellyMaxLimit)/10000) )) then
			self.tbData.num = tonumber(_bellyMaxLimit)/10000
		end
		local userBellyNum = UserModel.getSilverNumber()
		local userBellyTenThou = math.floor(userBellyNum/10000) -- 贝里以万为单位下取整
		if (self.tbData.num>userBellyTenThou) then
			ShowNotice.showShellInfo(_i18n[8130])
			self.tbData.num = userBellyTenThou
		end
	else										-- 用金币
		if ((_goldMaxLimit) and (self.tbData.num>tonumber(_goldMaxLimit))) then
			self.tbData.num = tonumber(_goldMaxLimit)
		end
		if (self.tbData.num>UserModel.getGoldNumber()) then
			ShowNotice.showShellInfo(_i18n[8129])
			self.tbData.num = UserModel.getGoldNumber()
		end
	end

	self:refreshNum()
end

function WABetTip:init(...)
	self.layMain = nil
	self.tbData = nil
	GlobalNotify.addObserver("WABetView_SET_BUTTON_FALSE", function ( ... )
		LayerManager.removeLayout()
	end, true, "WABETTIP")
end

function WABetTip:destroy(...)
	package.loaded["WABetTip"] = nil
end

function WABetTip:moduleName()
    return "WABetTip"
end

function WABetTip:ctor( ... )
	self:init()
	self.layMain = g_fnLoadUI("ui/bet_number.json")
end

function WABetTip:create( tbArgs )
	logger:debug("enter_bet_num_view")
	logger:debug({tbArgs_WABetTip = tbArgs})
	self.tbData = tbArgs

	local configData = WorldArenaModel.getworldArenaConfig()
	_bellyMaxLimit = configData.silver_limit
	_goldMaxLimit = configData.gold_limit

	UIHelper.titleShadow( self.layMain.BTN_BUY_CANCEL )
	UIHelper.titleShadow( self.layMain.BTN_BUY_SURE )

	self:refreshView()
	self:addBtnEvent()

	UIHelper.registExitAndEnterCall(self.layMain,
		function()
			logger:debug("test_exit_BetTip")
			GlobalNotify.removeObserver("WABetView_SET_BUTTON_FALSE", "WABETTIP")
			self.layMain = nil
		end,
		function()
			logger:debug("test_enter_BetTip")
			GlobalNotify.addObserver("WABetView_SET_BUTTON_FALSE", function ( ... )
				LayerManager.removeLayout()
			end, true, "WABETTIP")
		end
	)
	return self.layMain	
end
