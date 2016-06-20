

require (BATTLE_CLASS_NAME.class)
local BACall = class("BACall",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	BACall.callback 					= nil 	-- 总延迟

	------------------ functions -----------------------

	function BACall:ctor(...)
		self.super.ctor(self,...)
		local callback = ...
 		-- print("BACall:",callback)
		self.callback = callback
	end
 
	-- 运行函数
	function BACall:start()
		 if(self.callback) then
		 	self.callback()
		 end
	end

	function BACall:release( ... )
		self.callback = nil
	end

return BACall