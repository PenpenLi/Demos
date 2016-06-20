-- Filename：	GuildDataModel.lua
-- Author：		Cheng Liang
-- Date：		2013-12-21
-- Purpose：		缓存军团的数据


module("GuildDataModel", package.seeall)

local _isInGuild 			= false -- 是否在军团的相关界面

local va_hall_index 		= 1 	-- 军团大厅的下标
local va_zhongyitang_index 	= 2 	-- 忠义堂的下标
local va_guanyu_index 		= 3 	-- 人鱼咖啡厅的下标
local va_shop_index			= 4		-- 联盟商店的下标
local va_copy_index			= 5		-- 军机大厅（也就是军团副本）的下标
local va_book_index 		= 6 	-- 军团任务（也是就军团任务）的下标

local _mineSigleGuildInfo 	= nil	-- 我自己个人在联盟中的信息
local _guildInfo 			= nil	-- 我所在的军团的信息
local _memberInfoList 		= nil 	-- 成员列表
local m_verifyList			= nil 	-- 审核列表

local _requestMemberDelegate = nil 	-- 拉取成员信息列表


local _guildShopInfo		= nil	-- 联盟商店的信息 


-- 是否在军团界面
function isInGuildFunc()
	return _isInGuild
end

-- 设置是否在军团界面
function setIsInGuildFunc(isInGuild)
	_isInGuild = isInGuild
end

-- 清理缓存
function cleanCache()
	_mineSigleGuildInfo 	= nil
	_guildInfo 				= nil
	_memberInfoList 		= nil
	m_verifyList			= nil

	_requestMemberDelegate = nil
end

-- 设置个人军团信息
function setMineSigleGuildInfo( mineSigleGuildInfo)
	_mineSigleGuildInfo = mineSigleGuildInfo
end

-- 获取个人军团信息
function getMineSigleGuildInfo()
	return _mineSigleGuildInfo
end

function getMineContriType ()
	return _mineSigleGuildInfo.contri_type
end

function setMineContriType(contri_type)
	_mineSigleGuildInfo.contri_type = contri_type
end

function setMineContriTime (contri_time)
	_mineSigleGuildInfo.contri_time = contri_time
end

function getMineContriTime ()
	return _mineSigleGuildInfo.contri_time
end

function getIsHasInGuild( ... )
	if (_mineSigleGuildInfo and _mineSigleGuildInfo.guild_id ~= nil and tonumber(_mineSigleGuildInfo.guild_id) > 0) then
		return true
	end
	return false
end

-- 增减切磋次数
function addPlayDefeautNum( add_times )
	_mineSigleGuildInfo.playwith_num = tonumber(_mineSigleGuildInfo.playwith_num) + add_times
end

-- 设置军团信息
function setGuildInfo( guildInfo)
	_guildInfo = guildInfo
end

-- 获取军团信息
function getGuildInfo()
	return _guildInfo
end

-- 获取军团名称
function getGildName( ... )
	if( not table.isEmpty(_guildInfo) ) then
		return _guildInfo.guild_name
	else
		return nil
	end
end

--获取联盟活跃度
function getGildVitality( ... )
	if( not table.isEmpty(_guildInfo) ) then
		return _guildInfo.vitality
	else
		return 0
	end
end

--获取联盟活跃度
function setGildVitality( _nAddVitality )
	if( not table.isEmpty(_guildInfo) ) then
		_guildInfo.vitality = tonumber(_guildInfo.vitality) + tonumber(_nAddVitality)
	end
end

-- 获取军团战斗力 没有返回nil
function getGildFightForce( ... )
	if( not table.isEmpty(_guildInfo) ) then
		return _guildInfo.fight_force
	else
		return nil
	end
end

-- 获得个人信息中的军团id
function getMineSigleGuildId( ... )
	local guild_id = 0
	if( (not table.isEmpty(_mineSigleGuildInfo)) and _mineSigleGuildInfo.guild_id ~= nil  and tonumber(_mineSigleGuildInfo.guild_id) > 0 ) then
		guild_id = tonumber(_mineSigleGuildInfo.guild_id)
	end
	return guild_id
end

function setMineGuildId( id )
		logger:debug({_mineSigleGuildInfo = _mineSigleGuildInfo})

	if( (not table.isEmpty(_mineSigleGuildInfo)) and _mineSigleGuildInfo.guild_id ~= nil  ) then
		logger:debug({_mineSigleGuildInfo = _mineSigleGuildInfo})
		_mineSigleGuildInfo.guild_id = id
		logger:debug({_mineSigleGuildInfo = _mineSigleGuildInfo})

	end
