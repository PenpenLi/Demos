local NetworkCheckBean = class()

function NetworkCheckBean:ctor(requestUrlList)
	self.requestUrlList = requestUrlList
	self.forceShutDown = false
end

function NetworkCheckBean:request(url,callback)
	local function onCallback(response)
    	callback(response.httpCode)
    end

	local request = HttpRequest:createGet(url)
    local timeout = 3
  	local connection_timeout = 2

  	if __WP8 then 
    	timeout = 30
    	connection_timeout = 5
  	end

    request:setConnectionTimeoutMs(connection_timeout * 1000)
    request:setTimeoutMs(timeout * 1000)

    HttpClient:getInstance():sendRequest(onCallback, request)
end

function NetworkCheckBean:setForceShutDown(shutDown)
	self.forceShutDown = shutDown
end

function NetworkCheckBean:check(successCallback, failCallback)
	local animation = nil
	local requestList = {}
	for _,data in pairs(self.requestUrlList) do
		local url = data.url
		if url and string.len(url) > 0 then 
			local curRequestIdx = #requestList + 1
			requestList[curRequestIdx] = function()	
				print("PaymentNetworkCheck check url === "..url)
				self:request(url,function (code)
					if self.forceShutDown then 
						return 
					end 
					if code == 200 then 
						if data.successContinue and #requestList > curRequestIdx then 
							requestList[curRequestIdx + 1]()
						else
							PaymentNetworkCheck.getInstance():setIsChecking(false)
							PaymentNetworkCheck.getInstance():setNetworkState(true)
							animation:removeFromParentAndCleanup(true)
							if successCallback then 
								successCallback()
							end						
						end
					else
						if data.failContinue and #requestList > curRequestIdx then 
							requestList[curRequestIdx + 1]()
						else
							PaymentNetworkCheck.getInstance():setIsChecking(false)
							PaymentNetworkCheck.getInstance():setNetworkState(false)
							animation:removeFromParentAndCleanup(true)
							if failCallback then 
								failCallback()
							end			 		
						end
					end
				end)
			end
		end
	end

	local function onCloseButtonTap()
		self.forceShutDown = true
        animation:removeFromParentAndCleanup(true)
		if failCallback then 
			failCallback()
		end		
    end

	local scene = Director:sharedDirector():getRunningScene()
    animation = CountDownAnimation:createNetworkAnimation(scene, onCloseButtonTap)
    -- scene:addChild(animation)

	requestList[1]()
end

PaymentNetworkCheck = class()
local instance = nil

function PaymentNetworkCheck.getInstance()
	if not instance then
		instance = PaymentNetworkCheck.new()
		instance:init()
	end
	return instance
end

function PaymentNetworkCheck:init()
	self.networkState = false
	self.lastCheckTime = nil
	self.isChecking = false
	self:getRequestUrlList()
end

function PaymentNetworkCheck:getRequestUrlList()
	local compareUrl = "http://m.baidu.com/"
	local dynamicIp = nil
	if NetworkConfig.dynamicHost == "http://animalmobile.happyelements.cn/" then 
		dynamicIp = "http://182.254.189.181/"
	elseif NetworkConfig.dynamicHost == "http://mobile.app100718846.twsapp.com/" then 
	end 

	-- if dynamicIp then 
	--  	self.requestUrlList = {
	-- 		{
	-- 			url = compareUrl,
	-- 			successLog="",failLog="",
	-- 			successContinue=true,
	-- 			failContinue=false
	-- 		},
	-- 		{
	-- 			url = NetworkConfig.dynamicHost,
	-- 			successLog="The client bug",failLog="",
	-- 			successContinue=false,
	-- 			failContinue=true
	-- 		},
	-- 		{
	-- 			url = dynamicIp,
	-- 			successLog="DNS error",failLog="Failed to connect to the server",
	-- 			successContinue=false,
	-- 			failContinue=false
	-- 		},
	-- 	}
	-- else
	 	self.requestUrlList = {
			{
				url = compareUrl,
				successLog="",failLog="",
				successContinue=false,failContinue=false
			},
			-- {
			-- 	url = NetworkConfig.dynamicHost,
			-- 	successLog="The client bug",failLog="DNS error",
			-- 	successContinue=false,failContinue=false
			-- },
		}
	-- end
end

function PaymentNetworkCheck:setNetworkState(networkState)
	self.networkState = networkState
end

function PaymentNetworkCheck:check(successCallback, failCallback)
	if PrepackageUtil:isPreNoNetWork() then 
		if failCallback then 
			failCallback()
		end		
		return
	end

	if self.lastCheckTime then 
		local timePass = os.time() - self.lastCheckTime
		--1秒内不再重复检测
		if timePass < 1 then 
			if self.networkState then
				if successCallback then 
					successCallback()
				end	
			else
				if failCallback then 
					failCallback()
				end			 
			end
			return
		end
	end
	self.lastCheckTime = os.time()

	self:setIsChecking(true)
	local networkCheckBean = NetworkCheckBean.new(self.requestUrlList)
	networkCheckBean:check(successCallback, failCallback)
end

function PaymentNetworkCheck:setIsChecking(isChecking)
	if not isChecking then isChecking = false end
	self.isChecking = isChecking
end

function PaymentNetworkCheck:getIsChecking()
	return self.isChecking
end
