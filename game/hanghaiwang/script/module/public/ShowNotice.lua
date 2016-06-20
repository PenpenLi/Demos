-- FileName: ShowNotice.lua 
-- Author: xianghuiZhang 
-- Date: 14-4-11
-- Purpose: show notification at screen center

module("ShowNotice", package.seeall)

local jsonNotice = "ui/public_tip.json"
local tbNotice = {} --显示提示集合

local m_TipZorder = 51000 -- 弹出提示信息的初始Zorder

local function ActionSequenceCallback( node )
	if (#tbNotice > 0) then
		local reWidget = tbNotice[1]
		reWidget:removeFromParentAndCleanup(true)
		print("node:getTag()"..node:getTag())
		table.remove(tbNotice,1)
	end
end

local function fnAddRunScene( widget, time )
	local scene = CCDirector:sharedDirector():getRunningScene()
	scene:addChild(widget,m_TipZorder)
	table.insert( tbNotice, widget )

	local function bugMe(node)
        node:stopAllActions()
    end
    local nTime = time or 1.0	-- yucong 强化大师的停留时间长一些
	local array = CCArray:create()
    array:addObject(CCMoveBy:create(nTime, ccp(0,100)))
    array:addObject(CCCallFuncN:create(ActionSequenceCallback))
    local action = CCSequence:create(array)
    widget:runAction(action)
end

function showShellInfo( strText )
	local showItemLayer = g_fnLoadUI(jsonNotice)
	if (showItemLayer and strText ~= nil) then
		local showText = g_fnGetWidgetByName(showItemLayer, "TFD_TIP", "Label")
		if(showText) then
			-- local img_frame = g_fnGetWidgetByName(showItemLayer, "img_frame")
			-- local frameSize = img_frame:getVirtualRenderer():getContentSize()
			-- showText:ignoreContentAdaptWithSize(false)
			-- showText:setSize(CCSizeMake(frameSize.width,frameSize.height))
			-- showText:setTextHorizontalAlignment(kCCTextAlignmentCenter)
			-- showText:setTextVerticalAlignment(kCCVerticalTextAlignmentCenter)
			showText:setText(strText)
			-- showText:setFontSize(g_FontInfo.size)
			fnAddRunScene(showItemLayer)
		end
	end
end


-- 统一掉落界面 dropItemTid 掉落物品的tid
function showDropLayoutByTid( dropItemTid )
	require "script/module/public/PropertyDrop"
	local  dropBg  =   PropertyDrop:new()
	local dropInfoView = dropBg:create(dropItemTid)
    LayerManager.addLayout(dropInfoView)
end

-- 强化大师提示
-- num: 暴击次数
-- silver: 消耗贝里
function showMasterInfo( num, silver )
	local showItemLayer = g_fnLoadUI("ui/formation_guru_tip2.json")
	if (showItemLayer) then
		showItemLayer.TFD_CRITICAL_TIMES:setText(tostring(num))
		showItemLayer.TFD_BELLY_NUM:setText(silver)
		fnAddRunScene(showItemLayer, 2.0)
	end
end

--[[desc: 创建提示框，按照table创建多个label，排列为一行显示，用于一行内容多种颜色的情况
    arg1: tbData
	tbData = {
		fontName = name,    字体名 可为nil
		fontSize = size,	字体大小，可为nil
		{ str = "str", color = ccc3(255,255,255) }   --str:label内容，color：颜色，nil时默认显示白色
	}
    return: 无
—]]
function showWithMoreLabel( tbData)
	local showItemLayer = g_fnLoadUI(jsonNotice)
	local showText = g_fnGetWidgetByName(showItemLayer, "TFD_TIP", "Label")

	if (showItemLayer) then
		local fontName = tbData.fontName or showText:getFontName() 
		local fontSize = tbData.fontSize or showText:getFontSize()

		print("  showText:getFontSize()=",showText:getFontSize())

		local tbLabel = {}
		for k,v in pairs(tbData) do 
			if (type(v)=="table") then 
				local label = Label:create()
				label:setFontName(fontName) 
		    	label:setFontSize(fontSize) 
				if(v.str ) then
					label:setText("" .. v.str or " " )
				end 

				if (v.color) then
					label:setColor(v.color)
				end
				tbLabel[#tbLabel+1] = label
			else
				print(v) 
			end 
		end 

		require "script/module/main/BulletinData"
	    local contentNode = BulletinData.createHorizontalwidget(tbLabel)
	    local size = contentNode:getSize()
		contentNode:setPosition(ccp(-size.width/2,-size.height/2))
		if(showText) then
			showText:addChild(contentNode)
			fnAddRunScene(showItemLayer)
		end
	end 
end
