-- FileName: passCopyReward.lua
-- Author: liweidong
-- Date: 2014-12-19
-- Purpose: 通关某个据点后可领取的宝箱奖励
--[[TODO List]]

module("passCopyReward", package.seeall)

require "script/module/copy/copyData"
require "script/module/public/ItemUtil"
require "script/module/public/PublicInfoCtrl"
require "script/model/user/UserModel"

-- UI控件引用变量 --
local rewardLayer -- 主界面

-- 模块局部变量 --
local nReceived --领取状态，= 1为已领取，2为未领取,3为未开启
local tbBaseInfo --进入的副本数据
local copyDifficulty = 1 --副本难度
local copyBaseId =  1 --据点id

local m_tbBagFull  -- 所有需要调用的背包满的函数，zhangqi, 2014-07-11

-- ui文件名称 --
local jsonReward = "ui/copy_stronghold_box.json"
local jsonGetReward = "ui/copy_get_reward.json"


function destroy(...)
	package.loaded["passCopyReward"] = nil
end

function moduleName()
    return "passCopyReward"
end




function moduleName()
	return "copyReward"
end

-- 初始函数，加载UI资源文件，
function create( rewardStatus,tbitemInfo,difficult,baseID)
	nReceived = tonumber(rewardStatus)
	tbBaseInfo = tbitemInfo
	copyDifficulty=tonumber(difficult)
	copyBaseId=tonumber(baseID)

	--加载主背景UI
	rewardLayer = g_fnLoadUI(jsonReward)
	if (rewardLayer) then
		UIHelper.registExitAndEnterCall(rewardLayer,
				function()
					rewardLayer=nil
				end,
				function()
				end
			)
		-- local tfdTitle = g_fnGetWidgetByName(rewardLayer, "tfd_title")
		-- UIHelper.labelAddStroke(tfdTitle,gi18n[1312],ccc3(0x4f,0x14,0x00),2)
		-- UIHelper.labelShadow(tfdTitle,CCSizeMake(3,-3))
		init()
	end

	return rewardLayer
end

