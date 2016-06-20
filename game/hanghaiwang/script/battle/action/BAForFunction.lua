--运行function

local BAForFunction = class("BAForFunction",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	BAForFunction.caller 							= nil  
	BAForFunction.target 							= nil
	------------------ functions -----------------------
 

	-- 运行函数
	function BAForFunction:start(data)
		-- --print("BAForFunction:start")
		if( self.caller ) then
			self.caller(target,data)
			self.caller = nil
			self:complete()
		else
			--print("BAForFunction:start function nil")
		end

	end
return BAForFunction