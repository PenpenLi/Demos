if __IOS then
	require "zoo.util.IosPayment"
end

IapBuyPropLogic = class()

function IapBuyPropLogic:midEnergyBottle()
	local product = {id = 10, cash = 0, discount = 3, extraCash = 0, goodsId = 159,
		price = 1, productId = "com.happyelements.animal.gold.cn.10"}
	for k, v in ipairs(MetaManager:getInstance().product) do
		if v.id == product.id then product = v end
	end
	local meta = MetaManager:getInstance():getGoodMeta(product.goodsId)
	local ret = {id = product.id, price = product.price, itemId = meta.items[1].itemId, goodsId = product.goodsId,
		num = meta.items[1].num, productIdentifier = product.productId, iapPrice = product.price, priceLocal = "CN"}

	return ret
end

function IapBuyPropLogic:addStep()
	local product = {id = 11, cash = 0, discount = 2, extraCash = 0, goodsId = 160,
		price = 1, productId = "com.happyelements.animal.gold.cn.11"}
	for k, v in ipairs(MetaManager:getInstance().product) do
		if v.id == product.id then product = v end
	end
	local meta = MetaManager:getInstance():getGoodMeta(product.goodsId)
	local ret = {id = product.id, price = product.price, itemId = meta.items[1].itemId, goodsId = product.goodsId,
		num = meta.items[1].num, productIdentifier = product.productId, iapPrice = product.price, priceLocal = "CN"}

	return ret
end

function IapBuyPropLogic:rabbitWeeklyPlayCard()
	local product = {id = 12, cash = 0, discount = 6, extraCash = 0, goodsId = 161,
		price = 3, productId = "com.happyelements.animal.gold.cn.12"}
	for k, v in ipairs(MetaManager:getInstance().product) do
		if v.id == product.id then product = v end
	end
	local meta = MetaManager:getInstance():getGoodMeta(product.goodsId)
	local ret = {id = product.id, price = product.price, itemId = meta.items[1].itemId, goodsId = product.goodsId,
		num = meta.items[1].num, productIdentifier = product.productId, iapPrice = product.price, priceLocal = "CN"}

	return ret
end

function IapBuyPropLogic:buy(data, successCallback, failCallback)
	local function onSuccess()
		local user = UserManager:getInstance()
		local serv = UserService:getInstance()
		user:addUserPropNumber(data.itemId, data.num)
		serv:addUserPropNumber(data.itemId, data.num)

		local userExtend = UserManager:getInstance().userExtend
		if userExtend then userExtend.payUser = true end

		if NetworkConfig.writeLocalDataStorage then Localhost:getInstance():flushCurrentUserData()
		else print("Did not write user data to the device.") end

		if successCallback then
			successCallback()
		end

		GlobalEventDispatcher:getInstance():dispatchEvent(
			Event.new(kGlobalEvents.kConsumeComplete, {
				price = data.price,
				props = Localization:getInstance():getText("prop.name."..tostring(data.itemId)),
		}))
	end
	local function onFail()
		if failCallback then failCallback() end
	end

	if __IOS then
		IosPayment:buy(data.productIdentifier, data.iapPrice, data.priceLocale, "", onSuccess, onFail)
	elseif __WIN32 then
		onSuccess()
	else
		onFail()
	end
end