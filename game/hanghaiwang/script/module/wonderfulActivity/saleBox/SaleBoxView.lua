-- FileName: SaleBoxView.lua
-- Author: lvnanchun
-- Date: 2015-08-20
-- Purpose: 限时宝箱界面
--[[TODO List]]

SaleBoxView = class("SaleBoxView")

-- UI variable --
local _layMain

-- module local variable --
local _tbBtnEvent
local _fnGetWidget = g_fnGetWidgetByName
local _bEnd = false
local _i18n = gi18n

function SaleBoxView:moduleName()
    return "SaleBoxView"
end

function SaleBoxView:ctor(...)
	_layMain = g_fnLoadUI("ui/activity_salebox.json")
end

--[[desc:刷新某一个宝箱的剩余次数，颜色和按钮状态
    arg1: 宝箱index
    return: 无
—]]
function SaleBoxView:refreshRemainTime( boxIndex )
	local cellIndex = "LAY_BOX" .. tostring(boxIndex)
	local layCell = _fnGetWidget(_layMain, cellIndex )
	local nRemainTime = SaleBoxModel.getRemainTime(boxIndex)
	layCell.TFD_LEFT:setText(tostring(nRemainTime))
	if (nRemainTime < 1 ) then
		layCell.BTN_BUY:setBright(false)
		layCell.BTN_BUY:setTouchEnabled(false)
		layCell.TFD_LEFT:setColor(ccc3(0xDB , 0x14 , 0x00))
	else
		layCell.BTN_BUY:setBright(true)
		layCell.BTN_BUY:setTouchEnabled(true)
		layCell.TFD_LEFT:setColor(ccc3(0x00 , 0x8A , 0x00))
	end
end

--[[desc:显示奖励信息
    arg1: 奖励数据table
    return: 无
—]]
function SaleBoxView:playRewardDlg( rewardTable )
	logger:debug({rewardTable = rewardTable})

	local tbReward = {}

	require "script/module/public/ItemUtil"
	require "script/model/utils/HeroUtil"

	for k,v in pairs(rewardTable.drop) do 
		if (k == "item") then
			for i,j in pairs(v) do 
				logger:debug("saleBoxRewardItem")
				local iconBtn , tbItem = ItemUtil.createBtnByTemplateIdAndNumber(tonumber(i) , tonumber(j) , function (snder,eventType)
					if (eventType == TOUCH_EVENT_ENDED) then
						AudioHelper.playCommonEffect()
						PublicInfoCtrl.createItemInfoViewByTid(tonumber(i),tonumber(j))
					end
				end)
				tbItem.icon = iconBtn
				table.insert(tbReward , tbItem)
			end
		elseif (k == "hero") then
			for i,j in pairs(v) do
				logger:debug("saleBoxRewardHero")
				table.insert(tbReward , {icon = HeroUtil.getHeroIconByHTID(tonumber(i))})
			end
		elseif (k == "silver") then
			logger:debug("saleBoxRewardSilver")
			table.insert(tbReward , {icon = ItemUtil.getContriIconByNum(tonumber(v)),quality = 2,name = m_i18n[1520]})
		elseif (k == "soul") then
			logger:debug("saleBoxRewardSoul")
			table.insert(tbReward , {icon = ItemUtil.getJewelIconByNum(tonumber(v)),name = m_i18n[2082],quality = 5})
		elseif (k == "treasFrag") then
			for i,j in pairs(v) do 
				logger:debug("saleBoxRewardTreasFrag")
				local iconBtn , tbItem = ItemUtil.createBtnByTemplateIdAndNumber(tonumber(i) , tonumber(j) , function (snder,eventType)
					if (eventType == TOUCH_EVENT_ENDED) then
						AudioHelper.playCommonEffect()
						PublicInfoCtrl.createItemInfoViewByTid(tonumber(i),tonumber(j))
					end
				end)
				tbItem.icon = iconBtn
				table.insert(tbReward , tbItem)
			end
		end
	end

	logger:debug({tbReward = tbReward})
	LayerManager.addLayoutNoScale(UIHelper.createRewardDlg(tbReward))

end

--[[desc:设置某一宝箱的信息
    arg1: layCell宝箱的UI控件 ， cellIndex宝箱的index
    return: 无
—]]
function SaleBoxView:setLayInfo( layCell , cellIndex )
	local btnIndex = "onBuy" .. tostring(cellIndex)
	local infoIndex = "cellInfo" .. tostring(cellIndex)
	local tbOneCellInfo = SaleBoxModel.getCellInfo()[infoIndex]

	layCell.TFD_BOX_DES:setText(tbOneCellInfo.des)
	layCell.tfd_box_name:setText(tbOneCellInfo.name)
	
	-- 2015-12-11 修改宝箱名字的描边为1px
	if (cellIndex == 1) then
		UIHelper.labelNewStroke(layCell.tfd_box_name, ccc3(0x00, 0x23, 0x03), 1)
	else
		UIHelper.labelNewStroke(layCell.tfd_box_name, ccc3(0x28, 0x00, 0x00), 1)
	end
	layCell.tfd_buy_num:setText(_i18n[6503])
	layCell.TFD_LEFT:setText(tostring(tbOneCellInfo.numLeft))
	if (tonumber(tbOneCellInfo.numLeft) < 1) then
		layCell.TFD_LEFT:setColor(ccc3(0xDB , 0x14 , 0x00))
	else
		layCell.TFD_LEFT:setColor(ccc3(0x00 , 0x8A , 0x00))
	end 
	layCell.TFD_RIGHT:setText(tostring(tbOneCellInfo.num))
	layCell.tfd_slant:setText(_i18n[4908])
	layCell.LAY_YUANJIA.tfd_yuanjia:setText(_i18n[1470])
	layCell.LAY_YUANJIA.TFD_GOLD_NUM:setText(tbOneCellInfo.oricost)
	layCell.LAY_TEJIA.tfd_tejia:setText(_i18n[6504])
	layCell.LAY_TEJIA.TFD_GOLD_NUM:setText(tbOneCellInfo.discount)

	layCell.BTN_BUY:addTouchEventListener(_tbBtnEvent[btnIndex])
	UIHelper.titleShadow(layCell.BTN_BUY)
	if (tbOneCellInfo.numLeft <= 0) then
		layCell.BTN_BUY:setTouchEnabled(false)
		layCell.BTN_BUY:setBright(false)
	end

	layCell.IMG_BOX:loadTexture(tbOneCellInfo.imagePath)
