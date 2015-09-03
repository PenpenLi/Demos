require "hecore.class"
require "zoo.data.DataRef"

local debugUserData = false

local instance = nil
UserManager = class()
kMaxLevels = 210

function UserManager:ctor()
	self:reset()
end

function UserManager:reset()
	self.kMaxHeadImages = 10
	self.platform = kDefaultSocialPlatform
	self.uid = nil --set by debug, by sns connect, etc. 
	self.sessionKey = nil
	self.openId = nil
	self.appName = ""
	self.friendIds = {}
	self.user = UserRef.new()
	self.profile = ProfileRef.new()
	self.userExtend = UserExtendRef.new()
	self.bag = BagRef.new()
	self.mark = MarkRef.new()
	self.dailyData = DailyDataRef.new()
	self.props = {} 
	self.funcs = {} 
	self.decos = {}
	self.scores = {}

	self.oldScores = {}

	self.achis = {}
	self.requestInfos = {} 
	self.requestNum = 0
	self.unLockFriendInfos = {}
	self.ladyBugInfos = {}

	self.levelAreaOpenedId = false	-- Used To Record Which Level Area Opened Recently

	-- Index: locked area id
	-- value: a table { userid1, userid2, userid3, ...}
	self.unlockFriendInfos = {}

	-- Used To Invited Friend Info
	self.inviteFriendsInfo	= false

	-- Used In Friend Rank 
	self.selfNumberInFriendRank	= {}	-- Key: number(LevelId), Value: number(rank)
	self.selfOldNumberInFriendRank	= {}

	self.selfNumberInServerRank	= {}
	self.selfOldNumberInServerRank	= {}	

	self.exchangeCode = ""


	-- Used For Invited Friend Reward
	self.inviteFriendInfos = false

	-- 
	self.updateInfo = {}
	self.updateReward = {}
	self.updateRewards = {}
	self.timeProps = {}

end

function UserManager:checkDateChange()	

	local currentTime = math.ceil(Localhost:time()/1000)
	local currentDate = os.date("*t", currentTime)

	if not self.lastCheckTime then -- not initialized 
		print('not initialized ')
		self.lastCheckTime = currentTime
		UserService:getInstance().lastCheckTime = currentTime
		Localhost:flushCurrentUserData()
	end

	local lastTime = self.lastCheckTime
	local lastDate = os.date("*t", lastTime)

	local compareResult = compareDate(lastDate, currentDate)
	
	if 	compareResult == -1
	then
		self.lastCheckTime = currentTime
		UserService:getInstance().lastCheckTime = currentTime
        UserManager:getInstance():getDailyData():resetAll()
		Localhost:flushCurrentUserData()
	
	end

    if compareResult ~= 0 then -- not equal
        print(' not equal')
        -- WeeklyRaceManager:sharedInstance():onDayChange(lastDate, currentDate)  

        -- if  HomeScene:sharedInstance().weeklyRaceBtn then
        --     HomeScene:sharedInstance().weeklyRaceBtn:update()
        -- end
     --    if compareResult < 0 then -- 往后跨天才认为是真正的跨天
	    --     RabbitWeeklyManager:sharedInstance():onDayChange(lastDate, currentDate) 
	    --     if  HomeScene:sharedInstance().rabbitWeeklyButton then
	    --         HomeScene:sharedInstance().rabbitWeeklyButton:update()
	    --     end
	    -- end
    end	
end

function UserManager:getDailyData()
	self:checkDateChange()

	return self.dailyData
end

function UserManager:getInstance()
	if not instance then 
		instance = UserManager.new() 
	end
	return instance
end

function UserManager:isPlayerRegistered()
	return self.uid and self.uid ~= self.sessionKey
end

function UserManager:getMaxLevelInOpenedRegion()
	local curLevelId	= UserManager:getInstance().user.topLevelId
	local nextLevelAreaRef	= MetaManager.getInstance():getNextLevelAreaRefByLevelId(curLevelId)

	local areaMaxLevel = 0
	if nextLevelAreaRef then 
		areaMaxLevel	= tonumber(nextLevelAreaRef.minLevel) - 1 
	else
		for k, v in pairs(MetaManager.getInstance().level_area) do 
			if tonumber(v.maxLevel)  == 9999 then 
				areaMaxLevel = tonumber(v.minLevel) - 1
				break
			end
		end
	end
	return areaMaxLevel
