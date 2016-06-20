-- FileName: GuideLitFmtView.lua
-- Author: huxiaozhou
-- Date: January 24, 2015
-- Purpose: 阵容小伙伴引导
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变  
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /


module("GuideLitFmtView", package.seeall)

guideStep = 0
-- UI控件引用变量 --

-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_mainWidget = nil


local function init(...)

end

function destroy(...)
	package.loaded["GuideLitFmtView"] = nil
end

function moduleName()
    return "GuideLitFmtView"
end


function create(step,opacity,touchCallback)
	guideStep = step
	local json = "ui/new_small.json"
	m_mainWidget = g_fnLoadUI(json)
	m_mainWidget:setSize(g_winSize)
	local LAY_MAIN = m_fnGetWidget(m_mainWidget,"LAY_MAIN")
	

	local count = LAY_MAIN:getChildren():count()
	local LAY_NOMASK1
	logger:debug("LAY_SMALL_STEP" .. step)
	logger:debug("count".. count)
	local worldPosTemp = nil
	local rectTemp1 = nil
	for i=1,count do
		local layKeyName = "LAY_SMALL_STEP" .. i
		local lay_formation_step = m_fnGetWidget(m_mainWidget,layKeyName)

		if(tonumber(step) == i) then
			if (touchCallback == nil) then
				LAY_NOMASK1 = m_fnGetWidget(lay_formation_step, "LAY_NOMASK" .. step)

				if (i==2) then
					logger:debug("begin guideStep 2")
					local lay_step2_1 = m_fnGetWidget(lay_formation_step, "lay_step2_1")
					local lay_step2_2 = m_fnGetWidget(lay_formation_step, "lay_step2_2")
					local lay_step2_3 = m_fnGetWidget(lay_formation_step, "lay_step2_3")

					local parameter = lay_step2_3:getLayoutParameter(LAYOUT_PARAMETER_RELATIVE)
					local margin = parameter:getMargin()
					local right = 0--margin.right
					logger:debug(right)


					worldPosTemp = lay_step2_1:convertToWorldSpace(ccp(0,0))
					logger:debug("worldPosTemp.x ==" .. worldPosTemp.x)
					logger:debug("worldPosTemp.y ==" .. worldPosTemp.y)

					local x,y = lay_step2_2:getPosition()
					worldPosTemp = ccp(worldPosTemp.x + x , worldPosTemp.y + y)
					
					logger:debug("worldPosTemp.x ==" .. worldPosTemp.x)
					logger:debug("worldPosTemp.y ==" .. worldPosTemp.y)

					worldPosTemp = ccp(worldPosTemp.x + (lay_step2_2:getSize().width - right - lay_step2_3:getSize().width),
										 worldPosTemp.y + (lay_step2_2:getSize().height - lay_step2_3:getSize().height)/2)
					logger:debug("worldPosTemp.x ==" .. worldPosTemp.x)
					logger:debug("worldPosTemp.y ==" .. worldPosTemp.y)

					local percent = LAY_NOMASK1:getPositionPercent()
					local tempNodePos = ccp(lay_step2_3:getSize().width*percent.x,lay_step2_3:getSize().height*percent.y)
					logger:debug("tempNodePos.x ==" .. tempNodePos.x)
					logger:debug("tempNodePos.y ==" .. tempNodePos.y)
					worldPosTemp = ccp(tempNodePos.x + worldPosTemp.x,tempNodePos.y+worldPosTemp.y)
					logger:debug("worldPosTemp.x ==" .. worldPosTemp.x)
					logger:debug("worldPosTemp.y ==" .. worldPosTemp.y)
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
		local rectTemp = rectTemp1 or CCSizeMake(LAY_NOMASK1:getSize().width,LAY_NOMASK1:getSize().height)

		local worldPos = worldPosTemp  or LAY_NOMASK1:convertToWorldSpace(ccp(0,0))

		local touchRect = CCRectMake(worldPos.x-rectTemp.width*.5,worldPos.y-rectTemp.height*.5,rectTemp.width,rectTemp.height)
		local highRect = touchRect
		layer = UIHelper.createMaskLayer( priority,touchRect ,nil, layerOpacity,highRect)
		layer:addChild(m_mainWidget)
	else
		layer = UIHelper.createMaskLayer( priority,nil,touchCallback, layerOpacity,nil)
		layer:addChild(m_mainWidget)
	end
	
	return layer
end
