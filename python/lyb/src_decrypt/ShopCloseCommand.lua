ShopCloseCommand=class(MacroCommand);

function ShopCloseCommand:ctor()
	self.class=ShopCloseCommand;
end

function ShopCloseCommand:execute(notification)
  self:removeMediator(ShopMediator.name);
  self:unobserve(ShopCloseCommand);
  self:removeCommand(ShopNotifications.SHOP_UI_CLOSE,ShopCloseCommand);
  self:removeCommand(ShopNotifications.ITEM_BUY,ItemBuyCommand);

  self:checkFactionCurrencyClose();
end

function ShopCloseCommand:checkFactionCurrencyClose()
	require "main.controller.command.faction.CheckFactionCurrencyCloseCommand"
	CheckFactionCurrencyCloseCommand.new():execute();
end