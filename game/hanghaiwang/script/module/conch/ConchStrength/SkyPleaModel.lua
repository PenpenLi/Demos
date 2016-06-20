-- FileName: SkyPleaModel.lua
-- Author: liweidong
-- Date: 2015-02-27
-- Purpose: 空岛贝model
--[[TODO List]]

module("SkyPleaModel", package.seeall)

require "db/DB_Level_up_exp"
-- UI控件引用变量 --

-- 模块局部变量 --
local mDBLevelUpExp = DB_Level_up_exp
local mUModel = UserModel
local mMathInt = math.modf
local mMathMin = math.min

local function init(...)

end

function destroy(...)
	package.loaded["SkyPleaModel"] = nil
end

function moduleName()
    return "SkyPleaModel"
end

function create(...)

end
--获取一个空岛贝可升级的最大等级
function getMaxLevel( conch )
	if(not conch or not conch.itemDesc) then
		return 0
	end
	local pMax1 = tonumber(conch.itemDesc.maxLevel) or 0
	local pXi = tonumber(conch.itemDesc.maxLevelArg) or 0
	local pBase = tonumber(conch.itemDesc.baseMaxLevelArg) or 0
	local pMax2 = mMathInt((pBase + mUModel.getHeroLevel()*pXi/100)/5)*5
	local pResult = mMathMin(pMax1,pMax2) or 0
	logger:debug("max conch level:"..pResult .. ":" ..pMax1)
	return pResult
end

--获取一个空岛贝可提供多少经验
function getExpOfConchSuplly(conch)
	if(not conch or not conch.itemDesc or not conch.va_item_text) then
		return 0
	end
	local db_level = mDBLevelUpExp.getDataById(conch.itemDesc.upgradeID)
	if(not db_level) then
		return 0
	end
	-- local pLv = tonumber(conch.va_item_text.level) or 0
	local pExp = tonumber(conch.va_item_text.exp) or 0
	local pBase = tonumber(conch.itemDesc.baseExp) or 0
	pExp = pExp + pBase
	-- local pStr = ""
	-- for i=1,pLv do
	-- 	pStr = string.format("lv_%d",(i))
	-- 	pExp = pExp + (tonumber(db_level[pStr]) or 0)
	-- end
	return pExp
end

--获取一个空岛贝壳当前升级经验上限、当前等级经验
function getExpOnConchUpgrade(conch)
	if(not conch or not conch.itemDesc or not conch.va_item_text) then
		return 0
	end
	local db_level = mDBLevelUpExp.getDataById(conch.itemDesc.upgradeID)
	if(not db_level) then
		return 0
	end
	local pMaxLevl = getMaxLevel(conch)
	local pLv = tonumber(conch.va_item_text.level) or 0
	local pNowLv = tonumber(conch.va_item_text.level) or 0
	local pNowExp = tonumber(conch.va_item_text.exp) or 0
	local pMax = 0
	local pTempNow = pNowExp
	local pStr = string.format("lv_%d",(pLv+1))
	local nExp = tonumber(db_level[pStr]) or 0
	pMax = nExp
	for i=1, pLv do
		if(i > pMaxLevl) then
			break
		end
		pStr = string.format("lv_%d",(i))
		nExp = tonumber(db_level[pStr])
		if(not nExp)then
			break
		end
		pTempNow = pTempNow - nExp
	end
	logger:debug("wm----getExpOnConchUpgrade : %d , %d" , pTempNow , pMax)
	return pTempNow,pMax
end
--增加一定量经验后生成一个新的空岛贝
function getAfterAddExpConch(conch, exp)
	if(not conch or not conch.itemDesc or not conch.va_item_text) then
		return nil
	end
	local db_level = mDBLevelUpExp.getDataById(conch.itemDesc.upgradeID)
	if(not db_level) then
		return nil
	end
	local pMax = getMaxLevel(conch)
	local pNowLv = tonumber(conch.va_item_text.level) or 0
	local pNowExp = tonumber(conch.va_item_text.exp) or 0
	local pAddExp = tonumber(exp) or 0
	local pTotalExp = pNowExp + pAddExp
	local nLevelToExp = 0
	local nExpOfLevel = 0
	local pStr = ""
	for i=1, 999 do
		if(i > pMax) then
			nLevelToExp = i-1
			break
		end
		pStr = string.format("lv_%d",(i))
		local nExp = tonumber(db_level[pStr])
		if(not nExp)then
			nLevelToExp = i-1
			break
		end
		
		nExpOfLevel = nExpOfLevel + nExp
		if(nExpOfLevel > pTotalExp) then
			nLevelToExp = i-1
			nExpOfLevel = nExpOfLevel - nExp
			break
		end
	end
	local newConch={}
	table.hcopy(conch,newConch)
	newConch.va_item_text.level = nLevelToExp
	newConch.va_item_text.exp = pTotalExp

	return newConch
end


--排序空岛贝强化列表中的数据
function sortStrengthConch(tbConch)
	local function sortConch(v1,v2)
		if (v1.itemDesc.quality<v2.itemDesc.quality) then
			return true
		elseif (v1.itemDesc.quality==v2.itemDesc.quality) then
			if (v1.va_item_text.level<v2.va_item_text.level) then
				return true
			elseif (v1.va_item_text.level==v2.va_item_text.level) then
				if (tonumber(v1.itemDesc.id)<tonumber(v2.itemDesc.id)) then
					return true
				end
			end
		end
		return false
	end
	table.sort(tbConch,sortConch)
	return tbConch
end
--空岛贝选择列表排序 tbConch:需要排序的table hid:当前武将id
function sortSelectConch(tbConch,hid)
	local heroConchs = ItemUtil.getConchOnFormationHid(hid)
	local heroConchsType={}
	for _,v in pairs(heroConchs) do
		table.insert(heroConchsType,tonumber(v.itemDesc.type))
	end
	local conchs1={}
	local conchs2 = {}
	for _,val in pairs(tbConch) do
		if table.include(heroConchsType,{tonumber(val.itemDesc.type)}) then --与武将身上的空岛贝类型相同
			table.insert(conchs2,val)
		else
			table.insert(conchs1,val)
		end
	end
	local function sortConch(v1,v2)
		if (v1.itemDesc.quality>v2.itemDesc.quality) then
			return true
		elseif (v1.itemDesc.quality==v2.itemDesc.quality) then
			if (v1.va_item_text.level>v2.va_item_text.level) then
				return true
			elseif (v1.va_item_text.level==v2.va_item_text.level) then
				if (v1.itemDesc.sort<v2.itemDesc.sort) then
					return true
				end
			end
		end
		return false
	end
	table.sort(conchs1,sortConch)
	table.sort(conchs2,sortConch)
	local allEquips={}
	--将阵上的装备放到装备列表中
	for i,v in ipairs(conchs1) do
		table.insert(allEquips, v)
	end
	--将伙伴身上的装备放到装备列表中
	for i,v in ipairs(conchs2) do
		table.insert(allEquips, v)
	end
	return allEquips
end