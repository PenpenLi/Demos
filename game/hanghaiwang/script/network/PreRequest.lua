-- Filename：	PreRequest.lua
-- Author：		Cheng Liang
-- Date：		2013-7-16
-- Purpose：		物品Item
module("PreRequest", package.seeall)

require "script/network/RequestCenter"
require "script/model/DataCache"
require "script/module/switch/SwitchModel" 

local _new_useItem_num = 0  	-- 新增的使用物品的个数
local RECALL_INTERVAL = 3		-- 预加载信息未返回，重拉信息的定时间隔，3秒

-- zhangqi, 2015-04-23, 预加载信息的请求需要设置定时重拉，尽量避免第一次拉不到数据的错误
-- m_tbUnReCall 保存每个预加载信息请求定时重拉的取消定时器方法，以便信息返回后及时取消定时器
local m_tbUnReCall = {}

-- zhangqi, 2015-11-21, 注释掉 doUnReCall 和 setRecall 的实现，避免网络状况不好导致多次重发请求
-- zhangqi, 2015-04-23, 执行一个unReCall方法，带类型检查，目的是节省代码
function doUnReCall( sKeyTag )
	-- local fnUnSchedule = m_tbUnReCall[sKeyTag]
	-- if (type(fnUnSchedule) == "function") then
	-- 	fnUnSchedule()
	-- 	fnUnSchedule = nil
	-- end
end
-- 设置一个定时重拉的方法
-- sKeyTag: 必选，用于保存注销定时的key, 建议用拉取信息模块相关的名字，保证唯一
-- fnGetData: 必选，用于重拉信息的匿名function
-- nDelay: 可选，重拉信息的延时时间，单位秒；nil 的话默认3秒
function setRecall( sKeyTag, fnGetData, nDelay)
	-- local function back( ... )
	-- 	logger:debug("sKeyTag = %s", sKeyTag)
	-- 	fnGetData()
	-- end
	-- m_tbUnReCall[sKeyTag] = GlobalScheduler.scheduleFunc(back, nDelay or RECALL_INTERVAL)
end

function getNewUseItemNum()
	return _new_useItem_num
end

function clearNewuseItemNum()
	_new_useItem_num = 0
end

-- zhangqi, 2014-08-09, 是否显示某种背包红点提示的标志
-- zhangqi, 2015-11-16, m_tbShow 和 m_tbItemNum 加入饰品碎片的红点提示标志
local m_tbShow = nil -- {item = false, treas = false, teasFrag = false, equip = false, fragment = false, partner = false, shadow = false , excl = false , exclFrag = false, awake = false}
local m_tbItemNum = nil -- {item = 0, treas = 0, teasFrag = 0, equip = 0, fragment = 0, partner = 0, shadow = 0 , excl = 0 , exclFrag = 0, awake = 0}

function resetTbShow( ... )
	m_tbShow = {item = false, treas = false, teasFrag = false, equip = false, fragment = false, partner = false, shadow = false , excl = false , exclFrag = false, awake = false}
	m_tbItemNum = {item = 0, treas = 0, teasFrag = 0, equip = 0, fragment = 0, partner = 0, shadow = 0 , excl = 0 , exclFrag = 0, awake = 0}
end
resetTbShow() -- zhangqi, 2015-11-16, 先初始化各种背包红点标志的默认值

----------------------- 通知到界面的方法 --------------------
local _bagDataChangedDelegate = nil
function setBagDataChangedDelete( delegateFunc )
	_bagDataChangedDelegate = delegateFunc
end
-- zhangqi, 2014-07-23, 删除回调引用，避免造成错误的UI刷新找不到UI控件
function removeBagDataChangedDelete( ... )
	_bagDataChangedDelegate = nil
end

----------------------- 组队战的开始的委托函数 --------------------
local _copyteamBattleDelegate = nil
function registerTeamBattleDelegate( delegateFunc)
	_copyteamBattleDelegate= delegateFunc
end


----------------------- 背包推送接口 -----------------------------
-- zhangqi, 2014-08-09, 更新道具背包红点状态,
-- LvNanchun, 2015-10-9, 宝物（专属宝物）的变动有装备推送和碎片推送两部分，在宝物（专属宝物）部分若不是宝物（专属宝物）增加，则
-- 将g_redPoint对应的标志变为false，然后在碎片的部分计算拥有的碎片数量，若拥有足够的数量则将标志位置为true。
-- 饰品（宝物）部分与上两者不同，只有一个标志位，没有碎片标志位，因此需要在有推送却不是其他几种变化的情况下判断是不是
-- 饰品碎片发生了变化。装备部分并未使用后端推送的消息来改变红点，因此其实装备部分暂时没有使用这里的代码。
local function showBagPoint( tbShow )
--	logger:debug({m_tbShow = m_tbShow})
--	logger:debug({g_redPoint = g_redPoint})
	if (m_tbShow.item) then
		if (LayerManager.curModuleName() ~= "MainBagCtrl") then
			g_redPoint.bag.num = g_redPoint.bag.num + m_tbItemNum.item
			g_redPoint.bag.visible = true
			g_redPoint.bag.lastVisible = true
			require "script/module/main/MainScene"
			MainScene.updateBagPoint()
		else
			g_redPoint.bag.visible = false
			g_redPoint.bag.num = 0
		end
	-- 2015-09-30, 新增宝物（饰品）时，没有特殊的效果或显示红点，不作处理。
--	elseif (m_tbShow.treas) then -- 2015-09-29, 增加饰品背包红点的处理，需要时再完善
--		g_redPoint.treasure.num = g_redPoint.treasure.num + m_tbItemNum.treas
--		g_redPoint.treasure.visible = true
--		require "script/module/main/MainScene"
--		MainScene.updateBagPoint()
	elseif (m_tbShow.partner) then
		g_redPoint.partner.num = g_redPoint.partner.num + m_tbItemNum.partner
		loger:debug("====================partner red point")
		logger:debug(m_tbShow)
		logger:debug(m_tbItemNum)
		g_redPoint.partner.visible = true
		--g_redPoint.partner.setvisible(1)
		require "script/module/main/MainShip"
		MainShip.updateBagPoint("BTN_HERO")
	elseif (m_tbShow.equip) then
		if (LayerManager.curModuleName() ~= "MainEquipmentCtrl") then
			logger:debug("m_tbShow.equip true, moduleName = %s", LayerManager.curModuleName())
			g_redPoint.equip.num = g_redPoint.equip.num + m_tbItemNum.equip
			g_redPoint.equip.visible = true
			require "script/module/main/MainShip"
			MainShip.updateBagPoint("BTN_EQUIP")
			require "script/module/main/MainScene"
			MainScene.updateBagPoint()
		else
			logger:debug("m_tbShow.equip false")
			g_redPoint.equip.visible = false
		end
	elseif (m_tbShow.shadow) then
		require "script/module/partner/HeroSortUtil"
		local fuseNum = HeroSortUtil.getFuseSoulNum()
		if ( fuseNum > 0) then
			g_redPoint.partner.num = fuseNum
			g_redPoint.partner.visible = true
			--g_redPoint.partner.setvisible(1)
			require "script/module/main/MainShip"
			MainShip.updateBagPoint("BTN_HERO")
		end
	elseif (m_tbShow.fragment) then
		require "script/model/utils/EquipFragmentHelper"
		local fuseNum = EquipFragmentHelper.getCanFuseNum()
		if (fuseNum > 0) then
			logger:debug("m_tbShow.fragment")
			-- 装备碎片上的红点在各处单独判断，并不由这里确定 2015-11-30 lvnanchun
--			g_redPoint.equip.num = fuseNum
--			g_redPoint.equip.visible = true
			require "script/module/main/MainShip"
			MainShip.updateBagPoint("BTN_EQUIP")
			require "script/module/main/MainScene"
			MainScene.updateBagPoint()
		end
	elseif (m_tbShow.exclFrag) then
		require "script/module/specialBag/SBListModel"
		local fuseNum = SBListModel.getFragCompoundNum()
		if (fuseNum > 0) then
			g_redPoint.special.num = fuseNum
			g_redPoint.special.visible = true
			require "script/module/main/MainScene"
			MainScene.updateBagPoint()
		end
	elseif (m_tbShow.excl) then
		require "script/module/specialBag/SBListModel"
		local fuseNum = SBListModel.getFragCompoundNum()
		if not (fuseNum > 0) then
			g_redPoint.special.visible = false
			require "script/module/main/MainScene"
			MainScene.updateBagPoint()
		end
	elseif (m_tbShow.awake) then						-- 觉醒背包推送红点，规则和物品一致，有新物品显示
		-- 觉醒背包没有红点
--		if (LayerManager.curModuleName() ~= "AwakeBagCtrl") then
--			g_redPoint.awake.num = g_redPoint.awake.num + m_tbItemNum.awake
--			g_redPoint.awake.visible = true
--			g_redPoint.awake.lastVisible = true
--			require "script/module/main/MainScene"
--			MainScene.updateBagPoint()
--		else
--			g_redPoint.awake.visible = false
--			g_redPoint.awake.num = 0
--		end
	else
		-- 没有命中以上条件，可能是宝物（饰品）碎片，计算一下试试。
		require "script/module/grabTreasure/TreasureData"
		local treaFragNum = TreasureData.getCanFuseNum()
		logger:debug("prerequestTreaFrag:" .. tostring(treaFragNum))
		if (treaFragNum > 0) then
			g_redPoint.treasure.num = treaFragNum
			g_redPoint.treasure.visible = true
		else
			g_redPoint.treasure.num = treaFragNum
			g_redPoint.treasure.visible = false
		end
		-- 若没有命中以上条件，说明是宝物（饰品）碎片或者是物品减少或者没有变动。此时需要刷新一下右下角背包大按钮。
		require "script/module/main/MainScene"
		MainScene.updateBagPoint()
	end

	resetTbShow()
end

-- zhangqi, 2014-08-09, 计算新老背包物品增加的数量，大于0返回true和数量, 否则返回false
local function dropItemCount(newItemInfo, oldItemInfo)
	logger:debug("dropItemCount")
	local add_num = 0
	if(oldItemInfo and (not table.isEmpty(oldItemInfo)) ) then
		logger:debug("newItemInfo.item_num = %d, oldItemInfo.item_num = %d", tonumber(newItemInfo.item_num), tonumber(oldItemInfo.item_num))
		add_num = tonumber(newItemInfo.item_num) - tonumber(oldItemInfo.item_num)
		logger:debug("add_num = %d", add_num)
	else
		add_num = tonumber(newItemInfo.item_num)
		logger:debug("add_num = %d", add_num)
	end
	if(add_num > 0)then
		return true, add_num
	end
	return false, 0
end

-- zhangqi, 2015-11-19，用于生成统一处理背包推送回调中各种背包信息的方法
function getBagProcFunctionByType( bagHandlerType )
	local equipType = {arm = 1, treas = 2, conch = 3} -- 阵容对应装备的类型
	local hType = bagHandlerType

	return function ( r_gid, r_itemInfo, tmplBagInfo )
		local bagHandler = BagModel.getBagHandler(hType)
		local bagInfo = tmplBagInfo[hType]
		local fmtType = equipType[hType]
		-- logger:debug({hType = hType, r_gid = r_gid, r_itemInfo = r_itemInfo, bagInfo = bagInfo})

		-- logger:debug({r_gid_item = bagInfo[r_gid], str = bagInfo[tonumber(r_gid)]})
		if (bagInfo[r_gid]) then
			if (table.isEmpty(r_itemInfo) ) then -- 删除
				if (fmtType) then
					ItemUtil.solveBagLackInfo(bagInfo[r_gid], fmtType)
				end

				bagHandler:removeItemByGid(r_gid)
				bagInfo[r_gid] = nil
			else
				m_tbShow[hType], m_tbItemNum[hType] = dropItemCount(r_itemInfo, bagInfo[r_gid])

				if (fmtType) then
					ItemUtil.solveBagLackInfo(bagInfo[r_gid], fmtType)
				end

				bagInfo[r_gid] = r_itemInfo
				bagHandler:replaceItemByGid(r_gid, r_itemInfo) -- 替换
			end

			GlobalNotify.postNotify(BAG_CHANGE[hType])
		elseif (not table.isEmpty(r_itemInfo)) then
			m_tbShow[hType], m_tbItemNum[hType] = dropItemCount(r_itemInfo) -- zhangqi, 2014-08-09

			bagInfo[r_gid] = r_itemInfo
			bagHandler:addItemByGid(r_gid, r_itemInfo) -- 增加

			GlobalNotify.postNotify(BAG_CHANGE[hType])
		end

		if (fmtType) then
			ItemUtil.pushitemCallback(r_itemInfo, fmtType) -- 调用阵容需要的回调处理方法
		end
	end
end

