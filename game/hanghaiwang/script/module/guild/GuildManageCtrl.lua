-- FileName: GuildManageCtrl.lua
-- Author: huxiaozhou
-- Date: 2014-09-16
-- Purpose: function description of module
--[[TODO List]]
-- 点击管理弹出的二级管理面板控制

module("GuildManageCtrl", package.seeall)
require "script/module/guild/GuildManageView"
require "script/module/guildCopy/GCDistributionCtrl"
-- UI控件引用变量 --

-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString = gi18nString

local function init(...)

end

function destroy(...)
	package.loaded["GuildManageCtrl"] = nil
end

function moduleName()
    return "GuildManageCtrl"
end

function create(...)

	local tbEvents = {}
	-- 宣言
	tbEvents.fnAnnounce = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			LayerManager.removeLayout()
			logger:debug("fnAnnounce")
			require "script/module/guild/GuildAnnounceCtrl"
			GuildAnnounceCtrl.create()
		end
	end

	-- 密码
	tbEvents.fnPassword = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("fnPassword")
			AudioHelper.playCommonEffect()
			LayerManager.removeLayout()
			local _sigleGuildInfo = GuildDataModel.getMineSigleGuildInfo()
			if (tonumber(_sigleGuildInfo.member_type) == 1) then
				require "script/module/guild/ChangePasswordCtrl"
				ChangePasswordCtrl.create()
			else
				ShowNotice.showShellInfo(m_i18n[3540])
			end
		end
	end

	--  成员审核
	tbEvents.fnVerify = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("fnVerify")
			AudioHelper.playCommonEffect()
			LayerManager.removeLayout()
			require "script/module/guild/GuildMemberCtrl"
			GuildMemberCtrl.create(2)
		end
	end

	-- 解散联盟
	tbEvents.fnDissolve = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("fnDissolve")
			AudioHelper.playCommonEffect()
			LayerManager.removeLayout()
			local _sigleGuildInfo = GuildDataModel.getMineSigleGuildInfo()
			if (tonumber(_sigleGuildInfo.member_type) == 1) then
				local guildInfo = GuildDataModel.getGuildInfo()
				if tonumber(guildInfo.guild_level) >= 5 then
		            ShowNotice.showShellInfo(m_i18n[3577])
		        elseif tonumber(guildInfo.member_num) > 1 then
		          	ShowNotice.showShellInfo(m_i18n[3687])
		        else
					require "script/module/guild/GuildDissolveCtrl"
					GuildDissolveCtrl.create("dissolve")
				end
			else 	
				ShowNotice.showShellInfo(m_i18n[3555])
			end
		
		end
	end

	tbEvents.fnChangeLogo = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			local function modifyLogo( logoId )
				local params = CCArray:create()
	            params:addObject(CCInteger:create(logoId))
				RequestCenter.guild_modifyLogo(function (cbFlag, dictData, bRet)
					ShowNotice.showShellInfo(m_i18n[3693])
					GuildDataModel.setGuildIconId(logoId)
					MainGuildView.updateLogo(logoId)
				end, params)
			end
			LayerManager.removeLayout()
			require "script/module/guild/icon/GuildIconCtrl"
			logger:debug("tbEvents.fnChangeLogo")
			GuildIconCtrl.create(modifyLogo)
		end
	end

	-- 关闭
	tbEvents.fnClose = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("fnClose")
			AudioHelper.playCloseEffect()
			LayerManager.removeLayout()
		end
	end

	-- 分配战利品
	tbEvents.fnDistribution = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("fnDistribution")
			AudioHelper.playCloseEffect()

			local nIdentity = GuildDataModel.getUserGuildIdentity()
			--获取玩家在联盟中的身份，0团员，1团长，2副团
			logger:debug(nIdentity)
			if(nIdentity == 2) then
				ShowNotice.showShellInfo(m_i18n[2850])  --"只有会长才可以操作"
			else
				--先拉取副本的数据
				local function getDataCallBack( cbFlag, dictData, bRet )
					if(bRet)then
						-- DataCache.setGuildCopyData(dictData.ret)
						GCDistributionCtrl.create(dictData.ret)
					end
				end
				RequestCenter.guildCopy_getQueueSlim(getDataCallBack)	
			end
		end
	end

	tbEvents.fnTurnQueneSwitch = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			logger:debug("fnTurnQueneSwitch")
			local nIdentity = GuildDataModel.getUserGuildIdentity()
			if(nIdentity == 2) then
				ShowNotice.showShellInfo(m_i18n[2850])  --"只有会长才可以操作"
			else
				local state = GuildCopyModel.getJumpSwitch()
				local newState = math.abs(state-1)

				local function callBack(cbFlag, dictData, bRet)
					if (bRet) then 
						GuildCopyModel.setJumpSwitch(newState)
						GuildManageView.refreashButton()
					end 
				end
				require "script/module/guildCopy/GuildCopyModel"
				local arg = Network.argsHandler(newState)
				RequestCenter.guildCopy_turnQueneSwitch(callBack,arg) 
			end
  
		end
	end



	local view = GuildManageView.create(tbEvents)
	LayerManager.addLayout(view)
end
