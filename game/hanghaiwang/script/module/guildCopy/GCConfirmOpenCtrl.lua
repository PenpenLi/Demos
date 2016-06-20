-- FileName: GCConfirmOpenCtrl.lua
-- Author: liweidong
-- Date: 2015-06-04
-- Purpose: 开启副本确认框ctrl
--[[TODO List]]

module("GCConfirmOpenCtrl", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --
local m_i18n = gi18n

local function init(...)

end

function destroy(...)
	package.loaded["GCConfirmOpenCtrl"] = nil
end

function moduleName()
    return "GCConfirmOpenCtrl"
end

function create(id)
	require "script/module/guildCopy/GCConfirmOpenView"
	return GCConfirmOpenView.create(id)
end
--创建重置确认框
function createReset(id)
	require "script/module/guildCopy/GCConfirmOpenView"
	return GCConfirmOpenView.create(id,1)
end
--确认开启
function onConfirmOpen(id)
	AudioHelper.playCommonEffect()
	local copyDb=DB_Legion_newcopy.getDataById(id)
	if (tonumber(GuildCopyModel.getActitveyNum())<tonumber(copyDb.open_need_vital)) then
		ShowNotice.showShellInfo(m_i18n[5943]) --TODO
		return
	end
	local function getDataCallBack( cbFlag, dictData, bRet )
		if(bRet == true)then
			-- DataCache.setGuildCopyData(dictData.ret)
			LayerManager.removeLayout()
			if (dictData.ret.res=="ok") then
				GuildDataModel.setGildVitality(-copyDb.open_need_vital)
			else
				ShowNotice.showShellInfo(m_i18n[5944]) --TODO
				LayerManager.removeLayout()
			end
			getCopyDataAndRefrese()
		end
	end
	local tbRpcArgs = {tonumber(id),0}
	RequestCenter.openNewGuildCopy(getDataCallBack, Network.argsHandlerOfTable(tbRpcArgs))
end
--确认重置
function onConfirmReset(id)
	AudioHelper.playCommonEffect()
	local copyDb=DB_Legion_newcopy.getDataById(id)
	if (tonumber(GuildCopyModel.getActitveyNum())<tonumber(copyDb.open_need_vital)) then
		ShowNotice.showShellInfo(m_i18n[5953]) --TODO
		return
	end
	local function getDataCallBack( cbFlag, dictData, bRet )
		if(bRet == true)then
			-- DataCache.setGuildCopyData(dictData.ret)
			LayerManager.removeLayout()
			-- LayerManager.removeLayout()
			if (dictData.ret.res=="ok") then
				GuildDataModel.setGildVitality(-copyDb.open_need_vital) --减少活跃度
			else
				ShowNotice.showShellInfo(m_i18n[5944]) --TODO
				LayerManager.removeLayout()
			end
			getCopyDataAndRefrese()
		end
	end
	require "script/module/guildCopy/GuildCopyModel"
	local process = GuildCopyModel.getProgressOfCopy(id)
	local openType = 1
	if (process>=100) then
		openType = 0
	end
	local tbRpcArgs = {tonumber(id),openType}
	RequestCenter.openNewGuildCopy(getDataCallBack, Network.argsHandlerOfTable(tbRpcArgs))
end
--重新拉取副本数据并刷新UI
function getCopyDataAndRefrese()
	-- local function getDataCallBack( cbFlag, dictData, bRet )
	-- 	if(bRet == true)then
	-- 		DataCache.setGuildCopyData(dictData.ret)
	-- 		require "script/module/guildCopy/GuildCopyMapView"
	-- 		GuildCopyMapView.updateUI()
	-- 	end
	-- end
	-- RequestCenter.getGuildCopyAllInfo(getDataCallBack)
	GuildCopyMapCtrl.onReloadMap()
end