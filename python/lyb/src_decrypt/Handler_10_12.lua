Handler_10_12 = class(Command)

function Handler_10_12:execute()
	local strengthenPopupMediator = self:retrieveMediator(StrengthenPopupMediator.name)
	strengthenPopupMediator:updateGemPanel()
end

Handler_10_12.new():execute()