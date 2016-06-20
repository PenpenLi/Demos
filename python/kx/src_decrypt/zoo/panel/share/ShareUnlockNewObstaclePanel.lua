require 'zoo.panel.share.ShareBasePanel'
require 'zoo.panel.quickselect.QuickTableView'

ShareUnlockNewObstaclePanel = class(ShareBasePanel)

function ShareUnlockNewObstaclePanel:ctor()

end

function ShareUnlockNewObstaclePanel:init()
	FrameLoader:loadImageWithPlist("flash/quick_select_level.plist")
	FrameLoader:loadImageWithPlist("flash/quick_select_animation.plist")

	--初始化文案内容
	ShareBasePanel.init(self)

	self.level = self.achiManager:getData(self.achiManager.LEVEL)
	self:runBearAction()
	self:runTreeAction()
	self:initObstacle()

	local flower = self.ui:getChildByName("flower")
	flower:setAnchorPointWhileStayOriginalPosition(ccp(0.5, 0.5))
	--flower:setPositionY(flower:getPositionY() + 10)
	flower:setOpacity(0)

	local flowerLight = self.ui:getChildByName("flowerLight")
	flowerLight:setAnchorPointWhileStayOriginalPosition(ccp(0.5, 1.0))
	flowerLight:setOpacity(0)
end

function ShareUnlockNewObstaclePanel:createObstacle()
	local animateConfig = nil
	local obstacleConfig = require "zoo.PersonalCenter.ObstacleIconConfig"
    local index = obstacleConfig[self.level]
    
	for _,config in ipairs(QuickSelectAnimation) do
		if config.id == index then
			animateConfig = config
			break
		end
	end

	local sprite

	if animateConfig and CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("area_animation_"..index.."_0000") then
		sprite = Sprite:createWithSpriteFrameName("area_animation_"..index.."_0000")
		local frames = SpriteUtil:buildFrames("area_animation_"..index.."_%04d", 0, animateConfig.frameNum)
		local animate = SpriteUtil:buildAnimate(frames, 1/24)
		sprite:play(animate)
	elseif CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("area_icon_"..index.."0000") then
		sprite = Sprite:createWithSpriteFrameName("area_icon_"..index.."0000")
	end

	return sprite
end

function ShareUnlockNewObstaclePanel:initObstacle()
	local obstacleGroup = self.ui:getChildByName("obstacle")
	local obstacle_pos = obstacleGroup:getChildByName("obstacle")
	obstacle_pos:setVisible(false)
	obstacle_pos:setAnchorPointWhileStayOriginalPosition(ccp(0.5, 0.5))
	local pos = obstacle_pos:getPosition()
	local o_size = obstacle_pos:getGroupBounds().size

	local obstacle = self:createObstacle()
	if obstacle then
		local origin_size = obstacle:getContentSize()
		obstacle:setScale((o_size.width - 40) / origin_size.width)
		obstacle:setPosition(ccp(pos.x, pos.y))
		obstacleGroup:addChild(obstacle)
	end

	local size = obstacleGroup:getGroupBounds().size
	obstacleGroup:setContentSize(CCSizeMake(size.width, size.height))
	obstacleGroup:setVisible(false)
	obstacleGroup:ignoreAnchorPointForPosition(false)
	obstacleGroup:setAnchorPointWhileStayOriginalPosition(ccp(0.5, 0))
	obstacleGroup:setPositionY(obstacleGroup:getPositionY() - size.height + 250)

	for _,c in ipairs(obstacleGroup:getChildrenList()) do
		c:setAnchorPointWhileStayOriginalPosition(ccp(0.5, 0.5))
		local y = c:getPositionY()
		c:setPositionY(-y)
	end
end

function ShareUnlockNewObstaclePanel:runBearAction()
	local bear = self.ui:getChildByName("bear")
	bear:setAnchorPointWhileStayOriginalPosition(ccp(0.5, 0))
	bear:setOpacity(0)
	bear:setScale(0)

	bear:runAction(CCFadeIn:create(0.3))

	local function flowerAction()
		self:runFlowerAction()
	end

	local arr = CCArray:create()
	arr:addObject(CCScaleTo:create(0.3, 1.0))
	arr:addObject(CCScaleTo:create(0.2, 1.0, 0.8))
	arr:addObject(CCCallFunc:create(flowerAction))
	arr:addObject(CCScaleTo:create(0.2, 1.0))
	bear:runAction(CCSequence:create(arr))
end

function ShareUnlockNewObstaclePanel:runTreeAction()
	local tree = self.ui:getChildByName("tree")
	local parent = tree:getParent()
	tree:removeFromParentAndCleanup(false)

	local time = CCProgressTimer:create(tree.refCocosObj)
	time:setAnchorPoint(ccp(0,1))
	local pos = tree:getPosition()
	time:setPosition(ccp(pos.x, pos.y))
	parent:addChild(CocosObject.new(time))

	time:setType(kCCProgressTimerTypeBar)
	time:setMidpoint(ccp(0, 1))
	time:setBarChangeRate(ccp(1, 0))
	time:setPercentage(0)

	time:runAction(CCProgressTo:create(0.4, 100))
	tree:dispose()
