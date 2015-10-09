Handler_2_15 = class(Command);

function Handler_2_15:execute()
	local buddyListProxy = self:retrieveProxy(BuddyListProxy.name);
	buddyListProxy:setShezhi(recvTable["IDArray"]);
end

Handler_2_15.new():execute();