
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2014Äê01ÔÂ11ÈÕ 11:26:37
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

---------------------------------------------------
-------------- TreeTopLockedCloud
---------------------------------------------------

assert(not TreeTopLockedCloud)
assert(BaseUI)
TreeTopLockedCloud = class(BaseUI)

function TreeTopLockedCloud:init(...)
	assert(#{...} == 0)

	-------------------
	-- Init Base Class
	-- ---------------
	BaseUI.init(self, false)

	-- ----------------
	-- Create Wait Cloud
	-- -------------------
	-- self.waitedCloud	= Clouds:buildWait()
	self.waitedCloud = Clouds:buildStatic()
	
	-- Set Self Texture
	local texture = self.waitedCloud:getTexture()
	self:setTexture(texture)
	self:addChild(self.waitedCloud)
	self.waitedCloud:setScale(1.5)

	local cloudSize	= self:getGroupBounds(self).size
	self.waitedCloud:setPosition(ccp(cloudSize.width/2, -cloudSize.height/2))
end

function TreeTopLockedCloud:playAnim(...)
	assert(#{...} == 0)

	if self.isOpened then
		return 
	end
	self.isOpened = true

	-- ----------
	-- Create Lock
	-- -----------
	local manualAdjustLockPosY	= 50
	self.lock = Clouds:buildLock()
	self.lock:setPositionY(self.lock:getPositionY() + manualAdjustLockPosY)
	self.waitedCloud:addChild(self.lock)

	-------------------
	-- Create Text
	-- --------------
	local fontName		= "Helvetica"
	local fontSize		= 20
	local dimensions	= CCSizeMake(350, 100)
	self.desLabel		= TextField:create("", fontName, fontSize, dimensions)
	self.desLabel:setColor(ccc3(78, 125, 161))
	local desLabelKey	= "unlock.cloud.new.area.lock"
	local desLabelValue	= Localization:getInstance():getText(desLabelKey, {})
	self.desLabel:setString(desLabelValue)
	self.waitedCloud:addChild(self.desLabel)
	local manualAdjustDesPosY	= -50
	self.desLabel:setPositionY(manualAdjustDesPosY)

	self.lock:stop()
	-- self.waitedCloud:wait()
end

function TreeTopLockedCloud:create(...)
	assert(#{...} == 0)

	local newTreeTopLock = TreeTopLockedCloud.new()
	newTreeTopLock:init()
	return newTreeTopLock
end
