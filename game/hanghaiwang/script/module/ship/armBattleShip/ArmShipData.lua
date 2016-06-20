-- FileName: ArmShipData.lua
-- Author: 
-- Date: 2014-04-00
-- Purpose: function description of module
--[[TODO List]]

module("ArmShipData", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --

local function init(...)

end

function destroy(...)
	package.loaded["ArmShipData"] = nil
end

function moduleName()
    return "ArmShipData"
end


-- 根据炮弹的id 创建图标
-- fnOnTouch 为点击图标的回调
-- iconType 1 为炮弹 2 为炮 因为炮弹和炮的id是一样的
function createCannonAndBallBtnByTid( tid, fnOnTouch,iconType)
	local tbItemDB 

	local imgFullPath
	if (iconType == 1) then  					-- 炮弹
		tbItemDB = DB_Ship_skill.getDataById(tid)
		imgFullPath =  "images/ship/ship_cannon/" .. tbItemDB.icon_small

	elseif (iconType == 2) then                    -- 炮
		tbItemDB = DB_Ship_cannon.getDataById(tid)
		imgFullPath =  "images/base/props/" .. tbItemDB.icon_small
	end

	local bgFullPath = "images/base/potential/color_" .. tbItemDB.quality .. ".png"
	local borderFullPath = "images/base/potential/equip_" .. tbItemDB.quality .. ".png"

	local btnItem = Button:create()
	logger:debug("tid = %d, bg full path : %s", tbItemDB.id, bgFullPath)

	btnItem:loadTextures(bgFullPath, bgFullPath, nil) -- 用品质边框初始化按钮
	local imgItem = ImageView:create()
	imgItem:loadTexture(imgFullPath)
	btnItem:addChild(imgItem) -- 加载物品图标, 附加到Button上
	imgItem:setTag(1)
	imgItem:setName("imgIcon")

	local imgBorder = ImageView:create()
	imgBorder:loadTexture(borderFullPath)
	btnItem:addChild(imgBorder) 
	
	btnItem:setTouchEnabled(false) -- 默认没有交互性
	if (fnOnTouch) then
		btnItem:addTouchEventListener(fnOnTouch)
		btnItem:setTouchEnabled(true) -- 如果指定回调方法则设置可交互
	end

	return btnItem
end


-- 根据炮的等级 获取升级需要的东西
function getCostInfoByTidAndLel( cannonDB, cannonLel )
	
	cannonLel = cannonLel or 0
	local upLel = tonumber(cannonLel) + 1
	local costInfo = {}

	local consumeItemFeild = cannonDB.consume_item
	local consumeItemTb = consumeItemFeild and lua_string_split(consumeItemFeild,",")

	local consumeItemFeild2 = cannonDB.consume_item2
	local consumeItemTb2 = consumeItemFeild2 and lua_string_split(consumeItemFeild2,",")

	local consumeBeiliFeild = cannonDB.consume_belly
	local consumeBeiliTb = consumeBeiliFeild and lua_string_split(consumeBeiliFeild,"|")

	if (upLel <= #consumeBeiliTb ) then
		costInfo.costBeili = consumeBeiliTb[upLel]
	else
		costInfo.costBeili = 0
		return costInfo
	end

    local bag = DataCache.getRemoteBagInfo()

    local function getCostNormal( consumeItemTb )
    	if (not consumeItemTb) then
    		return nil
    	end

		for i,consumeItem in ipairs(consumeItemTb or {}) do
			if (i == upLel) then
				local consumeItemInfo = lua_string_split(consumeItem or {},"|")
				local costNormal = {}
				costNormal.tid = consumeItemInfo[1]

		    	local haveNum = 0
		    	for k, v in pairs( bag.props or {} ) do
		            if  (tonumber(v.item_template_id) == tonumber(costNormal.tid)) then
		                haveNum = haveNum + tonumber(v.item_num)
		            end
			    end
				costNormal.haveNum = haveNum
				costNormal.needNum = consumeItemInfo[2]
				-- costInfo.costNormal = costNormal
				return costNormal
			end
		end
    end 

    local costNormal1 = getCostNormal(consumeItemTb)
    local costNormal2 = getCostNormal(consumeItemTb2)

    local costNormal = {}
    if (costNormal1) then
    	table.insert(costNormal,costNormal1)
    end
    if (costNormal2) then
    	table.insert(costNormal,costNormal2)
    end

    costInfo.costNormal = costNormal

    logger:debug({costInfo = costInfo})

	return costInfo
end

-- 获取炮弹的属性信息，根据装载该炮弹的炮的等级
function getCannonBallAttrByLel( cannonBallTid, cannonLel )
	logger:debug(debug.traceback())

	cannonLel = cannonLel or 0
	local cannonBallAttr = {}
	local cannonBallDB = DB_Ship_skill.getDataById(cannonBallTid)
	cannonBallAttr.des = cannonBallDB.base_desc

	local attr = {}

	local descStrFeild = cannonBallDB.desc_str
	local descStrTb = lua_string_split(descStrFeild or {},",")

	local descPrepfeild = cannonBallDB.desc_prep
	local descPrepTb = lua_string_split(descPrepfeild or {},",")

	local descLevelFeild = cannonBallDB.desc_level
	local descLevelTb = lua_string_split(descLevelFeild or {},"|")



	for i,limitLel in ipairs(descLevelTb or {}) do
		if (tonumber(cannonLel) >= tonumber(limitLel)) then
			local cannonAttr = {}
			local nameInfo = lua_string_split(descStrTb[i] or {},"|")
			local symbol = (#nameInfo > 1) and nameInfo[2] or ""

			cannonAttr.name = nameInfo[1]
			local formulationStr = descPrepTb[i]

			local formulate = assert(loadstring("local level = ... ; return "  .. formulationStr))

			cannonAttr.beforValue = formulate(tonumber(cannonLel)) .. symbol
			cannonAttr.affterValue = formulate(tonumber(cannonLel) + 1) .. symbol

			logger:debug({getCannonBallAttrByLel_here = cannonAttr})

			table.insert(attr,cannonAttr)
		end
	end


	-- 阶段属性
	local periodDescStrField = cannonBallDB.period_desc_str
	local periodDescStrTB = periodDescStrField and lua_string_split(periodDescStrField ,"|")

	local periodDescLevelField = cannonBallDB.period_desc_level
	local periodDescLevelTB = periodDescLevelField and lua_string_split(periodDescLevelField ,",")

	local periodDescPrepFeild = cannonBallDB.period_desc_prep
	local periodDescPrepTB = periodDescPrepFeild and lua_string_split(periodDescPrepFeild ,",")

	local  periodAttr = {}

	-- 递归出阶级
	local function getCurFormulation( beforeClass,affterClss,checkedCannonLel )
		if (not periodDescLevelTB) then
			return nil
		end

		local levelBeforLimit = periodDescLevelTB[beforeClass]
		local levelAftterLimit = periodDescLevelTB[affterClss]

		local levelBeforLimitTb 
		local levelAftterLimitTb 

		if (levelBeforLimit) then
			levelBeforLimitTb = lua_string_split(levelBeforLimit ,"|")
		end


		if (levelAftterLimit) then
			levelAftterLimitTb = lua_string_split(levelAftterLimit ,"|")
		else
			levelAftterLimitTb = {99999,5}
		end
		

		if (levelBeforLimitTb and levelAftterLimitTb) then

			if ((tonumber(checkedCannonLel) < tonumber(levelAftterLimitTb[1])) and (tonumber(checkedCannonLel) >= tonumber(levelBeforLimitTb[1]))) then
				return beforeClass,levelBeforLimitTb[1],levelBeforLimitTb[2],periodDescPrepTB[beforeClass],periodDescStrTB[beforeClass]
			elseif (tonumber(checkedCannonLel) >= tonumber(levelAftterLimitTb[1])) then
				return getCurFormulation(affterClss,affterClss + 1)
			else
				return nil
			end
		end
	end 

	local beforeClass ,beforeLimitLel,beforePeriod,beforePerp,beforeDes = getCurFormulation(1,2,cannonLel)

	if (beforePerp) then
		periodAttr.beforAttr = {}
		local beforAttr = periodAttr.beforAttr
		beforAttr.class = beforeClass
		beforAttr.period = beforePeriod
		beforAttr.limitLel = beforeLimitLel
		beforAttr.perp = assert(loadstring("local level = ... ; return "  .. beforePerp)) 
		beforAttr.des = beforeDes

		local paralevel= (math.floor(cannonLel/beforePeriod)) * beforePeriod
		local perp = beforAttr.perp
		local periodValue = perp(paralevel)
		beforAttr.attrText = string.format(beforeDes, periodValue)
	else
		cannonBallAttr.attr = attr
		cannonBallAttr.periodAttr = periodAttr
		logger:debug({getCannonBallAttrByLel_all = cannonBallAttr})
		return cannonBallAttr
	end

	local nextClassLel = (math.floor(cannonLel / 5) + 1) * 5

	local affterClass ,affterLimitLel,affterPeriod,affterPerp,affterDes = getCurFormulation(1,2,nextClassLel)

	if (affterPerp) then
		periodAttr.aftterAttr = {}
		local aftterAttr = periodAttr.aftterAttr
		aftterAttr.class = affterClass
		aftterAttr.period = affterPeriod
		aftterAttr.limitLel = affterLimitLel
		aftterAttr.perp = assert(loadstring("local level = ... ; return "  .. affterPerp)) 
		aftterAttr.des = affterDes

		local paralevel= (math.floor(nextClassLel/affterPeriod)) * affterPeriod
		local perp = aftterAttr.perp
		local periodValue = perp(paralevel)
		aftterAttr.attrText = string.format(affterDes, periodValue)

	else
		cannonBallAttr.attr = attr
		cannonBallAttr.periodAttr = periodAttr
		logger:debug({getCannonBallAttrByLel_all = cannonBallAttr})
		return cannonBallAttr
	end


	cannonBallAttr.attr = attr
	cannonBallAttr.periodAttr = periodAttr
	logger:debug({getCannonBallAttrByLel_all = cannonBallAttr})

	return cannonBallAttr
end

function create(...)

end
