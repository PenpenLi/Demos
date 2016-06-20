-- FileName: SpecTreaRefineCtrl.lua
-- Author: sunyunpeng
-- Date: 2015-09-18
-- Purpose: function description of module
--[[TODO List]]

module("SpecTreaRefineCtrl", package.seeall)
require "db/DB_Item_exclusive"
require "script/module/specialTreasure/SpecTreaRefineView"
require "script/module/specialBag/SBListCtrl"
require "script/module/specialTreasure/SpecialConst"

-- UI控件引用变量 --

-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString = gi18nString
local _allTreaDB = {}
local _specTreaInfo  = {}
local _specTreaIndex = 1
local _formerModuleName
local _costEnoughInfo = {}
local _powerTid = 720001
-- local _remvoedIndexTb = {}  --  要删除的pageviewIndex

local function init(...)

end

function destroy(...)
	package.loaded["SpecTreaRefineCtrl"] = nil
end

function formerModuleName( ... )
    return _formerModuleName
end

function moduleName()
    return "SpecTreaRefineCtrl"
end

-- 参数列表
-- specTreaTb = {
--					{ tid -- 宝物id   refineLevel -- 精炼等级 }
--					... 
--				}
-- treaIndex -- 查看宝物当前的索引
function create( specTreaItemID )
	_specTreaItemID = specTreaItemID
	_formerModuleName = LayerManager.curModuleName()
	-- 宝物的基本信息 tid 和 精炼等级
	local allTreaDB = {}
	_allTreaDB = {}
	allTreaDB,_specTreaIndex = initSpecTb(specTreaItemID)
	table.hcopy(allTreaDB,_allTreaDB)
	-- 获取宝物tid，精炼等级，基本DB信息
	initTreaInfo()
	local refineLayout = SpecTreaRefineView.create(_specTreainfo)
	require "script/module/public/UIHelper"
	LayerManager.changeModule(refineLayout, moduleName(), {}, true)
    LayerManager.setPaomadeng(refineLayout)
    PlayerPanel.addForPartnerStrength()
end

-- 滑动列表数据
function initSpecTb( specTreaItemID )
	local specTb , index = {} ,1
		-- pageView 准备数据
	if (_formerModuleName == "MainFormation") then
		specTb, index = FormationSpecialModel.getSpecialInfoDatas(tonumber(specTreaItemID))
	else
		local curSpecTrea = {}
		local allTreaOnBag = ItemUtil.getSpecialOnBag()
		local allTreaOnForm = FormationSpecialModel.getSpecialInfoDatas()
		local allTrea = {}
		for i,trea in ipairs(allTreaOnBag) do
			table.insert(allTrea,trea)
		end
		for i,trea in ipairs(allTreaOnForm) do
			table.insert(allTrea,trea)
		end

		for i,treaItem in ipairs(allTrea) do
			if (tonumber(treaItem.item_id) == tonumber(specTreaItemID)) then
				curSpecTrea = treaItem
				break
			end
		end
		table.insert(specTb, curSpecTrea)
	end
	return specTb,index
end


--获取宝物的当前索引,和所有数量
function getTreaIndex( ... )
	return _specTreaIndex,#_allTreaDB
end

-- 获取宝物信息
function getTreaInfo( ... )
	return _specTreainfo
end


function getAllTreaDb( ... )
	return _allTreaDB
end


