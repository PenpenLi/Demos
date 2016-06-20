-- FileName: GuideTrainView.lua
-- Author: huxiaozhou
-- Date: 2014-06-30
-- Purpose: function description of module
--[[TODO List]]
-- 天命系统引导

module("GuideTrainView", package.seeall)

 guideStep = 0
-- UI控件引用变量 --

-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_mainWidget = nil

local function init(...)

end

function destroy(...)
	package.loaded["GuideTrainView"] = nil
end

function moduleName()
    return "GuideTrainView"
end

function create(step, opacity, touchCallback)
	guideStep = step
	local json = "ui/new_train.json"
	m_mainWidget = g_fnLoadUI(json)
	m_mainWidget:setSize(g_winSize)
	local LAY_MAIN = m_fnGetWidget(m_mainWidget,"LAY_MAIN")
	

	local count = LAY_MAIN:getChildren():count()
	local LAY_NOMASK1
	local worldPosTemp = nil 

	logger:debug("LAY_TRAIN_STEP" .. step)
	logger:debug("count".. count)
	for i=1,count do
		local layKeyName = "LAY_TRAIN_STEP" .. i
		local lay_formation_step = m_fnGetWidget(m_mainWidget,layKeyName)
		
		if(tonumber(step) == i) then

			if ( step ~= 4 and step ~= 5) then
				LAY_NOMASK1 = m_fnGetWidget(lay_formation_step, "LAY_NOMASK" .. step)
			end

			-- if i == 2 then
			-- 	local lay_step2_1 = m_fnGetWidget(lay_formation_step, "lay_step2_1")
			-- 	local lay_step2_2 = m_fnGetWidget(lay_step2_1,"lay_step2_2")
			-- 	local lay_step2_3 = m_fnGetWidget(lay_step2_2,"lay_step2_3")
			-- 	local oldSize21 = lay_step2_1:getSize()
			-- 	local oldSize22 = lay_step2_2:getSize()
			-- 	local oldSize23 = lay_step2_3:getSize()
			-- 	lay_step2_1:setSize(CCSizeMake(oldSize21.width*g_fScaleX,oldSize21.height*g_fScaleX))
			-- 	lay_step2_2:setSize(CCSizeMake(oldSize22.width*g_fScaleX,oldSize22.height*g_fScaleX))
			-- 	lay_step2_3:setSize(CCSizeMake(oldSize23.width*g_fScaleX,oldSize23.height*g_fScaleX))
			-- 	-- local newSize21 = lay_step2_1:getSize()
			-- 	-- local newSize22 = lay_step2_2:getSize()
			-- 	-- local newSize23 = lay_step2_3:getSize()
			-- 	-- local posy = newSize21.height - newSize22.height
			-- 	-- local pos = ccp(0, posy)
			-- 	-- local percent = lay_step2_3:getPositionPercent()
			-- 	-- pos = ccp(newSize22.width*percent.x, posy + newSize22.width*percent.y)
			-- 	-- logger:debug("pos .x = %s, pos.y = %s",pos.x, pos.y)

			-- end
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

		local worldPos = worldPosTemp or LAY_NOMASK1:convertToWorldSpace(ccp(0,0))

		local touchRect = CCRectMake(worldPos.x-rectTemp.size.width*.5,worldPos.y-rectTemp.size.height*.5,rectTemp.size.width,rectTemp.size.height)
		-- local touchCallback = nil
		local highRect = touchRect--LAY_NOMASK1:boundingBox()
		layer = UIHelper.createMaskLayer( priority,touchRect ,nil, layerOpacity,highRect)
		layer:addChild(m_mainWidget)
	else
		layer = UIHelper.createMaskLayer( priority,nil,touchCallback, layerOpacity,nil)
		layer:addChild(m_mainWidget)
	end
	return layer
end