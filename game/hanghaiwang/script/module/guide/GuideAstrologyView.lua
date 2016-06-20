-- FileName: GuideAstrologyView.lua
-- Author: huxiaozhou
-- Date: 2014-07-01
-- Purpose: function description of module
--[[TODO List]]

module("GuideAstrologyView", package.seeall)


guideStep = 0
-- UI控件引用变量 --

-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_mainWidget = nil

local function init(...)

end

function destroy(...)
	package.loaded["GuideAstrologyView"] = nil
end

function moduleName()
    return "GuideAstrologyView"
end

function create(step, opacity, touchCallback)
	guideStep = step
	local json = "ui/new_astrology.json"
	m_mainWidget = g_fnLoadUI(json)
	m_mainWidget:setSize(g_winSize)
	local LAY_MAIN = m_fnGetWidget(m_mainWidget,"LAY_MAIN")
	

	local count = LAY_MAIN:getChildren():count()
	local LAY_NOMASK1
	local LAY_LIGHT
	logger:debug("LAY_ASTROLOGY_STEP" .. step)
	logger:debug("count".. count)
	for i=1,count do
		local layKeyName = "LAY_ASTROLOGY_STEP" .. i
		local lay_formation_step = m_fnGetWidget(m_mainWidget,layKeyName)
		
		if(tonumber(step) == i) then
			if (step ~= 3) then
				LAY_NOMASK1 = m_fnGetWidget(lay_formation_step, "LAY_NOMASK" .. step)
				-- local IMG_ARROW_FORMATION1 = m_fnGetWidget(m_mainWidget,"IMG_ARROW_ASTROLOGY" .. step)
				-- runMoveAction(IMG_ARROW_FORMATION1)
				if (step == 4 or step == 5 or step == 6 or step == 7) then
					LAY_LIGHT = m_fnGetWidget(lay_formation_step, "LAY_LIGHT" .. step)
				end
			end
		else
			lay_formation_step:setVisible(false)
		end
	end

	--创建mask layer
	local priority = g_tbTouchPriority.guide
	local layerOpacity = opacity or 150
	local layer
	if (not touchCallback) then
		local rectTemp = LAY_NOMASK1:boundingBox()

		local worldPos = LAY_NOMASK1:convertToWorldSpace(ccp(0,0))

		local touchRect = CCRectMake(worldPos.x-rectTemp.size.width*.5,worldPos.y-rectTemp.size.height*.5,rectTemp.size.width,rectTemp.size.height)
		-- local touchCallback = nil
		local highRect = touchRect--LAY_NOMASK1:boundingBox()
		if (LAY_LIGHT ) then
			logger:debug("LAY_LIGHTLAY_LIGHTLAY_LIGHTLAY_LIGHTLAY_LIGHTLAY_LIGHT")
			local rectTemp1 = LAY_LIGHT:boundingBox()
			local worldPos1 = LAY_LIGHT:convertToWorldSpace(ccp(0,0))
			highRect = CCRectMake(worldPos1.x-rectTemp1.size.width*.5,worldPos1.y-rectTemp1.size.height*.5,rectTemp1.size.width,rectTemp1.size.height)
		end

		layer = UIHelper.createMaskLayer( priority,touchRect ,nil, layerOpacity,highRect)
		


		layer:addChild(m_mainWidget)
	else
		layer = UIHelper.createMaskLayer( priority,nil,touchCallback, layerOpacity,nil)
		layer:addChild(m_mainWidget)
	end
	return layer
end
