if __IOS then
	require "zoo.util.IosPayment"
	require 'zoo.gameGuide.IosPayGuide'
	require 'zoo.panel.iosSalesPromotion.IosSalesManager'
end

local function getMetaItems(items)
	local t = {}
	for k,v in pairs(items) do
		table.insert(t, {itemId = v.itemId, num = v.num})
	end
	return t
end

IapBuyPropLogic = class()

function IapBuyPropLogic:midEnergyBottle()
	local product = {id = 10, cash = 0, discount = 3, extraCash = 0, goodsId = 159,
		price = 1, productId = "com.happyelements.animal.gold.cn.10"}
	for k, v in ipairs(MetaManager:getInstance().product) do
		if v.id == product.id then product = v end
	end
	local meta = MetaManager:getInstance():getGoodMeta(product.goodsId)
	local ret = {id = product.id, price = product.price, items = getMetaItems(meta.items), goodsId = product.goodsId,
		productIdentifier = product.productId, iapPrice = product.price, priceLocal = "CN"}

	return ret
end

function IapBuyPropLogic:addStep()
	local product = {id = 11, cash = 0, discount = 2, extraCash = 0, goodsId = 160,
		price = 1, productId = "com.happyelements.animal.gold.cn.11"}
	for k, v in ipairs(MetaManager:getInstance().product) do
		if v.id == product.id then product = v end
	end
	local meta = MetaManager:getInstance():getGoodMeta(product.goodsId)
	local ret = {id = product.id, price = product.price, items = getMetaItems(meta.items), goodsId = product.goodsId,
		productIdentifier = product.productId, iapPrice = product.price, priceLocal = "CN"}

	return ret
end

function IapBuyPropLogic:rabbitWeeklyPlayCard()
	local product = {id = 12, cash = 0, discount = 6, extraCash = 0, goodsId = 161,
		price = 3, productId = "com.happyelements.animal.gold.cn.12"}
	for k, v in ipairs(MetaManager:getInstance().product) do
		if v.id == product.id then product = v end
	end
	local meta = MetaManager:getInstance():getGoodMeta(product.goodsId)
	local ret = {id = product.id, price = product.price, items = getMetaItems(meta.items), goodsId = product.goodsId,
		productIdentifier = product.productId, iapPrice = product.price, priceLocal = "CN"}

	return ret
end

function IapBuyPropLogic:oneYuanShop()
	local guideModel = require("zoo.gameGuide.IosPayGuideModel"):create()
	local oneYuanShopPID = guideModel:getOneYuanShopProductID()

	-- local product = {id = oneYuanShopPID , cash = 0, discount = 2, extraCash = 0, goodsId = 213,
	-- 	price = 1, productId = "com.happyelements.animal.gold.cn.14"}
	local ref
	local product
	for k, v in ipairs(MetaManager:getInstance().product) do
		if v.id == oneYuanShopPID then product = v end
	end
	if product then 
		local meta = MetaManager:getInstance():getGoodMeta(product.goodsId)
		local pConfig = IosSalesManager:getPromitonConfigById(oneYuanShopPID)
		if pConfig then 
			ret = {id = product.id, price = product.price, items = getMetaItems(meta.items), goodsId = product.goodsId,
					productIdentifier = product.productId, iapPrice = product.price, priceLocal = "CN", discount = product.discount, 
					oriPrice = pConfig.oriPrice, pLevel = pConfig.pLevel}
		else
			ret = {id = product.id, price = product.price, items = getMetaItems(meta.items), goodsId = product.goodsId,
					productIdentifier = product.productId, iapPrice = product.price, priceLocal = "CN", discount = product.discount}
		end
	end
	return ret
end

function IapBuyPropLogic:buy(data, successCallback, failCallback, dcDispatcher)
	local function onSuccess()

		for k, v in pairs(data.items) do
			if v.itemId >= 10000 and v.itemId < 20000 and v.itemId ~= 10054 then
				local user = UserManager:getInstance()
				local serv = UserService:getInstance()
				user:addUserPropNumber(v.itemId, v.num)
				serv:addUserPropNumber(v.itemId, v.num)
			elseif v.itemId == ItemType.COIN then
				UserManager:getInstance().user:setCoin(UserManager:getInstance().user:getCoin() + v.num)
	            UserService:getInstance().user:setCoin(UserService:getInstance().user:getCoin() + v.num)
	            if HomeScene:sharedInstance().coinButton then
	                HomeScene:sharedInstance():checkDataChange()
	                HomeScene:sharedInstance().coinButton:updateView()
	            end
			elseif v.itemId == ItemType.GOLD then
				UserManager:getInstance().user:setCash(UserManager:getInstance().user:getCash() + v.num)
	            UserService:getInstance().user:setCash(UserService:getInstance().user:getCash() + v.num)
	            if HomeScene:sharedInstance().goldButton then
	                HomeScene:sharedInstance():checkDataChange()
	                HomeScene:sharedInstance().goldButton:updateView()
	            end
			end
		end

		local userExtend = UserManager:getInstance().userExtend
		if userExtend then userExtend.payUser = true end

		if NetworkConfig.writeLocalDataStorage then Localhost:getInstance():flushCurrentUserData()
		else print("Did not write user data to the device.") end

		if successCallback then
			successCallback()
		end

		local user = UserManager:getInstance():getUserRef()
		local stageInfo = StageInfoLocalLogic:getStageInfo(user.uid)
		local levelId = 0
		if stageInfo then levelId = stageInfo.levelId end
		--ios用rmb购买 不关心道具类型 所以nil
		DcUtil:logRmbBuy(data.goodsId, nil, data.price, 1, levelId)

		GlobalEventDispatcher:getInstance():dispatchEvent(
			Event.new(kGlobalEvents.kConsumeComplete, {
				price = data.price,
				-- props = Localization:getInstance():getText("prop.name."..tostring(data.itemId)),
				props = Localization:getInstance():getText("goods.name.text"..tostring(data.goodsId)),
		}))
	end
	local function onFail()
		if failCallback then failCallback() end
	end

	if __IOS then
		IosPayment:buy(data.productIdentifier, data.iapPrice, data.priceLocale, "", onSuccess, onFail, dcDispatcher)
	elseif __WIN32 then
		onFail()
	else
		onFail()
	end
end