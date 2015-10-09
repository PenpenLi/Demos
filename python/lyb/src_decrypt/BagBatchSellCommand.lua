BagBatchSellCommand=class(Command);

function BagBatchSellCommand:ctor()
	self.class=BagBatchSellCommand;
end

function BagBatchSellCommand:execute(notification)
	if(connectBoo) then
		initializeSmallLoading();
		sendMessage(9,14,notification:getData());
	end
end