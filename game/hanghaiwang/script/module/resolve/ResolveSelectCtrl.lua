-- FileName: ResolveSelectCtrl.lua
-- Author:zhangjunwu
-- Date: 2014-04-00
-- Purpose: 分解物选择界面
--[[TODO List]]

module("ResolveSelectCtrl", package.seeall)

require "script/module/resolve/ResolveSelectView"
-- UI控件引用变量 --

-- 模块局部变量 --
local m_curPage = 1   --记录当前是在那个tab
local m_tArgsOfModule = nil  --所有的数据
local m_tbHeroCell = nil
local m_tbTreasCell = nil
local m_tbParnterCell = nil

local m_tbSelectedId = nil
local layMain  = nil
local function init(...)
	m_tbHeroCell = nil
	m_tbTreasCell = nil
	m_tbParnterCell = nil
end

function destroy(...)
	package.loaded["ResolveSelectCtrl"] = nil
end
--释放资源
function destruct( ... )
	m_tbHeroCell = nil
	m_tbTreasCell = nil
	m_tbParnterCell = nil

	m_tbSelectedId = nil
	ResolveSelectView.destruct()
end

function moduleName()
	return "ResolveSelectCtrl"
end
-- 构造 ItemCell 需要传递的数据
--[[
    tbShadowData = {name = "小刀海贼-" .. idx, sign = "item_type_shadow.png", 
    icon = btnIcon, sLevel = "Lv." .. idx, nStar = 4, nOwn = 1, 
    nMax = idx+1, onRecruit = onRecruitCall} 
} --]]
function getFiltersForHeros()
	--标签切换的时候清空所有的选中状态
	-- logger:debug(m_tbHeroCell)
	-- if(m_tbHeroCell ~= nil) then
	-- 	for i = 1, #m_tbHeroCell do
	-- 		m_tbHeroCell[i].bSelect = false
	-- 	end

	-- 	return m_tbHeroCell
	-- end
	m_tbHeroCell = {}
	local herosInfo = m_tArgsOfModule.filtersHero
	require "script/model/hero/HeroModel"
	require "db/DB_Item_hero_fragment"

	for k,v in pairs(herosInfo) do
		TimeUtil.timeStart("HeroModel")
		local value = {}
		value = v
		value.bCanSelectd = (v.item_num >= v.max_stack)
		value.bSelect = false
		if(m_curPage == 1)then
			for i = 1, #m_tbSelectedId do
				if(m_tbSelectedId[i] == v.item_id)then
					value.bSelect = true
					break
				end
			end
		end
		value.id = v.item_id
		table.insert(m_tbHeroCell,value)
	end
	return m_tbHeroCell
end
-- 构造 ItemCell 需要传递的数据
--[[
    tbShadowData = {name = "小刀海贼-" .. idx, sign = "item_type_shadow.png", 
    icon = btnIcon, sLevel = "Lv." .. idx, nStar = 4, nOwn = 1, 
    nMax = idx+1, onRecruit = onRecruitCall} 
} --]]
function getFiltersForParnter()
	--标签切换的时候清空所有的选中状态
	-- logger:debug(m_tbParnterCell)
	if(m_tbParnterCell ~= nil) then
		for i = 1, #m_tbParnterCell do
			m_tbParnterCell[i].bSelect = false
		end
		return m_tbParnterCell
	end

	m_tbParnterCell = {}
	local parntersInfo = m_tArgsOfModule.filtersParnter

	for k,v in pairs(parntersInfo) do
		local value = v
		if(m_curPage == 2)then
			for i = 1, #m_tbSelectedId do
				if(m_tbSelectedId[i] == v.hid)then
					value.bSelect = true
					break
				end
			end
		end

		value.id = v.hid
		table.insert(m_tbParnterCell,value)
	end
	-- logger:debug(m_tbParnterCell)
	return m_tbParnterCell
end

