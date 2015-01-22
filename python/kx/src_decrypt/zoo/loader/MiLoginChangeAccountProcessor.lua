require "zoo.panel.MiLoginRecommendPanel"
require "zoo.net.QzoneSyncLogic"

local Processor = class(EventDispatcher)

Processor.Events = {
	kComplete	= "milogin_complete",
	kCancel		= "milogin_cancel",
	kError		= "milogin_error",
	kAsGuest	= "milogin_asguest",
}

function Processor:start(context)
	self.context = context
    _G.origin_auth_type = nil
	if sns_token.accessToken then -- 未登录，点击登录账号
		local function onFinish(result)
	        print("preconnect:"..table.tostring(result))
	        if not result then
	            self:dispatchEvent(Event.new(self.Events.kError, nil, self))
	        else
	            if result.qqConnected then -- 登录的微博账号有数据
                    _G.origin_auth_type = PlatformAuthEnum.kWeibo
	                self:changeWithWeiboData(result)
	            else -- 登录的微博没有绑定过游戏账号
	            	self:changeWithoutWeiboData()
	            end
	        end
	    end
	    QzoneSyncLogic:preconnect(sns_token.openId, sns_token.accessToken, onFinish)
	else -- 已登录，点击开始游戏
		self:changeWithWeiboData(result)
	end
end

function Processor:changeWithWeiboData(data)
	local function onCancel()
		print("changeWithWeiboData:onCancel")
		self:dispatchEvent(Event.new(self.Events.kComplete, nil, self))
	end

	local rcmdPanel = MiLoginRecommendPanel:create(onCancel)
	rcmdPanel.infoLabel:setString(Localization:getInstance():getText("loading.tips.account.login.sucess"))
    rcmdPanel.normalBtn:setString(Localization:getInstance():getText("loading.tips.login.later"))
    local pfMi = Localization:getInstance():getText("platform.mi")
    rcmdPanel.recommendBtn:setString(Localization:getInstance():getText("loading.tips.login.snsid.login", {platform=pfMi}))

    local function onNormalBtnTapped(evt)
        rcmdPanel:dismiss()
        self:dispatchEvent(Event.new(self.Events.kComplete, nil, self))
    end
    rcmdPanel.normalBtn:addEventListener(DisplayEvents.kTouchTap, onNormalBtnTapped)

    local function onRecommendBtnTapped()
        rcmdPanel:dismiss()
        self:updateStatusLabel(Localization:getInstance():getText("loading.tips.loging.mi.account.tips"))
        local logoutCallback = {
            onSuccess = function(result)
				rcmdPanel:dismiss()
                self:mergeWeiboDataToMi(result)
            end,

            onError = function(errCode, msg) 
            	self:dispatchEvent(Event.new(self.Events.kError, nil, self))
            end,

            onCancel = function()
            	self:dispatchEvent(Event.new(self.Events.kCancel, nil, self))
            end
        }
        SnsProxy:logout(logoutCallback)
    end
    rcmdPanel.recommendBtn:addEventListener(DisplayEvents.kTouchTap, onRecommendBtnTapped)
    rcmdPanel:popout()
end

function Processor:changeWithoutWeiboData()
	local function onCancel()
		print("changeWithoutWeiboData:onCancel")
		self:dispatchEvent(Event.new(self.Events.kCancel, nil, self))
	end

	local rcmdPanel = MiLoginRecommendPanel:create(onCancel)
    rcmdPanel.infoLabel:setString(Localization:getInstance():getText("loading.tips.account.no.game.data"))
    rcmdPanel.normalBtn:setString(Localization:getInstance():getText("loading.tips.start.btn.guest"))
    local pfMi = Localization:getInstance():getText("platform.mi")
    rcmdPanel.recommendBtn:setString(Localization:getInstance():getText("loading.tips.login.snsid.login", {platform=pfMi}))

    local function onNormalBtnTapped(evt)
        local logoutCallback = {
            onSuccess = function(result)
                rcmdPanel:dismiss()
                self:dispatchEvent(Event.new(self.Events.kAsGuest, nil, self))
            end,

            onError = function(errCode, msg) 
            	self:dispatchEvent(Event.new(self.Events.kError, nil, self))
            end,

            onCancel = function()
            	self:dispatchEvent(Event.new(self.Events.kCancel, nil, self))
            end
        }
        SnsProxy:logout(logoutCallback) 
    end
    rcmdPanel.normalBtn:addEventListener(DisplayEvents.kTouchTap, onNormalBtnTapped)

	local function onRecommendBtnTapped()
        rcmdPanel:dismiss()
        self:updateStatusLabel(Localization:getInstance():getText("loading.tips.loging.mi.account.tips"))
        local logoutCallback = {
            onSuccess = function(result)
				rcmdPanel:dismiss()
				if self.context then self.context:logout() end
                self:loginAsMi(result)
            end,

            onError = function(errCode, msg) 
           	 	self:dispatchEvent(Event.new(self.Events.kError, nil, self))
            end,

            onCancel = function()
            	self:dispatchEvent(Event.new(self.Events.kCancel, nil, self))
            end
        }
        SnsProxy:logout(logoutCallback)
    end
    rcmdPanel.recommendBtn:addEventListener(DisplayEvents.kTouchTap, onRecommendBtnTapped)
    rcmdPanel:popout()
end

function Processor:loginAsMi( ... )
	self:updateStatusLabel(Localization:getInstance():getText("loading.tips.loging.mi.account.tips"))
	SnsProxy:setAuthorizeType(PlatformAuthEnum.kMI)

    local function onSNSLoginResult( status, result )
        if status == SnsCallbackEvent.onSuccess and result then
            _G.sns_token = result
            self:dispatchEvent(Event.new(self.Events.kComplete, nil, self))
        else 
            self:dispatchEvent(Event.new(self.Events.kError, nil, self))
        end
    end
    SnsProxy:login(onSNSLoginResult)
end

function Processor:mergeWeiboDataToMi(data)
    SnsProxy:setAuthorizeType(PlatformAuthEnum.kMI)

    local function onSNSLoginResult( status, result )
        if status == SnsCallbackEvent.onSuccess and result then
        	-- self:updateStatusLabel("正在合并账号数据...")
			local openIdFrom = _G.sns_token.openId
            local pfFrom = PlatformConfig:getPlatformAuthName(PlatformAuthEnum.kWeibo) or "weibo"
            local pfTo = PlatformConfig:getPlatformAuthName(PlatformAuthEnum.kMI) or "mi"
            local openIdTo = result.openId

            local function onReqFinish(evt)
                evt.target:rma()
                _G.sns_token = result
                self:dispatchEvent(Event.new(self.Events.kComplete, nil, self))
            end
            local function onReqError(evt)
                evt.target:rma()
                self:dispatchEvent(Event.new(self.Events.kError, nil, self))
            end
            local http = MergeConnectHttp.new()
            http:addEventListener(Events.kComplete, onReqFinish)
            http:addEventListener(Events.kError, onReqError)
            http:load(openIdFrom, pfFrom, openIdTo, pfTo)
        else 
            self:dispatchEvent(Event.new(self.Events.kError, nil, self))
        end
    end
    SnsProxy:login(onSNSLoginResult)
end

function Processor:cleatStatus()
	if self.context then self.context:clearStatus() end
end

function Processor:updateStatusLabel( text )
	if self.context then self.context:updateStatusLabel(text) end
end

return Processor