function re_bag_baginfo_callback( cbFlag, dictData, bRet )
	logger:debug({re_bag_baginfo_callback_dictData = dictData})

	require "script/module/public/ItemUtil"
	local mItemUtil = ItemUtil

	local newItemOrder = 0 -- zhangqi, 2014-12-22, 记录一次推送里新增物品道具的顺序，作为展示的排序条件
	if(dictData.err == "ok") then
		if(table.isEmpty(dictData.ret) == false) then
			local tmplBagInfo = DataCache.getRemoteBagInfo()
			local re_bagInfo = {}
			for k,v in pairs(dictData.ret) do
				re_bagInfo = v
			end

			logger:debug({re_bag_baginfo_callback_re_bagInfo = re_bagInfo})

			local tb_treasModife = {}
			tb_treasModife.deleteData = {}
			tb_treasModife.insertData = {}
			tb_treasModife.replaceData = {}

			for gid, r_itemInfo in pairs(re_bagInfo) do
				logger:debug({gid = gid, r_itemInfo = r_itemInfo})

				-- 临时背包的数据
				local isTmplArm 		= false
				local isTmplConch		= false -- zhangqi, 2015-02-25, 添加空岛贝类型
				local isTmplProps 		= false
				local isTmplHeroFrag 	= false
				local isTmplTreas 		= false
				--local isTmplTreasFrag	= false -- zhangqi, 2015-11-16, 添加饰品碎片类型
				local isTmplArmFrag 	= false
				local isTmplDress 		= false
				local isTmplExcl 		= false
				local isTmplExclFrag 		= false
				local isTmplAwake		= false
				if ( tonumber(gid) <=  (tonumber(tmplBagInfo.gridStart.tmp) + tonumber(tmplBagInfo.gridMaxNum.tmp)) ) then					
					tmplBagInfo.arm[gid] 		= nil
					tmplBagInfo.conch[gid]		= nil
					tmplBagInfo.props[gid]  	= nil
					tmplBagInfo.heroFrag[gid] 	= nil
					tmplBagInfo.treas[gid]		= nil
					-- tmplBagInfo.treasFrag[gid]	= nil -- 2015-11-16
					tmplBagInfo.armFrag[gid]	= nil
					tmplBagInfo.excl[gid]	= nil
					tmplBagInfo.exclFrag[gid]	= nil
					tmplBagInfo.awake[gid] 		= nil
					
					--zhangjunwu 2015-5-12 装备附魔时如果背包内装备超出上限，则会出现附魔完成后多余出虚假装备的情况
					require "script/module/equipment/MainEquipmentCtrl"
					MainEquipmentCtrl.removeEquipDataByGid(gid)

					if(not table.isEmpty(r_itemInfo))then
						local tid = tonumber( r_itemInfo.item_template_id )
						if (tid >= 400001 and tid <= 500000) then -- 武将碎片
							isTmplHeroFrag = true
						elseif(tid >= 100001 and tid <= 200000)then -- 装备
							isTmplArm = true
						elseif(tid >= 500001 and tid <= 600000)then -- 饰品
							isTmplTreas = true
						elseif(tid >= 1000001 and tid <= 5000000)then -- 装备碎片
							isTmplArmFrag = true
						--elseif(tid >= 5000000 and tid <= 6000000)then -- 饰品碎片，2015-11-16
							--isTmplTreasFrag = true
						elseif(tid >= 80001 and tid <= 90000)then -- 时装
							isTmplDress = true
						elseif(tid >= 70001 and tid <= 80000)then -- 空岛贝
							isTmplConch = true
						elseif( tid >= 700001 and tid <= 800000 )then -- 专属宝物
							isTmplExcl = true
						elseif (tid >= 800001 and tid <= 900000) then -- 觉醒物品
							isTmplAwake = true
						elseif( tid >= 7000001 and tid <= 8000000 )then -- 专属宝物碎片
							isTmplExclFrag = true
						else -- 道具
							isTmplProps = true
						end
					end

				end

				-- 装备
				if (isTmplArm or ( tonumber(gid) >= tonumber(tmplBagInfo.gridStart.arm) and tonumber(gid) < (tonumber(tmplBagInfo.gridStart.arm) + tonumber(tmplBagInfo.gridMaxNum.arm)) )) then
					local isNotFound = true
					require "script/module/equipment/MainEquipmentCtrl"
					for t_gid, t_data in pairs(tmplBagInfo.arm) do
						if(tonumber(t_gid) == tonumber(gid)) then
							isNotFound = false
							if(table.isEmpty(r_itemInfo) )then

								--需要在这里处理，能拿到很多的物品信息 add by zhaoqiangjun
								local deltrea = tmplBagInfo.arm[t_gid]

								mItemUtil.solveBagLackInfo(deltrea, 1)
								-------------------------------
								tmplBagInfo.arm[t_gid] = nil

								logger:debug("删除一个装备")
								--add by zhangjunwu ,装备背包数据更新 2014-11-8
								MainEquipmentCtrl.removeEquipDataByGid(t_gid)

							else
								-- m_tbShow.equip, m_tbItemNum.equip = dropItemCount(r_itemInfo, tmplBagInfo.arm[t_gid]) -- zhangqi, 2014-08-26, 获得装备不需要红点
								mItemUtil.solveBagLackInfo(tmplBagInfo.arm[t_gid], 1)
								tmplBagInfo.arm[t_gid] = r_itemInfo

								logger:debug("替换一个装备")
								--add by zhangjunwu ,装备背包数据更新 2014-11-8
								MainEquipmentCtrl.replaceEquipDataByGid(t_gid,r_itemInfo)
							end
							break
						end
					end
					if (isNotFound and table.isEmpty(r_itemInfo) == false) then
						-- m_tbShow.equip, m_tbItemNum.equip = dropItemCount(r_itemInfo) -- zhangqi, 2014-08-26, 获得装备不需要红点
						tmplBagInfo.arm[gid] = r_itemInfo

						--add by zhangjunwu ,装备背包数据更新 2014-11-8
						logger:debug("插入一个装备")
						MainEquipmentCtrl.insertEquipDataByGid(gid,r_itemInfo)
					end
					logger:debug("装备红点推送")
					mItemUtil.pushitemCallback(r_itemInfo, 1)-- zhaoqiangjun,装备变更时就通知阵容界面
					-- 空岛贝
				elseif (isTmplConch or ( tonumber(gid) >= tonumber(tmplBagInfo.gridStart.conch) and tonumber(gid) < (tonumber(tmplBagInfo.gridStart.conch) + tonumber(tmplBagInfo.gridMaxNum.conch)) )) then
					local isNotFound = true

					require "script/module/conch/ConchBag/MainConchCtrl"
					for t_gid, t_data in pairs(tmplBagInfo.conch) do
						if(tonumber(t_gid) == tonumber(gid)) then
							isNotFound = false

							if(table.isEmpty(r_itemInfo) )then

								--需要在这里处理，能拿到很多的物品信息 add by zhaoqiangjun
								local deltrea = tmplBagInfo.conch[t_gid]

								mItemUtil.solveBagLackInfo(deltrea, 3)
								-------------------------------
								tmplBagInfo.conch[t_gid] = nil

								logger:debug("删除一个空岛贝")
								--add by zhangjunwu ,装备背包数据更新 2014-11-8
								MainConchCtrl.removeConchDataByGid(t_gid)

							else
								-- m_tbShow.equip, m_tbItemNum.equip = dropItemCount(r_itemInfo, tmplBagInfo.arm[t_gid]) -- zhangqi, 2014-08-26, 获得装备不需要红点
								mItemUtil.solveBagLackInfo(tmplBagInfo.conch[t_gid], 3)
								tmplBagInfo.conch[t_gid] = r_itemInfo

								logger:debug("替换一个空岛贝")
								--add by zhangjunwu ,装备背包数据更新 2014-11-8
								MainConchCtrl.replaceConchDataByGid(t_gid,r_itemInfo)
							end
							break
						end
					end
					if (isNotFound and table.isEmpty(r_itemInfo) == false) then
						tmplBagInfo.conch[gid] = r_itemInfo

						-- 空岛贝背包数据更新
						logger:debug("插入一个空岛贝")
						MainConchCtrl.insertConchDataByGid(gid,r_itemInfo)
					end
					logger:debug("空岛贝红点推送")
					mItemUtil.pushitemCallback(r_itemInfo, 3)-- zhaoqiangjun,装备变更时就通知阵容界面
					-- 道具
				elseif (isTmplProps or ( tonumber(gid) >= tonumber(tmplBagInfo.gridStart.props) and tonumber(gid) < (tonumber(tmplBagInfo.gridStart.props) + tonumber(tmplBagInfo.gridMaxNum.props)) )) then
					local isNotFound = true
					for t_gid, t_data in pairs(tmplBagInfo.props) do
						if(tonumber(t_gid) == tonumber(gid)) then
							isNotFound = false
							if(table.isEmpty(r_itemInfo))then
								tmplBagInfo.props[t_gid] = nil
							else -- 如果是可使用的物品
								local m_template_id = tonumber(r_itemInfo.item_template_id)
								-- if( MainScene.getOnRunningLayerSign() ~= "bagLayer" and (m_template_id >= 10001 and m_template_id <50000)  )then
								-- zhangqi, 2014-08-09, 如果当前模块不是道具背包
								if (LayerManager.curModuleName() ~= "MainBagCtrl" and (m_template_id >= 10001 and m_template_id < 50000)) then
									m_tbShow.item, m_tbItemNum.item = dropItemCount(r_itemInfo, tmplBagInfo.props[t_gid]) -- zhangqi, 2014-08-09, 需要显示道具背包红点
									if (m_tbShow.item) then
										newItemOrder = newItemOrder + 1
										r_itemInfo.newOrder = newItemOrder -- zhangqi, 2014-12-22, 记录是否新道具的标志
									end
								end
								-- if (m_tbShow.item) then
								-- 	r_itemInfo.newOrder = newItemOrder -- zhangqi, 2014-12-22, 记录是否新道具的标志
								-- end
								tmplBagInfo.props[t_gid] = r_itemInfo
								logger:debug("re_bag-newPointItem: %s", tmplBagInfo.props[t_gid])
							end
							break
						end
					end
					if (isNotFound and table.isEmpty(r_itemInfo) == false) then
						local m_template_id = tonumber(r_itemInfo.item_template_id)
						-- if( MainScene.getOnRunningLayerSign() ~= "bagLayer" and (m_template_id >= 10001 and m_template_id <50000)  )then
						if (LayerManager.curModuleName() ~= "MainBagCtrl" and (m_template_id >= 10001 and m_template_id < 50000)) then
							m_tbShow.item, m_tbItemNum.item = dropItemCount(r_itemInfo)
							if (m_tbShow.item) then
								newItemOrder = newItemOrder + 1
								r_itemInfo.newOrder = newItemOrder -- zhangqi, 2014-12-22, 记录是否新道具的标志
							end
						end
						-- if (m_tbShow.item) then
						-- 	r_itemInfo.newOrder = newItemOrder -- zhangqi, 2014-12-22, 记录是否新道具的标志
						-- end
						tmplBagInfo.props[gid] = r_itemInfo
						logger:debug("re_bag-newPointItem: %s", tmplBagInfo.props[gid])
					end

					-- 武将碎片
				elseif ( isTmplHeroFrag or ( tonumber(gid) >= tonumber(tmplBagInfo.gridStart.heroFrag) and tonumber(gid) < (tonumber(tmplBagInfo.gridStart.heroFrag) + tonumber(tmplBagInfo.gridMaxNum.heroFrag)) )) then
					local isNotFound = true
					require "script/module/partner/MainPartner"
					for t_gid, t_data in pairs(tmplBagInfo.heroFrag) do
						if(tonumber(t_gid) == tonumber(gid)) then
							isNotFound = false
							if(table.isEmpty(r_itemInfo))then
								tmplBagInfo.heroFrag[t_gid] = nil
								logger:debug("删除一个武将碎片")
								--add by zhangjunwu ,伙伴背包碎片数据更新 2014-11-3
								MainPartner.removeHeroFragDataByGid(t_gid)
							else
								m_tbShow.shadow, m_tbItemNum.shadow = dropItemCount(r_itemInfo, tmplBagInfo.heroFrag[t_gid]) -- zhangqi, 2014-08-09
								tmplBagInfo.heroFrag[t_gid] = r_itemInfo
								logger:debug("替换一个武将碎片")
								--add by zhangjunwu ,伙伴背包碎片数据更新 2014-11-3
								if(HeroModel.getAllHeroes() ~= nil) then
									MainPartner.replacHeroFragDataByGid(t_gid,r_itemInfo)
								end
							end

							break
						end
					end
					if (isNotFound and table.isEmpty(r_itemInfo) == false) then
						m_tbShow.shadow, m_tbItemNum.shadow = dropItemCount(r_itemInfo) -- zhangqi, 2014-08-09
						tmplBagInfo.heroFrag[gid] = r_itemInfo

						--add by zhangjunwu ,伙伴背包碎片数据更新 2014-11-3
						logger:debug("插入一个武将碎片")
						MainPartner.insertHeroFragDataByGid(gid,r_itemInfo)
					end
				elseif (isTmplTreas or ( tonumber(gid) >= tonumber(tmplBagInfo.gridStart.treas) and tonumber(gid) < (tonumber(tmplBagInfo.gridStart.treas) + tonumber(tmplBagInfo.gridMaxNum.treas)) )) then
					-- 饰品
					local fnProc = getBagProcFunctionByType(BAG_TYPE_STR.treas)
					fnProc(gid, r_itemInfo, tmplBagInfo)
				-- elseif (isTmplTreasFrag  or ( tonumber(gid) >= tonumber(tmplBagInfo.gridStart.treasFrag) and tonumber(gid) < (tonumber(tmplBagInfo.gridStart.treasFrag) + tonumber(tmplBagInfo.gridMaxNum.treasFrag)) )) then
				-- 	-- 饰品碎片，zhangqi, 2015-11-16, 饰品碎片改为物品后的背包处理
				-- 	logger:debug({isTmplTreasFrag_gid = gid, r_itemInfo = r_itemInfo, tmplBagInfo = tmplBagInfo})
				-- 	local fnProc = getBagProcFunctionByType(BAG_TYPE_STR.treas)
				-- 	fnProc(gid, r_itemInfo, tmplBagInfo)
				elseif (isTmplArmFrag or ( tonumber(gid) >= tonumber(tmplBagInfo.gridStart.armFrag) and tonumber(gid) < (tonumber(tmplBagInfo.gridStart.armFrag) + tonumber(tmplBagInfo.gridMaxNum.armFrag)) )) then
					-- 装备碎片
					require "script/module/equipment/MainEquipmentCtrl"
					local isNotFound = true
					for t_gid, t_data in pairs(tmplBagInfo.armFrag) do
						if(tonumber(t_gid) == tonumber(gid)) then
							isNotFound = false
							if(table.isEmpty(r_itemInfo) )then
								tmplBagInfo.armFrag[t_gid] = nil

								logger:debug("删除一个装备碎片")
								--add by zhangjunwu ,装备背包碎片数据更新 2014-11-10
								MainEquipmentCtrl.removeEquipFragDataByGid(t_gid)
							else
								m_tbShow.fragment, m_tbItemNum.fragment = dropItemCount(r_itemInfo, tmplBagInfo.armFrag[t_gid]) -- zhangqi, 2014-08-09
								tmplBagInfo.armFrag[t_gid] = r_itemInfo

								logger:debug("替换一个装备碎片")
								--add by zhangjunwu ,装备背包碎片数据更新 2014-11-10
								MainEquipmentCtrl.replaceEquipFragDataByGid(t_gid,r_itemInfo)
							end
							break
						end
					end
					if (isNotFound and table.isEmpty(r_itemInfo) == false) then
						m_tbShow.fragment, m_tbItemNum.fragment = dropItemCount(r_itemInfo) -- zhangqi, 2014-08-09
						tmplBagInfo.armFrag[gid] = r_itemInfo

						logger:debug("插入一个装备碎片")
						--add by zhangjunwu ,装备背包碎片数据更新 2014-11-10
						MainEquipmentCtrl.insertEquipFragDataByGid(gid,r_itemInfo)
					end
				elseif (isTmplExcl or ( tonumber(gid) >= tonumber(tmplBagInfo.gridStart.excl) and tonumber(gid) < (tonumber(tmplBagInfo.gridStart.excl) + tonumber(tmplBagInfo.gridMaxNum.excl)) )) then
					-- 专属宝物
					local isNotFound = true
					for t_gid, t_data in pairs(tmplBagInfo.excl) do
						if(tonumber(t_gid) == tonumber(gid)) then
							isNotFound = false
							if(table.isEmpty(r_itemInfo) )then
								tmplBagInfo.excl[t_gid] = nil
							else
								m_tbShow.excl, m_tbItemNum.excl = dropItemCount(r_itemInfo, tmplBagInfo.excl[t_gid])
								tmplBagInfo.excl[t_gid] = r_itemInfo
							end
							break
						end
					end
					if (isNotFound and table.isEmpty(r_itemInfo) == false) then
						m_tbShow.excl, m_tbItemNum.excl = dropItemCount(r_itemInfo) -- zhangqi, 2014-08-09
						tmplBagInfo.excl[gid] = r_itemInfo
					end
				elseif (isTmplExclFrag or ( tonumber(gid) >= tonumber(tmplBagInfo.gridStart.exclFrag) and tonumber(gid) < (tonumber(tmplBagInfo.gridStart.exclFrag) + tonumber(tmplBagInfo.gridMaxNum.exclFrag)) )) then
					-- 专属宝物
					local isNotFound = true
					for t_gid, t_data in pairs(tmplBagInfo.exclFrag) do
						if(tonumber(t_gid) == tonumber(gid)) then
							isNotFound = false
							if(table.isEmpty(r_itemInfo) )then
								tmplBagInfo.exclFrag[t_gid] = nil
							else
								m_tbShow.exclFrag, m_tbItemNum.exclFrag = dropItemCount(r_itemInfo, tmplBagInfo.exclFrag[t_gid])
								tmplBagInfo.exclFrag[t_gid] = r_itemInfo
							end
							break
						end
					end
					if (isNotFound and table.isEmpty(r_itemInfo) == false) then
						m_tbShow.exclFrag, m_tbItemNum.exclFrag = dropItemCount(r_itemInfo) -- zhangqi, 2014-08-09
						tmplBagInfo.exclFrag[gid] = r_itemInfo
					end
				elseif (isTmplAwake or ( tonumber(gid) >= tonumber(tmplBagInfo.gridStart.awake) and tonumber(gid) < (tonumber(tmplBagInfo.gridStart.awake) + tonumber(tmplBagInfo.gridMaxNum.awake)) )) then
					-- 觉醒物品 lvnanchun 2015-11-19
					--local isNotFound = true
					--for t_gid, t_data in pairs(tmplBagInfo.awake) do
					--	if(tonumber(t_gid) == tonumber(gid)) then
					--		isNotFound = false
					--		if(table.isEmpty(r_itemInfo) )then
					--			tmplBagInfo.awake[t_gid] = nil
					--		else
					--			m_tbShow.awake, m_tbItemNum.awake = dropItemCount(r_itemInfo, tmplBagInfo.awake[t_gid])
					--			tmplBagInfo.awake[t_gid] = r_itemInfo
					--		end
					--		break
					--	end
					--end
					--if (isNotFound and table.isEmpty(r_itemInfo) == false) then
					--	m_tbShow.awake, m_tbItemNum.awake = dropItemCount(r_itemInfo)
					--	tmplBagInfo.awake[gid] = r_itemInfo
					--end
					local fnProc = getBagProcFunctionByType(BAG_TYPE_STR.awake)
					fnProc(gid, r_itemInfo, tmplBagInfo)
				end
			end

			-- logger:debug({tmplBagInfo = tmplBagInfo})
			DataCache.setBagInfo(tmplBagInfo) -- 更新缓存

			--如果阵容开启了，判断是否提示装备的红点，zhangqi modified, 2014-12-30
			if (SwitchModel.getSwitchOpenState(ksSwitchFormation)) then
				mItemUtil.justiceBagInfo()
			end

			showBagPoint() -- zhangqi, 2014-08-09, 因为要重新获取碎片可合成的单个数量（依赖背包信息），必须放在更新背包信息之后

			if(_bagDataChangedDelegate ~= nil) then
				logger:debug("_bagDataChangedDelegate ~= nil")
				local curCallback = _bagDataChangedDelegate
				_bagDataChangedDelegate(dictData) -- -- zhangqi, 2014-08-09, 加上推送结果，便于回调函数取数据
				-- zhangqi, 2014-08-25, 判断如果回调执行后和执行前是同一个回调则释放掉，否则视为在回调方法里又注册了新的回调方法
				if (curCallback == _bagDataChangedDelegate) then
					_bagDataChangedDelegate = nil
				end
			end

			-- zhangqi, 2015-10-26, 用全局通知代替设置回调代理的方式
			GlobalNotify.postNotify(GlobalNotify.BAG_PUSH_CALL, dictData)
		end
	else
		logger:error("re_bag_baginfo_callback: %s", dictData.err)
	end
