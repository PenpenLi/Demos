-- FileName: MainAwakeView.lua
-- Author: Xufei
-- Date: 2015-11-16
-- Purpose: 伙伴觉醒主界面 视图
--[[TODO List]]

MainAwakeView = class("MainAwakeView")

-- UI控件引用变量 --
local _layMain

-- 模块局部变量 --
local HERO_BODY_PATH = "images/base/hero/body_img/"
local _fnGetWidget = g_fnGetWidgetByName
local _tbEvent = nil

local _nowPartnerInfo = nil
local _i18n = gi18n
local _i18nString = gi18nString

function MainAwakeView:getIsTurningPage( ... )
    local heroPageView = _layMain.PGV_MAIN
    if (heroPageView:isAutoScrolling()) then
        return true
    else
        return false
    end
end



-- 仅仅刷新觉醒装备区域的视图，用作觉醒特效时候
function MainAwakeView:reloadAwakeEquipView( ... )
	local nowPartnerInfo = MainAwakeModel.getNowPartnerInfo()
	local awakeInfo = nowPartnerInfo.heroInfo.awakeConsume

	-- 镶嵌四个觉醒道具
	for i = 1,4 do
		local tbEquip = awakeInfo.equip[i]
		local btn = _fnGetWidget(_layMain, "BTN_" .. i)
		UIHelper.setWidgetGray(btn, false)
		btn:setTag(i)
		btn.IMG_EQUIP:removeAllChildrenWithCleanup(true)
		btn.TFD_TXT:setVisible(tbEquip.installed == 0)

		local itemDB = DB_Item_disillusion.getDataById(tbEquip.itemId)
		local qualityNum = itemDB.quality
		local qualityFrame = "images/base/potential/equip_" .. tostring(qualityNum) .. ".png"
		local qualityColor = "images/base/potential/color_" .. tostring(qualityNum) .. ".png"
		btn.IMG_BORDER:loadTexture(qualityFrame)
		btn:loadTextures(qualityColor, qualityColor, nil) 

		-- 如果已经装备
		if (tbEquip.installed == 1) then 	
			-- 显示对应图标
			local btnItem = ItemUtil.createBtnByTemplateId(tbEquip.itemId, function (sender,eventType)
				if (eventType == TOUCH_EVENT_ENDED) then
					PublicInfoCtrl.createItemInfoViewByTid(tbEquip.itemId)
				end
			end, {false,false})
			btn.IMG_EQUIP:addChild(btnItem)
		else
			-- 显示对应图标
			local btnItem = ItemUtil.createBtnByTemplateId(tbEquip.itemId, nil, {false,false})
			btn.IMG_EQUIP:addChild(btnItem)
			-- 如果背包里的足够，显示可装备
			if (MainAwakeModel.getIfEnough(tbEquip.itemId, tbEquip.itemNum)) then
				btn.TFD_TXT:setColor(ccc3(0x65, 0xef, 0x00))
				UIHelper.labelAddNewStroke( btn.TFD_TXT, _i18n[7410], ccc3(0x28, 0x00, 0x00) ) -- 可装备
				btn:addTouchEventListener(function ( sender, eventType )
					if (eventType == TOUCH_EVENT_ENDED) then
						AudioHelper.playInfoEffect()
						_tbEvent.onEquip( sender, eventType )
					end
				end)
			-- 如果不够，但能合成，显示可合成，能合成指的是存在合成表，不需要有足够材料
			-- 改成，有字段的话，弹出合成框，但是文字根据能否足够合成而显示可合成或去获取
			elseif (MainAwakeModel.getComposTableByItemId(tbEquip.itemId, tbEquip.itemNum).canCompose == 1)then
				--btn.TFD_TXT:setText("可合成") ---TODO
				if (MainAwakeModel.mainGetIfCanCompose(tbEquip.itemId, tbEquip.itemNum)) then
					btn.TFD_TXT:setColor(ccc3(0xff, 0xba, 0x00))
					UIHelper.labelAddNewStroke( btn.TFD_TXT, _i18n[7412], ccc3(0x28, 0x00, 0x00) ) -- 可合成
				else
					btn.TFD_TXT:setColor(ccc3(0xff, 0xe8, 0xc9))
					UIHelper.labelAddNewStroke( btn.TFD_TXT, _i18n[7425], ccc3(0x28, 0x00, 0x00) ) -- 去获取
				end
				btn:addTouchEventListener(_tbEvent.onCompose)
			-- 如果不能装备也不能合成，显示去获取
			else 
				--btn.TFD_TXT:setText("去获取") ---TODO
				btn.TFD_TXT:setColor(ccc3(0xff, 0xe8, 0xc9))
				UIHelper.labelAddNewStroke( btn.TFD_TXT, _i18n[7425], ccc3(0x28, 0x00, 0x00) ) -- 去获取

				btn:addTouchEventListener(_tbEvent.onGetWay)
			end
		end
		--UIHelper.setWidgetGray(btn.IMG_EQUIP, tbEquip.installed ~= 1)
		btn.IMG_MENGBAN:setVisible(tbEquip.installed ~= 1)
	end

