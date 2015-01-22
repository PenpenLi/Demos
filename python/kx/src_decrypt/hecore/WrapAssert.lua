
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013年11月26日 10:19:13
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

require "hecore.display.MultiLineTextField"
require "zoo.panel.ShowLogPanel"
require "zoo.UIConfigManager"

 -------------------------
-- Create Notification Node
-- -------------------------

if not __WP8 then

    local notificationLayer = Layer:create()
    CCDirector:sharedDirector():setNotificationNode(notificationLayer.refCocosObj)

    ----------------------------------------
    ---- Replace Old Assert With New Assert
    -----------------------------------------

    local old_assert = assert
    local assertFalseNumber = 0

    local function new_assert(cond, msg)
        if not cond then
            assertFalseNumber = assertFalseNumber + 1
            local breakLine = "\n========== index: " .. assertFalseNumber .. " =============\n"
            if msg then print("assert false message: " .. msg) end
            he_log_error(breakLine .. tostring(debug.traceback()))
        end

        return cond
    end

    assert = new_assert

else -- else of wp8

    local old_assert = assert

    local function new_assert(cond, msg)
        if not cond then
            if msg then
                msg = "assert false, message: " .. msg
            else
                msg = "assert false"
            end
            local trace = tostring(debug.traceback())
            local log = msg .. "\n" .. trace
            he_log_error(msg)
            if __DEBUG then Wp8Utils:ShowMessageBox(log) end
        end

        return cond
    end

    assert = new_assert

end -- end of __WP8
