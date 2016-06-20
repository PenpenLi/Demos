

--运行function
local BAForCallClosureFunction = class("BAForCallClosureFunction",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	BAForCallClosureFunction.closureFunction 				= nil  
	BAForCallClosureFunction.args 							= nil
	------------------ functions -----------------------
 

	-- 运行函数
	function BAForCallClosureFunction:start(data)
		-- --print("BAForCallClosureFunction:start")
		if( self.closureFunction ) then
			self.closureFunction(args)
			self.closureFunction = nil
		end

		self:complete()
	end

	function BAForCallClosureFunction:release( ... )
		self.super.release(self)
		self.closureFunction = nil
	end
return BAForCallClosureFunction
