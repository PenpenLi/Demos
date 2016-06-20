-- FileName: RewardCenterModel.lua
-- Author: huxiaozhou
-- Date: 2014-05-26
-- Purpose: function description of module
--[[TODO List]]

-- copy_get_reward.json

module("RewardCenterModel", package.seeall)

-- 模块局部变量 --

local m_i18n = gi18n
local m_i18nString = gi18nString

tbSubListView = {}


local tbRewardList = {}


--奖励类型  ---- 三国前后端约定好端 id 类型
local tbRewardClass = { -- 2,3,7
--"首充奖励",						--1 
m_i18n[3307],
-- "竞技场幸运排名",					--2
m_i18n[2216],
-- "竞技场奖励",						--3
m_i18n[3308],
-- "资源矿奖励",						--4
m_i18n[3309],
-- "青龙魔神奖励",					--5
m_i18n[3310],
-- "青龙魔神击杀奖励",				--6
m_i18n[3311],
-- "占星奖励",						--7
m_i18n[3312],
-- {"系统补偿","每日登录回馈"},		--8
{m_i18n[3313],m_i18n[3314]},
-- "比武排行奖励",					--9
m_i18n[3315],
-- "累积充值奖励",					--10
m_i18n[3316],
-- "酒馆十连抽",						--11
m_i18n[3317],
-- 系统发给个人的奖励,								--2014-08-12
m_i18n[2118],						--12
-- "活动卡包积分奖励",				--13
m_i18n[3318],
-- "活动卡包排名奖励",				--14
m_i18n[3319],
-- "试练塔奖励",						--15
m_i18n[3320],
-- "vip每日福利",					--16
m_i18n[3321],
-- "签到奖励",						--17
m_i18n[1903],
-- -- "每日任务领取奖励",               
-- m_i18n[3322],
-- 探险奖励
m_i18n[3343],                     --18
m_i18n[3322],						-- 19每日任务奖励
m_i18n[5511],								--20爬塔排名奖励
m_i18n[3346],					-- 21 伙伴影子副本奖励
m_i18n[3348],--22
m_i18n[3350],--23
m_i18n[3352],--24
m_i18n[3354],--25
m_i18n[3356],--26
m_i18n[3358],--月卡
m_i18n[3307],--首冲奖励
 m_i18n[8112],       -- 29;   //巅峰对决押注奖励
  m_i18n[8110],       -- 30;   //巅峰对决排名奖励
  m_i18n[8106],     -- 31;   //巅峰对决击杀奖励
  m_i18n[8108],     -- 32;   //巅峰对决连杀奖励
}	

local tbRewardContent = {
	-- "感谢您对我们的支持，现为您准备了首充礼包，奖励如下：",
	m_i18n[3323],
	-- "恭喜您在竞技场中获得了幸运排名{0}，获得幸运奖励如下：", --2
	m_i18n[3324],
	-- "恭喜您在竞技场中取得了{0}名的成绩，获得奖励如下：", --3
	m_i18n[3325],
	-- "恭喜您占领的资源矿已到期，获得奖励贝里数如下：",
	m_i18n[3326],
	-- "恭喜您在本次进击的魔神中取得优异成绩，获得奖励如下：",
	m_i18n[3327],
	-- "恭喜您在本次进击的魔神中击杀了青龙魔神，获得击杀奖励如下：",
	m_i18n[3328],
	-- "当前您有占星奖励在更新前没有领取，请领取占星奖励，奖励如下：", -- 7
	m_i18n[3329],
	-- {"很抱歉因一些问题影响到您的游戏体验，特发游戏补偿如下：","活动期间，为您准备了每日登录回馈，奖励如下："},
	{m_i18n[3330],m_i18n[3331]},
	-- "恭喜您在本次比武中取得了{0}名的成绩，获得奖励如下：",
	m_i18n[3332],
	-- "感谢您对我们的支持，活动期间累积充值满2000金币，额外获得以下奖励：",
	m_i18n[3333],
	-- "感谢您对我们的支持，活动期间为您准备了首次10连抽礼包，奖励如下：", --11
	m_i18n[3330],
	-- "",
	m_i18n[3334],
	-- "恭喜您在活动卡报中获得积分{0}，获得积分奖励如下：", 13
	m_i18n[3335],
	-- "恭喜您在活动卡报中获得积分排名第{0}，获得排名奖励如下：", 
	m_i18n[3336],
	-- "恭喜您在试练塔中获得如下奖励：", 15
	m_i18n[3337],
	-- "",		
	m_i18n[3345],
	-- "",
	m_i18n[3344],
	
	m_i18n[3342], -- 您有未领取的探险惊喜奖励，请领取奖励 18
	m_i18n[3338],    --19 //每日任务奖励
	m_i18n[5510],	-- 空洞啊爬塔奖励
	m_i18n[3347],					-- 21 伙伴影子副本奖励
	m_i18n[3349],--22
	m_i18n[3351],--23
	m_i18n[3353],--24
	m_i18n[3355],--25
	m_i18n[3357],--26
	m_i18n[3359],--月卡
	m_i18n[3360],--//首冲奖励
	 m_i18n[8112],               -- 29;   //巅峰对决押注奖励
	  m_i18n[8111],         -- 30;   //巅峰对决排名奖励
	  m_i18n[8107],       -- 31;   //巅峰对决击杀奖励
	  m_i18n[8109],       -- 32;   //巅峰对决连杀奖励
}


