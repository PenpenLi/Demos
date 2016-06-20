
-- 用于 BSTree(行为选择树) 内部结束回调的节点
-- blackBoard.treeComplete 为回调函数
require (BATTLE_CLASS_NAME.class)
local BAForRepeatCall = class("BAForRepeatCall",require(BATTLE_CLASS_NAME.BaseAction))
 	
	------------------ properties ----------------------
	BAForRepeatCall.repeatFunction 		= nil 		-- 
	BAForRepeatCall.total				= nil
	BAForRepeatCall.current 			= nil 		
	------------------ functions -----------------------
 	
 	function BAForRepeatCall:start()

		if(self.repeatFunction ~= nil and self.total > 0) then 
		 	self.current = 0
		 	self:addToRender()
		else	
			self:complete()
		end
		
	end

	function BAForRepeatCall:update( dt )
		self.current = self.current + 1
		if(self.repeatFunction) then
			self.repeatFunction()
		end
		if(self.current >= self.total) then
			self:complete()
			self:release()
		end
	end

	function BAForRepeatCall:release( ... )
		self.super.release(self)
		self.repeatFunction = nil
		self.total 			= 0
	end

return BAForRepeatCall