end
local function re_bag_baginfo_request( )
	Network.re_rpc(re_bag_baginfo_callback, "re.bag.bagInfo", "re.bag.bagInfo")
end

------------------------- 开启新副本的推送 ---------------------
local function push_newCopy_callback( cbFlag, dictData, bRet )
	if (bRet) then
		require "script/battle/BattleState"
		if(not table.isEmpty(dictData.ret) and (not BattleState.isPlaying()) )then
			local copyId = 0
			for k,v in pairs(dictData.ret) do
				if(tonumber(v.copy_id) > copyId) then
					copyId = tonumber(v.copy_id)
				end
			end
			ShowNewCopyLayer.showNewCopy(copyId)
		end
	end
end
--开启新副本的推送
local function push_copy_newCopy()
	Network.re_rpc(push_newCopy_callback, "push.copy.newcopy", "push.copy.newcopy")
end


------------------------- 名将的推送接口 ------------------------

-- local function re_star_addNewNotice_callback(cbFlag, dictData, bRet )
-- 	if (bRet) then
-- 		if( not table.isEmpty( dictData.ret ) ) then
-- 			for k,t_star in pairs(dictData.ret) do

-- 				StarUtil.saveNewStarId( tonumber(t_star.star_id))
-- 				DataCache.addStarToCache(t_star)
-- 			end
-- 		end
-- 	end
-- end

-- local function re_star_addNewNotice()
-- 	Network.re_rpc(re_star_addNewNotice_callback, "re.star.addNewNotice", "re.star.addNewNotice")
-- end

-------------------------- 邮件推送接口 -------------------------------
local function re_mail_addNewMail_callback(cbFlag, dictData, bRet )
	logger:debug({re_mail_addNewMail_callback = dictData})
	if (bRet) then
		require "script/module/main/MainShip"
		g_redPoint.newMail.visible = true
		MainShip.updateMailRedPoint()
		require "script/module/mine/MineMailData"
		MineMailData.updateMailRedPoint(dictData.ret)
	end
end
local function re_mail_addNewMail()
	Network.re_rpc(re_mail_addNewMail_callback, "re.mail.newMail", "re.mail.newMail")
end

-------------------------- 好友推送接口 -------------------------------
local function friendListFunc( cbFlag, dictData, bRet )
	doUnReCall("fnFRIEND") -- 2015-04-23

	if (bRet) then
		require "script/module/friends/MainFdsCtrl"
		MainFdsCtrl.updateFdsList(dictData.ret)
	end
end
--拉取好友数据
function getFriendsList( ... )
	RequestCenter.friend_getFriendInfoList(friendListFunc)

	setRecall("fnFRIEND", function ( ... )
		RequestCenter.friend_getFriendInfoList(friendListFunc)
	end)
end

local function re_friend_newFriend_callback(cbFlag, dictData, bRet )
	logger:debug({["好友推送"] = dictData})
	if (bRet) then
		-- 只通知有新好友，没有数据需要去拉
		getFriendsList()
	end
end
local function re_friend_newFriend()
	Network.re_rpc(re_friend_newFriend_callback, "re.friend.newFriend", "re.friend.newFriend")
end


-------------------------- 删除好友推送接口 -------------------------------
local function re_friend_delFriend_callback(cbFlag, dictData, bRet )
	if (bRet) then
		-- 被对方从对方好友列表删除
		require "script/module/friends/MainFdsCtrl"
		MainFdsCtrl.delupFdsList(dictData.ret)
	end
end
local function re_friend_delFriend()
	Network.re_rpc(re_friend_delFriend_callback, "push.friend.del", "push.friend.del")
end

-------------------------- 好友上线推送接口 -------------------------------
-- local function push_friend_login_callback(cbFlag, dictData, bRet )
-- 	if (bRet) then
-- 		require "script/module/friends/MainFdsCtrl"
-- 		MainFdsCtrl.upFdsOnline(dictData.ret)
-- 	end
-- end
-- local function push_friend_login()
-- 	Network.re_rpc(push_friend_login_callback, "push.friend.login", "push.friend.login")
-- end

-------------------------- 好友下线推送接口 -------------------------------
-- local function push_friend_logoff_callback(cbFlag, dictData, bRet )
-- 	if (bRet) then
-- 		require "script/module/friends/MainFdsCtrl"
-- 		MainFdsCtrl.upFdsOffline(dictData.ret)
-- 	end
-- end
-- local function push_friend_logoff()
-- 	Network.re_rpc(push_friend_logoff_callback, "push.friend.logoff", "push.friend.logoff")
-- end

-------------------------- 好友可领取耐力列表推送接口 -------------------------------
local function re_friend_receiveStamina_callback(cbFlag, dictData, bRet )
	if (bRet) then
		print("好友可领取耐力列表推送..")
		getReceiveStaminaInfo()
	end
end

local function re_friend_receiveStamina()
	Network.re_rpc(re_friend_receiveStamina_callback, "push.friend.newLove", "push.friend.newLove")
end


-------------------------- 好友申请推送接口 -------------------------------
function re_friend_fdsApply_callback( cbFlag, dictData, bRet )
	logger:debug("新的好友申请推送")
	if (bRet) then
		getFriendApplyList()
	end
end

function re_new_friend_apply()
	logger:debug("好友申请注册")
	Network.re_rpc(re_friend_fdsApply_callback, "re.friend.newApply", "re.friend.newApply")
end

function friendApplyListFunc( cbFlag, dictData, bRet )
	logger:debug({["获取申请好友返回数据"] = dictData})
	doUnReCall("fnFRIEND_APPLY")

	if (bRet) then
		require "script/module/friends/FriendsApplyCtrl"
		FriendsApplyCtrl.updateFdsApplyList(dictData.ret.list)
	end
end
-- 获取所有好友申请数据
function getFriendApplyList( ... )
	logger:debug("获取所有好友申请信息")

	local args = Network.argsHandlerOfTable({0, 20, "true"})
	RequestCenter.friend_getFriendApplyInfo(friendApplyListFunc,args)

	setRecall("fnFRIEND_APPLY", function ( ... ) -- 2015-04-23
		local args = Network.argsHandlerOfTable({0, 20, "true"})
		RequestCenter.friend_getFriendApplyInfo(friendApplyListFunc,args)
	end)
end


-------------------------- 比武推送接口 -------------------------------
local function re_match_dataRefresh_callback(cbFlag, dictData, bRet )
	if (bRet) then
		local ret = dictData.ret
		print("比武推送..")
		-- require "script/ui/match/MatchPlace"
		-- MatchPlace.upDateMacthDataAndui( ret )
	end
end

local function re_match_dataRefresh()
	Network.re_rpc(re_match_dataRefresh_callback, "push.compete.refresh", "push.compete.refresh")
end

-------------------------- 比武发奖推送接口 -------------------------------
local function re_match_reward_callback(cbFlag, dictData, bRet )
	if (bRet) then
		print("比武发奖推送..")
		-- local ret = dictData.ret
		-- require "script/ui/main/MainScene"
		-- if(MainScene.getOnRunningLayerSign() == "matchLayer")then
		-- 	print("in matchLayer ...")
		-- 	require "script/ui/match/MatchLayer"
		-- 	MatchLayer.updateUIforRewardState( ret[1] )
		-- end
	end
end

local function re_match_reward()
	Network.re_rpc(re_match_reward_callback, "push.compete.reward", "push.compete.reward")
end

-------------------------聊天的推送接口 开始------------------------


local function re_chat_getMsg_callback(cbFlag, dictData, bRet )
	if (bRet) then
		if( not table.isEmpty( dictData.ret ) ) then
			require "script/module/chat/ChatModel"
			ChatModel.addChat(dictData.ret)

			require "script/module/main/BulletinData"
			BulletinData.setMsgData(dictData.ret)
		end
	end
end


local function re_chat_getMsg()
	Network.re_rpc(re_chat_getMsg_callback, "re.chat.getMsg", "re.chat.getMsg")
end

-------------------------聊天的推送接口 结束------------------------

-------------------------------------- 活动卡包得推送接口 --------------------------
local function push_hero_rfrrank_callback(cbFlag, dictData, bRet)
	if (bRet) then
		if( not table.isEmpty( dictData.ret ) ) then
		-- require "script/ui/rechargeActive/ActiveCache"
		-- require "script/ui/rechargeActive/CardPackActiveLayer"
		-- ActiveCache.setRankInfo(dictData.ret)
		-- CardPackActiveLayer.refreshBottomUI()
		end
	end

end

local function push_hero_rfrrank( )
	Network.re_rpc(push_hero_rfrrank_callback, "push.heroshop.rfrrank", "push.heroshop.rfrrank")
end

--------------------------------------- 活动卡包得推送接口 end ---------------------------------
local function push_hero_endact_callback(cbFlag, dictData, bRet)
	if (bRet) then
	-- print("push_hero_endact_callback")
	-- require "script/ui/rechargeActive/ActiveCache"
	-- require "script/ui/rechargeActive/CardPackActiveLayer"
	-- CardPackActiveLayer.endactAction()
	end

end


local function push_hero_endact( )
	Network.re_rpc(push_hero_endact_callback, "push.heroshop.endact", "push.heroshop.endact")
end

-------------------------军团推送接口 ----------------------------
-- 个人信息发生变化  agreeApply，kickMember，setVicePresident，unsetVicePresident，transPresident  这几个地方会触发
function pushGuildRefreshMember( cbFlag, dictData, bRet )
	if (bRet)then
		require "script/module/guild/GuildDataModel"
		require "script/module/rank/RankModel"
		GuildDataModel.setMineGuildId(dictData.ret.guild_id)

		RankModel.setMyGuildRank(dictData.ret.rank or 0)
		RankModel.setMyGuildName(dictData.ret.guild_name or "")

		function fnCallBack(  )
			LayerManager.changeModule(Layout:create(), "temp", {}, true)
			require "script/module/guild/MainGuildCtrl"
			MainGuildCtrl.create()
		end

		require "script/module/guildCopy/GuildCopyMapView"
		logger:debug("GuildDataModel.isInGuildFunc() = %s", GuildDataModel.isInGuildFunc())

		require "script/module/rank/MainRankView"
		
		local isInRank = LayerManager.curModuleName()== MainRankView.moduleName()
		local isInGuildTab = RankModel.getCurTabIndex() == RankModel.T_GuildRank
		local isInGuildRank = isInRank and isInGuildTab
		if (LayerManager.curModuleName()==GuildCopyMapView.moduleName() or GuildDataModel.isInGuildFunc() or isInGuildRank) then
			require "script/battle/BattleState"
			if(BattleState.isPlaying() or DataCache.getInBattleStatus()) then --战斗中 和 自己添加的战斗中
				BattleState.addCallBack(fnCallBack)
			else
				fnCallBack()
			end
		end
	end
