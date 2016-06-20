-- FileName: MainGuildCtrl.lua
-- Author: huxiaozhou
-- Date: 2014-09-15
-- Purpose: function description of module
--[[TODO List]]
--点击军团按钮 调用的主控制模块


module("MainGuildCtrl", package.seeall)

require "script/module/guild/GuildUtil"
require "script/module/guild/MainGuildView"
require "script/module/guild/GuildDataModel"
require "script/module/guild/UpgradeAlert"
require "script/module/guild/hall/GuildHallCtrl"
-- UI控件引用变量 --
local m_i18n = gi18n
local m_i18nString = gi18nString
local m_fnCallBack
local m_nKeep
-- 模块局部变量 --
local m_nFlag -- 1 2 是大厅  3 咖啡屋

local funTable = {} -- 注册关闭二级以上界面回调

local function init(...)
	m_fnCallBack = nil
	m_nKeep = nil
end

function destroy(...)
	MainGuildView.destroy()
	package.loaded["MainGuildCtrl"] = nil
end

function moduleName()
	return "MainGuildCtrl"
end

function create(...)
	m_nFlag = 1
	RequestCenter.guild_getMemberInfo(memberInfoCallback)
end

function enterCafe( ... )
	m_nFlag = 3
	RequestCenter.guild_getMemberInfo(memberInfoCallback)
end

function enterHall( ... )
	m_nFlag = 2
	RequestCenter.guild_getMemberInfo(memberInfoCallback)
end

function enterShop( fnCallBack, nKeep)
	m_nFlag = 4
	m_fnCallBack = fnCallBack
	m_nKeep = nKeep
	RequestCenter.guild_getMemberInfo(memberInfoCallback)
end

function enterCopy()
	m_nFlag = 5
	RequestCenter.guild_getMemberInfo(memberInfoCallback)
end
function getGuildAllInfo(  )
	m_nFlag = 0
	RequestCenter.guild_getMemberInfo(memberInfoCallback)
end

local function createEvents( )
	local tbEvents = {}
	-- 返回
	tbEvents.fnBack = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("fnBack")
			AudioHelper.playBackEffect()
			GuildDataModel.setIsInGuildFunc(false)
			require "script/module/main/MainScene"
 			MainScene.homeCallback()
		end
	end

	tbEvents.fnChange = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("fnChange")
			AudioHelper.playMainUIEffect()
			require "script/module/guild/GuildAnnounceCtrl"
			GuildAnnounceCtrl.create("post")
		end
	end
    
    -- 弹出更换联盟图标的界面 add by sunyunpeng 2015-04-15


	tbEvents.iconChange = function ( sender, eventType )
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



	-- 其他联盟
	tbEvents.fnShowList = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("fnShowList")
			AudioHelper.playMainUIEffect()

			require "script/module/guild/GuildListCtrl"
			local view = GuildListCtrl.create()
			--LayerManager.changeModule(view, GuildListCtrl.moduleName(), {1}, true)
		end
	end

	-- 军团大厅
	tbEvents.fnGuildMain = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("fnGuildMain")
			AudioHelper.playBtnEffect("jianzhu.mp3")
			GuildHallCtrl.create()
		end
	end

	-- 大厅升级
	tbEvents.fnGuildMainUp = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("fnGuildMainUp")
			AudioHelper.playCommonEffect()
			local _guildInfo = GuildDataModel.getGuildInfo()
			local hallNeedExp = GuildUtil.getNeedExpByLv( tonumber(_guildInfo.guild_level) + 1 )
			UpgradeAlert.create({sType = "hall",cost = hallNeedExp ,curLv = _guildInfo.guild_level,confirmCBFunc = MainGuildView.afterUpgradeDelegate })
		end
	end

	--  关公殿
	tbEvents.fnGuildCafe = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("fnGuildCafe")
			AudioHelper.playBtnEffect("jianzhu.mp3")
			require "script/module/guild/cafeHouse/CafeHouseCtrl"
			CafeHouseCtrl.create()
		end
	end

	-- 关公殿升级
	tbEvents.fnGuildCafeUp = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("fnGuildCafeUp")
			AudioHelper.playCommonEffect()
			local _guildInfo = GuildDataModel.getGuildInfo()
			local guanyuNeedExp = GuildUtil.getGuanyuNeedExpByLv(tonumber(_guildInfo.va_info[3].level) + 1 )
			UpgradeAlert.create({sType = "guanyu",cost = guanyuNeedExp ,curLv = _guildInfo.va_info[3].level,confirmCBFunc = MainGuildView.afterUpgradeDelegate})
		end
	end

	-- 联盟商店	
	tbEvents.fnGuildShop = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("fnGuildShop")
			AudioHelper.playBtnEffect("jianzhu.mp3")
			require "script/module/guild/shop/GuildShopCtrl"
			GuildShopCtrl.create()
		end
	end

	-- 联盟商店升级
	tbEvents.fnGuildShopUp = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("fnGuildShopUp")
			AudioHelper.playCommonEffect()
			
			local _guildInfo = GuildDataModel.getGuildInfo()
			local guanyuNeedExp = GuildUtil.getShopNeedExpByLv(tonumber(_guildInfo.va_info[4].level) + 1 )
			UpgradeAlert.create({sType = "shop",cost = guanyuNeedExp ,curLv = _guildInfo.va_info[4].level,confirmCBFunc = MainGuildView.afterUpgradeDelegate})

		end
	end

	-- 联盟副本	
	tbEvents.fnGuildSoldier = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("fnGuildSoldier")
			AudioHelper.playBtnEffect("jianzhu.mp3")

			local isOpenCopy = GuildUtil.isGuildCopyOpen()
			local lvToOpen = GuildDataModel.getGuildLvToOpenCopy()
			logger:debug(isOpenCopy)
			if(isOpenCopy == false) then
				-- [1970] = "等级需要达到%s级",
				ShowNotice.showShellInfo(m_i18n[3701] .. m_i18nString(1970,lvToOpen))
				return 
			end
			
			require "script/module/guildCopy/GuildCopyMapCtrl"
			GuildCopyMapCtrl:create()
		end
	end

	-- 联盟副本升级
	tbEvents.fnGuildSoldierUp = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("fnGuildSoldierUp")
			AudioHelper.playCommonEffect()
			


			local _guildInfo = GuildDataModel.getGuildInfo()
			local copyNeedExp = GuildUtil.getCopyNeedExpByLv(tonumber(_guildInfo.va_info[5].level) + 1 )
			UpgradeAlert.create({sType = "copy",cost = copyNeedExp ,curLv = _guildInfo.va_info[5].level,confirmCBFunc = MainGuildView.afterUpgradeDelegate})

		end
	end
	-- 点击其他建筑
	tbEvents.fnGuildBuilding = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			ShowNotice.showShellInfo(m_i18n[3750])
		end
	end

	return tbEvents
