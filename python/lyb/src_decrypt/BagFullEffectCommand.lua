BagFullEffectCommand=class(Command);

function BagFullEffectCommand:ctor()
	self.class=BagFullEffectCommand;
end

function BagFullEffectCommand:execute(notification)
  -- if MainSceneMediator then
  -- 	local mainSceneMediator=self:retrieveMediator(MainSceneMediator.name);
  -- 	if mainSceneMediator then
  -- 		mainSceneMediator:setBagFull(self:retrieveProxy(BagProxy.name):getBagIsFull(self:retrieveProxy(ItemUseQueueProxy.name)));
  -- 	end
  -- end
end