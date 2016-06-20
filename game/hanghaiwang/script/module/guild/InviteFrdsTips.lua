-- FileName: InviteFrdsTips.lua
-- Author: zhangjunwu
-- Date: 2014-09-28
-- Purpose: 邀请好友通用界面
--[[TODO List]]

module("InviteFrdsTips", package.seeall)

-- UI控件引用变量 --
local m_editBoxBg = nil  	--输入框背景
local m_message_input = nil --输入框
-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_Uid				--邀请者的uid

local function init(...)
	m_Uid = nil
end

function destroy(...)
	package.loaded["InviteFrdsTips"] = nil
end

function moduleName()
	return "InviteFrdsTips"
end

function getMessage( ... )
	return m_message_input:getText()
end

--创建输入框
local function createEditBox( ... )
	-- 文本框
	require "script/module/public/UIHelper"
	logger:debug(m_editBoxBg:getSize())
	local size = m_editBoxBg:getSize()
	m_message_input = UIHelper.createEditBox(CCSizeMake(size.width, size.height),"images/base/potential/input_name_bg1.png",true,kCCVerticalTextAlignmentTop)
	--account_input:setFontColor(ccc3(255,0, 0));
	--m_message_input:setPlaceHolder(gi18nString(2163));
	m_message_input:setMaxLength(40);
	m_message_input:setPlaceholderFontColor(ccc3(0xc3, 0xc3, 0xc3))
	m_message_input:setReturnType(kKeyboardReturnTypeDone)
	m_message_input:setInputFlag (kEditBoxInputFlagInitialCapsWord)
	m_message_input:setText(gi18nString(2901))
	m_editBoxBg:addNode(m_message_input)
end

--[[desc:功能简介
    arg1:  type，从何处调用改界面
    return: 是否有返回值，返回值说明  
—]]
function create(Uid)
	init()
	m_Uid = Uid

	m_UIMain = g_fnLoadUI("ui/friends_invite.json")

	local BTN_CONFIRM = m_fnGetWidget(m_UIMain, "BTN_CONFIRM")		--确定按钮
	local btnBack = m_fnGetWidget(m_UIMain, "BTN_BACK")				--返回按钮
	local btnClose = m_fnGetWidget(m_UIMain, "BTN_CLOSE")			--取消按钮

	local TFD_TITLE= m_fnGetWidget(m_UIMain,"TFD_TITLE")			--好友留言
	TFD_TITLE:setText(gi18nString(2158))

	m_editBoxBg = m_fnGetWidget(m_UIMain,"IMG_TYPE_WORDS")

	UIHelper.titleShadow(BTN_CONFIRM,gi18nString(2629))
	UIHelper.titleShadow(btnBack,gi18nString(1019))

	BTN_CONFIRM:addTouchEventListener(onSendClick) 				--注册发送按钮
	btnBack:addTouchEventListener(onBackClicked) 				--注册返回按钮
	btnClose:addTouchEventListener(onCloseClicked) 				--注册取消按钮
	--创建输入框
	createEditBox()

	return m_UIMain
end


local function getStringLength(str)
	local strLen = 0
    local i =1
    while i<= #str do
        if(string.byte(str,i) > 127) then
            -- 汉字
            strLen = strLen + 1
            i= i+ 3
        else
            i =i+1
            strLen = strLen + 1
        end
    end
    return strLen
end

--邀请按钮回调
function onSendClick( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then

				AudioHelper.playCommonEffect()


				-- int $fuid: 对方uid( 申请者的uid )
					local function requestFunc( cbFlag, dictData, bRet )
						-- logger:debug ("addFriend---后端数据")
						logger:debug(dictData)
						LayerManager.removeLayout()
						if(bRet)then
							if(dictData.ret == "applied") then
									--	[2837] = "您已添加该玩家，请等待对方确认",
								ShowNotice.showShellInfo( gi18n[2837])
							end
							if(dictData.ret == "ok")then
								local str = gi18n[3576] --[3576] = "发送成功",
								ShowNotice.showShellInfo(str)
							end
							if(dictData.ret == "isfriend")then
								local str = gi18n[3664] --"对方已经是您的好友了！"
								ShowNotice.showShellInfo(str)
								return
							end
							if(dictData.ret == "applicant_reach_maxnum")then
								local str = gi18n[3665] -- "对方的好友数量已达上限",
								ShowNotice.showShellInfo(str)
								return
							end
							if(dictData.ret == "accepter_reach_maxnum")then
								local str = gi18n[3666] --"您的好友已数量达上限！"
								ShowNotice.showShellInfo(str)
								return
							end
						end
					end
				local inviteMessage = getMessage()
	 			local messageLength = getStringLength(getMessage())

				if (messageLength <= 0) then
					inviteMessage = gi18n[2901] 			--默认邀请内容 "土豪，我们做朋友吧！",
				end

				-- if (messageLength > 40) then   
				-- 	local str = gi18nString(3670)      		 --"留言数字要小于80字~
				-- 	ShowNotice.showShellInfo(str)
				-- 	return
				-- end
				
				local args = CCArray:create()
				args:addObject(CCInteger:create(m_Uid))
				args:addObject(CCString:create(inviteMessage))
				RequestCenter.friend_applyFriend(requestFunc,args)

    end  
end

--返回按钮回调
function onBackClicked( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playBackEffect()
			LayerManager.removeLayout()
    end  
end
--关闭按钮回调
function onCloseClicked( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCloseEffect()
			LayerManager.removeLayout()
    end  
end