Handler_10_10 = class(Command)

function Handler_10_10:execute()
	local strengthenPopupMediator = self:retrieveMediator(StrengthenPopupMediator.name)
	strengthenPopupMediator:updateGemPanel()
end

Handler_10_10.new():execute()