CloseXunbaoCommand=class(MacroCommand);

function CloseXunbaoCommand:ctor()
  self.class=CloseXunbaoCommand;
end

function CloseXunbaoCommand:execute(notification)

	local xunbaoProxy = self:retrieveProxy(XunbaoProxy.name)
	xunbaoProxy.isPop = false

	self:removeMediator(XunbaoMediator.name);
	self:unobserve(CloseXunbaoCommand);
	self:removeCommand(XunbaoNotifications.CLOSE_XUNBAO,CloseXunbaoCommand);

end