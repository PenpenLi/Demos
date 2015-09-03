
IconButtonManager = class()

local instance = nil
local function getDayStartTimeByTS(ts)
	local utc8TimeOffset = 57600 -- (24 - 8) * 3600
	local oneDaySeconds = 86400 -- 24 * 3600
	return ts - ((ts - utc8TimeOffset) % oneDaySeconds)
end

function IconButtonManager:getInstance( ... )
	if not instance then 
		instance = IconButtonManager.new()
		instance:init()
	end

	return instance
end

function IconButtonManager:ctor( ... )
	self.playTipIcons = {}
	self.clickReplaceScene = false
end

function IconButtonManager:init( ... )
	local function removeTips( ... )
		local icons = {}
		for _,v in pairs(self.playTipIcons) do
			if v.playTipPriority == self.playTipIcons[1].playTipPriority and not self:isActivityButton(v) then
				table.insert(icons,v)
			end
		end

		for _,v in pairs(icons) do
			self:removePlayTipIcon(v)
		end
	end

	local eventNode = CocosObject:create()
	HomeScene:sharedInstance():addChild(eventNode)
	eventNode:addEventListener(Events.kRemoveFromStage,function( ... )
		if not self.clickReplaceScene then
			removeTips()
		end
		self.clickReplaceScene = false
	end)

	HomeScene:sharedInstance():addEventListener(SceneEvents.kEnterForeground,function( ... )
		if not HomeScene:sharedInstance().exitDialog then 
			removeTips()
		end
	end)

end

local configPath = HeResPathUtils:getUserDataPath() .. "/IconButtonManager" 

local function readConfig( ... )
	local file = io.open(configPath, "r")
	if file then
		local data = file:read("*a") 
		file:close()
		if data then
			return table.deserialize(data) or {}
		end
	end
	return {}
end
local function writeConfig( data )
	local file = io.open(configPath,"w")
	if file then 
		file:write(table.serialize(data or {}))
		file:close()
	end
end

local function now( ... )
	return os.time() + (__g_utcDiffSeconds or 0)
end

function IconButtonManager:todayIsShow( icon )
	if icon:is(MessageButton) then 
		return false
	end

	local config = readConfig()

	if not config[icon.id] then 
		return false
	end

	if IconButtonManager:getInstance():isActivityButton(icon) then 
		if icon.tips and icon.tips ~= config[icon.id].tips then 
			return false
		end
	end

	local lastShowTime = getDayStartTimeByTS(config[icon.id].time or 0)
	local todayTime = getDayStartTimeByTS(now())
	return lastShowTime >= todayTime
end

function IconButtonManager:clearShowTime( icon )

	local config = readConfig()

	if not config[icon.id] then 
		config[icon.id] = {}
	end

	config[icon.id].time = 0

	writeConfig(config)
end

function IconButtonManager:writeShowTime( icon )
	if icon:is(MessageButton) then 
		return
	end

	local config = readConfig()

	if not config[icon.id] then 
		config[icon.id] = {}
	end
	if IconButtonManager:getInstance():isActivityButton(icon) then 
		if icon.tips then 
			config[icon.id].tips = icon.tips
		end	
	end

	config[icon.id].time = now()
	writeConfig(config)
end

function IconButtonManager:isActivityButton( icon )
	return icon:is(ActivityIconButton) or icon:is(ActivityButton)
end


function IconButtonManager:playHasNotificationAnim( ... )
	for _,v in pairs(self.playTipIcons) do
		IconButtonBase.stopHasNotificationAnim(v)
	end

	for i,v in ipairs(self.playTipIcons) do
		if v.playTipPriority > self.playTipIcons[1].playTipPriority then 
			v:playOnlyIconAnim()
			self:clearShowTime(v)
		else
			IconButtonBase.playHasNotificationAnim(v)
			
			if not IconButtonManager:getInstance():isActivityButton(v) then 
				self:writeShowTime(v)
			end
		end
	end
end

function IconButtonManager:addPlayTipIcon( icon )
	if not table.exist(self.playTipIcons,icon) then
		if self:todayIsShow(icon) then 
			return
		end

		table.insert(self.playTipIcons,icon)
		table.sort(self.playTipIcons,function(a,b) return a.playTipPriority < b.playTipPriority end)

		local eventNode = CocosObject:create()
		icon:addChild(eventNode)
		eventNode:addEventListener(Events.kDispose,function( ... )
			self:removePlayTipIcon(icon)
		end)
	end
	
	self:playHasNotificationAnim()
	print("addPlayTipIcon " .. icon.id)
end

function IconButtonManager:removePlayTipIcon( icon )
	if not table.exist(self.playTipIcons,icon) then 
		return
	end

	table.removeValue(self.playTipIcons,icon)
	IconButtonBase.stopHasNotificationAnim(icon)

	self:playHasNotificationAnim()

	print("removePlayTipIcon " .. icon.id)
	-- print(debug.traceback())
end

function IconButtonManager:writeShowTimeInQueue( icon )
	if not table.exist(self.playTipIcons, icon) then
		return
	end
	self:writeShowTime(icon)
end

function IconButtonManager:getButtonTodayShowById(buttonId)
	local config = readConfig()

	if not config[buttonId] then 
		return false
	end
	
	if not config[buttonId].time or config[buttonId].time == 0 then 
		config[buttonId].time = now()
		writeConfig(config)
	end
	
	local lastShowTime = getDayStartTimeByTS(config[buttonId].time)
	local todayTime = getDayStartTimeByTS(now())

	return lastShowTime >= todayTime
end