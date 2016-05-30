require "zoo.panel.ChooseFriendPanel"

ChooseNotiFriendPanel = class(ChooseFriendPanel)

function ChooseNotiFriendPanel:ctor()
	self.shareNotiList = nil
end

function ChooseNotiFriendPanel:init(onConfirmCallback, exceptIds, shareNotiList)
	self.shareNotiList = shareNotiList
	self.exceptIds = exceptIds
	-- 初始化视图
	self.ui = self:buildInterfaceGroup("ChooseFriendPanel")
	BasePanel.init(self, self.ui)
	local vSize = CCDirector:sharedDirector():getVisibleSize()
	local panelSize = self.ui:getGroupBounds().size
	local scaleX = vSize.width / panelSize.width
	local scaleY = vSize.height / panelSize.height
	if scaleX > scaleY then scaleX = scaleY end
	print("panelSize",scaleX)
	self.ui:setScale(scaleX)
	-- self:setPosition(ccp(self:getHCenterInScreenX(), 0))
	self:setPositionForPopoutManager()

	-- 获取控件
	self.closeBtn = self.ui:getChildByName("closeBtn")
	self.captain = self.ui:getChildByName("captain")
	self.btnAdd = self.ui:getChildByName("btnAdd")
	self.btnAdd = ButtonIconsetBase:create(self.btnAdd) 
	
	self.btnAdd:setString(Localization:getInstance():getText("message.center.send.request"))
	self.ui:getChildByName("avatar"):removeFromParentAndCleanup(true)

	-- 替换标题
	local charWidth = 65
	local charHeight = 65
	local charInterval = 57
	local fntFile = "fnt/caption.fnt"
	if _G.useTraditionalChineseRes then fntFile = "fnt/zh_tw/caption.fnt" end
	local position = self.captain:getPosition()
	self.newCaptain = LabelBMMonospaceFont:create(charWidth, charHeight, charInterval, fntFile)
	self.newCaptain:setAnchorPoint(ccp(0,1))
	self.newCaptain:setString(Localization:getInstance():getText("message.center.select.friends"))
	self.newCaptain:setPosition(ccp(position.x, position.y))
	self:addChild(self.newCaptain)
	self.newCaptain:setToParentCenterHorizontal()
	self.captain:removeFromParentAndCleanup(true)

	local listBg = self.ui:getChildByName("Layer 2")
	local listSize = listBg:getContentSize()
	local listPos = listBg:getPosition()
	local listHeight = listSize.height - 30

	self.listBg = listBg
	self.listSize = listSize
	self.listPos = listPos
	self.listHeight = listHeight	

	self:buildGridLayout()

	-- 添加事件监听
	local function onCloseTapped()
		self:onKeyBackClicked()
	end
	self.closeBtn:setTouchEnabled(true)
	self.closeBtn:setButtonMode(true)
	self.closeBtn:ad(DisplayEvents.kTouchTap, onCloseTapped)

	local function onBtnAddTapped()
		local selectedFriendsID = self.content:getSelectedFriendID()
		PopoutManager:sharedInstance():remove(self, true)
		if onConfirmCallback ~= nil then onConfirmCallback(selectedFriendsID) end
	end
	self.btnAdd:addEventListener(DisplayEvents.kTouchTap, onBtnAddTapped)


	return true
end

function ChooseNotiFriendPanel:onItemSelectChange() 
	return true
end

function ChooseNotiFriendPanel:create(onConfirmCallback,shareNotiList)
	local panel = ChooseNotiFriendPanel.new()
	panel:loadRequiredResource(PanelConfigFiles.AskForEnergyPanel)
	if panel:init(onConfirmCallback, {}, shareNotiList) then
		print("return true, panel should been shown")
		return panel
	else
		print("return false, panel's been destroyed")
		panel = nil
		return nil
	end
end