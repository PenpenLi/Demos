
-- FileName: AstrologyRewardView.lua
-- Author: zhangjunwu
-- Date: 2014-06-20
-- Purpose: 占卜屋奖励界面
--[[TODO List]]

module("AstrologyRewardView", package.seeall)

require "db/DB_Vip"
require "script/module/public/PublicInfoCtrl"

-- UI控件引用变量 --
local m_btnClose 					= nil
local m_btnAcceptReward 			= nil  		--领奖
local m_btnUpgradeReward 			=  nil 	--升级奖励
local m_btnRefresh					= nil 		--刷新

-- 模块局部变量 --
local m_i18n 						= gi18n
local m_fnGetWidget 				= g_fnGetWidgetByName
local m_i18nString 					= gi18nString


m_tbAstrologyInfo 					= nil
local m_tbDBVip 					= nil
local m_nRefreshTimes 				= 0 			--免费刷新奖励次数,从vip表里读取
local m_nRefreshBaseCost 			= 0 			--刷新所花的基础金币
local m_nRefreshRiseCost 			= 0 			--刷新价格递增
local m_nPriceStep 					= nil			--l领奖的步数
local m_tbStarArray	 				= nil 			--每一个i奖励所需要的星星数据
local m_dbAstrology 				= nil 			--根据奖励等级 获取本地数据
local m_nRefreshPrice 				= 0 			--每次刷新所花费的金币数量

local m_UIMain 						= nil
local ERewardItemTag 				= 102 			--图标tag		
local EEffectItemTag 				= 100			--特效tag	

local function init(...)
	m_UIMain = nil
end

function destroy(...)
	m_UIMain = nil 
	package.loaded["AstrologyRewardView"] = nil
end

function moduleName()
	return "AstrologyRewardView"
end

function getMainLayer()
	logger:debug(m_UIMain)
	return m_UIMain
end

--初始化 占卜数据，vip数据，每个奖励需要的星星数据，
function initData( ... )

	m_tbAstrologyInfo = MainAstrologyModel.m_tbAstrologyInfo

	m_dbAstrology = DB_Astrology.getDataById(tonumber(m_tbAstrologyInfo.prize_level))
	m_tbStarArray = lua_string_split(m_dbAstrology.star_arr,",")

	m_tbDBVip = DB_Vip.getDataById(UserModel.getVipLevel() + 1) or {}
	m_nRefreshTimes = string.split(m_tbDBVip.astrologyCost, "|")[1] or 0
	m_nRefreshBaseCost = string.split(m_tbDBVip.astrologyCost, "|")[2] or 0
	m_nRefreshRiseCost = string.split(m_tbDBVip.astrologyCost, "|")[3] or 0
end

--[[desc:功能简介
    tbEventListener:事件处理
    tbAstrologyInfo：占卜数据
    return: 是否有返回值，返回值说明  
—]]
function create( tbEventListener ,tbAstrologyInfo )
	m_tbAstrologyInfo = tbAstrologyInfo

	m_UIMain = g_fnLoadUI("ui/astrology_award.json")
	UIHelper.registExitAndEnterCall(m_UIMain,
		function()
			m_UIMain = nil 
		end,
		function()
		end
	)
	m_btnClose = m_fnGetWidget(m_UIMain, "BTN_CLOSE")
	m_btnAcceptReward = m_fnGetWidget(m_UIMain, "BTN_GET_REWARD")
	m_btnUpgradeReward = m_fnGetWidget(m_UIMain, "BTN_UP_LEVEL")
	m_btnRefresh = m_fnGetWidget(m_UIMain,"BTN_REFRESH")

	local tfd_cur_star1 = m_fnGetWidget(m_UIMain,"tfd_stars_1") --当前运势
	UIHelper.labelAddStroke(tfd_cur_star1,m_i18nString(2313))

	-- m_btnWorld:setTitleText()
	m_btnClose:addTouchEventListener(tbEventListener.onClose)
	m_btnAcceptReward:addTouchEventListener(tbEventListener.onAcceptReWard)
	m_btnUpgradeReward:addTouchEventListener(tbEventListener.onUpgradeReward)
	m_btnRefresh:addTouchEventListener(tbEventListener.onRefresh)

	--yinying
	UIHelper.titleShadow(m_btnAcceptReward,m_i18nString(2309))
	UIHelper.titleShadow(m_btnUpgradeReward,m_i18nString(2310))
	UIHelper.titleShadow(m_btnRefresh,m_i18nString(2302 ," "))

	--是否有随机奖励
	local newreward = m_tbAstrologyInfo.va_divine.newreward or {}
	if(table.count(newreward) <= 0)then
		fnRefreshRewardsWithNorm()
	else
		fnRefreshRewardsWithRandom()
	end
	--设置按钮属性
	setBtnsState()

	return m_UIMain
