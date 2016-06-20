-- FileName: PartnerSuccSelectCtrl.lua
-- Author: zhaoqiangjun
-- Date: 2014-06-19
-- Purpose: 伙伴选择列表ctrl

--[[
-- tbPartnerData = {name = "小刀海贼-" .. idx, sign = "item_type_shadow.png", 
					icon = btnIcon, sLevel = "Lv." .. idx, 
					nStar = 4, sQuality = idx,
                    sTransfer = idx, onLoad = func, -- load
 }
--]]

module("PartnerSuccSelectCtrl", package.seeall)

require "script/module/public/Cell/HeroCell"
require "script/module/public/ChooseList"
require "script/model/hero/HeroModel"
require "script/model/user/UserModel"
require "script/module/formation/MainFormation"
require "script/module/public/ShowNotice"


local m_fnGetWidget = g_fnGetWidgetByName
local m_i18n = gi18n
local tbCell = {}
local m_nSelectedNum = 0
local m_tbSelectedID = {}
local m_nTotalExp = 0
local m_showType
local m_nEquipBeStrongID
local m_heroPos
local m_hid
local m_behid
local numSourceType 
local numSrcLocation  
local m_tbEquipDatas = {}

local function backToFormation( ... )
	
	--更新阵型主界面
	-- print("去内容")
    LayerManager.removeLayout()   
end

local function advanceBtnTouchEvent( hid )
	require "script/module/partner/PartnerTransfer"
	require "script/model/hero/HeroModel"

	local allHeroes = HeroModel.getAllHeroes()
	for heroid,heroInfo in pairs(allHeroes) do
		local htid 			= heroInfo.htid
		if(heroInfo.htid == hid) then
			local pHeroinfo = heroInfo
			local tArgs = { selectedHeroes = pHeroinfo }
		    local layer = PartnerTransfer.create(tArgs,numSourceType , numSrcLocation)
		    
		    if (layer) then
		        LayerManager.changeModule(layer, PartnerTransfer.moduleName(), {1})
		        PlayerPanel.addForPartnerStrength()
		        PartnerTransfer.changepPaomao()
		    end
			return
		end
	end

    local tArgs = { selectedHeroes = allHeroes[tostring(hid)]}
    local layer = PartnerTransfer.create(tArgs,numSourceType , numSrcLocation)
    if (layer) then
        LayerManager.changeModule(layer, PartnerTransfer.moduleName(), {1})
        PartnerTransfer.changepPaomao()
    end
end

local function getHeroNameByHid( herohid )
	
    
    local heroInfo  =  HeroModel.getHeroByHid(herohid)
    local htid = heroInfo.htid
    local heroDBInfo = DB_Heroes.getDataById(htid)
    local heroId = heroDBInfo.model_id;

    if ((tonumber(heroId) < 20003 and tonumber(heroId)>20000) or ((tonumber(heroId) > 20100 and tonumber(heroId) < 20211))) then
        return UserModel.getUserName()
    else
        return heroDBInfo.name
    end
end

-- 判定已经上阵同类型的伙伴
local function justiceHeroesDoubleByHid( hid )
	
	local htid = HeroModel.getHeroByHid(hid).htid
	local htidNumber = tonumber(htid)
	local t_squad
	t_squad = DataCache.getSquad()

	for i,v in pairs(t_squad) do

		if (tonumber(v) ~= 0) then
			local vhtid =  HeroModel.getHeroByHid(v).htid

			if (htidNumber == tonumber(vhtid)) then
				return true
			end
		end
	end

	t_squad = DataCache.getExtra()
	for i,v in pairs(t_squad) do

		if (tonumber(v) ~= 0) then
			local vhtid =  HeroModel.getHeroByHid(v).htid
			if (htidNumber == tonumber(vhtid)) then
				return true
			end
		end
	end
	return false
end

-- 判定已经上阵的伙伴
local function justiceHeroesOnSquad( hid )

	local hidNumber = tonumber(hid)
	t_squad = DataCache.getSquad()

	for i,v in pairs(t_squad) do
		if (hidNumber == tonumber(v)) then
			return true
		end
	end

	t_squad = DataCache.getExtra()
	for i,v in ipairs(t_squad) do
		if (hidNumber == tonumber(v)) then
			return true
		end
	end
	return false
end

local function justiceRoleOfHero( htid )
	
    local heroDBInfo = DB_Heroes.getDataById(htid)
    local heroId = heroDBInfo.model_id;

	if ((tonumber(htid) < 20003 and tonumber(htid)>20000) or ((tonumber(htid) > 20100 and tonumber(htid) < 20211))) then
        return true
    else
		return false
    end