end

local function re_guild_refreshMember()
	Network.re_rpc(pushGuildRefreshMember, "push.guild.refreshMember", "push.guild.refreshMember")
end

------------------- 拉取资源矿信息，红点用 -------------------
function preGetMineInfo( ... )
	MainMineCtrl.getSelfPitsInfo()
	MainMineCtrl.getSelfReward(false)
end

function push_mine( ... )
	Network.re_rpc(MainMineCtrl.onPush_Pit, "push.mineral.update", "push.mineral.update")
	Network.re_rpc(MainMineCtrl.onPush_Broadcast, "push.mineral.rob", "push.mineral.rob")
	Network.re_rpc(MainMineCtrl.onPush_Reward, "push.mineral.reward", "push.mineral.reward")
end

------------------- 拉取深海监狱信息 -------------------
local function preGetImpelDownInfo( ... )
	local function getImpelDownInfoCallback( cbFlag, dictData, bRet )
		if (bRet) then
		 	require "script/module/impelDown/ImpelDownMainModel"
			ImpelDownMainModel.setImpelDownInfo(dictData.ret)
			if (ImpelDownMainModel.isSweeping()) then
				local function checkImpelDownRedPoint( ... )
					require "script/utils/TimeUtil"
					local nowServerTime = TimeUtil.getSvrTimeByOffset()
					if (ImpelDownMainModel.getWhenEndSweep() < nowServerTime) then
						ImpelDownMainModel.updateDataWhenStopSweepAuto()
						ImpelDownMainModel.updateDataWhenReceiveSweepEndPush()
						GlobalNotify.postNotify("IMPEL_DOWN_UPDATE_TIP")
						logger:debug("stop checkImpelDownRedPoint PreRequest begin")
						GlobalScheduler.removeCallback("checkImpelDownRedPoint")
						logger:debug("stop checkImpelDownRedPoint PreRequest end")
					end
				end
				logger:debug("start checkImpelDownRedPoint PreRequest begin")
				GlobalScheduler.addCallback("checkImpelDownRedPoint", checkImpelDownRedPoint)
				logger:debug("start checkImpelDownRedPoint PreRequest end")
			end

			if (ImpelDownMainModel.isHasFreeRefresh()) then
				GlobalNotify.postNotify("IMPEL_DOWN_UPDATE_TIP")
			end
		end
	end
	RequestCenter.impelDown_getTowerInfo(getImpelDownInfoCallback)
end

-- 深海监狱扫荡完毕推送			2015-11-03 弃用此方法，后端不再推送，改为前端自行计时判断是否显示红点
function re_PushImpelSweepOver()
	RequestCenter.impelDown_sweep_finish_push(function ( cbFlag, dictData, bRet )
		logger:debug("Push_Impel_down_Sweep_over")
		if (bRet) then
			logger:debug(dictData.ret)
			require "script/module/impelDown/MainImpelDownCtrl"
			if (LayerManager.curModuleName() ~= MainImpelDownCtrl.moduleName()) then
				require "script/module/impelDown/ImpelDownMainModel"
				ImpelDownMainModel.updateDataWhenReceiveSweepEndPush()
				GlobalNotify.postNotify("IMPEL_DOWN_UPDATE_TIP")
			end
		end
	end)
end
--推送挑战福利挑战次数
function re_pushChallengeWelNum()
	RequestCenter.challengeWelfare_pushNum(function ( cbFlag, dictData, bRet )
		logger:debug("challengeWelfare_pushNum")
		if (bRet) then
			require "script/module/wonderfulActivity/challengeWelfare/ChaWelModel" 
			logger:debug(dictData.ret)
			for t,v in pairs(dictData.ret) do
				ChaWelModel.setChallengeWelNum(t,v)
			end
		end
	end)
end
-------------------拉取联盟个人信息，用于联盟大厅，人鱼咖啡厅提示-----------------------
-- function guildMemberInfoCallback(cbFlag,dictData,bRet)
-- 	if (bRet)then
-- 		require "script/module/guild/GuildDataModel"
-- 		GuildDataModel.setMineSigleGuildInfo(dictData.ret)
-- 	end
-- end

local function preGuildMemberInfo()
	require "script/module/guild/MainGuildCtrl"
	MainGuildCtrl.getGuildAllInfo()
end
--拉取公会副本相关的公会相关信息
function guildCopyBaseInfoCallback(cbFlag,dictData,bRet)
	doUnReCall("fnGUILD_COPY_INFO") -- 2015-04-23
	if (bRet)then
		DataCache.setGuildCopyBaseData(dictData.ret)
	end
end
local function preGuildCopyBaseInfo()
	RequestCenter.getGuildCopyBaseInfo(guildCopyBaseInfoCallback)
	setRecall("fnGUILD_COPY_INFO", function ( ... )
		RequestCenter.getGuildCopyBaseInfo(guildCopyBaseInfoCallback)
	end)
end
--拉取公会副本相关的个人相关信息
function guildMemberBaseInfoCallback(cbFlag,dictData,bRet)
	doUnReCall("fnGUILD_MEMBER_INFO") -- 2015-04-23
	if (bRet)then
		DataCache.setGuildMemberBaseData(dictData.ret)
	end
end
local function preGuildMemberBaseInfo()
	RequestCenter.getGuildMemberBaseInfo(guildMemberBaseInfoCallback)
	setRecall("fnGUILD_MEMBER_INFO", function ( ... )
		RequestCenter.getGuildMemberBaseInfo(guildMemberBaseInfoCallback)
	end)
end
-------------------------刷新关公殿 ----------------------------
function pushGuildRefreshGuangong( cbFlag, dictData, bRet )
	if (dictData.err == "ok") then
		require "script/module/guild/cafeHouse/CafeHouseCtrl"
		CafeHouseView.refreshBaiNum(dictData.ret.reward_num)
	end
end

local function re_guild_refreshGuangong()
	Network.re_rpc(pushGuildRefreshGuangong, "push.refreshGuild", "push.refreshGuild")
end

------------------------刷新军团商店------------------------------------
local function pushGuildGoods( cbFlag, dictData, bRet )
-- if(dictData.err == "ok")then
-- 	require "script/ui/guild/GuildDataCache"
-- 	require "script/ui/guild/GuildShopLayer"
-- 	if(MainScene.getOnRunningLayerSign() == "guildShopLayer")then

-- 		GuildDataCache.addPushGoodsInfo(dictData.ret)
-- 		GuildShopLayer.refreshTableView()
-- 	end
-- end
end


local function re_guild_refreshShop()
	Network.re_rpc(pushGuildGoods, "push.refreshGoods", "push.refreshGoods")
end

------------------------军团组队推送的接口------------------------------------
local function pushDataChanged( cbFlag, dictData, bRet )
-- if(dictData.err == "ok")then
-- 	print("  copyData changed")
-- 	print_t(dictData.ret)
-- 	require "script/ui/teamGroup/TeamGroupData"
-- 	TeamGroupData.setTeamUpdate( dictData.ret )
-- end
end

local function re_team_changed()
	Network.re_rpc(pushDataChanged, "team.update", "team.update")
end

------------------------- 登陆即要请求的接口 ----------------------
---------------------- 拉背包的数据 --------------------
function preBagInfoCallback( cbFlag, dictData, bRet )
	if (dictData.err == "ok") then
		DataCache.setBagInfo(dictData.ret)
		--在背包中的数据拉取完毕后，需要维护一套包括装备和宝物的新表
		--add by zhaoqiangjun
		require "script/module/public/ItemUtil"
		ItemUtil.solveTheBag(dictData.ret)
	else
		print("error: preBagInfoCallback err")
	end
end
local function preBagInfoRequest( )
	RequestCenter.bag_bagInfo(PreRequest.preBagInfoCallback)
end

-------------------- 阵型的数据 ----------------------
function preFormationCallback( cbFlag, dictData, bRet )
	doUnReCall("fnFORMATION") -- 2015-04-23

	if (bRet) then
		formationInfo = {}
		if (dictData.ret) then
			for k,v in pairs(dictData.ret) do
				formationInfo["" .. (tonumber(k)-1)] = tonumber(v)
			end
			DataCache.setFormationInfo(formationInfo)
		end
	end
end

local function preFormationRequest( )
	RequestCenter.getFormationInfo(PreRequest.preFormationCallback)

	setRecall("fnFORMATION", function ( ... )
		RequestCenter.getFormationInfo(PreRequest.preFormationCallback)
	end)
end

---------------------- 拉酒馆数据 ----------------
-- 获取当前商店的信息
function shopInfoCallback( cbFlag, dictData, bRet )
	doUnReCall("fnSHOP") -- 2015-04-23

	if (bRet) then
		local _curShopCacheInfo = dictData.ret
		logger:debug(_curShopCacheInfo)
		DataCache.setShopCache(_curShopCacheInfo)
	end
end

local function preGetShopInfo( )
	RequestCenter.shop_getShopInfo(shopInfoCallback)

	setRecall("fnSHOP", function ( ... )
		RequestCenter.shop_getShopInfo(shopInfoCallback)
	end)
end

--------------------- 拉所有饰品碎片信息 --------------------
function preGetTreasureFragInfo( ... )
	local function requestFunc( cbFlag, dictData, bRet )
		doUnReCall("fnTREA_FRAG") -- 2015-04-23

		if (bRet) then
			require "script/module/grabTreasure/TreasureData"
			TreasureData.setTreasFrag(dictData.ret)
		end
	end

	RequestCenter.fragseize_getSeizerInfo(requestFunc)

	setRecall("fnTREA_FRAG", function ( ... ) -- 2015-04-23
		RequestCenter.fragseize_getSeizerInfo(requestFunc)
	end)
end

--------------------- 饰品碎片数量变化的推送 --------------------
function push_TreasureFragNum( ... )
	RequestCenter.re_frag_update(function ( cbFlag, dictData, bRet )
		logger:debug({re_frag_update_dicData = dictData})
		if (bRet) then
			for fid, sNum in pairs(dictData.ret) do
				TreasureData.setFrag(fid, tonumber(sNum))
			end
		end
	end)
end

--------------------- 拉副本 --------------------
-- 普通副本
function preGetNormalCopyCallback( cbFlag, dictData, bRet )
	doUnReCall("fnNCOPY") -- 2015-04-23

	if (bRet) then
		DataCache.setNormalCopyData( dictData.ret )
	end
end

local function preGetNormalCopy()
	RequestCenter.getLastNormalCopyList(preGetNormalCopyCallback)

	setRecall("fnNCOPY", function ( ... ) -- 2015-04-23
		RequestCenter.getLastNormalCopyList(preGetNormalCopyCallback)
	end)
end
-- 精英副本
function preGetEliteCopyCallback( cbFlag, dictData, bRet )
	doUnReCall("fnECOPY") -- 2015-04-23

	if (bRet) then
		DataCache.setEliteCopyData( dictData.ret )
	end
end
local function preGetEliteCopy()
	RequestCenter.getEliteCopyList(preGetEliteCopyCallback)

	setRecall("fnECOPY", function ( ... ) -- 2015-04-23
		RequestCenter.getEliteCopyList(preGetEliteCopyCallback)
	end)
end
-- 觉醒副本
function preGetAwakeCopyCallback( cbFlag, dictData, bRet )
	-- doUnReCall("fnAwakeCOPY") -- 2015-04-23
	if (bRet) then
		DataCache.setAwakeCopyData( dictData.ret )
	end
end
local function preGetAwakeCopy()
	RequestCenter.awakeCopy_getLastWorldInfo(preGetAwakeCopyCallback)

	-- setRecall("fnAwakeCOPY", function ( ... ) -- 2015-04-23
	-- 	RequestCenter.awakeCopy_getLastWorldInfo(preGetAwakeCopyCallback)
	-- end)
end
--------------------- 阵容数据 ---------------------
function preGetSquadCallback( cbFlag, dictData, bRet  )
	doUnReCall("fnSQUAD") -- 2015-04-23

	if (bRet) then
		if (dictData.ret) then
			local t_squad = {}
			if(dictData.ret) then
				for k,v in pairs(dictData.ret) do
					t_squad["" .. (tonumber(k)-1)] = tonumber(v)
				end
				DataCache.setSquad(t_squad)
			end
		end
	end
end
function preGetSquadRequest( )
	RequestCenter.getSquadInfo(preGetSquadCallback)

	setRecall("fnSQUAD", function ( ... ) -- 2015-04-23
		RequestCenter.getSquadInfo(preGetSquadCallback)
	end)
end

------------------- 小伙伴数据信息   --------------------
-------zhaoqiangjun 20140512 16：27

function preGetExtraCallback( cbFlag, dictData, bRet )
	doUnReCall("fnExtra") -- 2015-04-23

	if (bRet) then
		DataCache.setExtra(dictData.ret)
	end
end

local function preGetExtraRequest( ... )
	RequestCenter.formation_getExtraFriend(PreRequest.preGetExtraCallback)

	setRecall("fnExtra", function ( ... ) -- 2015-04-23
		RequestCenter.formation_getExtraFriend(PreRequest.preGetExtraCallback)
	end)
end
------------------- 替补数据信息   --------------------
-------wangming 20150114 15：22

function preGetBenchCallback( cbFlag, dictData, bRet )
	doUnReCall("fnBench") -- 2015-04-23

	if (bRet) then
		if (dictData.ret) then
			local t_bench = {}
			for k,v in pairs(dictData.ret) do
				t_bench["" .. (tonumber(k) - 1)] = tonumber(v)
			end
			DataCache.setBench(t_bench)
		end
	end
end

local function preGetBenchRequest( ... )
	RequestCenter.formation_getBench(PreRequest.preGetBenchCallback)

	setRecall("fnBench", function ( ... ) -- 2015-04-23
		RequestCenter.formation_getBench(PreRequest.preGetBenchCallback)
	end)
end

