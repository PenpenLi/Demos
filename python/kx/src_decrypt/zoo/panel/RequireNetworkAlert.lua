require "zoo.net.PostLoginLogic"
require "zoo.panel.CommonTip"

-------------------------------------------------------------------------
--  Class include: RequireNetworkAlert
-------------------------------------------------------------------------
kRequireNetworkAlertAnimation = {kDefault=0, kSync=1, kNoAnimation=2}

local function userLoginCheckLogic(scene, onCompleteFunc, animationType)
	local animation
	local layer = nil
	local timeoutID = nil
	local logic = PostLoginLogic.new()
	local responsed = false

	local function stopTimeout()
		if timeoutID ~= nil then CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(timeoutID) end
		print("userLoginCheckLogic:: stop timeout check")
	end
	local function removePopout()
		stopTimeout()
		if animation then animation:removeFromParentAndCleanup(true) end
		if layer then
			-- layer:removeFromParentAndCleanup(true)
			PopoutManager:sharedInstance():remove(layer)
		end
	end
	local function onCloseButtonTap( evt )
		if evt then evt.target:rma() end
		logic:rma()
		removePopout()
	end
	
	local function onRegisterError( evt )
		responsed = true
		if evt then evt.target:removeAllEventListeners() end
		print("post register error")
		removePopout()

		if animationType == kRequireNetworkAlertAnimation.kDefault then
			-- local item = RequireNetworkAlert.new(CCNode:create())
			-- item:buildUI(Localization:getInstance():getText("dis.connect.warning.tips"))
			-- if scene and scene.rootLayer then scene:addChild(item) end
			CommonTip:showTip(Localization:getInstance():getText("dis.connect.warning.tips"))
		end
	end
	local function onRegisterFinish( evt )
		responsed = true
		evt.target:removeAllEventListeners()
		print("post register finish")
		removePopout()
		if onCompleteFunc ~= nil then onCompleteFunc() end
	end 
	local function onTimeout()
		if not responsed and  animationType == kRequireNetworkAlertAnimation.kDefault then
			if layer then layer.onKeyBackClicked = function() removePopout() end end
			animation = CountDownAnimation:createNetworkAnimation(scene, onCloseButtonTap)
		end
		print("timeout @ userLoginCheckLogic")
		stopTimeout()
	end
	if animationType == kRequireNetworkAlertAnimation.kSync then animation = CountDownAnimation:createSyncAnimation() end
	print("--------------begin post user login logic.")
	if animationType == kRequireNetworkAlertAnimation.kDefault then
		local wSize = Director:sharedDirector():getWinSize()
	  	local scene = Director:sharedDirector():getRunningScene()
	  	layer = LayerColor:create()
	  	layer:changeWidthAndHeight(wSize.width, wSize.height)
	  	layer:setTouchEnabled(true, 0, true)
	  	layer:setOpacity(0)
	  	PopoutManager:sharedInstance():add(layer, false, false)
	  	-- scene:addChild(layer)
	end
	timeoutID = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(onTimeout,1,false)
	logic:addEventListener(Events.kComplete, onRegisterFinish)
	logic:addEventListener(Events.kError, onRegisterError)
	logic:load()
	return false
end

--
-- RequireNetworkAlert ---------------------------------------------------------
--
RequireNetworkAlert = class(CocosObject)
function RequireNetworkAlert:popout(onCompleteFunc, animationType)
	if animationType == nil then animationType = kRequireNetworkAlertAnimation.kDefault end

	local scene = Director:sharedDirector():getRunningScene()
	if scene then 
		if __IOS then
			if ReachabilityUtil.getInstance():isNetworkAvailable() then 
				--network available
				if _G.kUserLogin then return true
				else return userLoginCheckLogic(scene, onCompleteFunc, animationType) end
			else
				if _G.kUserLogin then return true
				else
					local kDebugLoading = NetworkConfig.noNetworkMode
					if kDebugLoading then return userLoginCheckLogic(scene, onCompleteFunc, animationType)
					else
						if animationType == kRequireNetworkAlertAnimation.kDefault then
							--only ios have the network status, display a alert
							-- local item = RequireNetworkAlert.new(CCNode:create())
							-- item:buildUI(Localization:getInstance():getText("dis.connect.warning.tips"))
							-- scene:addChild(item)
							CommonTip:showTip(Localization:getInstance():getText("dis.connect.warning.tips")) 
						end
						return false
					end
				end
			end
		else
			if _G.kUserLogin then return true
			else return userLoginCheckLogic(scene, onCompleteFunc, animationType) end
		end
	end
	return false
end

function RequireNetworkAlert:buildUI(message)
	local wSize = Director:sharedDirector():getWinSize()
	local vSize = Director:sharedDirector():getVisibleSize()
	local vOrigin = Director:sharedDirector():getVisibleOrigin()

	self:setPosition(ccp(vOrigin.x, vOrigin.y))

	local function onAnimationFinished() self:removeFromParentAndCleanup(true) end
	local container = CocosObject:create()
	local panel = ResourceManager:sharedInstance():buildGroup("panel_require_swape")
	local targetSize = panel:getGroupBounds().size
	local label = panel:getChildByName("label")
	label:setString(message or "")
	label:setFontSize(30)
	panel:setPosition(ccp(-targetSize.width/2, targetSize.height/2 + 100))
	container:addChild(panel)
	container:setPosition(ccp(vSize.width/2, vSize.height/2))

	local panelChildren = {}
	panel:getVisibleChildrenList(panelChildren)
	for i,child in ipairs(panelChildren) do
		local array = CCArray:create()
		array:addObject(CCFadeIn:create(0.1))
		array:addObject(CCDelayTime:create(1.5))
		array:addObject(CCFadeOut:create(0.06))
		child:setOpacity(0)
		child:runAction(CCSequence:create(array))
	end

	local seq = CCArray:create()
	seq:addObject(CCEaseElasticOut:create(CCMoveBy:create(0.1, ccp(0, -100)))) 
	seq:addObject(CCDelayTime:create(1.5))
	seq:addObject(CCCallFunc:create(onAnimationFinished))
	panel:runAction(CCSequence:create(seq))

	self:addChild(container)
end