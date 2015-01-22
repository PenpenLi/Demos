
local Processor = class(EventDispatcher)

function Processor:start()
    if __ANDROID then
        self:getLocationInfo()
        self:initDecisionScript()
    end
end

function Processor:getLocationInfo()
    local callbackHanler = function(response)
        if response.httpCode == 200 then
            if type(response) == "table" and type(response.body) == "string" then
                local tab = table.deserialize(response.body)
                if type(tab) == "table" then
                    local province = tab.province
                    if type(province) == "string" and string.len(province) > 0 then
                        Cookie.getInstance():write(CookieKey.kLocationProvince, province)
                    end
                end
            end
        end
    end

    local request = HttpRequest:createPost("http://int.dpool.sina.com.cn/iplookup/iplookup.php?format=json")
    request:setConnectionTimeoutMs(1000)
    request:setTimeoutMs(1000)
    HttpClient:getInstance():sendRequest(callbackHanler, request)

end

function Processor:initDecisionScript()
    AndroidPayment.getInstance():initCMPaymentDecisionScript()
end

return Processor