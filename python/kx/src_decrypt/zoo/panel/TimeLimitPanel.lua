
TimeLimitData = class()

local timeLimitData = nil
function TimeLimitData:getInstance( ... )

	if not timeLimitData then 
		timeLimitData = TimeLimitData.new()

		-- print(table.serialize(UserManager:getInstance().payGiftInfo))
		-- UserManager:getInstance().payGiftInfo = {
		-- 	goodsIdIngame = 128,
		-- 	goodsIdOutgame = 129,
		-- 	bought = false,
		-- 	showValue = 11
		-- }
		-- timeLimitData:writeLimitTime()

	end

	return timeLimitData

end


local function getTimePath(payGiftInfo )

	return HeResPathUtils:getUserDataPath() .. 
			"/timeLimit_" .. 
			tostring(payGiftInfo.goodsIdIngame) .. "_" .. 
			tostring(payGiftInfo.goodsIdOutgame) .. "_" .. 
			tostring(UserManager.getInstance().inviteCode)
end


function TimeLimitData:getLeftTime( ... )

	local payGiftInfo = UserManager:getInstance().payGiftInfo
	if not payGiftInfo then 
		return { hour=0, min=0, sec=0}
	end

	local timePath = getTimePath(payGiftInfo)
	local time = self._limitTime
	
	if time == nil then
		local file = io.open(timePath,"r")
		if file then 
			time = tonumber(file:read("*a")) or 0

			if time > 0 then
				self._limitTime = time
			end

			file:close()
		else
			time = 0
		end
	end

	local now = os.time() + (__g_utcDiffSeconds or 0)

	local diffTime = math.max(0,time - now) 

	return { 
		hour=math.min(23,math.floor(diffTime / 3600)),
		min=math.floor(diffTime % 3600 / 60),
		sec=math.floor(diffTime % 60)
	}

end

function TimeLimitData:isStart( ... )
	local payGiftInfo = UserManager:getInstance().payGiftInfo
	if not payGiftInfo then 
		return false
	end

	local timePath = getTimePath(payGiftInfo)
	return HeFileUtils:exists(timePath)
end

function TimeLimitData:writeLimitTime( ... )
	
	local payGiftInfo = UserManager:getInstance().payGiftInfo
	if not payGiftInfo then 
		return
	end
	if self:isStart() then 
		return
	end

	local timePath = getTimePath(payGiftInfo)
	local file = io.open(timePath,"w")
	if file then 
		local now = os.time() + (__g_utcDiffSeconds or 0)

		self._limitTime = now + 3600

		file:write(tostring(self._limitTime))
		file:close()

		self._needAutoPopout = true
	end
end

function TimeLimitData:getNeedAutoPopout( ... )
	return self._needAutoPopout or false
end

function TimeLimitData:setBought( ... )
	
	local payGiftInfo = UserManager:getInstance().payGiftInfo
	if not payGiftInfo then 
		return
	end

	payGiftInfo.bought = true
 
	local timePath = getTimePath(payGiftInfo)

	local file = io.open(timePath,"w")
	if file then 

		self._limitTime = 0

		file:write("0")
		file:close()
	end

	self._needAutoPopout = false

end

function TimeLimitData:getIngameGoodsId( ... )
	return self:_getGoodsId(1)
end
function TimeLimitData:getOutgameGoodsId( ... )
	return self:_getGoodsId(2)
end

function TimeLimitData:hasIngameBuyItem( ... )
	return self:_hasBuyItem(1)
end

function TimeLimitData:hasOutgameBuyItem( ... )
	return self:_hasBuyItem(2)
end

function TimeLimitData:getIngameBuyItem( ... )
	return self:_getBuyItem(1)
end
function TimeLimitData:getOutgameBuyItem( ... )
	return self:_getBuyItem(2)
end

function TimeLimitData:getIngameSendItems( ... )
	return self:_getSendItems(1)
end
function TimeLimitData:getIngameBuyActualValue( ... )
	return self:_getBuyActualValue(1)
end
function TimeLimitData:getIngameSendValue( ... )
	return self:_getSendValue(1)
end
function TimeLimitData:getIngameBuyDiscountValue( ... )
	return self:_getBuyDiscountValue(1)
end
function TimeLimitData:getIngameBuyDicount( ... )
	return self:_getBuyDiscount(1)
end


function TimeLimitData:getOutgameSendItems( ... )
	return self:_getSendItems(2)
end

function TimeLimitData:getOutgameTotalValue( ... )
	return self:_getTotalValue(2)
end
function TimeLimitData:getOutgameBuyDicount( ... )
	return self:_getBuyDiscount(2)
end
function TimeLimitData:getOutgameBuyActualValue( ... )
	return self:_getBuyActualValue(2)
end
function TimeLimitData:getOutgameBuyDiscountValue( ... )
	return self:_getBuyDiscountValue(2)
end



