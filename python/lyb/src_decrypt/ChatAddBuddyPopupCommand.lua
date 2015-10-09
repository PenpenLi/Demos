
	-- Copyright @2009-2013 www.happyelements.com, all rights reserved.
	-- Create date: 2013-4-17

	-- yanchuan.xie@happyelements.com


require "core.controls.CommonPopup";

ChatAddBuddyPopupCommand=class(Command);

function ChatAddBuddyPopupCommand:ctor()
	self.class=ChatAddBuddyPopupCommand;
end

function ChatAddBuddyPopupCommand:execute(notification)
  local data=notification:getData();
  print("chatAddBuddyPopupCommand",data.UserId,data.UserName);

  local popup=CommonPopup.new();
  popup:initialize(data.UserName .. "希望加你为好友,同意不咯?",self,self.onConfirm,data);
  sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(popup);
end

function ChatAddBuddyPopupCommand:onConfirm(data)
  if(connectBoo) then
    sendMessage(21,2,data);
  end
end