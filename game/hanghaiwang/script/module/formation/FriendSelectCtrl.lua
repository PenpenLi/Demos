-- FileName: FriendSelectCtrl.lua
-- Author: zhaoqiangjun
-- Date: 2014-06-19
-- Purpose: 伙伴选择列表

--[[
-- tbPartnerData = {name = "小刀海贼-" .. idx, sign = "item_type_shadow.png", 
					icon = btnIcon, sLevel = "Lv." .. idx, 
					nStar = 4, sQuality = idx,
                    sTransfer = idx, onLoad = func, -- load
 }
--]]

module("FriendSelectCtrl", package.seeall)

require "script/module/public/Cell/HeroCell"
require "script/module/public/ChooseList"
require "script/model/hero/HeroModel"
require "script/model/user/UserModel"
require "script/module/formation/MainFormation"
require "script/module/public/ShowNotice"

local m_i18n = gi18n
local m_dataCache = DataCache
local m_userModel = UserModel
local m_mainFM = MainFormation
local m_mainFMTools = MainFormationTools
local m_fnGetWidget = g_fnGetWidgetByName
local tbCell = {}
local m_nSelectedNum = 0
local m_tbSelectedID = {}
local m_nTotalExp = 0
local m_showType
local m_nEquipBeStrongID
local m_heroPos
local m_hid
local m_behid
local m_behtid

local m_tbEquipDatas = {}

--更新阵型主界面
local function backToFormation( ... )
    LayerManager.removeLayout()
    m_mainFM.showWidgetMain()
    
	require "script/module/guide/GuideModel"
	require "script/module/guide/GuideFiveLevelGiftView"
	if (GuideModel.getGuideClass() == ksGuideFiveLevelGift and GuideFiveLevelGiftView.guideStep == 8) then  
	    require "script/module/guide/GuideCtrl"
	    GuideCtrl.setPersistenceGuide("shop","11")
	    GuideCtrl.createkFiveLevelGiftGuide(9)
	    m_mainFM.setHeroPageViewTouchEnabled(false)
	    m_mainFM.hideActiveEffect()
	end  

	require "script/module/guide/GuideCopy2BoxView"
	if (GuideModel.getGuideClass() == ksGuideCopy2Box and GuideCopy2BoxView.guideStep == 12) then
		require "script/module/guide/GuideCtrl"
		GuideCtrl.createCopy2BoxGuide(13)
		m_mainFM.setHeroPageViewTouchEnabled(false)
		m_mainFM.hideActiveEffect()
	end

end


local function addExtraCallback( cbFlag, dictData, bRet )
	local extraData = dictData.ret
	if extraData == "ok" then
		m_userModel.updateFightValue()
		--处理小伙伴
		local extra = m_dataCache.getExtra()
		extra[m_heroPos] = m_hid
		m_dataCache.setExtra(extra)

		  --刷新伙伴列表数据   2014-11-17  zhangjunwu
        require "script/module/partner/MainPartner"
        MainPartner.replaceHeroDataByHid(m_hid) 
        if(tonumber(m_behid) > 0) then
			MainPartner.replaceHeroDataByHid(m_behid) 
		end

        m_userModel.setInfoChanged(true)
		m_userModel.updateFightValue({[m_hid] = {}})
		--更新阵容界面
		m_mainFM.updateExtra(m_hid, m_heroPos)

		backToFormation()
	end
