-- FileName: ArenaRankView.lua
-- Author: huxiaozhou
-- Date: 2014-05-09
-- Purpose: 竞技场排行面板
--[[TODO List]]

module ("ArenaRankView",package.seeall)
require "script/module/public/UIHelper"
require "db/i18n"
local arena_rank_json = "ui/arena_rank.json"
-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName

local m_mainWidget
local m_LSV_MAIN
local m_tbEvent
local m_i18n = gi18n
local m_i18nString = gi18nString

local function init(...)
	m_LSV_MAIN = nil
end

function destroy(...)
	package.loaded["ArenaRankView"] = nil
end

function moduleName()
    return "ArenaRankView"
end


local _tRankColor = {ccc3(0x81, 0x43, 0x19), ccc3(0x43, 0x42, 0x40), ccc3(0x6e, 0x25, 0x23), ccc3(0x57, 0x1e, 0x01)}
local _tRankColor2 = {ccc3(0xc8, 0x50, 0x00), ccc3(0x6c, 0x6a, 0x68), ccc3(0x9f, 0x4f, 0x36), ccc3(0x82, 0x56, 0x00)}

function loaded( _layModule , tbItemData)

	-- 一堆控件
	local TFD_PLAYER_LV =  m_fnGetWidget(_layModule, "TFD_PLAYER_LV") -- 等级
	local TFD_NAME =  m_fnGetWidget(_layModule, "TFD_NAME") -- 名字
	local LABN_RANK_AFTER4 =  m_fnGetWidget(_layModule, "LABN_RANK_AFTER4") -- 排名
	local TFD_BELLY_CELL = m_fnGetWidget(_layModule, "TFD_BELLY_CELL") -- 获得贝里
	local TFD_PRESTIGE_CELL = m_fnGetWidget(_layModule, "TFD_PRESTIGE_CELL") -- 获得声望


	local img_cellselfbg = m_fnGetWidget(_layModule, "IMG_CELLSELFBG") -- 自己的背景
	local img_cellbg = m_fnGetWidget(_layModule, "IMG_CELLBG") -- 别人或者NPC的背景
	local IMG_CELLBG1 = m_fnGetWidget(_layModule, "IMG_CELLBG1") --第一名背景
	local IMG_CELLBG2 = m_fnGetWidget(_layModule, "IMG_CELLBG2")
	local IMG_CELLBG3 = m_fnGetWidget(_layModule, "IMG_CELLBG3")

	img_cellselfbg:setScale(g_fScaleX)
	img_cellbg:setScale(g_fScaleX)
	IMG_CELLBG1:setScale(g_fScaleX)
	IMG_CELLBG2:setScale(g_fScaleX)
	IMG_CELLBG3:setScale(g_fScaleX)

	local IMG_RANKNUM1 = m_fnGetWidget(_layModule, "IMG_RANKNUM1")
	local IMG_RANKNUM2 = m_fnGetWidget(_layModule, "IMG_RANKNUM2")
	local IMG_RANKNUM3 = m_fnGetWidget(_layModule, "IMG_RANKNUM3")
	local IMG_RANK = m_fnGetWidget(_layModule,"IMG_RANK")
	local LSV_HEROES = m_fnGetWidget(_layModule, "LSV_HEROES") -- 伙伴列表

	LSV_HEROES:setSize(CCSizeMake(LSV_HEROES:getSize().width*g_fScaleX,LSV_HEROES:getSize().height*g_fScaleX))
	
	local img_luckyrank = m_fnGetWidget(_layModule, "img_luckyrank") -- 伙伴列表

	local  TFD_NAME_JUNTUAN = m_fnGetWidget(_layModule, "TFD_NAME_JUNTUAN") -- 军团名称
	local BTN_BUZHEN = m_fnGetWidget(_layModule, "BTN_BUZHEN") -- 阵容按钮
	UIHelper.titleShadow(BTN_BUZHEN,m_i18n[2215])

	BTN_BUZHEN:addTouchEventListener(m_tbEvent.onFormation)
	BTN_BUZHEN:setTag(tbItemData.uid)

	-- 幸
   	if(tonumber(tbItemData.luck) ~= 1)then
	   img_luckyrank:setVisible(false)
	end
	if tbItemData.guild_name then
		tbItemData.guildname = "【" .. tbItemData.guild_name .."】"
	end

	-- 军团名字
	TFD_NAME_JUNTUAN:setText(tbItemData.guildname or "")
	-- 判断是否是npc
	local isNpc = nil
	logger:debug({tbItemData = tbItemData})
	if(tonumber(tbItemData.armyId) ~= 0) then 
		isNpc = true
		local utid = tonumber(tbItemData.utid)
   		local npc_name = ArenaData.getNpcName( tonumber(tbItemData.uid), utid)
   		TFD_NAME:setText(npc_name)
   		TFD_NAME:setColor(g_QulityColor[5])
	else 
		TFD_NAME:setText(tbItemData.uname)
		TFD_NAME:setColor(UserModel.getPotentialColor({htid = tbItemData.figure})) 
	end

	local color1 = _tRankColor[tonumber(tbItemData.position)]
	if color1 then
		TFD_PLAYER_LV:setColor(color1)
		TFD_PRESTIGE_CELL:setColor(color1)
		TFD_BELLY_CELL:setColor(color1)
		TFD_NAME_JUNTUAN:setColor(color1)
	end

	_layModule.tfd_reward:setText(m_i18n[2209])
	_layModule.tfd_lv_txt:setText(m_i18n[1067])
	local color2 = _tRankColor2[tonumber(tbItemData.position)]
	if color2 then
		_layModule.tfd_reward:setColor(color2)
		_layModule.tfd_lv_txt:setColor(color2)
	end
	
	if (tonumber(tbItemData.position) == 1) then
		img_cellselfbg:removeFromParentAndCleanup(true)
		img_cellbg:removeFromParentAndCleanup(true)
		IMG_CELLBG1:setVisible(true)
		IMG_CELLBG2:removeFromParentAndCleanup(true)
		IMG_CELLBG3:removeFromParentAndCleanup(true)
		IMG_RANKNUM2:removeFromParentAndCleanup(true)
		IMG_RANKNUM3:removeFromParentAndCleanup(true)
		LABN_RANK_AFTER4:removeFromParentAndCleanup(true)
		IMG_RANK:removeFromParentAndCleanup(true)

	elseif(tonumber(tbItemData.position) == 2) then
		IMG_CELLBG1:removeFromParentAndCleanup(true)
		IMG_CELLBG2:setVisible(true)
		IMG_CELLBG3:removeFromParentAndCleanup(true)
		img_cellselfbg:removeFromParentAndCleanup(true)
		img_cellbg:removeFromParentAndCleanup(true)
		IMG_RANKNUM1:removeFromParentAndCleanup(true)
		IMG_RANKNUM2:setVisible(true)
		IMG_RANKNUM3:removeFromParentAndCleanup(true)
		LABN_RANK_AFTER4:removeFromParentAndCleanup(true)
		IMG_RANK:removeFromParentAndCleanup(true)
	elseif(tonumber(tbItemData.position) == 3) then
		IMG_CELLBG1:removeFromParentAndCleanup(true)
		IMG_CELLBG2:removeFromParentAndCleanup(true)
		IMG_CELLBG3:setVisible(true)
		img_cellselfbg:removeFromParentAndCleanup(true)
		img_cellbg:removeFromParentAndCleanup(true)
		IMG_RANKNUM1:removeFromParentAndCleanup(true)
		IMG_RANKNUM2:removeFromParentAndCleanup(true)
		IMG_RANKNUM3:setVisible(true)
		LABN_RANK_AFTER4:removeFromParentAndCleanup(true)
		IMG_RANK:removeFromParentAndCleanup(true)
	else
		-- img_frame:removeFromParentAndCleanup(true)
		IMG_CELLBG1:removeFromParentAndCleanup(true)
		IMG_CELLBG2:removeFromParentAndCleanup(true)
		IMG_CELLBG3:removeFromParentAndCleanup(true)
		IMG_RANKNUM1:removeFromParentAndCleanup(true)
		IMG_RANKNUM2:removeFromParentAndCleanup(true)
		IMG_RANKNUM3:removeFromParentAndCleanup(true)
		-- 区分自己和别的玩家
		if( tonumber(tbItemData.uid) == UserModel.getUserUid() )then
			img_cellbg:removeFromParentAndCleanup(true)
			LABN_RANK_AFTER4:setStringValue(tbItemData.position)
		else
			img_cellselfbg:removeFromParentAndCleanup(true)
			LABN_RANK_AFTER4:setStringValue(tbItemData.position)
		end
	end

	
	-- 获得的奖励
   	local silverData,prestigeData = ArenaData.getAwardItem(tbItemData.position,tbItemData.level)
	TFD_PLAYER_LV:setText(tbItemData.level)
	
	TFD_BELLY_CELL:setText(silverData)
	TFD_PRESTIGE_CELL:setText(prestigeData)


	local LAY_HERO_SAMPLE = m_fnGetWidget(LSV_HEROES, "LAY_HERO_SAMPLE")

	-- 名将背景
   	if( isNpc )then
   		BTN_BUZHEN:setEnabled(false)
   		-- 创建NPC名将头像
	   	local numTem = 0
	   	for k,v in pairs(tbItemData.squad) do
	   		local heroIcon = HeroUtil.createNPCHeroIconBtnByHtid(tonumber(v))

	   		local cell = LAY_HERO_SAMPLE:clone()

			heroIcon:setScale(g_fScaleX)

			cell:addChild(heroIcon)

			cell:setSize(CCSizeMake(cell:getSize().width*g_fScaleX,cell:getSize().height*g_fScaleX))

			heroIcon:setPosition(ccp(cell:getSize().width*.5,cell:getSize().height*.5))

			LSV_HEROES:pushBackCustomItem(cell)
	   	end
	   	LSV_HEROES:removeItem(0)
   	else
	   	-- 创建非NPC名将头像
	   	for k,v in pairs(tbItemData.squad) do
			local heroIcon = HeroUtil.createHeroIconBtnByHtid(v.htid)
			local cell = LAY_HERO_SAMPLE:clone()
			heroIcon:setScale(g_fScaleX)

			cell:addChild(heroIcon)

			cell:setSize(CCSizeMake(cell:getSize().width*g_fScaleX,cell:getSize().height*g_fScaleX))

			heroIcon:setPosition(ccp(cell:getSize().width*.5,cell:getSize().height*.5))

			LSV_HEROES:pushBackCustomItem(cell)
	   	end
	   	LSV_HEROES:removeItem(0)
   	end

