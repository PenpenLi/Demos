--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-17

	yanchuan.xie@happyelements.com
]]

Handler_21_5 = class(Command);

function Handler_21_5:execute()
  print(".21.5..");
  print(".21.5.",recvTable["ID"],recvTable["ParamStr1"],recvTable["ParamStr2"],recvTable["ParamStr3"],recvTable["Time"]);

  local data={};
  data.ID=recvTable["ID"];
  data.ParamStr1=recvTable["ParamStr1"];
  data.ParamStr2=recvTable["ParamStr2"];
  data.ParamStr3=recvTable["ParamStr3"];
  data.Time=recvTable["Time"];

  local chatListProxy=self:retrieveProxy(ChatListProxy.name);
  chatListProxy:refreshBuddyFeed(data);

  if ChatPopupMediator then
  	local chatPopupMediator=self:retrieveMediator(ChatPopupMediator.name);
  	if chatPopupMediator then
  		chatPopupMediator:refreshFeed(data);
  	end
  end

  if 1==recvTable["ID"] then
    recvTable["Value"]=tonumber(chatListProxy:getBuddyFeedEXP()+tonumber(recvTable["ParamStr3"]));
    recvMessage(1021,8);
  end
end

Handler_21_5.new():execute();