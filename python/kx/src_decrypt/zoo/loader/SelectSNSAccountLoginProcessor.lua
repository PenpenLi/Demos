
require "zoo.panel.SelectSNSAccountLoginPanel"

local Processor = class(EventDispatcher)

Processor.Events = {
	kComplete = "complete",
	kCancel = "cancel",
	kError = "error",
	kWeiboCacheLogin = "weiboCacheLogin"
	-- kQQChangeQQAccountLogin = "qqChangeQQAccountLogin"
}

function Processor:start(context,isWeiboCacheLogin,isErrorBack)
	self.context = context

	if isWeiboCacheLogin then 
		local thisWeekNoSelectAccount = CCUserDefault:sharedUserDefault():getIntegerForKey("thisWeekNoSelectAccount")
	 	print("isWeiboCacheLogin " .. thisWeekNoSelectAccount)
	 	if os.time() - thisWeekNoSelectAccount < 7 * 24 * 60 * 60 then --微博本周直接登录
			self:dispatchEvent(Event.new(Processor.Events.kWeiboCacheLogin,nil, self))
			return
		end 
	end
	
	local panel = SelectSNSAccountLoginPanel:create(isWeiboCacheLogin)
	panel:popout()

	panel:setQQLoginButtonCallback(function( ... )
		-- if _G.origin_auth_type == PlatformAuthEnum.kQQ then --QQ换QQ
		-- 	self:dispatchEvent(Event.new(Processor.Events.kQQChangeQQAccountLogin,nil,self))
		-- else
			self:dispatchEvent(Event.new(Processor.Events.kComplete,PlatformAuthEnum.kQQ,self))
		-- end
	end)

	panel:setWeiboLoginButtonCallback(function( ... )

		if isWeiboCacheLogin then --微博直接登录
			if SnsProxy:isLogin() and SnsProxy:getAuthorizeType() == PlatformAuthEnum.kWeibo then -- 原来的账号没退出
				self:dispatchEvent(Event.new(Processor.Events.kWeiboCacheLogin,nil, self))
			else
				self:dispatchEvent(Event.new(Processor.Events.kComplete, PlatformAuthEnum.kWeibo, self))
			end
			
			if panel:isThisWeekNoSelectAccount() then
				CCUserDefault:sharedUserDefault():setIntegerForKey("thisWeekNoSelectAccount",os.time())
				CCUserDefault:sharedUserDefault():flush()
			end
		else --切换微博账号
			self:dispatchEvent(Event.new(Processor.Events.kComplete, PlatformAuthEnum.kWeibo, self))			
		end
	end)

	panel:setCloseButtonCallback(function( ... )
		self:dispatchEvent(Event.new(Events.kCancel, nil, self))
	end)

	if isErrorBack then
		return 
	end 

    local isLogin = false
    if SnsProxy and SnsProxy.isLogin and type(SnsProxy.isLogin) == "function" then
        isLogin = SnsProxy:isLogin()
    end

    _G.isWeiboCacheLogin = isWeiboCacheLogin
    if isLogin then 
		_G.origin_auth_type = nil--PlatformAuthEnum.kWeibo
		_G.origin_openId = nil
   		local lastLoginUser = Localhost.getInstance():getLastLoginUserConfig()    	
		if lastLoginUser then 
			local userData = Localhost.getInstance():readUserDataByUserID(lastLoginUser.uid)
			if userData and userData.openId and userData.authorType then
				_G.origin_auth_type = userData.authorType
				_G.origin_openId = userData.openId 
			end
		end
	else
		_G.origin_auth_type = nil
    end
end

return Processor