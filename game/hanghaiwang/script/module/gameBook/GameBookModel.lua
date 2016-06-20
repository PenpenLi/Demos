-- FileName: GameBookModel.lua
-- Author: LvNanchun
-- Date: 2015-12-22
-- Purpose: function description of module
--[[TODO List]]

module("GameBookModel", package.seeall)

-- UI variable --

-- module local variable --
local _tbFormationInfo = {}
local _tbRecommendPartnerInfo = {}
local _tbWantStrongInfo = {}
local _tbPartnerDictionary = {}
local _tbPartnerNum = {}
local _tbGetData = {}
-- 后端gamebook数据
local _tbPartner
-- 检查紫色伙伴是否可突破为橙色
local _tbHashFromPurple
-- 检查橙色伙伴是否由紫色突破
local _tbHashFromOrange

local function init(...)

end

function destroy(...)
    package.loaded["GameBookModel"] = nil
end

function moduleName()
    return "GameBookModel"
end

function create(...)

end

--[[desc:存储一个table用于在reloadListView中调用
    arg1: 数据table
    return: 无
—]]
function setCellData( tbData, name )
	_tbGetData[name] = {}
	_tbGetData[name] = tbData
end

--[[desc:根据index获取信息
    arg1: 数据的index
    return: 数据
—]]
function getCellDataByIndex( index, name )
	return _tbGetData[name][index]
end

