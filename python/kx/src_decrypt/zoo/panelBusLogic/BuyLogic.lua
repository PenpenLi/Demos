


BuyLogic = class()

function BuyLogic:create(goodsId, moneyType, targetId)
	local logic = BuyLogic.new()
	if logic:init(goodsId, moneyType, targetId) then
		return logic
	else
		logic = nil
		return nil
	end
end

function BuyLogic:init(goodsId, moneyType, targetId)
	if moneyType ~= 1 and moneyType ~= 2 then return false end

	local meta = MetaManager:getInstance():getGoodMeta(goodsId)
	local user = UserManager:getInstance().user
	self.items = {}
	for __, v in ipairs(meta.items) do table.insert(self.items, {itemId = v.itemId, num = v.num}) end
	self.goodsId = goodsId
	self.meta = meta
	self.moneyType = moneyType
	self.user = user
	self.targetId = targetId or goodsId

	local stageInfo = StageInfoLocalLogic:getStageInfo( user.uid );
	self.levelId = -1
	if stageInfo then
		self.levelId = stageInfo.levelId
	end

	return true
end

-- 返回值：实际价格（可能是折扣价，0即为不可买），可买最高数量（仅与限购相关），折扣前价格（如果折扣了的话）
-- 实际价格为0表示出错，不考虑另外的返回值；可买数量为-1表示不限购买数量；折扣前价格为0表示当前就是原价
function BuyLogic:getPrice()
	local num = UserManager:getInstance():getDailyBoughtGoodsNumById(self.goodsId)

	local realPrice = 0
	local buyLimit = 0
	local originalPrice = 0

	if self.moneyType == 1 then 
		realPrice = self.meta.coin
		buyLimit = -1 
		originalPrice = 0
	elseif self.moneyType == 2 then

		if self.meta.discountQCash ~= 0 then -- 打折
			realPrice = self.meta.discountQCash
			originalPrice = self.meta.qCash
		else
			realPrice = self.meta.qCash
			originalPrice = 0
		end
		if self.meta.limit == 0 then
			buyLimit = -1
		else 
			if num >= self.meta.limit then
				buyLimit = 0
			else
				buyLimit = self.meta.limit - num
			end
		end
	end
	self.price = realPrice
	return realPrice, buyLimit, originalPrice


	-- if self.moneyType == 1 then -- 银币
	-- 	self.price = self.meta.coin -- 银币没有折扣和限购
	-- 	return self.price, -1, 0
	-- elseif self.moneyType == 2 then -- 金币
	-- 	if self.meta.discountQCash ~= 0 then
	-- 		if self.meta.limit == 0 then -- 折扣且不限购
	-- 			self.price = self.meta.discountQCash
	-- 			return self.price, -1, self.meta.qCash
	-- 		elseif num >= self.meta.limit then -- 折扣但限购数量用完了，不能买
	-- 			self.price = self.meta.discountQCash
	-- 			return self.price, 0, self.meta.qCash
	-- 		else
	-- 			self.price = self.meta.discountQCash
	-- 			return self.price, self.meta.limit - num, self.meta.qCash
	-- 		end
	-- 	else
	-- 		self.price = self.meta.qCash
	-- 		return self.price, -1, 0
	-- 	end
	-- else
	-- 	return 0
	-- end
end

-- static function
function BuyLogic:getDiscountPercentageForDisplay(original, discounted)
	local real = math.floor(100 * discounted / original)
	local level = 10 -- discount level: 95, 90, 85, 80
	local result = math.ceil(real / level) * level 
	if result % 10 == 0 then 
		if result == 100 then return 9 end
		return result / 10  -- 9 zhe, 8 zhe
	else
		return result -- 95 zhe, 85 zhe
	end
end

function BuyLogic:setCancelCallback(cancelCallback)
	self.cancelCallback = cancelCallback
end

function BuyLogic:start(num, successCallback, failCallback, load, price)
	-- 验证钱数
	if PrepackageUtil:isPreNoNetWork() and self.moneyType == 2 then
		PrepackageUtil:showInGameDialog()
		return 
	end
	
	local event = {}
	local money = self.user:getCash()
	if self.moneyType == 1 then money = self.user:getCoin() end
	self.num = num
	if price then self.price = price end
	print("self.price, self.num", self.price, self.num)
	if not self:energyLimitItem(self.goodsId) and money < self.price * self.num then
		local errorCode = nil
		if self.moneyType == 1 then 
			errorCode = 730321		-- 银币不够
		elseif self.moneyType == 2 then 
			errorCode = 730330 
		end		-- 金币不够
		if failCallback then failCallback(errorCode) end
		return
	end

	local list
	local function onSuccess(evt)
		evt.target:removeAllEventListeners()
		self:updatePropCount()
		if self.moneyType == 1 then
			DcUtil:logSilverCoinBuy(self.goodsId, self.price, self.num, self.user:getCoin(), self.levelId)
		elseif self.moneyType == 2 then
			DcUtil:logHappyCoinBuy(self.goodsId, self.price, self.num, self.user:getCash(), self.levelId)
		end
		if successCallback then
			successCallback(evt.data)
		end
	end
	local function onFail(evt)
		evt.target:removeAllEventListeners()
		if failCallback then
			failCallback(evt.data)
		end
	end
	local function onCancel(evt)
		evt.target:removeAllEventListeners()
		if self.cancelCallback then
			self.cancelCallback()
		end
	end
	if load ~= false then load = true end
	
	local http = BuyHttp.new(load)
	http:ad(Events.kComplete, onSuccess)
	http:ad(Events.kCancel, onCancel)
	http:ad(Events.kError, onFail)
	http:load(self.goodsId, self.num, self.moneyType, self.targetId)
end

function BuyLogic:energyLimitItem(goodsId)
	return goodsId == 70 
end

function BuyLogic:updatePropCount()
	print("BuyLogic:updatePropCount")
	local manager = UserManager:getInstance()
	local user = manager.user

	-- 扣钱
	if self.moneyType == 1 then
		local money = user:getCoin()
		money = money - self.price * self.num
		user:setCoin(money)
	elseif self.moneyType == 2 then
		local money = user:getCash()
		money = money - self.price * self.num
		user:setCash(money)
	end
	-- 加东西
	for __, v in ipairs(self.items) do
		if ItemType:isItemNeedToBeAdd(v.itemId) then
			manager:addUserPropNumber(v.itemId, v.num * self.num)
			DcUtil:logRewardItem("buy", v.itemId, v.num * self.num, self.levelId)
		elseif v.itemId == 2 then
			manager.user:setCoin(manager.user:getCoin() + v.num * self.num)
			HomeScene:sharedInstance():checkDataChange()
			HomeScene:sharedInstance().coinButton:updateView()
			DcUtil:logRewardItem("buy", v.itemId, v.num * self.num, self.levelId)
		end
	end
	-- 更新本日购买列表
	print("Update buyed list")
	local meta = MetaManager:getInstance():getGoodMeta(self.goodsId)
	if meta and meta.limit > 0 then
		UserManager:getInstance():addBuyedGoods(self.goodsId, self.num)
	end
end

function BuyLogic:itemsNotToBeAdded(itemId)
	local itemType = math.floor(itemId / 10000)
	print("itemType = ", itemType)
	if itemType == 1 then return false end
	return true
end