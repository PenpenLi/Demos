
OpenSevenDaysUICommand = class(Command);

function OpenSevenDaysUICommand:ctor(  )
	self.class = OpenSevenDaysUICommand;
end

function OpenSevenDaysUICommand:execute( notification )
	require "main.controller.command.SevenDays.CloseSevenDaysUICommand";
	require "main.view.SevenDays.SevenDaysMediator"

	self.notification = notification;
	self.UserProxy = self:retrieveProxy(UserProxy.name);
	self.UserCurrencyProxy = self:retrieveProxy(UserCurrencyProxy.name);
	self.BagProxy = self:retrieveProxy(BagProxy.name);

	if self.SevenDaysMediator == nil then 
		self.SevenDaysMediator = SevenDaysMediator.new();
		self:registerMediator(self.SevenDaysMediator:getMediatorName(), self.SevenDaysMediator);
		self.SevenDaysMediator:initializeUI();

		self:registerCloseCommands();
	end

	self:observe(CloseSevenDaysUICommand);
	LayerManager:addLayerPopable(self.SevenDaysMediator:getViewComponent());
end

function OpenSevenDaysUICommand:registerCloseCommands()
	print("function OpenSevenDaysUICommand:registerCloseCommands()")
  	self:registerCommand(SevenDaysNotifications.CLOSE_SEVENDAYS_UI, CloseSevenDaysUICommand);
end