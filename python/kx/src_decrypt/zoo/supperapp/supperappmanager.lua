--[[
	腾讯应用宝积分墙
--]]

yybAdWallHttp = class(HttpBase)
function yybAdWallHttp:load(requestData)
	local context = self

	if NetworkConfig.useLocalServer then
		UserService.getInstance():cacheHttp("yybAdWall", requestData)
		
		if NetworkConfig.writeLocalDataStorage then Localhost:getInstance():flushCurrentUserData()
		else print("Did not write user data to the device.") end

		context:onLoadingComplete() 
		
		return
	end

	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end

	local loadCallback = function(endpoint, data, err)
		if err then
	    	context:onLoadingError(err)
	    else
			context:onLoadingComplete(data)
	    end
	end

	self.transponder:call("yybAdWall", requestData, loadCallback, rpc.SendingPriority.kHigh, false)
end

local SurePanel = class(BasePanel)

function SurePanel:create(goldNum)
	local instance = SurePanel.new()
	instance:loadRequiredResource("ui/supper_sure_panel.json")
	instance:init(goldNum)
	return instance
end

function SurePanel:init( goldNum )
	self.ui = self:buildInterfaceGroup('supper_sure_panel')
	BasePanel.init(self, self.ui)

	self.okBtn = GroupButtonBase:create(self.ui:getChildByName('sure'))
	self.okBtn:setEnabled(true)
	self.okBtn:setString(Localization:getInstance():getText('button.ok'))
	local function onTab( ... )
		local bounds = self.ui:getChildByName("gold"):getGroupBounds()
		local anim = FlyGoldAnimation:create(tonumber(goldNum))
		anim:setScale(2)
		anim:setWorldPosition(ccp(bounds:getMidX(),bounds:getMidY()))
		anim:play()

		self:onCloseBtnTapped()
	end
	self.okBtn:addEventListener(DisplayEvents.kTouchTap, onTab)

	self.title = self.ui:getChildByName('title')
	self.title:setText(Localization:getInstance():getText('yingyongbao.task.title'))

	self.title = self.ui:getChildByName('tips')
	self.title:setString(Localization:getInstance():getText('yingyongbao.task.text'))

	local num = self.ui:getChildByName('num')
	local position = num:getPosition()
	self.num = BitmapText:create("x" .. tostring(goldNum),"fnt/target_amount.fnt")
 	self.num:setAnchorPoint(ccp(0,1))
 	self.num:setPosition(ccp(position.x - 5, position.y - 10))
 	self.num:setScale(1.4)
 	self.ui:addChild(self.num)
end

function SurePanel:popout()
	self:setPositionForPopoutManager()
	PopoutManager:sharedInstance():addWithBgFadeIn(self, true, false, false)
end

function SurePanel:onCloseBtnTapped()
	PopoutManager:sharedInstance():removeWithBgFadeOut(self, false)
end

SupperAppManager = {}

function SupperAppManager:init( ... )
	self.entryFunc = {}

	--0sdk初始化失败
	local function sdkFunc( ... )
		return self:isInitSucceeded()
	end

	--1等级要求
	local function levelFunc()
		local level = UserManager.getInstance().user:getTopLevelId()
		return level >= 44
	end

	--2非付费玩家
	local function moneyFunc()
		if self.payUser ~= nil then 
			return not self.payUser 
		end
		local userExtend = UserManager:getInstance().userExtend
		self.payUser = userExtend.payUser
		return not userExtend.payUser
	end

	--3有网
	local function networkFunc( ... )
		local MainActivityHolder = luajava.bindClass('com.happyelements.android.MainActivityHolder')
		local Context = luajava.bindClass("android.content.Context")
		local ConnectivityManager = luajava.bindClass("android.net.ConnectivityManager")

		local connectMgr = MainActivityHolder.ACTIVITY:getContext():getSystemService(Context.CONNECTIVITY_SERVICE)

		local networkInfo = connectMgr:getActiveNetworkInfo()

		if networkInfo == nil then return false end

		return networkInfo:isConnected()
	end

	--4其他：每次开放此条件用户的10%，根据数据结果可能再做放量的调整
	local function streamFunc( ... )
		if MaintenanceManager:getInstance():isEnabled("YYBTaskFreeMoney") ~= true then
			return false
		end

		local num = MaintenanceManager:getInstance():getValue("YYBTaskFreeMoney")
		if num == nil then num = 100 end
		num = tonumber(num)
		local uid = UserManager.getInstance().user.uid
		uid = tonumber(uid)
		if uid ~= nil then
			return (uid % 100) < num
		end
		return false
	end

	-- table.insert(self.entryFunc, sdkFunc)
	table.insert(self.entryFunc, levelFunc)
	table.insert(self.entryFunc, moneyFunc)
	table.insert(self.entryFunc, networkFunc)
	table.insert(self.entryFunc, streamFunc)

	self.isInit = false

	local function initSupper()
		local manager = luajava.bindClass('com.happyelements.android.platform.tencent.SupperAppManager')
		self.manager = manager:getInstance()

		local callback = luajava.createProxy("com.happyelements.android.InvokeCallback", {
	        onSuccess = function (result)
	            self:checkData(result)
	        end,
	        onError = function (code, errMsg)
	           self:onError(code, errMsg)
	        end,
	        onCancel = function ()
	           self:onCancel()
	        end
	    });

	    self.manager:registerCallback(callback)
	end

	pcall(initSupper)
