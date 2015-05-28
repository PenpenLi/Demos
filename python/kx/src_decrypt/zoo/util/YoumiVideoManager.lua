
YoumiVideoManager = {}
local instance = nil
local YOUMI_APP_ID = "9098b387db33e356"
local YOUMI_APP_SECRET = "20aa2d2e22cf792e"
local YOUMI_DC_ID = "youmi"
function YoumiVideoManager:init()
	
	if not instance then
		waxClass{"YoumiAdManager", NSObject}
		instance = YoumiAdManager:getInstance()
		instance:initAppinfo(YOUMI_APP_ID, YOUMI_APP_SECRET)
	end
end

local function buildCallbackIos( onQuitCallback, onCheckLegalCallback, onCheckHaveAdCallback )
	-- body
	waxClass{"YoumiDelegate",NSObject, protocols = {"YoumiDelegate"}}
	function YoumiDelegate:onQuitCallback( result )
		-- body
		print("youmi onQuitCallback ".."   isFinish = ")
		print(result)
		if onQuitCallback then 
			onQuitCallback(result, true)
		end
		GamePlayMusicPlayer:getInstance():onceResumeBackgroundMusic()
	end

	function YoumiDelegate:onCheckLegalCallback( result )
		-- body
		if onCheckLegalCallback then
			onCheckLegalCallback(result)
		end
	end

	function YoumiDelegate:onCheckHaveAdCallback( result )
		-- body
		if onCheckHaveAdCallback then
			onCheckHaveAdCallback(result)
		end
	end
	local callbackDelete = YoumiDelegate:init()
	return callbackDelete

end

function YoumiVideoManager:checkHaveAd( onCheckHaveAdCallback)
	-- body
	local delete = buildCallbackIos(nil, nil, onCheckHaveAdCallback)
	instance:checkHaveAd(delete)
end

local animationLoading = nil
function YoumiVideoManager:videoAdPlay( onQuitCallback, onCheckLegalCallback, noAdCallback )
	-- body
	local function isHasAdCallback(value)
		print("Youmi video have ad state = "..value)
		onQuitCallback(false, false)
		if value and value == 0 then
			DcUtil:requestSuccessAdVideo( YOUMI_DC_ID )
			GamePlayMusicPlayer:getInstance():oncePauseBackgroundMusic()
			instance:videoAdPlay(buildCallbackIos(onQuitCallback, onCheckLegalCallback, nil))
		else
			DcUtil:requestFailAdVideo( YOUMI_DC_ID )
			noAdCallback()
		end
		if animationLoading then animationLoading:removeFromParentAndCleanup() animationLoading = nil end
	end
	
	DcUtil:requestAdVideo( YOUMI_DC_ID )
	if not animationLoading then
		local scene = Director:sharedDirector():getRunningScene()
		animationLoading = CountDownAnimation:createActivityAnimation(scene)	
	end
	instance:checkHaveAd(buildCallbackIos(nil, nil, isHasAdCallback))
end

function YoumiVideoManager:isForceLandscape(isForce)
	instance:isForceLandscape(isForce)

end

function YoumiVideoManager:closeButtonHide()
	instance:closeButtonHide()
end

local version = AppController:getSystemVersion() or 5
if version and version >= 6 then   --ios 6 以下的不支持
	YoumiVideoManager:init()
end

-- YoumiVideoManager:isForceLandscape(false)
-- YoumiVideoManager:closeButtonHide()

