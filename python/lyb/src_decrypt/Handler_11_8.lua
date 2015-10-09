--[[
  Copyright @2009-2013 www.happyelements.com, all rights reserved.
  Create date: 2013-4-17

  yanchuan.xie@happyelements.com
]]

require "main.view.chat.ChatPopupMediator";

Handler_11_8 = class(Command);

function Handler_11_8:execute()
  print(".11.8.",recvTable["GeneralId"],recvTable["ItemId"],recvTable["StrengthenLevel"]);

  local data={};
  data.UserEquipmentId=recvTable["GeneralId"];
  data.ItemId=recvTable["ItemId"];
  data.StrengthenLevel=recvTable["StrengthenLevel"];

  --ChatPopupMediator
  local chatPopupMediator=self:retrieveMediator(ChatPopupMediator.name);
  if chatPopupMediator then
    chatPopupMediator:refreshChatEquipDetailLayer(self:retrieveProxy(BagProxy.name):getSkeleton(),data);
  end
end

Handler_11_8.new():execute();