require "zoo.util.MemClass"
local uuid = require "hecore.uuid"

local debugDataRef = false

--
-- DataRef ---------------------------------------------------------
--
DataRef = class()
function DataRef:dispose()
end
function DataRef:fromLua( src )
	if not src then
		print("  [WARNING] lua data is nil")
		return
	end

	for k,v in pairs(src) do
		if type(v) ~= "function" then self[k] = v end
		if debugDataRef then print(k, v) end
	end
end

function DataRef:encode()
	local dst = {}
	for k,v in pairs(self) do
		if k ~="class" and v ~= nil and type(v) ~= "function" then dst[k] = v end
	end
	return dst
end
function DataRef:decode(src)
	self:fromLua(src)
end

--
-- ProfileRef ---------------------------------------------------------
--
ProfileRef = class(DataRef)
function ProfileRef:ctor(src)
	self.uid = ""
	self.name = ""
	self.headUrl = "0"
	self.snsId = ""
	if src ~= nil then self:fromLua(src) end
end
function ProfileRef:haveName()
	if self.name and self.name ~= "" then return true
	else return false end
end
function ProfileRef:setDisplayName( name )
	self.name = HeDisplayUtil:urlEncode(name)
end
function ProfileRef:getDisplayName()
	if self:haveName() then return HeDisplayUtil:urlDecode(self.name)
	else return "ID:"..tostring(self.uid) end
end
function ProfileRef:fromLua( src )
	if not src then
		print("  [WARNING] ProfileRef lua data is nil")
		return
	end
	-- print("ProfileRef"..tostring(src.headUrl))
	self.uid = src.uid
	self.name = src.name
	self.headUrl = src.headUrl
	self.snsId = src.snsId
	if self.name == nil then self.name = "" end
	if self.headUrl == nil or self.headUrl == "" then self.headUrl = "" .. math.floor(math.random() * 11) end

	if string.find(self.headUrl, "ani://") ~= nil then
		self.headUrl = string.sub(self.headUrl, 7)
	end
end

--
-- UserRef ---------------------------------------------------------
--
UserRef = class(DataRef) --用户信息
function UserRef:ctor()
	self.uid = 0
	
	self:setCoin(0) --游戏币
	self:setCash(0) --风车币
	self:setEnergy(0) --精力
	self:setStar(0) --总星级
	self:setHideStar(0) --隐藏区域总星级
	self:setTopLevelId(0) --待通过的关卡
	self:setUpdateTime(Localhost:time()) --精力更新时间

	self.point = 0 --积分
	self.image = 0 --玩家 形象

	self.isFriendInfo = false
