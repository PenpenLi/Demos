
local Title = class(EventDispatcher)

Title.Events = {
	kBackTap = "backTap"
}

function Title:create( ui,hasBackLink )
	local title = Title.new()
	title:init(ui,hasBackLink)
	return title
end

function Title:init( ui,hasBackLink )
	self.ui = ui
	self.titleText = self.ui:getChildByName("text")
	self.titleText:setVerticalAlignment(kCCVerticalTextAlignmentCenter)

	self:setHasBackLink(hasBackLink)

	ui:addEventListener(Events.kDispose,function( ... )
		self:removeAllEventListeners()
	end)
end

function Title:setText( text )
	self.ui:getChildByName("text"):setString(text)
end

function Title:setHasBackLink( hasBackLink )
	local backLink = self.ui:getChildByName("back")

	backLink:setTouchEnabled(true)
	backLink:setButtonMode(true)
	backLink:addEventListener(DisplayEvents.kTouchTap, function( ... )
		if backLink:isVisible() then 
			self:dispatchEvent(Event.new(Title.Events.kBackTap, nil, self))
		end
	end)

	if hasBackLink then
		backLink:setVisible(true)
		backLink:setChildrenVisible(true,false)

		local backLinkText = backLink:getChildByName("text")
		backLinkText:setVerticalAlignment(kCCVerticalTextAlignmentCenter)
		backLinkText:setString("<" .. Localization:getInstance():getText("login.panel.button.4")) --返回
	else
		backLink:setVisible(false)
		backLink:setChildrenVisible(false,false)
	end

end

return Title