-- FileName: ArenaMesBatchBuy.lua
-- Author: huxiaozhou
-- Date: 2015-03-23
-- Purpose: 竞技场神秘商店 批量购买
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

ArenaMesBatchBuy = class("ArenaMesBatchBuy")

function ArenaMesBatchBuy:ctor()
	self.layMain = g_fnLoadUI("ui/shop_buy_item.json")
end

function ArenaMesBatchBuy:create(tbData)
	logger:debug("ArenaMesBatchBuy")
	logger:debug(tbData)
	self.data = tbData
	local layRoot = self.layMain

	self.nBuyNum = 1
	self.labBuyNum = m_fnGetWidget(layRoot, "TFD_PLAYER_BUY_NUM")
	self.labBuyNum:setText(self.nBuyNum)
	-- X
	self.btnClose = m_fnGetWidget(layRoot,"BTN_SHOP_BUY_ITEM_CLOSE")
	self.btnClose:addTouchEventListener(UIHelper.onClose)
	--取消按钮
	self.btnCancel = m_fnGetWidget(layRoot,"BTN_SHOP_ITEM_BUY_CANCEL")
	self.btnCancel:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCloseEffect()
			LayerManager.removeLayout()
		end
	end)
	UIHelper.titleShadow(self.btnCancel,m_i18n[1625])
	--确定按钮
	self.btnSure = m_fnGetWidget(layRoot,"BTN_SHOP_ITEM_BUY_SURE")
	self.btnSure:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			tbData.onSure(self.nBuyNum)
		end
	end)
	UIHelper.titleShadow(self.btnSure,m_i18n[1324])
	--加一
	self.btnAddOne = m_fnGetWidget(layRoot,"BTN_PLAYER_BUY_REDUCE")
	self.btnAddOne:addTouchEventListener(function( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			self:addBuyNum(1)
		end
	end)

	--加十
	self.btnAddTen = m_fnGetWidget(layRoot,"BTN_PLAYER_BUY_REDUCE_TEN")
	self.btnAddTen:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			self:addBuyNum(10)
		end
	end)

	--减一
	self.btnReduceOne = m_fnGetWidget(layRoot,"BTN_PLAYER_BUY_ADDITION")
	self.btnReduceOne:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			self:addBuyNum(-1)
		end
	end)

	--减十
	self.btnReduceTen = m_fnGetWidget(layRoot,"BTN_PLAYER_BUY_ADDITION_TEN")
	self.btnReduceTen:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			self:addBuyNum(-10)
		end
	end)

	
	self.i18nLabTotleOwner = m_fnGetWidget(layRoot,"TFD_PLAYER_OWN_NUM")
	if tbData.hasNumber then
		self.i18nLabTotleOwner:setText(m_i18n[1421] .. tbData.hasNumber .. m_i18n[1422])
	else
		self.i18nLabTotleOwner:setEnabled(false)
	end

	-- 购买提示
	self.labPleaseChoose = m_fnGetWidget(layRoot,"tfd_please_choose")
	self.labPleaseChoose:setText(m_i18n[1423])

	self.labChooseUtil = m_fnGetWidget(layRoot,"tfd_choose_num")
	self.labChooseUtil:setText(m_i18n[1424])
	--道具名字
	self.i18nLabBuyInfo = m_fnGetWidget(layRoot,"TFD_PLAYER_CHOOSE_BUY_NUM")
	UIHelper.labelEffect( self.i18nLabBuyInfo, tbData.itemName)
	self.i18nLabBuyInfo:setColor(m_gColor[tonumber(tbData.quality)])
	--兑换道具
	self.imgTitle = m_fnGetWidget(layRoot,"img_title")
	self.imgTitle:loadTexture("images/common/title_exchange_item.png")
	

	self.lay_price = m_fnGetWidget(layRoot, "lay_price")
	self.lay_price_num = m_fnGetWidget(layRoot, "lay_price_num")
	self.lay_price_num:removeFromParent()

	self.labTitle = m_fnGetWidget(layRoot,"tfd_item_price")
	self.imgGold = m_fnGetWidget(layRoot,"img_price_gold")
	self.imgPresitge = m_fnGetWidget(layRoot,"img_price_prestige")
	self.labTotlePrice = m_fnGetWidget(layRoot,"TFD_PRICE_NUM")

	if tonumber(self.data.costType) == 1 then
		self.labTitle:setText(m_i18n[1468])
		self.imgGold:removeFromParent()
	elseif tonumber(self.data.costType) == 2 then
		self.labTitle:setText(m_i18n[1469])
		self.imgPresitge:removeFromParent()
	end

	self.labTotlePrice:setText(self.data.costNum*self.nBuyNum)
	layRoot.lay_max:removeFromParent()
	return self.layMain
end


--花费 1：花费类型为声望 , 2：花费类型为金币

function ArenaMesBatchBuy:addBuyNum( num )
	self.nBuyNum = self.nBuyNum + num

	-- 不能小于一个
	if self.nBuyNum <= 1 then
		self.nBuyNum = 1
	end
	-- 不能超过最大
	if self.nBuyNum >= tonumber(self.data.canBuyNum)  then
		self.nBuyNum = tonumber(self.data.canBuyNum)
	end
	-- 不能超过当前能够购买的东西的 货币总量(声望)
	local canBuyNum = 0
	if tonumber(self.data.costType) == 1 then
		local preNum = UserModel.getPrestigeNum()
		canBuyNum = math.floor(preNum / self.data.costNum)
	elseif tonumber(self.data.costType) == 2 then
		local goldNum = UserModel.getGoldNumber()
		canBuyNum = math.floor(goldNum / self.data.costNum)
	end
	if self.nBuyNum >= canBuyNum then
		self.nBuyNum = canBuyNum
	end
	self.labBuyNum:setText(self.nBuyNum)
	self.labTotlePrice:setText(self.data.costNum*self.nBuyNum)
	AudioHelper.playCommonEffect()
end




