

-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013Äê12ÔÂ28ÈÕ 19:30:33
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

---------------------------------------------------
-------------- BubbleCloseBtn
---------------------------------------------------

assert(not BubbleCloseBtn)
assert(BaseUI)
BubbleCloseBtn = class(BaseUI)

function BubbleCloseBtn:init(ui, ...)
	assert(ui)
	assert(#{...} == 0)

	-- ----------------
	-- Init Base Class
	-- ---------------
	BaseUI.init(self, ui)

	----------------
	-- Get UI Component
	-- ---------------
	
	self.center 	= self.ui:getChildByName("center")
	self.cross	= self.center:getChildByName("cross")
	self.bg		= self.center:getChildByName("bg")
	assert(self.center)
	assert(self.cross)
	assert(self.bg)


	self.ui:setTouchEnabled(true, 0 , true)
	self.ui:setButtonMode(true)

	--------------------
	-- Play Bubble Normal Animation
	-- -----------------------------
	local bubbleNormalAction 	= BubbleNormalAction:create(self.bg, 66.35, 64.20, 1, 1)
	local repeatForever		= CCRepeatForever:create(bubbleNormalAction)
	self.bg:runAction(repeatForever)
end

function BubbleCloseBtn:create(ui, ...)
	assert(ui)
	assert(#{...} == 0)

	local newBubbleCloseBtn = BubbleCloseBtn.new()
	newBubbleCloseBtn:init(ui)
	return newBubbleCloseBtn
end

