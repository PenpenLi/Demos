-- FileName: WorldBossRewardView.lua
-- Author: yucong
-- Date: 2015-06-23
-- Purpose: 奖励界面
--[[TODO List]]

module("WorldBossRewardView", package.seeall)

local m_fnGetWidget = g_fnGetWidgetByName
-- 模块局部变量 --
local _tbData = nil
local _mainLayer = nil

local function init(tbData)
	_tbData = tbData
	_mainLayer = g_fnLoadUI("ui/public_item_reward.json")
end

function destroy(...)
	--_tbData = nil
	_mainLayer = nil
	package.loaded["WorldBossRewardView"] = nil
end

function moduleName()
    return "WorldBossRewardView"
end

function create(tbData, func)
	logger:debug(tbData)
	init(tbData)
	local tbNames = {"win_drop_black/white", "win_drop_black/white", "win_drop_green", "win_drop_blue", "win_drop_purple", "win_drop_orange"}

	LayerManager.lockOpacity(_mainLayer)
	UIHelper.registExitAndEnterCall(_mainLayer, function ( ... )
		if (_tbData) then
			for i=1,#tbData do
				tbData[i].icon:release()
			end
			_tbData = nil
		end
    end)
	-- registExitAndEnterCall(_mainLayer, function ( ... )
	-- 	LayerManager.addRemoveLayoutCallback(nil)
	-- end)
	-- LayerManager.addRemoveLayoutCallback(function ( ... )
	-- 	_mainLayer:setTouchEnabled(true)
	-- end)
	for i=1,#tbData do
		tbData[i].icon:retain()
	end

	local imgArrowUp = m_fnGetWidget(_mainLayer, "IMG_ARROW_UP")
	local imgArrowBottom = m_fnGetWidget(_mainLayer, "IMG_ARROW_BOTTOM")
	imgArrowUp:setEnabled(false)
	imgArrowBottom:setEnabled(false)
	_mainLayer.IMG_FADEIN_CLOSE:setVisible(false)

	_mainLayer.lay_touch:setTouchEnabled(false)
	_mainLayer.lay_touch:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			if (func) then
				func()
			else
				AudioHelper.playCloseEffect()
				if (_mainLayer.lay_touch:isTouchEnabled()) then
					LayerManager.removeLayout()
				end
			end
		end
	end)
	if (not func) then
		_mainLayer.TFD_TIP:setVisible(false)
	end

	local lsvDrop = m_fnGetWidget(_mainLayer, "LSV_DROP")
	local defaultItem = lsvDrop:getItem(0)
	lsvDrop:setItemModel(defaultItem)
	lsvDrop:removeAllItems()
	lsvDrop:setTouchEnabled(false)

	local imgForFill1 = ImageView:create()
	imgForFill1:loadTexture("ui/arrow_public.png")
	imgForFill1:setEnabled(false)
	imgForFill1:setScale9Enabled(true)
	imgForFill1:setSize(CCSizeMake(100, 35))
	lsvDrop:pushBackCustomItem(imgForFill1)

	local hei = defaultItem:getSize().height
	local rowCount = math.ceil(#tbData / 4)
	hCount = rowCount > 4 and 4 or rowCount
	lsvDrop:setSize(CCSizeMake(lsvDrop:getSize().width, lsvDrop:getSize().height * hCount + 45))

	for i = 1, rowCount do
		lsvDrop:pushBackDefaultItem()
		local item = lsvDrop:getItem(i)
		for j=1,4 do
			local layDrop = m_fnGetWidget(item, "LAY_DROP" .. j)
			layDrop:setEnabled(false)
			if (hCount == 1) then
				local pos = layDrop:getPositionPercent()
				local offX = (4 - #tbData) * 0.5 * layDrop:getSize().width / item:getSize().width
				layDrop:setPositionPercent(ccp(pos.x + offX, pos.y))
			end
		end
	end

	local imgForFill2 = ImageView:create()
	imgForFill2:loadTexture("ui/arrow_public.png")
	imgForFill2:setEnabled(false)
	imgForFill2:setScale9Enabled(true)
	imgForFill2:setSize(CCSizeMake(100, 10))
	lsvDrop:pushBackCustomItem(imgForFill2)

	function playAnimation( index )
		local row = math.ceil(index / 4)
		local col = index - row * 4 + 4
		-- 结束
		if (index > #tbData) then
			logger:debug("worldboss奖励动画结束")
			_mainLayer.lay_touch:setTouchEnabled(true)
			_mainLayer.IMG_FADEIN_CLOSE:setVisible(false)

			-- 触摸文字特效
			local armature = UIHelper.createArmatureNode({
					filePath = WorldBossModel.getEffectPath("fadein_close.ExportJson"),
					animationName = "fadein_close",
					loop = 1,
				})
			armature:setAnchorPoint(ccp(_mainLayer.IMG_FADEIN_CLOSE:getAnchorPoint().x, _mainLayer.IMG_FADEIN_CLOSE:getAnchorPoint().y))
			armature:setPosition(ccp(_mainLayer.IMG_FADEIN_CLOSE:getPositionX(), _mainLayer.IMG_FADEIN_CLOSE:getPositionY()))
			_mainLayer:addNode(armature)
			-- 闪烁动作
			-- local action = WorldBossModel.getBlinkAction()
			-- armature:runAction(action)

			if (rowCount > 4) then
				lsvDrop:setTouchEnabled(true)

				-- 上下剪头
				local arrowUp = UIHelper.fadeInAndOutImage("ui/arrow_public.png")
				local arrowBottom = UIHelper.fadeInAndOutImage("ui/arrow_public.png")
				arrowUp:setRotation(180)
				arrowUp:setPosition(ccp(imgArrowUp:getPositionX(), imgArrowUp:getPositionY()))
				arrowBottom:setPosition(ccp(imgArrowBottom:getPositionX(), imgArrowBottom:getPositionY()))
				imgArrowUp:getParent():addNode(arrowUp)
				imgArrowBottom:getParent():addNode(arrowBottom)
				arrowBottom:setVisible(false)

				lsvDrop:addEventListenerScrollView(function (sender, ScrollviewEventType)
					local offset = lsvDrop:getContentOffset()
					local lisvSizeH = lsvDrop:getSize().height
					local lisvContainerH = lsvDrop:getInnerContainerSize().height
					if (offset - lisvSizeH < 1) then
						arrowUp:setVisible(false)
					else
						arrowUp:setVisible(true)
					end

					if (offset- lisvContainerH < 0) then
						arrowBottom:setVisible(true)
					else
						arrowBottom:setVisible(false)
					end
				end)
			end

			return
		end

		local itemInfo = tbData[index]

		local item = lsvDrop:getItem(row)
		local layDrop = m_fnGetWidget(item, "LAY_DROP" .. col)
		local imgIcon = m_fnGetWidget(item, "IMG_" .. col)
		local tfdName = m_fnGetWidget(item, "TFD_NAME_" .. col)

		local x, y = imgIcon:getPosition()

		local callfunc1 = CCCallFunc:create(function ( ... )
			if (row > 4) then
				local posY = item:getPositionY()
				local tHeight = hei * rowCount + 45 - lsvDrop:getSize().height
				local nPercent = posY / tHeight * 100
				lsvDrop:scrollToPercentVertical(100 - nPercent, 0.15, true)
			end
		end)

		local callfunc2 = CCCallFunc:create(function ( ... )
			local armature = UIHelper.createArmatureNode({
				filePath = "images/effect/battle_result/win_drop.ExportJson",
				fnFrameCall = function ( bone, frameEventName, originFrameIndex, currentFrameIndex )
					if (frameEventName == "1") then
						-- imgIcon:setEnabled(true)
						tfdName:setEnabled(true)

						if (itemInfo.quality) then
							local armatureLight = UIHelper.createArmatureNode({
								filePath = "images/effect/battle_result/win_drop.ExportJson",
								animationName = tbNames[tonumber(itemInfo.quality)],
							})
							armatureLight:setPosition(ccp(x, y))
							layDrop:addNode(armatureLight, -1, -1)
						end

						playAnimation( index + 1 )
					end
				end,

				fnMovementCall = function ( sender, MovementEventType , frameEventName)
					if (MovementEventType == 1) then
						-- imgIcon:setEnabled(true)
						-- sender:removeFromParentAndCleanup(true)
						sender:removeFromParentAndCleanup(true)
						imgIcon:setEnabled(true)
						imgIcon:addChild(itemInfo.icon)
						--itemInfo.icon:release()
					end
				end,
			})

			--imgIcon:addChild(itemInfo.icon)
			--itemInfo.icon:release()
			tfdName:setText(itemInfo.name)
			if (itemInfo.quality) then
				tfdName:setColor(g_QulityColor2[tonumber(itemInfo.quality)])
			end

			-- -- imgIcon:retain()
			-- -- imgIcon:removeFromParent()
			-- local imgIconCopy = imgIcon:clone()
			-- imgIconCopy:setPosition(ccp(0, 0))
			-- armature:getBone("win_drop_3"):addDisplay(imgIconCopy, 0)
			-- -- imgIcon:release()
			armature:getBone("win_drop_3"):addDisplay(itemInfo.icon, 0)

			armature:setPosition(ccp(x, y))
			layDrop:addNode(armature)
			layDrop:setEnabled(true)
			imgIcon:setEnabled(false)
			--imgIconCopy:setEnabled(true)

			-- armature:getAnimation():gotoAndPause(1)
			AudioHelper.playSpecialEffect("texiao_fanpai.mp3")
			armature:getAnimation():play("win_drop", -1, -1, 0)
			armature:getAnimation():setSpeedScale(math.ceil(rowCount / 32))
		end)
		local sequence = CCSequence:createWithTwoActions(callfunc1, callfunc2)
		_mainLayer:runAction(sequence)
	end

	performWithDelay(_mainLayer, function ( ... )
		playAnimation(1)
	end, 0.18)

	return _mainLayer
end
