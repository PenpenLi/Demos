require "zoo.panel.phone.LoginAndRegisterPanel"
require "zoo.panel.phone.OtherLoginPanel"
require "zoo.panel.phone.PhoneLoginPanel"
require "zoo.panel.phone.PhoneRegisterPanel"

local Processor = class(EventDispatcher)
Processor.Events = {
	kSnsLogin = "snslogin",
	kPhoneLoginComplete = "phoneLogin",
	kCancel = "cancel",
}

function Processor:onCancel( ... )
    self:dispatchEvent(Event.new(self.Events.kCancel,nil,self))
end

function Processor:onPhoneLoginComplete( openId,phoneNumber )
    if SnsProxy:getAuthorizeType() == PlatformAuthEnum.kPhone then
        _G.sns_token = { openId=openId,accessToken="",authorType=PlatformAuthEnum.kPhone }
        Localhost:writeCachePhoneListData(phoneNumber)
        
        self:dispatchEvent(Event.new(self.Events.kPhoneLoginComplete,nil,self))
    else
        SnsProxy:logout({
            onSuccess = function( ... )
                _G.sns_token = { openId=openId,accessToken="", authorType=PlatformAuthEnum.kPhone }
                Localhost:writeCachePhoneListData(phoneNumber)
                SnsProxy:setAuthorizeType(PlatformAuthEnum.kPhone)
        
                self:dispatchEvent(Event.new(self.Events.kPhoneLoginComplete,nil,self))
            end,
            onError = function( ... )
                self:dispatchEvent(Event.new(self.Events.kError, nil, self))
            end,
            onCancel = function( ... )
                self:dispatchEvent(Event.new(self.Events.kCancel, nil, self))
            end
        })
    end
end

function Processor:onSelectSnsLogin( authEnum )
    if SnsProxy:getAuthorizeType() == PlatformAuthEnum.kPhone then
        SnsProxy:setAuthorizeType(authEnum)
        self:dispatchEvent(Event.new(self.Events.kSnsLogin,authEnum,self))
    else
        SnsProxy:logout({
            onSuccess = function( ... )
                SnsProxy:setAuthorizeType(authEnum)
                self:dispatchEvent(Event.new(self.Events.kSnsLogin,authEnum,self))
            end,
            onError = function( ... )
                self:dispatchEvent(Event.new(self.Events.kError, nil, self))
            end,
            onCancel = function( ... )
                self:dispatchEvent(Event.new(self.Events.kCancel, nil, self))
            end
        })
    end
end

function Processor:start(context,isChangeAccount,lastPhoneLoginExpire)
    
    local object = nil

    local panel = nil
    if lastPhoneLoginExpire then
        object = PlatformAuthEnum.kPhone
        panel = PhoneLoginPanel:create(function( ... )
            self:onCancel()
        end,nil)
        panel:setPhoneNumber(Localhost:getLastLoginPhoneNumber())
        panel:showCloseButton()

    elseif PlatformConfig:isMultipleAuthConfig() then
        panel = OtherLoginPanel:create(function( ... )
            self:onCancel()
        end)

    elseif PlatformConfig:hasAuthConfig(PlatformAuthEnum.kPhone) then
        object = PlatformAuthEnum.kPhone
        local authEnum = object
        panel = PhoneLoginPanel:create(function( ... )
            self:onCancel()
        end,nil)
        panel:showCloseButton()

    else--直接登录
        object = SnsProxy:getAuthorizeType()
        local authEnum = SnsProxy:getAuthorizeType()
        self:dispatchEvent(Event.new(self.Events.kSnsLogin,authEnum,self))

    end

    if panel then
        if isChangeAccount then 
            panel:setAction("ChangeAccountMode")
        else
            panel:setAction("NormalMode")
        end
        panel:setPhoneLoginCompleteCallback(function( openId,phoneNumber )
            self:onPhoneLoginComplete(openId,phoneNumber)
        end)
        panel:setSelectSnsCallback(function( authEnum )
            self:onSelectSnsLogin(authEnum)
        end)
        panel:setPlace(1)
        panel:popout()
    end

    if object == nil then
        if isChangeAccount then
            DcUtil:UserTrack({ category='login', sub_category='login_click_switch_account' })
        else
            DcUtil:UserTrack({ category='login', sub_category='login_click_account' })
        end
    else
        if isChangeAccount then 
            DcUtil:UserTrack({ category='login', sub_category='login_switch_account_type',object=object })
        else
            DcUtil:UserTrack({ category='login', sub_category='login_account_type',object=object })
        end      
    end
end

return Processor