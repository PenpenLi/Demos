-- refresh wenhao

Handler_8_13=class(MacroCommand);
 
function Handler_8_13:ctor()
	self.class=Handler_8_13;
end

function Handler_8_13:execute()

	-- refresh data
	local wenhaoTable = {}
 	wenhaoTable.Place = recvTable["Place"]
 	wenhaoTable.ID = recvTable["ID"]
 	wenhaoTable.Param = recvTable["Param"]
 	wenhaoTable.BooleanValue = recvTable["BooleanValue"]
	
	local xunbaoProxy = self:retrieveProxy(XunbaoProxy.name)
	xunbaoProxy:refreshWenhaoData(wenhaoTable)

	-- refresh ui
	-- local xunbaoMediator = self:retrieveMediator(XunbaoMediator.name);  
	-- if xunbaoMediator then
	-- 	xunbaoMediator:refreshData()
	-- end

end
Handler_8_13.new():execute();