end
--上阵回调 选择伙伴
local function addHeroCallback( cbFlag, dictData, bRet )
	if (tostring(dictData.err) == "ok") then
		--更新战斗力
		m_userModel.updateFightValue({[m_hid] = {}})

		--更新上阵信息
	    local t_squad = m_dataCache.getSquad()
	    t_squad["" .. m_heroPos - 1] = tonumber(m_hid)
	    m_dataCache.setSquad(t_squad)
	    
	    --阵型信息
		local t_formationInfo = {}
		for k,v in pairs(dictData.ret) do
	        t_formationInfo["" .. (tonumber(k)-1)] = tonumber(v)
	    end
		m_dataCache.setFormationInfo(t_formationInfo)


		--更新装备信息
		require "script/model/hero/HeroModel"
		--这里的3是因为切换伙伴的列表的id改为3了,因此0就不对了，只能改成3了。
		if (m_behid and tonumber(m_behid) > 3 )then
			HeroModel.exchangeEquipInfo(m_behid, m_hid)
		end 

		-- 点击上阵后拉取新伙伴的羁绊信息
		local htid = HeroModel.getHtidByHid(tonumber(m_hid))
		local modelId = HeroModel.getHeroModelId(htid)
		--BondRequst.getArrUnionByHero(modelId, function ( ... )
			-- m_userModel.setInfoChanged(true) -- zhangqi, 标记需要刷新战斗力
			-- m_userModel.updateFightValue({[m_hid] = {}})
			-- --更新阵容界面
			-- m_mainFM.updateFormation(m_heroPos, m_hid, nil, nil, true)

			-- backToFormation()
		--end)

		m_userModel.setInfoChanged(true) -- zhangqi, 标记需要刷新战斗力
		m_userModel.updateFightValue({[m_hid] = {}})
		--更新阵容界面
		m_mainFM.updateFormation(m_heroPos, m_hid, nil, nil, true)

		backToFormation()

         --刷新伙伴列表数据   2014-11-17  zhangjunwu
        require "script/module/partner/MainPartner"
        MainPartner.replaceHeroDataByHid(m_hid) 

        if(tonumber(m_behid) > 0) then
			MainPartner.replaceHeroDataByHid(m_behid) 
		end
	end
end

--[[desc:替补上阵的回调
    arg1: 
    return: 是否有返回值，返回值说明  
—]]
local function addBenchCallback( cbFlag, dictData, bRet )
	if (tostring(dictData.err) == "ok") then
		m_userModel.updateFightValue({[m_hid] = {}})

		--更新上阵信息
	    local t_bench = m_dataCache.getBench()
	    local pos = m_heroPos - tonumber(m_mainFMTools.fnGetSquadNum()) - 1
	    t_bench["" .. pos] = tonumber(m_hid)
	    m_dataCache.getBench(t_bench)

		--更新装备信息
		require "script/model/hero/HeroModel"
		--这里的3是因为切换伙伴的列表的id改为3了,因此0就不对了，只能改成3了。
		if (m_behid and tonumber(m_behid) > 3 )then
			HeroModel.exchangeEquipInfo(m_behid, m_hid)
		end

		-- 点击上阵后拉取新伙伴的羁绊信息
		local htid = HeroModel.getHtidByHid(tonumber(m_hid))
		local modelId = HeroModel.getHeroModelId(htid)
		-- BondRequst.getArrUnionByHero(modelId, function ( ... )
		-- 	m_userModel.setInfoChanged(true) -- zhangqi, 标记需要刷新战斗力
		-- 	m_userModel.updateFightValue({[m_hid] = {}})
		-- 	--更新阵容界面
		-- 	m_mainFM.updateFormation(m_heroPos, m_hid, nil, nil, true)

		-- 	backToFormation()
		-- end)
		m_userModel.setInfoChanged(true) -- zhangqi, 标记需要刷新战斗力
		m_userModel.updateFightValue({[m_hid] = {}})
		--更新阵容界面
		m_mainFM.updateFormation(m_heroPos, m_hid, nil, nil, true)

		backToFormation()

         --刷新伙伴列表数据   2014-11-17  zhangjunwu
        require "script/module/partner/MainPartner"
        MainPartner.replaceHeroDataByHid(m_hid) 

        if(tonumber(m_behid) > 0) then
			MainPartner.replaceHeroDataByHid(m_behid) 
		end
	end
end


local function getHeroNameByHid( herohid )
    local heroInfo  =  HeroModel.getHeroByHid(herohid)
    local htid = heroInfo.htid
    local heroDBInfo = DB_Heroes.getDataById(htid)
    local heroId = heroDBInfo.model_id;

    if ((tonumber(heroId) < 20003 and tonumber(heroId)>20000) or ((tonumber(heroId) > 20100 and tonumber(heroId) < 20211))) then
        return m_userModel.getUserName()
    else
        return heroDBInfo.name
    end