end

function SaleBoxView:create( tbBtnEvent )
	local imgMainBg = _layMain.img_main_bg
	imgMainBg:setScaleX(g_fScaleX)
	imgMainBg:setScaleY(g_fScaleY)
--	_layMain.img_bg:setScaleX(g_fScaleX)
--	_layMain.img_bg:setScaleY(g_fScaleY)
--	_layMain.LAY_BOX1:setScaleX(g_fScaleX)
--	_layMain.LAY_BOX1:setScaleY(g_fScaleY)
--	_layMain.LAY_BOX2:setScaleX(g_fScaleX)
--	_layMain.LAY_BOX2:setScaleY(g_fScaleY)
--	_layMain.LAY_BOX3:setScaleX(g_fScaleX)
--	_layMain.LAY_BOX3:setScaleY(g_fScaleY)

	_tbBtnEvent = tbBtnEvent

	_layMain.tfd_time:setText(_i18n[6502])
	UIHelper.labelNewStroke(_layMain.tfd_time , ccc3(0x28 , 0x00 , 0x00))
	local strTime = SaleBoxModel.getContinueTime()
	_layMain.tfd_time_num:setText(strTime)
	UIHelper.labelNewStroke(_layMain.tfd_time_num , ccc3(0x28 , 0x00 , 0x00))

	for i=1,3 do
		local cellIndex = "LAY_BOX" .. tostring(i)
		self:setLayInfo( _fnGetWidget(_layMain, cellIndex ) , i)
	end

	--宝箱倒计时的计时器
	local function saleBoxTimerCallBack( ... )
		require "script/utils/NewTimeUtil"
		local strTime , bActEnd = SaleBoxModel.getContinueTime()
		_layMain.tfd_time_num:setText(strTime)
		if (bActEnd) and not (_bEnd) then
			_layMain.LAY_BOX1.BTN_BUY:addTouchEventListener(function ( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					AudioHelper.playCommonEffect()
					ShowNotice.showShellInfo(_i18n[6501])  
				end
			end)
			_layMain.LAY_BOX2.BTN_BUY:addTouchEventListener(function ( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					AudioHelper.playCommonEffect()
					ShowNotice.showShellInfo(_i18n[6501])  
				end
			end)
			_layMain.LAY_BOX3.BTN_BUY:addTouchEventListener(function ( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					AudioHelper.playCommonEffect()
					ShowNotice.showShellInfo(_i18n[6501])  
				end
			end)
			_bEnd = true
		end
		require "script/model/user/UserModel"
		local timeOffset = UserModel.getDayOffset()
		local tbNowTime = TimeUtil.getServerDateTime(TimeUtil.getSvrTimeByOffset(-timeOffset))
		if ((tbNowTime.hour + tbNowTime.min + tbNowTime.sec) == 0) then
			SaleBoxModel.setRemainEveryDay()
			self:refreshRemainTime(1)
			self:refreshRemainTime(2)
			self:refreshRemainTime(3)
			-- 应策划需求不现实红点
--			local mainActivity = WonderfulActModel.tbBtnActList.saleBox
--			mainActivity:setVisible(true)
--			local numRedPoint = SaleBoxModel.nGetRedPointNum()
--			mainActivity.LABN_TIP_EAT:setStringValue(numRedPoint)
--			if (numRedPoint == 0) then 
--				mainActivity.IMG_TIP:setVisible(false)
--			end
		end
	end

	UIHelper.registExitAndEnterCall(_layMain, function ( )		
		GlobalScheduler.removeCallback("saleBoxTimer")
		local bActEnd
		_ , bActEnd = SaleBoxModel.getContinueTime()
		if (bActEnd) then
			local mainActivity = WonderfulActModel.tbBtnActList.saleBox
			mainActivity.IMG_TIP:setEnabled(false)
			SaleBoxModel.getIconBtn():addTouchEventListener(function ( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					AudioHelper.playCommonEffect()
					ShowNotice.showShellInfo(_i18n[6501])  
				end
			end)
		end
    end , function ( )
    	GlobalScheduler.addCallback("saleBoxTimer" , saleBoxTimerCallBack)
    	if (SaleBoxModel.getNewAniState() ~= 1) then
   			SaleBoxModel.setNewAniState(1)
   			local listCell = SaleBoxModel.getBtnCell()
			listCell:getNodeByTag(100):removeFromParentAndCleanup(true)
		end
    end)

	return _layMain
end