--[[desc:将后端的数据存储起来
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function setHadPartner( tbData )
	_tbPartner = tbData
	-- 设置数据的同时将原数据清空，防止缓存导致的显示错误
	_tbFormationInfo = {}
	_tbRecommendPartnerInfo = {}
	_tbWantStrongInfo = {}
	_tbPartnerDictionary = {}
	_tbPartnerNum = {}
	_tbGetData = {}

	logger:debug({_tbPartner = _tbPartner})
end

--[[desc:判断某一伙伴是否拥有过
    arg1: 伙伴htid
    return: boolen
—]]
function bHavePartner( htid )
	for _, v in pairs(_tbPartner) do
		if (tonumber(v) == tonumber(htid)) then
			return true
		end
	end
	return false
end

--[[desc:根据推荐伙伴的索引获取对应的伙伴信息
    arg1: 推荐伙伴的索引
    return: table存储伙伴信息  
—]]
function getRecommendPartnerById( recommendId )
	local tbRecommendPartner = DB_Game_book_type.getDataById(recommendId)
	local tbPartner = string.split(tbRecommendPartner.hero_id, "|")
	for k,v in pairs(tbPartner) do 
		tbPartner[k] = tonumber(v)
	end
	return tbPartner
end

--[[desc:获取初始化左侧listView的
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function getMainListViewInfo( mainTabIndex )
	-- tbMainListInfo中的tbList字段用于存储按钮的类型和名称。
	-- 类型为1表示推荐阵容，2表示推荐伙伴，3表示颜色用于伙伴图鉴，4表示提升类型用于我要变强
	local tbMainListInfo = {}
	if (mainTabIndex == 1) then
		-- 推荐阵容或者推荐伙伴
		tbMainListInfo.mainTabIndex = 1
		tbMainListInfo.tbList = {}
		tbMainListInfo.tbList[#tbMainListInfo.tbList + 1] = {btnType = 1, btnName = "阵容搭配"}
		local dnInfoNum = table.count(DB_Game_book_type.Game_book_type)
		for i = 1, dnInfoNum do
			local dbInfo = DB_Game_book_type.getDataById(i)
			tbMainListInfo.tbList[#tbMainListInfo.tbList + 1] = {btnType = 2, btnName = dbInfo.name, infoIndex = i}
		end
	elseif (mainTabIndex == 2) then
		-- 伙伴图鉴
		tbMainListInfo.mainTabIndex = 2
		tbMainListInfo.tbList = {}
		for i = 1,4 do
			if (i == 1) then
				tbMainListInfo.tbList[4] = {btnType = 3, btnName = "绿色", infoIndex = i}
			elseif (i == 2) then
				tbMainListInfo.tbList[3] = {btnType = 3, btnName = "蓝色", infoIndex = i}
			elseif (i == 3) then
				tbMainListInfo.tbList[2] = {btnType = 3, btnName = "紫色", infoIndex = i}
			elseif (i == 4) then
				tbMainListInfo.tbList[1] = {btnType = 3, btnName = "橙色", infoIndex = i}
			end
		end
	elseif (mainTabIndex == 3) then
		-- 我要变强
		tbMainListInfo.mainTabIndex = 3
		tbMainListInfo.tbList = {}
		local dbInfoNum = table.count(DB_Game_book_way.Game_book_way)
		for i = 1, dbInfoNum do 
			local isInclude = false
			local dbInfo = DB_Game_book_way.getDataById(i)
			local typeIndex = tonumber(dbInfo.type)
			for k,v in pairs(tbMainListInfo.tbList) do
				if (v.infoIndex == typeIndex) then
					isInclude = true
					break
				end
			end
			if (not isInclude) then
				tbMainListInfo.tbList[#tbMainListInfo.tbList + 1] = {btnType = 4, btnName = dbInfo.type_name, infoIndex = typeIndex}
			end
		end
	end

	return tbMainListInfo
end

--[[desc:获取推荐阵容需要的信息
    arg1: 
    return: 
—]]
function getRecommendFormationInfo( index )
	local dbInfoNum = table.count(DB_Game_book_formation.Game_book_formation)

	if (table.isEmpty(_tbFormationInfo)) then
		for i = 1, dbInfoNum do
			local dbInfo = DB_Game_book_formation.getDataById(i)
			local tbPartner = string.split(dbInfo.hero_id, "|")
			local tbData = {}
			tbData.formationIndex = i
			tbData.formationName = dbInfo.name
			tbData.heroList = {}
			for i,v in ipairs(tbPartner) do
				tbData.heroList[i] = tonumber(v)
			end
			_tbFormationInfo[#_tbFormationInfo + 1] = tbData
		end
	end

	if (index) then
		return _tbFormationInfo[index]
	else
		return _tbFormationInfo
	end
end

--[[desc:获取推荐伙伴主要信息，并设置推荐伙伴的类型
    arg1: 推荐伙伴的类型
    return: 对应类型的伙伴信息  
—]]
function recommendPartner( infoIndex )
	local dbInfo = DB_Game_book_type.getDataById(infoIndex)
	
	if (not _tbRecommendPartnerInfo[infoIndex]) then
		_tbRecommendPartnerInfo[infoIndex] = {}
		_tbRecommendPartnerInfo[infoIndex].heroList = {}
		_tbRecommendPartnerInfo[infoIndex].heroInfo = {}
		local tbPartner = string.split(dbInfo.hero_id, "|")
		for i,v in ipairs(tbPartner) do
			_tbRecommendPartnerInfo[infoIndex].heroList[i] = tonumber(v)
			local dbHeroInfo = HeroUtil.getHeroLocalInfoByHtid(tonumber(v))
			_tbRecommendPartnerInfo[infoIndex].heroInfo[i] = {}
			_tbRecommendPartnerInfo[infoIndex].heroInfo[i].name = dbHeroInfo.name
			_tbRecommendPartnerInfo[infoIndex].heroInfo[i].desc = dbHeroInfo.place_desc
			_tbRecommendPartnerInfo[infoIndex].heroInfo[i].quality = dbHeroInfo.quality
		end
	end

	return _tbRecommendPartnerInfo[infoIndex]
end

--[[desc: 获取我要变强界面的信息
    arg1: 提升的类型
    return: 对应的信息  
—]]
function wantStrong( infoIndex )
	local dbInfo = DB_Game_book_way.getArrDataByField( "type", infoIndex )
	if (not _tbWantStrongInfo[infoIndex]) then
		_tbWantStrongInfo[infoIndex] = {}
		for k,v in pairs(dbInfo) do
			local tbData = {}
			tbData.name = v.way_name
			tbData.desc = v.way_desc
			tbData.imgPath = v.way_icon
			_tbWantStrongInfo[infoIndex][#_tbWantStrongInfo[infoIndex] + 1] = tbData
		end
	end
	
	return _tbWantStrongInfo[infoIndex]	
end

--[[desc:获取伙伴图鉴界面信息
    arg1: 伙伴的品质
    return: 对应的信息
—]]
function partnerDictionary( infoIndex )
	local dbInfo = DB_Show.getDataById(infoIndex)

	if (not _tbHashFromPurple or not _tbHashFromOrange) then
		_tbHashFromOrange = {}
		_tbHashFromPurple = {}
		local dbHeroBreak = DB_Hero_break.Hero_break
		logger:debug({dbHeroBreak = dbHeroBreak})
		for k,v in pairs(dbHeroBreak) do 
			_tbHashFromPurple[v[1]] = v[2]
			_tbHashFromOrange[v[2]] = v[1]
		end
	end

	if (not _tbPartnerDictionary[infoIndex]) then
		_tbPartnerDictionary[infoIndex] = {}

		local tbPartner = string.split(dbInfo.item_array, ",")
		local tbPartnerDeal = {}
		-- 初始化数据
		for k,v in pairs(tbPartner) do
			local dbHeroInfo = HeroUtil.getHeroLocalInfoByHtid(tonumber(v))
			tbPartnerDeal[k] = {id = tonumber(v), 
								bHad = bHavePartner(tonumber(v)), 
								name = dbHeroInfo.name, 
								quality = dbHeroInfo.quality, 
								fragmentId = tonumber(dbHeroInfo.fragment),
								canBreak = false
								}
			-- 如果是橙色的，检查是否由紫色突破而来
			if (tbPartnerDeal[k].quality == 6 and _tbHashFromOrange[tbPartnerDeal[k].id]) then
				tbPartnerDeal[k].canBreak = not tbPartnerDeal[k].bHad
			end
			-- 如果是紫色，检查是否拥有橙色的，并添加是否可突破字段
			if (tbPartnerDeal[k].quality == 5 and _tbHashFromPurple[tbPartnerDeal[k].id]) then
				local orangeId = _tbHashFromPurple[tbPartnerDeal[k].id]
				-- 根据heroes表里面的break_id字段判断是否有这个橙将
				local breakToId = DB_Heroes.getDataById(tbPartnerDeal[k].id).break_id
				if (breakToId and not bHavePartner(tonumber(orangeId))) then
					tbPartnerDeal[k].canBreak = true
				end
			end
		end
		-- 排序
		local function sortFunc( tb1, tb2 )
			return (tb1.bHad and not tb2.bHad)
		end
		table.sort(tbPartnerDeal, sortFunc)
		-- 将数据插入结果table中
		local tbData = {}
		for i,v in ipairs(tbPartnerDeal) do
			tbData[#tbData + 1] = v
			if ((i-1)%3 == 2) then
				_tbPartnerDictionary[infoIndex][#_tbPartnerDictionary[infoIndex] + 1] = tbData
				tbData = {}
			end
		end
		if ((#tbData < 3) and (#tbData > 0)) then
			_tbPartnerDictionary[infoIndex][#_tbPartnerDictionary[infoIndex] + 1] = tbData
			tbData = {}
		end 
	end

	logger:debug({_tbPartnerDictionary = _tbPartnerDictionary})

	return _tbPartnerDictionary[infoIndex]
end

--[[desc:根据index获得伙伴图鉴拥有的数量和总数
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function partnerDictionaryNum( infoIndex )
	if (not _tbPartnerNum[infoIndex]) then
		local tbPartnerData = partnerDictionary(infoIndex)
		logger:debug({tbPartnerData = tbPartnerData})
		local tbData = {hadNum = 0, totalNum = 0}

		for k,v in pairs(tbPartnerData) do
			for i,j in pairs(v) do
				if (j.bHad) then
					tbData.hadNum = tbData.hadNum + 1
				end
				tbData.totalNum = tbData.totalNum + 1
			end
		end

		_tbPartnerNum[infoIndex] = tbData
	end

	return _tbPartnerNum[infoIndex]
end

