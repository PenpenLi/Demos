-- FileName: ExploreKeyCtrl.lua
-- Author: liweidong
-- Date: 2014-04-00
-- Purpose: 一键探索控制器
--[[TODO List]]

module("ExploreKeyCtrl", package.seeall)

-- UI控件引用变量 --
local popLayer = nil  --增加屏蔽
-- 模块局部变量 --
local controlStatus = false --是否处于控制状态当中
local m_fnGetWidget = g_fnGetWidgetByName

local function init(...)

end

function destroy(...)
	package.loaded["ExploreKeyCtrl"] = nil
end

function moduleName()
    return "ExploreKeyCtrl"
end

function create(explorlayer)
	--增加屏蔽，一键探索开始之后 任何位置都不可点击，也不中途停止
	popLayer = OneTouchGroup:create()
	popLayer:setTouchPriority(g_tbTouchPriority.explore)
	local layout = Layout:create()
	layout:setSize(g_winSize)
	layout:setTouchEnabled(true)
	popLayer:addWidget(layout)
	--explorlayer:addNode(popLayer)
	CCDirector:sharedDirector():getRunningScene():addChild(popLayer)
	--在屏蔽层上增加透明一键探索按钮，用于关闭一键探索
	-- local akeyBg = m_fnGetWidget(explorlayer, "lay_cbx")
	-- local pos = akeyBg:getWorldPosition()
	-- local aKeyLayout = tolua.cast(akeyBg:clone(), "Layout")
	
	-- aKeyLayout:removeAllChildrenWithCleanup(true)
	-- aKeyLayout:setPositionType(POSITION_ABSOLUTE)
	-- aKeyLayout:setPosition(pos)
	-- layout:addChild(aKeyLayout)  --如果
	
	--控制探索主界面的一建探索
	local function selectBgEvent(sender, eventType)
		if (eventType ~= TOUCH_EVENT_ENDED) then
			return
		end
		local selectbtn = m_fnGetWidget(explorlayer, "CBX_ONE_KEYBOARD")
		ExplorMainCtrl.onCheckBox(selectbtn,CHECKBOX_STATE_EVENT_UNSELECTED)
		removeKeyExplore()
	end
	layout:addTouchEventListener(selectBgEvent) --修改为点击整个屏幕，如果以后要改回来的话 把本行layout改为aKeyLayout

	controlStatus=true
	ExplorMainCtrl.fnBeginExplore()

	GlobalNotify.addObserver(GlobalNotify.RECONN_OK, removeKeyExplore,true)
	GlobalNotify.addObserver(GlobalNotify.NETWORK_FAILED, removeKeyExplore , true)
end

--移除一键屏蔽层，并停止控制
function removeKeyExplore()
	logger:debug("enter remove key Explore==========")
	if (popLayer) then
		popLayer:removeFromParentAndCleanup(true)
		popLayer=nil
	end
	controlStatus=false
end
--完成一次探索
function completeExplore()
	if (controlStatus) then
		ExplorMainCtrl.fnBeginExplore()
	end
end
--当前是否处于一键探索过程中
function isInKeyExplore()
	return controlStatus
end
--点击获取按钮
function clickGetItemBtn(isAdventure,delayTime)
	delayTime = delayTime==nil and 0 or delayTime
	--logger:deubg("key click get reward")
	if (controlStatus and popLayer) then
		performWithDelay(popLayer,function() 
				ExplorRewardCtrl.showItemRward(popLayer,TOUCH_EVENT_ENDED)
			end
		,0.3+delayTime)
		performWithDelay(popLayer,function()
				if (not isAdventure) then
					ExploreKeyCtrl.completeExplore()
				end
			end
		,0.7+delayTime)
	end
end