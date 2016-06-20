-- FileName: MainRankView.lua
-- Author: zhangjunwu
-- Date: 2016-02-03
-- Purpose: rank view
--[[TODO List]]

module("MainRankView", package.seeall)

-- UI控件引用变量 --
local json 							= "ui/rank.json"
local m_fnGetWidget 				= g_fnGetWidgetByName --读取UI组件方法
local m_i18n						= gi18n
local m_i18nString 					=  gi18nString
-- 模块局部变量 --
local _listView 
local LSV_LIST 
local m_mainWidget 
local m_tbEvent 
local m_tbBtns 			= nil
local m_tbMyInfoLayer 	= nil

function destroy(...)
	logger:debug("MainRankView destroy")
	package.loaded["MainRankView"] = nil
end

function moduleName()
    return "MainRankView"
end

function init()
    m_tbBtns= {}
    m_tbMyInfoLayer= {}
end


local function setMineInfoVisable(_curIndex)
	for i,v in ipairs(m_tbMyInfoLayer) do
		v:setEnabled(false)
		if(i == _curIndex) then
			v:setEnabled(true)
		end
	end
end


local function setGuildBottemLay(  )
	--公会相关
	local isInGuild = GuildDataModel.getIsHasInGuild()
	logger:debug(isInGuild)
	m_mainWidget.lay_my_guild.tfd_my_guild:setVisible(isInGuild)
	m_mainWidget.lay_my_guild.tfd_my_guild_num:setVisible(isInGuild)
	m_mainWidget.lay_my_guild.tfd_my_rank:setVisible(isInGuild)
	m_mainWidget.lay_my_guild.tfd_my_rank_num:setVisible(isInGuild)

	m_mainWidget.lay_my_guild.tfd_no_guild:setVisible(not isInGuild )

	if(isInGuild == true) then
		m_mainWidget.lay_my_guild.tfd_my_guild:setText(m_i18n[8007]) --8007 我的公会：
		logger:debug(RankModel.getMyGuildName())
		m_mainWidget.lay_my_guild.tfd_my_guild_num:setText(RankModel.getMyGuildName())
		m_mainWidget.lay_my_guild.tfd_my_rank:setText(m_i18n[8008]) --8008 公会排名：
		m_mainWidget.lay_my_guild.tfd_my_rank_num:setText("0") -- todo
	else
		m_mainWidget.lay_my_guild.tfd_no_guild:setText(m_i18n[8006]) -- todo8006 您尚未加入公会
	end
end

local function setSelfRank()
	local curIndex = RankModel.getCurTabIndex()
	local nSelfRank = 0
	if(curIndex == RankModel.T_GuildRank) then
		setGuildBottemLay()
		nSelfRank = tonumber(RankModel.getMyGuildRank())
	else
		nSelfRank =  tonumber(RankModel.getSelfRankValue())
	end
	  

	if(nSelfRank and nSelfRank > 0 and nSelfRank < 101) then 
		m_tbMyInfoLayer[curIndex].tfd_my_rank_num:setText(nSelfRank)
	else
		m_tbMyInfoLayer[curIndex].tfd_my_rank_num:setText(m_i18n[3704]) -- 3704 未上榜
	end

	--设置自己的据点信息
	if(curIndex == RankModel.T_CopyRank) then
		local nselfHoldId = RankModel.getSelfCopyId()
		local copyName,holdName = RankModel.getCopyNameAndHoldNameBy(nselfHoldId)
		m_tbMyInfoLayer[curIndex].tfd_my_copy_name:setText(copyName)
		m_tbMyInfoLayer[curIndex].tfd_my_stronghold_name:setText(holdName)
	end
end


