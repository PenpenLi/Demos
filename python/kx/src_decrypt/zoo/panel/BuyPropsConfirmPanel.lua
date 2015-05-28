local BuyPropsConfirmPanel = class(BasePanel)
local p = BuyPropsConfirmPanel
local winSize = CCDirector:sharedDirector():getVisibleSize()
local origin = CCDirector:sharedDirector():getVisibleOrigin()

-- @see also EndGamePropShowPanel
--[[
	local PropList = table.const{
		kAddMove = {itemid = 10004, goodId = 24, discountGoodsId = 33},
		kRivive = {itemid = 10040, goodId = 46, discountGoodsId = 47},
		kAddTime = {itemid = 16, goodId = 155, discountGoodsId = 155},
	} 
]]
	--102:1分钱加5步
local ignor_confirm_list = {102, 24, 33, 46, 47, 155}
local function needConfirm(goodsId, goodsMeta)
	if table.indexOf(ignor_confirm_list, goodsId) then
		print("===skip buy confirm:", goodsId)
		return false
	elseif string.find(goodsMeta.props, "签到礼包") then
		return false
	end
	return true
end

local diff = {}
diff[2] = 2.5

local function getPrice(id, def)
	if diff[id] ~= nil then
		return diff[id]
	else
		return def
	end
end

function p:showLoadingAnim()
	if self.ui then
		self.ui:removeChildren(true)
	end

	local _anim
	local function onCountDownAnimationFinished()	
		print("onCountDownAnimationFinished")
		if _anim then
			if not _anim.isDisposed then
				_anim:removeFromParentAndCleanup(true)
			end
			 _anim = nil
		end

		if self and not self.isDisposed then
			self:removeWithCallback(self.okfunc)
		end
	end

	local tips = Localization:getInstance():getText('loading.tips.mm.payment')
	_anim = CountDownAnimation:createLoadingAnimation(tips)
	_anim:setPosition(ccp(winSize.width/2, winSize.height/2))
	Director:sharedDirector():getRunningScene():addChild(_anim)
	setTimeOut(onCountDownAnimationFinished, 2)
end

function p:init(goodsId, goodsType, goodsMeta, okfunc, cancelfunc, ignoreNeedConfirm)
	print("init", goodsId, goodsType)
	print(table.tostring(goodsMeta))
	self:loadRequiredResource(PanelConfigFiles.panel_buy_confirm)
	self.ui = self:buildInterfaceGroup("BuyPropsConfirmPanel/BuyPropsConfirm")
	BasePanel.init(self, self.ui)
	self.extended = false
	self.cancelfunc = cancelfunc
	self.okfunc = okfunc
	self.discountLabel = self.ui:getChildByName('discount')
	self.discountLabel:setVisible(false)
	
	local isNeedConfirm = needConfirm(goodsId, goodsMeta) 
	self.isNeedConfirm = isNeedConfirm

	if isNeedConfirm and ignoreNeedConfirm ~= true then
		self:showConfirmPanel(goodsId, goodsType, goodsMeta)
		DcUtil:UserTrack({ category='buy', sub_category='item_id', act_type = 1 })
	else
		self:showLoadingAnim()
	end
end

