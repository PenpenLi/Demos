-- FileName: FormationData.lua  ::  CardPirate 
-- Author: mabingtao
-- Date: 14-4-1
-- Purpose: function description of module

-- $Id: FormationData.lua 136610 2016-01-06 15:13:56Z NanchunLv $

module("FormationData", package.seeall)

require "script/utils/LuaUtil"
require "script/network/RequestCenter"
require "db/DB_Normal_config"

local m_beginSquadData
local m_beginBenchData
local myFormationData
local tblFormation = {}
local tblBench = {}
local mChangeFhid
local mChangeBhid
local mBenchChanged
local mDataCache = DataCache

local _dbNormal = DB_Normal_config

function fnBenchChanged( ... )
	return mBenchChanged
end

--获取bench当前开启了几个
function fnGetBenchOpenNum( ... )
	local pinfo = DB_Formation.getDataById(1).openBenchByLv or ""
	local pArr = string.split(pinfo, ",") or {}
	local pLv = tonumber(UserModel.getHeroLevel()) or 1
	local pCount = 0
	for k,v in pairs(pArr) do
		local ppArr = string.split(v, "|") or {}
		local ppLv = tonumber(ppArr[1]) or 100
		if(pLv >= ppLv) then
			pCount = pCount + 1
		end
	end
	return pCount
end

-- 初始化获取阵型信息
local  function fnCreateFormationData( cbFlag, dictData, bRet  )
	if (dictData.err == "ok") then
		myFormationData = dictData.ret
		if(not myFormationData) then
			myFormationData = mDataCache.getFormationInfo()
			local pFormationData = mDataCache.getFormationInfo() or {}
			for k,v in pairs(pFormationData) do
				myFormationData[k] = v
			end
		end

		local pBench = mDataCache.getBench() or {}
		for k,v in pairs(pBench) do
			m_beginBenchData[k] = v
		end
		local pSquad = mDataCache.getSquad() or {}
		for k,v in pairs(pSquad) do
			m_beginSquadData[k] = v
		end

		Buzhen.createFromation()
	end
end


local function fnSetFormation( cbFlag, dictData, bRet  )
	if (dictData.err == "ok") then
		myFormationData = tblFormation
		local formationInfo = {}
		for k,v in ipairs(myFormationData) do
			formationInfo["" .. (tonumber(k)-1)] = tonumber(v)
		end
		mDataCache.setFormationInfo(formationInfo)
	end

	Buzhen.createFromation()
	tblFormation = {}
end


function changePos( pos1 , pos2 )
	tblFormation = {}
	if ( (not myFormationData[pos1]) or (not myFormationData[pos2]) ) then
		Buzhen.createFromation()
		return false
	end
	
	for k ,v in pairs(myFormationData) do 
		tblFormation[k] = v
	end

	local posData = tblFormation[pos1]
	tblFormation[pos1] = tblFormation[pos2]
	tblFormation[pos2] = posData

	local formationArr = CCArray:create()
	local arrFormation = CCArray:create()
	for k,v in pairs(tblFormation) do
		if (v == nil) then 
			v = 0
		end
 		local num = CCInteger:create(tonumber(v))
 		arrFormation:insertObject(num , k-1)
 		num:release()
 	end
 	formationArr:addObject(arrFormation)
 	RequestCenter.setFormationInfo(fnSetFormation , formationArr)

	
	arrFormation:release()
	formationArr:release()
	return true

end

function addToFromation( heroid )
	for i = 0,5 do
        local curHid = myFormationData.i 
        if (curHid == nil ) then
        	print(i)
        end
    end
end

