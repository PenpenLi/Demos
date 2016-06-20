-- FileName: GuideExploreView.lua
-- Author: huxiaozhou
-- Date: 2014-10-27
-- Purpose: 探索引导 显示
--[[TODO List]]

--                    _ooOoo_
--                   o8888888o
--                   88" . "88
--                   (| -_- |)
--                   O\  =  /O
--                ____/`---'\____
--              .'  \|     |//  `.
--             /  \|||  :  |||//  \
--            /  _||||| -:- |||||-  \
--            |   | \\  -  /// |   |
--            | \_|  ''\---/''  |   |
--            \  .-\__  `-`  ___/-. /
--          ___`. .'  /--.--\  `. . __
--       ."" '<  `.___\_<|>_/___.'  >'"".
--      | | :  `- \`.;`\ _ /`;.`/ - ` : | |
--      \  \ `-.   \_ __\ /__ _/   .-` /  /
-- ======`-.____`-.___\_____/___.-`____.-'======
--                    `=---='
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--          佛祖保佑       永无BUG


-- /


module("GuideExploreView", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --
guideStep = 0
local m_fnGetWidget = g_fnGetWidgetByName
local m_mainWidget = nil

local function init(...)

end

function destroy(...)
	package.loaded["GuideExploreView"] = nil
end

function moduleName()
    return "GuideExploreView"
end

function create(step, opacity, touchCallback)
		guideStep = step
	local json = "ui/new_explore.json"
	m_mainWidget = g_fnLoadUI(json)
	m_mainWidget:setSize(g_winSize)
	local LAY_MAIN = m_fnGetWidget(m_mainWidget,"LAY_MAIN")
	

	local count = LAY_MAIN:getChildren():count()
	local LAY_NOMASK1
	logger:debug("LAY_EXPLORE_STEP" .. step)
	logger:debug("count".. count)
	for i=1,count do
		local layKeyName = "LAY_EXPLORE_STEP" .. i
		local lay_formation_step = m_fnGetWidget(m_mainWidget,layKeyName)
		-- 副本地图特殊处理
		if (i==2)then
			local LAY_SCALEY = m_fnGetWidget(lay_formation_step, "LAY_SCALEY")
			LAY_SCALEY:setScale(g_winSize.height/1136)
		end

		-- if (i==5) then
		-- 	local lay_step5_1 = m_fnGetWidget(lay_formation_step, "lay_step5_1")
		-- 	local oldSize = lay_step5_1:getSize()
		-- 	lay_step5_1:setSize(CCSizeMake(oldSize.width*g_fScaleX,oldSize.height*g_fScaleX))
		-- end
		-- if (i==6) then
		-- 	local lay_step6_1 = m_fnGetWidget(lay_formation_step, "lay_step_6_1")
		-- 	local oldSize = lay_step6_1:getSize()
		-- 	lay_step6_1:setSize(CCSizeMake(oldSize.width*g_fScaleX,oldSize.height*g_fScaleX))
		-- end

		if(tonumber(step) == i) then
			if (touchCallback == nil) then
				LAY_NOMASK1 = m_fnGetWidget(lay_formation_step, "LAY_NOMASK" .. step)
				-- local IMG_ARROW_FORMATION1 = m_fnGetWidget(m_mainWidget,"IMG_ARROW_EXPLORE" .. step)
				-- runMoveAction(IMG_ARROW_FORMATION1)
			end
		else
			lay_formation_step:setVisible(false)
		end
	end
	--创建mask layer
	local priority = g_tbTouchPriority.guide
	local layer
	if (not touchCallback) then
		local rectTemp = LAY_NOMASK1:boundingBox()

		local worldPos = LAY_NOMASK1:convertToWorldSpace(ccp(0,0))

		local touchRect = CCRectMake(worldPos.x-rectTemp.size.width*.5,worldPos.y-rectTemp.size.height*.5,rectTemp.size.width,rectTemp.size.height)
		-- local touchCallback = nil
		local layerOpacity = opacity or 150
		local highRect = touchRect--LAY_NOMASK1:boundingBox()


		local maskRect = nil
		if (step == 6) then
			maskRect = touchRect
			touchRect = CCRectMake(0,0,g_winSize.width,g_winSize.height)
			touchCallback = function () 
				GuideCtrl.removeGuide()
			end
		end

		layer = UIHelper.createMaskLayer( priority,touchRect ,touchCallback, layerOpacity,highRect,maskRect)
		layer:addChild(m_mainWidget)
	else
		layer = UIHelper.createMaskLayer( priority,nil,touchCallback, layerOpacity,nil)
		layer:addChild(m_mainWidget)
	end
	
	return layer
end
