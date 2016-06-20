-- FileName: GCSharedRecordCtrl.lua
-- Author: yangna
-- Date: 2015-06-02
-- Purpose: 奖励分配记录 控制
--[[TODO List]]

module("GCSharedRecordCtrl", package.seeall)

require "script/module/guildCopy/GCSharedRecordView"
-- UI控件引用变量 --

-- 模块局部变量 --
local tbArgs = {}
local _instanceView = nil

local function init(...)
	_instanceView = nil
end

function destroy(...)
	package.loaded["GCSharedRecordCtrl"] = nil
end

function moduleName()
    return "GCSharedRecordCtrl"
end

local tbArgs = {}


-- 默认的关闭按钮事件
tbArgs.onClose = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCloseEffect()
		LayerManager.removeLayout()
		GuildCopyMapCtrl.setGuildType(0)
	end
end

function create(...)
	init()

	local function callBack( cbFlag, dictData, bRet )
		if (bRet) then 
			local tbData = {}
			for i=1,table.count(dictData.ret) do 
				local data = dictData.ret[i]
				for k,v in pairs(data.va_recorder) do 
					local cell = {}
					cell.reward_time = data.reward_time
					cell.record_type = data.record_type 
					cell.va_recorder = v
					table.insert(tbData,cell)
				end 
			end 

			_instanceView = GCSharedRecordView:new()
			local layMain = _instanceView:create()
			_instanceView:init(tbData)
			LayerManager.addLayout(layMain)
			GuildCopyMapCtrl.setGuildType(1)
		end 
	end


	local offset = 0   --偏移量
	local limit = 100  --获取的数量
	local arg = Network.argsHandler( tonumber(offset) ,tonumber(limit))
	RequestCenter.guildCopy_getDistriHistory(callBack,arg)

	return layMain
end
