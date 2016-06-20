-- FileName: GuildHallView.lua
-- Author: huxiaozhou
-- Date: 2014-09-20
-- Purpose: function description of module
--[[TODO List]]
-- 联盟大厅 

module("GuildHallView", package.seeall)

-- UI控件引用变量 --
local m_mainWidget
local m_IMG_TYPE_ORIGIN
local m_IMG_TYPE_NEW
local m_IMG_TYPE_CONFIRM

-- 模块局部变量 --
local json = "ui/union_hall.json"
local m_fnGetWidget = g_fnGetWidgetByName
local m_fnLoadUI = g_fnLoadUI

local m_i18n = gi18n
local m_i18nString = gi18nString

local m_tbEvent

local m_lsv_contri

local m_lsv_news

local Tag_Normal_Build 	= 1
local Tag_Middle_Build 	= 2
local Tag_High_Build 	= 3

local m_updateTimeScheduler 

local m_i18ntfd_time
local m_TFD_TIME_NUM
local m_img_count_bg


local function init(...)
	m_tbEvent = {}
	m_updateTimeScheduler = nil
	GuildDataModel.setIsInGuildFunc(true)
end

function destroy(...)
	package.loaded["GuildHallView"] = nil
end

function moduleName()
    return "GuildHallView"
end

function updateTime(  )
	if GuildUtil.getContriCD() == "00:00:00" then
		stopScheduler()
	else
		m_TFD_TIME_NUM:setText(GuildUtil.getContriCD())
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

local function loadUI( ... )

	local IMG_BG = m_fnGetWidget(m_mainWidget, "IMG_BG")
	IMG_BG:setScale(g_fScaleX)

	local img_background = m_fnGetWidget(m_mainWidget, "img_background")
	img_background:setScale(g_fScaleX)

	local BTN_CLOSE = m_fnGetWidget(m_mainWidget, "BTN_CLOSE")
	BTN_CLOSE:addTouchEventListener(m_tbEvent.fnClose)
	UIHelper.titleShadow(BTN_CLOSE,m_i18n[1019])


	local i18ntfd_lv = m_fnGetWidget(m_mainWidget, "tfd_lv") --联盟等级：
	i18ntfd_lv:setText(m_i18n[3730])--m_i18n[])
	UIHelper.labelNewStroke(i18ntfd_lv, ccc3(0x28,0x00,0x00))

	local LABN_LV_NUM = m_fnGetWidget(m_mainWidget, "TFD_LV_NUM") 
	LABN_LV_NUM:setText(GuildDataModel.getGuildHallLevel())

	local i18ntfd_contribution = m_fnGetWidget(m_mainWidget, "tfd_contribution") -- 升级所需建设度
	i18ntfd_contribution:setText(m_i18n[3708])
	UIHelper.labelNewStroke(i18ntfd_contribution, ccc3(0x28,0x00,0x00))
	
	local img_lv_bg = m_fnGetWidget(m_mainWidget, "img_lv_bg")
	local LAY_FIT = m_fnGetWidget(m_mainWidget,"LAY_FIT")

	local LABN_CONTRIBUTION_NUM1 = m_fnGetWidget(m_mainWidget, "TFD_CONTRIBUTION_NUM1")
	local _guildInfo = GuildDataModel.getGuildInfo()
	UIHelper.labelNewStroke(LABN_CONTRIBUTION_NUM1, ccc3(0x28,0x00,0x00))

	local img_slant = m_fnGetWidget(m_mainWidget, "tfd_slant")
	UIHelper.labelNewStroke(img_slant, ccc3(0x28,0x00,0x00))
	img_slant:updateSizeAndPosition()

	local hallNeedExp = GuildUtil.getNeedExpByLv( tonumber(_guildInfo.guild_level) + 1 )
	
	local LABN_CONTRIBUTION_NUM2 = m_fnGetWidget(m_mainWidget, "TFD_CONTRIBUTION_NUM2")
	LABN_CONTRIBUTION_NUM2:setText(_guildInfo.curr_exp)
	UIHelper.labelNewStroke(LABN_CONTRIBUTION_NUM2, ccc3(0x28,0x00,0x00))

	local imgDash = m_fnGetWidget(m_mainWidget, "tfd_max")
	UIHelper.labelNewStroke(imgDash, ccc3(0x28,0x00,0x00))
	if (tonumber(_guildInfo.guild_level) >= tonumber(GuildUtil.getMaxGuildLevel())) then 
		LABN_CONTRIBUTION_NUM1:setEnabled(false)
		imgDash:setEnabled(true)
	else 
		LABN_CONTRIBUTION_NUM1:setText(hallNeedExp)
		imgDash:setEnabled(false)
	end

	LAY_FIT:requestDoLayout()

	m_i18ntfd_time = m_fnGetWidget(m_mainWidget, "tfd_time") -- 建设倒计时：
	m_i18ntfd_time:setText(m_i18n[3717])
	m_TFD_TIME_NUM = m_fnGetWidget(m_mainWidget, "TFD_TIME_NUM") 
	m_img_count_bg = m_fnGetWidget(m_mainWidget, "img_count_bg")

	m_lsv_contri = m_fnGetWidget(m_mainWidget, "LSV_CONTRIBUTION")
	m_lsv_news = m_fnGetWidget(m_mainWidget, "LSV_NEWS")


	m_TFD_TIME_NUM:setText(GuildUtil.getContriCD())
	UIHelper.registExitAndEnterCall(m_mainWidget, stopScheduler, startScheduler)


	UIHelper.labelNewStroke(m_i18ntfd_time, ccc3(0x00,0x20,0x68))
	UIHelper.labelNewStroke(m_TFD_TIME_NUM, ccc3(0x00,0x20,0x68))
	loadConstructList()
	loadRecordList()
