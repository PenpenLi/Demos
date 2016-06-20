-- FileName: GuildAffairsCtrl.lua
-- Author: huxiaozhou
-- Date: 2014-09-22
-- Purpose: function description of module
--[[TODO List]]
-- 成员管理中 按钮管理 显示器

module("GuildAffairsCtrl", package.seeall)
require "script/module/guild/GuildAffairsView"
require "script/module/guild/GuildTip"
require "script/module/guild/GuildImpeach"
-- UI控件引用变量 --

-- 模块局部变量 --
local memberInfo

local m_i18n = gi18n
local m_i18nString = gi18nString

local function init(...)
	memberInfo = {}
end

function destroy(...)
	package.loaded["GuildAffairsCtrl"] = nil
end

function moduleName()
	return "GuildAffairsCtrl"
end


--加好友回调
function requestFuncFriend(cbFlag, dictData, bRet)
	if(bRet == true)then
		-- print_t(dictData.ret)
		local dataRet = dictData.ret
		-- 等待确认
		if(dataRet == "applied")then
			ShowNotice.showShellInfo(m_i18n[2837])
			return
		end
		if(dataRet == "reach_maxnum")then
			ShowNotice.showShellInfo(m_i18n[3666])
			return
		end
		if(dataRet == "ok")then
			ShowNotice.showShellInfo(m_i18n[2836])
			return
		end
		if (dataRet == "alreadyfriend") then
			ShowNotice.showShellInfo(m_i18n[3664])
			return
		end
		if (dataRet == "black") then
			ShowNotice.showShellInfo(m_i18n[3676])
			return
		end
		if (dataRet == "beblack") then
			ShowNotice.showShellInfo(m_i18n[3677])
			return
		end
		LayerManager.removeLayout()
	end
end

--加好友
function gotoMakeFriend()
	local args = CCArray:create()
	args:addObject(CCInteger:create(memberInfo.uid))
	args:addObject(CCString:create(""))
	Network.rpc(requestFuncFriend, "friend.applyFriend", "friend.applyFriend", args, true)
end


function requestFuncColeader(cbFlag, dictData, bRet)
	if not bRet then
		return
	end
	if (cbFlag == "guild.setVicePresident")then
		if dictData.ret == "ok" then
			ShowNotice.showShellInfo(m_i18n[3675])
			GuildDataModel.addGuildVPNum(1)
			memberInfo.member_type = "2"
			GuildMemberCtrl.refreshMemberList()
		end
		if dictData.ret == "failed" then
			-- ShowNotice.showShellInfo(m_i18n[3673])
			ShowNotice.showShellInfo(m_i18n[3593])  --玩家已退出工会
			GuildMemberCtrl.reloadMemberList()
		end
	end
	LayerManager.removeLayout()
end

--任命副团长
function gotoMakeColeader()
	local guildInfo = GuildDataModel.getGuildInfo()
	if (tonumber(guildInfo.vp_num) +1) > tonumber(GuildUtil.getMaxViceLeaderNumBy(tonumber(guildInfo.guild_level))) then
		ShowNotice.showShellInfo(m_i18n[3625])
	else
		local args = CCArray:create()
		args:addObject(CCInteger:create(memberInfo.uid))
		RequestCenter.guild_setVicePresident(requestFuncColeader,args)
	end
end


function requestFuncNoColeader(cbFlag, dictData, bRet)
	if not bRet then
		return
	end
	if (cbFlag == "guild.unsetVicePresident") then
		if dictData.ret == "ok" then
			ShowNotice.showShellInfo(m_i18nString(3663,memberInfo.uname))
			GuildDataModel.addGuildVPNum(-1)
			memberInfo.member_type = "0"
			GuildMemberCtrl.refreshMemberList()
		end
		if dictData.ret == "failed" then
			-- ShowNotice.showShellInfo(m_i18n[3674])
			ShowNotice.showShellInfo(m_i18n[3593])  --玩家已退出工会
			GuildMemberCtrl.reloadMemberList()
		end
	end
	LayerManager.removeLayout()
