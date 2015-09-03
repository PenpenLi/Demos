require "hecore.class"

WMBBuyItemLogic = class()
function WMBBuyItemLogic:ctor()
	
end

function WMBBuyItemLogic:init()
	
end

function WMBBuyItemLogic:buy(goodsId, goodsNum, uniquePayId, buyLogic, successCallback, failCallback, cancelCallback, updateFunc)
	self.goodsId = goodsId
	self.goodsNum = goodsNum
	self.uniquePayId = uniquePayId
	self.buyLogic = buyLogic
	self.successCallback = successCallback
	self.failCallback = failCallback
	self.cancelCallback = cancelCallback
	self.updateFunc = updateFunc

	self:handleWithNetwork()
end

function WMBBuyItemLogic:handleWithNetwork()
	local singlePrice = self.buyLogic:getPrice()

	local function onSuccess(evt)
		local scene = HomeScene:sharedInstance()
		local button = scene.goldButton
		if button then button:updateView() end

		if self.successCallback then 
			self.successCallback(self.goodsNum)
		end

		PaymentDCUtil.getInstance():sendPayEnd(Payments.WIND_MILL, Payments.WIND_MILL, self.uniquePayId, self.goodsId, 1, 
								self.goodsNum, 0, 0, self.goodsNum * singlePrice, 0, nil, 0)
	end
	local function onFail(evt)
		if evt and evt.data == 730330 then
			self:goldNotEnough()
		else
			local errorCode = nil
			if evt and evt.data then 
				CommonTip:showTip(Localization:getInstance():getText("error.tip."..tostring(evt.data)), "negative")
				errorCode = evt.data
			end
			if self.failCallback then 
				self.failCallback()
			end
			PaymentDCUtil.getInstance():sendPayEnd(Payments.WIND_MILL, Payments.WIND_MILL, self.uniquePayId, self.goodsId, 1, 
									self.goodsNum, 0, 0, self.goodsNum * singlePrice, 1, errorCode, 0)
		end
	end

    local function onUserHasLogin()
   		self.buyLogic:start(self.goodsNum, onSuccess, onFail)
   	end
   	onUserHasLogin()
  	-- RequireNetworkAlert:callFuncWithLogged(onUserHasLogin)
end

function WMBBuyItemLogic:goldNotEnough()
	local function updateGold()
		if self.updateFunc then 
			self.updateFunc()
		end
	end
	local function createGoldPanel()
		print("createGoldPanel")
		local index = MarketManager:sharedInstance():getHappyCoinPageIndex()
		if index ~= 0 then
			local config = {TabsIdConst.kHappyeCoin}
			local panel = createMarketPanel(index,config)
			panel:addEventListener(kPanelEvents.kClose, updateGold)
			panel:popout()
		else 
			updateGold() 
		end
	end

	local function cancelCallback()
		if self.cancelCallback then 
			self.cancelCallback()
		end
	end
	local panel = GoldlNotEnoughPanel:create(createGoldPanel, cancelCallback, self.uniquePayId)
	if panel then panel:popout() end 
end

function WMBBuyItemLogic:create()
	local logic = WMBBuyItemLogic.new()
	logic:init()
	return logic
end