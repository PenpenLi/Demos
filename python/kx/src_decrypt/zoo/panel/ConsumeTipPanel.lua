
require "zoo.panel.ConsumeHistoryPanel"

local visibleOrigin = Director.sharedDirector():getVisibleOrigin()
local visibleSize = Director.sharedDirector():getVisibleSize()

ConsumeTipPanel = class(BasePanel)

function ConsumeTipPanel:create( price )
	local panel = ConsumeTipPanel.new()
	panel:loadRequiredResource("ui/consume_tip.json")
	panel:init(price)
	return panel
end

function ConsumeTipPanel:init( props )

	self.ui = self:buildInterfaceGroup("consumeTip/panel")
	BasePanel.init(self, self.ui)

	local text= self.ui:getChildByName("text")
	self._text = text 
	local string = Localization:getInstance():getText("consume.tip.panel.text.1",{n=props})
	text:setDimensions(CCSizeMake(0,0))
	self:setText(string)
	-- text:setAnchorPoint(ccp(0,0.5))
	-- text:setPositionY(text:boundingBox():getMidY())
	local size = text:getContentSize()
	local bg = self.ui:getChildByName("bg")
	if bg then
		local bgSize = bg:getGroupBounds().size
		text:setPositionX((bgSize.width - size.width) / 2)
	end


	local text2 = self.ui:getChildByName("text2")
	local icon = self.ui:getChildByName("icon")

	if ConsumeHistoryPanel.isShowCustomerPhone() then
		text2:setString(Localization:getInstance():getText("consume.tip.panel.text.2"))
		text2:setAnchorPoint(ccp(0,0.5))
		text2:setPositionY(icon:boundingBox():getMidY())
		text2:setDimensions(CCSizeMake(text2:getDimensions().width,0))
	else
		icon:setVisible(false)
		-- text:setPositionX(text:getPositionX() - 25)
		text:setPositionY(text:getPositionY() - 20)
	end


	self.link = self.ui:getChildByName("logLink")
	self.ui:setTouchEnabled(true, 0, true)
	self.ui:addEventListener(DisplayEvents.kTouchTap,function()
		self.ui:setTouchEnabled(false)
		self:runAction(CCCallFunc:create(function( ... )
			ConsumeHistoryPanel:create():popout()
			
			self:removeFromParentAndCleanup(true)
		end))
	end)

end

function ConsumeTipPanel:setText( text )
	-- body
	self._text:setString(text)
end

function ConsumeTipPanel:popout( ... )
	local scene = Director.sharedDirector():getRunningScene()
	if scene == nil then 
		self:dispose()
		return 
	end
	if scene:is(GamePlaySceneUI) then 
		self.link:setVisible(false)	
		self.ui:setTouchEnabled(false)
	end

	local bounds = self:getGroupBounds()

	local container = CocosObject:create()
	container:setContentSize(bounds.size)
	container:setAnchorPoint(ccp(0.5,0.5))

	self:setPositionY(bounds.size.height)
	container:addChild(self)

	local toPos = ccp(
		visibleOrigin.x + visibleSize.width/2 + 7,
		visibleOrigin.y + visibleSize.height - bounds.size.height/2 - 40
	)
	local actions = CCArray:create()

	if scene:is(HomeScene) then 
		local goldBounds = scene.goldButton.ui:getGroupBounds()

		container:setScale(0)
		container:setPositionX(goldBounds:getMaxX())
		container:setPositionY(goldBounds:getMinY())

		actions:addObject(CCEaseBounceOut:create(CCSpawn:createWithTwoActions(
			CCScaleTo:create(10/30,1.0),
			CCMoveTo:create(10/30,toPos)
		)))
	else
		container:setPositionX(toPos.x)
		container:setPositionY(visibleOrigin.y + visibleSize.height + bounds.size.height/2)

		actions:addObject(CCEaseBounceOut:create(
			CCMoveTo:create(10/30,toPos)
		))
	end

	actions:addObject(CCDelayTime:create(3))
	actions:addObject(CCCallFunc:create(function( ... )
		container:removeFromParentAndCleanup(true)
	end))

	container:runAction(CCSequence:create(actions))

	scene:addChild(container)
end

