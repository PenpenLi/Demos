-- FileName: WABatchBuyAtkTimes.lua
-- Author: huxiaozhou
-- Date: 2015-02-25
-- Purpose: 巅峰对决购买挑战次数
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变  
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /


-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString 	= gi18nString
local m_fnGetWidget = g_fnGetWidgetByName
local m_gColor = g_QulityColor

WABatchBuyAtkTimes = class("WABatchBuyAtkTimes")

function WABatchBuyAtkTimes:ctor()
	self.layMain = g_fnLoadUI("ui/buy_times.json")
end

function WABatchBuyAtkTimes:create(tbData)
	logger:debug("WABatchBuyAtkTimes")
	logger:debug({tbData = tbData})
	self.data = tbData
	local layRoot = self.layMain

	self.nBuyNum = 1
	self.labBuyNum = m_fnGetWidget(layRoot, "TFD_PLAYER_BUY_NUM")
	self.labBuyNum:setText(self.nBuyNum)
	-- X
	self.btnClose = m_fnGetWidget(layRoot,"BTN_CLOSE")
	self.btnClose:addTouchEventListener(UIHelper.onClose)
	--取消按钮
	self.btnCancel = m_fnGetWidget(layRoot,"BTN_BUY_CANCEL")
	self.btnCancel:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCloseEffect()
			LayerManager.removeLayout()
		end
	end)
	UIHelper.titleShadow(self.btnCancel,m_i18n[1625])
	--确定按钮
	self.btnSure = m_fnGetWidget(layRoot,"BTN_BUY_SURE")
	self.btnSure:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			tbData.onSure(self.nBuyNum)
		end
	end)
	UIHelper.titleShadow(self.btnSure,m_i18n[1324])
	--加一
	self.btnAddOne = m_fnGetWidget(layRoot,"BTN_ADD_TEN")
	self.btnAddOne:addTouchEventListener(function( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			self:addBuyNum(1)
		end
	end)

	--加十
	self.btnAddTen = m_fnGetWidget(layRoot,"BTN_ADD")
	self.btnAddTen:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			self:addBuyNum(10)
		end
	end)

	--减一
	self.btnReduceOne = m_fnGetWidget(layRoot,"BTN_MINUS_TEN")
	self.btnReduceOne:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			self:addBuyNum(-1)
		end
	end)

	--减十
	self.btnReduceTen = m_fnGetWidget(layRoot,"BTN_MINUS")
	self.btnReduceTen:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			self:addBuyNum(-10)
		end
	end)
	

	-- 购买提示
	self.labPleaseChoose = m_fnGetWidget(layRoot,"tfd_please_choose")
	self.labPleaseChoose:setText(m_i18n[1423])

	self.labChooseUtil = m_fnGetWidget(layRoot,"tfd_choose_num")
	self.labChooseUtil:setText(m_i18n[1424])
	--道具名字
	self.i18nLabBuyInfo = m_fnGetWidget(layRoot,"tfd_name")
	UIHelper.labelEffect( self.i18nLabBuyInfo, "挑战次数") --TODO


	self.lay_price = m_fnGetWidget(layRoot, "lay_price")
	self.lay_price_num = m_fnGetWidget(layRoot, "lay_price_num")
	self.lay_price_num.tfd_price_name:setText("消耗金币:") --TODO
	self.lay_price_num.TFD_PRICE_NUM:setText(WorldArenaModel.getBuyAtkNumCost(self.nBuyNum))
	return self.layMain
end

function WABatchBuyAtkTimes:countNum( num )
		local canBuyNum = 1
		-- 不能超过当前能够购买的东西的 货币总量
		local goldNum = UserModel.getGoldNumber()
		local needGoldNum = WorldArenaModel.getBuyAtkNumCost(num)
		if goldNum < needGoldNum then
			self:countNum(num-1)
		else
			canBuyNum = num
		end
		return canBuyNum
end


function WABatchBuyAtkTimes:addBuyNum( num )
	local tempNum = self.nBuyNum
	self.nBuyNum = self.nBuyNum + num

	local canBuyNum = 1

	function count( num )
		-- 不能超过当前能够购买的东西的 货币总量
		local goldNum = UserModel.getGoldNumber()
		local needGoldNum = WorldArenaModel.getBuyAtkNumCost(num)
		if goldNum < needGoldNum then
			count(num-1)
		else
			canBuyNum = num
		end
	end

	count(self.nBuyNum)
	logger:debug({nBuyNum = self.nBuyNum})
	logger:debug({canBuyNum = canBuyNum})
	if self.nBuyNum > canBuyNum then
		ShowNotice.showShellInfo(m_i18n[8129])
	end
	if self.nBuyNum >= canBuyNum then
		self.nBuyNum = canBuyNum
	end

	-- 不能小于一个
	if self.nBuyNum <= 1 then
		self.nBuyNum = 1
	end
		-- 不能超过最大
	if self.nBuyNum >= tonumber(self.data.canBuyNum)  then
		self.nBuyNum = tonumber(self.data.canBuyNum)
	end

	self.labBuyNum:setText(self.nBuyNum)
	self.lay_price_num.TFD_PRICE_NUM:setText(WorldArenaModel.getBuyAtkNumCost(self.nBuyNum))
	self.lay_price_num:requestDoLayout()
	AudioHelper.playCommonEffect()
end