end
function UserRef:debugPrint(...)
	assert(#{...} == 0)

	print("======= UserRef:debugPrint =========")
	print("uid: " .. self.uid)
	print("star: " .. self:getStar())
	print("hideStar: " .. self:getHideStar())
	print("topLevelId: " .. self:getTopLevelId())
	print("image: " .. self.image)
end

function UserRef:fromLua( src )
	if not src then
		print("  [WARNING] lua data is nil at UserRef:fromLua")
		return
	end

	for k,v in pairs(src) do		
		if k == "coin" then self:setCoin(v)
		elseif k == "cash" then self:setCash(v)	
		elseif k == "topLevelId" then self:setTopLevelId(v)	
		elseif k == "star" then self:setStar(v)	
		elseif k == "hideStar" then self:setHideStar(v)	
		elseif k == "energy" then self:setEnergy(v)	
		elseif k == "updateTime" then self:setUpdateTime(v)	
		else 
			if type(v) ~= "function" then self[k] = v end
			if debugDataRef then print(k, v) end
		end
	end
	local updateTime = tonumber(self.updateTime) or Localhost:time()
	-- print("User->fromLua, updateTime: ", updateTime, os.date(nil, updateTime / 1000), " energy:", self.energy)
end

function UserRef:getCoin()
	local key = "UserRef.coin"..tostring(self)
	return decrypt_integer(key)
end
function UserRef:setCoin(v)
	local key = "UserRef.coin"..tostring(self)
	self.coin = v --onlu used for encode
	encrypt_integer(key, v)
end

function UserRef:getCash()
	local key = "UserRef.cash"..tostring(self)
	return decrypt_integer(key)
end
function UserRef:setCash(v)
	local key = "UserRef.cash"..tostring(self)
	self.cash = v --onlu used for encode
	encrypt_integer(key, v)
end

function UserRef:getTopLevelId()
	local key = "UserRef.topLevelId"..tostring(self)
	local level = decrypt_integer_f(key)
	if level > kMaxLevels then level = kMaxLevels end
	return level
end
function UserRef:setTopLevelId(v)
	local key = "UserRef.topLevelId"..tostring(self)
	self.topLevelId = v --onlu used for encode
	encrypt_integer_f(key, v)
end

function UserRef:getStar()
	local key = "UserRef.star"..tostring(self)
	return decrypt_integer(key)
end
function UserRef:setStar(v)
	local key = "UserRef.star"..tostring(self)
	self.star = v --onlu used for encode
	encrypt_integer(key, v)
end

function UserRef:getHideStar()
	local key = "UserRef.hideStar"..tostring(self)
	return decrypt_integer(key)
end
function UserRef:setHideStar(v)
	local key = "UserRef.hideStar"..tostring(self)
	self.hideStar = v --onlu used for encode
	encrypt_integer(key, v)
end

function UserRef:getEnergy()
	local key = "UserRef.energy"..tostring(self)
	return decrypt_integer_f(key)
end
function UserRef:setEnergy(v)
	local key = "UserRef.energy"..tostring(self)
	self.energy = v --onlu used for encode
	encrypt_integer_f(key, v)
end

function UserRef:getUpdateTime()
	local key = "UserRef.updateTime"..tostring(self)
	return decrypt_number(key)
end
function UserRef:setUpdateTime(v)
	local key = "UserRef.updateTime"..tostring(self)
	v = tonumber(v) or Localhost:time() --onlu used for encode
	self.updateTime = v
	encrypt_number(key, v)
end

function UserRef:encode()
	local dst = {}
	self.updateTime = self:getUpdateTime()
	self.energy = self:getEnergy()
	self.hideStar = self:getHideStar()
	self.star = self:getStar()
	self.topLevelId = self:getTopLevelId()
	self.cash = self:getCash()
	self.coin = self:getCoin()

	for k,v in pairs(self) do
		if k ~="class" and v ~= nil and type(v) ~= "function" then dst[k] = v end
	end
	return dst
end

function UserRef:getTotalStar( ...)
	assert(#{...} == 0)

	local usrTotalStar = tonumber(self:getStar()) + tonumber(self:getHideStar())
	return usrTotalStar
end

function UserRef:addEnergy(energyToAdd, ...)
	assert(energyToAdd)
	assert(type(energyToAdd) == "number")
	assert(#{...} == 0)

	--local newEnergy = self:getEnergy() + energyToAdd
	--he_log_warning("hard coded max energy value !")
	--if newEnergy > 30 then
	--	newEnergy = 30
	--end
	--self:setEnergy(newEnergy)

	print("deprecated function, use UserEnergyRecoverManager:addEnergy instead !")
	UserEnergyRecoverManager:sharedInstance():addEnergy(energyToAdd)
end

--
-- UserExtendRef ---------------------------------------------------------
--
UserExtendRef = class(DataRef) --用户相关扩展信息
function UserExtendRef:ctor( )
	self:setFruitTreeLevel(0) --金银果树级别
	self:setStarReward(0) --已领取的星级奖励
	self:setNewUserReward(0) --新手奖: 1,领过；0，未领
	self:setEnergyPlusEffectTime(0) --精力值额外加值有效时间戳
	self:setNotConsumeEnergyBuff(0) --无限精力值buff 有效时间戳

	self.qqVipNewComeReward = false --qq 新手礼包领取标识
	self.appOnQQPanel = false -- 用户是否将应用图标添加到qq 主面板
	self.appOnQQPanelRewardMark = 0 --用户是否领取将应用图标添加到qq 主面板的奖励: 1,领过；0，未领
	self.ladyBugStart = 0 --是否开启瓢虫任务, 0:未开启, 1:已开启
	self.goldTicket = 0 --用户的金券余额
	self.energyPlusId = 0 --精力值临时额外加值 道具Id
	self.energyPlusPermanentId = 0 --精力值永久额外加值 道具Id
	self.activityMark = 0 --活动弹板mark
	self.scoreGameReward = 0 --评分领奖标识
	self.tutorialStep = 0 --新手引导步骤
	self.playStep = 0 --玩法引导步骤
	self.topLevelFailCount = 0 -- 最高关卡连续失败次数
end

function UserExtendRef:getFruitTreeLevel()
	local key = "UserExtendRef.fruitTreeLevel"..tostring(self)
	return decrypt_integer(key)
end
function UserExtendRef:setFruitTreeLevel( v )
	local key = "UserExtendRef.fruitTreeLevel"..tostring(self)
	self.fruitTreeLevel = v --onlu used for encode
	encrypt_integer(key, v)
end

function UserExtendRef:getStarReward()
	local key = "UserExtendRef.starReward"..tostring(self)
	return decrypt_integer(key)
end
function UserExtendRef:setStarReward( v )
	local key = "UserExtendRef.starReward"..tostring(self)
	self.starReward = v --onlu used for encode
	encrypt_integer(key, v)
end

function UserExtendRef:getNewUserReward()
	local key = "UserExtendRef.newUserReward"..tostring(self)
	return decrypt_integer(key)
end
function UserExtendRef:setNewUserReward( v )
	local key = "UserExtendRef.newUserReward"..tostring(self)
	self.newUserReward = v --onlu used for encode
	encrypt_integer(key, v)
end

function UserExtendRef:setEnergyPlusEffectTime( v )
	if v == nil then v = 0 end
	v = tonumber(v)
	local key = "UserExtendRef.energyPlusEffectTime"..tostring(self)
	self.energyPlusEffectTime = v
	encrypt_number(key, v)
end
function UserExtendRef:getEnergyPlusEffectTime()
	local key = "UserExtendRef.energyPlusEffectTime"..tostring(self)
	return decrypt_number(key) or 0
end

function UserExtendRef:setNotConsumeEnergyBuff( v )
	if v == nil then v = 0 end
	v = tonumber(v)
	local key = "UserExtendRef.notConsumeEnergyBuff"..tostring(self)
	self.notConsumeEnergyBuff = v
	encrypt_number(key, v)
end
function UserExtendRef:getNotConsumeEnergyBuff()
	local key = "UserExtendRef.notConsumeEnergyBuff"..tostring(self)
	if PublishActUtil:isGroundPublish() then
		oneMoreDay = math.floor(Localhost:time()) + 5*60*1000
		return oneMoreDay
	else
		return decrypt_number(key) or 0
	end
end

function UserExtendRef:isStarRewardReceived(rewardLevel, ...)
	assert(type(rewardLevel) == "number")
	assert(#{...} == 0)

	local mask = bit.lshift(1, rewardLevel)
	local result = bit.band(self:getStarReward(), mask)
	return result > 0 
end

function UserExtendRef:setRewardLevelReceived(rewardLevel, ...)
	assert(type(rewardLevel) == "number")
	assert(#{...} == 0)

	if self:isStarRewardReceived(rewardLevel) then assert(false) end
	local mask = bit.lshift(1, rewardLevel)
	self:setStarReward(bit.bor(self:getStarReward(), mask))
end

function UserExtendRef:getFirstNotReceivedRewardLevel(rewardLevel, ...)
	assert(#{...} == 0)
	for index = 1, rewardLevel do
		if not self:isStarRewardReceived(index) then return index end
	end
	return false
end

function UserExtendRef:hasEnteredInviteCode()
	if not self.flag then return false end
	local bit = require("bit")
	return 1 == bit.band(self.flag, 0x01)
end

function UserExtendRef:setEnteredInviteCode(isSet)
	if not self.flag then return end
	local bit = require("bit")
	if isSet then
		self.flag = bit.bor(self.flag, 0x01)
	else
		if 1 == bit.band(self.flag, 0x01) then 
			self.flag = self.flag - 1
		end
	end
end

function UserExtendRef:isFlagBitSet(bitIndex)
	self.flag = self.flag or 0
	if bitIndex < 1 then bitIndex = 1 end
	local mask = math.pow(2, bitIndex - 1) -- e.g.: mask: 0010

	local bit = require("bit")
	return mask == bit.band(self.flag, mask) -- e.g.:1111 & 0010 = 0010
end

function UserExtendRef:setFlagBit(bitIndex, setToTrue)
	self.flag = self.flag or 0
	if bitIndex < 1 then bitIndex = 1 end
	local mask = math.pow(2, bitIndex - 1) -- e.g.: maks: 0010
	local bit = require("bit")
	if setToTrue == true or setToTrue == 1 then 
		self.flag = bit.bor(self.flag, mask) -- e.g. 1100 | 0010 = 1110
	else
		if mask == bit.band(self.flag, mask) then 
			self.flag = self.flag - mask -- e.g.: 1110 - 0010 = 1100
		end
	end
	return self.flag
end

function UserExtendRef:getLastPayTime()
	return self.lastPayTime or 0
end

function UserExtendRef:setLastPayTime(time)
	if type(time) == "number" then
		self.lastPayTime = time
	end
end

-- 在开始游戏时就记为失败，成功过关后清除
function UserExtendRef:incrTopLevelFailCount(count)
	count = count or 1
	self.topLevelFailCount = self.topLevelFailCount + count
end

function UserExtendRef:resetTopLevelFailCount()
	self.topLevelFailCount = 0
end

function UserExtendRef:fromLua( src )
	if not src then
		print("  [WARNING] lua data is nil at UserExtendRef:fromLua")
		return
	end

	for k,v in pairs(src) do
		if k == "fruitTreeLevel" then self:setFruitTreeLevel(v)		
		elseif k == "starReward" then self:setStarReward(v)
		elseif k == "newUserReward" then self:setNewUserReward(v)
		elseif k == "energyPlusEffectTime" then self:setEnergyPlusEffectTime(v)
		elseif k == "notConsumeEnergyBuff" then self:setNotConsumeEnergyBuff(v)
		else 
			if type(v) ~= "function" then self[k] = v end
			if debugDataRef then print(k, v) end
		end
	end
	if src.notConsumeEnergyBuff == nil then  self:setNotConsumeEnergyBuff(0) end
	if src.energyPlusEffectTime == nil then  self:setEnergyPlusEffectTime(0) end
	if src.newUserReward == nil then  self:setNewUserReward(0) end
end

function UserExtendRef:encode()
	local dst = {}
	self.fruitTreeLevel = self:getFruitTreeLevel()
	self.starReward = self:getStarReward()
	self.newUserReward = self:getNewUserReward()
	self.energyPlusEffectTime = self:getEnergyPlusEffectTime()
	self.notConsumeEnergyBuff = self:getNotConsumeEnergyBuff()
	for k,v in pairs(self) do
		if k ~="class" and v ~= nil and type(v) ~= "function" then dst[k] = v end
	end
	return dst
end

--
-- PropRef ---------------------------------------------------------
--
PropRef = class(DataRef) --道具
function PropRef:ctor()
	self.itemId = 0 --道具id
	self.num = 0 --道具数量
end
function PropRef:dispose()
	local key = "PropRef.num."..tostring(self.itemId)..tostring(self)
	HeMemDataHolder:deleteByKey(key)
end
function PropRef:getNum()
	local key = "PropRef.num."..tostring(self.itemId)..tostring(self)
	return decrypt_integer(key)
end
function PropRef:setNum( v )
	local key = "PropRef.num."..tostring(self.itemId)..tostring(self)
	self.num = v --onlu used for encode
	encrypt_integer(key, v)
end

function PropRef:fromLua( src )
	if not src then
		print("  [WARNING] lua data is nil at PropRef:fromLua")
		return
	end
	self.itemId = src.itemId
	self:setNum(src.num)
end

function PropRef:encode()
	local dst = {}
	dst.itemId = self.itemId
	dst.num = self:getNum()
	return dst
end

------------------------
-- 限时道具
------------------------
TimePropRef = class(DataRef)
function TimePropRef:ctor( ... )
	self.itemId = 0
	self.num = 0
	self.expireTime = 0
end

function TimePropRef:fromLua(src)
	self.itemId = src.itemId
	self.num = src.num or 1 -- 现在没有数量，默认1
	self.expireTime = tonumber(src.expireTime)
end

function TimePropRef:encode()
	local dst = {}
	dst.itemId = self.itemId
	dst.num = self.num
	dst.expireTime = self.expireTime
	return dst
end

--
-- FuncRef ---------------------------------------------------------
--
FuncRef = class(DataRef) --功能包
function FuncRef:ctor()
	self.itemId = 0 --功能包id
	self.num = 0 --功能包数量
end
function FuncRef:getNum()
	local key = "FuncRef.num."..tostring(self.itemId)..tostring(self)
	return decrypt_integer(key)
end
function FuncRef:setNum( v )
	local key = "FuncRef.num."..tostring(self.itemId)..tostring(self)
	self.num = v --onlu used for encode
	encrypt_integer(key, v)
end
function FuncRef:fromLua( src )
	if not src then
		print("  [WARNING] lua data is nil at FuncRef:fromLua")
		return
	end
	self.itemId = src.itemId
	self:setNum(src.num)
end

function FuncRef:encode()
	local dst = {}
	dst.itemId = self.itemId
	dst.num = self:getNum()
	return dst
end

--
-- DecoRef ---------------------------------------------------------
--
DecoRef = class(DataRef) --装扮
function DecoRef:ctor()
	self.itemId = 0 --装扮id
	self.num = 0 --装扮数量
end

function DecoRef:getNum()
	local key = "DecoRef.num."..tostring(self.itemId)..tostring(self)
	return decrypt_integer(key)
end
function DecoRef:setNum( v )
	local key = "DecoRef.num."..tostring(self.itemId)..tostring(self)
	self.num = v --onlu used for encode
	encrypt_integer(key, v)
end
function DecoRef:fromLua( src )
	if not src then
		print("  [WARNING] lua data is nil at DecoRef:fromLua")
		return
	end
	self.itemId = src.itemId
	self:setNum(src.num)
end

function DecoRef:encode()
	local dst = {}
	dst.itemId = self.itemId
	dst.num = self:getNum()
	return dst
end
--
-- ScoreRef ---------------------------------------------------------
--
ScoreRef = class(DataRef) --用户关卡得分
function ScoreRef:ctor()
	self.uid = 0 --uid
	self.levelId = 0 --关卡id
	self.score = 0 --最高得分
	self.star = 0 --最高星级
	self.updateTime = 0 --上次更新时间
end

--
-- AchiRef ---------------------------------------------------------
--
AchiRef = class(DataRef) --成就
function AchiRef:ctor()
	self.achiId = 0 --成就id
	self.count = 0 --成就数量
end

function AchiRef:getCount()
	local key = "AchiRef.num."..tostring(self.achiId)..tostring(self)
	return decrypt_integer(key)
end
function AchiRef:setCount( v )
	local key = "AchiRef.num."..tostring(self.achiId)..tostring(self)
	self.count = v --onlu used for encode
	encrypt_integer(key, v)
end
function AchiRef:fromLua( src )
	if not src then
		print("  [WARNING] lua data is nil at AchiRef:fromLua")
		return
	end
	self.achiId = src.achiId
	self:setCount(src.count)
end

function AchiRef:encode()
	local dst = {}
	dst.achiId = self.achiId
	dst.count = self:getCount()
	return dst
end
--
-- RequestInfoRef ---------------------------------------------------------
--
RequestInfoRef = class(DataRef)
function RequestInfoRef:ctor( )
	self.senderUid = 0 --senderUid
	self.type = 0 --请求类系：1,赠送礼物;2,索要礼物;3,区域解锁的请求;4,索要精力值请求
	self.id = 0 --request消息的id
	self.itemId = 0 --请求物品的id
	self.itemNum = 0 --请求物品的数量
end

--
-- UnLockFriendInfoRef ---------------------------------------------------------
--
UnLockFriendInfoRef = class(DataRef) --区域解锁请求消息
function UnLockFriendInfoRef:ctor( )
	self.id = 0 --区域id
	self.friendUids = {} --已同意请求的 好友id
end

--
-- LadyBugInfoRef ---------------------------------------------------------
--
LadyBugInfoRef = class(DataRef) --瓢虫任务-子任务具体内容
function LadyBugInfoRef:ctor()
	self.id = 0 --任务id
	self.startTime = 0 --任务开始时间，毫秒数
	self.reward = 0 --奖励是否领取 0：未领取，1：已领取
	self.canReward = 0 --是否可以领取奖励
	self.endTime	= 0	-- Task End Time In Unix Time, Unit Is Millisecond
end

function LadyBugInfoRef:debugPrint()

	print("LadyBugInfoRef:debugPrint Called !")
	print("id: " 		.. self.id)
	print("startTime: " 	.. self.startTime)
	print("reward: " 	.. tostring(self.reward))
	print("canReward: " 	.. tostring(self.canReward))
end

--
-- BagRef ---------------------------------------------------------
--
GoodsInfoRef = class(DataRef)
function GoodsInfoRef:ctor()
	self.goodsId = 0
	self.num = 0
end

--
-- BagRef ---------------------------------------------------------
--
BagRef = class(DataRef) --背包
function BagRef:ctor()
	self.uid = 0 --uid
	self.friendSize = 0 --好友方式开启的个数
	self.buyCount = 0 --Q点购买的次数
end

--
-- MarkRef ---------------------------------------------------------
--
MarkRef = class(DataRef) --签到信息
function MarkRef:ctor( )
	self.uid = 0 --用户id
	self.addNum = 0 --已补签次数
	self.markNum = 0 --签到次数
	self.markTime = 0 --上次签到时间
	self.createTime = 0 --用户创建当天的零点
end

--
-- DailyDataRef ---------------------------------------------------------
--
DailyDataRef = class(DataRef) --用户每日数据(每日重置)
function DailyDataRef:ctor( )
	self.sendGiftCount = 0 --当天已发送礼物数
	self.receiveGiftCount = 0 --当天已接收礼物数
	self.wantIds = {} --当天发送过索要的好友id列表
	self.unLockLevelAreaRequestCount = 0 --当天区域解锁已发送请求次数
	self.inviteFriend = false --当天是否已邀请过好友（通过分组邀请面板）
	self.mark = false --今天是否签到
	self.energyRequestCount = 0 --用户当天已索要精力次数
	self.qqVipDailyReward = false --黄钻、蓝钻每日普通奖励是否领取
	self.qqGameVipYearDailyReward = false --蓝钻年费每日奖励是否领取
	self.qqGameVipSuperDailyReward = false --蓝钻超级每日奖励是否领取
	self.pickFruitCount = 0 --当天已采摘金银果实数目
	self.buyedGoodsInfo = {} --当日已购买商品详情
	self.diggerCount = 0 --挖宝大赛当天已挖宝次数
	self.sendIds = {}
	self.videoAdRewardLeft = 0  ---每日观看广告视频剩余次数
	self.videoAdReward = {}     --- 观看广告视频奖励
	self.videoAdCycle = {}      ---不同视频广告的循环规则
	
end
function DailyDataRef:resetAll()
	self.sendGiftCount = 0
	self.receiveGiftCount = 0
	self.wantIds = {}
	self.unLockLevelAreaRequestCount = 0
	self.inviteFriend = false
	self.mark = false
	self.energyRequestCount = 0
	self.qqVipDailyReward = false
	self.qqGameVipYearDailyReward = false
	self.qqGameVipSuperDailyReward = false
	self.pickFruitCount = 0
	self.buyedGoodsInfo = {}
	self.diggerCount = 0
	self.sendIds = {}
	self.videoAdRewardLeft = 0 
	self.videoAdReward = {}
	self.videoAdCycle = {}
end
function DailyDataRef:fromLua( src )
	if not src then
		print("  [WARNING] lua data is nil at DailyDataRef:fromLua")
		return
	end

	self.buyedGoodsInfo = {}

	for k,v in pairs(src) do
		if k == "buyedGoodsInfo" then
			if src.buyedGoodsInfo then
				for ib,vb in ipairs(src.buyedGoodsInfo) do
					local p = GoodsInfoRef.new()
					p:fromLua(vb)
					self.buyedGoodsInfo[ib] = p
				end
			end
		else 
			if type(v) ~= "function" then self[k] = v end
			if debugDataRef then print(k, v) end
		end
	end
end
function DailyDataRef:encode()
	local dst = {}
	for k,v in pairs(self) do
		-- if k == "buyedGoodsInfo" then
		-- 	local buyedGoodsInfoEncoded = {}
		-- 	for idx,bvx in ipairs(self.buyedGoodsInfo) do
		-- 		buyedGoodsInfoEncoded[idx] = bvx:encode()
		-- 	end
		-- 	dst["buyedGoodsInfo"] = buyedGoodsInfoEncoded
		-- else
			if k ~="class" and v ~= nil and type(v) ~= "function" then dst[k] = v end
		-- end
	end
	return dst
end

function DailyDataRef:addBuyedGoods(iGoodsId, iNum)
	for __, v in ipairs(self.buyedGoodsInfo) do
		if v.goodsId == iGoodsId then
			v.num = v.num + iNum
			return
		end
	end
	table.insert(self.buyedGoodsInfo, {goodsId = iGoodsId, num = iNum})
end

function DailyDataRef:getBuyedGoodsById(goodsId)
	for __, v in ipairs(self.buyedGoodsInfo) do
		if v.goodsId == goodsId then return v.num end
	end
	return 0
end

function DailyDataRef:getWantIds()
	return self.wantIds
end

function DailyDataRef:addWantIds(ids)
	local function addWandId(id)
		for k, v in ipairs(self.wantIds) do
			if tonumber(v) == id then return end
		end
		table.insert(self.wantIds, id)
	end
	for k, v in ipairs(ids) do
		addWandId(v)
	end
end

function DailyDataRef:getSendGiftCount()
	if self.sendIds and type(self.sendIds) == 'table' then
		return #self.sendIds
	else 
		return 0 
	end
	-- return self.sendGiftCount
end

function DailyDataRef:incSendGiftCount()
	-- self.sendGiftCount = self.sendGiftCount + 1
end


function DailyDataRef:getReceiveGiftCount()
	return self.receiveGiftCount
end

function DailyDataRef:incReceiveGiftCount()
	self.receiveGiftCount = self.receiveGiftCount + 1
end

function DailyDataRef:decReceiveGiftCount()
	self.receiveGiftCount = self.receiveGiftCount - 1
end


function DailyDataRef:getSendIds()
	return self.sendIds
end

function DailyDataRef:addSendId(sendId)
	if self.sendIds and type(self.sendIds) == 'table' then
		table.insert(self.sendIds, sendId)
	end
end

function DailyDataRef:removeSendId(sendId)
	if self.sendIds and type(self.sendIds) == 'table' then 
		for i, v in pairs(self.sendIds) do 
			if v == sendId then
				table.remove(self.sendIds, i)
				return 
			end
		end
	end
end

---------------------------------------------------
-------------- LeaveArea
---------------------------------------------------

he_log_warning("used in code ?")
assert(not LeaveArea)
LeaveArea = class()

function LeaveArea:init(levelAreaId, ...)
	assert(type(levelAreaId) == "number")
	assert(#{...} == 0)

	self.levelAreaId = levelAreaId
	
end

function LeaveArea:create(levelAreaId, ...)
	assert(#{...} == 0)

	local newLeaveArea = LeaveArea.new()
	newLeaveArea:init(levelAreaId)
	return newLeaveArea
end


---------------------------------------------------
-------------- UnlockFriendInfo
---------------------------------------------------

UnlockFriendInfo = class(DataRef)

function UnLockFriendInfoRef:ctor(...)
	assert(#{...} == 0)
	
	self.id	= 0			-- Locked Area Id
	self.friendUids = {}
end

--
-- LevelDataInfo ---------------------------------------------------------
--
local kMaxComboStoreTime = 24 * 60 * 60 * 1000
LevelDataInfo = class(DataRef)
function LevelDataInfo:ctor()
	self.maxConbo = 0
	self.comboStartTime = 0
	self.levels = {}
end
function LevelDataInfo:getLevelInfo( levelId )
	local key = tostring(levelId)
	local level = self.levels[key]
	if level == nil then 
		level = {playTimes = 0, win = 0, failTimes = 0, lastUpdateTime = os.time(), createTime = os.time()}
		self.levels[key] = level
	end
	return level
end
function LevelDataInfo:onLevelWin( levelId, score )
	local now = os.time()
	local level = self:getLevelInfo(levelId)
	local winBefore = level.win

	if self.maxConbo > 15 then self.maxConbo = 0 end

	local comboStartTime = self.comboStartTime
	if now - comboStartTime > kMaxComboStoreTime then
		self.maxConbo = 0
		self.comboStartTime = 0
	end
	
	if winBefore == 0 then
		if self.maxConbo == 0 then self.comboStartTime = now end
		self.maxConbo = self.maxConbo + 1
	end

	level.win = 1
	level.playTimes = level.playTimes + 1
	level.lastUpdateTime = now
end
function LevelDataInfo:onLevelFail( levelId, score )
	self.maxConbo = 0
	self.comboStartTime = 0
	local level = self:getLevelInfo(levelId)
	level.lastUpdateTime = os.time()
	level.playTimes = level.playTimes + 1
	level.failTimes = level.failTimes + 1
end


--
-- HttpDataInfo ---------------------------------------------------------
--
HttpDataInfo = class(DataRef)
function HttpDataInfo:ctor()
	self.list = {}
end
local function updateHttpDataID( data )
	if data and data.endpoint and not data.id then
		data.id = uuid:getUUID()
	end
end
function HttpDataInfo:add( endpoint, body )
	local data = {endpoint=endpoint, body=body}
	self.list = self.list or {}
	table.insert(self.list, data)
	updateHttpDataID(data)
end
function HttpDataInfo:fromLua( src )
	if not src then return end
	self.list = src
	for i,v in ipairs(self.list) do updateHttpDataID(v) end
end

function HttpDataInfo:encode()
	return self.list
end
function HttpDataInfo:decode(src)
	self:fromLua(src)
end

DigJewelCount = class(DataRef)

function DigJewelCount:ctor()
	self:setValue(0)
end
function DigJewelCount:setValue(value)
	local key = "DigJewelCount.digJewelCount"..tostring(self)
	self.digJewelCount = value
	encrypt_integer(key, value)
end
function DigJewelCount:getValue()
	local key = "DigJewelCount.digJewelCount"..tostring(self)
	return decrypt_integer(key)
end

RabbitCount = class(DataRef)

function RabbitCount:ctor()
	self:setValue(0)
end
function RabbitCount:setValue(value)
	local key = "RabbitCount.rabbitCount"..tostring(self)
	self.rabbitCount = value
	encrypt_integer(key, value)
end
function RabbitCount:getValue()
	local key = "RabbitCount.rabbitCount"..tostring(self)
	return decrypt_integer(key)
end