end

-- 军团请求回调
function getGuildInfoCallback(  cbFlag, dictData, bRet  )
	if(dictData.err == "ok")then

		local _guildInfo 		= dictData.ret

		logger:debug(_guildInfo)

		if(not table.isEmpty(_guildInfo))then
			GuildDataModel.setGuildInfo(_guildInfo)
			if (m_nFlag == 1) then
				LayerManager.changeModule(MainGuildView.create(createEvents()), MainGuildView.moduleName(), {1}, true)
			elseif(m_nFlag == 2) then
				require "script/module/guild/hall/GuildHallCtrl"
				GuildHallCtrl.create()
			elseif (m_nFlag == 3) then
				require "script/module/guild/cafeHouse/CafeHouseCtrl"
				CafeHouseCtrl.create()
			elseif (m_nFlag == 4) then
				require "script/module/guild/shop/GuildShopCtrl"
				GuildShopCtrl.create(m_fnCallBack, m_nKeep)
			elseif (m_nFlag == 5) then
				require "script/module/guildCopy/GuildCopyMapCtrl"
				GuildCopyMapCtrl.create()
			end
		end
	end
end


-- 创建 param 是否强制拉数据
function getGuildInfo( _isForceRequest )
	local isForceRequest = _isForceRequest or false

	if(isForceRequest == true )then
		RequestCenter.guild_getGuildInfo(getGuildInfoCallback)
	else
		local _guildInfo = GuildDataModel.getGuildInfo()
		if(not table.isEmpty(_guildInfo))then
			LayerManager.changeModule(MainGuildView.create(createEvents()), MainGuildView.moduleName(), {1}, true)
		else
			RequestCenter.guild_getGuildInfo(getGuildInfoCallback)
		end
	end
end
-- 拉取公会副本基本信息
function getGuildCopyBaseInfo()
	--拉取公会副本相关的公会相关信息
	function guildCopyBaseInfoCallback(cbFlag,dictData,bRet)
		if (bRet)then
			DataCache.setGuildCopyBaseData(dictData.ret)
		end
	end
	RequestCenter.getGuildCopyBaseInfo(guildCopyBaseInfoCallback)
	
	--拉取公会副本相关的个人相关信息
	function guildMemberBaseInfoCallback(cbFlag,dictData,bRet)
		if (bRet)then
			DataCache.setGuildMemberBaseData(dictData.ret)
		end
	end
	RequestCenter.getGuildMemberBaseInfo(guildMemberBaseInfoCallback)

	local function getDataCallBack( cbFlag, dictData, bRet )
		if(bRet == true)then
			DataCache.setGuildCopyData(dictData.ret)
		end
	end
	RequestCenter.getGuildCopyAllInfo(getDataCallBack)
end
-- 自己的军团信息
function memberInfoCallback( cbFlag, dictData, bRet )
	if(dictData.err == "ok")then
		GuildDataModel.setIsInGuildFunc(true)
		GuildDataModel.setMineSigleGuildInfo(dictData.ret)

		if (GuildDataModel.getIsHasInGuild()) then
			-- 已经加入军团
			getGuildCopyBaseInfo()
			getGuildInfo(true)

		else
			-- 没有加入军团
			if m_nFlag ~= 0 then
				require "script/module/guild/GuildListCtrl"
				GuildListCtrl.create()
			end
		end
	end

end

