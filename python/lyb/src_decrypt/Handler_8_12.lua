-- refresh data and ui

Handler_8_12=class(MacroCommand);
 
function Handler_8_12:ctor()
	self.class=Handler_8_12;
end

function Handler_8_12:execute()

	-- refresh data
	local palce = recvTable["Place"]
	local state = recvTable["State"]

	local xunbaoProxy = self:retrieveProxy(XunbaoProxy.name)
	xunbaoProxy:refreshData(palce,state)

	-- refresh ui
	local xunbaoMediator = self:retrieveMediator(XunbaoMediator.name);  
	if xunbaoMediator then
		xunbaoMediator:refreshData()
	end

end

Handler_8_12.new():execute();