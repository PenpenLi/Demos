require "zoo.panel.basePanel.BasePanel"
require "zoo.baseUI.ButtonWithShadow"

PropInfoPanel = class(BasePanel)

-- local InGamePropsId = {
-- 	10001,10010,10002,10003,10004,10005, 10052
-- }

function PropInfoPanel:create(panelType, levelId)
	local panel = PropInfoPanel.new()
	panel:loadRequiredResource(PanelConfigFiles.panel_buy_prop)
	if panel:init(panelType, levelId) then
		return panel
	else
		panel = nil
		return nil
	end
end

function PropInfoPanel:init(panelType, levelId)
	FrameLoader:loadArmature( "skeleton/tutorial_animation" )

	panelType = panelType or 2
	if panelType ~= 1 and panelType ~= 2 then return false end
	if panelType == 1 and not levelId then return false end

	-- 初始化数据
	self.exitCallback = nil

	-- 初始化面板
	self.panel = self:buildInterfaceGroup("PropInfoPanel")
	BasePanel.init(self, self.panel)

	-- 获取控件
	self.bg = self.panel:getChildByName("yellowBg")
	self.panelTitle = self.panel:getChildByName("panelTitle")
	self.panelBtn = self.panel:getChildByName("panelBtn")
	self.panelBtn = GroupButtonBase:create(self.panelBtn)

	-- 屏幕适配
	local wSize = CCDirector:sharedDirector():getWinSize()
	local vSize = CCDirector:sharedDirector():getVisibleSize()
	local vOrigin = CCDirector:sharedDirector():getVisibleOrigin()
	self.background = LayerGradient:create()
	self.background:changeWidthAndHeight(vSize.width, vSize.height)
	self.background:setStartColor(ccc3(255, 216, 119))
    self.background:setEndColor(ccc3(247, 187, 129))
    self.background:setStartOpacity(255)
    self.background:setEndOpacity(255)
    self.background:ignoreAnchorPointForPosition(false)
    self.background:setAnchorPoint(ccp(0, 1))
    local index = self.panel:getChildIndex(self.bg)
    self.panel:addChildAt(self.background,index)
	local backgroundSize = self.background:getContentSize()
	local bgSize = self.bg:getGroupBounds().size
	self.bg:setPositionX((vSize.width - bgSize.width) / 2)
	self.bg:setPreferredSize(CCSizeMake(bgSize.width, backgroundSize.height - 217)) -- upper 81, lower 136
	bgSize = self.bg:getGroupBounds().size
	self.panelBtn:setPositionY(68 - vSize.height)

	-- 设置文字（需要更新本地化文件）
	self.panelTitle:setText(Localization:getInstance():getText("prop.info.panel.title"))
	local size = self.panelTitle:getContentSize()
	local scale = 65 / size.height
	self.panelTitle:setScale(scale)
	self.panelTitle:setPositionX((vSize.width - size.width * scale) / 2)
	self.panelBtn:setString(Localization:getInstance():getText("prop.info.panel.close.txt"))

	-- 添加遮罩（可动区域）
	local listVHeight = bgSize.height - 40
	self.clippingNode = ClippingNode:create(CCRectMake(0, 0, bgSize.width - 40, listVHeight))
	self.clippingNode:setPosition(ccp(self.bg:getPositionX() + 25, self.bg:getPositionY() - 20 - listVHeight))
	self:addChild(self.clippingNode)
	self.propVisualList = Layer:create()
	self.propVisualList:setPosition(ccp(0, listVHeight))
	self.clippingNode:addChild(self.propVisualList)

	-- 设置道具说明列表
	self:buildPropComment(panelType)
	self.propComment:setPositionX((bgSize.width - 55 - self.propComment:getGroupBounds().size.width) / 2)
	self.propVisualList:addChild(self.propComment)
	self.listHeight = -self.propComment:getGroupBounds().size.height
	if panelType == 1 then
		local metaModel = MetaModel:sharedInstance()
		local metaManager = MetaManager.getInstance()
		local levelModeTypeId = metaModel:getLevelModeTypeId(levelId)
		local initialProps = metaManager.gamemode_prop[levelModeTypeId].initProps

		for __, v in ipairs(initialProps) do
			if not ItemType:isTimeProp(v) then
				self:buildPropListItem(v)
			end
		end
	else
		local metaModel = MetaModel:sharedInstance()
		local metaManager = MetaManager.getInstance()
		local levelModeTypeId = metaModel:getLevelModeTypeId(levelId)
		local InGamePropsId = metaManager.gamemode_prop[levelModeTypeId].ingameProps
		for __, v in ipairs(InGamePropsId) do
			if not ItemType:isTimeProp(v) then
				self:buildPropListItem(v)
			end
		end
	end
	for i = 1, #self.propList do
		self.propList[i]:setPosition(ccp((bgSize.width - 40 - self.propList[i]:getGroupBounds().size.width) / 2, self.listHeight))
		self.propVisualList:addChild(self.propList[i])
		self.listHeight = self.listHeight - self.propList[i].height
		print(self.listHeight)
	end	

	-- 设置互动事件监听
	local function onPanelBtnTapped()
		self:onCloseBtnTapped()
	end
	self.panelBtn:addEventListener(DisplayEvents.kTouchTap, onPanelBtnTapped)

	local function checkTouchArea(positionY)
		local pos = ccp(0, -listVHeight - 70)
		pos = self:convertToWorldSpace(ccp(0, pos.y))
		return not (positionY > pos.y + listVHeight or positionY < pos.y)
	end

	local function onTouchBegin(evt)
		self.propVisualList:stopAllActions()
		self.lastY = evt.globalPosition.y
		self.disableListening = not checkTouchArea(self.lastY)
	end
	local function onTouchMove(evt)
		if self.disableListening then return end
		local nowPos = self.propVisualList:getPosition().y
		local deltaY = evt.globalPosition.y - self.lastY
		if nowPos < listVHeight then
			if math.abs(listVHeight - nowPos) > 10 then
				deltaY = deltaY / ((listVHeight - nowPos) / 10)
			end
		elseif nowPos + self.listHeight > 0 then
			if math.abs(nowPos + self.listHeight) > 10 then
				deltaY = deltaY / ((nowPos + self.listHeight) / 10)
			end
		end
		self.propVisualList:runAction(CCMoveBy:create(0, ccp(0, deltaY)))
		self.lastY = evt.globalPosition.y
	end
	local function onTouchEnd(evt)
		self.propVisualList:stopAllActions()
		local nowPos = self.propVisualList:getPosition().y
		if nowPos < listVHeight then
			self.propVisualList:runAction(CCMoveTo:create(0.2, ccp(0, listVHeight)))
		elseif nowPos + self.listHeight > 0 then
			self.propVisualList:runAction(CCMoveTo:create(0.2, ccp(0, -self.listHeight)))
		end
		self.lastY = nil
		print(nowPos, self.listHeight)
	end
	if -self.listHeight > listVHeight then
		self.propVisualList:setTouchEnabled(true)
		self.propVisualList:ad(DisplayEvents.kTouchBegin, onTouchBegin)
		self.propVisualList:ad(DisplayEvents.kTouchMove, onTouchMove)
		self.propVisualList:ad(DisplayEvents.kTouchEnd, onTouchEnd)
	end
	local function onPlayClick(evt)
		if not checkTouchArea(evt.globalPosition.y) then return end
		for __, v in ipairs(self.propList) do
			if v.curtain == evt.target then v:playAnime()
			else v:stopAnime() end
		end
	end
	for __, v in ipairs(self.propList) do
		v.curtain:setTouchEnabled(true)
		v.curtain:ad(DisplayEvents.kTouchTap, onPlayClick)
	end

	return true
