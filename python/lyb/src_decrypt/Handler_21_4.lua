--

-- require "main.controller.command.chat.ChatAddBuddyPopupCommand";

Handler_21_4 = class(MacroCommand);

function Handler_21_4:execute()
	uninitializeSmallLoading();
  print(".21.4..");
  print(".21.4.",recvTable["FriendArray"]);

  -- local a=ChatNotification.new("",{UserId=0,UserName=recvTable["UserName"]});
  -- self:addSubCommand(ChatAddBuddyPopupCommand);
  -- self:complete(a);
  local buddyPopupMediator = self:retrieveMediator(BuddyPopupMediator.name);
  if buddyPopupMediator then
  	buddyPopupMediator:getViewComponent():refreshShenqingData(recvTable["FriendArray"]);
  end
end

Handler_21_4.new():execute();