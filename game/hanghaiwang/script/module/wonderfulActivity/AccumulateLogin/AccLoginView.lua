-- FileName: AccLoginView.lua
-- Author: yucong
-- Date: 2015-11-11
-- Purpose: 累计登录活动
--[[TODO List]]

AccLoginView = class("AccLoginView")

require "script/module/public/GlobalNotify"

-- 模块局部变量 --
local m_i18n	= gi18n
local m_fnGetWidget = g_fnGetWidgetByName
local _model = AccLoginModel

AccLoginView._mainLayer = nil
AccLoginView._goodsClone1 = nil
AccLoginView._goodsClone2 = nil

function AccLoginView:notifications( ... )
	return {
		[_model.MSG_CLOSED]	= function () self:fnMSG_CLOSED() end,
	}
end

function AccLoginView:fnUpdate( ... )
	--self:reload_countdown()
	-- 倒计时判断活动是否结束
	_model.getCountDown()
end

function AccLoginView:ctor()

end

function AccLoginView:create( ... )
	self._mainLayer = g_fnLoadUI("ui/activity_total_login.json")
	self._mainLayer.img_main_bg:setScaleX(g_fScaleX) -- 背景图适配
	self._mainLayer.img_chunjie_bottom:setScale(g_fScaleX)

	-- 注册onExit()
	UIHelper.registExitAndEnterCall(self._mainLayer, function ( ... )
		self:removeObserver()
		GlobalScheduler.removeCallback("AccLoginView")
		AccLoginCtrl.destroy()
		if (self._goodsClone1) then
			self._goodsClone1:release()
			self._goodsClone1 = nil
		end
		if (self._goodsClone2) then
			self._goodsClone2:release()
			self._goodsClone2 = nil
		end
    end, function ( ... )
    	-- 开启计时器
		GlobalScheduler.addCallback("AccLoginView", function ( ... )
			self:fnUpdate()
		end)
		self:addObserver()
    end)
    self:createFrame()

    self:reload_countdown()

	return self._mainLayer
end

function AccLoginView:addObserver( ... )
	for msg, func in pairs(self:notifications()) do
		GlobalNotify.addObserver(msg, func, false, "AccLoginView")
	end
end

function AccLoginView:removeObserver( ... )
	for msg, func in pairs(self:notifications()) do
		GlobalNotify.removeObserver(msg, "AccLoginView")
	end
end

function AccLoginView:createFrame( ... )
	self:initListView()

	local dbData = _model.getDBData()
	--self._mainLayer.TFD_DESC:setText(dbData.desc)
	self._mainLayer.tfd_time:setText(m_i18n[7302])--活动时间：
	UIHelper.labelNewStroke(self._mainLayer.tfd_time, ccc3(0x28, 0x00, 0x00), 2)
	--self._mainLayer.img_title:loadTexture("images/wonderfullAct/"..dbData.title)
	local layer1 = self._mainLayer.LAY_INFO1
	local layer2 = self._mainLayer.LAY_INFO2
	layer1:setVisible(tonumber(dbData.LAY) == 1)
	layer2:setVisible(tonumber(dbData.LAY) == 2)
	layer1.TFD_DESC:setText(dbData.desc)
	layer2.TFD_DESC:setText(dbData.desc)
end

function AccLoginView:initListView( ... )
	self._goodsClone1 = self._mainLayer.LSV_TOTAL.LSV_GOODS.LAY_CLONE1:clone()
	self._goodsClone1:retain()
	self._goodsClone2 = self._mainLayer.LSV_TOTAL.LSV_GOODS.LAY_CLONE2:clone()
	self._goodsClone2:retain()
	UIHelper.initListView(self._mainLayer.LSV_TOTAL)
end

--------------- reload -----------------
function AccLoginView:reload_lsv( ... )
	self._mainLayer.LSV_TOTAL:removeAllItems()

	local index = 0
	local dbData = _model.getDBData()
	local tRewards = _model.getRewards()
	logger:debug({tRewards = tRewards})
	for day, info in pairs(tRewards) do
		local state = _model.getState(day)
		logger:debug(state)
		if (info ~= "" and tonumber(info) ~= 0 and state ~= _model.STATE_ALREADY) then
			self._mainLayer.LSV_TOTAL:pushBackDefaultItem()
			local cell = self._mainLayer.LSV_TOTAL:getItem(index)
			cell:setSize(CCSizeMake(cell:getSize().width * g_fScaleX, cell:getSize().height * g_fScaleX))
			cell.IMG_CELL:setScaleX(g_fScaleX)
			cell.IMG_CELL:setScaleY(g_fScaleX)

			cell.tfd_cell_1:setText(m_i18n[7301])
			cell.tfd_cell_3:setText(m_i18n[1937])---天
			cell.tfd_jindu:setText(m_i18n[6603])--进度：
			UIHelper.titleShadow(cell.BTN_GET_REWARD, m_i18n[2628])	-- "领取"
			cell.BTN_GET_REWARD:addTouchEventListener(AccLoginCtrl.onBtnGain)
			cell.BTN_GET_REWARD:setTag(day)
			cell.TFD_CELL_2:setText(tostring(day))

			-- 进度
			local num = math.min(_model.getAccNum(), day)
			cell.TFD_LEFT:setText(num)
			cell.TFD_RIGHT:setText(day)
			
			-- 不可领取
			if (state == _model.STATE_NOT) then
				cell.BTN_GET_REWARD:setTouchEnabled(false)
				cell.BTN_GET_REWARD:setGray(true)
			end
			
			-- 奖励图标
			local tbRewardsData = RewardUtil.parseRewards(info)	
			logger:debug(tbRewardsData)
			local rewardType = AccLoginModel.getRewardTypeWithDay(day)
			cell.LSV_GOODS:removeAllItems()
			for k, reward in pairs(tbRewardsData) do
				if (reward) then
					local rcell = self._goodsClone1:clone()
					rcell.img_reward1:addChild(reward.icon)
					rcell.tfd_name1:setText(reward.name)
					rcell.tfd_name1:setColor(g_QulityColor[reward.quality])
					cell.LSV_GOODS:pushBackCustomItem(rcell)
					if (rewardType == 2 and tonumber(k) ~= #tbRewardsData) then
						local orcell = self._goodsClone2:clone()
						cell.LSV_GOODS:pushBackCustomItem(orcell)
					end
				end
			end
			UIHelper.setSliding(cell.LSV_GOODS)

			index = index + 1
		end
	end
	UIHelper.setSliding(self._mainLayer.LSV_TOTAL)
end

function AccLoginView:reload_countdown( ... )
	-- local timeStr = _model.getCountDown()
	-- self._mainLayer.tfd_time_num:setText(timeStr)
	-- self._mainLayer.tfd_time_num:updateSizeAndPosition()
	self._mainLayer.tfd_time_num:setText(_model.getDuration())
	UIHelper.labelNewStroke(self._mainLayer.tfd_time_num, ccc3(0x28, 0x00, 0x00), 2)
end

------------------ notifications -------------------
function AccLoginView:fnMSG_CLOSED( ... )
	logger:debug("AccLogin 累计登录活动关闭了!!!")
	GlobalScheduler.removeCallback("AccLoginView")
	-- 倒计时置0
	--self:reload_countdown()
end