end

function PropInfoPanel:onCloseBtnTapped()
	if self.exitCallback then self.exitCallback() end
	self.allowBackKeyTap = false
	PopoutManager:sharedInstance():remove(self, true)
	CCTextureCache:sharedTextureCache():removeTextureForKey(CCFileUtils:sharedFileUtils():fullPathForFilename("skeleton/tutorial_animation/texture.png"))
end

function PropInfoPanel:popout()
	PopoutManager:sharedInstance():add(self, true, false)
	self.allowBackKeyTap = true
end

function PropInfoPanel:setExitCallback(callback)
	self.exitCallback = callback
end

function PropInfoPanel:buildPropComment(commentType)
	self.propComment = self:buildInterfaceGroup("propComment" .. commentType)
	if commentType == 1 then
		self.comment = self.propComment:getChildByName("comment")
		-- 设置文字（需要更新本地化文件）
		self.comment:setString(Localization:getInstance():getText("prop.info.panel.list1"))
	else
		self.comment1 = self.propComment:getChildByName("comment1")
		self.comment2 = self.propComment:getChildByName("comment2")
		-- 设置文字（需要更新本地化文件）
		self.comment1:setString(Localization:getInstance():getText("prop.info.panel.list3"))
		self.comment2:setString(Localization:getInstance():getText("prop.info.panel.list4"))
	end
