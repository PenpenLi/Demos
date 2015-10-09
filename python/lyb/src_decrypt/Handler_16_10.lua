Handler_16_10 = class(Command);

function Handler_16_10:execute()
    local jingjichangMediator=self:retrieveMediator(JingjichangMediator.name);
    if jingjichangMediator then
        jingjichangMediator:getViewComponent():refreshScore(recvTable["Score"]);
    end
end

Handler_16_10.new():execute();