end

-- 获得军团id, guild_id
function getGuildId( ... )
	local guild_id = 0
	if( (not table.isEmpty(_guildInfo))  and tonumber(_guildInfo.guild_id) > 0 ) then
		guild_id = tonumber(_guildInfo.guild_id)
	end
	return guild_id
end

--增加军团副团长个数
function addGuildVPNum(addVPNum)
	_guildInfo.vp_num = tonumber(_guildInfo.vp_num) + tonumber(addVPNum)
end

-- 获取军团的宣言
function getSlogan()
	return _guildInfo.va_info[va_hall_index].slogan
end

-- 修改军团的宣言
function setSlogan(slogan)
	_guildInfo.va_info[va_hall_index].slogan = slogan
end

-- 获取军团的公告
function getPost()
	return _guildInfo.va_info[va_hall_index].post
end

-- 修改军团的公告
function setPost(post)
	_guildInfo.va_info[va_hall_index].post = post
end

-- 得到军团成员个数
function getGuildMemberNum()
	return tonumber(_guildInfo.member_num)
end

-- 我今天的捐献次数
function getMineDonateTimes()
	return tonumber(_mineSigleGuildInfo.contri_num)
end

-- 增减我今天的捐献次数
function addMineDonateTimes(addLv)
	_mineSigleGuildInfo.contri_num = tonumber(_mineSigleGuildInfo.contri_num) + tonumber(addLv)
end

-- 修改我的权限信息
function changeMineMemberType(m_type)
	_mineSigleGuildInfo.member_type = m_type
end

-- 增减军团成员个数
function addGuildMemberNum( addLv )
	_guildInfo.member_num = tonumber(_guildInfo.member_num) + addLv
end

-- 获取当前 logo
local tempLogo = 1
function getGuildIconId(  )
	if getIsHasInGuild() then
		return _guildInfo.guild_logo or 1
	else
		return tempLogo
	end
end

-- 设置当前logo
function setGuildIconId(logoId)
	if getIsHasInGuild() then
		_guildInfo.guild_logo = logoId
	else
		tempLogo = logoId
	end
end

-- 增加建筑物等级
function addGuildLevelBy( b_type, addLv, addDonate )
	if(b_type == 2)then
		-- 是军团大厅
		_guildInfo.guild_level = tostring( tonumber(_guildInfo.guild_level) + tonumber(addLv) )
	end
	_guildInfo.va_info[b_type].level = tostring( tonumber(_guildInfo.va_info[b_type].level) + tonumber(addLv) )
	_guildInfo.va_info[b_type].allExp = tostring( tonumber(_guildInfo.va_info[b_type].allExp) + tonumber(addDonate) )
end

-- 军团大厅的等级
function getGuildHallLevel()
	if(_guildInfo) then
		return tonumber(_guildInfo.guild_level )
	else
		return 0
	end
end

-- 获得个人总贡献
function getSigleDoante()
	return tonumber(_mineSigleGuildInfo.contri_point)
end

-- 增减个人总贡献
function addSigleDonate(addDonate)
	_mineSigleGuildInfo.contri_point = tonumber(_mineSigleGuildInfo.contri_point) + tonumber(addDonate)
end

-- 增减军团建设度
function addGuildDonate( addDonate )
	_guildInfo.curr_exp = tonumber(_guildInfo.curr_exp) +  tonumber(addDonate)
end

--获得军团建设度
function getGuildDonate()
	return _guildInfo.curr_exp
end

-- 获得关公殿的等级
function getGuanyuTempleLevel()
	return tonumber(_guildInfo.va_info[va_guanyu_index].level)
end

-- 修改关公殿的等级
function addGuanyuTempleLevel( addLv)
	_guildInfo.va_info[va_guanyu_index].level = tonumber(_guildInfo.va_info[va_guanyu_index].level) + tonumber(addLv)
end

-- 获得军团商店的等级
function getShopLevel( )
	return tonumber(_guildInfo.va_info[va_shop_index].level)
end

-- 获得军机大厅的等级
function getCopyHallLevel( ... )
	return tonumber(_guildInfo.va_info[va_copy_index].level)
end

--
function getGuildBookLevel( ... )
	return tonumber(_guildInfo.va_info[va_book_index].level )
end

--军团总参拜次数
function getGuildRewardTimes()
	return tonumber(_guildInfo.reward_num)
end

--增减军团总参拜次数
function addGuildRewardTimes(addTimes)
	_guildInfo.reward_num = tonumber(_guildInfo.reward_num) + tonumber(addTimes)
end

