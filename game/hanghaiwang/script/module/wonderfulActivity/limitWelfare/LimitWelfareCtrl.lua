-- FileName: LimitWelfareCtrl.lua
-- Author: Xufei
-- Date: 2015-01-19
-- Purpose: 限时福利
--[[TODO List]]

module("LimitWelfareCtrl", package.seeall)

-- UI控件引用变量 --
local _limitWelViewInstance = nil
-- 模块局部变量 --

local function init(...)

end

function destroy(...)
	package.loaded["LimitWelfareCtrl"] = nil
end

function moduleName()
    return "LimitWelfareCtrl"
end

function removeNew( ... )
	-- 移除new
	local listCell = LimitWelfareModel.getCell()
	if (listCell) then
		listCell:removeNodeByTag(100)
	end
	LimitWelfareModel.setNewAniState(1)
end

function initAndShowLimitWelView( ... )
	local limitWelfareData = LimitWelfareModel.getLimitWelfareData()
	if (limitWelfareData) then
		_limitWelViewInstance = LimitWelfareView:new()
		removeNew()
		MainWonderfulActCtrl.addLayChild(_limitWelViewInstance:create(limitWelfareData))
	else
		ShowNotice.showShellInfo("本活动已结束，谢谢参与！") -- TODO
	end
end


function create(...)
	initAndShowLimitWelView()
end