end

--设置升级奖励按钮的属性
function setUpgradeBtnState( canUpgrade,rewardLimitLevel)
	local layUpReward = m_fnGetWidget(m_UIMain,"lay_up_reward")

	local reachText = m_fnGetWidget(layUpReward,"tfd_up_reward_1")
	UIHelper.labelEffect(reachText,m_i18nString(1313))

	local levelText = m_fnGetWidget(layUpReward,"labn_up_reward_2")
	--UIHelper.labelEffect(levelText,tostring(rewardLimitLevel))
	levelText:setStringValue(tonumber(rewardLimitLevel))
	
	local reachText1 = m_fnGetWidget(layUpReward,"tfd_up_reward_3")
	UIHelper.labelEffect(reachText1,m_i18nString(2311))

	if(canUpgrade) then
		--如果玩家等级达到了下一级别的奖励所需要的等级，则升级按钮可用
		m_btnUpgradeReward:setBright(true)
		m_btnUpgradeReward:setTouchEnabled(true)

	else
		--如果玩家等级没有达到了下一级别的奖励所需要的等级，则升级按钮置灰
		m_btnUpgradeReward:setBright(false)
		m_btnUpgradeReward:setTouchEnabled(false)

	end
end

--根据玩家等级设置按钮
function setBtnsState( ... )
	local  prize_level 		= m_tbAstrologyInfo.prize_level
	local  astroTableCount  = table.count(DB_Astrology.Astrology)   			--表中配置的个数
	local  dbNextAstrology  = nil

	if(m_tbAstrologyInfo.prize_level + 1 <= astroTableCount) then
		dbNextAstrology = DB_Astrology.getDataById(tonumber(m_tbAstrologyInfo.prize_level + 1))
	end

	local randAward = m_dbAstrology.randReward1			--看是否有随机奖励
	local avaterLevel = UserModel.getAvatarLevel()

	--如果有下一档配置
	if(dbNextAstrology ~= nil) then
		local rewardLimitLevel = dbNextAstrology.limited_lv		--
		if(avaterLevel >= rewardLimitLevel) then
			--如果玩家等级达到了下一级别的奖励所需要的等级，则升级按钮可用
			setUpgradeBtnState(true,rewardLimitLevel)

		else
			--如果玩家等级没有达到了下一级别的奖励所需要的等级，则升级按钮置灰
			setUpgradeBtnState(false,rewardLimitLevel)

		end
	else
		--如果升级到尽头了，则升级按钮影藏
		m_btnUpgradeReward:setEnabled(false)
		local layUpReward = m_fnGetWidget(m_UIMain,"lay_up_reward")

		layUpReward:setEnabled(false)
	end
	--配置表里没有刷新数据，则刷新按钮隐藏

	local lay_refresh = m_fnGetWidget(m_UIMain,"lay_btn_up")
	if(randAward == nil) then
		lay_refresh:setEnabled(false)
		m_btnRefresh:setEnabled(false)
	else
		lay_refresh:setEnabled(true)
		--每天
		local i18n_tfd_every = m_fnGetWidget(lay_refresh,"tfd_refresh_1")
		UIHelper.labelEffect(i18n_tfd_every,m_i18nString(2314))
		--刷新占卜奖励
		local i18n_tfd_refresh = m_fnGetWidget(lay_refresh,"tfd_refresh_3")
		UIHelper.labelEffect(i18n_tfd_refresh,m_i18nString(2315))
		--o点
		local tfd_time = m_fnGetWidget(lay_refresh,"tfd_refresh_2")
		UIHelper.labelEffect(tfd_time,"0")

		--剩余刷新次数
		local nleftRefreshTimes = m_nRefreshTimes - m_tbAstrologyInfo.ref_prize_num
		local tfd_refreshTimes = m_fnGetWidget(lay_refresh,"TFD_TIMES_2")
		UIHelper.labelEffect(tfd_refreshTimes,tostring(nleftRefreshTimes))

		local i18n_tfd_leftrefresh = m_fnGetWidget(lay_refresh,"tfd_times_1")
		UIHelper.labelEffect(i18n_tfd_leftrefresh,m_i18nString(2316))

		--刷新所需要的金币数量
		local tfd_gold = m_fnGetWidget(lay_refresh,"tfd_gold")
		m_nRefreshPrice= m_nRefreshBaseCost + m_nRefreshRiseCost * m_tbAstrologyInfo.ref_prize_num
		UIHelper.labelEffect(tfd_gold,tostring(m_nRefreshPrice))
	end
