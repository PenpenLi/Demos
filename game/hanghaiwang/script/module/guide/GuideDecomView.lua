-- FileName: GuideDecomView.lua
-- Author: huxiaozhou
-- Date: 2014-06-30
-- Purpose: function description of module
--[[TODO List]]
-- 分解室 和 神秘商店引导

module("GuideDecomView", package.seeall)

guideStep = 0
-- UI控件引用变量 --

-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_mainWidget = nil

local function init(...)

end

function destroy(...)
	package.loaded["GuideDecomView"] = nil
end

function moduleName()
    return "GuideDecomView"
end

function create(step,opacity,touchCallback)
	guideStep = step
	local json = "ui/new_decomposition.json"
	m_mainWidget = g_fnLoadUI(json)
	m_mainWidget:setSize(g_winSize)
	local LAY_MAIN = m_fnGetWidget(m_mainWidget,"LAY_MAIN")
	

	local count = LAY_MAIN:getChildren():count()
	local LAY_NOMASK1
	local worldPosTemp = nil
	logger:debug("LAY_DE_STEP" .. step)
	logger:debug("count".. count)
	for i=1,count do
		local layKeyName = "LAY_DE_STEP" .. i
		local lay_formation_step = m_fnGetWidget(m_mainWidget,layKeyName)
		
		if(tonumber(step) == i) then
			if (touchCallback == nil) then
				LAY_NOMASK1 = m_fnGetWidget(lay_formation_step, "LAY_NOMASK" .. step)
				
				-- if(i==3)then
				-- 	local lay_pmd = m_fnGetWidget(lay_formation_step, "lay_pmd")
				-- 	local LAY_SCALEX = m_fnGetWidget(lay_formation_step, "LAY_SCALEX")
					
				-- 	LAY_SCALEX:setSize(CCSizeMake(LAY_SCALEX:getSize().width*g_fScaleX,LAY_SCALEX:getSize().height*g_fScaleX))
				
				-- 	local lay_step3_1 = m_fnGetWidget(lay_formation_step, "lay_step3_1")
				-- 	local worldPosTempY = g_winSize.height - lay_pmd:getSize().height - LAY_SCALEX:getSize().height - lay_step3_1:getSize().height
					
				-- 	local percent = LAY_NOMASK1:getPositionPercent()
				-- 	local tempNodePos = ccp(lay_step3_1:getSize().width*percent.x,lay_step3_1:getSize().height*percent.y)
				-- 	worldPosTemp = ccp(tempNodePos.x,tempNodePos.y+worldPosTempY)
				-- end
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

		local worldPos = worldPosTemp or LAY_NOMASK1:convertToWorldSpace(ccp(0,0))
		logger:debug("worldPos.x = %s, worldPos.y = %s", worldPos.x, worldPos.y)
		local touchRect = CCRectMake(worldPos.x-rectTemp.size.width*.5,worldPos.y-rectTemp.size.height*.5,rectTemp.size.width,rectTemp.size.height)
		-- local touchCallback = nil
		local layerOpacity = opacity or 150
		local highRect = touchRect--LAY_NOMASK1:boundingBox()
		layer = UIHelper.createMaskLayer( priority,touchRect ,nil, layerOpacity,highRect)
		layer:addChild(m_mainWidget)
	else
		layer = UIHelper.createMaskLayer( priority,nil,touchCallback, layerOpacity,nil)
		layer:addChild(m_mainWidget)
	end
	
	return layer
end
