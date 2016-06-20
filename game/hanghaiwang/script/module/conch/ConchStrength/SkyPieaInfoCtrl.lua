-- FileName: SkyPieaInfoCtrl.lua
-- Author: liweidong
-- Date: 2015-02-27
-- Purpose: 显示空岛贝信息界面的代理，向外部提供调用接口
--[[TODO List]]

module("SkyPieaInfoCtrl", package.seeall)
require "script/module/conch/ConchStrength/SkyPieaInfoView"
-- UI控件引用变量 --

-- 模块局部变量 --

local function init(...)

end

function destroy(...)
	package.loaded["SkyPieaInfoCtrl"] = nil
end

function moduleName()
    return "SkyPieaInfoCtrl"
end

local function fnGetConchInfo( tbConch, tbAllUse, nlevel )
	local pConchInfo = tbConch
	pConchInfo.itemDesc = DB_Item_conch.getDataById(pConchInfo.item_template_id)
	pConchInfo.lv = pConchInfo.va_item_text.level or 0
	return pConchInfo
end

-- 阵容中展示装备信息
function createForFormation(tbConch ,n_curPageNum, isChangeBtnTip)
	local pInfo = fnGetConchInfo(tbConch)
	local layConch = SkyPieaInfoView.create(pInfo,1, isChangeBtnTip)
	LayerManager.addLayout(layConch)
end

-- 查看他人阵容中展示装备信息，tbAllUse是一个人物已穿戴的所有装备信息
function createForOtherFormation( tbConch, tbAllUse, nlevel)
	local pInfo = fnGetConchInfo(tbConch, tbAllUse, nlevel)
	local layConch = SkyPieaInfoView.create(pInfo,2)
	LayerManager.addLayout(layConch)
end

-- 装备列表中展示装备信息
function createForConch( tbConch )
	local pInfo = fnGetConchInfo(tbConch)
	local layConch = SkyPieaInfoView.create(pInfo,3)
	LayerManager.addLayout(layConch)
end

-- 装备列表中展示装备信息
function createForConchItemInfo( dbConch )
	local tbConch = {lv = 0, itemDesc = dbConch}
	tbConch.va_item_text = {level = 0,exp = 0}
	tbConch.item_template_id = tbConch.itemDesc.id
	local layConch = SkyPieaInfoView.create(tbConch,2)
	LayerManager.addLayout(layConch)
end

function create(...)

end
