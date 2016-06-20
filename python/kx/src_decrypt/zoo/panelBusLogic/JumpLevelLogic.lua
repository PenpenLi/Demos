require "zoo.panelBusLogic.AdvanceTopLevelLogic"
require "zoo.panelBusLogic.UpdateLevelScoreLogic"
JumpLevelLogic = class()
function JumpLevelLogic:create( level, levelType, onSuccessCallback, onFailCallback )
	-- body
	local logic = JumpLevelLogic.new()
	logic:init(level, levelType, onSuccessCallback, onFailCallback)
	return logic
end

function JumpLevelLogic:init( level, levelType, onSuccessCallback, onFailCallback )
	-- body
	self.levelId = level
	self.levelType = levelType
	self.onSuccessCallback = onSuccessCallback
	self.onFailCallback = onFailCallback
end

function JumpLevelLogic:start( ... )
	-- body
	local function sendRequestSuccess( data )
		-- body
		self.pawnNum = data.pawnNum
		UserManager:getInstance().lastPassedLevel = self.levelId
		--update ingredient num
		UserManager:getInstance():addUserPropNumber(ItemType.INGREDIENT, -self.pawnNum)
		UserService:getInstance():addUserPropNumber(ItemType.INGREDIENT, -self.pawnNum)
		-----------------------
		-- Update Level Score
		-- ---------------------
		local updateLevelScoreLogic = UpdateLevelScoreLogic:create(self.levelId, 
			self.levelType, 0, 0 )
		updateLevelScoreLogic:start()

		----------------------------------
		--update jump info
		-------------------------------
		local jumpLevelRef = JumpLevelRef.new()
		jumpLevelRef.levelId = self.levelId
		jumpLevelRef.pawnNum = self.pawnNum
		UserManager:getInstance():addJumpLevelInfo(jumpLevelRef)
		
		-- ------------------------------------
		-- Check If It's A New Completed Level
		-- ----------------------------------
		local advanceTopLevelLogic = AdvanceTopLevelLogic:create(self.levelId)
		advanceTopLevelLogic:start()

		-- ------------------------------------
		--刷新藤蔓上icon位置 包括星星奖励 邀请好友
		-- ------------------------------------
		local homeScene = HomeScene:sharedInstance()
		if homeScene then 
			homeScene:updateStarRewardBtnPosition()
			homeScene:updateInviteBtnPosition()
		end
		--------------
		-- Callback 
		-- -----------
		if self.onSuccessCallback then
			self.onSuccessCallback(self.pawnNum)
		end

		if NetworkConfig.writeLocalDataStorage then Localhost:getInstance():flushCurrentUserData() end
		-- SyncManager:getInstance():sync()

		LocalNotificationManager.getInstance():setPassLevelFlag(self.levelId, 0, 0)
	end

	self:sendJumpLevelRequest(sendRequestSuccess, self.onFailCallback)
end

function JumpLevelLogic:sendJumpLevelRequest( onSuccessCallback, onFailCallback )
	-- body
	local function onSuccess( evt )
		-- body
		UserService.getInstance():onLevelUpdate(1, self.levelId, 0)
		if onSuccessCallback then
			onSuccessCallback(evt.data)
		end
		DcUtil:UserTrack({category = 'skipLevel', sub_category = 'skip_level', t1 = self.levelId})
	end

	local function onFail( evt )
		-- body
		local errorCode = evt and tonumber(evt.data) or 0
		CommonTip:showTip(localize('error.tip.'..errorCode), "negative")
		if onFailCallback then
			onFailCallback(evt)
		end
	end

	local http = JumpLevelHttp.new(true)
	http:ad(Events.kComplete, onSuccess)
	http:ad(Events.kError, onFail)
	http:syncLoad(self.levelId)
end