-- 剩余拜关公次数
function getBaiGuangongTimes()
	return tonumber(_mineSigleGuildInfo.reward_num)
end

-- 增减拜关公次数
function addBaiGuangongTimes( addTimes )
	_mineSigleGuildInfo.reward_num = tonumber(_mineSigleGuildInfo.reward_num) + tonumber(addTimes)
	_mineSigleGuildInfo.reward_time = TimeUtil.getSvrTimeByOffset()
end

--金币参拜关公殿次数
function getCoinBaiTimes()
	return tonumber(_mineSigleGuildInfo.reward_buy_num)
end

--增减金币拜关公次数
function addCoinBaiTimes(addTimes)
	_mineSigleGuildInfo.reward_buy_num = tonumber(_mineSigleGuildInfo.reward_buy_num) + tonumber(addTimes)
end

-- 设置成员列表
function setMemberInfoList(memberInfoList)
	_memberInfoList = memberInfoList
end

-- 获取成员列表
function getMemberInfoList()
	return _memberInfoList
end


-- 删除某个成员
function removeOneMember( uid )
	logger:debug("uid: " .. uid)
	logger:debug(_memberInfoList)
	uid = tonumber(uid)
	for k,v in pairs(_memberInfoList.data) do
		if(tonumber(v.uid) == uid )then
			_memberInfoList.data[k] = nil
			break
		end
	end
	logger:debug(_memberInfoList)
end

-- 设置审核列表信息，每条数据只对应列表cell的数据项
function setVerifyList( tbVerify )
	m_verifyList = tbVerify
end

function getVerifyList( ... )
	return m_verifyList
end
-- 根据指定的uid删除相应审核信息
local function removeFromVerifyByUid( sUid )
	local idx = 0
	for i, usr in ipairs(m_verifyList) do
		if (usr.uid == sUid) then
			idx = i
			break
		end
	end
	table.remove(m_verifyList, idx)
end

-- 军团请求回调
function sendRequestMemberCallback(  cbFlag, dictData, bRet  )
	if(dictData.err == "ok")then
		_memberInfoList = dictData.ret
		if(_requestMemberDelegate)then
			_requestMemberDelegate()
		end
	end
end

--- 获取成员列表
function sendRequestForMemberList(requestMemberDelegate)
	_requestMemberDelegate = requestMemberDelegate
	local args = Network.argsHandler(0, 99)
	RequestCenter.guild_getMemberList(sendRequestMemberCallback, args)
end

-- 获取某个成员的信息
function getMemberInfoBy( uid )
	uid = tonumber(uid)
	local m_info = {}
	for k,v in pairs(_memberInfoList.data) do
		if(tonumber(v.uid) == uid )then
			m_info = v
			break
		end
	end

	return m_info
end

--获得军团人数上限
function getMemberLimit()
	return tonumber(_guildInfo.member_limit)
end

function getJoinNum( ... )
	return tonumber(_guildInfo.join_num)
end

-- 获取军团当日已经踢出的人数
function getKickNum( ... )
	return _guildInfo.kick_num and tonumber(_guildInfo.kick_num) or 0
end

function setKickNum( num )
	num = num  or 0
	_guildInfo.kick_num = num
end

-- 获取还能踢出的人数
function getRemainKickNum( ... )
	local info = DB_Legion.getDataById(1)
	local num = tonumber(info.deleteNumLimit) - getKickNum()
	return tonumber(num)
end


-- 设置军团商店
function setShopInfo( shopInfo )
	_guildShopInfo = shopInfo
end

-- 获得军团商店信息
function getShopInfo( )
	return _guildShopInfo
end

-- 获得军团商店珍品信息
function getSpecialGoodsInfo( )
	return _guildShopInfo.special_goods
end

-- 获得军团商店刷新刷新时间
function getShopRefreshCd()
	require "script/utils/TimeUtil"
	local endShieldTime = tonumber(_guildShopInfo.refresh_cd)
	local havaTime = endShieldTime - TimeUtil.getSvrTimeByOffset()
	if(havaTime > 0) then
		return havaTime
	else
		return 0
	end
end

-- 设置军团商店珍品信息和刷新时间
function setSpecialGoodsInfo( special_goods,refreshCd )
	_guildShopInfo.special_goods= special_goods
	_guildShopInfo.refresh_cd= refreshCd
end


--[[
    @des:       通过DB_Legion_goods的id来获得道具中已经购买的次数v{sum ,num}
    			num: 个人购买次数
    			若无则 sum 和num都为 0
]]
function getNorBuyNumById( id)
	local normal_goods= _guildShopInfo.normal_goods
	for goodId,v  in pairs(normal_goods) do
		if(tonumber(goodId) == tonumber(id)) then
			return v
		end
	end
	return {num=0,sum=0 }
