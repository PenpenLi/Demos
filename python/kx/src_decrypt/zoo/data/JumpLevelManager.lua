local function debug_log(arg)
    print(arg)
    if not _G.isLocalDevelopMode then return end
    local filename = HeResPathUtils:getUserDataPath() .. '/debug_log'
    local file = io.open(filename,"a+")
    if file then 
        file:write(arg)
        file:write('\n')
        file:close()
    end
end

JumpLevelManager = class()

local _instance = nil
function JumpLevelManager:getInstance( ... )
	-- body
	if not _instance then
		_instance = JumpLevelManager.new()
	end
	return _instance
end

function JumpLevelManager:ctor( ... )
	-- body
end

function JumpLevelManager:getLowestJumpableLevel()
    return 40
end

function JumpLevelManager:shouldShowFakeIcon(levelId)
    return levelId >= 31 and levelId <= 39
end

--是否可以跳关，此关为toplevel
function JumpLevelManager:shouldShowJumpLevelIcon( levelId )
	debug_log('shouldShowJumpLevelIcon 0')
	if not MaintenanceManager:getInstance():isEnabled("JumpLevel") then
		debug_log('shouldShowJumpLevelIcon 1')
		return false
	end

	if not levelId then 
		debug_log('shouldShowJumpLevelIcon 2')
		return false 
	end
	local topLevel = UserManager.getInstance():getUserRef():getTopLevelId()
	if levelId ~= topLevel then 
		debug_log('shouldShowJumpLevelIcon 3')
		return false 
	end

    local score = UserManager.getInstance():getUserScore(levelId)
    if score and score.star > 0 then
        debug_log('shouldShowJumpLevelIcon 7')
        return false
    end

	if FUUUManager:getLevelContinuousFailNum(levelId) < MetaManager.getInstance():getFailLevelNumToShowJump() then 
		debug_log('shouldShowJumpLevelIcon 4')
		return false
	end

	if self:getJumpLevelCost(levelId) == 0 and not JumpLevelManager:shouldShowFakeIcon(levelId) then 
		debug_log('shouldShowJumpLevelIcon 5')
		return false
	end

    if self:hasJumpedLevel(levelId) then
        debug_log('shouldShowJumpLevelIcon 6')
        return false
    end

	return true
end

--金豆荚是否足够跳过level
function JumpLevelManager:isEnoughForJumpLevel( levelId )
	-- body
	local spend = self:getJumpLevelCost(levelId)
	local own = self:getOwndIngredientNum()
	if own >= spend then
		return true
	else
		return false
	end

end

--金豆荚拥有个数
function JumpLevelManager:getOwndIngredientNum( )
	-- body
	local prop = UserManager.getInstance():getUserProp(ItemType.INGREDIENT)
	local own = prop and prop.num or 0
	return own
end

--跳过关卡需要的道具数量
function JumpLevelManager:getJumpLevelCost( levelId )
	-- body
	if LevelType:isMainLevel(levelId) then
		local reward = MetaManager.getInstance():getLevelRewardByLevelId(levelId)
		if reward then
			return reward:getSkipLevelSpend() or 0
		end
	end
	return 0
end

--跳关的所有关卡scoreRef列表
function JumpLevelManager:getJumpedLevels( )
    local ret = {}
    local maxNormalLevel = MetaManager:getInstance():getMaxNormalLevelByLevelArea()
    for k, v in pairs(UserManager.getInstance():getJumpLevelInfo()) do
        if v.levelId <= maxNormalLevel then
            table.insert(ret, v)
        end
    end
	return ret
end

function JumpLevelManager:getLevelPawnNum( levelId )
	-- body
	local ref = UserManager.getInstance():getUserJumpLevelRef(levelId)
	if ref and ref.pawnNum then
		return ref.pawnNum
	else
		return 0
	end
end

function JumpLevelManager:hasJumpedLevel( levelId )
	return self:getLevelPawnNum(levelId) > 0
end

function JumpLevelManager:getMoreIngredientLevels()
	local function isIngredientLevel(levelId)
        local level_rewards = MetaManager:getInstance():getLevelRewardByLevelId(levelId)
        for k, v in pairs(level_rewards.threeStarReward) do
            if v.itemId == ItemType.INGREDIENT then
                return true
            end
        end
        return false
    end
    local maxNormalLevel = MetaManager:getInstance():getMaxNormalLevelByLevelArea()
    local levels = {}
    local scores = UserManager:getInstance():getScoreRef()
    for k, v in pairs(scores) do
        if v.star > 0 and v.star < 3 and LevelType:isMainLevel(v.levelId) and v.levelId <= maxNormalLevel and isIngredientLevel(v.levelId) then
            table.insert(levels, v)
        end
    end
    return levels
end