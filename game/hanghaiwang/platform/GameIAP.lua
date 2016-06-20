-- FileName: GameIAP.lua
-- Author: MaBingtao
-- Date: 2014-08-12
-- Purpose: function description of module
--[[TODO List]]

module("GameIAP", package.seeall)


-- local HttpConnTimeout = 10

local StatePurchasing = 0      -- Transaction is being added to the server queue.
local StatePurchased = 1       -- Transaction is in queue, user has been charged.  Client should complete the transaction.
local StateFailed = 2          -- Transaction was cancelled or failed before being added to the server queue.
local StateRestored = 3        -- Transaction was restored from user's purchase history.  Client should complete the transaction.

-- 模块局部变量 --
local m_tbl_effectProducts = {}

local order_id = nil

local inGame = false

function getHost( ... )
    local host = "http://msdk.one-piece.cc"
    if( Platform.isDebug() )then
        host = "http://192.168.1.113:17601"
    end
    return host
end

-- 按splitByChar分割字符串str
-- added by fang. 2013.10.14
local  function stringSplitByChar (str, char)
    local sub_str_tab = {}

    local lastPos=1

    local bLeft = false 
    for i=1, #str do
        local curChar = string.char(string.byte(str, i))
        if curChar == char then
            local size = #sub_str_tab
            sub_str_tab[size+1] = string.sub(str, lastPos, i-1)
            lastPos = i+1
            bLeft = false 
        else
            bLeft = true
        end
    end
    if bLeft then
       local size = #sub_str_tab
       sub_str_tab[size+1] = string.sub(str, lastPos)
    end
        
    return sub_str_tab
end

local function getUUID(  )
	return Platform.getUUID()
end

local function getServerTime( )
	return tostring(os.time())
end
local function getToken(  )
	return Platform.getConfig().getToken()
end

local function getServerKey( )
	return Platform.getServerId()
end

local function getAppPurchaesUrl()
	local url = getHost() .. "/sdk/sdkexchange/appstore/" .. Platform.getConfig().getAppId() .. "/ios?"
	if ( Platform.isDebug() ) then
		url = url .. "issandbox=1"
	else
		url = url .. "issandbox=0"
	end
	url = url .. "&packageVersion=" .. g_pkgVer.package

	
	return url
end
local _updateTimeScheduler=nil
local timeOutCount=60
local function timeOutFunc( ... )
	print(" timer out")
	hideProgress()
end

function showProgress(string)

	BTStoreUtil:showProgress(string)
	if nil == _updateTimeScheduler then
		print("GameIAP strat timer")
	 	_updateTimeScheduler = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc( timeOutFunc, timeOutCount, false )
	end
end

function hideProgress()
	BTStoreUtil:hideProgress()
	if(nil ~= _updateTimeScheduler)then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry( _updateTimeScheduler )
		_updateTimeScheduler = nil
		print("GameIAP stop timer 2")
	end
end



--[[
    desc:创建订单  并给苹果发送支付请求
    arg1:商品 id
    return: void  
-—]]
local function createOrder( _product_id )
	inGame = true
	
	logger:debug("createOrder  %s" , _product_id)

	local function onCreateOrder( client, response )
	
		local responseString = response:getResponseData()
		local retCode = response:getResponseCode()
	  	
		logger:debug("responseString: %s",responseString)

	  	if(retCode~=200)then
	 		logger:fatal("http code %d" , retCode)
	 		hideProgress()
	  	   	return
	 	end

	 	local cjson = require "cjson"
	 	local createOrderInfo = cjson.decode(responseString)
	 	logger:debug("createOrder : %s" , createOrderInfo)

	 	if(createOrderInfo == nil) then
	 		logger:fatal("err : responseString : %s" , responseString)
	 		hideProgress()
	    	return
		end

	  	if(createOrderInfo.status == "0") then
        	
        	order_id = createOrderInfo.orderId or 0
        	local saveInfo=getToken().."|"..getServerKey().."|"..createOrderInfo.orderId
        	--存储，如果苹果存储信息丢失时使用
        	CCUserDefault:sharedUserDefault():setStringForKey(_product_id, saveInfo)
        	logger:debug("start buy product saveInfo=%s",saveInfo)
        	showProgress("正在请求支付")
        	local payment = BTSKPayment:paymentWithProductIdentifier(_product_id)
			payment:setApplicationUsername(saveInfo)
			BTSKPaymentQueue:defaultQueue():addPayment(payment)
	 	else
	 		logger:fatal("createOrder failed! status : %d" , createOrderInfo.status)
	 		hideProgress()
	 		BTStoreUtil:showAlert(function () end , "提示" , createOrderInfo.msg, "", "OK")
	 		return
	  	end
    end

    local requestUrl = getAppPurchaesUrl()
    logger:debug("requestUrl  %s" , requestUrl)
 	--请求创建订单
    local requestCreateOrder = function ( ... )
    	logger:debug("requestCreateOrder")
    	local isJail = BTStoreUtil:isDeviceJail()

        requestUrl = requestUrl .. "&action=create"
        requestUrl = requestUrl .. "&bind=" .. getUUID()
	    requestUrl = requestUrl .. "&product_id=" .. Platform.encodeURL( _product_id )
    	requestUrl = requestUrl .. "&is_jail=" .. isJail
	    requestUrl = requestUrl .. "&token="..getToken().."&serverid="..getServerKey()

	    logger:debug("requestUrl: %s", newUrl)
	    sendHTTPRequestLua(onCreateOrder, requestUrl, 0)
    	
    end



    --获得付费地区标识
    local getLocalIndentifierCallback = function ( request , response )
    	logger:debug("getLocalIndentifierCallback")
		local bt_response = tolua.cast(response , "BTSKProductsResponse")
        localId = bt_response:getLocalId() or ""
        requestUrl = requestUrl .. "&local_id=" .. Platform.encodeURL(localId)
        logger:debug("iap local = %s", localId)
        requestCreateOrder()
    end
    local args = CCArray:create()
	args:addObject(CCString:create(_product_id))

   	local productReq = BTSKProductsRequest:createWithProductIdentifiers(args);
   	productReq:registerScriptHandler(getLocalIndentifierCallback)

