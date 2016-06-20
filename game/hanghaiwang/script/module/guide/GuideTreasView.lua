-- FileName: GuideTreasView.lua
-- Author: huxiaozhou
-- Date: 2014-10-29
-- Purpose: 宝物引导
--[[TODO List]]

--                    _ooOoo_
--                   o8888888o
--                   88" . "88
--                   (| -_- |)
--                   O\  =  /O
--                ____/`---'\____
--              .'  \|     |//  `.
--             /  \|||  :  |||//  \
--            /  _||||| -:- |||||-  \
--            |   | \\  -  /// |   |
--            | \_|  ''\---/''  |   |
--            \  .-\__  `-`  ___/-. /
--          ___`. .'  /--.--\  `. . __
--       ."" '<  `.___\_<|>_/___.'  >'"".
--      | | :  `- \`.;`\ _ /`;.`/ - ` : | |
--      \  \ `-.   \_ __\ /__ _/   .-` /  /
-- ======`-.____`-.___\_____/___.-`____.-'======
--                    `=---='
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--          佛祖保佑       永无BUG


-- /


module("GuideTreasView", package.seeall)

guideStep = 0

-- UI控件引用变量 --

-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_mainWidget = nil

local function init(...)

end

function destroy(...)
	package.loaded["GuideTreasView"] = nil
end

function moduleName()
    return "GuideTreasView"
end

function create(step, opacity, pos, touchCallback)
	guideStep = step
	local json = "ui/new_treasure.json"
	m_mainWidget = g_fnLoadUI(json)
	m_mainWidget:setSize(g_winSize)
	local LAY_MAIN = m_fnGetWidget(m_mainWidget,"LAY_MAIN")
	

	local count = LAY_MAIN:getChildren():count()
	local LAY_NOMASK1
	logger:debug("LAY_TREASURE_STEP" .. step)
	logger:debug("count".. count)

	local worldPosTemp = pos
	local rectTemp1 = nil

	for i=1,count do
		local layKeyName = "LAY_TREASURE_STEP" .. i
		local lay_formation_step = m_fnGetWidget(m_mainWidget,layKeyName)

		if(tonumber(step) == i) then
			LAY_NOMASK1 = m_fnGetWidget(lay_formation_step, "LAY_NOMASK" .. step)

			-- if (i==4) then
			-- 	local lay_step3_1 = m_fnGetWidget(lay_formation_step, "lay_step4_1")
			-- 	worldPosTemp = lay_step3_1:convertToWorldSpace(ccp(0,0))
				
			-- 	local LAY_SCALE = m_fnGetWidget(lay_formation_step, "LAY_SCALE")
			-- 	local laySize = LAY_SCALE:getSize()
			-- 	-- LAY_SCALE:setScale(g_fScaleX)
			-- 	LAY_SCALE:setSize(CCSizeMake(laySize.width*g_fScaleX,laySize.height*g_fScaleX))
				
			-- 	local lay_step3_2 = m_fnGetWidget(lay_formation_step, "lay_step4_2")
			-- 	lay_step3_2:setSize(CCSizeMake(lay_step3_2:getSize().width*g_fScaleX,lay_step3_2:getSize().height*g_fScaleX))

			-- 	laySize = LAY_SCALE:getSize()

	
			-- 	local lay_step3_3 = m_fnGetWidget(lay_formation_step, "lay_step4_3")
			-- 	lay_step3_3:setSize(CCSizeMake(lay_step3_3:getSize().width*g_fScaleX, lay_step3_3:getSize().height*g_fScaleX))
			-- 	local laySize1 = lay_step3_3:getSize()
			-- 	logger:debug("laySize1.width = %s", laySize1.width)

			-- 	local percent = LAY_NOMASK1:getPositionPercent()

			-- 	local posNode3_2_x,  posNode3_2_y = lay_step3_2:getPosition()

			-- 	local percent3_3 = lay_step3_3:getPositionPercent()


			-- 	worldPosTemp = ccp( posNode3_2_x*g_fScaleX +  lay_step3_2:getSize().width*percent3_3.x + laySize1.width*percent.x,
			-- 						worldPosTemp.y+lay_step3_1:getSize().height-laySize.height + laySize1.height*percent.y + posNode3_2_y*g_fScaleX + lay_step3_2:getSize().height*percent3_3.y)
			-- 	logger:debug("worldPosTemp.x = %s\n  worldPosTemp.y = %s ", worldPosTemp.x, worldPosTemp.y)

			-- 	LAY_NOMASK1:setSize(CCSizeMake(LAY_NOMASK1:getSize().width*g_fScaleX,LAY_NOMASK1:getSize().height*g_fScaleX))

			-- 	rectTemp1 =LAY_NOMASK1:getSize()
			-- end
			
			if (i==7)then
				local LAY_SCALEY = m_fnGetWidget(lay_formation_step, "LAY_SCALEY")
				LAY_SCALEY:setScale(g_winSize.height/1136)
			end

			-- if(i==3)then
			-- 	local lay_step3_1 = m_fnGetWidget(lay_formation_step, "lay_step2_1")

			-- 	local pos3_1X, pos3_1Y = lay_step3_1:getPosition()


			-- 	local lay_fit1 = m_fnGetWidget(lay_formation_step, "lay_fit1")
			-- 	local lay_fit2 = m_fnGetWidget(lay_formation_step, "lay_fit2")

			-- 	local lay_step3_2 = m_fnGetWidget(lay_formation_step, "lay_step2_2")


			-- 	local worldPosTempY = g_winSize.height + pos3_1Y - lay_fit1:getSize().height - lay_fit2:getSize().height - lay_step3_2:getSize().height
			-- 	local percent = LAY_NOMASK1:getPositionPercent()
			-- 	local tempNodePos = ccp(lay_step3_2:getSize().width*percent.x,lay_step3_2:getSize().height*percent.y)
			-- 	worldPosTemp = ccp(tempNodePos.x,tempNodePos.y+worldPosTempY)

			-- end

				-- local IMG_ARROW_FORMATION1 = m_fnGetWidget(m_mainWidget,"IMG_ARROW_TREASURE" .. step)
				-- runMoveAction(IMG_ARROW_FORMATION1)
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