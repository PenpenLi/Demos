-- FileName: AccLoginCtrl.lua
-- Author: yucong
-- Date: 2015-11-11
-- Purpose: 累计登录活动ctrl
--[[TODO List]]

module("AccLoginCtrl", package.seeall)
require "script/module/wonderfulActivity/AccumulateLogin/AccLoginView"
require "script/module/wonderfulActivity/AccumulateLogin/AccLoginModel"
require "script/module/wonderfulActivity/AccumulateLogin/AccLoginRequest"

local AccLoginModel = AccLoginModel
local _mainInstance = nil
local _mainLayer = nil

local function init(...)

end

function destroy(...)
	_mainInstance = nil
	_mainLayer = nil
	AccLoginModel.setCell(nil)
	package.loaded["AccLoginCtrl"] = nil
end

function moduleName()
    return "AccLoginCtrl"
end

function create(...)
	-- 拉取信息
	AccLoginRequest.getAccLoginInfo(getAccLoginInfoOK)
end

--------------- btn callback ---------------
-- 领取
function onBtnGain( sender, eventType ) 
	if (eventType == TOUCH_EVENT_ENDED) then
		if (AccLoginModel.isClosed()) then
			AudioHelper.playCommonEffect()
			ShowNotice.showShellInfo("本轮累计登录活动已结束！")--"本轮累计登录活动已结束！"
			return
		end
		AudioHelper.playTansuo02()
		local day = sender:getTag()
		local tRewards = AccLoginModel.getRewards()
		local rewardType = AccLoginModel.getRewardTypeWithDay(day)
		logger:debug("rewardType:"..rewardType)
		if (rewardType == 1) then 	-- 直接领取
			AccLoginRequest.getAccLoginGift(sender:getTag(), 0, function ( data )
				getAccLoginGiftOK(sender:getTag())
			end)
		elseif (rewardType == 2) then -- 选择领取
			ChooseItemCtrl.create(tRewards[day], ChooseItemCtrl.kTYPE_GAIN, function ( selectIndex )
				logger:debug("selectIndex:"..selectIndex)
				AccLoginRequest.getAccLoginGift(sender:getTag(), selectIndex + 1, function ( data )
					getAccLoginGiftOK(sender:getTag(), selectIndex + 1)
				end)
				-- getAccLoginGiftOK(day, selectIndex + 1)
			end)
		end
		
	end
end

---------------- request callback ---------------
-- 拉取信息回调
function getAccLoginInfoOK( data )
	logger:debug("AccLogin getAccLoginInfo")
	logger:debug(data)
	AccLoginModel.setAccData(data)
	if (not _mainLayer) then
		-- 创建界面
		_mainInstance = AccLoginView:new()
		_mainLayer = _mainInstance:create()
		MainWonderfulActCtrl.addLayChild(_mainLayer)

		-- 移除new
		local listCell = AccLoginModel.getCell()
		if (listCell) then
			listCell:removeNodeByTag(100)
		end

		-- 不再显示new
		AccLoginModel.setNewAniState(1)
	end
	_mainInstance:reload_lsv()
	_mainInstance:reload_countdown()
end

-- 领取奖励回调
function getAccLoginGiftOK( day, goodIndex )
	AccLoginModel.missionComplete(day)
	_mainInstance:reload_lsv()

	-- 创建奖励界面
	local tRewards = AccLoginModel.getRewards()
	local tItem = RewardUtil.parseRewards(tRewards[day], true)
	if (goodIndex) then
		tItem = {tItem[goodIndex]}
	end
	LayerManager.addLayoutNoScale(UIHelper.createRewardDlg(tItem))

	-- 红点数量
	local IMG_TIP = WonderfulActModel.tbBtnActList["accLogin"]
	local num = AccLoginModel.getTipCount()
	IMG_TIP:setVisible(num > 0 and true or false)
	IMG_TIP.LABN_TIP_EAT:setStringValue(tostring(num))
end

