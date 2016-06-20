-- FileName: FormLitFriCtrl.lua 
-- Author: zhaoqiangjun 
-- Date: 14-6-12
-- Purpose: function description of module

module("FormLitFriCtrl", package.seeall)

require "script/module/formation/MainFormation"

local SHOW_SELF_SQUAD   = 11000
local SHOW_THEM_SQUAD   = 11001

local tbFriData
local tbBenchData

function getDataResource( litFriendInfo )
	tbFriData 			= {}
	tbBenchData         = {}
	local heroOpenForm	= litFriendInfo.heroOpenForm
	local benchForm		= litFriendInfo.benchOpen
	local showSquadTye	= litFriendInfo.squadType
	local litFriendData	= litFriendInfo.litFriendData
	local benchData		= litFriendInfo.benchData

	local index = 1

	for i = 0, heroOpenForm - 1 do
		local herohid
		if showSquadTye == SHOW_SELF_SQUAD then
            herohid     = tonumber(litFriendData[tostring(i)])
        elseif showSquadTye == SHOW_THEM_SQUAD then
            herohid     = tonumber(litFriendData[i + 1])
        end
        
        if (herohid ~= 0) then
            local heroInfo = MainFormation.getHeroInfoByHid(herohid)
            tbFriData[index] = heroInfo
        	index = index + 1
        end
	end

	index = 1

	for i = 0, benchForm - 1 do
		local herohid = 0
		if showSquadTye == SHOW_SELF_SQUAD then
            herohid = tonumber(benchData[tostring(i)]) or 0
        elseif showSquadTye == SHOW_THEM_SQUAD then
        	local pinfo = benchData[i+1] or nil
        	if(pinfo and (tonumber(pinfo) ~= 0)) then
	            herohid = tonumber(pinfo.hid) or 0
	        end
        end
        
        if (herohid ~= 0 and herohid ~= -1) then
            local heroInfo = MainFormation.getHeroInfoByHid(herohid)
            tbBenchData[index] = heroInfo
        	index = index + 1
        end
	end

	return tbFriData , tbBenchData
end