-- FileName: treaRefineCtrl.lua
-- Author: menghao
-- Date: 2014-12-09
-- Purpose: 宝物精炼ctrl


module("treaRefineCtrl", package.seeall)


require "script/module/treasure/treaRefineView"
require "script/module/treasure/treaInfoModel"
require "script/module/grabTreasure/TreasureData"
require "script/module/public/AttribEffectManager"



-- UI控件引用变量 --
local layMain


-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_treaID
local _nSrcType
local _nHeroIndex
local _fnCallback
local m_i18n = gi18n

local m_tbBefore
local m_tbAfter
local _treaSuccedRefineInfo = {}


local _treaRefineInfo



function getTbForMaster( ... )
	return m_tbBefore, m_tbAfter
end


local function init(...)

end


function destroy(...)
	package.loaded["treaRefineCtrl"] = nil
end


function moduleName()
	return "treaRefineCtrl"
end


function afterBagRefresh( ... )


	initTreaRefineInfo()
	treaRefineView.resetAllLayout()
end

function getMasterBeforAndAfter( ... )
	return m_tbBefore,m_tbAfter
end


function onRefine( )
	-- 移除战斗力提升动画
	MainFormationTools.removeFlyText()
	-- 强化过的才可精练
	local treaRefineCostInfo = DB_Treasurerefine.getDataById(_treaRefineInfo.itemDesc.costId)
	if (tonumber(treaRefineCostInfo.refine_interval) ~= 0) then
		if(tonumber(_treaRefineInfo.va_item_text.treasureLevel) == 0) then
			ShowNotice.showShellInfo(m_i18n[1719])
			return
		end
	end

	-- 已到最高
	if(tonumber(_treaRefineInfo.va_item_text.treasureEvolve) >= tonumber(_treaRefineInfo.maxLv)) then
		ShowNotice.showShellInfo(m_i18n[1722])
		return
	end

	-- 强化等级不够
	local lvNeed = 0
	if (tonumber(treaRefineCostInfo.refine_interval) == 0) then
		lvNeed = (tonumber(_treaRefineInfo.va_item_text.treasureEvolve) + 1) * treaRefineCostInfo.refine_interval
	else
		lvNeed = tonumber(treaRefineCostInfo.max_upgrade_level)
	end
	local treaLv = tonumber(_treaRefineInfo.va_item_text.treasureLevel)
	if(tonumber(_treaRefineInfo.va_item_text.treasureLevel) < lvNeed) then
		ShowNotice.showShellInfo(gi18nString(1734, lvNeed))
		return
	end

	-- 没材料
	if(treaRefineView.getLackItemTid())then
		local lackItemTID = treaRefineView.getLackItemTid()
		if (lackItemTID == 60008) then
			PublicInfoCtrl.createItemDropInfoViewByTid(lackItemTID,nil,true)  -- 宝物精华不足引导界面
		else
			PublicInfoCtrl.createItemDropInfoViewByTid(lackItemTID,function ( ... )
				local costInfo  = reGetCostInfo()
				treaRefineView.refreshCostLay(costInfo)
			end,true)  -- 宝物精华不足引导界面
		end

		ShowNotice.showShellInfo(m_i18n[1718])
		return
	end
	-- 没钱
	local costSilver = tonumber(_treaRefineInfo.tbCostInfo.silver)
	if( costSilver > UserModel.getSilverNumber()) then
		PublicInfoCtrl.createItemDropInfoViewByTid(60406,nil,true)  -- 贝里不足引导界面
		ShowNotice.showShellInfo(m_i18n[1717])
		return
	end
	
	local function requestFunc( cbFlag, dictData, bRet )
		if(bRet)then
			local tbInfoTemp = HeroModel.getHeroByHid(_treaRefineInfo.equip_hid)
			-- m_tbBefore = MainEquipMasterCtrl.fnGetMasterInfoByHeroInfo(tbInfoTemp)
			--修改消耗消耗贝里
			--修改缓存属性
			TreasureEvolveUtil.setTreasureEvolve(_treaItemID,dictData.ret.va_item_text.treasureEvolve)
			TreasureEvolveUtil.treasureInfo = nil

			local tbInfoTemp = HeroModel.getHeroByHid(_treaRefineInfo.equip_hid)
			m_tbAfter = MainEquipMasterCtrl.fnGetMasterInfoByHeroInfo(tbInfoTemp)

			local resetForceValueHid = _treaRefineInfo.equip_hid

			if(resetForceValueHid and tonumber(resetForceValueHid)>0 )then
				local updataInfo = {[resetForceValueHid] = {HeroFightUtil.FORCEVALUEPART.UNION ,
														 	HeroFightUtil.FORCEVALUEPART.TREASURE,
															 HeroFightUtil.FORCEVALUEPART.MASTER,
															 },}
				
				UserModel.setInfoChanged(true)
				UserModel.updateFightValue(updataInfo)
			end
			UserModel.addSilverNumber(-tonumber(costSilver))

			_treaSuccedRefineInfo = {}
			_treaSuccedRefineInfo = table.hcopy(_treaRefineInfo,_treaSuccedRefineInfo)
			
			PreRequest.setBagDataChangedDelete(afterBagRefresh) -- 注册后端推送背包信息时的回调，以便刷新道具和宝物列表，人物属性，红色圆圈提示等

			-- 加屏蔽层
			local layout = Layout:create()
			layout:setName("layForShield")
			LayerManager.addLayout(layout)

			local function playSuccess( sender, MovementEventType, movementID )
				require "script/module/treasure/treaRefineSuccCtrl"
				local treaRefineInfo = {}
				treaRefineSuccCtrl.create(_treaSuccedRefineInfo)
			end
			treaRefineView.showAnimation(playSuccess)
		else

		end
	end

	-- 参数
	local args = CCArray:create()
	args:addObject(CCInteger:create(tonumber(_treaRefineInfo.item_id)))
	local twoParm = CCArray:create()
	local costItems = _treaRefineInfo.tbCostInfo.items
	for k,v in pairs(costItems) do
		for key,idValue in pairs(v.id) do
			twoParm:addObject(CCInteger:create(tonumber(idValue)))
		end
	end
	args:addObject(twoParm)
	RequestCenter.evolveTreasure(requestFunc,args)
