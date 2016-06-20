-- FileName: SkyPleaSelect.lua
-- Author: liweidong
-- Date: 2015-02-27
-- Purpose: 空岛贝选择列表
--[[TODO List]]

module("SkyPleaSelect", package.seeall)

require "script/module/public/Cell/ConchCell"
require "script/module/public/ChooseList"
require "script/module/bag/BagUtil"
require "script/model/hero/HeroModel"
require "script/model/user/UserModel"
require "script/module/formation/MainFormation"
require "script/module/conch/ConchStrength/SkyPleaModel"
-- UI控件引用变量 --

-- 模块局部变量 --
local m_hId
local m_cellId
local m_conchId

local m_i18n = gi18n
local m_fnGetWidget = g_fnGetWidgetByName
local m_mainFM = MainFormation
local mItemUtil = ItemUtil
local m_fromHid = 0
local m_sOldItemId

local function init(...)

end

function destroy(...)
	package.loaded["SkyPleaSelect"] = nil
end

function moduleName()
    return "SkyPleaSelect"
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

local function changeBagData( ... )
	local bagInfo = DataCache.getRemoteBagInfo()

	local selectedIteminfo = nil
	local allHeros 			= HeroModel.getAllHeroes()
	
	if (m_fromHid == 0) then --在背包中取装备
		for i_gid, treaInfo in pairs(bagInfo.conch) do
			if (treaInfo.item_id == m_sOldItemId) then
				selectedIteminfo = treaInfo
				--在这里更新下背包的八个位置的数据
				mItemUtil.solveBagLackInfo(bagInfo.conch[i_gid], 3)
				bagInfo.conch[i_gid] = nil
				DataCache.setBagInfo(bagInfo)
				break
			end
		end
	else --在英雄身上
		selectedIteminfo = mItemUtil.getConchFromHeroByItemId(m_sOldItemId)
	end

	-- 之前的装备
	local sHid, sPos = tostring(m_hId), tostring(m_cellId)
	
	--对于原来在别人身上的要添加到表中
	local oldConch = allHeros[sHid].equip.conch[sPos]
	if(oldConch and tonumber(oldConch) ~= 0) then
		mItemUtil.pushitemCallback(oldConch, 3)
	end
		
	if(m_fromHid == 0)then
		allHeros[sHid].equip.conch[sPos] = selectedIteminfo -- 更换装备
	else
		local pConchs = allHeros[tostring(m_fromHid)].equip.conch
		for k,v in pairs(pConchs) do
			if(tonumber(v.item_id) == tonumber(selectedIteminfo.item_id)) then
				allHeros[tostring(m_fromHid)].equip.conch[k] = "0"
			end
		end
		allHeros[sHid].equip.conch[sPos] = selectedIteminfo
	end

	UserModel.setInfoChanged(true)
	UserModel.updateFightValue({[sHid] = {HeroFightUtil.FORCEVALUEPART.CONCH}, 
								[m_fromHid] = {HeroFightUtil.FORCEVALUEPART.CONCH} })

	MainFormation.updateHeroConch(m_cellId) -- zhangqi, 2015-06-19, 必须先更新战斗力才有效

	MainFormation.changeConch(true)
	MainFormation.showFlyQuality() -- 飘字
end

local function onLoadConchCallBack( cbFlag, dictData, bRet )
	if (bRet) then
		changeBagData()
		LayerManager.removeLayout()
	    m_mainFM.showWidgetMain()
	end
end

