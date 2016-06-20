MF_ShowWeeklyMatchStartPanel = class()

function MF_ShowWeeklyMatchStartPanel:doAction(action , context)
	if HomeScene:sharedInstance() then HomeScene:sharedInstance():onSummerWeeklyButtonTapped() end
end

return MF_ShowWeeklyMatchStartPanel