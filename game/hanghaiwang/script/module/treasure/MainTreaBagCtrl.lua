-- FileName: MainTreaBagCtrl.lua
-- Author: zhangqi
-- Date: 2015-09-14
-- Purpose: 宝物背包主控模块
--[[TODO List]]  

module("MainTreaBagCtrl", package.seeall)

require "script/module/public/Bag"
require "script/module/bag/BagUtil"
require "script/module/public/Cell/TreasureCell"
require "script/module/public/Cell/TreaFragCell"

-- UI控件引用变量 --

-- 模块局部变量 --
local _nExpandNum = 5 -- 背包一次扩充固定的 5 个格子
local _i18n = gi18n
local _i18nString = gi18nString

local _bag = nil -- 背包对象
local _objTreasFrag = nil -- 宝物碎片背包数据对象
local _objTreas = nil -- 宝物背包数据对象

local function init(...)
	_objTreas = BagModel.getBagHandler(BAG_TYPE_STR.treas)
	_objTreasFrag = BagModel.getBagHandler(BAG_TYPE_STR.treasFrag)
end

function destroy(...)
	package.loaded["MainTreaBagCtrl"] = nil
end

function moduleName()
    return "MainTreaBagCtrl"
end

local function getTreasSaleData( bagIndex )
	return _objTreas:getSaleListData()
	--[[
	if (bagIndex == 1) then
        return _objTreas:getSaleListData()
    elseif(bagIndex == 2) then
        return _objTreasFrag:getSaleListData()
    end
	--]]
end

-- 构造宝物出售列表的配置
local function getTreasSaleView( objSaleList )
	local tbView = {}

	tbView.szCell = g_fnCellSize(CELLTYPE.TREASURE)
	tbView.tbDataSource = getTreasSaleData()

	--[[
	local saleConf = {{handler = _objTreas}, {handler = _objTreasFrag}}
	saleConf[1].fnGetCell = function ( ... )
		return TreasureCell:new()
	end
	saleConf[1].fnGetCellSize = function ( ... )
		return g_fnCellSize(CELLTYPE.TREASURE)
	end

	saleConf[2].fnGetCell = function ( ... )
		return TreaFragCell:new()
	end
	saleConf[2].fnGetCellSize = function ( ... )
		return g_fnCellSize(CELLTYPE.TREA_FRAG)
	end

	local tabIdx = objSaleList.bagIndex

	tbView.szCell = saleConf[tabIdx].fnGetCellSize()
	tbView.tbDataSource = getTreasSaleData(tabIdx)
	--]]

	tbView.CellAtIndexCallback = function (tbData)
        AudioHelper.playCommonEffect()
		--local instCell, handler = nil, nil
		local instCell, handler = TreasureCell:new(), _objTreas 
		
		--instCell = saleConf[tabIdx].fnGetCell()
		--handler = saleConf[tabIdx].handler

		instCell:init(CELL_USE_TYPE.SALE)

		instCell:bagHandler(handler)

		handler:fillOne(tbData) -- 补全每个元素的其他字段

		instCell:refresh(tbData)
		
		return instCell
	end

	tbView.CellTouchedCallback = function ( view, cell, objCell)
		local index = cell:getIdx()
		local item = objSaleList.mList.Data[index + 1] -- 需要从HZListView的Data成员取对应的cell数据

		local bStat = not objCell.cbxSelect:getSelectedState()
		objCell.cbxSelect:setSelectedState(bStat)
		item.bSelect = bStat

		local itemPrice = tonumber(item.sPrice) * item.nNum -- 选中某种物品实际要加上所有数量*单价的总价
		objSaleList:changeItem(bStat, itemPrice, index)

		objSaleList.mSellList[item.gid] = bStat == true and item or nil

		objSaleList.mList.Data[index + 1] = item
	end

	return tbView
end

-- 必须实现getSaleListConfig这个方法，SaleList 类里会调用
local function getSaleListConfig( objSaleList )
	local tbCfg = getTreasSaleView(objSaleList)
	return tbCfg

	--[[
    if (objSaleList.bagIndex == 1) then
        return getTreasSaleView(objSaleList)
    elseif(objSaleList.bagIndex  == 2) then
        return getTreasSaleView(objSaleList)
    end
	]]
