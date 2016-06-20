-- FileName: NewLoginCtrl.lua
-- Author: menghao
-- Date: 2014-07-10
-- Purpose: 登陆界面ctrl


module("NewLoginCtrl", package.seeall)


require "script/module/login/NewLoginView"
require "platform/Platform"

-- UI控件引用变量 --
local layMain

-- 模块局部变量 --
local m_ExpCollect = ExceptionCollect:getInstance()
local m_userDefault = CCUserDefault:sharedUserDefault()
local m_i18n = gi18n
local m_tbAllServerData
local m_selectServer
local m_lastLoginServer -- 2016-01-08, 保存最近登录服务器信息
local tbEvent

local m_MAX_RECENT = 6 -- 最近访问的服务器最多6个
local m_tbGidGname -- 记录groupid和服务器名称的对应关系，便于获取最近登录服务器名称
local m_commendServer -- 记录推荐服信息


local function init(...)
	m_tbAllServerData = {}
	m_lastLoginServer = {}
	m_tbGidGname = {}
	m_commendServer = nil
	m_selectServer = nil
end


function destroy(...)
	package.loaded["NewLoginCtrl"] = nil
end


function moduleName()
	return "NewLoginCtrl"
end

local function copy2gServerInfo(tbInfo)
	if (g_debug_mode and g_no_web) then
		return g_tbServerInfo
	end

	for k, v in pairs(tbInfo or {}) do
		g_tbServerInfo[k] = v
	end
end

function setSelectServer( tbServerData )
	if (not tbServerData) then
		return
	end
	logger:debug({setSelectServer_tbServerData = tbServerData})
	m_selectServer = tbServerData
	copy2gServerInfo(tbServerData)
	NewLoginView.upServerUI(tbServerData)
end


