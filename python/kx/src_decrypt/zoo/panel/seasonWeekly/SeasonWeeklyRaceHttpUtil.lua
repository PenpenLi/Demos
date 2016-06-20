SeasonWeeklyRaceHttpUtil = {}

function SeasonWeeklyRaceHttpUtil.newGetInfoHttp(inBackground, onRequestSuccess, onRequestFail, onRequestCancel)
	local http = GetAutumnWeekMatchInfoHttp.new(not inBackground)
    http:ad(Events.kComplete, onRequestSuccess)
    http:ad(Events.kError, onRequestFail)
    http:ad(Events.kCancel, onRequestCancel)
    return http
end

function SeasonWeeklyRaceHttpUtil.newGetRewardsHttp(onRequestSuccess, onRequestFail, onRequestCancel)
	local http = GetAutumnWeekMatchRewardHttp.new(true)
    http:ad(Events.kComplete, onRequestSuccess)
    http:ad(Events.kError, onRequestFail)
    http:ad(Events.kCancel, onRequestCancel)
    return http
end

function SeasonWeeklyRaceHttpUtil.newOpNotifyHttp(onRequestSuccess, onRequestFail, onRequestCancel)
	local http = OpNotifyHttp.new(true)
    http:ad(Events.kComplete, onRequestSuccess)
    http:ad(Events.kError, onRequestFail)
    http:ad(Events.kCancel, onRequestCancel)
    return http
end

function SeasonWeeklyRaceHttpUtil.newPushNotifyHttp(onRequestSuccess, onRequestFail, onRequestCancel)
	local http = PushNotifyHttp.new()
	http:addEventListener(Events.kComplete, onRequestSuccess)
	http:addEventListener(Events.kError, onRequestFail)
	http:addEventListener(Events.kCancel, onRequestCancel)
	return http
end

function SeasonWeeklyRaceHttpUtil.newGetRankListHttp(onRequestSuccess, onRequestFail, onRequestCancel)
	local http = GetCommonRankListHttp.new()
    http:addEventListener(Events.kComplete, onRequestSuccess)
    http:addEventListener(Events.kError, onRequestFail)
    return http
end