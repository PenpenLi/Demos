-- FileName: HeroPreview.lua
-- Author: menghao
-- Date: 2014-04-30
-- Purpose: 招将预览


module("HeroPreview", package.seeall)


require "db/DB_Hero_view"


-- UI控件引用变量 --
local m_UIMain

local m_btnQuit
local m_btnLowerHero
local m_btnSeniorHero

local m_tbBtns

local m_tfdTitle
local m_tfdRecruit

local m_lsvRow
local m_lsvCol

-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_fnAddStroke = UIHelper.labelAddStroke

local mi18n = gi18n

local m_nIndex
local m_curHerosData

local itemForCopy


local function onQuit( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCloseEffect()
		LayerManager.removeLayout()
	end
end


-- 通过 index 获得英雄的数据
local function getCurHerosData( index )
	index = (index == 4) and 3 or index
	local tempData = DB_Hero_view.getDataById(index).Heroes
	tempData = string.gsub(tempData, " ", "")
	tempData = lua_string_split(tempData, ",")
	return tempData
end


local function refreshListView( ... )
	m_lsvRow:removeAllItems()
	m_lsvCol:removeAllItems()

	local rowCount = math.floor((#m_curHerosData) / 5) + 1
	if ( (#m_curHerosData) % 5 == 0 ) then
		rowCount = math.floor((#m_curHerosData) / 5)
	end

	for i=1,rowCount do
		m_lsvCol:pushBackDefaultItem()
		for j=1,5 do
			local lsvRowI = tolua.cast(m_lsvCol:getItem( i - 1),"ListView")
			local k = (i - 1) * 5 + j
			if (k <= #m_curHerosData) then
				local item = itemForCopy:clone()
				-- 头像
				local heroIcon = m_fnGetWidget(item, "IMG_SHOP_RECRUIT_PREVIEW_HEAD_ICON")
				local imgFilePath =  HeroModel.getHeroHeadIconByHtid(m_curHerosData[k])
				heroIcon:loadTexture(imgFilePath)

				-- 名字
				local tbColor = {ccc3(0x27,0x27,0x27), ccc3(0x27,0x27,0x27), ccc3(0x00,0x34,0x08), ccc3(0x00,0x28,0x55), ccc3(0x21,0x00,0x42), ccc3(0x69,0x27,0x00)}

				local heroInfo = DB_Heroes.getDataById(tonumber(m_curHerosData[k]))
				local heroName = m_fnGetWidget(item, "TFD_SHOP_RECRUIT_PREVIEW_NAME")
				heroName:setText(heroInfo.name)
				heroName:setColor(tbColor[heroInfo.potential])

				local heroIconBg = m_fnGetWidget(item, "IMG_SHOP_RECRUIT_PREVIEW_HEAD_BG")
				heroIconBg:loadTexture("images/others/hero_bg_0" .. heroInfo.potential .. ".png")

				lsvRowI:pushBackCustomItem(item)
			end
		end
	end

	m_lsvCol:jumpToTop()
end


local function showViewByIndex( index )
	if (m_nIndex == 4) then
		m_btnLowerHero:setEnabled(false)
		m_btnSeniorHero:setEnabled(false)

		m_fnAddStroke(m_tfdRecruit, mi18n[1440])

		m_curHerosData = getCurHerosData(m_nIndex)
		refreshListView()

		return
	end

	if (index == m_nIndex) then
		m_tbBtns[m_nIndex]:setFocused(true)
		return
	end
	if (index and index ~= m_nIndex) then
		m_tbBtns[m_nIndex]:setFocused(false)
		m_nIndex = index
	end
	if (m_nIndex == 1) then
		m_btnLowerHero:setFocused(true)
		m_fnAddStroke(m_tfdRecruit, mi18n[1438])
	elseif (m_nIndex == 2) then

	else
		m_btnSeniorHero:setFocused(true)
		m_fnAddStroke(m_tfdRecruit, mi18n[1440])
	end
	m_curHerosData = getCurHerosData(m_nIndex)
	refreshListView()
end


local function onLower( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playTabEffect()
		showViewByIndex(1)
	end
end


local function onSenior( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playTabEffect()
		showViewByIndex(3)
	end
end


local function init(...)
	m_btnQuit = m_fnGetWidget(m_UIMain, "BTN_RECRUIT_SENIOR_HERO_CLOSE")
	m_btnLowerHero = m_fnGetWidget(m_UIMain, "BTN_RECRUIT_LOWER_HERO_TAB")
	m_btnSeniorHero = m_fnGetWidget(m_UIMain, "BTN_RECRUIT_SENIOR_HERO_TAB")

	m_tfdTitle = m_fnGetWidget(m_UIMain, "tfd_shop_recruit_preview_title")
	m_tfdRecruit = m_fnGetWidget(m_UIMain, "TFD_RECRUIT")

	m_btnLowerHero:setFocused(false)
	m_btnSeniorHero:setFocused(false)

	m_tbBtns = {m_btnLowerHero, m_btnLowerHero, m_btnSeniorHero}

	-- m_fnAddStroke(m_tfdTitle, mi18n[1404])

	m_btnQuit:addTouchEventListener(onQuit)
	m_btnLowerHero:addTouchEventListener(onLower)
	m_btnSeniorHero:addTouchEventListener(onSenior)


	m_btnLowerHero:setTitleText(mi18n[1431])
	m_btnSeniorHero:setTitleText(mi18n[1433])
	-- UIHelper.titleShadow(m_btnLowerHero, mi18n[1431])
	-- UIHelper.titleShadow(m_btnSeniorHero, mi18n[1433])

	m_lsvRow = m_fnGetWidget(m_UIMain, "LSV_SHOP_RECRUIT_PREVIEW_LIST")
	m_lsvCol = m_fnGetWidget(m_UIMain, "LSV_SHOP_RECRUIT_PREVIEW")

	local itemRow = m_lsvRow:getItem(0)
	itemForCopy = itemRow:clone()
	itemForCopy:retain()
	UIHelper.registExitAndEnterCall(m_UIMain, function ( ... )
		itemForCopy:release()
	end)

	local itemCol = m_lsvCol:getItem(0)
	m_lsvCol:setItemModel(itemCol)

	showViewByIndex()
end


function destroy(...)
	package.loaded["HeroPreview"] = nil
end


function moduleName()
	return "HeroPreview"
end


function create(index)
	m_UIMain = g_fnLoadUI("ui/shop_recruit_preview.json")

	m_nIndex = index
	LayerManager.addLayout(m_UIMain)
	init()
end

