
require "zoo.net.Http" 

--
-- LoginHttp ---------------------------------------------------------
--
LoginHttp = class(HttpBase)
function LoginHttp:load()
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
	    	he_log_info("game login fail, err: " .. err)
	    	context:onLoadingError(err)
	    else
	    	he_log_info("game login success")
	    	context:onLoadingComplete(data)
	    end
	end

	self.transponder:call(kHttpEndPoints.login, nil, loadCallback, rpc.SendingPriority.kHigh, true)
end

--
-- FriendHttp ---------------------------------------------------------
--
FriendHttp = class(HttpBase)

--  <request>
--	  <property code="refresh" type="boolean" desc="æ˜¯å¦éœ€è¦åˆ·æ–°åŽç«¯å¥½å‹åˆ—è¡¨" /> 
--	  <list code="friendIds" type="long" desc="å¥½å‹idåˆ—è¡¨" /> 
--  </request>
function FriendHttp:load(refresh, friendIds)
	-- test
	-- for i=1140, 1350 do table.insert(friendIds, tostring(i)) end

	assert(type(friendIds) == "table", "friendIds not a table")
	local context = self
	if refresh == nil then refresh = false end
	if friendIds == nil or #friendIds == 0 then 
		--NO Friend need to refresh, just finish it.
		context:onLoadingComplete()
		return 
	end



	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end

	local loadCallback = function(endpoint, data, err)
		if err then
	    	he_log_info("get friends fail, err: " .. err)
	    	context:onLoadingError(err)
	    else
	    	he_log_info("get friends success")
	    	if data.users and type(data.users) == "table" then	    		
	    		FriendManager.getInstance():syncFromLua(data.users, data.profiles, data.snsFriendIds, data.achievementList)
	    		Localhost.getInstance():flushCurrentFriendsData() -- why? how about delete it.
	    	end
	    	context:onLoadingComplete(data)
	    end
	end
	self.transponder:call(kHttpEndPoints.friends, {refresh=refresh, friendIds=friendIds}, loadCallback, rpc.SendingPriority.kHigh, false)
end

GetFriendsHttp	= class(HttpBase)

function GetFriendsHttp:load()
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self

	local loadCallback = function(endpoint, data, err)

		if err then
			he_log_info("get friends id fail, err: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("get friends id success ! ")

			-- test
			-- for i=1140, 1350 do table.insert(data.friendIds, tostring(i)) end

			UserManager:getInstance().friendIds = data.friendIds

			context:onLoadingComplete(data)
		end
	end

	local parameters = {}
	if __IOS_FB then
		parameters.openId = Localhost:getInstance():readCurrentUserData().openId
		parameters.accessToken = FacebookProxy:getInstance():accessToken()
		print("openId="..tostring(parameters.openId)..",accessToken="..tostring(parameters.accessToken))
	end

	self.transponder:call(kHttpEndPoints.getFriends, parameters, loadCallback, rpc.SendingPriority.kHigh, false)
end


--
-- GetUnlockFriendHttp ---------------------------------------------------------
--
GetUnlockFriendHttp = class(HttpBase)
function GetUnlockFriendHttp:load()
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end

	local context = self
	local unlockFriendCallback = function(endpoint, data, err)
		if err then
	    	he_log_info("get unlock friend fail, err: " .. err)
	    	context:onLoadingError(err)
	    else 
	    	he_log_info("get unlock friend success")
			for k,v in pairs(data.unLockFriendInfos) do
				local function updateUnlockInfo(ipt)
					local unlockFriendInfos = UserManager:getInstance().unlockFriendInfos
					for k, v in ipairs(unlockFriendInfos) do
						if v.id == ipt.id then
							v.friendUids = ipt.friendUids
							return
						end
					end

					local unlockFriendInfo = UnLockFriendInfoRef.new()
					unlockFriendInfo.id		= ipt.id
					unlockFriendInfo.friendUids	= ipt.friendUids
					table.insert(unlockFriendInfos, unlockFriendInfo)
				end
				updateUnlockInfo(v)				
			end
	    	context:onLoadingComplete()
	    end
	end
	self.transponder:call(kHttpEndPoints.getUnLockFriend, nil, unlockFriendCallback, rpc.SendingPriority.kHigh, false)
end

--
-- QueryUserHttp ---------------------------------------------------------
--
QueryUserHttp = class(HttpBase)
-- <request>
-- 	<property code="inviteCode" type="int" desc="好友邀请码"/>
-- </request>
-- <response>
-- 	<property code="user" ref="User" desc="好友用户信息"/>
-- </response>
function QueryUserHttp:load(code)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local function loadCallback(endPoint, data, err)
		if err then
			he_log_info("QueryUserHttp, err:" .. err)
			context:onLoadingError(err)
		else
			he_log_info("QueryUserHttp success")
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.queryUser, {inviteCode = code}, loadCallback, rpc.SendingPriority.kHigh, false)
end

--
-- RequestFriend ---------------------------------------------------------
--
RequestFriendHttp = class(HttpBase)
-- <request>
-- 	<property code="inviteCode" type="int" desc="好友邀请码"/>
-- 	<property code="friendUid" type="long" desc="好友的uid"/>
-- 	type: 1 --手机好友，0--其他方式的好友
-- </request>
-- <response>
-- </response>
function RequestFriendHttp:load(code, uid, type)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local function loadCallback(endPoint, data, err)
		if err then
			he_log_info("RequestFriendHttp fail, err:" .. err)
			context:onLoadingError(err)
		else
			he_log_info("RequestFriendHttp success")
			context:onLoadingComplete()
		end
	end
	self.transponder:call(kHttpEndPoints.requestFriend, {inviteCode = code, friendUid = uid, type = type}, loadCallback, rpc.SendingPriority.kHigh, false)
end

--
-- GetLevelScoreRankHttp ---------------------------------------------------------
--
GetLevelScoreRankHttp = class(HttpBase) --èŽ·å–å…³å¡å¾—åˆ†å…¨æœæŽ’è¡Œ

-- dispatched event.data = response