local function getConchCellData( v, tbConchs, heroConchTypes )
	local tbAttr = mItemUtil.getConchNumerialByItemId(v.item_id)

	local tbData 	= {}
	tbData.id 		= v.item_id
	tbData.level 	= v.va_item_text.level
	tbData.starLvl 	= v.itemDesc.quality  -- 星级弃用，zhangqi, 2014-07-24
	tbData.quality 	= 0 --nScore
	tbData.nQuality	= v.itemDesc.quality
	tbData.sScore 	= tostring(v.itemDesc.scorce)
	tbData.name 	= v.itemDesc.name
	tbData.sign 	= mItemUtil.getSignTextByItem(v.itemDesc)
	tbData.icon 	= { id = v.item_template_id, bHero = false }
	tbData.icon.onTouch = function ( sender, eventType )
        if (eventType == TOUCH_EVENT_ENDED) then
            AudioHelper.playCommonEffect()
            require "script/module/conch/ConchStrength/SkyPieaInfoCtrl"
            SkyPieaInfoCtrl.createForOtherFormation(v) -- 只带一个"返回"按钮的空岛贝信息面板
        end
    end
	tbData.bSelect 	= false
    
	local fromHid 	= 0
	if (v.equip_hid) then
		tbData.owner 	= getHeroNameByHid(v.equip_hid)
		fromHid 	= v.equip_hid
	else -- 如果是未装备的空岛贝且已经装备同类型空岛贝，则显示“已装备同类型空岛贝”，i18id为5532
		if (heroConchTypes and heroConchTypes[v.itemDesc.type]) then
			tbData.owner = m_i18n[5532]
			tbData.bSameType = true
		end
	end

	tbData.onLoad 		= function ( sender, eventType )
		if (eventType 	== TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			--武将身上已有同类型空岛贝判断 但不考虑当前要替换的空岛贝
			local oldConch = nil --mItemUtil.getConchFromHeroByItemId(m_conchId)
			if (m_conchId~=nil ) then
				oldConch = mItemUtil.getConchFromHeroByItemId(m_conchId)
			end
			if (oldConch==nil or v.itemDesc.type~=oldConch.itemDesc.type) then
				local heroConch = mItemUtil.getConchOnFormationHid(m_hId)
				for _,val in pairs(heroConch) do
					if (val.itemDesc.type==v.itemDesc.type) then
						ShowNotice.showShellInfo(m_i18n[5516]..val.itemDesc.name)
						return
					end
				end
			end

			local args = CCArray:create()
			local itemId 	= v.item_id;
			--装备所在伙伴hid：fromHid
			m_sOldItemId 	= itemId

			
			args:addObject(CCInteger:create(m_hId))
			args:addObject(CCInteger:create(m_cellId))
			args:addObject(CCInteger:create(v.item_id))
			if tonumber(fromHid) > 0 then
				m_fromHid = fromHid
				args:addObject(CCInteger:create(fromHid))
			else
				m_fromHid = 0
			end

			RequestCenter.hero_addConch(onLoadConchCallBack, args)
		end
	end

	-- zhangqi, 2014-07-24, 属性值改为2列显示，1列显示3个
	tbData.tbAttr = {}
	local strDesc, i = "", 1
	logger:debug("conch values:")
	logger:debug(tbAttr)
	for k, val in pairs(tbAttr) do
		if (val ~= 0) then
		    strDesc = strDesc .. val.name .. " +" .. val.num .. "\n"
		    if (i%3 == 0 ) then
		        table.insert(tbData.tbAttr, strDesc)
		        strDesc = ""
		    end
		    i = i + 1
		end
	end
	table.insert(tbData.tbAttr, strDesc)

	tbData.rebornGoldNeed = v.itemDesc.resetCostGold

	table.insert( tbConchs, tbData )
end

-- zhangqi, 2015-03-10, 空岛贝选择列表排序
--[[
1.按照是否已装备排序，未装备的空岛贝排在前面，已装备的空岛贝排在后面
	由方法外部来处理
2.按照空岛贝的星级排列，星级越高，排列越靠前
3.按照空岛贝的等级排列，等级高的排列在前面
4.按照空岛贝的sort字段排序（用于同类型空岛贝的排序字段），id小的排列在前面，id大的排列在后面
]]
local function conchSort( conch1, conch2 )
	if (conch1.itemDesc.quality > conch2.itemDesc.quality) then
		return true
	elseif (conch1.itemDesc.quality == conch2.itemDesc.quality) then
		if (conch1.va_item_text.level > conch2.va_item_text.level) then
			return true
		elseif (conch1.va_item_text.level == conch2.va_item_text.level) then
			if (conch1.itemDesc.sort < conch2.itemDesc.sort) then
				return true
			end
		end
	end

	return false
end

--获取选择列表所有数据
function getAllConchs()
	local allConchs = {}

	local heroConchs = mItemUtil.getConchOnFormationHid(m_hId) -- 当前伙伴已装备的空岛贝
	local conchTypes = {}
	for i, v in ipairs(heroConchs) do -- 记录当前伙伴已准备的所有空岛贝的类型
		conchTypes[v.itemDesc.type] = true
	end

	-- 背包里未装备的空岛贝排序和cell数据准备
	local sortBagConchs = DataCache.getBagInfo().conch
	table.sort(sortBagConchs, conchSort)
	for k,v in pairs(sortBagConchs) do
		if(not mItemUtil.fnIsExpConchType(v.itemDesc.type) ) then
			getConchCellData(v, allConchs, conchTypes)
		end
	end

	-- 其他伙伴已装备的空岛贝排序和cell数据准备
	local otherHeroConchs = mItemUtil.getConchOnFormationExeptHid(m_hId)
	table.sort(otherHeroConchs, conchSort)
	for _,v in pairs(otherHeroConchs) do
		if(not mItemUtil.fnIsExpConchType(v.itemDesc.type) ) then
			getConchCellData(v, allConchs)
		end
	end

	return allConchs
end

--hid 武将id   cellId 整容中的第几个格子   conchId 要更换的空岛贝（第一次装备时为空）
function create( hId, cellId, conchId )
	m_mainFM.hideWidgetMain()
	--LayerManager.hideAllLayout(moduleName()) --由于指定父节点，这里不能使用此优化
	m_hId = hId
	m_cellId = cellId
	m_conchId = conchId
	local tbconchListInfo = getAllConchs()

	local tbEventListener = {}

	tbEventListener.onBack = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playBackEffect()
			LayerManager.removeLayout()
    		m_mainFM.showWidgetMain()
		end
	end

	tbEventListener.onSure = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			LayerManager.removeLayout()
    		m_mainFM.showWidgetMain()
		end
	end

	
	local tbInfo = {}

	tbInfo.sType = CHOOSELIST.LOADCONCH
	tbInfo.onBack = tbEventListener.onBack
	tbInfo.tbState = {sChoose = m_i18n[1522],sChooseNum = m_nSelectedNum,
		sExp = m_i18n[1060], sExpNum = m_nTotalExp, onOk = tbEventListener.onSure}


	tbInfo.tbView = {}
	tbInfo.tbView.szCell = g_fnCellSize(CELLTYPE.EQUIP)
	tbInfo.tbView.tbDataSource = tbconchListInfo

	tbInfo.tbView.CellAtIndexCallback = function (tbData)
		local instCell = ConchCell:new()
		instCell:init(CELL_USE_TYPE.LOAD)
		instCell:refresh(tbData)
		return instCell
	end

	tbInfo.tbView.CellTouchedCallback = function ( view, cell, objCell)
		return
	end

	local instTableView = ChooseList:new()
	local layMain = instTableView:create(tbInfo)
	UIHelper.registExitAndEnterCall(layMain,
				function()
					--LayerManager.remuseAllLayoutVisible(moduleName()) ----由于指定父节点，这里不能使用此优化
				end,
				function()
				end
			) 
	return layMain
end