function TimeLimitData:_getGoodsId( type )

	local payGiftInfo = UserManager:getInstance().payGiftInfo
	local goodsId = nil
	if type == 1 then
		goodsId = payGiftInfo.goodsIdIngame
	else
		goodsId = payGiftInfo.goodsIdOutgame
	end

	return goodsId	
end

function TimeLimitData:_getGoods( type )
	local goodsId = self:_getGoodsId(type)
	return MetaManager:getInstance():getGoodMeta(goodsId)
end

function TimeLimitData:_hasBuyItem( type )

	if __ANDROID then 
		local defaultSmsPayType = AndroidPayment.getInstance():getDefaultSmsPayment()
		if defaultSmsPayType ~= Payments.CHINA_MOBILE then -- cmcc payment only
			return false
		end
	elseif not __WIN32 then
		return false
	end

	local payGiftInfo = UserManager:getInstance().payGiftInfo
	if not payGiftInfo then 
		return false
	end

	if payGiftInfo.bought then
		return false
	end

	local goods = self:_getGoods(type)
	if not goods then 
		return false
	end

	return true
end

function TimeLimitData:_getBuyItem( type )
	if not self:_hasBuyItem(type) then 
		return nil
	end

	local goods = self:_getGoods(type)

	return goods.items[1]
end

function TimeLimitData:_getSendItems( type )
	if not self:_hasBuyItem(type) then 
		return {}
	end

	local goods = self:_getGoods(type)
	local ret = {}
	local items = goods.items
	for i=2,#items do
		ret[#ret + 1] = items[i]
	end
	return ret
end

function TimeLimitData:_getTotalValue( type )
	if not self:_hasBuyItem(type) then 
		return 0
	end

	local goods = self:_getGoods(type)

	return goods.rmb / 100
end

function TimeLimitData:_getBuyActualValue( type )
	if not self:_hasBuyItem(type) then 
		return 0
	end
	
	local sendValue = self:_getSendValue(type)

	local goods = self:_getGoods(type)

	return goods.rmb / 100 - sendValue
end

function TimeLimitData:_getBuyDiscountValue( type )
	if not self:_hasBuyItem(type) then 
		return 0
	end
	
	local sendValue = self:_getSendValue(type)

	local goods = self:_getGoods(type)

	return goods.discountRmb / 100
end

function TimeLimitData:_getBuyDiscount( type )
	if not self:_hasBuyItem(type) then 
		return 0
	end

	local buyActualValue = self:_getBuyActualValue(type)

	local buyDiscountValue = self:_getBuyDiscountValue(type)
	
	return buyDiscountValue / buyActualValue
end

function TimeLimitData:_getSendValue( type )
	if not self:_hasBuyItem(type) then 
		return 0
	end

	local payGiftInfo = UserManager:getInstance().payGiftInfo

	return payGiftInfo.showValue
end



TimeLimitPanel = class(BasePanel)

function TimeLimitPanel:create( pos )

	local panel = TimeLimitPanel.new()
	panel:loadRequiredResource("ui/TimeLimitPanel.json")
	panel:init( pos ) 

	return panel
end

function TimeLimitPanel:init( pos )
	
	local payGiftInfo = UserManager:getInstance().payGiftInfo

	self.ui = self:buildInterfaceGroup('timeLimit/panel')
	BasePanel.init(self, self.ui)

	self.showHideAnim = IconPanelShowHideAnim:create(self, pos)

	local closeBtn = self.ui:getChildByName("close")
	closeBtn:setTouchEnabled(true)
	closeBtn:setButtonMode(true)
	closeBtn:addEventListener(DisplayEvents.kTouchTap, function() self:onKeyBackClicked() end)

	local title = self.ui:getChildByName("title")
	title:setText(Localization:getInstance():getText("timeLimit.panel.title"))
	local titleSize = title:getContentSize()
	local titleScale = 65 / titleSize.height
	title:setScale(titleScale)
	local bg = self.ui:getChildByName("bg")
	local bgSize = bg:getGroupBounds().size
	title:setPositionX((bgSize.width - titleSize.width * titleScale) / 2)

	local timeIcon = self.ui:getChildByName("timeIcon")

	local time = self.ui:getChildByName("time")
	time:setDimensions(CCSizeMake(0,0))
	time:setAnchorPoint(ccp(0,0.5))
	time:setPositionY(timeIcon:boundingBox():getMidY())
	
	local function setTimeString( ... )
		local t = TimeLimitData:getInstance():getLeftTime()
		time:setString(string.format("%02d:%02d:%02d",t.hour,t.min,t.sec))	
	end
	time:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(
		CCDelayTime:create(1.0),
		CCCallFunc:create(setTimeString)
	)))
	setTimeString()

	local discount = self.ui:getChildByName("discount")
	discount:getChildByName("num"):setString(
		math.ceil(TimeLimitData:getInstance():getOutgameBuyDicount() * 100) / 10
	)
	discount:getChildByName("text"):setString(
		Localization:getInstance():getText("buy.gold.panel.discount")
	)

	local buyItemBg = self.ui:getChildByName("buyItemBg")
	self:addReward(
		buyItemBg:boundingBox(),
		TimeLimitData:getInstance():getOutgameBuyItem()
	)

	local sendItemBg = self.ui:getChildByName("sendItemBg")
	local sendRect = sendItemBg:boundingBox()
	local sendWidth = sendRect.size.width/3
	local sendItems = TimeLimitData:getInstance():getOutgameSendItems()
	for i=1,3 do
		if i > #sendItems then 
			break
		end

		local rect = CCRectMake(
			sendRect.origin.x + (i-1) * sendWidth,
			sendRect.origin.y,
			sendWidth,
			sendRect.size.height
		)
		self:addReward(rect,sendItems[i])
	end

	self.ui:getChildByName("value"):setString(
		Localization:getInstance():getText("timeLimit.panel.totalValue",{n=timeLimitData:getInstance():getOutgameTotalValue()})
	)

	self.buyButton = self:buildBuyButton()
	self.buyButton:addEventListener(DisplayEvents.kTouchTap, function() self:onbuyClicked() end)
