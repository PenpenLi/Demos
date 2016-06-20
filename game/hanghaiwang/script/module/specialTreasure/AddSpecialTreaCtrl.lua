-- FileName: AddSpecialTreaCtrl.lua
-- Author: yucong
-- Date: 2015-09-16
-- Purpose: 专属宝物选择列表
--[[TODO List]]

module("AddSpecialTreaCtrl", package.seeall)

require "script/module/specialTreasure/FormationSpecialModel"
require "script/module/public/ChooseList"
require "script/module/public/Cell/TreasureCell"
require "script/module/specialTreasure/AddSpecialTreaCell"
require "script/module/specialTreasure/SpecialConst"
require "script/module/specialTreasure/AddSpecialTreaRequest"
require "script/module/public/DropUtil"

local m_i18n = gi18n
local _sModel = FormationSpecialModel
local _aRequest = AddSpecialTreaRequest
local _partnerInstance = nil

local _view = nil

function onBtnLoad( data )
	addExclusive(_sModel.getHid(), data)
end

-- 上阵
function addExclusive( hid, data )
	logger:debug({addExclusive = data})
	_aRequest.addExclusive(hid, tonumber(SpecialConst.SPECIAL_POS), data.item_id, data.equip_hid, function ( ... )
		-- 
		local tbHeroes = HeroModel.getAllHeroes()
		local heroInfo = tbHeroes[tostring(hid)]
		-- 抢来穿处理
		if (data.equip_hid) then
			local ownerInfo = tbHeroes[tostring(data.equip_hid)]
			ownerInfo.equip.exclusive = {}
			-- 计算被抢那货的战斗力
			_sModel.calcFightForce(data.equip_hid)
		end
		-- 转换拥有人
		data.equip_hid = hid
		-- 修改阵容数据
		heroInfo.equip.exclusive[SpecialConst.SPECIAL_POS] = data
		-- 计算当前伙伴战斗力
		_sModel.calcFightForce(hid)
											
		LayerManager.removeLayout()
		if (_partnerInstance) then
			local fnAffterLoadLayer = _partnerInstance:getfnAffterLoadLayer()
			-- 针对伙伴信息去选择列表的处理
			if (fnAffterLoadLayer) then
				fnAffterLoadLayer()
				-- 重置回调
				_partnerInstance:resetChoseReCallFn()
			end
		end
	end)
end

function createDatas( ... )
	local tbEventListener = {}

	tbEventListener.onBack = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playBackEffect()
			GlobalNotify.postNotify(SpecialConst.MSG_SPECIAL_SELECT_CLOSED)
			LayerManager.removeLayout()
			if (_partnerInstance) then
				local fnreAddPartnerInfoLayer = _partnerInstance:getReAddFn()
				-- 针对伙伴信息去选择列表的处理
				if (fnreAddPartnerInfoLayer) then
					fnreAddPartnerInfoLayer()
					-- 重置回调
					_partnerInstance:resetChoseReCallFn()
				end
			end
		end
	end

	local instTableView
	local tbInfo = {}
	tbInfo.sType = CHOOSELIST.LOADSPECIAL
	tbInfo.onBack = tbEventListener.onBack
	tbInfo.tbView = {}
	tbInfo.tbView.szCell = g_fnCellSize(CELLTYPE.SPECIAL)
	tbInfo.tbView.tbDataSource = _sModel.getDataSource()
	tbInfo.tbView.CellAtIndexCallback = function (tbDat)
		logger:debug({tbDat = tbDat})
		local instCell = AddSpecialTreaCell:new()
		instCell:init(CELL_USE_TYPE.LOAD)
		instCell:refresh(tbDat)
		return instCell
	end

	tbInfo.tbView.CellTouchedCallback = function ( view, cell, objCell)

	end
	return tbInfo
end

-------------- init --------------
local function init(...)
	_view = nil
end

function destroy(...)
	_view = nil
	_partnerInstance = nil
	package.loaded["AddSpecialTreaCtrl"] = nil
end

function moduleName()
    return "AddSpecialTreaCtrl"
end

function create(hid, partnerInstance)
	_sModel.setHid(hid)
	_sModel.handleDatas(onBtnLoad)
	_partnerInstance = partnerInstance
	
	local datas = createDatas()
	_view = ChooseList:new()
	local mainLayer = _view:create(datas)
	return mainLayer

end

-------------- notify -------------
function fnRELOAD_DATA( ... )
	logger:debug("fnRELOAD_DATA")
	_sModel.sortDatas()
	_view:changeDataSource(_sModel.getDataSource())
	_view:refresh()	
end
