-- FileName: ArenaReplay.lua
-- Author:huxiaozhou 
-- Date: 2014-12-13
-- Purpose: 竞技场王者对决


module("ArenaReplay", package.seeall)

local arena_rank_json = "ui/arena_rank.json"
-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName

local m_mainWidget
local m_LSV_MAIN
local m_tbEvent
local TFD_RANK_PRESTAGE  -- 可获得声望
local m_i18n = gi18n
local m_i18nString = gi18nString

local function init(...)

end

function destroy(...)
	package.loaded["ArenaReplay"] = nil
end

function moduleName()
    return "ArenaReplay"
end

local _tRankColor2 = {ccc3(0xc8, 0x50, 0x00), ccc3(0x6c, 0x6a, 0x68), ccc3(0x9f, 0x4f, 0x36), ccc3(0x82, 0x56, 0x00)}

function loaded( _layModule , tbItemData, index)
	local img_cellselfbg = m_fnGetWidget(_layModule, "IMG_CELLSELFBG") -- 自己的背景
	local img_cellbg = m_fnGetWidget(_layModule, "IMG_CELLBG") -- 别人或者NPC的背景
	local IMG_CELLBG1 = m_fnGetWidget(_layModule, "IMG_CELLBG1") --第一名背景
	local IMG_CELLBG2 = m_fnGetWidget(_layModule, "IMG_CELLBG2")
	local IMG_CELLBG3 = m_fnGetWidget(_layModule, "IMG_CELLBG3")

	img_cellselfbg:removeFromParentAndCleanup(true)
	img_cellbg:setScale(g_fScaleX)
	IMG_CELLBG1:setScale(g_fScaleX)
	IMG_CELLBG2:setScale(g_fScaleX)
	IMG_CELLBG3:setScale(g_fScaleX)
	
	if (tonumber(tbItemData.attack_position) == 1) then
		img_cellbg:removeFromParentAndCleanup(true)
		IMG_CELLBG1:setVisible(true)
		IMG_CELLBG1:removeAllChildren()
		IMG_CELLBG2:removeFromParentAndCleanup(true)
		IMG_CELLBG3:removeFromParentAndCleanup(true)

	elseif(tonumber(tbItemData.attack_position) == 2) then
		IMG_CELLBG1:removeFromParentAndCleanup(true)
		IMG_CELLBG2:removeAllChildren()
		IMG_CELLBG3:removeFromParentAndCleanup(true)
		img_cellbg:removeFromParentAndCleanup(true)
	elseif(tonumber(tbItemData.attack_position) == 3) then
		IMG_CELLBG1:removeFromParentAndCleanup(true)
		IMG_CELLBG2:removeFromParentAndCleanup(true)
		IMG_CELLBG3:removeAllChildren()
		img_cellbg:removeFromParentAndCleanup(true)
	else
		img_cellbg:removeAllChildren()
		IMG_CELLBG1:removeFromParentAndCleanup(true)
		IMG_CELLBG2:removeFromParentAndCleanup(true)
		IMG_CELLBG3:removeFromParentAndCleanup(true)
	end
	--[[
		attack_position = "1"
		replay = "10175"
		defend_position = "4"
		defend_uid = "23674"
		defend_utid = "2"
		rise = "1"
		attack_uname = "军爷1001"
		defend_uname = "1801"
		attack_uid = "21223"
		attack_utid = "2"
		}
	--]]

	

	local TFD_ATTACK_NAME = m_fnGetWidget(_layModule, "TFD_ATTACK_NAME")
	TFD_ATTACK_NAME:setText(tbItemData.attack_uname)

	TFD_ATTACK_NAME:setColor(UserModel.getPotentialColor({htid = tbItemData.attack_figure}))


	local TFD_DEFENCE_NAME = m_fnGetWidget(_layModule, "TFD_DEFENCE_NAME")
	if tbItemData.defend_armyId ~= nil then
		local name = ArenaData.getNpcName(tbItemData.defend_uid, tbItemData.defend_utid)
		TFD_DEFENCE_NAME:setText(name)
		require "db/DB_Monsters"
		local htid = DB_Monsters.getDataById(tbItemData.defend_figure).htid
		TFD_DEFENCE_NAME:setColor(UserModel.getPotentialColor({htid = htid}))
		tbItemData.defend_uname = name
	else
		TFD_DEFENCE_NAME:setText(tbItemData.defend_uname)
		TFD_DEFENCE_NAME:setColor(UserModel.getPotentialColor({htid = tbItemData.defend_figure}))
	end
	
	local TFD_WINNER = m_fnGetWidget(_layModule, "TFD_WINNER") 
	TFD_WINNER:setText(tbItemData.attack_uname)
	local TFD_LOSER = m_fnGetWidget(_layModule, "TFD_LOSER")
	TFD_LOSER:setText(tbItemData.defend_uname)

	local LABN_RANK_UP = m_fnGetWidget(_layModule, "LABN_RANK_UP")
	LABN_RANK_UP:setStringValue(tbItemData.rise)

	local img_attack_name_bg = m_fnGetWidget(_layModule, "img_attack_name_bg")
	local img_defence_name_bg = m_fnGetWidget(_layModule, "img_defence_name_bg")

	local LABN_ATK_RANK = m_fnGetWidget(_layModule, "LABN_ATK_RANK")
	local img_ming1 = m_fnGetWidget(_layModule, "img_ming1")
	local rank = tonumber(tbItemData.attack_position)
	if rank==1 or rank==2 or rank==3 then
		LABN_ATK_RANK:removeFromParent()
		img_ming1:removeFromParent()
		img_defence_name_bg:loadTexture("images/arena/bag_cell_txt_" .. rank .. "_s.png")
		img_attack_name_bg:loadTexture("images/arena/bag_cell_txt_" .. rank .. "_s.png")
	else
		img_defence_name_bg:loadTexture("images/arena/bag_cell_txt_" .. 4 .. "_s.png")
		img_attack_name_bg:loadTexture("images/arena/bag_cell_txt_" .. 4 .. "_s.png")
		LABN_ATK_RANK:setStringValue(rank)
	end

	



	for i=1,3 do
		local imgRank = m_fnGetWidget(_layModule, "IMG_ATK_RANK" .. i)
		if rank ~= i then
			imgRank:removeFromParent()
		end
	end



	local LABN_DEF_RANK = m_fnGetWidget(_layModule, "LABN_DEF_RANK")
	
	local img_ming2 = m_fnGetWidget(_layModule, "img_ming2")
	local defRank = tonumber(tbItemData.defend_position)
	if defRank==1 or defRank==2 or defRank==3 then
		img_ming2:removeFromParent()
		LABN_DEF_RANK:removeFromParent()
	else
		LABN_DEF_RANK:setStringValue(defRank)
	end
	for i=1,3 do
		local imgRank = m_fnGetWidget(_layModule, "IMG_DEF_RANK" .. i)
		if defRank ~= i then
			imgRank:removeFromParent()
		end
	end

	loadIcon(_layModule, "img_attack", "img_photo1", tbItemData.attack_figure)

	local htid = 0
	if tbItemData.defend_armyId ~= nil then
		require "db/DB_Monsters"
		htid = DB_Monsters.getDataById(tbItemData.defend_figure).htid
	else
		htid = tbItemData.defend_figure -- zhangqi, 2015-01-09, 去主角后修改 
	end
	loadIcon(_layModule, "img_defence", "img_photo2", htid)
	TFD_LOSER:setColor(UserModel.getPotentialColor({htid = htid}))
	TFD_WINNER:setColor(UserModel.getPotentialColor({htid = tbItemData.attack_figure}))
	local BTN_REPORT = m_fnGetWidget(_layModule, "BTN_REPORT")
	BTN_REPORT:setTag(index)
	BTN_REPORT:addTouchEventListener(m_tbEvent.onReplayBattle)
	UIHelper.titleShadow(BTN_REPORT, m_i18n[2170])

	_layModule.tfd_challenge:setText(m_i18n[3653])
	_layModule.tfd_win:setText(m_i18n[2272])
	_layModule.tfd_rank_up:setText(m_i18n[2273])
	_layModule.tfd_ming:setText(m_i18n[2274])
	local color2 = _tRankColor2[rank]
	if color2 then
		_layModule.tfd_challenge:setColor(color2)
		_layModule.tfd_win:setColor(color2)
		_layModule.tfd_rank_up:setColor(color2)
		_layModule.tfd_ming:setColor(color2)
	end

