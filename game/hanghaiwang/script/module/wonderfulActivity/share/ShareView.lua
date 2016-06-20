-- FileName: ShareView.lua
-- Author: yucong
-- Date: 2015-07-03
-- Purpose: 每日分享view
--[[TODO List]]
ShareView = class("ShareView")

require "script/module/wonderfulActivity/share/ShareModel"
require "script/network/RequestCenter"
require "script/module/public/GlobalNotify"
require "platform/Platform"

-- 模块局部变量 --
local m_i18n	= gi18n
local m_fnGetWidget = g_fnGetWidgetByName
local _sModel	= ShareModel

local _mainLayer = nil
local _tbUnRegister = {}
local _delegate = nil
local _rewardId = 0
local _platformData = {}

function ShareView:notifications( ... )
	return {
		[_sModel.MSG.CB_GET_SHARE_REWARD]	= function () self:fnMSG_CB_GET_SHARE_REWARD() end,
		[_sModel.MSG.CB_SHARE_RELOAD]		= function () self:fnMSG_CB_SHARE_RELOAD() end,
	}
end

function ShareView:ctor()

end

function ShareView:create( ... )
	_mainLayer = g_fnLoadUI("ui/share_main.json")
	_mainLayer.img_bg:setScaleX(g_fScaleX) -- 背景图适配

	-- 注册onExit()
	UIHelper.registExitAndEnterCall(_mainLayer, function ( ... )
		for k, func in pairs(_tbUnRegister) do
			func()
		end

		for msg, func in pairs(self:notifications()) do
			GlobalNotify.removeObserver(msg, msg)
		end
		_delegate.destroy()
		_mainLayer = nil
		_delegate = nil
    end)
    -- 处理数据
	_sModel.handleDatas()
	-- 获取平台数据
    self:handlePlatform()
	-- 注册微信
	assert(_platformData.weixinId, "平台配置未填写weixinId")
    ShareManager:register_wx(_platformData.weixinId)	-- 
	-- 创建框架
	self:createFrame()
	-- 添加监听
	self:addObserver()

	return _mainLayer
end

function ShareView:handlePlatform( ... )
	local platform = Platform.getPL()--getPlatformFlag()
	if (Platform.isPlatform() == false)then
		platform = "appstore"
	end
	_platformData = _sModel.getShareContent(platform)
end

function ShareView:addObserver( ... )
	_tbUnRegister.success = GlobalNotify.addObserverToNotificationCenter("SHARE_SECCUSS", function ( ... )
		self:fnMSG_SHARE_SUCCESS()
	end)
	_tbUnRegister.failed = GlobalNotify.addObserverToNotificationCenter("SHARE_FAILED", function ( ... )
		self:fnMSG_SHARE_FAILED()
	end)
	_tbUnRegister.foreGround = GlobalNotify.addObserverForForeground("ShareView", function ( ... )
		self:fnMSG_SHARE_FORGROUND()
	end)

	for msg, func in pairs(self:notifications()) do
		GlobalNotify.addObserver(msg, func, false, msg)
	end
end

function ShareView:createFrame( ... )
	self:init_Lsv()
	_mainLayer.tfd_shuoming:setText(m_i18n[5806])	-- 把冒险经历分享给其他小伙伴，就能获得额外的奖励！
end

function ShareView:reload( ... )
	_sModel.sortDatas()
	-- 设置红点及数字
	self:setICONTips()

	local lsv = _mainLayer.LSV_MAIN
	lsv:removeAllItems()
	local datas = _sModel.getDBShares()
	for k, info in pairs(datas) do
		local id = tonumber(info.id)
		local reward = RewardUtil.parseRewards(info.reward)[1]
		local achieveInfo = info.tInfo
		local tStatus = _sModel.getStatus()
		lsv:pushBackDefaultItem()
		local cell = lsv:getItem(k - 1)
		cell.TFD_NAME:setText(info.des)
		-- icon
		--local icon = ItemUtil.getGoldIconByNum()--ImageView:create()
		--icon:loadTexture("ui/"..info.img)
		local icon= ImageView:create()
		icon:loadTexture(string.format("images/base/potential/color_%d.png", info.quality))
		local iconImgV  = ImageView:create()
		iconImgV:loadTexture("images/base/props/" .. info.img)
		local icomBorder = ImageView:create()
		icomBorder:loadTexture(string.format("images/base/potential/equip_%d.png", info.quality))
		icon:addChild(iconImgV)
		icon:addChild(icomBorder)  

		icon:setPosition(ccp(icon:getContentSize().width/2, icon:getContentSize().height/2))
		cell.LAY_ICON:addChild(icon)
		-- 是否每日
		local isDaily = tonumber(info.isDaily) == 1
		cell.img_dailyshare:setVisible(isDaily and true or false)
		-- 背景图 只有每日分享更换
		if (isDaily) then
			local bgImg, ctImg = _sModel.getCellImg(isDaily)
			cell.IMG_CELLBG:loadTexture(bgImg)
			cell.img_infobg:loadTexture(ctImg)
		end
		-- 是否已领取
		local isRecive = false
		-- 是否可分享
		local isShare = false
		
		cell.BTN_SHARE:addTouchEventListener(onShare)
		cell.BTN_SHARE:setTag(id)
		-- 进度
		cell.tfd_progress:setText(m_i18n[5801])

		if (isDaily) then
			if (tStatus[id] == 1) then
				isRecive = true
			else
				isShare = true
			end
			cell.tfd_progress:setVisible(false)
			cell.TFD_PROGRESS_NUM:setVisible(false)
		else
			if (tStatus[id] == 1) then
				isRecive = true
			elseif (info.tInfo.status == 1 or info.tInfo.status == 2) then
				isShare = true
			end
			cell.TFD_PROGRESS_NUM:setText(info.tInfo.finish_num .. "/" .. info.tInfo.max_num)
			cell.tfd_progress:setVisible(not (isShare or isRecive))	-- 可以分享、已分享的不显示进度
			cell.TFD_PROGRESS_NUM:setVisible(not (isShare or isRecive))
		end
		cell.IMG_ALREADY:setVisible(isRecive)
		cell.BTN_SHARE:setTouchEnabled(isShare)	-- 可分享才能点击
		cell.BTN_SHARE:setVisible(not isRecive)	-- 已领取后不可见
		cell.BTN_SHARE:setGray(not isShare)	-- 不可分享的置灰
		-- 奖励显示
		cell.TFD_JIANGLI_WUPIN:setText(reward.name)
		cell.TFD_ITEM_NUM:setText("x"..info.rewardNum)
	end