--初始化我的各种数据
local function initMineData(  )
	--等级相关
	m_mainWidget.lay_my_level.tfd_my_level:setText(m_i18n[8004])  --8004 我的等级：
	m_mainWidget.lay_my_level.tfd_my_rank:setText(m_i18n[8003])   --8003 我的排名：
	m_mainWidget.lay_my_level.tfd_my_level_num:setText(UserModel.getHeroLevel())
	m_mainWidget.lay_my_level.tfd_my_rank_num:setText("0") -- todo

	--战力相关
	m_mainWidget.lay_my_fight.tfd_my_fight:setText(m_i18n[8002]) --8002 我的战斗力：
	m_mainWidget.lay_my_fight.tfd_my_fight_num:setText(UserModel.getFightForceValue())
	m_mainWidget.lay_my_fight.tfd_my_rank:setText(m_i18n[8003])
	m_mainWidget.lay_my_fight.tfd_my_rank_num:setText("0") -- todo

	--副本相关
	m_mainWidget.lay_my_copy.tfd_my_copy:setText(m_i18n[8005]) --8005 我的进度：
	m_mainWidget.lay_my_copy.tfd_my_copy_name:setText("")
	m_mainWidget.lay_my_copy.tfd_my_stronghold_name:setText("")
	m_mainWidget.lay_my_copy.tfd_my_rank:setText(m_i18n[8003]) -- todo
	m_mainWidget.lay_my_copy.tfd_my_rank_num:setText("0") -- todo

	--深海监狱相关
	m_mainWidget.lay_my_impel.tfd_my_impel:setText(m_i18n[8005])
	local curDownLevel = tonumber(ImpelDownMainModel.getTopGradeFightId() or 0)
	local str = curDownLevel == 0  and m_i18n[1093] or curDownLevel
	m_mainWidget.lay_my_impel.tfd_my_impel_num:setText(str)
	m_mainWidget.lay_my_impel.tfd_my_rank:setText(m_i18n[8003])
	m_mainWidget.lay_my_impel.tfd_my_rank_num:setText("0") -- todo

	setGuildBottemLay()

	table.insert(m_tbMyInfoLayer,m_mainWidget.lay_my_fight)
	table.insert(m_tbMyInfoLayer,m_mainWidget.lay_my_level)
	table.insert(m_tbMyInfoLayer,m_mainWidget.lay_my_copy)
	table.insert(m_tbMyInfoLayer,m_mainWidget.lay_my_impel)
	table.insert(m_tbMyInfoLayer,m_mainWidget.lay_my_guild)

end

--1.BTN_TAB按钮，未选中的按钮颜色为#bf9367，选中的按钮颜色为#ffffff
local titleSelectColor = ccc3(0xff, 0xff, 0xff)
local titleNormalColor = ccc3(0xbf, 0x93, 0x67)

--设置tab按钮的点击状态和显示状态
function setTabBtnStats( _index )
	for i,v in ipairs(m_tbBtns) do
		v:setFocused(i == _index)
		v:setTouchEnabled(not (i == _index))
		RankModel.setCurTabIndex(_index)
		if(not v:isFocused()) then
			v:setTitleColor(titleNormalColor)
		else
			v:setTitleColor(titleSelectColor)
		end
		
	end

	setMineInfoVisable(_index)
end

--创建按钮
function loadRankTabCell( )
	LSV_LIST = m_fnGetWidget(m_mainWidget, "LSV_TAB")
	UIHelper.initListView(LSV_LIST)

	local cell, nIdx
	for i,iconIndex in ipairs(RankModel.getRankTab()) do
		LSV_LIST:pushBackDefaultItem()	
		nIdx = i - 1
    	cell = LSV_LIST:getItem(nIdx)  -- cell 索引从 0 开始

    	local btnTab = m_fnGetWidget(cell,"BTN_TAB")
    	btnTab:setTitleText(iconIndex)
    	btnTab:setTag(i)
    	btnTab:addTouchEventListener(m_tbEvent.onTabBtn)
    	

		table.insert(m_tbBtns,btnTab)
	end

	setTabBtnStats(1)
end


local function setRankNumLable(cellLay,_rankValue)
	local nRank = tonumber(_rankValue)
	local bgRank1 = nil
	local bgRank2 = nil
	local bgRank3 = nil
	local bgRank4 = nil
	if(RankModel.getCurTabIndex() == RankModel.T_GuildRank) then
		bgRank1 = cellLay.item.IMG_GUILDBG1
		bgRank2 = cellLay.item.IMG_GUILDBG2
		bgRank3 = cellLay.item.IMG_GUILDBG3
		bgRank4 = cellLay.item.IMG_GUILDBG4
	else
		bgRank1 = cellLay.item.IMG_CELLBG1
		bgRank2 = cellLay.item.IMG_CELLBG2
		bgRank3 = cellLay.item.IMG_CELLBG3
		bgRank4 = cellLay.item.IMG_CELLBG4
	end

	bgRank1:setEnabled(false)
	bgRank2:setEnabled(false)
	bgRank3:setEnabled(false)
	bgRank4:setEnabled(false)

	cellLay.item.IMG_RANK_1:setEnabled(false)
	cellLay.item.IMG_RANK_2:setEnabled(false)
	cellLay.item.IMG_RANK_3:setEnabled(false)
	cellLay.item.IMG_RANK:setEnabled(false)
	cellLay.item.LABN_RANK_4:setEnabled(false)

	if(nRank == 1) then
		bgRank1:setEnabled(true)
		cellLay.item.IMG_RANK_1:setEnabled(true)
	elseif(nRank == 2) then
		bgRank2:setEnabled(true)
		cellLay.item.IMG_RANK_2:setEnabled(true)
	elseif(nRank == 3) then
		bgRank3:setEnabled(true)
		cellLay.item.IMG_RANK_3:setEnabled(true)
	else
		bgRank4:setEnabled(true)
		cellLay.item.IMG_RANK:setEnabled(true)
		cellLay.item.LABN_RANK_4:setEnabled(true)
		cellLay.item.LABN_RANK_4:setStringValue(_rankValue)
	end
