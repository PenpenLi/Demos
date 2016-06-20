-- FileName: GuideCopyBoxView.lua
-- Author: huxiaozhou
-- Date: 2014-06-24
-- Purpose: function description of module
--[[TODO List]]

module("GuideCopyBoxView", package.seeall)

-- UI控件引用变量 --
guideStep = 0
-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_mainWidget = nil

local function init(...)

end

function destroy(...)
	package.loaded["GuideCopyBoxView"] = nil
end

function moduleName()
    return "GuideCopyBoxView"
end

function create(step, opacity, pos, callfunc)
	guideStep = step
	local json = "ui/new_copy_box.json"
	m_mainWidget = g_fnLoadUI(json)
	m_mainWidget:setSize(g_winSize)
	local LAY_MAIN = m_fnGetWidget(m_mainWidget,"LAY_MAIN")
	

	local count = LAY_MAIN:getChildren():count()
	local LAY_NOMASK1
	local worldPosTemp = nil
	local rectTemp1 = nil

	logger:debug("LAY_BOX_STEP" .. step)
	logger:debug("count".. count)

	for i=1,count do
		local layKeyName = "LAY_BOX_STEP" .. i
		local lay_formation_step = m_fnGetWidget(m_mainWidget,layKeyName)

		if(tonumber(step) == i) then
			-- if i~=2 then
			-- 	logger:debug("step = %s", step)
			-- 	logger:debug("i = %s", i)
				LAY_NOMASK1 = m_fnGetWidget(lay_formation_step, "LAY_NOMASK" .. step)
			-- end
			
			-- 副本地图 特殊处理
			if (i == 11) then
				local LAY_SCALEY = m_fnGetWidget(lay_formation_step, "LAY_SCALEY")
				LAY_SCALEY:setScale(g_winSize.height/1136)
			end
			-- 副本地图特殊处理
			if (i==4)then
				local LAY_SCALEX = m_fnGetWidget(lay_formation_step, "LAY_SCALEX")
				LAY_SCALEX:setSize(CCSizeMake(LAY_SCALEX:getSize().width*g_fScaleX,LAY_SCALEX:getSize().height*g_fScaleX))	
			end

			if (i==1) then
				local LAY_SCALEX = m_fnGetWidget(lay_formation_step, "LAY_SCALEX")
				LAY_SCALEX:setScale(g_fScaleX)
			end

			-- if i==2 then
			-- 	require "script/module/public/EffectHelper"
			-- 	local IMG_ARROW = m_fnGetWidget(lay_formation_step, "IMG_ARROW")
			-- 	local guideEff = EffArrow:new()
			-- 	IMG_ARROW:addNode(guideEff:Armature())
			-- end

		else
			lay_formation_step:setVisible(false)
		end
	end
	--创建mask layer
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
