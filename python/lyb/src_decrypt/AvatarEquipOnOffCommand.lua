AvatarEquipOnOffCommand=class(Command);

function AvatarEquipOnOffCommand:ctor()
	self.class=AvatarEquipOnOffCommand;
end

function AvatarEquipOnOffCommand:execute(notification)
  local data=notification:getData();
	print("AvatarEquipOnOffCommand");
  if(connectBoo) then
    if self:retrieveProxy(BagProxy.name):getItemData(notification:getData().UserEquipmentId).IsUsing==notification:getData().BooleanValue then
    
    else
      sendMessage(6,4,data);
    end
  end
end