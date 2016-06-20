


require (BATTLE_CLASS_NAME.class)

local ClosureHandle = class("ClosureHandle")
 
	------------------ properties ----------------------
	ClosureHandle.calller			= nil 					-- 回调函数
	ClosureHandle.leftTime			= nil					-- 剩余次数 
	ClosureHandle.foreverCall		= nil					-- 是否是永久回调
	ClosureHandle.released			= nil
	------------------ functions -----------------------
	-- true 表示
	function ClosureHandle:ctor()
		ObjectTool.setProperties(self)
		self.foreverCall 		= false
		self.leftTime 			= 0
		self.released 			= false
	end
	
	function ClosureHandle:runHandle(data)
		self.calller(target,data)
		if self.foreverCall == false then 
			self.leftTime = self.leftTime - 1
		end
	end

	function ClosureHandle:canRemove()
		if self.foreverCall ~= true then 
			return self.leftTime <= 0
		end
		return false
	end
	function ClosureHandle:release()
		
		self.calller 			= nil
		self.data				= nil
		self.leftTime			= 0
		self.released 			= true
	end

return ClosureHandle