end

-- 判定已经上阵同类型的伙伴
local function justiceHeroesDoubleByHid( hid , _htid)
	local pHid = hid or nil
	local htid = nil
	if(pHid) then
		htid = HeroModel.getHeroByHid(pHid).htid
	else
		htid = _htid or nil
	end
	if(not htid) then
		return false
	end
	local htidNumber = tonumber(htid)
	local t_squad
	t_squad = m_dataCache.getSquad()

	for i,hid in pairs(t_squad) do
		if (tonumber(hid) > 0) then
			local vhtid =  HeroModel.getHeroByHid(v) and HeroModel.getHeroByHid(v).htid or 0
			if (htidNumber == tonumber(vhtid)) then
				return true
			end
		else

		end
	end

	t_squad = m_dataCache.getExtra()
	for i,hid in pairs(t_squad) do
		--zhangjunwu 2014-11-15  大于0表示小伙伴位置上有人，等于0表示没有人,-1 标识小伙伴位置还未开放
		if (tonumber(hid) > 0) then
			local vhtid = HeroModel.getHeroByHid(v) and  HeroModel.getHeroByHid(v).htid or 0
			if (htidNumber == tonumber(vhtid)) then
				return true
			end
		end
	end

	t_squad = m_dataCache.getBench()
	for i,hid in pairs(t_squad) do
		--zhangjunwu 2014-11-15  大于0表示小伙伴位置上有人，等于0表示没有人,-1 标识小伙伴位置还未开放
		if (tonumber(hid) > 0) then
			local vhtid =  HeroModel.getHeroByHid(v) and HeroModel.getHeroByHid(v).htid or 0
			if (htidNumber == tonumber(vhtid)) then
				return true
			end
		end
	end
	return false
end


--获取数组对应的羁绊数
local function getTbJinBanNum( htid , datas )
	local JibanNum = 0
	if(not datas or not tonumber(htid)) then
		return 0
	end
	for pos,hid in pairs(datas) do
		hid = tonumber(hid) or -1
		if(hid > 0 and tonumber(m_behid) ~= hid) then
			local lhtid =  HeroModel.getHeroByHid(hid).htid
			local heroDBInfo = DB_Heroes.getDataById(lhtid)
			local groupInfo = heroDBInfo.link_group1
			if(groupInfo) then
				local hGroupInfo = lua_string_split(groupInfo, ",")
				for i,groupId in ipairs(hGroupInfo) do
					local linkInfo 	= DB_Union_profit.getDataById(groupId)
					local linkCards = linkInfo.union_card_ids
					local linkType = lua_string_split(linkCards, "|")[1]
					if(tonumber(linkType) == 1) then 		--等于1表示英雄羁绊，2是宝物羁绊
						JibanNum = JibanNum + 1 			--现将该羁绊加上去，如果在下面检测出来没有激活，那么就再减去1不算
						local linkCardArr = lua_string_split(linkCards,",")
						local isOnForm 	= false
						for lCId,lCards in ipairs(linkCardArr) do  		--先确定是否在阵上
							local lCardArr 	= lua_string_split(lCards,"|")
							-- local lHitd = lCardArr[2]
							local lHitd = tonumber(HeroModel.fnGetHaveHtidByModelID(lCardArr[2])) or 0
							if(tonumber(htid) == tonumber(lHitd)) then
								isOnForm = true
							end
						end
						if(isOnForm) then
							local continue = true
							for lCId,lCards in ipairs(linkCardArr) do  --然后确定其他两个是否在阵上
								if(continue) then
									local lCardArr = lua_string_split(lCards,"|")
									-- local lHitd = lCardArr[2]
									local lHitd = tonumber(HeroModel.fnGetHaveHtidByModelID(lCardArr[2])) or 0
									if( (tonumber(m_behtid) == tonumber(lHitd)) or 
									  ((tonumber(htid) ~= tonumber(lHitd)) and (not justiceHeroesDoubleByHid(nil , lHitd))) ) then 	--如果没有busy并且不是要换的这个
										JibanNum = JibanNum - 1
										continue = false
									end
								end
							end
						else
							JibanNum = JibanNum - 1
						end
					end
				end
			end
		end
	end
	return JibanNum
