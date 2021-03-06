SeasonWeeklyMatchRankData = class()

function SeasonWeeklyMatchRankData:ctor(rankMinNum)
	rankMinNum = rankMinNum or 20
	self.uid = 0
	self.rankMinNum = rankMinNum
	self.rankList = {}
	self.activeFriends = {}
end

function SeasonWeeklyMatchRankData:initWithData(uid, rankList, activeFriends)
	self.uid = uid
	rankList = rankList or {}
	self.activeFriends = activeFriends or {}

	local rankUids = {}
	local distinctRankList = {} -- 去重后的排行数据
	for _, v in pairs(rankList) do
		if not rankUids[tostring(v.uid)] then
			table.insert(distinctRankList, {uid = tostring(v.uid), score = v.score})
			rankUids[tostring(v.uid)] = true
		end
	end

	self.rankList = distinctRankList

	-- 将自己放入排行榜
	if not rankUids[tostring(self.uid)] then
		table.insert(self.rankList, {uid = tostring(self.uid), score = 0})
	end
	if #self.rankList < 4 then
		-- 填充活跃但未上榜的好友，最多3名
		if #self.activeFriends > 0 then
			for _, fuid in pairs(self.activeFriends) do
				if #self.rankList >= 4 then break end
				if not rankUids[tostring(fuid)] then
					table.insert(self.rankList, {uid = tostring(fuid), score = 0})
					rankUids[tostring(fuid)] = true
				end
			end
		end
		-- 还不够？填充普通好友
		if #self.rankList < 4 then
			local friends = FriendManager.getInstance().friends
			for fuid, _ in pairs(friends) do
				if #self.rankList >= 4 then break end
				if not rankUids[tostring(fuid)] then
					table.insert(self.rankList, {uid = tostring(fuid), score = 0})
					rankUids[tostring(fuid)] = true
				end
			end
		end
	end

	self:updateAndSortRankList()
end

function SeasonWeeklyMatchRankData:updateAndSortRankList()
	if #self.rankList > 1 then
		table.sort(self.rankList, function(a, b)
				if a.score == b.score then
					if tostring(a.uid) == tostring(self.uid) then return true end
					if tostring(b.uid) == tostring(self.uid) then return false end
					return tonumber(a.uid) < tonumber(b.uid)
				end
				return a.score > b.score
			end)
	end
end

function SeasonWeeklyMatchRankData:updateMyScore(newScore)
	if newScore >= self.rankMinNum then
		local myRank = nil
		for _, v in pairs(self.rankList) do
			if tostring(v.uid) == tostring(self.uid) then
				myRank = v
				myRank.score = newScore
			end
		end
		if not myRank then
			myRank = {uid=self.uid, score = newScore}
			table.insert(self.rankList, myRank)
		end
		self:updateAndSortRankList()
	end
end

function SeasonWeeklyMatchRankData:getRankList()
	return self.rankList
end

function SeasonWeeklyMatchRankData:getRankNum( ... )
	local rankNum = 0
	for _, rank in ipairs(self.rankList) do
		if rank.score >= self.rankMinNum then
			rankNum = rankNum + 1
		else
			break
		end
	end
	return rankNum 
end

function SeasonWeeklyMatchRankData:getMyRank()
	for index, rank in ipairs(self.rankList) do
		if tostring(rank.uid) == tostring(self.uid) and rank.score >= self.rankMinNum then
			return index
		end
	end
	return 0
end

function SeasonWeeklyMatchRankData:getSurpassFriends()
	local inRankList = false
	local myScore = 0
	local ret = {}
	for _, rank in ipairs(self.rankList) do
		if rank.score < self.rankMinNum then break end
		if inRankList then 
			if myScore > rank.score then
				table.insert(ret, rank.uid)
			end
		elseif tostring(rank.uid) == tostring(self.uid) then
			inRankList = true
			myScore = rank.score
		end
	end
	return ret
end

function SeasonWeeklyMatchRankData:getSurpassCount()
	local surpassFriends = self:getSurpassFriends()
	return #surpassFriends
end