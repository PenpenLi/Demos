BagOpenPlaceCommand=class(Command);

function BagOpenPlaceCommand:ctor()
	self.class=BagOpenPlaceCommand;
end

function BagOpenPlaceCommand:execute(notification)
  local data={Place=notification:getData()};
	print("sendOpenPlace",data.Place);
  if(connectBoo) then
    sendMessage(9,6,data);
  end
end