end

function getBulidingContructData(  )
	local tbDataSource = {}
	for i=1,3 do
		local tbDonate = GuildUtil.getDonateInfoBy(i)
		table.insert(tbDataSource, tbDonate)
	end
	return tbDataSource
end

-- 捐献种类列表
function loadConstructList( )
	local tbDataSource = getBulidingContructData()
	logger:debug(tbDataSource)
	UIHelper.initListView(m_lsv_contri)
	local cell, nIdx
	for i,cellData in ipairs(tbDataSource or {}) do
		m_lsv_contri:pushBackDefaultItem()	
		nIdx = i - 1
    	cell = m_lsv_contri:getItem(nIdx)  -- cell 索引从 0 开始
    	loadContriCell(cell,cellData,i)
	end
	
end

local tbText = {m_i18n[3710], m_i18n[3711], m_i18n[3712]}
-- 捐献列表cell
function loadContriCell( cell, cellData,index)
	-- local i18ntfd_simple = m_fnGetWidget(cell, "tfd_simple") -- 简单建设
	-- i18ntfd_simple:setText(cellData.sTitle)

	local img_simple = m_fnGetWidget(cell, "img_simple") -- 图片
	local img_normal = m_fnGetWidget(cell, "img_normal") -- 图片
	local img_hard = m_fnGetWidget(cell, "img_hard") -- 图片
	cell.tfd_simple:setText(tbText[index])

	if index == 1 then
		img_simple:setEnabled(true)
		img_normal:setEnabled(false)
		img_hard:setEnabled(false)
	elseif index == 2 then
		img_simple:setEnabled(false)
		img_normal:setEnabled(true)
		img_hard:setEnabled(false)
	elseif index == 3 then
		img_simple:setEnabled(false)
		img_normal:setEnabled(false)
		img_hard:setEnabled(true)
	end

	
	
	local lay_simple_consume = m_fnGetWidget(cell, "lay_simple_consume")
	local i18ntfd_consume = m_fnGetWidget(lay_simple_consume, "tfd_consume") -- 消耗
	i18ntfd_consume:setText(m_i18n[1405])
	

	local BTN_SIMPLE_CONSTRUCT = m_fnGetWidget(cell, "BTN_SIMPLE_CONSTRUCT") -- 建设按钮
	local LABN_SIMPLE_CONSUME = m_fnGetWidget(BTN_SIMPLE_CONSTRUCT, "TFD_SIMPLE_CONSUME") -- 消耗
	local img_belly = m_fnGetWidget(BTN_SIMPLE_CONSTRUCT, "img_belly") -- 贝里图片
	if index==1 then
		LABN_SIMPLE_CONSUME:setText(cellData.silver)
	else
		img_belly:loadTexture("ui/gold.png")
		LABN_SIMPLE_CONSUME:setText(cellData.gold)
	end

	local lay_simple_union = m_fnGetWidget(cell, "lay_simple_union") 
	local i18ntfd_add_union = m_fnGetWidget(lay_simple_union,"tfd_add") -- 增加
	i18ntfd_add_union:setText(m_i18n[3709])

	local LABN_SIMPLE_UNION = m_fnGetWidget(lay_simple_union, "TFD_SIMPLE_UNION")
	local i18ntfd_union = m_fnGetWidget(lay_simple_union,"tfd_union") -- 联盟总建设
	LABN_SIMPLE_UNION:setText(cellData.guildDonate)

	local lay_simple_individual = m_fnGetWidget(cell, "lay_simple_individual") 
	local i18ntfd_add = m_fnGetWidget(lay_simple_individual, "tfd_add") -- 增加
	i18ntfd_add:setText(m_i18n[3709])

	local LABN_SIMPLE_INDIVIDUAL = m_fnGetWidget(lay_simple_individual, "TFD_SIMPLE_INDIVIDUAL")
	local i18ntfd_individual = m_fnGetWidget(lay_simple_individual, "tfd_individual")--个人贡献
	LABN_SIMPLE_INDIVIDUAL:setText(cellData.sigleDonate)

	BTN_SIMPLE_CONSTRUCT:setTag(index)
	BTN_SIMPLE_CONSTRUCT:addTouchEventListener(m_tbEvent.fnConstruct)
	
	local img_already = m_fnGetWidget(cell, "img_already")

	local TFD_CONSTRUCT = cell.TFD_CONSTRUCT

	if(GuildDataModel.getMineDonateTimes()<=0 and index == tonumber(GuildDataModel.getMineContriType()))then
		BTN_SIMPLE_CONSTRUCT:setEnabled(false)
		img_already:setEnabled(true)
	elseif(GuildDataModel.getMineDonateTimes()<=0) then
		BTN_SIMPLE_CONSTRUCT:setBright(false)
		img_already:setEnabled(false)
		UIHelper.labelShadowWithText(TFD_CONSTRUCT, m_i18n[3733])

	else
		img_already:setEnabled(false)
		UIHelper.labelShadowWithText(TFD_CONSTRUCT, m_i18n[3733])
	end