end

function loadIcon(_layModule, sImgKey1, sImgKey2, htid)
	local heroInfo = HeroUtil.getHeroLocalInfoByHtid(htid)
	local bgFile = "images/base/potential/officer_" .. heroInfo.potential .. ".png"
	local imgKey1 = m_fnGetWidget(_layModule, sImgKey1)
	local imgKey2 = m_fnGetWidget(_layModule, sImgKey2)
	imgKey1:loadTexture(bgFile)
	imgKey2:loadTexture(HeroUtil.getHeroIconImgByHTID(htid))
end


function updateUI( )
	local img_main_bg = m_fnGetWidget(m_mainWidget, "img_main_bg")
	-- img_main_bg:setScale(g_fScaleX)
	-- listView
	m_LSV_MAIN = m_fnGetWidget(m_mainWidget,"LSV_MAIN")
	local ReplayData = ArenaData.getReplayList(  )

	local layModule = m_fnGetWidget(m_LSV_MAIN, "LAY_MODULE")
	local LAY_ORIGIN_RANK = m_fnGetWidget(layModule, "LAY_ORIGIN_RANK")
	LAY_ORIGIN_RANK:removeFromParentAndCleanup(true)
	-- layModule:setScale(g_fScaleX)
	local tempSize = layModule:getSize()
	layModule:setSize(CCSizeMake(tempSize.width * g_fScaleX, tempSize.height * g_fScaleX))

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

	local BTN_LUCKY = m_fnGetWidget(LAY_INFO_RANK, "BTN_LUCKY")
	BTN_LUCKY:addTouchEventListener(m_tbEvent.onLuckRank)

	for i=1, #ReplayData do
      	local itemModule = layModule:clone()
      	local val = ReplayData[i]
      	loaded(itemModule,val, i)
        m_LSV_MAIN:pushBackCustomItem(itemModule)
        -- layModule = itemModule
        local lay = m_fnGetWidget(itemModule, "LAY_TEST")
        UIHelper.startCellAnimation(lay, i, function ( ... )
        	logger:debug("动画播放完成了")
        end, 1)
  	end
  	m_LSV_MAIN:removeItem(0)


  	UIHelper.labelNewStroke(tfd_rank_now, ccc3(0x28, 0x00, 0x00), 2)
	UIHelper.labelNewStroke(tfd_prestige_now, ccc3(0x28, 0x00, 0x00), 2)
	UIHelper.labelNewStroke(TFD_PRESTAGE, ccc3(0x28, 0x00, 0x00), 2)
	UIHelper.labelNewStroke(TFD_RANK, ccc3(0x28, 0x00, 0x00), 2)

end


function create( tbEvent)
	m_tbEvent = tbEvent
	m_mainWidget = g_fnLoadUI(arena_rank_json)
	m_mainWidget:setSize(g_winSize)
	updateUI()
	return m_mainWidget
end
