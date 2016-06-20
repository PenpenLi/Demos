-- FileName: GCEnterCtrl.lua
-- Author: 
-- Date: 2014-04-00
-- Purpose: function description of module
--[[TODO List]]

module("GCEnterCtrl", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --
local m_i18n = gi18n

local function init(...)

end

function destroy(...)
	package.loaded["GCEnterCtrl"] = nil
end

function moduleName()
    return "GCEnterCtrl"
end

function create(id)
	require "script/module/guildCopy/GCEnterView"
	return GCEnterView.create(id)
end

--点击进入
function onEnterCopyHold(copyId)
	require "script/module/guildCopy/GuildCopyModel"
	local enterStatus,enterStr = GuildCopyModel.isCanEnterGuildCopy(copyId)
	if (not enterStatus) then
		ShowNotice.showShellInfo(enterStr)
		return
	end

	local function callback( cbFlag, dictData, bRet )
		if (bRet) then 
			-- 刷新单个副本数据
			local tbCopyData = DataCache.getGuildCopyData()
			tbCopyData[copyId .. ""] = dictData.ret
			
			LayerManager.removeLayout()
			require "script/module/guildCopy/GCItemCtrl"
			local item =  GCItemCtrl.create(copyId)
			LayerManager.addLayoutNoScale(item)
			GCItemView.setScrollViewPos()
		end 
	end

	-- 拉取单个副本数据，刷新当前页面
	local arg = Network.argsHandler(tonumber(copyId))
	RequestCenter.guildCopy_getOneCopyInfo(callback,arg)
end
--点击重置副本
function onResetCopy(copyId)
	require "script/module/guildCopy/GuildCopyModel"
	local process = GuildCopyModel.getProgressOfCopy(copyId)
	local guildDb=DB_Legion_copy_build.getDataById(1)
	local needProcess = tonumber(guildDb.reset_progress)
	if (process<needProcess/10000*100) then
		ShowNotice.showShellInfo(string.format(m_i18n[5937],needProcess/10000*100)) --TODO
		return
	end
	--弹出开启
	require "script/module/guildCopy/GCConfirmOpenCtrl"
	LayerManager.addLayout(GCConfirmOpenCtrl.createReset(copyId))
end