end


-- 捐献记录lsv
function loadRecordList(  )
	local tbRecord = GuildDataModel._recordList
	logger:debug(tbRecord)
	m_lsv_news:setEnabled(false)
	if #tbRecord ~= 0 then
		m_lsv_news:setEnabled(true)
		UIHelper.initListView(m_lsv_news)
	end
	
	local cell, nIdx
	for i,cellData in ipairs(tbRecord or {}) do
		m_lsv_news:pushBackDefaultItem()	
		nIdx = i - 1
    	cell = m_lsv_news:getItem(nIdx)  -- cell 索引从 0 开始
    	loadRecordCell(cell,cellData,i)
	end

	
end

-- 捐献记录cell
function loadRecordCell( cell, cellData, index)
	local TFD_PLAYER_NAME = m_fnGetWidget(cell, "TFD_PLAYER_NAME")
	TFD_PLAYER_NAME:setText(cellData.uname)
	local nameColor = UserModel.getPotentialColor({htid = cellData.figure, bright = true}) -- 2015-07-29
	TFD_PLAYER_NAME:setColor(nameColor)
	local i18ntfd_tigongle = m_fnGetWidget(cell, "tfd_tigongle") --提供了
	local i18ntfd_jianshedu = m_fnGetWidget(cell, "tfd_jianshedu") --建设度
	i18ntfd_tigongle:setText(m_i18n[3731])
	i18ntfd_jianshedu:setText(m_i18n[3732])
	local TFD_PLAYER_CONTRIBUTE = m_fnGetWidget(cell, "TFD_PLAYER_CONTRIBUTE")
	TFD_PLAYER_CONTRIBUTE:setText(cellData.record_data)

	if tonumber(cellData.record_type) == 1 then
		TFD_PLAYER_CONTRIBUTE:setColor(ccc3(0x4d, 0xec, 0x15))
	elseif tonumber(cellData.record_type) == 2 then
		TFD_PLAYER_CONTRIBUTE:setColor(ccc3(0x1f, 0xd7, 0xff))
	elseif tonumber(cellData.record_type) == 3 then
		TFD_PLAYER_CONTRIBUTE:setColor(ccc3(0xee, 0x46, 0xec))
	end 

end

function updateUI( )
	loadUI()
	-- local LABN_CONTRIBUTION_NUM1 = m_fnGetWidget(m_mainWidget, "LABN_CONTRIBUTION_NUM2")
	-- LABN_CONTRIBUTION_NUM1:setStringValue(999999)

	updateInfoBar() -- zhangqi, 2015-05-05, 替换统一的信息条刷新方法
	startScheduler()
end

function playContriEffect( _curDonateInfo)
	local img_hall_icon = m_fnGetWidget(m_mainWidget,"img_hall_icon")

	local function animationCallBack( armature,movementType,movementID )
		if(movementType == 1) then
		end
	end

	local function keyFrameCallBack( bone,frameEventName,originFrameIndex,currentFrameIndex )
		logger:debug("frameEventName : " .. frameEventName)
		logger:debug("originFrameIndex : " .. originFrameIndex)
		logger:debug("currentFrameIndex : " .. currentFrameIndex)
		if (frameEventName == "1") then
			ShowNotice.showShellInfo(m_i18nString(3736,_curDonateInfo.sigleDonate,_curDonateInfo.guildDonate))
		end
	end


	local  animation = UIHelper.createArmatureNode({
		filePath = "images/effect/guild/lmbuild.ExportJson",
		animationName = "lmbuild",
		loop = 0,
		fnMovementCall = animationCallBack,
		fnFrameCall = keyFrameCallBack,
	})

	img_hall_icon:addNode(animation)
end



function create( tbEvent )
	init()
	m_tbEvent = tbEvent
	m_mainWidget = m_fnLoadUI(json)
	m_mainWidget:setSize(g_winSize)
	loadUI()
	m_mainWidget:addChild(GuildMenuCtrl.create())

	return m_mainWidget
end
