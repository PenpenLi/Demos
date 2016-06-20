-- FileName: ResolveCtrl.lua
-- Author:zhangjunwu
-- Date: 2014-05-27
-- Purpose: 分解主界面

module("ResolveCtrl", package.seeall)
require "script/model/hero/HeroModel"
require "db/DB_Item_arm"
require "db/DB_Item_treasure"
require "script/module/resolve/ResolveView"
-- require "script/module/resolve/ResolveModel"

-- UI控件引用变量 --#8a3700
local N_ADDITEM_NUM  = 5
local titleColor =   ccc3(0x8a,0x37,0x00)
local m_laySelectView = nil
-- 模块局部变量 --
local m_tbSelectedHeroes 		= nil     	--被选中的武将
local m_tbSelectedTreas 		= nil 		--被选中的宝物
local m_tbSelectedParnter 		= nil 		--被选中的伙伴

local m_tbAllHeroes 			= nil     	--所有的武将（符合炼化）
local m_tbAllTreas 				= nil 		--所有的宝物（符合炼化）
local m_tbAllParnter 			= nil 		--所有的伙伴（符合炼化）

local m_ResolveType 			= 0  		--当前需要炼化的是那种类型

local m_ResolveNull 			= -1 		--当前没有选中任何可炼化的东西
local m_ResolveHero 			= 1 		--当前小伙伴有被选中，则更新按钮状态，选择区域的更新
local m_ResloveTreas 			= 3
local m_ResolveParnter 			= 2

local m_nSelectHeroCount 		= nil
local m_nSelectedTreasCount 	= nil
local m_nSelectedParnterCount 	= nil

local m_tbSeclet 				= nil    	--进入选择页面的时候，用来保存已经选中的id
local m_fnGetWidget 			= g_fnGetWidgetByName
local m_i18nString 				= gi18nString
local m_i18n 					= gi18n
m_bIsAnimationg 				= false

local function init(...)
	m_tbSelectedHeroes 						= {}        --被选中的武将
	m_tbSelectedTreas 						= {} 		--被选中的宝物
	m_tbSelectedParnter 					= {} 		--被选中的时装

	m_nSelectHeroCount      				=1 			--被选中的武将总数
	m_nSelectedTreasCount 					= 0 		--被选中的宝物总数
	m_nSelectedParnterCount 				= 0 		--被选中的时装总数

	m_tbAllHeroes 							= nil     	--所有的武将（符合炼化）
	m_tbAllTreas 							= nil 		--所有的宝物（符合炼化）
	m_tbAllParnter 							= nil 		--所有的时装（符合炼化）

	m_tbSeclet 								= {}
	m_laySelectView							= nil
	m_bIsAnimationg 						= false
end


function destroy(...)
	package.loaded["ResolveCtrl"] = nil
end


function moduleName()
	return "ResolveCtrl"
end
--选择界面点击确认之后的回调
function onBtnSureCall( selectData,pageType )
	m_tbSeclet = selectData
	m_ResolveType = pageType

	m_tbSelectedHeroes = {}
	m_tbSelectedTreas = {}
	m_tbSelectedParnter = {}
	if(table.count(selectData) == 0) then
		updateViewBtnState(m_ResolveNull)
		return
	end
	if(m_ResolveType == m_ResolveHero) then
		m_tbSelectedHeroes = {}
		for i = 1,#m_tbSeclet do
			for k, v in pairs(m_tbAllHeroes) do
				if(m_tbSeclet[i] == m_tbAllHeroes[k].item_id)then
					table.insert(m_tbSelectedHeroes,m_tbAllHeroes[k])
					break
				end
			end
		end
		m_nSelectHeroCount = #m_tbSelectedHeroes
	elseif(m_ResolveType == m_ResloveTreas)then
		m_tbSelectedTreas = {}
		for i = 1,#m_tbSeclet do
			for k, v in pairs(m_tbAllTreas) do
				if(m_tbSeclet[i] == m_tbAllTreas[k].item_id)then
					table.insert(m_tbSelectedTreas,m_tbAllTreas[k])
					break
				end
			end
		end
		m_nSelectedTreasCount = #m_tbSelectedTreas
	elseif(m_ResolveType == m_ResolveParnter)then
		m_tbSelectedParnter = {}
		for i = 1,#m_tbSeclet do
			for k, v in pairs(m_tbAllParnter) do
				if(m_tbSeclet[i] == m_tbAllParnter[k].hid)then
					table.insert(m_tbSelectedParnter,m_tbAllParnter[k])
					break
				end
			end
		end
		m_nSelectedEquipCount = #m_tbSelectedParnter
	else
		logger:debug("wrong coming")
	end

	updateViewBtnState(m_ResolveType)
