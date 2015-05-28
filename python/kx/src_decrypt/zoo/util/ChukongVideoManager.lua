
ChukongVideoManager = {}
local instance = nil
local CHANGSI_DC_ID = "changsi"
function ChukongVideoManager:init()
	
	if not instance then
		waxClass{"ChukongAdManager", NSObject}
		instance = ChukongAdManager:getInstance()
	end
end

local animationLoading = nil
local function buildCallbackIos( onQuitCallback, onCheckLegalCallback, noAdCallback )
	-- body
	waxClass{"ChukongDelegate",NSObject, protocols = {"ChukongDelegate"}}
	function ChukongDelegate:getVideoADError()
		if animationLoading then animationLoading:removeFromParentAndCleanup() animationLoading = nil end
		DcUtil:requestFailAdVideo( CHANGSI_DC_ID )
		noAdCallback()
	end

	function ChukongDelegate:getVideoADSuccess()
		if animationLoading then animationLoading:removeFromParentAndCleanup() animationLoading = nil end
		DcUtil:requestSuccessAdVideo( CHANGSI_DC_ID )
		-- onQuitCallback(false,true)
	end

	function ChukongDelegate:showVideoAdError()
		onQuitCallback(false,true)
		GamePlayMusicPlayer:getInstance():onceResumeBackgroundMusic()
	end

	function ChukongDelegate:showVideoAdSuccess()
		GamePlayMusicPlayer:getInstance():oncePauseBackgroundMusic()
	end

	function ChukongDelegate:cancelPlayVideo()
		onQuitCallback(false,true)
		GamePlayMusicPlayer:getInstance():onceResumeBackgroundMusic()
	end

	function ChukongDelegate:showVideoAdFinish()
		onCheckLegalCallback(true)
		GamePlayMusicPlayer:getInstance():onceResumeBackgroundMusic()
	end

	local callbackDelete = ChukongDelegate:init()
	return callbackDelete

end

function ChukongVideoManager:videoAdPlay( onQuitCallback, onCheckLegalCallback, noAdCallback )
	-- body
	print("chukong videoAdPlay")
	DcUtil:requestAdVideo( CHANGSI_DC_ID )
	if not animationLoading then
		local scene = Director:sharedDirector():getRunningScene()
		animationLoading = CountDownAnimation:createActivityAnimation(scene)	
	end
	local delete = buildCallbackIos(onQuitCallback, onCheckLegalCallback, noAdCallback)
	instance:videoAdPlay(delete)
end

ChukongVideoManager:init()

