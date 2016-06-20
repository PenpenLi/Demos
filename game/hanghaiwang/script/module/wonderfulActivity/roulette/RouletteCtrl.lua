-- FileName: RouletteCtrl.lua
-- Author: lvnanchun
-- Date: 2015-08-17
-- Purpose: 幸运转盘控制器
--[[TODO List]]

module("RouletteCtrl", package.seeall)


-- UI variable --

-- module local variable --

local function init(...)

end

function destroy(...)
    package.loaded["RouletteCtrl"] = nil
end

function moduleName()
    return "RouletteCtrl"
end

function create(...)
	local function rouletteInfoCallBack( cbFlag, dictData, bRet )
		if (bRet) then
			logger:debug({rouletteDictData = dictData})
			require "script/module/wonderfulActivity/roulette/RouletteView"
			local instanceView = RouletteView:new()
			MainWonderfulActCtrl.addLayChild(instanceView:create(dictData.ret))
		end
	end
	RequestCenter.roulette_getTurntableInfo(rouletteInfoCallBack)
end

