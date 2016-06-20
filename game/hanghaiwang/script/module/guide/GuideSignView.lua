-- FileName: GuideSignView.lua
-- Author: huxiaozhou
-- Date: 2014-07-07
-- Purpose: function description of module
--[[TODO List]]
-- 签到系统引导

module("GuideSignView", package.seeall)

guideStep = 0
-- UI控件引用变量 --

-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_mainWidget = nil

local function init(...)

end

function destroy(...)
	package.loaded["GuideSignView"] = nil
end

function moduleName()
    return "GuideSignView"
end

function create(step,opacity,touchCallback)
	guideStep = step
	local json = "ui/new_sign.json"
	m_mainWidget = g_fnLoadUI(json)
	m_mainWidget:setSize(g_winSize)
	local LAY_MAIN = m_fnGetWidget(m_mainWidget,"LAY_MAIN")
	

	local count = LAY_MAIN:getChildren():count()
	local LAY_NOMASK1
	local worldPosTemp
	logger:debug("LAY_SIGN_STEP" .. step)
	logger:debug("count".. count)
	for i=1,count do
		local layKeyName = "LAY_SIGN_STEP" .. i
		local lay_formation_step = m_fnGetWidget(m_mainWidget,layKeyName)
		
		if(tonumber(step) == i) then
			LAY_NOMASK1 = m_fnGetWidget(lay_formation_step, "LAY_NOMASK" .. step)
			-- local IMG_ARROW_FORMATION1 = m_fnGetWidget(m_mainWidget,"IMG_ARROW_SIGN" .. step)
			-- runMoveAction(IMG_ARROW_FORMATION1)
			if (i==1) then

				local lay_fit_pmd = m_fnGetWidget(lay_formation_step, "lay_fit_pmd")
				local lay_step1_2 = m_fnGetWidget(lay_formation_step, "lay_step1_2")
				local LAY_SETSIZE = m_fnGetWidget(lay_formation_step, "LAY_SETSIZE")
				-- LAY_SETSIZE:setScale(g_fScaleX)
				LAY_SETSIZE:setSize(CCSizeMake(LAY_SETSIZE:getSize().width*g_fScaleX,LAY_SETSIZE:getSize().height*g_fScaleX))

				local parameter = lay_step1_2:getLayoutParameter(LAYOUT_PARAMETER_RELATIVE)
				local margin = parameter:getMargin()
				local top = margin.top

				local worldPosTempY = g_winSize.height - top - lay_fit_pmd:getSize().height - lay_step1_2:getSize().height - LAY_SETSIZE:getSize().height
				local percent = LAY_NOMASK1:getPositionPercent()
				local tempNodePos = ccp(lay_step1_2:getSize().width*percent.x,lay_step1_2:getSize().height*percent.y)
				logger:debug("tempNodePos.x ==" .. tempNodePos.x)
				logger:debug("tempNodePos.y ==" .. tempNodePos.y)
				worldPosTemp = ccp(tempNodePos.x,tempNodePos.y+worldPosTempY)
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
