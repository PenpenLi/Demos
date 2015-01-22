local TIP_DURATION = 10 --sec

BubbleTip = class(BasePanel)

function BubbleTip:create(content, propsId)
	local panel = BubbleTip.new()
	if panel:init(content, propsId) then
		panel:loadRequiredResource(PanelConfigFiles.common_ui)
		return panel
	else
		panel = nil
		return nil
	end
end

function BubbleTip:loadRequiredResource( panelConfigFile )
	self.panelConfigFile = panelConfigFile
	self.builder = InterfaceBuilder:create(panelConfigFile)
end

function BubbleTip:init(content, propsId)
	-- 默认值以及依赖资源的值
	self.defaultWidth = 287.45
	self.defaultHeight = 227.15
	self.contentMargin = 30 --px

	-- 创建窗口
	self.ui = ResourceManager:sharedInstance():buildGroup("ui_groups/ui_group_tip_bubble")
	BasePanel.init(self, self.ui)

	-- 获取控件
	self.panel = self.ui:getChildByName("panel")
	self.arrow = self.ui:getChildByName("arrow")

	if not self.panel or not self.arrow then return false end
	self.arrowHeight = self.arrow:getGroupBounds().size.height


	if content then
		self.panel:addChild(content)
		local size = content:getGroupBounds().size
		local panelSize = CCSizeMake(size.width + self.contentMargin * 2, size.height + self.contentMargin * 2)
		self.width = panelSize.width
		self.height = panelSize.height
		content:setPosition(ccp(self.contentMargin, self.contentMargin + size.height))
		self.panel:addChild(content)
	end

	self.width, self.height = self.width or self.defaultWidth, self.height or self.defaultHeight
	self.panel:setPreferredSize(CCSizeMake(self.width, self.height))

	self.panel:setAnchorPoint(ccp(0, 1))
	self.panel:setPosition(ccp(0, 0))

	self.ui:setTouchEnabled(true, 0, true)
	local function __onTouchDelegate(event)
		self:onTouchTap(event)
	end
	self.ui:addEventListener(DisplayEvents.kTouchTap, __onTouchDelegate)

	self.touchCheckLayer = Layer:create()
	local visibleSize = Director:sharedDirector():getVisibleSize()
	local visibleOrigin = Director:sharedDirector():getVisibleOrigin()
	self.touchCheckLayer:setAnchorPoint(ccp(0,0))
	self.touchCheckLayer:setPosition(ccp(visibleOrigin.x, visibleOrigin.y))
	self.touchCheckLayer:changeWidthAndHeight(visibleSize.width, visibleSize.height)
	self.touchCheckLayer:setTouchEnabled(true, 0, false)
	Director:sharedDirector():getRunningScene():addChild(self.touchCheckLayer)


	return true
end

function BubbleTip:onTouchTap(event)
	print('touched')
	local time = TIP_DURATION --sec
	if self.timerId then
		Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.timerId)
		self.timerId = 
			Director:sharedDirector():getScheduler():scheduleScriptFunc(
		                                                   function () self:hide() end,
											               time, 	
											               false)
	end
end