end


local function setGuildCell(itemcell,itemData)
	itemcell.item.TFD_UNION_LV:setText("LV." .. (itemData.guild_level))
	itemcell.item.TFD_UNION_NAME:setText(tostring(itemData.guild_name))
	itemcell.item.TFD_LEADER_NAME:setText(tostring(itemData.leader_name))
	itemcell.item.TFD_UNION_FIGHT:setText(tostring(tonumber(itemData.fight_force)))
	itemcell.item.TFD_MEMBERS_OWN:setText(tostring(itemData.member_num))
	itemcell.item.TFD_MEMBERS_TOTAL:setText(tostring(itemData.member_limit))
	if(itemData.slogan)then
		itemcell.item.img_declare:setEnabled(true)
		itemcell.item.TFD_DECLARE:setEnabled(true)
		itemcell.item.TFD_DECLARE:setVisible(true)
		itemcell.item.img_declare:setVisible(true)
		itemcell.item.TFD_DECLARE:setText(tostring(itemData.slogan))
	end

	itemcell.item.tfd_union_leader:setText(m_i18n[8012] )     --公会会长
	itemcell.item.tfd_union_fight:setText(m_i18n[8013] )   	 --总战力
	itemcell.item.tfd_union_members:setText(m_i18n[3506] .. "")

	local imgLogo = itemcell.item.IMG_FLAG
	local sIconPath = "images/union/flag/"
	local tbIcon = GuildUtil.getLogoDataById(itemData.guild_logo)
	local imgPath = sIconPath .. tbIcon.img
	imgLogo:loadTexture(imgPath)

	UIHelper.labelNewStroke(itemcell.item.TFD_UNION_LV)

	--按钮--公会相关
	UIHelper.titleShadow(itemcell.item.BTN_APPLY,m_i18n[3507]) --3507 申请
	UIHelper.titleShadow(itemcell.item.BTN_CANCEL,m_i18n[3508])

	local isInGuild = GuildDataModel.getIsHasInGuild()
	logger:debug(isInGuild)
	if(isInGuild == true ) then
		-- itemcell.item.BTN_APPLY:setBright(false)
		itemcell.item.BTN_APPLY:setTouchEnabled(false)
		itemcell.item.BTN_CANCEL:setEnabled(false)
		UIHelper.setWidgetGray(itemcell.item.BTN_APPLY,true)

	else
		--撤销申请
		if(itemData.apply and tonumber(itemData.apply) == 1 ) then
			itemcell.item.BTN_APPLY:setEnabled(false)
			itemcell.item.BTN_CANCEL:setEnabled(true)
		else
			itemcell.item.BTN_APPLY:setEnabled(true)
			itemcell.item.BTN_CANCEL:setEnabled(false)
		end
	
		itemcell.item.BTN_APPLY:setTag(tonumber(itemData.guild_id))
		itemcell.item.BTN_APPLY:addTouchEventListener(MainRankCtrl.applyCallFun)  --聊天

		itemcell.item.BTN_CANCEL:setTag(tonumber(itemData.guild_id))
		itemcell.item.BTN_CANCEL:addTouchEventListener(MainRankCtrl.applyCancleCallFun)  --聊天
	end

	itemcell.item.BTN_COMMUNICATE_LEADER:setTag(tonumber(itemData.leader_uid))
	itemcell.item.BTN_COMMUNICATE_LEADER:addTouchEventListener(MainRankCtrl.onChatIcon)  --聊天
end

