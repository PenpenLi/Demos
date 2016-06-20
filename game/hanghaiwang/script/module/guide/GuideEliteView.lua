-- FileName: GuideEliteView.lua
-- Author: 
-- Date: 2014-04-00
-- Purpose: function description of module
--[[TODO List]]
-- 精英副本引导


module("GuideEliteView", package.seeall)
require "script/module/public/UIHelper"
 
 guideStep = 0
-- UI控件引用变量 --

-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_mainWidget = nil
local function init(...)

end

function destroy(...)
	package.loaded["GuideEliteView"] = nil
end

function moduleName()
    return "GuideEliteView"
end


function create(step, opacity)
	guideStep = step
	local json = "ui/new_elite_copy.json"
	m_mainWidget = g_fnLoadUI(json)
	m_mainWidget:setSize(g_winSize)
	local LAY_MAIN = m_fnGetWidget(m_mainWidget,"LAY_MAIN")
	

	local count = LAY_MAIN:getChildren():count()
	local LAY_NOMASK1
	logger:debug("LAY_ELITE_STEP" .. step)
	logger:debug("count".. count)


	for i=1,count do
		local layKeyName = "LAY_ELITE_STEP" .. i
		local lay_formation_step = m_fnGetWidget(m_mainWidget,layKeyName)
		
		-- 	-- 精英副本 特殊处理
		if (i==3)then
			local LAY_SCALEY = m_fnGetWidget(lay_formation_step, "LAY_SCALEY")
			-- LAY_SCALEY:setScale(g_fScaleY)
			LAY_SCALEY:setScale(g_winSize.height/1136)
		end

		if(tonumber(step) == i) then
			LAY_NOMASK1 = m_fnGetWidget(lay_formation_step, "LAY_NOMASK" .. step)
			-- local IMG_ARROW_FORMATION1 = m_fnGetWidget(m_mainWidget,"IMG_ARROW_ELITE" .. step)
			-- runMoveAction(IMG_ARROW_FORMATION1)
		else
			lay_formation_step:setVisible(false)
		end
	end

	--创建mask layer
	local priority = g_tbTouchPriority.guide
	local rectTemp = LAY_NOMASK1:boundingBox()

	local worldPos = LAY_NOMASK1:convertToWorldSpace(ccp(0,0))

	local touchRect = CCRectMake(worldPos.x-rectTemp.size.width*.5,worldPos.y-rectTemp.size.height*.5,rectTemp.size.width,rectTemp.size.height)
	local touchCallback = nil
	local layerOpacity = opacity or 150
	local highRect = touchRect--LAY_NOMASK1:boundingBox()
	local layer = UIHelper.createMaskLayer( priority,touchRect ,touchCallback, layerOpacity,highRect)
	layer:addChild(m_mainWidget)
	return layer
end
