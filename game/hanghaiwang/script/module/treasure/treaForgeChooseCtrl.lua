-- FileName: treaForgeChooseCtrl.lua
-- Author: menghao
-- Date: 2014-05-21
-- Purpose: 宝物强化选择列表ctrl


module("treaForgeChooseCtrl", package.seeall)


require "script/module/public/Cell/TreasureCell"
require "script/module/public/ChooseList"


-- UI控件引用变量 --

--
-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local tbCell = {}
local m_nSelectedNum = 0
local m_tbSelectedID = {}
local m_nTotalExp = 0
local m_nType
local m_nQuality

local m_nTreaBeStrongID
local mi18n = gi18n

local m_isFull


-- 构造宝物列表需要的数据
function getTreaListData( quality,treaid,flag )
	local tbTreasureList = DataCache.getBagInfo().treas

	DataCache.fnSortTreasInBag()

	local tbListInfo = {}
	local tbTreaInfo, treaData, dbData
	for k, v in pairs(tbTreasureList) do
		--tbTreaInfo = treaInfoModel.getSimpleTreaInfo(v.item_id) -- zhangqi, 2015-06-15, 替换开销小的方法
		dbData = v.itemDesc

		-- 宝物强化筛选宝物规则。同时满足下面三条
		-- 1、同类型，类型0可以作其他类型材料，其他类型也可作0类型材料（ 2015.05.18 更改成不同类型也可以强化）
		-- 2、紫色宝物不可做为材料（经验宝物除外）
		-- 3、不能用自己强化自己
		local canBeEat1
		if (m_nType == 0) then
			canBeEat1 = true
		else
			canBeEat1 = dbData.quality <= quality or dbData.type == 0
		end

		-- local canBeEat2 = (dbData.isExpTreasure or (dbData.quality < 5))
		local canBeEat2 = (dbData.isExpTreasure)
		local canBeEat3 = (treaid ~= v.item_id)
		-- if (canBeEat1 and canBeEat2 and canBeEat3) then
		if (canBeEat2 and canBeEat3) then
			local tbData = {}

			tbData.orignData = v
			tbData.id = v.item_id
            tbData.type = dbData.type
			tbData.name = dbData.name
			tbData.sign = ItemUtil.getSignTextByItem(v.itemDesc)

			tbData.icon = { id = v.itemDesc.id, bHero = false }
			tbData.sStrongNum = v.va_item_text.treasureLevel
			tbData.sRefinNum = v.va_item_text.treasureEvolve
			tbData.nQuality = tonumber(dbData.quality)
			tbData.sRank = dbData.base_score
			tbData.sExp = v.va_item_text.treasureExp + dbData.base_exp_arr

			-- 经验宝物属性label, zhangqi, 2014-07-23, 宝物属性改为左3条，右3条
			if( (tonumber(dbData.isExpTreasure) == 1) )then
				tbData.sSupplyExp = tbData.sExp -- 2015-06-15，经验宝物提供经验的数值
			else
				local strAttrDesc = ""
				tbData.tbAttr = {}
				local baseProperty = treaInfoModel.fnGetTreaBaseProperty(v.item_template_id,v.va_item_text.treasureLevel)
				for i, v in ipairs(baseProperty or {}) do
					strAttrDesc = strAttrDesc .. v.name .. " +" .. v.value .. "\n"
					-- if (i%3 == 0 ) then
					-- 	table.insert(tbData.tbAttr, strAttrDesc)
					-- 	strAttrDesc = ""
					-- end
				end
				local property = treaInfoModel.fnGetTreaProperty(v.item_template_id,v.va_item_text.treasureLevel)
				for i, v in ipairs(property or {}) do
					strAttrDesc = strAttrDesc .. v.name .. " +" .. v.value .. "\n"
					-- if (i%3 == 0 ) then
					-- 	table.insert(tbData.tbAttr, strAttrDesc)
					-- 	strAttrDesc = ""
					-- end
				end
				table.insert(tbData.tbAttr, strAttrDesc)
			end

			tbData.bSelect = false
			for i=1,#m_tbSelectedID do
				if (m_tbSelectedID[i] == tbData.id) then
					tbData.bSelect = true
					m_nTotalExp = m_nTotalExp + tbData.sExp
				end
			end

			table.insert(tbListInfo, tbData)
		end
	end

	-- 排序，被选择的，经验宝物，经验少的，品质低的，id小的
	local function sortTreas(trea1, trea2)
		if (trea1.bSelect and not trea2.bSelect) then
			return true
		end
		if (not trea1.bSelect and trea2.bSelect) then
			return false
		end

		if (trea1.sSupplyExp and not trea2.sSupplyExp) then
			return true
		end
		if (not trea1.sSupplyExp and trea2.sSupplyExp) then
			return false
		end

		if (tonumber(trea1.sExp) ~= tonumber(trea2.sExp)) then
			return tonumber(trea1.sExp) < tonumber(trea2.sExp)
		end

	    if (tonumber(trea1.type) ~= tonumber(trea2.type)) then
			return tonumber(trea1.type) < tonumber(trea2.type)
		end

		if (trea1.nQuality ~= trea2.nQuality) then
			return trea1.nQuality < trea2.nQuality
		end

		return trea1.id < trea2.id
	end
    --新排序，经验少的，按照0>2>3>4>1顺序，id小的排在前面

    local function newsortTreas(trea1, trea2)

        if (not flag and trea1.bSelect and not trea2.bSelect) then    -- 被选择的
        	return true
        elseif (not flag and not trea1.bSelect and trea2.bSelect) then 
        	return false
        else
        	if (trea1.sSupplyExp and not trea2.sSupplyExp) then  -- 经验宝物
				return true
			elseif (not trea1.sSupplyExp and trea2.sSupplyExp) then
				return false
			else
		    	if (tonumber(trea1.sExp) ~= tonumber(trea2.sExp)) then  -- 经验少得
					return tonumber(trea1.sExp) < tonumber(trea2.sExp)
				else
					if (tonumber(trea1.type) ~= tonumber(trea2.type)) then    --  类型
		                return trea1.type < trea2.type
		            else
						if  (trea1.nQuality ~= trea2.nQuality) then           -- 品质
			                return tonumber(trea1.nQuality) < tonumber(trea2.nQuality) 
			            else
			                return tonumber(trea1.id) < tonumber(trea2.id)     -- id
			            end
			        end
			    end
			end
	    end
	end

    for i,v in ipairs(tbListInfo) do
    	if (v.type ==1) then
    		v.type = 5
    	end
    end
     
    table.sort(tbListInfo, newsortTreas)
    
    for i,v in ipairs(tbListInfo) do
    	if (v.type == 5) then
    		v.type = 1
    	end
    end
    


	--table.sort(tbListInfo, sortTreas)
	return tbListInfo
