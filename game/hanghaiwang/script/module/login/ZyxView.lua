-- FileName: ZyxView.lua
-- Author: zhangqi
-- Date: 2014-11-03
-- Purpose: 登陆的视图（view)模块
--[[TODO List]]

module("ZyxView", package.seeall)

-- UI控件引用变量 --
local m_ebAccount = nil -- 登录面板账号文本框的引用，用来设置已存在的快速注册账号
local m_btnReset = nil -- 一次清除文本框内容的清除按钮

-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_i18n = gi18n

local m_redColor = ccc3(0xff, 0x00, 0x00)
local m_ebBg = "images/base/potential/input_name_bg1.png"
local m_ebHolderColor = ccc3(0xba, 0x9d, 0x4f)
local m_ebFontColor = ccc3(0x57, 0x1e, 0x01)
local m_ebFontSize = 24
local m_allText = {account = "", pwd = "", email = "", newPwd = "", pwdConfirm = ""}
local m_InputTag = {account = 111, pwd = 222, newPwd = 333, email = 444, pwdConfirm = 555}
local m_InputName = {[111] = "account", [222] = "pwd", [333] = "newPwd", [444] = "email", [555] = "pwdConfirm"}

m_dlgName = "OUR_LOGIN" -- 2014-12-04, 统一命名，便于请求成功后删除面板

function destroy(...)
	package.loaded["ZyxView"] = nil
end

function moduleName()
	return "ZyxView"
end

local function setEditBoxTitle( labTitle, strText )
	labTitle:setColor(ccc3(0x7f, 0x5f, 0x20))
	labTitle:setFontSize(28)
	labTitle:setText(strText)
end

function getAllInputText()
	return m_allText
end

function resetAllInputText( ... )
	for k, v in pairs(m_allText) do
		m_allText[k] = ""
	end
	logger:debug("resetAllInputText")
	logger:debug(m_allText)
end

local function bindEventToEditBox( tbArgs )
	local function editboxEventHandler(eventType, sender)
		if eventType == "began" then
			local x,y = sender:getPosition()
			sender:setPosition(ccp(x,y))
			-- triggered when an edit box gains focus after keyboard is shown
			logger:debug("began, text = " .. sender:getText())
			if (tbArgs.onBegan and type(tbArgs.onBegan) == "function") then
				tbArgs.onBegan()
			end
		elseif eventType == "ended" then
			-- triggered when an edit box loses focus after keyboard is hidden.
			logger:debug("ended, text = " .. sender:getText())
			if (tbArgs.onEnded and type(tbArgs.onEnded) == "function") then
				tbArgs.onEnded()
			end
		elseif eventType == "changed" then
			-- triggered when the edit box text was changed.
			logger:debug("changed, text = " .. sender:getText())
			if (tbArgs.onChanged and type(tbArgs.onChanged) == "function") then
				tbArgs.onChanged()
			end
		elseif eventType == "return" then
			-- triggered when the return button was pressed or the outside area of keyboard was touched.
			logger:debug("return, text = " .. sender:getText())
			
			local text = sender:getText()
			if (m_btnReset) then
				m_btnReset:setEnabled(text ~= "")
			end

			if (tbArgs.onReturn and type(tbArgs.onReturn) == "function") then
				tbArgs.onReturn()
			end
			m_allText[m_InputName[sender:getTag()]] = text
			logger:debug(m_allText)
			UIHelper.clearTouchStat()
		end
	end
	tbArgs.inputBox:registerScriptEditBoxHandler(editboxEventHandler)
end

local function addAccountEdit( layRoot, contentText )
	local imgBg = m_fnGetWidget(layRoot, "IMG_ACCUNT_NUMBER_BG")
	local bgSize = imgBg:getSize()
	local tbEbCfg = { size = CCSizeMake(bgSize.width, bgSize.height), bg = m_ebBg,
		content = contentText, holder = m_i18n[4703], holderColor = m_ebHolderColor, maxLen = 20,
		FontSize = m_ebFontSize, FontColor = m_ebFontColor,
		RetrunType = kKeyboardReturnTypeDone, InputMode = kEditBoxInputModeSingleLine,
	}
	local editbox = UIHelper.createEditBoxNew(tbEbCfg)
	editbox:setInputFlag(kEditBoxInputFlagSensitive)
	imgBg:addNode(editbox)
	editbox:setTag(m_InputTag.account)

	local ebArgs = {inputBox = editbox}
	bindEventToEditBox(ebArgs)

	if (contentText) then
		m_allText[m_InputName[m_InputTag.account]] = contentText -- 避免文本框没有事件导致没有把账户名保存到table
	end

	return editbox
end

