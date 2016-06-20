-- FileName: SaleBoxModel.lua
-- Author: lvnanchun
-- Date: 2015-08-20
-- Purpose: 限时宝箱业务逻辑
--[[TODO List]]

module("SaleBoxModel", package.seeall)
require "db/DB_Sale_box"

-- UI variable --
local _btnIcon

-- module local variable --
local _tbInfo
local _tbBoxState = {}
local _tbRemainTime = {}
local _nId
local _nStartTime
local _nEndTime
local _serverInfo = g_tbServerInfo
local _listCell
local _userDefault = g_UserDefault

local function init(...)

end

function destroy(...)
    package.loaded["SaleBoxModel"] = nil
end

function moduleName()
    return "SaleBoxModel"
end

function create(...)

end

--[[desc:在手机中存储是否曾经访问过这个按钮
    arg1: 访问状态
    return: 无  
—]]
function setNewAniState( nState )
	_userDefault:setIntegerForKey("new_saleBox_visible"..UserModel.getUserUid(), nState)
end

--[[desc:获取是否访问过这个按钮的状态
    arg1: 无
    return: 储存的状态  
—]]
function getNewAniState()
	return _userDefault:getIntegerForKey("new_saleBox_visible"..UserModel.getUserUid())
end

--[[desc:获取上面listView中的按钮
    arg1: 按钮
    return: 无
—]]
function setIconBtn( cell, btnIcon )
	_btnIcon = btnIcon
	_listCell = cell
end

--[[desc:返回之前获取的按钮
    arg1: 无
    return: 按钮
—]]
function getIconBtn(  )
	return _btnIcon
end

--[[desc:返回按钮的cell
    arg1: 无
    return: cell的控件
—]]
function getBtnCell(  )
	return _listCell
end

--[[desc:获取db信息
    arg1: 后端拉取的活动id
    return: 无
—]]
local function setDBInfoById( infoId )
	_tbInfo = DB_Sale_box.getDataById(infoId)
	logger:debug({_tbInfo = _tbInfo})
end

--[[desc:是否显示按钮开启活动
    arg1: 无
    return: boolen 
—]]
function bShowBtnIcon(  )
	local tbNowTime , nNowTime = TimeUtil.getServerDateTime()
	local nOpenTime = tonumber(_serverInfo.openDateTime)
	local bOpen = false
	logger:debug({_serverInfo = _serverInfo})

	for k,v in pairs(DB_Sale_box.Sale_box) do
		local strTimeConfig = DB_Sale_box.getDataById(v[1]).time
		local strId = DB_Sale_box.getDataById(v[1]).id
		local tbTimeConfig = string.split(strTimeConfig , '|')
		local startDay = tonumber(tbTimeConfig[1])
		local endDay = tonumber(tbTimeConfig[2])
		local startTime = nOpenTime + (startDay - 1) * 24 * 60 * 60
		local endTime = nOpenTime + (endDay) * 24 * 60 * 60
		local endTime = endTime - (endTime - 8*3600)%86400 + 8*3600
		logger:debug("SaleBoxTime")
		logger:debug(nNowTime)
		logger:debug(startTime)
		logger:debug(endTime)
		if ((startTime <= nNowTime) and (endTime >= nNowTime)) then
			bOpen = true
			_nId = tonumber(strId)
			_nStartTime = startTime
			_nEndTime = endTime
			break
		end
	end

	logger:debug({bOpen = bOpen})

	return bOpen
end

--[[desc:获取剩余时间
    arg1: 无
    return: strTime剩余时间的字符串 ， bEnd是否结束
—]]
function getContinueTime(  )
	require "script/utils/NewTimeUtil"
	local _ , bEnd , nSecond = NewTimeUtil.expireTimeString( _nEndTime )

	logger:debug({_nEndTime = _nEndTime})
	logger:debug({bEnd = bEnd})

	local strTime
	if not (bEnd) then
		strTime = NewTimeUtil.getTimeDesByInterval( nSecond )
	else
		strTime = "0"
	end

	return strTime , bEnd
end

--[[desc:手动设置剩余次数减去1，用于点击按钮时更新前端数据
    arg1: 宝箱的index
    return: 无
—]]
function setReaminTime( boxIndex )
	if (boxIndex) then
		_tbRemainTime[tonumber(boxIndex)] = _tbRemainTime[tonumber(boxIndex)] - 1
	end
end

