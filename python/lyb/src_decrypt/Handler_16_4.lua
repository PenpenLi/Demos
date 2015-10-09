
Handler_16_4 = class(Command);

function Handler_16_4:execute()
	-- local arenaProxy = self:retrieveProxy(ArenaProxy.name)
 --    arenaProxy.userArenaArray = recvTable["UserArenaArray"];
 for k,v in pairs(recvTable["UserArenaArray"]) do
        print("Handler_16_4.");
        for k_,v_ in pairs(v) do
            print("Handler_16_4..",k_,v_);
        end
    end
    local jingjichangMediator=self:retrieveMediator(JingjichangMediator.name);
    if jingjichangMediator then
        jingjichangMediator:getViewComponent():refreshUserData(recvTable["UserArenaArray"]);
    end
end

Handler_16_4.new():execute();