function setRewardList( _tbRewardList )
	tbRewardList = _tbRewardList
end


--得到奖励条数
function getRewardCount()
	return table.count(tbRewardList)
end

-- {
--	rid		奖励id
-- 	title	奖励类型
-- 	time  	发奖时间
-- 	havaTime  	发奖时间梭
--  expireTime	过期时间
-- 	content 奖励内容
--  va_reward  奖励的物品
-- }

function getRewardList(  )
	local tbReward = {}
	for k,v in pairs(tbRewardList) do
		
		local rewardInfo = {}
		rewardInfo.rid	 = v.rid
		rewardInfo.title = tbRewardClass[tonumber(v.source)]		
		-- rewardInfo.time  = tostring(TimeUtil.getLocalOffsetDate(m_i18n[3305],tonumber(v.send_time)))
		-- yucong 2016-03-08
		rewardInfo.time = os.date(m_i18n[3305], tonumber(v.send_time))
		--内容描述
		local sourceString = tbRewardContent[tonumber(v.source)]
		if(tonumber(v.source) == 2 or tonumber(v.source) == 3) then
			rewardInfo.content = string.gsub(sourceString, "{0}", v.va_reward.extra["rank"])
			-- yucong 2016-03-08
			-- rewardInfo.time = tostring(TimeUtil.getLocalOffsetDate(m_i18n[3305],tonumber(v.va_reward.extra["time"])))
			rewardInfo.time = os.date(m_i18n[3305],tonumber(v.va_reward.extra["time"]))
		elseif(tonumber(v.source) == 4)	then
			rewardInfo.content = sourceString .. v.va_reward.silver
		elseif(tonumber(v.source) == 9 or tonumber(v.source) == 14 or tonumber(v.source) == 20) then
			rewardInfo.content = string.gsub(sourceString, "{0}", v.va_reward.extra["rank"])
		elseif(tonumber(v.source) == 8) then
			if(v.va_reward.type ~= nil) then
				rewardInfo.content  = sourceString[tonumber(v.va_reward.type)]
				rewardInfo.title = tbRewardClass[tonumber(v.source)][tonumber(v.va_reward.type)]	
			else
				rewardInfo.content  = sourceString[1]
				rewardInfo.title = tbRewardClass[tonumber(v.source)][1]
			end
		elseif(tonumber(v.source) == 12) then
			--自定义消息体
			rewardInfo.title = v.va_reward.title or m_i18n[3339]
			rewardInfo.content  = v.va_reward.msg or m_i18n[3339]
		elseif(tonumber(v.source) == 13) then
			rewardInfo.content = string.gsub(sourceString, "{0}", v.va_reward.extra["score"])
		elseif (tonumber(v.source) == 26) then
			rewardInfo.content = string.format(sourceString, v.va_reward.extra["uname"])
		elseif (tonumber(v.source) == 22) then
			require "script/module/guildCopy/GuildCopyModel"
			rewardInfo.content = string.format(sourceString, GuildCopyModel.getCopyNameById(v.va_reward.extra["gcId"]))
		elseif (tonumber(v.source) == 23) then
			require "script/module/guildCopy/GuildCopyModel"
			rewardInfo.content = string.format(sourceString, GuildCopyModel.getCopyNameById(v.va_reward.extra["gcId"]), v.va_reward.extra["rank"])
		elseif (tonumber(v.source) == 29) then
			if tonumber(v.va_reward.extra["rankType"])== 1 then -- 击杀
				rewardInfo.content = m_i18n[8114]
			elseif tonumber(v.va_reward.extra["rankType"])== 2 then -- 连杀
				rewardInfo.content = m_i18n[8113]
			elseif tonumber(v.va_reward.extra["rankType"])== 3 then -- 名次
				rewardInfo.content = m_i18n[8115]
			end
		elseif (tonumber(v.source) == 31) or (tonumber(v.source) == 32) or (tonumber(v.source) == 30) then
			rewardInfo.content = string.format(sourceString,v.va_reward.extra["rank"])
		else
			rewardInfo.content = sourceString
		end

		if g_debug_mode then
			if not rewardInfo.title or not rewardInfo.content then
					error("未知类型奖励 source :" .. v.source .. "  去问问策划吧？")
			end
		end
		

		--剩余过期时间
		rewardInfo.haveTime = tonumber(v.expire_time) - TimeUtil.getSvrTimeByOffset()
		--过期时间
		rewardInfo.expireTime = tonumber(v.expire_time)
		--物品信息
		rewardInfo.va_reward = v.va_reward
		rewardInfo.source = v.source
		table.insert(tbReward, rewardInfo)
	end

	return tbReward
end




