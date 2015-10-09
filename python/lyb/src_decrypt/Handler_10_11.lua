Handler_10_11 = class(Command)

function Handler_10_11:execute()
	local strengthenPopupMediator = self:retrieveMediator(StrengthenPopupMediator.name)
	if nil ~= strengthenPopupMediator then
		strengthenPopupMediator:updateGemPanel();
	end
end

Handler_10_11.new():execute()