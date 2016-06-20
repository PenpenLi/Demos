-- FileName: VipGiftView.lua
-- Author: lvnanchun
-- Date: 2015-08-12
-- Purpose: vip礼包界面
--[[TODO List]]

VipGiftView = class("VipGiftView")
require "script/module/wonderfulActivity/vipGift/VipGiftModel"
require "script/utils/NewTimeUtil"

-- UI variable --
local _layMain
local _layDay
local _layWeek
local _laySale
local _btnTabDay
local _btnTabWeek

-- module local variable --
local _tbBtnState = {}
local _layState = "sale"
local _i18n = gi18n
local _tbLayFreshState = {day = 0, week = 0, sale = 0}

function VipGiftView:moduleName()
    return "VipGiftView"
end

function VipGiftView:ctor(...)
	_layMain = g_fnLoadUI("ui/activity_vip_gift.json")


end

function VipGiftView:VipGiftScheduleCallBack()
	local tbNowTime = NewTimeUtil.getServerDateTime()
	local nDayRemian = 7 - NewTimeUtil.getRealwday(tbNowTime.wday)
	local nHourRemain = 23 - tbNowTime.hour
	local nMinRemain = 59 - tbNowTime.min
	local nSecRemain = 59 - tbNowTime.sec
	local mainActivity = WonderfulActModel.tbBtnActList.vipGift
	if (nDayRemian+nHourRemain+nMinRemain+nSecRemain == 0) then
		VipGiftModel.resetWeek()
		_tbBtnState.gift = {}
		_tbBtnState.bonus = 0
		_layMain.BTN_TAB2.IMG_RED:setVisible(VipGiftModel.getWeekRedPoint())
		mainActivity.IMG_TIP:setEnabled(VipGiftModel.getRedPoint())
		self:setLayWeek()
	end
	if ((tbNowTime.hour + tbNowTime.min + tbNowTime.sec) == 0) then
		VipGiftModel.resetDay()
		_tbBtnState.bonus = 0
		_layMain.BTN_TAB1.IMG_RED:setVisible( true )
		mainActivity.IMG_TIP:setEnabled(VipGiftModel.getRedPoint())
		self:setLayDay()
	end
	_layWeek.tfd_time:setText( tostring(nDayRemian) .. _i18n[1937] .. tostring(nHourRemain) .. _i18n[1977] .. tostring(nMinRemain) .. _i18n[5411] .. tostring(nSecRemain) .. _i18n[1981] )
end

--[[desc:设置当前处于哪个界面
    arg1: “day”表示每日福利，“week”表示周礼包
    return: 无
—]]
function VipGiftView:setLay( layType )
	local ttfWeek = tolua.cast(_btnTabWeek:getTitleTTF(), "CCLabelTTF")
	local ttfDay = tolua.cast(_btnTabDay:getTitleTTF(), "CCLabelTTF")
	local ttfSale = tolua.cast(_btnTabSale:getTitleTTF(), "CCLabelTTF")
	_layDay:setEnabled(layType == "day")
	_layWeek:setEnabled(layType == "week")
	_laySale:setEnabled(layType == "sale")
	_btnTabDay:setFocused(layType == "day")
	_btnTabWeek:setFocused(layType == "week")
	_btnTabSale:setFocused(layType == "sale")
	if (layType == "day") then
		ttfDay:setColor(ccc3(0xff, 0xff, 0xff))
		ttfWeek:setColor(ccc3(0xbf, 0x93, 0x67))
		ttfSale:setColor(ccc3(0xbf, 0x93, 0x67))
		if (_tbLayFreshState.day == 0) then
			self:setLayDay()
			_tbLayFreshState.day = 1
		end
	elseif (layType == "week") then
		ttfDay:setColor(ccc3(0xbf, 0x93, 0x67))
		ttfWeek:setColor(ccc3(0xff, 0xff, 0xff))
		ttfSale:setColor(ccc3(0xbf, 0x93, 0x67))
		-- 红点问题
		_layMain.BTN_TAB2.IMG_RED:setVisible(VipGiftModel.getWeekRedPoint())

		if (_tbLayFreshState.week == 0) then
			self:setLayWeek()
			_tbLayFreshState.week = 1
		end
	elseif (layType == "sale") then
		ttfDay:setColor(ccc3(0xbf, 0x93, 0x67))
		ttfWeek:setColor(ccc3(0xbf, 0x93, 0x67))
		ttfSale:setColor(ccc3(0xff, 0xff, 0xff))
		if (_tbLayFreshState.sale == 0) then
			self:setLaySale()
			_tbLayFreshState.sale = 1
		end
	end
