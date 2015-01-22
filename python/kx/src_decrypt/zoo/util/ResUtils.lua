require "hecore.display.CocosObject"
ResUtils = class()

function ResUtils:ctor()
end

function ResUtils:getResFromUrls( urls , callback )
    --urls is a table
    local function loadThirdPartyResCallback(eventName, data)
      if eventName == ResCallbackEvent.onError then
        he_log_info("load third party res error, errorCode: " .. data.errorCode .. ", item: " .. data.item)
      elseif eventName == ResCallbackEvent.onSuccess then
        -- data is a table: { url=xxx, realPath=xxx }
        --he_log_info("load third party res success " .. table.tostring(data))
        callback(data)
      end
    end
    ResourceLoader.loadThirdPartyRes(urls, loadThirdPartyResCallback)
end