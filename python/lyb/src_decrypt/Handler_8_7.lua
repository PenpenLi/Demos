-- return roll

Handler_8_7=class(MacroCommand);
 
function Handler_8_7:ctor()
	self.class=Handler_8_7;
end

function Handler_8_7:execute()

	-- refresh data
	local rollCount = recvTable["Count"]

	-- refresh ui
	local xunbaoMediator = self:retrieveMediator(XunbaoMediator.name);  
	if xunbaoMediator then
		xunbaoMediator:refreshRoll(rollCount)
	end

end

Handler_8_7.new():execute();