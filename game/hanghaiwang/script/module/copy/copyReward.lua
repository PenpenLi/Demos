-- FileName: copyReward.lua
-- Author: xianghuiZhang
-- Date: 2014-04-03
-- Purpose: 副本星数宝箱领取

module("copyReward", package.seeall)

require "script/module/copy/copyData"
require "script/module/public/ItemUtil"
require "script/module/public/PublicInfoCtrl"
require "script/model/user/UserModel"

-- UI控件引用变量 --
local rewardLayer -- 主界面

-- 模块局部变量 --
local nTagValue --领取奖励的tag
local nReceived --领取状态，= 1为已领取，0为未领取
local nCurScore --当前分数
local tbCopyInfo --进入的副本数据
local copyDifficulty = 1 --副本难度

local m_tbBagFull  -- 所有需要调用的背包满的函数，zhangqi, 2014-07-11
local m_i18n=gi18n
-- ui文件名称 --
local jsonReward = "ui/copy_reward.json"
local jsonGetReward = "ui/copy_get_reward.json"

function moduleName()
	return "copyReward"
end

-- 初始函数，加载UI资源文件，
function create( nTag,strReced,strScore,tbitemInfo,difficult)
	nTagValue = nTag
	nReceived = tonumber(strReced)
	nCurScore = tonumber(strScore)
	tbCopyInfo = tbitemInfo
	copyDifficulty=difficult

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

	require "script/module/guide/GuideModel"
	require "script/module/guide/GuideCopyBoxView"
	if (GuideModel.getGuideClass() == ksGuideCopyBox and GuideCopyBoxView.guideStep == 1) then
		require "script/module/guide/GuideCtrl"
		GuideCtrl.createCopyBoxGuide(2)
	end
	require "script/module/guide/GuideCopy2BoxView"
	if (GuideModel.getGuideClass() == ksGuideCopy2Box and GuideCopy2BoxView.guideStep == 1) then
		require "script/module/guide/GuideCtrl"
		GuideCtrl.createCopy2BoxGuide(2)
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

		local args = Network.argsHandler( tbCopyInfo.id,copyDifficulty,nTagValue)
		requestCopyReward(args)
		AudioHelper.playBtnEffect("tansuo02.mp3")
	end
end

--奖励物品预览
local function fnRewardGoods( layerReward )
	local boxId=copyDifficulty
	boxId=boxId==1 and "" or boxId
	local tbGoodsTmp
	if (nTagValue == 3) then
		tbGoodsTmp = tbCopyInfo["pt_box"..boxId]
	elseif (nTagValue == 2) then
		tbGoodsTmp = tbCopyInfo["au_box"..boxId]
	else
		tbGoodsTmp = tbCopyInfo["ag_box"..boxId]
	end

	if(tbGoodsTmp ~= nil) then
		-- local goodsTemp = lua_string_split(tbGoodsTmp,",")
		local reward = RewardUtil.parseRewards(tbGoodsTmp)
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
				
				-- local info = ItemUtil.getItemById(tonumber(goodsInfo[i].id))
				-- -- 如果此物品有对应的背包满检查方法，就存到一个set里，用于后面领取前的背包满检测
				-- if (info.fnBagFull) then
				-- 	m_tbBagFull[info.fnBagFull] = true
				-- end
				
			else
				local dropLayer = g_fnGetWidgetByName(layerReward, "LAY_DROP"..i, "Layout")
				if (dropLayer) then
					dropLayer:setVisible(false)
				end
			end
		end
	end
end

--确认点击
local function onReurnBase( sender, eventType )
	-- if (eventType == TOUCH_EVENT_ENDED) then
		LayerManager.removeLayout()
		require "script/module/guide/GuideModel"
		require "script/module/guide/GuideCopyBoxView"
		if (GuideModel.getGuideClass() == ksGuideCopyBox and GuideCopyBoxView.guideStep == 3) then
			require "script/module/guide/GuideCtrl"
			GuideCtrl.createCopyBoxGuide(4)
		end

		require "script/module/guide/GuideCopy2BoxView"
		if (GuideModel.getGuideClass() == ksGuideCopy2Box and GuideCopy2BoxView.guideStep == 3) then
			require "script/module/guide/GuideCtrl"
			GuideCtrl.createCopy2BoxGuide(4)
		end

		--AudioHelper.playCloseEffect()
	-- end