end

-- 宝物背包列表配置
local function getTreasViewConfig( ... )
	-- 构造列表需要的数据
	local tbView = {}
	tbView.szCell = g_fnCellSize(CELLTYPE.TREASURE)
	tbView.tbDataSource = _objTreas:getListData()

	tbView.CellAtIndexCallback = function (tbData, idx, objView)
		local instCell = TreasureCell:new(objView)
		instCell:init(CELL_USE_TYPE.BAG)
		instCell:bagHandler(_objTreas)

		_objTreas:fillOne(tbData) -- 补全每个元素的其他字段

		instCell:addDownCallback(function ( idxData )   
            require "db/DB_Switch"
            local strenthLv = DB_Switch.getDataById(ksSwitchTreasureForge).level
            local refinLv = DB_Switch.getDataById(ksSwitchTreasureFixed).level

    		local treasData = _objTreas:getListData()
            local itemData = treasData[idxData] -- 取当前物品cell的数据，后面提取对应的按钮事件给按钮面板

            -- 插入一条相对于按钮面板cell的人造数据 2015-04-24
            require "script/module/public/Cell/BtnBarCell"
            local size = g_fnCellSize(CELLTYPE.BTN_BAR)
            local barData = {isBtnBar = true, width = size.width, height = size.height}
            barData.events = {{event = itemData.onStrong, unlock = strenthLv, i18n = 1007}, 
                              {event = itemData.onRefining, unlock = refinLv, i18n = 1705}, {}, {}} -- 2015-11-20， 下拉按钮变4个，增加一个空表匹配个数
            objView:setBtnBarData(barData, idxData) -- 2015-05-13, 添加按钮面板的数据
        end)

		instCell:refresh(tbData)
		return instCell
	end

	return tbView
end

-- 宝物碎片背包列表配置
local function getTreaFragViewConfig( ... )
	-- 构造列表需要的数据
	local tbView = {}
	tbView.szCell = g_fnCellSize(CELLTYPE.TREA_FRAG)

	tbView.tbDataSource = _objTreasFrag:getListData()
	tbView.getData = function () return _objTreasFrag:getListData() end

	tbView.CellAtIndexCallback = function (tbData, idx, objView)
		local instCell = TreaFragCell:new(objView)
		instCell:init(CELL_USE_TYPE.BAG)
		instCell:bagHandler(_objTreasFrag)

		_objTreasFrag:fillOne(tbData) -- 补全每个元素的其他字段

		instCell:refresh(tbData)

		return instCell
	end

	return tbView
end

-- 扩充按钮事件回调
-- nIndex = 1, 宝物; 2 道具;
function onExpand ( nIndex )
	local expData = {{itype = 3, i18nWarn = 1702, i18nRet = 1010, goldNeed = BagUtil.getNextOpenPriceByType(BAG_TYPE_STR.treas)}, -- 后端请求参数
					 --{itype = 7, i18nWarn = 1177, i18nRet = 1010, goldNeed = BagUtil.getNextOpenPriceByType(BAG_TYPE_STR.treasFrag)},
					}
	local strMsg = _i18nString(expData[nIndex].i18nWarn, _nExpandNum, expData[nIndex].goldNeed)

	local function expandCallback( cbFlag, dictData, bRet )
		if (bRet) then
			UserModel.addGoldNumber(- expData[nIndex].goldNeed)
			ShowNotice.showShellInfo(_i18nString(expData[nIndex].i18nRet, expData[nIndex].goldNeed, _nExpandNum))
			DataCache.addGidNumBy( expData[nIndex].itype, _nExpandNum) -- 修改背包信息里的携带数

			if (LayerManager.curModuleName() == moduleName()) then
				local extIndex = nIndex
				if (_bag.mBtnIndex == nIndex) then
					extIndex = nil -- 如果是在背包里回调的扩充事件，nil 指定更新最大数，否则只提示扩充不更新最大数
				end
				_bag:updateMaxNumber(_objTreas:getMaxNum(), extIndex) -- 刷新携带数
			end
		end
	end

	local function onConfirm ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			if (expData[nIndex].goldNeed <= UserModel.getGoldNumber()) then
            	AudioHelper.playBuyGoods() 
				local args = Network.argsHandler(_nExpandNum, expData[nIndex].itype) -- nIndex=1, 开启宝物格子; 2, 开启道具格子
				RequestCenter.bag_openGridByGold(expandCallback, args)
				LayerManager.removeLayout()
			else -- 金币不足, 弹提示充值面板
        		AudioHelper.playCommonEffect()
				LayerManager.removeLayout() -- 关闭扩充提示面板
				LayerManager.addLayout(UIHelper.createNoGoldAlertDlg())
			end
		end
	end

	LayerManager.addLayout(UIHelper.createCommonDlg(strMsg, nil, onConfirm))
