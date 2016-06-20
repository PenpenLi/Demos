-- FileName: CafeHouseView.lua
-- Author: menghao
-- Date: 2014-09-16
-- Purpose: 人鱼咖啡厅view


module("CafeHouseView", package.seeall)


-- UI控件引用变量 --
local m_UIMain

local m_imgBG
local m_layEasyInfo

-- 上方的十个文本
local m_tfdLevel
local m_tfdRemain
local m_tfdRemainNum
local m_tfdContribution
local m_labnContributionNum1
local m_labnContributionNum2
local m_imgDash
local m_tfdTime
local m_tfdTimeInfo

-- 下方的十个文本
local m_imgConsume
local m_labnConsumeNum

-- 三个按钮和一个图片
local m_btnReward
local m_btnBack
local m_btnDrink
local m_imgDrink


-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName

local m_updateTimeScheduler
local m_nFutureTime
local m_nLeftNum

local mi18n = gi18n


local function init(...)
	GuildDataModel.setIsInGuildFunc(true)
end


function destroy(...)
	package.loaded["CafeHouseView"] = nil
end


function moduleName()
	return "CafeHouseView"
end


function refreshBaiNum(nowNum)
	if (m_tfdRemainNum) then
		local totalNum = GuildDataModel.getMemberLimit()
		m_tfdRemainNum:setText(tostring(totalNum-nowNum))
		GuildDataModel.addGuildRewardTimes(1)
	end
end

function setString( str )
	m_tfdRemainNum:setText(str)
end


function updateTime( ... )
	local leftTime = m_nFutureTime - TimeUtil.getSvrTimeByOffset()

	if (leftTime <= 0) then
		stopScheduler()
		checkStatus()
		m_layConutDown:setEnabled(false)
		m_imgConsume:setEnabled(true)
		m_labnConsumeNum:setEnabled(true)
	else
		m_layConutDown:setEnabled(true)
		m_imgConsume:setEnabled(false)
		m_labnConsumeNum:setEnabled(false)

		-- local tbTimeStr = string.split(TimeUtil.getTimeString(leftTime), ":")
		m_labnHour:setText(TimeUtil.getTimeString(leftTime))
		-- m_labnMinute:setStringValue(tbTimeStr[2])
		-- m_labnSecond:setStringValue(tbTimeStr[3])
	end
end


-- 启动scheduler
function startScheduler()
	if(m_updateTimeScheduler == nil) then
		m_updateTimeScheduler = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(updateTime, 1, false)
	end
end


-- 停止scheduler
function stopScheduler()
	if(m_updateTimeScheduler)then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(m_updateTimeScheduler)
		m_updateTimeScheduler = nil
	end
end


function checkStatus( ... )
	local curTime = TimeUtil.getSvrTimeByOffset()
	local date = TimeUtil.getLocalOffsetDate("*t", curTime)
	local nowHour = date.hour
	local nowMin = date.min
	local nowSec = date.sec
	local nowTime = tonumber(nowHour) * 10000 + tonumber(nowMin) * 100 + tonumber(nowSec)

	local dbInfo = DB_Legion_feast.getDataById(1)

	m_btnDrink:setEnabled(true)
	m_imgDrink:setEnabled(false)

	if (nowTime >= tonumber(dbInfo.beginTime) and nowTime <= tonumber(dbInfo.endTime)) then
		if (tonumber(GuildDataModel.getBaiGuangongTimes()) <= 0) then
			m_btnDrink:setEnabled(false)
		else
		end
	else
		m_btnDrink:setEnabled(false)
	end
end


function afterDrink( callback )
	-- 倒计时
	if (GuildUtil.getCafeCD() ~= 0) then
		local nowTime = TimeUtil.getSvrTimeByOffset()
		m_nFutureTime = nowTime + GuildUtil.getCafeCD()
	else
		m_nFutureTime = 0
	end
	startScheduler()
	-- 剩余次数
	if (m_nLeftNum > 0) then
		m_nLeftNum = m_nLeftNum - 1
	end
	m_tfdRemainNum:setText(m_nLeftNum)

	updateInfoBar() -- zhangqi, 2015-05-05, 替换统一的信息条刷新方法

	checkStatus()
end


