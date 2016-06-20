-- FileName: ChooseGiftCtrl.lua
-- Author: zhangqi
-- Date: 2015-07-30
-- Purpose: 选择礼物控制模块
--[[TODO List]]

module("ChooseGiftCtrl", package.seeall)

require "script/module/bag/ChooseGiftView"

-- UI控件引用变量 --

-- 模块局部变量 --

local function init(...)

end

function destroy(...)
	package.loaded["ChooseGiftCtrl"] = nil
end

function moduleName()
    return "ChooseGiftCtrl"
end

function create(tbGift)
	logger:debug({ChooseGiftCtrl_create_tbGift = tbGift})

	local dbItem = tbGift.itemDesc
	-- logger:debug({dbItem_choose_reward = dbItem.choose_reward})
	-- dbItem.choose_reward		7|410031|1,7|410015|1,7|410016|1,7|410032|1

	local tbArgs = {}
	tbArgs.items = {} -- 可选择物品列表数据

	local cfgGift, tbItem = nil, nil
	for i, strGift in ipairs(string.strsplit(dbItem.choose_reward, ",")) do
		cfgGift = string.strsplit(strGift, "|")

		tbItem = {}
		-- tbItem.item_type = tonumber(cfgGift[1])
		tbItem.htid = cfgGift[2]
		tbItem.num = tonumber(cfgGift[3])

		local dbItem = ItemUtil.getItemById(tbItem.htid)

		tbItem.name = dbItem.name
		tbItem.quality = dbItem.quality -- 2015-11-21，名称颜色用品质
		tbItem.giftStr = strGift

		 -- opt_id表示选中的物品序号，后端要求从0开始
		tbItem.getArgs =  {gid = tonumber(tbGift.gid), item_id = tonumber(tbGift.item_id), opt_id = i - 1}

		tbArgs.items[i] = tbItem
	end

	tbArgs.GetCallback = function ( tbArgs )
		logger:debug({GetCallback_tbArgs = tbArgs})
		local args = {tbArgs.rpcArgs.gid, tbArgs.rpcArgs.item_id, tbArgs.rpcArgs.opt_id}
		logger:debug({GetCallback_args = args})

		LayerManager.addUILoading() -- 添加屏蔽

		PreRequest.setBagDataChangedDelete(MainBagCtrl.refreshPropList) -- 注册后端推送背包信息时的回调，以便刷新道具列表，红色圆圈提示等

		local arrArgs = Network.argsHandlerOfTable(args)
		RequestCenter.bag_useGift(function ( cbFlag, dictData, bRet )
			LayerManager.begainRemoveUILoading() -- 移除屏蔽

			if (bRet) then
				LayerManager.removeLayout() -- 关闭物品选择面板

				local tbUseData = {err = "ok"} -- 构造调用使用物品回调的信息
				tbUseData.ret = {giftSelectStr = tbArgs.giftStr}
				MainBagCtrl.useItemCallback(cbFlag, tbUseData, true)
			end
		end, arrArgs)
	end

	local view = ChooseGiftView:new()
	return view:create(tbArgs)
end
