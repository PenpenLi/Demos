kGamePlayEvents = table.const {
	kPassLevel	= "gameplay.events.passlevel",
	kAreaOpenIdChange	= "gameplay.events.areaopenidchange",
	kTopLevelChange		= "gameplay.events.toplevelchange",
}

GamePlayEvents = {}

GamePlayEvents.removePassLevelEvent = function(func)
	GlobalEventDispatcher:getInstance():removeEventListener(kGamePlayEvents.kPassLevel, func)
end

GamePlayEvents.addPassLevelEvent = function(func, context) 
	-- print(">>>>>>>>>>>>> GamePlayEvents.addPassLevelEvent")
	GlobalEventDispatcher:getInstance():addEventListener(kGamePlayEvents.kPassLevel, func, context)
end

GamePlayEvents.dispatchPassLevelEvent = function(levelResult)
	-- print(">>>>>>>>>>>>> GamePlayEvents.dispatchPassLevelEvent:", table.tostring(levelResult))
	GlobalEventDispatcher:getInstance():dispatchEvent(Event.new(kGamePlayEvents.kPassLevel, levelResult))
end

GamePlayEvents.addTopLevelChangeEvent = function(func) 
	-- print(">>>>>>>>>>>>> GamePlayEvents.addTopLevelChangeEvent")
	GlobalEventDispatcher:getInstance():addEventListener(kGamePlayEvents.kTopLevelChange, func)
end

GamePlayEvents.dispatchTopLevelChangeEvent = function(topLevelId)
	-- print(">>>>>>>>>>>>> GamePlayEvents.dispatchTopLevelChangeEvent:", topLevelId)
	GlobalEventDispatcher:getInstance():dispatchEvent(Event.new(kGamePlayEvents.kTopLevelChange, topLevelId))
end

GamePlayEvents.addAreaOpenIdChangeEvent = function(func) 
	-- print(">>>>>>>>>>>>> GamePlayEvents.addAreaOpenIdChangeEvent")
	GlobalEventDispatcher:getInstance():addEventListener(kGamePlayEvents.kAreaOpenIdChange, func)
end

GamePlayEvents.dispatchAreaOpenIdChangeEvent = function(areaId) 
	-- print(">>>>>>>>>>>>> GamePlayEvents.dispatchAreaOpenIdChangeEvent")
	GlobalEventDispatcher:getInstance():dispatchEvent(Event.new(kGamePlayEvents.kAreaOpenIdChange, areaId))
end