end

function onBack(  )
	if (_nSrcType == 1) then
		MainTreaBagCtrl.create()
	else
		LayerManager.changeModule(MainFormation.create(_nHeroIndex), MainFormation.moduleName(), {1,3}, true)
	end
	if (_fnCallback) then
		_fnCallback()
	end
	-- 移除战斗力提升动画
	MainFormationTools.removeFlyText()
end

function getTreaRefineInfo( ... )
	return _treaRefineInfo
end

-- 掉落引导返回重新刷新所需物品信息
function reGetCostInfo( ... )
	local treaInfo = treaInfoModel.fnGetTreasNetData(_treaItemID)
	local treaEvolveLv = treaInfo.va_item_text.treasureEvolve
	local tbCostInfo = TreasureEvolveUtil.getEvolveCostInfo(treaInfo.itemDesc.id, treaEvolveLv + 1, treaInfo.itemDesc.costId,treaItemID)
	_treaRefineInfo.tbCostInfo = tbCostInfo
	return tbCostInfo
end


-- 获取精炼所需要的信息
function initTreaRefineInfo(  )
	local treaInfo = {}
	treaInfo = treaInfoModel.fnGetTreasNetData(_treaItemID)
	local treaEvolveLv = treaInfo.va_item_text.treasureEvolve
	-- 消耗物品 最大等级
	local tbCostInfo, maxLv = TreasureEvolveUtil.getEvolveCostInfo(treaInfo.itemDesc.id, treaEvolveLv + 1, treaInfo.itemDesc.costId,treaItemID)
	-- 精炼前后属性
	treaInfo.tbTreaEvolveBeforeInfo = treaInfoModel.fnTbTreaEvolveInfo(treaInfo.itemDesc.id,treaEvolveLv,maxLv)
	treaInfo.tbTreaEvolveAffterInfo = treaInfoModel.fnTbTreaEvolveInfo(treaInfo.itemDesc.id,treaEvolveLv + 1,maxLv)
	_treaRefineInfo = treaInfo
	_treaRefineInfo.tbCostInfo = tbCostInfo
	_treaRefineInfo.maxLv = maxLv

