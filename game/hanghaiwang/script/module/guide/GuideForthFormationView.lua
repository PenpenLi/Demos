-- FileName: GuideForthFormationView.lua
-- Author: huxiaozhou
-- Date: 2014-06-27
-- Purpose: function description of module
--[[TODO List]]

module("GuideForthFormationView", package.seeall)

guideStep = 0
-- UI控件引用变量 --

-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_mainWidget = nil


local function init(...)

end

function destroy(...)
	package.loaded["GuideForthFormationView"] = nil
end

function moduleName()
    return "GuideForthFormationView"
end

function create(step,opacity,touchCallback)
	guideStep = step
	local json = "ui/new_four.json"
	m_mainWidget = g_fnLoadUI(json)
	m_mainWidget:setSize(g_winSize)
	local LAY_MAIN = m_fnGetWidget(m_mainWidget,"LAY_MAIN")
	

	local count = LAY_MAIN:getChildren():count()
	local LAY_NOMASK1
	logger:debug("LAY_FOUR_STEP" .. step)
	logger:debug("count".. count)
	local worldPosTemp
	local touchRectTemp
	for i=1,count do
		local layKeyName = "LAY_FOUR_STEP" .. i
		local lay_formation_step = m_fnGetWidget(m_mainWidget,layKeyName)
		if(tonumber(step) == i) then
			if (touchCallback == nil) then
				LAY_NOMASK1 = m_fnGetWidget(lay_formation_step, "LAY_NOMASK" .. step)
				-- local IMG_ARROW_FORMATION1 = m_fnGetWidget(m_mainWidget,"IMG_ARROW_FOUR" .. step)
				-- runMoveAction(IMG_ARROW_FORMATION1)
			end

			if i == 2 then
				logger:debug("begin guideStep 2")
				local lay_step2_1 = m_fnGetWidget(lay_formation_step, "lay_step2_1")
				local lay_step2_2 = m_fnGetWidget(lay_formation_step, "lay_step2_2")
				local lay_step2_3 = m_fnGetWidget(lay_formation_step, "lay_step2_3")

				local parameter = lay_step2_3:getLayoutParameter(LAYOUT_PARAMETER_RELATIVE)
				local margin = parameter:getMargin()
				local left = margin.left
				logger:debug(left)
				worldPosTemp = lay_step2_2:convertToWorldSpace(ccp(0,0))

				worldPosTemp = ccp(worldPosTemp.x + left, worldPosTemp.y)


				local percent = LAY_NOMASK1:getPositionPercent()
				local tempNodePos = ccp(lay_step2_3:getSize().width*percent.x,lay_step2_3:getSize().height*percent.y)
				logger:debug("tempNodePos.x ==" .. tempNodePos.x)
				logger:debug("tempNodePos.y ==" .. tempNodePos.y)
				worldPosTemp = ccp(tempNodePos.x + worldPosTemp.x,tempNodePos.y+worldPosTemp.y)
				logger:debug("worldPosTemp.x ==" .. worldPosTemp.x)
				logger:debug("worldPosTemp.y ==" .. worldPosTemp.y)
				logger:debug("end guideStep 2")
			end

		else
			lay_formation_step:setVisible(false)
		end
	end
	--创建mask layer
	local priority = g_tbTouchPriority.guide
	local layer
	if (not touchCallback) then
		local rectTemp = LAY_NOMASK1:getSize()

		local worldPos = worldPosTemp or LAY_NOMASK1:convertToWorldSpace(ccp(0,0))

		local touchRect = CCRectMake(worldPos.x-rectTemp.width*.5,worldPos.y-rectTemp.height*.5,rectTemp.width,rectTemp.height)
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
