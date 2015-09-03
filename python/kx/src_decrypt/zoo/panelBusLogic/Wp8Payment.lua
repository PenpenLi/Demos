Wp8Payments = {
--    CHINA_MOBILE = 1,
    IAPPPAY = 4,
    MSPAY = 5,
}

Payments = Wp8Payments

Wp8SupportedPayments = {
--	[Wp8Payments.CHINA_MOBILE] = {1,2,3},
	[Wp8Payments.IAPPPAY] = {1,2,3,4,5},
	[Wp8Payments.MSPAY] = {},
}

local mmAppId = "300008276251"
local mmAppKey = "3BA7DC3A10380449"
CMccPayment:GetInstance():Init(mmAppId, mmAppKey)

Wp8Payment = class()

local forceChoose = false
local billIdSeq = 0
local gspAppId = "5000105666"

function Wp8Payment:create(goodsId)
	local logic = Wp8Payment.new()
	if logic:init(goodsId) then
		return logic
	else
		logic = nil
		return nil
	end
end

function Wp8Payment:init(goodsId)
	self.goodsId = goodsId
	self.goodsType = 2
	return true
end

function Wp8Payment:iapppayStart(uid, orderId, price)
	local pay_start = os.time()
	local function onPurchaseCallback(r)
		local pay_duration = os.time() - pay_start
		local alreadySuccess = false
		if r == 1 then
			alreadySuccess = true
		end
		local intervals = {1}
		if alreadySuccess then
			intervals = {2, 4, 8}
		elseif pay_duration > 60 then
			intervals = {2, 4, 4}
		elseif pay_duration > 40 then
			intervals = {2, 4}
		elseif pay_duration > 20 then
			intervals = {2, 2}
		end
		local trytimes = 0
		local function __checkOrder()
			local function onFail()
				Wp8Utils:CloseLoading()
				if alreadySuccess then
					CommonTip:showTip("支付已经完成，但是到账会稍有延迟", "positive", nil, 3)
					if self.cancelCallback then self.cancelCallback() end
				else
					if self.failCallback then self.failCallback() end
				end
			end
			local function onSuccess()
				Wp8Utils:CloseLoading()
				if self.successCallback then self.successCallback() end
			end
			local function onRequestError( evt )
				evt.target:removeAllEventListeners()
				if trytimes < #intervals then
					print("__checkOrder retry when onRequestError")
					trytimes = trytimes + 1
					setTimeOut(__checkOrder, intervals[trytimes])
				else
					print("__checkOrder fail onRequestError")
					onFail()
				end
			end
			local function onRequestFinish( evt )
				evt.target:removeAllEventListeners()
				if evt.data and evt.data.finished then
					if evt.data.success then
						print("__checkOrder success")
						onSuccess()
					else
						print("__checkOrder finish but not success")
						onFail()
					end
				elseif trytimes < #intervals then
					print("__checkOrder retry when onRequestFinish")
					trytimes = trytimes + 1
					setTimeOut(__checkOrder, intervals[trytimes])
				else
					print("__checkOrder fail onRequestFinish")
					onFail()
				end
			end
			local http = QueryQihooOrderHttp.new(true)
			http:addEventListener(Events.kComplete, onRequestFinish)
			http:addEventListener(Events.kError, onRequestError)
			http:load(self.billId)
		end
		trytimes = trytimes + 1
		setTimeOut(__checkOrder, intervals[trytimes])
		Wp8Utils:ShowLoading()
	end
	IappPay:GetInstance():StartPay(tostring(uid), self.goodsId, tostring(orderId), price, onPurchaseCallback)
end

