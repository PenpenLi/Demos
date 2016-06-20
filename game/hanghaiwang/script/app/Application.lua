
-- modifeid
--[[
2016-01-08, zhangqi, 加入带SDK线上版不显示版本号白屏的处理
]]

require "script/module/login/CheckVersion"
---
local m_i18n = gi18n
local m_i18nString = gi18nString
local m_fnGetWidget = g_fnGetWidgetByName
local m_ExpCollect = ExceptionCollect:getInstance()
local m_userDefault = CCUserDefault:sharedUserDefault()

local delayScheduler = nil -- 2016-02-23, 为了显示版本检测进度达到100%的延时定时器

-- 主应用类
-- @type Application
Application = class("Application")

---
-- 基础实例对象
local mInstance = nil

---
-- 获取共享的Application
-- @function [parent=#Application] sharedApplication
-- @return #Application
function Application:sharedApplication()
	if mInstance == nil then
		mInstance = Application.create()
	end
	return mInstance
end

---
-- 创建一个对象
-- @function [parent=#Application] create
-- @return #Application
function Application.create()
	local application = Application.new()

	application.mUpdating = false

	return application
end

function Application:getLastedVersion( ... )
	logger:debug("g_pkgVer.package:%s, script:%s;", g_pkgVer.package, g_pkgVer.script)
	self.mPkgVersion, self.mResVersion = g_pkgVer.package, g_pkgVer.script

	m_ExpCollect:start("getLastedVersion", 
		string.format("pid = %s, pkgVer = %s, scriptVer = %s", tostring(Platform.getPid() or 0), self.mPkgVersion, self.mResVersion))

	-- 读取外部资源包里的 version 信息
	local resPath = string.format("%s%s/%s", g_ResPath, g_ProjName, g_ResRoot) -- ../fknpirate/Resources
	local function readResVersion( ... )
		local ver = require(resPath .. "/script/version")
		package.loaded[resPath .. "/script/version"] = nil -- 释放已经require的同名模块，避免不退出游戏检测更新时不能重新加载
		return ver
	end
	local stat = nil
	stat, g_resVer = pcall(readResVersion) -- 外部资源包可能不存在，用pcall保证程序不崩溃

	if (stat) then
		logger:debug("g_resVer.package:%s, script:%s", g_resVer.package, g_resVer.script)

		if (not Helper.compareVersion(g_pkgVer.package, g_resVer.package)) then -- 底包大版本号 <= 外部更新大版本号
			self.mPkgVersion, self.mResVersion = g_resVer.package, g_resVer.script
		else
			if (not Helper.compareVersion(g_pkgVer.script, g_resVer.script)) then -- 底包资源版本号 <= 外部更新资源版本号
				-- 删除外部更新目录下script版本号低于底包script的文件
				package.loaded[g_ExtUpdateHistory] = nil
				local statH, upHistory = pcall(function () return require(g_ExtUpdateHistory) end)
				if (statH) then
					local rmFiles = {}
					local projPath = g_ResPath .. g_ProjName .. "/"
					for filePath, ver in pairs(upHistory) do
						-- 外部更新目录下script版本号 <= 底包script版本号的文件会被删除，避免错误引用
						if (not Helper.compareVersion(ver, g_pkgVer.script)) then
							logger:debug("getLastedVersion-remove: %s", projPath .. filePath)
							Util.removeDir(projPath .. filePath)
							table.insert(rmFiles, filePath)
						end
					end

					-- 从历史更新列表中删除被删除的文件记录并写回
					for _, filePath in ipairs(rmFiles) do
						upHistory[filePath] = nil
					end
					Helper.saveUpdateHistory(upHistory)

					Helper.saveVersion(g_pkgVer.package, g_resVer.script) -- 将外部更新的大版本号改成和底包相同, 避免下次检查仍进入这个条件分支
					self.mPkgVersion, self.mResVersion = g_pkgVer.package, g_resVer.script
				end
			else
				-- 把外部更新目录删除
				logger:debug("getLastedVersion-removeDir: %s", g_ResPath .. g_ProjName)
				Util.removeDir(g_ResPath .. g_ProjName) -- ../fknpirate
			end
		end
	else
		logger:debug("can not found version.lua in update path")
	end

	logger:debug(string.format("getLastedVersion--self.mPkgVersion:%s, mResVersion:%s", self.mPkgVersion, self.mResVersion))
	Helper.setVersion(self.mPkgVersion, self.mResVersion) -- 记录当前的底包和资源包版本号

	m_ExpCollect:finish("getLastedVersion")
end

---
-- 初始化方法
-- @function [parent=#Application] init
-- @param self
function Application:init(bReconnect, bSvrUpdate)
	logger:debug("Application:init bReconnect = %s", tostring(bReconnect))

	self.mDownloadUrl = "" -- 更新包下载URL
	self.mPkgInfo = nil -- 在线拉取的更新包版本信息
	self.mDownloadIdx = 0 -- 更新包的下载索引
	self.bReconnect = bReconnect or false -- 记录本次init是否重连
	self.bSvrUpdate = bSvrUpdate or false -- 记录当前是否停服更新状态

	self.instanceView = nil -- 2016-03-03, 初始化更新UI模块的实例对象，避免请求出错重试时没有初始化导致调用失败
	self.updateView = nil -- 2016-03-03，初始化更新UI模块的画布，避免请求出错重试时没有初始化导致调用失败

	self:getLastedVersion() -- 读取当前的底包和资源包版本号, 保存到 self.mPkgVersion, self.mResVersion

	if (not self.bReconnect) then -- 如果不是游戏内重连，则需要显示游戏LOGO
		-- zhangqi, 2016-01-19, 版本检测前如果是iOS版就先显示一个带游戏LOGO的白色图片，避免出现黑屏
		local plTarget = CCApplication:sharedApplication():getTargetPlatform()                                                                                                                                                                        
		if (plTarget ~= kTargetAndroid and  plTarget ~= kTargetWP8) then 
			-- 显示公司logo
			local imgLogo = ImageView:create()
			imgLogo:loadTexture("images/login/logo.png")
			imgLogo:setPosition(ccp(g_winSize.width/2, g_winSize.height/2))
			imgLogo:setScale(g_fScaleX) -- 优先屏宽放大
			local layBg = Layout:create()
			layBg:addChild(imgLogo)

			LayerManager.changeModule(layBg, "LogoSecond", {}, true)

			LayerManager.removeLogoLayer()
			self.instanceView = UpdateView:new()
			self.updateView = self.instanceView:create()
			LayerManager.changeModule( self.updateView, "3dversion", {}, true)
			self.instanceView:fakeUpdateProcess()
		end
	end

	self:checkVersion() -- 发送版本检测请求
end

---
-- 检查新版本
-- @function [parent=#Application] checkVersion
-- @param self
function Application:checkVersion()
	-- 读取平台相关信息，组合实际的更新检测请求URL
	local chkUrl = Platform.getCheckVersionUrl( self.mPkgVersion, self.mResVersion )  
	logger:debug("version chkUrl:%s", chkUrl)

	local request = LuaHttpRequest:newRequest()
	request:setRequestType(CCHttpRequest.kHttpGet)
	request:setTimeoutForConnect(g_HttpConnTimeout)
	request:setUrl(chkUrl)

	logger:debug("checkVersion: before setResponseScriptFunc")
	request:setResponseScriptFunc(function(...)
		logger:debug("checkVersion: get3dVersion response")
		if (self.httpTimeOutFunc) then
			self.httpTimeOutFunc()
			self.httpTimeOutFunc = nil
		end
		if (self.bReconnect) then
			LayerManager.removeLoginLoading() -- 删除loading
		end
		self:onGetVersion(...)
	end)
	logger:debug("checkVersion: after setResponseScriptFunc")

	self.httpTimeOutFunc = GlobalScheduler.scheduleFunc(function ( ... )
		if (self.httpTimeOutFunc) then
			self.httpTimeOutFunc()
			self.httpTimeOutFunc = nil
		end
		if (self.instanceView) then
			self.instanceView:stopProcess()
		end

		local alert = UIHelper.createVersionCheckFailed(m_i18n[1987], m_i18n[1985], function ( ... )
			LayerManager.removeNetworkDlg()
			LoginHelper.loginAgain() -- 服务器列表拉取错误提示重试就重头执行登陆流程
		end)
		LayerManager.addNetworkDlg(alert)
	end, g_HttpConnTimeout)

	m_ExpCollect:start("checkVersion", string.format("pid = %s chkUrl = %s", tostring(Platform.getPid() or 0), chkUrl))

	if (self.bReconnect) then
		LayerManager.addLoginLoading()-- 自动重连时，发请求才显示loading
	end
	local httpClient = CCHttpClient:getInstance()
	httpClient:send(request)
	request:release()
end

-- zhangqi, 2015-01-19, 是否更新的条件改为由参数直接传入，避免可能因为异步调用导致的条件错误等诡异问题
function Application:jumpToLogin( bUpdated )
	self.instanceView = nil
	self.updateView = nil
	
	-- zhangqi, 2016-02-19, 增加条件：如果上次进入游戏不是停服更新状态才进入直接重连的逻辑
	-- 否则进入选服登录UI，配合选服登录模块实现停服更新时点进入游戏按钮也能检测更新
	if (self.bReconnect and (not bUpdated) and (not self.bSvrUpdate) ) then
		self.bReconnect = false
		if (Platform.isPlatform()) then
			local pid = Platform.getPid()
			if (pid == "" or pid == nil) then -- 自动重连时常规上pid都是有效的(只有SDK帐号注销才会重置pid)，为了避免意外再判断一次
				Platform.login(LoginHelper.connectAndLogin) -- 如果pid无效就重新进行SDK的登陆，成功后再走游戏的重连流程
			else
				LoginHelper.connectAndLogin() -- 否则直接走重连流程
			end
		else
			LoginHelper.connectAndLogin()
		end
	else
		self.bReconnect = false
		LoginHelper.setReconnectStat(false) -- zhangqi, 2015-01-05, 避免断线重连的更新后无法进入游戏

		LayerManager.removeLogoLayer() -- 2016-01-25, 先删除LOGO

		local function checkFirstPlay( ... )
			if (m_userDefault:getStringForKey("FIRST_ENTER_APPLICATION") == "") then
				m_userDefault:setStringForKey("FIRST_ENTER_APPLICATION", "1")
				m_userDefault:flush()
				return true
			else
				return false
			end
		end

		local function showLoginUI( ... )
			require "script/module/login/NewLoginCtrl"
			NewLoginCtrl.create()
		end

		if (checkFirstPlay()) then -- 2015-12-16,修改为第一次玩游戏需要重播开场的罗杰动画
			require "script/module/login/NewGuyHelper"
			NewGuyHelper.showLuojie(function ( ... )
				showLoginUI()
			end)
		else
			logger:debug("jumpToLogin_showLoginUI")
			showLoginUI()
		end
	end
end

-- zhangqi, 2016-01-25, 返回更新总字节数是否小于500KB的bool值，作为静默更新的条件
function Application:isSilentUpdate( ... )
	-- return self.mTotalSize <= 500 -- KB
	return false -- 2016-1-30，暂时去掉静默更新
end

---
-- @function [parent=#Application] onGetVersion
-- @param self
-- @param CCHttpClient#CCHttpClient client
-- @param LuaHttpResponse#LuaHttpResponse response
function Application:onGetVersion(client, response)
	logger:debug("Application:onGetVersion")

	local stat, version_info = CheckVersion.getCheckStat(client, response)

	m_ExpCollect:info("checkVersion", string.format("stat = %d versionInfo = %s", stat, tostring(version_info)))
	m_ExpCollect:finish("checkVersion")

	if (self.instanceView) then
		self.instanceView:stopProcess()
		self.instanceView:setProcessFull()
	end

	-- 2016-02-23，由于performWithDelay方法第一个参数是CCNode, 而getRunningScene经常返回nil导致报错，所以改为
	-- 用 scheduler 来实现延时功能
	delayScheduler = GlobalScheduler.scheduleFunc(function ( ... )
		if (isFunc(delayScheduler)) then
			logger:debug({delayScheduler = delayScheduler})
			delayScheduler()
			delayScheduler = nil
		end
		if (stat == CheckVersion.Code_Update_None) then -- 无任何更新
			self:jumpToLogin() -- 直接进入登录界面
		elseif (stat == CheckVersion.Code_Update_Base) then -- 底包更新
			LayerManager.removeLogoLayer()  -- 删除LOGO
	
			local alert = UIHelper.createCommonDlg( m_i18n[2001], nil,
				Helper.openExplore(version_info.base.package.packageUrl),
				1, Helper.exitGameCallback())
			LayerManager.addLayout(alert)
		elseif (stat == CheckVersion.Code_Update_Script) then -- 脚本更新
			LayerManager.removeLogoLayer() -- 删除LOGO，否则挡住更新面板
	
			self.mPkgInfo = version_info.script
			-- 计算所有更新包的总大小，单位KB
			local totalSize = 0
			for i, pkg in ipairs(self.mPkgInfo) do
				totalSize = totalSize + pkg.total_size
			end
			totalSize = totalSize/1024 -- KB
			self.mTotalSize = totalSize
	
		
			function onUpdate( ... )
				self.mUpdater = Updater.create()
				self.mUpdater:addListener(self)

				self.mDownloadUrl = version_info.static_url -- zhangqi, 2015-05-15, 改为从版本信息中获取下载路径 Platform.getDownloadHost()
				m_ExpCollect:start("Download", "DownloadUrl:" .. self.mDownloadUrl)

				self.mDownloadIdx = 1 -- 当前正在下载的文件索引
				self:donwloadOnce(self.mDownloadIdx)
				LayerManager.removeLayout() -- 关闭提示框
			end

			-- zhangqi, 2016-01-25, 如果更新包字节数小于指定数值, 就不显示更新界面，静默更新
			-- 2016-01-30, 暂时去掉静默更新功能
			-- if (self:isSilentUpdate()) then
			-- 	onUpdate()
			-- 	return
			-- end

			-- zhangqi, 2015-06-01, 检查如果当前已经显示了更新UI则直接返回
			-- 避免重连时多次弹出更新提示的诡异现象以及其导致的更新报错
			if (LayerManager.curModuleName() == "UpdateView") then
				return
			end

			-- zhangqi, 2015-06-01, 先释放全局定时器(包括通过GlobalScheduler创建的独立定时器），
			-- 避免更新完成后释放所有被加载模块时因为先后顺序问题可能导致的变量引用错误
			GlobalScheduler.destroy()

			LayerManager.removePriorityTouchLayer() -- 删除可能存在的触摸高优先级屏蔽层

			self.bReconnect = false

			if (self.instanceView) then
				self.instanceView:updateProcess(0, 0, 0)
			else
				require "script/module/update/UpdateView"
				self.instanceView = UpdateView:new()
				self.updateView = self.instanceView:create()
				LayerManager.changeModule( self.updateView, self.instanceView:moduleName(), {}, true)
			end

			-- 新的更新提示面板
			local strokeColor = ccc3(0x28, 0x00, 0x00)
			local layPrompt = g_fnLoadUI("ui/regist_update_tip.json")
			local labTotal = m_fnGetWidget(layPrompt, "TFD_FORCE_2")
			labTotal:setText(string.format("%.2fKB", totalSize))

			local i18nText1 = m_fnGetWidget(layPrompt, "TFD_FORCE_1")
			i18nText1:setText(m_i18n[4207])
			local i18nText3 = m_fnGetWidget(layPrompt, "TFD_FORCE_3")


			local btnUpdate = m_fnGetWidget(layPrompt, "BTN_UPDATE")
			UIHelper.titleShadow(btnUpdate, m_i18n[4201])
			btnUpdate:addTouchEventListener(function ( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					onUpdate()
				end
			end)

			local btnClose = m_fnGetWidget(layPrompt, "BTN_CLOSE")
			if (self.mPkgInfo[1].forceUpdate == 0) then -- 以第一个更新包的 forceUpdate 为准决定本次所有更新是否需要强制下载
				i18nText3:setText(m_i18n[4209]) -- 非强制更新提示
				UIHelper.titleShadow(btnClose, m_i18n[4101])
				btnClose:addTouchEventListener(function ( sender, eventType )
					if (eventType == TOUCH_EVENT_ENDED) then
						self:jumpToLogin() -- 非强制更新，直接进入登录界面
					end
				end)
			else
				i18nText3:setText(m_i18n[4208]) -- 强制更新提示
				UIHelper.titleShadow(btnClose, m_i18n[4202])
				btnClose:addTouchEventListener(Helper.onExitGame("checkVersion")) -- 2015-03-31
			end

			-- AppStore审核
			-- if (Platform.isAppleReview()) then
			-- 	onUpdate()
			-- else
			-- 	LayerManager.addLayout(layPrompt)
			-- end
			onUpdate()

		elseif (stat == CheckVersion.Code_NetWork_Error) then -- 网络请求出错
			if (self.bReconnect) then -- 是自动重连
				-- 如果尝试重连次数未达到最大值 并且 没有显示断线提示才自动重连
				if (LoginHelper.reconnCount() < g_reconnMax and not LayerManager.networkDlgIsShow()) then
					LoginHelper.autoReconnect()
				else
					self.bReconnect = false
					LoginHelper.netWorkFailed(true) -- true表示显示断线提示面板
				end
			else
				logger:debug("Appliction-not reconnect")
				local alert = UIHelper.createVersionCheckFailed(m_i18n[1987], m_i18n[1985], function ( ... )
					if (g_debug_mode and g_no_web) then -- 如果web服务异常直接进入登录界面
						LayerManager.removeNetworkDlg()

						self:jumpToLogin()

						return
					end

					LayerManager.removeNetworkDlg()

					self:checkVersion()
				end)
				LayerManager.addNetworkDlg(alert)
			end
		else -- Web端返回数据格式错误或没查到请求的版本号
			self:jumpToLogin() -- 直接进入登录界面
		end -- end for if (stat == CheckVersion.Code_Update_None) then -- 无任何更新
	end, 0.5)
end

function Application:donwloadOnce(fileIndex)
    local pkg = self.mPkgInfo[fileIndex]
    self.mUpdating = true
    self.mUpdateVersion = pkg.tar_version

    -- 用于判断更新包后面有没有.zip这几个字符
    local zipString = ""

    if (pkg.noZipString and pkg.noZipString == 1) then
    	zipString =  ""
    else
    	zipString = ".zip"
    end

    local pkgUrl = ""
    -- zhangqi, 2015-11-30, 将线上下载更新包的路径由os决定改为取path字段
    if (Platform.isPlatform() and (not g_debug_mode)) then
        pkgUrl = string.format("%s/%s/%s/%s" .. zipString, self.mDownloadUrl, pkg.updateType, pkg.path, pkg.file)
    else
        pkgUrl = string.format("%s/%s" .. zipString, self.mDownloadUrl, pkg.file)
    end

    -- zhangqi, 2015-12-17, 线下调试环境连线上需要         
	if (g_DEBUG_env.offline) then                          
	    pkgUrl = g_DEBUG_env.pkgUrl(self.mDownloadUrl, pkg)
	end
	                                                  
    logger:debug("donwloadOnce, pkgUrl: %s", pkgUrl)

    m_ExpCollect:info("Download", "donwloadOnce: pkgUrl = " .. pkgUrl)

    -- 计算本次下载大概需要的时间   
    local maxDownloadTime = math.ceil(tonumber(pkg.total_size)/g_HttpRateRef)
    logger:debug("maxDownloadTime = %d", maxDownloadTime)
    if (maxDownloadTime < g_HttpReadTimeout) then
        maxDownloadTime = g_HttpReadTimeout
    end

    -- 启动一个更新器
    self.mUpdater:start(pkgUrl, pkg.file .. zipString, pkg.file, maxDownloadTime) -- url, save_name, md5
end

function Application:onProgress(event)
	local curDownloaded = self.mPkgInfo[self.mDownloadIdx].total_size/1024 * event.percent / 100 -- 当前包已下载的字节数 KB
	local downloaded = 0 -- 之前已下载的所有包的字节数 KB
	for i = 1, self.mDownloadIdx - 1 do
		downloaded = downloaded + self.mPkgInfo[i].total_size
	end
	downloaded = downloaded/1024

	logger:debug("self.mDownloadIdx = %d", self.mDownloadIdx)
	logger:debug("self.mPkgInfo[self.mDownloadIdx].total_size = %d, kb = %d", self.mPkgInfo[self.mDownloadIdx].total_size, self.mPkgInfo[self.mDownloadIdx].total_size/1024)
	logger:debug("event.percent = %d, curDownloaded = %f", event.percent, curDownloaded)
	logger:debug("downloaded = %f", downloaded)

	self.curSize = math.ceil(downloaded + curDownloaded) -- 当前已下载的总字节数
	self.totalPercent = self.curSize/self.mTotalSize * 100
	logger:debug("self.curSize = %f, self.mTotalSize = %d, self.totalPercent = %d", self.curSize, self.mTotalSize, self.totalPercent)
	
	if (event.complete) then
		m_ExpCollect:finish("Download")

		-- if (not self:isSilentUpdate()) then -- 2016-1-30，暂时去掉静默更新
			self.instanceView:updateProcess(self.mTotalSize, self.curSize, self.totalPercent)
			self.instanceView:showUnzipText()
		-- end

		-- zhangqi, 2015-04-23, 把下载完成切换到登陆界面的处理放在 instanceView:updateProcess 之后，
		-- 避免在onFinished中切换会有几率导致莫名其妙的 instanceView:updateProcess 找不到控件对象 self 的报错
		performWithDelay(
			tolua.cast(LayerManager.getRootLayout(), "CCNode"),
			function ( ... )
				-- zhangqi, 2014-12-27, 清理 CCFileUtils 的路径缓存，避免重新加载文件时加载了非预期的缓存路径中的文件
				CCFileUtils:sharedFileUtils():purgeCachedEntries()

				-- if (not self:isSilentUpdate()) then -- 2016-1-30，暂时去掉静默更新
					-- zhangqi, 2016-01-19, 以最后一个更新包的 forceExit 为准决定本次更新完成后是否需要强制退出重进游戏
					if (self.mPkgInfo and self.mPkgInfo[#self.mPkgInfo].forceExit == 1) then
						local alert = UIHelper.createCommonDlg(m_i18n[2002], nil, Helper.onExitGame(), 1, Helper.exitGameCallback() )
						LayerManager.addSwitchDlg(alert)
						return
					end

					-- 因为后面LayerManager.init会清除scene上所有节点，为了避免加载选服界面之前的黑屏（创建选服UI的时间间隔）
					-- 必须再把更新界面保持一会儿
					self.updateView:retain()
					if (self.updateView:getParent()) then
						self.updateView:removeFromParentAndCleanup(true)
					end
					local layTemp = Layout:create()
					layTemp:addChild(self.updateView)
					self.updateView:release()
				-- end
				
				-- zhangqi, 2015-12-17, 先释放所有已加载模块
				LoginHelper.releaseLoadedModule()

				-- zhangqi, 2015-12-17, 上面释放里所有的已加载模块，需要重新require
				require "script/module/login/LoginHelper"
				LoginHelper.initGame() 

				-- if (not self:isSilentUpdate()) then -- 2016-1-30，暂时去掉静默更新
					-- LayerManager 重新初始完再把更新界面显示出来，最后change到选服界面时会自动删除更新界面
					LayerManager.addLayoutNoScale(layTemp)
				-- end

				local mainApp = Application.create()
				mainApp:jumpToLogin(true)
			end, 
			0.5 -- 延时0.5秒进入登录界面，留时间看清下载成功正在解压的文字
		) 
	else
		logger:debug("self.curSize1 = %f", self.curSize)
		-- if (not self:isSilentUpdate()) then -- 2016-1-30，暂时去掉静默更新
			self.instanceView:updateProcess(self.mTotalSize, self.curSize, self.totalPercent)
		-- end
	end
end

function Application:onFinished(event)
	self.mUpdating = false
	if event.err ~= "ok" then
		logger:debug("更新第%d个包错误，按确认重试，取消退出游戏", self.mDownloadIdx)
		logger:debug(event.err)

		local alert = UIHelper.createCommonDlg(m_i18n[4204], nil,
			function ( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					if (self.mDownloadIdx <= #self.mPkgInfo) then
						self:donwloadOnce(self.mDownloadIdx)
					else
						logger:debug("DownloadIdx:%d > #self.mPkgInfo:%d", self.mDownloadIdx, #self.mPkgInfo)
					end
				end
			end, 2, Helper.exitGameCallback())
		LayerManager.addLayout(alert)
	else
		Helper.saveVersion(self.mPkgVersion, self.mUpdateVersion) -- 保存本次更新的版本
		Helper.UpdateHistory() -- 刷新本地的历史更新列表

		m_ExpCollect:info("Download", "donwloadOnce ok: " .. self.mDownloadIdx)
		self.mDownloadIdx = self.mDownloadIdx + 1
		if (self.mDownloadIdx <= #self.mPkgInfo) then
			self:donwloadOnce(self.mDownloadIdx)
			logger:debug("正在更新 %d/%d 包", self.mDownloadIdx, #self.mPkgInfo)
			-- UpdateView.updateProcess(self.mDownloadIdx, #self.mPkgInfo, 0)
			logger:debug("self.curSize2 = %d", self.curSize)
			self.instanceView:updateProcess(self.mTotalSize, self.curSize, self.totalPercent)
		else
			logger:debug("更新完成, 进入登录UI")
			-- zhangqi, 2015-04-23, 为了避免onProgress中百分比检查的误差，手工指定必然可以切换到登陆界面的条件
			self.mDownloadIdx = self.mDownloadIdx - 1
			local event = {complete = true, percent = 100}
			self:onProgress(event)
		end
	end
end

function Application:onLowMemory()
	CCDirector:sharedDirector():purgeCachedData()
end
