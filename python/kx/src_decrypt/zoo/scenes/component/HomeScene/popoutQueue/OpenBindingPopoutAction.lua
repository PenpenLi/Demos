require "zoo.common.FAQ"

OpenBindingPopoutAction = class(HomeScenePopoutAction)

function OpenBindingPopoutAction:ctor(url)
    self.url = url
end

function OpenBindingPopoutAction:popout( ... )
    if not self.url then
        self:placeholder()
        self:next()
        return
    end

    if not string.find(self.url,"happyelements%.com/") then
        self:placeholder()
        self:next()
        return
    end

    if __IOS then 
        GspEnvironment:getCustomerSupportAgent():setExtraParams(FAQ:getParams()) 
        GspEnvironment:getCustomerSupportAgent():setFAQurl(FAQ:getUrl(self.url)) 
        GspEnvironment:getCustomerSupportAgent():ShowJiraMain() 
    elseif __ANDROID then
        GspProxy:setExtraParams(FAQ:getParams())
        GspProxy:setFAQurl(FAQ:getUrl(self.url))
        GspProxy:showCustomerDiaLog()  
    end

    self:next()
end


function OpenBindingPopoutAction:getConditions( ... )
    return {"enter","enterForground","preActionNext"}
end