function Wp8Payment:buy(successCallback, failCallback, cancelCallback)
  
	local function startPayment(paymentType)
		self.paymentType = paymentType
		if not paymentType then 
			if cancelCallback then cancelCallback() end
			return
		end
		local user = UserManager:getInstance().user
		if not user or not user.uid then
			he_log_error("cat not get user id")
			failCallback()
			return
		end
		
		if paymentType == Wp8Payments.IAPPPAY then
			local uid = user.uid
			billIdSeq = billIdSeq + 1
			self.billId = uid .. "_" .. os.time() .. "_" .. billIdSeq
			local exchangeMeta = MetaManager:getInstance().product_wp8[self.goodsId]
			local extend_table = {billId=self.billId, itemId=10000+self.goodsId, goodsType=2, itemPrice=exchangeMeta.rmb}
			local cjson = require("cjson")
			local extend = cjson.encode(extend_table)
			local url = 'http://web.pay.cn.happyelements.com/userpayment/76/1/init/'..gspAppId..'/'..uid
			local request = HttpRequest:createPost(url)
			request:setConnectionTimeoutMs(10 * 1000)
			request:setTimeoutMs(30 * 1000)
			request:addPostValue("random", os.time() .. "")
			request:addPostValue("product_id", (10000 + self.goodsId) .. "")
			request:addPostValue("price", string.format("%.2f", exchangeMeta.rmb / 100.0))
			request:addPostValue("client", "windowsphone")
			request:addPostValue("client_version", MetaInfo:getInstance():getApkVersion())
			request:addPostValue("locale", MetaInfo:getInstance():getCountry())
			request:addPostValue("language", MetaInfo:getInstance():getLanguage())
			request:addPostValue("platform", "windowsphone")
			request:addPostValue("extend", extend)
			request:addPostValue("store", "microsoft")
      
			local function initOrderFinish(response)
				Wp8Utils:CloseLoading()
				if response.httpCode == 200 then
					local orderId = nil
					local function safeParseRsp()
						print(response.body)
						local rsp_table = cjson.decode(response.body)
						if rsp_table.result == "success" then
							orderId = rsp_table.order_id
						end
					end
					pcall(safeParseRsp)
					if orderId then
						self.successCallback = successCallback
						self.failCallback = failCallback
						self.cancelCallback = cancelCallback
						self:iapppayStart(uid, orderId, exchangeMeta.rmb)
					else
						print(response.body)
						CommonTip:showTip("创建订单失败", "negative")
						if cancelCallback then cancelCallback() end
					end
				else
					print(table.tostring(response))
					CommonTip:showTip("网络异常，创建订单失败", "negative")
					if cancelCallback then cancelCallback() end
				end
			end
			Wp8Utils:ShowLoading(500)
			HttpClient:getInstance():sendRequest(initOrderFinish, request)

		elseif paymentType == Wp8Payments.CHINA_MOBILE then
			local function onPurchaseCallback(r, para)
				print("onPurchaseCallback " .. r)
				if r == 1 then
					local function onSuccess()
						if successCallback then successCallback() end
					end
					local function onFail(evt)
						if failCallback then failCallback(evt) end
					end
					local http = IngameHttp.new(true)
					http:ad(Events.kComplete, onSuccess)
					http:ad(Events.kError, onFail)
					local orderId = para.tradeId
					local channelId = "wp8_china_mobile"
					local detail = ""
					if para and type(para) == "table" then
						detail = table.serialize(para)
					end
					http:load(self.goodsId, orderId, channelId, self.goodsType, detail)
				elseif r == 0 then
					if failCallback then failCallback() end
				elseif r == -1 then
					if cancelCallback then cancelCallback() end
				else end
			end
      local mobile_mock = false
      if mobile_mock then
        local mock_tradeId = user.uid .. "_" .. os.time()
        onPurchaseCallback(1, {tradeId = mock_tradeId})
      else
        local payCode = MetaManager.getInstance().product_wp8[self.goodsId].mmPaycode
        CMccPayment:GetInstance():Order(payCode, 1, onPurchaseCallback)
      end
		end
	end
	
	local paymentsToShow = {}
	for k,v in pairs(Wp8SupportedPayments) do
		for __,v2 in ipairs(v) do 
			if v2 == self.goodsId then
				paymentsToShow[k] = true
				break
			end
		end
	end
	
	local snum = 0
	local usedPayment
	for k,v in pairs(paymentsToShow) do
		if v then 
			snum = snum + 1 
			usedPayment = k
		end
	end
	print("Wp8 paymentsToShow num " .. snum)
	if not forceChoose and snum == 1 then
		startPayment(usedPayment)
	else
		require 'zoo.panel.ChoosePaymentPanel'
		local panel = ChoosePaymentPanel:create(paymentsToShow)
		if panel then panel:popout(startPayment) end
	end

end
