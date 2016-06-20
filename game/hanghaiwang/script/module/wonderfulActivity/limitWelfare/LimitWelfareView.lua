-- FileName: LimitWelfareView.lua
-- Author: Xufei
-- Date: 2015-01-19
-- Purpose: 限时福利
--[[TODO List]]

LimitWelfareView = class("LimitWelfareView")

-- UI控件引用变量 --

-- 模块局部变量 --
local _layMain = nil
LimitWelfareView.limitWelData = nil
local TITTLE_PIC_PATH = "images/wonderfullAct/"


function LimitWelfareView:labelScaleChangedWithStr( UIlableWidet,textInfo )
    local tfdBeforeSize = UIlableWidet:getContentSize()
    local tfdBeforeSizeHeight = tfdBeforeSize.height  -- 必须把高度值单独取出来放进变量里 否则值会变
    local tfdBeforeSizeWidth = tfdBeforeSize.width  -- 必须把高度值单独取出来放进变量里 否则值会变

    -- UIlableWidet:ignoreContentAdaptWithSize(false)
    UIlableWidet:setSize(CCSizeMake(tfdBeforeSize.width,0))
    UIlableWidet:setText(textInfo)
    local tfdAffterSize =  UIlableWidet:getVirtualRenderer():getContentSize()
    local lineHeightScale = math.ceil(tfdAffterSize.height/tfdBeforeSizeHeight)
    local affterSizeHeight = lineHeightScale * tfdBeforeSizeHeight
    UIlableWidet:setSize(CCSizeMake(tfdBeforeSizeWidth,affterSizeHeight))

    return tfdBeforeSizeWidth,tfdBeforeSizeHeight,affterSizeHeight

end


function LimitWelfareView:showView( ... )
	local data = self.limitWelData

	_layMain.TFD_DESC:setText(data.desc)

	local tittlePath = TITTLE_PIC_PATH..data.title

	_layMain.img_title:loadTexture(tittlePath)

	local descCell = _layMain.LSV_EXHIBIT.TFD_ACTIVITY_DESC
	local itemCell = _layMain.LSV_EXHIBIT.LAY_REWARDS
	local listView = _layMain.LSV_EXHIBIT

	UIHelper.initListView(listView)
	listView:removeAllItems()

	listView:pushBackCustomItem(descCell)
	listView:pushBackCustomItem(itemCell)

	local cellDesc = listView:getItem(0)
	local cellItem = listView:getItem(1)
	self:labelScaleChangedWithStr(cellDesc, data.output)

	-- 是否有额外掉落
	if (data.reward and data.reward~="") then 
		local listViewIcon = cellItem.LSV_REWARDS
		UIHelper.initListView(listViewIcon)
		local tbItemlist = lua_string_split(data.reward, "|")
		listViewIcon:removeAllItems()
		for key, itemId in ipairs( tbItemlist ) do
			listViewIcon:pushBackDefaultItem()
			local icon = ItemUtil.createBtnByItem( ItemUtil.getItemById(tonumber(itemId)), function ( sender,eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					PublicInfoCtrl.createItemInfoViewByTid(tonumber(itemId))
				end
			end)
			local iconCell = listViewIcon:getItem(key-1)
			icon:setPosition(ccp(iconCell:getContentSize().width/2, iconCell:getContentSize().height/2))
			iconCell:addChild(icon)
		end
		UIHelper.setSliding(listViewIcon, true)
	else 
		local listViewIcon = cellItem.LSV_REWARDS
		listViewIcon:setVisible(false)
	end 

	UIHelper.setSliding(listView)
end

function LimitWelfareView:init(...)

end

function LimitWelfareView:destroy(...)
	package.loaded["LimitWelfareView"] = nil
end

function LimitWelfareView:moduleName()
    return "LimitWelfareView"
end

function LimitWelfareView:ctor( ... )
	self.layMain = g_fnLoadUI("ui/activity_timelimit_welfare.json")
end

function LimitWelfareView:create( limitWelData )
	_layMain = self.layMain

	local function updateActivityTime()
		_layMain.tfd_time_num:setText(LimitWelfareModel:getCountDownTime())
	end

	UIHelper.registExitAndEnterCall(_layMain,
		function()
			GlobalScheduler.removeCallback("updateLimitWelfareActivityTime")
			LimitWelfareModel.destroy()
		end,
		function()
			GlobalScheduler.addCallback("updateLimitWelfareActivityTime", updateActivityTime)
		end
	)

	updateActivityTime()

	_layMain.img_main_bg:setScaleX(g_fScaleX)	--背景适配屏幕
	_layMain.img_decorate1:setScale(g_fScaleX)
	--_layMain.img_decorate1:setScaleY(g_fScaleY)
	_layMain.img_body:setScale(g_fScaleX)
	--_layMain.img_body:setScaleY(g_fScaleY)	
	
	UIHelper.labelNewStroke( _layMain.tfd_time_num )
	UIHelper.labelNewStroke( _layMain.tfd_time )

	self.limitWelData = limitWelData
	self:showView()
	return _layMain
end
