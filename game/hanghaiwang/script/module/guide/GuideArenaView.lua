-- FileName: GuideArenaView.lua
-- Author: huxiaozhou
-- Date: 2014-06-27
-- Purpose: function description of module
--[[TODO List]]
-- 竞技场引导

module("GuideArenaView", package.seeall)

guideStep = 0
-- UI控件引用变量 --

-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_mainWidget = nil

local function init(...)

end

function destroy(...)
	package.loaded["GuideArenaView"] = nil
end

function moduleName()
    return "GuideArenaView"
end

function create(step,opacity,pos,touchCallback)
	guideStep = step
	local json = "ui/new_arena.json"
	m_mainWidget = g_fnLoadUI(json)
	m_mainWidget:setSize(g_winSize)
	local LAY_MAIN = m_fnGetWidget(m_mainWidget,"LAY_MAIN")
	

	local count = LAY_MAIN:getChildren():count()
	local LAY_NOMASK1
	logger:debug("LAY_ARENA_STEP" .. step)
	logger:debug("count".. count)
	local worldPosTemp = pos
	local rectTemp1 = nil
	for i=1,count do
		local layKeyName = "LAY_ARENA_STEP" .. i
		local lay_formation_step = m_fnGetWidget(m_mainWidget,layKeyName)
		
		-- if (i==2)then
		-- 	local lay_step2_1 = m_fnGetWidget(lay_formation_step, "lay_step2_1")
		-- 	-- lay_step2_1:setScaleY(g_fScaleX)
		-- 	lay_step2_1:setSize(CCSizeMake(lay_step2_1:getSize().width*g_fScaleX,lay_step2_1:getSize().height*g_fScaleX))
		-- end




		if(tonumber(step) == i) then
			if (touchCallback == nil) then
				LAY_NOMASK1 = m_fnGetWidget(lay_formation_step, "LAY_NOMASK" .. step)
				-- local IMG_ARROW_FORMATION1 = m_fnGetWidget(m_mainWidget,"IMG_ARROW_ARENA" .. step)
					
				if (i==2) then
					-- local lay_pmd = m_fnGetWidget(lay_formation_step, "lay_pmd")
					-- local lay_rob = m_fnGetWidget(lay_formation_step, "lay_rob")
					-- lay_rob:setSize(CCSizeMake(lay_rob:getSize().width*g_fScaleX,lay_rob:getSize().height*g_fScaleX))
					-- local LAY_SETSIZE = m_fnGetWidget(lay_formation_step, "LAY_SETSIZE")
					-- LAY_SETSIZE:setSize(CCSizeMake(LAY_SETSIZE:getSize().width*g_fScaleX,LAY_SETSIZE:getSize().height*g_fScaleX))
					
					-- local lay_step2_2 = m_fnGetWidget(lay_formation_step, "lay_step2_2")
					-- -- lay_step2_2:setScale(g_fScaleX)
					-- lay_step2_2:setSize(CCSizeMake(lay_step2_2:getSize().width*g_fScaleX,lay_step2_2:getSize().height*g_fScaleX))

					-- local lay_step2_3 = m_fnGetWidget(lay_formation_step, "lay_step2_3")
					-- -- lay_step2_3:setScale(g_fScaleX)
					-- lay_step2_3:setSize(CCSizeMake(lay_step2_3:getSize().width*g_fScaleX,lay_step2_3:getSize().height*g_fScaleX))

					-- local worldPosTempY = g_winSize.height - lay_pmd:getSize().height - lay_step2_2:getSize().height - LAY_SETSIZE:getSize().height - lay_rob:getSize().height
					-- -- LAY_NOMASK1:setSize(CCSizeMake(LAY_NOMASK1:getSize().width*g_fScaleX,LAY_NOMASK1:getSize().height*g_fScaleX))
					
					-- local percent = LAY_NOMASK1:getPositionPercent()
					-- local tempNodePos = ccp(lay_step2_2:getSize().width*percent.x,lay_step2_2:getSize().height*percent.y)
					-- worldPosTemp = ccp(tempNodePos.x,tempNodePos.y+worldPosTempY)
					rectTemp1 =LAY_NOMASK1:getSize()
					rectTemp1 = CCSizeMake(LAY_NOMASK1:getSize().width*g_fScaleX, LAY_NOMASK1:getSize().height*g_fScaleX)
				end
				-- runMoveAction(IMG_ARROW_FORMATION1)
			end

			-- if(i==2) then
			-- 	local lay_step2_1 = m_fnGetWidget(lay_formation_step, "lay_step2_1")
			-- 	worldPosTemp = ccp(g_winSize.width*.5, g_winSize.height - 72*g_fScaleY - lay_step2_1:getSize().height*0.5 - 13 - lay_step2_1:getSize().height)
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
		local rectTemp = rectTemp1 or CCSizeMake(LAY_NOMASK1:getSize().width,LAY_NOMASK1:getSize().height)

		local worldPos = worldPosTemp  or LAY_NOMASK1:convertToWorldSpace(ccp(0,0))

		local touchRect = CCRectMake(worldPos.x-rectTemp.width*.5,worldPos.y-rectTemp.height*.5,rectTemp.width,rectTemp.height)
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