end

--[[
    @des:       通过DB_Legion_goods的id来获得珍品已经购买的次数v{sum ,num}
    @return:    sum: 军团购买次数 
    			num: 个人购买次数
    			若无则 sum 和num都为 0
]]
function getSpecialBuyNumById( id)
	local special_goods= _guildShopInfo.special_goods
	for goodId,v  in pairs(special_goods) do
		if(tonumber(goodId) == tonumber(id) and not table.isEmpty(v) ) then
			return v
		end
	end
	return {num=0,sum=0 }
end

--通过ID，设置guildShopInfo 中珍品的
function addSpecialBuyNumById(id,addSum, addNum )
	for goodId,v  in pairs(_guildShopInfo.special_goods) do
		if(tonumber(goodId) == tonumber(id)) then
			if(_guildShopInfo.special_goods[tostring(goodId)].sum) then
				_guildShopInfo.special_goods[tostring(goodId)].sum= _guildShopInfo.special_goods[tostring(goodId)].sum+ addSum
			else
				_guildShopInfo.special_goods[tostring(goodId)].sum= addSum
			end
			if(	_guildShopInfo.special_goods[tostring(goodId)].num) then
				_guildShopInfo.special_goods[tostring(goodId)].num= _guildShopInfo.special_goods[tostring(goodId)].num+ addNum
			else
				_guildShopInfo.special_goods[tostring(goodId)].num= addNum
			end
			ishas = true
		end
	end
end

-- 通过id, 设置
function addNorBuyNumById(id,addSum, addNum )

	local ishas= false

	for goodId,v  in pairs(_guildShopInfo.normal_goods) do
		if(tonumber(goodId) == tonumber(id)) then
			_guildShopInfo.normal_goods[tostring(goodId)].num= _guildShopInfo.normal_goods[tostring(goodId)].num+ addNum
			if(_guildShopInfo.normal_goods[tostring(goodId)].sum) then
				_guildShopInfo.normal_goods[tostring(goodId)].sum= _guildShopInfo.normal_goods[tostring(goodId)].sum+ addSum
			end
			ishas = true
		end
	end

	if(ishas==false) then
		_guildShopInfo.normal_goods[tostring(id)]= {sum= addSum, num = addNum}
	end
end

-- 后端推送商品信息的处理
function addPushGoodsInfo( goodInfo)

	-- 道具处理
	local normal_goods= _guildShopInfo.normal_goods
	for id , v in pairs(goodInfo) do
		-- 判断id是否为道具
		local goodData= DB_Legion_goods.getDataById(id)
		if(goodData.goodType == 2 ) then

			local ishas= false
			for goodId, values in pairs(normal_goods) do
				if(tonumber(id) == tonumber(goodId)) then
					normal_goods[tostring(goodId)].sum = v.sum
					ishas = true
				end
			end
			if(ishas== false) then
				normal_goods[tostring(id)]= { sum = v.sum, num= 0}
			end
		end
	end

	-- 珍品处理
	local special_goods =  _guildShopInfo.special_goods
	for id , v in pairs(goodInfo) do
		local goodData= DB_Legion_goods.getDataById(id)
		if(goodData.goodType == 1 ) then
			for goodId, values in pairs(special_goods) do
				if(tonumber(id) == tonumber(goodId)) then
					special_goods[tostring(goodId)].sum = v.sum
				end
			end
		end
	end

	logger:debug(_guildShopInfo)
end

-- guild  copy 
require "db/DB_Legion_copy_build" 
-- 获取打开联盟副本需要的工会大厅等级	
function getGuildLvToOpenCopy()
	local legionCopyInfo = DB_Legion_copy_build.getDataById(1)
	local openlv = legionCopyInfo.openlv
	return openlv
end


--获取玩家在联盟中的身份，0团员，1团长，2副团
function getUserGuildIdentity()
	return tonumber(_mineSigleGuildInfo.member_type)
end

--获取联盟副本的等级
function getGuildCopyLv()
	-- logger:debug(_guildInfo.va_info[va_copy_index].level)
	-- return tonumber(_guildInfo.va_info[va_copy_index].level)

	if( not table.isEmpty(_guildInfo) ) then
		return tonumber(_guildInfo.va_info[va_copy_index].level)
	else
		return 0
	end
	-- if(_guildInfo.va_info[va_copy_index]) then
	-- 	return tonumber(_guildInfo.va_info[va_copy_index].level)
	-- else
	-- 	return 1
	-- end
end
