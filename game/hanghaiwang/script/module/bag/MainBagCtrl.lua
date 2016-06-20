-- FileName: MainBagCtrl.lua
-- Author: zhangqi
-- Date: 2014-06-20
-- Purpose: 道具背包模块控制器
--[[TODO List]]

module("MainBagCtrl", package.seeall)

require "script/module/public/Bag"
require "script/module/bag/BagUtil"
require "script/module/public/Cell/ItemCell"

require "script/module/wonderfulActivity/buyBox/BuyBoxData"
require "script/module/wonderfulActivity/MainWonderfulActCtrl"

-- UI控件引用变量 --

-- 模块局部变量 --
local m_tbAllBagInfo -- 后端给的原始的背包信息
local m_tbBagInfo -- 按类型（装备，道具，宝物等）分类处理后的背包信息
local m_bag -- Bag 类的对象引用
local m_nExpandNum = 5 -- 背包一次扩充固定的 5 个格子
local m_i18n = gi18n
local m_i18nString = gi18nString
local m_fnGetWidget = g_fnGetWidgetByName
-- local m_tbBagCurInfo
local m_nUseTid
local m_nUseNum
local m_nUseGid
local m_tbUseItem
local m_nOldNum
local m_tbSaleData -- 出售列表数据

local m_nOldNeedNum = 0 -- 记录使用宝箱或钥匙时对应的另外一个道具的数量

local m_MONTH_CARD_TID = 60701 -- 月卡在item_normal表中的id，用来做区分

local m_tbYaoshuiId = { -- zhangqi, 2016-01-12, 存放所有体力药水和耐力药水的配置表id，用于使用按钮音效的播放
10031,10032,10033,10034,10035, -- 体力药水对应的配置表物品id
10041,10042,10043,10044,10045, -- 耐力药水对应的配置表物品id
}

local m_tbKeyId = {30012, 30013} -- 白银、黄金钥匙的配置表物品id

local function isCoin( tid )
	local nTid = tonumber(tid)
	local be, ed = 10011, 10030 -- 贝里和金币的配置表物品id
	for i = be, ed do
		if (nTid == i) then
			return true
		end
	end
	return false
end

local function init(...)
	m_tbAllBagInfo = nil
	m_tbBagInfo = nil

	m_nUseTid = nil
	m_nUseNum = nil
	m_nUseGid = nil
	m_tbUseItem = nil
	m_bag = nil
end

function destroy(...)
	init()
	package.loaded["MainBagCtrl"] = nil
end

function moduleName()
	return "MainBagCtrl"
end

function touchTabWithIndex( nIndex )
	if (m_bag) then
		m_bag:touchTabWithIndex(nIndex)
	end
end

-- 更新本模块背包数据
local function updateBagInfo ( ... )
	m_tbAllBagInfo = DataCache.getRemoteBagInfo() or {}
	-- logger:debug(m_tbAllBagInfo)
	m_tbBagInfo = DataCache.getBagInfo() or {}
	-- logger:debug(m_tbBagInfo)
end

local function getMaxNumByIndex( nIndex )
	return m_tbAllBagInfo.gridMaxNum.props
end

-- 扩充按钮事件回调
-- nIndex = 1, 道具
function onExpand ( nIndex )
	local expData = {{itype = 2, i18nWarn = 1507, i18nRet = 1010, goldNeed = BagUtil.getNextOpenPropGridPrice()},}
	local strMsg = m_i18nString(expData[nIndex].i18nWarn, m_nExpandNum, expData[nIndex].goldNeed)

	local function expandCallback( cbFlag, dictData, bRet )
		if (bRet) then
			UserModel.addGoldNumber(- expData[nIndex].goldNeed)
			ShowNotice.showShellInfo(m_i18nString(expData[nIndex].i18nRet, expData[nIndex].goldNeed, m_nExpandNum))
			DataCache.addGidNumBy( expData[nIndex].itype, m_nExpandNum)
			updateBagInfo() -- 刷新背包信息
			if (LayerManager.curModuleName() == moduleName()) then
				local maxNum = getMaxNumByIndex(nIndex)
				local extIndex = nIndex
				if (m_bag.mBtnIndex == nIndex) then
					extIndex = nil -- 如果是在背包里回调的扩充事件，nil 指定更新最大数，否则只提示扩充不更新最大数
				end
				m_bag:updateMaxNumber(getMaxNumByIndex(nIndex), extIndex) -- 刷新携带数
			end
		end
	end

	local function onConfirm ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			if (expData[nIndex].goldNeed <= UserModel.getGoldNumber()) then
                AudioHelper.playBuyGoods() 
				local args = Network.argsHandler(m_nExpandNum, expData[nIndex].itype) -- nIndex=1, 开启道具格子;
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