end


local function sendVerifyOrder( _transaction , purchase_pid, purchase_server_id ,purchase_order_id )
	
	--[[
	 	   和web端约定的错误码处理
    	0: 正常验证成功， 重复验证成功
    	1: 创建失败
    	2: 取消失败
    	3: 确认订单失败
    	4: 默认失败
    	5: 验证超时失败
    	6: 服务器返回，但未收到数据
    --]]
	local function onVerifyOrder( client, response )
		hideProgress()
		local responseString = response:getResponseData()
		local retCode = response:getResponseCode()
	  	
		logger:debug("Verify responseString: %s",responseString)

	  	if(retCode~=200)then
	 		logger:fatal("Verify http code %d" , retCode)
	 		_transaction:release()
	  	   	return
	 	end

	 	local cjson = require "cjson"
	 	local verifyInfo = cjson.decode(responseString)
	 	logger:debug("verifyInfo : %s" , verifyInfo)
		logger:debug("status : %s" , verifyInfo.status)

	 	if(verifyInfo == nil) then
	 		logger:fatal("verify result decode err : responseString : %s" , responseString)
	 		_transaction:release()
	    	return
		end

		if (tonumber(verifyInfo.status) == 0) then

			BTStoreUtil:showAlert(function () end , "提示" , "充值成功", "", "OK")
			
			BTSKPaymentQueue:defaultQueue():finishTransaction( _transaction )
			logger:debug("finishTransaction")
		elseif  (tonumber(verifyInfo.status) == 3) then

			BTStoreUtil:showAlert(function () end , "提示" , "充值验证失败，如果已扣款，请退出游戏后重试", "", "OK")
			-- BTSKPaymentQueue:defaultQueue():finishTransaction( _transaction )
		elseif  (tonumber(verifyInfo.status) == 5) then

			BTStoreUtil:showAlert(function () end , "提示" , "充值验证中，请耐心等待到账，若长时间未到账，请联系客服", "", "OK")
			-- BTSKPaymentQueue:defaultQueue():finishTransaction( _transaction )
		elseif  (tonumber(verifyInfo.status) == 7) then

			BTStoreUtil:showAlert(function () end , "提示" , "订单创建失败，请检查网络并重试！", "", "OK")
			-- BTSKPaymentQueue:defaultQueue():finishTransaction( _transaction )
		else
			BTStoreUtil:showAlert(function () end , "提示" , "充值失败，请检查网络并重试！", "", "OK")
		end

		_transaction:release()

	end

	local receiptData =  _transaction:getTransactionReceipt()
	local encodeReceipt = BTStoreUtil:encode( receiptData , string.len( receiptData ))

	local verifyUrl = getAppPurchaesUrl().."&action=confirm&orderId="..(purchase_order_id or "non")
	verifyUrl = verifyUrl .. "&timestamp=".. Platform.encodeURL(getServerTime()) .. "&uuid=" ..Platform.encodeURL( getUUID() )
	verifyUrl = verifyUrl.."&token="..(purchase_pid or "non").."&serverid="..(purchase_server_id or "non").."&receipt-data="..encodeReceipt

	sendHTTPRequestLua(onVerifyOrder, verifyUrl, 0)
	if(purchase_order_id == nil)then
		local errorLog = debug.traceback()  .. "-lua_tracebackex=" .. Platform.tracebackex()
		loggerHttp:fatal(errorLog)
	end