end

function ShareView:init_Lsv( ... )
	local lsv = _mainLayer.LSV_MAIN
	UIHelper.initListView(lsv)

	self:reload()
end

function ShareView:setDelegate( delegate )
	assert(delegate, "ShareView:delegate SHOULD NOT be null!")
	_delegate = delegate
end

function onShare( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		if (ShareManager:isInstall_wx() == false) then
			ShowNotice.showShellInfo(m_i18n[5802])
			return
		end
		local data = _sModel.getDBShareWithId(sender:getTag())
		local reward = RewardUtil.getItemsDataByStr(data.reward, true)[1]
		if (reward.tid ~= 0 and ItemUtil.bagIsFullWithTid(reward.tid, true)) then
			return
		end
		--local platform = Platform.getPlatformFlag()--1001--
		--local data = _sModel.getShareContent(platform) --_sModel.getShareContent()[platform]
		--assert(_platformData, "ShareView:DB_SharePlatform 平台:"..tostring(platform).." 不存在")
		_rewardId = sender:getTag()
		ShareManager:share_wx(_platformData.shareContent, 	-- 类型 1:链接 2:图片
			_platformData.platformTitle, 					-- 标题
			_platformData.platformWord, 					-- 描述
			"images/share/icon/".._platformData.platformIcon, -- 小图
			"images/share/img/".._platformData.platformImage, -- 大图
			_platformData.url)								-- 超链
	end
end

function ShareView:setICONTips( ... )
	local IMG_TIP = WonderfulActModel.tbBtnActList["shareReward"]
	local num = _sModel.getTipsCount()
	IMG_TIP:setVisible(num > 0 and true or false)
	IMG_TIP.LABN_TIP_EAT:setStringValue(tostring(num))
end

function ShareView:showSuccess( index )
	local successLayer = g_fnLoadUI("ui/share_success.json")
	LayerManager.addLayout(successLayer)

	local data = _sModel.getDBShareWithId(index)
	--local data = _sModel.getDBShares()[index]
	local reward = RewardUtil.parseRewards(data.reward, true)[1]
	logger:debug({reward = reward})
	reward.icon:setPosition(ccp(successLayer.LAY_ITEM:getPositionX() + successLayer.LAY_ITEM:getLayoutSize().width, successLayer.LAY_ITEM:getPositionY() + successLayer.LAY_ITEM:getLayoutSize().height))
	successLayer.LAY_ITEM:addChild(reward.icon)
	successLayer.TFD_NAME:setText(reward.name)
	successLayer.TFD_NAME:setColor(g_QulityColor[reward.quality])
	successLayer.tfd_share_success:setText(m_i18n[5803])
	UIHelper.titleShadow(successLayer.BTN_SURE, m_i18n[1029])
	successLayer.BTN_SURE:addTouchEventListener(UIHelper.onClose)
	successLayer.BTN_CLOSE:addTouchEventListener(UIHelper.onClose)
end

-------------------- Notification --------------------
local _isSuccess = 0
-- SDK 分享成功
function ShareView:fnMSG_SHARE_SUCCESS( ... )
	logger:debug("fnMSG_SHARE_SUCCESS")
	_isSuccess = 2
	if (g_system_type == kBT_PLATFORM_IOS ) then
		self:fnMSG_SHARE_FORGROUND()
	end
end

-- SDK 分享失败
function ShareView:fnMSG_SHARE_FAILED( ... )
	logger:debug("fnMSG_SHARE_FAILED")
	_isSuccess = 1
	if (g_system_type == kBT_PLATFORM_IOS ) then
		self:fnMSG_SHARE_FORGROUND()
	end
end
-- activity回到前台再调用OpenGL绘制，不然会出现纹理全黑
function ShareView:fnMSG_SHARE_FORGROUND( ... )
	if (_isSuccess == 2) then
		ShowNotice.showShellInfo(m_i18n[5804])
		assert(_rewardId ~= 0, "fnMSG_SHARE_SUCCESS:_rewardId SHOULD NOT be NULL")
		_delegate.getShareReward(_rewardId)
	elseif (_isSuccess == 1) then
		ShowNotice.showShellInfo(m_i18n[5805])
		_rewardId = 0
	end
	_isSuccess = 0
end

-- 领取成功
function ShareView:fnMSG_CB_GET_SHARE_REWARD( ... )
	logger:debug("fnMSG_CB_GET_SHARE_REWARD")	
	-- 修改状态
	_sModel.getStatus()[_rewardId] = 1
	-- 显示奖励框
	self:showSuccess(_rewardId)
	-- 刷新界面
	self:reload()
	_rewardId = 0
end

function ShareView:fnMSG_CB_SHARE_RELOAD( ... )
	logger:debug("fnMSG_CB_SHARE_RELOAD")
	self:reload()
end