local function addPwdEdit( layRoot, ebImgBgName, nTag, contentText, sHolder, bNormal )
	local imgBg = m_fnGetWidget(layRoot, ebImgBgName)
	local bgSize = imgBg:getSize()
	local nInputFlag = bNormal and kEditBoxInputModeSingleLine or kEditBoxInputFlagPassword
	local tbEbCfg = { size = CCSizeMake(bgSize.width, bgSize.height), bg = m_ebBg,
		holder = sHolder, holderColor = m_ebHolderColor, maxLen = 20,
		FontSize = m_ebFontSize, FontColor = m_ebFontColor,
		RetrunType = kKeyboardReturnTypeDone, InputFlag = nInputFlag,
	}
	local editbox = UIHelper.createEditBoxNew(tbEbCfg)
	imgBg:addNode(editbox)
	editbox:setTag(nTag)
	editbox:setText(contentText or "")

	local ebArgs = {inputBox = editbox}
	bindEventToEditBox(ebArgs)

	if (contentText) then
		m_allText[m_InputName[m_InputTag.pwd]] = contentText -- 避免文本框没有事件导致没有把密码保存到table
	end

	return editbox
end

local function addEmailEdit( layRoot )
	local imgBg = m_fnGetWidget(layRoot, "IMG_MAIL_BG")
	local bgSize = imgBg:getSize()
	local tbEbCfg = { size = CCSizeMake(bgSize.width, bgSize.height), bg = m_ebBg,
		holder = m_i18n[4706], holderColor = m_ebHolderColor, maxLen = 20,
		FontSize = m_ebFontSize, FontColor = m_ebFontColor,
		RetrunType = kKeyboardReturnTypeDone, InputMode = kEditBoxInputModeEmailAddr,
	}
	local editbox = UIHelper.createEditBoxNew(tbEbCfg)
	imgBg:addNode(editbox)
	editbox:setTag(m_InputTag.email)

	local ebArgs = {inputBox = editbox}
	bindEventToEditBox(ebArgs)

	return editbox
end

-- 一键清除按钮
local function setResetButton( layParent, tbEditBox )
	m_btnReset = m_fnGetWidget(layParent, "BTN_DELETE")
	m_btnReset:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			for k, inputBox in pairs(tbEditBox) do
				inputBox:setText("")
			end
			m_allText.account = ""
			m_allText.pwd = ""

			m_btnReset:setEnabled(false)
		end
	end)
	m_btnReset:setEnabled(tbEditBox.account:getText() ~= "") -- 如果账户名不为空才可用
end

-- 绑定邮箱提示界面
function showBindEmailPromt( tbData )
	local layDlg = g_fnLoadUI("ui/register_prompt.json")

	local btnClose = m_fnGetWidget(layDlg, "BTN_CLOSE")
	btnClose:addTouchEventListener(UIHelper.onClose)

	local btnBind = m_fnGetWidget(layDlg, "BTN_BINDING") -- 绑定按钮
	UIHelper.titleShadow(btnBind, m_i18n[4765])
	btnBind:addTouchEventListener(tbData.eventBindEmail)

	local btnEnter = m_fnGetWidget(layDlg, "BTN_GAME") -- 进入游戏按钮
	UIHelper.titleShadow(btnEnter, m_i18n[4101])
	btnEnter:addTouchEventListener(UIHelper.onClose)

	local i18n_player = m_fnGetWidget(layDlg, "tfd_player")
	i18n_player:setText(m_i18n[4759])

	local i18n_line1_1 = m_fnGetWidget(layDlg, "tfd_explain_1_1")
	i18n_line1_1:setText(m_i18n[4760])
	local i18n_line1_2 = m_fnGetWidget(layDlg, "tfd_explain_1_2")
	i18n_line1_2:setText(m_i18n[4761])

	local i18n_line2_1 = m_fnGetWidget(layDlg, "tfd_explain_2_1")
	i18n_line2_1:setText(m_i18n[4762])
	local i18n_line2_2 = m_fnGetWidget(layDlg, "tfd_explain_2_2")
	i18n_line2_2:setText(m_i18n[4763])

	LayerManager.addLayout(layDlg)
end

-- 保存快速注册截图失败界面（用户没有给相册的访问权限）
function showFastRegistFailed( tbData )
	local layFaild = g_fnLoadUI("ui/register_prompt_fail.json")

	local btnClose = m_fnGetWidget(layFaild, "BTN_CLOSE")
	btnClose:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			UIHelper.closeCallback()
			tbData.fnCloseCallback()
		end
	end)

	local i18n_user = m_fnGetWidget(layFaild, "tfd_accunt_number")
	setEditBoxTitle(i18n_user, m_i18n[4767])
	local i18n_pwd = m_fnGetWidget(layFaild, "tfd_password")
	setEditBoxTitle(i18n_pwd, m_i18n[4768])

	local btnEnter = m_fnGetWidget(layFaild, "BTN_IN") -- 进入游戏按钮
	UIHelper.titleShadow(btnEnter, m_i18n[4101])
	btnEnter:addTouchEventListener(tbData.fnConfirmEvent)

	local i18n_line1 = m_fnGetWidget(layFaild, "tfd_explain_1")
	i18n_line1:setText(m_i18n[4754])
	i18n_line1:setColor(m_redColor)
	local i18n_line2 = m_fnGetWidget(layFaild, "tfd_explain_2")
	i18n_line2:setText(m_i18n[4766])
	i18n_line2:setColor(m_redColor)

	local labAccount = m_fnGetWidget(layFaild, "TFD_ACCUNT_NUMBER")
	labAccount:setText(tbData.account)

	local labPwd = m_fnGetWidget(layFaild, "TFD_PASSWORD")
	labPwd:setText(tbData.pwd)

	LayerManager.addLayout(layFaild)
