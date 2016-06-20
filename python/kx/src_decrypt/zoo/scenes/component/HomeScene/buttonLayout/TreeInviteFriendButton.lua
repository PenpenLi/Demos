
TreeInviteFriendButton = class(BaseUI)

function TreeInviteFriendButton:ctor()
	
end

function TreeInviteFriendButton:init()
	self.ui	= ResourceManager:sharedInstance():buildGroup("treeInviteFriendBtn")
	BaseUI.init(self, self.ui)

	self.bgNormal = self.ui:getChildByName("bg1")
	self.bgLight = self.ui:getChildByName("bg2")
	self.iconLight = self.ui:getChildByName("iconLight")

	local wrapperSize = self.bgNormal:getContentSize()
	self.wrapper = LayerColor:create()
    self.wrapper:setColor(ccc3(255,0,0))
    self.wrapper:setOpacity(0)
    self.wrapper:setContentSize(CCSizeMake(wrapperSize.width, wrapperSize.height))
    self.wrapper:setPosition(ccp(-wrapperSize.width/2, 0))
	self.wrapper:setTouchEnabled(true, 0, true)
	self.ui:addChild(self.wrapper)

	self:update()
end

function TreeInviteFriendButton:update()
	-- self.bgLight:setVisible(false)	
	self.iconLight:setVisible(false)
end

function TreeInviteFriendButton:create()
	local btn = TreeInviteFriendButton.new()
	btn:init()
	return btn	
end