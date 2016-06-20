-- FileName: ChooseGiftView.lua
-- Author: zhangqi
-- Date: 2015-07-30
-- Purpose: 选择礼物的UI模块
--[[TODO List]]

-- module("ChooseGiftView", package.seeall)

ChooseGiftView = class("ChooseGiftView")

function ChooseGiftView:ctor(...)
	self.layMain = g_fnLoadUI("ui/item_choose.json")
	self._i18n = gi18n
	self._i18nString = gi18nString

	self._LSV_SCROLL_COUNT = 3 -- 物品列表超过3个才允许滑动
	self._TAG_ARROW_ACT = 777
	self._tbCBX = {} -- 存放 checkbox 的引用和状态
end

function ChooseGiftView:create( tbArgs )
	logger:debug({ChooseGiftView_create_tbArgs = tbArgs})
	local layRoot = self.layMain

	layRoot.BTN_CLOSE:addTouchEventListener(UIHelper.onClose)
	layRoot.BTN_GET:addTouchEventListener(function ( sender, eventType ) -- 领取按钮事件
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()

			for cbx, getArgs in pairs(self._tbCBX) do
				if (cbx:getSelectedState()) then
					tbArgs.GetCallback(getArgs)
					return
				end
			end

			require "script/module/public/ShowNotice"
			ShowNotice.showShellInfo(self._i18n[6201])
		end
	end)
	UIHelper.titleShadow(layRoot.BTN_GET, self._i18n[2628])

	layRoot.tfd_choose:setText(self._i18n[6202])

	self._lArrow = self.layMain.IMG_ARROW_LEFT  -- UIHelper.createRedTipAnimination()
	self._lArrowNode = self._lArrow:getVirtualRenderer()
	self._rArrow = self.layMain.IMG_ARROW_RIGHT -- UIHelper.createRedTipAnimination()
	self._rArrowNode = self._rArrow:getVirtualRenderer()

	self:initItemList(tbArgs.items)

	return self.layMain
end

function ChooseGiftView:addArrowAction( node,tagAct )
	if (not node) then
		return
	end

	local ct = 1.5 -- 渐隐渐现总时长 1.5秒
	local arrAct = CCArray:create()
	arrAct:addObject(CCFadeIn:create(ct/2))
	arrAct:addObject(CCFadeOut:create(ct/2))
	local act = CCRepeatForever:create(CCSequence:create(arrAct))
	act:setTag(tagAct)
	node:runAction(act)

end

function ChooseGiftView:createActFunc( ... )
	return function ( bShow, node )
		local tag = self._TAG_ARROW_ACT
		if (bShow) then
			if (not node:getActionByTag(tag)) then
				self:addArrowAction(node, tag)
			end
		else
			node:stopActionByTag(tag)
		end
	end
end

function ChooseGiftView:setArrowVisible( bLeft, bRight )
	self._lArrow:setVisible(bLeft)
	self._rArrow:setVisible(bRight)

	local fnLeft = self:createActFunc()
	fnLeft(bLeft, self._lArrowNode)

	local fnRight = self:createActFunc()
	fnRight(bRight, self._rArrowNode)
end

function ChooseGiftView:initItemList( tbItems )
	-- logger:debug({initItemList_tbItems = tbItems})
	local lsvList = self.layMain.LSV_MAIN

	UIHelper.initListView(lsvList)

	if (not table.isEmpty(tbItems)) then
		local bScroll = #tbItems > self._LSV_SCROLL_COUNT
		lsvList:setTouchEnabled(bScroll)

		self:setArrowVisible(false, bScroll) -- 初始化滑动指向箭头的显示状态

		if (bScroll) then
			self._szLsvCont = lsvList:getInnerContainerSize()

			-- 2015-11-21，添加滑动事件，便于处理指示箭头的显示
			lsvList:addEventListenerScrollView(function ( sender, eventType )
				if (eventType == SCROLLVIEW_EVENT_SCROLLING) then
					logger:debug("SCROLLVIEW_EVENT_SCROLLING")

					local hOffset = sender:getHContentOffset()
					
					logger:debug({hOffset = hOffset})
					if (hOffset >= 0) then -- 右箭头不显示
						self:setArrowVisible(false, true)
					else
						local lOffMax = sender:getViewSize().width - self._szLsvCont.width -- 左边的最大位移
						logger:debug({hOffset = hOffset, lOffMax = lOffMax})
						if (hOffset <= lOffMax) then -- 左箭头不显示
							self:setArrowVisible(true, false)
						else
							self:setArrowVisible(true, true)
						end
					end
				end		
			end)
		end

		local nIdx, cell = -1, nil
		for i, gift in ipairs(tbItems) do
			lsvList:pushBackDefaultItem()
			nIdx = nIdx + 1
			cell = lsvList:getItem(nIdx)  -- cell 索引从 0 开始

			local icon = ItemUtil.createBtnByTemplateIdAndNumber(gift.htid, gift.num,
				function ( sender, eventType )  -- 道具图标按钮事件，弹出道具信息框
					if (eventType == TOUCH_EVENT_ENDED) then
						-- AudioHelper.playCommonEffect()
						PublicInfoCtrl.createItemInfoViewByTid(gift.htid, nil)
					end
				end
			)
			local szIcon = icon:getSize()
			icon:setPosition(ccp(szIcon.width/2, szIcon.height/2))
			cell.LAY_PHOTO:addChild(icon) -- 物品图标
			cell.tfd_name:setText(gift.name) -- 名称
			cell.tfd_name:setColor(g_QulityColor[gift.quality]) -- 2015-11-21，名称颜色用品质颜色

			-- 选择物品
			cell.CBX_CHOOSE:addEventListenerCheckBox(function ( sender, eventType )
				AudioHelper.playCommonEffect()

				if (eventType == CHECKBOX_STATE_EVENT_SELECTED) then
					for cbx, _ in pairs(self._tbCBX) do
						cbx:setSelectedState(cbx == sender)
					end
				else
					sender:setSelectedState(false)
				end
			end)
			self._tbCBX[cell.CBX_CHOOSE] = {rpcArgs = gift.getArgs, giftStr = gift.giftStr}
		end
	end
end
