Handler_16_9 = class(Command);

function Handler_16_9:execute()
    local jingjichangMediator=self:retrieveMediator(JingjichangMediator.name);
    if jingjichangMediator then
        jingjichangMediator:getViewComponent():refreshRenwuData(recvTable["IDStateArray"]);
    end
end

Handler_16_9.new():execute();