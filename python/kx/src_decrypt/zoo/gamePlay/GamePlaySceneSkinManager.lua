GamePlaySceneSkinManager = {}

GamePlaySceneSkinConfig = {
	[GameLevelType.kMayDay] = {
		gameBG = "game_bg_activity.png",
		topLeftLeaves = "leftLeaves",
		topRightLeaves = "rightLeaves",
		ladybugAnimation = "ladybug",
		propsListView = "props_animations",
		moveOrTimeCounter = "moveOrTimeCounter",
		levelTargets = "ingame_level_targets",
		markPanelSkin = "MarkPanel",
	},
	[GameLevelType.kSummerWeekly] = {
		gameBG = "game_bg.png",
		topLeftLeaves = "leftLeaves",
		topRightLeaves = "rightLeaves",
		ladybugAnimation = "ladybug",
		propsListView = "props_animations",
		moveOrTimeCounter = "moveOrTimeCounter_weekly",
		levelTargets = "ingame_level_targets_weekly",
		markPanelSkin = "MarkPanel",
	},
}

local defaultConfig = {
	gameBG = "game_bg.png",
	topLeftLeaves = "leftLeaves",
	topRightLeaves = "rightLeaves",
	ladybugAnimation = "ladybug",
	propsListView = "props_animations",
	moveOrTimeCounter = "moveOrTimeCounter",
	levelTargets = "ingame_level_targets",
	markPanelSkin = "MarkPanel",
}

local defaultConfig_spring_day = {
	gameBG = "game_bg.png",
	topLeftLeaves = "leftLeaves_spring_day",
	topRightLeaves = "rightLeaves_spring_day",
	ladybugAnimation = "ladybug_spring_day",
	propsListView = "props_animations",
	moveOrTimeCounter = "moveOrTimeCounter_weekly",
	levelTargets = "ingame_level_targets_weekly",
	markPanelSkin = "MarkPanel_spring",
}

local defaultConfig_spring_night = {
	gameBG = "game_bg.png",
	topLeftLeaves = "leftLeaves_spring_night",
	topRightLeaves = "rightLeaves_spring_night",
	ladybugAnimation = "ladybug_spring_night",
	propsListView = "props_animations",
	moveOrTimeCounter = "moveOrTimeCounter_weekly",
	levelTargets = "ingame_level_targets_weekly",
	markPanelSkin = "MarkPanel_spring",
}

local anniversaryTwoYearsConfig = {
	gameBG = "game_bg_AnniversaryTwoYears.png",
	topLeftLeaves = "leftLeaves",
	topRightLeaves = "rightLeaves",
	ladybugAnimation = "ladybug",
	propsListView = "props_animations",
	moveOrTimeCounter = "moveOrTimeCounter",
	levelTargets = "ingame_level_targets",
	markPanelSkin = "MarkPanel_AnniversaryTwoYears",
}
--[[
GameLevelType = {
	kQixi 			= 1,
	kMainLevel 		= 2,
	kHiddenLevel 	= 3,
	kDigWeekly		= 4,
	kMayDay			= 5,
	kRabbitWeekly	= 6,
	kTaskForRecall  = 8,
	kTaskForUnlockArea = 9,
	kSummerWeekly 	= 10,
}
]]

local function copyTab(st)  
    local tab = {}  
    for k, v in pairs(st or {}) do  
        if type(v) ~= "table" then  
            tab[k] = v  
        else  
            tab[k] = copyTab(v)  
        end  
    end  
    return tab  
end  

function GamePlaySceneSkinManager:initCurrLevel(levelType)
	self.levelType = levelType
end

function GamePlaySceneSkinManager:getCurrLevelType()
	return self.levelType
end

function GamePlaySceneSkinManager:isHalloweenLevel()
	if self.levelType == GameLevelType.kMayDay then
		return true
	end
	return false
end

function GamePlaySceneSkinManager:getConfig(levelType)
	local config = GamePlaySceneSkinConfig[levelType]

	if not config then
		if WorldSceneShowManager:getInstance():isInAcitivtyTime() then 
			local showType = WorldSceneShowManager:getInstance():getShowType()
			if showType == 1 then 
				local plistPath = "materials/springDay/game_bg.plist"
				if __use_small_res then  
					plistPath = table.concat(plistPath:split("."),"@2x.")
				end
				CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(plistPath)
				CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(plistPath)
				config = defaultConfig_spring_day
			else
				local plistPath = "materials/springNight/game_bg.plist"
				if __use_small_res then  
					plistPath = table.concat(plistPath:split("."),"@2x.")
				end
				CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(plistPath)
				CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(plistPath)
				config = defaultConfig_spring_night
			end
		else
			config = defaultConfig
			--config = anniversaryTwoYearsConfig

			if UserManager:getInstance().user:getTopLevelId() < 20 or not MaintenanceManager:getInstance():isEnabled("Background") then
				config.gameBG = "game_bg.png"
			end
		end
	end

	local tab = copyTab(config)

	return tab
end

function GamePlaySceneSkinManager:getMarkPanelSkin()
	return defaultConfig.markPanelSkin
	-- return anniversaryTwoYearsConfig.markPanelSkin
end