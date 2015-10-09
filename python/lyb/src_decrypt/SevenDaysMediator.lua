require "main.view.SevenDays.ui.SevenDaysPopup"

SevenDaysMediator = class(Mediator);

function SevenDaysMediator:ctor(  )
	self.class = SevenDaysMediator;
end
rawset(SevenDaysMediator, "name", "SevenDaysMediator");

function SevenDaysMediator:initialize(  )
	self.viewComponent = SevenDaysPopup.new();
	self:getViewComponent():initialize();
end

function SevenDaysMediator:onRegister()
	print("function SevenDaysMediator:onRegister()")
	self:initialize();
	self:getViewComponent():addEventListener("CLOSE_SEVENDAYS_UI", self.onSevenDaysClose, self);
	self:getViewComponent():addEventListener("ON_ITEM_TIP", self.onItemTip, self);
	self:getViewComponent():addEventListener("gotocharge", self.gotocharge, self);
end

function SevenDaysMediator:initializeUI()
	print("function SevenDaysMediator:initializeUI(  )")
	
end


function SevenDaysMediator:setData()
 self:getViewComponent():setData();
end

function SevenDaysMediator:refreshData()
 self:getViewComponent():refreshData();
end

function SevenDaysMediator:refreshRedDot( tab )
	self:getViewComponent():refreshRedDot(tab);
end

function SevenDaysMediator:refreshLeftRedDot()
	print("\n\n\n\n\n\nfunction SevenDaysMediator:refreshLeftRedDot()")
 self:getViewComponent():refreshLeftRedDot();
end

function SevenDaysMediator:onRemove(  )
	local parent = self:getViewComponent().parent;
	if parent then
		parent:removeChild(self:getViewComponent());
	end
end

function SevenDaysMediator:onSevenDaysClose( event )
	self:sendNotification(SevenDaysNotification.new(SevenDaysNotifications.CLOSE_SEVENDAYS_UI));
end

function SevenDaysMediator:onItemTip( event )
	-- body
	print("onItemTip")
	self:sendNotification(TipNotification.new(TipNotifications.OPEN_TIP_COMMOND, event.data));
end

function SevenDaysMediator:gotocharge( event )
	print("gotocharge");
  	self:sendNotification(OpenFunctionNotification.new(OpenFunctionNotifications.OPEN_UI_BY_FUNCTION_ID,{functionid=2}));
end

function SevenDaysMediator:updateTextDate( str )
	self:getViewComponent():updateTextDate(str);
end

function SevenDaysMediator:stopSevendays()
	self:getViewComponent():stopSevendays();
end