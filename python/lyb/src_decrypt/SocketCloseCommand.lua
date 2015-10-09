-- socket close stuff

SocketCloseCommand=class(MacroCommand);

function SocketCloseCommand:ctor()
	self.class = SocketCloseCommand;
end

function SocketCloseCommand:execute(notification)

  -- 寻宝 骰子停
  require "main.view.xunbao.XunbaoMediator";
  local xunbaoMediator = self:retrieveMediator(XunbaoMediator.name);  
  if xunbaoMediator then
    xunbaoMediator:stopRolling()
  end  
end
