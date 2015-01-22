require 'zoo.panel.component.bubbleTip.BubbleTip'
require 'zoo.panelBusLogic.UsePropsLogic'
require 'zoo.panelBusLogic.SellLogic'
require 'zoo.panel.CommonTip'
require 'zoo.panel.UpdateNewVersionPanel'


-------------------- LOCAL FUNCTIONS --------------------
local function buildBtnLabel(ui, labelName, fontSizeName, labelString)
	local label = ui:getChildByName(labelName)
	local labelRect = ui:getChildByName(fontSizeName)

	local newLabel = TextField:createWithUIAdjustment(labelRect, label)
	newLabel.name = labelName
	newLabel:setString(labelString)
	ui:addChild(newLabel)
end




local tipInstance = nil

local function disposeTip()
	if tipInstance then 
		tipInstance:hide()
		tipInstance:dispose()
		tipInstance = nil
	end
end

local function showTip(rect, content, propsId)

	disposeTip()

	tipInstance = BubbleTip:create(content, propsId)
	tipInstance:show(rect)
end







---------------- PAGE RENDERER CLASS -----------------

PageRenderer = class(BaseUI)

function PageRenderer:create(groupName, pageSize, drawUnlockButton)
	local instance = PageRenderer.new()
	instance:loadRequiredResource(PanelConfigFiles.bag_panel_ui)
	instance:init(groupName, pageSize, drawUnlockButton)
	return instance
end

function PageRenderer:loadRequiredResource(panelConfigFile)
	self.panelConfigFile = panelConfigFile
	self.builder = InterfaceBuilder:create(panelConfigFile)
end

function PageRenderer:init(groupName, pageSize, drawUnlockButton)


	self.ui = self.builder:buildGroup(groupName)--ResourceManager:sharedInstance():buildGroup(groupName)

	assert(self.ui)

	BaseUI.init(self, self.ui)
	self.ui:getChildByName('bg'):setOpacity(0)


	local maxSize = 20


	-- self.pageSize = 18 -- every page is simply 18 boxes plus a unlock button!
	self.pageSize = pageSize
	self.showUnlockBtn = drawUnlockButton -- show unlock on every page

	self.itemBoxes = {}
	-- set visible according to the page size
	for i=1, self.pageSize do 
		local ib = self.ui:getChildByName('item'..i)
		ib:setVisible(true)
		table.insert(self.itemBoxes, ib)
		-- ib:getChildByName('icon'):setVisible(false)
		ib:getChildByName('txt'):setVisible(false)
		ib:getChildByName('txt_fontSize'):setVisible(false)
	end 

	-- set the rest invisible
	for i=self.pageSize+1, maxSize do
		local ib = self.ui:getChildByName('item'..i)
		ib:setVisible(false)
	end

	if self.showUnlockBtn then
		local btn = self.ui:getChildByName('unlockButton')
		btn:getChildByName('txt'):setString(Localization:getInstance():getText('bag.panel.unlock', {}))
		btn:setVisible(true)
		btn:setTouchEnabled(true, 0, false)
		btn:addEventListener(DisplayEvents.kTouchTap, 
		                     function (event)
		                     	self:onUnlockButtonTap(event)
		                     end,
		                     self)
	else 
		local btn = self.ui:getChildByName('unlockButton')
		btn:setVisible(false)
		btn:removeEventListenerByName(DisplayEvents.kTouchTap)
	end


	return true
end