end

--parm :rewardInfo每一个奖励的数据信息：i 第几个奖励
function setRewardUI( rewardInfo,i )
	local resultIcon = nil
	local rewardName = nil
	local lay_award_name = m_fnGetWidget(m_UIMain,"TFD_NAME_" .. i) 		--奖励名字
	local lay_award_img = m_fnGetWidget(m_UIMain,"IMG_ICON_" .. i) 			--奖励的图标
	local lay_award_star = m_fnGetWidget(m_UIMain,"LABN_NUM_" .. i) 			--需要的星术
	local image_star = m_fnGetWidget(m_UIMain,"img_star_" .. i) 			--五角星

	local iamge_have_get = m_fnGetWidget(m_UIMain,"IMG_HAVE_GET_" .. i) 	--已领奖
	iamge_have_get:setEnabled(false)

	--判断奖励类型
	if("0"==lua_string_split(rewardInfo,"|")[1])then
		--贝里
		resultIcon = ItemUtil.getSiliverIconByNum()
		rewardName = m_i18n[1520] .. lua_string_split(rewardInfo,"|")[2]
	elseif("1"==lua_string_split(rewardInfo,"|")[1])then
		--金币
		resultIcon = ItemUtil.getGoldIconByNum()
		rewardName = m_i18n[2220] .. lua_string_split(rewardInfo,"|")[2]
	elseif("2"==lua_string_split(rewardInfo,"|")[1])then
		--经验石
		resultIcon = ItemUtil.getSoulIconByNum()
		rewardName = m_i18n[1087] .. lua_string_split(rewardInfo,"|")[2]
	elseif("3"==lua_string_split(rewardInfo,"|")[1])then
		--道具
		local tid = lua_string_split(rewardInfo,"|")[2]
		--resultIcon = ItemUtil.createBtnByTemplateId(lua_string_split(rewardInfo,"|")[2])
		resultIcon = ItemUtil.createBtnByTemplateId(tid, function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				PublicInfoCtrl.createItemInfoViewByTid(tid)
			end
		end)

		rewardName = ItemUtil.getItemById(lua_string_split(rewardInfo,"|")[2]).name
	end
	--名字
	UIHelper.labelEffect(lay_award_name,rewardName)
	--图片
	lay_award_img:removeChildByTag(ERewardItemTag,true)
	lay_award_img:addChild(resultIcon,0,ERewardItemTag)

	--星星数量
	--UIHelper.labelEffect(lay_award_star,m_tbStarArray[i])
	lay_award_star:setStringValue(tonumber(m_tbStarArray[i]))
	
	--如果已经领过了，则隐藏领奖图片
	if(i < m_nPriceStep + 1)then
		iamge_have_get:setEnabled(true)
	end

	--删除之前的特效
	lay_award_img:removeNodeByTag(EEffectItemTag)
	--添加特效动画
	if(i >= m_nPriceStep+ 1 and tonumber(m_tbStarArray[i]) <= tonumber(m_tbAstrologyInfo.integral))then
		local tbParams = {
			filePath = "images/effect/astrology/zhanbu5.ExportJson",
			animationName = "zhanbu5",}

		local effectNode = UIHelper.createArmatureNode(tbParams)
		lay_award_img:addNode(effectNode,1,100);
	end

	--设置星星的灰亮
	if(tonumber(m_tbStarArray[i]) >= tonumber(m_tbAstrologyInfo.integral)) then
		image_star:loadTexture("images/common/astrology_ash_star.png")
	end
