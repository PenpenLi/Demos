-- FileName: ZyxCtrl.lua
-- Author: zhangqi
-- Date: 2014-11-03
-- Purpose: 登陆平台的主控
--[[TODO List]]

module("ZyxCtrl", package.seeall)

require "script/module/login/ZyxView"
require "script/module/public/ShowNotice"

-- UI控件引用变量 --

-- 模块局部变量 --
local m_ExpCollect = ExceptionCollect:getInstance()
local m_fnGetWidget = g_fnGetWidgetByName
local m_i18n = gi18n
local m_userDefault = g_UserDefault
local m_config = Platform.getConfig()

local m_Code_NetWork_Error 		= 0 	-- 网络请求出错
local m_Code_WebClient_Error	= -1 	-- Web端出错，返回参数格式不对
local m_Code_Unkown_ErrorId 	= -3 	-- Web端的返回ErrorId 未知
local _isAutoEnterGame = false
local m_Code_Request = 0 -- 表示请求类型: 登陆 1，注册 2，修改密码 3，试玩 4，绑定新帐号 5，绑定老账号 6，解除绑定 7，快速注册 8，保存快速注册 9
local m_RESPONSE_OK = "0"
local m_BOUND = 2 -- 表示已绑定邮箱

local m_usrKeyPre = "zyx_user_"
local m_pwdKeyPre = "zyx_pwd_"
local m_pwdHolder = "999"  -- 绑定过帐号的游客登陆由于拿不到账户密码，用3位的占位密码标识是绑定过帐号的游客登陆
local m_reqType = {LOGIN = 1, REGISTE = 2, CHGPWD = 3, GUEST = 4, BIND_NEW = 5, BIND_OLD = 6, UNBIND = 7, FAST_REGISTE = 8, FAST_REGISTE_SAVE = 9,}
-- 异常收集的actionName, 和 m_reqType 对应
local m_actionName = {"LOGIN", "REGISTE", "CHGPWD", "GUEST", "BIND_NEW", "BIND_OLD", "UNBIND", "FAST_REGISTE", "FAST_REGISTE_SAVE"}

local m_errInfo = {
	["1001"] = m_i18n[1986],
	["1004"] = m_i18n[4707], -- "参数错误" -> "数据异常，请重试"
	["1009"] = m_i18n[4722],
	["1010"] = m_i18n[4737],
	["1011"] = m_i18n[4743],
	["1012"] = m_i18n[4727],
	["1013"] = m_i18n[4742],
	["1014"] = m_i18n[4741],
	["1015"] = m_i18n[4740],
	["1016"] = m_i18n[4734],
	["1017"] = m_i18n[4726],
	["1018"] = m_i18n[4744],
	["1019"] = m_i18n[4748] .. "\n" .. m_i18n[4749]
}

local m_tbFastSave -- 记录玩家保存的快速注册信息，用于保存成功后的自动登录
local m_bFastRegisted = false -- 记录是否已经快速注册过的状态

local function sendHttpRequest( request )
	local httpClient = CCHttpClient:getInstance()
	httpClient:send(request)
	request:release()
end

local function init(...)

end

function destroy(...)
	package.loaded["ZyxCtrl"] = nil
end

function moduleName()
	return "ZyxCtrl"
end