--点击领取按钮
local function onGetReward( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		-- for k, v in pairs(m_tbBagFull) do -- zhangqi, 2014-07-11, 只执行需要调用的背包满检查，而不是所有背包
		-- 	if ( k(true) ) then
		-- 		return
		-- 	end
		-- end
		-- 检查背包是否已满 
		if (ItemUtil.isBagFull(true)) then
			return
		end

		local args = Network.argsHandler( copyBaseId,copyDifficulty)
		requestCopyReward(args)
		-- AudioHelper.playCommonEffect()
		AudioHelper.playBtnEffect("tansuo02.mp3")
	end
end

--奖励物品预览
local function fnRewardGoods( layerReward , saveReward)
	local rewardKey={"simple_box","normal_box","hard_box"}
	local tbGoodsTmp=tbBaseInfo[rewardKey[tonumber(copyDifficulty)]]
	logger:debug({tbGoodsTmp=tbGoodsTmp})
	if(tbGoodsTmp ~= nil) then
		-- local goodsTemp = lua_string_split(tbGoodsTmp,",")
		local reward = RewardUtil.parseRewards(tbGoodsTmp,saveReward)
		-- local goodsInfo= RewardUtil.getItemsDataByTb(tbGoodsTmp)
		logger:debug({reward=reward})
		for i=1,4 do
			if (i <= #reward) then
				local goodsImg = g_fnGetWidgetByName(layerReward, "IMG_"..i, "ImageView")
				local goodsTitle = g_fnGetWidgetByName(layerReward, "TFD_NAME_"..i, "Label")
				goodsImg:addChild(reward[i].icon)
				goodsTitle:setText(reward[i].name)
				local color =  g_QulityColor[tonumber(reward[i].quality)]
				if(color ~= nil) then
					goodsTitle:setColor(color)
				end
			else
				local dropLayer = g_fnGetWidgetByName(layerReward, "LAY_DROP"..i, "Layout")
				if (dropLayer) then
					dropLayer:setVisible(false)
				end
			end
		end
	end
end
local function fnGetRewardGoods()
	local rewardKey={"simple_box","normal_box","hard_box"}
	local tbGoodsTmp=tbBaseInfo[rewardKey[tonumber(copyDifficulty)]]
	logger:debug({tbGoodsTmp=tbGoodsTmp})
	if(tbGoodsTmp ~= nil) then
		-- local goodsTemp = lua_string_split(tbGoodsTmp,",")
		local reward = RewardUtil.parseRewards(tbGoodsTmp,true)
		local brow = UIHelper.createGetRewardInfoDlg(gi18n[1312], reward, function()
				LayerManager.removeLayout()
			end)
		LayerManager.addLayout(brow)
	end
end
--确认点击
local function onReurnBase( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		LayerManager.removeLayout()
		AudioHelper.playCloseEffect()
	end
end

local function fncloseLayout( layout )
	local closeBtn = g_fnGetWidgetByName(layout, "BTN_CLOSE", "Button")
	if  (closeBtn) then
		closeBtn:addTouchEventListener(onReurnBase)
	end
end

-- 初始加载配置数据
function init( ... )

	m_tbBagFull = {}

	--关闭按钮
	fncloseLayout(rewardLayer)

	--奖励物品
	fnRewardGoods(rewardLayer)

	--领取奖励条件
	local getBtn = g_fnGetWidgetByName(rewardLayer, "BTN_GET", "Button")
	local unrecedImg = g_fnGetWidgetByName(rewardLayer, "IMG_RECEIVED", "ImageView")

	--nReceived --领取状态，= 1为已领取，2为未领取,3为未开启
	logger:debug("get pass reward status====" .. nReceived)
	if (nReceived==1) then
		getBtn:setEnabled(false)
		getBtn:setVisible(false)
	end
	if (nReceived==2) then
		unrecedImg:setVisible(false)
	end
	if (nReceived==3) then
		getBtn:setTouchEnabled(false)
		getBtn:setBright(false)

		unrecedImg:setVisible(false)
	end
	UIHelper.titleShadow(getBtn,gi18n[1315])
	getBtn:addTouchEventListener(onGetReward)

	--领取条件描述

	-- local passLable = g_fnGetWidgetByName(rewardLayer, "TFD_PASS")
	-- passLable:setText(string.format(gi18n[1968],tbBaseInfo.name))
	-- UIHelper.labelStroke(passLable)
end

-----------数据请求与返回处理
--处理奖励数据
local function fnUpRewardData( ... )
	local rewardKey={"simple_box","normal_box","hard_box"}
	local tbGoodsTmp=tbBaseInfo[rewardKey[tonumber(copyDifficulty)]]

	if(tbGoodsTmp ~= nil) then
		local goodsTemp = lua_string_split(tbGoodsTmp,",")
		for i=1,4 do
			if (i <= #goodsTemp) then
				local dropIds = lua_string_split(goodsTemp[i],"|")
				local num = tonumber(dropIds[3])
				local itemType = tonumber(dropIds[1])
				if(itemType == 2) then
					UserModel.addSilverNumber(num)
				elseif(itemType == 1) then
					UserModel.addGoldNumber(num)
				end
			end
		end
	end
end

--奖励回调
local function getRewardCallback( cbFlag, dictData, bRet )
	if(dictData.err ~= "ok") then
		return
	end
	LayerManager.removeLayout()
	fncloseLayout(rewgetLayer)
	fnGetRewardGoods()
	require "script/module/copy/itemCopy"
	itemCopy.doPassBoxState(copyBaseId)
end

--领取副本奖励请求
function requestCopyReward(parama)
	RequestCenter.ncopy_getPassPrize(getRewardCallback,parama)
end