end

--过滤宝物
function getFiltersForTreas()
	m_tbAllTreas = ResolveModel.getFiltersForTreas()
	return m_tbAllTreas
end
--获得可以分解的武将影子
function getFilterHeroList()
	m_tbAllHeroes = ResolveModel.getFilterHeroList()
	return m_tbAllHeroes
end
--获得可以分解的伙伴
function getFilterPartnerList()
	m_tbAllParnter = ResolveModel.getFilterPartnerList()
	return m_tbAllParnter
end

--更新按钮和数据
function updateSelectData( _tbSelectItem ,_resolveType )

	m_tbSelectedTreas = {}
	m_tbSelectedHeroes = {}
	m_tbSelectedParnter = {}

	local noResolveInfo = ""

	if(_resolveType == m_ResolveHero)then
		noResolveInfo = m_i18nString(2013)
		m_tbSelectedHeroes = _tbSelectItem
	elseif(_resolveType == m_ResloveTreas)then
		noResolveInfo = m_i18nString(2015)
		m_tbSelectedTreas = _tbSelectItem
	elseif(_resolveType == m_ResolveParnter)then
		noResolveInfo = m_i18nString(2025)
		m_tbSelectedParnter = _tbSelectItem
	end

	if table.isEmpty(_tbSelectItem) then
		ShowNotice.showShellInfo(noResolveInfo)
		updateViewBtnState(m_ResolveNull)
	else
		updateViewBtnState(_resolveType)
	end

end

--获取可分解的影子的个数
local function getCanDecompShadowNum( )
	local count  = 0
	for i,v in ipairs(m_tbAllHeroes) do
		if(v.bCanSelectd == true) then
			count  = count +1
		end
	end
	return count
end

--快速添加伙伴影子
function fastAddHero()
	--获取伙伴碎片信息
	if(table.count(m_tbAllHeroes) == 0) then
		getFilterHeroList()
	end
	m_tbSelectedHeroes = {}
	local count = 0
	for i = 1,#m_tbAllHeroes do

		if(m_tbAllHeroes[i].bCanSelectd == true) then
			count = count+1
			table.insert(m_tbSelectedHeroes,m_tbAllHeroes[i])
		end

		if count == N_ADDITEM_NUM then
			break
		end
	end
	m_nSelectHeroCount = count+1
	logger:debug(m_nSelectHeroCount)
	updateSelectData(m_tbSelectedHeroes,m_ResolveHero)
end
--快速添加伙伴
function fastAddParnter()
	--获取伙伴碎片信息
	if(table.count(m_tbAllParnter) == 0) then
		getFilterPartnerList()
	end

	m_tbSelectedParnter = {}
	local count = 0
	for i = 1,#m_tbAllParnter do
		count = count+1
		table.insert(m_tbSelectedParnter,m_tbAllParnter[i])
		if i == N_ADDITEM_NUM then
			break
		end
	end
	m_nSelectedParnterCount = count+1
	logger:debug(m_nSelectedParnterCount)
	updateSelectData(m_tbSelectedParnter,m_ResolveParnter)
end
--快速添加宝物
function fastAddTreas(tag)
	--获取宝物信息
	if(table.count(m_tbAllTreas) == 0) then
		getFiltersForTreas()
	end

	local count = 0
	m_tbSelectedTreas = {}
	for i =1, #m_tbAllTreas do
		count = count+1
		table.insert(m_tbSelectedTreas,m_tbAllTreas[i])
		if count == N_ADDITEM_NUM then
			break
		end
	end

	m_nSelectedTreasCount = count+1
	logger:debug(m_nSelectedTreasCount)
	updateSelectData(m_tbSelectedTreas,m_ResloveTreas)
end

--换一组伙伴影子
function changeHero()

	local nShadowCount =  getCanDecompShadowNum()

	if (m_nSelectHeroCount > nShadowCount) then
		m_nSelectHeroCount = 1
	else
		if(m_nSelectHeroCount <= N_ADDITEM_NUM) then
			m_nSelectHeroCount = 1
		else

		end
	end

	m_tbSelectedHeroes = {}
	local addCount = 0
	for i = m_nSelectHeroCount,#m_tbAllHeroes do
		if(m_tbAllHeroes[i].bCanSelectd == true) then
			addCount = addCount +1
			table.insert(m_tbSelectedHeroes,m_tbAllHeroes[i])
		end

		if addCount == N_ADDITEM_NUM then
			break
		end
	end

	m_nSelectHeroCount = m_nSelectHeroCount + addCount

	updateSelectData(m_tbSelectedHeroes,m_ResolveHero)
