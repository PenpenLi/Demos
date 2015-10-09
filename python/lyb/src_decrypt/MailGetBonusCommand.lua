MailGetBonusCommand=class(MacroCommand);

function MailGetBonusCommand:ctor()
	self.class=MailGetBonusCommand;
end

function MailGetBonusCommand:execute(notification)
  local data=notification:getData();
  if(connectBoo) then
    sendMessage(23,12,data);
    -- 刷新数据
    local mailProxy = self:retrieveProxy(MailProxy.name)

    mailProxy:mailOperation(data.MailId,2)
    -- 刷新红点
	self:addSubCommand(ToRefreshReddotCommand);
	self:complete({data={type=FunctionConfig.FUNCTION_ID_5}});      
  end
end