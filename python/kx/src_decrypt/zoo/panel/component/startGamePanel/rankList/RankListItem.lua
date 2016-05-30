

-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013年09月12日 16:33:31
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

---------------------------------------------------
-------------- RankListItem
---------------------------------------------------

assert(not RankListItem)
assert(BaseUI)
RankListItem = class(BaseUI)

function RankListItem:init(ui, ...)
	assert(ui)
	assert(#{...} == 0)

	-- Init Base Class
	BaseUI.init(self, ui)

	-- ---------------
	-- Get UI Reousece
	-- -----------------
	self.rankLabel		= self.ui:getChildByName("rankLabel")
	self.userNameLabel	= self.ui:getChildByName("userNameLabel")
	self.userScoreLabel	= self.ui:getChildByName("userScoreLabel")

	self.goldCrown		= self.ui:getChildByName("goldCrown")
	self.silverCrown	= self.ui:getChildByName("silverCrown")
	self.brassCrown		= self.ui:getChildByName("brassCrown")
	self.rankLabelBg	= self.ui:getChildByName("rankLabelBg")

	self.userIconPlaceholder= self.ui:getChildByName("userIconPlaceholder")

	assert(self.rankLabel)
	assert(self.userNameLabel)
	assert(self.userScoreLabel)

	assert(self.goldCrown)
	assert(self.silverCrown)
	assert(self.brassCrown)
	assert(self.rankLabelBg)

	assert(self.userIconPlaceholder)

	----------------------
	-- Init UI Component
	-- ------------------
	self.goldCrown:setVisible(false)
	self.silverCrown:setVisible(false)
	self.brassCrown:setVisible(false)
	--self.highLightBg:setVisible(false)

	----------------------
	-- Add Event Listener
	-- ------------------
	local function headDisposed(...)
		self.headDisposed = true
	end
	self.userIconPlaceholder:ad(Events.kDispose, headDisposed)

	-- 活动中需要修改UI，自己头像上需要加一个装饰，在此特殊处理
	-- 搜索用关键字：useSpecialActivityUI
	self.headDeco = self.ui:getChildByName("headdeco")
end

function RankListItem:setData(rank, userName, userScore, headUrl, isSelf, ...)
	assert(type(rank) 	== "number")
	assert(type(userName)	== "string")
	assert(type(userScore)	== "number")
	assert(#{...} == 0)

	self.rankLabel:setVisible(true)
	self.rankLabelBg:setVisible(true)
	
	self.rankLabel:setString(tostring(rank))
	self.userNameLabel:setString(HeDisplayUtil:urlDecode(userName))
	self.userScoreLabel:setString(tostring(userScore))

	if self.headUrl ~= headUrl then
		self.headUrl = headUrl
		if headUrl ~= nil then
			if self.clipping then self.clipping:removeFromParentAndCleanup(true) end
			local function onImageLoadFinishCallback(clipping)
				if not self.userIconPlaceholder or self.userIconPlaceholder.isDisposed then return end
				if self.headDisposed then return end
				local holderSize = self.userIconPlaceholder:getContentSize()
				local clippSize = clipping:getContentSize()
				local scale = holderSize.width / clippSize.width
				clipping:setScale(scale*0.83)
				clipping:setPosition(ccp(holderSize.width/2-2 , holderSize.height/2+3))
				self.clipping = clipping
				self.userIconPlaceholder:addChild(self.clipping)
			end
			HeadImageLoader:create(userName, headUrl, onImageLoadFinishCallback)
		else
			if self.clipping then self.clipping:removeFromParentAndCleanup(true) end
			self.clipping = nil
		end
	end
	-- 活动中需要修改UI，自己头像上需要加一个装饰，在此特殊处理
	-- 搜索用关键字：useSpecialActivityUI
	if self.headDeco then
		self.headDeco:setVisible(isSelf)
	end

	if rank >= 1 and rank <= 3 then

		self.rankLabel:setVisible(false)
		self.rankLabelBg:setVisible(false)

		if rank == 1 then
			self.goldCrown:setVisible(true)
		elseif rank == 2 then
			self.silverCrown:setVisible(true)
		elseif rank == 3 then
			self.brassCrown:setVisible(true)
		end
	end
end

function RankListItem:create(ui, ...)
	assert(ui)
	assert(#{...} == 0)

	local newItem = RankListItem.new()
	newItem:init(ui)
	return newItem
end
