-- FileName: RecomLitFriSelect.lua
-- Author: zhaoqiangjun
-- Date: 14-11-15
-- Purpose: function description of module

require "script/GlobalVars"
require "db/DB_Heroes"
require "db/DB_Union_profit"
require "script/module/public/HZListView"
require "script/module/formation/RecomFriCell"
require "script/module/public/ShowNotice"
require "script/module/public/UIHelper"

module("RecomLitFriSelect", package.seeall)

local jsonRecom = "ui/formation_recommand.json"
local widgetRecom
local mCache = DataCache

local layTabView 			--tableview放置的layout
local layTabCell 			--tableview的Cell
local recomTabView 			--推荐小伙伴的tableView
local recomFriInfo 			--推荐小伙伴的数据信息
local m_hid
local m_heroPos
local m_activeJiBan 		--激活羁绊的数目

local m_i18n 	= gi18n
local m_i18nString 	= gi18nString
local m_getWidget 	= g_fnGetWidgetByName
local m_formWidget

--创建新的tableview，显示推荐小伙伴

local function cellAtIndex( tbData, idx)
	local cell = RecomFriCell:new(layTabCell)
	cell:init(tbData)
	cell:refresh(tbData,idx,1)
	return cell
end

local function createTableView( ... )

	recomTabView = HZListView:new()

	recomCfg = {}
	recomCfg.szView = CCSizeMake(layTabView:getSize().width, layTabView:getSize().height) 	--tableView的大小
	local szSize 	= layTabCell:getSize()
	recomCfg.szCell = CCSizeMake(szSize.width*g_fScaleX, szSize.height*g_fScaleX) 						--cell的size
	recomCfg.tbDataSource = recomFriInfo 						--数据源
	recomCfg.CellAtIndexCallback = cellAtIndex

    if (recomTabView:init(recomCfg)) then
        local hzLayout = TableViewLayout:create(recomTabView:getView())
        layTabView:addChild(hzLayout)
        -- layList:addNode(self.objView:getView())
        recomTabView:refresh()
    end
    
	local LAYCELL 	= m_getWidget(layTabView,"LAY_CELL")
    LAYCELL:removeFromParentAndCleanup(true)
end

--推荐伙伴排序
local function sortRecomPartner( hero_1, hero_2 )
	local isPre = false

	local herostate1, herostate2 = tonumber(hero_1.isForm), tonumber(hero_2.isForm)
	if herostate1 < herostate2 then
		isPre = true
	elseif herostate1 == herostate2 then
		local groupCount1, groupCount2 = table.count(hero_1.GroupArr), table.count(hero_2.GroupArr)
		if (groupCount1 > groupCount2) then
			isPre = true
		elseif(groupCount1 == groupCount2) then
			local nQuality1, nQuality2 = tonumber(hero_1.quality), tonumber(hero_2.quality)
			if ( nQuality1 > nQuality2 ) then
				isPre = true
			elseif ( nQuality1 == nQuality2 )then
				nLevel1, nLevel2 = tonumber(hero_1.level), tonumber(hero_2.level)
				if ( nLevel1 > nLevel2 ) then
					isPre = true
				elseif( nLevel1 == nLevel2 ) then
					if tonumber(hero_1.htid) < tonumber(hero_2.htid) then
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
		end
	end

	return isPre
end

--是否在阵容上,未在阵上返回true
local function isOnSquadByHtid( htid )
	local squadData = mCache.getSquad()
	for pos,sqhid in pairs(squadData) do
		if tonumber(sqhid) > 0 then
			local sqInfo = HeroModel.getHeroByHid(sqhid)
			local mhtid 	= sqInfo.htid
			if tonumber(mhtid) == tonumber(htid) then
				return false
			end
		end
	end
	--20150105 wangming修改，添加替补的判断
	local squadData = mCache.getBench()
	for pos,sqhid in pairs(squadData) do
		if tonumber(sqhid) > 0 then
			local sqInfo = HeroModel.getHeroByHid(sqhid)
			local mhtid 	= sqInfo.htid
			if tonumber(mhtid) == tonumber(htid) then
				return false
			end
		end
	end

	return true
end

--是否是小伙伴阵上
local function isOnExtraByHtid( htid )
	local extraData = mCache.getExtra()
	for pos,extrahid in ipairs(extraData) do
		if tonumber(extrahid) > 0 then
			local extraInfo = HeroModel.getHeroByHid(extrahid)
			local mhtid 	= extraInfo.htid

			if tonumber(mhtid) == tonumber(htid) then
				local hid = extraInfo.hid
				return true, hid
			end
		end
	end
	return false, 0
