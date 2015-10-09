ItemBuyCommand=class(Command);

function ItemBuyCommand:ctor()
	self.class=ItemBuyCommand;
end

function ItemBuyCommand:execute(notification)

      initializeSmallLoading();
    	sendMessage(3,16,notification:getData());
end