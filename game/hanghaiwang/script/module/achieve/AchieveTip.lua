-- FileName: AchieveTip.lua
-- Author: huxiaozhou
-- Date: 2014-11-11
-- Purpose: function description of module
-- 成就显示 提示显示动画效果  提示得到某个成就 


module("AchieveTip", package.seeall)

local json = "ui/achievement_effect.json"
local m_i18n = gi18n
local m_i18nString = gi18nString


-- 模块局部变量 --
local m_arrNew
local m_mainWidget
local m_fnGetWidget = g_fnGetWidgetByName
local img_item_bg = nil
local function init(...)
	m_arrNew = {}
end

function destroy(...)
	package.loaded["AchieveTip"] = nil
end

function moduleName()
    return "AchieveTip"
end

function loadUI(aid)
	local tbDataItem = AchieveModel.getAchieveInfoById(aid)
	m_mainWidget = g_fnLoadUI(json)
	m_mainWidget:setSize(g_winSize)
	img_item_bg = m_fnGetWidget(m_mainWidget, "img_item_bg")

	local img_item_bg_clone = img_item_bg:clone()
	-- img_item_bg_clone:retain()
	-- img_item_bg:removeFromParentAndCleanup(false)
	-- local img_icon_bg = m_fnGetWidget(img_item_bg_clone, "img_icon_bg") 
	local img_icon = m_fnGetWidget(img_item_bg_clone, "img_icon") 

	-- img_icon_bg:loadTexture("images/base/potential/props_" .. tbDataItem.achie_quality .. ".png")
	img_icon:loadTexture("images/base/props/" .. tbDataItem.achie_icon)
	
	img_item_bg_clone.IMG_ICON_BG:loadTexture("images/base/potential/color_" .. tbDataItem.achie_quality .. ".png")

	img_item_bg_clone.IMG_BODER:loadTexture("images/base/potential/equip_" .. tbDataItem.achie_quality .. ".png")
	
	local TFD_NAME = m_fnGetWidget(img_item_bg_clone, "TFD_NAME") 
	TFD_NAME:setText(tbDataItem.achie_name)
	
	local color =  g_QulityColor2[tonumber(tbDataItem.achie_quality)]
	if(color ~= nil) then
		TFD_NAME:setColor(color)
	end
	
	-- UIHelper.labelNewStroke(TFD_NAME,ccc3(0x39, 0x02,0x00))
	
	local TFD_DESC = m_fnGetWidget(img_item_bg_clone, "TFD_DESC")
	TFD_DESC:setText(tbDataItem.achie_des)
	
	local tfd_reward = m_fnGetWidget(img_item_bg_clone, "tfd_reward")
	tfd_reward:setText(m_i18n[2620])

	local name, num = AchieveModel.getStringByRewardStr(tbDataItem.achie_reward)
	local TFD_REWARD_NAME = m_fnGetWidget(img_item_bg_clone, "TFD_REWARD_NAME")
	TFD_REWARD_NAME:setText(name)

	local TFD_REWARD_NUM = m_fnGetWidget(img_item_bg_clone, "TFD_REWARD_NUM")
	TFD_REWARD_NUM:setText(num)
	return img_item_bg_clone
end

function playEffect(aid)
	logger:debug(aid)
	local img_item_bg_clone = loadUI(aid)
	local actions = CCArray:create()
	actions:addObject(CCDelayTime:create(0.3))
	actions:addObject(CCEaseSineOut:create(CCMoveTo:create(0.3, ccp(g_winSize.width * 0.5,g_winSize.height * 0.35))))
	actions:addObject(CCCallFunc:create(function ( ... )
		UIHelper.widgetFadeTo(img_item_bg_clone,2,0,function (  )
			logger:debug("img_item_bg_clone:removeFromParentAndCleanup")
			local aid = table.remove(m_arrNew)
			if aid ~= nil then
				playEffect(aid)
			end
			img_item_bg_clone:removeFromParentAndCleanup(true)
		end)
	end))
	-- actions:addObject(CCDelayTime:create(2.5))
	-- actions:addObject(CCMoveBy:create(0.2, ccp(0,600)))
	-- actions:addObject(CCCallFuncN:create(function( sender)
 --               sender:removeFromParentAndCleanup(false)
 --               local aid = table.remove(m_arrNew)
 --               if aid ~= nil then
 --               		playEffect(aid)
 --               end
 --            end))
	local runningScene = CCDirector:sharedDirector():getRunningScene()
	runningScene:addChild(img_item_bg_clone, 99999999)
	img_item_bg_clone:setPosition(ccp(g_winSize.width * 0.5, -100))
	img_item_bg_clone:runAction(CCSequence:create(actions))



end


function sortShowId( arrNew )
	local tbArr = arrNew
	m_arrNew = {}
	for i,aid in ipairs(tbArr) do
		local tbDataItem = AchieveModel.getAchieveInfoById(aid)
		if tonumber(tbDataItem.is_display) == 1 then
			table.insert(m_arrNew, aid)
		end
	end
end

function create(arrNew)
	if table.isEmpty(arrNew) == false then
		init()

		sortShowId(arrNew)
		-- m_mainWidget = g_fnLoadUI(json)
		-- m_mainWidget:setSize(g_winSize)
		-- LayerManager.addLayoutNoScale(m_mainWidget)
		local aid = table.remove(m_arrNew)
		logger:debug(aid)
		if aid ~= nil then
            playEffect(aid)
        end
	else
		assert("新完成的不是一个数组")
	end

end