end

--修改返回的数据类型，一个羁绊名称对应一条羁绊数据
local function getLinkByHtid( htid )
	local tabLinkHtid 	= {}

	local heroDBInfo 	= DB_Heroes.getDataById(htid)
	local groupInfo 	= heroDBInfo.link_group1

	if groupInfo then
		local hGroupInfo 	= lua_string_split(groupInfo, ",")

		for i,groupId in ipairs(hGroupInfo) do

			local linkInfo 	= DB_Union_profit.getDataById(groupId)
			local lname 	= linkInfo.union_arribute_name
			local linkCards = linkInfo.union_card_ids
			local linkType 	= lua_string_split(linkCards, "|")[1]

			if tonumber(linkType) 	== 1 then 		--等于1表示英雄羁绊，2是宝物羁绊
				local linkCardArr 	= lua_string_split(linkCards, ",")
				for lCId,lCards in ipairs(linkCardArr) do
					local lCardArr 	= lua_string_split(lCards,"|")
					-- local lHitd 	= lCardArr[2]
					local lHitd = tonumber(HeroModel.fnGetHaveHtidByModelID(lCardArr[2])) or 0

					if isOnSquadByHtid(lHitd) and tonumber(lHitd) > 0 then 	--如果既没在伙伴阵上，又没在小伙伴阵上
						local litFri 	= {}
						litFri["gname"] = lname
						litFri["hero"] 	= lHitd
						litFri["linkCards"] 	= linkCards
						table.insert(tabLinkHtid, litFri)
					end
				end
				-- end
			end
		end
	end

	return tabLinkHtid
end

--获得某个英雄所有的伙伴羁绊
local function getLinkGroupByHtid( htid )
	local tabLinkHtid 	= {}

	local heroDBInfo 	= DB_Heroes.getDataById(htid)
	local groupInfo 	= heroDBInfo.link_group1

	if groupInfo then
		local hGroupInfo 	= lua_string_split(groupInfo, ",")

		for i,groupId in ipairs(hGroupInfo) do

			local linkInfo 	= DB_Union_profit.getDataById(groupId)
			local lname 	= linkInfo.union_arribute_name
			local linkCards = linkInfo.union_card_ids
			local linkType 	= lua_string_split(linkCards, "|")[1]

			if tonumber(linkType) 	== 1 then 		--等于1表示英雄羁绊，2是宝物羁绊
	
				local litFri 	= {}
				litFri["gname"] = lname

				table.insert(tabLinkHtid, litFri)
			end
		end
	end

	return tabLinkHtid
end

--根据htid获取已经存得羁绊名称
local function getGroupByHtid( htid, extraArr )
	local tabGroup 	= {}

	--羁绊信息，在这里将得到的羁绊都放到
	local mheroInfo		= getLinkGroupByHtid(htid)

	for i,litFri in ipairs(extraArr) do
		local mhtid 	= litFri.hero
		local hname = litFri.gname
		if tonumber(mhtid) == tonumber(htid) then
			table.insert(tabGroup, hname)
		end
	end

	return tabGroup
end


--根据伙伴的htid来获得等级 
--已经获得的伙伴等级不变
--未曾获得的伙伴等级为1
--第一个返回值，等级 ，第二个表示伙伴是否在阵上 100 小伙伴 101 伙伴中 102 未获取
local function getHeroLevelByHtid( htid )
	local level = "1"
	local isForm = 102

	local isExtra, thid = isOnExtraByHtid(htid)
	if isExtra then
		local extraInfo = HeroModel.getHeroByHid(thid)
		level 	= extraInfo.level
		isForm 	= 100
	else
		local allHeroes = HeroModel.getAllHeroes()

		for hid,heroInfo in pairs(allHeroes) do
			local mhtid = heroInfo.htid
			if tonumber(mhtid) == tonumber(htid) then
				thid = hid
				level = heroInfo.level
				isForm = 101
			end
		end
	end

	return level, isForm, thid
end
--如果重复返回false,不重复返回true
local function isDoubleByHtid( htid  )
	for i,heroInfo in ipairs(recomFriInfo) do
		local mhtid = heroInfo.htid
		if tonumber(mhtid) == tonumber(htid) then
			return false
		end
	end
	return true
end

local function checkLitPos( ... )
	local extra = mCache.getExtra()
	for i,v in ipairs(extra) do
		local exHid = tonumber(v)
		if exHid == 0 then
			return i
		end
	end
	return -1
end

local function getLitFirPos( hid )
	local extra = mCache.getExtra()
	for k,v in ipairs(extra) do
		if tonumber(v) == tonumber(hid) then
			return k
		end
	end
	return -1
