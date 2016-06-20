local SyncQQFriendsLogic = class()

local isCancel = false
local animation

function SyncQQFriendsLogic:syncQQFriends(onConnectFinish, onConnectError, onConnectCancel)
	local scene = Director:sharedDirector():getRunningScene()
    if not scene then
        return
    end

    animation = CountDownAnimation:createBindAnimation(scene, function( ... )
        isCancel = true
        animation:removeFromParentAndCleanup(true)
        if onConnectCancel then
            onConnectCancel()
        end
    end)

    local function isNetworkError(errorCode)
        return errorCode == -2 or errorCode == -6 or errorCode == -7
    end

	if not UserManager:getInstance().qqOpenID then
		print("goto get qq openID")
	    local function onRequestError(evt)
	    	if not isCancel then
	    		animation:removeFromParentAndCleanup(true)
                
                local errCode = tonumber(evt.data)
                if isNetworkError(errCode) then
                    CommonTip:showTip(localize("dis.connect.warning.tips"), "negative",nil, 2)
                else
                    CommonTip:showTip("同步QQ好友失败！","negative")
                end
	    	end
        end

        local function onRequestFinish(evt)
        	UserManager:getInstance().qqOpenID = evt.data.qqOpenID
        	self:doSyncQQFriends(PlatformAuthEnum.kQQ, onConnectFinish, onConnectError, onConnectCancel)
        end

        local http = GetQQOpenIDHttp.new()
        http:addEventListener(Events.kComplete, onRequestFinish)
        http:addEventListener(Events.kError, onRequestError)
        http:load()
	else
		self:doSyncQQFriends(PlatformAuthEnum.kQQ, onConnectFinish, onConnectError, onConnectCancel)
	end
end

function SyncQQFriendsLogic:doSyncQQFriends(authorizeType, onConnectFinish, onConnectError, onConnectCancel)
	local scene = Director:sharedDirector():getRunningScene()
    if not scene then
        return
    end
    
    local weiboAccountNameBeforeSync = UserManager:getInstance().profile:getSnsUsername(PlatformAuthEnum.kWeibo)
    print("weiboAccountNameBeforeSync: "..tostring(weiboAccountNameBeforeSync))

    local oldAuthorizeType = SnsProxy:getAuthorizeType()
    local logoutCallback = {
        onSuccess = function(result)

            local function onSNSLoginResult( status, result )
                if status == SnsCallbackEvent.onSuccess then
                    local sns_token = result
                    sns_token.authorType = authorizeType

                    print("login Sns account success:" .. table.tostring(sns_token))
				    local function gotoSyncSnsFriends()
				        if authorizeType ~= PlatformAuthEnum.kPhone then
				            if not PlatformConfig:isQQPlatform() then
				                SnsProxy:setAuthorizeType(authorizeType)
				                SnsProxy:syncSnsFriend(sns_token)
				                SnsProxy:setAuthorizeType(oldAuthorizeType)
				            end
				        end

                        local weiboAccountNameAfterSync = UserManager:getInstance().profile:getSnsUsername(PlatformAuthEnum.kWeibo)
                        print("weiboAccountNameAfterSync: "..tostring(weiboAccountNameAfterSync))
				    end

                    if not isCancel then
                        --登录的qq和绑定的qq不一致
                        print("~~~~~~isQQBound: ", UserManager.getInstance().profile:isQQBound())
                        print("~~~~~~qqOpenID: ", tostring(UserManager:getInstance().qqOpenID))
                        print("~~~~~~authorizeType: ", authorizeType, PlatformAuthEnum.kQQ)
                        print("~~~~~~current bound QQ: ", sns_token.openId)
                        print("authorizeType == PlatformAuthEnum.kQQ: ", authorizeType == PlatformAuthEnum.kQQ)
                        print("UserManager:getInstance().qqOpenID ~=  sns_token.openId:", UserManager:getInstance().qqOpenID ~=  sns_token.openId)

                        if  UserManager.getInstance().profile:isQQBound() and
                            UserManager:getInstance().qqOpenID and 
                            authorizeType == PlatformAuthEnum.kQQ then
                                if	UserManager:getInstance().qqOpenID ~= sns_token.openId then
									local panel = require("zoo.panel.addfriend.QQAccountConfirmPanel"):create()
									panel:setReloginCallback(function() 
											self:doSyncQQFriends(authorizeType, onConnectFinish, onConnectError, onConnectCancel)
										end)
									panel:setCancelCallback(onConnectCancel)
									panel:popout()
                                else
                                	gotoSyncSnsFriends()
                                    print("doSyncSnsFriends called!!!!!!!")
                                end
                        else
                        	if onConnectError then
	                            onConnectError()
	                        end
                        end

                        animation:removeFromParentAndCleanup(true)
                    end
                elseif status == SnsCallbackEvent.onCancel then
                    local platform = PlatformConfig:getPlatformNameLocalization(authorizeType)
                    CommonTip:showTip(localize("add.friend.panel.cancel.login.qq", {platform = platform}))
                    animation:removeFromParentAndCleanup(true)
                    if onConnectCancel then
                        onConnectCancel()
                    end
                else 
                    if not isCancel then
                        animation:removeFromParentAndCleanup(true)
                        if onConnectError then
                            onConnectError()
                        end
                    end

                    print("bindSns:login error " .. tostring(status))
                end
            end
            SnsProxy:setAuthorizeType(authorizeType)
            SnsProxy:login(onSNSLoginResult)
            SnsProxy:setAuthorizeType(oldAuthorizeType)
        end,
        onError = function(errCode, msg) 
            if not isCancel then
                CommonTip:showTip("同步QQ好友失败！","negative")
                animation:removeFromParentAndCleanup(true)
                if onConnectError then
                    onConnectError()
                end
            end

            print("bindSns:",errCode,msg)
        end,
        onCancel = function()
            if not isCancel then
                CommonTip:showTip("您取消了同步QQ好友！","negative")
                animation:removeFromParentAndCleanup(true)
                if onConnectCancel then
                    onConnectCancel()
                end
            end

            print("bindSns: cancel")
        end
    }

    SnsProxy:setAuthorizeType(authorizeType)
    SnsProxy:logout(logoutCallback)
    SnsProxy:setAuthorizeType(oldAuthorizeType)
end

return SyncQQFriendsLogic