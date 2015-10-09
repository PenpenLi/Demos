--=====================================================
-- LocalNoticeUtil
-- by zhijian.li
-- (c) copyright 2009 - 2014, www.happyelements.com
-- All Rights Reserved. 
--=====================================================
-- filename:  LocalNoticeUtil.lua
-- author:    zhijian.li
-- e-mail:    zhijian.li@happyelements.com
-- created:   2014/06/20
-- descrip:   安卓本地推送lua实现（平台版）
--=====================================================
local wulinNoticeUtilBridge_java = nil;


local platformUtl = nil;
if __IOS then 
    platformUtl = PlatformUtil();
end

if __ANDROID then
    wulinNoticeUtilBridge_java = luajava.bindClass("com.happyelements.yanghuang.LYBNoticeUtil");
    local function registerAndroidLocalNotification(id, notiType, content, timeFromNow, isCancelNoti)
        local notiDay = 0;
        local notiHour = 0;
        local notiMin = 0;
        local notiInterVal = 0;
        local timeZone = "Asia/Shanghai";
        local notiText = content;
        if not isCancelNoti then
            isCancelNoti = false;
        end

        if notiType==LocalNoticeType.kDelayOnce then
            --恢复时间单位为秒
            if not timeFromNow then
                timeFromNow = -1;
            end
        else
            local sysTimeZone = MetaInfo:getInstance():getTimeZone();
            notiDay, notiHour, notiMin = getFormatTime(timeFromNow); 
            notiHour = notiHour + (tonumber(sysTimeZone) - 8); --beijing is +8 timezone
            if notiType==LocalNoticeType.kDayCircle then 
                notiInterVal = 1;
            elseif notiType==LocalNoticeType.kWeekCircle then
                notiInterVal = 7;
            end
        end
        wulinNoticeUtilBridge_java:registerLocalNotification(id, notiType, notiDay, notiHour, notiMin, timeFromNow,
                                                             notiInterVal, timeZone, notiText, isCancelNoti);
    end
end
function registerLocalNotification(id, notiType, content, timeFromNow, isCancelNoti)
    if __ANDROID then
        -- registerAndroidLocalNotification(id, notiType, content, timeFromNow, isCancelNoti)
    elseif __IOS then
        platformUtl:makeLocalNotefication(id, notiType, content, timeFromNow, isCancelNoti and 1 or 0);
    end
end