Handler_10_9 = class(Command)

function Handler_10_9:execute()
	local strengthenPopupMediator = self:retrieveMediator(StrengthenPopupMediator.name)
	strengthenPopupMediator:updateGemPanel()
end

Handler_10_9.new():execute()