end

--处理伙伴的信息（处理成需要显示的样子）
local function solveTheHeroCellInfo(k, v, tbHerosData )
	
	--去掉在阵上或者在小伙伴上的伙伴

	local htid 		= v.htid
	local heroData 	= DB_Heroes.getDataById(htid)
	--需要添加的伙伴信息
	local tbData 	= {}
	tbData.id 		= htid
	tbData.idx 		= k
	tbData.isRole	= justiceRoleOfHero(htid)
	tbData.isForm	= justiceHeroesOnSquad(v.hid)
	tbData.sLevel 	= v.level
	tbData.sQuality = heroData.potential
	tbData.nQuality	= heroData.potential
	tbData.heroQuality = heroData.heroQuality
	tbData.name 	= getHeroNameByHid(v.hid)
	tbData.sign 	= ItemUtil.getGroupOfHeroByInfo(heroData)
	tbData.icon 	= {id = htid, bHero = true, onTouch = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
	        local tArgs = { selectedHeroes = tbData }
	        if (layer) then
	            LayerManager.addLayoutNoScale(layer)
	            PartnerInformation.initScvHeight()
	            require "script/module/partner/PartnerInfoCtrl"
		        local pHeroValue = tbData --PartnerModle.getHeroDataByHid(m_tbHeroesValue[sender.idx])
		        logger:debug({pHeroValue=pHeroValue})
		        local tbherosInfo = {}
		        local heroInfo = {htid = pHeroValue.htid ,hid = pHeroValue.id ,strengthenLevel = pHeroValue.sLevel ,transLevel = pHeroValue.evolve_level,heroValue = pHeroValue }
		        table.insert(tbherosInfo,heroInfo)
		        local tArgs = {}
		        tArgs.heroInfo = heroInfo
		        local layer = PartnerInfoCtrl.create(tArgs,4)     --所选择武将信息22
		        LayerManager.addLayoutNoScale(layer)
        
	        else
	            logger:error("PartnerInformation  nil")
	        end
	    elseif (eventType == TOUCH_EVENT_BEGAN) then
	        local frameLight = CCSprite:create("images/hero/quality/highlighted.png")
	        frameLight:setAnchorPoint(ccp(0.5, 0.5))
	        sender:addNode(frameLight,10,tagFrameLight)
	    elseif (eventType == TOUCH_EVENT_CANCELED) then
	        sender:removeNodeByTag(tagFrameLight)
	    end
	end}
	tbData.nStar	= heroData.star_lv
	tbData.sTransfer= v.evolve_level

	--上阵按钮的触发事件
	tbData.onTransfer 		= function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			advanceBtnTouchEvent(sender.phid)
		end
	end

	table.insert( tbHerosData, tbData )
end


local function sort(hero_1, hero_2)

	local isPre = false
	if hero_1.isRole then
		isPre = true
		return isPre
	elseif (hero_2.isRole) then
		isPre = false
		return isPre
	end

	if (hero_1.isForm == true and hero_2.isForm == false) then
		isPre = true
		return isPre
	elseif (hero_1.isForm == false and hero_2.isForm == true) then
		isPre = false
		return isPre
	end

	if( tonumber(hero_1.sQuality) > tonumber(hero_2.sQuality))then
		isPre = true
	elseif(tonumber(hero_1.sQuality) == tonumber(hero_2.sQuality))then

		if(tonumber(hero_1.sLevel) > tonumber(hero_2.sLevel))then
			isPre = true
		elseif(tonumber(hero_1.sLevel) == tonumber(hero_2.sLevel)) then
			if tonumber(hero_1.id) > tonumber(hero_2.id) then
				isPre = true
			else
				isPre = false
			end
		else
			isPre = false
		end
	else
		isPre = false
	end

	return isPre
end

local function loadAllHeroes( allHeroes )
	
	local tabHeroes 		= {}
	for heroid,heroInfo in pairs(allHeroes) do
		local htid 			= heroInfo.htid
		local heroDBInfo	= DB_Heroes.getDataById(htid)
		heroInfo["heroDesc"]= heroDBInfo
		table.insert(tabHeroes, heroInfo)
	end
	return tabHeroes
end

