Handler_21_10 = class(Command);

function Handler_21_10:execute()
	print(".21.10..");
  for k,v in pairs(recvTable["IDArray"]) do
    print("");
    for k_,v_ in pairs(v) do
      print(".21.10.",k_,v_);
    end
  end
  local buddyListProxy=self:retrieveProxy(BuddyListProxy.name);
  buddyListProxy:refreshHaoyouIDs(recvTable["IDArray"]);
end

Handler_21_10.new():execute();