local function setPlayerInfoCell(itemcell,itemData)
	itemcell.item.TFD_NAME:setText(tostring(itemData.uname))

	itemcell.item.TFD_NAME_JUNTUAN:setText("")
	if(itemData.guild_name) then
		itemcell.item.TFD_NAME_JUNTUAN:setText("[" .. itemData.guild_name .. "]")
	end
	itemcell.item.TFD_PLAYER_LV:setText(tostring(itemData.level))
	itemcell.item.tfd_lv_txt:setText(m_i18n[1618]) --1618 等级


	itemcell.item.lay_fight:setEnabled(false)
	itemcell.item.lay_impeldown:setEnabled(false)
	itemcell.item.lay_copy:setEnabled(false)

	local ncurIndex = RankModel.getCurTabIndex()
	if(ncurIndex == RankModel.T_FightRank or ncurIndex == RankModel.T_LevelRank) then
		itemcell.item.lay_fight:setEnabled(true)
		itemcell.item.lay_fight.tfd_fight:setText("" .. tonumber(itemData.fight_force))

	elseif(ncurIndex == RankModel.T_CopyRank) then
		itemcell.item.lay_copy:setEnabled(true)

		itemcell.item.lay_copy:setEnabled(true)
		itemcell.item.lay_copy.tfd_copy:setText(m_i18n[1349])  --8001 副本进度
		local copyName,holdName = RankModel.getCopyNameAndHoldNameBy(itemData.last_base)

		itemcell.item.lay_copy.tfd_copy_name:setText("" .. copyName )	 --副本名称
		itemcell.item.lay_copy.tfd_stronghold:setText("   " .. holdName)	 --据点名称

	elseif(ncurIndex == RankModel.T_PrisonRank) then

		itemcell.item.lay_impeldown:setEnabled(true)
		itemcell.item.lay_impeldown.tfd_impeldown:setText(m_i18n[8011])  --8011 深海监狱进度：
		itemcell.item.lay_impeldown.tfd_impeldown_num:setText(m_i18nString(7807,itemData.max_level))
	end

	local LSV_HEROES = itemcell.item.LSV_HEROES
	LSV_HEROES:removeAllItems()
   	for k,v in ipairs(itemData.squad or {}) do
   		LSV_HEROES:pushBackDefaultItem()
		local heroIcon = HeroUtil.createHeroIconBtnByHtid(v.htid)
		local cell = LSV_HEROES:getItem( k -1 )
		heroIcon:setScale(g_fScaleX)

		cell:addChild(heroIcon)
		cell:setSize(CCSizeMake(cell:getSize().width*g_fScaleX,cell:getSize().height*g_fScaleX))
		heroIcon:setPosition(ccp(cell:getSize().width*.5,cell:getSize().height*.5))
   	end
	itemcell.item.BTN_BUZHEN:setTag(tonumber(itemData.uid))
	itemcell.item.BTN_BUZHEN:addTouchEventListener(MainRankCtrl.onFormation)  --聊天

end

local function setPeopleCellLayVisable( cell,_visable )
	cell.item.IMG_CELLBG4:setVisible(_visable)
	cell.item.IMG_CELLBG2:setVisible(_visable)
	cell.item.IMG_CELLBG3:setVisible(_visable)
	cell.item.IMG_CELLBG1:setVisible(_visable)
	cell.item.LAY_ORIGIN_RANK:setVisible(_visable)
end

local function setGuildCellLayVisable( cell,_visable )
	cell.item.IMG_GUILDBG4:setVisible(_visable)
	cell.item.IMG_GUILDBG3:setVisible(_visable)
	cell.item.IMG_GUILDBG2:setVisible(_visable)
	cell.item.IMG_GUILDBG1:setVisible(_visable)
	cell.item.LAY_UNION:setVisible(_visable)
end

function updateCellByIdex( lsv, idx )
	local tbRankInfo =  RankModel.getRankListData()
	logger:debug(idx)
	logger:debug(tbRankInfo[idx + 1])
	local tbData = tbRankInfo[idx + 1]
	if(tbData == nil) then
		logger:debug(tbRankInfo)
	end
	local cell = lsv:getItem(idx)
	if(tbData == nil) then
		return 
	end
	local nRank = tonumber(tbData.rank)

	cell.item.BTN_MORE:setEnabled(false)
	if(tbData.more == true) then
		cell.item.BTN_MORE:setEnabled(true)
		cell.item.BTN_MORE:setTouchEnabled(true)
		cell.item.BTN_MORE:setTag(tonumber(tbData.offset))
		cell.item.BTN_MORE:addTouchEventListener(MainRankCtrl.onMoreCell)  --聊天
		if(RankModel.getCurTabIndex() == RankModel.T_GuildRank) then
			setGuildCellLayVisable(cell,false)
		else
			setPeopleCellLayVisable(cell,false)
		end
	elseif(RankModel.getCurTabIndex() == RankModel.T_GuildRank) then
		setGuildCellLayVisable(cell,true)

		setGuildCell(cell,tbData)
		setRankNumLable(cell,nRank)
	else

		setPeopleCellLayVisable(cell,true)
		setPlayerInfoCell(cell,tbData)
		setRankNumLable(cell,nRank)
	end
	-- cell:updateSizeAndPosition()