end

function SupperAppManager:initSDK( success_cb )
	if self.manager then
		local callback = luajava.createProxy("com.happyelements.android.InvokeCallback", {
	        onSuccess = function (result)
	        	self.isInit = true
	            success_cb()
	            DcUtil:UserTrack({ category='activity', sub_category='request_ad_success'})
	        end,
	        onError = function (code, errMsg)
	           self.isInit = false
	           DcUtil:UserTrack({ category='activity', sub_category='request_ad_fail'})
	        end,
	        onCancel = function ()
	        end
   	 	});
		self.manager:initSupperAppSDK(callback)
	end
end

--检测是否需要显示积分墙入口
function SupperAppManager:checkEntry()
	if not __ANDROID then return false end
	
	for _,func in ipairs(self.entryFunc) do
		if func() == false then
			return false
		end
	end
	return true
end

--显示积分墙
function SupperAppManager:showJiFenView( ... )
	if self:isInitSucceeded() == false then
		--TODO:show init error
		print("suppersdk-->show init error")
		return
	end

	if self.manager then
		self.manager:showJiFenView()
	end
end

--查询是否有任务完成
function SupperAppManager:checkData( ... )
	if self:checkEntry() == false then return end

	local callback = luajava.createProxy("com.happyelements.android.InvokeCallback", {
        onSuccess = function (result)
            self:onSuccess(result)
        end,
        onError = function (code, errMsg)
           self:onError(code, errMsg)
        end,
        onCancel = function ()
           self:onCancel()
        end
    });

    if self.manager then
    	local function check()
    		self.manager:checkData(callback)
    	end
    	pcall(check)
    end
end

function SupperAppManager:showSurePanel( goldNum )
	local panel = SurePanel:create(goldNum)
	if panel then panel:popout() end
end

--任务奖励回调
function SupperAppManager:onSuccess( p )
	if p == nil then return end

	local prize = luaJavaConvert.map2Table(p)

	local requestData = {
		tradeId = prize.tradeId,
		prizeNum = prize.prizeNum,
		taskIndex = prize.taskIndex,
		issueNum = prize.issueNum,
		taskId = prize.taskId,
		appId = prize.appId,
		taskGroup = prize.taskGroup,
		totalNum = prize.totalNum,
		issueTime = prize.issueTime,
		moneyUnit = prize.moneyUnit,
		signature = prize.signature
	}

	print("suppersdk-->lua onSuccess")
	print(table.tostring(requestData))

	local function onSuccess(event)
		print("suppersdk jifen add coin success !")
		SyncManager.getInstance():sync()
		UserManager:getInstance().user:setCash(UserManager:getInstance().user:getCash() + prize.prizeNum)
        UserService:getInstance().user:setCash(UserService:getInstance().user:getCash() + prize.prizeNum)
        if HomeScene:sharedInstance().goldButton then
            HomeScene:sharedInstance():checkDataChange()
            HomeScene:sharedInstance().goldButton:updateView()
        end
        if NetworkConfig.writeLocalDataStorage then
         	Localhost:getInstance():flushCurrentUserData()
		else 
			print("Did not write user data to the device.") 
		end
		DcUtil:UserTrack({ category='activity', sub_category='push_ad_award1', num = prize.prizeNum})
		
		local function _showSurePanel( ... )
			BuyObserver:sharedInstance():onBuySuccess()
			self:showSurePanel(prize.prizeNum)
		end

		setTimeOut(_showSurePanel, 0.2)
	end
	local function onFailed(event)
		print("suppersdk jifen add coin failed !")
	end
	local http = yybAdWallHttp.new()
	http:addEventListener(Events.kComplete, onSuccess)
	http:addEventListener(Events.kError, onFailed)
	http:load(requestData)
end

function SupperAppManager:onError(errorCode, errExtra)

end

function SupperAppManager:onCancel()
	-- body
end

--sdk 是否初始化成功
function SupperAppManager:isInitSucceeded()
	return self.isInit
end

if PlatformConfig:isQQPlatform() == true or 
	PlatformConfig:isPlatform(PlatformNameEnum.kHE) 
then
	SupperAppManager:init()
else
	function SupperAppManager:checkEntry()
		return false
	end
end