end

function UserManager:getFullStarInOpenedRegion(...)
	assert(#{...} == 0)

	local areaMaxLevel = self:getMaxLevelInOpenedRegion()
	local fullStar = areaMaxLevel * 3

	return fullStar
end

local function debugMessage( msg )
	if debugUserData then print("[UserManager]", ""..msg) end
end 

function UserManager:decode(src)
	self:initFromLua(src)
end

function UserManager:createNewUser()
	local globalMeta = MetaManager.getInstance().global
	local userCoin = globalMeta.user_init_coin or 30000
	print("createNewUser:", userCoin)

	self.platform = kDefaultSocialPlatform
	self.uid = kDeviceID
	self.sessionKey = kDeviceID
	self.openId = nil
	self.user.uid = kDeviceID
	self.user:setEnergy(globalMeta.user_energy_init_count or 30)
	self.user:setCoin(userCoin)
	self.user:setUpdateTime(os.time() * 1000)
	self.user:setTopLevelId(1)

	local kMaxHeadImages = self.kMaxHeadImages + 1
	self.profile.headUrl = math.floor(math.random() * kMaxHeadImages)
end

function UserManager:syncUserFromLua( src )
	if src then
		self.user:fromLua(src)
	end
end

local function cloneMetaTableArray( dst )
	local result = {}
	for i,v in ipairs(dst) do
		result[i] = v
	end
	return result
end 
local function cloneClassTableArray( src, Cls )
	local result = {}
	for i,v in ipairs(src) do
		local p = Cls.new()
		p:fromLua(v)
		result[i] = p
	end
	return result
end 
function UserManager:clone(dst)
	dst.platform = self.platform
	dst.appName = self.appName
	dst.uid = self.uid
	dst.inviteCode = self.inviteCode
	dst.sessionKey = self.sessionKey
	dst.friendIds = cloneMetaTableArray(self.friendIds)
	dst.openId = self.openId
	
	dst.user = UserRef.new()
	dst.user:fromLua(self.user)

	dst.userExtend = UserExtendRef.new()
	dst.userExtend:fromLua(self.userExtend)

	dst.profile = ProfileRef.new()
	dst.profile:fromLua(self.profile)

	dst.bag = BagRef.new()
	dst.bag:fromLua(self.bag)

	dst.mark = MarkRef.new()
	dst.mark:fromLua(self.mark)

	dst.dailyData = DailyDataRef.new()
	dst.dailyData:fromLua(self.dailyData)

	dst.props = cloneClassTableArray(self.props, PropRef)
	dst.funcs = cloneClassTableArray(self.funcs, FuncRef)
	dst.decos = cloneClassTableArray(self.decos, DecoRef)
	dst.scores = cloneClassTableArray(self.scores, ScoreRef)
	dst.achis = cloneClassTableArray(self.achis, AchiRef)
	dst.requestInfos = cloneClassTableArray(self.requestInfos, RequestInfoRef)
	dst.requestNum = self.requestNum
	dst.unLockFriendInfos = cloneClassTableArray(self.unLockFriendInfos, UnLockFriendInfoRef)
	dst.ladyBugInfos = cloneClassTableArray(self.ladyBugInfos, LadyBugInfoRef)
	dst.weekMatch = self.weekMatch
	dst.lastCheckTime = self.lastCheckTime
	dst.userReward = self.userReward
	dst.rabbitWeekly = self.rabbitWeekly
	dst.dimePlat = self.dimePlat
	dst.dimeProvince = self.dimeProvince
	dst.timeProps = cloneClassTableArray(self.timeProps, TimePropRef)
	dst.userType = self.userType
	dst.setting = self.setting
end


function UserManager:ladyBugInfos_getLadyBugInfoById(id, ...)
	assert(type(id) == "number")
	assert(#{...} == 0)

	for k,v in pairs(self.ladyBugInfos) do
		if v.id == id then
			return v
		end
	end

	return false
end

function UserManager:initFromLua( src )
	self.appName = src.appName --ConfigManager中的App名称
	self.friendIds = src.friendIds --用户好友id列表,只在访问自己信息的时候返回

	self.inviteCode	= src.inviteCode or ""
	print("inviteCode ".. tostring(src.inviteCode))

	debugMessage("FriendIds")
	if debugUserData then
		for i,v in ipairs(self.friendIds) do print("FriendId:",v) end
	end

	debugMessage(self.appName)
	debugMessage("UserRef")

	self.user = UserRef.new() --用户信息
	self.user:fromLua(src.user)

	self.profile = ProfileRef.new()
	self.profile:fromLua(src.profile)

	debugMessage("UserExtendRef")

	self.userExtend = UserExtendRef.new() --用户扩展信息
	self.userExtend:fromLua(src.userExtend)

	debugMessage("BagRef")

	self.bag = BagRef.new() --用户背包信息
	self.bag:fromLua(src.bag)

	debugMessage("MarkRef")

	self.mark = MarkRef.new() --用户签到信息
	self.mark:fromLua(src.mark)

	debugMessage("DailyDataRef")

	self.dailyData = DailyDataRef.new() --用户每日数据
	self.dailyData:fromLua(src.dailyData)

	self.exchangeCode = src.exchangeCode

	--用户道具信息,只在访问自己信息的时候返回

	debugMessage("PropRef")

	self.props = {}
	if src.props then
		for i,v in ipairs(src.props) do
			local p = PropRef.new()
			p:fromLua(v)
			self.props[i] = p
		end
	end

	-- 限时道具
	self:timePropsFromServer(src.timeProps)
		
	--用户功能信息,只在访问自己信息的时候返回

	debugMessage("FuncRef")

	self.funcs = {}
	if src.funcs then
		for i,v in ipairs(src.funcs) do
			local p = FuncRef.new()
			p:fromLua(v)
			self.funcs[i] = p
		end
	end
	
	--用户装扮信息,只在访问自己信息的时候返回

	debugMessage("DecoRef")

	self.decos = {}
	if src.decos then
		for i,v in ipairs(src.decos) do
			local p = DecoRef.new()
			p:fromLua(v)
			self.decos[i] = p
		end
	end	

	--用户关卡得分和星级信息

	debugMessage("ScoreRef")

	self.scores = {}
	if src.scores then
		for i,v in ipairs(src.scores) do
			local p = ScoreRef.new()
			p:fromLua(v)
			self.scores[i] = p
		end
	end

	----------- 暂时只针对应用宝平台，重新计算客户端支持的星星数 ----------
	if PlatformConfig:isQQPlatform() then
		local userStars = 0
		local areaMaxLevel = self:getMaxLevelInOpenedRegion()
		for k, v in pairs(self.scores) do 
			if tonumber(v.levelId) <= areaMaxLevel then
				userStars = userStars + tonumber(v.star)
			end
		end
		self.user:setStar(userStars)

		local userHiddenStars = 0
	end
	-------------------- END ----------------------------------------------


	--用户成就相关数据

	debugMessage("AchiRef")

	self.achis = {}
	if src.achis then
		for i,v in ipairs(src.achis) do
			local p = AchiRef.new()
			p:fromLua(v)
			self.achis[i] = p
		end
	end
	
	--请求信息（免费礼物信息除外）

	debugMessage("RequestInfoRef")

	local inviteProfilesMap = {}
	local inviteProfiles = src.inviteProfiles
	if inviteProfiles and #inviteProfiles > 0 then
		for i,v in ipairs(inviteProfiles) do inviteProfilesMap[v.uid] = v end
	end

	self.requestInfos = {}
	if src.requestInfos then
		for i,v in ipairs(src.requestInfos) do
			local p = RequestInfoRef.new()
			p:fromLua(v)
			local profile = inviteProfilesMap[p.senderUid]
			if profile then
				p.name = HeDisplayUtil:urlDecode(profile.name or "")
				p.headUrl = profile.headUrl
			end
			self.requestInfos[i] = p
		end
	end

	self.requestNum = src.requestNum or 0
	
	--已同意请求的 关卡好友信息

	debugMessage("UnLockFriendInfoRef")

	self.unLockFriendInfos = {}
	if src.unLockFriendInfos then
		for i,v in ipairs(src.unLockFriendInfos) do
			local p = UnLockFriendInfoRef.new()
			p:fromLua(v)
			self.unLockFriendInfos[i] = p
		end
	end
	

	--具体的各个子任务信息

	debugMessage("LadyBugInfoRef")

	self.ladyBugInfos = {}
	if src.ladyBugInfos then
		for i,v in ipairs(src.ladyBugInfos) do
			local p = LadyBugInfoRef.new()
			p:fromLua(v)
			self.ladyBugInfos[i] = p
		end
	end

	-- 排除过高的关卡

	if MetaManager:getInstance().level_area then
		for k, v in pairs(MetaManager:getInstance().level_area) do
			if v.maxLevel == 9999 then
				kMaxLevels = v.minLevel - 1
				break
			end
		end
	end

	-- 更新信息
	self.updateInfo = src.updateInfo
	self.updateReward = src.updateReward
	self.updateRewards = src.updateRewards
	self.sjRewards = src.sjRewards

	self.compens = src.compens
	self.compenText = src.compenText
	self.compenList = src.compenList
	
	-- 
	self.actInfos = src.actInfos

	self.weekMatch = src.weekMatch

	self.payGiftInfo = src.payGiftInfo

	self.lastCheckTime = src.lastCheckTime

	self.userReward = src.userReward
	self.rabbitWeekly = src.rabbitWeekly
	--用户流失类型 RecallRewardType之一
	self.lostType = src.lostType
	-- 用户类型,做白名单判断,普通用户=0
	self.userType = src.userType or 0
	-- 存储在后端的设置 目前用于获取用户支付类型
	self.setting = src.setting or 0
	-- android dime middle energy
	self.dimePlat = src.dimePlat
	if type(self.dimePlat) == "table" then
		for k, v in ipairs(self.dimePlat) do
			self.dimePlat[k] = string.gsub(v, '\"', '')
		end
	else self.dimePlat = {} end
	self.dimeProvince = src.dimeProvince
	if type(self.dimeProvince) == "table" then
		for k, v in ipairs(self.dimeProvince) do
			self.dimeProvince[k] = string.gsub(v, '\"', '')
		end
	else self.dimeProvince = {} end
end

function UserManager:syncUserData( src )
	if src then
		print("sync user data.", self.user.energy, src.energy)
		self.user:setCoin(src.coin)
		self.user.point = src.point
		self.user:setStar(src.star)
		self.user:setHideStar(src.hideStar)
		self.user:setEnergy(src.energy)
		self.user:setTopLevelId(src.topLevelId)
		print("initFromLua sync:"..tostring(self.user:getTopLevelId()).."/"..tostring(#self.scores))
	end
end

function UserManager:correctTopLevelID()
	local topLevelId = self.user:getTopLevelId()
	local passedLevels = 0
	local computedTopLevelID = 0
	for i,v in ipairs(self.scores) do
		if v.star > 0 then passedLevels = passedLevels + 1 end
	end

	print("computed", passedLevels)
	if self:isNewLevelAreaStart(passedLevels + 1) then computedTopLevelID = passedLevels 
	else computedTopLevelID = passedLevels + 1 end

	if topLevelId ~= computedTopLevelID then
		he_log_warning("computed top level id error:"..tostring(computedTopLevelID).."/"..tostring(topLevelId))
		self.user:setTopLevelId(computedTopLevelID)
	end
end
function UserManager:isNewLevelAreaStart( levelId )
	return MetaManager.getInstance():isMinLevelAreaId(levelId)  
end

function UserManager:updateUserData( src )
	if not src then return end
	for i,v in ipairs(self.props) do v:dispose() end

	self.user:fromLua(src.user)
	self.scores = {}
	if src.scores then
		for i,v in ipairs(src.scores) do
			local p = ScoreRef.new()
			p:fromLua(v)
			self.scores[i] = p
		end
	end
	self.props = {}
	if src.props then
		for i,v in ipairs(src.props) do
			local p = PropRef.new()
			p:fromLua(v)
			self.props[i] = p
		end
	end

	if src.requestInfos then
		self.requestInfos = {}
		for i,v in ipairs(src.requestInfos) do
			local p = RequestInfoRef.new()
			p:fromLua(v)
			self.requestInfos[i] = p
		end
	end

	if src.requestNum then
		self.requestNum = src.requestNum
	end
end

function UserManager:getUserRef(...)
	assert(#{...} == 0)

	return self.user
end

function UserManager:getPropRef(...)
	assert(#{...} == 0)

	return self.props
end

function UserManager:removeRequestInfo( infoId )
	local index = -1
	for i,v in ipairs(self.requestInfos) do
		if v.id == infoId then index = i end
	end
  	if index ~= -1 then table.remove(self.requestInfos, index) end
end

--------------------------------------
-----	Function About User Score
-------------------------------------

function UserManager:getScoreRef(...)
	assert(#{...} == 0)
	return self.scores
end

function UserManager:getUserScore( levelId )
	for i,v in ipairs(self.scores) do
		if v.levelId == levelId then return v end
	end
	return nil
end
function UserManager:addUserScore( userscore )
	if self:getUserScore(userscore.levelId) == nil then
		table.insert(self.scores, userscore)
	else
		assert(false)
	end
end

function UserManager:removeUserScore(levelId, ...)
	assert(type(levelId) == "number")
	assert(#{...} == 0)

	for i,v in ipairs(self.scores) do

		if v.levelId == levelId then
			table.remove(self.scores, i)
			return
		end
	end

	assert(false)
end

-----------------------------------
--- Function About Old User Score
------------------------------------

function UserManager:getOldUserScore(levelId, ...)
	assert(type(levelId) == "number")
	assert(#{...} == 0)

	for i,v in ipairs(self.oldScores) do

		if v.levelId == levelId then 
			return v
		end
	end

	return nil
end

function UserManager:addOldUserScore(oldUserScore, ...)
	assert(type(oldUserScore) == "table")
	assert(#{...} == 0)

	if self:getOldUserScore(oldUserScore.levelId) == nil then
		table.insert(self.oldScores, oldUserScore)
	else
		assert(false)
	end
end

function UserManager:removeOldUserScore(levelId, ...)
	assert(type(levelId) == "number")
	assert(#{...} == 0)

	for i,v in ipairs(self.oldScores) do
		if v.levelId == levelId then
			table.remove(self.oldScores, i)
			return
		end
	end

	--assert(false)
end

function UserManager:addUserProp( prop )
	if self:getUserProp(prop.itemId) == nil then
		table.insert(self.props, prop)
	end
end
function UserManager:getUserProp(itemId, ...)
	assert(type(itemId) == "number")
	assert(#{...} == 0)

	for i,v in ipairs(self.props) do
		if v.itemId == itemId then 
			return v 
		end
	end
	return nil
end

function UserManager:setUserPropNumber(itemId, newNumber, ...)
	assert(type(itemId) == "number")
	assert(type(newNumber) == "number")
	assert(newNumber >= 0)
	assert(#{...} == 0)

	for i,v in ipairs(self.props) do
		if v.itemId == itemId then 
			v:setNum(newNumber)
			return
		end
	end
	--assert(false)

	-- Not Record This Prop Before
	-- Add A New Prop Record
	local newProp = PropRef.new()
	newProp.itemId	= itemId
	newProp:setNum(newNumber)

	self:addUserProp(newProp)
end

-- add in ver1.25
function UserManager:addRewards(rewards)
	if type(rewards) == "table" then
		for _, v in pairs(rewards) do
			if v.itemId == 2 then
				self.user:setCoin(self.user:getCoin() + v.num)
			elseif v.itemId == 14 then
				self.user:setCash(self.user:getCash() + v.num)
			else
				self:addUserPropNumber(v.itemId, v.num)
			end
		end
	end
end

function UserManager:getUserPropNumber(itemId, ...)
	assert(type(itemId) == "number")
	assert(#{...} == 0)
	local userProp = self:getUserProp(itemId)
	if userProp then return userProp:getNum() end
	return 0
end

function UserManager:addUserPropNumber(itemId, deltaNumber, ...)
	assert(itemId)
	assert(type(itemId) == "number")
	assert(deltaNumber)
	assert(type(deltaNumber) == "number")
	assert(#{...} == 0)

	if ItemType:isTimeProp(itemId) then
		self:addTimeProp(itemId, deltaNumber)
	else
		local curNumber = self:getUserPropNumber(itemId)
		assert(curNumber)
		local newNumber = curNumber + deltaNumber
		if newNumber < 0 then newNumber = 0 end
		self:setUserPropNumber(itemId, newNumber)
	end
end

function UserManager:timePropsFromServer(timeProps)
	self.timeProps = {}

	if not timeProps then  return end

	for i, v in ipairs(timeProps) do
		local p = TimePropRef.new()
		p:fromLua(v)
		local newProp = true
		-- 合并同一种且过期时间相同的限时道具数量
		for _, prop in pairs(self.timeProps) do
			if prop.itemId == p.itemId and prop.expireTime == p.expireTime then
				prop.num = prop.num + p.num
				newProp = false
			end
		end
		if newProp then
			table.insert(self.timeProps, p)
		end
	end

	self:sortTimeProps()
end

function UserManager:getAndUpdateTimeProps()
	-- print("getAndUpdateTimeProps:", table.tostring(self.timeProps))
	local timeProps = {}
	if #self.timeProps > 0 then
		local curTimeInSec = Localhost:timeInSec()
		for k,v in pairs(self.timeProps) do
			-- 转为s计算更准确
			if math.floor(v.expireTime / 1000) > curTimeInSec and v.num > 0 then
				table.insert(timeProps, v)
			end
		end
	end
	self.timeProps = timeProps

	self:sortTimeProps()
	return self.timeProps
end

-- 将限时道具按过期时间从小到大排列,方便显示和扣除
function UserManager:sortTimeProps()
	table.sort( self.timeProps, function( a, b )
		return a.expireTime < b.expireTime
	end )
end

function UserManager:getTimePropsByRealItemId(realItemId)
	local ret = {}

	for i,v in ipairs(self.timeProps) do
		if v.num > 0 and ItemType:getRealIdByTimePropId(v.itemId) == realItemId then
			local p = TimePropRef.new()
			p:fromLua(v)
			table.insert(ret, p)
		end
	end
	return ret
end

function UserManager:addTimeProp(itemId, num)
	local propMeta = MetaManager:getInstance():getPropMeta(itemId)
	if propMeta and propMeta.expireTime then
		local p = TimePropRef.new()
		p.itemId = itemId
		p.num = num
		p.expireTime = Localhost:time() + propMeta.expireTime
		table.insert(self.timeProps, p)
		self:sortTimeProps()
	end
end

function UserManager:getUserTimePropNumber(itemId)
	local num = 0
	for _,v in pairs(self.timeProps) do
		if v.itemId == itemId then
			num = num + v.num
		end
	end
	return num
end

function UserManager:useTimeProp(itemId)
	-- print("UserManager:useTimeProp:", itemId)
	if self:getUserTimePropNumber(itemId) < 1 then return false end

	for i,v in ipairs(self.timeProps) do
		if itemId == v.itemId and v.num > 0 then
			v.num = v.num - 1
			return true
		end
	end
	return false
end

function UserManager:addUserDeco( deco )
	if self:getUserDeco(deco.itemId) == nil then
		table.insert(self.decos, deco)
	end
end
function UserManager:getUserDeco( itemId )
	for i,v in ipairs(self.decos) do
		if v.itemId == itemId then return v end
	end
	return nil
end


function UserManager:addUserFunc( func )
	if self:getUserFunc(func.itemId) == nil then
		table.insert(self.funcs, func)
	end
end
function UserManager:getUserFunc( itemId )
	for i,v in ipairs(self.funcs) do
		if v.itemId == itemId then return v end
	end
	return nil
end

function UserManager:refreshEnergy()
	local user = UserManager.getInstance().user
	local now = Localhost:time()
	local maxEnergy = MetaManager.getInstance().global.user_energy_max_count or 30
	local userExtend = UserManager.getInstance().userExtend
	local energyPlusEffectTime = userExtend:getEnergyPlusEffectTime()
	local notUsedTime = 0
	local isRefresh = false

	if energyPlusEffectTime > now then
		local propMeta = MetaManager.getInstance():getPropMeta(userExtend.energyPlusId)
		if propMeta then
			maxEnergy = maxEnergy + propMeta.confidence
		end
	elseif userExtend.energyPlusPermanentId > 0 then
		local propMeta = MetaManager.getInstance():getPropMeta(userExtend.energyPlusPermanentId)
		if propMeta then
			maxEnergy = maxEnergy + propMeta.confidence
		end
	end

	if user:getEnergy() < maxEnergy then

		local timePast = now - user:getUpdateTime()
		local user_energy_recover_time_unit = MetaManager.getInstance().global.user_energy_recover_time_unit or 480000
		local energyInc = math.floor(timePast / user_energy_recover_time_unit)

		if energyInc >= 1 then
			if user:getEnergy() + energyInc >= maxEnergy then
				user:setEnergy(maxEnergy)
				user:setUpdateTime(now)
			else
				user:setEnergy(user:getEnergy() + energyInc)
				notUsedTime = timePast % user_energy_recover_time_unit
				user:setUpdateTime(now - notUsedTime)

				notUsedTime = user_energy_recover_time_unit - notUsedTime
			end
			isRefresh = true
		else
			--user:setUpdateTime(now)
			notUsedTime = user_energy_recover_time_unit - timePast
		end
		user.isFull = false
	else
		-- user:getEnergy() >= maxEnergy
		user:setUpdateTime(now)
		user.isFull = true
	end

	return math.floor(notUsedTime / 1000), isRefresh, maxEnergy
end

function UserManager:getDailyBoughtGoodsNumById(goodsId)
	return self:getDailyData():getBuyedGoodsById(goodsId)
end

function UserManager:addBuyedGoods(goodsId, num)
	self:getDailyData():addBuyedGoods(goodsId, num)
end

function UserManager:addBagBuyCountByOne()
	if self.bag.buyCount < 4 then
		self.bag.buyCount = self.bag.buyCount + 1
	end
end

function UserManager:getBagRef()
	return self.bag
end

function UserManager:getWantIds()
	local res = self:getDailyData():getWantIds()
	if type(res) ~= "table" then res = {} end
	return res
end

function UserManager:addWantIds(ids)
	self:getDailyData():addWantIds(ids)
end

function UserManager:sendGiftCount()
	return self:getDailyData():getSendGiftCount()
end

function UserManager:incSendGiftCount()
	self:getDailyData():incSendGiftCount()
end

function UserManager:receiveGiftCount()
	return self:getDailyData():getReceiveGiftCount()
end

function UserManager:incReceiveGiftCount()
	return self:getDailyData():incReceiveGiftCount()
end

function UserManager:decReceiveGiftCount()
	return self:getDailyData():decReceiveGiftCount()
end

function UserManager:getSendIds()
	return self:getDailyData():getSendIds()
end

function UserManager:addSendId(sendId)
	self:getDailyData():addSendId(sendId)
end

function UserManager:removeSendId(sendId)
	self:getDailyData():removeSendId(sendId)
end

function UserManager:getUserExtendRef()
	return self.userExtend
end

function UserManager:isUserRewardBitSet(bitIndex)
	self.userReward = self.userReward or {}
	self.userReward.rewardFlag = self.userReward.rewardFlag or 0
	if bitIndex < 1 then bitIndex = 1 end
	local mask = math.pow(2, bitIndex) -- e.g.: mask: 0010

	local bit = require("bit")
	return mask == bit.band(self.userReward.rewardFlag, mask) -- e.g.:1111 & 0010 = 0010
end

function UserManager:setUserRewardBit(bitIndex, setToTrue)
	self.userReward = self.userReward or {}
	self.userReward.rewardFlag = self.userReward.rewardFlag or 0
	if bitIndex < 1 then bitIndex = 1 end
	local mask = math.pow(2, bitIndex) -- e.g.: maks: 0010
	local bit = require("bit")
	if setToTrue == true or setToTrue == 1 then 
		self.userReward.rewardFlag = bit.bor(self.userReward.rewardFlag, mask) -- e.g. 1100 | 0010 = 1110
	else
		if mask == bit.band(self.userReward.rewardFlag, mask) then 
			self.userReward.rewardFlag = self.userReward.rewardFlag - mask -- e.g.: 1110 - 0010 = 1100
		end
	end
	return self.userReward.rewardFlag
end

function UserManager:getDimePlatforms()
	return self.dimePlat
end

function UserManager:getDimeProvinces()
	return self.dimeProvince
end

---------------------------
--判断后端是否在一个平台
---------------------------
function UserManager:isSameInviteCodePlatform( code )
	-- body
	local function isYYBCode(_code)
		local codeNum = tonumber(_code)
		codeNum = math.floor(codeNum/1000000000)
		-- print(codeNum, type(codeNum)) debug.debug()
		if 1<= codeNum and codeNum <=3 then 
			return true
		end
		return false
	end

	return isYYBCode(code) == isYYBCode(self.inviteCode)
end

function UserManager:isYYBInviteCodePlatform(code)
	code = code or self.inviteCode

	local codeNum = tonumber(code)
	codeNum = math.floor(codeNum/1000000000)
	if 1<= codeNum and codeNum <=3 then 
		return true
	end
	return false
end

function UserManager:setIngameBuyGuide(var)
	self.ingameBuyPropsGuide = var
end

function UserManager:getIngameBuyGuide()
	if self.ingameBuyPropsGuide == 1 then
		self.ingameBuyPropsGuide = 0
		return true
	end
	return false
end