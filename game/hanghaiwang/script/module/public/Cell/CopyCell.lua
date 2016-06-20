-- FileName: CopyCell.lua
-- Author: 
-- Date: 2014-04-00
-- Purpose: function description of module
--[[TODO List]]

require "script/module/public/class"
require "script/module/public/Cell/Cell"

local m_fnGetWidget = g_fnGetWidgetByName

----------------------------- 定义副本cell CopyCell  -----------------------------
CopyCell = class("CopyCell", Cell)

function CopyCell:ctor(...)
    local tbCell = ...
    self.cell = tolua.cast(tbCell, "Layout")
end

function CopyCell:getGroup()
    if (self.mlaycell) then
        local tg = HZTouchGroup:create() -- 可接受触摸事件，传递给UIButton等UI控件
        tg:addWidget(self.mlaycell)
        return tg
    end
    return nil
end

function CopyCell:refresh(tbData)
    if (self.mlaycell) then
        local cell = self.mlaycell
        local tfdName = m_fnGetWidget(cell, "TFD_COPY1_NAME")
        tfdName:setText(tbData.copyName)

        local tfdOwn = m_fnGetWidget(cell, "TFD_OWN1")
        tfdOwn:setText(tbData.score)

        local tfdTotal = m_fnGetWidget(cell, "TFD_TOTAL1")
        tfdTotal:setText(tbData.all_stars)

        local imgCopy = m_fnGetWidget(cell, "IMG_COPY1")
        imgCopy:loadTexture(tbData.normalImg)

        local imgPassed = m_fnGetWidget(cell, "IMG_COPY_PASSED")
        local tfdCondition = m_fnGetWidget(cell, "TFD_CONDITION")
        
        if (tbData.passText) then
            imgPassed:setVisible(false)
            tfdCondition:setText(tbData.passText)
        else
            if(tbData.cross == 1) then
                imgPassed:setVisible(true)
                tfdCondition:setVisible(false)
            else
                imgPassed:setVisible(false)
                tfdCondition:setVisible(false)
            end
        end
    end
end

function CopyCell:init( tbData )
    local widget = self.cell
    if (widget) then
        self.mlaycell = widget:clone()
        self.mlaycell:setPosition(ccp(0,0))
    end 
end