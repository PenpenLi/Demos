-- FileName: ShipStrengthCtrl.lua
-- Author: LvNanchun
-- Date: 2015-10-19
-- Purpose: function description of module
--[[TODO List]]

module("ShipStrengthCtrl", package.seeall)
require "script/module/ship/shipStrength/ShipStrengthModel"
require "script/module/ship/shipStrength/ShipStrengthView"

-- UI variable --

-- module local variable --
local _viewInstance
local _i18n = gi18n

local function init(...)

end

function destroy(...)
    package.loaded["ShipStrengthCtrl"] = nil
end

function moduleName()
    return "ShipStrengthCtrl"
end

-- 关闭按钮回调
local function fnCloseBtn( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playBackEffect()
		require "script/module/ship/ShipMainCtrl"
		ShipMainCtrl.create(ShipStrengthModel.getShipId(), "main")
	end
end

--[[desc:刷新界面
    arg1: 无
    return: 无
—]]
function resetView()
	local tbResetInfo = {}
	-- 获取当前的强化等级
	local strengthLevel = ShipStrengthModel.getStrengthLevel()
	tbResetInfo.strengthLevel = strengthLevel

	-- 获取左边界面的显示信息
	local nowInfo = ShipStrengthModel.getAttrInfoByLevel(strengthLevel)
	tbResetInfo.nowInfo = nowInfo

	-- 若屏蔽了触摸则恢复触摸
	_viewInstance:removeShieldLay()

	-- 判断是否达到最大等级
	if (strengthLevel < ShipStrengthModel.getStrLevelLimit()) then
		tbResetInfo.isMax = false
		-- 获取右边界面的显示信息
		tbResetInfo.nextInfo = ShipStrengthModel.getAttrInfoByLevel(strengthLevel + 1)
		-- 显示强化材料面板的信息
		tbResetInfo.strengthItemInfo = ShipStrengthModel.getStrItemByLevel(strengthLevel)
		-- 强化不需要物品
		if (tbResetInfo.strengthItemInfo.itemNeedNum == 0) then
			tbResetInfo.itemFree = true
		else
			tbResetInfo.itemFree = false
			tbResetInfo.strengthItemInfo.fnIconBtn = function ( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					PublicInfoCtrl.createItemDropInfoViewByTid(tbResetInfo.strengthItemInfo.item.id)
				end
			end
		end
		-- 强化不需要贝里
		if (tonumber(tbResetInfo.strengthItemInfo.belly) == 0) then
			tbResetInfo.bellyFree = true
		else
			tbResetInfo.bellyFree = false
		end

		-- 构建传入强化成功界面的数据
		local tbStrSuccess = {}
		tbStrSuccess.preLevel = tbResetInfo.strengthLevel
		tbStrSuccess.preAttr = tbResetInfo.nowInfo
		tbStrSuccess.nowAttr = tbResetInfo.nextInfo
		tbStrSuccess.shipAniId = ShipStrengthModel.getShipAniNumber()

		-- 强化网络回调
		local function strNetworkCallBack( cbFlag, dictData, bRet )
			if (bRet) then
				require "script/module/ship/ShipData"
				-- 强化1级修改数据
				ShipData.setShipStrengthLevel(ShipStrengthModel.getShipId())
				-- 删除贝里
				UserModel.addSilverNumber(-tbResetInfo.strengthItemInfo.belly)
				-- 修改战斗力
				UserModel.setInfoChanged(true)
				UserModel.updateFightValue()
				updateInfoBar()
				_viewInstance:performWithDelay(1/60, function ( ... )
					-- 刷新强化界面
					-- resetView()
				end)
				
				_viewInstance:addStrengthAni(function ( ... )
					require "script/module/ship/shipStrength/ShipStrengthSuccessView"
					local successViewInstance = ShipStrengthSuccessView:new()
					local successView = successViewInstance:create( tbStrSuccess )
					LayerManager.addLayout(successView)
					-- _viewInstance:removeShieldLay()
					resetView()
				end)
			else
				_viewInstance:removeShieldLay()
			end
		end

		-- 强化按钮回调时间
		local function btnStrCallBack( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCommonEffect()
				local tbArgs = Network.argsHandler(ShipStrengthModel.getShipId(), 1)
				if (UserModel.getSilverNumber() >= tbResetInfo.strengthItemInfo.belly) then
					_viewInstance:addShieldLay()
					RequestCenter.mainship_strengthen(strNetworkCallBack, tbArgs)
				else
					require "script/module/public/ShowNotice"
					PublicInfoCtrl.createItemDropInfoViewByTid(60406,nil,true) -- 贝里掉落界面
					ShowNotice.showShellInfo(_i18n[1057])
				end
			end
		end
		-- 判断物品数量是否满足要求
		if (tbResetInfo.strengthItemInfo.itemHaveNum >= tbResetInfo.strengthItemInfo.itemNeedNum) then
			tbResetInfo.isEnough = true
			tbResetInfo.fnStrBtn = btnStrCallBack
		else
			tbResetInfo.isEnough = false
			tbResetInfo.fnStrBtn = function ( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					AudioHelper.playCommonEffect()
					require "script/module/public/ShowNotice"
					ShowNotice.showShellInfo(_i18n[1409])
					PublicInfoCtrl.createItemDropInfoViewByTid(tbResetInfo.strengthItemInfo.item.id, nil, true)
				end
			end
		end
	else
		tbResetInfo.isMax = true
		tbResetInfo.fnStrBtn = function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCommonEffect()
				require "script/module/public/ShowNotice"
				ShowNotice.showShellInfo(_i18n[1620])
			end
		end
	end

	_viewInstance:resetView( tbResetInfo )
end

--[[desc:
    arg1: nowShip传入当前界面的船的id
    return: 是否有返回值，返回值说明  
—]]
function create( nowShip )
	ShipStrengthModel.setStrengthInfo()
	ShipStrengthModel.setNowShipId(nowShip)
	local viewInstance = ShipStrengthView:new()
	_viewInstance = viewInstance

	-- 构建界面
	resetView()

	local tbCreateInfo = {}
	tbCreateInfo.fnCloseBtn = fnCloseBtn

	local mainView = viewInstance:create( tbCreateInfo )
	LayerManager.changeModule(mainView, moduleName(), {1})
	PlayerPanel.addForPartnerStrength()
end