end
--换一组伙伴
function changeParnter()
	if (m_nSelectedParnterCount > table.count(m_tbAllParnter)) then
		m_nSelectedParnterCount = 1
	else
		if(m_nSelectedParnterCount <= N_ADDITEM_NUM) then
			m_nSelectedParnterCount = 1
		else

		end
	end

	m_tbSelectedParnter = {}
	local addCount = 0
	for i = m_nSelectedParnterCount,#m_tbAllParnter do
		logger:debug(i)
		addCount = addCount +1
		table.insert(m_tbSelectedParnter,m_tbAllParnter[i])
		if addCount == N_ADDITEM_NUM then
			break
		end
	end

	m_nSelectedParnterCount = m_nSelectedParnterCount + addCount

	updateSelectData(m_tbSelectedParnter,m_ResolveParnter)
end

--换一组宝物
function changeTreas()
	if (m_nSelectedTreasCount > table.count(m_tbAllTreas)) then
		m_nSelectedTreasCount = 1
	else
		if(m_nSelectedTreasCount <= N_ADDITEM_NUM) then
			m_nSelectedTreasCount = 1
		else

		end
	end

	m_tbSelectedTreas = {}
	local count = 0
	for i = m_nSelectedTreasCount,#m_tbAllTreas do
		count = count+1
		table.insert(m_tbSelectedTreas,m_tbAllTreas[i])
		if count == N_ADDITEM_NUM then
			break
		end
	end
	m_nSelectedTreasCount = m_nSelectedTreasCount+count

	updateSelectData(m_tbSelectedTreas,m_ResloveTreas)
end

--改变按钮状态，更新+号的信息
function updateViewBtnState( resolveType )
	m_ResolveType = resolveType

	ResolveView.updateBtnByType(m_ResolveType)

	createSelectedIcons()
end
--+按钮回调
function fnOnAddCall()
	--local resloveType = 1
	TimeUtil.timeStart("fnOnAddCall")
	m_tbSeclet = {}
	--获取伙伴影子信息
	if(table.count(m_tbAllHeroes) == 0) then
		getFilterHeroList()
	end
	--获取宝物信息
	if(table.count(m_tbAllTreas) == 0) then
		getFiltersForTreas()
	end
	--获取伙伴信息
	if(table.count(m_tbAllParnter) == 0) then
		getFilterPartnerList()
	end

	if not table.isEmpty(m_tbSelectedHeroes) then
		for i = 1,#m_tbSelectedHeroes do
			table.insert(m_tbSeclet,m_tbSelectedHeroes[i].item_id)
		end
		m_ResolveType = 1
	end

	if not table.isEmpty(m_tbSelectedTreas) then
		for i = 1,#m_tbSelectedTreas do
			table.insert(m_tbSeclet,m_tbSelectedTreas[i].item_id)
		end
		m_ResolveType = 3
	end

	if not table.isEmpty(m_tbSelectedParnter) then
		for i = 1,#m_tbSelectedParnter do
			table.insert(m_tbSeclet,m_tbSelectedParnter[i].hid)
		end
		m_ResolveType = 2
	end

	require "script/module/resolve/ResolveSelectCtrl"
	local tArgsOfModule = {sign="BreakDownLayer"}
	tArgsOfModule.filtersHero 	= m_tbAllHeroes
	tArgsOfModule.filtersTreas 	= m_tbAllTreas
	tArgsOfModule.filtersParnter = m_tbAllParnter
	
	m_laySelectView = ResolveSelectCtrl.create(tArgsOfModule,m_tbSeclet,m_ResolveType)
	UIHelper.registExitAndEnterCall(m_laySelectView,exitCall,enterCall)
	LayerManager.addLayoutNoScale(m_laySelectView)
	m_laySelectView:setBackGroundColorOpacity(0)
	LayerManager.setPaomadeng(m_laySelectView, 10)
	return
end