-- 后端推送背包信息的回调, 刷新道具背包列表
function refreshPropList( ... )
	if (not m_bag) then
		return
	end
	
	local viewData = getItemCellsData()

	local itemType = m_tbUseItem.itemDesc.item_type

	local delNum = 0 -- 默认不用删除cell
	if (m_nOldNum == m_nUseNum) then -- 一次使用完了
		delNum = (m_nOldNum == m_nOldNeedNum) and 2 or 1 -- 2，同时删除宝箱和钥匙；只删除1个
	elseif (m_tbUseItem.itemDesc.item_type == 8) then
		delNum = (m_nOldNeedNum == m_nUseNum) and 1 or 0 -- 1, 需要删除1个
	end
	
	m_bag:updateListWithData(viewData, nil, delNum, m_nUseIdx)
	
	--zhangjunwu 2014-11-24
	LayerManager.begainRemoveUILoading()
end

--快速出售更新背包的ListView
function setCallBackBag( delNum)
	local function upBagList( ... )
		if (not m_bag) then
			return
		end
		
		local viewData = getItemCellsData()

		m_bag:updateListWithData(viewData, nil, delNum)
		
		--zhangjunwu 2014-11-24
		LayerManager.begainRemoveUILoading()
	end
	GlobalNotify.addObserver(GlobalNotify.BAG_PUSH_CALL, upBagList, true)
end

-- 使用道具的回调事件
function useItemCallback( cbFlag, dictData, bRet )
	if (bRet and (not table.isEmpty(dictData.ret)) ) then
		local tbDrop = dictData.ret.drop
		local dlgTitle = m_i18n[1902] -- 面板标题，默认"开启宝箱"

		if ( table.isEmpty(tbDrop) ) then
			if (m_tbUseItem.itemDesc.isGift) then -- 是可选择礼包
				require "script/module/public/RewardUtil"
				local tbData = RewardUtil.parseRewards(dictData.ret.giftSelectStr)
				local dlg = UIHelper.createRewardDlg(tbData, nil, true)
				LayerManager.addLayoutNoScale(dlg)
			elseif (m_tbUseItem.itemDesc.award_item_id) then -- 包含多个物品的处理
				local arrGifts = ItemUtil.getGiftInfo(m_nUseTid)

				ItemDropUtil.refreshUserInfo(arrGifts) -- 将礼包中直接获取的数值更新到本地缓存，包括贝里，金币，经验石

				local tbGifts = {}  -- {item = tbItem, icon = btnIcon, sign = signPath, num = tbGift.num or 1}
				for i, gift in ipairs(arrGifts) do
					table.insert(tbGifts, ItemUtil.getGiftData(gift))
				end
				if (ItemUtil.isVipGift(m_tbUseItem.itemDesc.id)) then  -- 是vip礼包
					dlgTitle = m_i18n[1908]
					----modife zhangjunwu  2015-3-22 将vip礼包的奖励预览改为全屏
					require "script/module/public/RewardUtil"
					local tbRewardData = RewardUtil.parseRewardsByTb(arrGifts)
					local rewardVipDlg = UIHelper.createRewardDlg(tbRewardData, nil, true)
					LayerManager.addLayoutNoScale(rewardVipDlg)
					------------------end modifi
				else
					local tbInfo = {sTitle = dlgTitle, tbGift = tbGifts}
					require "script/module/bag/OpenGiftsView"
					LayerManager.addLayout(OpenGiftsView.create(tbInfo))
				end
			else
				-- 使用的物品是一定数量的贝里或金币的情况
				local useResult = ItemUtil.getUseResultBy(m_nUseTid, m_nUseNum, true) -- true表示在调用内部会根据获得属性值修改cache
				if (useResult.result_text ~= "") then
					ShowNotice.showShellInfo(useResult.result_text)
				end
			end
		else
			if (m_nUseNum > 1) then -- zhangqi, 2014-12-24, 批量使用的处理, 参考开宝箱 buyBox
				dlgTitle = m_i18n[1529]
				local tbGifts = ItemDropUtil.getDropItem(tbDrop)
				-- logger:debug(tbGifts)
				if (table.isEmpty(tbGifts)) then
					return
				end
				
				ItemDropUtil.refreshUserInfo(tbGifts)
				local rewardDlg = UIHelper.createRewardDlg(tbGifts, nil, true)
				LayerManager.addLayoutNoScale(rewardDlg)
			else
				local tbReward = ItemDropUtil.getDropItem(tbDrop) -- 2015-03-23，单个使用宝箱用全屏奖励界面
				ItemDropUtil.refreshUserInfo(tbReward) -- 同步更新贝里、金币的缓存
				local dlg = UIHelper.createRewardDlg(tbReward)
				LayerManager.addLayoutNoScale(dlg)
			end
		end

		if (m_tbUseItem.itemDesc.isRandGift) then -- 是随机礼包
			if (m_tbUseItem.itemDesc.use_needItem and m_tbUseItem.itemDesc.use_needItem > 0)then
				local t_info = ItemUtil.getCacheItemInfoBy( m_tbUseItem.itemDesc.use_needItem )
				if (not table.isEmpty(t_info)) then
					ItemUtil.reduceItemByGid(t_info.gid, tonumber(m_tbUseItem.itemDesc.use_needNum))
				end
			end
		end
		ItemUtil.reduceItemByGid(m_nUseGid, m_nUseNum)
	end
