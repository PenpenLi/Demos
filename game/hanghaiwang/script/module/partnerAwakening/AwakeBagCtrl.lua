-- FileName: AwakeBagCtrl.lua
-- Author: LvNanchun
-- Date: 2015-11-11
-- Purpose: 觉醒背包控制器
--[[TODO List]]

module("AwakeBagCtrl", package.seeall)
require "script/module/public/Bag"

-- UI variable --

-- module local variable --
local _bagInstance
local _awakeHandler
local _gi18nString = gi18nString
local _nExpandNum = 5

local function init(...)
	require "script/module/public/Bag/BagModel" 
	_awakeHandler = BagModel.getBagHandler(BAG_TYPE_STR.awake)
end

function destroy(...)
    package.loaded["AwakeBagCtrl"] = nil
end

function moduleName()
    return "AwakeBagCtrl"
end

--[[desc:扩充按钮回调事件
    arg1: 
    return: 无  
—]]
function fnExpandCallBack()
	local nIndex = 1
	local expData = {{itype = 7, i18nWarn = 7419, i18nRet = 1010, goldNeed = BagUtil.getNextOpenAwakeGridPrice()}, -- 后端请求参数
					}
	local strMsg = _gi18nString(expData[nIndex].i18nWarn, _nExpandNum, expData[nIndex].goldNeed)

	local function expandCallback( cbFlag, dictData, bRet )
		if (bRet) then
			UserModel.addGoldNumber(- expData[nIndex].goldNeed)
			ShowNotice.showShellInfo(_gi18nString(expData[nIndex].i18nRet, expData[nIndex].goldNeed, _nExpandNum))
			DataCache.addGidNumBy( expData[nIndex].itype, _nExpandNum) -- 修改背包信息里的携带数

			if (LayerManager.curModuleName() == moduleName()) then
				local extIndex = nIndex
				if (_bagInstance.mBtnIndex == nIndex) then
					extIndex = nil -- 如果是在背包里回调的扩充事件，nil 指定更新最大数，否则只提示扩充不更新最大数
				end

				_bagInstance:updateMaxNumber(_awakeHandler:getMaxNum(), extIndex) -- 刷新携带数
				logger:debug({maxNum = _awakeHandler:getMaxNum()})
			end
		end
	end

	local function onConfirm ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			if (expData[nIndex].goldNeed <= UserModel.getGoldNumber()) then
				local args = Network.argsHandler(_nExpandNum, expData[nIndex].itype) -- nIndex=1, 开启宝物格子; 2, 开启道具格子
				logger:debug({args = args})
				RequestCenter.bag_openGridByGold(expandCallback, args)
				LayerManager.removeLayout()
			else -- 金币不足, 弹提示充值面板
				LayerManager.removeLayout() -- 关闭扩充提示面板
				LayerManager.addLayout(UIHelper.createNoGoldAlertDlg())
			end
		end
	end

	LayerManager.addLayout(UIHelper.createCommonDlg(strMsg, nil, onConfirm))
end


--[[desc:获取觉醒物品的配置
    arg1: 无
    return: 觉醒物品的配置
—]]
function getAwakeConfig()
	local tbView = {}

	tbView.szCell = g_fnCellSize(CELLTYPE.AWAKE)
	tbView.tbDataSource = _awakeHandler:getListData()

	tbView.CellAtIndexCallback = function (tbData, idx, objView)
		local instCell = AwakeCell:new(objView)
		instCell:init(CELL_USE_TYPE.BAG)
		instCell:bagHandler(_awakeHandler)

		_awakeHandler:fillOne(tbData) -- 补全每个元素的其他字段

		instCell:refresh(tbData)
		return instCell
	end

	return tbView
end

function create( nTabIndex )
	init()

	-- 构造bag类需要的数据
	local tbBagInfo = {sType = BAGTYPE.AWAKE, expands = {1}, nums = {1}}
	tbBagInfo.onExpand = fnExpandCallBack
	tbBagInfo.tbTab = {{}} -- 宝物列表，宝物碎片列表
	local awakeList = tbBagInfo.tbTab[1]  -- 宝物列表数据
	awakeList.tbView = getAwakeConfig()
	awakeList.nMaxNum = _awakeHandler:getMaxNum()

	_bagInstance = Bag.create(tbBagInfo, nTabIndex or 1)
	local bagView = _bagInstance.mainList

	_awakeHandler:setBagObject(_bagInstance)

	LayerManager.changeModule(bagView, moduleName(), {1, 3}, true)
	PlayerPanel.addForPartnerStrength()
end

