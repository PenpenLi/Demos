
Handler_7_38 = class(Command)

function Handler_7_38:execute()
	local battleEmployArray = recvTable["BattleEmployArray"]
    local strongPointInfoMediator=self:retrieveMediator(StrongPointInfoMediator.name);  
    if strongPointInfoMediator then
        strongPointInfoMediator:refreshEmployArrayData(battleEmployArray);
    end
end

Handler_7_38.new():execute();