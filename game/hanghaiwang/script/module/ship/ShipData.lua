-- FileName: ShipData.lua
-- Author: LvNanchun
-- Date: 2015-10-16
-- Purpose: 主船界面数据，用于外部调用
--[[TODO List]]

module("ShipData", package.seeall)
require "db/DB_Super_ship"
require "db/DB_Switch"
require "db/DB_Ship_ability"
require "db/DB_Affix"

-- UI variable --

-- module local variable --
-- 给_tbShipInfo一个初始值，若从后端拉倒了数据，则用后端的数据否则说明刚到10级，初始化为装备着小帆船
local _tbShipInfo = {main_ship = nil , ship = {}}
local _dbShip = DB_Super_ship
local _dbSwitch = DB_Switch
local _dbShipAbility = DB_Ship_ability
local _dbAffix = DB_Affix

local function init(...)

end

function destroy(...)
    package.loaded["ShipData"] = nil
end

function moduleName()
    return "ShipData"
end

function create(...)

end

--[[desc:从后端获取船的信息
    arg1: 后端传入的table
    return: 无
—]]
function setShipInfo( tbData )
    logger:debug({ShipDataServerData = tbData})
    -- 将后端所有信息重构一遍，将key都转化成number
    local tbNewData = {}
    tbNewData.main_ship = tonumber(tbData.main_ship)
    tbNewData.ship = {}
    for k,v in pairs(tbData.ship) do
        tbNewData.ship[tonumber(k)] = v
    end
    logger:debug({tbNewData = tbNewData})

	_tbShipInfo = tbNewData
end