--[[desc:替补互换后的回调
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
local function fnSetBench( cbFlag, dictData, bRet )
	if (dictData.err == "ok") then
		mBenchChanged = true
		mDataCache.setBench(tblBench)
	end
	Buzhen.createFromation()
	tblBench = {}
end

--[[desc:布阵中替补之间互换位置
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function fnChangeBench( pos1, pos2 )
	tblBench = {}
	local pnum = tonumber(fnGetBenchOpenNum()) or 0
	if ( (pos1 >= pnum) or (pos2 >= pnum) ) then
		logger:debug("pos1 or  pos2 data  nil" .. tostring(pos1) .. " , " .. tostring(pos2))
		Buzhen.createFromation()
		return false
	end
	
	local pBenchData = mDataCache.getBench()
	for k = 1 , pnum do 
		local key = (k-1) .. ""
		tblBench[key] = pBenchData[key] or 0
	end

	local posData = tblBench[pos1 .. ""] or 0 
	tblBench[pos1 .. ""] = tblBench[pos2 .. ""] or 0
	tblBench[pos2 .. ""] = posData

	local formationArr = CCArray:create()
	local arrFormation = CCArray:create()

	for k = 1, pnum do
		local key = (k-1) .. ""
		local v = tblBench[key]
		if (v == nil) then 
			v = 0
		end
 		local num = CCInteger:create(tonumber(v))
 		arrFormation:insertObject(num , k - 1)
 		num:release()
 	end
 	formationArr:addObject(arrFormation)
	RequestCenter.formation_setBench(fnSetBench , formationArr)

	arrFormation:release()
	formationArr:release()
end

local function fnCannotUse( pos )
	local pType = tonumber(pos) > 6 and 2 or 1
	local pPos
	local mHave = false
	local pHid = 0
	if(pType == 1) then
		pPos = tonumber(pos)
		pHid = tonumber(myFormationData[pPos]) or 0
	elseif(pType == 2) then
		pPos = tonumber(pos) - 6 - 1
		local pBenchData = mDataCache.getBench()
		pHid = tonumber(pBenchData[pPos .. ""]) or 0
	end
	local pHero = HeroModel.getHeroByHid(pHid) or nil
 	if(not pHero) then
 		mHave = true
 	end
	logger:debug("mHave = " .. tostring(mHave) .. " pType = " .. pType .. " pPos = " .. pPos .. " , pHid : " .. pHid)
	return mHave , pType , pPos
end

--[[desc:阵容和替补互换的回调
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
local function fnSwapCallBack( cbFlag, dictData, bRet )
	if (dictData.err == "ok") then
		mBenchChanged = true
		mDataCache.setBench(tblBench)

		myFormationData = tblFormation
		local formationInfo = {}
		for k,v in ipairs(myFormationData) do
			formationInfo["" .. (tonumber(k)-1)] = tonumber(v)
		end
		mDataCache.setFormationInfo(formationInfo)

		local pData = mDataCache.getSquad()
		for k,v in pairs(pData) do
			if(tonumber(v) == mChangeFhid) then
				pData[k] = mChangeBhid
			end
		end
		mDataCache.setSquad(pData)
		local pData = mDataCache.getSquad()
	end
	Buzhen.createFromation()
	tblFormation = {}
	tblBench = {}
end

function fnSwapForBen( pos1, pos2 )
	local mCannot1 , mType1 , mpos1 = fnCannotUse(pos1)
	local mCannot2 , mType2 , mpos2 = fnCannotUse(pos2)
	if( mCannot1 or mCannot2 ) then
		ShowNotice.showShellInfo(gi18n[5310])
		Buzhen.createFromation()
		return false
	end

	for k ,v in pairs(myFormationData) do 
		tblFormation[k] = v
	end

	local pBenchData = mDataCache.getBench()
	for k ,v in pairs(pBenchData) do 
		tblBench[k] = v
	end

	local f_pos = mType1 == 1 and mpos1 or mpos2
	local b_pos = mType2 == 2 and mpos2 or mpos1
	-- local 111


	mChangeBhid = tonumber(tblBench[b_pos .. ""])
	mChangeFhid = tonumber(tblFormation[f_pos])

	tblBench[b_pos .. ""] = mChangeFhid
	tblFormation[f_pos] = mChangeBhid

	local args = Network.argsHandler(mChangeFhid, mChangeBhid)
	RequestCenter.formation_swapForBen(fnSwapCallBack, args)

end

function  getData( ... )
	return myFormationData , mDataCache.getBench()
end

function fnUpdateMainFormation( ... )
	mBenchChanged = false
	local pCurPage = tonumber(MainFormation.fnGetHeroPageCurIndex()) or -1
	pCurPage = pCurPage + 1
	local pSquadData = mDataCache.getSquad()
	for k,v in pairs(pSquadData) do
		local pNow = tonumber(v) or 0
		local pOld = tonumber(m_beginSquadData[k]) or 0
		if(pNow ~= pOld) then
			local pKey = tonumber(k) + 1
			local pChange = (pKey ~= pCurPage)
    		MainFormation.updateFormation(pKey, pNow , pChange , true)
		end
	end

	local formationNum = MainFormationTools.fnGetSquadNum() + MainFormationTools.fnGetBenchNum()
	local pBenchData = mDataCache.getBench()
	for k,v in pairs(pBenchData) do
		local pNow = tonumber(v) or 0
		local pOld = tonumber(m_beginBenchData[k]) or 0
		if(pNow ~= pOld) then
			local pKey = tonumber(k) + formationNum
			local pChange = (pKey ~= pCurPage)
    		MainFormation.updateFormation(pKey , pNow , pChange , true)
		end
	end
end

function init( ... )
	m_beginBenchData = {}
	m_beginSquadData = {}
	mBenchChanged = false
    RequestCenter.getFormationInfo(fnCreateFormationData)
end

function  destroy( ... )
end