end

function TimeLimitPanel:buildBuyButton( ... )

	local button = ButtonNumberBase:create(self.ui:getChildByName("button"))

	local groupNode = button.groupNode
	local numberSize = groupNode:getChildByName("number2Size")
	local size = numberSize:getContentSize()
	local position = numberSize:getPosition()
	local scaleX = numberSize:getScaleX()
	local scaleY = numberSize:getScaleY()
	
	numberSize:removeFromParentAndCleanup(true)


	local numberRect = {x=position.x, y=position.y, width=size.width*scaleX, height=size.height*scaleY}
	numberLabel = groupNode:getChildByName("number2")

	button:setColorMode(kGroupButtonColorMode.blue)
	button:setString(Localization:getInstance():getText("timeLimit.panel.buy.text"))
	button:setNumber(Localization:getInstance():getText("buy.gold.panel.money.mark") .. TimeLimitData:getInstance():getOutgameBuyDiscountValue())

	numberLabel:setText(Localization:getInstance():getText("buy.gold.panel.money.mark") .. TimeLimitData:getInstance():getOutgameBuyActualValue())
	InterfaceBuilder:centerInterfaceInbox( numberLabel, numberRect )

	return button
end

function TimeLimitPanel:addReward(rect,item)
	
 	local reward = ResourceManager:sharedInstance():buildItemSprite(item.itemId)

 	local rewardBounds = reward:getGroupBounds()

 	local numberLabel = BitmapText:create("x" .. tostring(item.num),"fnt/target_amount.fnt")
 	numberLabel:setAnchorPoint(ccp(1,0))
 	numberLabel:setPositionX(rewardBounds:getMaxX())
 	numberLabel:setPositionY(0)
 	numberLabel:setScale(1.2)

 	reward:addChild(numberLabel)

 	reward:setAnchorPoint(ccp(0.5,0.5))
 	reward:setPositionX(rect:getMidX())
 	reward:setPositionY(rect:getMidY())

 	reward:setScale(rect.size.height / 140)
 	
 	self.ui:addChild(reward)

end

function TimeLimitPanel:onbuyClicked( ... )

	if __ANDROID then 

		self.buyButton:setEnabled(false)

		local goodsId = timeLimitData:getInstance():getOutgameGoodsId()
		local ingamePaymentLogic = IngamePaymentLogic:create(goodsId)

		local function successCallback( ... )
			TimeLimitData:getInstance():setBought()
			DcUtil:UserTrack({ category = 'activity', sub_category = 'buy_main_interface'})
			self:onCloseBtnTapped()
		end
		local function failCallback( ... )
			CommonTip:showTip(
				Localization:getInstance():getText("add.step.panel.buy.fail.android"), 
				"negative"
			)
			self.buyButton:setEnabled(true)	
		end
		local function cancelCallback( ... )
			self.buyButton:setEnabled(true)		
		end

		if AndroidPayment.getInstance():getDefaultSmsPayment() ~= Payments.CHINA_MOBILE then
			failCallback()
			self:onCloseBtnTapped()
		else
			ingamePaymentLogic:buy(successCallback, failCallback, cancelCallback, true)
		end
	end

end

function TimeLimitPanel:popout()

	PopoutManager:sharedInstance():addWithBgFadeIn(self, true, false, false)
	local function onFinish() self.allowBackKeyTap = true end
	self.showHideAnim:playShowAnim(onFinish)

end

function TimeLimitPanel:onCloseBtnTapped()

	local function hidePanelCompleted()
		PopoutManager:sharedInstance():removeWithBgFadeOut(self, false)
	end
	self.allowBackKeyTap = false
	self.showHideAnim:playHideAnim(hidePanelCompleted)
end