end
--[[
    desc:支付结果返回后向web端验证此次支付结果
    arg1: 订单对象
    reture: none
-—]]
local function verifyPurchase(  _transaction )

	local product_id = _transaction:getPayment():getProductIdentifier()
	local backOrderId = CCUserDefault:sharedUserDefault():getStringForKey(product_id)
	local userInfo = _transaction:getPayment():getApplicationUsername()
	logger:debug("userInfo : %s" , userInfo)
	_transaction:retain()
	if(userInfo == nil or userInfo == "") then
		if(backOrderId == nil or backOrderId == "")then
			BTStoreUtil:showAlert(function () end , "提示" , "充值验证失败，如果已扣款，请联系客服", "", "OK")
			BTSKPaymentQueue:defaultQueue():finishTransaction( _transaction )
			hideProgress()
			return
		end
		userInfo = backOrderId 
	end

	
	--
	--校验当前账号和服务器信息与订单返回附带的信息是否一致
	---
	local purchase_pid  = "none"
	local purchase_server_id = "none"
	local purchase_order_id = "none"
	logger:debug("userInfo : %s" , userInfo)

	local tbl_info = stringSplitByChar(userInfo , "|")
	logger:debug(tbl_info)

	if (tbl_info) then
		purchase_pid  = tbl_info[1]
		purchase_server_id = tbl_info[2]
	    purchase_order_id = tbl_info[3]
		if(purchase_pid == nil or purchase_server_id==nil or purchase_order_id==nil)then
			BTStoreUtil:showAlert(function () end , "提示2" , "充值验证失败，如果已扣款，请联系客服", "", "OK")
			BTSKPaymentQueue:defaultQueue():finishTransaction( _transaction )
			hideProgress()
			return
		end
	else
		BTSKPaymentQueue:defaultQueue():finishTransaction( _transaction )
		hideProgress()
	end
	if(inGame)then
		showProgress("正在验证支付结果")
	end
	sendVerifyOrder( _transaction , purchase_pid, purchase_server_id ,purchase_order_id )

end


local function cancelOrder( _transaction )

	local userInfo = _transaction:getPayment():getApplicationUsername()
	local errorCode=0
	if(_transaction.getErrorCode)then
		errorCode = _transaction:getErrorCode()
	end
	print("userInfo",userInfo)
	local tbl_info = stringSplitByChar(userInfo , "|")
	print("tbl_info[3]",tbl_info[3])
	if ( type(tbl_info) == "table"  and tbl_info[3] ) then

		 --支付失败平台数据处理
		local  function failRequestCallback ( client, response )
			hideProgress()
		    if ( response:getResponseCode() ~= 200 ) then
		    	logger:fatal("cancel order error  %d ",response:getResponseCode())
		        return
		    end
		    local responseString = response:getResponseData()
		    -- logger:debug("purchase cancelOrder:" , responseString)
		    local cjson = require "cjson"
		    local cancelOrderInfo = cjson.decode(responseString)
	 		logger:debug("cancelOrder : %s" , cancelOrderInfo)
	 		if(errorCode)then
	 			if(errorCode ~= 2)then
	 				BTStoreUtil:showAlert(function () end , "提示" , "充值失败，请检查网络并重试！", "", "OK")
	 			end
	 		else
			    BTStoreUtil:showAlert(function () end , "提示" , "充值失败，请检查网络并重试！", "", "OK")
			end
		end
		local requestUrl = getAppPurchaesUrl().."&action=cancel".."&orderId=".. Platform.encodeURL( tbl_info[3] )
		requestUrl = requestUrl.."&token="..(tbl_info[1] or "") .. "&serverid="..(tbl_info[2] or "")
		print("requestUrl",requestUrl)
		-- local newUrl = addMd5ForVerifyUrl(requestUrl)
		-- if newUrl == nil then
  --   		newUrl = requestUrl
  --  		end
   		-- sendHttpRequest(newUrl , failRequestCallback)
   		sendHTTPRequestLua(failRequestCallback, requestUrl, 0)

	else
		hideProgress()
	end

end


