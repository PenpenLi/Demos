-- FileName: GuideFormationView.lua
-- Author: huxiaozhou
-- Date: 2014-06-09
-- Purpose: function description of module
--[[TODO List]]
--  阵容阶段开启的功能节点后要用到的引导

module("GuideFormationView", package.seeall)
require "script/module/public/UIHelper"
 
 guideStep = 0


-- UI控件引用变量 --

-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_mainWidget = nil


local function init(...)
	m_mainWidget = nil
end

function destroy(...)
	package.loaded["GuideFormationView"] = nil
end

function moduleName()
    return "GuideFormationView"
end

-- modified by zhangqi, 2014-07-15, 添加参数 pos, 副本引导中会传入当前据点的坐标
function create( step, pos, callfunc)
	guideStep = step
	local json = "ui/new_formation.json"
	m_mainWidget = g_fnLoadUI(json)
	m_mainWidget:setSize(g_winSize)
	local LAY_MAIN = m_fnGetWidget(m_mainWidget,"LAY_MAIN")
	
 
	local count = LAY_MAIN:getChildren():count()
	local LAY_NOMASK1
	logger:debug("LAY_FORMATION_STEP" .. step)
	logger:debug("count".. count)
	local worldPosTemp = nil
	local rectTemp1 = nil
	for i=1,count do
		local layKeyName = "LAY_FORMATION_STEP" .. i
		local lay_formation_step = m_fnGetWidget(m_mainWidget,layKeyName)
		
		if(tonumber(step) == i) then
			if (i==8)then
				local LAY_SPECIAL = m_fnGetWidget(lay_formation_step, "LAY_SPECIAL")
				local laySize = LAY_SPECIAL:getSize()
				LAY_SPECIAL:setSize(CCSizeMake(laySize.width*g_fScaleX,laySize.height*g_fScaleX))
				LAY_SPECIAL:setPositionY(laySize.height)
			end

			LAY_NOMASK1 = m_fnGetWidget(lay_formation_step, "LAY_NOMASK" .. step)
			
			-- if (i==4) then
		
			-- 	local lay_step4_1 = m_fnGetWidget(lay_formation_step, "lay_step4_1")
			-- 	worldPosTemp = lay_step4_1:convertToWorldSpace(ccp(0,0))
				
			-- 	local LAY_SCALE = m_fnGetWidget(lay_formation_step, "LAY_SCALE")
			-- 	local laySize = LAY_SCALE:getSize()
			-- 	logger:debug("laySize.width = " .. laySize.width .. "laySize.height = " .. laySize.height )
			-- 	LAY_SCALE:setSize(CCSizeMake(laySize.width*g_fScaleX,laySize.height*g_fScaleX))
			-- 	local lay_step4_2 = m_fnGetWidget(lay_formation_step, "lay_step4_2")
			-- 	local laySize1 = lay_step4_2:getSize()
			-- 	lay_step4_2:setSize(CCSizeMake(laySize1.width*g_fScaleX,laySize1.height*g_fScaleX))
			-- 	local laySize1 = lay_step4_2:getSize()


			-- 	laySize = LAY_SCALE:getSize()
			-- 	logger:debug("laySize.width = " .. laySize.width .. "laySize.height = " .. laySize.height )
		

			-- 	-- worldPosTemp = ccp(laySize.width*0.01+ laySize1.width*0.83,(g_winSize.height - laySize.height*0.60- 77*g_fScaleY))
			-- 	local percent = LAY_NOMASK1:getPositionPercent()
			-- 	local percent1 = lay_step4_2:getPositionPercent()
			-- 	worldPosTemp = ccp(laySize.width*percent1.x+laySize1.width*percent.x,worldPosTemp.y+lay_step4_1:getSize().height-laySize.height + laySize1.height*percent.y)
			-- 	logger:debug("g_winSize.width = " .. g_winSize.width .. "   " .. "g_winSize.height" .. g_winSize.height)
			-- 	logger:debug("g_origin.x = " .. g_origin.x .."\n" .. "g_origin.y = " .. g_origin.y .. "\n")

			-- 	LAY_NOMASK1:setSize(CCSizeMake(LAY_NOMASK1:getSize().width*g_fScaleX,LAY_NOMASK1:getSize().height*g_fScaleX))

			-- 	rectTemp1 =LAY_NOMASK1:getSize()
			-- end

			-- 副本地图 特殊处理
			if (i == 7) then
				local LAY_SCALEY = m_fnGetWidget(lay_formation_step, "LAY_SCALEY")
				LAY_SCALEY:setScale(g_winSize.height/1136)
			end

			-- if i==2 then
			-- 	logger:debug("begin guideStep 2")
			-- 	local lay_step2_1 = m_fnGetWidget(lay_formation_step, "lay_step2_1")
			-- 	local lay_step2_2 = m_fnGetWidget(lay_formation_step, "lay_step2_2")
			-- 	local lay_step2_3 = m_fnGetWidget(lay_formation_step, "lay_step2_3")

			-- 	local parameter = lay_step2_3:getLayoutParameter(LAYOUT_PARAMETER_RELATIVE)
			-- 	local margin = parameter:getMargin()
			-- 	local left = margin.left
			-- 	logger:debug(left)
			-- 	worldPosTemp = lay_step2_2:convertToWorldSpace(ccp(0,0))

			-- 	worldPosTemp = ccp(worldPosTemp.x + left, worldPosTemp.y)


			-- 	local percent = LAY_NOMASK1:getPositionPercent()
			-- 	local tempNodePos = ccp(lay_step2_3:getSize().width*percent.x,lay_step2_3:getSize().height*percent.y)
			-- 	logger:debug("tempNodePos.x ==" .. tempNodePos.x)
			-- 	logger:debug("tempNodePos.y ==" .. tempNodePos.y)
			-- 	worldPosTemp = ccp(tempNodePos.x + worldPosTemp.x,tempNodePos.y+worldPosTemp.y)
			-- 	logger:debug("worldPosTemp.x ==" .. worldPosTemp.x)
			-- 	logger:debug("worldPosTemp.y ==" .. worldPosTemp.y)
			-- 	logger:debug("end guideStep 2")
			-- end
			-- if i==9 then
			-- 	local IMG_ARROW = m_fnGetWidget(lay_formation_step, "IMG_ARROW")
			-- 	runMoveAction(IMG_ARROW)
			-- end
		else
			lay_formation_step:setVisible(false)
		end
	end

	--创建mask layer
	local touchCallback = callfunc 
	local priority = g_tbTouchPriority.guide
	local layer
	if (not touchCallback) then

		local rectTemp = rectTemp1 or CCSizeMake(LAY_NOMASK1:getSize().width,LAY_NOMASK1:getSize().height)

		local worldPos = worldPosTemp or LAY_NOMASK1:convertToWorldSpace(ccp(0,0))
		local  tempPos = pos or worldPos
		logger:debug("tempPos.x = %f, tempPos.y = %f", tempPos.x, tempPos.y)
		local touchRect = CCRectMake(tempPos.x-rectTemp.width*.5, tempPos.y-rectTemp.height*.5, rectTemp.width,rectTemp.height)

		-- local touchRect = CCRectMake(worldPos.x-rectTemp.width*.5, worldPos.y-rectTemp.height*.5, rectTemp.width,rectTemp.height)
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

function showStep( step )

end
