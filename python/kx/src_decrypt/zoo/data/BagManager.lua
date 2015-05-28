local INIT_BAG_SIZE = 18
local ADDITIONAL_SIZE_PER_BUY = 0 -- not implemented

local STACK_SIZE = 100

BagManager = class()

local instance = nil 

local valideIds = {
	[ItemType.INGAME_REFRESH]  			= true, 
	[ItemType.INGAME_BACK] 				= true, 
	[ItemType.INGAME_SWAP] 				= true, 
	[ItemType.ADD_FIVE_STEP] 			= true, 
	[ItemType.INGAME_BRUSH] 			= true, 
	[ItemType.INGAME_HAMMER] 			= true, 
	[ItemType.INGREDIENT] 				= true, 
	[ItemType.SMALL_ENERGY_BOTTLE] 		= true, 
	[ItemType.MIDDLE_ENERGY_BOTTLE] 	= true, 
	[ItemType.LARGE_ENERGY_BOTTLE] 		= true, 
	[ItemType.INFINITE_ENERGY_BOTTLE] 	= true, 
	[ItemType.RABBIT_MISSILE]			= true,
	[ItemType.HOURGLASS]				= true,
	[ItemType.OCTOPUS_FORBID]			= true,
	[ItemType.RANDOM_BIRD]				= true,
	[ItemType.BROOM]					= true,
}


function BagManager:isValideItemId(id)
	if valideIds[id] then 
		return true
	else 
		return false
	end
end


function BagManager:getInstance()
	if instance then return instance end
	instance = BagManager.new()
	return instance
end

function BagManager:ctor()
	INIT_BAG_SIZE = MetaManager.getInstance():getInitBagSize()
	-- INIT_BAG_SIZE = 20
	ADDITIONAL_SIZE_PER_BUY = 0 -- not implemented

	STACK_SIZE = MetaManager.getInstance():getBagCapacity()
end

function BagManager:getUserBagData()
	return self:prepDataForBag(UserManager:getInstance().props, UserManager:getInstance():getAndUpdateTimeProps())
end

function BagManager:getUsedBoxCount()
	local um = UserManager:getInstance()
	local props = um:getPropRef()
	local usedCount = 0
	local stackSize = self:getStackSize()

	for k, v in pairs(props) do 
		usedCount = usedCount + math.ceil(v.num / stackSize)
	end
	if um.timeProps then
		for k, v in pairs(um.timeProps) do 
			usedCount = usedCount + math.ceil(v.num / stackSize)
		end
	end
	return usedCount
end

function BagManager:getEmptyBoxCount()
	

	return self:getUserBagSize() - self:getUsedBoxCount()
end

function BagManager:getUserBagSize()
	-------------------------------------------------------------------------
	-- ATTENTION: USE THIS CODE BLOCK WHEN 'UNLOCK' AND OTHER FUNCTIONS ARE
	-- IMPLEMENTED.
	-------------------------------------------------------------------------
	-- local um = UserManager:getInstance()
	-- local buyCount = um:getBagRef().buyCount
	-- local inviteSize = um:getBagRef().friendSize

	-- return INIT_BAG_SIZE + ADDITIONAL_SIZE_PER_BUY * buyCount + inviteSize

	-------------------------------------------------------------------------
	-- CURRENTLY: SHOW AS MANY ITEMS AS THE USER HAS.
	-- TO BE REPLACED BY THE CODE ABOVE.
	-------------------------------------------------------------------------
	local numOfPages = math.ceil(self:getUsedBoxCount() / INIT_BAG_SIZE)
	if numOfPages == 0 then numOfPages = 1 end
	return  numOfPages * INIT_BAG_SIZE

end

function BagManager:getStackSize()
	return STACK_SIZE
end

function BagManager:setStackSize()
 -- not implemented
end

-- return a copy of sorted table
function BagManager:sortByIdAsc(items)

	local function __less(item1,item2)
		return item1.itemId < item2.itemId
	end

	table.sort(items, __less)
	return items

	-- local function swap(item1, item2)
	-- 	return item2, item1
	-- end

	-- local count = #items
	-- for i=1, count-1 do 
	-- 	for j=1, count-i do 
	-- 		if tonumber(items[j].itemId) > tonumber(items[j+1].itemId) then
	-- 			items[j], items[j+1] = swap(items[j], items[j+1])
	-- 		end
	-- 	end
	-- end
	-- return items

end

