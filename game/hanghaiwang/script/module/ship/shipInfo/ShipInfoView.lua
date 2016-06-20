-- FileName: ShipInfoView.lua
-- Author: Xufei
-- Date: 2015-10-16
-- Purpose: 主船信息界面
--[[TODO List]]

ShipInfoView = class("ShipInfoView")

-- UI控件引用变量 --
local _layMain = nil
local _fnGetWidgetByName = g_fnGetWidgetByName
local _QulityColor2 = g_QulityColor2

-- 模块局部变量 --
local CELL_DIST_H = 0 -- 天赋文字竖直位置调整
local CELL_PACING_H = -4 -- 天赋文字竖直间隔调整
local TEXT_UP_LEAVE = 50
local TEXT_DOWN_LEAVE = 20
local SHIP_ANI_TAG = 411
local WATER_ANI_TAG = 412
local _i18n = gi18n

function ShipInfoView:i18nAndEffect( ... )
	_layMain.TFD_NAME1:setColor(_QulityColor2[tonumber(ShipInfoModel.getShipQuality())])
	UIHelper.labelNewStroke(_layMain.TFD_NAME1, ccc3(0x28, 0x00, 0x00))

	UIHelper.labelNewStroke(_layMain.tfd_skill_attr, ccc3(0x92, 0x53, 0x1b))
	UIHelper.labelNewStroke(_layMain.tfd_str_attr, ccc3(0x92, 0x53, 0x1b))
	UIHelper.labelNewStroke(_layMain.tfd_str, ccc3(0x92, 0x53, 0x1b))
	UIHelper.labelNewStroke(_layMain.tfd_activate_attr, ccc3(0x92, 0x53, 0x1b))
	UIHelper.labelNewStroke(_layMain.tfd_desc_title, ccc3(0x92, 0x53, 0x1b))
end

