-------------------------------------------------------------------------------
-- Prints logging information to console
--
-- @author Thiago Costa Ponte (thiago@ideais.com.br)
--
-- @copyright 2004-2013 Kepler Project
--
-------------------------------------------------------------------------------

local logging = require "script/libs/logging"

function logging.console(logPattern)
	return logging.new( function(self, level, message)
		local msg = logging.prepareLogMsg(logPattern, os.date("*t"), level, message)
		
		if (g_system_type == kBT_PLATFORM_ANDROID) then 
			print(msg)
		else 
			io.stdout:write(msg)
		end 
		
		if (level == "fatal") then
			CCMessageBox(msg, "FATAL")
		end
		return true
	end)
end

return logging.console