end

--职位罢免
function noMakeColeader()
	local args = CCArray:create()
	args:addObject(CCInteger:create(memberInfo.uid))
	RequestCenter.guild_unsetVicePresident(requestFuncNoColeader,args)
end

--弹劾军团长
function gotoImpeachment()

	local awayTime = TimeUtil.getSvrTimeByOffset() - tonumber(memberInfo.last_logoff_time)
	logger:debug("awayTime===" .. awayTime)
	logger:debug("memberInfo.status==" .. memberInfo.status)

	logger:debug(memberInfo)

	if tonumber(memberInfo.status) ~= 1 and tonumber(awayTime) > 7*24*3600 then
		GuildImpeach.create(memberInfo)
	else
		ShowNotice.showShellInfo(m_i18n[3618])
	end
end

function removeLayout( ... )
	LayerManager.removeLayout()
end

function create(_uid)
	init()
	memberInfo = GuildDataModel.getMemberInfoBy(_uid)
	local tbEvents = {}
	-- 加好友
	tbEvents.fnAddFirend = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("fnAddFirend")
			AudioHelper.playCommonEffect()
			gotoMakeFriend()
		end
	end

	-- 私了
	tbEvents.fnPirateChat = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("fnPirateChat")
			AudioHelper.playCommonEffect()
			LayerManager.removeLayout()
			local name = memberInfo.uname
			require "script/module/chat/ChatCtrl"
			ChatCtrl.create(2, name)
		end
	end

	--  罢免职务
	tbEvents.fnOust = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("fnOust")
			AudioHelper.playCommonEffect()
			noMakeColeader()
		end
	end

	-- 退出联盟
	tbEvents.fnQuit = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("fnQuit")
			AudioHelper.playCommonEffect()
			LayerManager.removeLayout()
			local _sigleGuildInfo = GuildDataModel.getMineSigleGuildInfo()
			if tonumber(_sigleGuildInfo.member_type) == 1 then
				local guildInfo = GuildDataModel.getGuildInfo()
				if tonumber(guildInfo.member_num) > 1 then
					GuildTip.create("quit", memberInfo)
				else
					ShowNotice.showShellInfo(m_i18n[3691])
				end

			else

				GuildTip.create("quit", memberInfo)
			end
		end
	end

	-- 转让联盟长
	tbEvents.fnTransfer = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("fnTransfer")
			AudioHelper.playCommonEffect()
			LayerManager.removeLayout()
			require "script/module/guild/GuildDissolveCtrl"
			GuildDissolveCtrl.create("transfer" ,memberInfo.uid)
		end
	end
	-- 踢出联盟
	tbEvents.fnKick= function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("fnKick")
			AudioHelper.playCommonEffect()
			LayerManager.removeLayout()

			if (GuildDataModel.getRemainKickNum()<=0) then 
				ShowNotice.showShellInfo(m_i18n[3596])
			else 
				GuildTip.create("kick", memberInfo)
			end 
		end
	end

	-- 关闭
	tbEvents.fnClose= function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("fnClose")
			AudioHelper.playCommonEffect()
			LayerManager.removeLayout()
		end
	end

	-- 任命副联盟长
	tbEvents.fnAppoint= function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("fnAppoint")
			AudioHelper.playCommonEffect()
			gotoMakeColeader()
		end
	end

	-- 弹劾联盟长
	tbEvents.fnImpeach= function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("fnImpeach")
			AudioHelper.playCommonEffect()
			gotoImpeachment()
		end
	end

	-- 切磋
	tbEvents.fnPVP = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("fnPVP")
			require "script/module/public/PVP"
			PVP.doPVP(sender.tag)
		end
	end

	GuildAffairsView.create(tbEvents,_uid)

end
