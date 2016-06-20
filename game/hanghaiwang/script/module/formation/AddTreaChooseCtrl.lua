-- FileName: AddTreaChooseCtrl.lua
-- Author: menghao
-- Date: 2014-06-27
-- Purpose: 装备或更换宝物ctrl


module("AddTreaChooseCtrl", package.seeall)


require "script/module/treasure/treaInfoModel"
require "script/module/public/ChooseList"
require "script/module/public/Cell/TreasureCell"


-- UI控件引用变量 --


-- 模块局部变量 --
local mItemUtil = ItemUtil
local m_curHeroID
local m_nPos
local m_heroPage
local m_sOldItemId
local tbTreaListInfo
local BaghasZhuanshu
local FormhasZhuanshu
local m_i18n = gi18n


local function init(...)

end


function destroy(...)
	package.loaded["AddTreaChooseCtrl"] = nil
end


function moduleName()
	return "AddTreaChooseCtrl"
end

-- 更换宝物的时候需要更新背包的信息，背包推送太慢了
-- 换宝物回调
function changeTreasureCallback( cbFlag, dictData, bRet )
	if (bRet) then
		require "script/module/guide/GuideModel"


		require "script/module/guide/GuideTreasView"
		if (GuideModel.getGuideClass() == ksGuideTreasure and GuideTreasView.guideStep == 4) then
			require "script/module/guide/GuideCtrl"
			GuideCtrl.createTreasGuide(5)
		end

		-- 英雄id和宝物位置
		local sHid, sPos = tostring(m_curHeroID), tostring(m_nPos)

		-- 获得要装备的宝物
		local bagInfo = DataCache.getRemoteBagInfo()
		local allHeros = HeroModel.getAllHeroes()

		require "script/module/formation/MainEquipMasterCtrl"
		local befor = MainEquipMasterCtrl.fnGetMasterInfoByHeroInfo(allHeros[sHid])

		local selectedIteminfo = nil
		-- 查找 更换的宝物或者装备的宝物 是否在背包中
		for i_gid, treaInfo in pairs(bagInfo.treas) do
			if (treaInfo.item_id == m_sOldItemId) then
				selectedIteminfo = treaInfo

				--对于原来在背包中的需要去掉
				mItemUtil.solveBagLackInfo(selectedIteminfo, 2)

				bagInfo.treas[i_gid] = nil
				DataCache.setBagInfo(bagInfo)
				break
			end
		end

		-- 当前格子上的宝物信息
		local pOldTrea = allHeros[sHid].equip.treasure[sPos]
		if(pOldTrea and tonumber(pOldTrea) ~= 0) then
			pOldTrea.equip_hid = nil
			pOldTrea.pos = nil
			mItemUtil.pushitemCallback(pOldTrea, 2)
		end

		local grabFormTreaHid  --  被抢夺宝物的英雄hid
		if(selectedIteminfo)then                   -- 如果在背包中
			selectedIteminfo.equip_hid = sHid
			selectedIteminfo.pos = sPos
		else                                       -- 如果再阵容上。则是抢过来传
			local tbTreasureList = mItemUtil.getTreasOnFormation()
			for k,v in pairs(tbTreasureList) do
				if(tostring(v.item_id) == tostring(m_sOldItemId))then
					selectedIteminfo = v
					break
				end
			end
			grabFormTreaHid = selectedIteminfo.equip_hid
			local treainfo = mItemUtil.getTreasInfoFromHeroByItemId(tonumber(selectedIteminfo.item_id))
			local posNum = treainfo.pos
			allHeros[tostring(selectedIteminfo.equip_hid)].equip.treasure[posNum] = "0"
			selectedIteminfo.equip_hid = sHid
			selectedIteminfo.pos = sPos
		end
		allHeros[sHid].equip.treasure[sPos] = selectedIteminfo

		UserModel.setInfoChanged(true)
		UserModel.updateFightValue({[sHid] = {HeroFightUtil.FORCEVALUEPART.UNION,
											  HeroFightUtil.FORCEVALUEPART.TREASURE,
											  HeroFightUtil.FORCEVALUEPART.MASTER,
											  },})  -- 更新宝物，羁绊，强化大师
		-- UserModel.updateFightValue({[sHid] = {1,2,3,4,5,6,7,8,9
		-- 							  },})  -- 更新宝物，羁绊，强化大师
		UserModel.setInfoChanged(true)
		if (grabFormTreaHid) then
			UserModel.updateFightValue({[grabFormTreaHid] = {HeroFightUtil.FORCEVALUEPART.UNION,
															HeroFightUtil.FORCEVALUEPART.TREASURE,
															HeroFightUtil.FORCEVALUEPART.MASTER,
															},})
		end

		MainFormation.updateHeroTreasure(m_nPos) -- zhangqi, 2015-06-19, 必须先更新战斗力才有效

		require "script/module/formation/MainEquipMasterCtrl"
		local after = MainEquipMasterCtrl.fnGetMasterInfoByHeroInfo(allHeros[sHid])
		local pStringinfo = MainEquipMasterCtrl.fnGetAllMasterChangeString2(befor,after)

		-- 如果穿上的饰品有羁绊，显示属性加成成功！
		local unionId = BondManager.getTreasureBondId(sHid, selectedIteminfo.item_template_id)
		
		MainFormation.showFlyQuality(nil, pStringinfo, unionId)


		-- 给宝物背包数据置刷新状态
		BagModel.setBagUpdateByType(BAG_TYPE_STR.treas)

		LayerManager.removeLayout()

		local function afterBagRefresh( ... )
			-- MainFormation.updateHeroTreasure(m_nPos) -- zhangqi, 2015-06-19, 必须先更新战斗力才有效
			GlobalNotify.postNotify("MSG_UPDATE_TREASURE_TIP")
		end
		-- MainFormation.updateHeroTreasure(m_nPos) -- zhangqi, 2015-06-19, 必须先更新战斗力才有效
		PreRequest.setBagDataChangedDelete(afterBagRefresh) -- 注册后端推送背包信息时的回调，以便刷新道具和宝物列表，人物属性，红色圆圈提示等（做不需要立刻变的）
	end