end

-- 快速注册界面
function showFastRegister( tbData )
	local layFast = g_fnLoadUI("ui/register_success.json")

	local btnClose = m_fnGetWidget(layFast, "BTN_CLOSE")
	btnClose:addTouchEventListener(UIHelper.onClose)

	local i18n_desc = m_fnGetWidget(layFast, "tfd_explain")
	i18n_desc:setText(m_i18n[4750])

	local i18n_user = m_fnGetWidget(layFast, "tfd_accunt_number")
	setEditBoxTitle(i18n_user, m_i18n[4767])
	local i18n_pwd = m_fnGetWidget(layFast, "tfd_password")
	setEditBoxTitle(i18n_pwd, m_i18n[4768])

	-- 附加帐号的editbox
	local ebAccount = addAccountEdit(layFast, tbData.account)

	-- 密码的editbox
	local ebPwd = addPwdEdit(layFast, "IMG_PASSWORD_BG", m_InputTag.pwd, tbData.pwd, m_i18n[4704], true)

	-- 一键清除按钮
	setResetButton(layFast, {account = ebAccount, pwd = ebPwd})

	local btnSave = m_fnGetWidget(layFast, "BTN_KEEP") -- 保存按钮
	UIHelper.titleShadow(btnSave, m_i18n[4751])
	btnSave:addTouchEventListener(tbData.eventSave)

	UIHelper.addCallbackOnExit(layFast, function ( ... )
		m_btnReset = nil
		resetAllInputText()
	end)

	LayerManager.addLayout(layFast)
end

-- 普通登陆和带修改密码的登陆界面
function showOtherLogin( tbData )
	local laySignIn = g_fnLoadUI("ui/sign_in_other.json")

	local i18n_topTip = m_fnGetWidget(laySignIn, "tfd_explain")
	i18n_topTip:setText(m_i18n[4702])

	local i18n_user = m_fnGetWidget(laySignIn, "tfd_accunt_number")
	setEditBoxTitle(i18n_user, m_i18n[4767])
	local i18n_pwd = m_fnGetWidget(laySignIn, "tfd_password")
	setEditBoxTitle(i18n_pwd, m_i18n[4768])

	local btnClose = m_fnGetWidget(laySignIn, "BTN_CLOSE") -- 关闭按钮
	btnClose:addTouchEventListener(UIHelper.onClose)

	local laySign = m_fnGetWidget(laySignIn, "lay_sign_in_btn")
	local layOtherSign = m_fnGetWidget(laySignIn, "lay_sign_in_other_btn")

	if (tbData.other) then -- 账户列表切换其他用户
		laySign:removeFromParentAndCleanup(true)
	else -- 当前已登陆账户
		layOtherSign:removeFromParentAndCleanup(true)

		if (tbData.eventChangePwd) then -- 修改密码
			local btn = m_fnGetWidget(laySignIn, "BTN_REVISE_PASSWORD")
			btn:addTouchEventListener(tbData.eventChangePwd)
			UIHelper.titleShadow(btn, m_i18n[4713])
		end
	end

	if (tbData.eventLogin) then -- 登陆
		local btn = m_fnGetWidget(laySignIn, "BTN_SIGN_IN")
		btn:addTouchEventListener(tbData.eventLogin)
		UIHelper.titleShadow(btn, m_i18n[4715])
	end

	local btnRegist = m_fnGetWidget(laySignIn, "BTN_REGISTER_NEW")
	if (tbData.eventRegist) then -- 注册
		btnRegist:addTouchEventListener(tbData.eventRegist)
		UIHelper.titleShadow(btnRegist, m_i18n[4714])
	end

	if (tbData.eventFastRegist) then -- 快速注册
		btnRegist:addTouchEventListener(tbData.eventFastRegist)
		UIHelper.titleShadow(btnRegist, m_i18n[4748])
	end

	-- 附加帐号的editbox
	m_ebAccount = addAccountEdit(laySignIn, tbData.account)

	-- 密码的editbox
	local ebPwd = addPwdEdit(laySignIn, "IMG_PASSWORD_BG", m_InputTag.pwd, tbData.pwd, m_i18n[4704])

	-- 一键清除按钮
	setResetButton(laySignIn, {account = m_ebAccount, pwd = ebPwd})

	UIHelper.addCallbackOnExit(laySignIn, function ( ... )
		m_btnReset = nil
		resetAllInputText()
	end)

	laySignIn:setName(m_dlgName)
	LayerManager.addLayout(laySignIn)