-- rect: the box around which the tip should show itself
-- direction: on which direction of the rect the tip should put itself
function BubbleTip:pointTo(rect)
	local size = rect.size
	local origin = rect.origin

	local visibleSize = Director:sharedDirector():getVisibleSize()
	local visibleOrigin = Director:sharedDirector():getVisibleOrigin()

	local left = ccp(origin.x, origin.y + size.height / 2)
	local right = ccp(origin.x + size.width, origin.y + size.height / 2)
	local top = ccp(origin.x + size.width / 2, origin.y + size.height)
	local bottom = ccp(origin.x + size.width / 2, origin.y)

	local arrowSize = self.arrow:getGroupBounds().size
	local panelSize = self.panel:getGroupBounds().size

	local direction = right -- default the tip appears on the right

	-- check border
	local rightOut = false
	local leftOut = false
	local topOut = false
	local bottomOut = false

	if right.x + arrowSize.width + panelSize.width > visibleOrigin.x + visibleSize.width
	then 
		rightOut = true
	end

	if left.x - arrowSize.width - panelSize.width < visibleOrigin.x
	then 
		leftOut = true
	end

	if top.y + arrowSize.height + panelSize.height > visibleOrigin.y + visibleSize.height
	then 
		topOut = true
	end

	if top.y - arrowSize.height - panelSize.height < visibleOrigin.y
	then
		bottomOut = true
	end

	if not rightOut then
		direction = right
	elseif not leftOut then
		direction = left
	elseif not topOut then
		direction = top
	elseif not bottomOut then
		direction = bottom
	else 
		direction = right
	end


	local panelOffset = arrowSize.width * (0.33) -- distance from arrow to panel

	if direction == right then 
		self.ui:setAnchorPoint(ccp(0, 0.5))
		self.arrow:setRotation(90) -- point to left
		self.arrow:setPosition(ccp(0, 0))
		self.panel:setAnchorPoint(ccp(0, 0.5))
		self.panel:setPosition(ccp(panelOffset, 0))
		self.ui:setPosition(right)

	elseif direction == left then
		self.ui:setAnchorPoint(ccp(1, 0.5))
		self.arrow:setRotation(-90)
		self.arrow:setPosition(ccp(0, 0))
		self.panel:setAnchorPoint(ccp(1, 0.5))
		self.panel:setPosition(ccp(-panelOffset, 0))
		self.ui:setPosition(left)

	elseif direction == top then 
		self.ui:setAnchorPoint(ccp(0.5, 0))
		self.arrow:setRotation(0)
		self.arrow:setPosition(ccp(0,0))
		self.panel:setAnchorPoint(ccp(0.5, 0))
		self.panel:setPosition(ccp(0, panelOffset))
		self.ui:setPosition(top)
	else -- bottom
		self.ui:setAnchorPoint(ccp(0.5, 1))
		self.arrow:setRotation(180)
		self.arrow:setPosition(ccp(0, 0))
		self.panel:setAnchorPoint(ccp(0.5, 1))
		self.panel:setPosition(ccp(0, -panelOffset))
		self.ui:setPosition(bottom)

	end



end



function BubbleTip:onEnterHandler(evt)
	-- 什么也不做，只为了覆盖方法
end

function BubbleTip:isPopedOut()
	if self._isPopedOut == nil then self._isPopedOut = false end
	return self._isPopedOut;
end

function BubbleTip:show(rect)
	local time = TIP_DURATION --sec
	local function __hideDelegate(event)
		self:hide()
	end

	self.timerId = Director:sharedDirector():getScheduler():scheduleScriptFunc(__hideDelegate, time, false)
	self.touchCheckLayer:addEventListener(DisplayEvents.kTouchBegin, __hideDelegate, nil)

	local scene = Director:sharedDirector():getRunningScene()
	if scene then 

		print(self.ui:getGroupBounds().origin.x, self.ui:getGroupBounds().origin.y)
		print(self.ui:getGroupBounds().size.width, self.ui:getGroupBounds().size.height)
		self:pointTo(rect)
		scene:addChild(self)
		self._isPopedOut = true
	end
end

function BubbleTip:hide()
	if self.timerId ~= nil then 
		Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.timerId)
	end
	self:removeFromParentAndCleanup(true)
	self.touchCheckLayer:removeEventListenerByName(DisplayEvents.kTouchBegin)
	self.touchCheckLayer:removeFromParentAndCleanup(true)
	self._isPopedOut = false
end

function BubbleTip:dispose()
	print 'bubble tip dispose'
	-- self:hide()
	-- self.touchCheckLayer:removeFromParentAndCleanup(false)
	BaseUI.dispose(self)
end

