BagItemSellCommand=class(Command);

function BagItemSellCommand:ctor()
	self.class=BagItemSellCommand;
end

function BagItemSellCommand:execute(notification)
	print("bagItemSellCommand",notification:getData().UserItemId);
  if(connectBoo) then
  	if self:retrieveProxy(BagProxy.name):getItemDataIsUsing(notification:getData().UserItemId) then
  		sharedTextAnimateReward():animateStartByString("装备正在使用中, 无法出售哦 !");
  	else
      initializeSmallLoading();
    	sendMessage(9,10,notification:getData());
    end
  end
end