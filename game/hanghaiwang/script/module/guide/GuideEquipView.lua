-- FileName: GuideEquipView.lua
-- Author: huxiaozhou
-- Date: 2014-06-26
-- Purpose: function description of module
--[[TODO List]]
-- 装备强化 引导


module("GuideEquipView", package.seeall)

require "script/module/public/UIHelper"

guideStep = 0

-- UI控件引用变量 --

-- 模块局部变量 --

local m_fnGetWidget = g_fnGetWidgetByName
local m_mainWidget = nil


local function init(...)

end

function destroy(...)
	package.loaded["GuideEquipView"] = nil
end

function moduleName()
    return "GuideEquipView"
end

function create(step, opacity, pos )
	guideStep = step
	local json = "ui/new_equip.json"
	m_mainWidget = g_fnLoadUI(json)
	m_mainWidget:setSize(g_winSize)
	local LAY_MAIN = m_fnGetWidget(m_mainWidget,"LAY_MAIN")
	

	local count = LAY_MAIN:getChildren():count()
	local LAY_NOMASK1
	logger:debug("LAY_EQUIP_STEP" .. step)
	logger:debug("count".. count)
	local worldPosTemp = pos
	local rectTemp1 = nil
	for i=1,count do
		local layKeyName = "LAY_EQUIP_STEP" .. i
		local lay_formation_step = m_fnGetWidget(m_mainWidget,layKeyName)
		
		if(tonumber(step) == i) then
			LAY_NOMASK1 = m_fnGetWidget(lay_formation_step, "LAY_NOMASK" .. step)

			-- if(i==3)then
			-- 	local lay_step3_1 = m_fnGetWidget(lay_formation_step, "lay_step3_1")

			-- 	local pos3_1X, pos3_1Y = lay_step3_1:getPosition()

			-- 	logger:debug("pos13_1X = %s, pos13_1Y = %s",pos3_1X,pos3_1Y)

			-- 	local lay_fit1 = m_fnGetWidget(lay_formation_step, "lay_fit1")
			-- 	local lay_fit2 = m_fnGetWidget(lay_formation_step, "lay_fit2")

			-- 	local lay_step3_2 = m_fnGetWidget(lay_formation_step, "lay_step3_2")


			-- 	local worldPosTempY = g_winSize.height + pos3_1Y - lay_fit1:getSize().height - lay_fit2:getSize().height - lay_step3_2:getSize().height
			-- 	local percent = LAY_NOMASK1:getPositionPercent()
			-- 	local tempNodePos = ccp(lay_step3_2:getSize().width*percent.x,lay_step3_2:getSize().height*percent.y)
			-- 	logger:debug("tempNodePos.x ==" .. tempNodePos.x)
			-- 	logger:debug("tempNodePos.y ==" .. tempNodePos.y)
			-- 	logger:debug("worldPosTempY = " .. worldPosTempY)
			-- 	worldPosTemp = ccp(tempNodePos.x,tempNodePos.y+worldPosTempY)
			-- 	logger:debug("worldPosTemp.y = " .. worldPosTemp.y)
			-- 	logger:debug("worldPosTemp.y = " .. LAY_NOMASK1:getWorldPosition().y )

			-- end

			if i == 9 or i == 6 or i == 7 or i == 8 then
				-- local lay_step = m_fnGetWidget(lay_formation_step, "lay_step".. i .. "_1")
				-- lay_step:setScale(g_fScaleX)
			end
			if (i == 11) then
				local LAY_SCALEY = m_fnGetWidget(lay_formation_step, "LAY_SCALEY")
				LAY_SCALEY:setScale(g_winSize.height/1136)
			end

		else
			lay_formation_step:setVisible(false)
		end
	end

	--创建mask layer
	local priority = g_tbTouchPriority.guide
	-- local rectTemp = LAY_NOMASK1:boundingBox()

	-- local worldPos = LAY_NOMASK1:convertToWorldSpace(ccp(0,0))

	-- local touchRect = CCRectMake(worldPos.x-rectTemp.size.width*.5,worldPos.y-rectTemp.size.height*.5,rectTemp.size.width,rectTemp.size.height)
	-- local touchCallback = nil
	-- local layerOpacity = 150--opacity or 150
	-- local highRect = touchRect--LAY_NOMASK1:boundingBox()
	-- local layer = UIHelper.createMaskLayer( priority,touchRect ,touchCallback, layerOpacity,highRect)
	-- layer:addChild(m_mainWidget)

	local rectTemp = rectTemp1 or CCSizeMake(LAY_NOMASK1:getSize().width,LAY_NOMASK1:getSize().height)

	local worldPos = worldPosTemp or LAY_NOMASK1:convertToWorldSpace(ccp(0,0))
	logger:debug("worldPos.x = %s, worldPos.y = %s", worldPos.x, worldPos.y)

	local touchRect = CCRectMake(worldPos.x-rectTemp.width*.5, worldPos.y-rectTemp.height*.5, rectTemp.width,rectTemp.height)
	local layerOpacity = 150--opacity or 150
	local highRect = touchRect--LAY_NOMASK1:boundingBox()
	layer = UIHelper.createMaskLayer( priority,touchRect ,nil, layerOpacity,highRect)
	layer:addChild(m_mainWidget)


	return layer
end
