--[[
  Copyright @2009-2013 www.happyelements.com, all rights reserved.
  Create date: 2013-4-17

  yanchuan.xie@happyelements.com
]]

require "main.view.chat.ChatPopupMediator";

Handler_11_11 = class(Command);

function Handler_11_11:execute()
  print(".11.11.",recvTable["GeneralId"],recvTable["ConfigId"],recvTable["Grade"]);

  local data={};
  data.GeneralId=recvTable["GeneralId"];
  data.ConfigId=recvTable["ConfigId"];
  data.Grade=recvTable["Grade"];
  data.StarLevel=recvTable["StarLevel"];

  --ChatPopupMediator
  local chatPopupMediator=self:retrieveMediator(ChatPopupMediator.name);
  if chatPopupMediator then
    chatPopupMediator:refreshChatHeroDetailLayer(getSkeletonByName("hero_ui"),data);
  end
end

Handler_11_11.new():execute();