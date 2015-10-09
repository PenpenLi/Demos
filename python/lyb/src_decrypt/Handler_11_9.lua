--[[
  Copyright @2009-2013 www.happyelements.com, all rights reserved.
  Create date: 2013-4-17

  yanchuan.xie@happyelements.com
]]

require "main.view.chat.ChatPopupMediator";

Handler_11_9 = class(Command);

function Handler_11_9:execute()
  print(".11.9.",recvTable["State"]);

  --ChatPopupMediator
  local chatPopupMediator=self:retrieveMediator(ChatPopupMediator.name);
  if chatPopupMediator then
    chatPopupMediator:refreshPrivateChatValid(recvTable["State"]);
  end
end

Handler_11_9.new():execute();