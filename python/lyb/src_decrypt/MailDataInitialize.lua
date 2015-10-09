
require "main.model.MailProxy";

MailDataInitialize=class(Command);

function MailDataInitialize:ctor()
	self.class=MailDataInitialize;
end

function MailDataInitialize:execute()
	--
  local mailProxy=MailProxy.new();
  self:registerProxy(mailProxy:getProxyName(),mailProxy);
end