function p:showConfirmPanel(goodsId, goodsType, goodsMeta)
	print("show confirm panel")
	FrameLoader:loadArmature( "skeleton/tutorial_animation" )
	self.animComplete = true
	local onClosePanel = function()
		print("=== onClosePanel")
		self:onKeyBackClicked()
	end

	local onBuy = function()
		print("=== onBuy")
		--self:onKeyBackClicked()
		self:showLoadingAnim()
		DcUtil:UserTrack({ category='buy', sub_category='item_id', act_type = 2 })
	end

	

	local bg = self.ui:getChildByName("blackBg")
	self.bg = bg

	local closeBtn = self.ui:getChildByName("closeBtn")
	closeBtn:setTouchEnabled(true)
	closeBtn:setButtonMode(true)
	closeBtn:addEventListener(DisplayEvents.kTouchTap,  onClosePanel)
	
	local buyBtn = GroupButtonBase:create(self.ui:getChildByName("buyBtn"))
	-- buyBtn:setString(string.format("￥%0.2f 购买", getPrice(goodsMeta.id, goodsMeta.price)))
	buyBtn:setString("购买")
	buyBtn:setColorMode(kGroupButtonColorMode.blue)
	buyBtn:addEventListener(DisplayEvents.kTouchTap,  onBuy)

	local priceLabel = self.ui:getChildByName("price")
	priceLabel:setString(string.format("￥%0.2f", getPrice(goodsMeta.id, goodsMeta.price)))

	local msg = self.ui:getChildByName("msg")
	-- msg:setString("购买"..goodsMeta.props)
	msg:setString(goodsMeta.props)
	print(goodsMeta.id, goodsMeta.props)

	self.helpButton = self.ui:getChildByName('helpButton')
	self.helpButton:setVisible(false)

	local btn = self.ui:getChildByName("bubble")
	btn:addEventListener(DisplayEvents.kTouchTap, function(event) self:onHelpButtonClick(event) end)
	self.bubbleBtn = btn

	self.extendedPanel = self.ui:getChildByName('extendedPanel')
	self.extendedPanel:setVisible(false)
	local descLabel = self.ui:getChildByName('txt')
	descLabel:setString("")

	local goodsData = MarketManager:sharedInstance():getGoodsById(goodsId)
	local items = goodsData.items
	if items and #items == 1 and goodsType == 1 then
		local itemId = items[1].itemId

		local desckey = "level.prop.tip."..itemId
		local propsDesc = Localization:getInstance():getText(desckey, {n = "\n"})
		if desckey ~= propsDesc then
			descLabel:setString(propsDesc)
		end

		if goodsData.originalPrice ~= 0 then
			local discount = math.ceil(tonumber(goodsMeta.price) / (goodsData.rmb / 100) * 10)
			-- print('wenkan', goodsMeta.price, 'origin', goodsData.originalPrice, 'discount', discount, 'goodsId', goodsId)
			-- print(table.tostring(goodsData))
			if discount ~= 10 then
				self.discountLabel:setVisible(true)
				self.discountLabel:getChildByName('txt'):setString(discount)
			end
		end

		local tutorialAnimation = CommonSkeletonAnimation:creatTutorialAnimation(itemId)
		if tutorialAnimation then 
			print("init tutorial")
			self.helpButton:getChildByName("active"):setVisible(false)
			self.helpButton:setVisible(true)
			self.tutorial = tutorialAnimation
			self:showHelpButton()

			tutorialAnimation:setAnchorPoint(ccp(0, 1))
			local animePlaceHolder = self.extendedPanel:getChildByName('animePlaceHolder')
			local pos = animePlaceHolder:getPosition()
			

			tutorialAnimation:setPosition(ccp(pos.x, pos.y))
			local zOrder = animePlaceHolder:getZOrder()
			animePlaceHolder:getParent():addChildAt(tutorialAnimation, zOrder)
			animePlaceHolder:removeFromParentAndCleanup(true)

			-- set play button text
			local playBtn = self.extendedPanel:getChildByName('btnPlay')
			playBtn:getChildByName('text'):setString(Localization:getInstance():getText("prop.info.panel.anim.play"))
			playBtn:setTouchEnabled(true)
			playBtn:setButtonMode(true)


			local function onPlayBtnClick()
				self:playTutorial()
			end

			playBtn:addEventListener(DisplayEvents.kTouchTap, onPlayBtnClick)		
		end	
	end


	local iconBuilder = InterfaceBuilder:create(PanelConfigFiles.properties)
	local itemIcon
	if goodsType == 2 then -- 购买金币
		itemIcon = iconBuilder:buildGroup("Prop_14")
	elseif goodsType == 1 then
		if string.find(goodsMeta.props, "新区域解锁") then
			itemIcon = Sprite:createWithSpriteFrameName("BuyPropsConfirmPanel/unlockIcon0000")
			itemIcon:setAnchorPoint(ccp(0,1))
		--elseif string.find(goodsMeta.props, "签到礼包") then
			--itemIcon = Sprite:createWithSpriteFrameName("BuyPropsConfirmPanel/checkinIcon0000")
			--itemIcon:setAnchorPoint(ccp(0,1))
		else
			local gid = goodsId
			if string.find(goodsMeta.props, "加5步") then
				gid = 4
			elseif string.find(goodsMeta.props, "追踪导弹") then
				gid = 45
			end
			itemIcon = iconBuilder:buildGroup('Goods_'..gid)
		end

		
	end

	local holder = self.ui:getChildByName("icon")
	local holderIndex = self.ui:getChildIndex(holder)
	local bSize = holder:getGroupBounds().size
	if itemIcon then 
		local iSize = itemIcon:getGroupBounds().size
		itemIcon:setPositionXY(holder:getPositionX() + (bSize.width - iSize.width) / 2, holder:getPositionY() - (bSize.height - iSize.height) / 2)
		self.ui:addChildAt(itemIcon, holderIndex)
	else
		self.ui:getChildByName("bubble"):setVisible(false)
		print(self.ui:getGroupBounds().size.width)
		buyBtn:setPositionX(winSize.width / 2)
	end

	holder:removeFromParentAndCleanup(true)


	if GameGuide:sharedInstance():onTryBuyProps() then
		local function showGuideAnim()
			if self and not self.isDisposed then
				local anim = CommonSkeletonAnimation:createTutorialMoveIn2()
				anim:setScaleX(-1)
				if self.helpButton and not self.helpButton.isDisposed then
					anim:setPosition(ccp(self.helpButton:getPositionX() - 50, self.helpButton:getPositionY()+40))
				end
				self.ui:addChild(anim)

				local function guideComplete()
					if anim and not anim.isDisposed then
						anim:removeFromParentAndCleanup(true)
						anim = nil
					end
					GameGuide:sharedInstance():tryStartGuide()
					print("guide guideComplete")
				end

				setTimeOut(guideComplete, 3)
			end
		end
		setTimeOut(showGuideAnim, .5)
	end