------------------- 英雄/武将掉落推送 -------------------
-- added by fang. 2013.07.31
local function onPushHeroAddHero(cbFlag, dictData, bRet)
	if (cbFlag == "push.hero.addhero" and bRet) then
		require "script/model/hero/HeroModel"
		logger:debug("add partner ===========")
		logger:debug(dictData.ret)


		local tbAddHeroData = {}
		local tbAddHtid = {}

		for k, v in pairs(dictData.ret) do
			HeroModel.addHeroWithHid(k, v)
			--zhangjunwu 2014-11-17  --更新伙伴背包的数据
			table.insert(tbAddHeroData ,k)
			--yucong 更新图鉴
			table.insert(tbAddHtid, v.htid)

			g_redPoint.partner.num = g_redPoint.partner.num + 1 -- zhangqi, 2014-08-09, 增加伙伴按钮红点提示的数值
			--如果是4星以上的伙伴设置new特效显示
			require "db/DB_Heroes"
			local hero=DB_Heroes.getDataById(v.htid)
			if hero.star_lv>=4 then
				g_redPoint.partner.setvisible(1)
			end
		end
		--刷新伙伴列表数据
		require "script/module/partner/MainPartner"
		MainPartner.updataHeroDataByHtid(tbAddHeroData)

		--更新图鉴
		DataCache.addHeroBook(tbAddHtid)

		-- zhangqi, 2014-08-09, 刷新主页伙伴按钮的红点显示
		if (LayerManager.curModuleName() ~= "MainPartner") then
			g_redPoint.partner.visible = true
			require "script/module/main/MainShip"
			MainShip.updateBagPoint("BTN_HERO")
		else
			g_redPoint.partner.visible = false
			g_redPoint.partner.setvisible(0)
		end
	end
end
-- 注册英雄系统服务端推送英雄的接口
local function regPushHeroAddHero()
	Network.re_rpc(onPushHeroAddHero, "push.hero.addhero", "push.hero.addhero")
end


----------------------奖励中心----------------------------
local function handlerOfOnGotRewardList(cbFlag, dictData, bRet)
	logger:debug({handlerOfOnGotRewardList = dictData})
	doUnReCall("fnREWARD_CENTER") -- 2015-04-23

	if (bRet) then
		if (dictData.ret and table.count(dictData.ret) > 0) then
			DataCache.setRewardCenterStatus(true)
			require "script/module/rewardCenter/RewardCenterModel"
			RewardCenterModel.setRewardList(dictData.ret)
		end
	end
end


local function getRewardList()
	local args = Network.argsHandlerOfTable({0, 0})
	RequestCenter.reward_getRewardList(handlerOfOnGotRewardList, args)

	setRecall("fnREWARD_CENTER", function ( ... ) -- 2015-04-23
		local args = Network.argsHandlerOfTable({0, 0})
		RequestCenter.reward_getRewardList(handlerOfOnGotRewardList, args)
	end)
end

-- added by fang. 2013.08.28
local function onPushNewReward(cbFlag, dictData, bRet)
	if (cbFlag == "re.reward.newReward") and bRet then
		require "script/model/DataCache"
		DataCache.setRewardCenterStatus(true)
		getRewardList()
		-- TODO 添加奖励中心图标
	end
end

-- 注册奖励中心服务端推送接口
local function regPushNewReward()
	Network.re_rpc(onPushNewReward, "re.reward.newReward", "re.reward.newReward")
end

---------- Achieve --------------------

-- 成就延时展示
local _isCanShowAchieveTip = true
local _tbAchieTipData = {}

function setIsCanShowAchieveTip( isCan)
	logger:debug("setIsCanShowAchieveTip %s",isCan)
	_isCanShowAchieveTip = isCan
	if( _isCanShowAchieveTip == true and not table.isEmpty(_tbAchieTipData) )then
		require "script/module/achieve/AchieveTip"
		AchieveTip.create(_tbAchieTipData)
		_tbAchieTipData = {}
	end
end

-- 推送成就达成
local function re_finishAchieve_callback(cbFlag, dictData, bRet )
	logger:debug(dictData.ret)
	require "script/module/achieve/AchieveModel"
	require "script/module/achieve/AchieveTip"
	for _,aid in ipairs(dictData.ret or {}) do
		AchieveModel.changeSortAchieveById(aid, 1)
	end
	-- 添加成就延时处理
	if _isCanShowAchieveTip == true then
		AchieveTip.create(dictData.ret)
	else
		for _,aid in ipairs(dictData.ret or {}) do
			table.insert(_tbAchieTipData, aid)
		end
	end
	logger:debug(_tbAchieTipData)
	GlobalNotify.postNotify(GlobalNotify.PUSHNEWACHIEVE)
end

local function re_finishAchieve()
	Network.re_rpc(re_finishAchieve_callback, "push.achieve_new_finish", "push.achieve_new_finish")
end


-- 拉去成就相关
local function getAchieveInfo()
	local function getAchieInfoCallBack(cbFlag, dictData, bRet)
		logger:debug({getAchieveInfo = dictData})
		doUnReCall("fnACHIEVE") -- 2015-04-23

		assert(bRet, "成就系统getinfo挂了")
		require "script/module/achieve/AchieveModel"
		AchieveModel.setAchieve(dictData.ret)

		require "script/module/wonderfulActivity/share/ShareModel"
		ShareModel.setAchieveInfo(dictData.ret)
	end

	RequestCenter.getAchieInfo(getAchieInfoCallBack)

	setRecall("fnACHIEVE", function ( ... ) -- 2015-04-23
		RequestCenter.getAchieInfo(getAchieInfoCallBack)
	end)
end

local function getTaskInfo( callfunc)
	if (not SwitchModel.getSwitchOpenState(ksSwitchEveryDayTask)) then
		return
	end
	local function getDailyTaskBack(cbFlag, dictData, bRet)
		logger:debug({getDailyTaskBack = dictData})
		doUnReCall("fnDAILY_TASK") -- 2015-04-23

		if (bRet) then
			require "script/module/dailyTask/MainDailyTaskData"
			MainDailyTaskData.setDailyTaskInfo(dictData.ret)
		end
	end

	RequestCenter.getActiveInfo(getDailyTaskBack)

	setRecall("fnDAILY_TASK", function ( ... ) -- 2015-04-23
		logger:debug("fnDAILY_TASK")
		RequestCenter.getActiveInfo(getDailyTaskBack)
	end)
end

-- 推送成就达成
local function re_finishTask_callback(cbFlag, dictData, bRet )
	require "script/module/dailyTask/MainDailyTaskData"
	logger:debug(dictData.ret)
	for _,aid in ipairs(dictData.ret or {}) do
		MainDailyTaskData.setOver(aid)
	end
end

local function re_finishTask()
	Network.re_rpc(re_finishTask_callback, "push.active.task.finish", "push.active.task.finish")
end

local function re_bossKilled_callback( cbFlag, dictData, bRet )
	require "script/module/WorldBoss/WorldBossModel"
	logger:debug(dictData.ret)
	for _,aid in ipairs(dictData.ret or {}) do
		WorldBossModel.setBossOver(aid)
	end
end

local function re_bossKilled( ... )
	RequestCenter.re_bossKilled(re_bossKilled_callback)
end

----------------- Achieve -----------------------------------------

-- added by fang. 2013.09.27
local function onPushUserInfo(cbFlag, dictData, bRet)
	if (cbFlag == "push.user.updateUser") and bRet then
		require "script/model/user/UserModel"
		UserModel.changeUserInfo(dictData.ret)
	end
end

-- 注册"用户信息"服务端推送接口
local function regPushUserInfo( )
	Network.re_rpc(onPushUserInfo, "push.user.updateUser", "push.user.updateUser")
end

-------------    获取探索信息接口  add by lizy 2014.09.17  ----------------------
local function getExploreInfoCallBack( cbFlag, dictData, bRet )
	logger:debug({getExploreInfoCallBack = dictData})
	doUnReCall("fnEXPLORE") -- 2015-04-23

	if (bRet) then
		DataCache.setExploreInfo( dictData.ret)
	end
end

local function getExploreInfo()
	RequestCenter.explorInfo(getExploreInfoCallBack)

	setRecall("fnEXPLORE", function ( ... ) -- 2015-04-23
		RequestCenter.explorInfo(getExploreInfoCallBack)
	end)
end

-------------    获取活动副本信息接口  add by lizy 2014.09.17  ----------------------
local function getActivityCopyInfoCallBack( cbFlag, dictData, bRet )
	logger:debug({getActivityCopyInfoCallBack = dictData})
	doUnReCall("fnACOPY") -- 2015-04-23

	if (bRet) then
		DataCache.setActiviyCopyInfo( dictData.ret)
	end
end

local function getActivityCopyInfo()
	RequestCenter.activityCopyInfo(getActivityCopyInfoCallBack)

	setRecall("fnACOPY", function ( ... ) -- 2015-04-23
		RequestCenter.activityCopyInfo(getActivityCopyInfoCallBack)
	end)
end

----------------  charge_Info ----------------------
local function setChargeInfo( cbFlag, dictData, bRet )
	logger:debug({setChargeGold = dictData.ret})
	if (bRet) then
		IAPData.setChargeInfo(dictData.ret)
	end
end

function preGetChargeInfo( )
	RequestCenter.user_getChargeInfo(setChargeInfo)
end

-- 充值相关推送
local function reUserChargeInfo(cbFlag, dictData, bRet)
	-- gold_num: int  玩家当前的金币数
	-- vip: int 玩家当前的vip等级
	-- charge_gold_sum:int 玩家当前充值金额总值
	-- charge_gold: int  玩家此次充值金额
	-- pay_back: int  充值返还（平台返还+配置返还）
	-- first_pay: boolen 是否首充
	-- charge_type: int 充值类型 1 金币充值 2 月卡充值
	-- charge_info:  充值档位信息 月卡充值没有此信息
	local tDict = dictData.ret

	local tUser = {gold_num = tDict.gold_num, vip = tDict.vip } -- 修改用户 金币 和vip 等级

	UserModel.changeUserInfo(tUser)
	IAPData.setChargeGoldNum(tDict.charge_gold_sum) -- 更新玩家已经充值的金币数
	if tonumber(tDict.charge_type) == 1  then
		IAPData.setIAPInfo(tDict.charge_info)
		local str = gi18nString(5710,tDict.charge_gold, tDict.pay_back)
		-- AppStore审核
		if (Platform.isAppleReview()) then
			str = gi18nString(7506,tDict.charge_gold)
		end
		LayerManager.addLayout(UIHelper.createCommonDlg(str, nil, nil, 1))
	elseif tonumber(tDict.charge_type) == 2 then
		local tDbVipCard = DB_Vip_card.getDataById(1)
		local rewards = RewardUtil.getItemsDataByStr(tDbVipCard.cardReward)
		logger:debug({rewards = rewards})
		VipCardModel.changeDueTime()
		local str = gi18nString(5711,tDict.charge_gold, rewards[1].num)
		-- AppStore审核
		if (Platform.isAppleReview()) then
			str = gi18nString(7506,tDict.charge_gold)
		end
		LayerManager.addLayout(UIHelper.createCommonDlg(str, nil, function ( ... )
			LayerManager.removeLayout()
			-- AppStore审核
			if (not Platform.isAppleReview()) then
				require "script/module/wonderfulActivity/MainWonderfulActCtrl"
				LayerManager.removeLayout()
				if LayerManager.curModuleName() ==  MainWonderfulActCtrl.moduleName() then
					MainWonderfulActCtrl.showVipCard()
					MainWonderfulActView.btnSelectFunc(MainWonderfulActView.tbBtn[WonderfulActModel.tbShowType.kVipCard])
				else
					local act = MainWonderfulActCtrl.create("vipcard")
					LayerManager.changeModule(act, MainWonderfulActCtrl.moduleName(), {1,3},true)
					local scene = CCDirector:sharedDirector():getRunningScene()
					performWithDelay(scene, function(...)
						MainWonderfulActView.updateLSVPos(WonderfulActModel.tbShowType.kVipCard)
					end, 0.1)
				end
			end
		end, 1))
	end

	-- 开服7日数据修改
	OpenServerModel.modifyPayStatusData(tDict.charge_gold)
	
	GlobalNotify.postNotify("RechargeBackGoldNum", tDict.charge_gold)
	GlobalNotify.postNotify("LuxurySignCountGoldNum", tDict.charge_gold)
	GlobalNotify.postNotify("PUSHCHARGEOK")
	GlobalNotify.postNotify("VIPGIFT_CHARGEOK")
	GlobalNotify.postNotify("RECHARGEBONUS")
	
end

-- 充值月卡相关推送  
local function rePushMonthCardUpdate(cbFlag, dictData, bRet)
	VipCardModel.setVipCardPersonalInfo(dictData.ret)
end

local function addRerpcCharge(  )
	Network.re_rpc(reUserChargeInfo, "push.user.chargegold", "push.user.chargegold") --充值相关推送
	Network.re_rpc(rePushMonthCardUpdate, "push.monthcard.update", "push.monthcard.update") -- 如果是充值的月卡
end

----------------------------------- sign added by zhz ------------------------
local function getNorSignInfo(cbFlag, dictData, bRet )
	doUnReCall("fnDAILY_SIGN") -- 2015-04-23

	if (bRet) then
		if( not table.isEmpty(dictData.ret)) then
			DataCache.setNorSignCurInfo(dictData.ret)
		end
	end
end

function preGetSignInfo( )
	RequestCenter.sign_getNormalInfo(getNorSignInfo)

	setRecall("fnDAILY_SIGN", function ( ... ) -- 2015-04-23
		RequestCenter.sign_getNormalInfo(getNorSignInfo)
	end)
end

----------------------------------- 开服活动（累计签到）  added by zhangjunwu 2014-11-25------------------------
require "script/module/accSignReward/AccSignModel"
function accSignInfoCallbck(cbFlag, dictData, bRet )
	doUnReCall("fnACC_SIGN") -- 2015-04-23

	if (bRet) then
		if (not table.isEmpty(dictData.ret)) then
			AccSignModel.setAccSignInfo(dictData.ret)
		end
	end

end

function preGetAccSignInfo()
	RequestCenter.sign_getAccInfo(accSignInfoCallbck)

	setRecall("fnACC_SIGN", function ( ... ) -- 2015-04-23
		RequestCenter.sign_getAccInfo(accSignInfoCallbck)
	end)
end

----------------------------------- 成长基金 added by LvNanchun and XuFei 2015-06-23------------------------
function preGetGrowthFundInfo(  )
	local function growInfoCallback( cbFlag, dictData, bRet )
		if bRet then
			require "script/module/wonderfulActivity/growthFund/GrowthFundModel"
			GrowthFundModel.setGrowthInfo(dictData.ret)
			require "script/module/wonderfulActivity/growthFund/EveryoneWelfareModel"
			EveryoneWelfareModel.setBackendInfo(dictData.ret)
		end
	end
	RequestCenter.growUp_getInfo(growInfoCallback)
end

------------------------------------月卡 added by LvNanchun 2015-07-07---------------------------------------
require "script/module/wonderfulActivity/vipcard/VipCardModel"
function preGetVipcardInfo(  )
	local function vipCardInfoCallback( cbFlag, dictData, bRet )
		if (bRet) then
			VipCardModel.setVipCardPersonalInfo(dictData.ret)
		end
	end

	RequestCenter.vipCard_getInfo(vipCardInfoCallback)
end