function PageRenderer:setItems(items)
-- items = {{id = xxx, quantity = xxx}, ...}

	assert(items)
	assert(#items <= self.pageSize)

	for i=1, #items do
		self:showBoxIcon(i, 0, 0)
		self:showBoxIcon(i, items[i].itemId, items[i].num)
	end
	for j=#items + 1, self.pageSize do 
		self:showBoxIcon(j, 0, 0)
	end
end

function PageRenderer:setItemAt(index, item)
	assert(item)
	assert(item.itemId)
	assert(item.num >= 0)
	assert(index <= self.pageSize)

	self:showBoxIcon(index, item.itemId, item.num)
end


function PageRenderer:showBoxIcon(index, propsId, quantity)
	assert(index > 0)
	assert(index <= self.pageSize)
	assert(propsId)

	local ib = self.itemBoxes[index]
	local txt = ib:getChildByName('txt')
	local fontSize = ib:getChildByName('txt_fontSize')
	local newLabel = TextField:createWithUIAdjustment(fontSize, txt)
	-- createWithUIAdjustment will remove txt from parent
	-- SO use newLabel to replace txt
	txt = newLabel
	newLabel.name = 'txt'
	ib:addChild(newLabel)

	if quantity == 0 then 
		ib:setTouchEnabled(false)
		ib:removeEventListenerByName(DisplayEvents.kTouchTap)
		txt:setVisible(false)
		if ib.ui then ib.ui:removeFromParentAndCleanup(true) end
		return 
	end

	-------------------------------------
	-- ignore bad IDs
	-- if  propsId <= 10000 
	-- 	or (propsId >=10016 and propsId <= 10017)
	-- 	or (propsId >= 10020 and propsId <= 10024) 
	-- 	or propsId == 10028
	-- 	or (propsId >= 10030 and propsId ~= 10039)
	-- then
	-- 	-- no good...
	-- 	return

	-- end 
	-- if not BagManager:isValideItemId(propsId) then return end

	local isWenHao = not BagManager:isValideItemId(propsId)
	
	local ui = nil
	if isWenHao then
		ui = ResourceManager:sharedInstance():buildGroup('Prop_wenhao')
	else
		ui = ResourceManager:sharedInstance():buildItemGroup(propsId)
	end
	txt:setVisible(true)
	txt:setString(quantity)
	-- make the icon to fit into the box
	ui:setScale(0.8)
	local outSize = ib:getGroupBounds().size
	local innerSize = ui:getGroupBounds().size
	-- center the icon in the box
	ui:setPosition(ccp((outSize.width - innerSize.width) / 2, 0 - (outSize.height - innerSize.height) / 2))

	if ib.ui ~= nil then ib.ui:removeFromParentAndCleanup(true) end

	ib:addChild(ui)
	ib.ui = ui

	ib:setTouchEnabled(true, 0, false)
	ib:addEventListener(DisplayEvents.kTouchTap, 
	                      function(event)
	                      		self:onItemTap(event)
	                      end, 
	                      {index = index, propsId = propsId, isWenHao = isWenHao })
	-- make sure that txt is above the icon
	txt:removeFromParentAndCleanup(false)
	ib:addChild(txt)
end


function PageRenderer:onItemTap(event)
	-- show tips
	assert(event.context)
	local index = event.context.index
	local propsId = event.context.propsId
	local isWenHao = event.context.isWenHao
	local ib = self.itemBoxes[index]

	local originSize = ib.ui:getGroupBounds().size
	local enlargeRestoreAction = EnlargeRestore:create(ib.ui, originSize, 1.25, 0.1, 0.1)
	if ib.ui:numberOfRunningActions() == 0 then
		ib.ui:runAction(enlargeRestoreAction)
	end

	if isWenHao then
		if NewVersionUtil:hasPackageUpdate() then 
			local panel = UpdatePageagePanel:create(
				ib:getPositionInWorldSpace(),
				Localization:getInstance():getText("new.version.tip.bag")
			) --UpdateNewVersionPanel:create()
			panel:popout()
		end
	else 
		self:showTip(ib,propsId)
	end

end
function PageRenderer:showTip(ib,propsId)

	local content = self.builder:buildGroup('bagItemTipContent')--ResourceManager:sharedInstance():buildGroup('bagItemTipContent')
	local desc = content:getChildByName('desc')
	local title = content:getChildByName('title')
	local sellBtn = GroupButtonBase:create(content:getChildByName('sellButton'))
	local useBtn = GroupButtonBase:create(content:getChildByName('useButton'))

	local function canUseItem(itemId)
		if itemId == 10012 or itemId == 10013 or itemId == 10014 or itemId == 10039
		then 
			return true
		else 
			return false
		end
	end

	local canUse = canUseItem(propsId)
	local canSell = false -- CURRENTLY: not supported



	title:setString(Localization:getInstance():getText("prop.name."..propsId))
	local originSize = desc:getDimensions()
	originSize = {width = originSize.width, height = originSize.height}
	desc:setDimensions(CCSizeMake(originSize.width, 0))
	desc:setString(Localization:getInstance():getText("level.prop.tip."..propsId, {n = "\n", replace1 = 1}))
	local descSize = desc:getContentSize()
	descSize = {width = descSize.width, height = descSize.height}
	-- descSize.height = math.max(descSize.height, originSize.height)

	sellBtn:setVisible(false)
	sellBtn:setEnabled(false)
	sellBtn:setColorMode(kGroupButtonColorMode.orange)

	useBtn:setVisible(false)
	useBtn:setEnabled(false)
	useBtn:setColorMode(kGroupButtonColorMode.green)

	if canSell then 
		sellBtn:setVisible(true)
		-- sellBtn:setButtonMode(true)
		sellBtn:setEnabled(true)
		sellBtn:addEventListener(DisplayEvents.kTouchTap, function(event) self:onSellBtnTapped(event) end, propsId )
		sellBtn:setString(Localization:getInstance():getText('bag.panel.button.sell', {}))
	end

	if canUse then
		local boxPosition = ib:convertToWorldSpace(ccp(ib:getPosition().x, ib:getPosition().y))


		useBtn:setVisible(true) 
		-- useBtn:setButtonMode(true)
		useBtn:setEnabled(true)
		useBtn:addEventListener(DisplayEvents.kTouchTap, function(event) self:onUseBtnTapped(event) end, {propsId = propsId, pos = boxPosition} )
		-- buildBtnLabel(useBtn, 'txt', 'txt_fontSize', Localization:getInstance():getText('bag.panel.button.use', {}))
		useBtn:setString(Localization:getInstance():getText('bag.panel.button.use', {}))
	end

	local btnPosY = desc:getPositionY() - descSize.height - 40
	sellBtn:setPositionY(btnPosY)
	useBtn:setPositionY(btnPosY)

	if canSell and not canUse then 
		local contSize = content:getGroupBounds().size
		sellBtn:setPositionX(contSize.width / 2)
	elseif not canSell and canUse then
		local contSize = content:getGroupBounds().size
		useBtn:setPositionX(contSize.width / 2)
	elseif not canSell and not canUse then
		useBtn:removeFromParentAndCleanup(true)
		sellBtn:removeFromParentAndCleanup(true)
	end	


	showTip(ib:getGroupBounds(), content, propsId)
end

function PageRenderer:onUnlockButtonTap(event)
	-- print('unlock button clicked')

	local function callback(success, event)
		if self.buyUnlockCallbackFunc then
			self.buyUnlockCallbackFunc(success, event)
		end
	end

	BagManager:getInstance():buyUnlock(callback)
end

function PageRenderer:dispose()
	CocosObject.dispose(self)
	disposeTip()
end

function PageRenderer:setBuyUnlockCallbackFunc(callbackFunc)
	self.buyUnlockCallbackFunc = callbackFunc
end

function PageRenderer:setSellCallbackFunc(callbackFunc)
	self.sellCallbackFunc = callbackFunc
end

function PageRenderer:setUseCallbackFunc(callbackFunc)
	self.useCallbackFunc = callbackFunc
end

function PageRenderer:onSellBtnTapped(event)
	local propsId = event.context

	local amount = 1
	local sellLogic = SellLogic:create(propsId, amount)

	local function onSuccess()
		-- print 'sell success'
		disposeTip()
		self.sellCallbackFunc(true)
	end

	local function onFail()
		-- print 'sell failed'
		disposeTip()
		self.sellCallbackFunc(false)
	end

	local showLoading = true
	sellLogic:start(onSuccess, onFail, showLoading)

end

function PageRenderer:onUseBtnTapped(event)
	local propsId = event.context.propsId
	local position = event.context.pos
	local isTempProps = false
	local levelId = 0
	local param = nil 
	local itemLIst = {propsId}

	local function onSuccess()
		local anim = HomeScene:sharedInstance():createFlyingEnergyAnim(false)
		if anim then

			local visibleOrigin = Director:sharedDirector():getVisibleOrigin()
			local visibleSize = Director:sharedDirector():getVisibleSize()
			anim:setPosition(ccp(visibleOrigin.x + visibleSize.width / 2, visibleOrigin.y + visibleSize.height / 2))

			anim:playFlyToAnim()
		end
		disposeTip()
		self.useCallbackFunc(true)
	end 
	local function onFail()
		disposeTip()
		self.useCallbackFunc(false)
	end


	if UserEnergyRecoverManager:isEnergyFull() and propsId ~= 10039 then
		disposeTip()
		CommonTip:showTip(Localization:getInstance():getText('energy.panel.energy.is.full', {}), 1, nil)
	else
		local type = ItemType.SMALL_ENERGY_BOTTLE
		if propsId == 10012 then
			type = ItemType.SMALL_ENERGY_BOTTLE
		elseif propsId == 10013 then
			type = ItemType.MIDDLE_ENERGY_BOTTLE
		elseif propsId == 10014 then
			type = ItemType.LARGE_ENERGY_BOTTLE
		elseif propsId == 10039 then
			type = ItemType.INFINITE_ENERGY_BOTTLE
		end

		local logic = UseEnergyBottleLogic:create(type)
		logic:setSuccessCallback(onSuccess)
		logic:start(true)
		local scene = HomeScene:sharedInstance()
		local button = scene.energyButton
		scene:checkUserEnergyDataChange()
		button:updateView()
	end


end