--得到单条奖励信息
function getSingleRewardInfo( t_rid )
	-- local tbReward = getRewardList()
	for k,v in pairs(tbRewardList) do
		if(tonumber(v.rid) == tonumber(t_rid)) then
			--查询物品信息
			return v
		end
	end
end


--得到单条奖励信息 idx
function getSingleRewardKey (t_rid )
	local tbReward = getRewardList()
	for k,v in pairs(tbReward) do
		if(tonumber(v.rid) == tonumber(t_rid)) then
			--查询物品信息
			return k
		end
	end
end

--判断奖励是否过期 true 是过期了  不能领了
function isTimeOut( rid )
	for k,v in pairs(tbRewardList) do
		if(tonumber(rid) == tonumber(v.rid)) then
			local haveTime = tonumber(v.expire_time) - TimeUtil.getSvrTimeByOffset()
			if(haveTime < 0) then
				return true
			else
				return false
			end
		end
	end
end

function getIsHasUnTimeOut(  )
	local has = false
	for k,v in pairs(tbRewardList) do
		local haveTime = tonumber(v.expire_time) - TimeUtil.getSvrTimeByOffset()
		-- logger:debug("haveTime = %s", haveTime)
		if(haveTime > 0) then
			has = true
			break
		end
	end
	return has
end

--------------------------[[修改数据]]--------------------------
--rid :奖励id
function deleteReward( rid )	
	for k,v in pairs(tbRewardList) do
		if(tonumber(v.rid) == tonumber(rid)) then
			tbRewardList[k] = nil
		end
	end
end


function parseRewardsData( tbData )
	local tbRewardsData = {}
	for k,v in pairs(tbData.va_reward) do
        if(k == "gold") then --金币图标
            local goldInfo = {}
            goldInfo.name = m_i18n[2220]
            goldInfo.type = k
            goldInfo.num = v
            table.insert(tbRewardsData, goldInfo)
        elseif(k == "silver") then --贝里图标
            local silverInfo ={}
            silverInfo.type = k
            silverInfo.name = m_i18n[1520]
            silverInfo.num = v
            table.insert(tbRewardsData, silverInfo)
        elseif(k == "soul") then --经验石图标
            local soulInfo ={}
           	soulInfo.type = k
            soulInfo.name = m_i18n[1087]
            soulInfo.num  = v
            table.insert(tbRewardsData, soulInfo)
        elseif(k == "prestige") then -- 声望图标
        	local prestigeInfo ={}
            prestigeInfo.type = k
            prestigeInfo.name = m_i18n[1921]
            prestigeInfo.num = v
            table.insert(tbRewardsData, prestigeInfo)
        elseif(k == "jewel") then -- 海魂
        	local jewelInfo ={}
          	jewelInfo.type = k
            jewelInfo.name = m_i18n[2082]
            jewelInfo.num = v
            table.insert(tbRewardsData, jewelInfo)
        elseif(k == "hero") then --卡牌
	        for key,heroInfo in pairs(v) do
	    		require "db/DB_Heroes"
	    		require "script/model/utils/HeroUtil"
				local db_hero = DB_Heroes.getDataById(heroInfo.tplId)
				local card ={}
	            card.type  = k
	            card.name = db_hero.name
	            card.tid = heroInfo.tplId
	            card.num = heroInfo.num
	            table.insert(tbRewardsData, card)
	        end
        elseif(k == "execution") then --  奖励 体力 --	 签到奖励特殊处理
			local executionInfo ={}
          	executionInfo.type = k
            executionInfo.name = m_i18n[1922]
            executionInfo.num = v
            table.insert(tbRewardsData, executionInfo)
		elseif(k == "stamina") then --  奖励耐力
        	local staminaInfo ={}
          	staminaInfo.type = k
            staminaInfo.name = m_i18n[1923]
            staminaInfo.num = v
            table.insert(tbRewardsData, staminaInfo)
        elseif(k == "item" ) then --物品
			for key,itemInfo in pairs(v) do
				local rewardItem = {}
				--查询物品信息	
				local itemTableInfo = ItemUtil.getItemById(tonumber(itemInfo.tplId))
				local btnIcon = ItemUtil.createBtnByTemplateIdAndNumber(itemTableInfo.id,itemInfo.num,function ( sender,eventType )
												if (eventType == TOUCH_EVENT_ENDED) then
													PublicInfoCtrl.createItemInfoViewByTid(itemTableInfo.id,itemInfo.num)
												end
				end)

				rewardItem.type = k
				rewardItem.name = itemTableInfo.name
				rewardItem.num = itemInfo.num
				rewardItem.tid = itemInfo.tplId

				table.insert(tbRewardsData,rewardItem)
			end
		elseif (k=="coin") then
			local coinInfo ={}
          	coinInfo.type = k
            coinInfo.name = m_i18n[5414]
            coinInfo.num = v
            table.insert(tbRewardsData, coinInfo)
        elseif (k=="contri") then
        	local contriInfo ={}
          	contriInfo.type = k
            contriInfo.name = m_i18n[3716]
            contriInfo.num = v
            table.insert(tbRewardsData, contriInfo)
		end
	end

	return tbRewardsData

end


