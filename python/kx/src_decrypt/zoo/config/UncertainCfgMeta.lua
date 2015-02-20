UncertainCfgMeta = class()

function UncertainCfgMeta:ctor()
	
end

function UncertainCfgMeta:create( config )
	-- body
	local meta = UncertainCfgMeta.new()
	meta:init(config)
	return meta
end

function UncertainCfgMeta:init( config )
	-- body
	self.allItemList = {}
	self.canfallingItemList = {}
	local allItemPer = 0
	local allCanFallingItemPer = 0
	for k, v in pairs(config) do 
		-- print(v.k, v.v) debug.debug()
		local item = {}
		local value = v.k:split("_")
		item.changeType = tonumber(value[1])    --可以变的item的类型
		item.changeItem = tonumber(value[2])    --可以变得item 在tile中的值
		item.changePer = tonumber(v.v)            --权重
		table.insert(self.allItemList, item)
		allItemPer = allItemPer + item.changePer
		if item.changeType ~= UncertainCfgConst.kCannotFalling then
			allCanFallingItemPer = allCanFallingItemPer + item.changePer
			table.insert(self.canfallingItemList, item)
		end
	end

	local perlimit = 0
	local str = "allItemPer:"
	for k = 1, #self.allItemList do 
		local v = self.allItemList[k]
		local per = math.ceil(v.changePer/allItemPer * 100)
		perlimit = perlimit + per
		v.limitInAllItem = perlimit
		str = str.."|"..v.limitInAllItem
	end
	print(str)
	perlimit = 0 
	local str1 = "allCanFallingItemPer:"
	for k = 1, #self.canfallingItemList do 
		local v = self.canfallingItemList[k]
		local per = math.ceil(v.changePer/allCanFallingItemPer * 100)
		perlimit = perlimit + per
		v.limitInCanFallingItem = perlimit
		str1 = str1.."|"..v.limitInCanFallingItem
	end
	print(str1)
	
end