end

--获得将要激活的羁绊数
local function getJibanNumByhtid( htid )
	local JibanNum = 0

	--算阵上伙伴的。
	local squadData = m_dataCache.getSquad()
	JibanNum = JibanNum + getTbJinBanNum(htid , squadData)
	squadData = m_dataCache.getBench()
	JibanNum = JibanNum + getTbJinBanNum(htid , squadData)

	if m_showType == 2 then
		return JibanNum
	end
	
	local heroDBInfo 	= DB_Heroes.getDataById(htid)
	local groupInfo 	= heroDBInfo.link_group1
	if groupInfo then
		local hGroupInfo = lua_string_split(groupInfo, ",")
		for i,groupId in ipairs(hGroupInfo) do

			local linkInfo 	= DB_Union_profit.getDataById(groupId)
			local linkCards = linkInfo.union_card_ids
			local linkType 	= lua_string_split(linkCards, "|")[1]

			if tonumber(linkType) 	== 1 then 		--等于1表示英雄羁绊，2是宝物羁绊
				JibanNum = JibanNum + 1 			--现将该羁绊加上去，如果在下面检测出来没有激活，那么就再减去1不算
				local linkCardArr 	= lua_string_split(linkCards,",")
				local continue 	= true
				for lCId,lCards in ipairs(linkCardArr) do
					if continue then
						local lCardArr = lua_string_split(lCards,"|")
						-- local lHitd = lCardArr[2]
						local lHitd = tonumber(HeroModel.fnGetHaveHtidByModelID(lCardArr[2])) or 0
							
					    if(	(tonumber(m_behtid) == tonumber(lHitd)) or 
					    	 (tonumber(htid) ~= tonumber(lHitd) and (not justiceHeroesDoubleByHid(nil , lHitd))) ) then 	--如果既没在伙伴阵上，又没在小伙伴阵上
							JibanNum 	= JibanNum - 1
							continue 	= false
						end
					end
				end
			end
		end
	end

	return JibanNum
end