end
-- --根据hid获得伙伴的羁绊数目。
-- local function getNumOfHero( ... )
-- 	for i,heroInfo in ipairs(recomFriInfo) do
-- 		local hid = heroInfo.hid
-- 		if tonumber(hid) == tonumber(m_hid) then
-- 			m_activeJiBan = table.count(heroInfo.GroupArr)
-- 		end
-- 	end
-- end

local function getNumOfHeroes( addExtra )
	require "script/module/formation/FormLitFriScrollView"
	local jibanNum = FormLitFriScrollView.getAddJibanNum()
	return jibanNum
end

local function addExtraCallback( cbFlag, dictData, bRet )
	local extraData = dictData.ret
	if extraData == "ok" then
		UserModel.updateFightValue()
		--得到上阵伙伴激活的羁绊数
		--处理小伙伴
		local extra = mCache.getExtra()
		extra[m_heroPos] = m_hid
		mCache.setExtra(extra)
		--更新阵容界面
		MainFormation.refreshExtra(m_hid, m_heroPos)

		--刷新界面。
		recomFriInfo = {}
		loadRecomFriInfo()
		recomTabView:changeDataSource(recomFriInfo)
		recomTabView:refresh()

		m_activeJiBan = getNumOfHeroes()
		local alertStr = m_i18n[1233] .. 1 .. m_i18n[1232] .. m_activeJiBan .. m_i18n[1227]
		ShowNotice.showShellInfo(alertStr)

		UserModel.setInfoChanged(true)
		UserModel.updateFightValue()

		-- --刷新伙伴列表数据   2014-10-28 zhangjunwu
		-- require "script/module/partner/MainPartner"
		-- MainPartner.refreshYingZiListView()

		  --刷新伙伴列表数据   2014-11-17  zhangjunwu
  --       require "script/module/partner/MainPartner"
  --       MainPartner.replaceHeroDataByHid(m_hid) 
  --       if(tonumber(m_behid) > 0) then
		-- 	MainPartner.replaceHeroDataByHid(m_behid) 
		-- end
        
	end

end

local function delExtraCallback( cbFlag, dictData, bRet )
	local extraData = dictData.ret
	if extraData == "ok" then
		--得到上阵伙伴激活的羁绊数

		--处理小伙伴
		-- local extra = mCache.getExtra()
		-- extra[m_heroPos] = 0
		-- mCache.setExtra(extra)
		--更新阵容界面
		MainFormation.refreshExtra(0, m_heroPos)
		
		m_activeJiBan 	= getNumOfHeroes()
		local alertStr = m_i18n[1225] .. 1 .. m_i18n[1226] .. 0 - m_activeJiBan .. m_i18n[1227]
		ShowNotice.showShellInfo(alertStr)
		--刷新界面。
		recomFriInfo = {}
		loadRecomFriInfo()
		recomTabView:changeDataSource(recomFriInfo)
		recomTabView:refresh()

		-- --刷新伙伴列表数据   2014-10-28 zhangjunwu
		-- require "script/module/partner/MainPartner"
		-- MainPartner.refreshYingZiListView()

		  --刷新伙伴列表数据   2014-11-17  zhangjunwu
        require "script/module/partner/MainPartner"

        MainPartner.replaceHeroDataByHid(m_hid) 
        if(m_behid and tonumber(m_behid) > 0) then
			MainPartner.replaceHeroDataByHid(m_behid) 
		end
	end

