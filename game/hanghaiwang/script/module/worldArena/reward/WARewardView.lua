-- FileName: WARewardView.lua
-- Author: Xufei
-- Date: 2016-02-18
-- Purpose: 奖励预览
--[[TODO List]]

WARewardView = class("WARewardView")

-- UI控件引用变量 --

-- 模块局部变量 --
local _fnGetWidget = g_fnGetWidgetByName

function WARewardView:showPreview( ... )
	local tabNum = WARewardModel.getTabNum()
	for i = 1, 3 do
		local btnTab = _fnGetWidget(self.layMain, "BTN_REWARD"..i)
		btnTab:setFocused(i == tonumber(tabNum))
		btnTab:setTouchEnabled(i ~= tonumber(tabNum))
		btnTab:setTag(i)
		btnTab:addTouchEventListener(WARewardCtrl.getBtnFunByName("onChooseTab"))
	end
	local tabNowInfo = WARewardModel.getNowTabInfo()
	logger:debug({nowTabInfo = tabNowInfo})
	self.listView:removeAllItems()
	for k,v in ipairs (tabNowInfo) do
		self.listView:pushBackDefaultItem()
		local listIndex = k-1
		local listCell = self.listView:getItem(listIndex)
		listCell.TFD_RANK:setText(v.desc)
		UIHelper.initListView(listCell.LSV_REWARD_LIST)
		local rewardTb = RewardUtil.parseRewards(v.DBOnlyRewards)
		for k1,v1 in ipairs(rewardTb) do
			listCell.LSV_REWARD_LIST:pushBackDefaultItem()
			local rewardIndex = k1-1
			local rewardCell = listCell.LSV_REWARD_LIST:getItem(rewardIndex)
			local layIcon = rewardCell.LAY_REWARD
			local imgIcon = v1.icon
			--imgIcon:setPosition(ccp(layIcon.IMG_REWARD:getContentSize().width / 2 , layIcon.IMG_REWARD:getContentSize().height / 2))
			layIcon.IMG_REWARD:removeAllChildrenWithCleanup(true)
			layIcon.IMG_REWARD:addChild(imgIcon)
			layIcon.TFD_REWARD_NAME:setColor(g_QulityColor[v1.quality])
			layIcon.TFD_REWARD_NAME:setText(v1.name)
		end
		UIHelper.setSliding( listCell.LSV_REWARD_LIST )
	end
	self.listView:jumpToPercentVertical(0)
	UIHelper.setSliding( self.listView )
end

function WARewardView:setBtnEvent( ... )
	self.layMain.BTN_CLOSE:addTouchEventListener(WARewardCtrl.getBtnFunByName("onClose"))
	self.layMain.BTN_CONFIRM:addTouchEventListener(WARewardCtrl.getBtnFunByName("onConfirm"))	
end

function WARewardView:init(...)
	self.layMain = nil
end

function WARewardView:destroy(...)
	package.loaded["WARewardView"] = nil
end

function WARewardView:moduleName()
    return "WARewardView"
end

function WARewardView:ctor( ... )
	self:init()
	self.layMain = g_fnLoadUI("ui/reward_preview.json")
end

function WARewardView:create(...)
	UIHelper.registExitAndEnterCall(self.layMain,
		function()
			self.layMain = nil
		end,
		function()
		end
	)
	self.listView = self.layMain.LSV_LIST
	self.listView.BTN_REWARD_BG:setTouchEnabled(false)
	UIHelper.initListView(self.listView)

	UIHelper.titleShadow( self.layMain.BTN_CONFIRM )
	
	self:showPreview()
	self:setBtnEvent()
	return self.layMain
end