--过滤宝物
--[[
local tbData = {name = "小刀海贼-" .. idx, sign = "item_type_shadow.png", icon = btnIcon, 
    sStrongNum = 10, sStar = 88, sRank = 15, sAttr = "string of all attribute", -- Treasure
    sOwner = "小刀胖子", onRefining = onRecruitCall, onStrong = onRecruitCall, -- bag
    sPrice = 9999, bSelect = false, -- sale
    sOwner = "小刀胖子", onLoad = onRecruitCall, -- load
    bSelect = (idx%5 == 0), -- reborn
    sExp = 1000, bSelect = false, -- strong
} -]]
function getFiltersForTreas()
	-- --标签切换的时候清空所有的选中状态
	-- if(m_tbTreasCell ~= nil) then
	-- 	for i = 1, #m_tbTreasCell do
	-- 		m_tbTreasCell[i].bSelect = false
	-- 	end
	-- 	return m_tbTreasCell
	-- end
	-- logger:debug(m_tbSelectedId)
	--第一次进入此页面，配置cell数据
	m_tbTreasCell = {}
	local treasInfo = m_tArgsOfModule.filtersTreas
	require "db/DB_Item_arm"
	for k,v in pairs(treasInfo) do
		local value = {}

		local t_level = 0
		if( (not table.isEmpty(v.va_item_text) and v.va_item_text.treasureLevel ))then
			t_level = v.va_item_text.treasureLevel
		end

		value.sStrongNum = t_level
		value.sRefinNum = v.va_item_text.treasureEvolve or  0
		-- value.sStar = v.itemDesc.quality -- zhangqi, 2014-07-23, 星级弃用
		local m_tbAttr, m_tbPLAttr, m_nScore, m_tbEquipInfo = ItemUtil.getEquipNumerialByIID(v.item_id)
		-- 获得相关数值
		local attr_arr, score_t, ext_active = ItemUtil.getTreasAttrByItemId( tonumber(v.item_id), v)

		-- 处理 经验金马 经验银马 经验金书 经验银书, zhangqi, 2014-07-23
		if( (tonumber(v.itemDesc.isExpTreasure) == 1) )then
			local add_exp = tonumber(v.itemDesc.base_exp_arr) + tonumber(v.va_item_text.treasureExp)
			value.sSupplyExp = tostring(add_exp) -- 提供经验的数值
		else
			--CCLuaLog("getAtrrNameAndNum-begin: " .. os.clock())
			local strDesc, i = "", 1
			value.tbAttr = {}

			-- 显示基础属性 add by sunyunpeng 2015.07.10
			for i , ext_active_info in ipairs(ext_active) do
				if (ext_active_info.isOpen) then
					local affixDesc, displayNum = ItemUtil.getAtrrNameAndNum(ext_active_info.attId, ext_active_info.num)
					strDesc = strDesc .. affixDesc.displayName .. " +" .. displayNum .. "\n"
				end
			end

			for key, attr_info in pairs(attr_arr) do
				local affixDesc, displayNum = ItemUtil.getAtrrNameAndNum(attr_info.attId, attr_info.num)
				strDesc = strDesc .. affixDesc.sigleName .. " +" .. displayNum .. "\n"
				if (i%3 == 0 ) then
					table.insert(value.tbAttr, strDesc)
					strDesc = ""
				end
				i = i + 1
			end

			table.insert(value.tbAttr, strDesc)
		end

		value.nQuality = tonumber(v.itemDesc.quality)
		value.sRank = score_t.num
		value.name = v.itemDesc.name
		value.sign = ItemUtil.getSignTextByItem(v.itemDesc)
		value.icon  = {id = v.item_template_id}
		value.bSelect = false

		value.id = v.item_id

		if(m_curPage == 3)then
			for i = 1, #m_tbSelectedId do
				if(m_tbSelectedId[i] == v.item_id)then

					value.bSelect = true
					break
				end
			end
		end
		table.insert(m_tbTreasCell,value)
	end
	return m_tbTreasCell
end
--[[desc:功能简介
    arg1: tArgsOfModule 过滤伙伴 装备，宝物，时装信息;
    		selectid 被选中的id table;
    		tabType 
    return: 是否有返回值，返回值说明  
—]]
function create(tbListData,tabType ,tbSelectTemp)
	m_tArgsOfModule = tbListData
	local tbOnTouch = {}
	--确认按钮
	tbOnTouch.onSure = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("tbBtnEvent.onSure")
			AudioHelper.playCommonEffect()
			-- m_tbSelectedId = ResolveSelectView.getSelectedid()
			ResolveModel.setSelectedData()
			MainRecoveryView.setAddBtnAuto(true)
			MainRecoveryView.createSelectedIcons()
			
			layMain = nil
			LayerManager.removeLayout()
		end
	end
	--返回按钮
	tbOnTouch.onBack = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("tbBtnEvent.onBack")
			logger:debug(tbSelectTemp)
			ResolveModel.setSelectedDataBytemp(tbSelectTemp)
			AudioHelper.playBackEffect()

			MainRecoveryView.createSelectedIcons()
			LayerManager.removeLayout()

		end
	end
	logger:debug(ResolveModel.getSelectedData())

	layMain = ResolveSelectView.create(tbOnTouch ,m_tArgsOfModule,tabType)
	-- m_tbSelectedId = tbSelectId
	m_curPage = tabType
	
	ResolveSelectView.initTableView()


	return layMain
end

