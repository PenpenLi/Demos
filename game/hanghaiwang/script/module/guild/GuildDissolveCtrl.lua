-- FileName: GuildDissolveCtrl.lua
-- Author: huxiaozhou
-- Date: 2014-09-15
-- Purpose: function description of module
--[[TODO List]]
-- 解散军团 或者 转让军团

module("GuildDissolveCtrl", package.seeall)
require "script/module/guild/GuildDissolveView"

-- UI控件引用变量 --

-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString = gi18nString
local memberInfo
local function init(...)

end

function destroy(...)
	package.loaded["GuildDissolveCtrl"] = nil
end

function moduleName()
    return "GuildDissolveCtrl"
end

function transferBack(cbFlag, dictData, bRet)
    if not bRet then
        return
    end
    if cbFlag == "guild.transPresident" then
        if dictData.ret == "ok" then
             ShowNotice.showShellInfo(m_i18nString(3627,memberInfo.uname))
             LayerManager.removeLayout()
             memberInfo.member_type = "1"
            local  mytbInfo = GuildDataModel.getMemberInfoBy(UserModel.getUserUid())
            mytbInfo.member_type = "0"
            GuildDataModel.changeMineMemberType("0")
            GuildMemberView.checkBtnVerify()
             GuildMemberCtrl.refreshMemberList()
        elseif dictData.ret == "err_passwd" then
            ShowNotice.showShellInfo(m_i18n[3629])
        elseif dictData.ret == "failed" then
          -- ShowNotice.showShellInfo(m_i18n[3671])
          LayerManager.removeLayout()
          ShowNotice.showShellInfo(m_i18n[3593])  --玩家已退出工会
          GuildMemberCtrl.reloadMemberList()

        end
    end

end


function fnDissMissCallBack(cbFlag, dictData, bRet)
	LayerManager.removeLayout()
    if not bRet then
        return
    end
    if cbFlag == "guild.dismiss" then
        if dictData.ret == "ok" then

        	ShowNotice.showShellInfo(m_i18n[3558])

        	GuildDataModel.cleanCache()
        	LayerManager.setCurModuleName(" ")
        	-- 解散完成后 到可加入联盟
        	MainGuildCtrl.create()
        elseif dictData.ret == "err_passwd" then
           	ShowNotice.showShellInfo(m_i18n[3629])
        elseif dictData.ret == "forbidden" then
            ShowNotice.showShellInfo(m_i18n[3672])
        end
    end
end

function create(_type,_uid)
	local tbEvents = {}
	-- 确定
	if _type == "transfer" then
		memberInfo = GuildDataModel.getMemberInfoBy(_uid)
	end
	tbEvents.fnConfirm = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("fnConfirm")
			AudioHelper.playCommonEffect()

			local strCode = GuildDissolveView.getCodeBoxText()
			if string.len(strCode) == 0 then
       			ShowNotice.showShellInfo(m_i18n[3559])
		        return
		    end
		    if _type == "transfer" then
		        local createParams = CCArray:create()
		        createParams:addObject(CCInteger:create(_uid))
		        createParams:addObject(CCString:create(strCode))
			    local result = RequestCenter.guild_transPresident(transferBack,createParams)
		    end
		    if _type == "dissolve" then
		        local createParams = CCArray:create()
		        createParams:addObject(CCString:create(strCode))
		        RequestCenter.guild_dissmissGuild(fnDissMissCallBack,createParams)
		    end


		end
	end

	-- 取消
	tbEvents.fnCancel = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("fnCancel")
			AudioHelper.playCommonEffect()

			LayerManager.removeLayout()
		end
	end

	--  关闭
	tbEvents.fnClose = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("fnClose")
			AudioHelper.playCloseEffect()
			LayerManager.removeLayout()
		end
	end

	local view = GuildDissolveView.create(tbEvents,_type)
	LayerManager.addLayout(view)
end