-- 获取 创建页面的 专属宝物所有信息
-- { treaDB             -- 专属宝物DB
--	 refineLevel        -- 精炼等级
--   maxRefineLel       -- 最大精炼等级
--	 refineBeforeAttr   -- 精炼前属性信息
--	 refineAfterAttr    -- 精炼后属性信息
--	 treaLelUpAwaken    -- 精炼后觉醒属性信息
--	}
function initTreaInfo( treaIndex )
	if (treaIndex) then
		_specTreaIndex = treaIndex
	end

	local specTempTreaInfo = _allTreaDB[_specTreaIndex]
	local treainfo = {}
	treainfo = specTempTreaInfo
	local itemId = specTempTreaInfo.item_id
	local speTreaTid = specTempTreaInfo.item_template_id
	local refineLevel = tonumber(specTempTreaInfo.va_item_text.exclusiveEvolve)
	local treaDB = DB_Item_exclusive.getDataById(speTreaTid)
	treainfo.treaDB = treaDB
	treainfo.refineLevel = refineLevel

	require "db/DB_Exclusive_evolve"
	-- 宝物最大进阶等级
	local  exclusiveInfo = DB_Exclusive_evolve.getDataById(treaDB.evolveid)
	local maxRefineLel = exclusiveInfo.maxlevel
	treainfo.maxRefineLel = maxRefineLel
	-- 人物限制的最大进阶等级
	local userLel = tonumber(UserModel.getHeroLevel())
	local refineLelInterVel = tonumber(exclusiveInfo.interval)
	treainfo.heroLimitRefineLel = math.floor(userLel/refineLelInterVel) + 1

	-- 当前查看宝物的基础增益属性 生命，物防，魔防，物攻，魔攻等
	local treaAttrB = SpecTreaModel.fnGetTreaProperty(speTreaTid,refineLevel)
	treainfo.refineBeforeAttr = treaAttrB
	if ((refineLevel + 1) <= maxRefineLel) then
		local treaAttrA = SpecTreaModel.fnGetTreaProperty(speTreaTid,refineLevel + 1)
		treainfo.refineAfterAttr = treaAttrA
	else
		treainfo.refineAfterAttr = nil
	end
	--  当前宝物将要解锁的觉醒
	local affterRefineLel = refineLevel + 1
	-- local treaAwaken,thresholdLel,awakenIndex = SpecTreaModel.fnGetTreaAwakByRefineLel(speTreaTid,affterRefineLel)
	-- local treaAwaken2,thresholdLel2,awakenIndex2 = SpecTreaModel.getSpecAwakeForOnHero(itemId,affterRefineLel)

	-- treainfo.treaLelUpAwaken = treaAwaken and  (treaAwaken .. "\n" .. (treaAwaken2 and treaAwaken2 or "")) or treaAwaken2
	-- treainfo.thresholdLel = thresholdLel 
	-- treainfo.awakenIndex = awakenIndex 
	-- if (awakenIndex or awakenIndex2) then
	-- 	treainfo.awakeName = awakenIndex and m_i18nString(6943,awakenIndex) or "  "
	-- end

	-- local unlockDes1 = treaAwaken and treaAwaken .. m_i18nString(6944,thresholdLel)
	-- local unlockDes2 = treaAwaken2 and treaAwaken2 .. m_i18nString(6944,thresholdLel2)

	local treaAwaken,thresholdLel,awakeName = SpecTreaModel.getAllSkill(speTreaTid,itemId,affterRefineLel)
	treainfo.treaLelUpAwaken = treaAwaken 
	treainfo.thresholdLel = thresholdLel 
	treainfo.awakeName = awakeName 

	local unlockDes = treaAwaken and treaAwaken .. m_i18nString(6944,thresholdLel) 
	treainfo.treaLelUpAwakenDes = unlockDes

	-- 当前宝物进阶需要消耗的物品
	if ((refineLevel + 1) <= maxRefineLel) then
		local costInfo = SpecTreaModel.fnGetRefineCost(itemId,treaDB.id,refineLevel + 1)
		treainfo.costInfo = costInfo
	else
		treainfo.costInfo = nil
	end
	_,powerFragNum  =  SpecTreaModel.getSpecTreaNumByTid(nil,_powerTid)
	treainfo.powerFragNum = powerFragNum

	_specTreainfo = treainfo
	return treainfo
end



