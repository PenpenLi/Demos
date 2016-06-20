-- FileName: GuideRebornView.lua
-- Author: huxiaozhou
-- Date: 2015-01-15	
-- Purpose: 伙伴，装备，宝物 重生引导
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变  
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /


module("GuideRebornView", package.seeall)

guideStep = 0
-- UI控件引用变量 --

-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_mainWidget = nil


local function init(...)

end

function destroy(...)
	package.loaded["GuideRebornView"] = nil
end

function moduleName()
    return "GuideRebornView"
end

function create(step,opacity,touchCallback)
	guideStep = step
	local json = "ui/new_reborn.json"
	m_mainWidget = g_fnLoadUI(json)
	m_mainWidget:setSize(g_winSize)
	local LAY_MAIN = m_fnGetWidget(m_mainWidget,"LAY_MAIN")
	

	local count = LAY_MAIN:getChildren():count()
	local LAY_NOMASK1
	local worldPosTemp = nil
	logger:debug("LAY_REBORN_STEP" .. step)
	logger:debug("count".. count)
	for i=1,count do
		local layKeyName = "LAY_REBORN_STEP" .. i
		local lay_formation_step = m_fnGetWidget(m_mainWidget,layKeyName)
		
		if(tonumber(step) == i) then
			if (touchCallback == nil) then
				LAY_NOMASK1 = m_fnGetWidget(lay_formation_step, "LAY_NOMASK" .. step)
				
				if(i==3)then
					local lay_pmd = m_fnGetWidget(lay_formation_step, "lay_pmd")
					local LAY_SETSIZE = m_fnGetWidget(lay_formation_step, "LAY_SETSIZE")
					
					LAY_SETSIZE:setSize(CCSizeMake(LAY_SETSIZE:getSize().width*g_fScaleX,LAY_SETSIZE:getSize().height*g_fScaleX))
				
					local lay_step3_1 = m_fnGetWidget(lay_formation_step, "lay_step3_1")
					local worldPosTempY = g_winSize.height - lay_pmd:getSize().height - LAY_SETSIZE:getSize().height - lay_step3_1:getSize().height
					
					local lay_step3_2 = m_fnGetWidget(lay_formation_step, "lay_step3_2")

					local percent = LAY_NOMASK1:getPositionPercent()
					local percent1 = lay_step3_2:getPositionPercent()

					local tempNodePos = ccp(lay_step3_1:getSize().width*percent1.x + lay_step3_2:getSize().width*percent.x ,
											lay_step3_1:getSize().height*percent1.y + lay_step3_2:getSize().height*percent.y)

					worldPosTemp = ccp(tempNodePos.x,tempNodePos.y+worldPosTempY)
				end
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

