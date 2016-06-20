-- FileName: MineInfoCtrl.lua
-- Author: zhangqi
-- Date: 2015-04-11
-- Purpose: 矿点信息显示的主控模块

module("MineInfoCtrl", package.seeall)
require "script/module/mine/MineInfoView"
require "script/module/mine/MineConst"
require "script/module/mine/MineUtil"
require "db/DB_Res"
-- UI控件引用变量 --

-- 模块局部变量 --
local _instanceView = nil
local _tPitInfo = {}
local function init(...)
	_instanceView = nil
end

function destroy(...)
	package.loaded["MineInfoCtrl"] = nil
end

function moduleName()
    return "MineInfoCtrl"
end

-- 整理数据增加 db 相关数据
local function preData(tInfo)
	local db_data = DB_Res.getDataById(tInfo.domain_id)
	local tKey = {"res_type", "res_name", "res_attr", "res_icon",}
	for i,v in ipairs(tKey) do
		tInfo[v] = db_data[v .. tInfo.pit_id]
	end
	tInfo.res_attr = string.split(tInfo.res_attr, ",")
end


function refresh( tPitInfo, infoType)
	if tonumber(tPitInfo.domain_id) == tonumber(_tPitInfo.domain_id) and 
		tonumber(tPitInfo.pit_id) == tonumber(_tPitInfo.pit_id) then
		if _instanceView then
			local infoType = infoType or MineConst.MineInfoType.MINE_NONE
			local tbInfo = {}
			_tPitInfo = tPitInfo
			tbInfo =  table.hcopy(tPitInfo, tbInfo)
			preData(tbInfo)
			tbInfo.infoType = infoType
			logger:debug({huxiaozhou = tbInfo})

			_instanceView:refreshUI(tbInfo)
		end
	end
	
end

-- 矿坑信息, 资源矿类型
function create(tPitInfo, infoType)

	assert(tPitInfo.domain_id, "tInfo.domain_id 为nil")

	local infoType = infoType or MineConst.MineInfoType.MINE_NONE
	local tbInfo = {}
	_tPitInfo = tPitInfo
	tbInfo =  table.hcopy(tPitInfo, tbInfo)
	preData(tbInfo)
	tbInfo.infoType = infoType
	logger:debug({tbInfo = tbInfo})
	init()
	_instanceView = MineInfoView:new()
	local layView = _instanceView:create(tbInfo)
	UIHelper.registExitAndEnterCall(layView, function (  )
		_instanceView = nil
	end)

	return layView
end