end

--[[desc:设置每日福利界面的横向listView中每个按钮的信息
    arg1: 按钮cell和对应信息
    return: 无
—]]
function VipGiftView:setCell( cell , cellInfo )
	local iconBtn = cell.IMG_GOODS
	local tfdName = cell.TFD_GOODS_NAME

	tfdName:setText(cellInfo.name)
	iconBtn:addChild(cellInfo.icon)
end

--[[desc:设置每日福利的界面
    arg1: 无
    return: 无
—]]
function VipGiftView:setLayDay()
	local tbReward = VipGiftModel.getDayRewards()
	logger:debug({vipreward = tbReward})

	local nVip = UserModel.getVipLevel()

	local btnGetReward = _layDay.BTN_GET_REWARD
	UIHelper.titleShadow(btnGetReward)
	local imgReceived = _layDay.IMG_RECIEVED

	local redPoint = _layMain.BTN_TAB1.IMG_RED

	local mainActivity = WonderfulActModel.tbBtnActList.vipGift

	if (tonumber(_tbBtnState.bonus) == 1) then
		imgReceived:setVisible(true)
		btnGetReward:setVisible(false)
		btnGetReward:setTouchEnabled(false)
	else
		imgReceived:setVisible(false)
		btnGetReward:setVisible(true)
		btnGetReward:setTouchEnabled(true)
	end