function ShipInfoView:refreshView( ... )
	_layMain.TFD_NAME1:setText(ShipInfoModel.getShipName())
	-- 界面上船和浪花的特效
	local imgShip = _layMain.img_ship
	local tbShipPos = ccp(imgShip:getPositionX(),imgShip:getPositionY())
	local tbShipAnchor = ccp(imgShip:getAnchorPoint().x,imgShip:getAnchorPoint().y)
	imgShip:setVisible(false)
	-- 设置tag为411方便之后删除
	UIHelper.addShipAnimation(_layMain.LAY_NOSCV, tonumber(ShipInfoModel.getShipAniId()), tbShipPos, tbShipAnchor, nil, SHIP_ANI_TAG, WATER_ANI_TAG)
	-- 级数
	_layMain.LAY_STR_INFO.TFD_LV_NUM:setText(ShipInfoModel.getStrengthenLevel().."/"..ShipInfoModel.getShipMaxLv())
	-- 强化属性
	local strengthenAttri = ShipInfoModel.getStrengthenAttribute()
	for k,v in ipairs(strengthenAttri) do
		local strTitle = _fnGetWidgetByName(_layMain, "TFD_ATTR" .. tostring(k) .."_STR")
		local strValue = _fnGetWidgetByName(_layMain, "TFD_ATTR" .. tostring(k) .."_NUM_STR")
		if (strTitle) then
			strTitle:setText(v.descName)
			strValue:setText(v.descString)
		end
	end
	_layMain.BTN_STRENGTHEN:addTouchEventListener(ShipInfoCtrl.btnEventGoStrength)
	_layMain.BTN_STRENGTHEN:setTouchEnabled(ShipInfoModel.getIsActivited())
	_layMain.BTN_STRENGTHEN:setEnabled(ShipInfoModel.getIsActivited())
	-- 激活属性，如果没有这个配置，则删除掉这一cell
	local activatedAttri = ShipInfoModel.getActivatedAttribute()
	if (activatedAttri) then
		for k,v in ipairs(activatedAttri) do
			local strTitle = _fnGetWidgetByName(_layMain, "TFD_ATTR" .. tostring(k) .."_ACTIVATE")
			local strValue = _fnGetWidgetByName(_layMain, "TFD_ATTR" .. tostring(k) .."_NUM_ACTIVATE")
			if (strTitle) then
				strTitle:setText(v.descName)
				strValue:setText(v.descString)
			end
			if (not ShipInfoModel.getIsActivited()) then
				strTitle:setColor(ccc3(0x67, 0x67, 0x67))
				strValue:setColor(ccc3(0x67, 0x67, 0x67))
			end
		end
		_layMain.IMG_ALREADY_ACTIVATE:setVisible(ShipInfoModel.getIsActivited())
		_layMain.IMG_NOT_ACTIVATE:setVisible(not ShipInfoModel.getIsActivited())
	else
		_layMain.LSV_MAIN:removeItem(_layMain.LSV_MAIN:getIndex(_layMain.LAY_ACTIVATE_INFO))
	end
	-- 激活天赋
	local talent = ShipInfoModel.getStrengthenTalent()
	local layGiftCopyRef = _layMain.LAY_GIFT_COPY
	local initGiftCopyPosX = layGiftCopyRef:getPositionX()
	local initGiftCopyPosY = layGiftCopyRef:getPositionY()
	local giftCopySize = layGiftCopyRef:getContentSize()
	initGiftCopyPosY = initGiftCopyPosY + CELL_DIST_H
	local layGiftCopyClone = layGiftCopyRef:clone()
	_layMain.LAY_GIFT_COPY:removeFromParentAndCleanup(true)
	local shipDesc = ShipInfoModel.getShipIntroduce()
	_layMain.TFD_DESC:setText(shipDesc)
	

	-- 每条文字的高度
	local textHeight = _layMain.LAY_GIFT_COPY:getSize().height
	logger:debug({print_textHeight = textHeight})
	-- 所有文字的总高度
	local talentTextHeight = (textHeight + CELL_PACING_H) * table.count(talent) - CELL_PACING_H
	logger:debug({print_talentTextHeight = talentTextHeight,
		tablecount = table.count(talent)})
	-- 文字上方留边的总高度
	local leaveHeightUp = TEXT_UP_LEAVE
	logger:debug({print_leaveHeightUp = leaveHeightUp})
	-- 文字下方留边总高度
	local leaveHeightDown = TEXT_DOWN_LEAVE
	logger:debug({print_leaveHeightDown = leaveHeightDown})
	-- 文字加上留边需要的总高度
	local needHeight = leaveHeightUp + leaveHeightDown + talentTextHeight
	logger:debug({print_needHeight = needHeight})

	_layMain.LAY_STR_GIFT_INFO:setSize(CCSizeMake(_layMain.LAY_STR_GIFT_INFO:getSize().width,needHeight))
	_layMain.IMG_STRGIFT_PAPER_BG:setSize(CCSizeMake(_layMain.IMG_STRGIFT_PAPER_BG:getSize().width,needHeight))

	local posFirstTextY = needHeight/2-leaveHeightUp-textHeight

	-- 循环所有天赋，复制UI的TFD
	for k,v in ipairs(talent) do
		local layGiftCopy = layGiftCopyClone:clone()
		layGiftCopy.TFD_GIFT_NAME1:setText("["..v.title.."]")
		layGiftCopy.TFD_GIFT_INFO1:setText(v.desc)
		layGiftCopy.TFD_GIFT_CONDITION1:setText( string.format(_i18n[7505], tostring(v.awakeLv)) )
		if (v.isAwake) then
			layGiftCopy.TFD_GIFT_NAME1:setColor(ccc3(0x0a,0x8a,0x00))
			layGiftCopy.TFD_GIFT_INFO1:setColor(ccc3(0x0a,0x8a,0x00))
			layGiftCopy.TFD_GIFT_CONDITION1:setVisible(false)
		end
		local posY = posFirstTextY - (tonumber(k)-1)*(textHeight+CELL_PACING_H)
		layGiftCopy:runAction(CCPlace:create(ccp(initGiftCopyPosX,posY)))
		_layMain.IMG_STRGIFT_PAPER_BG:addChild(layGiftCopy)
	end

	-- 船炮信息
	local cannonInfo,cannonBallDB,cannonLel =	ShipInfoModel.getShipCannon()
	logger:debug({cannonInfo = cannonInfo})
	_layMain.LAY_SKILL_INFO.tfd_skill_attr:setText(_i18n[7516])
	_layMain.LAY_SKILL_INFO.TFD_SKILL_NAME:setText(cannonBallDB.skill_name)
	_layMain.LAY_SKILL_INFO.TFD_SKILL_NAME:setColor(g_QulityColor[cannonBallDB.quality])
	_layMain.LAY_SKILL_INFO.TFD_SKILL_DESC:setText(cannonInfo.des)

	local layIcon = _layMain.LAY_SKILL_INFO.LAY_SKILL_ICON --图标
	local btnlay = ArmShipData.createCannonAndBallBtnByTid(cannonBallDB.id,btnLayShow,1)
	layIcon:removeAllChildren()
	local laySkillIconSize = layIcon:getContentSize()
	btnlay:setPosition(ccp(laySkillIconSize.width * 0.5,laySkillIconSize.height * 0.5))
	layIcon:addChild(btnlay)

	local attr = cannonInfo.attr
	_layMain.LAY_SKILL_INFO.TFD_SKILL_ATTR1_NAME:setText(attr[1].name)
	_layMain.LAY_SKILL_INFO.TFD_SKILL_ATTR1_NUM:setText(attr[1].beforValue)

	local periodAttr = cannonInfo.periodAttr
	if (periodAttr ) then
		local beforAttr = periodAttr.beforAttr
		if (beforAttr) then
			local attrSkillStr =  beforAttr.attrText
			_layMain.LAY_SKILL_INFO.TFD_SKILL_ATTR2_NAME:setEnabled(true)
			_layMain.LAY_SKILL_INFO.TFD_SKILL_ATTR2_NAME:setText(attrSkillStr)
		else
			_layMain.LAY_SKILL_INFO.TFD_SKILL_ATTR2_NAME:setEnabled(false)
		end
	else
		_layMain.LAY_SKILL_INFO.TFD_SKILL_ATTR2_NAME:setEnabled(false)
	end