-- 获取默认选择的服务器
function getSelectServerInfo( ... )
	if (g_debug_mode and g_no_web) then
		return g_tbServerInfo
	end

	if (m_selectServer) then
		return m_selectServer
	else
		local last = getLastLoginServer()
		if (last) then
			return last
		elseif (m_tbAllServerData) then
			if (m_commendServer) then
				return m_commendServer
			else
				return m_tbAllServerData[#m_tbAllServerData]
			end
		else
			return nil
		end
	end
end


-- 获取最近选择的服务器
function getRecentServerList()
	if (not table.isEmpty(m_lastLoginServer)) then
		return m_lastLoginServer
	end

	local recentGroup = LoginHelper.fnRecentServerGroup()
	if (recentGroup == nil or recentGroup == "") then
		return nil
	else
		local recentGroupTable = string.split(recentGroup, ",")
		local recentServer = {}
		for k1,groupId in pairs(recentGroupTable) do -- 外层循环先遍历本地缓存的登录group保证最近优先的顺序
			for k2,v in pairs(m_tbAllServerData) do
				if(v.group and v.group == groupId) then
					table.insert(recentServer, v)
				end
			end
		end
		return recentServer
	end
end


-- 添加一个最近选择的服务器
local function addRecentServerGroup(server_group)
	local recentGroup = LoginHelper.fnRecentServerGroup()
	local tbRecent = {}
	local idx, bFound = 1, false

	if (recentGroup and recentGroup ~= "") then
		tbRecent = string.split(recentGroup, ",")

		-- 从当前保存的最近访问服务器中查找
		for i, group in ipairs(tbRecent) do
			if (group == server_group) then
				idx, bFound = i, true
				break
			end
		end
	end

	local function newRecentList( newRecent, oldRecent )
		for i = 1, m_MAX_RECENT - 1 do
			if (not oldRecent[i]) then
				break
			end
			table.insert(newRecent, oldRecent[i])
		end
	end

	local newRecent = {server_group}
	if (bFound) then -- 如果从最近列表中找到
		if (idx == 1) then 
			return -- 已经是最近一个，不需要保存
		else
			table.remove(tbRecent, idx) -- 如果不是最近一个，从之前的位置删除
		end	
	end
	newRecentList(newRecent, tbRecent)

	LoginHelper.fnRecentServerGroup(table.concat(newRecent, ","))
end


function getLastLoginServer( )
	if(m_tbAllServerData == nil) then
		return nil
	end

	local list = getRecentServerList() or {}
	return list[1]
end

local function getList( sender, res )
	if (res:getResponseCode()==200) then
		m_ExpCollect:finish("askServerList")

		local cjson = require "cjson"
		local results = cjson.decode(res:getResponseData())
		logger:debug({getList_jsonResults = results})

		-- zhangqi, 2014-12-15, web端返回的root.item是一个字典，需要按key降序排序后转成一个array型的table
		local allServerKey = table.allKeys(results.root.item)
		table.sort(allServerKey, function ( a, b )
			return tonumber(a) > tonumber(b)
		end)
		for _, key in ipairs(allServerKey) do
			local svrInfo = results.root.item[key]
			table.insert(m_tbAllServerData, svrInfo)
			m_tbGidGname[svrInfo.groupid] = svrInfo

			if (tonumber(svrInfo.tj) == 1) then
				m_commendServer = svrInfo -- zhangqi, 2016-01-20, 记录推荐服的信息
			end
		end
		logger:debug({m_tbGidGname = m_tbGidGname, getList_m_tbAllServerData = m_tbAllServerData})

		setSelectServer(getSelectServerInfo()) -- 2016-01-08

		-- 如果有进入游戏公告则显示
		local tbNotices = results.root.notice
		if (tbNotices and tbNotices.open and tonumber(tbNotices.open) > 0) then
			require "script/module/login/LoginNoticeView"
			local layNotice = LoginNoticeView.create()
			LayerManager.addLayout(layNotice)

			local strDesc = tbNotices.desc
			local tbOneOld = string.split(strDesc, "|")
			local tbInfo = {}

			tbInfo.colorT = string.split(tbOneOld[1], ",")
			tbInfo.colorW = string.split(tbOneOld[3], ",")
			tbInfo.title = tbOneOld[2]
			tbInfo.word = tbOneOld[4]

			LoginNoticeView.addAnnounce(tbInfo)
		end
	else
		logger:debug("askServerList_responseCode = %s", tostring(res:getResponseCode()))
		m_ExpCollect:info("askServerList", "responseCode = " .. tostring(res:getResponseCode()))
		local alert = UIHelper.createVersionCheckFailed(m_i18n[1987], m_i18n[1985], function ( ... )
			LayerManager.removeNetworkDlg()
			LoginHelper.loginAgain() -- 服务器列表拉取错误提示重试就重头执行登陆流程
		end)
		LayerManager.addNetworkDlg(alert)
	end
end


function askServerList( ... )
	-- zhangqi, 2015-12-17, 加入线下连线上环境的条件判断
	if (g_DEBUG_env.offline) then                       
		config.getHost = g_DEBUG_env.getHost            
		Platform.getUrlParam = g_DEBUG_env.getUrlParam  
	end

	local url = Platform.getServerListUrl()
	m_ExpCollect:start("askServerList", "url = " .. url)
	local request = LuaHttpRequest:newRequest()
	request:setRequestType(CCHttpRequest.kHttpGet)
	request:setUrl(url)
	request:setResponseScriptFunc(getList)
	CCHttpClient:getInstance():send(request)
	request:release()
end

-- zhangqi, 2016-01-12, 处理拉最近登录服务器信息的http响应
local function getRecentList( sender, res )
	-- zhangqi, 2016-03-09, 解决了getHash和实际登录游戏服的信息不一致问题，去掉登录按钮的限制
	-- NewLoginView.setBtnLoginEnabled(true) -- 2016-02-25, 最近登录服务器请求返回后启用登录按钮

	if (res:getResponseCode() ~=200 ) then
		LayerManager.removeLoading() -- 2016-02-21

		local alert = UIHelper.createVersionCheckFailed(m_i18n[1987], m_i18n[1985], function ( ... )
			LayerManager.removeNetworkDlg()
			LoginHelper.loginAgain() -- 服务器列表拉取错误提示重试就重头执行登陆流程
		end)
		LayerManager.addNetworkDlg(alert)
	else
		local cjson = require "cjson"
		local results = cjson.decode(res:getResponseData())
		logger:debug({getRecentList_jsonResults = results})

		-- zhangqi, 2016-01-07, 保存从web端返回的最近登录信息      
 		local roles = results.root.role or {}
		for i, server in ipairs(roles) do
			server.groupid = tostring(server.groupid)
			m_lastLoginServer[i] = m_tbGidGname[server.groupid .. ""]
			if (m_lastLoginServer[i]) then
				for k, v in pairs(server) do
					m_lastLoginServer[i][k] = v
				end
			end
		end
		logger:debug({m_lastLoginServer = m_lastLoginServer})

		local recent = getRecentServerList() or {} -- 第一次登陆没有最近登陆信息，用空表容错
		setSelectServer(recent[1] or m_commendServer) -- 如果没有上次登录信息则用推荐服设置

		LayerManager.removeLoading() -- 2016-02-21
	end
end

-- zhangqi, 2016-01-12, 拉最近登录的服务器信息
function askRecentSeverList( ... )
	local url = Platform.getRecentLoginUrl()
	local request = LuaHttpRequest:newRequest()
	request:setRequestType(CCHttpRequest.kHttpGet)
	request:setUrl(url)
	request:setResponseScriptFunc(getRecentList)

	-- 2016-02-21, 增加Loading屏蔽，确保最近登录信息未返回时用户点了进入游戏按钮连接服务器的信息和从getHash返回的一致
	LayerManager.addLoading() -- 2016-02-21, 增加Loading屏蔽，避免最近登录信息未返回时用户点了进入游戏按钮导致

	CCHttpClient:getInstance():send(request)
	request:release()
end

local function beginLoginGame( ... )
	local pid = LoginHelper.pidGet()

	local function gameLogin( ... )
		addRecentServerGroup(m_selectServer.group)
		LoginHelper.loginGame()
	end

	-- zhangqi, 2015-12-17, 加入线下连线上环境的条件判断
	if (g_DEBUG_env.offline) then
		gameLogin()
		return
	end

	if (pid and pid ~= "") then
		gameLogin()
	else
		if (Platform.isLogin()) then -- 如果平台账户已登录，可能pid信息还没从web端返回，提示重试
			local tbArgs = {strText = m_i18n[2829], nBtn = 2}
			LayerManager.addLayout(UIHelper.createCommonDlgNew(tbArgs))
		else
			Platform.login(function ( ... )
				gameLogin()
			end) -- 平台帐号没有登陆, 登录成功后直接进入游戏
		end
	end
end

-- 2016-02-19, 把进入游戏按钮的逻辑独立成一个方法，以便实现停服更新时点击进入游戏按钮也要进行更新检测的需求
function onLogin( ... )
	-- 如果web服务异常就跳过直接显示登陆界面
	if (g_debug_mode and g_no_web) then
		local testPid = NewLoginView.getTextPid()
		if (tonumber(testPid) == nil or testPid == "") then
			LayerManager.addLayout(UIHelper.createCommonDlg("Need pid number"))
			return
		end
		LoginHelper.debugUID(testPid)
		LoginHelper.loginGame()
		return
	end

	-- zhangqi, 2015-12-17, 加入线下连线上环境的条件判断
	if (g_DEBUG_env.offline) then
	    beginLoginGame()
	    return
	end

	if (Platform.isPlatform()) then
		-- zhangqi, 2016-01-04, 如果没有开服（拉到空服务器列表）就弹出浮动提示
		local pid = Platform.getPid()
		if ( pid and pid ~= "" and table.isEmpty(m_tbAllServerData)) then
			ShowNotice.showShellInfo(m_i18n[7601])
			return
		end
		
		beginLoginGame()
	else
		logger:debug("enter onLogin 2")

		local testPid = NewLoginView.getTextPid()
		if (tonumber(testPid) == nil or testPid == "") then
			LayerManager.addLayout(UIHelper.createCommonDlg("Need pid number"))
			return
		end
		
		LoginHelper.debugUID(testPid)

		local group = m_selectServer.group
		Platform.setLastLoginGroup(group)
		addRecentServerGroup(group)

		LoginHelper.loginGame()
	end
end

function create(...)
	if (LayerManager.curModuleName() == NewLoginView.moduleName()) then
		logger:debug({"NewLoginView exist"})
		-- 如果当前还是在选服界面，就表示是在选服界面点击进入游戏后重新进行了版本检查而且没有更新的情况，直接进入游戏
		onLogin()
		return
	end

	init() -- zhangqi, 2016-01-04

	-- 2013-03-11, 平台统计需求，进入选服主页面
	if (Platform.isPlatform()) then
		Platform.sendInformationToPlatform(Platform.kComeInMainLayer)
	end

	AudioHelper.initAudioInfo()
	AudioHelper.playSceneMusic("denglu.mp3")

	tbEvent = {}

	tbEvent.onChoose = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			m_ExpCollect:start("showServerList")
			require "script/module/login/ServerListCtrl"
			local recentServerList = getRecentServerList()
			LayerManager.addLayout(ServerListCtrl.create(m_tbAllServerData, recentServerList))
			m_ExpCollect:finish("showServerList")
		end
	end

	tbEvent.onLogin = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playEnter()

			-- zhangqi, 2016-02-19, 如果是停服更新状态，每次都需要走版本检测的流程
			if (LoginHelper.svrUpdateStat()) then
				LoginHelper.svrUpdateStat(false) -- 重置停服更新状态为false

				LoginHelper.svrUpdateWaitCheck()
				return
			else
				onLogin()
			end
		end
	end

	if (g_debug_mode and g_no_web) then
		layMain = NewLoginView.create( tbEvent, {hot = 1, name = "1.85 server"} )
		LayerManager.changeModule( layMain, NewLoginView.moduleName(), {}, true)
	else
		layMain = NewLoginView.create( tbEvent, m_selectServer )
		LayerManager.changeModule( layMain, NewLoginView.moduleName(), {}, true)


	    LayerManager.removeLogoLayer() -- 2016-01-08, 删除渠道LOGO

	    
	    if (Platform.isPlatform()) then
	    	-- zhangqi, 2016-03-01, 如果是AppStore包重发一次AdShow请求，解决更新后没有更新AdShow状态导致审核屏蔽失效的问题
	    	local platformName = Platform.getPlatformFlag()
	    	if (platformName == "IOS_APPSTORE_CHW" or platformName == "IOS_APPSTORE_CHW2") then
	    		Platform.fnAdShow()
	    	end

	    	askServerList() -- 先拉所有服务器列表

			logger:debug("NewLoginCtrl.create: Platform.login")
			Platform.login(askRecentSeverList) -- sdk登录成功后才能拉最近登录的服务器信息
		else
			askServerList()
		end
	end
end

