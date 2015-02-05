
require "zoo.net.QzoneSyncLogic"
require "zoo.panel.SelectSNSAccountLoginPanel"

local Processor = class(EventDispatcher)

Processor.Events = {
	kComplete = "complete",
	kMergeComplete = "mergeComplete",
	kQQLogin = "qqLogin",
	kWeiboLogin = "weiboLogin",
	kCancel = "cancel",
	kMergeError = "mergeError",
	kError = "error",
}

function Processor:checkWeiboLogin( openId,accessToken )
	local function onFinish( data )
		print("checkWeiboLogin onFinish openId:" .. openId .. " " .. table.tostring(data))

		if not data then 
			self:dispatchEvent(Event.new(Processor.Events.kError, nil, self))
		else
			if not data.qqConnected then --拒绝未绑定的微博账号 
				self:snsLogout(function( ... )
					self:popoutNoWeiboDataPanel()
				end)
			else
				self:dispatchEvent(Event.new(Processor.Events.kComplete, nil, self))
			end
		end
	end

	QzoneSyncLogic:preconnect(openId,accessToken,onFinish,true)
end


function Processor:start(context)
	self.context = context

	local openId = nil 
	local accessToken = nil
	
	if _G.sns_token then
		openId = _G.sns_token.openId
		accessToken = _G.sns_token.accessToken
	end

	--未登陆
	if not _G.origin_auth_type or _G.origin_auth_type == PlatformAuthEnum.kQQ then 
		if SnsProxy:getAuthorizeType() == PlatformAuthEnum.kQQ then
			self:dispatchEvent(Event.new(Processor.Events.kComplete, nil, self))
		else
			self:checkWeiboLogin(openId,accessToken)
		end
	else --PlatformAuthEnum.kWeibo

		if SnsProxy:getAuthorizeType() == PlatformAuthEnum.kQQ then 
			local function onFinish( data )
				print("checkQQLogin onFinish openId:" .. openId .. " " .. table.tostring(data))

				if not data then 
					self:dispatchEvent(Event.new(Processor.Events.kError, nil, self))
				else
					if not data.qqConnected then --未绑定过的qq账号，数据合并过去
						self:weiboMergeToQQAccount(_G.origin_openId,openId,accessToken)
					else
						if _G.isWeiboCacheLogin then
							self:snsLogout(function( ... )
								CommonTip:showTip(
									-- "报错，提示玩家用新QQ号码导入游戏数据", 
									Localization:getInstance():getText("loading.tips.register.failure.5"),	
									"negative",
									function( ... )
										self:dispatchEvent(Event.new(Processor.Events.kMergeError, true, self))
									end,
									5
								)
							end)
						else
							-- 直接切换新QQ账号
							self:dispatchEvent(Event.new(Processor.Events.kComplete,nil,self))
						end
					end
				end
			end
			QzoneSyncLogic:preconnect(openId,accessToken,onFinish,true)
		else
			self:checkWeiboLogin(openId,accessToken)
		end
	end

end

function Processor:popoutNoWeiboDataPanel( ... )
	local panel = NoWeiboDataPanel:create()
	panel:popout()

	panel:setWeiboLoginButtonCallback(function( ... )
		self:dispatchEvent(Event.new(Processor.Events.kWeiboLogin,nil, self))
	end)

	panel:setQQLoginButtonCallback(function( ... )
		self:dispatchEvent(Event.new(Processor.Events.kQQLogin,nil, self))
	end)

	panel:setCloseButtonCallback(function( ... )
		self:dispatchEvent(Event.new(Processor.Events.kCancel, nil, self))
	end)
end

function Processor:weiboMergeToQQAccount( weiboOpenId,qqOpenId,qqAccessToken )

    local function onReqFinish(evt)
    	--  uuid
    	-- evt.data.uuid
    		-- evt.data.uid
    	_G.kDeviceID = evt.data.uuid
    	UdidUtil:saveUdid(_G.kDeviceID)
    	-- 

		local loginInfo = { uid = evt.data.uid, sk = evt.data.uuid, p = kDefaultSocialPlatform }

  		self:doLogin(loginInfo,function( ... )

  			Localhost.getInstance():setCurrentUserOpenId(qqOpenId,qqAccessToken)

	    	local panel = WeiboMergeToQQSuccessPanel:create()
	    	panel:popout()

	    	panel:setOkButtonCallback(function( ... )
		        self:dispatchEvent(Event.new(Processor.Events.kComplete, nil, self))
	    	end)

  		end)

        evt.target:rma()
    end
    local function onReqError(evt)
        evt.target:rma()

        -- TODO:
        self:dispatchEvent(Event.new(Processor.Events.kError, nil, self))
    end
    local http = MergeConnectHttp.new()
    http:addEventListener(Events.kComplete, onReqFinish)
    http:addEventListener(Events.kError, onReqError)
    http:load(weiboOpenId,qqOpenId)
end


function Processor:snsLogout(successCallback) 
   local logoutCallback = {
        onSuccess = function(result)
            successCallback()
        end,
        onError = function(errCode, msg) 
            self:dispatchEvent(Event.new(Processor.Events.kError, nil, self))
        end,
        onCancel = function()
            self:dispatchEvent(Event.new(Processor.Events.kCancel, nil, self))
        end
    }
    SnsProxy:logout(logoutCallback)
end

function Processor:doLogin(loginInfo,successCallback )
	local userId = loginInfo.uid
	local sessionKey = loginInfo.sk
	local platform = loginInfo.p

    if __IOS then
        GspEnvironment:getInstance():setGameUserId(tostring(userId))
    elseif __ANDROID then 
        GspProxy:setGameUserId(tostring(userId)) 
    end

    HeGameDefault:setUserId(tostring(userId))
    DcUtil:dailyUser()


    local function onLoginFinish( evt )
        successCallback()
    end 

    local function onLoginFail(evt)
        self:dispatchEvent(Event.new(Processor.Events.kError, nil, self))
    end

    print(userId, sessionKey)

    local logic = LoginLogic.new()
    logic:addEventListener(Events.kComplete, onLoginFinish)
    logic:addEventListener(Events.kError, onLoginFail)
    logic:execute(userId, sessionKey, platform, 30)
end


return Processor