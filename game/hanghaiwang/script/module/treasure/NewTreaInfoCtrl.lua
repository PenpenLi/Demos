-- FileName: NewTreaInfoCtrl.lua
-- Author: sunyunpeng
-- Date:  2016-01-23
-- Purpose: function description of module
--[[TODO List]]
require "script/module/treasure/NewTreaInfoView"
require "script/module/treasure/TreaInfoData"

module("NewTreaInfoCtrl", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --

local function init(...)

end

function destroy(...)
	package.loaded["NewTreaInfoCtrl"] = nil
end

function moduleName()
    return "NewTreaInfoCtrl"
end

function onBtnClose( ... )
	LayerManager.removeLayout()
end 


--去强化
function onBtnForge( treaInfo )
	-- 如果宝物强化未开启，提示后直接返回
	if (not SwitchModel.getSwitchOpenState(ksSwitchTreasureForge,true) ) then
		return
	end

	-- 先判断是否经验宝物，如果是经验宝物提示不能强化，避免多调用一次treaForgeCtrl.create
	if (treaInfo.treaDb.isExpTreasure == 1 or tonumber(treaInfo.treaDb.id) == 501010) then
		ShowNotice.showShellInfo(m_i18n[1512])
		return
	end

	require "script/module/treasure/treaForgeCtrl"
	LayerManager.removeLayout()
	local itemId = treaInfo.itemId
	local equipHid = treaInfo.equipHid 

	local curModuleName = LayerManager.curModuleName()
    local layCurType = curModuleName == "MainFormation" and 2 or 1

    local m_nHeroIndex = HeroModel.getHeroPosByHid(equipHid)
	local layout = treaForgeCtrl.create(itemId,layCurType, m_nHeroIndex)
	LayerManager.changeModule(layout, treaForgeCtrl.moduleName(), {1, 3}, true)
	PlayerPanel.addForPartnerStrength()
end 

--去精炼
function onRefine( treaInfo )
	--判断功能节点
	if(not SwitchModel.getSwitchOpenState(ksSwitchTreasureFixed,true)) then
		return
	end

	require "script/module/treasure/treaRefineCtrl"
	local itemId = treaInfo.itemId
	local equipHid = treaInfo.equipHid 

	local curModuleName = LayerManager.curModuleName()
    local layCurType = curModuleName == "MainFormation" and 2 or 1

    local m_nHeroIndex = HeroModel.getHeroPosByHid(equipHid)
	treaRefineCtrl.create(itemId,layCurType, m_nHeroIndex)
end 


--去获取
function onDrop( treaInfo )
	require "script/module/public/FragmentDrop"
	local treaDB  = treaInfo.treaDb
	local fragFeild = treaDB.fragment_ids
	if (fragFeild) then
		local tbfrag = lua_string_split(fragFeild, "|")
		local fragTid = tonumber(tbfrag[1])
		logger:debug({fragTid=fragTid})
		PublicInfoCtrl.createItemDropInfoViewByTid(fragTid,nil,true)
	else
		PublicInfoCtrl.createItemDropInfoViewByTid(treaDB.id,nil,true)
	end
end


-- 更换宝物
function onChange( treaInfo )
	LayerManager.removeLayout()

	local itemId = treaInfo.itemId

	local equipHid = treaInfo.equipHid 
	local allHeros = HeroModel.getAllHeroes()
	local oldConchAll = allHeros[tostring(equipHid)].equip.treasure

	logger:debug({oldConch = oldConch})

	local posIndex = 1
	for k,treaItem in pairs(oldConchAll) do
		if (tonumber(treaItem.item_id) == tonumber(itemId)) then
			posIndex =  k
			break
		end
	end

	local m_nHeroIndex = HeroModel.getHeroPosByHid(equipHid)

	require "script/module/formation/AddTreaChooseCtrl"
	local tbInfo = {hid = equipHid, treaType = posIndex, from = 0}



	local treasList = AddTreaChooseCtrl.create(tbInfo)
	LayerManager.addLayoutNoScale(treasList, LayerManager.getModuleRootLayout())
	UIHelper.changepPaomao(treasList) -- zhangqi, 2015-05-16, 跑马灯要放在下面层级不档返回按钮

end 

--卸载宝物
function onBtnUnload( treaInfo )
	if(ItemUtil.isTreasBagFull(true, function () LayerManager.removeLayout() end))then
		return
	end

	local itemId = treaInfo.itemId
	local equipHid = treaInfo.equipHid 
	local allHeros = HeroModel.getAllHeroes()
	local oldConchAll = allHeros[tostring(equipHid)].equip.treasure

	local posIndex 

	for k,treaItem in pairs(oldConchAll) do
		if (tonumber(treaItem.item_id) == tonumber(itemId)) then
			posIndex =  k
			break
		end
	end

	local function removeTreasureCallback( cbFlag, dictData, bRet )
		if (bRet) then
			logger:debug("卸下宝物回掉 的时候把宝物背包的数据清空")
			BagModel.setBagUpdateByType(BAG_TYPE_STR.treas)

			local oldConch = oldConchAll[tostring(posIndex)]
			
			if(oldConch and tonumber(oldConch) ~= 0) then
				ItemUtil.pushitemCallback(oldConch, 2)
			end

			HeroModel.removeTreasFromHeroBy(equipHid,posIndex)
			LayerManager.removeLayout()
			
			UserModel.setInfoChanged(true)
			UserModel.updateFightValue({[equipHid] = {HeroFightUtil.FORCEVALUEPART.TREASURE,
													HeroFightUtil.FORCEVALUEPART.MASTER,
													},})

			require "script/module/formation/MainFormation"
			MainFormation.removeHeroTreasure(posIndex) -- zhangqi, 2015-06-19, 必须先更新战斗力才有效

			MainFormation.showFlyQuality()
		end
	end
	
	if (equipHid and posIndex) then
		local args = Network.argsHandler(equipHid, posIndex)
		RequestCenter.hero_removeTreasure(removeTreasureCallback,args )
	end
end 


--前往夺宝
local function onBtnRob( ... )
	require "script/module/grabTreasure/MainGrabTreasureCtrl"
	MainGrabTreasureCtrl.create()
end


function createByItemId( treaItemid ,srcType,redPoindShow)
	logger:debug({NewTreaInfoCtrl_treaTid = treaItemid})

	local treaInfoData = TreaInfoData:new()
	local infoModleInstance = treaInfoData:initTreaDataBtItemId( treaItemid )
    local newTreaInfoView = NewTreaInfoView:new()
    local infoViewInstance = newTreaInfoView:create(infoModleInstance,srcType,redPoindShow)
    if (infoViewInstance) then
		LayerManager.addLayoutNoScale(infoViewInstance)
    end
end



function createBtTid(treaTid,level, evolve, srcType)

	local treaInfoData = TreaInfoData:new()
	local infoModleInstance = treaInfoData:initTreaDataBtTid( treaTid,level or 0,evolve or 0)
    local newTreaInfoView = NewTreaInfoView:new()
    local infoViewInstance = newTreaInfoView:create(infoModleInstance,srcType)
    if (infoViewInstance) then
		LayerManager.addLayoutNoScale(infoViewInstance)
    end
end