end
local function onClose( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCloseEffect()
		onReurnBase()
	end
end

local function fncloseLayout( layout )
	local closeBtn = g_fnGetWidgetByName(layout, "BTN_CLOSE", "Button")
	if  (closeBtn) then
		closeBtn:addTouchEventListener(onClose)
	end
end

-- 初始加载配置数据
function init( ... )

	m_tbBagFull = {}

	--关闭按钮
	fncloseLayout(rewardLayer)

	--奖励物品
	fnRewardGoods(rewardLayer)

	local starTemp = lua_string_split(tbCopyInfo.starlevel,",")
	local starNum = tonumber(starTemp[nTagValue])

	--领取奖励条件
	local getBtn = g_fnGetWidgetByName(rewardLayer, "BTN_GET", "Button")
	local unrecedImg = g_fnGetWidgetByName(rewardLayer, "IMG_CANNOTGET", "ImageView")
	if  (getBtn and unrecedImg) then
		if (nCurScore >= starNum) then
			if (nReceived == 0 ) then
				unrecedImg:setVisible(false)
				getBtn:addTouchEventListener(onGetReward)
			else
				local recedImg = g_fnGetWidgetByName(rewardLayer, "IMG_RECEIVED", "ImageView")
				getBtn:setVisible(false)
				getBtn:setEnabled(false)
				recedImg:setVisible(true)
				unrecedImg:setVisible(false)
			end
		else
			UIHelper.setWidgetGray(unrecedImg,true)
			unrecedImg:setVisible(true)
			getBtn:setVisible(false)
			getBtn:setEnabled(false)
			local tfdcannot = g_fnGetWidgetByName(unrecedImg, "TFD_CANNOTGET")
			tfdcannot:setText(gi18n[1315])
			UIHelper.labelShadow(tfdcannot)
			local recedImg = g_fnGetWidgetByName(rewardLayer, "IMG_RECEIVED", "ImageView")
			recedImg:setVisible(false)
		end
		UIHelper.titleShadow(getBtn,gi18n[1315])
	end

	--头部星数
	local getStar = g_fnGetWidgetByName(rewardLayer, "TFD_NUM")
	if  (getStar and starNum ~= nil) then
		getStar:setText(starNum)
	end
end

-----------数据请求与返回处理
--处理奖励数据
local function fnUpRewardData( ... )
	local boxId=copyDifficulty
	boxId=boxId==1 and "" or boxId
	local tbGoodsTmp
	if (nTagValue == 3) then
		tbGoodsTmp = tbCopyInfo["pt_box"..boxId]
	elseif (nTagValue == 2) then
		tbGoodsTmp = tbCopyInfo["au_box"..boxId]
	else
		tbGoodsTmp = tbCopyInfo["ag_box"..boxId]
	end

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

--显示获得的奖励
function showRewardDialog(drop)
	local boxId=copyDifficulty
	boxId=boxId==1 and "" or boxId
	local tbGoodsTmp
	if (nTagValue == 3) then
		tbGoodsTmp = tbCopyInfo["pt_box"..boxId]
	elseif (nTagValue == 2) then
		tbGoodsTmp = tbCopyInfo["au_box"..boxId]
	else
		tbGoodsTmp = tbCopyInfo["ag_box"..boxId]
	end
	
	local items = {}
	-- local rewardKey={"simple_box","normal_box","hard_box"}
	-- local tbGoodsTmp=tbBaseInfo[rewardKey[tonumber(copyDifficulty)]]
	-- logger:debug({tbGoodsTmp=tbGoodsTmp})
	if(tbGoodsTmp ~= nil) then
		-- local goodsTemp = lua_string_split(tbGoodsTmp,",")
		items = RewardUtil.parseRewards(tbGoodsTmp,true)
	end
	local brow = UIHelper.createGetRewardInfoDlg(gi18n[1312], items, onReurnBase)
	LayerManager.addLayout(brow)
end
--奖励回调
local function getRewardCallback( cbFlag, dictData, bRet )
	if(dictData.err ~= "ok") then
		return
	end
	LayerManager.removeLayout()
	-- fnUpRewardData()
	local treasureData = dictData.ret
	logger:debug("copy reward data:")
	logger:debug(treasureData)
	showRewardDialog(treasureData)
	
	require "script/module/copy/itemCopy"
	itemCopy.doBoxState(nTagValue)

	require "script/module/guide/GuideModel"
	require "script/module/guide/GuideCopyBoxView"
	if (GuideModel.getGuideClass() == ksGuideCopyBox and GuideCopyBoxView.guideStep == 2) then
		require "script/module/guide/GuideCtrl"
		GuideCtrl.createCopyBoxGuide(3)
		GuideCtrl.setPersistenceGuide("copyBox","9")
	end

	require "script/module/guide/GuideCopy2BoxView"
	if (GuideModel.getGuideClass() == ksGuideCopy2Box and GuideCopy2BoxView.guideStep == 2) then
		require "script/module/guide/GuideCtrl"
		GuideCtrl.createCopy2BoxGuide(3)
	end
end

--领取副本奖励请求
function requestCopyReward(parama)
	RequestCenter.ncopy_getPrize(getRewardCallback,parama)
end


-- 析构函数，释放纹理资源
function destroy( ... )

end