--- 万能宝物兑换完以后 刷新背包 和 pageView 和 消耗材料数据
function onChangAfter( addTreaTB )
	local curTreaItemId = tonumber( _specTreainfo.itemId)
	local curTreatreaDB =  _specTreainfo.treaDB
	local curTrearefineLevel = tonumber( _specTreainfo.refineLevel)
	------
	local addTreaInfo = {}
	
	if (_formerModuleName == "SBListCtrl") then
		local data = SBListModel.getChargAfterListData(_allTreaDB)
		local refineData = {}
		local itemNums = 0
		local itemIndex = 0
		for i,v in ipairs(data) do
			if (v.itemDesc.isMasterkey~=1) then
				itemNums = itemNums + 1
				table.insert(refineData,{hid = v.equip_hid, tid=v.itemDesc.id, itemId = v.item_id , refineLevel=tonumber(v.va_item_text.exclusiveEvolve)})
				if (tonumber(v.item_id) == curTreaItemId) then
					itemIndex = itemNums
				end
			end 
		end

		_allTreaDB = refineData
		_specTreaIndex = itemIndex
		for i,addItemId in ipairs(addTreaTB) do
			for k,tempItem in ipairs(_allTreaDB) do
				if (tonumber(addItemId) == tonumber(tempItem.itemId)) then
					local addInfo = {}
					addInfo = tempItem
					addInfo.index = k
					local treaDB = DB_Item_exclusive.getDataById(addInfo.tid)
					addInfo.imagePath = "images/base/exclusive/big/" .. treaDB.icon_big
					table.insert(addTreaInfo,addInfo)
				end
			end
		end

		table.sort( addTreaInfo, function ( v1,v2 )
			return tonumber(v1.index) < tonumber(v2.index)

		end )

	elseif (_formerModuleName == "MainFormation") then
	end

	-- 当前宝物进阶需要消耗的物品
	local costInfo = SpecTreaModel.fnGetRefineCost(curTreaItemId,curTreatreaDB.id,curTrearefineLevel + 1)
	_specTreainfo.costInfo = costInfo

	_,powerFragNum  =  SpecTreaModel.getSpecTreaNumByTid(nil,_powerTid)
	_specTreainfo.powerFragNum = powerFragNum

	-- 宝物的基本信息 tid 和 精炼等级
	SpecTreaRefineView.setTreaInfo(_specTreainfo)
	return addTreaInfo
end

function onChangAfterQuick(  )
	local curTreaItemId = tonumber( _specTreainfo.itemId)
	local curTreatreaDB =  _specTreainfo.treaDB
	local curTrearefineLevel = tonumber( _specTreainfo.refineLevel)
	------
	-- 当前宝物进阶需要消耗的物品
	local costInfo = SpecTreaModel.fnGetRefineCost(curTreaItemId,curTreatreaDB.id,curTrearefineLevel + 1)
	_specTreainfo.costInfo = costInfo
	-- 万能宝物
	_,powerFragNum  =  SpecTreaModel.getSpecTreaNumByTid(nil,_powerTid)
	_specTreainfo.powerFragNum = powerFragNum
	-- 宝物的基本信息 tid 和 精炼等级
	SpecTreaRefineView.setTreaInfo(_specTreainfo)
end


-- 获取页面容器里的所有图片模型资源地址
function getTreaPageViewList( ... )

	local treaListviewInfo = {}
	for i,v in ipairs(_allTreaDB) do
		local specTreaInfo = v
		local imagePath = "images/base/exclusive/big/" .. specTreaInfo.itemDesc.icon_big
		table.insert(treaListviewInfo,imagePath) 
	end
	return treaListviewInfo
end


-- 检查进阶材料是否充足
function getMaterialIsEnough( ... )
	local costEnoughInfo = {}
	local costInfo = _specTreainfo.costInfo
	local normalCost = costInfo.normalCost

	for i,v in ipairs(normalCost) do
		local costItemEnoughInfo = {}
		local tempItem = v

		local haveNum = tempItem.haveNum
		local needNum = tempItem.needNum
		costItemEnoughInfo.tid = tempItem.tid
		costItemEnoughInfo.isEnough = false

		if ( haveNum >= needNum) then
			costItemEnoughInfo.isEnough = true
		end
		table.insert( costEnoughInfo ,costItemEnoughInfo)
	end
	return costEnoughInfo