------------------------------------vip礼包 added by LvNanchun 2015-08-13---------------------------------------
require "script/module/wonderfulActivity/vipGift/VipGiftModel"
function preGetVipGiftInfo(  )
	local function vipGiftInfoCallBack( cbFlag, dictData, bRet )
		if (bRet) then
			VipGiftModel.setBtnState(dictData.ret)
		end
	end
	RequestCenter.vipBonus_getInfo(vipGiftInfoCallBack)
end

------------------------------------幸运转盘 added by LvNanchun 2015-08-18---------------------------------------
require "script/module/wonderfulActivity/roulette/RouletteModel"
function preGetRouletteInfo(  )
	local function rouletteInfoCallBack( cbFlag, dictData, bRet )
		if (bRet) then
			RouletteModel.setActivityInfo(dictData.ret)
		end
	end
	if RouletteModel.bActivityOpen() then
		if not (RouletteModel.bRouletteLevelNotReached()) then
			RequestCenter.roulette_getTurntableInfo(rouletteInfoCallBack)
		end
	end
end

------------------------------------限时宝箱 added by LvNanchun 2015-08-21----------------------------------------
require "script/module/wonderfulActivity/saleBox/SaleBoxModel"
function preGetSaleBoxInfo(  )
	local function saleBoxInfoCallBack( cbFlag, dictData, bRet )
		if (bRet) then
			SaleBoxModel.setSaleBoxInfo(dictData.ret)
		end
	end
	if (SaleBoxModel.bShowBtnIcon()) then
		RequestCenter.chest_getChestInfo(saleBoxInfoCallBack)
	end
end

------------------------------------每日奖励 yucong---------------------------------------
require "script/module/wonderfulActivity/share/ShareModel"
function preGetShareInfo(  )
	local function shareInfoCallback( cbFlag, dictData, bRet )
		if bRet then
			ShareModel.setStatus_handle(dictData.ret)
		end
	end

	RequestCenter.share_getShareInfo(shareInfoCallback)
end

------------------------------------开服七日 yucong---------------------------------------
require "script/module/newServerReward/OpenServerModel"
function preGetOpenServerInfo(  )
	local function openServerInfoCallback( cbFlag, dictData, bRet )
		if bRet then
			OpenServerModel.setStatusData(dictData.ret)
		end
	end
	
	RequestCenter.weekweal_getInfo(openServerInfoCallback, Network.argsHandlerOfTable({UserModel.getFightForceValue()}))
end

-- 开服7日推送
function re_pushOpenserver()
	RequestCenter.weekweal_new_finish(function ( cbFlag, dictData, bRet )
		logger:debug("fnMSG_Openserver_Finish")
		if (bRet) then
			logger:debug(dictData.ret)
			OpenServerModel.modifyStatusData(dictData.ret)
			GlobalNotify.postNotify(OpenServerModel.MSG.CB_MODITY_DATA)
		end
	end)
end

----------------------------------- online added by zhz ---------------
local function onlineDataCallback(cbFlag, dictData, bRet )
	doUnReCall("fnONLINE_REWARD") -- 2015-04-23

	if (bRet) then
		if (not table.isEmpty(dictData.ret)) then
			require "script/module/onlineReward/OnlineRewardCtrl"
			OnlineRewardCtrl.calFutureTime(dictData)
		end
	end
end

local function preGetOnlineInfo( )
	RequestCenter.online_getOnlineInfo(onlineDataCallback)

	setRecall("fnONLINE_REWARD", function ( ... ) -- 2015-04-23
		logger:debug("fnONLINE_REWARD")
		RequestCenter.online_getOnlineInfo(onlineDataCallback)
	end)
end

-------------------------------- 等级礼包 added by zhz ------------------
-- 获取等级礼包的网络信息
local function rewardInfoCallback(cbFlag, dictData, bRet )
	logger:debug({rewardInfoCallback = dictData.ret})
	doUnReCall("fnLEVEL_REWARD") -- 2015-04-23

	if (bRet) then
		require "script/module/levelReward/LevelRewardCtrl"
		LevelRewardCtrl.getAllRewardData(dictData.ret)
	end
end

local function preGetLevelReward( )
	RequestCenter.levelfund_getLevelfundInfo(rewardInfoCallback)

	setRecall("fnLEVEL_REWARD", function ( ... ) -- 2015-04-23
		RequestCenter.levelfund_getLevelfundInfo(rewardInfoCallback)
	end)
end

--------------------------------- 吃烧鸡 主界面精彩活动按钮上红点的处理 ---------------------

-- 获得获得上次领取的时间
local function getSupplyInfo(cbFlag, dictData, bRet )
	doUnReCall("fnSUPPLY") -- 2015-04-23

	if (bRet) then
		require "script/module/wonderfulActivity/supply/SupplyModel"
		SupplyModel.setSupplyTime(dictData.ret)
	end
end


local function preGetSupplyInfo( )
	RequestCenter.supply_getSupplyInfo(getSupplyInfo)

	setRecall("fnSUPPLY", function ( ... ) -- 2015-04-23
		RequestCenter.supply_getSupplyInfo(getSupplyInfo)
	end)
end

-- 获得神秘商店信息的网络回调函数
local function mysteryShopInfoCallBack( cbFlag, dictData, bRet )
	doUnReCall("fnMYSTERY_SHOP") -- 2015-04-23

	if (bRet) then
		require "script/module/wonderfulActivity/mysteryCastle/MysteryCastleData"
		MysteryCastleData.setShopInfo(dictData.ret)
	end
end

local function preGetMysTeryShop(  )
	RequestCenter.mysteryShop_getShopInfo(mysteryShopInfoCallBack)
end


local function preGetAwakeShop(  )
	RequestCenter.awakeCopy_getShopInfo(function ( cbFlag, dictData, bRet )
		if(dictData.err ~= "ok") then
			return 
		end
		AwakeShopModel.setShopInfo(dictData.ret)
	end)
end


local function getSpeShopInfo(  )
	RequestCenter.treasureShop_getShopInfo(function ( cbFlag, dictData, bRet )
		if(dictData.err ~= "ok") then
			return 
		end
		TreaShopData.setShopInfo(dictData.ret)
	end)
end

--------------------------修炼系统拉取数据add by yangna 2015.10.23--------------------
local function getTrainInfoCallBack( cbFlag, dictData, bRet )
	doUnReCall("fnGetTrainInfo")

	if (bRet) then 
		require "script/module/Train/MainTrainModel"
		MainTrainModel.setTrainData(dictData.ret)
	end 
end

local function preGetTrainInfo( ... )
	RequestCenter.train_getTrainInfo(getTrainInfoCallBack)

	setRecall("fnGetTrainInfo",function ( ... )
		RequestCenter.train_getTrainInfo(getTrainInfoCallBack)
	end)
end

---------------------------- 新主船系统拉取数据 added by LvNanchun 2015-10-22-----------------------------------
local function getShipInfoCallBack( cbFlag, dictData, bRet )
	doUnReCall("fnGetShipInfo")
	
	if (bRet) then
		require "script/module/ship/ShipData"
		ShipData.setShipInfo(dictData.ret)
	end
end

local function preGetShipInfo( ... )
	RequestCenter.mainship_getShipInfo(getShipInfoCallBack)

	setRecall("fnGetShipInfo",function ( ... )
		RequestCenter.mainship_getShipInfo(getShipInfoCallBack)
	end)
end

---------------------------- 新主船系统拉取船炮数据 added by SunYunPeng 2016-02-04-----------------------------------
-- 获取船炮信息
function perGetCannonAndBall( ... )
	local function getCannonAndBallCallFn( cbFlag, dictData, bRet )
		logger:debug("fnGetCannonAndBall")
		logger:debug(cbFlag)
		logger:debug(dictData)
		logger:debug(bRet)

		if (bRet) then
			CannonModel.setAllCannonAndBallInfo(dictData.ret)
			ShipBulletBagModel.setAllBullets(dictData.ret)
			CannonModel.setFightValue()
		end
	end
	RequestCenter.mainship_getGunBarInfo(getCannonAndBallCallFn)
end

------------------------- 活动配置 -----------------------------
--  现在后端的配置还没加入 目前配置为空 世玉格格说等功能完成后加入 （需要加入 消费累积），成长基金不需要
local function preGetActivityInfo(bPushMsg, p_callback)
	bPushMsg = bPushMsg or false
	local function preGetActivityInfoCallBack( cbFlag, dictData, bRet )
		doUnReCall("fnACTIVITY") -- 2015-04-23

		if (bRet) then
			require "script/model/utils/ActivityConfigUtil"
			ActivityConfigUtil.process(dictData.ret, bPushMsg)
		end

		if p_callback then
	        p_callback()
	    end

	end

	--加载活动配置数据
	require "script/model/utils/ActivityConfigUtil"
	require "script/model/utils/ActivityConfig"
	ActivityConfigUtil.loadPersitentActivityConfig()
	--得到配置版本号
	local version = tonumber(ActivityConfig.ConfigCache.version)
	local args = Network.argsHandlerOfTable({0})

	RequestCenter.activity_getConf(preGetActivityInfoCallBack, args)

	setRecall("fnACTIVITY", function ( ... ) -- 2015-04-23
		RequestCenter.activity_getConf(preGetActivityInfoCallBack, args)
	end)
end

function reg_ActivityConfig( ... )
	local requestCallback = function ( cbFlag, dictData, bRet )
		local serverVersion = tonumber(dictData.ret[1])

		local localVersion 	= tonumber(ActivityConfig.ConfigCache.version)
		logger:debug("serverVersion = %s", serverVersion)
		logger:debug("localVersion  = %s", localVersion)
		if (serverVersion > localVersion) then
			preGetActivityInfo()
		end
	end
	Network.re_rpc(requestCallback, "re.activity.newConf", "re.activity.newConf")
end

---------------------------- 消费累积活动数据 added by xufei 2015-6-30----------------
function preGetSpendAccumulateInfo()
	function getSpendAccInfoCallback( cbFlag, dictData, bRet )	
		if (bRet) then
			require "script/module/wonderfulActivity/spendAccumulate/SpendAccumulateModel"
			SpendAccumulateModel.setSpendAccInfo(dictData.ret)

			GlobalNotify.addObserver("SpendAccumulateGoldSpend", function ( value )
				return SpendAccumulateModel.setExpenseGolds( value )
			end, nil, "spendGold") --addedby xufei 2015-7-17,注册通知，更新消费金币数
		end
	end
	RequestCenter.spend_getInfo(getSpendAccInfoCallback)
end

local function getConsumeActiveInfoCallBack( cbFlag, dictData, bRet )
-- if(dictData.err == "ok") then
-- 	print("消费累积活动 。。。 ")
-- 	require "script/ui/rechargeActive/ActiveCache"
-- 	ActiveCache.setConsumeServiceInfo( dictData.ret )
-- end
end

local function getConsumeActiveInfo( )
-- 目前需要及时拉取  不用在这拉取数据
-- Network.rpc(getConsumeActiveInfoCallBack, "spend.getInfo", "spend.getInfo", nil, true)
end
---------------------------- 充值回馈活动数据  added by xufei 2015-6-30---------------
function preGetRechargeBackInfo()
	function getRechargeBackInfoCallback( cbFlag, dictData, bRet )	
		if (bRet) then
			require "script/module/wonderfulActivity/rechargeBack/RechargeBackModel"
			RechargeBackModel.setRechargeBackInfo(dictData.ret)

			GlobalNotify.addObserver("RechargeBackGoldNum", function ( value )
				return RechargeBackModel.setRechargeGolds( value )
			end, nil, "RechargeBackGoldNum") --addedby xufei 2015-8-7,注册通知，更新充值金币数
		end
	end
	RequestCenter.recharge_getInfo(getRechargeBackInfoCallback)
end
---------------------------- 豪华签到活动数据 added by xufei 2016-01-12-------------------
function preGetLuxurySignInfo()
	local function getLuxurySignInfoCallback( cbFlag, dictData, bRet )
		if (bRet) then
			LuxurySignModel.setLuxurySignInfo(dictData.ret)

			GlobalNotify.addObserver("LuxurySignCountGoldNum", function ( value )
				return LuxurySignModel.updateChargeData( value )
			end, nil, "LuxurySignCountGoldNum")
		end
	end
	-- getLuxurySignInfoCallback(1,{ret = {
	--               ["rewardInfo"] = { ["1"] = { ["rewardId"] = "4", ["ifHadBuy"] = "0" }  },
	--               ["hadRechargeGold"] = "0"
	--           }},1)
	if (LuxurySignModel.isLevelEnough()) then
		RequestCenter.luxury_sign_getInfo(getLuxurySignInfoCallback)
	end
end

---------------------------- 福利商店活动数据 added by xufei 2015-12-23-------------------
function preGetWelfareShopInfo()
	function getWelfareShopInfoCallback( cbFlag, dictData, bRet )
		if (bRet) then
			StaticWelfareShopCtrl.setWelfareShopInfo(dictData.ret)
		end
	end
	
	if (StaticWelfareShopCtrl.getIsActivityOn()) then -- 返回true说明有活动在进行中
		RequestCenter.welfareShop_getInfo(getWelfareShopInfoCallback)
	end
end
---------------------------- 动态福利商店活动数据 added by xufei 2015-12-31------------
function preGetDynamicWelShopInfo( ... )
	function getDynWelShopCallBack( cbFlag, dictData, bRet )
		if (bRet) then
			DynamicWelShopCtrl.setWelfareShopInfo(dictData.ret)
		end
	end
	if (DynamicWelShopCtrl.getIsActivityOn()) then -- 返回true说明有活动在进行中
		RequestCenter.dynamic_welfareshop_getInfo(getDynWelShopCallBack)
	end
end

-----------------------------活动数据拉取的回调  added by xufei 2015-7-13--------------
function preGetActivityCallback( ... )
	require "script/model/utils/ActivityConfigUtil"
	if ActivityConfigUtil.isActivityOpen( "spend" ) then
		logger:debug("get spend info  in PreRequest")
		preGetSpendAccumulateInfo()
	end
	if ActivityConfigUtil.isActivityOpen( "topupFund" ) then
		logger:debug("get rechargeBack info  in PreRequest")
		preGetRechargeBackInfo()
	end
	if ActivityConfigUtil.isActivityOpen( "chargeWeal" ) then
		logger:debug("get chargeWeal info  in PreRequest")
		preGetRechargeBonusInfo()
	end
	-- if ActivityConfigUtil.isActivityOpen( "wealLittle" ) then
	-- 	logger:debug("get wealLittle info  in PreRequest")
	-- 	preGetChallengeWel() --拉取挑战福利数据
	-- end
	require "script/module/wonderfulActivity/challengeWelfare/ChaWelModel"  
	if (ChaWelModel.getCurActitveDbInfo()) then
		logger:debug("get wealLittle info  in PreRequest")
		preGetChallengeWel() --拉取挑战福利数据
	end
	if ActivityConfigUtil.isActivityOpen( "actwelfareshop" ) then
		logger:debug("get actwelfareshop info  in PreRequest")
		preGetDynamicWelShopInfo()
	end

	preGetWAInfo() -- 巅峰对决数据

	preGetAccLoginInfo() -- 累计登录
