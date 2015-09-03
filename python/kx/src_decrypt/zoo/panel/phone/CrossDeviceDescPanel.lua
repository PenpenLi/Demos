local Button = require "zoo.panel.phone.Button"
local Title = require "zoo.panel.phone.Title"

CrossDeviceDescPanel = class(BasePanel)

function CrossDeviceDescPanel:create(  )
	local panel = CrossDeviceDescPanel.new()
	panel:loadRequiredResource("ui/login.json")	
	panel:init()
	return panel
end

function CrossDeviceDescPanel:init( ... )
	self.ui = self:buildInterfaceGroup("CrossDeviceDescPanel")
	BasePanel.init(self, self.ui)

	local title = Title:create(self.ui:getChildByName("title"),false)
	title:setText(Localization:getInstance():getText("login.panel.title.6")) --"跨设备登陆说明"

	local closeBtn = self.ui:getChildByName("closeBtn")
	closeBtn:setTouchEnabled(true)
	closeBtn:addEventListener(DisplayEvents.kTouchTap,function( ... )
		self:remove()

		if self.cancelCallback then
			self.cancelCallback()
		end
	end)

	local desc = self.ui:getChildByName("desc")
	-- desc:setDimensions(CCSizeMake(0,0))
	desc:setString(Localization:getInstance():getText("login.panel.warning.1",{n="\n"}))
	--local desc2 = self.ui:getChildByName("desc2")
	--desc2:setString(Localization:getInstance():getText("login.panel.intro.17"))

	local errorTip = self.ui:getChildByName("errorTip")
	errorTip:setString(Localization:getInstance():getText("login.panel.warning.3"))
	errorTip:setVisible(false)

	local checkBox = self.ui:getChildByName("checkBox")
	function checkBox:isCheck( ... )
		return self:getChildByName("iconCheck"):isVisible()
	end
	checkBox:getChildByName("iconCheck"):setVisible(false)
	checkBox:setTouchEnabled(true)
	checkBox:addEventListener(DisplayEvents.kTouchTap,function( ... )
		if not checkBox:isCheck() then
			errorTip:setVisible(false)
		end
		checkBox:getChildByName("iconCheck"):setVisible(not checkBox:isCheck())
	end)


	local tipConcact = self.ui:getChildByName("tipConcact")
	tipConcact:setString(Localization:getInstance():getText("login.panel.warning.2"))

	local okBtn = Button:create(self.ui:getChildByName("okBtn"))
	okBtn:setText("确定")
	okBtn:addEventListener(DisplayEvents.kTouchTap,function ( ... )
		if not checkBox:isCheck() then
			errorTip:setVisible(true)
			CommonTip:showTip(Localization:getInstance():getText("login.panel.warning.4"), "negative", nil, 3)
			return
		end

		self:remove()

		if self.okCallback then 
			self.okCallback()
		end
	end)
end

function CrossDeviceDescPanel:popout( ... )

	PopoutManager:sharedInstance():add(self,true,false)

	local visibleSize = Director.sharedDirector():getVisibleSize()
	local visibleOrigin = Director:sharedDirector():getVisibleOrigin()

	local bounds = self.ui:getChildByName("bg"):getGroupBounds()

	if visibleSize.height < bounds.size.height then
		self.ui:setScale(visibleSize.height / bounds.size.height)
		bounds = self.ui:getChildByName("bg"):getGroupBounds()
	end

	self.position = ccp(
		visibleSize.width/2 - bounds.size.width/2,
		-visibleSize.height/2 + bounds.size.height/2
	)
	self:setPositionX(self.position.x)
	self:setPositionY(self.position.y)

end

function CrossDeviceDescPanel:remove( ... )
	PopoutManager:sharedInstance():remove(self)
end

-- function CrossDeviceDescPanel:onKeyBackClicked()
-- 	PopoutManager:sharedInstance():remove(self)
-- end

function CrossDeviceDescPanel:setOkCallback( okCallback )
	self.okCallback = okCallback
end
function CrossDeviceDescPanel:setCancelCallback( cancelCallback )
	self.cancelCallback = cancelCallback
end

