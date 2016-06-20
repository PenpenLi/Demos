require "hecore.class"

WMBBuyItemLogic = class()
function WMBBuyItemLogic:ctor()
	
end

function WMBBuyItemLogic:init()
	
end

function WMBBuyItemLogic:buy(goodsId, goodsNum, dcWindmillInfo, buyLogic, successCallback, failCallback, cancelCallback, updateFunc)
	self.goodsId = goodsId
	self.goodsNum = goodsNum
	self.dcWindmillInfo = dcWindmillInfo
	self.buyLogic = buyLogic
	self.successCallback = successCallback
	self.failCallback = failCallback
	self.cancelCallback = cancelCallback
	self.updateFunc = updateFunc

	self:buyWithWindmill()
end

function WMBBuyItemLogic:buyWithWindmill()
	local singlePrice = self.buyLogic:getPrice()
	self.dcWindmillInfo:setGoodsNum(self.goodsNum)
	self.dcWindmillInfo:setWindMillPrice(self.goodsNum * singlePrice)

	local function onSuccess(data)
		local scene = HomeScene:sharedInstance()
		local button = scene.goldButton
		if button then button:updateView() end

		if self.successCallback then 
			self.successCallback(self.goodsNum)
		end

		self.dcWindmillInfo:setResult(DCWindmillPayResult.kSuccess)
		if __ANDROID then 
			PaymentDCUtil.getInstance():sendAndroidWindmillPayEnd(self.dcWindmillInfo)
		elseif __IOS then 
			PaymentIosDCUtil.getInstance():sendIosWindmillPayEnd(self.dcWindmillInfo)
		end
	end
	local function onFail(errorCode)
		if errorCode and errorCode == 730330 then
			self.dcWindmillInfo:setResult(DCWindmillPayResult.kNoWindmill)
			self:goldNotEnough()
		else
			self.dcWindmillInfo:setResult(DCWindmillPayResult.kFail, errorCode)
			if errorCode then 
				CommonTip:showTip(Localization:getInstance():getText("error.tip."..tostring(errorCode)), "negative")
			end
			if self.failCallback then 
				self.failCallback()
			end
		end
		if __ANDROID then 
			PaymentDCUtil.getInstance():sendAndroidWindmillPayEnd(self.dcWindmillInfo)
		elseif __IOS then 
			PaymentIosDCUtil.getInstance():sendIosWindmillPayEnd(self.dcWindmillInfo)
		end
	end

   	self.buyLogic:start(self.goodsNum, onSuccess, onFail)
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
	local panel = GoldlNotEnoughPanel:create(createGoldPanel, cancelCallback)
	if panel then panel:popout() end 
end

function WMBBuyItemLogic:create()
	local logic = WMBBuyItemLogic.new()
	logic:init()
	return logic
end