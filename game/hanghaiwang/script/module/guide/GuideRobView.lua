-- FileName: GuideRobView.lua
-- Author: huxiaozhou
-- Date: 2014-06-26
-- Purpose: function description of module
--[[TODO List]]
-- 夺宝 引导

module("GuideRobView", package.seeall)

guideStep = 0
-- UI控件引用变量 --

-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_mainWidget = nil

local function init(...)

end

function destroy(...)
	package.loaded["GuideRobView"] = nil
end

function moduleName()
    return "GuideRobView"
end

function create(step, opacity, pos, touchCallback)
	guideStep = step
	local json = "ui/new_rob.json"
	m_mainWidget = g_fnLoadUI(json)
	m_mainWidget:setSize(g_winSize)
	local LAY_MAIN = m_fnGetWidget(m_mainWidget,"LAY_MAIN")
	

	local count = LAY_MAIN:getChildren():count()
	local LAY_NOMASK1
	logger:debug("LAY_ROB_STEP" .. step)
	logger:debug("count".. count)

	local worldPosTemp = pos
	local rectTemp1 = nil

	for i=1,count do
		local layKeyName = "LAY_ROB_STEP" .. i
		local lay_formation_step = m_fnGetWidget(m_mainWidget,layKeyName)
		if(tonumber(step) == i) then
			if i~=7 then
				LAY_NOMASK1 = m_fnGetWidget(lay_formation_step, "LAY_NOMASK" .. step)
			end

			-- if (step == 1) then
			-- 	local lay_step1_1 = m_fnGetWidget(lay_formation_step, "lay_step1_1")
			-- 	local lay_step1_2 = m_fnGetWidget(lay_formation_step, "lay_step1_2")
				
			-- 	local parameter = lay_step1_1:getLayoutParameter(LAYOUT_PARAMETER_RELATIVE)
			-- 	local margin = parameter:getMargin()
			-- 	local bottom = margin.bottom


			-- 	local percent = LAY_NOMASK1:getPositionPercent()
			-- 	local percent1 = lay_step1_2:getPositionPercent()
			-- 	local size1_2 = lay_step1_2:getSize()
			-- 	local size1_1 = lay_step1_1:getSize()

			-- 	local tempNodePos = ccp(size1_2.width*percent.x, size1_2.height*percent.y)
			-- 	local tempNodePos1 = ccp(size1_1.width*percent1.x, size1_1.height*percent1.y)
			-- 	worldPosTemp = ccp((g_winSize.width - size1_1.width)/2 + tempNodePos1.x + tempNodePos.x  ,bottom+tempNodePos1.y+tempNodePos.y)

			-- 	logger:debug("bottom = " .. bottom)
			-- end


			-- if (step == 4) then
			-- 	local lay_pmd = m_fnGetWidget(lay_formation_step, "lay_pmd")
			-- 	local LAY_SETSIZE = m_fnGetWidget(lay_formation_step, "LAY_SETSIZE")
			-- 	LAY_SETSIZE:setSize(CCSizeMake(LAY_SETSIZE:getSize().width*g_fScaleX,LAY_SETSIZE:getSize().height*g_fScaleX))

			-- 	local lay_step4_1 = m_fnGetWidget(lay_formation_step, "lay_step4_1")

			-- 	local worldPosTempY = g_winSize.height - lay_pmd:getSize().height - lay_step4_1:getSize().height - LAY_SETSIZE:getSize().height
			-- 	worldPosTemp = lay_step4_1:convertToWorldSpace(ccp(0,0))

			-- 	logger:debug("lay_pmd:getSize().height = %s", lay_pmd:getSize().height)

			-- 	logger:debug("g_winSize.height = %s", g_winSize.height)

			-- 	logger:debug("lay_step4_1:getSize().height = %s", lay_step4_1:getSize().height)

			-- 	logger:debug("LAY_SETSIZE:getSize().height = %s", LAY_SETSIZE:getSize().height)

			-- 	logger:debug("worldPosTempY = %s", worldPosTempY)
			-- 	logger:debug(" worldPosTemp.x = %s , worldPosTemp.y = %s ", worldPosTemp.x, worldPosTemp.y)
			-- 	local lay_step4_2 = m_fnGetWidget(lay_formation_step, "lay_step4_2")

			-- 	local lay_step4_3 = m_fnGetWidget(lay_formation_step, "lay_step4_3")

			-- 	local parameter = lay_step4_2:getLayoutParameter(LAYOUT_PARAMETER_RELATIVE)
			-- 	local margin = parameter:getMargin()
			-- 	local top = margin.top


			-- 	local percent = LAY_NOMASK1:getPositionPercent()
			-- 	local percent2 = lay_step4_3:getPositionPercent()

			-- 	logger:debug(" percent.x = %s , percent.y = %s ", percent.x, percent.y)

			-- 	worldPosTemp = ccp(lay_step4_2:getSize().width*percent2.x + lay_step4_3:getSize().width*percent.x 
			-- 						+ (g_winSize.width-lay_step4_2:getSize().width)/2,
			-- 						worldPosTempY + lay_step4_2:getSize().height*percent2.y 
			-- 						+ lay_step4_3:getSize().height*percent.y + lay_step4_1:getSize().height - lay_step4_2:getSize().height - top)

			-- 	logger:debug(" worldPosTemp.x = %s , worldPosTemp.y = %s ", worldPosTemp.x, worldPosTemp.y)
			-- 	LAY_NOMASK1:setSize(CCSizeMake(LAY_NOMASK1:getSize().width,LAY_NOMASK1:getSize().height))
			-- 	rectTemp1 =LAY_NOMASK1:getSize()
			-- end

			-- if (step == 8) then
			-- 	local lay_pmd = m_fnGetWidget(lay_formation_step, "lay_pmd")
			-- 	local LAY_SETSIZE = m_fnGetWidget(lay_formation_step, "LAY_SETSIZE")
			-- 	LAY_SETSIZE:setSize(CCSizeMake(LAY_SETSIZE:getSize().width*g_fScaleX,LAY_SETSIZE:getSize().height*g_fScaleX))

			-- 	local lay_step4_1 = m_fnGetWidget(lay_formation_step, "lay_step8_1")

			-- 	local worldPosTempY = g_winSize.height - lay_pmd:getSize().height - lay_step4_1:getSize().height - LAY_SETSIZE:getSize().height
			-- 	worldPosTemp = lay_step4_1:convertToWorldSpace(ccp(0,0))

			-- 	logger:debug("lay_pmd:getSize().height = %s", lay_pmd:getSize().height)

			-- 	logger:debug("g_winSize.height = %s", g_winSize.height)

			-- 	logger:debug("lay_step4_1:getSize().height = %s", lay_step4_1:getSize().height)

			-- 	logger:debug("LAY_SETSIZE:getSize().height = %s", LAY_SETSIZE:getSize().height)

			-- 	logger:debug("worldPosTempY = %s", worldPosTempY)
			-- 	logger:debug(" worldPosTemp.x = %s , worldPosTemp.y = %s ", worldPosTemp.x, worldPosTemp.y)
			-- 	local lay_step4_2 = m_fnGetWidget(lay_formation_step, "lay_step8_2")

			-- 	local lay_step4_3 = m_fnGetWidget(lay_formation_step, "lay_step8_3")


			-- 	local parameter = lay_step4_2:getLayoutParameter(LAYOUT_PARAMETER_RELATIVE)
			-- 	local margin = parameter:getMargin()
			-- 	local top = margin.top


			-- 	local percent = LAY_NOMASK1:getPositionPercent()
			-- 	local percent2 = lay_step4_3:getPositionPercent()

			-- 	logger:debug(" percent.x = %s , percent.y = %s ", percent.x, percent.y)

			-- 	worldPosTemp = ccp(lay_step4_2:getSize().width*percent2.x + lay_step4_3:getSize().width*percent.x 
			-- 						+ (g_winSize.width-lay_step4_2:getSize().width)/2,
			-- 						worldPosTempY + lay_step4_2:getSize().height*percent2.y 
			-- 						+ lay_step4_3:getSize().height*percent.y + lay_step4_1:getSize().height - lay_step4_2:getSize().height - top)

			-- 	logger:debug(" worldPosTemp.x = %s , worldPosTemp.y = %s ", worldPosTemp.x, worldPosTemp.y)
			-- 	LAY_NOMASK1:setSize(CCSizeMake(LAY_NOMASK1:getSize().width,LAY_NOMASK1:getSize().height))
			-- 	rectTemp1 =LAY_NOMASK1:getSize()
			-- end

			-- if (i==3) then
			-- 	local lay_pmd = m_fnGetWidget(lay_formation_step, "lay_pmd")
			-- 	local LAY_SETSIZE = m_fnGetWidget(lay_formation_step, "LAY_SETSIZE")
			-- 	LAY_SETSIZE:setSize(CCSizeMake(LAY_SETSIZE:getSize().width*g_fScaleX,LAY_SETSIZE:getSize().height*g_fScaleX))
				
			-- 	local lay_step2_2 = m_fnGetWidget(lay_formation_step, "lay_step3_2")
			-- 	lay_step2_2:setSize(CCSizeMake(lay_step2_2:getSize().width*g_fScaleX,lay_step2_2:getSize().height*g_fScaleX))

			-- 	local lay_step2_3 = m_fnGetWidget(lay_formation_step, "lay_step3_3")
			-- 	lay_step2_3:setSize(CCSizeMake(lay_step2_3:getSize().width*g_fScaleX,lay_step2_3:getSize().height*g_fScaleX))

			-- 	local worldPosTempY = g_winSize.height - lay_pmd:getSize().height - lay_step2_2:getSize().height - LAY_SETSIZE:getSize().height
				
			-- 	local percent = LAY_NOMASK1:getPositionPercent()
			-- 	local tempNodePos = ccp(lay_step2_2:getSize().width*percent.x,lay_step2_2:getSize().height*percent.y)
			-- 	worldPosTemp = ccp(tempNodePos.x,tempNodePos.y+worldPosTempY)
			-- 	rectTemp1 =LAY_NOMASK1:getSize()
			-- end
		else
			lay_formation_step:setVisible(false)
		end
	end
	--创建mask layer
	local priority = g_tbTouchPriority.guide
	local layer
	if (not touchCallback) then

		local rectTemp = rectTemp1 or CCSizeMake(LAY_NOMASK1:getSize().width,LAY_NOMASK1:getSize().height)

		local worldPos = worldPosTemp or LAY_NOMASK1:convertToWorldSpace(ccp(0,0))

		local touchRect = CCRectMake(worldPos.x-rectTemp.width*.5, worldPos.y-rectTemp.height*.5, rectTemp.width,rectTemp.height)
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
