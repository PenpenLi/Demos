QQStarRewardLogic = class()

local instance = nil

function QQStarRewardLogic:getInstance()
	if not instance then
		instance = QQStarRewardLogic.new()
	end
	return instance
end

function QQStarRewardLogic:init(homeScene)
	self.homeScene = homeScene

	local visibleSize	= CCDirector:sharedDirector():getVisibleSize()
	local visibleOrigin	= CCDirector:sharedDirector():getVisibleOrigin()
	local topScreenPosY 	= visibleOrigin.y + visibleSize.height
	local rightScreenPosX	= visibleOrigin.x + visibleSize.width

	self.needShowGuide = true

	local platform = UserManager.getInstance().platform
	local uid = UserManager.getInstance().uid
	if (not uid) or uid == "" then
		uid = "12345"
	end
	local fileKey = "QQStarRewardFileKey_" .. tostring(platform) .. "_u_".. tostring(uid) .. ".ds"
	local localData = Localhost:readFromStorage(fileKey)
	if not localData then
		localData = {needShowGuide = true}
	end

	self.localData = localData
	self.fileKey = fileKey
	self.needShowGuide = localData.needShowGuide
	--self.needShowGuide = true
	
	self.homeScene.qqStarRewardButton = QQStarRewardButton:create(self.homeScene , self.needShowGuide)
	self.homeScene:addChild(self.homeScene.qqStarRewardButton) 
	local qqStarRewardBtnSize	= self.homeScene.qqStarRewardButton.wrapper:getGroupBounds().size
	self.homeScene.qqStarRewardButton:setPosition(  
		ccp(rightScreenPosX - qqStarRewardBtnSize.width - 120 , visibleOrigin.y + qqStarRewardBtnSize.height + 250 )   )

	
	self.homeScene.qqStarRewardButton:onInitPosition()	

	local function onTotalStarNumberChange()
		self.homeScene.qqStarRewardButton:updateRewardState()
	end
	self.homeScene:addEventListener(HomeSceneEvents.USERMANAGER_TOTAL_STAR_NUMBER_CHANGE, onTotalStarNumberChange)
	
	onTotalStarNumberChange()
end

function QQStarRewardLogic:setNeedShowGuideState()
	self.localData.needShowGuide = false
	Localhost:writeToStorage( self.localData , self.fileKey )
end

function QQStarRewardLogic:createFalseButton()

	if self.needShowGuide then
		local starRewardButton = StarRewardButton:create()
		self.falseButton = starRewardButton
		self.homeScene.leftRegionLayoutBar:addItem(starRewardButton)

		local starRewardBtnPos 			= starRewardButton:getPosition()
		local starRewardBtnParent		= starRewardButton:getParent()
		local starRewardBtnPosInWorldSpace	=starRewardBtnParent:convertToWorldSpace(ccp(starRewardBtnPos.x, starRewardBtnPos.y))

		local starRewardBtnSize	= starRewardButton.wrapper:getGroupBounds().size

		starRewardBtnPosInWorldSpace.x = starRewardBtnPosInWorldSpace.x + starRewardBtnSize.width / 2
		starRewardBtnPosInWorldSpace.y = starRewardBtnPosInWorldSpace.y - starRewardBtnSize.height / 2

		self.starRewardBtnPosInWorldSpace = starRewardBtnPosInWorldSpace

		self.homeScene.qqStarRewardButton:checkShowGudie()
	end
end

function QQStarRewardLogic:playFalseButtonFlyAnime(callback)
	if self:isOldUser() then
		
		self:setNeedShowGuideState()

		local flyButton = StarRewardButton:create()
		self.homeScene:addChild(flyButton)
		local buttonSize = flyButton:getGroupBounds().size
		--racsh.carsh()
		if not self.starRewardBtnPosInWorldSpace then
			self.starRewardBtnPosInWorldSpace = ccp(30 , 500)
		end
		flyButton:setPosition(ccp( self.starRewardBtnPosInWorldSpace.x - (buttonSize.width/2) , 
			self.starRewardBtnPosInWorldSpace.y + (buttonSize.height/2) ))

		local action2Callback = function()
			if self.falseButton then self.homeScene.leftRegionLayoutBar:removeItem(self.falseButton) end
			flyButton:removeFromParentAndCleanup(true)
			if callback and type(callback) == "function" then
				callback()
			end
		end

		local action1Callback = function()
			local anim2 = CCArray:create()
			anim2:addObject( CCFadeTo:create(0.5, 0) )
			anim2:addObject( CCCallFunc:create(action2Callback) )

			flyButton.wrapper:getChildByName("bg"):runAction( CCSequence:create(anim2) )
		end

		local tarPosition = self.homeScene.qqStarRewardButton:getPosition()

		local anim = CCArray:create()
		anim:addObject( CCEaseSineOut:create( CCMoveTo:create(1.5, ccp(tarPosition.x,tarPosition.y - 100))  ) )
		anim:addObject( CCCallFunc:create(action1Callback) )

		if self.falseButton then self.falseButton:setVisible(false) end

		flyButton:runAction( CCSequence:create(anim) )
	else
		if callback and type(callback) == "function" then
			callback()
		end
	end	
end

function QQStarRewardLogic:isOldUser()
	--local dateData=os.date("*t",os.time())
	local enabletime = os.time({day=13,month=7,year=2015,hour=0,min=0,sec=0})--今天零点的时间
	local createtime = tonumber(UserManager.getInstance().mark.createTime)/1000--注册日零点
	return enabletime > createtime
end