-- FileName: PartnerBondModel.lua
-- Author: lvnanchun
-- Date: 2015-07-22
-- Purpose: 羁绊界面业务逻辑
--[[TODO List]]

module("PartnerBondModel", package.seeall)
require "db/DB_Union_profit"
require "db/DB_Heroes"
require "db/DB_Item_hero_fragment"
require "db/DB_Item_treasure"
require "db/DB_Hero_model_id"

-- UI variable --

-- module local variable --
local _nHid
local _nBtnIndex
local _tbHeroFightInfo = {}
local _tbHeroInfo = {}
-- 原界面阵容（包含黑影）
local _tbFormationHids = {}
-- 现界面阵容（不包含黑影）
local _tbPartnerHids = {}
local DB_Union_profit = DB_Union_profit
local DB_Heroes = DB_Heroes
local DB_Item_hero_fragment = DB_Item_hero_fragment
local DB_Item_treasure = DB_Item_treasure
local DB_Hero_model_id = DB_Hero_model_id
local _i18n = gi18n

local function init(...)

end

function destroy(...)
    package.loaded["PartnerBondModel"] = nil
end

function moduleName()
    return "PartnerBondModel"
end

function create(...)

end

function getBtnIndex( )
	return _nBtnIndex
end

function setBtnIndex( nIdx , nHtidGet )
	logger:debug("nHtidGet" .. tostring(nHtidGet))
	logger:debug("_tbHeroInfo_htid" .. tostring(_tbHeroInfo.htid))
	if (tonumber(_tbHeroInfo.htid) == tonumber(nHtidGet)) then
		_nBtnIndex = nIdx
	else
		_nBtnIndex = nil
	end
end

function setFormationHids( nHid )
	_tbFormationHids = {}

	if (nHid) then
		_tbFormationHids[0] = nHid
	else
		for k,v in pairs(DataCache.getSquad()) do
			_tbFormationHids[tonumber(k)] = v
		end
		local benchId = DataCache.getBench()['0']
		if (benchId and benchId > 0) then 
			_tbFormationHids[#_tbFormationHids + 1] = benchId
		else
			_tbFormationHids[#_tbFormationHids + 1] = 0
		end
	end

	_tbPartnerHids = {}

	for i=0,table.count(_tbFormationHids)-1 do
		if (_tbFormationHids[i] ~= 0) then
			table.insert( _tbPartnerHids , _tbFormationHids[i])
		end
	end
end

function getFormationPage()
	for k,v in pairs(_tbFormationHids) do
		if (tonumber(v) == tonumber(_nHid)) then
			return k
		end
	end
end

function getBondPageNum( )
	return table.count(_tbPartnerHids)
end

function getBondPage( )
	for k,v in pairs(_tbPartnerHids) do 
		if (tonumber(v) == tonumber(_nHid)) then
			return k
		end
	end
end

function setFightInfo( )
	require "script/module/partner/HeroFightUtil"
	local pdic = HeroFightUtil.getAllForceValuesByHid(_nHid)
	if(not table.isEmpty(pdic)) then
		_tbHeroFightInfo = { {name = _i18n[1047] , value = pdic.life}, 
							 {name = _i18n[1048] , value = pdic.physicalAttack},
		 					 {name = _i18n[1049] , value = pdic.magicAttack},
							 {name = _i18n[1050] , value = pdic.physicalDefend}, 
							 {name = _i18n[1051] , value = pdic.magicDefend} }
	end
end

function setHid( nHeroId , layPreType )
	_nHid = nHeroId
	table.hcopy( HeroUtil.getHeroInfoByHid(_nHid) , _tbHeroInfo )
	
	if (layPreType == 2) then
		setFormationHids()
	else
		setFormationHids( nHeroId )
	end
	
	setFightInfo()
end

function setPageNum( nPageNum )
	for k,v in pairs(_tbPartnerHids) do 
		if (tonumber(k) == tonumber(nPageNum)) then
			setHid(tonumber(v) , 2)
			break
		end
	end
end

function getHid( ... )
	return _nHid
end

function getHtid( )
	return _tbHeroInfo.htid
end

function getHeroFightInfo( )
	return _tbHeroFightInfo
end

function getHeroName( htid )
	if (htid) then
		return DB_Heroes.getDataById(htid).name 
	else
		return _tbHeroInfo.localInfo.name
	end
end

function getFragInfo( htid )
	local modelId = HeroModel.getHeroModelId(_tbHeroInfo.htid)
	if (htid) then
		modelId = HeroModel.getHeroModelId(htid)
	end
	--if (htid) then
		return DB_Item_hero_fragment.getArrDataByField("aimItem" , modelId)[1]
	--else
	--	return DB_Item_hero_fragment.getArrDataByField("aimItem" , )[1]
	--end
end

function getHeroImage( nPage )
	assert(_tbPartnerHids[nPage] , "PartnerHid not found")
	assert(HeroUtil.getHeroInfoByHid(_tbPartnerHids[nPage]) , "Heroinfo not found" .. _tbPartnerHids[nPage])
	return "images/base/hero/body_img/" .. HeroUtil.getHeroInfoByHid(_tbPartnerHids[nPage]).localInfo.body_img_id
end

function getEnevolveLevel( )
	return "+" .. _tbHeroInfo.evolve_level
end

function getTreasureInfoById( treaId )
	local treaInfo = DB_Item_treasure.getDataById(treaId)
	return treaInfo
end

function getEquipInfoById( equipId )
	require "db/DB_Item_arm"
	return DB_Item_arm.getDataById(equipId)
end

function getBond( )
	local strBondId = _tbHeroInfo.localInfo.link_group1
	local tbBondId = string.split(strBondId , ',')
	
	local tbBondInfo = {}
	-- 自己往羁绊名字后面加罗马数字
	local tbNumber = { "Ⅰ", "Ⅱ", "Ⅲ", "Ⅳ" }
	local tbNameNumber = {}

	for k,v in pairs(tbBondId) do 
		local tbOneBond = {}
		local dbData = DB_Union_profit.getDataById(v)
		tbOneBond.bondId = dbData.id 
		tbOneBond.name = dbData.union_arribute_type
		if not (tbNameNumber[dbData.union_arribute_ids]) then
			tbNameNumber[dbData.union_arribute_ids] = 1
		else
			tbNameNumber[dbData.union_arribute_ids] = tbNameNumber[dbData.union_arribute_ids] + 1
		end
		tbOneBond.name = tbOneBond.name .. tbNumber[tbNameNumber[dbData.union_arribute_ids]]
		local itemStr = string.split(dbData.activate_spend , ',')[2]
		local bellyStr = string.split(dbData.activate_spend , ',')[1]
		tbOneBond.bellyPrize = tonumber(string.split(bellyStr , '|')[3])
		tbOneBond.itemType = tonumber(string.split(itemStr , '|')[2])
		tbOneBond.itemNum = tonumber(string.split(itemStr , '|')[3])
		tbOneBond.htid = tonumber(_tbHeroInfo.htid)
		table.insert( tbBondInfo , tbOneBond)
	end

	return tbBondInfo
end

function getNameColorByHtid( htid )
	assert(DB_Heroes.getDataById(htid) , "Heroinfo not found" .. htid)
	assert(DB_Heroes.getDataById(htid).star_lv , "hero have no quality")
	return DB_Heroes.getDataById(htid).star_lv
end

function getNameColorById( nTreaId , itemType )
	if (itemType == 2) then
		return DB_Item_treasure.getDataById(nTreaId).quality
	elseif (itemType == 3) then
		return DB_Item_arm.getDataById(nTreaId).quality
	end
end
