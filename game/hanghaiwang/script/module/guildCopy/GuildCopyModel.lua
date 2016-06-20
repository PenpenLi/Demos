-- FileName: GuildCopyModel.lua
-- Author: liweidong
-- Date: 2015-06-01
-- Purpose: 公会副本公共model
--[[TODO List]]

module("GuildCopyModel", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --
local m_i18n = gi18n
local _guildCopyWordId = 30000 --公会副本地图

local function init(...)

end

function destroy(...)
	package.loaded["GuildCopyModel"] = nil
end

function moduleName()
    return "GuildCopyModel"
end

function create(...)

end
--返回发送申请邮件次数 ReqType  1 重置 2 开启 
function getRequestMailTims(ReqType)
	local data = DataCache.getGuildCopyBaseData()
	if (ReqType==1) then
		return tonumber(data.reset_mail_num)
	end
	return tonumber(data.open_mail_num)
end
--设置发送申请邮件次数 ReqType  1 重置 2 开启 
function setRequestMailTims(ReqType)
	local data = DataCache.getGuildCopyBaseData()
	if (ReqType==1) then
		data.reset_mail_num = data.reset_mail_num+1
	end
	data.open_mail_num = data.open_mail_num+1
end

--判断是否是首次攻打公会副本
function isFirstAttackCopy()
	local status = CCUserDefault:sharedUserDefault():getIntegerForKey("g_isFirstAttackCopy"..UserModel.getUserUid())
	return status~=1
end
--设置首次攻打公会副本状态
function setFirstAttackCopyStatus()
	CCUserDefault:sharedUserDefault():setIntegerForKey("g_isFirstAttackCopy"..UserModel.getUserUid(),1)
end
--返回当前是否有可攻打的副本
function isHaveAttackingCopy()
	if (not GuildUtil.isGuildCopyOpen()) then
		return false
	end

	local worldDb = DB_World.getDataById(_guildCopyWordId)
	local copyIds = lua_string_split(worldDb.legion_id, "|")
	local have = false
	for k,v in ipairs(copyIds) do
		local cross = getCopyOpenStatus(v)
		if (cross==1) then
			local percent = getProgressOfCopy(v)
			if (percent<100) then
				have = true
			end
		else
			break
		end
	end
	return have
end
--返回一个副本的奖励物品信息
function getRewardArrayByCopyId( id )
	local copyDb=DB_Legion_newcopy.getDataById(id)
	local rewardItdms = RewardUtil.getItemsDataByStr(copyDb.reward_id)
	return rewardItdms
end
--返回一个副本的名称
function getCopyNameById(id)
	local copyDb=DB_Legion_newcopy.getDataById(id)
	return copyDb.name
end
--返回一个副本是否可以进入 return1 bool true可进入，return2 string 不可进入显示文字
function isCanEnterGuildCopy(id)
	require "db/DB_Legion_newcopy"
	require "script/module/copy/MainCopy"

	local guildCopyDb=DB_Legion_newcopy.getDataById(id)
	if (MainCopy.fnCrossCopy(guildCopyDb.need_pass_ncopy) and UserModel.getHeroLevel()>=tonumber(guildCopyDb.need_player_lv)) then
		return true,""
	end
	require "db/DB_Copy"
	local copyDb = DB_Copy.getDataById(guildCopyDb.need_pass_ncopy)
	return false,string.format(m_i18n[5927],copyDb.name,tonumber(guildCopyDb.need_player_lv))
end
--返回一个副本的开启状态 1为已经开启，2为未开启，3为未开启且返回不满条件开启str
function getCopyOpenStatus(id)
	local guildCopyDb=DB_Legion_newcopy.getDataById(id)
	if (GuildDataModel.getGuildCopyLv()<tonumber(guildCopyDb.open_build_lv)) then
		return 3,string.format(m_i18n[5928],tonumber(guildCopyDb.open_build_lv))
	end
	local guildCopyInfo = DataCache.getGuildCopyData()
	if (guildCopyInfo==nil) then --可能存在登陆时进入主界面过快，公会副本数据还没有拉回来的情况。因为公会副本接口是顺序摘取的。
		return 3,""
	end
	local preId = id-1 --上一副本
	if (preId%100~=0) then
		local preItem = guildCopyInfo[""..preId]
		local preGuildCopyDb=DB_Legion_newcopy.getDataById(preId)
		if (preItem==nil) then
			return 3,string.format(m_i18n[5929],preGuildCopyDb.name)
		end
		if (tonumber(preItem.status)<2) then
			return 3,string.format(m_i18n[5929],preGuildCopyDb.name)
		end
	end
	if (guildCopyInfo[""..id]==nil) then
		return 2
	end
	local item = guildCopyInfo[""..id]
	if (tonumber(item.status)==0) then
		return 2
	end
	return 1
end
--返回一个副本的进度
function getProgressOfCopy(id)
	if (getCopyOpenStatus(id)~=1) then
		return 0
	end
	local guildCopyInfo = DataCache.getGuildCopyData()
	-- logger:debug({guildCopyInfo = guildCopyInfo})
	local item = guildCopyInfo[""..id]
	if (tonumber(item.status)==2) then
		return 100 --已经通关
	end
	if (item.va_gc.curBaseInfo==nil) then
		return 0
	end 
	if (item.va_gc.curBaseInfo.id==nil) then
		return 0
	end
	if (item.rate==nil) then
		return 0
	end
	local percent = tonumber(item.rate)/10000*100
	return percent-percent%1 --取整
end
--返回本地缓存的活跃度
function getActitveyNum()
	local guildCopyInfo = DataCache.getGuildCopyData()
	return tonumber(guildCopyInfo.today_guild_vitality) --GuildDataModel.getGildVitality()
end
--返回活跃度上线
function getActivtiyMaxNum()
	local copyDb=DB_Legion_copy_build.getDataById(1)
	local limitArr = lua_string_split(copyDb.vital_limit, "|")
	-- logger:debug("guildcopyinfo:")
	-- logger:debug(GuildDataModel.getGuildCopyLv())
	-- logger:debug(limitArr)
	return tonumber(limitArr[GuildDataModel.getGuildCopyLv()+1])
end
--返回公会插队开关状态 0 关 1开
function getJumpSwitch()
	local data = DataCache.getGuildCopyBaseData()
	return tonumber(data.jump_switch)
end
--设置公会插队开关状态 0 关 1开
function setJumpSwitch(s)
	local data = DataCache.getGuildCopyBaseData()
	data.jump_switch=s
end
--返回插队次数
function getJumpNum()
	local data = DataCache.getGuildCopyBaseData()
	return tonumber(data.jump_num)
end
--增加插队次数
function addJumpNum()
	local data = DataCache.getGuildCopyBaseData()
	data.jump_num = data.jump_num+1
end
--返回今天本公会手动发奖的次数
function getRewardDistributeNum()
	local data = DataCache.getGuildCopyBaseData()
	return tonumber(data.distribute_num)
end
--增加今天本公会手动发奖的次数
function addRewardDistributeNum()
	local data = DataCache.getGuildCopyBaseData()
	data.distribute_num = data.distribute_num+1
end