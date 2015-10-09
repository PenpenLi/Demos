
-- require "main.view.challenge.ChallengeMediator";

MainSceneGantanhaoCommand=class(Command);

function MainSceneGantanhaoCommand:ctor()
	self.class=MainSceneGantanhaoCommand;
end

function MainSceneGantanhaoCommand:execute(notification)
  local activityProxy = self:retrieveProxy(ActivityProxy.name);
  if MainSceneMediator and self:retrieveMediator(MainSceneMediator.name) then  
  	for k,v in pairs(ActivityConstConfig.activities) do
  		print("+++",v,activityProxy.activityNoticeStatusTbl[v]);
      if v==ActivityConstConfig.ID_7 then

      else
  	    if v==ActivityConstConfig.ID_2 then
      	 recvTable["ID"]=10;
      	 recvTable["ParamStr1"]=100006;
        elseif v==ActivityConstConfig.ID_4 then
      	 recvTable["ID"]=10;
      	 recvTable["ParamStr1"]=100005;
        elseif v==ActivityConstConfig.ID_5 then
      	 recvTable["ID"]=10;
      	 recvTable["ParamStr1"]=100001;
        elseif v==ActivityConstConfig.ID_6 then
          recvTable["ID"]=12;
          recvTable["ParamStr1"]=0;
        elseif v==ActivityConstConfig.ID_10 then
          recvTable["ID"]=79;
        end
        recvTable["ParamStr2"]=0;
        recvTable["ParamStr3"]=0;
        recvTable["Content"]="";
        if activityProxy.activityNoticeStatusTbl[v] then
          recvMessage(1011,6);
          activityProxy.activityNoticeStatusTbl[v] = false;
        end
      end
      
    end
    -- ActivityConstConfig.activities={};
  end
end