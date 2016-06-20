require (BATTLE_CLASS_NAME.class)

--- eventDispatcher,回调函数为closure,不支持对象回调

local function getEvtCallList( ... )
	local tb = require(BATTLE_CLASS_NAME.ClosureHandleArray).new()
	return tb
end 


local BaseEventDispatcher = class("BaseEventDispatcher")
 
	------------------ properties ----------------------
	BaseEventDispatcher.eventMap 			= nil -- 弱引用回调
	------------------ functions -----------------------
	
	function BaseEventDispatcher:ctor()
			 ObjectTool.setProperties(self)
			 self.eventMap 	= {}
			  
	end


	function BaseEventDispatcher:dispathcEvent(evtName,data)
		if(evtName == nil or self.eventMap == nil or self.eventMap[evtName] == nil) then
			return false
		end
		for callBack,v in pairs(self.eventMap[evtName] or {}) do
			self.eventMap[evtName]:runArray(data)
		end
	end


	function BaseEventDispatcher:addEventListener(evtName,listener,ctime)
		
		if(self.eventMap == nil) then
			self.eventMap = {}
		end

		if(evtName == nil or listener == nil) then
			return false
		end

		if(self.eventMap[evtName] == nil) then
			self.eventMap[evtName] = require(BATTLE_CLASS_NAME.ClosureHandleArray).new()
		end
		-- 把回调当做key传入,防止同一个函数多次调用
		-- self.eventMap[evtName][listener] = 1
		if(ctime == nil) then
			self.eventMap[evtName]:addForeverCall(listener)
		else
			if(tonumber(ctime) < 1) then ctime = 1 end
			self.eventMap[evtName]:addLimitTimeCall(listener,ctime)
		end
		return true
	end

	function BaseEventDispatcher:removeEventListener(evtName,listener)
		if(evtName == nil or listener == nil or self.eventMap == nil or
		   self.eventMap[evtName] == nil or self.eventMap[evtName][listener] ~= 1) then
			return false
		end
		self.eventMap[evtName][listener] = nil
		return true
	end

	function BaseEventDispatcher:removeAllEvent()
		self.eventMap = {}
	end

return BaseEventDispatcher