end


function p:playTutorial()
	if self.tutorial then
		local curtain = self.extendedPanel:getChildByName('curtain')
		local playBtn = self.extendedPanel:getChildByName('btnPlay')
		curtain:setVisible(false)
		playBtn:setVisible(false)
		self.tutorial:playAnimation()
	end
end

function p:stopTutorial()
	if self.tutorial then
		local curtain = self.extendedPanel:getChildByName('curtain')
		local playBtn = self.extendedPanel:getChildByName('btnPlay')
		self.tutorial:stopAnimation()
		curtain:setVisible(true)
		playBtn:setVisible(true)
	end
end

function p:showHelpButton()
	print("showHelpButton")
	self.helpButton:setVisible(true)

	self.bubbleBtn:setTouchEnabled(true, 0, false)
	self.bubbleBtn:setButtonMode(true)
end

function p:hideHelpButton()
	print("hideHelpButton")
	self.helpButton:setVisible(false)
	self.bubbleBtn:setTouchEnabled(false)
	self.bubbleBtn:setButtonMode(false)
end

function p:onHelpButtonClick(event)
	if not self.animComplete then return end
	
	self.animComplete = false
	if self.extended then 
		self.helpButton:getChildByName("active"):setVisible(false)
		self.helpButton:getChildByName("normal"):setVisible(true)
		self.extendedPanel:setVisible(false)
		self.extended = false
		self:stopTutorial()
		local size = self.bg:getGroupBounds().size
		self.bg:setPreferredSize(CCSizeMake(size.width, 383))
		self:runAction(CCSequence:createWithTwoActions(
		               CCEaseSineOut:create(CCMoveBy:create(0.2, ccp(0, -100))),
		               CCCallFunc:create(function()
		               		self.animComplete = true
                    	end )
		               ))
		DcUtil:UserTrack({ category='buy', sub_category='item_id', act_type = 5 })
	else 
		self.helpButton:getChildByName("active"):setVisible(true)
		self.helpButton:getChildByName("normal"):setVisible(false)
		local size = self.bg:getGroupBounds().size
		
		self:runAction(CCSequence:createWithTwoActions(
		               CCEaseSineOut:create(CCMoveBy:create(0.2, ccp(0, 100))),
		               CCCallFunc:create(function()
	                     	self.extendedPanel:setVisible(true)
							self.extended = true
							self.animComplete = true
							if self.bg and not self.bg.isDisposed then
			                	self.bg:setPreferredSize(CCSizeMake(size.width, 600))
			                end
		                end)
		               ))
		DcUtil:UserTrack({ category='buy', sub_category='item_id', act_type = 4 })
	end
	
end

function p:popout()
	print("popout")
	PopoutManager:sharedInstance():add(self, false, false)
	local parent = self:getParent()
	if parent then
		self:setToScreenCenterHorizontal()
		self:setToScreenCenterVertical()		
	end

	self.allowBackKeyTap = true

end

function p:removeWithCallback(callback)
	print("remove")
	if self.isNeedConfirm then
		CCTextureCache:sharedTextureCache():removeTextureForKey(CCFileUtils:sharedFileUtils():fullPathForFilename("skeleton/tutorial_animation/texture.png"))
	end

	PopoutManager:sharedInstance():remove(self)
	self.allowBackKeyTap = false

	if callback and type(callback) == "function" then
		callback()
	end
end

function p:onKeyBackClicked()
	self:removeWithCallback(self.cancelfunc)
	DcUtil:UserTrack({ category='buy', sub_category='item_id', act_type = 3 })
end


function p:create(goodsId, goodsType, goodsMeta, okfunc, cancelfunc, ignoreNeedConfirm)
	print("create")
	local t = p.new()
	t:init(goodsId, goodsType, goodsMeta, okfunc, cancelfunc, ignoreNeedConfirm)
	return t
end

return p