
WorldMapOptimizer = class()

local instance = nil
local screenHeight = 1280

function WorldMapOptimizer:getInstance()
	if not instance then 
		instance = WorldMapOptimizer.new()
		instance.viewMap = {}
		instance.operMap = {}
		instance.worldScene = nil
	end
	return instance
end

function WorldMapOptimizer:init(worldScene, ...)
	instance.worldScene = worldScene

	local visibleSize = CCDirector:sharedDirector():getVisibleSize()

	screenHeight = visibleSize.height
end

function WorldMapOptimizer:buildCache(view , type , ...)
	local viewY = view:getPositionY() - 360
	local screenID = math.ceil(viewY / screenHeight) 
	if screenID == 0 then
		screenID = 1
	end

	if not instance.viewMap[screenID] then
		instance.viewMap[screenID] = {}
	end

	table.insert( instance.viewMap[screenID] , view )

	if type == 2 and view.parent then
		view:setVisible(false)
	end
end

local function updateViews(currScreenID , isShow)
	if instance.viewMap and instance.viewMap[currScreenID] then
		local currViews = instance.viewMap[currScreenID]

		for k,v in pairs(currViews) do
			if v.parent and not v:isVisible() == isShow then
				v:setVisible(isShow)
			end
		end
	end

	if instance.operMap[currScreenID] then
		instance.operMap[currScreenID] = nil
	end
end

function WorldMapOptimizer:firstUpdate(...)
	
	local k,v
	local k2,v2

	for k,v in pairs(instance.viewMap) do
		if v and type(v) == "table" then
			for k2,v2 in pairs(v) do
				if v2 and v2.parent and v2:isVisible() then
					v2:setVisible(false)
				end
			end
		end
	end
	
	instance:update()
end

function WorldMapOptimizer:update(...)

	local offsetY = instance.worldScene.maskedLayer:getPositionY()
	offsetY = math.abs(offsetY) - 50 + (screenHeight / 2)
	local currScreenID = math.ceil( offsetY / screenHeight )
	if currScreenID == 0 then 
		currScreenID = 1
	end

	if instance.operMap[currScreenID] 
		and instance.operMap[currScreenID - 1] 
		and instance.operMap[currScreenID + 1] 
		then

		return

	end


	updateViews(currScreenID , true)
	updateViews(currScreenID - 1 , true)
	updateViews(currScreenID + 1 , true)

	for k,v in pairs(instance.operMap) do
		if v then
			updateViews(k , false)
		end
	end

	instance.operMap = {}
	instance.operMap[currScreenID] = true
	instance.operMap[currScreenID - 1] = true
	instance.operMap[currScreenID + 1] = true

end