end

function initListViewBy()
	-- logger:debug(RankModel.getRankListData())
	if(#(RankModel.getRankListData()) > 0) then
		m_mainWidget.LAY_PEOPLE_CELL:setEnabled(true)
		m_mainWidget.LAY_GUILD_CELL:setEnabled(true)

		if(RankModel.getCurTabIndex() ~= RankModel.T_GuildRank) then
			UIHelper.initListViewCell(_listView,m_mainWidget.LAY_PEOPLE_CELL)
		else
			UIHelper.initListViewCell(_listView,m_mainWidget.LAY_GUILD_CELL)
		end

		UIHelper.reloadListView(_listView, #(RankModel.getRankListData()), updateCellByIdex,0)
		m_mainWidget.LAY_PEOPLE_CELL:setEnabled(false)
		m_mainWidget.LAY_GUILD_CELL:setEnabled(false)

		m_mainWidget.tfd_rank_no:setVisible(false)
	else
		UIHelper.reloadListView(_listView, #(RankModel.getRankListData()), updateCellByIdex,0)
		m_mainWidget.tfd_rank_no:setVisible(true)
		if(RankModel.getCurTabIndex() ~= RankModel.T_GuildRank) then
			m_mainWidget.tfd_rank_no:setText(m_i18n[8009]) --todo8009 当前无人上榜
		else
			m_mainWidget.tfd_rank_no:setText(m_i18n[8010]) -- 8010 当前没有公会
		end
	end

	setSelfRank()
end

function reloadGuildListView(  )
	UIHelper.reloadListView(_listView, #(RankModel.getRankListData()), updateCellByIdex)
end

function create(tbEvent)
	m_tbEvent = tbEvent
	init()
	m_mainWidget = g_fnLoadUI(json)
	local IMGBG1 = m_fnGetWidget(m_mainWidget,"img_bg")
	IMGBG1:setScale(g_fScaleX)

	m_mainWidget.LAY_PEOPLE_CELL.IMG_CELLBG1:setScale(g_fScaleX)
	m_mainWidget.LAY_PEOPLE_CELL.IMG_CELLBG2:setScale(g_fScaleX)
	m_mainWidget.LAY_PEOPLE_CELL.IMG_CELLBG3:setScale(g_fScaleX)
	m_mainWidget.LAY_PEOPLE_CELL.IMG_CELLBG4:setScale(g_fScaleX)
	m_mainWidget.LAY_PEOPLE_CELL.BTN_MORE:setScale(g_fScaleX)
	m_mainWidget.LAY_GUILD_CELL.BTN_MORE:setScale(g_fScaleX)

	m_mainWidget.LAY_GUILD_CELL.IMG_GUILDBG4:setScale(g_fScaleX)
	m_mainWidget.LAY_GUILD_CELL.IMG_GUILDBG3:setScale(g_fScaleX)
	m_mainWidget.LAY_GUILD_CELL.IMG_GUILDBG2:setScale(g_fScaleX)
	m_mainWidget.LAY_GUILD_CELL.IMG_GUILDBG1:setScale(g_fScaleX)
	m_mainWidget.LAY_PEOPLE_CELL.LSV_HEROES:setScale(g_fScaleX)

	m_mainWidget.LAY_PEOPLE_CELL:setSize(CCSizeMake( m_mainWidget.LAY_PEOPLE_CELL:getSize().width * g_fScaleX,m_mainWidget.LAY_PEOPLE_CELL:getSize().height * g_fScaleX))
	m_mainWidget.LAY_GUILD_CELL:setSize(CCSizeMake( m_mainWidget.LAY_GUILD_CELL:getSize().width * g_fScaleX,m_mainWidget.LAY_GUILD_CELL:getSize().height * g_fScaleX))

	local LSV_HEROES = m_mainWidget.LAY_PEOPLE_CELL.LSV_HEROES
	UIHelper.initListView(LSV_HEROES)
	initMineData()
	--初始化tabCell
	loadRankTabCell() 
	_listView = m_mainWidget.LSV_MAIN

	m_mainWidget.tfd_rank_no:setText(m_i18n[8009]) --todo8009 当前无人上榜

    local imgChain    = m_fnGetWidget(m_mainWidget,"img_chain")
    imgChain:setScale(g_fScaleX)
	return m_mainWidget
end

--给云鹏的去获取返回调用
function refreshListViewAfterDrop(  )
	UIHelper.reloadListView(_listView, #(RankModel.getRankListData()), updateCellByIdex,0)
end