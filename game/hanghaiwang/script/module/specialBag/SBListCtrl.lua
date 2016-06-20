-- FileName: SBListCtrl.lua
-- Author: liweidong
-- Date: 2015-09-15
-- Purpose: 专属宝物背包list ctrl
--[[TODO List]]

module("SBListCtrl", package.seeall)
require "script/module/specialBag/SBListModel"
-- UI控件引用变量 --

-- 模块局部变量 --
local _listOffset = nil --记录list的偏移坐标

local function init(...)

end

function destroy(...)
	package.loaded["SBListCtrl"] = nil
end

function moduleName()
    return "SBListCtrl"
end

function setReturnInfo(  )
    DropUtil.insertReturnInfo(moduleName(),"topBar",function ( ... )
        PlayerPanel.addForPartnerStrength()
    end)
end

--进入宝物背包
function create(...)
	if (LayerManager.curModuleName()==SBListCtrl.moduleName()) then
		return
	end
	require "script/module/specialBag/SBListView"
	local layout = SBListView:create()
	LayerManager.changeModule(layout, SBListCtrl.moduleName(), {3,1}, true)
	PlayerPanel.addForPartnerStrength()
	SBListModel.getItemListData(true) --重新生成列表排序数据
	SBListView.loadItemList()
	SBListView.updateUI()
end
--进入碎片背包
function createFrag()
	if (LayerManager.curModuleName()==SBListCtrl.moduleName()) then
		return
	end
	require "script/module/specialBag/SBListView"
	local layout = SBListView:create()
	LayerManager.changeModule(layout, SBListCtrl.moduleName(), {3,1}, true)
	PlayerPanel.addForPartnerStrength()
	SBListModel.getFragListData(true) --重新生成列表排序数据
	SBListView.loadFragList()
	SBListView.updateUI()
end
--点击扩展背包 bagType 1 宝物 2：碎片
function onExpand(nIndex)
	local expData = {{itype = 5, i18nWarn = 6902, i18nRet = 1010, goldNeed = BagUtil.getNextOpenExclGridPrice()},
                     {itype = 6, i18nWarn = 6904, i18nRet = 1010, goldNeed = BagUtil.getNextOpenExclFragGridPrice()} -- 后端请求参数
                    }
    local m_nExpandNum = 5
    local strMsg = gi18nString(expData[nIndex].i18nWarn, m_nExpandNum, expData[nIndex].goldNeed)
    
    local function expandCallback( cbFlag, dictData, bRet )
        if (bRet) then
            UserModel.addGoldNumber(- expData[nIndex].goldNeed)
            ShowNotice.showShellInfo(gi18nString(expData[nIndex].i18nRet, expData[nIndex].goldNeed, m_nExpandNum))
            DataCache.addGidNumBy(expData[nIndex].itype, m_nExpandNum)
            if (LayerManager.curModuleName() == moduleName()) then
                SBListView.updateUI()
            end
        end
    end

    local function onConfirm ( sender, eventType )
        if (eventType == TOUCH_EVENT_ENDED) then
        	AudioHelper.playCommonEffect()
            if (expData[nIndex].goldNeed <= UserModel.getGoldNumber()) then
                local args = Network.argsHandler(m_nExpandNum, expData[nIndex].itype) -- nIndex=1, 开启装备格子; 2, 开启装备碎片格子
                RequestCenter.bag_openGridByGold(expandCallback, args)
                LayerManager.removeLayout()
            else -- 金币不足, 弹提示充值面板
                LayerManager.removeLayout() -- 关闭扩充提示面板
                LayerManager.addLayout(UIHelper.createNoGoldAlertDlg())
            end
        end
    end
    
    LayerManager.addLayout(UIHelper.createCommonDlg(strMsg, nil, onConfirm))
end
--点击宝物页签
function onclickItemTag()
	SBListModel.getItemListData(true) --重新生成列表排序数据
	SBListView.loadItemList()
	SBListView.updateUI()
end
--点击碎片页签
function onclickFragTag()
	SBListModel.getFragListData(true) --重新生成列表排序数据
	SBListView.loadFragList()
	SBListView.updateUI()
end
--刷新当前宝物列表 保持位置不变
function refreshItemList()
	SBListModel.getItemListData(true) --重新生成列表排序数据
	SBListView.loadItemList(true,_listOffset)
	SBListView.updateUI()
end
--刷新当前宝物碎片列表 保持位置不变
function refreshFragList()
	SBListModel.refreshFragList(true) --重新生成列表排序数据
	SBListView.loadFragList(true,_listOffset)
	SBListView.updateUI()