--处理伙伴的信息（处理成需要显示的样子）
local function solveTheHeroCellInfo( v, tbHerosData )
	--去掉在阵上或者在小伙伴上的伙伴
	if m_dataCache.isHeroBusy(v.hid) then
		return
	end

	local htid 		= v.htid
	local heroData 	= DB_Heroes.getDataById(htid)
	local maxLevel	= UserModel.getHeroLevel()
	--需要添加的伙伴信息
	local tbData 	= {}
	tbData.db_hero = heroData
	tbData.hid      = v.hid
	tbData.htid     = tonumber(htid)
	tbData.id 		= htid

	-- tbData.JibanNum = getJibanNumByhtid(htid)
	tbData.sLevel 	= v.level.."/"..maxLevel	-- 用于显示 xx/xx
	tbData.lv 		= v.level 					-- 用于使用
	tbData.heroQuality 	= heroData.heroQuality
	tbData.nQuality	= heroData.potential
	-- tbData.name 	= getHeroNameByHid(v.hid)
	tbData.name 	= heroData.name
	tbData.sign 	= ItemUtil.getGroupOfHeroByInfo(heroData)
	
	tbData.trend 	= heroData.trend
	tbData.icon 	= {id = htid, bHero = true, onTouch = function ( sender, eventType )

		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playInfoEffect()
	        local tArgs = { selectedHeroes = tbData }
	        require "script/module/partner/PartnerInfoCtrl"
	        local pHeroValue = tbData--PartnerModle.getHeroDataByHid(m_tbHeroesValue[sender.idx])
	        local heroInfo = {htid = pHeroValue.htid ,hid = pHeroValue.hid ,strengthenLevel = pHeroValue.sLevel ,transLevel = v.evolve_level,heroValue = pHeroValue ,showOnly = true}
	        tArgs.heroInfo = heroInfo
	        local layer = PartnerInfoCtrl.create(tArgs,4)     --所选择武将信息22
	        LayerManager.addLayoutNoScale(layer)
        
	    elseif (eventType == TOUCH_EVENT_BEGAN) then
	        local frameLight = CCSprite:create("images/hero/quality/highlighted.png")
	        frameLight:setAnchorPoint(ccp(0.5, 0.5))
	        sender:addNode(frameLight,10,tagFrameLight)
	    elseif (eventType == TOUCH_EVENT_CANCELED) then
	        sender:removeNodeByTag(tagFrameLight)
	    end
	end}
	tbData.nStar	= heroData.star_lv
	tbData.sTransfer= "+"..v.evolve_level
	tbData.heroid 	= v.hid
	tbData.awake_attr 	= v.awake_attr
	tbData.disillusion_quality 	= heroData.disillusion_quality
    tbData.isCanAwake = heroData.disillusion_quality and SwitchModel.getSwitchOpenState(ksSwitchAwake or 40) 

	--上阵按钮的触发事件
	tbData.onLoad 		= function ( sender, eventType )
		if (eventType 	== TOUCH_EVENT_ENDED) then

			AudioHelper.playCommonEffect()
			--需要检查是否有同样的伙伴在阵上。
			local herohid = sender:getTag()
			if justiceHeroesDoubleByHid(v.hid) then
				ShowNotice.showShellInfo(m_i18n[1214])
			else
				m_hid = herohid
				local htid = HeroModel.getHtidByHid(tonumber(m_hid))
				local modelId = HeroModel.getHeroModelId(htid)
				BondRequst.getArrUnionByHero(modelId, function ( ... )

					local pNum = tonumber(m_mainFMTools.fnGetSquadNum())
					local pos = m_showType == 3 and (m_heroPos - pNum) or m_heroPos
					local args = Network.argsHandler(m_hid, pos - 1)
					--根据选择的不同来判断究竟是伙伴还是小伙伴
					if(m_showType == 1) then
						RequestCenter.formation_addHero(addHeroCallback, args)
					elseif(m_showType == 2) then
						RequestCenter.formation_addExtra(addExtraCallback,args)
					elseif(m_showType == 3) then
						RequestCenter.formation_addBench(addBenchCallback,args)
					end

				end)
			end
		end
	end
	
	table.insert( tbHerosData, tbData )
end


local nQuality1, nQuality2 = 0, 0
local nLevel1, nLevel2 = 0, 0
local function sort(hero_1, hero_2)	
	local isPre = false
	-- local JibanNum1, JibanNum2 = tonumber(hero_1.JibanNum), tonumber(hero_2.JibanNum)
	-- if JibanNum1 > JibanNum2 then
	-- 	isPre = true
	-- elseif JibanNum1 == JibanNum2 then
		nQuality1, nQuality2 = tonumber(hero_1.nQuality), tonumber(hero_2.nQuality)
		if ( nQuality1 > nQuality2 ) then
			isPre = true
		elseif ( nQuality1 == nQuality2 )then
			nLevel1, nLevel2 = tonumber(hero_1.lv), tonumber(hero_2.lv)
			if ( nLevel1 > nLevel2 ) then
				isPre = true
			elseif( nLevel1 == nLevel2 ) then
				if tonumber(hero_1.id) < tonumber(hero_2.id) then
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
	--end
	
	return isPre
end

local function solveTheHerosInfo( ... )
	local tbHerosData = {}

	require "script/model/hero/HeroModel"
	local tbAllHerosInfo = HeroModel.getAllHeroes()

	for k,v in pairs(tbAllHerosInfo) do
		solveTheHeroCellInfo(v, tbHerosData)
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
	package.loaded["FriendSelectCtrl"] = nil
end


function moduleName()
	return "FriendSelectCtrl"
end

