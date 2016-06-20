-- FileName: GuideAcopyView.lua
-- Author: huxiaozhou
-- Date: 2015-03-09
-- Purpose: 新手引导 活动副本
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变  
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /


module("GuideAcopyView", package.seeall)

guideStep = 0
-- UI控件引用变量 --

-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_mainWidget = nil


local function init(...)

end

function destroy(...)
	package.loaded["GuideAcopyView"] = nil
end

function moduleName()
    return "GuideAcopyView"
end

function create(step,opacity,touchCallback, pos)
	guideStep = step
	local json = "ui/new_acopy.json"
	m_mainWidget = g_fnLoadUI(json)
	m_mainWidget:setSize(g_winSize)
	local LAY_MAIN = m_fnGetWidget(m_mainWidget,"LAY_MAIN")
	

	local count = LAY_MAIN:getChildren():count()
	local LAY_NOMASK1
	logger:debug("LAY_ACOPY_STEP" .. step)
	logger:debug("count".. count)
	local worldPosTemp = nil
	local rectTemp1 = nil
	for i=1,count do
		local layKeyName = "LAY_ACOPY_STEP" .. i
		local lay_formation_step = m_fnGetWidget(m_mainWidget,layKeyName)

		if(tonumber(step) == i) then
			if (touchCallback == nil) then
				LAY_NOMASK1 = m_fnGetWidget(lay_formation_step, "LAY_NOMASK" .. step)
					
				-- if (i==2) then
				-- 	local lay_pmd = m_fnGetWidget(lay_formation_step, "lay_pmd")
				-- 	-- local lay_rob = m_fnGetWidget(lay_formation_step, "lay_rob")
				-- 	-- lay_rob:setSize(CCSizeMake(lay_rob:getSize().width*g_fScaleX,lay_rob:getSize().height*g_fScaleX))
				-- 	local LAY_SETSIZE = m_fnGetWidget(lay_formation_step, "LAY_SETSIZE")
				-- 	LAY_SETSIZE:setSize(CCSizeMake(LAY_SETSIZE:getSize().width*g_fScaleX,LAY_SETSIZE:getSize().height*g_fScaleX))
					
				-- 	local lay_step2_2 = m_fnGetWidget(lay_formation_step, "lay_step2_2")
				-- 	lay_step2_2:setSize(CCSizeMake(lay_step2_2:getSize().width*g_fScaleX,lay_step2_2:getSize().height*g_fScaleX))

				-- 	local lay_step2_3 = m_fnGetWidget(lay_formation_step, "lay_step2_3")
				-- 	lay_step2_3:setSize(CCSizeMake(lay_step2_3:getSize().width*g_fScaleX,lay_step2_3:getSize().height*g_fScaleX))

				-- 	local worldPosTempY = g_winSize.height - lay_pmd:getSize().height - lay_step2_2:getSize().height - LAY_SETSIZE:getSize().height
					
				-- 	local percent = LAY_NOMASK1:getPositionPercent()
				-- 	local tempNodePos = ccp(lay_step2_2:getSize().width*percent.x,lay_step2_2:getSize().height*percent.y)
				-- 	worldPosTemp = ccp(tempNodePos.x,tempNodePos.y+worldPosTempY)
				-- 	rectTemp1 =LAY_NOMASK1:getSize()
				-- end
				-- if i==4 then
				-- 	local LAY_SCALEX = m_fnGetWidget(lay_formation_step, "LAY_SCALEX")
				-- 	LAY_SCALEX:setSize(CCSizeMake(LAY_SCALEX:getSize().width*g_fScaleX,LAY_SCALEX:getSize().height*g_fScaleX)) 
				-- end
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
		local  tempPos = pos or worldPos
		logger:debug("tempPos.x = %f, tempPos.y = %f", tempPos.x, tempPos.y)
		local touchRect = CCRectMake(tempPos.x-rectTemp.width*.5, tempPos.y-rectTemp.height*.5, rectTemp.width,rectTemp.height)		-- local touchCallback = nil
		local highRect = touchRect--LAY_NOMASK1:boundingBox()
		layer = UIHelper.createMaskLayer( priority,touchRect ,nil, layerOpacity,highRect)
		layer:addChild(m_mainWidget)
	else
		layer = UIHelper.createMaskLayer( priority,nil,touchCallback, layerOpacity,nil)
		layer:addChild(m_mainWidget)
	end
	
	return layer
end
