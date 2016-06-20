-- FileName: ImpelDownSweepReward.lua
-- Author: Xufei and LvNanchun
-- Date: 2015-09-17
-- Purpose: 深海监狱扫荡奖励窗
--[[TODO List]]

ImpelDownSweepReward = class("ImpelDownSweepReward")

-- UI控件引用变量 --
local _layMain = nil
-- 模块局部变量 --
local _fnGetWidget = g_fnGetWidgetByName
local _i18n = gi18n

function ImpelDownSweepReward:ctor( ... )
	self.layMain = g_fnLoadUI("ui/impel_down_sweep.json")
end

function ImpelDownSweepReward:destroy(...)
	package.loaded["ImpelDownSweepReward"] = nil
end

function ImpelDownSweepReward:moduleName()
    return "ImpelDownSweepReward"
end

function ImpelDownSweepReward:initListView( rewardInfo )
	logger:debug({rewardInfo= rewardInfo})
	local tbShowReward = {}
	if (rewardInfo.belly and tonumber(rewardInfo.belly) ~= 0) then
		table.insert(tbShowReward, {icon = ItemUtil.getSiliverIconByNum(tonumber(rewardInfo.belly)) , name = _i18n[1520]})
		
	end
	if (rewardInfo.prison and tonumber(rewardInfo.prison) ~= 0) then
		table.insert(tbShowReward, {icon = ItemUtil.getPrisonGoldIconByNum(tonumber(rewardInfo.prison)) , name = _i18n[7032]})
	end
	if (tostring(rewardInfo.strReward) ~= "") then
		require "script/module/public/RewardUtil"
		local tbReward = RewardUtil.parseRewards(rewardInfo.strReward)
		for k,v in pairs(tbReward) do 
			table.insert(tbShowReward, v)
		end
	end

	logger:debug({tbShowReward = tbShowReward})

	UIHelper.initListView(_layMain.LSV_REWARD_BIG)

	for i=1,(math.ceil((#tbShowReward)/4)) do
		_layMain.LSV_REWARD_BIG:pushBackDefaultItem()

		local cell = _layMain.LSV_REWARD_BIG:getItem(i-1)

		for j = 1, 4 do 
			local itemWidget = _fnGetWidget(cell, ("lay_reward_bg" .. tostring(j)))
			local itemInfo = tbShowReward[(i - 1) * 4 + j]
			if (itemInfo) then
				itemWidget.IMG_ICON:addChild(itemInfo.icon)
				itemWidget.TFD_NAME:setText(itemInfo.name)
			else
				itemWidget:setVisible(false)
			end
		end
	end


end

function ImpelDownSweepReward:create(startLayer, endLayer)
	_layMain = self.layMain


	logger:debug({startReward = startLayer,
		endReward = endLayer})


	UIHelper.registExitAndEnterCall(_layMain,
		function()
			_layMain=nil
		end,
		function()
		end
	)


	UIHelper.titleShadow(_layMain.BTN_GET, _i18n[1324])

	

	-- local startFightLayerId 
	-- local endFightLayerId 
	local endLayerId
	-- if (ImpelDownMainModel.isBoxLayerById(startLayer)) then
	-- 	if (startLayer == ImpelDownMainModel.getTotalNumOfLayer()) then
	-- 		startFightLayerId = ImpelDownMainModel.getFightLayerIdByNormalId(startLayer-1)
	-- 	else
	-- 		startFightLayerId = ImpelDownMainModel.getFightLayerIdByNormalId(startLayer+1)
	-- 	end
	-- else
	-- 	startFightLayerId = ImpelDownMainModel.getFightLayerIdByNormalId(startLayer)
	-- end
	if (ImpelDownMainModel.isBoxLayerById(endLayer)) then
		-- endFightLayerId = ImpelDownMainModel.getFightLayerIdByNormalId(endLayer-1)
		endLayerId = endLayer-1
	else
		-- endFightLayerId = ImpelDownMainModel.getFightLayerIdByNormalId(endLayer)
		endLayerId = endLayer
	end	
	-- if (endFightLayerId<startFightLayerId) then
	-- 	endFightLayerId = startFightLayerId
	-- end
	if (ImpelDownMainModel.isBoxLayerById(startLayer) and endLayer == startLayer) then
		_layMain.tfd_desc_1:setText(_i18n[7033])
		_layMain.tfd_desc_2:setText(_i18n[7034])
		_layMain.tfd_desc_3:setText(_i18n[7035])
	else
		_layMain.tfd_desc_1:setText(_i18n[7036])
		_layMain.tfd_desc_2:setText(ImpelDownMainModel.getLayerNameById(endLayerId))
		_layMain.tfd_desc_3:setText(_i18n[7035])
	end

	local rewardInfo = ImpelDownMainModel.getRewardArrayById(startLayer, endLayer)
	self:initListView(rewardInfo)

	local function onObtainReward( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()		
			local function obtainSweepRewardCallback( cbFlag, dictData, bRet )
				if (bRet) then
					UserModel.addSilverNumber( tonumber(rewardInfo.belly) )
					UserModel.addImpelDownNum( tonumber(rewardInfo.prison) )

					ShowNotice.showShellInfo(_i18n[7037])
					ImpelDownMainModel.updateDataWhenObtainReward()
					LayerManager.removeLayout()
					GlobalNotify.postNotify("IMPEL_DOWN_UPDATE_TIP")
				end
			end

			local tbRewardData = RewardUtil.getItemsDataByStr(rewardInfo.strReward)
			-- 判断背包是否已满
			for k,v in pairs(tbRewardData) do
				if (tonumber(v.tid) ~= 0 and ItemUtil.bagIsFullWithTid(v.tid, true)) then
					return
				end
			end

			RequestCenter.impelDown_obtainSweepReward(obtainSweepRewardCallback)
		end
	end
	_layMain.BTN_GET:addTouchEventListener(onObtainReward)


	return _layMain
end

