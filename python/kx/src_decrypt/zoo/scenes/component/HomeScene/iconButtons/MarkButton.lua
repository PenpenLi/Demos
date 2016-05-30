
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2014年01月 6日 17:06:42
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

---------------------------------------------------
-------------- MarkButton
---------------------------------------------------

assert(not MarkButton)
assert(IconButtonBase)
MarkButton = class(IconButtonBase)

function MarkButton:ctor()
	self.idPre = "MarkButton"
    self.playTipPriority = 40
end
function MarkButton:playHasNotificationAnim(...)
    IconButtonManager:getInstance():addPlayTipNormalIcon(self)
end
function MarkButton:stopHasNotificationAnim(...)
    IconButtonManager:getInstance():removePlayTipNormalIcon(self)
end


function MarkButton:init(...)
	assert(#{...} == 0)
	self.id = self.idPre .. self.tipState
	self["tip"..IconTipState.kNormal] = Localization:getInstance():getText("mark.panel.btn.has.sign.tip")
	
	self.ui	= ResourceManager:sharedInstance():buildGroup("finalSignIcon")
	self.icon = self.ui:getChildByName("wrapper")
	self.timerText = self.ui:getChildByName("timer")
	self.label = self.ui:getChildByName("label")

	local icon = self.icon:getChildByName("bg")
	local icon_tw = self.icon:getChildByName("bg_tw")
	if icon and icon_tw then 
		icon:setVisible(not _G.useTraditionalChineseRes)
		icon_tw:setVisible(_G.useTraditionalChineseRes)
	end
	local size = self.icon:getGroupBounds().size
	self.iconGB = {width = size.width, height = size.height}

	-- Init Base Class
	--BaseUI.init(self, self.ui)
	IconButtonBase.init(self, self.ui)
	IconButtonBase.setTipString(self, self["tip"..IconTipState.kNormal])

	local index, time = MarkModel:getInstance():getCurrentIndexAndTime()
	if index ~= 0 then
		self.label:setVisible(false)
		self.timerText:setString(string.format("%02d:%02d:%02d", tostring(math.floor(time / 3600)), tostring(math.floor(time % 3600 / 60)), tostring(math.floor(time % 60))))
		local tSize = self.timerText:getContentSize()
		self.timerText:setPositionX((self.iconGB.width - 20 - tSize.width) / 2)
	else
		self.label:setVisible(true)
		self.timerText:setString("")
	end
	local function refresh(evt) self:onRefresh(evt) end
	MarkModel:getInstance():addEventListener(kMarkEvents.kPriseTimer, refresh)
	self.removeListeners = function(self)
		MarkModel:getInstance():removeEventListener(kMarkEvents.kPriseTimer, refresh)
	end
end

function MarkButton:onRefresh(evt)
	if self.isDisposed then return end
	local time = evt.data
	if type(time) ~= "number" or time <= 0 then
		self.label:setVisible(true)
		self.timerText:setString("")
	else
		self.label:setVisible(false)
		self.timerText:setString(string.format("%02d:%02d:%02d", tostring(math.floor(time / 3600)), tostring(math.floor(time % 3600 / 60)), tostring(math.floor(time % 60))))
		local tSize = self.timerText:getContentSize()
		self.timerText:setPositionX((self.iconGB.width - 20 - tSize.width) / 2)
	end

end

function MarkButton:create(...)
	assert(#{...} == 0)

	local newMarkButton = MarkButton.new()
	newMarkButton:init()
	return newMarkButton
end

function MarkButton:dispose()
	self:removeListeners()
	IconButtonBase.dispose(self)
end

function MarkButton:playHasSignAnimation()
	self:playHasNotificationAnim()
end

function MarkButton:stopHasSignAnimation()
	self:stopHasNotificationAnim()
end