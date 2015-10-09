TianXiangCloseCommand=class(MacroCommand);

function TianXiangCloseCommand:ctor()
	self.class=TianXiangCloseCommand;
end

function TianXiangCloseCommand:execute(notification)

  self:removeMediator(TianXiangMediator.name);
  self:unobserve(TianXiangCloseCommand);
end
