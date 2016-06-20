-- FileName: TalkModel.lua
-- Author: huxiaozhou
-- Date: 2014-06-11
-- Purpose: function description of module
--[[TODO List]]
-- 对话数据模型

module("TalkModel", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --
local m_currentDialog

function getTalkById(talkID)
	m_currentDialog = nil
    require "db/talk"
    for i=1,#talk do
        if(talk[i].id == ("" .. talkID)) then
            local result = {}
            result.id = tonumber(talk[i].id)
            result.tips = talk[i].tips
            result.dialog = {}
            if(#(talk[i])>0)then
                for j=1,#(talk[i]) do
                    result.dialog[j] = talk[i][j]
                end
            else
                result.dialog[1] = talk[i].dialog
            end
             return result
        end
    end
end

function getNextDialog(tbTalk)
    local index
    if(m_currentDialog==nil)then
        index = 1
    else
        index = tonumber( m_currentDialog.option.data)
    end
    if(index==nil)then
        return nil
    end
    for i=1,#(tbTalk.dialog) do
        if(tbTalk.dialog[i].id == ("" .. index)) then
            m_currentDialog = tbTalk.dialog[i]
            return m_currentDialog
        end
    end
    
    return nil
end