-- 长度检查
function stringLenthVerify( strText, minLen, maxLen )
	return strText and (#strText >= minLen and #strText <= maxLen) or false
end

-- 帐号检查
function zyxAccountVerify( sAccount )
	local other = string.find(sAccount, "[^%w_]") -- 帐号只允许是 数字、字母、_, 结果返回nil表示没有特殊字符
	local validLen = stringLenthVerify(sAccount, 1, 16)
	return (not other) and validLen
end

-- 密码检查
function zyxPwdVerify( sPwd )
	local other = string.find(sPwd, "[^%w_]") -- 帐号只允许是 数字、字母、_, 结果返回nil表示没有特殊字符
	return (not other) and stringLenthVerify(sPwd, 4, 14)
end

-- 邮件检查
function zyxEmailVerify( sEmail )
	local validLen = stringLenthVerify(sEmail, 0, 50)
	if (#sEmail > 0) then
		return validLen and string.find(sEmail, "^[%w-_.]+@[%w-_.]+$")
	end
	return validLen
end

local function zyxAlert( sInfo )
	local tbArgs = {strText = sInfo, nBtn = 1}
	LayerManager.addLayout(UIHelper.createCommonDlgNew(tbArgs))
end

local function saveLoginInfoToLocal( uid, tbLogin, okTX )
	LayerManager.removeLayoutByName( ZyxView.m_dlgName ) -- 2014-12-04, 指定名称只删除主登陆面板

	saveAndLogin( uid, tbLogin)

	if (okTX) then
		ShowNotice.showShellInfo(okTX)
	else
		--广告需求
		local adurl = config.getADUrl(uid)
		logger:debug("adurl %s",adurl)
		local requestAD = LuaHttpRequest:newRequest()
		requestAD:setRequestType(CCHttpRequest.kHttpGet)
		requestAD:setTimeoutForConnect(g_HttpConnTimeout)
		requestAD:setUrl(adurl)
		requestAD:setResponseScriptFunc(function() m_ExpCollect:finish("adurl") end)

		m_ExpCollect:start("adurl", "adurl = " .. adurl)

		local httpClientAD = CCHttpClient:getInstance()
		httpClientAD:send(requestAD)
		requestAD:release()
	end
end

-- 登陆处理
local function onLoginResponse(tbData)
	local codeRequest = m_Code_Request -- 缓存请求类型区别是否绑定的提示来自登陆还是注册
	m_Code_Request = 0 -- 重置请求类型
	if (tbData.eno == m_RESPONSE_OK) then -- ok
		m_ExpCollect:finish(m_actionName[codeRequest])

		LayerManager.removeLayout() -- 关闭当前登录面板, 重置缓存的所有文本框内容

		-- 2013-03-11, 平台统计需求， 平台新账号注册
		if (Platform.isPlatform() and (codeRequest == m_reqType.REGISTE)) then
			ShowNotice.showShellInfo(m_i18n[4731]) -- 提示注册成功
			Platform.sendInformationToPlatform(Platform.kNewPlatformAccount)
		end

		saveLoginInfoToLocal(tbData.uid, tbData.login, tbData.ok) -- 保存登录信息到本地记录

		-- 登陆的响应里邮箱绑定状态才有效
		if (codeRequest == m_reqType.LOGIN and tbData.isBindEmail ~= m_BOUND) then
			local tbArgs = {}
			tbArgs.eventBindEmail = function ( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					logger:debug("eventBindEmail")
					AudioHelper.playCommonEffect()

					local param = m_config.getBindEmailParam()
					Platform.getSdk():callOCFunctionWithName_oneParam_noBack("openZXYWebView", param)
					LayerManager.removeLayout()
				end
			end
			ZyxView.showBindEmailPromt(tbArgs)
			return
		else
			LoginHelper.reLoginAfterPlatformLogin()
			return
		end
	end
	
	m_ExpCollect:info(m_actionName[codeRequest], "errorInfo: " .. (m_errInfo[tbData.eno] or tbData.estr))

	zyxAlert(m_errInfo[tbData.eno] or tbData.estr)
end
-- 检测是否已经快速注册处理
local function onFastRegResponse( tbData )
	logger:debug({onFastRegResponse_tbData = tbData})
	m_Code_Request = 0 -- 重置请求类型

	if (tbData.uid) then --TODO 对web端返回uid的有效性检查
		ShowNotice.showShellInfo(m_i18n[4749])
		ZyxView.addFastRegistAccount(tbData.username or "") -- 用返回的账号填充登录面板账号文本框
		m_bFastRegisted = true
	else
		LayerManager.removeLayout() -- 先关闭首次登陆界面

		local tbArgs = {account = tbData.username, pwd = tbData.password}
		tbArgs.eventSave = function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCommonEffect()

				local allInput = ZyxView.getAllInputText()
				logger:debug({eventSave_allInput = allInput})
				onFastRegistSave(allInput)
			end
		end
		ZyxView.showFastRegister(tbArgs)
	end
end
-- 快速注册成功保存账号的处理
local function onFastRegSaveResponse( tbData )
	logger:debug({onFastRegSaveResponse_tbData = tbData})
	m_Code_Request = 0 -- 重置请求类型
	if (tbData.eno == m_RESPONSE_OK) then -- ok
		-- 保存到系统相册
		Platform.gotoSaveImage(UIHelper.getScreenshots())
		LayerManager.removeLayout()
		return
	end

	m_ExpCollect:info(m_actionName[codeRequest], "errorInfo: " .. (m_errInfo[tbData.eno] or tbData.estr))
	zyxAlert(m_errInfo[tbData.eno] or tbData.estr)
end
-- 注册处理
local function onRegistResponse( tbData )
	onLoginResponse(tbData)
end
-- 修改密码处理
local function onChangePwdResponse( tbData )
	onLoginResponse(tbData)
end

function parseResponse( client, response, tbLogin, errorTX, okTX)
	local JsonString = response:getResponseData()
	local retCode = response:getResponseCode()
	logger:debug("JsonString %s",JsonString )
	local statusCode = m_Code_NetWork_Error
	local resValue = nil

	if (retCode ~= 200) then -- -- http 返回错误
		m_ExpCollect:info(m_actionName[m_Code_Request],
			string.format("RequestType = %s, retCode = %s, retData = %s", tostring(m_Code_Request), tostring(retCode), JsonString))

		m_Code_Request = 0
		statusCode = m_Code_NetWork_Error
		logger:debug("retCode: %d", retCode)
		PlatformUtil.showAlert(errorTX, nil)
	elseif (type(JsonString) == "string" and #JsonString > 0) then
		local cjson = require "cjson"
		resValue = cjson.decode(JsonString)
		logger:debug("parseResponse")
		logger:debug(resValue)

		m_ExpCollect:info(m_actionName[m_Code_Request], "JsonString = " .. JsonString)


		-- resValue.email_status: 0未绑定 1 待验证 2 已绑定
		local tbData = {eno = tostring(resValue.errornu), estr = resValue.errordesc,
			newuser = resValue.newuser, username = resValue.username, password = resValue.password,
			isBindUser = resValue.isBindUser, isBindEmail = tonumber(resValue.email_status),
			uid = resValue.uid, login = tbLogin, ok = okTX}
		logger:debug("m_Code_Request = %d", m_Code_Request)
		logger:debug(tbData)

		if (m_Code_Request == m_reqType.LOGIN) then  -- 登陆
			onLoginResponse(tbData)
		elseif (m_Code_Request == m_reqType.FAST_REGISTE) then -- 快速注册
			onFastRegResponse(tbData)
		elseif (m_Code_Request == m_reqType.FAST_REGISTE_SAVE) then -- 快速注册保存
			onFastRegSaveResponse(tbData)
		elseif (m_Code_Request == m_reqType.REGISTE) then -- 注册
			onRegistResponse(tbData)
		elseif (m_Code_Request == m_reqType.CHGPWD) then -- 修改密码
			onChangePwdResponse(tbData)
		end
	end
end

-- 登陆按钮回调
function onLogin(tbLogin)
	if (tbLogin.account == "" or tbLogin.pwd == "") then
		zyxAlert(m_i18n[4718])
		return false
	end

	-- if (not zyxAccountVerify(tbLogin.account) or not zyxPwdVerify(tbLogin.pwd)) then
	--     local alert = UIHelper.createCommonDlg("登陆信息格式有误，请重新输入" )
	--     LayerManager.addLayout(alert)
	--     return false
	-- end

	_isAutoEnterGame = tbLogin.bAutoLogin or false
	LayerManager.addUILoading() -- 添加屏蔽层

	-- 登陆请求URL
	local loginUrl = m_config.getLoginUrl(tbLogin.account, tbLogin.pwd)
	-- local loginUrl = m_config.getLoginUrl(CCCrypto:desEncrypt(tbLogin.account), CCCrypto:desEncrypt(tbLogin.pwd))
	logger:debug("loginUrl:%s", loginUrl)

	local request = LuaHttpRequest:newRequest()
	request:setRequestType(CCHttpRequest.kHttpGet)
	request:setTimeoutForConnect(g_HttpConnTimeout)
	request:setUrl(loginUrl)

	local function onResponse( client, response )
		LayerManager.begainRemoveUILoading() -- 请求返回删除屏蔽层

		local errorTX = m_i18n[4724] -- "登陆失败"
		local tbData = {}
		parseResponse(client, response, table.hcopy(tbLogin, tbData), errorTX )
	end

	request:setResponseScriptFunc(function(...)
		onResponse(...)
	end)

	m_Code_Request = m_reqType.LOGIN

	m_ExpCollect:start(m_actionName[m_Code_Request], "loginUrl = " .. loginUrl)

	local httpClient = CCHttpClient:getInstance()
	httpClient:send(request)
	request:release()

	return true
end

local function registVerify( tbLogin )
	if (tbLogin.account == "" or tbLogin.pwd == "" or tbLogin.pwdConfirm == "") then
		zyxAlert(m_i18n[4718])
		return false
	end

	if ( (not zyxAccountVerify(tbLogin.account)) or (not zyxPwdVerify(tbLogin.pwd))
		or (not zyxEmailVerify(tbLogin.email)) ) then
		zyxAlert(m_i18n[4729])
		return false
	end

	if (tbLogin.pwd ~= tbLogin.pwdConfirm) then
		logger:debug("sPwd = %s, confirm = %s", tbLogin.pwd, tbLogin.pwdConfirm)
		zyxAlert(m_i18n[4722]) -- "密码填写错误"
		return false
	end
	return true
end

-- 快速注册账号密码前端校验
local function fastRegistVerify( tbData )
	logger:debug({fastRegistVerify_tbData = tbData})
	
	if (tbData.account == "" or tbData.pwd == "") then
		zyxAlert(m_i18n[4718])
		return false
	end

	if ( (not zyxAccountVerify(tbData.account)) or (not zyxPwdVerify(tbData.pwd)) ) then
		zyxAlert(m_i18n[4729])
		return false
	end

	return true
end

local function addAutoLoginEvent(tbArgs)
	tbArgs.fnConfirmEvent = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()

			LayerManager.removeLayout()

			if (m_tbFastSave.account and m_tbFastSave.pwd) then
				onLogin(m_tbFastSave)
			end
		end
	end
	tbArgs.fnCloseCallback = function ( ... )
		if (m_tbFastSave.account and m_tbFastSave.pwd) then
			onLogin(m_tbFastSave)
		end
	end
end

-- 显示保存快速注册截图失败界面（用户没有给相册的访问权限）
function showFastRegistFailed(...)
	local tbArgs = {account = m_tbFastSave.account, pwd = m_tbFastSave.pwd}
	addAutoLoginEvent(tbArgs)
	ZyxView.showFastRegistFailed(tbArgs)
end

-- 显示保存快速注册截成功界面
function showFastRegistOk( ... )
	local tbArgs = {}
    tbArgs.strText = m_i18n[4752]
    tbArgs.nBtn = 1
    tbArgs.sOkTitle = m_i18n[4101]
    addAutoLoginEvent(tbArgs)
    local dlg = UIHelper.createCommonDlgNew(tbArgs)
    LayerManager.addLayout(dlg)
end

-- 快速注册按钮回调
function onFastRegist(...)
	local tbLogin = getLastRecord()
	-- 如果设备有缓存的账号信息或已经从web端返回快速注册的账号，则直接提示不再向web端请求
	local fastAccount = ZyxView.getLoginAccount()
	if (tbLogin.account and tbLogin.account ~= "" or m_bFastRegisted and fastAccount and fastAccount ~= "" ) then
		ShowNotice.showShellInfo(m_i18n[4749])
		ZyxView.addFastRegistAccount(tbLogin.account or fastAccount)
		return false
	end

	_isAutoEnterGame = tbLogin.bAutoLogin or false
	LayerManager.addUILoading() -- 添加屏蔽层

	local registUrl = m_config.getFastRegisterUrl()
	logger:debug("FastRegistUrl:%s", registUrl)

	local request = LuaHttpRequest:newRequest()
	request:setRequestType(CCHttpRequest.kHttpGet)
	request:setTimeoutForConnect(g_HttpConnTimeout)
	request:setUrl(registUrl)

	local function onResponse( client, response )
		logger:debug("onFastRegist-onResponse")
		LayerManager.begainRemoveUILoading() -- 请求返回删除屏蔽层

		local errorTX = m_i18n[4726] -- "注册失败"
		local tbData = {}
		parseResponse(client, response, table.hcopy(tbLogin, tbData), errorTX )
		-- parseResponse(client, response, tbLogin, errorTX )
	end

	request:setResponseScriptFunc(function(...)
		onResponse(...)
	end)

	m_Code_Request = m_reqType.FAST_REGISTE

	m_ExpCollect:start(m_actionName[m_Code_Request], "registUrl = " .. registUrl)

	sendHttpRequest(request)
end

-- 快速注册保存按钮回调
function onFastRegistSave(tbData)
	if (not fastRegistVerify(tbData)) then
		return
	end

	LayerManager.addUILoading() -- 添加屏蔽层

	m_tbFastSave = {account = tbData.account, pwd = tbData.pwd}

	local registUrl = m_config.getFastRegisterActionUrl(tbData.account, tbData.pwd)
	logger:debug("FastRegistActionUrl:%s", registUrl)

	local request = LuaHttpRequest:newRequest()
	request:setRequestType(CCHttpRequest.kHttpGet)
	request:setTimeoutForConnect(g_HttpConnTimeout)
	request:setUrl(registUrl)

	local function onResponse( client, response )
		logger:debug("onFastRegistSave-onResponse")
		LayerManager.begainRemoveUILoading() -- 请求返回删除屏蔽层

		local errorTX = m_i18n[4726] -- "注册失败"
		local tbLogin = {}
		parseResponse(client, response, table.hcopy(tbData, tbLogin), errorTX )
		-- parseResponse(client, response, tbLogin, errorTX )
	end

	request:setResponseScriptFunc(function(...)
		onResponse(...)
	end)

	m_Code_Request = m_reqType.FAST_REGISTE_SAVE

	m_ExpCollect:start(m_actionName[m_Code_Request], "registUrl = " .. registUrl)

	sendHttpRequest(request)
end

-- 注册按钮回调
function onRegist(tbLogin)
	if (not registVerify(tbLogin)) then
		return
	end

	_isAutoEnterGame = tbLogin.bAutoLogin or false
	LayerManager.addUILoading() -- 添加屏蔽层

	local registUrl = m_config.getRegisterUrl(tbLogin.account, tbLogin.pwd, tbLogin.email)
	logger:debug("registUrl:%s", registUrl)

	local request = LuaHttpRequest:newRequest()
	request:setRequestType(CCHttpRequest.kHttpGet)
	request:setTimeoutForConnect(g_HttpConnTimeout)
	request:setUrl(registUrl)

	local function onResponse( client, response )
		LayerManager.begainRemoveUILoading() -- 请求返回删除屏蔽层

		local errorTX = m_i18n[4726] -- "注册失败"
		local tbData = {}
		parseResponse(client, response, table.hcopy(tbLogin, tbData), errorTX )
		-- parseResponse(client, response, tbLogin, errorTX )
	end

	request:setResponseScriptFunc(function(...)
		onResponse(...)
	end)

	m_Code_Request = m_reqType.REGISTE

	m_ExpCollect:start(m_actionName[m_Code_Request], "registUrl = " .. registUrl)

	local httpClient = CCHttpClient:getInstance()
	httpClient:send(request)
	request:release()
end

-- 修改密码按钮回调
function onChangePW(tbLogin)
	if (tbLogin.account == "" or tbLogin.pwd == "" or tbLogin.newPwd == "" or tbLogin.pwdConfirm == "") then
		zyxAlert(m_i18n[4718])
		return
	end

	if (tbLogin.pwd == tbLogin.newPwd) then
		zyxAlert(m_i18n[4708]) -- 新密码需要和旧密码不一致
		return
	end

	if (not zyxPwdVerify(tbLogin.pwd) or not zyxPwdVerify(tbLogin.newPwd) or not zyxPwdVerify(tbLogin.pwdConfirm)) then
		zyxAlert(m_i18n[4729])
		return
	end
	if (tbLogin.newPwd ~= tbLogin.pwdConfirm) then
		zyxAlert(m_i18n[4745])
		return
	end

	_isAutoEnterGame = tbLogin.bAutoLogin or false
	LayerManager.addUILoading() -- 添加屏蔽层

	local changePWUrl = m_config.getChangePasswordUrl(tbLogin.account, tbLogin.pwd, tbLogin.newPwd)
	logger:debug("changePWUrl:%s", changePWUrl)

	local request = LuaHttpRequest:newRequest()
	request:setRequestType(CCHttpRequest.kHttpGet)
	request:setTimeoutForConnect(g_HttpConnTimeout)
	request:setUrl(changePWUrl)

	local function onResponse( client, response )
		LayerManager.begainRemoveUILoading() -- 请求返回删除屏蔽层

		local errorTX = m_i18n[4727] --"修改失败"
		local okTX = m_i18n[4728] -- "修改成功"
		local tbNewLogin = {account = tbLogin.account, pwd = tbLogin.newPwd}
		parseResponse(client, response, tbNewLogin, errorTX, okTX)
	end

	request:setResponseScriptFunc(function(...)
		onResponse(...)
	end)

	m_Code_Request = m_reqType.CHGPWD

	m_ExpCollect:start(m_actionName[m_Code_Request], "changePWUrl = " .. changePWUrl)

	local httpClient = CCHttpClient:getInstance()
	httpClient:send(request)
	request:release()
end

function saveAndLogin( uid, tbLogin)
	logger:debug("saveAndLogin")
	logger:debug(tbLogin)

	Platform.setPid(uid)

	-- 保存登陆类型
	local loginStat = tbLogin.udid and m_config.kLoginsStateUDIDLogin or m_config.kLoginsStateZYXLogin
	m_config.loginState(loginStat)
	m_userDefault:flush()

	setLastRecord(tbLogin)

	-- 登陆成功, 设置显示账户名称的按钮
	if (LayerManager.curModuleName() == "NewLoginView") then
		require "script/module/login/NewLoginView"
		NewLoginView.updateAccount(tbLogin) -- 如果当前模块是在选服界面才刷新帐号信息，避免找不到控件报错
	end

	if(type(config.setLoginInfo) == "function")then
		config.setLoginInfo(xmlTable)
	end

	if(_isAutoEnterGame)then
		if(not Platform.isDebug())then
			LoginHelper.loginLogicServer(uid)
		else
			local serverInfo = ServerList.getLastLoginServer()
			serverInfo.pid = uid
			print("login arg")
			print_t(serverInfo)
			LoginHelper.loginInServer(serverInfo)
		end
	end

	Platform.setCrashInfo()
end

function create( ... )
	local tbData = {other = true, logined = false, account = ""}  

	tbData.eventFastRegist = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("onFastRegist")
			if (onFastRegist()) then
				LayerManager.removeLayout()
			end
		end
	end

	tbData.eventLogin = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("onLogin")
			-- 获取文本框的内容
			local allInput = ZyxView.getAllInputText()
			logger:debug("ZyxCtrl.onLogin ZyxView.getAllInputText()")
			logger:debug(allInput)
			onLogin(allInput) -- 2015-02-13
		end
	end

	ZyxView.showOtherLogin(tbData)
end

function getLoginRecord( ... )
	local all = {}

	for i = 1, 5 do
		local uname = m_userDefault:getStringForKey(m_usrKeyPre .. i)
		if (uname == "") then
			break
		end
		all[i] = {}
		all[i].account = CCCrypto:desDecrypt(uname) -- 读出后解密
		all[i].pwd = CCCrypto:desDecrypt(m_userDefault:getStringForKey(m_pwdKeyPre .. i))
	end

	return all
end

function deleteLoginRecord( nIdx )
	local all = getLoginRecord()
	logger:debug("deleteLoginRecord before delete: %d", nIdx)
	logger:debug(all)
	if (not table.isEmpty(all)) then
		table.remove(all, nIdx)
		logger:debug("deleteLoginRecord after delete")
		logger:debug(all)
		writeAllLogin(all)
	end
end

function getLastRecord( ... )
	local all = getLoginRecord()
	return all[1] or {}
end

function setLastRecord(tbLogin)
	local all = getLoginRecord()
	logger:debug("setLastRecord1")
	logger:debug(all)
	logger:debug(tbLogin)

	if (all[1] and all[1].account == tbLogin.account) then
		logger:debug("setLastRecord2")
		if (all[1].pwd == tbLogin.pwd) then
			return -- 要设置的账户是最近一次登陆，且密码也一样直接返回
		else
			all[1].account, all[1].pwd = tbLogin.account, tbLogin.pwd  -- 如果修改了密码则重新写入本地
			logger:debug("setLastRecord3")
			logger:debug(all)
			writeAllLogin(all)
			return
		end
	end

	-- 查找要设置的账户是否已在记录中
	local idx, bFound = 1, false
	for i, v in ipairs(all) do
		if (v.account == tbLogin.account) then
			idx, bFound = i, true
			break
		end
	end

	local newRec, newAll = {account = tbLogin.account, pwd = tbLogin.pwd}, all
	if (not bFound) then -- 是一个新账户，删除最后一个，插入第一个
		if (#all == 5) then
			table.remove(all, #all)
		end
		table.insert(all, 1, newRec)
	else
		if (idx ~= 1) then
			table.remove(newAll, idx)
			table.insert(newAll, 1, newRec)
		end
	end

	logger:debug("setLastRecord4")
	writeAllLogin(newAll)
end

function writeAllLogin( tbData )
	logger:debug("writeAllLogin")
	logger:debug(tbData)

	for i = 1, 5 do
		if (tbData[i]) then
			logger:debug("writeAllLogin: %s, %s", tbData[i].account, tbData[i].pwd)
			local encUser = CCCrypto:desEncrypt(tbData[i].account)
			local encPwd = CCCrypto:desEncrypt(tbData[i].pwd)
			m_userDefault:setStringForKey(m_usrKeyPre .. i, encUser) -- 写入前加密
			m_userDefault:setStringForKey(m_pwdKeyPre .. i, encPwd)
			logger:debug("i = %d, usr = %s, pwd = %s", i, tbData[i].account, tbData[i].pwd)
			m_userDefault:flush()
		else
			m_userDefault:setStringForKey(m_usrKeyPre .. i, "")
			m_userDefault:setStringForKey(m_pwdKeyPre .. i, "")
			m_userDefault:flush()
		end
	end
end

function autoLogin( ... )
	local logins = getLoginRecord()
	local tbLogin = logins[1]
	if (tbLogin) then
		if (tbLogin and tbLogin.account and tbLogin.pwd ) then
			logger:debug(tbLogin)
			onLogin(tbLogin) -- 2015-02-13
		else
			create() -- 如果本地登陆记录有问题，则显示默认的登录界面
		end
	else
		create() -- 如果本地登陆记录有问题，则显示默认的登录界面
	end
end