end
--点击去获取
function onclickToGet(idx,tid)
	-- local data = SBListModel.getItemListData()
	-- local item = data[idx]
	-- local tid = tonumber(item.itemDesc.id)

	local curModuleName = LayerManager.curModuleName()
	local callFn = function ( ... )
		SBListCtrl.refreshItemList()
	end

    -- DropUtil.insertCallFn(curModuleName,callFn)

	require "script/module/public/FragmentDrop"
	local fragmentDrop = FragmentDrop:new()
	local dropLayout = fragmentDrop:create(tid,callFn)
	LayerManager.addLayout(dropLayout)
	--  Tid - 宝物tid
end
--点击合成
function onclickCompond(idx)
	if (ItemUtil.isSpecialTreasBagFull(true)) then
		return
	end
	local data = SBListModel.getFragListData()
	local itemData = data[idx]
	local function useItemCallback( cbFlag, dictData, bRet )
	    if (bRet) then
	    end
	end
	-- 后端推送背包信息的回调
	local function refreshSpecialListData( ... )
		-- if (itemData.item_num-itemData.itemDesc.needfragmentnum>0)then --后端说减少数量后 格子还存在不会给推送，需要自己修改数量，但事实上有推送
		-- 	ItemUtil.reduceItemByGid(itemData.gid, itemData.itemDesc.needfragmentnum)
		-- end
		SBListModel.getFragListData(true) --重新生成列表排序数据
		SBListView.refreshFragList()
		SBListView.updateUI()
		PreRequest.removeBagDataChangedDelete()
		LayerManager.removeUILayer()
		-- SpecTreaInfoCtrl.create(itemData.itemDesc.id,nil,nil,nil,1)

		local data = {}
    	data.tid = tonumber(itemData.itemDesc.id)
    	data.num = 1 -- 数量为 1
    	data.iType = 4 -- 5 代表类型为：装备
    	require "script/module/shop/HeroDisplay"
	 	HeroDisplay.create(data, 4)
	end
	LayerManager.addUILayer()
	PreRequest.setBagDataChangedDelete(refreshSpecialListData) -- 注册后端推送背包信息时的回调，以便刷新专属宝物列表，红色圆圈提示等
	local args = Network.argsHandler(itemData.gid, itemData.item_id, itemData.itemDesc.need_part_num)
	RequestCenter.bag_useItem(useItemCallback, args)
end
--点击进阶按钮
function onclickAdvanced(idx)
	local data = SBListModel.getItemListData()
	local item = data[idx]
	logger:debug(data)
	if (item.itemDesc.isMasterkey==1) then
		ShowNotice.showShellInfo(gi18n[6945])
		return
	end
	local refineData = {}
	require "script/module/specialTreasure/SpecTreaRefineCtrl"
	SpecTreaRefineCtrl.create( item.item_id,1 )

end

--进阶后重新生成进阶所需要的列表数据
function getAdvancedData(item_id)
	local data = SBListModel.getItemListData(true)
	local idx = 1 -- 当前进阶的宝物在列表中的idx
	local refineData = {}
	for i,v in ipairs(data) do
		if (v.itemDesc.isMasterkey~=1) then
			table.insert(refineData,{tid=v.itemDesc.id, itemId = v.item_id , refineLevel=tonumber(v.va_item_text.exclusiveEvolve)})
		end
		if (item_id==v.item_id) then
			idx = i
		end
	end
	return refineData,idx
end

--进阶后重新生成进阶所需要的列表数据
function getSpecTreaDataByItemId(item_id)
	local data = SBListModel.getItemListData(true)
	local specTb = getmetatable(data[1])
	logger:debug({ getSpecTreaDataByItemId = specTb.__index })
	logger:debug({ getSpecTreaDataByItemId = item_id})
	local itemData = {}
	local refineData = {}
	for i,v in ipairs(data) do
		if (tonumber(item_id)== tonumber(v.item_id)) then
			
			return v
		end
	end
	return itemData
end

--点击宝物图标
function onClickItemIcon(idx)
	local data = SBListModel.getItemListData()
	local item = data[idx]
	local tid = tonumber(item.itemDesc.id)
	local itemId = tonumber(item.item_id)
	local hid = tonumber(item.equip_hid)
	local level = tonumber(item.va_item_text.exclusiveEvolve)

	require "script/module/specialTreasure/SpecTreaInfoCtrl"
	if (tonumber(tid) == 720001 ) then  -- 万能宝物
		SpecTreaInfoCtrl.create(tid,nil,nil,1)
	else
		SpecTreaInfoCtrl.create(tid,level, itemId,1)
	end
	--  Tid - 宝物tid ,refineLel - 宝物精炼等级 ,SpeTreaInfo -- 其他信息（暂定）
end
--点击碎片图标
function onClickFragIcon(idx)
	local data = SBListModel.getFragListData()
	local item = data[idx]
	local tid = tonumber(item.itemDesc.id)

	require "script/module/specialTreasure/SpecTreaInfoCtrl"
	logger:debug("SpecTreaInfoCtrl")
	SpecTreaInfoCtrl.create(tid,nil,nil,1)
end


