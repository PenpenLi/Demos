-- FileName: GuideGuildView.lua
-- Author: huxiaozhou
-- Date: January 24, 2015
-- Purpose: 联盟系统 引导
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变  
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /


module("GuideGuildView", package.seeall)

guideStep = 0
-- UI控件引用变量 --

-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_mainWidget = nil

local function init(...)

end

function destroy(...)
	package.loaded["GuideGuildView"] = nil
end

function moduleName()
    return "GuideGuildView"
end


function create(step,opacity,touchCallback)
	guideStep = step
	local json = "ui/new_union.json"
	m_mainWidget = g_fnLoadUI(json)
	m_mainWidget:setSize(g_winSize)
	local LAY_MAIN = m_fnGetWidget(m_mainWidget,"LAY_MAIN")
	

	local count = LAY_MAIN:getChildren():count()
	local LAY_NOMASK1
	logger:debug("LAY_UNION_STEP" .. step)
	logger:debug("count".. count)
	local worldPosTemp = nil
	local rectTemp1 = nil
	for i=1,count do
		local layKeyName = "LAY_UNION_STEP" .. i
		local lay_formation_step = m_fnGetWidget(m_mainWidget,layKeyName)

		if(tonumber(step) == i) then
			if (touchCallback == nil) then
				LAY_NOMASK1 = m_fnGetWidget(lay_formation_step, "LAY_NOMASK" .. step)

				if (i==1) then

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
