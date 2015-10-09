
Handler_7_59 = class(Command);

function Handler_7_59:execute()
 
    local quickBattleMediator=self:retrieveMediator(QuickBattleMediator.name); 	

    if quickBattleMediator then
    	quickBattleMediator:mopUpOver();
    end

end

Handler_7_59.new():execute();