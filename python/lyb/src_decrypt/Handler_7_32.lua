
Handler_7_32 = class(Command)

function Handler_7_32:execute()
	local IndexArray = recvTable["IndexArray"]
	local battleProxy = self:retrieveProxy(BattleProxy.name)
	for key,value in pairs(IndexArray) do
		battleProxy.hasSendIndexArray[value.Index] = value.Index
	end
	
end

Handler_7_32.new():execute();