function prepareStore(  )

	local function paymentQueueHandler( _transaction)
		local state = _transaction:getTransactionState()
		local product_id = _transaction:getPayment():getProductIdentifier()

		logger:debug("product_id %s state : %d error:%s" ,product_id, state , _transaction:getError())
		
		if ( state == StatePurchasing ) then
			logger:trace("pay StatePurchasing : %s" , product_id )

		elseif ( state == StatePurchased ) then
			logger:trace("pay StatePurchased : %s" , product_id )
			-- BTSKPaymentQueue:defaultQueue():finishTransaction( _transaction )
			verifyPurchase( _transaction )	

		elseif ( state == StateFailed ) then
			logger:trace("pay StateFailed : %s" , product_id )
			logger:debug("%s",_transaction:getError())
			BTSKPaymentQueue:defaultQueue():finishTransaction( _transaction )
			cancelOrder( _transaction ) 
			
		elseif ( state == StateRestored ) then
			logger:trace("pay StateRestored : %s" , product_id )
			verifyPurchase( _transaction )
		end

	end

	BTSKPaymentQueue:defaultQueue():registerScriptHandler(paymentQueueHandler)
end



--[[
    desc:获取商品信息状态 包括可购买的和不可购买的
    arg1: 商品数组
    return: 
-—]]
function getProductInfo( _productids )
	if ( type(_productids) ~= "table" ) then
		return
	end

	logger:debug(_productids)

	local args = CCArray:create()
	
	for k, v in ipairs( _productids ) do
		if (type(v) == "number") then
			args:addObject(CCInteger:create(v))
		elseif (type(v) == "string") then
			args:addObject(CCString:create(v))
		end 
	end


	local function productInfo( request , response )

		local bt_response = tolua.cast(response , "BTSKProductsResponse")
		local  effectiveArr = tolua.cast( bt_response:getProducts(), "CCArray")
		local  InvalidArr =  tolua.cast( bt_response:geInvalidProductIdentifiers() , "CCArray")
		
		for i=0 , effectiveArr:count()-1 do
			local bt_product = tolua.cast( effectiveArr:objectAtIndex(i), "BTSKProduct")
			local product_id = bt_product:getProductIdentifier()
			logger:debug(" effective :%s" , product_id)
			table.insert( m_tbl_effectProducts , product_id) 
		end

		for i=0 , InvalidArr:count()-1 do
			local product_id = tolua.cast( InvalidArr:objectAtIndex(i), "CCString")
			local Invalidproduct_id = product_id:getCString()
			logger:debug(" Invalidproduct_id :%s" , Invalidproduct_id)
		end

	end

   	local productReq = BTSKProductsRequest:createWithProductIdentifiers(args);
   	productReq:registerScriptHandler(productInfo)

end



--[[
    desc:发出购买请求
    arg1: 有效地product_id
    return: 
-—]]
function buyProduct( _product_id )
	if ( type(_product_id) ~= "string") then
		logger:fatal("_product_id not string")
		return
	end

	local isEffective = false
	for k,product_id in pairs(m_tbl_effectProducts) do
		if ( product_id == _product_id ) then
			isEffective = true
		end
	end

	if ( isEffective ) then
		logger:debug(m_tbl_effectProducts)
		logger:debug("try to buy Invalid product_id %s" , _product_id)
		-- return
	end

	if ( not BTSKPaymentQueue:canMakePayments() ) then
		logger:fatal("BTSKPaymentQueue:canMakePayments = false")
		return
	end

	createOrder( _product_id )

	showProgress("正在创建订单")

end

--- 签名下 url 增加time 和sign
local function signUrl( _url )
    local  url = _url .. "&time="..Platform.getWebTime()
    local sortedParams = Platform.fnSortUrlParams (url)
    sortedParams = Platform.getConfig().getAppKey()..sortedParams
    logger:debug("sortedParams = %s", sortedParams)
    local sign = CCCrypto:md5(sortedParams, string.len(sortedParams), false)
    url = url .. "&sign=" .. sign
    logger:debug("sign url %s" , url)
    return url
end

function sendHTTPRequestLua( callback, url,  type)
    url = signUrl(url)
	logger:debug("url=%s",url)
	local arr = stringSplitByChar(url,"?")
	url = arr[1]
	local param = arr[2]
    local request = LuaHttpRequest:newRequest()
    request:setRequestType(1)--post
    request:setUrl(url)
    request:setRequestData(param, string.len(param))
    request:setResponseScriptFunc(function(client, response)
        logger:debug("request url: %s",url )
        logger:debug("response: %s",response:getResponseData() )
        if not response:isSucceed() then
            logger:fatal("url : %s" , url)
            PlatformUtil.showAlert(("充值失败，请检查网络并重试！!"), function ( ... )
                PlatformUtil.closeAlert()
            end)
            PlatformUtil.reduceLoadingUI()
            return
        end
        if(callback)then
            callback(client, response)
        end
    end)
    local httpClient = CCHttpClient:getInstance()
    httpClient:send(request)
    request:release()
end

