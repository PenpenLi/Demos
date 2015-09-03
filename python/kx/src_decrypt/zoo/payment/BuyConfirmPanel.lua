require "zoo.panelBusLogic.BuyLogic"
require "zoo.payment.ThirdPayDiscountLabel"
require 'zoo.panel.ChoosePaymentPanel'
require "zoo.payment.GoldlNotEnoughPanel"

BuyConfirmPanel = class(BasePanel)

function BuyConfirmPanel:ctor()


end

function BuyConfirmPanel:init()
	self.ui	= self:buildInterfaceGroup("BuyConfirmPanel") 
	BasePanel.init(self, self.ui)

	FrameLoader:loadArmature( "skeleton/tutorial_animation" )

	self.goodsName = Localization:getInstance():getText("goods.name.text"..tostring(self.goodsId))
	self:initTitlePart()
	self:initExtendPanel()
	self:initItemBubble()

	self.rmbPart = self.ui:getChildByName("rmbPart")
	self.windMillPart = self.ui:getChildByName("windMillPart")
end

function BuyConfirmPanel:initTitlePart()
	local panelTitle = self.ui:getChildByName("panelTitle")
	panelTitle:setString("购买 "..self.goodsName)

	local closeBtn = self.ui:getChildByName("closeBtn")
	closeBtn:setTouchEnabled(true)
	closeBtn:setButtonMode(true)
	closeBtn:addEventListener(DisplayEvents.kTouchTap,  function ()
		self:onCloseBtnTap()
	end)
end

function BuyConfirmPanel:onCloseBtnTap()
	self:removePopout()
end

function BuyConfirmPanel:initExtendPanel()
	self.bg = self.ui:getChildByName("bg")
	self.extended = false
	self.animComplete = true
	self.extendedPanel = self.ui:getChildByName('extendedPanel')
	self.extendedPanel:setVisible(false)

	self.curtain = self.extendedPanel:getChildByName("curtain")
	self.btnPlay = self.extendedPanel:getChildByName("btnPlay")
	self.btnPlay:getChildByName('text'):setString(Localization:getInstance():getText("prop.info.panel.anim.play"))
end

function BuyConfirmPanel:initItemBubble()
	self.itemBubbleRes = self.ui:getChildByName("itemBubble")

	self.bubbleDiscount = self.itemBubbleRes:getChildByName("discount")
	self.bubbleDiscountNum = self.bubbleDiscount:getChildByName("num")
	if self:getDiscountShowState(self.paymentType) then 
		self.bubbleDiscountNum:setString(self.discountNum)
	else
		self.bubbleDiscount:setVisible(false)
	end

	self.helpButton = self.itemBubbleRes:getChildByName("questionMark")
	self.helpButton_light = self.helpButton:getChildByName("light")
	self.helpButton_dark = self.helpButton:getChildByName("dark")
	self.helpButton:setVisible(false)
	local goodsData = MarketManager:sharedInstance():getGoodsById(self.goodsId)
	local items = goodsData.items
	if items and #items == 1 and self.goodsType == 1 then
		local itemId = items[1].itemId
		local tutorialAnimation = CommonSkeletonAnimation:creatTutorialAnimation(itemId)
		if tutorialAnimation then 
			self.helpButton_light:setVisible(false)
			self.helpButton:setVisible(true)
			self.helpButton:setTouchEnabled(true)
			self.helpButton:addEventListener(DisplayEvents.kTouchTap, function ()
				self:onHelpButtonClick()
			end)
			self.tutorial = tutorialAnimation
			tutorialAnimation:setAnchorPoint(ccp(0, 1))
			local animePlaceHolder = self.extendedPanel:getChildByName('animePlaceHolder')
			local pos = animePlaceHolder:getPosition()
			tutorialAnimation:setPosition(ccp(pos.x, pos.y))
			local zOrder = animePlaceHolder:getZOrder()
			animePlaceHolder:getParent():addChildAt(tutorialAnimation, zOrder)
			animePlaceHolder:removeFromParentAndCleanup(true)

			self.btnPlay:setTouchEnabled(true)
			self.btnPlay:setButtonMode(true)
			self.btnPlay:addEventListener(DisplayEvents.kTouchTap, function ()
				self:playTutorial()
			end)		
		end	
	end


	local iconBuilder = InterfaceBuilder:create(PanelConfigFiles.properties)
	local itemIcon = nil
	if self.goodsType == 2 then -- 购买金币
		itemIcon = iconBuilder:buildGroup("Prop_14")
	elseif self.goodsType == 1 then
		if string.find(self.goodsName, "新区域解锁") then
			itemIcon = Sprite:createWithSpriteFrameName("buy_confirm_panel/cells/unlockIcon0000")
			itemIcon:setAnchorPoint(ccp(0,1))
		elseif string.find(self.goodsName, "签到礼包") then
			itemIcon = Sprite:createWithSpriteFrameName("buy_confirm_panel/cells/checkinIcon0000")
			itemIcon:setAnchorPoint(ccp(0,1))
		else
			local gid = self.goodsId
			if string.find(self.goodsName, "加5步") then
				gid = 4
			elseif string.find(self.goodsName, "追踪导弹") then
				gid = 45
			end
			itemIcon = iconBuilder:buildGroup('Goods_'..gid)
		end
	end

	local holder = self.itemBubbleRes:getChildByName("targetIconPlaceHolder")
	local holderIndex = self.itemBubbleRes:getChildIndex(holder)
	local bSize = holder:getGroupBounds().size
	if itemIcon then 
		local iSize = itemIcon:getGroupBounds().size
		itemIcon:setPositionXY(holder:getPositionX() + (bSize.width - iSize.width) / 2, holder:getPositionY() - (bSize.height - iSize.height) / 2)
		self.itemBubbleRes:addChildAt(itemIcon, holderIndex)
	end
	holder:removeFromParentAndCleanup(true)