--为六个个子加入头像，名字，点击事件
function createSelectedIcons()
	logger:debug(m_tbSelectedTreas)
	--如果格子有内容
	for i = 1,N_ADDITEM_NUM do
		local itemName = nil
		local itemNameColor = nil
		local heroFragNum = nil
		if ((not table.isEmpty(m_tbSelectedHeroes)) and (i <= #m_tbSelectedHeroes))then

			itemname = m_tbSelectedHeroes[i].name
			itemNameColor = g_QulityColor2[tonumber(m_tbSelectedHeroes[i].star_lv)]
			heroFragNum = m_tbSelectedHeroes[i].item_num
		elseif (not table.isEmpty(m_tbSelectedTreas)) and (i <= #m_tbSelectedTreas) then

			local i_data = DB_Item_treasure.getDataById(m_tbSelectedTreas[i].item_template_id)
			itemname = m_tbSelectedTreas[i].itemDesc.name
			itemNameColor = g_QulityColor2[tonumber(m_tbSelectedTreas[i].itemDesc.quality)]

		elseif (not table.isEmpty(m_tbSelectedParnter)) and (i <= #m_tbSelectedParnter) then
			itemname = m_tbSelectedParnter[i].name
			itemNameColor = g_QulityColor2[tonumber(m_tbSelectedParnter[i].star_lv)]
		else
			itemname = nil
			itemNameColor = nil
		end
		--更新名字
		ResolveView.setPlusIconName(itemname,itemNameColor,i,heroFragNum)
		--头像初始值
		local head_icon = nil
		--如果有武将，则换为头像
		if (not table.isEmpty(m_tbSelectedHeroes)) and (i <= #m_tbSelectedHeroes) then
			local btnIcon,tbItem = ItemUtil.createBtnByTemplateId(m_tbSelectedHeroes[i].item_template_id)
			head_icon  = CCSprite:create(tbItem.iconBigPath)
			head_icon:setScale(0.72)

		elseif (not table.isEmpty(m_tbSelectedTreas)) and (i <= #m_tbSelectedTreas)  then
			local btnIcon,tbItem = ItemUtil.createBtnByTemplateId(m_tbSelectedTreas[i].item_template_id)
			head_icon  = CCSprite:create(tbItem.iconBigPath)
			head_icon:setScale(1.2)
		elseif (not table.isEmpty(m_tbSelectedParnter)) and (i <= #m_tbSelectedParnter) then
			head_icon = HeroUtil.getHeroBodySpriteByHTID(m_tbSelectedParnter[i].htid)
			head_icon:setScale(0.72)
		end
		-- head_icon:setAnchorPoint(ccp(0.5,0.0))
		ResolveView.setPlusIcon(head_icon,i)
	end
end
--炼化后端返回的回调
function fnHandlerOfNetwork(cbFlag, dictData, bRet)
	logger:debug(dictData)
	if bRet then
		--炼化影子
		if cbFlag == "mysteryshop.resolveHeroFrag" then

			UserModel.addSilverNumber(tonumber(dictData.ret.silver) or 0)
			UserModel.addJewelNum(tonumber(dictData.ret.jewel) or 0)

			local fnResolveAnimationCall = function ( ... )
			TimeUtil.timeStart("fnResolveAnimationCall")
			
				local tbItem = {}
				if(dictData.ret.silver) then
					local silverInfo = {}
					silverInfo.icon = ItemUtil.getSiliverIconByNum(dictData.ret.silver)
					silverInfo.name = m_i18n[1520]
					table.insert( tbItem, silverInfo )
				end

				if(dictData.ret.jewel) then
					local jewelInfo = {}
					jewelInfo.icon = ItemUtil.getJewelIconByNum(dictData.ret.jewel)
					jewelInfo.name = m_i18n[2082]
					table.insert( tbItem, jewelInfo )
				end
				local itemInfo = dictData.ret.item
				require "db/DB_Item_hero_fragment"
				logger:debug(itemInfo)
				for k,v in pairs(itemInfo) do
					local itemData = {}
					itemData.icon = ItemUtil.createBtnByTemplateIdAndNumber(k,tonumber(v))
					itemData.name = DB_Item_hero_fragment.getDataById(k).name
					logger:debug(itemData)
					table.insert( tbItem, itemData )
				end
				TimeUtil.timeEnd("fnResolveAnimationCall")


				local layReward = UIHelper.createGetRewardInfoDlg( m_i18nString(2011), tbItem )
				LayerManager.addLayoutNoScale(layReward)
				TimeUtil.timeStart("updateViewBtnState")
				updateViewBtnState(m_ResolveNull)
				TimeUtil.timeEnd("updateViewBtnState")
				
			end
			-- TimeUtil.timeStart("开始播放特效")
			ResolveView.showAnimation(fnResolveAnimationCall)
			-- TimeUtil.timeEnd("开始播放特效")
			--refrashHerosData()
		end
		
		--炼化宝物
		if cbFlag == "mysteryshop.resolveTreasure" then
			local fnResolveAnimationCall = function ( ... )
				local tbItem = {}

				UserModel.addSilverNumber(tonumber(dictData.ret.silver) or 0)
				local silverInfo = {}
				silverInfo.icon = ItemUtil.getSiliverIconByNum(dictData.ret.silver)
				silverInfo.name = m_i18n[1520]
				table.insert( tbItem, silverInfo )

				local itemInfo = dictData.ret.item
				-- require "db/DB_Item_normal"
				logger:debug(itemInfo)
				for k,v in pairs(itemInfo) do
					local itemData = {}
					local iteminfo = {}
					itemData.icon , iteminfo = ItemUtil.createBtnByTemplateIdAndNumber(k,v)
					itemData.name = iteminfo.name
					logger:debug(itemData)
					table.insert( tbItem, itemData )
				end

				local layReward = UIHelper.createGetRewardInfoDlg(m_i18nString(2011), tbItem )
				LayerManager.addLayoutNoScale(layReward)

				updateViewBtnState(m_ResolveNull)
			end

			ResolveView.showAnimation(fnResolveAnimationCall)
		end
		--炼化伙伴
		if cbFlag == "mysteryshop.resolveHero" then
			local fnResolveAnimationCall = function ( ... )
				local tbItem = {}

				if(dictData.ret.silver and tonumber(dictData.ret.silver) > 0) then
					local silverInfo = {}
					silverInfo.icon = ItemUtil.getSiliverIconByNum(dictData.ret.silver)
					silverInfo.name = m_i18n[1520]
					table.insert( tbItem, silverInfo )
				end

				if(dictData.ret.jewel) then
					local jewelInfo = {}
					jewelInfo.icon = ItemUtil.getJewelIconByNum(dictData.ret.jewel)
					jewelInfo.name = m_i18n[2082]
					table.insert( tbItem, jewelInfo )
				end

				local itemInfo = dictData.ret.item
				require "db/DB_Item_hero_fragment"
				logger:debug(itemInfo)
				for k,v in pairs(itemInfo) do
					local itemData = {}
					itemData.icon = ItemUtil.createBtnByTemplateIdAndNumber(k,tonumber(v))
					itemData.name = DB_Item_hero_fragment.getDataById(k).name
					logger:debug(itemData)
					table.insert( tbItem, itemData )
				end

				local layReward = UIHelper.createGetRewardInfoDlg( m_i18nString(2011), tbItem )
				LayerManager.addLayoutNoScale(layReward)

				updateViewBtnState(m_ResolveNull)
			end

			UserModel.addSilverNumber(tonumber(dictData.ret.silver))
			UserModel.addJewelNum(tonumber(dictData.ret.jewel) or 0)
			ResolveView.showAnimation(fnResolveAnimationCall)
		end
	end
end
--发送分解请求后，背包的推送之后更新本界面的数据
function refrashEquipData()
	m_tbSelectedEquips = {}
	getFiltersForEquip()

end
function refrashTreasData( ... )
	m_tbSelectedTreas = {}
	getFiltersForTreas()

end
function refrashHerosData( ... )
	m_tbSelectedHeroes = {}
	getFilterHeroList()

end
function refrashPartnerData( ... )
	for i = 1,#m_tbSelectedParnter do
		HeroModel.deleteHeroByHid(m_tbSelectedParnter[i].hid)
	end
	m_tbAllParnter = {}
	m_tbSelectedParnter = {}
	--初始化所有的数据
	getFilterPartnerList()
end

local function deleteLastChar( str )
	if(string.len(str) > 0) then
		return  string.sub(str,0 ,string.len(str) - 1)
	else
		return str
	end
end

local function getResolveTipInfo( tbSelectInfo ,i18n_6,i18n_5,i18n_end)
	local tbStrContent = {}
	local tipTitle = ""
	local richStrContent1 ,richStrContent2,richStrContent3,richStrContent4 = "","","",""
	local fiveStarCount = 0
	local sixStarCount = 0
	for i = 1,#tbSelectInfo do
		if(tbSelectInfo[i].star_lv == 5 and fiveStarCount < 3) then
			richStrContent1 = richStrContent1 .. "[" .. tbSelectInfo[i].name .. "]" .. ","
			fiveStarCount = fiveStarCount + 1
		elseif(tbSelectInfo[i].star_lv  == 5 and fiveStarCount >= 3) then
			richStrContent2 = richStrContent2 .. "[" .. tbSelectInfo[i].name .. "]" .. ","
			fiveStarCount = fiveStarCount + 1
		end

		if(tonumber(tbSelectInfo[i].star_lv) == 6 and  sixStarCount < 3) then
			richStrContent3 = richStrContent3 .. "[" .. tbSelectInfo[i].name .. "]" .. ","
			sixStarCount = sixStarCount + 1
		elseif(tonumber(tbSelectInfo[i].star_lv) == 6 and sixStarCount >= 3) then
			richStrContent4 = richStrContent4 .. "[" .. tbSelectInfo[i].name .. "]" .. ","
			sixStarCount = sixStarCount + 1
		end
	end

	local purpleColor =  g_QulityColor[5]
	local orangeColor =  g_QulityColor[6]

	--6星提示
	if((string.len(richStrContent3) > 0) or (string.len(richStrContent4) > 0)) then
		tipTitle = string.gsub(m_i18nString(i18n_6,m_i18n[1834]) ,"#", "|")
		table.insert(tbStrContent, {tipTitle,{{color=titleColor};{color = orangeColor};{color = titleColor};}})
	end

	if(string.len(richStrContent3) > 0) then
		table.insert(tbStrContent, {deleteLastChar(richStrContent3),{{color = orangeColor};}})
	end
	if(string.len(richStrContent4) > 0) then
		table.insert(tbStrContent, {deleteLastChar(richStrContent4),{{color = orangeColor};}})
	end


	--五星提示
	if((string.len(richStrContent3) <= 0) and (string.len(richStrContent4) <= 0) and ((string.len(richStrContent1) > 0) or (string.len(richStrContent2) > 0))) then
		tipTitle =string.gsub(m_i18nString(i18n_6,m_i18n[1833]) ,"#", "|")
		table.insert(tbStrContent, {tipTitle,{{color=titleColor};{color = purpleColor};{color = titleColor};}})
	elseif(((string.len(richStrContent3) > 0) or  (string.len(richStrContent4) > 0)) and ((string.len(richStrContent1) > 0) or (string.len(richStrContent2) > 0))) then
		tipTitle =string.gsub(m_i18nString(i18n_5,m_i18n[1833]) ,"#", "|")
		table.insert(tbStrContent, {tipTitle,{{color = purpleColor};{color = titleColor};}})
	end

	if(string.len(richStrContent1) > 0) then
		table.insert(tbStrContent, {deleteLastChar(richStrContent1),{{color = purpleColor};}})
	end
	if(string.len(richStrContent2) > 0) then
		table.insert(tbStrContent, {deleteLastChar(richStrContent2),{{color = purpleColor};}})
	end
	if(string.len(tipTitle) > 0) then
		table.insert(tbStrContent,{m_i18nString(i18n_end),{{color=titleColor};}})
	end

	return 	 tbStrContent
end

--获取分解室的警告富文本信息 #8a3700
function getResloveConfirmText( ... )
	local tbStrContent = {}
	--三个item为一行，richStrContent1用来显示第一行，richStrContent2用来显示第二行
	local richStrContent1 ,richStrContent2,richStrContent3,richStrContent4 = "","","",""
	local tipTitle = ""
	--hero frags
	if (not table.isEmpty(m_tbSelectedHeroes)) then
		tbStrContent = getResolveTipInfo(m_tbSelectedHeroes,2005,2087,2006)
	end
	--伙伴富文本提示
	if (not table.isEmpty(m_tbSelectedParnter)) then
		tbStrContent = getResolveTipInfo(m_tbSelectedParnter,2024,2086,2008)
	end
	
	--宝物
	if (not table.isEmpty(m_tbSelectedTreas)) then
		local tipTitle =string.gsub(m_i18nString(2009,m_i18n[1833]) ,"#", "|")
		logger:debug(richStrContent2)
		for i = 1,#m_tbSelectedTreas do
			local nQuality = tonumber(m_tbSelectedTreas[i].itemDesc.quality)

			if(i <= 3 and nQuality >= 5) then
				richStrContent1 = richStrContent1 .. "[" .. m_tbSelectedTreas[i].itemDesc.name .. "]" .. ","
			elseif(i > 3 and nQuality>= 5) then
				richStrContent2 = richStrContent2 .. "[" .. m_tbSelectedTreas[i].itemDesc.name .. "]" .. ","
			end
		end

		local treasColor = g_QulityColor[5]
		--获取宝物精华的名字
		local refine_item = m_tbSelectedTreas[1].itemDesc.resolve_base_refine_item
		local refineItemId = string.split(refine_item,"|")[1]
		local treasRefineName = ItemUtil.getItemById(refineItemId).name

		if(string.len(richStrContent1) > 0 and string.len(richStrContent2) > 0 ) then
			tbStrContent[1]  = {tipTitle,{{color=titleColor};{color = treasColor};{color=titleColor};}}
			tbStrContent[2] =  {deleteLastChar(richStrContent1),{{color=treasColor};}}
			tbStrContent[3] =  {deleteLastChar(richStrContent2),{{color=treasColor};}}
			tbStrContent[4] = {string.gsub(m_i18nString(2010,treasRefineName) ,"#", "|"),{{color=titleColor};{color = treasColor};{color=titleColor};}}
			tbStrContent[5] = {m_i18nString(2088),{{color=titleColor};}}
			tbStrContent[6] = {m_i18nString(2008),{{color=titleColor};}}
		elseif(string.len(richStrContent1) > 0) then
			tbStrContent[1]  = {tipTitle,{{color=titleColor};{color=treasColor};{color=titleColor};}}
			tbStrContent[2] =  {deleteLastChar(richStrContent1),{{color=treasColor};}}
			tbStrContent[3] = {string.gsub(m_i18nString(2010,treasRefineName) ,"#", "|"),{{color=titleColor};{color = treasColor};{color=titleColor};}}
			tbStrContent[4] = {m_i18nString(2088),{{color=titleColor};}}
			tbStrContent[5] = {m_i18nString(2008),{{color=titleColor};}}
		end
	end
	--return一个富文本信息
	return tbStrContent
end

--获取用于添加到commonDlg上的layout
--parm :返回一个layout 和所有富文本的高度
function getTextLayOut( ... )
	--根据返回的富文本信息，生成一个layout
	local tbHeroText = getResloveConfirmText()
	logger:debug(tbHeroText)
	local layout = nil
	local heightTotle = 0
	--没有需要提示的信息则返回nil
	if(#tbHeroText > 0) then
		layout  = Layout:create()
		layout:setSize(CCSizeMake(380,30))
		for i=#tbHeroText,1,-1 do

			local richText = BTRichText.create(tbHeroText[i], nil)
			richText:setSize(CCSizeMake(380,0))
			richText:setAnchorPoint(ccp(0.5,1.0))
			richText:setPositionX(230)
			richText:setAlignCenter(true)
			layout:addChild(richText,0,i)
			richText:visit()

			local textHeight = richText:getTextHeight()
			logger:debug(textHeight)
			logger:debug(heightTotle)
			heightTotle = heightTotle + textHeight + 10
			richText:setPositionY(heightTotle)
		end
		layout:setSize(CCSizeMake(460,heightTotle))
	end

	return layout, heightTotle
end
--炼化之前给用户一个确认提示，confimCallBack是点击了确定之后的回调，开始向后端发请求
function confirmResolve(confimCallBack )
	--获取text的lauout，返回layout和富文本的高度
	local textLayout , heightTotle = getTextLayOut()
	if(textLayout)then
		local dlg  = UIHelper.createCommonDlg(nil, textLayout, confimCallBack,2)
		LayerManager.addLayout(dlg)
		logger:debug(heightTotle)
		UIHelper.updateCommonDlgSize(dlg,heightTotle)
	else
		--layout为空则说明选择的东西不需要提示
		confimCallBack(nil,TOUCH_EVENT_ENDED)
	end
end

--开始炼化
function beginToResolve()
	local arg = CCArray:create()
	arg:retain()
	local subArg = CCArray:create()
	subArg:retain()
	--炼化伙伴影子
	if (not table.isEmpty(m_tbSelectedHeroes)) then

		for i = 1,#m_tbSelectedHeroes do
			subArg:addObject(CCInteger:create(m_tbSelectedHeroes[i].item_id))
		end
		--确定按钮回调
		function onConfirm (sender, eventType)
			if (eventType == TOUCH_EVENT_ENDED) then
				LayerManager:removeLayout()
				arg:addObject(subArg)
				PreRequest.setBagDataChangedDelete(refrashHerosData)
				RequestCenter.resolveHeroFrag(fnHandlerOfNetwork,arg)
			end
		end
		--获取确认要炼化的富文本的lauout
		confirmResolve(onConfirm)
		--炼化宝物
	elseif (not table.isEmpty(m_tbSelectedTreas)) then
		logger:debug(m_tbSelectedTreas)
		if(ItemUtil.isTreasBagFull(true) == true) then
			return
		end

		for i = 1,#m_tbSelectedTreas do
			subArg:addObject(CCInteger:create(m_tbSelectedTreas[i].item_id))
		end
		--确定按钮回调
		local  function onConfirm (sender, eventType)
			if (eventType == TOUCH_EVENT_ENDED) then
				logger:debug("begian")
				LayerManager:removeLayout()
				arg:addObject(subArg)
				--注册背包推送回调
				PreRequest.setBagDataChangedDelete(refrashTreasData)
				RequestCenter.resolveTreasures(fnHandlerOfNetwork,arg)
			end
		end
		confirmResolve(onConfirm)
		--分解伙伴
	elseif (not table.isEmpty(m_tbSelectedParnter)) then
		for i = 1,#m_tbSelectedParnter do
			subArg:addObject(CCInteger:create(m_tbSelectedParnter[i].hid))
		end
		logger:debug(m_tbSelectedParnter)
		--确定按钮回调
		function onConfirm (sender, eventType)
			if (eventType == TOUCH_EVENT_ENDED) then
				LayerManager:removeLayout()
				arg:addObject(subArg)
				PreRequest.setBagDataChangedDelete(refrashPartnerData)
				RequestCenter.resolveHero(fnHandlerOfNetwork,arg)
			end
		end
		--获取确认要炼化的富文本的lauout
		confirmResolve(onConfirm)
	else
		ShowNotice.showShellInfo(m_i18nString(2003))
	end
end
--按钮注册
function btnRegister( tbBtnEvent )
	tbBtnEvent.onIntroduce = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED and m_bIsAnimationg == false) then
			logger:debug("tbBtnEvent.onIntroduce")
			AudioHelper.playCommonEffect()
			local layIntroduce = g_fnLoadUI("ui/help_decompose.json")
			LayerManager.addLayout(layIntroduce)

			local i18nDesc = g_fnGetWidgetByName(layIntroduce, "tfd_desc")
			i18nDesc:setText(m_i18nString(2002))

			local btnClose = m_fnGetWidget(layIntroduce,"BTN_CLOSE")
			btnClose:addTouchEventListener(function ( sender, eventType)
				if (eventType == TOUCH_EVENT_ENDED) then
					AudioHelper.playCloseEffect()
					LayerManager.removeLayout()
				end
			end
			)
		end
	end

	-- 添加武将影子按钮
	tbBtnEvent.onAddHero= function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED and m_bIsAnimationg == false) then
			logger:debug("tbBtnEvent.onAddHero")
			AudioHelper.playCommonEffect()
			fastAddHero()
		end
	end
	-- 添加伙伴按钮
	tbBtnEvent.onAddParnter= function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED and m_bIsAnimationg == false) then
			logger:debug("tbBtnEvent.onAddParnter")
			AudioHelper.playCommonEffect()
			fastAddParnter()
		end
	end

	-- 添加宝物按钮
	tbBtnEvent.onAddTreas = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED and m_bIsAnimationg == false) then
			logger:debug("tbBtnEvent.onAddTreas")
			AudioHelper.playCommonEffect()
			fastAddTreas()
		end
	end

	-- 换一组武将影子按钮
	tbBtnEvent.onChangeHero= function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED and m_bIsAnimationg == false) then
			logger:debug("tbBtnEvent.onChangeHero")
			logger:debug(m_nSelectHeroCount)
			AudioHelper.playCommonEffect()
			changeHero()
		end
	end
	-- 换一组伙伴按钮
	tbBtnEvent.onChangeParnter= function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED and m_bIsAnimationg == false) then
			logger:debug("tbBtnEvent.onChangeHero")
			logger:debug(m_nSelectHeroCount)
			AudioHelper.playCommonEffect()
			changeParnter()
		end
	end
	-- 换一组宝物按钮
	tbBtnEvent.onChangeTreas = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED and m_bIsAnimationg == false) then
			logger:debug("tbBtnEvent.onChangeTreas")
			AudioHelper.playCommonEffect()
			changeTreas()
		end
	end
	--分解按钮
	tbBtnEvent.onResolve = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED and m_bIsAnimationg == false) then
			logger:debug("tbBtnEvent.onResolve")
			AudioHelper.playCommonEffect()
			beginToResolve()
		end
	end

	tbBtnEvent.onAdd = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED and m_bIsAnimationg == false) then
			logger:debug("tbBtnEvent.onAdd")
			fnOnAddCall()
		end
	end
end

function create(...)
	init()
	local tbBtnEvent = {}
	-- 按钮注册
	btnRegister(tbBtnEvent)
	--初始化所有的数据
	local  layout =  ResolveView.create(tbBtnEvent)

	updateViewBtnState(m_ResolveNull)


	local skypieData = DataCache.getSkypieaData()
	local isOpenSky = SwitchModel.getSwitchOpenState(ksSwitchTower)
	logger:debug(#skypieData)
	logger:debug(table.count(skypieData))
	logger:debug(isOpenSky)
	if(table.count(skypieData) == 0 and isOpenSky == true) then
			local function getSkyPieaInfoCallBack(cbFlag, dictData, bRet)
				if(bRet) then
					DataCache.setSkypieaData(dictData.ret)
				end
			end

		RequestCenter.skyPieaEnter(getSkyPieaInfoCallBack)
	end

	return layout
end
--选择界面的回调函数 ，用来释放tableview
function exitCall( ... )
	LayerManager.resetPaomadeng()
	ResolveSelectCtrl.destruct()
end

function enterCall( ... )
	logger:debug("enter call")
end