end

-- 根据itemId检查是否可以精炼  checkeNeedTrea 检查是否需要本体
function checkTreaCanRefineByItemId( itemID,checkeNeedTrea )
	local checkedTreaInfo = treaInfoModel.fnGetTreasNetData(itemID)
	local treaEvolveLv = checkedTreaInfo.va_item_text.treasureEvolve or 0
	-- 消耗物品 最大等级
	local temptreaDB = checkedTreaInfo.itemDesc
	local tempcostId = temptreaDB.costId

	if (not tempcostId) then
		return false
	end

	local tbCostInfo, maxLv = TreasureEvolveUtil.getEvolveCostInfo(checkedTreaInfo.itemDesc.id, treaEvolveLv + 1, checkedTreaInfo.itemDesc.costId,itemID)
	-- 强化过的才可精练
	local treaRefineCostInfo = DB_Treasurerefine.getDataById(checkedTreaInfo.itemDesc.costId)
	if (tonumber(treaRefineCostInfo.refine_interval) ~= 0) then
		if(tonumber(checkedTreaInfo.va_item_text.treasureLevel) == 0) then
			return false
		end
	end

	-- 已到最高
	if(tonumber(checkedTreaInfo.va_item_text.treasureEvolve) >= tonumber(maxLv)) then
		return false
	end

	-- 强化等级不够
	local lvNeed = 0
	if (tonumber(treaRefineCostInfo.refine_interval) == 0) then
		lvNeed = (tonumber(checkedTreaInfo.va_item_text.treasureEvolve) + 1) * treaRefineCostInfo.refine_interval
	else
		lvNeed = tonumber(treaRefineCostInfo.max_upgrade_level)
	end

	local treaLv = tonumber(checkedTreaInfo.va_item_text.treasureLevel)
	if(tonumber(checkedTreaInfo.va_item_text.treasureLevel) < lvNeed) then
		return false
	end

	-- 没材料
	local costNeedTrea = false
	for i,needItem in ipairs(tbCostInfo.items) do
		if (tonumber(needItem.num) > needItem.numHave) then
			return false
		else
			local itemType = ItemUtil.getItemTypeByTid(needItem.tid)
			costNeedTrea = (itemType.isTreasure and not costNeedTrea) and true
		end
	end
	--   是否需要本体
	if (checkeNeedTrea and not costNeedTrea) then
		return false
	end

	-- 没钱
	local costSilver = tonumber(tbCostInfo.silver)
	if( costSilver > UserModel.getSilverNumber()) then
		return false
	end
	return true
end

function create( treaItemID, srcType, nHeroIndex, callback)
	-- local canRefine = checkTreaCanRefineByItemId(treaItemID,true)
	-- logger:debug({canRefine = canRefine})
	_nSrcType = srcType
	_nHeroIndex = nHeroIndex
	_fnCallback = callback
	_treaItemID = treaItemID

	initTreaRefineInfo(_treaItemID)
	--判断功能节点
	if(not SwitchModel.getSwitchOpenState(ksSwitchTreasureFixed,true)) then
		return
	end

	-- if(tonumber(m_treaRefineInfo.treaData.dbData.isUpgrade) ~= 1)then
	if(tonumber(_treaRefineInfo.itemDesc.isUpgrade) ~= 1)then
		ShowNotice.showShellInfo( m_i18n[1720])
		return
	end

	layMain = treaRefineView.create()
	
	LayerManager.changeModule(layMain, treaRefineCtrl.moduleName(), {}, true)
	PlayerPanel.addForPartnerStrength()   -- 加简易信息条

	LayerManager.setPaomadeng(layMain, 0)
	UIHelper.registExitAndEnterCall(layMain, function ( ... )
		LayerManager.resetPaomadeng()
	end)

	return layMain
end

