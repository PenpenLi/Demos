-------------------------
-- close battle Mediator
-------------------------

CloseLotteryCommand=class(Command);

function CloseLotteryCommand:ctor()
	self.class=CloseLotteryCommand;
end

function CloseLotteryCommand:execute()
	if LotteryMediator then
		--self:removeMediator(LotteryMediator.name);
		self:removeCommand(BattleSceneNotifications.CLOSE_LOTTERY_MEDIATOR,CloseLotteryCommand);	
		self:removeCommand(BattleSceneNotifications.SEND_MESSAGE_FOR_CHARGE_BOX,SendMessageForChargeBoxCommand);
	end
end
