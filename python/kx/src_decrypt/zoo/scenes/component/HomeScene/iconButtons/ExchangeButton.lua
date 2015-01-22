
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2014年01月 6日 15:54:41
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

---------------------------------------------------
-------------- ExchangeButton
---------------------------------------------------

assert(not ExchangeButton)
assert(IconButtonBase)
ExchangeButton = class(IconButtonBase)

function ExchangeButton:init(...)
	assert(#{...} == 0)

	self.ui = ResourceManager:sharedInstance():buildGroup("exchangeIcon")

	-- Init Base
	IconButtonBase.init(self, self.ui)

	self.wrapper:setTouchEnabled(true, 0, true)
end

function ExchangeButton:create(...)
	assert(#{...} == 0)

	local newExchangeButton = ExchangeButton.new()
	newExchangeButton:init()
	return newExchangeButton
end