end
-- 使用道具按钮事件
local function useEvent ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		LayerManager.addUILoading() -- 添加屏蔽		

		local nGid = sender:getTag()
		m_nUseIdx = sender.idx -- 保存使用物品的列表索引

		m_tbUseItem = nil
		for k, item in pairs(m_tbBagInfo.props) do
			if (tonumber(item.gid) == nGid) then
				m_nUseTid = tonumber(item.item_template_id)
				m_nUseNum = 1
				m_nOldNum = tonumber(item.item_num)
				m_nUseGid = tonumber(item.gid)
				m_tbUseItem = item
				break
			end
		end

		local itemType = ItemUtil.getItemTypeByTid(m_nUseTid)
		-- zhangqi, 2016-01-12, 如果使用的物品是体力和耐力药水，播放特定的按钮音效，其他还是默认的
		-- 2016-01-13, 新增如果物品是礼包或随机礼包，播放指定的按钮音效
		if (itemType.isGift or itemType.isRandGift) then
			if (table.include(m_tbKeyId, m_nUseTid)) then
				AudioHelper.playCommonEffect() -- 2016-01-16, 如果是白银、黄金钥匙，则播放通用按钮音效
			else
				AudioHelper.playBtnEffect("anniu_dakailibao.mp3")
			end
		elseif (table.include(m_tbYaoshuiId, m_nUseTid) and m_nOldNum == 1) then -- 如果是1个才播放使用音效
			AudioHelper.playBtnEffect("shiyong_yaoshui.mp3")
		elseif (isCoin(m_nUseTid) and m_nOldNum == 1) then
			AudioHelper.playBuyGoods()
		else
			AudioHelper.playCommonEffect()
		end


		if (BuyBoxData.fnItemIsBoxOrKeyByTid(m_nUseTid)) then

			if(not SwitchModel.getSwitchOpenState(ksSwitchBuyTreasBox,true)) then
				LayerManager.begainRemoveUILoading()
				return
			end


			local function fnBackHere( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					AudioHelper.playBackEffect()
					MainScene.homeCallback()

					MainBagCtrl.create()

					require "script/module/main/MainScene"
					MainScene.changeMenuCircle(6)
				end
			end

			require "script/module/wonderfulActivity/buyBox/BuyBoxCtrl"
			BuyBoxCtrl.create(nil, fnBackHere)
			return 
		end

		if (m_tbUseItem) then
			-- 先处理是否判断背包已满的情况
			if ( m_tbUseItem.itemDesc.award_item_id ) then
				if (ItemUtil.isBagFull())then
					LayerManager.begainRemoveUILoading()
					return
				end
			end
			-- 当奖励为 award_card_id( 即奖励的可能为武将时)存在 并且 item_template_id 在 随机礼包的范围时，需判断伙伴背包是否已满
			if ( m_tbUseItem.itemDesc.award_card_id and m_tbUseItem.itemDesc.bRandGift) then
				if (ItemUtil.isPartnerFull()) then
					LayerManager.begainRemoveUILoading()
					return
				end
			end

			-- 4星将魂包 和 5星将魂包 不做判断
			if (m_tbUseItem.itemDesc.item_type == 8 and m_tbUseItem.itemDesc.id ~= 30021 and m_tbUseItem.itemDesc.id ~= 30022) then
				if (m_tbUseItem.itemDesc.id == 30201) then -- 5星武将包
					if (ItemUtil.isPartnerFull()) then
						LayerManager.begainRemoveUILoading()
						return
					end
				elseif (ItemUtil.isBagFull()) then
					LayerManager.begainRemoveUILoading()
					return
				end
			end

			if (m_tbUseItem.itemDesc.item_type == 5) then -- 可选择物品的礼包判断除伙伴背包外的其他4个背包
				if (ItemUtil.isBagFullExPartner()) then
					LayerManager.begainRemoveUILoading()
					return
				end
			end

			-- 结束判断背包已满的情况

			local function sendUsePRC( nUseNum )
				m_nUseNum = nUseNum -- 记录实际使用的次数，批量使用时可能会大于 1
				GlobalNotify.addObserver(GlobalNotify.BAG_PUSH_CALL, refreshPropList, true)
				local args = Network.argsHandler(m_tbUseItem.gid, m_tbUseItem.item_id, nUseNum)
				RequestCenter.bag_useItem(useItemCallback, args)
			end

			-- zhangqi, 2014-12-23, 显示批量使用的对话框
			local function showUseMoreDlg( nMaxUseNum, dbItem)
				local tbData = { totalNum = nMaxUseNum, name = dbItem.name, useCallback = sendUsePRC, quality = dbItem.quality, tid = dbItem.id}
				require "script/module/bag/UseMoreView"
				local useMoreItem = UseMoreItemView:new()
				local moreDlg = useMoreItem:create(tbData)
				LayerManager.addLayout(moreDlg)
			end

			if (m_tbUseItem.itemDesc.item_type == 8) then  -- 各种宝箱
				-- 需要 use_needItem 标识的道具才能使用
    			if (m_tbUseItem.itemDesc.use_needItem and m_tbUseItem.itemDesc.use_needItem > 0) then
    				local t_info = ItemUtil.getCacheItemInfoBy( m_tbUseItem.itemDesc.use_needItem )
    				-- zhangqi, 2014-12-23, 如果宝箱没有配套使用的道具，需要跳转到开宝箱界面
    				if (table.isEmpty(t_info)) then
    					if (not SwitchModel.getSwitchOpenState(ksSwitchBuyBox,true)) then
    						LayerManager.begainRemoveUILoading()
							return -- 2015-02-13, 如果没有开启商店则不跳转
						end

						LayerManager.addUILoading()
						local act = MainWonderfulActCtrl.create("buyBox")
						LayerManager.changeModule(act, MainWonderfulActCtrl.moduleName(), {1,3},true)
						return
					elseif (m_nOldNum > 1 and tonumber(t_info.item_num) > 1) then -- 如果有多次使用次数
						m_nOldNeedNum = tonumber(t_info.item_num)
						local nMin = m_nOldNum < m_nOldNeedNum and m_nOldNum or m_nOldNeedNum
						showUseMoreDlg(nMin, m_tbUseItem.itemDesc)
    				else -- 只有一次使用次数
    					m_nOldNeedNum = tonumber(t_info.item_num)
    					sendUsePRC(m_nUseNum)
    				end
    			else
    				if (m_nOldNum > 1) then -- 如果有多次使用次数
						showUseMoreDlg(m_nOldNum, m_tbUseItem.itemDesc)
    				else -- 只有一次使用次数
    					sendUsePRC(m_nUseNum)
    				end
    			end
			elseif (m_tbUseItem.itemDesc.item_type == 9) then -- "宴会厅暂未开启" -- 2015-10-23 Xufei 改成“主船系统”
				if (not SwitchModel.getSwitchOpenState(ksSwitchMainShip)) then
					--ShowNotice.showShellInfo(m_i18n[1527])
					LayerManager.begainRemoveUILoading()
					return
    			end
				-- TODO 打开名将系统
			elseif (m_tbUseItem.itemDesc.item_type == 4) then -- 宠物
    			if (not SwitchModel.getSwitchOpenState(ksSwitchPet)) then
    				ShowNotice.showShellInfo(m_i18n[1528])
    				LayerManager.begainRemoveUILoading()
    				return
                end
				-- TODO 打开宠物系统
			elseif (m_tbUseItem.itemDesc.item_type == 5) then -- 可选择的礼包
				LayerManager.begainRemoveUILoading()

				require "script/module/bag/ChooseGiftCtrl"
				local dlg = ChooseGiftCtrl.create(m_tbUseItem)
				LayerManager.addLayout(dlg)
			else
				if (m_nOldNum > 1) then -- zhangqi, 2014-12-23, 加入批量使用物品的逻辑
					showUseMoreDlg(m_nOldNum, m_tbUseItem.itemDesc)
				else
	                sendUsePRC(m_nUseNum)
				end
			end
		end -- end of "if (m_tbUseItem)"
	end -- end of "if (eventType)
end

function getItemCellsData( ... )
	updateBagInfo() -- 先同步模块背包信息和Cache的背包信息，以便在背包推送后可以正确刷新

	-- logger:debug(m_tbBagInfo.props)

	local hasNewItem = false -- zhangqi, 2014-12-22, 是否有新增道具，如果有才用新的排序方法

	local tbCells = {}
	for i, v in ipairs(m_tbBagInfo.props or {}) do
		local item = {}
		item.name = v.itemDesc.name or " "
		item.sign = ItemUtil.getSignTextByItem(v.itemDesc)
		item.icon = {id = v.item_template_id}
		item.icon.onTouch = function ( sender, eventType )  -- 道具图标按钮事件，弹出道具信息框
			if (eventType == TOUCH_EVENT_ENDED) then
				PublicInfoCtrl.createItemInfoViewByTid(v.item_template_id, item.sOwnNum)
			end
		end
		if (v.newOrder) then
			hasNewItem = true
		end
		item.newOrder = v.newOrder or 0 -- zhangqi, 2014-12-22, 没有新道具顺序值的默认为0	

		item.nQuality = v.itemDesc.quality
		item.sOwnNum = v.item_num or 1
		item.sDesc = v.itemDesc.desc
		--排序所用的tid
		item.item_template_id =  v.item_template_id
		item.itemDesc = v.itemDesc
		-- 直接使用类物品/随机礼包/礼包/名将礼物/宠物 <==> 3/8/5/9/4
		local tbCanUse = {false, false, true, true, true, false, false, true, false, false}
		if (tbCanUse[v.itemDesc.item_type]) then
			item.onUse = useEvent
			item.gid = v.gid
		end

		item.enhanceExp = v.itemDesc.enhance_exp -- zhangqi, 2015-08-31, 新增附魔石可以提供附魔经验
		if (item.enhanceExp) then -- 如果是附魔石则显示 "去附魔" 按钮（打开装备背包）
			item.onEnhance = function ( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					AudioHelper.playCommonEffect()

					LayerManager.addUILoading() -- 添加屏蔽
					
					require "script/module/equipment/MainEquipmentCtrl"
					local layEquipment = MainEquipmentCtrl.create()
					if layEquipment then
						LayerManager.changeModule(layEquipment, MainEquipmentCtrl.moduleName(), {1, 3}, true)
						PlayerPanel.addForPartnerStrength()
					end
				end
			end
		end

		if (tonumber(v.itemDesc.item_type) == 9) then		-- 如果是主船道具，添加去分解和去激活的逻辑
			require "script/module/ship/ShipData"
			local shipId = ShipData.getShipIdByItemId(v.itemDesc.id)
			-- 如果没开启主船系统，则点击按钮后弹出提示
			if (not SwitchModel.getSwitchOpenState(ksSwitchMainShip)) then
				item.onActivate = function ( sender, eventType )
					if (eventType == TOUCH_EVENT_ENDED) then
						ShowNotice.showShellInfo("主船系统未开启")
						LayerManager.begainRemoveUILoading()
						return
					end
				end
			-- 如果使用过该道具，点击后去分解屋
			elseif (ShipData.getIfShipActivatedById(shipId)) then
				item.onDecompose = function ( sender, eventType )
					if (eventType == TOUCH_EVENT_ENDED) then
						AudioHelper.playCommonEffect()

						require "script/module/resolve/MainRecoveryCtrl"
						local nRecoveryType = ResolveTabType.E_SuperShip
				        local layResolve = MainRecoveryCtrl.create(nRecoveryType)
				        if (layResolve) then
				            LayerManager.changeModule(layResolve, MainRecoveryCtrl.moduleName(), {1,3}, true)
				            PlayerPanel.addForPublic()
				        end
					end
				end
			-- 如果没使用过该道具，点击后去主船激活
			else
				item.onActivate = function ( sender, eventType )
					if (eventType == TOUCH_EVENT_ENDED) then
						AudioHelper.playCommonEffect()

						require "script/module/ship/ShipMainCtrl"
						ShipMainCtrl.create(shipId, "bag")
					end
				end
			end
		end

		if (v.itemDesc.id == m_MONTH_CARD_TID) then -- 2015-11-26, 是月卡加去领取事件
			item.sDesc = m_i18nString(1539, VipCardModel.getRemainDays()) -- 月卡的描述显示剩余可领取天数
			item.onVipCard = function ( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					AudioHelper.playCommonEffect()
					local act = MainWonderfulActCtrl.create(WonderfulActModel.tbShowType.kVipCard)
					LayerManager.changeModule(act, MainWonderfulActCtrl.moduleName(), {1,3},true)
					local scene = CCDirector:sharedDirector():getRunningScene()
					performWithDelay(scene, function(...)
						MainWonderfulActView.updateLSVPos(WonderfulActModel.tbShowType.kVipCard)
					end, 1/60)
				end
			end
		end

		table.insert(tbCells, item)
	end
	
	if (hasNewItem) then
		logger:debug("newPropsSort")
		table.sort(tbCells,BagUtil.newPropsSort)
	else
		logger:debug("propsSort")
		table.sort(tbCells,BagUtil.propsSort)
	end

	-- zhangqi, 2014-12-26, 排序后才能记录最终的列表索引
	for i, item in ipairs(tbCells) do
		item.idx = i - 1 -- 保存当前物品在列表中的索引，CCTableViewCell的索引从0开始，需要 - 1
	end

	return tbCells
end

local function getItemViewConfig( ... )
	-- 构造列表需要的数据
	local tbView = {}
	tbView.szCell = g_fnCellSize(CELLTYPE.ITEM)
	tbView.tbDataSource = getItemCellsData()

	tbView.CellAtIndexCallback = function (tbData)
		local instCell = ItemCell:new()
		instCell:init(CELL_USE_TYPE.BAG)
		instCell:refresh(tbData)
		return instCell
	end

	return tbView
end

------------------------------------- 出售列表数据准备 -------------------------------------
--[[
tbItem = {name = "小刀海贼-" .. idx, sign = "item_type_shadow.png", icon = {id = tid, onTouch = func}, 
    sOwnNum = 10, sDesc = "宝物等等....", -- Item
    sPrice = 1000, bSelect = true, -- sale
} --]]
local function getItemSaleData( tbItem )
	local tbCells = {}
	for i, v in ipairs(m_tbBagInfo.props or {}) do
		if (v.itemDesc.sellable == 1) then -- 可卖
			local item = {}
			item.name = v.itemDesc.name or " "
			item.sign = ItemUtil.getSignTextByItem(v.itemDesc)
			item.icon = {id = v.item_template_id}
			item.icon.onTouch = function ( sender, eventType )  -- 道具图标按钮事件，弹出道具信息框
				if (eventType == TOUCH_EVENT_ENDED) then
					PublicInfoCtrl.createItemInfoViewByTid(v.item_template_id, item.sOwnNum)
				end
			end

			item.nQuality = v.itemDesc.quality
			item.sOwnNum = v.item_num or 1
			item.sDesc = v.itemDesc.desc

			item.nNum = tonumber(v.item_num)
			item.sPrice = tostring(v.itemDesc.sell_num)
			item.bSelect = false -- 默认非选中

			item.gid = v.gid
			item.item_id = tonumber(v.item_id)


			--排序所用的tid
			item.item_template_id =  v.item_template_id
			item.itemDesc = v.itemDesc

			--zhangjunwu 1.01-11-1 临时背包里的宝物不出现在出售列表
			if (tonumber(item.gid) >= 3000001 and tonumber(item.gid) < 4000000) then
				table.insert(tbCells, item)
			end

		end
	end

	table.sort(tbCells,BagUtil.propsSort)
	for i, item in ipairs(tbCells) do
		item.idx = i - 1 -- 保存当前物品在列表中的索引，CCTableViewCell的索引从0开始，需要 - 1
	end

	return tbCells
end

local function getItemSaleView( objSaleList )
	-- 构造列表需要的数据
	local tbView = {}

	tbView.szCell = g_fnCellSize(CELLTYPE.ITEM)
	tbView.tbDataSource = getItemSaleData()

	tbView.CellAtIndexCallback = function (tbData)
		local instCell = ItemCell:new()
		instCell:init(CELL_USE_TYPE.SALE)
		instCell:refresh(tbData)
		return instCell
	end

	tbView.CellTouchedCallback = function ( view, cell, objCell)
        AudioHelper.playCommonEffect()
		local index = cell:getIdx()
		local item = objSaleList.mList.Data[index + 1] -- 需要从HZListView的Data成员取对应的cell数据

		local bStat = not objCell.cbxSelect:getSelectedState()
		objCell.cbxSelect:setSelectedState(bStat)
		item.bSelect = bStat

		local itemPrice = tonumber(item.sPrice) * item.nNum-- 选中某种物品实际要加上所有数量*单价的总价
		objSaleList:changeItem(bStat, itemPrice, index)

		objSaleList.mSellList[item.gid] = bStat == true and item or nil

		objSaleList.mList.Data[index + 1] = item
	end

	return tbView
end

-- 必须实现getSaleListConfig这个方法，SaleList 类里会调用
local function getSaleListData( objSaleList )
	updateBagInfo() -- 同步模块背包信息和Cache的背包信息
	local tbData = getItemSaleData()
	return tbData
end

-- 必须实现getSaleListConfig这个方法，SaleList 类里会调用
local function getSaleListConfig( objSaleList )
	local tbCfg = getItemSaleView(objSaleList)
	return tbCfg
end

function create(nTabIndex)
	init()

	updateBagInfo()

	local tbBagInfo = {sType = BAGTYPE.BAG, expands = {1}, sales = {1}, nums = {1}}

	tbBagInfo.onExpand = onExpand

	tbBagInfo.tbTab = {}
	tbBagInfo.tbTab[1] = {nMaxNum = tonumber(m_tbAllBagInfo.gridMaxNum.props), tbView = getItemViewConfig()} -- 道具列表数据

	-- 出售列表
	tbBagInfo.tbSale = {fnGetSaleListConfig = getSaleListConfig, fnGetSaleListData = getSaleListData }
	m_bag = Bag.create(tbBagInfo, nTabIndex)
	local layBag = m_bag.mainList
	UIHelper.registExitAndEnterCall(layBag, function ( ... )
		m_bag = nil
	end)

	LayerManager.changeModule(layBag, moduleName(), {1, 3}, true)
	PlayerPanel.addForPartnerStrength()
end
