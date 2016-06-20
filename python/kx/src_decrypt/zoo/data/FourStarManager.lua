FourStarManager = class()
local instance
function FourStarManager:getInstance( ... )
	-- body
	if not instance then
		instance = FourStarManager.new()
		instance:init()
	end
	return instance
end

function FourStarManager:init( ... )
	-- body
	self:readConfig()
end

function FourStarManager:getMyMainStar( ... )
	-- body
	return UserManager.getInstance().user:getStar()
end

function FourStarManager:getMaxMainStar( ... )
	-- body
	return UserManager:getInstance():getFullStarInOpenedRegion()
end

function FourStarManager:getMaxHideStar( ... )
	-- body
	return MetaModel.sharedInstance():getFullStarInOpenedHiddenRegion()
end

function FourStarManager:getMyHideStar( ... )
	-- body
	return  UserManager.getInstance().user:getHideStar()
end


function FourStarManager:getAllFourStarLevels( ... )
	-- body
	local list = {}
	for level = 1, kMaxLevels do 
		local targetScores =  MetaModel.sharedInstance():getLevelTargetScores(level)
		if targetScores and #targetScores > 3 and targetScores[4] > 0 then
			local data = {}
			data.level = level
			table.insert(list, data)
		end
	end

	return list
end

function FourStarManager:getAllNotToFourStarLevels( ... )
	-- body
	local list = {}
	for level = 1, kMaxLevels do 
		local targetScores =  MetaModel.sharedInstance():getLevelTargetScores(level)
		if targetScores and #targetScores > 3 and targetScores[4] > 0  then
			local star = 0
			local score = UserManager.getInstance():getUserScore(level)
			if score then
				star = score.star
			end
			local data = {}
			data.level = level
			data.star = star
			if star < 4 then
				table.insert(list, data)
			end
		end
	end
	return list
end


function FourStarManager:getFourStarLevels( ... )
	-- body
	local list = {}
	for level = 1, kMaxLevels do 
		local targetScores =  MetaModel.sharedInstance():getLevelTargetScores(level)
		if targetScores and #targetScores > 3 and targetScores[4] > 0  then
			local star = 0
			local score = UserManager.getInstance():getUserScore(level)
			if score then
				star = score.star
			end
			local data = {}
			data.level = level
			data.star = star
			table.insert(list, data)
		end
	end
	return list
end


-- 所有未满级的隐藏关
function FourStarManager:getAllNotPerfectHiddenLevels(...)
	local hiddenNodeStart = 10001
	local hiddenNodeEnd = 19999

	local list = {}
	for level = hiddenNodeStart, kMaxHiddenLevel do 
		-- print("===========> prepare to get ",level)
		local targetScores =  MetaModel.sharedInstance():getLevelTargetScores(level)
		if targetScores then
			local star = 0
			local score = UserManager.getInstance():getUserScore(level)
			if score then
				star = score.star
			end
			local data = {}
			data.level = level
			data.star = star
			if star < 3 then
				table.insert(list, data)
			end
		end
	end
	return list
end

function FourStarManager:getAllHiddenLevels(...)
	local hiddenNodeStart = 10001
	local hiddenNodeEnd = 19999

	local list = {}
	for level = hiddenNodeStart, kMaxHiddenLevel do 
		-- print("===========> prepare to get ",level)
		local targetScores =  MetaModel.sharedInstance():getLevelTargetScores(level)
		if targetScores then
			local star = 0
			local score = UserManager.getInstance():getUserScore(level)
			if score then
				star = score.star
			end
			local data = {}
			data.level = level
			data.star = star
			table.insert(list, data)
		end
	end
	return list
end


function FourStarManager:isFourStarLevel( level )
	-- body
	local targetScores = MetaModel.sharedInstance():getLevelTargetScores(level)
	if targetScores and #targetScores > 3 and targetScores[4] > 0 then
		return true
	end
	return false
end

function FourStarManager:isGetFourStarInLevel( level )
	-- body
	local score = UserManager.getInstance():getUserScore(level)
	if score and score.star > 3 then
		return true
	end
	return false
end

function FourStarManager:writeConfig( ... )
	-- body
	local filePath = HeResPathUtils:getUserDataPath().."/four_star_guide"
	local file = io.open(filePath, "w")
	if file then
		file:write(table.serialize(self.config or {}))
		file:close()
	end
end

function FourStarManager:readConfig( ... )
	-- body
	local filePath = HeResPathUtils:getUserDataPath().."/four_star_guide"
	if not self.config then
		local file = io.open(filePath, "r")
		if file then
			local data = file:read("*a")
			file:close()
			if data then
				self.config = table.deserialize(data) or {}
			else
				self.config = {}
			end
		else
			self.config = {}
		end
	end
end

function FourStarManager:isTimeToShowGuide( level )
	-- body
	local time_now = os.time()
	local time_last
	for k, v in ipairs(self.config) do
		if v.level == level then
			if time_now - v.time >= 60 * 60 * 24 then
				v.time = time_now
				self:writeConfig()
				return true
			else
				return false
			end
		end

	end

	local data = {level = level, time = time_now}
	table.insert(self.config, data)
	self:writeConfig()
	return true
end

function FourStarManager:getLadyBugAnimationType( level, star )
	-- body
	local function randomFourstarLevel( minLevel, maxLevel )
		-- body
		local list = {}
		for k = minLevel, maxLevel do 
			if self:isFourStarLevel(k) and not self:isGetFourStarInLevel(k) then
				table.insert(list, k)
			end
		end

		if #list > 0 then
			return LadyBugFourStarAnimationType.kWithBtn, list[math.random(1, #list)]
		end
	end

	if self:isFourStarLevel(level) then
		if star and star == 4 then
			local topLevel = UserManager.getInstance().user:getTopLevelId()
			local _type, _level
			if level < topLevel then
				 _type, _level = randomFourstarLevel(level + 1, topLevel)
				if _type then 
					return _type, _level
				end
			end

			_type, _level = randomFourstarLevel(1, level - 1)
			if _type then 
				return _type, _level
			end

			for k = topLevel, kMaxLevels do 
				if self:isFourStarLevel(k) then
					return LadyBugFourStarAnimationType.kWithoutBtn, k
				end
			end
		elseif self:isGetFourStarInLevel(level) then
			return nil
		elseif self:isTimeToShowGuide(level) then
			return LadyBugFourStarAnimationType.kWithoutBtn
		end
	else
		return nil
	end
end