end

function BuyConfirmPanel:getDiscountShowState(paymentType)
	-- local thirdPaymentConfig = AndroidPayment.getInstance().thirdPartyPayment
	-- for i,v in ipairs(thirdPaymentConfig) do
	-- 	if v == paymentType then 
	-- 		if string.find(self.goodsName, "新区域解锁") then
	-- 			return false
	-- 		elseif string.find(self.goodsName, "签到礼包") then
	-- 			return false
	-- 		end
	-- 		return true
	-- 	end
	-- end
	-- return false

	--去掉三方八折优惠
	return false
end

function BuyConfirmPanel:onHelpButtonClick()
	if not self.animComplete then return end
	self.animComplete = false
	if self.extended then 
		self.helpButton_light:setVisible(false)
		self.helpButton_dark:setVisible(true)
		self.extendedPanel:setVisible(false)
		self.extended = false
		self:stopTutorial()
		local size = self.bg:getGroupBounds().size
		self.bg:setPreferredSize(CCSizeMake(size.width, 446))
		self:runAction(CCSequence:createWithTwoActions(
		               CCEaseSineOut:create(CCMoveBy:create(0.2, ccp(0, -100))),
		               CCCallFunc:create(function()
		               		self.animComplete = true
                    	end )
		               ))
	else 
		self.helpButton_light:setVisible(true)
		self.helpButton_dark:setVisible(false)
		local size = self.bg:getGroupBounds().size
		self:runAction(CCSequence:createWithTwoActions(
		               CCEaseSineOut:create(CCMoveBy:create(0.2, ccp(0, 100))),
		               CCCallFunc:create(function()
	                     	self.extendedPanel:setVisible(true)
							self.extended = true
							self.animComplete = true
							if self.bg and not self.bg.isDisposed then
			                	self.bg:setPreferredSize(CCSizeMake(size.width, 640))
			                end
		                end)
		               ))
	end
end

function BuyConfirmPanel:playTutorial()
	if self.tutorial then
		self.curtain:setVisible(false)
		self.btnPlay:setVisible(false)
		self.tutorial:playAnimation()
	end
end

function BuyConfirmPanel:stopTutorial()
	if self.tutorial then
		self.tutorial:stopAnimation()
		self.curtain:setVisible(true)
		self.btnPlay:setVisible(true)
	end
end

function BuyConfirmPanel:popout()
	PopoutManager:sharedInstance():add(self, false, false)
	local parent = self:getParent()
	if parent then
		self:setToScreenCenterHorizontal()
		self:setToScreenCenterVertical()		
	end
	self.allowBackKeyTap = true
end

function BuyConfirmPanel:removePopout()
	CCTextureCache:sharedTextureCache():removeTextureForKey(CCFileUtils:sharedFileUtils():fullPathForFilename("skeleton/tutorial_animation/texture.png"))
	PopoutManager:sharedInstance():remove(self, true)
	self.allowBackKeyTap = false
end

function BuyConfirmPanel:onKeyBackClicked()
	self:onCloseBtnTap()
end
