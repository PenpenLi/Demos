-- FileName: UpdateView.lua
-- Author: zhangqi
-- Date: 2014-08-02
-- Purpose: 资源更新控制模块
--[[TODO List]]
--[[ modified
2015-04-17, 给主画布加上onExit回调方法，释放所有控件引用变量，用于在updateProcess和showUnzipText方法中作为判断条件不刷新UI
]]

-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString = gi18nString
local m_fnGetWidget = g_fnGetWidgetByName

UpdateView = class("UpdateView")

function UpdateView:ctor()
	self.mLayoutMain = g_fnLoadUI("ui/regist_update.json")

	local function onExit()
		self:destroy()
	end

	UIHelper.registExitAndEnterCall(tolua.cast(self.mLayoutMain, "CCNode"), onExit)
end

function UpdateView:moduleName( ... )
	return "UpdateView"
end

function UpdateView:destroy( ... )
	logger:debug("UpdateView.destroy")
	-- package.loaded["script/module/update/UpdateView"] = nil

	self.mLayoutMain = nil
	-- self.mLabPercent = nil -- 进度百分比数字
-- local mLoadBar -- 进度
	self.mImgBall = nil -- 进度条上的球图标
	self.mLabByte = nil -- 当前已下载的字节数

	self.m_ccpBall = nil -- 进度船的坐标百分比
	self.m_ccpBallX = nil -- 进度船x坐标百分比
	self.m_szBall = nil -- 进度船的size
	self.m_percentBall = nil -- 进度船实际滑过长度占进度条总长的百分比，用于根据下载百分比换算船当前的坐标百分比
	self.m_ballPercent = nil -- 每次下载回调时进度船的坐标百分比
end

function UpdateView:create(...)
	-- self.mLayoutMain = g_fnLoadUI("ui/regist_update.json")
	local imgLogo = m_fnGetWidget(self.mLayoutMain, "img_logo")
	imgLogo:setEnabled(false) -- zhangqi, 2015-05-20, 360测试隐藏logo
	
	local imgCloud = m_fnGetWidget(self.mLayoutMain, "img_cloud")
	imgCloud:setScale(g_fScaleX)

	local imgMap = m_fnGetWidget(self.mLayoutMain, "IMG_MAP")

	local imgBG = m_fnGetWidget(self.mLayoutMain, "img_bg")
	local imgLoadBG = m_fnGetWidget(self.mLayoutMain, "img_load_bg")
	local imgMB = m_fnGetWidget(self.mLayoutMain, "IMG_MENGBAN")
	imgBG:setScale(g_fScaleX)
	imgLoadBG:setScale(g_fScaleX)
	imgLoadBG.img_bubble:setScale(g_fScaleX)
	imgMB:setScale(g_fScaleX)

	-- mLoadBar = m_fnGetWidget(self.mLayoutMain, "LOAD_BAR") -- 进度条
	-- mLoadBar:setPercent(0)
	-- m_szLoadBar = mLoadBar:getSize()
	self.mImgBall = m_fnGetWidget(self.mLayoutMain, "IMG_PROGRESS_BALL") -- 进度条上的球图标
	self.m_szBall = self.mImgBall:getSize()

	self.m_ccpBall = self.mImgBall:getPositionPercent()
	self.m_ccpBallX = self.m_ccpBall.x
	self.m_percentBall = 1 -- - (self.m_szBall.width/m_szLoadBar.width)

	-- self.mLabPercent = m_fnGetWidget(self.mImgBall, "TFD_PERCENT") -- 球图标上的气泡的百分比数字
	-- self.mLabPercent:setText("0%")

	self.mLabByte = m_fnGetWidget(self.mLayoutMain, "TFD_BYTE") -- 进度条下的已下载字节数
	UIHelper.labelShadow(self.mLabByte, CCSizeMake(3, -3))
	self.mLabByte:setEnabled(false)

	-- AppStore审核
	if (Platform.isAppleReview()) then
		self.mLabByte:setEnabled(false)
	end

	return self.mLayoutMain
end

function UpdateView:updateProcess(totalSize, downloadedSize, nPercent )
	if (not self.mLabByte or tolua.isnull(self.mLabByte)) then
		return
	end

	if (not self.mLabByte:isEnabled()) then
		self.mLabByte:setEnabled(true)
	end
	-- AppStore审核
	if (Platform.isAppleReview()) then
		self.mLabByte:setEnabled(false)
	end

		-- zhangqi, 2016-02-02, 简单处理更新最后当前已下载的字节数比总字节数大的问题，可能是由于多级转换的误差导致的
	if (downloadedSize > totalSize) then
		downloadedSize = totalSize
	end
	
	self.mLabByte:setText(m_i18nString(4205, downloadedSize, totalSize))

	-- mLoadBar:setPercent((nPercent > 100) and 100 or nPercent)

	-- self.mLabPercent:setText(string.format("%d%%", nPercent))

	self.m_ballPercent = (nPercent/100 * self.m_percentBall + self.m_ccpBallX)
	self.m_ballPercent = self.m_ballPercent > 0.5 and 0.5 or self.m_ballPercent -- 避免进度条右边超过边界导致左边出现空白

	logger:debug("self.m_ccpBall.x = %f, self.m_percentBall = %f, nPercent = %f, self.m_ballPercent = %f", self.m_ccpBallX, self.m_percentBall, nPercent, self.m_ballPercent)
	self.mImgBall:setPositionPercent(ccp(self.m_ballPercent, self.m_ccpBall.y))
end

function UpdateView:showUnzipText( ... )
	if (not self.mLabByte or tolua.isnull(self.mLabByte)) then
		return
	end

	self.mLabByte:setText(m_i18n[4206])
	-- mLoadBar:setPercent(100)

	logger:debug("self.m_ccpBall.x = %f, self.m_ballPercent = %f", self.m_ccpBallX, self.m_ballPercent)
	self.mImgBall:setPositionPercent(ccp(self.m_ballPercent, self.m_ccpBall.y))
end

--[[desc:用
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function UpdateView:fakeUpdateProcess(  )
	self.mLabByte:setEnabled(true)
	self.mLabByte:setText("正在拉取服务器信息")
	self.mImgBall:runAction(CCMoveBy:create(g_HttpConnTimeout, ccp(g_winSize.width, 0)))
end

function UpdateView:stopProcess( ... )
	self.mImgBall:stopAllActions()
end

function UpdateView:setProcessFull( ... )
	self.mImgBall:setPositionPercent(ccp(self.m_percentBall + self.m_ccpBallX, self.m_ccpBall.y))
end