end

-- 将返回的已有快速注册账号填充到登录账号
function addFastRegistAccount( sAccount )
	if (m_ebAccount) then
		m_ebAccount:setText(sAccount)

		m_allText[m_InputName[m_InputTag.account]] = sAccount
		logger:debug({addFastRegistAccount_m_allText = m_allText})
	end
end

-- 返回登录界面的账号文本框内容
function getLoginAccount( ... )
	if (m_ebAccount) then
		return m_ebAccount:getText()
	end
	return ""
end

-- 注册界面
function showRegister( tbData )
	local layReg = g_fnLoadUI("ui/register_account.json")
	layReg:setName(m_dlgName)
	LayerManager.addLayout(layReg)

	UIHelper.addCallbackOnExit(layReg, function ( ... )
		resetAllInputText()
	end)

	local btnClose = m_fnGetWidget(layReg, "BTN_CLOSE") -- 关闭按钮
	btnClose:addTouchEventListener(UIHelper.onClose)

	local i18n_user = m_fnGetWidget(layReg, "tfd_accunt_number")
	setEditBoxTitle(i18n_user, m_i18n[4767])
	local i18n_pwd = m_fnGetWidget(layReg, "tfd_password")
	setEditBoxTitle(i18n_pwd, m_i18n[4768])
	local i18n_conf_pwd = m_fnGetWidget(layReg, "tfd_confirmation_password")
	setEditBoxTitle(i18n_conf_pwd, m_i18n[4773])
	local i18n_email = m_fnGetWidget(layReg, "tfd_mail")
	setEditBoxTitle(i18n_email, m_i18n[4772])

	local ebAccount = addAccountEdit(layReg, tbData.account)
	local ebPwd = addPwdEdit(layReg, "IMG_PASSWORD_BG", m_InputTag.pwd, "", m_i18n[4704])
	local ebPwdConfirm = addPwdEdit(layReg, "IMG_CONFIRMATION_PASSWORD_BG", m_InputTag.pwdConfirm, "", m_i18n[4705])
	local ebMail = addEmailEdit(layReg)

	local btnConfirm = m_fnGetWidget(layReg, "BTN_SIGN_IN")
	btnConfirm:addTouchEventListener(tbData.eventConfirm)
	UIHelper.titleShadow(btnConfirm, m_i18n[4716])
end

-- 修改密码界面
function showChangePwd( tbData )
	local layPwd = g_fnLoadUI("ui/revise_password.json")
	layPwd:setName(m_dlgName)
	LayerManager.addLayout(layPwd)

	UIHelper.addCallbackOnExit(layPwd, function ( ... )
		resetAllInputText()
	end)

	local btnClose = m_fnGetWidget(layPwd, "BTN_CLOSE") -- 关闭按钮
	btnClose:addTouchEventListener(UIHelper.onClose)

	local i18n_user = m_fnGetWidget(layPwd, "tfd_accunt_number")
	setEditBoxTitle(i18n_user, m_i18n[4767])
	local i18n_old_pwd = m_fnGetWidget(layPwd, "tfd_old_password")
	setEditBoxTitle(i18n_old_pwd, m_i18n[4769])
	local i18n_new_pwd = m_fnGetWidget(layPwd, "tfd_new_password")
	setEditBoxTitle(i18n_new_pwd, m_i18n[4770])
	local i18n_conf_pwd = m_fnGetWidget(layPwd, "tfd_confirmation_password")
	setEditBoxTitle(i18n_conf_pwd, m_i18n[4771])

	local ebAccount = addAccountEdit(layPwd, tbData.account)
	local ebOldPwd = addPwdEdit(layPwd, "IMG_OLD_PASSWORD_BG", m_InputTag.pwd, "", m_i18n[4710])
	local ebNewPwd = addPwdEdit(layPwd, "IMG_NEW_PASSWORD_BG", m_InputTag.newPwd, "", m_i18n[4711])
	local ebPwdConfirm = addPwdEdit(layPwd, "IMG_CONFIRMATION_PASSWORD_BG", m_InputTag.pwdConfirm, "", m_i18n[4712])

	local btnConfirm = m_fnGetWidget(layPwd, "BTN_REVISE_PASSWORD")
	btnConfirm:addTouchEventListener(tbData.eventConfirm)
	UIHelper.titleShadow(btnConfirm, m_i18n[4713])
end