--[[desc:根据之前设置的后端次数数据和配置中的总次数设置当前剩余次数
    arg1: 无
    return: 无
—]]
local function setTbRemainTime()
	if not (_tbInfo) then
		setDBInfoById(_nId)
	end

	if (table.isEmpty(_tbBoxState)) then
		_tbRemainTime = {}
	else
		_tbRemainTime[1] = _tbInfo["box1_num"] - (tonumber(_tbBoxState[1]))
		_tbRemainTime[2] = _tbInfo["box2_num"] - (tonumber(_tbBoxState[2]))
		_tbRemainTime[3] = _tbInfo["box3_num"] - (tonumber(_tbBoxState[3]))
	end
end

--[[desc:获取后端数据
    arg1: 后端数据table，id指开启的id，1为一个table{start_time , end_time}两个时间戳，2为一个table{},2中1，2，3表示不同宝箱对应开启情况
    return: 无 
—]]
function setSaleBoxInfo( tbSaleBoxInfo )
	_tbBoxState[1] = 0
	_tbBoxState[2] = 0
	_tbBoxState[3] = 0
	for k,v in pairs(tbSaleBoxInfo) do
		if (v.num) then
			_tbBoxState[tonumber(k)] = tonumber(v.num)
		end
	end

	setTbRemainTime()
end

--[[desc:拉取活动开启时间
    arg1: 拉取回调
    return: 无 
—]]
function pullSaleBoxInfo( fnCallBack )
	local function saleBoxInfoCallBack( cbFlag, dictData, bRet )
		if (bRet) then
			SaleBoxModel.setSaleBoxInfo(dictData.ret)
			if (fnCallBack) then
				fnCallBack()
			end
		end
	end
	RequestCenter.chest_getChestInfo(saleBoxInfoCallBack)
end

--[[desc:每日结束直接从配置表更新数据，不需从后端再次拉取数据
    arg1: 无
    return: 无  
—]]
function setRemainEveryDay( )
	_tbBoxState[1] = 0
	_tbBoxState[2] = 0
	_tbBoxState[3] = 0

	setTbRemainTime()
end

--[[desc:获取某一宝箱的剩余次数
    arg1: 宝箱index
    return: 剩余次数
—]]
function getRemainTime( boxIndex )
	return _tbRemainTime[tonumber(boxIndex)]
end

--[[desc:是否显示红点
    arg1: 无
    return: boolen
—]]
function bShowRedPoint( )
	return false
	-- 应策划需求不显示红点了 2015-12-8 吕南春
--	if (bShowBtnIcon()) then
--		if ( table.isEmpty(_tbRemainTime) ) then
--			return true
--		else
--			return not (_tbRemainTime[1] + _tbRemainTime[2] + _tbRemainTime[3] == 0)
--		end
--	else
--		return false
--	end
end

--[[desc:功能简介
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function nGetRedPointNum()
	local nRed = 3
	if (bShowBtnIcon()) then
		if ( table.isEmpty(_tbRemainTime) ) then
			pullSaleBoxInfo(function ( ... )
				for k,v in pairs(_tbRemainTime) do 
					if (tonumber(v) == 0) then
						nRed = nRed - 1
					end
				end 

				performWithDelay(_btnIcon , function ( ... )
					require "script/module/wonderfulActivity/WonderfulActModel"
					local mainActivity = WonderfulActModel.tbBtnActList.saleBox
					mainActivity:setVisible(true)
					mainActivity.LABN_TIP_EAT:setStringValue(nRed)
					if (nRed == 0) then 
						mainActivity.IMG_TIP:setVisible(false)
					end
				end , 1/60)
			end)
			return "3"
		else
			for k,v in pairs(_tbRemainTime) do 
				if (tonumber(v) == 0) then
					nRed = nRed - 1
				end
			end 

			return nRed
		end
	end
end

--[[desc:获取某一宝箱显示的全部信息
    arg1: 无
    return: 包含全部信息的table
—]]
function getCellInfo()
	local tbInfo = {}
	if not (_tbInfo) then
		setDBInfoById(_nId)
	end

	for i=1,3 do
		tbInfo["cellInfo"..tostring(i)] = {}
		tbInfo["cellInfo"..tostring(i)].name = _tbInfo["box"..tostring(i).."_name"]
		tbInfo["cellInfo"..tostring(i)].des = _tbInfo["box"..tostring(i).."_des"]
		tbInfo["cellInfo"..tostring(i)].oricost = _tbInfo["box"..tostring(i).."_oricost"]
		tbInfo["cellInfo"..tostring(i)].discount = _tbInfo["box"..tostring(i).."_discount"]
		tbInfo["cellInfo"..tostring(i)].num = _tbInfo["box"..tostring(i).."_num"]
		tbInfo["cellInfo"..tostring(i)].numLeft = getRemainTime(i)
		tbInfo["cellInfo"..tostring(i)].imagePath = "images/salebox/".._tbInfo["box"..tostring(i).."_icon"]
	end

	return tbInfo
end