function create( tbEvents )
	init()
	m_UIMain = g_fnLoadUI("ui/union_cafe.json")

	m_imgBG = m_fnGetWidget(m_UIMain, "img_bg")
	m_imgBG:setScale(g_fScaleX)

	local img_tab = m_fnGetWidget(m_UIMain, "img_tab_bg")
	img_tab:setScale(g_fScaleX)

	m_layEasyInfo = m_fnGetWidget(m_UIMain, "LAY_EASY_INFO")
	m_layEasyInfo:setSize(CCSizeMake(m_layEasyInfo:getSize().width * g_fScaleX, m_layEasyInfo:getSize().height * g_fScaleX))

	-- 上方的十个文本
	m_tfdLevel = m_fnGetWidget(m_UIMain, "TFD_LV_NUM")
	m_tfdRemain = m_fnGetWidget(m_UIMain, "tfd_remain")
	UIHelper.labelNewStroke(m_tfdRemain, ccc3(0x28,0x00,0x00))
	m_tfdRemainNum = m_fnGetWidget(m_UIMain, "TFD_REMAIN_NUM")
	UIHelper.labelNewStroke(m_tfdRemainNum, ccc3(0x28,0x00,0x00))
	m_tfdContribution = m_fnGetWidget(m_UIMain, "tfd_contribution")
	UIHelper.labelNewStroke(m_tfdContribution, ccc3(0x28,0x00,0x00))
	m_labnContributionNum1 = m_fnGetWidget(m_UIMain, "TFD_CONTRIBUTION_NUM1")
	m_labnContributionNum2 = m_fnGetWidget(m_UIMain, "TFD_CONTRIBUTION_NUM2")
	UIHelper.labelNewStroke(m_labnContributionNum1, ccc3(0x28,0x00,0x00))
	UIHelper.labelNewStroke(m_labnContributionNum2, ccc3(0x28,0x00,0x00))
	m_imgDash = m_fnGetWidget(m_UIMain, "TFD_DASH")
	UIHelper.labelNewStroke(m_imgDash, ccc3(0x28,0x00,0x00))
	m_tfdTime = m_fnGetWidget(m_UIMain, "tfd_time")
	UIHelper.labelNewStroke(m_tfdTime, ccc3(0x28,0x00,0x00))
	m_tfdTimeInfo = m_fnGetWidget(m_UIMain, "TFD_TIME_INFO")
	UIHelper.labelNewStroke(m_tfdTimeInfo, ccc3(0x28,0x00,0x00))
	-- 下方的十个文本
	m_imgConsume = m_fnGetWidget(m_UIMain, "TFD_CONSUME")
	m_labnConsumeNum = m_fnGetWidget(m_UIMain, "TFD_CONSUME_NUM")
	UIHelper.labelNewStroke(m_labnConsumeNum, ccc3(0x28,0x00,0x00))
	local i18n_desc = m_fnGetWidget(m_UIMain, "tfd_desc")
	UIHelper.labelAddNewStroke(i18n_desc, mi18n[3821], ccc3(0x28, 0x00, 0x00))

	-- 三个按钮和一个图片
	m_btnReward = m_fnGetWidget(m_UIMain, "BTN_REWARD")
	m_btnBack = m_fnGetWidget(m_UIMain, "BTN_CLOSE")
	m_btnDrink = m_fnGetWidget(m_UIMain, "BTN_DRINK")
	m_imgDrink = m_fnGetWidget(m_UIMain, "IMG_DRUNK")

	UIHelper.labelNewStroke(m_UIMain.TFD_COUNTDOWN, ccc3(0x28,0x00,0x00))
	UIHelper.labelNewStroke(m_UIMain.tfd_slant, ccc3(0x28,0x00,0x00))
	
	-- 咖啡屋等级
	local level = GuildDataModel.getGuanyuTempleLevel()
	m_tfdLevel:setText(level)

	-- 剩余次数
	local totalNum = GuildDataModel.getMemberLimit()
	local guildInfo = GuildDataModel.getGuildInfo()
	local haveNum = GuildDataModel.getGuildRewardTimes()
	m_nLeftNum = totalNum - haveNum
	m_tfdRemain:setText(mi18n[3722])
	m_tfdRemainNum:setText(m_nLeftNum)

	-- 建设度
	local dbInfo = DB_Legion_feast.getDataById(1)
	local expid = dbInfo.expId
	local nextLv = level + 1
	local expNum = DB_Level_up_exp.getDataById(tonumber(expid))["lv_" .. nextLv]
	m_labnContributionNum1:setText(GuildDataModel.getGuildDonate())
	if (level >= GuildUtil.getMaxGongyuLevel()) then
		m_labnContributionNum2:setEnabled(false)
	else
		m_labnContributionNum2:setText(expNum)
		m_imgDash:setEnabled(false)
	end

	-- 时间倒计时
	m_layConutDown = m_fnGetWidget(m_UIMain, "LAY_COUNTDOWN")
	m_labnHour = m_fnGetWidget(m_layConutDown, "TFD_COUNTDOWN_NUM")
	UIHelper.labelNewStroke(m_labnHour, ccc3(0x28,0x00,0x00))
	-- m_labnMinute = m_fnGetWidget(m_layConutDown, "LABN_MINUTE")
	-- m_labnSecond = m_fnGetWidget(m_layConutDown, "LABN_SECOND")
	m_tfdTime:setText(mi18n[3723])
	m_tfdTimeInfo:setText(mi18n[3724])
	if (GuildUtil.getCafeCD() ~= 0) then
		-- local tbTimeStr = string.split(TimeUtil.getTimeString(GuildUtil.getCafeCD()), ":")
		m_labnHour:setText(TimeUtil.getTimeString(GuildUtil.getCafeCD()))
		-- m_labnMinute:setStringValue(tbTimeStr[2])
		-- m_labnSecond:setStringValue(tbTimeStr[3])
		local nowTime = TimeUtil.getSvrTimeByOffset()
		m_nFutureTime = nowTime + GuildUtil.getCafeCD()
		m_imgConsume:setEnabled(false)
		m_labnConsumeNum:setEnabled(false)
	else
		m_nFutureTime = 0
		m_layConutDown:setEnabled(false)
	end

	-- 按钮事件
	m_btnReward:addTouchEventListener(tbEvents.onReward)
	m_btnBack:addTouchEventListener(tbEvents.onBack)
	m_btnDrink:addTouchEventListener(tbEvents.onDrink)

	UIHelper.titleShadow(m_btnBack,mi18n[1019])

	checkStatus()

	-- 按钮上动画
	local imgEffect = m_fnGetWidget(m_UIMain, "IMG_EFFECT")
	local armature = UIHelper.createArmatureNode({
		filePath = "images/effect/lianmeng/caffea.ExportJson",
		animationName = "caffea",
		fnMovementCall = function ( sender, MovementEventType , frameEventName)
		end,
	})
	imgEffect:addNode(armature, 100)

	LayerManager.setPaomadeng(m_UIMain, 100)
	UIHelper.registExitAndEnterCall(m_UIMain, function ( ... )
		LayerManager.resetPaomadeng()
		stopScheduler()
		m_tfdRemainNum = nil
	end, startScheduler)

	return m_UIMain
end

