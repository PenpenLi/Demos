-- FileName: PassLastLevel.lua
-- Author: zhangjunwu
-- Date: 2015-01-12
-- Purpose: 通关最后关卡的通关界面 界面比较简单，就没有分开ctrl 和 view
--[[TODO List]]

module("PassLastLevel", package.seeall)

-- UI控件引用变量 --
local m_mainWidget 			= nil
local json = "ui/air_finally.json"

-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local function init(...)

end

function destroy(...)
	package.loaded["PassLastLevel"] = nil
end

function moduleName()
	return "PassLastLevel"
end

function create(...)
	m_mainWidget  = g_fnLoadUI(json)
	-- LayerManager.lockOpacity(m_mainWidget)

	local lay_main = m_fnGetWidget(m_mainWidget, "lay_main")
	-- local IMG_EFFECT = m_fnGetWidget(m_mainWidget, "IMG_EFFECT")
	local function playAni( ... )
							--船动画
				local file_Path = "images/effect/skypiea/bell_duang.ExportJson"
				local animation_Name = "bell_duang"
				
					--音效
				AudioHelper.playEffect("audio/effect/texiao_shenmikongdao_tongguan.mp3")
				local clockAni = UIHelper.createArmatureNode({
					filePath = file_Path,
					fnFrameCall = function ( bone, frameEventName, originFrameIndex, currentFrameIndex )
						if frameEventName == "1" then
								local forceAni = UIHelper.createArmatureNode({
									filePath = "images/effect/forge/qh3/qh3.ExportJson",
								    -- animation_Name = "qh3_2"
								})
							lay_main:addNode(forceAni,99)
							forceAni:setPosition(ccp(lay_main:getSize().width / 2,lay_main:getSize().height / 2 + 180))
							forceAni:getAnimation():playWithIndex(1, -1, -1, -1)
						end
					end

				})

				clockAni:setPosition(ccp(lay_main:getSize().width / 2,lay_main:getSize().height / 2))
				clockAni:getAnimation():playWithIndex(0, -1, -1, -1)
				lay_main:addNode(clockAni,100)

				lay_main:addTouchEventListener(function ( sender, eventType )
					if (eventType == TOUCH_EVENT_ENDED) then
						logger:debug("	LayerManager.removeLayout() -- 移除屏蔽层")
						AudioHelper.playCloseEffect()

						LayerManager.removeLayout() -- 移除屏蔽层

					end
				end)
	end


	performWithDelay(m_mainWidget,playAni,1)

	LayerManager.lockOpacity(m_mainWidget)
	return m_mainWidget
end