end

function getRemovePageViewIndex( ... )
	return _remvoedIndexTb
end


function setRemovePageIndex( remvoedIndex )
	for i,removeInfo in ipairs(remvoedIndex) do
		for k,listInfo in ipairs(_allTreaDB) do
			if (tonumber(removeInfo.itemId) == tonumber(listInfo.itemId)) then
				table.insert(_remvoedIndexTb,tonumber(k))
				break
			end
		end
	end
end


-- 精炼
function onRefine( )
	local userLel = tonumber(UserModel.getHeroLevel())
	local configDb = DB_Normal_config.getDataById(1)
	local heroLimitLel = tonumber(configDb.start_upgrade_level or 0)

	if (userLel < heroLimitLel )  then
		ShowNotice.showShellInfo(m_i18nString(1108, heroLimitLel))
		return
	end

	local treaRefineLev = _specTreainfo.refineLevel

	local treaMaxRefineLel = _specTreainfo.maxRefineLel

	if ( treaRefineLev >= treaMaxRefineLel ) then
		ShowNotice.showShellInfo(m_i18n[6936])
		return
	end

	local treaHeroLimitRefineLel = _specTreainfo.heroLimitRefineLel

	if ( treaRefineLev >=  treaHeroLimitRefineLel) then
		ShowNotice.showShellInfo(m_i18n[6937])
		return
	end

	local dropcallfn = function ( ... )
		onChangAfterQuick()
		SpecTreaRefineView.initMaterial()
		SpecTreaRefineView.initFragment()
	end

	local costEnoughInfo = getMaterialIsEnough()
	local costNormal = costEnoughInfo[1]
	if (costNormal and not costNormal.isEnough) then
		PublicInfoCtrl.createItemDropInfoViewByTid(costNormal.tid,dropcallfn,true)
		ShowNotice.showShellInfo(m_i18n[6938])
		return
	end

	local costTrea = costEnoughInfo[2]
	if (costTrea and not costTrea.isEnough) then
		--  碎片的获取途径 不是整体的
		local specTreaInfo = DB_Item_exclusive.getDataById(costTrea.tid)
		local fragTb = lua_string_split(specTreaInfo.fragment, "|")
		frgTid = tonumber(fragTb[1])

		PublicInfoCtrl.createItemDropInfoViewByTid(frgTid,dropcallfn,true)
		ShowNotice.showShellInfo(m_i18n[6939])
		return
	end

	local silverCost = _specTreainfo.costInfo.silverCost
	if( tonumber(silverCost) > tonumber( UserModel.getSilverNumber())) then
		PublicInfoCtrl.createItemDropInfoViewByTid(60406,nil,true)  -- 贝里不足引导界面
		ShowNotice.showShellInfo(m_i18n[1717])
		return
	end

	-- 加屏蔽层
	-- local layout = Layout:create()
	-- layout:setName("layForShield")
	-- LayerManager.addLayout(layout)
	SpecTreaRefineView.setBtnStatus(false)

	local function afterBagRefresh( ... )
		-- 获取宝物tid，精炼等级，基本DB信息
		local treaInfo = initTreaInfo()
		SpecTreaRefineView.setTreaInfo(treaInfo)
		SpecTreaRefineView.resetAllMes()

		-- 刷新专属宝物的显示
		GlobalNotify.postNotify(SpecialConst.MSG_RELOAD_SPECIAL)
	end 

	PreRequest.setBagDataChangedDelete(afterBagRefresh) -- 注册后端推送背包信息时的回调，以便刷新道具和宝物列表，人物属性，红色圆圈提示等（做不需要立刻变的）

	local function requestFunc( cbFlag, dictData, bRet )  -- 做一些立刻要变的东西
		if(bRet)then
			local bagInfo = DataCache.getBagInfo()
			for i,v in pairs(bagInfo.excl) do
				if (v.item_id == _specTreainfo.item_id) then
					v.va_item_text.exclusiveEvolve = tonumber(v.va_item_text.exclusiveEvolve)+ 1
					break
				end
			end

			local bagInfo = DataCache.getBagInfo()
			-- 修改阵容上的等级
			local euiphid = tonumber(_specTreainfo.equip_hid)

			for k,v in pairs(_allTreaDB) do
				if (tonumber(v.item_id) == tonumber(_specTreainfo.item_id) ) then
					v.va_item_text.exclusiveEvolve = tonumber(v.va_item_text.exclusiveEvolve)+ 1
					if (euiphid and tonumber(euiphid) > 0) then
						local tbHero = HeroModel.getHeroByHid(v.equip_hid)
						local exclusiveInfo = tbHero.equip.exclusive[SpecialConst.SPECIAL_POS]
					end
					break
				end
			end

			if( euiphid )then
				UserModel.setInfoChanged(true)
				UserModel.updateFightValue({[euiphid] = {
										 			 HeroFightUtil.FORCEVALUEPART.SPECIAL,
										 			 HeroFightUtil.FORCEVALUEPART.MASTER,
										  			},})  -- 更新专属宝物战斗力
			end

			UserModel.addSilverNumber(-tonumber(silverCost))

			-- 进阶成功界面
			require "script/module/specialTreasure/SpTreaRefineSucceed"
			local newInfo = {}
			table.hcopy(_specTreainfo,newInfo)

			local refineLevel = tonumber(_specTreainfo.refineLevel)
			local thresholdLel = tonumber(_specTreainfo.thresholdLel) 

			SpecTreaRefineView.refineAnimation(function ( ... )
				if (refineLevel + 1 == thresholdLel ) then
					SpTreaRefineSucceed.create(newInfo)
				else
					local showFight = false
					if (euiphid) then
						showFight = true
					end
					SpecTreaRefineView.showFloatText( showFight )
				end
			end)
		else

		end
	end

	-- 参数
	
	local args = CCArray:create()
	args:addObject(CCInteger:create(tonumber(_specTreainfo.item_id)))

	local costInfo = _specTreainfo.costInfo
	local normalCost = costInfo.normalCost
	local realCost = SpecTreaModel.getRealCost(normalCost)

	-- local remvoedIndexTb = {}
	-- _remvoedIndexTb = {}
	local consmeParm = CCArray:create()
	for k, v in pairs(realCost) do
		-- local removedItemInfo = {}
		-- removedItemInfo.itemId = v.itemId
		-- local arrItems = CCArray:create()
		consmeParm:addObject(CCInteger:create(v.itemId))
		-- table.insert(remvoedIndexTb,removedItemInfo)
	end

	-- setRemovePageIndex(remvoedIndexTb)
	args:addObject(consmeParm)
	RequestCenter.evolveSpecTreasure(requestFunc,args)

end

-- 删除断线的观察
function removeOfflineObserver( ... )
	-- 删除背包推送
    PreRequest.removeBagDataChangedDelete()
    GlobalNotify.removeObserver(GlobalNotify.RECONN_OK, moduleName() .. "_RemoveUILoading")
end

-- 增加断线的观察
function addOfflineObserver( ... )
    RequestCenter.bag_bagInfo(function (  cbFlag, dictData, bRet  )
                                PreRequest.preBagInfoCallback(cbFlag, dictData, bRet)
                              end)
    -- 重新设置界面
	_allTreaDB,_specTreaIndex = initSpecTb(_specTreaItemID)
	local treaInfo = initTreaInfo()
	_specTreainfo = treaInfo
	--  重置页面信息
	SpecTreaRefineView.resetAllMes(_specTreainfo)
end