--  <request>
--	  <property code="levelId" type="int" desc="å…³å¡id" />
--	  <property code="pageStart" type="int" desc="æŸ¥è¯¢å¼€å§‹é¡µ" />
--    <property code="pageEnd" type="int" desc="æŸ¥è¯¢ç»“æŸé¡µ" />
--  </request>
--  <response>
--		<list code="ranks" ref="Rank" desc="æŽ’è¡Œæ¦œä¿¡æ¯"/>
--		<property code="rank" type="int" desc="å½“å‰çŽ©å®¶æŽ’å" />
--	</response>

function GetLevelScoreRankHttp:load(levelId, pageStart, pageEnd)
	assert(levelId ~= nil, "levelId must not a nil")
	assert(pageStart ~= nil, "pageStart must not a nil")
	assert(pageEnd ~= nil, "pageEnd must not a nil")
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end

	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
	    	he_log_info("getLevelScoreRank fail, err: " .. err)
	    	context:onLoadingError(err)
	    else
	    	he_log_info("getLevelScoreRank success")
	    	context:onLoadingComplete(data)
	    end
	end
	self.transponder:call(kHttpEndPoints.getLevelScoreRank, 
		{levelId=levelId, pageStart=pageStart, pageEnd=pageEnd}, 
		loadCallback, rpc.SendingPriority.kHigh, false)
end

--
-- GetLevelTopHttp ---------------------------------------------------------
--
GetLevelTopHttp = class(HttpBase) --èŽ·å–å…³å¡å¾—åˆ†å…¨æœæŽ’è¡Œ

-- dispatched event.data = response.scores å¥½å‹æŽ’ååˆ—è¡¨

--  <request>
--	  <property code="levelId" type="int" desc="å…³å¡id" />
--  </request>
--  <response>
--		<list code="scores" ref="Score" desc="å¥½å‹æŽ’ååˆ—è¡¨"/>
--	</response>
function GetLevelTopHttp:load(levelId)
	assert(levelId ~= nil, "levelId must not a nil")
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end

	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
	    	he_log_info("getLevelTop fail, err: " .. err)
	    	context:onLoadingError(err)
	    else
	    	he_log_info("getLevelTop success")
	    	context:onLoadingComplete(data.scores)
	    end
	end
	self.transponder:call(kHttpEndPoints.getLevelTop, {levelId=levelId}, loadCallback, rpc.SendingPriority.kHigh, false)
end

