-- FileName: GuidePartnerAdvView.lua
-- Author: huxiaozhou
-- Date: 2014-06-20
-- Purpose: function description of module
--[[TODO List]]

module("GuidePartnerAdvView", package.seeall)
guideStep = 0
-- UI控件引用变量 --

-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_mainWidget = nil



local function init(...)

end

function destroy(...)
	package.loaded["GuidePartnerAdvView"] = nil
end

function moduleName()
    return "GuidePartnerAdvView"
end
-- modified by zhangqi, 2014-07-15, 添加参数 pos, 副本引导中会传入当前据点的坐标
function create( step,opacity,pos)
	guideStep = step
	local json = "ui/new_advance.json"
	m_mainWidget = g_fnLoadUI(json)
	m_mainWidget:setSize(g_winSize)
	local LAY_MAIN = m_fnGetWidget(m_mainWidget,"LAY_MAIN")
	

	local count = LAY_MAIN:getChildren():count()
	local LAY_NOMASK1
	logger:debug("LAY_ADVANCE_STEP" .. step)
	logger:debug("count".. count)

	local worldPosTemp = nil
	local rectTemp1 = nil

	for i=1,count do
		local layKeyName = "LAY_ADVANCE_STEP" .. i
		local lay_formation_step = m_fnGetWidget(m_mainWidget,layKeyName)
		
		if(tonumber(step) == i) then
		
			-- 副本地图特殊处理
			if (i==6 or i==9)then
				local LAY_SCALEY = m_fnGetWidget(lay_formation_step, "LAY_SCALEY")
				-- LAY_SCALEY:setScale(g_fScaleY)
				LAY_SCALEY:setScale(g_winSize.height/1136)
			end

			if (i==8)then
				local LAY_SCALEX = m_fnGetWidget(lay_formation_step, "LAY_SCALEX")
				LAY_SCALEX:setSize(CCSizeMake(LAY_SCALEX:getSize().width*g_fScaleX,LAY_SCALEX:getSize().height*g_fScaleX))
			end
			LAY_NOMASK1 = m_fnGetWidget(lay_formation_step, "LAY_NOMASK" .. step)
			

			if (i==2) then

				local lay_step4_1 = m_fnGetWidget(lay_formation_step, "lay_step2_1")
				worldPosTemp = lay_step4_1:convertToWorldSpace(ccp(0,0))
				local LAY_SCALE = m_fnGetWidget(lay_formation_step, "LAY_SCALE")
				local laySize = LAY_SCALE:getSize()
				logger:debug("laySize.width = " .. laySize.width .. "laySize.height = " .. laySize.height )
				LAY_SCALE:setSize(CCSizeMake(laySize.width*g_fScaleX,laySize.height*g_fScaleX))
				local lay_step4_2 = m_fnGetWidget(lay_formation_step, "lay_step2_2")
				local laySize1 = lay_step4_2:getSize()
				lay_step4_2:setSize(CCSizeMake(laySize1.width*g_fScaleX,laySize1.height*g_fScaleX))
				local laySize1 = lay_step4_2:getSize()

				laySize = LAY_SCALE:getSize()
				logger:debug("laySize.width = " .. laySize.width .. "laySize.height = " .. laySize.height )
		
				-- worldPosTemp = ccp(laySize.width*0.01+ laySize1.width*0.61,(g_winSize.height - laySize.height*0.65- 161*g_fScaleY))--255*g_fScaleY))
					
				local percent = LAY_NOMASK1:getPositionPercent()
				local percent1 = lay_step4_2:getPositionPercent()
				worldPosTemp = ccp(laySize.width*percent1.x+laySize1.width*percent.x,worldPosTemp.y+lay_step4_1:getSize().height-laySize.height + laySize1.height*percent.y)
				
				logger:debug("g_winSize.width = " .. g_winSize.width .. "   " .. "g_winSize.height" .. g_winSize.height)
				logger:debug("g_origin.x = " .. g_origin.x .."\n" .. "g_origin.y = " .. g_origin.y .. "\n")

				LAY_NOMASK1:setSize(CCSizeMake(LAY_NOMASK1:getSize().width*g_fScaleX,LAY_NOMASK1:getSize().height*g_fScaleX))

				rectTemp1 =LAY_NOMASK1:getSize()
			end
			
			-- local IMG_ARROW_FORMATION1 = m_fnGetWidget(m_mainWidget,"IMG_ARROW_ADVANCE" .. step)
			-- runMoveAction(IMG_ARROW_FORMATION1)

		else
			lay_formation_step:setVisible(false)
		end
	end



	--创建mask layer
	local priority = g_tbTouchPriority.guide
	local rectTemp = rectTemp1 or CCSizeMake(LAY_NOMASK1:getSize().width,LAY_NOMASK1:getSize().height)

	local worldPos = worldPosTemp or LAY_NOMASK1:convertToWorldSpace(ccp(0,0))

	-- local touchRect = CCRectMake(worldPos.x-rectTemp.size.width*.5,worldPos.y-rectTemp.size.height*.5,rectTemp.size.width,rectTemp.size.height)
	local  tempPos = pos or worldPos
	logger:debug("tempPos.x = %f, tempPos.y = %f", tempPos.x, tempPos.y)
	local touchRect = CCRectMake(tempPos.x-rectTemp.width*.5, tempPos.y-rectTemp.height*.5, rectTemp.width,rectTemp.height)
	
	local touchCallback = nil

	local layerOpacity = opacity or 150
	local highRect = touchRect--LAY_NOMASK1:boundingBox()
	local layer = UIHelper.createMaskLayer( priority,touchRect ,touchCallback, layerOpacity,highRect)
	layer:addChild(m_mainWidget)
	
	return layer
end
