require "zoo.net.SyncManager"
require "zoo.panelBusLogic.BuyEnergyLogic"

SyncBuyAndUseAddMaxEnergyLogic = class()

function SyncBuyAndUseAddMaxEnergyLogic:init(timeType, energyType)
	self.timeType = timeType
	self.energyType = energyType
end

function SyncBuyAndUseAddMaxEnergyLogic:start(onSuccessCallback, onFailCallback, onCancelCallback)
	self:createAnimation()
	self.listening = true
	self:sync(onSuccessCallback, onFailCallback, onCancelCallback)
end

function SyncBuyAndUseAddMaxEnergyLogic:sync(onSuccessCallback, onFailCallback, onCancelCallback)
	local function onSuccess()
		if self.listening then self:get(onSuccessCallback, onFailCallback, onCancelCallback) end
	end
	local function onFail()
		if self.listening then
			self.listening = false
			self:removeAnimation()
			if onFailCallback then onFailCallback() end
		end
	end
	SyncManager:getInstance():sync(onSuccess, onFail)
end

function SyncBuyAndUseAddMaxEnergyLogic:get(onSuccessCallback, onFailCallback, onCancelCallback)

	local logic = BuyAndUseAddMaxEnergyLogic:create(self.timeType, self.energyType)

	local function onSuccess()
		if self.listening then
			self.listening = false
			self:removeAnimation()
			if onSuccessCallback then onSuccessCallback() end
		end
	end
	local function onFail(event)
		if self.listening then
			self.listening = false
			self:removeAnimation()
			if onFailCallback then onFailCallback(event) end
		end
	end
	local function onCancel()
		if self.listening then
			self.listening = false
			self:removeAnimation()
			if onCancelCallback then onCancelCallback() end
		end
	end
	logic:start(onSuccess, onFail, onCancel, onCancel)
end

function SyncBuyAndUseAddMaxEnergyLogic:createAnimation()
	local scene = Director:sharedDirector():getRunningScene()
	local wSize = Director:sharedDirector():getWinSize()
	local layer = LayerColor:create()
	layer:changeWidthAndHeight(wSize.width, wSize.height)
	layer:setOpacity(0)
	layer:setTouchEnabled(true, 0, true)
	PopoutManager:sharedInstance():add(layer, false, false)
	-- scene:addChild(layer)
	self.layer = layer
	local function onCloseButtonTap()
		if self.listening then
			self.listening = false
			self:removeAnimation()
		end
	end
	local function onTimeout()
		if self.schedule then
			Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.schedule)
			self.schedule = nil
			if self.layer then self.layer.onKeyBackClicked = function() onCloseButtonTap() end end
			local animation = CountDownAnimation:createNetworkAnimation(scene, onCloseButtonTap)
			self.animation = animation
		end
	end
	
	self.schedule = Director:sharedDirector():getScheduler():scheduleScriptFunc(onTimeout, 1, false)
end

function SyncBuyAndUseAddMaxEnergyLogic:removeAnimation()
	if self.schedule then
		Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.schedule)
		self.schedule = nil
	end
	if self.animation then self.animation:removeFromParentAndCleanup(true) end
	if self.layer then PopoutManager:sharedInstance():remove(self.layer) end
end

function SyncBuyAndUseAddMaxEnergyLogic:create(timeType, energyType)
	local logic	= SyncBuyAndUseAddMaxEnergyLogic.new()
	logic:init(timeType, energyType)
	return logic
end
