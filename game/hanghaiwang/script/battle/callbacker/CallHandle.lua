
require (BATTLE_CLASS_NAME.class)

local CallHandle = class("CallHandle")
 
	------------------ properties ----------------------
	CallHandle.selfPointer		= nil					-- this指针
	CallHandle.calller			= nil 					-- 回调函数
	CallHandle.leftTime			= nil					-- 剩余次数 
	CallHandle.foreverCall		= nil					-- 是否是永久回调
	CallHandle.released			= nil
	--CallHandle.data 			= nil					-- 回调数据
	------------------ functions -----------------------
	-- true 表示
	function CallHandle:ctor()
		ObjectTool.setProperties(self)
		self.foreverCall 		= false
		self.leftTime 			= 0
		self.released 			= false
	end
	
	function CallHandle:runHandle(target,data)
		-- --print("CallHandle:run selfPointer",self.selfPointer," call:",self.calller)
		-- --print("CallHandle:run")
		-- -- if self:canRemove() ~= false then
		-- -- 	--print("CallHandle:run->call")
			
		-- -- end
		-- --print("CallHandle:run->calller")
		-- --print("CallHandle:foreverCall:",self.foreverCall)
		-- --print("&&&&&&&&&&&&&&&  CallHandle call:",self.selfPointer:instanceName())
		self.calller(self.selfPointer,target,data)
		-- --print("CallHandle:self.calller(self.selfPointer,data)")

		--self.selfPointer[self.call](data)
		----print("CallHandle:handle leftTime:",self.leftTime)
		if self.foreverCall == false then 
			self.leftTime = self.leftTime - 1
			-- --print("CallHandle:handle leftTime:",self.leftTime)
		end
	end

	function CallHandle:canRemove()
		if self.foreverCall ~= true then 
			return self.leftTime <= 0
		end
		return false
	end
	function CallHandle:release()
		
		self.calller 			= nil
		self.data				= nil
		self.selfPointer		= nil
		self.leftTime			= 0
		self.released 			= true
	end

return CallHandle