end

--获取没有升级后的普通奖励数据
function getNormalRewardData( index )
	local rewardArray = string.split(m_dbAstrology.reward_arr, ",")
	local rewardInfo = rewardArray[index]
	return rewardInfo
end

--根据奖励级别从表里读取占卜信息
function getUpgradedRewardData( ... )
	--随机奖励的下表数组
	local rewardArray = m_tbAstrologyInfo.va_divine.newreward
	--依次读取十个随机奖励数据
	local randwardData = m_dbAstrology["randReward" .. i]
	--根据返回的下表读取奖励数据
	local rewardInfo = lua_string_split(randwardData,",")[tonumber(rewardArray[i]) + 1]

	return rewardInfo
end
--初始化奖励数据和ui,无随机奖励
function fnRefreshRewardsWithNorm()
	--刷新数据
	--m_tbAstrologyInfo = MainAstrologyModel.m_tbAstrologyInfo

	initData()
	logger:debug(m_tbAstrologyInfo)
	m_nPriceStep = m_tbAstrologyInfo.prize_step


	local tfd_cur_star = m_fnGetWidget(m_UIMain,"LABN_STARS_2") --当前运势
	-- UIHelper.labelAddStroke(tfd_cur_star,m_tbAstrologyInfo.integral)
	tfd_cur_star:setStringValue(tonumber(m_tbAstrologyInfo.integral))

	local rewardArray = string.split(m_dbAstrology.reward_arr, ",")
	for i=1,#rewardArray do
		local rewardInfo = rewardArray[i]
		setRewardUI(rewardInfo,i)
	end
end

--更新奖励数据和ui，有随机奖励
function fnRefreshRewardsWithRandom()
	--刷新数据
	--m_tbAstrologyInfo = MainAstrologyModel.m_tbAstrologyInfo
	
	initData()

	m_nPriceStep = m_tbAstrologyInfo.prize_step

	logger:debug(m_tbAstrologyInfo)
	local tfd_cur_star = m_fnGetWidget(m_UIMain,"LABN_STARS_2") --当前运势
	-- UIHelper.labelAddStroke(tfd_cur_star,m_tbAstrologyInfo.integral)
	tfd_cur_star:setStringValue(tonumber(m_tbAstrologyInfo.integral))
	--随机奖励的下表数组
	local rewardArray = m_tbAstrologyInfo.va_divine.newreward

	for i=1,#rewardArray do
		--一次读取十个随机奖励数据
		local randwardData = m_dbAstrology["randReward" .. i]
		--根据返回的下表读取奖励数据
		local rewardInfo = lua_string_split(randwardData,",")[tonumber(rewardArray[i]) + 1]
		setRewardUI(rewardInfo,i,starArray)
	end

	setBtnsState()
end