end

----------------------------------------------------------
function ShipInfoView:ctor()
	self.layMain = g_fnLoadUI("ui/ship_info.json")
	
end

function ShipInfoView:destroy(...)
	package.loaded["ShipInfoView"] = nil
end

function ShipInfoView:moduleName()
    return "ShipInfoView"
end

function ShipInfoView:create( noReturnBtnFlag )
	_layMain = self.layMain

	-- 背景运动的计时器
	local fnRemoveSchedule

	UIHelper.registExitAndEnterCall(_layMain,
		function()
			fnRemoveSchedule()
			_layMain=nil
		end,
		function()
			if (not fnRemoveSchedule) then
				fnRemoveSchedule = GlobalScheduler.scheduleFunc( ShipMainCtrl.getBgUpdateFun( _layMain ), 0 )
			end
		end
	)

	self:i18nAndEffect()
	self:refreshView()
	_layMain.LAY_NOSCV.BTN_CLOSE:addTouchEventListener(ShipInfoCtrl.btnEventBack) -- 返回按钮
	_layMain.LAY_BTNS.BTN_CLOSE:addTouchEventListener(ShipInfoCtrl.btnEventClose) -- 确定按钮

	-- 为伙伴信息界面生成无返回按钮的view
	_layMain.LAY_NOSCV.BTN_CLOSE:setVisible(not noReturnBtnFlag)
	_layMain.LAY_NOSCV.BTN_CLOSE:setEnabled(not noReturnBtnFlag)
	_layMain.LAY_BTNS.BTN_CLOSE:setEnabled(not noReturnBtnFlag)
	_layMain.LAY_BTNS:setVisible(not noReturnBtnFlag)
	_layMain.BTN_STRENGTHEN:setEnabled(not noReturnBtnFlag)
	_layMain.BTN_STRENGTHEN:setVisible(not noReturnBtnFlag)

	_layMain.LSV_MAIN:addTouchEventListener(function ( sender, eventType )
		GlobalNotify.postNotify("MSG_SHIP_LSV_TOUCH", eventType)
	end)

	return _layMain
end