local function solveTheHerosInfo( ... )
	
	local tbHerosData = {}
	require "script/model/hero/HeroModel"
	local allHeroes = HeroModel.getAllHeroes()
	local tabHeroes_ = loadAllHeroes(allHeroes)

	require "script/module/partner/HeroSortUtil"
    local tbAllHerosInfo = HeroSortUtil.fnSortOfHero(tabHeroes_)

	for k,v in pairs(tbAllHerosInfo) do
		solveTheHeroCellInfo(k, v, tbHerosData)
	end

	table.sort(tbHerosData, sort)

	return tbHerosData
end

--获取所有的装备
local function getAllOfHeros( ... )
	
	local allHeros = {}
	local tbAllHerosInfo = solveTheHerosInfo()
	--将伙伴身上的装备放到装备列表中
	for i,v in ipairs(tbAllHerosInfo) do
		table.insert(allHeros, v)
	end
	return allHeros
end 

local function init(...)
	m_nTotalExp = 0
end


function destroy(...)
	package.loaded["PartnerSuccSelectCtrl"] = nil
end


function moduleName()
	return "PartnerSuccSelectCtrl"
end


function create( compa_type, hpos ,heroHid ,srcType,srcLocation)
	m_behid 	= heroHid
	m_heroPos 	= hpos
	m_showType	= compa_type
	if (srcType) then
        numSourceType = srcType
        numSrcLocation = srcLocation
    else
        numSourceType  = 1
    end
	init()

	local tbHeroListInfo = getAllOfHeros()

	logger:debug("tbHeroListInfo:")
	logger:debug(tbHeroListInfo)

	local tbEventListener = {}

	tbEventListener.onBack = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playBackEffect()
			if (m_showType == 3) then
				advanceBtnTouchEvent(m_behid)
			else
				LayerManager.removeLayout()
			end
		end
	end

	tbEventListener.onSure = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			LayerManager.removeLayout()
		end
	end

	local instTableView
	local tbInfo = {}

	tbInfo.sType = CHOOSELIST.LOADPARTNER
	tbInfo.onBack = tbEventListener.onBack
	tbInfo.tbState = {sChoose = m_i18n[1020],sChooseNum = m_nSelectedNum,
		sExp = m_i18n[1060], sExpNum = m_nTotalExp, onOk = tbEventListener.onSure}


	tbInfo.tbView = {}
	tbInfo.tbView.szCell = g_fnCellSize(CELLTYPE.PARTNER)
	tbInfo.tbView.tbDataSource = tbHeroListInfo

	tbInfo.tbView.CellAtIndexCallback = function (tbDat)
		local instCell = PartnerCell:new()
		instCell:init(CELL_USE_TYPE.TRANSFER)
		instCell:refresh(tbDat)
		return instCell
	end

	tbInfo.tbView.CellTouchedCallback = function ( view, cell, objCell)
		-- local index = cell:getIdx()
		-- local tbData = tbHeroListInfo[index + 1]

		-- if (not tbData.bSelect) then
		-- 	if (m_nSelectedNum < 5) then
		-- 		tbData.bSelect = not tbData.bSelect
		-- 		objCell.cbxSelect:setSelectedState(tbData.bSelect)

		-- 		m_nSelectedNum = m_nSelectedNum + 1
		-- 		m_nTotalExp = m_nTotalExp + tbData.sExp
		-- 		tbInfo.tbState.sChooseNum = m_nSelectedNum
		-- 		tbInfo.tbState.sExpNum = m_nTotalExp
		-- 		table.insert(m_tbSelectedID, tbData.id)
		-- 	else
		-- 		logger:debug("max num is 5")
		-- 		ShowNotice.showShellInfo(m_i18n[1058])
		-- 	end
		-- else
		-- 	tbData.bSelect = not tbData.bSelect
		-- 	objCell.cbxSelect:setSelectedState(tbData.bSelect)

		-- 	m_nSelectedNum = m_nSelectedNum - 1
		-- 	m_nTotalExp = m_nTotalExp - tbData.sExp
		-- 	tbInfo.tbState.sChooseNum = m_nSelectedNum
		-- 	tbInfo.tbState.sExpNum = m_nTotalExp
		-- 	for i=1,#m_tbSelectedID do
		-- 		if (m_tbSelectedID[i] == tbData.id) then
		-- 			table.remove(m_tbSelectedID, i)
		-- 		end
		-- 	end
		-- end
		-- instTableView:refreshChooseStateNum(tbInfo.tbState)
	end

	instTableView = ChooseList:new()
	local layMain = instTableView:create(tbInfo)

	logger:debug("wm－－－－－show")
	LayerManager.setPaomadeng(layMain , 1000)
	UIHelper.registExitAndEnterCall(layMain, function ( ... )
		LayerManager.resetPaomadeng()
	end)

	return layMain
end