-- split props into small stacks
function BagManager:prepDataForBag(userProps, expireProps)
	assert(userProps)

	local dest = {}
	local stackSize = self:getStackSize()

	local function splitPropToStacks(v, copyFunc)
		assert(copyFunc)
		local quantity = v.num
		local itemId = v.itemId
		local realItemId = v.itemId
		if v.expireTime and v.expireTime > 0 then realItemId = ItemType:getRealIdByTimePropId(v.itemId) end
		-------------------------------------
		-- ignore bad IDs
		-- if itemId <= 10000 
		-- 	or (itemId >=10016 and itemId <= 10017)
		-- 	or (itemId >= 10020 and itemId <= 10024) 
		-- 	or itemId == 10028 
		-- 	or (itemId >= 10030 and itemId ~= 10039)
		-- then
		-- 	-- no good...
		-- 	-- Lua has no continue !!!

		-- if self:isValideItemId(itemId) then
		if realItemId ~= 10047 and realItemId ~= 10048 and realItemId ~= 10049 and realItemId ~= 10050 and realItemId ~= 10051 then
			while quantity >= stackSize do 

				local tmp1 = copyFunc(v)
				tmp1.num = stackSize
				table.insert(dest, tmp1)
				quantity = quantity - stackSize
			end

			if quantity > 0 then

				local tmp2 = copyFunc(v)
				tmp2.num = quantity
				table.insert(dest, tmp2)
			end
			
		end
	end

	--限时道具优先显示
	table.sort(expireProps, function(a, b)
		if a.itemId == b.itemId then
			return a.expireTime < b.expireTime
		else
			return a.itemId < b.itemId
		end
	end)
	for _,v in pairs(expireProps) do
		splitPropToStacks(v, function(src) 
			local normalItemId = ItemType:getRealIdByTimePropId(src.itemId)
			return {itemId = normalItemId, timePropId = src.itemId, expireTime = src.expireTime } 
			end)
	end

	local sort = self:sortByIdAsc(userProps)
	for k, v in pairs(sort) do
		splitPropToStacks(v, function(src) 
			return {itemId = src.itemId} 
			end)
	end

	local filtered = {}
	local bagSize = self:getUserBagSize()
	for i=0, bagSize do 
		if dest[i] ~= nil then 
			table.insert(filtered, dest[i])
		end
	end
	return filtered
end

function BagManager:isItemExist(itemId, quantity)
	quantity = quantity or 1
	local props = UserManager:getInstance().props

	for k, v in pairs(props) do 

		if v.itemId == itemId then
			if v.num >= quantity then
				return true, v
			else
				return false, nil
			end
		end
	end

	return false, nil
end

function BagManager:canAddItem(itemId, quantity)
	local props = UserManager:getInstance().props
	local found = nil
	local stackSize = self:getStackSize()

	for k, v in pairs(props) do 

		if v.itemId == itemId then
			found = v
			break
		end
	end

	if found ~= nil then 
		local old = math.ceil(found.num / stackSize)
		local new = math.ceil((found.num + quantity) / stackSize)
		return self:getUsedBoxCount() - old + new <= self:getEmptyBoxCount()
	else
		local need = math.ceil(quantity / stackSize)
		return need <= self:getEmptyBoxCount()
	end
end

function BagManager:canAddItemTable(items)
	local props = table.clone(UserManager:getInstance().props, true)
	local stackSize = self:getStackSize()

	for k1, v1 in pairs(items) do
		for k2, v2 in pairs(props) do
			if v1.itemId == v2.itemId then 
				v2.num = v2.num + v1.num
			end
		end
	end

	local used = 0

	for k, v in pairs(props) do
		used = used + math.ceil(v.num / stackSize)
	end

	return used <= self:getUserBagSize()
end

function BagManager:buyUnlock(callback)
	local unlock1GoodsId = 11 -- first time buying unlock
	local unlock2GoodsId = 12 -- second time
	local unlock3GoodsId = 13
	local unlock4GoodsId = 14

	local goodsId = unlock1GoodsId

	local buyCount = UserManager:getInstance():getBagRef().buyCount

	if buyCount == 0 then -- first time buying unlock
		goodsId = unlock1GoodsId 
	elseif buyCount == 1 then	-- second time 
		goodsId = unlock2GoodsId
	elseif buyCount == 2 then
		goodsId = unlock3GoodsId
	elseif buyCount == 3 then
		goodsId = unlock4GoodsId
	end

	local function onSuccess(event)
		print 'buy unlock SUCCESS'
		UserManager:getInstance():addBagBuyCountByOne()
		if callback then callback(true, event) end
	end

	local function onFail(event)
		print 'buy unlock FAILED'
		-- print(table.tostring(event))
		if callback then callback(false, event) end
	end

	local moneyType = 2
	local bl = BuyLogic:create(goodsId, moneyType)
	local price = bl:getPrice()
	local amount = 1
	local showLoadingAnime = true
	bl:start(amount, onSuccess, onFail, showLoadingAnime, price)


end	