end

----------------------------- 充值红利 added by xufei 2015-8-28
function preGetRechargeBonusInfo(  )
	local function getRechargeBonusDataCallback( cbFlag, dictData, bRet )
		if (bRet) then
			require "script/module/wonderfulActivity/rechargeBonus/RechargeBonusModel"
			RechargeBonusModel.setBackendInfo(dictData.ret)

			GlobalNotify.addObserver("RECHARGEBONUS", function ()
				return RechargeBonusModel.updateData()
			end, nil, "RECHARGEBONUS_UPDATE") --addedby xufei 2015-8-30,注册通知，更新充值的天数
		end
	end
	RequestCenter.rechargeBonus_getInfo(getRechargeBonusDataCallback)
end
------------------ 名将数据 -----------------------
-- local function preGetAllStarInfoCallback( cbFlag, dictData, bRet )
-- 	if (dictData.err == "ok") then
-- 		if( not table.isEmpty( dictData.ret.allStarInfo) ) then
-- 			DataCache.saveStarInfoToCache( dictData.ret.allStarInfo )
-- 		end
-- 	end
-- end

-- function preGetAllStarInfoRquest( )
-- 	RequestCenter.star_getAllStarInfo(preGetAllStarInfoCallback, nil)
-- end

----------------- 拉取boss开启时间的偏移量 -----------
local function preGetBossTimeOffsetCallback( cbFlag, dictData, bRet )
	logger:debug({boss_getBossOffset = dictData})
	doUnReCall("fnBOSS_TIMEOFFSET") -- 2015-04-23

	if (bRet) then
		local pOffset = tonumber(dictData.ret) or 0
		require "script/module/WorldBoss/WorldBossModel"
		WorldBossModel.setOffSetTime(pOffset)
		WorldBossModel.loadEnterBossInfo()
	end
end

function preGetBossTimeOffset()
	RequestCenter.boss_getBossOffset(preGetBossTimeOffsetCallback)

	setRecall("fnBOSS_TIMEOFFSET", function ( ... ) -- 2015-04-23
		RequestCenter.boss_getBossOffset(preGetBossTimeOffsetCallback)
	end)
end

---------------------------- 累计登录  added by yucong 2015-11-12---------------    
function preGetAccLoginInfo()                                                       
    function getAccLoginInfoCallback( cbFlag, dictData, bRet )                      
        if (bRet) then                                                              
            logger:debug("getAccLoginInfoCallback")                                 
            logger:debug(dictData.ret)                                              
            require "script/module/wonderfulActivity/AccumulateLogin/AccLoginModel" 
            AccLoginModel.setAccData(dictData.ret)                                  
        end                                                                         
    end  
    if (ActivityConfigUtil.isActivityOpen("accgift")) then                                                                           
    	logger:debug("get accgift info")
    	RequestCenter.accGift_getAccLoginInfo(getAccLoginInfoCallback)                  
    end
end

---------------- 功能开启------------------------
-- added by lichenyang. 2013.08.29
-- modified by huxiaozhou 2014-06-07
local function preGetSwitchRequest(callback)
	local function requestCallback( cbFlag, dictData, bRet  )
		if (bRet) then
			SwitchModel.saveSwitchCache(dictData.ret)
			callback()
		end
	end
	RequestCenter.user_getSwitchInfo(requestCallback)
end

--新功能开启回调
-- modified by huxiaozhou 2014-06-07
local function onPushNewSwitch(cbFlag, dictData, bRet)
	if (cbFlag == "push.switch.newSwitch") and bRet then
		require "script/model/DataCache"

		--新功能开启
		if(dictData.err == "ok") then
			local nNewSwitchId = tonumber(dictData.ret.newSwitchId)
			SwitchModel.addNewSwitchNode(nNewSwitchId)
			require "db/DB_Switch"

			local switchInfo = DB_Switch.getDataById(nNewSwitchId)
			if (tonumber(switchInfo.show) == 1) then
				require "script/module/switch/SwitchCtrl"
				SwitchCtrl.create(nNewSwitchId)
			end

			--功能节点开启时夺宝引导用
			if (nNewSwitchId == ksSwitchRobTreasure) then
				GuideModel.setGuideState(true)
				require "script/module/guide/GuideModel"
				GuideModel.setGuideClass(ksGuideRobTreasure)
			end

			--功能节点开启时宝物引导用
			if (nNewSwitchId == ksSwitchTreasure) then
				GuideModel.setGuideState(true)
				require "script/module/guide/GuideModel"
				GuideModel.setGuideClass(ksGuideTreasure)
			end

			-- 新功难开启 商店 然后去拉去商店信息
			if (nNewSwitchId == ksSwitchShop) then
				preGetShopInfo()
				GuideCtrl.setPersistenceGuide("shop","2")
			end

			if nNewSwitchId == ksSwitchExplore then
				getExploreInfo() -- 获取探索信息
			end
			--活动副本
			if nNewSwitchId == ksSwitchActivityCopy then
				getActivityCopyInfo()
			end

			-- 每日签到
			if nNewSwitchId == ksSwitchSignIn then
				preGetSignInfo()
			end
			-- 新功能开启 神秘商店 拉去神秘商店信息
			if (tonumber(dictData.ret.newSwitchId) == ksSwitchResolve) then
				preGetMysTeryShop()
			end
			if (tonumber(dictData.ret.newSwitchId) == ksSwitchEliteCopy) then
				preGetEliteCopy() -- 拉取精英副本
			end
			--觉醒副本
			if (tonumber(dictData.ret.newSwitchId) == ksSwitchAwake) then
				preGetAwakeCopy()
				preGetAwakeShop()
			end
			require "script/module/guide/GuideCtrl"
			if(nNewSwitchId == ksSwitchFormation) then -- 阵容开启
				preFormationRequest()
				preGetSquadRequest()
				preGetExtraRequest()
				preGetBenchRequest()
			elseif (nNewSwitchId == ksSwitchArena) then	-- 竞技场
				GuideCtrl.setPersistenceGuide("arena","2")
			elseif(nNewSwitchId == ksSwitchStar) then
				GuideCtrl.setPersistenceGuide("astrology","4")
			elseif(nNewSwitchId == ksSwitchLevelGift) then -- 等级礼包

			elseif(nNewSwitchId == ksSwitchGeneralTransform) then -- 伙伴进阶

			elseif (nNewSwitchId == ksSwitchDestiny) then-- 天命
				GuideCtrl.setPersistenceGuide("destiny","2")
			elseif(nNewSwitchId == ksSwitchGeneralForge) then-- 伙伴强化
				GuideCtrl.setPersistenceGuide("fmt","2")
			elseif(nNewSwitchId == ksSwitchResource) then -- 资源矿
				logger:debug("开启资源矿")
				preGetMineInfo()	-- 拉取资源矿信息，红点用
			elseif(nNewSwitchId == ksSwitchWorldBoss) then -- 世界boss
				logger:debug("开启世界boss")
				preGetBossTimeOffset() -- 拉取boss战的时间偏移
			elseif (nNewSwitchId == ksSwitchCannonAndBall) then -- 船炮
				logger:debug("newSwitch_cannon")
				perGetCannonAndBall() --  船炮信息获取
			end
		end
	end
end

-- 注册功能节点开启服务端推送接口
local function re_push_newSwitch()
	-- change by licheng 暂时取消 新节点开启提示
	Network.re_rpc(onPushNewSwitch, "push.switch.newSwitch", "push.switch.newSwitch")
end

------------------------------------  new hand guide begin ----------------------------------

--[[
local function preGetArrConfig(  )
	local function getArrConfigCallBack( cbFlag, dictData, bRet)
		logger:debug("getArrConfigCallBack")
		logger:debug(cbFlag)
		logger:debug(dictData)
		logger:debug(bRet)
		require "script/module/guide/GuideModel"
		GuideModel.setGuideConfig(dictData.ret)
	end

	RequestCenter.user_getArrConfig(getArrConfigCallBack)
	logger:debug("user_getArrConfig")
end
--]]
------------------------------------ new hand guide config end -------------------------------


-- 增加“注册推送请求”方法
-- local _arr={}
-- function addRegPushRequest(pFunc)
-- 	table.insert(_arr, pFunc)
-- end

-------------------------------------- 组队战 ---------------------
-- 副本组队回调
function pushCopyteamBattleResultCallback( cbFlag, dictData, bRet )
	if( dictData.err == "ok" )then
		local b_result = dictData.ret
		if(_copyteamBattleDelegate~=nil)then
			pcall(_copyteamBattleDelegate)
		end
		require "script/battle/GuildBattle"
		GuildBattle.createLayer(b_result)

	end
end

-- 注册副本组队战
local function push_copyteam_battleResult()
	Network.re_rpc( pushCopyteamBattleResultCallback, "push.copyteam.battleResult", "push.copyteam.battleResult")
end

----------------------------------- yucong 获取伙伴图鉴 ---------------

local function preGetHeroBookCallback(cbFlag, dictData, bRet )
	if (bRet) then
		if (not table.isEmpty(dictData.ret)) then
			DataCache.setHeroBook(dictData.ret)
		end
	end
end

local function preGetHeroBook( )
	RequestCenter.hero_getHeroBook(preGetHeroBookCallback)
end


function preGetChallengeWel()
	local function getChallengeWelInfo(cbFlag, dictData, bRet )
		if (bRet) then
			if (not table.isEmpty(dictData.ret)) then
				logger:debug({challengeWelfare_getInfo=dictData.ret})
				require "script/module/wonderfulActivity/challengeWelfare/ChaWelModel" 
				ChaWelModel.setChallengeWelInfo(dictData.ret)
			end
		end
	end
	RequestCenter.challengeWelfare_getInfo(getChallengeWelInfo)
end

-- 拉巅峰对决xinxi
function preGetWAInfo( ... )
	if not ActivityConfigUtil.isActivityOpen("worldarena") then
		return
	end
	WAService.getWorldArenaInfoLogin(function ( tData )
		WorldArenaModel.setWorldArenaInfo(tData)
		local tBet = table.hcopy(tData.self_bet, {})
		WABetModel.preSetWABetInfo( tBet )
		local betContinueTime = tData.bet_duration_after_bgn
		WABetModel.preSetWAbetContiTime( betContinueTime )
	end)
end

---------------------------yangna 工会副本有新成员申请加入,撤销申请 时的推送---------------------

local function re_guild_newApply_callback(cbFlag, dictData, bRet )
	logger:debug({re_guild_newApply_callback = dictData})
	if (bRet) then
		g_redPoint.newGuildMemApply.visible = true
		g_redPoint.newGuildMemApply.num = dictData.ret[1]

		if (LayerManager.curModuleName()~="GuildMemberView") then 
			GlobalNotify.postNotify( "NEW_GUILD_MEMBER_APPLY")
		end 
		
	end
end
local function re_guild_newApply()
	Network.re_rpc(re_guild_newApply_callback, "push.guild.apply", "push.guild.apply")
end

local function re_guild_cancleApply_callback(cbFlag, dictData, bRet )
	logger:debug({re_guild_cancleApply_callback = dictData})

	if (bRet) then
		g_redPoint.newGuildMemApply.num = dictData.ret[1]
		if (tonumber(g_redPoint.newGuildMemApply.num)<=0) then 
			g_redPoint.newGuildMemApply.visible = false
		end 

		if (LayerManager.curModuleName()~="GuildMemberView") then 
			GlobalNotify.postNotify( "NEW_GUILD_MEMBER_APPLY")
		end 	
	end

end

local function re_guild_cancleApply()
	Network.re_rpc(re_guild_cancleApply_callback, "push.guild.applyCancel", "push.guild.applyCancel")
end




-- zhangqi, 2015-11-19, 尝试解决新角色创建后进游戏loading过长，不拉非必要请求的方法
function newPlayerPreRequest( callback )
	logger:debug("newPlayerPreRequest begin")

	registerAllPushMessageHandler()

	preGetSwitchRequest(function ( ... )
		preBagInfoRequest() -- zhangqi, 2015-07-01, 先拉取背包信息，避免计算战斗力时引用错误

		if (SwitchModel.getSwitchOpenState(ksSwitchFormation,false)) then
			logger:debug("Formation is opened") -- 阵容相关信息
			preFormationRequest()
			preGetSquadRequest()
			preGetExtraRequest() --	修改者：zhaoqiangjun 20140512 16：27
			preGetBenchRequest() -- 修改者：wangming 20150114 15:24
		end

		if ( UserModel.getHeroLevel() )then
			preGetNormalCopy()  -- 普通副本世界地图
		end

		if (SwitchModel.getSwitchOpenState(ksSwitchSignIn,false)) then
			preGetSignInfo() -- 每日签到
		end

		if (SwitchModel.getSwitchOpenState(ksSwitchShop,false)) then
			preGetShopInfo() -- 酒馆信息
		end

		preGetLevelReward() -- 等级礼包

		if (SwitchModel.getSwitchOpenState(ksSwitchResolve,false)) then
			preGetMysTeryShop() -- 拉去神秘商店信息
		end

		if(SwitchModel.getSwitchOpenState(ksSwitchWorldBoss,false)) then
			preGetBossTimeOffset() -- 拉取boss战的时间偏移
		end

		getAchieveInfo() -- 成就, 是否可以把默认信息保存在代码里

		preGetOnlineInfo() -- 在线奖励

		preGetSupplyInfo() -- 体力等补给信息

		getTaskInfo() -- 每日任务

		preGetAccSignInfo() -- 签到开服奖励

		preGetGrowthFundInfo() -- 获取成长基金信息

		preGetVipcardInfo() --获取月卡信息

		preGetOpenServerInfo()	-- 获取开服7日奖励信息

		preGetVipGiftInfo()  -- 获取vip礼包信息

		preGetRouletteInfo() -- 获取幸运转盘信息

		preGetSaleBoxInfo() -- 获取限时宝箱信息

		preGetWelfareShopInfo() -- 获取福利商店信息

		preGetLuxurySignInfo() -- 获取豪华签到数据

		preGetActivityInfo(false,preGetActivityCallback) -- 活动配置

		preGetChargeInfo() -- 获得充值信息

		if (callback and type(callback) == "function") then
			callback()
		end

		logger:debug("newPlayerPreRequest end")
	end)