--
-- EndLadyBugTask ---------------------------------------------------------
--
EndLadyBugTask = class(HttpBase)
function EndLadyBugTask:load(...)
	assert(#{...} == 0)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)

		if err then
			he_log_info("end lady bug task error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("end lady bug task success !")
			-- context:onLoadingComplete(data.metaClient)
			-- fix
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.endLadyBugTask, nil, loadCallback, rpc.SendingPriority.kHigh, false)
end

--
-- FinishChildLadyBugTask ---------------------------------------------------------
--
FinishChildLadyBugTask = class(HttpBase)
function FinishChildLadyBugTask:load(taskId, ...)
	assert(type(taskId) == "number")
	assert(#{...} == 0)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)

		if err then
			he_log_info("finish child lady bug task taskId:" .. taskId .. " error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("finish child lady bug task taskId:" .. taskId .. " success !")

			-- context:onLoadingComplete(data.metaClient)
			-- fix
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.finishChildLadyBugTask, {taskId = taskId}, loadCallback, rpc.SendingPriority.kHigh, false)
end


--
-- GetInvitedFriendsUserInfo ---------------------------------------------------------
--
GetInvitedFriendsUserInfo = class(HttpBase)
function GetInvitedFriendsUserInfo:load(invitedFriendsInfo)
	print('this debug GetInvitedFriendsUserInfo:load')
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local friendIds = {}
	for k, v in pairs(invitedFriendsInfo) do
		if tonumber(v.friendUid) ~= 0 and v.invite == true then
			table.insert(friendIds, tonumber(v.friendUid))
		end
	end

	local function loadCallback(endPoint, data, err)
		if err then
			he_log_info("GetInvitedFriendsUserInfo: error: " .. err)
			self:onLoadingError(err)
		else
			print('this debug loadCallback sucess')
			FriendManager:getInstance():syncFromLuaForInvitedFriends(data.users, data.profiles)
			self:onLoadingComplete(data)
		end

	end

	self.transponder:call(kHttpEndPoints.friends, {refresh=refresh, friendIds=friendIds}, loadCallback, rpc.SendingPriority.kHigh, false)
end


--
-- GetInviteFriendsInfo ---------------------------------------------------------
--
GetInviteFriendsInfo = class(HttpBase)
function GetInviteFriendsInfo:load(...)

	assert(#{...} == 0)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)

		if err then
			he_log_info("get invite frinds info error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("get invite friends info success !")
			--print(table.tostring(data))
			UserManager:getInstance().inviteFriendsInfo = data.groupInfos
			context:onLoadingComplete(data.groupInfos)
		end
	end
	self.transponder:call(kHttpEndPoints.getInviteFriendsInfo, nil, loadCallback, rpc.SendingPriority.kHigh, false)
end


--
-- RespRequest ---------------------------------------------------------
--
-- <property code="action" type="int" desc="用户操作 1：同意帮助，2：忽略" />
-- <property code="id" type="int" desc="请求id" />
RespRequest = class(HttpBase)
function RespRequest:load(id, action)
	print("RespOpCheckTask:"..id..":"..action)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)

		if err then
			he_log_info("RespRequest error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("RespRequest success !")
			UserManager.getInstance():removeRequestInfo(id)
			UserManager.getInstance().requestNum = UserManager.getInstance().requestNum - 1
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.respRequest, {id=id, action=action}, loadCallback, rpc.SendingPriority.kHigh, false)
end

-- 
-- NewUserEnergy ---------------------------------------------------------
-- 
NewUserEnergy = class(HttpBase)
function NewUserEnergy:load()
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("Request error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("Request success !")
			context:onLoadingComplete()
		end
	end
	self.transponder:call(kHttpEndPoints.newUserEnergy, nil, loadCallback, rpc.SendingPriority.kHigh, false)
end

-- 
-- GetUserHttp ---------------------------------------------------------
-- 
GetUserHttp = class(HttpBase)
function GetUserHttp:load()
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("GetUserHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("GetUserHttp success !")
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.getUser, nil, loadCallback, rpc.SendingPriority.kHigh, false)
end

-- 
-- GetLeftAskInfoHttp ---------------------------------------------------------
-- 
GetLeftAskInfoHttp = class(HttpBase)
function GetLeftAskInfoHttp:load(uid)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("GetLeftAskInfoHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("GetLeftAskInfoHttp success !")
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.getLeftAskInfos, {uids = uid}, loadCallback, rpc.SendingPriority.kHigh, false)
end

-- 
-- GetRequestInfoHttp ---------------------------------------------------------
-- 
GetRequestInfoHttp = class(HttpBase)
function GetRequestInfoHttp:load()
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("GetRequestInfoHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("GetRequestInfoHttp success !")
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.getRequestInfos, {uilds = uid}, loadCallback, rpc.SendingPriority.kHigh, false)
end

-- 
-- GetRequestNumHttp ---------------------------------------------------------
-- 
GetRequestNumHttp = class(HttpBase)
function GetRequestNumHttp:load()
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("GetRequestNumHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("GetRequestNumHttp success !")
			context:onLoadingComplete(data)
		end
	end

	local userbody = {
		curMd5 = ResourceLoader.getCurVersion(),
		pName = _G.packageName 
	}
	if StartupConfig:getInstance():getSmallRes() then 
		userbody.mini = 1
	else
		userbody.mini = 0
	end
	--推送召回 前端向后端发送流失状态
	userbody.lostType = RecallManager.getInstance():getRecallRewardState()
	self.transponder:call(kHttpEndPoints.getRequestNum, userbody, loadCallback, rpc.SendingPriority.kHigh, false)
end

-- 
-- IgnoreFreegift ---------------------------------------------------------
-- 
IgnoreFreegiftHttp = class(HttpBase)
function IgnoreFreegiftHttp:load(messageId)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("IgnoreFreegiftHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("IgnoreFreegiftHttp success !")
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.ignoreFreegift, {id = messageId}, loadCallback, rpc.SendingPriority.kHigh, false)
end

-- 
-- updateConfigFromServer ---------------------------------------------------------
-- 
UpdateConfigFromServerHttp = class(HttpBase)
function UpdateConfigFromServerHttp:load()
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("updateConfigFromServer error: " .. err)
			self:onLoadingError(err)
		else  
			he_log_info("updateConfigFromServer success !")
			self:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.updateConfigFromServer, {}, loadCallback, rpc.SendingPriority.kHigh, false)
end


------------
--- queryQihooOrder
-------------
QueryQihooOrderHttp = class(HttpBase)
function QueryQihooOrderHttp:load(orderId)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("QueryQihooOrderHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("QueryQihooOrderHttp success !")
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.queryQihooOrder, {orderId = orderId}, loadCallback, rpc.SendingPriority.kHigh, false)
end


QueryAliOrderHttp = class(HttpBase)
function QueryAliOrderHttp:load(orderId)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("QueryAliOrderHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("QueryAliOrderHttp success !")
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.queryAliOrder, {orderId = orderId}, loadCallback, rpc.SendingPriority.kHigh, false)
end

ExtraConnectHttp = class(HttpBase)
function ExtraConnectHttp:load(openId,accessToken,snsPlatform,snsName)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("QQConnectHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("QQConnectHttp success !")
			context:onLoadingComplete(data)
		end
	end
	local connectProtocol = "extraConnect"
	local params = {
		openId=openId,
		accessToken=accessToken,
		snsPlatform=snsPlatform,
		snsName = snsName,
	}

	self.transponder:call(connectProtocol, params, loadCallback, rpc.SendingPriority.kHigh, false)
end

-- 
-- QQConnect ---------------------------------------------------------
-- 
QQConnectHttp = class(HttpBase)
function QQConnectHttp:load(openId, accessToken,snsPlatform,snsName)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("QQConnectHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("QQConnectHttp success !")
			context:onLoadingComplete(data)
		end
	end
	local connectProtocol = "otherConnectV3"
	if PlatformConfig:isQQPlatform() then
		if snsPlatform == PlatformAuthDetail[PlatformAuthEnum.kQQ].name then
			connectProtocol = "qqConnectV3"
		end
	end

	local params = {
		openId=openId,
		accessToken=accessToken,
		snsPlatform=snsPlatform,
		-- oldSnsPlatform=oldSnsPlatform,
		snsName = snsName,
		deviceUdid = MetaInfo:getInstance():getUdid(),
	}

	self.transponder:call(connectProtocol, params, loadCallback, rpc.SendingPriority.kHigh, false)
end

--rebinding
RebindingHttp = class(HttpBase)
function RebindingHttp:load(snsName, openId,accessToken)
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("RebindingHttp error: " .. err)
			self:onLoadingError(err)
		else
			he_log_info("RebindingHttp success !")
			self:onLoadingComplete(data)
		end
	end
	local connectProtocol = "reBinding"
	self.transponder:call(connectProtocol, {snsName = snsName, openId = openId, accessToken=accessToken}, loadCallback, rpc.SendingPriority.kHigh, false)
end

-- 
-- PreQQConnectHttp ---------------------------------------------------------
-- 
PreQQConnectHttp = class(HttpBase)
function PreQQConnectHttp:load(openId,accessToken,haveSyncCache,snsPlatform,snsName)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("QQConnectHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("QQConnectHttp success !")
			context:onLoadingComplete(data)
		end
	end

	local connectProtocol = "preOtherConnectV3"
	if PlatformConfig:isQQPlatform() then
		if snsPlatform == PlatformAuthDetail[PlatformAuthEnum.kQQ].name then
			connectProtocol = "preQqConnectV3"
		end
	end

	-- print("openId="..openId..",accessToken="..accessToken)
	local params = {
		openId=openId,
		accessToken=accessToken,
		snsPlatform=snsPlatform,
		-- oldSnsPlatform=oldSnsPlatform,
		hasCache=haveSyncCache,
		snsName = snsName,
		deviceUdid = MetaInfo:getInstance():getUdid()
	}

	self.transponder:call(connectProtocol, params, loadCallback, rpc.SendingPriority.kHigh, false)
end

-- PreQQConnectV2Http = class(PreQQConnectHttp)
-- function PreQQConnectV2Http:syncLoad(...)
-- 		if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
-- 	  	local para = {...}

-- 	  	local function onSyncError(err)
-- 	  		self:onLoadingError(err)
-- 	  	end

-- 	  	local function onSyncFinished()
-- 	  		self:load(para[1], para[2], para[3], para[4], para[5], para[6],
-- 	    		para[7], para[8], para[9], para[10], para[11], para[12], para[13], para[14], para[15])
-- 	  	end

-- 	  	SyncManager.getInstance():sync(onSyncFinished, onSyncError, kRequireNetworkAlertAnimation.kNone)
-- end

PreQQConnectV1Http = class(HttpBase)
function PreQQConnectV1Http:load(openId, accessToken, haveSyncCache)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("QQConnectHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("QQConnectHttp success !")
			context:onLoadingComplete(data)
		end
	end
	local connectProtocol = "preOtherConnect"
	if PlatformConfig:isQQPlatform() then
		assert(false)
		-- connectProtocol = "preQqConnect"
	end
	-- print("openId="..openId..",accessToken="..accessToken)
	local params = {openId=openId,accessToken=accessToken,hasCache=haveSyncCache}
	if __ANDROID and _G.sns_token then
		params.snsPlatform = PlatformConfig:getPlatformAuthName()
	end
	self.transponder:call(connectProtocol, params, loadCallback, rpc.SendingPriority.kHigh, false)
end


-- 
-- SyncSnsFriendHttp ----------------------------------------------------
-- 
SyncSnsFriendHttp = class(HttpBase)
function SyncSnsFriendHttp:load(friendOpenIds, openId, accessToken,authorType)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
	    	he_log_info("syncSnsFriend fail, err: " .. err)
	    	context:onLoadingError(err)
	    else
	    	he_log_info("syncSnsFriend success")
	    	print("friendsData:"..table.tostring(data))
	    	if data.users and type(data.users) == "table" then
	    		FriendManager.getInstance():syncFromLua(data.users, data.profiles, data.snsFriendIds)
	    		Localhost.getInstance():flushCurrentFriendsData()
	    	end
	    	context:onLoadingComplete(data)
	    end
	end
	local params = {friendOpenIds=friendOpenIds, openId=openId, openKey=accessToken}
	if __ANDROID and _G.sns_token then
		params.snsPlatform = PlatformConfig:getPlatformAuthName(authorType)
	end
	self.transponder:call(kHttpEndPoints.syncSnsFriend, params, loadCallback, rpc.SendingPriority.kHigh, false)
end
-- 
-- GetNearbyHttp ----------------------------------------------------
-- 
-- <request>
-- 	<property code="longitude" type="double" desc="经度"/>
-- 	<property code="latitude" type="double" desc="纬度"/>
-- </request>
-- <response>
-- 	<list code="users" ref="User" desc="用户列表"/>
-- 	<list code="profiles" ref="Profile" desc="用户头像列表"/>
-- </response>
GetNearbyHttp = class(HttpBase)
function GetNearbyHttp:load(longitude, latitude)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("GetNearbyHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("GetNearbyHttp success !")
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.getNearby, {longitude = longitude, latitude = latitude}, loadCallback, rpc.SendingPriority.kHigh, false)
end

-- 
-- SendLocationHttp ----------------------------------------------------
-- 
-- <request>
-- 	<property code="longitude" type="double" desc="经度"/>
-- 	<property code="latitude" type="double" desc="纬度"/>
-- </request>
-- <response>
-- </response>
SendLocationHttp = class(HttpBase)
function SendLocationHttp:load(longitude, latitude)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("SendLocationHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("SendLocationHttp success !")
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.sendLocation, {longitude = longitude, latitude = latitude}, loadCallback, rpc.SendingPriority.kHigh, false)
end

-- 
-- GetMatchsHttp ----------------------------------------------------
-- 
-- <request>
-- </request>
-- <response>
-- 	<list code="users" ref="User" desc="用户列表"/>
-- 	<list code="profiles" ref="Profile" desc="用户头像列表"/>
-- </response>
GetMatchsHttp = class(HttpBase)
function GetMatchsHttp:load()
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("GetMatchsHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("GetMatchsHttp success !")
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.getMatchs, nil, loadCallback, rpc.SendingPriority.kHigh, false)
end

-- 
-- ConfirmMatchHttp ----------------------------------------------------
-- 
-- <request>
-- 	<property code="friendUid" type="long" desc="待添加的好友id"/>
-- </request>
-- <response>
-- </response>
ConfirmMatchHttp = class(HttpBase)
function ConfirmMatchHttp:load(uid)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("ConfirmMatchHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("ConfirmMatchHttp success !")
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.confirmMatch, {friendUid = uid}, loadCallback, rpc.SendingPriority.kHigh, false)
end

-- 
-- AckMatchHttp ----------------------------------------------------
-- 
-- <request>
-- </request>
-- <response>
-- 	<property code="ret" type="int" desc="0：成功 1：失败 2：继续等待"/>
-- </response>
AckMatchHttp = class(HttpBase)
function AckMatchHttp:load()
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("AckMatchHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("AckMatchHttp success !")
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.ackMatch, nil, loadCallback, rpc.SendingPriority.kHigh, false)
end


-- getUpdateReward

GetUpdateRewardHttp = class(HttpBase)
function GetUpdateRewardHttp:load()
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("GetUpdateRewardHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("GetUpdateRewardHttp success !")
			context:onLoadingComplete(data)
		end
	end
	local userbody = {
		curMd5 = ResourceLoader.getCurVersion(),
		pName = _G.packageName 
	}
	if StartupConfig:getInstance():getSmallRes() then 
		userbody.mini = 1
	else
		userbody.mini = 0
	end
	--推送召回 前端向后端发送流失状态
	userbody.lostType = RecallManager.getInstance():getRecallRewardState()
	self.transponder:call(kHttpEndPoints.getUpdateReward, userbody, loadCallback, rpc.SendingPriority.kHigh, false)
end


-- getPromoStatus

GetPromoStatusHttp = class(HttpBase)
function GetPromoStatusHttp:load(appId)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("GetPromoStatusHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("GetPromoStatusHttp success !")
			context:onLoadingComplete(data)
		end
	end

	self.transponder:call(kHttpEndPoints.getPromStatus, {appId = appId}, loadCallback, rpc.SendingPriority.kHigh, false)
end


-- getPromoReward

GetPromoRewardHttp = class(HttpBase)
function GetPromoRewardHttp:load(appId, rewardId)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("GetPromoRewardHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("GetPromoRewardHttp success !")
			context:onLoadingComplete(data)
		end
	end

	self.transponder:call(kHttpEndPoints.getPromReward, {appId = appId, rewardId = rewardId}, loadCallback, rpc.SendingPriority.kHigh, false)
end

-- clickPromo

ClickPromoHttp = class(HttpBase)
function ClickPromoHttp:load(appId, idfa, mac)
	print('load')
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("ClickPromoHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("ClickPromoHttp success !")
			context:onLoadingComplete(data)
		end
	end

	self.transponder:call(kHttpEndPoints.clickProm, {appId = appId, idfa = idfa, mac= mac}, loadCallback, rpc.SendingPriority.kHigh, false)
end

--
-- GetFruitsInfoHttp ---------------------------------------------------------
--
GetFruitsInfoHttp = class(HttpBase)
function GetFruitsInfoHttp:load()
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("GetFruitsInfoHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("GetFruitsInfoHttp success !")
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.getFruitsInfo, {}, loadCallback, rpc.SendingPriority.kHigh, false)
end

--
-- UpgradeFruitTreeHttp ---------------------------------------------------------
--
UpgradeFruitTreeHttp = class(HttpBase)
function UpgradeFruitTreeHttp:load()
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("UpgradeFruitTreeHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("UpgradeFruitTreeHttp success !")
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.upgradeFruitTree, {}, loadCallback, rpc.SendingPriority.kHigh, false)
end

--
-- GetPassNumHttp ---------------------------------------------------------
--
GetPassNumHttp = class(HttpBase)
function GetPassNumHttp:load(levelId)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("GetPassNumHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("GetPassNumHttp success !")
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.getPassNum, {levelId = levelId}, loadCallback, rpc.SendingPriority.kHigh, false)
end

--
-- GetShareRankHttp ---------------------------------------------------------
--
GetShareRankHttp = class(HttpBase)
function GetShareRankHttp:load(levelId, score)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("GetShareRankHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("GetShareRankHttp success !")
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.getShareRank, {levelId = levelId, score = score}, loadCallback, rpc.SendingPriority.kHigh, false)
end

--
-- getShareRankWithPosition ---------------------------------------------------------
--
GetShareRankWithPosition = class(HttpBase)
function GetShareRankWithPosition:load(levelId, score)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("GetShareRankWithPosition error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("GetShareRankWithPosition success !")
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.getShareRankWithPosition, {levelId = levelId, score = score}, loadCallback, rpc.SendingPriority.kHigh, false)
end

--
-- CanSendLinkShowOff ---------------------------------------------------------
--
CanSendLinkShowOff = class(HttpBase)
function CanSendLinkShowOff:load(levelId, score)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("CanSendLinkShowOff error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("CanSendLinkShowOff success !")
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.canSendLinkShowOff, {}, loadCallback, rpc.SendingPriority.kHigh, false)
end

GetWeekMatchDataHttp = class(HttpBase)
function GetWeekMatchDataHttp:load(levelId)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("GetWeekMatchDataHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("GetWeekMatchDataHttp success !")
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.getWeekMatchData, {levelId = levelId}, loadCallback, rpc.SendingPriority.kHigh, false)
end

CommonRankType = table.const {
	kWeeklyRace = 1,
	kRabbitWeeklyMatch = 5,
	kLaborDay = 6,
	kDragonBoat = 7,
	kSummerWeeklyMatch = 8,
	kQiXi2015 = 9,
	kAutumnWeekMatch = 11,
	kWinterWeekMatch = 14,
}
GetCommonRankListHttp = class(HttpBase)
function GetCommonRankListHttp:load(rankType, subType, levelId, startIndex, endIndex)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	startIndex = startIndex or 0
	endIndex = endIndex or 0
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("GetCommonRankListHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("GetCommonRankListHttp success !")
			context:onLoadingComplete(data)
		end
	end
	local params = {
		rankType = rankType, 
		subType = subType, 
		levelId = levelId, 
		startIndex = startIndex, 
		endIndex = endIndex,
	}
	self.transponder:call(kHttpEndPoints.getCommonRankList, params, loadCallback, rpc.SendingPriority.kHigh, false)
end

ExchangeWeekMatchItemsHttp = class(HttpBase)
function ExchangeWeekMatchItemsHttp:load(rewardId, number, levelId)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("ExchangeWeekMatchItemsHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("ExchangeWeekMatchItemsHttp success !")
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.exchangeWeekMatchItems, {rewardId = rewardId, num = number, levelId = levelId}, loadCallback, rpc.SendingPriority.kHigh, false)
end

ReceiveWeekMatchRewardsHttp = class(HttpBase)
function ReceiveWeekMatchRewardsHttp:load(id, levelId)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("ReceiveWeekMatchRewardsHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("ReceiveWeekMatchRewardsHttp success !")
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.receiveWeekMatchRewards, {type = id, levelId = levelId}, loadCallback, rpc.SendingPriority.kHigh, false)
end

CnValentineInfoHttp = class(HttpBase)
function CnValentineInfoHttp:load()
if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("CnValentineInfoHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("CnValentineInfoHttp success !")
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.cnValentineInfo, {}, loadCallback, rpc.SendingPriority.kHigh, false)
end

CnValentineExchangeHttp = class(HttpBase)
function CnValentineExchangeHttp:load(rewardId)
if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("CnValentineExchangeHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("CnValentineExchangeHttp success !")
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.cnValentineExchange, {id = rewardId}, loadCallback, rpc.SendingPriority.kHigh, false)
end

MergeConnectHttp = class(HttpBase)
function MergeConnectHttp:load(weiboOpenId, qqOpenId)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("MergeConnectHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("MergeConnectHttp success !")
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.mergeConnect, {weiboOpenId = weiboOpenId, qqOpenId = qqOpenId}, loadCallback, rpc.SendingPriority.kHigh, false)
end

ClickActivityHttp = class(HttpBase)
function ClickActivityHttp:load(actId)
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("ClickActivityHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("ClickActivityHttp success !")
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.clickActivity, {actId=actId}, loadCallback, rpc.SendingPriority.kHigh, false)
end


GetCashLogsHttp = class(HttpBase)
function GetCashLogsHttp:load(start,_end)
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("GetCashLogsHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("GetCashLogsHttp success !")
			context:onLoadingComplete(data)
		end
	end
	local d = {}
	d["start"] = start
	d["end"] = _end
	self.transponder:call(kHttpEndPoints.getCashLogs, d, loadCallback, rpc.SendingPriority.kHigh, false)
end

GetRabbitMatchDatasHttp = class(HttpBase)
function GetRabbitMatchDatasHttp:load(levelId)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("GetRabbitMatchDatasHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("GetRabbitMatchDatasHttp success !")
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.getRabbitMatchDatas, {levelId = levelId}, loadCallback, rpc.SendingPriority.kHigh, false)
end

ReceiveRabbitMatchRewardsHttp = class(HttpBase)
function ReceiveRabbitMatchRewardsHttp:load(levelId, rewardType, boxIdx)
	-- if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	if not kUserLogin then return self:onLoadingError({}) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("ReceiveRabbitMatchRewardsHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("ReceiveRabbitMatchRewardsHttp success !")
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.receiveRabbitMatchRewards, {type = rewardType, levelId = levelId, idx = boxIdx}, loadCallback, rpc.SendingPriority.kHigh, false)
end

OpNotifyType = {
	kShare = 1, --分享
	kNewYearAsk = 2,
	kXuanYao = 3,
	kSpringVideo = 4,--新春点击视频统计
	kVideoAdPlay = 6, --观看视频广告
	kAnniversaryShare = 7, --周年纪念分享得100银币 活动里用 
	kWeeklyMatchShare = 10, -- 周赛分享
	kSummerShare = 11, --夏日分享活动分享
	kOppoSummerLottery = 12,
	kQiXiLevel2015 = 13,
	kNdShare2015TurnTable = 19, -- 分享得转盘次数
	kNdShare2015Coin = 20, -- 分享得银币
	kNdShare2015AskFriend = 21, -- 求助好友抽取小动物
	kAutumnWeekMatchShare = 22,
	kPassMaxNormalLevel = 24, 	-- 通过版本最高关卡
	kRequestPushEnergy = 25,  -- 请求生成NPC免费精力推送
	kRdefAutumnWeekMatchShare = 26, -- 此版本添加多少游戏次数由后端返回决定
	kCheckUnlockRecord = 27,
	kDengchaoEnergy = 28, -- 邓超送精力
	kRdefWinterWeekMatchShare = 30, --冬季周赛分享加次数
	kRdefSpringWeekMatchShare = 31, --冬季周赛分享加次数
	kAndroidSalesPromotion = 32 , 	--安卓破冰促销
}
OpNotifyHttp = class(HttpBase)
function OpNotifyHttp:load(opType, param)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("OpNotifyHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("OpNotifyHttp success !")
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.opNotify, {type = opType, param = param}, loadCallback, rpc.SendingPriority.kHigh, false)
end

LevelConfigUpdateHttp = class(HttpBase)
function LevelConfigUpdateHttp:load(os, version)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("LevelConfigUpdateHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("LevelConfigUpdateHttp success !")
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.levelConfigUpdate, {platform = os, version = version}, loadCallback, rpc.SendingPriority.kHigh, false)
end

GetSummerWeekMatchInfoHttp = class(HttpBase)
function GetSummerWeekMatchInfoHttp:load( levelId )
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("GetSummerWeekMatchInfoHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("GetSummerWeekMatchInfoHttp success !")
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.getSummerWeekMatchInfo, {levelId = levelId}, loadCallback, rpc.SendingPriority.kHigh, false)
end

GetWeeklyRaceRewardsType = table.const {
	kDailyReward = 0,
	kWeeklyReward = 1,
	kLastWeekRewards = 2,
	kLastWeekRankRewards = 3,
}
GetSummerWeekMatchRewardHttp = class(HttpBase)
function GetSummerWeekMatchRewardHttp:load(levelId, type, index, day)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	day = day or 0
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("GetSummerWeekMatchRewardHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("GetSummerWeekMatchRewardHttp success !")
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.getSummerWeekMatchReward, {levelId = levelId, type = type, index = index, day = day}, loadCallback, rpc.SendingPriority.kHigh, false)
end

-- 秋季周赛
GetAutumnWeekMatchInfoHttp = class(HttpBase)
function GetAutumnWeekMatchInfoHttp:load( levelId )
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("GetAutumnWeekMatchInfoHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("GetAutumnWeekMatchInfoHttp success !")
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.getSummerWeekMatch2016Info, {levelId = levelId}, loadCallback, rpc.SendingPriority.kHigh, false)
end

GetAutumnWeekMatchRewardHttp = class(HttpBase)
function GetAutumnWeekMatchRewardHttp:load(levelId, type, index, day)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	day = day or 0
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("GetAutumnWeekMatchRewardHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("GetAutumnWeekMatchRewardHttp success !")
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.getSummerWeekMatch2016Reward, {levelId = levelId, type = type, index = index, day = day}, loadCallback, rpc.SendingPriority.kHigh, false)
end

GetMissionInfoHttp = class(HttpBase)
function GetMissionInfoHttp:load()
if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	day = day or 0
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("GetMissionInfoHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("GetMissionInfoHttp success !")
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.getMissionInfo, {}, loadCallback, rpc.SendingPriority.kHigh, false)
end

CreateMissionHttp = class(HttpBase)
function CreateMissionHttp:load(userReturnDay, positions, tasks, loginInfo)
if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	day = day or 0
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("CreateMissionHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("CreateMissionHttp success !")
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.createMission, {userReturnDay = userReturnDay, positions = positions,
		tasks = tasks, loginInfo = loginInfo}, loadCallback, rpc.SendingPriority.kHigh, false)
end

-- 特殊状况，道具在上层处理逻辑中添加给用户，所以是一个OnlineGetter
GetMissionRewardHttp = class(HttpBase)
function GetMissionRewardHttp:load(positions)
if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	day = day or 0
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("GetMissionRewardHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("GetMissionRewardHttp success !")
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.getMissionReward, {positions = positions}, loadCallback, rpc.SendingPriority.kHigh, false)
end

--支付宝签约
GetAliPaymentSign = class(HttpBase)
function GetAliPaymentSign:load(phoneNumber, aliAccount)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("GetAliPaymentSign error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@GetAliPaymentSign success !")
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.getAliPaymentSign, {phoneNum = phoneNumber, aliAccount = aliAccount}, loadCallback, rpc.SendingPriority.kHigh, false)
end


--支付宝签约
GetAliPaymentVerify = class(HttpBase)
function GetAliPaymentVerify:load(applyId, smsCode)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("GetAliPaymentSign error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("GetAliPaymentSign success !")
			context:onLoadingComplete(data)
		end
	end
	print("applyId: "..tostring(applyId), "code: "..tostring(smsCode))
	self.transponder:call(kHttpEndPoints.getAliPaymentVerify, {applyId = applyId, code = smsCode}, loadCallback, rpc.SendingPriority.kHigh, false)
end

--支付宝签约
GetAliPaymentUnsign = class(HttpBase)
function GetAliPaymentUnsign:load()
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("GetAliPaymentUnsign error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("GetAliPaymentUnsign success !")
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.getAliPaymentUnsign, {}, loadCallback, rpc.SendingPriority.kHigh, false)
end

--支付宝签约
GetAliIngamePayment = class(HttpBase)
function GetAliIngamePayment:load(tradeId, platform, goodsId, goodsType, num, goodsName, totalFee, checkStr)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("GetAliIngamePayment error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("GetAliIngamePayment success !")
			context:onLoadingComplete(data)
		end
	end

	self.transponder:call(kHttpEndPoints.getAliIngamePayment, {tradeId = tradeId, platform = platform, 
						goodsId = goodsId, goodsType = goodsType, num = num, goodsName = goodsName, 
						totalFee = totalFee, checkStr = checkStr}, loadCallback, rpc.SendingPriority.kHigh, false)
end

SendQrCodeHttp = class(HttpBase)
function SendQrCodeHttp:load(raceType, timeStamp, targetCount)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self

	local loadCallback = function(endpoint, data, err)
		if err then
	    	context:onLoadingError(err)
	    else
			context:onLoadingComplete(data)
	    end
	end
	self.transponder:call(kHttpEndPoints.sendQrCode, {type = raceType, timestamp = timeStamp, targetCount = targetCount},
		loadCallback, rpc.SendingPriority.kHigh, false)
end

--获取促销信息
GetIosOneYuanPromotionInitInfo = class(HttpBase)
function GetIosOneYuanPromotionInitInfo:load()
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("GetIosOneYuanPromotionInitInfo error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("GetIosOneYuanPromotionInitInfo success !")
			context:onLoadingComplete(data)
		end
	end

	self.transponder:call(kHttpEndPoints.getIosOneYuanPromotionInitInfo, {}, loadCallback, rpc.SendingPriority.kHigh, false)
end

--触发促销
TriggerIosOneYuanPromotion = class(HttpBase)
function TriggerIosOneYuanPromotion:load(promotionType)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("TriggerIosOneYuanPromotion error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("TriggerIosOneYuanPromotion success !")
			context:onLoadingComplete(data)
		end
	end

	self.transponder:call(kHttpEndPoints.triggerIosOneYuanPromotion, {type = promotionType}, loadCallback, rpc.SendingPriority.kHigh, false)
end

--重置道具信息
ResetIosOneYuanShop = class(HttpBase)
function ResetIosOneYuanShop:load()
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("ResetIosOneYuanShop error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("ResetIosOneYuanShop success !")
			context:onLoadingComplete(data)
		end
	end

	self.transponder:call(kHttpEndPoints.resetIosOneYuanShop, {}, loadCallback, rpc.SendingPriority.kHigh, false)
end

GetLevelPawnNumHttp = class(HttpBase)
function GetLevelPawnNumHttp:load(levelId)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("GetLevelPawnNumHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("GetLevelPawnNumHttp success !")
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.getLevelPawnNum, {levelId = levelId}, loadCallback, rpc.SendingPriority.kHigh, false)
end

GetLoginInfosHttp = class(HttpBase)
function GetLoginInfosHttp:load()
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("GetLoginInfos error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("GetLoginInfos success !")
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.getLoginInfos, {deviceUdid = MetaInfo:getInstance():getUdid()}, loadCallback, rpc.SendingPriority.kHigh, false)
end

LoadFriendsByPhoneNumbersHttp = class(HttpBase)
function LoadFriendsByPhoneNumbersHttp:load(phoneNumbers)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("LoadFriendsByPhoneNumbersHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("LoadFriendsByPhoneNumbersHttp success !")
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.loadFriendsByPhoneNumbers, {phoneNumbers = phoneNumbers}, loadCallback, rpc.SendingPriority.kHigh, false)
end

LoadProfilesByUidsHttp = class(HttpBase)
function LoadProfilesByUidsHttp:load(uids)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("LoadProfilesByUidsHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("LoadProfilesByUidsHttp success !")
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.loadProfilesByUids, {uids = uids}, loadCallback, rpc.SendingPriority.kHigh, false)
end

GetQQOpenIDHttp = class(HttpBase)
function GetQQOpenIDHttp:load()
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("GetQQOpenIDHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("GetQQOpenIDHttp success !")
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.getQQOpenID, {}, loadCallback, rpc.SendingPriority.kHigh, false)
end

GetPctOfRank = class(HttpBase)
function GetPctOfRank:load( star )
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self

	local loadCallback = function(endpoint, data, err)
		if err then
	    	context:onLoadingError(err)
	    else
	    	context:onLoadingComplete(data)
	    end
	end
	-- loadCallback()
	self.transponder:call(kHttpEndPoints.getPctOfRank, {star = star}, loadCallback, rpc.SendingPriority.kHigh, false)
end

GetHideAreaRewardsHttp = class(HttpBase)
function GetHideAreaRewardsHttp:load( hideAreaId )
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self

	local loadCallback = function(endpoint, data, err)
		if err then
	    	context:onLoadingError(err)
	    else
	    	context:onLoadingComplete(data)
	    end
	end
	-- loadCallback()
	self.transponder:call(kHttpEndPoints.getHideAreaRewards, { id = hideAreaId }, loadCallback, rpc.SendingPriority.kHigh, false)
end

GetSignHttp = class(HttpBase)
function GetSignHttp:load( fileId, expired )
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self

	local loadCallback = function(endpoint, data, err)
		if err then
	    	context:onLoadingError(err)
	    else
	    	context:onLoadingComplete(data)
	    end
	end
	-- loadCallback()
	self.transponder:call(kHttpEndPoints.getSign, { fileId = fileId, expired = expired }, loadCallback, rpc.SendingPriority.kHigh, false)
end

MaRankInfoHttp = class(HttpBase)
function MaRankInfoHttp:load()
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self

	local loadCallback = function(endpoint, data, err)
		if err then
	    	context:onLoadingError(err)
	    else
	    	context:onLoadingComplete(data)
	    end
	end
	-- loadCallback()
	self.transponder:call(kHttpEndPoints.maRankInfo, {}, loadCallback, rpc.SendingPriority.kHigh, false)
end

GetUserCommonRewardsHttp = class(HttpBase)
function GetUserCommonRewardsHttp:load(rewardType)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self

	local loadCallback = function(endpoint, data, err)
		if err then
	    	context:onLoadingError(err)
	    else
	    	context:onLoadingComplete(data)
	    end
	end
	-- loadCallback()
	self.transponder:call(kHttpEndPoints.getUserCommonRewards, {type = rewardType}, loadCallback, rpc.SendingPriority.kHigh, false)	
end

ActivityRewardHttp = class(HttpBase)
function ActivityRewardHttp:load(actId , rewardId)
    if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end    
    local context = self
    local loadCallback = function(endpoint, data, err)
        if err then
            he_log_info("getRewardHttp error: " .. err)
            context:onLoadingError(err)
        else
            he_log_info("getRewardHttp success !")
            context:onLoadingComplete(data)
        end
    end
    self.transponder:call("activityReward", { actId = actId , rewardId = rewardId }, loadCallback, rpc.SendingPriority.kHigh, false)
end

WxGetContractUrl = class(HttpBase)
function WxGetContractUrl:load()
    if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end    
    local context = self
    local loadCallback = function(endpoint, data, err)
        if err then
            he_log_info("WxGetContractUrl error: " .. err)
            context:onLoadingError(err)
        else
            he_log_info("WxGetContractUrl success !")
            context:onLoadingComplete(data)
        end
    end
    self.transponder:call(kHttpEndPoints.wxGetContractUrl, {}, loadCallback, rpc.SendingPriority.kHigh, false)
end

WxDeleteContract = class(HttpBase)
function WxDeleteContract:load()
    if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end    
    local context = self
    local loadCallback = function(endpoint, data, err)
        if err then
            he_log_info("WxDeleteContract error: " .. err)
            context:onLoadingError(err)
        else
            he_log_info("WxDeleteContract success !")
            context:onLoadingComplete(data)
        end
    end
    self.transponder:call(kHttpEndPoints.wxDeleteContract, {}, loadCallback, rpc.SendingPriority.kHigh, false)
end

WxQueryContract = class(HttpBase)
function WxQueryContract:load()
    if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end    
    local context = self
    local loadCallback = function(endpoint, data, err)
        if err then
            he_log_info("WxQueryContract error: " .. err)
            context:onLoadingError(err)
        else
            he_log_info("WxQueryContract success !")
            context:onLoadingComplete(data)
        end
    end
    self.transponder:call(kHttpEndPoints.wxQueryContract, {}, loadCallback, rpc.SendingPriority.kHigh, false)
end

WxIngame = class(HttpBase)
function WxIngame:load(tradeId, pf, goodsId, goodsType, num, goodsName, totalFee, checkStr)
    if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end    
    local context = self
    local loadCallback = function(endpoint, data, err)
        if err then
            he_log_info("WxIngame error: " .. err)
            context:onLoadingError(err)
        else
            he_log_info("WxIngame success !")
            context:onLoadingComplete(data)
        end
    end
    self.transponder:call(kHttpEndPoints.wxIngame, 
    {
    	tradeId = tradeId, platform = pf, goodsId = goodsId, goodsType = goodsType,
    	num = num, goodsName = goodsName, totalFee = totalFee, checkStr = checkStr,
    }, loadCallback, rpc.SendingPriority.kHigh, false)
end

getEasterEggReward = class(HttpBase)
function getEasterEggReward:load(animalId)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self

	local loadCallback = function(endpoint, data, err)
		if err then
	    	context:onLoadingError(err)
	    else
	    	context:onLoadingComplete(data)
	    end
	end
	self.transponder:call(kHttpEndPoints.getEasterEggReward, {animalId = animalId}, loadCallback, rpc.SendingPriority.kHigh, false)	
end