--[[desc:功能简介
    arg1: compa_type 1-阵容，2-小伙伴，3-替补
    return: 是否有返回值，返回值说明  
—]]
function create( compa_type, hpos ,heroHid )
	logger:debug("enter friend Select ctrl")
	m_mainFM.hideWidgetMain()
	m_behid 	= tonumber(heroHid) or 3
	m_behtid    = -1
	if(m_behid > 0 ) then
		local pHeroinfo = HeroModel.getHeroByHid(m_behid) or nil
		if(pHeroinfo) then
			m_behtid = tonumber(pHeroinfo.htid) or -1
		end
	end
	m_heroPos 	= hpos
	m_showType	= compa_type or 1
	if(m_showType == 1) then
		local pNum = tonumber(m_mainFMTools.fnGetSquadNum())
		if(tonumber(m_heroPos) > pNum) then
			m_showType = 3
		end

	end

	init()

	local tbHeroListInfo = getAllOfHeros()


	local tbEventListener = {}

	tbEventListener.onBack = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playBackEffect()
			m_mainFM.showWidgetMain()
			LayerManager.removeLayout()
		end
	end

	tbEventListener.onSure = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			m_mainFM.showWidgetMain()
			LayerManager.removeLayout()
		end
	end

	local instTableView
	local tbInfo = {}
	if m_showType == 1 then
		tbInfo.sType = CHOOSELIST.LOADPARTNER
	elseif(m_showType == 2) then
		tbInfo.sType = CHOOSELIST.LITTLE
	elseif(m_showType == 3) then
		tbInfo.sType = CHOOSELIST.LOADPARTNER
	end
	tbInfo.onBack = tbEventListener.onBack
	tbInfo.tbState = {sChoose = m_i18n[1020], sChooseNum = m_nSelectedNum,
		sExp = m_i18n[1060], sExpNum = m_nTotalExp, onOk = tbEventListener.onSure}


	tbInfo.tbView = {}
	tbInfo.tbView.szCell = g_fnCellSize(CELLTYPE.PARTNER)
	tbInfo.tbView.tbDataSource = tbHeroListInfo
	--创建cell
	tbInfo.tbView.CellAtIndexCallback = function (tbDat)
		local instCell = PartnerCell:new()
		--类型为LOAD,更换列表
		instCell:init(CELL_USE_TYPE.LOAD)
		instCell:refresh(tbDat)
		return instCell
	end
	--ChooseList
	instTableView = ChooseList:new()

	local layMain = instTableView:create(tbInfo)


------------------------- new guide begin --------------------------------------------------------
	LayerManager.addUILayer()
	require "script/module/guide/GuideModel"
    require "script/module/guide/GuideFiveLevelGiftView"
    performWithDelayFrame(nil, function ( ... )
    	 if (GuideModel.getGuideClass() == ksGuideFiveLevelGift and GuideFiveLevelGiftView.guideStep == 7) then 
        	assert(instTableView.objView ~= nil, "再遇见这个问题找策划，招募没招募到伙伴")
          	-- add by huxiaozhou 2014-08-20 modified 2015-11-26
          	instTableView.objView.view:setTouchEnabled(false)
			local cell = instTableView.objView.view:cellAtIndex(0)
			local layCell = instTableView.objView.tbCellMap[cell]
			local pos = layCell.btnLoad:getWorldPosition()
			logger:debug("pos.x = %s pos.y = %s", pos.x, pos.y)
			GuideCtrl.createkFiveLevelGiftGuide(8,0,pos)
	    end  

       	require "script/module/guide/GuideCopy2BoxView"
		if (GuideModel.getGuideClass() == ksGuideCopy2Box and GuideCopy2BoxView.guideStep == 11) then
			require "script/module/guide/GuideCtrl"
			 -- add by huxiaozhou 2014-08-20 modified 2015-11-26
	         	instTableView.objView.view:setTouchEnabled(false)
	         	local cell = instTableView.objView.view:cellAtIndex(0)
				local layCell = instTableView.objView.tbCellMap[cell]
				local pos = layCell.btnLoad:getWorldPosition()
				logger:debug("pos.x = %s pos.y = %s", pos.x, pos.y)
				GuideCtrl.createCopy2BoxGuide(12,0,pos)
		end

		LayerManager.removeUILayer()
    end, 2)
   
 


----------------------- new guide end -----------------------------------------------------------------
	return layMain
end