--	_layDay.tfd_desc_1:setText("vip福利来了！")
	_layDay.tfd_desc_2:setText(_i18n[6801])
	UIHelper.labelNewStroke(_layDay.tfd_desc_2 , ccc3(0x28, 0x00, 0x00))
	_layDay.BTN_LOOK:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			_layState = "day"
			require "script/module/IAP/IAPCtrl"
			LayerManager.addLayout(IAPCtrl.create("vip"))
		end
	end)

	local imgCellNow = _layDay.IMG_CELL_NOW
	imgCellNow.tfd_cell_title:setText(_i18n[2117] .. tostring(nVip) .. _i18n[6802])

	local nowListView = imgCellNow.LSV_FORTBV

	UIHelper.initListView(nowListView)

	for k,v in pairs(tbReward.cur) do 
		nowListView:pushBackDefaultItem()
		local cell = nowListView:getItem( k - 1 )
		self:setCell( cell , v )
	end

	local imgCellNext = _layDay.IMG_CELL_NEXT
	if not (table.isEmpty(tbReward.next)) then
		imgCellNext.tfd_cell_title:setText(_i18n[2117] .. tostring(nVip + 1) .. _i18n[6802])
		imgCellNext.tfd_cell_desc:setText(_i18n[1413] .. tostring(VipGiftModel.getCoinsNeed()) .. _i18n[6803])
		imgCellNext.BTN_GET_REWARD:addTouchEventListener(function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCommonEffect()
				_layState = "day"
				require "script/module/IAP/IAPCtrl"
				LayerManager.addLayout(IAPCtrl.create())
			end
		end)
		UIHelper.titleShadow(imgCellNext.BTN_GET_REWARD)
	
		local nextListView = imgCellNext.LSV_FORTBV
	
		UIHelper.initListView(nextListView)
	
		for k,v in pairs(tbReward.next) do 
			nextListView:pushBackDefaultItem()
			local cell = nextListView:getItem( k - 1 )
			self:setCell( cell , v )
		end
	else 
		imgCellNext:setVisible(false)
		imgCellNext:setEnabled(false)
	end

	local function onBtnGet( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playBtnEffect("tansuo02.mp3")
			local function getRewardCallBack( cbFlag, dictData, bRet )
				if (bRet) then
					if (dictData.ret == "ok") then
						imgReceived:setVisible(true)
						btnGetReward:setVisible(false)
						btnGetReward:setTouchEnabled(false)
						redPoint:setVisible(false)
						VipGiftModel.setRedPointFalse()
						mainActivity.IMG_TIP:setEnabled(VipGiftModel.getRedPoint())
						logger:debug({vipGiftReward = tbReward})
						LayerManager.addLayoutNoScale(UIHelper.createRewardDlg(RewardUtil.parseRewards(tbReward.dlg)))
						local tbDlg = string.split(tbReward.dlg , ',')
						local nBelly = nil
						for k,v in pairs(tbDlg) do 
							local tbGiftInfo = string.split(v , '|')
							if tonumber(tbGiftInfo[1]) == 1 then
								nBelly = tonumber(tbGiftInfo[3])
							end
						end
						if (nBelly) then
							UserModel.addSilverNumber(nBelly)
						end
					end
				end
			end
			if not (ItemUtil.isBagFull()) then
				RequestCenter.vipBonus_getReward(getRewardCallBack)
			end
		end
	end

	btnGetReward:addTouchEventListener(onBtnGet)

end

--[[desc:设置周礼包界面
    arg1: 无
    return: 无
—]]
function VipGiftView:setLayWeek()
	local nVip = UserModel.getVipLevel()
	-- 倒计时相关控件的设置
	_layWeek.tfd_time_txt:setText(_i18n[6809])
	UIHelper.labelNewStroke(_layWeek.tfd_time_txt , ccc3(0x28, 0x00, 0x00))
	UIHelper.labelNewStroke(_layWeek.tfd_time , ccc3(0x28, 0x00, 0x00))

	-- listView相关设置
	local vipLevelMax = VipGiftModel.getVipLevelMaxNum()
	local vipMax = (nVip + 3 > vipLevelMax) and vipLevelMax or nVip + 3

	_layMain.LSV_WEEK:removeAllItems()

	for i = 1, vipMax do
		_layMain.LSV_WEEK:pushBackDefaultItem()
		local cell = _layMain.LSV_WEEK:getItem(i - 1)

		local cellInfo = VipGiftModel.getOneWeekCellInfo(i)
		local cellVipLevel = tonumber(cellInfo.level)

		cell.TFD_VIP:setText(tostring(cellVipLevel))
		cell.tfd_buy_vip:setText(_i18n[2117] .. tostring(cellVipLevel))
		cell.tfd_buy_can:setText(_i18n[2263])
		cell.tfd_now:setText(_i18n[4352])
		cell.tfd_original:setText(_i18n[1470])
		cell.tfd_now_price:setText(cellInfo[2])
		cell.tfd_original_price:setText(cellInfo[1])
		cell.tfd_cell_title:setText(_i18n[2000])

		local btnIcon = cellInfo.reward[1].icon
		cell.TFD_GOODS_NAME:setText(cellInfo.reward[1].name)
		
		if (cell.IMG_GOODS:getChildByTag(100)) then
			cell.IMG_GOODS:getChildByTag(100):removeFromParentAndCleanup(true)
		end
		cell.IMG_GOODS:addChild(btnIcon, 1, 100)

		local btnBuy = cell.BTN_BUY
		local imgBuy = cell.IMG_BUY

		local function onBtnBuy( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				--AudioHelper.playBtnEffect("buttonbuy.mp3")
				AudioHelper.playCommonEffect()
				local tipDlg
				local nVip = UserModel.getVipLevel()
				if (nVip < cellVipLevel) then
					tipDlg = UIHelper.createCommonDlg(_i18n[6807] .. tostring(cellVipLevel) .. _i18n[6806] , nil , function ( sender, eventType )
						if (eventType == TOUCH_EVENT_ENDED) then
							AudioHelper.playCommonEffect()
							LayerManager.removeLayout()
							_layState = "week"
							require "script/module/IAP/IAPCtrl"
							LayerManager.addLayout(IAPCtrl.create())
						end
					end , 2 )
				else
					local function onBtnSure( sender, eventType )
						if (eventType == TOUCH_EVENT_ENDED) then
							--AudioHelper.playCommonEffect()
							if (UserModel.getGoldNumber() < tonumber(cellInfo[2])) then
								AudioHelper.playCommonEffect()
								LayerManager.removeLayout()
								LayerManager.addLayout(UIHelper.createNoGoldAlertDlg())
							else
								AudioHelper.playBtnEffect("buttonbuy.mp3")
								local function sureCallBack( cbFlag, dictData, bRet )
									if (bRet) then
										if (dictData.ret == "ok") then
											local tbReward = VipGiftModel.getOneWeekCellInfo(cellVipLevel)
											LayerManager.removeLayout()
											_layState = "week"
											table.insert(_tbBtnState.gift , tostring(cellVipLevel))
											btnBuy:setTouchEnabled(false)
											btnBuy:setVisible(false)
											imgBuy:setVisible(true)
											UserModel.addGoldNumber(-tbReward[2])
											-- 将获得的物品存起来
											RewardUtil.parseRewardsByTb(tbReward.tbReward, true)
											LayerManager.addLayoutNoScale(UIHelper.createRewardDlg(tbReward.reward))
										end
									end
								end
								require "script/network/Network"
								RequestCenter.vipBonus_buyWeekGift(sureCallBack , Network.argsHandler(cellVipLevel))
							end
						end
					end
					tipDlg = UIHelper.createCommonDlg(_i18n[6808] .. tostring(cellVipLevel) .. _i18n[1403] .. "?" , nil , onBtnSure , 2 )
				end
	
				LayerManager.addLayout(tipDlg)
			end
		end
	
		btnBuy:addTouchEventListener(onBtnBuy)
		UIHelper.titleShadow(btnBuy)

		if (table.include( _tbBtnState.gift , {tostring(cellVipLevel)})) then
			btnBuy:setTouchEnabled(false)
			btnBuy:setVisible(false)
			btnBuy:setGray(false)
			imgBuy:setVisible(true)
		elseif (cellVipLevel > nVip) then
			btnBuy:setVisible(true)
			btnBuy:setTouchEnabled(false)
			btnBuy:setGray(true)
			imgBuy:setVisible(false)
		else
			btnBuy:setVisible(true)
			btnBuy:setTouchEnabled(true)
			btnBuy:setGray(false)
			imgBuy:setVisible(false)
		end
	end
end



--[[desc:设置超值礼包界面
    arg1: 无
    return: 无
—]]
function VipGiftView:setLaySale()
	-- 功能节点未开启则不设置超值礼包界面
	if (not SwitchModel.getSwitchOpenState(ksSwitchShop)) then
		return
	end
	local nVip = UserModel.getVipLevel()
	local vipMax = (nVip + 3 > 15) and 15 or nVip + 3
	local tbListViewInfo = VipGiftModel.getSaleListInfo()
	logger:debug({tbListViewInfo = tbListViewInfo})

	-- tab上面的红点
	if (_layMain.BTN_TAB3.IMG_RED:getNodeByTag(100)) then
		_layMain.BTN_TAB3.IMG_RED:removeNodeByTag(100)
	end
	_layMain.BTN_TAB3.IMG_RED:addNode(UIHelper.createRedTipAnimination(), 1, 100)
	local redPoint = _layMain.BTN_TAB3.IMG_RED
	redPoint:setVisible(VipGiftModel.getSaleRedPoint())
	local mainActivity = WonderfulActModel.tbBtnActList.vipGift
	mainActivity.IMG_TIP:setEnabled(VipGiftModel.getRedPoint())

	_layMain.LSV_VIP:removeAllItems()

	for i,v in ipairs(tbListViewInfo) do
		_layMain.LSV_VIP:pushBackDefaultItem()
		local cell = _layMain.LSV_VIP:getItem(i - 1)

		cell.TFD_VIP_BUY:setText(gi18nString(1472,tostring(v.vipLevel)))
		cell.TFD_TITLE_VIP_NUM:setText(tostring(v.vipLevel))
		cell.tfd_vip_gift_name:setText(_i18n[1461])
		cell.tfd_price_ago:setText(_i18n[1470])
		cell.TFD_AGO_PRICE:setText(tostring(v.oldPrice))
		cell.tfd_price_now:setText(_i18n[6504])
		cell.TFD_NOW_PRICE:setText(tostring(v.nowPrice))

		local preEffect = cell.BTN_VIP_BUY:getNodeByTag(100)
		if (preEffect) then
			preEffect:removeFromParentAndCleanup(true)
		end

		-- 购买VIP礼包
		local function buyVipGift( vipLevel )
			if(UserModel.getVipLevel() < vipLevel) then
				ShowNotice.showShellInfo(_i18n[1434])
				return
			end
		
			local function requestFunc( cbFlag, dictData, bRet )
				if(bRet) then
					DataCache.setBuyedVipGift(vipLevel)
					--刷新礼包列表
					self:setLaySale()
					--刷新公共信息面板
					updateInfoBar() -- 新信息条统一更新方法
		
					local costGoldNUmber = -tonumber(v.nowPrice)
					UserModel.addGoldNumber(costGoldNUmber)
		
					--ShowNotice.showShellInfo(_i18n[1343])
					LayerManager.removeLayout()
					LayerManager.addLayoutNoScale(UIHelper.createRewardDlg(RewardUtil.parseRewards(v.itemStr, true)))
					
		
					-- 获取当前商店的信息
					function shopInfoCallback( cbFlag, dictData, bRet )
						if(bRet == nil)then
							return
						end
		
						local tbCurShopCacheInfo = dictData.ret
						DataCache.setShopCache(tbCurShopCacheInfo)
		--				-- menghao 购买后处理商店小红点
		--				MainShopView.updateTipGift()
					end
		
					RequestCenter.shop_getShopInfo(shopInfoCallback, nil)
				end
			end
			local args = CCArray:create()
			args:addObject(CCInteger:create(vipLevel))
			Network.rpc(requestFunc, "shop.buyVipGift", "shop.buyVipGift", args, true)
		end

		cell.BTN_VIP_BUY:addTouchEventListener(function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				--AudioHelper.playBtnEffect("buttonbuy.mp3")
				AudioHelper.playCommonEffect()
				local tbData = {}
				tbData.strText = gi18nString(5752, tostring(v.nowPrice), tostring(v.vipLevel))
				tbData.nBtn = 2
				tbData.fnConfirmEvent = function ( sender, eventType )
					if (eventType == TOUCH_EVENT_ENDED) then
						--AudioHelper.playCommonEffect()
						require "script/module/public/ItemUtil"
						if(ItemUtil.isPropBagFull(true) == true)then
							return
						end
			
						if(tonumber(v.nowPrice) <= UserModel.getGoldNumber()) then
							AudioHelper.playBtnEffect("buttonbuy.mp3")
							buyVipGift(v.vipLevel)
						else
							AudioHelper.playCommonEffect()
							LayerManager:removeLayout()
							local noGoldAlert = UIHelper.createNoGoldAlertDlg()
							LayerManager.addLayout(noGoldAlert)
			
						end
					end
				end
				tbData.fnCloseCallback = function ( sender, eventType )
					if (eventType == TOUCH_EVENT_ENDED) then
						AudioHelper.playCloseEffect()
						LayerManager:removeLayout()
					end
				end

				LayerManager.addLayout(UIHelper.createCommonDlgNew(tbData))
			end
		end)

		if (not v.isReach) then
			cell.BTN_VIP_BUY:setTouchEnabled(false)
			cell.BTN_VIP_BUY:setGray(true)
			UIHelper.titleShadow(cell.BTN_VIP_BUY, _i18n[1435])
		elseif (v.isBought) then
			cell.BTN_VIP_BUY:setTouchEnabled(false)
			cell.BTN_VIP_BUY:setGray(true)
			UIHelper.titleShadow(cell.BTN_VIP_BUY, _i18n[1452])
		else
			cell.BTN_VIP_BUY:setGray(false)
			cell.BTN_VIP_BUY:setTouchEnabled(true)
			UIHelper.titleShadow(cell.BTN_VIP_BUY, _i18n[1435])
			--按钮特效
			local tbParams = {
				filePath = "images/effect/button_small/button_small.ExportJson",
				animationName = "button_small",
			}

			local effectNode = UIHelper.createArmatureNode(tbParams)
			cell.BTN_VIP_BUY:addNode(effectNode, 1, 100)
		end

		local iconListView = cell.LSV_GIFT
		-- 横着的listView
		for k,j in pairs(v.itemInfo) do
			iconListView:pushBackDefaultItem()
			local iconCell = iconListView:getItem(k - 1)
			iconCell.IMG_ICON:addChild(j.icon)
		end
	end
end

--[[desc:view构造函数
    arg1: 礼包按钮的状态table
    return: 返回界面 
—]]
function VipGiftView:create( tbGiftState )
	_layDay = _layMain.img_day_bg
	_layWeek = _layMain.img_week_bg
	_laySale = _layMain.img_vip_bg

	local imgBg = _layMain.img_main_bg
	imgBg:setScaleX(g_fScaleX)
	imgBg:setScaleY(g_fScaleY)

	-- 2015-12-15 cell做适配
	local cellDayNow = _layMain.img_day_bg.IMG_CELL_NOW
	local cellDayNext = _layMain.img_day_bg.IMG_CELL_NEXT
	cellDayNow:setScale(g_fScaleX)
	cellDayNext:setScale(g_fScaleX)
	cellDayNext:setPositionType(0)
	-- 这个163是编辑器里的距离。
	cellDayNext:setPositionY(cellDayNow:getPositionY() - 163 * g_fScaleX)

	local layTab = _layMain.lay_bag_tab
	_btnTabDay = layTab.BTN_TAB1
	_btnTabWeek = layTab.BTN_TAB2
	_btnTabSale = layTab.BTN_TAB3
	
	logger:debug({tbGiftState = tbGiftState})
	if (tbGiftState) then
		table.hcopy( tbGiftState , _tbBtnState )
	end

	-- 对listView中的cell进行适配
	_layMain.LSV_WEEK.lay_week_bg.IMG_CELL_NOW:setScale(g_fScaleX)
	_layMain.LSV_WEEK.lay_week_bg:setSize(CCSizeMake(_layMain.LSV_WEEK.lay_week_bg:getSize().width*g_fScaleX, _layMain.LSV_WEEK.lay_week_bg:getSize().height*g_fScaleX ))
	UIHelper.titleShadow(_layMain.LSV_WEEK.lay_week_bg.BTN_BUY)
	_layMain.LSV_VIP.lay_vip_gift_bg.img_vip_gift_bg:setScale(g_fScaleX)
	_layMain.LSV_VIP.lay_vip_gift_bg:setSize(CCSizeMake(_layMain.LSV_VIP.lay_vip_gift_bg:getSize().width*g_fScaleX, _layMain.LSV_VIP.lay_vip_gift_bg:getSize().height*g_fScaleX ))
	UIHelper.initListView(_layMain.LSV_VIP.lay_vip_gift_bg.LSV_GIFT)
	UIHelper.titleShadow(_layMain.LSV_VIP.lay_vip_gift_bg.BTN_VIP_BUY)
	-- 初始化week和sale上的listView
	UIHelper.initListView(_layMain.LSV_WEEK)
	UIHelper.initListView(_layMain.LSV_VIP)
	
--	self:setLayDay()
--	self:setLayWeek()
--	self:setLaySale()
	self:setLay("sale")

	-- tab上面的红点
	-- 超值礼包上的红点
	if (_layMain.BTN_TAB3.IMG_RED:getNodeByTag(100)) then
		_layMain.BTN_TAB3.IMG_RED:removeNodeByTag(100)
	end
	_layMain.BTN_TAB3.IMG_RED:addNode(UIHelper.createRedTipAnimination(), 1, 100)
	local redPoint3 = _layMain.BTN_TAB3.IMG_RED
	redPoint3:setVisible(VipGiftModel.getSaleRedPoint())
	-- 每日礼包上的红点
	local redPoint1 = _layMain.BTN_TAB1.IMG_RED
	if (redPoint1:getNodeByTag(100)) then
		redPoint1:removeNodeByTag(100)
	end
	redPoint1:addNode(UIHelper.createRedTipAnimination(), 1, 100)

	if (tonumber(_tbBtnState.bonus) == 1) then
		redPoint1:setVisible(false)
	else
		redPoint1:setVisible(true)
	end
	-- 每周礼包上的红点
	local redPoint2 = _layMain.BTN_TAB2.IMG_RED
	if (redPoint2:getNodeByTag(100)) then
		redPoint2:removeNodeByTag(100)
	end
	redPoint2:addNode(UIHelper.createRedTipAnimination(), 1, 100)
	local weekRedPoint = VipGiftModel.getWeekRedPoint()
	redPoint2:setVisible(weekRedPoint)

	-- 整体上的红点
	local mainActivity = WonderfulActModel.tbBtnActList.vipGift
	mainActivity.IMG_TIP:setEnabled(VipGiftModel.getRedPoint())

	_btnTabDay:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playTabEffect()
			self:setLay("day")
		end
	end)

	_btnTabWeek:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playTabEffect()
			self:setLay("week")
			-- 点击周礼包按钮就吧红点消掉
			if (VipGiftModel.getWeekRedPoint()) then
				VipGiftModel.setWeekRedPointTrue(false)
				if (VipGiftModel.getVipUp()) then
					VipGiftModel.setVipUp(false)
				end
			end
			_layMain.BTN_TAB2.IMG_RED:setVisible(VipGiftModel.getWeekRedPoint())
			-- 整体上的红点
			local mainActivity = WonderfulActModel.tbBtnActList.vipGift
			mainActivity.IMG_TIP:setEnabled(VipGiftModel.getRedPoint())
		end
	end)	

	_btnTabSale:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playTabEffect()
			if (SwitchModel.getSwitchOpenState(ksSwitchShop,true)) then
				self:setLay("sale")
			end
		end
	end)

	UIHelper.registExitAndEnterCall(_layMain, function ( )		
		GlobalScheduler.removeCallback("vipGiftTimer")
		GlobalNotify.removeObserver("VIPGIFT_CHARGEOK", "VIPGIFT_CHARGEOK")
		_tbLayFreshState = {day = 0, week = 0, sale = 0}
    end , function ( )
    	GlobalNotify.addObserver("VIPGIFT_CHARGEOK" , function ( ... )
			self:setLayDay()
			self:setLayWeek()
			self:setLaySale()
			self:setLay(_layState)
		end , false , "VIPGIFT_CHARGEOK" )
		GlobalScheduler.addCallback("vipGiftTimer" , function ( ... )
			self:VipGiftScheduleCallBack()
		end)
    end)

	return _layMain
end