end

-- 仅仅刷新除了觉醒装备区域之外的视图，用作觉醒特效时候
function MainAwakeView:reloadAwakeOtherInfoView( ... )
	local awakeInfo = _nowPartnerInfo.heroInfo.awakeConsume

	-- 改变星级显示
	for i = 1, 5 do
		local star = _fnGetWidget(_layMain, "IMG_STAR" .. i .. "_ON")
		star:setVisible(i <= awakeInfo.star)
	end
	_layMain.TFD_LV_NUM:setText( string.format(_i18n[7403],awakeInfo.star,awakeInfo.level) ) -- X星X级

	local textOfNextStar = string.format(_i18n[7405], tonumber(awakeInfo.advanceNextStar)) -- 觉醒X星解锁
	local textOfAdvance = awakeInfo.advanceDes .. "（" .. textOfNextStar .. "）"
	UIHelper.labelAddNewStroke( _layMain.TFD_ABILITY, textOfAdvance, ccc3(0x45, 0x05, 0x05) ) 

	-- 消耗类物品
	for i = 1,2 do 
		local itemInfo
		local lay = _fnGetWidget(_layMain, "LAY_ITEM_ALL" .. i)
		local btnItem
		local leftNum
		if (i == 1) then
			itemInfo = awakeInfo.stone
			btnItem = ItemUtil.createBtnByTemplateId(itemInfo.id, function ( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					AudioHelper.playInfoEffect()
					local stoneDrop = PropertyDrop:new()
					local stoneDropLayer = stoneDrop:create(itemInfo.id, function ( ... )
						self:changePage()
					end)
					LayerManager.addLayout(stoneDropLayer)
				end
			end, {false,false})
			leftNum = ItemUtil.getNumInBagByTid(itemInfo.id)
		elseif (i == 2) then
			itemInfo = awakeInfo.fragment
			btnItem = ItemUtil.createBtnByTemplateId(itemInfo.id, function ( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					AudioHelper.playInfoEffect()
					local fragmentDrop = FragmentDrop:new()
					local fragmentDropLayer = fragmentDrop:create(itemInfo.id, function ( ... )
						self:changePage()
					end)
					LayerManager.addLayout(fragmentDropLayer)
				end
			end, {false,false})
			leftNum = DataCache.getHeroFragNumByItemTmpid(itemInfo.id)
		end
		lay:setEnabled(itemInfo.num ~= 0)
		local item = ItemUtil.getItemById(itemInfo.id)
		local tfdName = _fnGetWidget(lay, "TFD_ITEM_NAME" .. i)
		tfdName:setText(item.name)
		tfdName:setColor(g_QulityColor[item.quality])
		lay.TFD_NUM_RIGHT:setText(itemInfo.num)
		lay.TFD_NUM_LEFT:setText(leftNum)
		if (tonumber(leftNum)<tonumber(itemInfo.num))then
			lay.TFD_NUM_LEFT:setColor(ccc3(0xff, 0x00, 0x00))
		else
			lay.TFD_NUM_LEFT:setColor(ccc3(0x00, 0x8a, 0x00))
		end
		local layBtn = _fnGetWidget(lay, "LAY_ITEM" .. i) 
		btnItem:setPosition(ccp(layBtn:getContentSize().width*0.5,layBtn:getContentSize().height*0.5))
		if ((itemInfo.num ~= 0)) then
			layBtn:addChild(btnItem)
		end
	end

	-- 贝里消耗
	_layMain.TFD_CONSUME_NUM:setText(awakeInfo.belly)

	-- 觉醒按钮
	---[==[
	UIHelper.setWidgetGray( _layMain.BTN_ADVANCE , (not MainAwakeModel.canAwake()) or (awakeInfo.lvInfo.isMaxLv == 1))
	if ( tonumber(_nowPartnerInfo.heroInfo.level) < awakeInfo.limitLv ) then
		UIHelper.titleShadow(_layMain.BTN_ADVANCE, _i18n[7413]..awakeInfo.limitLv) -- 需要等级：
	else
		UIHelper.titleShadow(_layMain.BTN_ADVANCE, _i18n[7401]) -- 觉醒
	end--]==]
	_layMain.BTN_ADVANCE:addTouchEventListener(_tbEvent.onAwake)
---[==[	
	_layMain.BTN_ADVANCE:setTouchEnabled( MainAwakeModel.canAwake() and (awakeInfo.lvInfo.isMaxLv == 0) )

	if (awakeInfo.lvInfo.isMaxLv == 1) then
		_layMain.TFD_CONSUME_NUM:setText("0")
	end

	if (awakeInfo.lvInfo.isMaxLv == 1) then
		_layMain.LAY_ITEM_ALL1:setEnabled(false)
		_layMain.LAY_ITEM_ALL2:setEnabled(false)
	end

	for i = 1,4 do
		local btns = _fnGetWidget(_layMain, "BTN_" .. i)
		btns:setEnabled(awakeInfo.lvInfo.isMaxLv == 0)
		btns:setTouchEnabled(awakeInfo.lvInfo.isMaxLv == 0)
	end--]==]
end


-- 重新显示觉醒信息和镶嵌的视图
function MainAwakeView:reloadAwakeInfoView( ... )
	local awakeInfo = _nowPartnerInfo.heroInfo.awakeConsume

	-- 改变星级显示
	for i = 1, 5 do
		local star = _fnGetWidget(_layMain, "IMG_STAR" .. i .. "_ON")
		star:setVisible(i <= awakeInfo.star)
	end
	_layMain.TFD_LV_NUM:setText( string.format(_i18n[7403],awakeInfo.star,awakeInfo.level) ) -- X星X级

	local textOfNextStar = string.format(_i18n[7405], tonumber(awakeInfo.advanceNextStar)) -- 觉醒X星解锁
	local textOfAdvance = awakeInfo.advanceDes .. "（" .. textOfNextStar .. "）"
	UIHelper.labelAddNewStroke( _layMain.TFD_ABILITY, textOfAdvance, ccc3(0x45, 0x05, 0x05) ) 

	-- 镶嵌四个觉醒道具
	for i = 1,4 do
		local tbEquip = awakeInfo.equip[i]
		local btn = _fnGetWidget(_layMain, "BTN_" .. i)
		UIHelper.setWidgetGray(btn, false)
		btn:setTag(i)
		btn.IMG_EQUIP:removeAllChildrenWithCleanup(true)
		btn.TFD_TXT:setVisible(tbEquip.installed == 0)

		local itemDB = DB_Item_disillusion.getDataById(tbEquip.itemId)
		local qualityNum = itemDB.quality
		local qualityFrame = "images/base/potential/equip_" .. tostring(qualityNum) .. ".png"
		local qualityColor = "images/base/potential/color_" .. tostring(qualityNum) .. ".png"
		btn.IMG_BORDER:loadTexture(qualityFrame)
		btn:loadTextures(qualityColor, qualityColor, nil) 

		-- 如果已经装备
		if (tbEquip.installed == 1) then 	
			-- 显示对应图标
			local btnItem = ItemUtil.createBtnByTemplateId(tbEquip.itemId, function (sender,eventType)
				if (eventType == TOUCH_EVENT_ENDED) then
					PublicInfoCtrl.createItemInfoViewByTid(tbEquip.itemId)
				end
			end, {false,false})
			btn.IMG_EQUIP:addChild(btnItem)
		else
			-- 显示对应图标
			local btnItem = ItemUtil.createBtnByTemplateId(tbEquip.itemId, nil, {false,false})
			btn.IMG_EQUIP:addChild(btnItem)
			-- 如果背包里的足够，显示可装备
			if (MainAwakeModel.getIfEnough(tbEquip.itemId, tbEquip.itemNum)) then
				btn.TFD_TXT:setColor(ccc3(0x65, 0xef, 0x00))
				UIHelper.labelAddNewStroke( btn.TFD_TXT, _i18n[7410], ccc3(0x28, 0x00, 0x00) ) -- 可装备
				btn:addTouchEventListener(function ( sender, eventType )
					if (eventType == TOUCH_EVENT_ENDED) then
						AudioHelper.playInfoEffect()
						_tbEvent.onEquip( sender, eventType )
					end
				end)
			-- 如果不够，但能合成，显示可合成，能合成指的是存在合成表，不需要有足够材料
			-- 改成，有字段的话，弹出合成框，但是文字根据能否足够合成而显示可合成或去获取
			elseif (MainAwakeModel.getComposTableByItemId(tbEquip.itemId, tbEquip.itemNum).canCompose == 1)then
				--btn.TFD_TXT:setText("可合成") ---TODO
				if (MainAwakeModel.mainGetIfCanCompose(tbEquip.itemId, tbEquip.itemNum)) then
					btn.TFD_TXT:setColor(ccc3(0xff, 0xba, 0x00))
					UIHelper.labelAddNewStroke( btn.TFD_TXT, _i18n[7412], ccc3(0x28, 0x00, 0x00) ) -- 可合成
				else
					btn.TFD_TXT:setColor(ccc3(0xff, 0xe8, 0xc9))
					UIHelper.labelAddNewStroke( btn.TFD_TXT, _i18n[7425], ccc3(0x28, 0x00, 0x00) ) -- 去获取
				end

				btn:addTouchEventListener(_tbEvent.onCompose)
			-- 如果不能装备也不能合成，显示去获取
			else 
				--btn.TFD_TXT:setText("去获取") ---TODO
				btn.TFD_TXT:setColor(ccc3(0xff, 0xe8, 0xc9))
				UIHelper.labelAddNewStroke( btn.TFD_TXT, _i18n[7425], ccc3(0x28, 0x00, 0x00) )  --去获取

				btn:addTouchEventListener(_tbEvent.onGetWay)
			end
		end
		--UIHelper.setWidgetGray(btn.IMG_EQUIP, tbEquip.installed ~= 1)
		btn.IMG_MENGBAN:setVisible(tbEquip.installed ~= 1)
	end

	-- 消耗类物品
	for i = 1,2 do 
		local itemInfo
		local lay = _fnGetWidget(_layMain, "LAY_ITEM_ALL" .. i)
		local btnItem
		local leftNum
		if (i == 1) then
			itemInfo = awakeInfo.stone
			btnItem = ItemUtil.createBtnByTemplateId(itemInfo.id, function ( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					AudioHelper.playInfoEffect()
					if (self:getIsTurningPage()) then
						return
					end
					local stoneDrop = PropertyDrop:new()
					local stoneDropLayer = stoneDrop:create(itemInfo.id, function ( ... )
						self:changePage()
					end)
					LayerManager.addLayout(stoneDropLayer)
				end
			end, {false,false})
			leftNum = ItemUtil.getNumInBagByTid(itemInfo.id)
		elseif (i == 2) then
			itemInfo = awakeInfo.fragment
			btnItem = ItemUtil.createBtnByTemplateId(itemInfo.id, function ( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					AudioHelper.playInfoEffect()
					if (self:getIsTurningPage()) then
						return
					end
					local fragmentDrop = FragmentDrop:new()
					local fragmentDropLayer = fragmentDrop:create(itemInfo.id, function ( ... )
						self:changePage()
					end)
					LayerManager.addLayout(fragmentDropLayer)
				end
			end, {false,false})
			leftNum = DataCache.getHeroFragNumByItemTmpid(itemInfo.id)
		end
		lay:setEnabled(itemInfo.num ~= 0)
		local item = ItemUtil.getItemById(itemInfo.id)
		local tfdName = _fnGetWidget(lay, "TFD_ITEM_NAME" .. i)
		tfdName:setText(item.name)
		tfdName:setColor(g_QulityColor[item.quality])
		lay.TFD_NUM_RIGHT:setText(itemInfo.num)
		lay.TFD_NUM_LEFT:setText(leftNum)
		if (tonumber(leftNum)<tonumber(itemInfo.num))then
			lay.TFD_NUM_LEFT:setColor(ccc3(0xff, 0x00, 0x00))
		else
			lay.TFD_NUM_LEFT:setColor(ccc3(0x00, 0x8a, 0x00))
		end
		local layBtn = _fnGetWidget(lay, "LAY_ITEM" .. i) 
		btnItem:setPosition(ccp(layBtn:getContentSize().width*0.5,layBtn:getContentSize().height*0.5))
		if ((itemInfo.num ~= 0)) then
			layBtn:addChild(btnItem)
		end
	end

	-- 贝里消耗
	_layMain.TFD_CONSUME_NUM:setText(awakeInfo.belly)

	-- 觉醒按钮
	---[==[
	UIHelper.setWidgetGray( _layMain.BTN_ADVANCE , (not MainAwakeModel.canAwake()) or (awakeInfo.lvInfo.isMaxLv == 1))
	if ( tonumber(_nowPartnerInfo.heroInfo.level) < awakeInfo.limitLv ) then
		UIHelper.titleShadow(_layMain.BTN_ADVANCE, _i18n[7413]..awakeInfo.limitLv) -- 需要等级：
	else
		UIHelper.titleShadow(_layMain.BTN_ADVANCE, _i18n[7401]) -- 觉醒
	end--]==]
	_layMain.BTN_ADVANCE:addTouchEventListener(_tbEvent.onAwake)
---[==[	
	_layMain.BTN_ADVANCE:setTouchEnabled( MainAwakeModel.canAwake() and (awakeInfo.lvInfo.isMaxLv == 0) )

	if (awakeInfo.lvInfo.isMaxLv == 1) then
		_layMain.TFD_CONSUME_NUM:setText("0")
	end

	if (awakeInfo.lvInfo.isMaxLv == 1) then
		_layMain.LAY_ITEM_ALL1:setEnabled(false)
		_layMain.LAY_ITEM_ALL2:setEnabled(false)
	end

	for i = 1,4 do
		local btns = _fnGetWidget(_layMain, "BTN_" .. i)
		btns:setEnabled(awakeInfo.lvInfo.isMaxLv == 0)
		btns:setTouchEnabled(awakeInfo.lvInfo.isMaxLv == 0)
	end--]==]
end

-- 翻页时更新当前伙伴信息
function MainAwakeView:changePage( ... )
	_nowPartnerInfo = MainAwakeModel.getNowPartnerInfo()

	self:reloadAwakeInfoView()

	_layMain.img_arrow_left:setVisible( MainAwakeModel.getIfCanSlip()==1 and _layMain.PGV_MAIN:getCurPageIndex()~=0)
	_layMain.img_arrow_right:setVisible( MainAwakeModel.getIfCanSlip()==1 and _layMain.PGV_MAIN:getCurPageIndex()~=_layMain.PGV_MAIN:getChildrenCount()-1)
end

-- 加载伙伴的图片
function loadPartnerViewAndName( page, partnerInfo )
	page.IMG_SPECIAL:loadTexture(HERO_BODY_PATH .. partnerInfo.localInfo.body_img_id)
	page.IMG_SPECIAL:setScale(80 / 100)
	UIHelper.fnPlayHuxiAni(page.IMG_SPECIAL)
end

-- 显示伙伴pageView
function MainAwakeView:showPartner( ... )
	local canSlip = MainAwakeModel.getIfCanSlip()
	local partnerList = MainAwakeModel.getPartnerListWithNoEmpty()

	_layMain.img_arrow_left:setVisible(canSlip==1)
	_layMain.img_arrow_right:setVisible(canSlip==1)

	if (canSlip == 0) then
		loadPartnerViewAndName(_layMain.PGV_MAIN, partnerList[1].heroInfo)
		_nowPartnerInfo = partnerList[1]
		self:reloadAwakeInfoView()
	elseif (canSlip == 1) then
		_layMain.PGV_MAIN:addEventListenerPageView(_tbEvent.onPgvEvent)
		
		local pageClone = _layMain.PGV_MAIN.LAY_PAGE:clone()
		_layMain.PGV_MAIN.LAY_PAGE:removeFromParentAndCleanup(true)
		_layMain.PGV_MAIN:removeAllPages()
		
		local pos = 1
		for k, v in pairs(partnerList) do
			if (v.heroInfo) then
				local pageLayer = pageClone:clone()
				pageLayer:addTouchEventListener(function ( sender,eventType )
					if (eventType == TOUCH_EVENT_CANCELED) then
						logger:debug("pageLayer TOUCH_EVENT_CANCELED")
						-- MainAwakeCtrl.setBtnCanTouchSatus(false)
						 -- 加屏蔽层
						 local layout = Layout:create()
						 layout:setName("layForShield")
						 local isAutoScrolling = _layMain.PGV_MAIN:isAutoScrolling()
						logger:debug({isAutoScrolling = isAutoScrolling})

						 if (isAutoScrolling) then
						 	 LayerManager.addLayout(layout)
						 end

					elseif (eventType == TOUCH_EVENT_ENDED) then 
						logger:debug("pageLayer TOUCH_EVENT_ENDED")
						 --MainAwakeCtrl.setBtnCanTouchSatus(false)
					end
				end)
				loadPartnerViewAndName(pageLayer, v.heroInfo)
				_layMain.PGV_MAIN:addWidgetToPage(pageLayer, pos - 1, true)
				pos = pos+1
			end
		end
		_layMain.PGV_MAIN:initToPage(MainAwakeModel.getNowIndex())

		self:changePage() -- 第一次进入页面，也调用翻页的方法加载页面
	end

end



function MainAwakeView:showEquipAni(equipAttrs, aniPos, hid)
	logger:debug("SHOW UP ZHUANGBEI ANIMATION!!!")
	local aniEquip = UIHelper.createArmatureNode({
		filePath = "images/effect/juexing/awakeEquip/awake_equip.ExportJson",
		animationName = "awake_equip",
		fnMovementCall = function ( sender, MovementEventType , frameEventName)
			if (MovementEventType == EVT_COMPLETE) then
				UserModel.setInfoChanged(true)
				UserModel.updateFightValue({[hid] = {HeroFightUtil.FORCEVALUEPART.HEROAWAKE}})
				
				AwakeUtil.showFlyText(equipAttrs, function ( ... )
					updateInfoBar()
					MainFormationTools.fnShowFightForceChangeAni()
				end)
				LayerManager.removeLayoutByName("layerBlockAwakeEquipAnimation")
			end
		end
	})
	self:changePage()
	local btnItem = _fnGetWidget( _layMain, "BTN_" .. aniPos )
	AudioHelper.playSpecialEffect("awake_item_compose.mp3")
	btnItem.IMG_EQUIP:addNode(aniEquip)
end

function MainAwakeView:showAwakeAni(addAttrs)
	local aniShakeNode1 = nil
	local aniShakeNode2 = nil

	local fnCreateAwakeLightAni = function ( ... )
		logger:debug("SHOW UP HECHENGGUANG ANIMATION !")
		local pageNow = _layMain.PGV_MAIN:getPage(MainAwakeModel.getNowIndex())
		local aniLight = UIHelper.createArmatureNode({
			filePath = "images/effect/hero_qh/qh_hecheng_da/qh_hecheng_da.ExportJson",
			animationName = "qh_hecheng_da",
			fnFrameCall = function ( bone, frameEventName, originFrameIndex, currentFrameIndex )
				if (frameEventName == "3") then
					local aniStar = UIHelper.createArmatureNode({
						filePath = "images/effect/hero_qh/qh_xing/qh_xing.ExportJson",
						animationName = "qh_xing",
						fnMovementCall = function ( sender, MovementEventType , frameEventName)
							if (MovementEventType == EVT_COMPLETE) then
								--ShowNotice.showShellInfo("属性")
								-- 属性飘字
								self:reloadAwakeOtherInfoView()
								AwakeUtil.showFlyText(addAttrs, function ( ... )
									updateInfoBar()
									MainFormationTools.fnShowFightForceChangeAni()
								end)
								LayerManager.removeLayoutByName("layerBlockAwakeAnimation")
							end
						end,
					})
					pageNow.IMG_SPECIAL:addNode(aniStar)
				end
			end
		})
		pageNow.IMG_EFFECT:addNode(aniLight)

		-- 震屏
		local imgBg = _layMain.IMG_BG
		local pageNow = _layMain.PGV_MAIN:getPage(MainAwakeModel.getNowIndex())
		local shakePointTable = {{0,0,2},{0,15,2},{0,15,0},{10,0,2},{0,-15,4},{0,0,0}}
        aniShakeNode1 = ShakeSenceEffNorandom:new(imgBg,shakePointTable)
        aniShakeNode2 = ShakeSenceEffNorandom:new(pageNow.IMG_SPECIAL,shakePointTable)
	end

	local fnCreateAwakeAni1 = function ( ... )
		local aniAwake1 = UIHelper.createArmatureNode({
			filePath = "images/effect/juexing/awake/awake_1.ExportJson",
			animationName = "awake_1",
		})
		return aniAwake1
	end

	local fnCreateAwakeAni = function ( index )
		local aniAwake = UIHelper.createArmatureNode({
			filePath = "images/effect/juexing/awake/awake.ExportJson",
			animationName = "awake",
			fnFrameCall = function ( bone, frameEventName, originFrameIndex, currentFrameIndex )
				local aniAwake1 = fnCreateAwakeAni1()
				local btnItem = _fnGetWidget( _layMain, "BTN_" .. index )
				local pageNow = _layMain.PGV_MAIN:getPage(MainAwakeModel.getNowIndex())
				local positionSpecial = ccp(pageNow.IMG_SPECIAL:getWorldPosition().x,pageNow.IMG_SPECIAL:getWorldPosition().y+pageNow.IMG_SPECIAL:getContentSize().height/2)

				if (frameEventName == "1") then
					logger:debug("show awake event")
					if (index == 1) then
						AudioHelper.playSpecialEffect("awake_1.mp3")
					end

					local acitonArray = CCArray:create()
					acitonArray:addObject(CCDelayTime:create(27 / 60)) --第14帧到第41帧为闪电球【awake_1】停留的时间（即停留27帧）
					acitonArray:addObject(CCCallFunc:create(function( ... )
  						self:reloadAwakeEquipView()
	 				end))
					acitonArray:addObject( CCMoveTo:create(11 / 60, positionSpecial) ) --第42帧到第52帧是闪电球【awake_1】飘到觉醒角色的时间
					acitonArray:addObject(CCDelayTime:create(3 / 60)) -- 第52到第55帧是闪电球【awake_1】落到角色身上之后停留的时间
					acitonArray:addObject(CCFadeOut:create(1 / 60)) --（闪电球【awake_1】到第56帧时直接消失）

					aniAwake1:runAction(CCSequence:create(acitonArray))
					aniAwake1:setPosition(btnItem:getWorldPosition())
					_layMain:addNode(aniAwake1)
				elseif (frameEventName == "2") then
					GlobalNotify.postNotify("MAIN_AWAKE_ANIMATION_GUANGXIAN")
				end
			end
		})
		return aniAwake
	end

	AudioHelper.playSpecialEffect("awake_item_compose.mp3")
	GlobalNotify.addObserver("MAIN_AWAKE_ANIMATION_GUANGXIAN", fnCreateAwakeLightAni, true)
	for i=1,4 do
		local btnItem = _fnGetWidget( _layMain, "BTN_" .. i )
		local aniAwake = fnCreateAwakeAni(i)
		btnItem.IMG_EQUIP:addNode(aniAwake)
	end
end

function MainAwakeView:init(...)
	_layMain = nil
end

function MainAwakeView:destroy(...)
	package.loaded["MainAwakeView"] = nil
	self.layMain = nil
end

function MainAwakeView:moduleName()
    return "MainAwakeView"
end

function MainAwakeView:ctor()
	self.layMain = g_fnLoadUI("ui/awake_main.json") 
end

function MainAwakeView:create( tbEvent )
	self:init()

	_layMain = self.layMain
	_tbEvent = tbEvent
	UIHelper.registExitAndEnterCall(_layMain,
		function()
			GlobalNotify.removeObserver(GlobalNotify.RECONN_OK, "AwakeMainModel")
			MainFormationTools.removeFlyText()
			self:destroy()
		end,
		function()
			GlobalNotify.addObserver(GlobalNotify.RECONN_OK, function ( ... )
				LayerManager.removeLayoutByName("layerBlockAwakeEquipAnimation")
				LayerManager.removeLayoutByName("layerBlockAwakeAnimation")
			end,false,"AwakeMainModel")
		end
	)

	_layMain.IMG_BG:setScaleX(g_fScaleX)	--背景适配屏幕

	_layMain.BTN_CLOSE:addTouchEventListener(_tbEvent.onBtnBack)

	_layMain.BTN_PREVIEW:setZOrder(999)
	_layMain.BTN_PREVIEW:addTouchEventListener(_tbEvent.onPreview)

	self:showPartner()

	require "script/module/guide/GuideAwakeView"
   	if (GuideModel.getGuideClass() == ksGuideAwake and GuideAwakeView.guideStep == 3) then
        require "script/module/guide/GuideCtrl"
        GuideCtrl.createAwakeGuide(4,0,nil, function (  )
        	GuideCtrl.createAwakeGuide(5,0,nil, function (  )
        		GuideCtrl.createAwakeGuide(6)
       		end)
        end)
    end

    _layMain.tfd_consume:setText(_i18n[7407])
    UIHelper.titleShadow(_layMain.BTN_CLOSE, _i18n[1019])
	return _layMain
end

