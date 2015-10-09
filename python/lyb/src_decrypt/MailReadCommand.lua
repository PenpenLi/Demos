MailReadCommand=class(MacroCommand);

function MailReadCommand:ctor()
	self.class=MailReadCommand;
end

function MailReadCommand:execute(notification)
  local data=notification:getData();
  if(connectBoo) then
    sendMessage(23,11,data);
    -- 刷新数据
    local mailProxy = self:retrieveProxy(MailProxy.name)
    
    mailProxy:mailOperation(data.MailId,1)
    -- 刷新红点
	self:addSubCommand(ToRefreshReddotCommand);
	self:complete({data={type=FunctionConfig.FUNCTION_ID_5}});  
  end
end