end
--hitd来显示伙伴信息
local function onShowHeadWithHtid( sender, eventType )
	if(eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playInfoEffect()
		-- 没有的伙伴信息
		local htid = sender:getTag()
		local heroInfo =HeroUtil.getHeroLocalInfoByHtid(htid)
		local tArgs={selectedHeroes=heroInfo}

	    require "script/module/partner/PartnerInfoCtrl"
        local pHeroValue = heroInfo --PartnerModle.getHeroDataByHid(m_tbHeroesValue[sender.idx])
        local heroInfo = {htid = pHeroValue.htid ,hid = 0 ,strengthenLevel = pHeroValue.sLevel ,transLevel = pHeroValue.evolve_level,heroValue = pHeroValue }
        tArgs.heroInfo = heroInfo
        local layer = PartnerInfoCtrl.create(tArgs,4)     --所选择武将信息22
        LayerManager.addLayoutNoScale(layer) 
        
	end
end 
--hid来显示伙伴信息，没有上阵的
local function onShowHeadWithHid( sender, eventType )
	if(eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playInfoEffect()
		-- 已有的伙伴信息
		local hid = sender:getTag()
		local heroInfo = HeroModel.getHeroByHid(hid)
		local tArgs={selectedHeroes=heroInfo}

		require "script/module/partner/PartnerInfoCtrl"
        local pHeroValue = heroInfo --PartnerModle.getHeroDataByHid(m_tbHeroesValue[sender.idx])
        local tbherosInfo = {}
        local heroInfo = {htid = pHeroValue.htid ,hid = hid ,strengthenLevel = pHeroValue.sLevel ,transLevel = pHeroValue.evolve_level,heroValue = pHeroValue }
        table.insert(tbherosInfo,heroInfo)
        local tArgs = {}
        tArgs.heroInfo = heroInfo
        logger:debug({tArgs=tArgs})
        local layer = PartnerInfoCtrl.create(tArgs,4)     --所选择武将信息22
        LayerManager.addLayoutNoScale(layer)
	end
end

--hid来显示伙伴信息，已经上阵的
local function onShowHaveUpHeadWithHid( sender, eventType )
	-- 已有的伙伴信息
	if(eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playInfoEffect()
		local hid = sender:getTag()
		local heroInfo = HeroModel.getHeroByHid(hid)
		require "script/module/partner/PartnerInfoCtrl"
        local pHeroValue = heroInfo --PartnerModle.getHeroDataByHid(m_tbHeroesValue[sender.idx])
        local heroInfo = {htid = pHeroValue.htid ,hid = hid ,strengthenLevel = pHeroValue.sLevel ,transLevel = pHeroValue.evolve_level,heroValue = pHeroValue }
        local tArgs = {}
        tArgs.heroInfo = heroInfo
        local layer = PartnerInfoCtrl.create(tArgs,4)     --所选择武将信息22
        LayerManager.addLayoutNoScale(layer)

	end
end 

local function onUnloadRec( sender, eventType )
	if(eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		local hid = sender:getTag()
		local litFriPos = getLitFirPos(hid)
		if litFriPos > 0 then
			local args = Network.argsHandler(hid, litFriPos - 1)
			RequestCenter.formation_delExtra(delExtraCallback, args)
			m_hid = hid
			m_heroPos = litFriPos
		else
			ShowNotice.showShellInfo(m_i18n[1250])
		end
	end
end


--[[desc:根据hid判断是否需要提示，对应返回提示所需数据
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
local function fnGetInfo( _hid )
	local needShow = false
	local canStart = {}
	local cannotStartTree = {}
	local needMoreName = {}
	for key , ver in ipairs(recomFriInfo) do
		if(tonumber(ver.hid) == tonumber(_hid)) then
			local lhtid = ver.htid
			for i,v in ipairs(ver.GroupArr) do
				if(v["isActive"]) then
					table.insert(canStart,v["gname"])
				else
					local pThree = v["isThree"]
					if(pThree) then
						needShow = true
						table.insert(cannotStartTree,v["gname"])
						local linkCards = v["linkCards"]
						local linkGArr 	= lua_string_split(linkCards, ",")
						local pNames = {}
						for heroIndex,hIntid in ipairs(linkGArr) do
							local htid = lua_string_split(hIntid, "|")[2]
							if isOnSquadByHtid(htid) and (not isOnExtraByHtid(htid)) and tonumber(lhtid) ~= tonumber(htid) then 	--没在阵上
								table.insert(pNames,htid)
							end
						end
						table.insert(needMoreName,pNames)
					end
				end
			end
		end
	end
	return needShow , canStart , cannotStartTree , needMoreName
end


local m_useHid	--要上阵的hid

--[[desc:上阵方法
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
local function fnLoadRec( ... )
	local hid = m_useHid
	local loadPos = checkLitPos()
	local args = Network.argsHandler(hid, loadPos - 1)
	if tonumber(loadPos) > 0 then
		RequestCenter.formation_addExtra(addExtraCallback, args)
		m_hid = hid
		m_heroPos = loadPos
	else
		ShowNotice.showShellInfo(m_i18n[1251])
	end
end


--[[desc:获取富文本和高
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
local function getRich (pTb , width)
	local nAngwidth = width

	require "script/libs/LuaCCLabel"
	local labAngerText = LuaCCLabel.createMultiLineLabel(
		{text=" ", width=nAngwidth,color=ccBlack, alignment=kCCTextAlignmentLeft})

    local textInfo = pTb
    local richText = BTRichText.create(textInfo, nil)
    labAngerText:addChild(richText)
    richText:setSize(CCSizeMake(nAngwidth,0))
	richText:visit()

 	local pHeight = richText:getTextHeight()

 	labAngerText:setContentSize(CCSizeMake(nAngwidth , pHeight))
 	labAngerText:setAnchorPoint(ccp(0,0))
 	richText:setPosition(ccp(0,pHeight))

    return labAngerText , pHeight
end

--[[desc:创建提示dlg
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
local function createDlg(canStart , cannotStartTree , needMoreName)

	local layPrompt = g_fnLoadUI("ui/formation_tip.json")

	local function CloseEvent( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCloseEffect()
			LayerManager.removeLayout()
		end
	end

	local function OKEvent( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			LayerManager.removeLayout()
			fnLoadRec()
		end
	end

	local btnClose = m_getWidget(layPrompt, "BTN_CLOSE")
	btnClose:addTouchEventListener(CloseEvent)

	local btnCancel = m_getWidget(layPrompt, "BTN_CANCEL")
	UIHelper.titleShadow(btnCancel, m_i18n[1325])
	btnCancel:addTouchEventListener(CloseEvent)

	local btnOK = m_getWidget(layPrompt, "BTN_SURE")
	UIHelper.titleShadow(btnOK, m_i18n[1324])
	btnOK:addTouchEventListener(OKEvent)

	local normalCo = ccc3(0x8a,0x37,0x00)
	local jiBanCo = ccc3(0xf6,0x17,0x00)

	local pFontSize = 26
	local tfd_can = m_getWidget(layPrompt, "LAY_CAN")
	local pWidth = tfd_can:getSize().width
	local totleH = 0
	local pPart = 5
	local m_count = 0
	if(#canStart > 0) then
		m_count = m_count + 1
		local richStr = m_i18n[1228]
		local pRich = {}

		table.insert(pRich,{color = normalCo , font = g_sFontName , size = pFontSize})
		for i=1,#canStart do
			richStr = UIHelper.concatString({richStr,canStart[i]})
			table.insert(pRich,{color = jiBanCo , font = g_sFontPangWa , size = pFontSize})

			if(i ~= #canStart) then
				richStr = UIHelper.concatString({richStr,"、"})
				table.insert(pRich,{color = normalCo , font = g_sFontName , size = pFontSize})
			else
				richStr = UIHelper.concatString({richStr,m_i18n[5303]})
				table.insert(pRich,{color = normalCo , font = g_sFontName , size = pFontSize})
			end
		end
		local pTb = { richStr, pRich}

		local lb , pH = getRich(pTb,pWidth)
		tfd_can:setSize(CCSizeMake(pWidth , pH + pPart))
		lb:setPosition(ccp(8, pPart))
		tfd_can:addNode(lb)
		totleH = totleH + pH + pPart
	else
		tfd_can:setSize(CCSizeMake(0,0))
		totleH = totleH - pFontSize
	end

	local tfd_need = m_getWidget(layPrompt, "LAY_NEED")
	pWidth = tfd_need:getContentSize().width
	local pCount = table.count(cannotStartTree)
	local tmpheight = 0
	m_count = m_count + pCount
	for i = pCount, 1 , -1 do
		local richStr = m_i18n[1229]
		local pRich = {}
		table.insert(pRich,{color = normalCo , font = g_sFontName , size = pFontSize})

		for j=1,#needMoreName[i] do
			local htid = needMoreName[i][j]
			local pDB = DB_Heroes.getDataById(htid)
			local pName = pDB.name
			richStr = UIHelper.concatString({richStr,pName})
			table.insert(pRich,{color = g_QulityColor[tonumber(pDB.star_lv)] , font = g_sFontPangWa , size = pFontSize})

			if(j ~= #needMoreName[i]) then
				richStr = UIHelper.concatString({richStr,"、"})
				table.insert(pRich,{color = normalCo , font = g_sFontName , size = pFontSize})
			end
		end
		richStr = UIHelper.concatString({richStr,m_i18n[1230]})
		table.insert(pRich,{color = normalCo , font = g_sFontName , size = pFontSize})

		richStr = UIHelper.concatString({richStr,cannotStartTree[i]})
		table.insert(pRich,{color = jiBanCo , font = g_sFontPangWa , size = pFontSize})

		richStr = UIHelper.concatString({richStr,m_i18n[5303]})
		table.insert(pRich,{color = normalCo , font = g_sFontName , size = pFontSize})

		local pTb = {richStr,pRich}
		local lb , pH = getRich(pTb , pWidth - 15)
		if(pCount == 1 and pH == pFontSize) then
			lb:setPosition(ccp(8, pPart*2))
		else
			lb:setPosition(ccp(8, pPart + tmpheight))
			tmpheight = tmpheight + pH + pPart
		end
		tfd_need:addNode(lb)
	end
	totleH = totleH + tmpheight
	if(tmpheight > 40) then
		tfd_need:setSize(CCSizeMake(pWidth , tmpheight))
	end


	local tfd_is = m_getWidget(layPrompt, "LAY_IS")
	local tfd_is_size = tfd_is:getContentSize()

	local pText = m_i18n[1231]
	local cclObj = CCLabelTTF:create(pText, g_sFontName, pFontSize)
	cclObj:setColor(normalCo)
	cclObj:setAnchorPoint(ccp(0.5,0.5))
	cclObj:setPosition(ccp(tfd_is_size.width*0.5,tfd_is_size.height*0.5))
	tfd_is:addNode(cclObj)

	local pChangeH = totleH - m_count*pFontSize
	if(pChangeH ~= 0) then
		local img_bg = m_getWidget(layPrompt, "img_bg")
		local pSize = img_bg:getSize()
		img_bg:setSize(CCSizeMake(pSize.width , pSize.height + pChangeH))
	end


	LayerManager.addLayout(layPrompt)
end

local function onLoadRec( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		m_useHid = sender:getTag()
	
		local needShow , canStart , cannotStartTree , needMoreName = fnGetInfo(m_useHid)

		if(needShow) then
			--wmShow 显示羁绊提醒
			createDlg(canStart , cannotStartTree , needMoreName)
			return
		end

		fnLoadRec()
	end
end

local function onGainRec( sender, eventType )

	local htid 	= sender:getTag()
	local heroDBInfo 	= DB_Heroes.getDataById(htid)
	local selectedHeroes 	= {}
	selectedHeroes.id 	= heroDBInfo.fragment
	selectedHeroes.nQuality 	= heroDBInfo.star_lv
	selectedHeroes.head_icon 	= heroDBInfo.head_icon_id
	selectedHeroes.heroQuality 	= heroDBInfo.heroQuality

	local heroFrag 	= DB_Item_hero_fragment.getDataById(selectedHeroes.id)

	selectedHeroes.nMax = heroFrag.need_part_num

    require "script/module/public/FragmentDrop"
    local fragmentDrop = FragmentDrop:new()
  
	local fragmentDropLayout = fragmentDrop:create(selectedHeroes.id,Dropcallfn)
    
	LayerManager.addLayout(fragmentDropLayout)

end
--处理得出的数据
local function solveHeroUnionActive( allExAbHero )
	local tabHeroUnion 	= {}
	for pos,linkGroup in ipairs(allExAbHero) do
		local linkCards = linkGroup["linkCards"]
		local lhtid 	= linkGroup["hero"]
		local linkGArr 	= lua_string_split(linkCards, ",")
		local isActive 	= true 	--默认开启
		local pNum = 0
		for heroIndex,hIntid in ipairs(linkGArr) do
			local htid 	= lua_string_split(hIntid, "|")[2] 	--羁绊的htid
			pNum = pNum + 1
			if isOnSquadByHtid(htid) and (not isOnExtraByHtid(htid)) and tonumber(lhtid) ~= tonumber(htid) then 	--没在阵上
				isActive = false
			end
		end
		if(pNum > 2) then
			--是多人羁绊
			linkGroup["isThree"] = true
		end
		linkGroup["isActive"] = isActive
		table.insert(tabHeroUnion, linkGroup)
	end
	return tabHeroUnion
end
--将所有的羁绊整合起来
local function sumAllofUnion( tabHeroUnion )
	local sumUnion 	= {}
	for pos,tabUnion in ipairs(tabHeroUnion) do
		local htid 	= tabUnion["hero"]
		local tabHero 	= sumUnion[htid ..""]
		if tabHero then
			local vhJustice = true
			for i,vh in ipairs(tabHero) do
				local gname 	= vh.gname
				local lgname 	= tabUnion.gname
				if gname == lgname then
					vhJustice = false
				end
			end
			if vhJustice then
				table.insert(tabHero, tabUnion)
			end
		else
			tabHero = {}
			table.insert(tabHero, tabUnion)
		end
		sumUnion[htid ..""] = tabHero
	end
	return sumUnion
end

--准备数据
function loadRecomFriInfo( ... )
	local extraArr 	= mCache.getSquad()
	local allExAbArr 	= {}		--最终出来的伙伴

	local allExAbHero 	= {} 		--第一遍处理出来的伙伴
	for pos,sq_hid in pairs(extraArr) do
		--在循环中获得所有的伙伴的羁绊关系的伙伴htid
		if tonumber(sq_hid) > 0 then
			local heroInfo  	= HeroModel.getHeroByHid(sq_hid)
			local htid 			= heroInfo.htid
			local tabLinkHtid 	= getLinkByHtid(htid)
			for linkId,lHArr in ipairs(tabLinkHtid) do
				table.insert(allExAbHero, lHArr)
			end
		end
	end
	local benchArr 	= mCache.getBench()
	for pos,sq_hid in pairs(benchArr) do
		--在循环中获得所有的伙伴的羁绊关系的伙伴htid
		if tonumber(sq_hid) > 0 then
			local heroInfo  	= HeroModel.getHeroByHid(sq_hid)
			local htid 			= heroInfo.htid
			local tabLinkHtid 	= getLinkByHtid(htid)
			for linkId,lHArr in ipairs(tabLinkHtid) do
				table.insert(allExAbHero, lHArr)
			end
		end
	end

	--处理得到的羁绊数据
	allExAbArr = solveHeroUnionActive(allExAbHero)
	allExAbArr = sumAllofUnion(allExAbArr)

	--处理得到的数据,根据得到的htid,为tableView准备数据
	for htid, litFri in pairs(allExAbArr) do
			--处理推荐的伙伴信息
			local heroDBInfo 	= DB_Heroes.getDataById(htid)
			local isShow 	= heroDBInfo.ismask

			if isShow == nil then
				local recomInfo 	= {}
				recomInfo.htid 		= htid
				recomInfo.name 		= heroDBInfo.name
				recomInfo.quality 	= heroDBInfo.star_lv
				recomInfo.icon 		= heroDBInfo.head_icon_id
				recomInfo.country 	= heroDBInfo.country
				recomInfo.GroupArr	= litFri      --激活的羁绊
				local mlevel, misForm ,mhid 	= getHeroLevelByHtid(htid)	--在小伙伴上需要显示（下阵），在英雄中（上阵），不在英雄中显示获取

				recomInfo.showFunc	= onShowHead

				recomInfo.level 	= mlevel
				recomInfo.isForm 	= misForm
				recomInfo.hid 		= mhid

				if tonumber(misForm) == 100 then
					recomInfo.onUnload 	= onUnloadRec
					recomInfo.onheadFunc 	= onShowHaveUpHeadWithHid
				elseif tonumber(misForm) == 101 then
					recomInfo.onLoad 	= onLoadRec
					recomInfo.onheadFunc 	= onShowHeadWithHid
				else
					recomInfo.onGain 	= onGainRec
					recomInfo.onheadFunc 	= onShowHeadWithHtid
				end

				table.insert(recomFriInfo, recomInfo)
			end
	end

	table.sort(recomFriInfo, sortRecomPartner)
end
--载入tableview的layout和Cell
local function loadTabViewCfg( ... )
	layTabView 		= m_getWidget(widgetRecom, "LAY_TBV")
	local LAYCELL 	= m_getWidget(layTabView,"LAY_CELL")
	layTabCell = LAYCELL:clone()
	-- layTabCell:retain()  --文件已经弃用
end

local function isContainExtra( extraData, oHeroId )
	local contain = true
	for cIndex,cHeroId in ipairs(extraData) do
		if tonumber(oHeroId) > 0  and tonumber(cHeroId) > 0 then
			if tonumber(oHeroId) == tonumber(cHeroId) then
				contain = false
			end
		end
	end
	return contain
end

local function solveTheExtra( origExtra, extraData )
	local addExtra = {}

	for oIndex,oHeroId in ipairs(extraData) do
		if tonumber(oHeroId) > 0 then
			if isContainExtra(origExtra, oHeroId) then
				table.insert(addExtra, oHeroId)
			end
		end
	end

	return addExtra
end

local function getExtraNum( extraData )
	
	local extranum = 0
	for pos,extra in ipairs(extraData) do
		if tonumber(extra) > 0 then
			extranum = extranum + 1
		end
	end
	return extranum
end

-- 一键上阵的回调
local function bestExtraCallBack( cbFlag, dictData, bRet )
	
	if bRet then
		local extraData = dictData.ret
		--需要对比下上了几个伙伴激活了几个羁绊
		m_activeJiBan = 0
		local oriExtra = mCache.getExtra()		
		local addExtra = solveTheExtra(oriExtra, extraData)
		local m_heroCount = table.count(addExtra)
		local extranum = getExtraNum(extraData)
		local oriexnum = getExtraNum(oriExtra)
		--只有替换了伙伴的时候才需要去更新等操作。
		if m_heroCount ~= 0 or (oriexnum > extranum and extranum == 0) then

			UserModel.setInfoChanged(true)
			UserModel.updateFightValue()

			mCache.setExtra(extraData)
			-- MainFormation.extraFriendExtend()
			MainFormation.refreshLittleFriendView(extraData)
			--阵容数据
			require "script/module/formation/FormLitFriScrollView"
			FormLitFriScrollView.refreshScrollView()

			m_activeJiBan = getNumOfHeroes()

			local alertStr
			if (oriexnum > extranum and extranum == 0) then
				alertStr = m_i18n[1225] .. oriexnum - extranum .. m_i18n[1226] .. m_activeJiBan .. m_i18n[1227]
			else
				alertStr = m_i18n[1233] .. m_heroCount .. m_i18n[1232] .. m_activeJiBan .. m_i18n[1227]
			end
			ShowNotice.showShellInfo(alertStr)
			--刷新界面
			recomFriInfo = {}
			loadRecomFriInfo()
			recomTabView:changeDataSource(recomFriInfo)
			recomTabView:refresh()

			UserModel.setInfoChanged(true)
			UserModel.updateFightValue()
		else
			local pNum = 0
			local pData = mCache.getExtra()
			for k,v in pairs(pData or {}) do
				local pValue = tonumber(v) or 0
				if(pValue > 0) then
					pNum = pNum + 1
				end
			end

			if(pNum == 0) then
				ShowNotice.showShellInfo(m_i18n[1235])
			else
				ShowNotice.showShellInfo(m_i18n[1234])
			end
			
		end
	end
end

--一键上阵的处理，可替换原来的小伙伴
local function oneKeyAddForm( ... )
		
	RequestCenter.formation_bestExtra(bestExtraCallBack, nil)
end

--最上面的返回和一键上阵按钮
local function loadUpUIAndTouchEvent( ... )
	
	local backBtn 		= m_getWidget(widgetRecom, "BTN_BACK") 			--返回
	backBtn:addTouchEventListener(function(sender, eventType)
						
						if(eventType == TOUCH_EVENT_ENDED) then
							AudioHelper.playBackEffect()
							if(m_formWidget) then
								m_formWidget:setVisible(true)
							end 
							LayerManager.removeLayout()
						end
					end)
	
	local oneKeyAdd 	= m_getWidget(widgetRecom, "BTN_ONEKEY")		--一键上阵

	--wm 添加一键功能开启的判断
	local function getNum( extraData )
		local pnum = 0
		for pos,extra in ipairs(extraData) do
			if(tonumber(extra) >= 0) then
				pnum = pnum + 1
			end
		end
		return pnum
	end

	require "db/DB_Formation"
	local pShowNum = DB_Formation.getDataById(1).onekey_when
	local pNum = getNum(mCache.getExtra())
	if(pNum < pShowNum) then
		oneKeyAdd:setVisible(false)
		oneKeyAdd:setTouchEnabled(false)
	else
		oneKeyAdd:setVisible(true)
		oneKeyAdd:setTouchEnabled(true)
		oneKeyAdd:addTouchEventListener(function(sender, eventType)
						
			if(eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCommonEffect()
				oneKeyAddForm()
			end
		end)
	end

    UIHelper.titleShadow(backBtn, m_i18n[1019])
    UIHelper.titleShadow(oneKeyAdd, m_i18n[1236])
end
--初始化数据
local function init( ... )
	
	recomFriInfo = {}
end

--退出推荐伙伴页面
local function onExitCall( ... )
	
end

--进入推荐伙伴页面
local function onEnterCall( ... )
	
	require "script/module/formation/FormLitFriView"
	FormLitFriView.setShowRecomFalse()
end

--界面适配
local function fitFrameScale( ... )
	
	local imgBack = m_getWidget(widgetRecom ,"IMG_BG")
	imgBack:setScale(g_fScaleX)
	local imgTabBack = m_getWidget(widgetRecom ,"IMG_TAB_BG")
	imgTabBack:setScale(g_fScaleX)
end

--创建。。。
function create( p_formWidget )
	m_formWidget = p_formWidget
	if(m_formWidget) then
		m_formWidget:setVisible(false)
	end 
	widgetRecom = g_fnLoadUI(jsonRecom)
	widgetRecom:setSize(g_winSize)
 	--初始化数据
	init()

	fitFrameScale()

	loadUpUIAndTouchEvent()
	--生成TableView的阶段
	loadTabViewCfg()
	loadRecomFriInfo()
	createTableView()

    UIHelper.registExitAndEnterCall(widgetRecom, onExitCall, onEnterCall)

	return widgetRecom
end