end


-- 从副本过来刷新列表
function resumBagCallFn( fraginfoTid,tableIndex)
    -- TimeUtil.timeStart("resumBagCallFn")
    local indexid = fraginfoTid
    listViewIndex = tableIndex 
    local ListValue 
    local tbDataSource
    if (listViewIndex ~= 0 and _bag) then     -- 是从背包进入副本
        local cellIndex = 0
        if (listViewIndex ==  1) then
        	tbDataSource = _objTreas:getListData()-- 宝物列表数据
        	for i,v in ipairs(tbDataSource or {}) do
        		if (tonumber(v.id) ~= tonumber(indexid)) then
                    cellIndex = cellIndex + 1
                else
                    break
                end
        	end
        elseif (listViewIndex ==  2) then
        	tbDataSource = _objTreasFrag:getListData()-- 宝物碎片列表数据
        	for i,v in ipairs(tbDataSource or {}) do
                if (tonumber(v.gid) ~= tonumber(indexid)) then
                    cellIndex = cellIndex + 1
                else
                    break
                end
            end
        end
        _bag:updateCurrentListWithData(tbDataSource, nil,1,cellIndex)

    end
    -- TimeUtil.timeEnd("resumBagCallFn")
end

-- zhangqi, 2016-02-24, 切换标签列表, 用于饰品碎片列表提示背包满时切换到饰品列表
function changeTabWithIndex( nIndex )
	_bag:touchTabWithIndex(nIndex)
end


function create(nTabIndex)
	init()

	-- zhangqi, 2015-09-23, 加入是否显示扩充按钮和出售按钮的配置项
	--local tbBagInfo = {sType = BAGTYPE.TREA, expands = {1,2}, sales = {1,2}, nums = {1,2}}
	local tbBagInfo = {sType = BAGTYPE.TREA, expands = {1}, sales = {1}, nums = {1}}

	tbBagInfo.onExpand = onExpand

	tbBagInfo.tbTab = {{}, {}} -- 宝物列表，宝物碎片列表

	local treaList = tbBagInfo.tbTab[1]  -- 宝物列表数据
	treaList.tbView = getTreasViewConfig()
	treaList.nMaxNum = _objTreas:getMaxNum()

	local treaFragList = tbBagInfo.tbTab[2] -- 宝物碎片列表
	treaFragList.tbView = getTreaFragViewConfig() -- 宝物碎片列表数据
	treaFragList.nMaxNum = _objTreasFrag:getMaxNum()
	treaFragList.num = _objTreasFrag:calcCanFuseNum() -- 可合成的数量

	-- 出售列表
	tbBagInfo.tbSale = {fnGetSaleListConfig = getSaleListConfig, fnGetSaleListData = getTreasSaleData }
	_bag = Bag.create(tbBagInfo, nTabIndex or 1)

	_objTreas:setBagObject(_bag)
	_objTreasFrag:setBagObject(_bag)

	local layBag = _bag.mainList
	UIHelper.registExitAndEnterCall(layBag, function ( ... )
		_bag = nil
	end)

	LayerManager.changeModule(layBag, moduleName(), {1, 3}, true)
	PlayerPanel.addForPartnerStrength()
end