end

--[[desc:检查选择列表中的专属或者羁绊宝物 是否在 目标英雄身上有穿戴
    arg1: 身上的宝物
    arg2: 目标英雄的专属或者羁绊宝物
    arg3: 被检查的目标宝物
    arg4: 被检查宝物类别 1 专属 2 羁绊

    return: 返回true和false
—]]
local  function checktetter( tbDbInfosOn,TreaIDs,tbItem,treasureType )
	local treasureOn
	if (treasureType == 1) then
       treasureOn = tbDbInfosOn.tbZhuanshuOn
	else
       treasureOn = tbDbInfosOn.tbfetterOn
	end
	for i=1,#TreaIDs do
        local TreaID
        if (treasureType == 1) then
            TreaID = TreaIDs[i]
	    else
            TreaID = TreaIDs[i].id
	    end
		if (tonumber(tbItem.icon.id) == tonumber(TreaID)) then
			if (#treasureOn == 0) then
                  return true
            else
				for k,v in ipairs(treasureOn) do
					if (tonumber(tbItem.icon.id) == tonumber(v.item_template_id)) then
						return false			
					end
				end
				return true
			end
		end
	end

	return false
end


--[[desc:按专属 羁绊 可装备 品级 等级 id大 排序
    arg1: 选择列表
    arg2: 身上的宝物
    arg3: 目标英雄的专属宝物
    arg4: 目标英雄的羁绊宝物
    return: 排序后的列表  
—]]
local function sortChoseList(tbListInfo,tbDbInfosOn,zhuanshuTreaIDs,fetterTreaIDs )

	local zhuanshu = {}   --  专属列表
	local jiban = {}      --  羁绊列表
	local caload = {}     --  可装备列表
	local noload = {}     --  任何人没有装备列表
	local otherload = {}  --  其他伙伴穿戴宝物列表

	local other = {}      --  其他列表
	local tbListInfoNewOrder= {}  -- 排序后的新列表
	
	--品级 等级 id大 排序
	local function innerSort( w1,w2 )
		if (tonumber(w1.nQuality) ~= tonumber(w2.nQuality)) then
			return tonumber(w1.nQuality) > tonumber(w2.nQuality)
		else
			if(tonumber(w1.sStrongNum) ~= tonumber(w2.sStrongNum)) then
				return tonumber(w1.sStrongNum) >tonumber(w2.sStrongNum)
			else
				return tonumber(w1.id) >tonumber(w2.id)
			end
		end
	end
    
	

	for i=1,#tbListInfo do
		if (checktetter( tbDbInfosOn,zhuanshuTreaIDs,tbListInfo[i] ,1))  then		
			table.insert(zhuanshu,tbListInfo[i])
		elseif (checktetter( tbDbInfosOn,fetterTreaIDs,tbListInfo[i] ,2)) then
			table.insert(jiban,tbListInfo[i])
		elseif (tbListInfo[i].canLoad) then
			table.insert(caload,tbListInfo[i])
			if (tbListInfo[i].ohterLoaded) then
			    table.insert( otherload, tbListInfo[i] )
			else
				table.insert( noload, tbListInfo[i] )
			end
		else
			table.insert(other,tbListInfo[i])
		end
	end

    
    table.sort( zhuanshu, innerSort )
	for i,v in ipairs(zhuanshu) do
		table.insert(tbListInfoNewOrder,v)
	end

	table.sort( jiban, innerSort )
	for i,v in ipairs(jiban) do
		table.insert(tbListInfoNewOrder,v)
	end

	-- table.sort( caload, innerSort )
	-- for i,v in ipairs(caload) do
	-- 	table.insert(tbListInfoNewOrder,v)
	-- end
	table.sort( noload, innerSort )
	for i,v in ipairs(noload) do
		table.insert(tbListInfoNewOrder,v)
	end

	table.sort( otherload, innerSort )
	for i,v in ipairs(otherload) do
		table.insert(tbListInfoNewOrder,v)
	end

    
    -- 设置排序后的宝物 是否为专属还是羁绊
    for i=1,#tbListInfoNewOrder do
        if (tonumber(tbListInfoNewOrder[i].icon.id) == tonumber(zhuanshuTreaID)) then
            tbListInfoNewOrder[i].isZhuanshu = true        
        else
        	for k=1,#fetterTreaIDs do 
                if (tonumber(tbListInfoNewOrder[i].icon.id) == tonumber(fetterTreaIDs[k].id)) then
                    tbListInfoNewOrder[i].isFetterTrea = true 
                	break
                end
            end
        end
    end
	return tbListInfoNewOrder
end



-- 返回目标英雄推荐专属宝物id,是否推荐突破
local function getAweakid( htid )
	local zhuanshuTreaIDs = MainFormationTools.getExclusiveTreaureIDs(htid)
	if ( #zhuanshuTreaIDs == 0) then
		return nil
	else
		local dbInfo = DB_Item_treasure.getDataById(zhuanshuTreaIDs[1])
	    local tbawake= string.split(dbInfo.awakeId,"|")	
	 	local tbhero= string.split(dbInfo.heroId,"|")	
		local awakeId 
	    
	    if (#tbhero==2 ) then
	        if (tonumber(htid) == tonumber(tbhero[2])) then
	        	awakeId = tbawake[2]
	        else
	        	awakeId = tbawake[1]
	        end
	    elseif (#tbhero==1) then
	        awakeId = tbawake[1]
	    end
	    return awakeId
	end
end


--[[desc:给选择列表中的宝物加状态，属性
    arg1: 身上穿得 加 背包里的所有宝物
    arg2: 目标格子上的宝物
    arg1: 身上穿得 所有的宝物
    arg4: 专属宝物id 用来判断是否已经拥有此专属宝物
    return: 返回加了状态属性的选择列表 
—]]

local  function getChoseList( tbTreasureList ,tbCurrentTrea,tbDbInfos,zhuanshuTreaIDs)
	local tbListInfo = {}
	for k, v in pairs(tbTreasureList) do
		
    	-- local tbTreaInfo = treaInfoModel.getSimpleTreaInfo(v.item_id) -- zhangqi, 2015-06-11

		-- 可装备宝物过滤规则。1、类型限制 2、不是已经装备上的 3、不能是经验宝物
		if (tonumber(v.equip_hid) ~= tonumber(m_curHeroID) and tonumber(v.itemDesc.isExpTreasure)~= 1 and tonumber(v.itemDesc.is_refine_item)~= 1) then
			local tbData = {}


			if (v.equip_hid) then 
				tbData.ohterLoaded = true
			end
			tbData.id = v.item_id
			tbData.name = v.itemDesc.name

			tbData.sign = mItemUtil.getSignTextByItem(v.itemDesc)
			tbData.icon = { id = v.itemDesc.id, bHero = false }
			tbData.icon.onTouch = function ( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					require "script/module/treasure/NewTreaInfoCtrl"
					AudioHelper.playInfoEffect()
					NewTreaInfoCtrl.createByItemId(v.item_id) -- 相当于从背包中过来de
				end
			end

			tbData.sStrongNum = v.va_item_text.treasureLevel
			tbData.sRefinNum = v.va_item_text.treasureEvolve
			-- tbData.sStar = tbTreaInfo.quality -- zhangqi, 2014-07-23, 星级弃用了
			tbData.nQuality = tonumber(v.itemDesc.quality)
			tbData.sRank = v.itemDesc.base_score

			tbData.sOwner = mItemUtil.getOwnerByEquipId(v.equip_hid)
			tbData.equipHid = v.equip_hid

			-- 判断能不能装备（已装备同类型则不可装备）m_i18n
			tbData.canLoad = true
			local tbTypeNames = {m_i18n[1072],m_i18n[1128],m_i18n[1068],m_i18n[1071]}  --{"魔防", "攻击","生命", "物防"}
			local typeName
			local treaName

			for i=1,#tbDbInfos do
				if (tonumber(tbDbInfos[i].type) == tonumber(v.itemDesc.type)) then
					tbData.canLoad = false
					typeName = tbTypeNames[tonumber(v.itemDesc.type)]
					treaName = tbDbInfos[i].name
				end
			end

			if (tbCurrentTrea~=nil) then
				local dbCurrentTreaInfo = DB_Item_treasure.getDataById(tbCurrentTrea.item_template_id)
			    if (tonumber(dbCurrentTreaInfo.type) == tonumber(v.itemDesc.type)) then
					tbData.canLoad = true
				end
            end

			tbData.onLoad = function ( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					AudioHelper.playClickArmEffect()
					if (not tbData.canLoad) then
						ShowNotice.showShellInfo(gi18nString(1254, typeName, treaName))
						return
					end

					m_sOldItemId = tbData.id
					local args = CCArray:create()
					args:addObject(CCInteger:create(m_curHeroID))
					args:addObject(CCInteger:create(m_nPos))
					args:addObject(CCInteger:create(tbData.id))
					if (v.equip_hid) then
						args:addObject(CCInteger:create(v.equip_hid))
					end
					RequestCenter.hero_addTreasure( changeTreasureCallback, args )

				
				end
			end

			-- 属性label, zhangqi, 2014-07-23, 宝物属性改为左3条，右3条
			-- 处理经验宝物

			if( (tonumber(v.itemDesc.isExpTreasure) == 1) )then
				local add_exp = tonumber(v.itemDesc.base_exp_arr) + tonumber(v.va_item_text.treasureExp)
				tbData.sSupplyExp = tostring(add_exp) -- 经验马提供经验的数值
			else
				tbData.tbAttr = {}
				--tbData.tbAttr = tbTreaInfo.property or {}
				-- local basePropertys = tbTreaInfo.baseProperty
				local basePropertys = treaInfoModel.fnGetTreaBaseProperty(v.itemDesc.id,v.va_item_text.treasureLevel)
				local property = treaInfoModel.fnGetTreaProperty( v.itemDesc.id,v.va_item_text.treasureLevel)

				for i,v in ipairs(basePropertys) do
					table.insert(tbData.tbAttr,  v)
				end
				for i,v in ipairs(property) do
					table.insert(tbData.tbAttr,  v)
				end
			end
			table.insert(tbListInfo, tbData)

		end
        
        -- 判断背包里有是否有专属宝物
        for i=1,#zhuanshuTreaIDs do
			local zhuanshuTreaID = tonumber(zhuanshuTreaIDs[i])
		    if (tonumber(v.itemDesc.id) == zhuanshuTreaID) then
		        BaghasZhuanshu = true
	     	end	
	    end

	end
	return tbListInfo
end

-- 构造宝物列表需要的数据 不含推荐专属Cell
local function getTreaListData( htid,zhuanshuTreaIDs, fetterTreaIDs)
	require "script/module/formation/MainFormationTools"
	local htid = HeroModel.getHeroByHid(m_curHeroID).htid
	local zhuanshuTreaIDs = MainFormationTools.getExclusiveTreaureIDs(htid)
	local fetterTreaIDs = MainFormationTools.getFetterTreaureID(htid) or {}

	local tbTreas = HeroModel.getHeroByHid(m_curHeroID).equip.treasure

    -- 有英雄没羁绊物品
	if (not fetterTreaIDs or #fetterTreaIDs == 0) then
		fetterTreaIDs = {}
	end

    if (not zhuanshuTreaIDs or #zhuanshuTreaIDs == 0) then
		zhuanshuTreaIDs = {}
	end
	local i = 1
	while (fetterTreaIDs[i]) do
		local treaID = tonumber(fetterTreaIDs[i].id)
		if (treaID >= 500001 and treaID <= 600000) then
			i = i + 1
		else
			table.remove(fetterTreaIDs, i)
		end
	end

	-- 获取 羁绊和 宝物
	local tbDbInfos = {}    --  身上所有的物品
	local tbDbInfosOn = {}  --  整理出目标英雄的专属和羁绊
	local tbZhuanshuOn = {}
	local tbfetterOn = {}
	local bLoadTreaFull = true  --身上宝物格子是否全装满了   默认满的
	local tbCurrentTrea 

	for k,v in pairs(tbTreas) do
		if (v ~= "0") then
			if (m_nPos == tonumber(k)) then      -- 点击换宝物时的 格子目前装备的宝物
                tbCurrentTrea = v               
			end
			local dbInfo = DB_Item_treasure.getDataById(v.item_template_id)
			for i=1,#fetterTreaIDs do
				local treaID = tonumber(fetterTreaIDs[i].id)
				if (tonumber(v.item_template_id) == tonumber(treaID)) then
					table.insert(tbfetterOn,v)

				end
			end
			for i=1,#zhuanshuTreaIDs do
				local zhuanShuID = tonumber(zhuanshuTreaIDs[i])
				if ( tonumber(v.item_template_id) == tonumber(zhuanShuID)) then
					table.insert(tbZhuanshuOn,v)
				end
            end
			table.insert(tbDbInfos, dbInfo)
        else
        	bLoadTreaFull = false
		end
	end

	tbDbInfosOn.tbZhuanshuOn = tbZhuanshuOn
	tbDbInfosOn.tbfetterOn = tbfetterOn

	--  所有英雄身上的所有宝物
	local tbTreasureList = mItemUtil.getTreasOnFormation()
	-- 加上背包里的未被装备的宝物
	for k, v in ipairs(DataCache.getBagInfo().treas) do
		table.insert(tbTreasureList, v)
	end

	BaghasZhuanshu = false
	FormhasZhuanshu = false

    -- 给选择列表中的宝物加状态 和属性
	local tbListInfo = getChoseList( tbTreasureList ,tbCurrentTrea,tbDbInfos,zhuanshuTreaIDs)
	if (#tbDbInfosOn.tbZhuanshuOn > 0) then
		FormhasZhuanshu = true
	end

    -- 给选择列表排序 并剔除不可装备的宝物
	local choseList = sortChoseList(tbListInfo ,tbDbInfosOn,zhuanshuTreaIDs,fetterTreaIDs)
	
	return choseList
end


--  构造宝物列表需要的数据 添加推荐专属Cell
local function reCtorChoseList( ... )

    local htid = HeroModel.getHeroByHid(m_curHeroID).htid
    local zhuanshuTreaIDs = MainFormationTools.getExclusiveTreaureIDs(htid)
	local fetterTreaIDs = MainFormationTools.getFetterTreaureID(htid) or {}
	logger:debug({zhuanshuTreaIDs=zhuanshuTreaIDs})

    local awakeid = getAweakid( htid )
    local choseList = getTreaListData(htid,zhuanshuTreaIDs,fetterTreaIDs)


    --  插入推荐宝物cell  1.背包中没有 2.身上没装备 3.但是目标英雄可以拥有专属宝物的情况下
	if (not BaghasZhuanshu and not FormhasZhuanshu and zhuanshuTreaIDs ~= nil and #zhuanshuTreaIDs >=1 ) then
        local treaID = tonumber(zhuanshuTreaIDs[1]) or 0
		local dbInfo = DB_Item_treasure.getDataById(treaID)

		local tbData = {}
		tbData.isAddZhuanShu = true

		tbData.name = dbInfo.name
		tbData.sign = mItemUtil.getSignTextByItem(dbInfo)
		tbData.icon = { id = dbInfo.id, bHero = false }
        tbData.va_item_text = {}
		tbData.va_item_text.treasureEvolve = "0"
		tbData.va_item_text.treasureLevel = "0"

		tbData.icon.onTouch = function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				require "script/module/treasure/NewTreaInfoCtrl"
				-- 此类情况进入信息界面，类似从别人阵容进入
				NewTreaInfoCtrl.createBtTid(treaID,0,0,1)
			end
		end

		tbData.sStrongNum = 0
		tbData.sRefinNum = 0
		tbData.nQuality = tonumber(dbInfo.quality)
		tbData.sRank = dbInfo.base_score
		tbData.sOwner = ""

		tbData.onGet = function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				-- 先更新宝物碎片数据
				require "script/module/grabTreasure/TreasureService"
				require "script/module/treasure/treaRefineCtrl"
				if (not SwitchModel.getSwitchOpenState(ksSwitchRobTreasure, false)) then
					return
				end
				TreasureService.getSeizerInfo(function ( ... )
				end)
			end
		end

		-- local tbProperty = treaInfoModel.fnGetTreaProperty(treaID, 0)
		-- -- 加入基本属性
		-- local tbBasePropertys = treaInfoModel.fnGetTreaBaseProperty(treaID,0)
		-- for i,v in ipairs(tbBasePropertys) do
		-- 	table.insert(tbProperty, v)
		-- end

		tbData.isZhuanshu = true             -- 新添加专属

		if (awakeid) then
			tbData.awakeDes = DB_Awake_ability.getDataById(awakeid).des
		else
			tbData.awakeDes = ""
		end
		table.insert(choseList, 1, tbData)
	end

	return choseList
end


function create( tbChangeInfo )

	logger:debug({tbChangeInfo = tbChangeInfo})

	local from = tbChangeInfo.from
	m_curHeroID = tbChangeInfo.hid
	m_nPos = tbChangeInfo.treaType - from
	m_heroPage = tbChangeInfo.heroPage

	tbTreaListInfo = getTreaListData(htid,zhuanshuTreaIDs,fetterTreaIDs)
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
			LayerManager.removeLayout()
		end
	end

	local instTableView
	local tbInfo = {}

	tbInfo.sType = CHOOSELIST.LOADTREASURE
	tbInfo.onBack = tbEventListener.onBack
	tbInfo.tbState = {sChoose = gi18n[1713],sChooseNum = m_nSelectedNum,
		sExp = gi18n[1060], sExpNum = 0, onOk = tbEventListener.onSure}

	tbInfo.tbView = {}
	tbInfo.tbView.szCell = g_fnCellSize(CELLTYPE.TREASURE)
	tbInfo.tbView.tbDataSource = tbTreaListInfo

	tbInfo.tbView.CellAtIndexCallback = function (tbDat)
		local instCell = TreasureCell:new()
		instCell:init(CELL_USE_TYPE.LOAD)
		instCell:refresh(tbDat)
		return instCell
	end

	tbInfo.tbView.CellTouchedCallback = function ( view, cell, objCell)

	end

	instTableView = ChooseList:new()
	local layMain = instTableView:create(tbInfo)

	require "script/module/guide/GuideModel"
	require "script/module/guide/GuideTreasView"
	if (GuideModel.getGuideClass() == ksGuideTreasure and GuideTreasView.guideStep == 3) then
		require "script/module/guide/GuideCtrl"
		assert(instTableView.objView ~= nil, "再遇见这个问题找策划， 让策划把宝物配上")

		local scene = CCDirector:sharedDirector():getRunningScene()
	    performWithDelay(scene, function(...)
			instTableView.objView.view:setTouchEnabled(false)

			 -- zhangqi, 2015-09-29, 因为去掉了宝物选择列表的第一个固定推荐专属宝物，所以将以前
			 -- 取第二个cell改为取第一个, cellAtIndex的参数从1改为0
			local cell = instTableView.objView.view:cellAtIndex(0)
			local layCell = instTableView.objView.tbCellMap[cell]
			local pos = layCell.btnLoad:getWorldPosition()
			GuideCtrl.createTreasGuide(4, 0, pos)
	    end, 1/60)

	end

	return layMain
end

