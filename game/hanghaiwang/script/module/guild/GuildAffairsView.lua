-- FileName: GuildAffairsView.lua
-- Author: huxiaozhou
-- Date: 2014-09-22
-- Purpose: function description of module
--[[TODO List]]
-- 成员管理中 按钮管理 显示器

module("GuildAffairsView", package.seeall)

-- UI控件引用变量 --

local m_mainMenu

local m_lay1
local m_lay2
local m_lay3
local m_lay4
local m_lay5
local m_lay6

-- 模块局部变量 --
local jsonMenu = "ui/union_member_execution.json"
local m_fnGetWidget = g_fnGetWidgetByName
local m_fnLoadUI = g_fnLoadUI

local m_i18n = gi18n
local m_i18nString = gi18nString

local m_tbEvent
local m_uid

local m_bFirend
local function init(...)
	m_uid = nil
end

function destroy(...)
	package.loaded["GuildAffairsView"] = nil
end

function moduleName()
    return "GuildAffairsView"
end

function loadUI( ... )
	local tbInfo = GuildDataModel.getMemberInfoBy(m_uid)
	assert(tbInfo,"hahahhahaha")
	logger:debug(tbInfo)
	--点击人信息
    local uMes = UserModel.getUserInfo()
    local uid = uMes.uid

    local tbMyself = GuildDataModel.getMemberInfoBy(uid)
	m_lay1 = m_fnGetWidget(m_mainMenu, "LAY_MAIN1")
	m_lay2 = m_fnGetWidget(m_mainMenu, "LAY_MAIN2")
	m_lay3 = m_fnGetWidget(m_mainMenu, "LAY_MAIN3")
	m_lay4 = m_fnGetWidget(m_mainMenu, "LAY_MAIN4")
	m_lay5 = m_fnGetWidget(m_mainMenu, "LAY_MAIN5")
	m_lay6 = m_fnGetWidget(m_mainMenu, "LAY_MAIN6")
 	
 	logger:debug(tbInfo)
 	logger:debug(tbInfo.member_type)
 	logger:debug(tbMyself.member_type)

	m_lay2.BTN_PVP:addTouchEventListener(m_tbEvent.fnPVP)
	m_lay3.BTN_PVP:addTouchEventListener(m_tbEvent.fnPVP)
	m_lay4.BTN_PVP:addTouchEventListener(m_tbEvent.fnPVP)
	m_lay5.BTN_PVP:addTouchEventListener(m_tbEvent.fnPVP)
	m_lay6.BTN_PVP:addTouchEventListener(m_tbEvent.fnPVP)

	m_lay2.BTN_PVP.tag = tbInfo.uid
	m_lay3.BTN_PVP.tag = tbInfo.uid
	m_lay4.BTN_PVP.tag = tbInfo.uid
	m_lay5.BTN_PVP.tag = tbInfo.uid
	m_lay6.BTN_PVP.tag = tbInfo.uid
	UIHelper.titleShadow(m_lay6.BTN_PVP,gi18n[6701])--
	UIHelper.titleShadow(m_lay5.BTN_PVP,gi18n[6701])--
	UIHelper.titleShadow(m_lay4.BTN_PVP,gi18n[6701])--
	UIHelper.titleShadow(m_lay3.BTN_PVP,gi18n[6701])--
	UIHelper.titleShadow(m_lay2.BTN_PVP,gi18n[6701])--

 	--会长点击平民
    if (tonumber(tbInfo.member_type) == 0) and (tonumber(tbMyself.member_type) == 1) then --5
    	m_lay1:removeFromParentAndCleanup(true)
    	m_lay2:removeFromParentAndCleanup(true)
		m_lay3:removeFromParentAndCleanup(true)
		m_lay4:removeFromParentAndCleanup(true)
		m_lay6:removeFromParentAndCleanup(true)

		local BTN_CLOSE = m_fnGetWidget(m_lay5, "BTN_CLOSE") -- 关闭按钮
		BTN_CLOSE:addTouchEventListener(m_tbEvent.fnClose)

		local BTN_ADD_FRIEND = m_fnGetWidget(m_lay5, "BTN_ADD_FRIEND") -- 添加好友
		BTN_ADD_FRIEND:addTouchEventListener(m_tbEvent.fnAddFirend)

		if m_bFirend == true then
			-- BTN_ADD_FRIEND:setTouchEnabled(false)
			BTN_ADD_FRIEND:setBright(false)
			UIHelper.titleShadow(BTN_ADD_FRIEND,m_i18n[3659])
		else 
			UIHelper.titleShadow(BTN_ADD_FRIEND,m_i18n[2921])
		end

		local BTN_PRIVATE_CHAT = m_fnGetWidget(m_lay5, "BTN_PRIVATE_CHAT") -- 私聊
		BTN_PRIVATE_CHAT:addTouchEventListener(m_tbEvent.fnPirateChat)
		UIHelper.titleShadow(BTN_PRIVATE_CHAT,m_i18n[2802])

		local BTN_APPOINT = m_fnGetWidget(m_lay5, "BTN_APPOINT") --任命副团长
		BTN_APPOINT:addTouchEventListener(m_tbEvent.fnAppoint)
		UIHelper.titleShadow(BTN_APPOINT,m_i18n[3614])

		local BTN_KICK = m_fnGetWidget(m_lay5, "BTN_KICK") -- 提出联盟
		BTN_KICK:addTouchEventListener(m_tbEvent.fnKick)
		UIHelper.titleShadow(BTN_KICK,m_i18n[3613])
    end
    --会长点击副会长
    if (tonumber(tbInfo.member_type) == 2) and (tonumber(tbMyself.member_type) == 1) then -- 6
    	m_lay1:removeFromParentAndCleanup(true)
    	m_lay2:removeFromParentAndCleanup(true)
		m_lay3:removeFromParentAndCleanup(true)
		m_lay4:removeFromParentAndCleanup(true)
		m_lay5:removeFromParentAndCleanup(true)

		local i18nTFD_TITLE = m_fnGetWidget(m_lay6, "TFD_TITLE")
		local BTN_CLOSE = m_fnGetWidget(m_lay6, "BTN_CLOSE")
		BTN_CLOSE:addTouchEventListener(m_tbEvent.fnClose)

		local BTN_ADD_FRIEND = m_fnGetWidget(m_lay6, "BTN_ADD_FRIEND") -- 添加好友
		BTN_ADD_FRIEND:addTouchEventListener(m_tbEvent.fnAddFirend)
		if m_bFirend == true then
			BTN_ADD_FRIEND:setBright(false)
			UIHelper.titleShadow(BTN_ADD_FRIEND,m_i18n[3659])
		else 
			UIHelper.titleShadow(BTN_ADD_FRIEND,m_i18n[2921])
		end

		local BTN_PRIVATE_CHAT = m_fnGetWidget(m_lay6, "BTN_PRIVATE_CHAT") -- 私聊
		BTN_PRIVATE_CHAT:addTouchEventListener(m_tbEvent.fnPirateChat)

		local BTN_KICK = m_fnGetWidget(m_lay6, "BTN_KICK") -- 提出联盟
		BTN_KICK:addTouchEventListener(m_tbEvent.fnKick)

		local BTN_RECALL = m_fnGetWidget(m_lay6, "BTN_RECALL") --罢免职务
		BTN_RECALL:addTouchEventListener(m_tbEvent.fnOust)

		local BTN_TRANSFER = m_fnGetWidget(m_lay6, "BTN_TRANSFER") -- 转让联盟
		BTN_TRANSFER:addTouchEventListener(m_tbEvent.fnTransfer)


		UIHelper.titleShadow(BTN_PRIVATE_CHAT,m_i18n[2802])
		UIHelper.titleShadow(BTN_RECALL,m_i18n[3615])
		UIHelper.titleShadow(BTN_TRANSFER,m_i18n[3616])
		UIHelper.titleShadow(BTN_KICK,m_i18n[3613])

    end
    --副会长点击平民
    if (tonumber(tbInfo.member_type) ==0)  and (tonumber(tbMyself.member_type) == 2) then -- 3
    	m_lay1:removeFromParentAndCleanup(true)
    	m_lay2:removeFromParentAndCleanup(true)
		m_lay4:removeFromParentAndCleanup(true)
		m_lay5:removeFromParentAndCleanup(true)
		m_lay6:removeFromParentAndCleanup(true)

		local i18nTFD_TITLE = m_fnGetWidget(m_lay3, "TFD_TITLE")
		local BTN_CLOSE = m_fnGetWidget(m_lay3, "BTN_CLOSE")
		BTN_CLOSE:addTouchEventListener(m_tbEvent.fnClose)

		local BTN_ADD_FRIEND = m_fnGetWidget(m_lay3, "BTN_ADD_FRIEND") -- 添加好友
		BTN_ADD_FRIEND:addTouchEventListener(m_tbEvent.fnAddFirend)
		if m_bFirend == true then
			BTN_ADD_FRIEND:setBright(false)
			UIHelper.titleShadow(BTN_ADD_FRIEND,m_i18n[3659])
		else 
			UIHelper.titleShadow(BTN_ADD_FRIEND,m_i18n[2921])
		end

		local BTN_PRIVATE_CHAT = m_fnGetWidget(m_lay3, "BTN_PRIVATE_CHAT") -- 私聊
		BTN_PRIVATE_CHAT:addTouchEventListener(m_tbEvent.fnPirateChat)
		
		local BTN_KICK = m_fnGetWidget(m_lay3, "BTN_KICK") -- 提出联盟
		BTN_KICK:addTouchEventListener(m_tbEvent.fnKick)
		UIHelper.titleShadow(BTN_PRIVATE_CHAT,m_i18n[2802])
		UIHelper.titleShadow(BTN_KICK,m_i18n[3613])
    end 

    --副会长点击会长
    if (tonumber(tbInfo.member_type) == 1) and (tonumber(tbMyself.member_type) == 2) then -- 4
    	m_lay1:removeFromParentAndCleanup(true)
    	m_lay2:removeFromParentAndCleanup(true)
		m_lay3:removeFromParentAndCleanup(true)
		m_lay5:removeFromParentAndCleanup(true)
		m_lay6:removeFromParentAndCleanup(true)

		local i18nTFD_TITLE = m_fnGetWidget(m_lay4, "TFD_TITLE")
		local BTN_CLOSE = m_fnGetWidget(m_lay4, "BTN_CLOSE")
		BTN_CLOSE:addTouchEventListener(m_tbEvent.fnClose)

		local BTN_ADD_FRIEND = m_fnGetWidget(m_lay4, "BTN_ADD_FRIEND") -- 添加好友
		BTN_ADD_FRIEND:addTouchEventListener(m_tbEvent.fnAddFirend)

		if m_bFirend == true then
			BTN_ADD_FRIEND:setBright(false)
			UIHelper.titleShadow(BTN_ADD_FRIEND,m_i18n[3659])
		else 
			UIHelper.titleShadow(BTN_ADD_FRIEND,m_i18n[2921])
		end

		local BTN_PRIVATE_CHAT = m_fnGetWidget(m_lay4, "BTN_PRIVATE_CHAT") -- 私聊
		BTN_PRIVATE_CHAT:addTouchEventListener(m_tbEvent.fnPirateChat)

		UIHelper.titleShadow(BTN_PRIVATE_CHAT,m_i18n[2802])

		local BTN_IMPEACH = m_fnGetWidget(m_lay4, "BTN_IMPEACH") -- 弹劾联盟长
		BTN_IMPEACH:addTouchEventListener(m_tbEvent.fnImpeach)
		UIHelper.titleShadow(BTN_IMPEACH,m_i18n[3617])

    end 
    --点自己
    if tonumber(uid) == tonumber(tbInfo.uid) then -- 1
		m_lay2:removeFromParentAndCleanup(true)
		m_lay3:removeFromParentAndCleanup(true)
		m_lay4:removeFromParentAndCleanup(true)
		m_lay5:removeFromParentAndCleanup(true)
		m_lay6:removeFromParentAndCleanup(true)

		local i18nTFD_TITLE = m_fnGetWidget(m_lay1, "TFD_TITLE")
		local BTN_CLOSE = m_fnGetWidget(m_lay1, "BTN_CLOSE")
		BTN_CLOSE:addTouchEventListener(m_tbEvent.fnClose)
		logger:debug("tonumber(uid) == tonumber(tbInfo.uid)")
		local BTN_QUIT = m_fnGetWidget(m_lay1, "BTN_QUIT")
		BTN_QUIT:addTouchEventListener(m_tbEvent.fnQuit)
		UIHelper.titleShadow(BTN_QUIT,m_i18n[3611])

		
    elseif ((tonumber(tbMyself.member_type) == 0) or ((tonumber(tbInfo.member_type) == 2) and (tonumber(tbMyself.member_type) == 2))) then
    --   --平民点会长，副会长，平民 --- 2
   		m_lay1:removeFromParentAndCleanup(true)
    	m_lay3:removeFromParentAndCleanup(true)
		m_lay4:removeFromParentAndCleanup(true)
		m_lay5:removeFromParentAndCleanup(true)
		m_lay6:removeFromParentAndCleanup(true)

		local i18nTFD_TITLE = m_fnGetWidget(m_lay2, "TFD_TITLE")
		local BTN_CLOSE = m_fnGetWidget(m_lay2, "BTN_CLOSE")
		BTN_CLOSE:addTouchEventListener(m_tbEvent.fnClose)

		local BTN_ADD_FRIEND = m_fnGetWidget(m_lay2, "BTN_ADD_FRIEND") -- 添加好友
		BTN_ADD_FRIEND:addTouchEventListener(m_tbEvent.fnAddFirend)
		if m_bFirend == true then
			BTN_ADD_FRIEND:setBright(false)
			UIHelper.titleShadow(BTN_ADD_FRIEND,m_i18n[3659])
		else 
			UIHelper.titleShadow(BTN_ADD_FRIEND,m_i18n[2921])
		end


		local BTN_PRIVATE_CHAT = m_fnGetWidget(m_lay2, "BTN_PRIVATE_CHAT") -- 私聊
		BTN_PRIVATE_CHAT:addTouchEventListener(m_tbEvent.fnPirateChat)
		UIHelper.titleShadow(BTN_PRIVATE_CHAT,m_i18n[2802])
    end

end

function requestFunc(cbFlag, dictData, bRet)
    if(bRet == true)then
        local dataRet = dictData.ret
        if(dataRet == "true" or dataRet == true )then
            m_bFirend = true
        end
        if(dataRet == "false" or dataRet == false  )then
            m_bFirend = false
        end
    end
    createUI( )
end

function isFriendNet()
    local args = CCArray:create()
    args:addObject(CCInteger:create(tonumber(m_uid)))
    Network.rpc(requestFunc, "friend.isFriend", "friend.isFriend", args, true)
end

function createUI( ... )
	m_mainMenu = m_fnLoadUI(jsonMenu)
	m_mainMenu:setSize(g_winSize)
	loadUI()
	LayerManager.addLayout(m_mainMenu)
end

function create(tbEvent,_uid)
	init()
	m_uid = _uid
	m_tbEvent = tbEvent
	isFriendNet()
end