end

function PropInfoPanel:buildPropListItem(propId)
	local propListItem = self:buildInterfaceGroup("PropListItem")
	propListItem.propIconPlaceholder = propListItem:getChildByName("propIconPlaceholder")
	propListItem.propName = propListItem:getChildByName("propName")
	propListItem.propDesc = propListItem:getChildByName("propDesc")
	propListItem.animePlaceholder = propListItem:getChildByName("animePlaceholder")
	propListItem.curtain = propListItem:getChildByName("curtain")
	propListItem.btnPlay = propListItem:getChildByName("btnPlay")
	propListItem.btnPlayText = propListItem.btnPlay:getChildByName("text")

	-- 设置文字（需要更新本地化文件）
	print(propId)
	local propName = Localization:getInstance():getText("prop.name."..propId)
	propListItem.propName:setString(propName)
	propListItem.propDesc:setString(Localization:getInstance():getText("level.prop.tip."..propId, {n = "\n"}))
	local sprite = ResourceManager:sharedInstance():buildItemGroup(propId)
	local pos = propListItem.propIconPlaceholder:getPosition()
	sprite:setPosition(ccp(pos.x - 5, pos.y + 5))
	sprite:setScale(0.7)
	propListItem.propIconPlaceholder:getParent():addChild(sprite)
	propListItem.propIconPlaceholder:removeFromParentAndCleanup(true)
	propListItem.btnPlayText:setString(Localization:getInstance():getText("prop.info.panel.anim.play"))

	-- 添加动画
	propListItem.animation = CommonSkeletonAnimation:creatTutorialAnimation(propId)
	local ac = propListItem.animation:getAnchorPoint()
	propListItem.animation:setAnchorPoint(ccp(0, 1))
	pos = propListItem.animePlaceholder:getPosition()
	size = propListItem:getGroupBounds().size
	propListItem.height = size.height
	propListItem.animation:setPosition(ccp(pos.x, pos.y))
	propListItem.animePlaceholder:getParent():addChildAt(propListItem.animation, 0)
	print(size.width, size.height)
	propListItem.animePlaceholder:removeFromParentAndCleanup(true)
	propListItem.animePlaceholder = nil

	propListItem.playAnime = function()
		propListItem.curtain:setVisible(false)
		propListItem.btnPlay:setVisible(false)
		propListItem.animation:playAnimation()
	end
	propListItem.stopAnime = function()
		propListItem.animation:stopAnimation()
		propListItem.curtain:setVisible(true)
		propListItem.btnPlay:setVisible(true)
	end

	if not self.propList then self.propList = {} end
	table.insert(self.propList, propListItem)
end

function PropInfoPanel:getHCenterInScreenX(...)
	assert(#{...} == 0)

	local visibleSize	= CCDirector:sharedDirector():getVisibleSize()
	local visibleOrigin	= CCDirector:sharedDirector():getVisibleOrigin()
	local selfWidth		= 722

	local deltaWidth	= visibleSize.width - selfWidth
	local halfDeltaWidth	= deltaWidth / 2

	return visibleOrigin.x + halfDeltaWidth
end