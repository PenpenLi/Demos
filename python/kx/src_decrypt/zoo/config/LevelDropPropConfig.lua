LevelDropPropConfig = class()

-- config "dragonBoatPropGen":[{"k":"10059","v":5},{"k":"10060","v":5},{"k":"10061","v":5},{"k":"10063","v":5}]
function LevelDropPropConfig:create(config)
 	local meta = LevelDropPropConfig.new()
 	meta:init(config)
 	return meta
end

function LevelDropPropConfig:ctor()
	self.totalWeight = 0
	self.propList = {}
end

function LevelDropPropConfig:init(config)
	if type(config) == "table" then
		local totalWeight = 0
		for _, prop in pairs(config) do
			totalWeight = totalWeight + tonumber(prop.v)
		end

		if totalWeight > 0 then
			for _, prop in pairs(config) do
				local weight = math.floor(tonumber(prop.v) / totalWeight * 10000)
				self.totalWeight = self.totalWeight + weight
				table.insert(self.propList, {propId = tonumber(prop.k), weight = weight})
			end
		end
	end
end

function LevelDropPropConfig:getTotalWeight()
	return self.totalWeight
end

function LevelDropPropConfig:getRandProp(random)
	if type(random) == "number" and random <= self.totalWeight then
		for _, prop in pairs(self.propList) do
			random = random - prop.weight
			if random <= 0 then
				return prop.propId
			end
		end
	end
	return nil
end