--[[desc:查看是否有后端数据，没有则重拉，用于判断是否取到了后端
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function getInfoState()
    return _tbShipInfo
end

--[[desc:根据船的id获取船的信息
    arg1: 船的id
    return: 船的信息
—]]
function getShipInfoById( shipId )
	return _dbShip.getDataById(tonumber(shipId))
end

--[[desc:根据物品id获取船物品信息
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function getShipItemInfoById( itemId )
    require "script/module/public/ItemUtil"
    return ItemUtil.getItemById(itemId)
end

--[[desc:功能简介
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function getShipAbilityById( abilityId )
    return _dbShipAbility.getDataById(abilityId)
end

--[[desc:功能简介
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function getAllShipInfo()
    local tbAllShipInfo = {}

    tbAllShipInfo.nowShipId = _tbShipInfo.main_ship
    tbAllShipInfo.nShipNum = table.count(_dbShip.Super_ship)
--    for k,v in _tbShipInfo.ship do 
--        table.insert(tbAllShipInfo.strengthShipInfo , k)
--    end
    tbAllShipInfo.strengthShipInfo = _tbShipInfo.ship

    logger:debug({tbAllShipInfo = tbAllShipInfo})
    return tbAllShipInfo
end

--[[desc:通过主船道具id,获取对应主船id
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function getShipIdByItemId( shipItemId )
    local itemData = getShipItemInfoById(shipItemId)
    local shipId = tonumber(itemData[16])

    return shipId
end

--[[desc:判断对应主船是否被激活
    arg1: 主船id
    return: 是否被激活，lv(未激活时lv == 0)
—]]
function getIfShipActivatedById( shipId )
    local shipActivated = false
    local shipLv = 0

    for k,v in pairs (_tbShipInfo.ship) do
        if (k == shipId) then
            shipActivated = true
            shipLv = v.strengthen_level
            break
        end
    end

    return shipActivated, tonumber(shipLv)
end

--[[desc:判断对应主船是否被激活
    arg1: 道具id
    return: 是否被激活，lv(未激活时lv == 0)
—]]
function getIfShipActivatedByItemId( shipItemId )
    local shipId = getShipIdByItemId(shipItemId) 
    return getIfShipActivatedById(shipId)
end

--[[desc:设置正在装备的主船的id，用于装备按钮
    arg1: 船的id
    return: 无  
—]]
function setMainShipId( shipId )
    _tbShipInfo.main_ship = shipId
end

--[[desc:设置某一已激活的船的强化等级
    arg1: 船id, 是增加1（用于强化按钮）还是重置（用于重置按钮）
    return: 无  
—]]
function setShipStrengthLevel( shipId , isReset )
    if (isReset) then
        _tbShipInfo.ship[shipId].strengthen_level = 0
    else
        _tbShipInfo.ship[shipId].strengthen_level = _tbShipInfo.ship[shipId].strengthen_level + 1
    end
end

--[[desc:激活一艘船
    arg1: 船的id
    return:无  
—]]
function activateShipById( shipId )
    _tbShipInfo.ship[shipId] = {strengthen_level = 0}
end

--[[desc:通过shipId，获得激活所需的道具的item_id
    arg1: shipId
    return: 若没有足够的道具，则返回nil 
—]]
function getItemIdByShipId( shipId )
    -- 读取需要的激活道具id
    local shipInfo = getShipInfoById(shipId)
    local strShipActNeed = shipInfo.activate_item
    logger:debug({shipNeedStr = strShipActNeed})

    local tbShipActNeed = lua_string_split(strShipActNeed, "")

    -- 读取背包信息
    require "script/model/DataCache"
    local bagInfo = DataCache.getBagInfo()
    for k,v in ipairs(bagInfo.props) do

    end
    logger:debug({bagbaginfoinfo = bagInfo})
    --------没写完呢
end

function getNowShipId( ... )
    return (_tbShipInfo.main_ship and tonumber(_tbShipInfo.main_ship) > 0) and tonumber(_tbShipInfo.main_ship) or 1
end

--[[desc:功能简介
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
local function splitAttrStr( attrStr )
    assert(attrStr, "配置属性加成字符串为空")

    local tbAttr = {}

    local tbStr = string.split(attrStr, ",")
    for k,v in pairs(tbStr) do 
        local tbData = string.split(v, "|")

        tbAttr[tonumber(tbData[1])] = tonumber(tbData[2])
    end

    return tbAttr
end

--[[desc:根据船的id和强化等级获取船的属性信息
    arg1: shipId假设的正在装备的船的id，strLevel强化等级
    return: 是否有返回值，返回值说明  
—]]
function getShipAttrByShipIdAndStrLevel( shipId, strLevel )
    local tbTotalAttr = {0,0,0,0,0}

    -- 计算所有激活的船的激活属性
    for k,v in pairs(_tbShipInfo.ship) do
        local tmpShipInfo = _dbShip.getDataById(k)
        if (tmpShipInfo.activate_attr) then
            local tbActivate = splitAttrStr(tmpShipInfo.activate_attr)
            for i,j in pairs(tbActivate) do
                tbTotalAttr[i] = (tbTotalAttr[i] or 0) + j
            end
        end
    end
    local tbPercent = {}
    if (shipId and shipId > 0) then
        -- 计算shipId的船的基础属性
        local tmpShipInfo = _dbShip.getDataById(shipId)
        local strBase = tmpShipInfo.attr
        if (strBase) then
            local tbBase = splitAttrStr(strBase)
            for i,j in pairs(tbBase) do
                tbTotalAttr[i] = (tbTotalAttr[i] or 0) + j
            end
        end
        -- 计算shipId的船的强化属性
        local strStrength = tmpShipInfo.str_attr
        if (strStrength) then
            local tbStrength = splitAttrStr(strStrength)
            for i,j in pairs(tbStrength) do
                tbTotalAttr[i] = (tbTotalAttr[i] or 0) + j * tonumber(strLevel)
            end
        end
        -- 计算觉醒的天赋带来的加成
        
        local strAwake = tmpShipInfo.str_awake
        if (strAwake) then
            local tbAwake = splitAttrStr(strAwake)
            for k,v in pairs(tbAwake) do
                if (k <= tonumber(strLevel)) then
                    local tmpAbilityInfo = _dbShipAbility.getDataById(v)
                    -- 觉醒的固定值的加成
                    local strAbilityBase = tmpAbilityInfo.attr
                    if (strAbilityBase) then
                        local tbAbilityBase = splitAttrStr(strAbilityBase)
                        for i,j in pairs(tbAbilityBase) do
                            tbTotalAttr[i] = (tbTotalAttr[i] or 0) + j
                        end
                    end
                    -- 觉醒的百分比加成
                    local strAbilityPercent = tmpAbilityInfo.attr_add
                    if (strAbilityPercent) then
                        local tbAbilityPercent = splitAttrStr(strAbilityPercent)
                        for i,j in pairs(tbAbilityPercent) do
                            tbPercent[i] = (tbPercent[i] or 0) + j / 10000
                        end
                    end
                end
            end
        end
    end
    -- 计算百分比加成
    for k,v in pairs(tbPercent) do
        tbTotalAttr[k] = math.floor(tbTotalAttr[k] * (1 + v))
    end

    return tbTotalAttr
end

function getHomeNowShipImageId( ... )
    local shipId = getNowShipId()
    local shipInfo = getShipInfoById(shipId)
    return tonumber(shipInfo.home_graph)
end

--[[desc:功能简介
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function getAffixInfoById( affixId )
    return _dbAffix.getDataById(affixId)
end


--[[desc:根据船id获取船的形象id
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function getShipFigureIdByShipId( shipId )
    if (shipId) and (tonumber(shipId) > 0) then
        local shipInfo = getShipInfoById(shipId)
        return tonumber(shipInfo.home_graph)
    else
        local shipInfo = getShipInfoById(1)
        return tonumber(shipInfo.home_graph) 
    end
end

--[[desc:判断是否可以被激活
    arg1: 船的id
    return: boolen是否可以被激活。已激活的返回false
—]]
function bCanActivateByShipId( shipId )
    local tbActivateInfo = _tbShipInfo.ship

    -- 判断是否已激活
    for k,v in pairs(tbActivateInfo) do
        if (k == shipId) then
            return false
        end
    end

    -- 获取激活需要的物品
    local strNeedItem = _dbShip.getDataById(shipId).activate_item
    if (strNeedItem == nil) then
        -- 如果是nil，说明免费，返回可激活
        return true
    else
        local tbNeedItem = string.split(strNeedItem, "|")
        local itemId = tonumber(tbNeedItem[1])
        local itemNeedNum = tonumber(tbNeedItem[2])
        local itemHaveNum = tonumber(ItemUtil.getNumInBagByTid(itemId))
        return itemHaveNum >= itemNeedNum
    end
end

--[[desc:判断整体是否有红点
    arg1: 无
    return: boolen  
—]]
function bShipCanActivate( ... )
    local tbActivateInfo = _tbShipInfo.ship
    local nShipNum = getAllShipInfo().nShipNum
    local bCanActivate = false

    for i = 1, nShipNum do
        if (bCanActivateByShipId(i)) then
            bCanActivate = true
            break
        end
    end

    return bCanActivate
end
