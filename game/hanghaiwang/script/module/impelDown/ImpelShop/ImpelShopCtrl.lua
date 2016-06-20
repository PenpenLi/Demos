-- FileName: ImpelShopCtrl.lua
-- Author: LvNanchun
-- Date: 2015-09-09
-- Purpose: function description of module
--[[TODO List]]

module("ImpelShopCtrl", package.seeall)
require "script/module/impelDown/ImpelShop/ImpelShopModel"

-- UI variable --

-- module local variable --

local function init(...)

end

function destroy(...)
    package.loaded["ImpelShopCtrl"] = nil
end

function moduleName()
    return "ImpelShopCtrl"
end

--[[desc:功能简介
    arg1: tbData = {cache = , from = }cache为boolen，表示是否需要缓存前一界面，from为返回按钮的事件，不存在则默认返回深海监狱界面。
    return: 是否有返回值，返回值说明  
—]]
function create( tbData )
	local function impelShopInfoCallBack( cbFlag, dictData, bRet )
		if (bRet) then
			logger:debug({impelDowmDictData = dictData})
			ImpelShopModel.setBoughtNum(dictData.ret.hadBuyGoodsNum)
			ImpelShopModel.setMaxLevel(tonumber(dictData.ret.max_level))
			require "script/module/impelDown/ImpelShop/ImpelShopView"
			local instanceView = ImpelShopView:new()
			if (tbData and tbData.cache) then
				LayerManager.changeModule(instanceView:create( tbData ), moduleName(), {1,3}, true , 1)
			else
				LayerManager.changeModule(instanceView:create( tbData ), moduleName(), {1,3}, true)
			end
			PlayerPanel.addForImpelDown()
		end
	end
	RequestCenter.impelDown_getTowerShopInfo(impelShopInfoCallBack)
end

