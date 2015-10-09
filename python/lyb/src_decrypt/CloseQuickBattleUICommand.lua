CloseQuickBattleUICommand=class(Command);

function CloseQuickBattleUICommand:ctor()
	self.class=CloseQuickBattleUICommand;
end

function CloseQuickBattleUICommand:execute(notification)
    self:removeMediator(QuickBattleMediator.name);
end

