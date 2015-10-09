Handler_16_8 = class(Command);

function Handler_16_8:execute()
	print(recvTable["BooleanValue"]);
	local arenaProxy = self:retrieveProxy(ArenaProxy.name);
	arenaProxy:setIsUpdating(recvTable["BooleanValue"]);

    local jingjichangMediator=self:retrieveMediator(JingjichangMediator.name);
    if jingjichangMediator then
        jingjichangMediator:getViewComponent():refreshIsUpdating();
    end
end

Handler_16_8.new():execute();