end

function ShareUnlockNewObstaclePanel:runFlowerAction()
	local flower = self.ui:getChildByName("flower")
	local flowerLight = self.ui:getChildByName("flowerLight")

	flower:runAction(CCFadeIn:create(0.2))
	flowerLight:runAction(CCFadeIn:create(0.2))

	local arr = CCArray:create()
	arr:addObject(CCScaleTo:create(0.2, 2.8, 1.6))
	arr:addObject(CCScaleTo:create(0.2, 1.6, 1.6))
	arr:addObject(CCScaleTo:create(0.1, 1.5, 1.6))
	arr:addObject(CCScaleTo:create(0.05, 1.55, 1.6))
	arr:addObject(CCScaleTo:create(0.05, 1.6, 1.6))
	local seq = CCSequence:create(arr)
	flower:runAction(seq)

	local arr1 = CCArray:create()
	arr1:addObject(CCScaleTo:create(0.2, 2.8, 1.4))
	arr1:addObject(CCScaleTo:create(0.2, 1.4, 1.4))
	arr1:addObject(CCScaleTo:create(0.1, 1.3, 1.4))
	arr1:addObject(CCScaleTo:create(0.05, 1.35, 1.4))
	arr1:addObject(CCScaleTo:create(0.05, 1.4, 1.4))

	local function obstacleAction()
		self:runObstacleAction()
	end

	local arr2 = CCArray:create()
	arr2:addObject(CCScaleTo:create(0.05, 1.0, 1.4))
	arr2:addObject(CCFadeOut:create(0.05))
	arr2:addObject(CCCallFunc:create(obstacleAction))
	arr1:addObject(CCSpawn:create(arr2))
	flowerLight:runAction(CCSequence:create(arr1))
end

function ShareUnlockNewObstaclePanel:runObstacleAction()
	local obstacleGroup = self.ui:getChildByName("obstacle")
	obstacleGroup:setVisible(true)

	obstacleGroup:setScale(0.3)
	obstacleGroup:runAction(CCMoveBy:create(0.2, ccp(0, -200)))
	obstacleGroup:runAction(CCFadeIn:create(0.2))

	local arr = CCArray:create()
	arr:addObject(CCScaleTo:create(0.2, 1.0, 0.7))
	arr:addObject(CCScaleTo:create(0.05, 1.0, 1.0))
	arr:addObject(CCScaleTo:create(0.05, 1.0, 0.8))
	arr:addObject(CCScaleTo:create(0.05, 1.0, 1.0))
	local seq = CCSequence:create(arr)
	obstacleGroup:runAction(seq)

	local light = obstacleGroup:getChildByName("light")
	light:runAction(CCRepeatForever:create(CCRotateBy:create(0.5, 40)))

	FrameLoader:loadArmature('skeleton/personal_center_guide')
    self.animNode = ArmatureNode:create("personal_center_guide")
    self.animNode:setScale(2.0)
    local pos = obstacleGroup:getChildByName("buble"):getPosition()
    self.animNode:setAnchorPoint(ccp(0.5, 0.5))
    self.animNode:setPosition(ccp(pos.x - 12, pos.y + 35))
    obstacleGroup:addChild(self.animNode)
    self.animNode:playByIndex(0, 1)
end

function ShareUnlockNewObstaclePanel:getShareTitleName()
	local level = self.achiManager:getData(self.achiManager.LEVEL)
	return Localization:getInstance():getText(self.shareTitleKey,{num = level})
end

function ShareUnlockNewObstaclePanel:dispose( ... )
	BasePanel.dispose(self)
	FrameLoader:unloadImageWithPlists(
		{
		"flash/quick_select_level.plist",
	 	"flash/quick_select_animation.plist"
	 	}, true)
end

function ShareUnlockNewObstaclePanel:create(shareId)
	local panel = ShareUnlockNewObstaclePanel.new()
	panel:loadRequiredResource("ui/NewSharePanelEx.json")

	local panelRes = "ShareUnlockNewObstaclePanel"
	local size = Director:sharedDirector():getVisibleSize()
	if size.width / size.height > 0.6 then
		panelRes = "ShareUnlockNewObstaclePanel1"
	end

	panel.ui = panel:buildInterfaceGroup(panelRes)
	panel.shareId = shareId
	panel:init()
	return panel
end

function ShareUnlockNewObstaclePanel:beforeSrnShot(srnShot, afterSrnShot)
	local function moreAdjust()
		self:loadSpecialBackground()
	    self.obstacle = self:createObstacle()
	    self.obstacle:setPositionXY(475, 410)
	    if _G.__use_small_res == true then
	    	self.obstacle:setScale(0.625)
	    end
	    self.ui:addChildAt(self.obstacle, 3)

		if srnShot then
			srnShot()
		end
		if afterSrnShot then
			afterSrnShot()
		end
	end
	ShareBasePanel.beforeSrnShot(self, moreAdjust)
end

function ShareUnlockNewObstaclePanel:afterSrnShot()
	if self.obstacle then
   		self.obstacle:removeFromParentAndCleanup(true)
   	end
   	self:unloadSpecialBackground()
end