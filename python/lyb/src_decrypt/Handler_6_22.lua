


Handler_6_22 = class(Command);

function Handler_6_22:execute()
    print(recvTable["GeneralId"],recvTable["ID"],recvTable["Level"]);
    local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
  	heroHouseProxy:refreshYuanfenShengji(recvTable["GeneralId"],recvTable["ID"],recvTable["Level"]);
    heroHouseProxy.Yuanfen_Jinjie_Bool = nil;
end

Handler_6_22.new():execute();