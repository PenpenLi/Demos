require "zoo.util.NewVersionUtil"
require "zoo.util.ReachabilityUtil"
require "zoo.net.Localhost"

local iosShortVersionKey = "animal_apple_short_ver_9"
local alertNumKey = "animal_apple_update_alert_num_8"
local alertVersionKey = "animal_apple_update_alert_verion_6"
local iosReleaseNotesKey = "animal_apple_update_note_41"
local preAlertDateKey = "animal_apple_update_date_90"
local instance = nil

UpdateCheckUtils = class()
local m = UpdateCheckUtils
local userDefault = CCUserDefault:sharedUserDefault()
local ver
local alertNum = userDefault:getIntegerForKey(alertNumKey, 0)
local currVer = userDefault:getStringForKey(iosShortVersionKey, "")
local lvs
local releaseNote = userDefault:getStringForKey(iosReleaseNotesKey, "")
local preAlertDate = userDefault:getIntegerForKey(preAlertDateKey, 0)
local today = tonumber(os.date("%y%m%d", Localhost:timeInSec()))

function m:getInstance()
	if not instance then instance = UpdateCheckUtils.new() end
	return instance
end

function m:ctor()
	print("=========== ucu init ===========")
end

function m:run()
    local isAlerted = today <= preAlertDate
	if __IOS and not __IOS_FB and not isAlerted then
        ver = AppController:getBundleShortVersion()
        lvs = ver:split(".")

		if MaintenanceManager:getInstance():isEnabled("NewVersionNotice") then
			if currVer and currVer ~= "" and currVer ~= "nil" then -- read from cache
		        if self:checkVersion(currVer) then
		            print("check local Version>>>>>>>>>>>>>>")
		            if self:checkAlertNum() then
		                self:showUpdateConfirm()
		                return
		            end
		        end
		    end
		    self:requestNewVersion()
		end
	end
end

function m:checkVersion(v)
	print("checkVersion>>>>>>>>>>>>>>", ver, v)
    local nvs = v:split(".")

    if #lvs == #nvs then
        for i = 1, #lvs do
            if tonumber(nvs[i]) > tonumber(lvs[i]) then return true end
        end
    end
    return false
end

function m:checkAlertNum()
    local checkver = userDefault:getStringForKey(alertVersionKey, "")
    if checkver ~= "" then
        if checkver == currVer then
            if alertNum < 3 then
                print("check alert num>>>>>>>>>>>>>", alertNum)
                userDefault:setIntegerForKey(alertNumKey, alertNum + 1)
                userDefault:flush()
                return true
            else
                print("check alert num over 3 time>>>>>>>>>")
                return false
            end
        end
    end
    userDefault:setStringForKey(alertVersionKey, currVer)
    userDefault:setIntegerForKey(alertNumKey, 1)
    userDefault:flush()
    print("check alert num>>>>>>>>>>>>>new version")
    return true
end

function m:showUpdateConfirm()
	if ReachabilityUtil.getInstance():isEnableWIFI() then 
	    local function onUIAlertViewCallback( alertView, buttonIndex )
	        if buttonIndex == 1 then
	            NewVersionUtil:gotoAppleStore()
	        end
	    end
	    local title = Localization:getInstance():getText("new.version.dynamic.title")
	    local okLabel = Localization:getInstance():getText("new.version.ios.notice.confirm")
	    local cancelLabel = Localization:getInstance():getText("new.version.ios.notice.later")
	    local UIAlertViewClass = require "zoo.util.UIAlertViewDelegateImpl"
	    local alert = UIAlertViewClass:buildUI(title, releaseNote, cancelLabel, onUIAlertViewCallback)
	    alert:addButtonWithTitle(okLabel)
	    alert:show()

        preAlertDate = today
        userDefault:setIntegerForKey(preAlertDateKey, today)
        userDefault:flush()
	end
end

function m:requestNewVersion()
    print("requestNewVersion>>>>>>>>>>>>>>")
    if ReachabilityUtil.getInstance():isEnableWIFI() then  
        print("start check, local:", ver)
        local function onCheckResponse( response )
            if response.httpCode == 200 then
                local message = response.body
                print("check response:", message)
                
                local json  = table.deserialize(message)
                if json and json.results and #json.results > 0 then
                    currVer = json.results[1].version
                    releaseNote = json.results[1].releaseNotes
                    local s = string.find(releaseNote, "\n")
                    if s then
                        releaseNote = string.sub(releaseNote, 1, s)
                    end

                    --currVer = "1.1.13"
                    print("requestNewVersion>>>>>>>>>>>>>>", currVer)
                    userDefault:setStringForKey(iosShortVersionKey, currVer)
                    userDefault:setStringForKey(iosReleaseNotesKey, releaseNote)
                    userDefault:flush()

                    if self:checkVersion(currVer) then
                        if self:checkAlertNum() then
                            self:showUpdateConfirm()
                        end
                    end
                end
            end
        end

        local url = "http://itunes.apple.com/cn/lookup?id=791532221"
        local timeout = 1000
        local request = HttpRequest:createGet(url)
        request:setConnectionTimeoutMs(timeout)
        request:setTimeoutMs(timeout * 10)
        HttpClient:getInstance():sendRequest(onCheckResponse, request)
    end
end