end

function updateUI( )
	local img_main_bg = m_fnGetWidget(m_mainWidget, "img_main_bg")
	-- img_main_bg:setScale(g_fScaleX)
	-- listView
	m_LSV_MAIN = m_fnGetWidget(m_mainWidget,"LSV_MAIN")
	local topTenData = ArenaData.getTopTenData( ArenaData.rankListData )

	local layModule = m_fnGetWidget(m_LSV_MAIN, "LAY_MODULE")
	local LAY_HIGHEST = m_fnGetWidget(layModule, "LAY_HIGHEST")
	LAY_HIGHEST:removeFromParentAndCleanup(true)
	-- layModule:setScale(g_fScaleX)
	local tempSize = layModule:getSize()
	layModule:setSize(CCSizeMake(tempSize.width * g_fScaleX, tempSize.height * g_fScaleX))
	logger:debug(topTenData)

	local LAY_INFO_RANK = m_fnGetWidget(m_mainWidget, "LAY_INFO_RANK")
  	-- 当前排名数据
	local curData = ArenaData.getSelfRanking() or 0
	local TFD_RANK =  m_fnGetWidget(LAY_INFO_RANK, "TFD_RANK") -- 排名
	TFD_RANK:setText(curData)

	local tfd_rank_now = m_fnGetWidget(LAY_INFO_RANK, "tfd_rank_now") --当前排名
	tfd_rank_now:setText(gi18nString(2204))
	-- 当前声望值
	local numData = UserModel.getPrestigeNum() or 0
	local TFD_PRESTAGE = m_fnGetWidget(LAY_INFO_RANK, "TFD_PRESTAGE")
	TFD_PRESTAGE:setText(numData)


	local tfd_prestige_now = m_fnGetWidget(LAY_INFO_RANK, "tfd_prestige_now") --当前声望
	tfd_prestige_now:setText(gi18nString(2205))


	UIHelper.labelNewStroke(tfd_rank_now, ccc3(0x28, 0x00, 0x00), 2)
	UIHelper.labelNewStroke(tfd_prestige_now, ccc3(0x28, 0x00, 0x00), 2)
	UIHelper.labelNewStroke(TFD_PRESTAGE, ccc3(0x28, 0x00, 0x00), 2)
	UIHelper.labelNewStroke(TFD_RANK, ccc3(0x28, 0x00, 0x00), 2)




	local BTN_LUCKY = m_fnGetWidget(LAY_INFO_RANK, "BTN_LUCKY")
	BTN_LUCKY:addTouchEventListener(m_tbEvent.onLuckRank)

	for i=1, #topTenData do
      	local itemModule = layModule:clone()
      	local val = topTenData[i]
      	loaded(itemModule,val)
        m_LSV_MAIN:pushBackCustomItem(itemModule)
        -- layModule = itemModule
        local lay = m_fnGetWidget(itemModule, "LAY_TEST")
        UIHelper.startCellAnimation(lay, i, function ( ... )
        	logger:debug("动画播放完成了")
        end, 1)
  	end
  	m_LSV_MAIN:removeItem(0)
end


function create( tbEvent)
	m_tbEvent = tbEvent
	m_mainWidget = g_fnLoadUI(arena_rank_json)
	m_mainWidget:setSize(g_winSize)
	updateUI()
	return m_mainWidget
end