end
--------------- 开始 拉数据 ----------------------
function startPreRequest(callback)
	regPushGmRunScript() -- 注册 GM脚本通知推送
	RequestCenter.re_OtherLogin() -- zhangqi, 2015-06-01, 注册账号在别处登陆的推送
	RequestCenter.re_KickOff() -- zhangqi, 2015-12-23, 注册后端主动断开连接前的推送

	preGetSwitchRequest(function ( ... )
		preBagInfoRequest() -- zhangqi, 2015-07-01, 先拉取背包信息，避免计算战斗力时引用错误

		if (SwitchModel.getSwitchOpenState(ksSwitchFormation,false)) then
			logger:debug("Formation is opened")
			preFormationRequest()
			preGetSquadRequest()
			preGetExtraRequest() --	修改者：zhaoqiangjun 20140512 16：27
			preGetBenchRequest() -- 修改者：wangming 20150114 15:24
		end

		if ( UserModel.getHeroLevel() )then
			preGetNormalCopy()  -- 普通副本世界地图
		end

		if (SwitchModel.getSwitchOpenState(ksSwitchAwake,false)) then
			preGetAwakeCopy()--觉醒副本
			preGetAwakeShop()
		end
		if (SwitchModel.getSwitchOpenState(ksSwitchExplore,false)) then
			getExploreInfo() -- 获取探索信息
		end

		if (SwitchModel.getSwitchOpenState(ksSwitchActivityCopy,false)) then
			getActivityCopyInfo() --活动副本
		end

		if (SwitchModel.getSwitchOpenState(ksSwitchEliteCopy,false)) then
			preGetEliteCopy() -- 拉取精英副本
		end

		if (SwitchModel.getSwitchOpenState(ksSwitchSignIn,false)) then
			preGetSignInfo() -- 每日签到  
		end

		if (SwitchModel.getSwitchOpenState(ksSwitchShop,false)) then
			preGetShopInfo() -- 酒馆信息
		end

		preGetLevelReward() -- 等级礼包

		if (SwitchModel.getSwitchOpenState(ksSwitchRobTreasure,false)) then
			preGetTreasureFragInfo() -- 所有宝物碎片信息
		end

		if (SwitchModel.getSwitchOpenState(ksSwitchDestiny, false)) then
			preGetTrainInfo()  --新修炼系统
		end

		if (SwitchModel.getSwitchOpenState( ksSwitchMainShip , false )) then
			preGetShipInfo() -- 新主船信息获取
		end

		if (SwitchModel.getSwitchOpenState( ksSwitchMainShip , false ) and SwitchModel.getSwitchOpenState( ksSwitchCannonAndBall , false )) then
			logger:debug("getSwitchOpenState perGetCannonAndBall ")
			perGetCannonAndBall() --  船炮信息获取
		end

		if (SwitchModel.getSwitchOpenState(ksSwitchResolve,false)) then
			preGetMysTeryShop() -- 拉去神秘商店信息
		end

		-- 2015-5-14  删除了占卜屋 那么登陆的时候也就不拉取数据了
 		-- if (SwitchModel.getSwitchOpenState(ksSwitchStar,false)) then
		-- 	preGetDiviStarInfo() -- 获得占星数据
		-- end

		if (SwitchModel.getSwitchOpenState(ksSwitchGuild,false)) then
			preGuildMemberInfo() -- 获取联盟个人信息信息
			-- preGuildMemberBaseInfo() --公会副本个人信息相关
			-- preGuildCopyBaseInfo() --公会副本公会信息相关
		end

		if (SwitchModel.getSwitchOpenState(ksSwitchImpelDown,false)) then
			preGetImpelDownInfo()
		end

		if (SwitchModel.getSwitchOpenState(ksSwitchResource,false)) then
			preGetMineInfo()	-- 拉取资源矿信息，红点用
		end

		if (SwitchModel.getSwitchOpenState(ksSwitchSpeShop,false)) then
			getSpeShopInfo()	-- 拉取宝物商店信息，红点用
		end

		if(SwitchModel.getSwitchOpenState(ksSwitchWorldBoss,false)) then
			preGetBossTimeOffset() -- 拉取boss战的时间偏移
		end

		--preGetArrConfig() -- 拉去新手引导 配置信息  暂时先注释掉 改成数据存储到本地

		getFriendsList() -- 获取所有好友信息

		getFriendApplyList() -- 获取所有好友申请信息

		getAchieveInfo() -- 成就

		preGetOnlineInfo() -- 在线奖励

		getRewardList() -- 用户登陆时拉一次奖励中心数据

		preGetSupplyInfo() -- 体力等补给信息

		getTaskInfo() -- 每日任务

		preGetAccSignInfo() -- 签到开服奖励

		preGetGrowthFundInfo() -- 获取成长基金信息

		preGetVipcardInfo() --获取月卡信息

		preGetShareInfo()	-- 获取分享信息

		preGetOpenServerInfo()	-- 获取开服7日奖励信息

		preGetVipGiftInfo()  -- 获取vip礼包信息 

		preGetRouletteInfo() -- 获取幸运转盘信息

		preGetSaleBoxInfo() -- 获取限时宝箱信息

		getReceiveStaminaInfo() -- 拉取好友领取耐力列表数据 add by licong 2013.12.31

		preGetWelfareShopInfo() -- 获取福利商店信息

		preGetLuxurySignInfo() -- 获取豪华签到数据

		preGetActivityInfo(false,preGetActivityCallback) -- 活动配置

		preGetChargeInfo() -- 获得充值信息

		preGetHeroBook()	--拉取伙伴图鉴

		--preGetAccLoginInfo() -- 累计登录

		require "script/module/formation/BondRequst"
		BondRequst.getArrUnionByFmt()
--]==]
		if (callback and type(callback) == "function") then
			callback()
		end
	end)


	-------- 注册通知 -----------
	--此处有误，先注释掉
	-- require "script/ui/switch/SwitchOpen"
	-- SwitchOpen.registerFighterNotification()

	-- add by huxiaozhou 2014-06-07。
	-- 2015-07-01, zhangqi 移入LoginHelper.lua
	-- SwitchCtrl.registerBattleNotification()
	-- SwitchCtrl.registerLevelUpNotification()


	--------- 后端主动推送接口 ---------
	reg_ActivityConfig() --活动配置推送注册

	re_bag_baginfo_request() -- 背包信息

	push_TreasureFragNum() -- 饰品碎片数量变化
	
	regPushHeroAddHero() -- 英雄推送接口

	re_mail_addNewMail() -- 邮件推送
	
	re_friend_newFriend() -- 新好友推送
	re_friend_delFriend() -- 删除好友推送
	-- push_friend_login() -- 好友上线推送	
	-- push_friend_logoff() -- 好友下线推送
	re_friend_receiveStamina() -- 好友耐力领取列表推送
	re_new_friend_apply() --新的好友申请推送

	
	regPushNewReward() -- “奖励中心”
	
	re_chat_getMsg() --聊天推送
	
	re_push_newSwitch() --新功能开启推送
	
	push_hero_rfrrank() -- 卡包活动得推送
	push_hero_endact()
	
	regPushUserInfo() -- 用户信息修改推送
	
	re_guild_refreshMember() -- 公会个人信息发生变化
	re_guild_refreshGuangong() -- 公会大厅剩余奖励发生变化
	re_guild_refreshShop() -- 公会商店剩余推送
	
	re_team_changed() -- 组队数据变化接口
	push_copyteam_battleResult() -- 组队战斗接口
	
	re_finishAchieve() --成就推送  add by huxiaozhou 2014-11-10
	
	re_finishTask() --每日任务推送 add by wangming 2015-01-13
	
	re_bossKilled() --世界boss死亡推送 add by wangming 2015-02-04
	addRerpcCharge() -- 增加 充值 和月卡推送 

	re_pushOpenserver()	-- 开服7日推送

--	re_PushImpelSweepOver() -- 深海监狱扫荡完毕推送

	re_pushChallengeWelNum() --推送挑战福利挑战次数

	push_mine()	-- 资源矿推送

	re_guild_newApply()  --工会有新成员申请推送

	re_guild_cancleApply() -- 工会成员取消申请推送
end


-- 拉取领取耐力列表数据
function getReceiveStaminaInfo( ... )
	local function staminaFdsFunc( cbFlag, dictData, bRet )
		doUnReCall("fnFRIEND_STAMINA") -- 2015-04-23

		if (bRet) then
			require "script/module/friends/staminaFdsCtrl"
			staminaFdsCtrl.upStaminaList(dictData.ret)
		end
	end

	RequestCenter.friend_receiveLoveList(staminaFdsFunc)

	setRecall("fnFRIEND_STAMINA", function ( ... ) -- 2015-04-23
		RequestCenter.friend_receiveLoveList(staminaFdsFunc)
	end)
end
-- 获得占卜信息的网络回调函数
function diviStarInfoCallBack( cbFlag, dictData, bRet )
	logger:debug({diviStarInfoCallBack = dictData})
	doUnReCall("fnDIVI_STAR") -- 2015-04-23

	if (bRet) then
		require "script/module/astrology/MainAstrologyModel"
		MainAstrologyModel.setDiviInfo(dictData.ret)
	end
end


function preGetDiviStarInfo()
	RequestCenter.divine_getDiviInfo(diviStarInfoCallBack)

	setRecall("fnDIVI_STAR", function ( ... ) -- 2015-04-23
		RequestCenter.divine_getDiviInfo(diviStarInfoCallBack)
	end)
end
------------------------ 注册 获得从服务器端发来的脚本 -------------------------
-- 回调
function reportScriptResultCallback( cbFlag, dictData, bRet )
-- print_t(dictData)
end

--- function dadd(a,b) return a+b  end  dadd(1,2)
-- 回调
function pushGmRunScriptCallback(cbFlag, dictData, bRet)
	if( not table.isEmpty(dictData) and dictData.err == "ok")then
		local m_script = dictData.ret
		if(m_script and #m_script>0)then
			local runScript = loadstring(m_script)
			if(runScript and type(runScript) == "function")then
				local re_data = runScript()
				local t_args = CCString:create("nil")
				if(type(re_data) == "table")then
					t_args = table.dictFromTable(re_data)
				elseif(re_data~=nil)then
					t_args = CCString:create(re_data)
				end
				local args = CCArray:create()
				args:addObject(t_args)
				Network.no_loading_rpc(reportScriptResultCallback, "gm.reportScriptResult", "gm.reportScriptResult", args)
			end
		end
	end
end

-- 注册
function regPushGmRunScript()
	Network.re_rpc(pushGmRunScriptCallback, "re.gm.runScript", "re.gm.runScript")
end

-- zhangqi, 2014-10-12, 注册所有推送消息处理的方法
-- 断线后会清除底层事件分发队列，重连时需要重新注册这些推送的处理
function registerAllPushMessageHandler( ... )
	Network.re_rpc(pushGmRunScriptCallback, "re.gm.runScript", "re.gm.runScript")
	RequestCenter.re_OtherLogin() -- 注册账号在别处登陆的推送，zhangqi, 2015-01-05
	RequestCenter.re_KickOff() -- zhangqi, 2015-12-23, 注册后端主动断开连接前的推送

	reg_ActivityConfig() -- zhangqi, 2015-12-23, 添加断线重连后的活动配置推送注册
	
	Network.re_rpc(re_bag_baginfo_callback, "re.bag.bagInfo", "re.bag.bagInfo")
	push_TreasureFragNum() -- 饰品碎片数量变化
	Network.re_rpc(push_newCopy_callback, "push.copy.newcopy", "push.copy.newcopy")
	-- Network.re_rpc(re_star_addNewNotice_callback, "re.star.addNewNotice", "re.star.addNewNotice")
	Network.re_rpc(re_mail_addNewMail_callback, "re.mail.newMail", "re.mail.newMail")
	Network.re_rpc(re_friend_newFriend_callback, "re.friend.newFriend", "re.friend.newFriend")
	Network.re_rpc(re_friend_delFriend_callback, "push.friend.del", "push.friend.del")
	-- Network.re_rpc(push_friend_login_callback, "push.friend.login", "push.friend.login")
	-- Network.re_rpc(push_friend_logoff_callback, "push.friend.logoff", "push.friend.logoff")
	Network.re_rpc(re_friend_receiveStamina_callback, "push.friend.newLove", "push.friend.newLove")

	Network.re_rpc(re_friend_fdsApply_callback, "re.friend.newApply", "re.friend.newApply")


	Network.re_rpc(re_match_dataRefresh_callback, "push.compete.refresh", "push.compete.refresh")
	Network.re_rpc(re_match_reward_callback, "push.compete.reward", "push.compete.reward")
	Network.re_rpc(re_chat_getMsg_callback, "re.chat.getMsg", "re.chat.getMsg")
	Network.re_rpc(push_hero_rfrrank_callback, "push.heroshop.rfrrank", "push.heroshop.rfrrank")
	Network.re_rpc(push_hero_endact_callback, "push.heroshop.endact", "push.heroshop.endact")
	Network.re_rpc(pushGuildRefreshMember, "push.guild.refreshMember", "push.guild.refreshMember")
	Network.re_rpc(pushGuildRefreshGuangong, "push.refreshGuild", "push.refreshGuild")
	Network.re_rpc(pushGuildGoods, "push.refreshGoods", "push.refreshGoods")
	Network.re_rpc(pushDataChanged, "team.update", "team.update")
	Network.re_rpc(onPushHeroAddHero, "push.hero.addhero", "push.hero.addhero")
	Network.re_rpc(onPushNewReward, "re.reward.newReward", "re.reward.newReward")
	Network.re_rpc(onPushUserInfo, "push.user.updateUser", "push.user.updateUser")
	Network.re_rpc(requestCallback, "re.activity.newConf", "re.activity.newConf")
	Network.re_rpc(onPushNewSwitch, "push.switch.newSwitch", "push.switch.newSwitch")
	Network.re_rpc( pushCopyteamBattleResultCallback, "push.copyteam.battleResult", "push.copyteam.battleResult")
	Network.re_rpc(re_finishAchieve_callback, "push.achieve_new_finish", "push.achieve_new_finish")
	Network.re_rpc(re_finishTask_callback, "push.active.task.finish", "push.active.task.finish")
	RequestCenter.re_bossKilled(re_bossKilled_callback)

	Network.re_rpc(reUserChargeInfo, "push.user.chargegold", "push.user.chargegold") --充值相关推送
	Network.re_rpc(rePushMonthCardUpdate, "push.monthcard.update", "push.monthcard.update") -- 如果是充值的月卡

	Network.re_rpc(MainMineCtrl.onPush_Pit, "push.mineral.update", "push.mineral.update")
	Network.re_rpc(MainMineCtrl.onPush_Broadcast, "push.mineral.rob", "push.mineral.rob")
	Network.re_rpc(MainMineCtrl.onPush_Reward, "push.mineral.reward", "push.mineral.reward")

	Network.re_rpc(re_guild_newApply_callback, "push.guild.apply", "push.guild.apply")
	Network.re_rpc(re_guild_cancleApply_callback, "push.guild.applyCancel", "push.guild.applyCancel")
end

