-- FileName: GuildImpeach.lua
-- Author: huxiaozhou
-- Date: 2014-09-23
-- Purpose: function description of module
--[[TODO List]]
-- 弹劾联盟长

module("GuildImpeach", package.seeall)

-- UI控件引用变量 --
local m_mainWidget
-- 模块局部变量 --
local json = "ui/union_replace_leader.json"
local m_fnGetWidget = g_fnGetWidgetByName
local m_fnLoadUI = g_fnLoadUI

local m_i18n = gi18n
local m_i18nString = gi18nString
local m_memberInfo

local function init(...)

end

function destroy(...)
	package.loaded["GuildImpeach"] = nil
end

function moduleName()
    return "GuildImpeach"
end

function fnClose ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("fnClose")
			AudioHelper.playCloseEffect()
			LayerManager.removeLayout()
		end
end

function cancel ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("cancel")
			AudioHelper.playCommonEffect()
			LayerManager.removeLayout()
		end
end

function fnHandlerOfNetwork(cbFlag, dictData, bRet)
    if not bRet then
        return
    end

     logger:debug(dictData)

    if (cbFlag == "guild.impeach") and (dictData.ret == "ok") then
        local guildInfo = GuildDataModel.getGuildInfo()
        local guildName = guildInfo.guild_name

        -- GuildDataModel.changeMineMemberType("1")
        local  mytbInfo = GuildDataModel.getMemberInfoBy(UserModel.getUserUid())
         mytbInfo.member_type = "1"
        m_memberInfo.member_type = "0"
        GuildMemberCtrl.refreshMemberList()
        ShowNotice.showShellInfo(m_i18nString(3619,guildName))
        UserModel.addGoldNumber(tonumber(-GuildUtil.getCostForAccuse()))
        -- 关闭
        LayerManager.removeLayout()
        LayerManager.removeLayout()
    elseif ((cbFlag == "guild.impeach") and (dictData.ret[1] == "failed")) then 
    	-- 会长已经转给其他人
    	LayerManager.removeLayout()
		GuildAffairsCtrl.removeLayout()
    	ShowNotice.showShellInfo(m_i18nString(3628,m_memberInfo.uname,dictData.ret[2]))
      	GuildMemberCtrl.reloadMemberList()
    else 
    	ShowNotice.showShellInfo(m_i18n[3622])
    end 
end

function confirmCb()
    local userInfo = UserModel.getUserInfo()
    if UserModel.getGoldNumber() < tonumber(GuildUtil.getCostForAccuse()) then
        LayerManager.addLayout(UIHelper.createNoGoldAlertDlg())
    else
    	local arg = Network.argsHandler(m_memberInfo.uid)
        RequestCenter.guild_impeach(fnHandlerOfNetwork,arg)
    end
end

function fnConfirm( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		logger:debug("fnConfirm")
		AudioHelper.playCommonEffect()
		confirmCb()
	end
end


function loadUI( ... )
	-- local i18nTFD_TITLE = m_fnGetWidget(m_mainWidget, "TFD_TITLE") --弹劾联盟长
	-- i18nTFD_TITLE:setText(m_i18n[3617])
	local i18nTFD_INFO = m_fnGetWidget(m_mainWidget, "TFD_INFO") -- 弹劾联盟长后，您将成为新联盟长！
	i18nTFD_INFO:setText(m_i18n[3620])

	local i18ntfd_info2 = m_fnGetWidget(m_mainWidget, "tfd_info2") --是否花费
	local i18ntfd_info3 = m_fnGetWidget(m_mainWidget, "tfd_info3") --弹劾联盟长?
	i18ntfd_info2:setText(m_i18n[3621])
	i18ntfd_info3:setText(m_i18n[3690])

	local TFD_GOLD_NUM = m_fnGetWidget(m_mainWidget, "TFD_GOLD_NUM") -- 花费金币数量

	TFD_GOLD_NUM:setText(GuildUtil.getCostForAccuse())


	local BTN_CLOSE = m_fnGetWidget(m_mainWidget, "BTN_CLOSE") -- BTN_CLOSE
	local BTN_CONFIRM = m_fnGetWidget(m_mainWidget, "BTN_CONFIRM") -- 确认
	local BTN_CANCEL = m_fnGetWidget(m_mainWidget, "BTN_CANCEL") --取消

	UIHelper.titleShadow(BTN_CONFIRM, m_i18n[1324])
	UIHelper.titleShadow(BTN_CANCEL, m_i18n[1325])

	BTN_CLOSE:addTouchEventListener(fnClose)
	BTN_CONFIRM:addTouchEventListener(fnConfirm)
	BTN_CANCEL:addTouchEventListener(cancel)
end

function create(memberInfo)
	init()
	m_memberInfo = memberInfo
	m_mainWidget = m_fnLoadUI(json)
	m_mainWidget:setSize(g_winSize)
	loadUI()
	LayerManager.addLayout(m_mainWidget)
end
