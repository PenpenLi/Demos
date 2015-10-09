BagItemTrimCommand=class(Command);

function BagItemTrimCommand:ctor()
	self.class=BagItemTrimCommand;
end

function BagItemTrimCommand:execute(notification)
	print("整理");
  if(connectBoo) then
    sendMessage(9,8);
  end
end