RemoveTipCommand=class(Command);

function RemoveTipCommand:ctor()
	self.class=RemoveTipCommand;
end

function RemoveTipCommand:execute(notification)
  if TipMediator then
	  self:removeMediator(TipMediator.name);
	  self:unobserve(RemoveTipCommand);
  end
end