end


local function init(...)
	m_nTotalExp = 0
	m_isFull = false
end


function destroy(...)
	package.loaded["treaForgeChooseCtrl"] = nil
end


function moduleName()
	return "treaForgeChooseCtrl"
end




-- function create(tbSelectedID, m_tbTreaDb..treaType,m_tbTreaInfo.. treaID, nToMaxNeedExp)
function create(tbSelectedID, TreaInfo, nToMaxNeedExp)
	m_nSelectedNum = #tbSelectedID
	m_tbSelectedID = {}
	for k,v in pairs(tbSelectedID) do
		table.insert(m_tbSelectedID, v)
	end
	m_nType = TreaInfo.itemDesc.type
	m_nTreaBeStrongID = TreaInfo.item_id
    
    m_nQuality = TreaInfo.itemDesc.quality
	--m_nQuality = treaInfoModel.fnGetTreasAllData(m_nTreaBeStrongID).dbData.quality
	init()

	local tbTreaListInfo = getTreaListData(m_nQuality,m_nTreaBeStrongID)
	if m_nTotalExp >= nToMaxNeedExp then
		m_isFull = true
	end

	local tbEventListener = {}

	tbEventListener.onBack = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playBackEffect()
			LayerManager.removeLayout()
		end
	end

	tbEventListener.onSure = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()

			treaForgeCtrl.setSelectedTreas(m_tbSelectedID)
			LayerManager.removeLayout()
		end
	end

	local instTableView
	local tbInfo = {}

	tbInfo.sType = CHOOSELIST.TREASURE
	tbInfo.onBack = tbEventListener.onBack
	tbInfo.tbState = {sChoose = mi18n[1713],sChooseNum = m_nSelectedNum, sExp = mi18n[1060],
		sExpNum = m_nTotalExp, onOk = tbEventListener.onSure }


	tbInfo.tbView = {}
	local szCell = g_fnCellSize(CELLTYPE.TREASURE)
	tbInfo.tbView.szCell = CCSizeMake(szCell.width, szCell.height)
	tbInfo.tbView.tbDataSource = tbTreaListInfo

	tbInfo.tbView.CellAtIndexCallback = function (tbDat)
		local instCell = TreasureCell:new()
		instCell:init(CELL_USE_TYPE.STRONG)
		instCell:refresh(tbDat)
		return instCell
	end

	tbInfo.tbView.CellTouchedCallback = function ( view, cell, objCell)
        AudioHelper.playCommonEffect()
		
		local index = cell:getIdx()
		local tbData = tbTreaListInfo[index + 1]

		if (not tbData.bSelect) then
			if (m_nSelectedNum < 5) then
				if not m_isFull then
					tbData.bSelect = not tbData.bSelect
					objCell.cbxSelect:setSelectedState(tbData.bSelect)

					m_nSelectedNum = m_nSelectedNum + 1
					m_nTotalExp = m_nTotalExp + tbData.sExp
					tbInfo.tbState.sChooseNum = m_nSelectedNum
					tbInfo.tbState.sExpNum = m_nTotalExp
					table.insert(m_tbSelectedID, tbData.id)
				else
					ShowNotice.showShellInfo(gi18n[5527])
				end
			else
				ShowNotice.showShellInfo(mi18n[1058])
			end
		else
			tbData.bSelect = not tbData.bSelect
			objCell.cbxSelect:setSelectedState(tbData.bSelect)

			m_nSelectedNum = m_nSelectedNum - 1
			m_nTotalExp = m_nTotalExp - tbData.sExp
			tbInfo.tbState.sChooseNum = m_nSelectedNum
			tbInfo.tbState.sExpNum = m_nTotalExp
			for i=1,#m_tbSelectedID do
				if (m_tbSelectedID[i] == tbData.id) then
					table.remove(m_tbSelectedID, i)
				end
			end
		end

		if m_nTotalExp >= nToMaxNeedExp then
			m_isFull = true
		else
			m_isFull = false
		end
		instTableView:refreshChooseStateNum(tbInfo.tbState)
	end

	instTableView = ChooseList:new()
	

	local layMain = instTableView:create(tbInfo)

	return layMain
end

