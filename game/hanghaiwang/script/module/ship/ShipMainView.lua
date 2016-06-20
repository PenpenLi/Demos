-- FileName: ShipMainView.lua
-- Author: LvNanchun
-- Date: 2015-10-16
-- Purpose: 主船主界面UI
--[[TODO List]]

ShipMainView = class("ShipMainView")
require "script/module/ship/ShipMainModel"

-- UI variable --
local _layMain
local _preBtn  -- 当前listView中正在选择的cell的控件
-- 以下tabel用于利用循环初始化界面
local _tbTFDNumPlus
local _tbTFDNum
local _tbTFDName


-- module local variable --
local _qualityColor =  g_QulityColor
local _qualityColor2 =  g_QulityColor2
local _nowShipInfo
local _nowMainShip
local _SHIP_ANI_TAG = 512
local _WATER_ANI_TAG = 513
local _ICON_BTN_TAG = 999
local _i18n = gi18n
local RED_TIP_TAG = 998

function ShipMainView:moduleName()
    return "ShipMainView"
end

function ShipMainView:ctor(...)
	_layMain = g_fnLoadUI("ui/ship_main.json")
	-- 初始化listView
	UIHelper.initListView(_layMain.LSV_MAIN)
	-- 初始化装着控件的几个table
	_tbTFDNumPlus = {_layMain.TFD_BLOOD_NUM_PLUS,
					_layMain.TFD_WUGONG_NUM_PLUS,
					_layMain.TFD_MOGONG_NUM_PLUS,
					_layMain.TFD_WUFANG_NUM_PLUS,
					_layMain.TFD_MOFANG_NUM_PLUS
				}
	_tbTFDNum = {_layMain.TFD_BLOOD_NUM,
				_layMain.TFD_WUGONG_NUM,
				_layMain.TFD_MOGONG_NUM,
				_layMain.TFD_WUFANG_NUM,
				_layMain.TFD_MOFANG_NUM
				}
	_tbTFDName = {_layMain.TFD_BLOOD_NAME,
				_layMain.TFD_WUGONG_NAME,
				_layMain.TFD_MOGONG_NAME,
				_layMain.TFD_WUFANG_NAME,
				_layMain.TFD_MOFANG_NAME
				}		
end

--[[desc:刷新listView
    arg1: listView显示的信息，当前显示的船的id
    return: 无
—]]
function ShipMainView:reloadListView( tbShipInfo, shipId )
	local listView = _layMain.LSV_MAIN
	listView:setBounceEnabled(true)
	listView:removeAllItems()
	_nowShipInfo = tbShipInfo

	-- 利用信息构建listView
	for i = 1, tbShipInfo.shipNum do
		local oneCellInfo = tbShipInfo[i]
		logger:debug({oneCellInfo = oneCellInfo})
		listView:pushBackDefaultItem()
		local cell = listView:getItem(i-1)
		cell.IMG_LIGHT:setVisible(false)
		cell.IMG_EQUIPPED:setVisible(false)
		cell.LAY_NOT_ACTIVATE:setVisible(false)
		UIHelper.labelNewStroke(cell.TFD_SHIP_NAME, ccc3(0x28, 0x00, 0x00), 2)
		cell.TFD_SHIP_NAME:setText(oneCellInfo.name)
		cell.TFD_SHIP_NAME:setColor(_qualityColor2[tonumber(oneCellInfo.quality)])
		if (oneCellInfo.state == 1) then
			if not (shipId) then
				_nowMainShip = oneCellInfo.id
				_preBtn = cell.BTN_SHIP
				cell.IMG_LIGHT:setVisible(true)
			end
			cell.IMG_EQUIPPED:setVisible(true)

			performWithDelayFrame(cell, function (  )
				require "script/module/guide/GuideCtrl"
				require "script/module/guide/GuideShipMainView"
				if GuideShipMainView.guideStep == 3 and GuideModel.getGuideClass() == ksGuideMainShip then
					listView:setTouchEnabled(false)
					GuideCtrl.createShipMainGuide(4,nil,nil, function (  )
						GuideCtrl.createShipMainGuide(5)
					end)
				end
			end,2)

		elseif (oneCellInfo.state == 2) then
					
		elseif (oneCellInfo.state == 3) then
			-- 若未激活可激活添加红点
			if (ShipData.bCanActivateByShipId(oneCellInfo.id)) then
				local redTip = UIHelper.createRedTipAnimination()
				cell.IMG_ICON_TIP:addNode(redTip)
			end
			cell:setGray(true)
			cell.LAY_NOT_ACTIVATE:setVisible(true)
			UIHelper.labelAddNewStroke(cell.TFD_NOT_ACTIVATE, _i18n[7501], ccc3(0x28, 0x00, 0x00), 2)
		end

		if (shipId and shipId == oneCellInfo.id) then
			_nowMainShip = shipId
			_preBtn = cell.BTN_SHIP
			cell.IMG_LIGHT:setVisible(true)
			-- 当跳到特定ship时listView跳转
			UIHelper.autoSetListOffset(listView, cell)
		end

		-- 创建图标
		local iconImg, iconBg, iconBorder = ShipMainModel.getShipIconById(oneCellInfo.id)
		cell.img_ship:loadTexture(iconBg) -- 加载背景图片
		local imgItem = ImageView:create()
		imgItem:loadTexture(iconImg)
		cell.img_ship:addChild(imgItem) -- 加载物品图标, 附加到Button上
		local imgBorder = ImageView:create()
		imgBorder:loadTexture(iconBorder)
		cell.img_ship:addChild(imgBorder) 

		cell.BTN_SHIP:addTouchEventListener(function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCommonEffect()
				if (_nowMainShip ~= oneCellInfo.id) then
					-- 第一时间删除战斗力动画
					MainFormationTools.removeFlyText()
					-- 修改全局的当前船id
					_nowMainShip = oneCellInfo.id
					-- 刷新界面
					tbShipInfo.fnBtn(oneCellInfo.id)
					-- 调整背景光
					_preBtn.IMG_LIGHT:setVisible(false)
					sender.IMG_LIGHT:setVisible(true)
					_preBtn = sender
					-- 点击按钮listView自动跳转
					UIHelper.autoSetListOffset(listView, cell)
				end
			end
		end)
	end
end

--[[desc:刷新下方信息面板的函数
    arg1: viewIndex表示船的id
    return: 是否有返回值，返回值说明  
—]]
function ShipMainView:refreshInfoPanel( attrInfo )


	_layMain.LAY_ATTR.TFD_SHIP_NAME:setText(attrInfo.name)
	_layMain.LAY_ATTR.TFD_SHIP_NAME:setColor(_qualityColor[attrInfo.quality])
	-- 将后面附加的文字隐藏，方便之后或者加动画，或者重新显示
	for i = 1,5 do
		_tbTFDNumPlus[i]:setVisible(false)
	end
	-- 设置强化等级为0时，不显示重生按钮和强化等级+0这个文字
	if not (attrInfo.canReborn) then 
		_layMain.TFD_LV_NOW:setVisible(false)
		_layMain.BTN_REBORN:setVisible(false)
		_layMain.BTN_REBORN:setTouchEnabled(false)
	else
		_layMain.TFD_LV_NOW:setVisible(true)
		_layMain.BTN_REBORN:setVisible(true)
		_layMain.BTN_REBORN:setTouchEnabled(true)
		-- 若重生需要的金币为0，不显示金币的图标和数字
		if (attrInfo.rebornFree) then
			_layMain.TFD_GOLD_NUM:setVisible(false)
			_layMain.img_gold:setVisible(false)
		else
			_layMain.TFD_GOLD_NUM:setVisible(true)
			_layMain.img_gold:setVisible(true)
			UIHelper.labelAddNewStroke(_layMain.TFD_GOLD_NUM, tostring(attrInfo.rebornGoldNum), ccc3(0x28,0x00,0x00), 2)
		end
		_layMain.TFD_LV_NOW:setText("Lv." .. tostring(attrInfo.strengthLevel))
		_layMain.TFD_LV_NOW:setColor(_qualityColor[attrInfo.quality])
	end
	-- 若不是正在装备的船，属性跟当前主船有区别的时候需要现实附加的文字
	if not (attrInfo.isMainShip) then
		for i = 1,5 do
			if (attrInfo.subStr[i]) then
				_tbTFDNumPlus[i]:setText(tostring(attrInfo.subStr[i]))
				_tbTFDNumPlus[i]:setColor(attrInfo.subColor[i])
				_tbTFDNumPlus[i]:setVisible(true)
			end
		end
	end
	-- 设置属性的值，加动画
	
	if (attrInfo.needAni) then
		-- 加动画刷新
		require "script/module/formation/MainFormationTools"
		-- 构造动画用的数据
		local aniInfo = attrInfo.aniInfo
		local aniNode = _tbTFDNum
		MainFormationTools.setNumerialInfo(aniInfo.preAttr, aniInfo.nextAttr , aniNode)
		local function flyTextCallBack(  )
			MainFormationTools.fnShowFightForceChangeAni()
		end
		MainFormationTools.showAttrChangeInfo(flyTextCallBack)
	else
		-- 不加动画直接刷新
		for i=1,5 do
			_tbTFDNum[i]:setText(tostring(attrInfo.attr[i]))
			_tbTFDName[i]:setText(attrInfo.attrName[i])
		end
	end



end

--[[desc:刷新激活面板
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function ShipMainView:refreshActivatePanel( activateInfo )
	
	-- 判断是否可能是免费激活的情况
	if (activateInfo.isFree) then
		_layMain.LAY_ITEM_ICON:setVisible(false)
		_layMain.TFD_ITEM_NAME:setVisible(false)
		_layMain.lay_item_num:setVisible(false)
	else
		_layMain.LAY_ITEM_ICON:setVisible(true)
		_layMain.TFD_ITEM_NAME:setVisible(true)
		_layMain.lay_item_num:setVisible(true)
		-- 根据信息设置面板上的显示
		-- 将button的tag设置为999，方便删除
		_layMain.LAY_ITEM_ICON:addChild(activateInfo.btn, 1, _ICON_BTN_TAG)
		activateInfo.btn:setPosition(ccp(_layMain.LAY_ITEM_ICON:getContentSize().width/2, _layMain.LAY_ITEM_ICON:getContentSize().height/2))
		activateInfo.btn:setTouchEnabled(true)
		-- 图标的按钮回调
		activateInfo.btn:addTouchEventListener(activateInfo.fnIconBtn)
		_layMain.TFD_ITEM_NAME:setText(activateInfo.name)
		_layMain.TFD_ITEM_NAME:setColor(_qualityColor[tonumber(activateInfo.quality)])
		_layMain.TFD_NUM_LEFT:setText(tostring(activateInfo.haveNum))
		_layMain.TFD_NUM_RIGHT:setText(tostring(activateInfo.needNum))
	end

	-- 删除之前留下的红点
	local preRedTip = _layMain.BTN_ACTIVATE.IMG_ACTIVATE_TIP:getNodeByTag(RED_TIP_TAG)
	if (preRedTip) then
--		preRedTip:removeFromParentAndCleanup(true)
		_layMain.BTN_ACTIVATE.IMG_ACTIVATE_TIP:removeNode(preRedTip)
	end

	-- 若激活道具不存在，haveNum为1，needNum为0，确保激活成功
	if (activateInfo.isEnough) then
		_layMain.TFD_NUM_LEFT:setColor(ccc3(0x00, 0x8a, 0x00))
		_layMain.BTN_ACTIVATE:setGray(false)
		-- 激活道具充足则加红点
		local redTip = UIHelper.createRedTipAnimination()
		_layMain.BTN_ACTIVATE.IMG_ACTIVATE_TIP:addNode(redTip, 1, RED_TIP_TAG)
	else
		_layMain.TFD_NUM_LEFT:setColor(ccc3(0xd8, 0x14, 0x00))
		_layMain.BTN_ACTIVATE:setGray(true)
	end
	-- 激活按钮
	_layMain.BTN_ACTIVATE:addTouchEventListener(activateInfo.fnActivate)

	performWithDelayFrame(_layMain.BTN_ACTIVATE, function (  )
			require "script/module/guide/GuideCtrl"
			require "script/module/guide/GuideShipMainView"
			if GuideShipMainView.guideStep == 1 and GuideModel.getGuideClass() == ksGuideMainShip then
				GuideCtrl.createShipMainGuide(2,nil, _layMain.BTN_ACTIVATE:convertToWorldSpace(ccp(0,0)))
			end
		end,2)
end

--[[desc:刷新整个界面（不包含listView）
    arg1: 传1表示需要加动画
    return: 是否有返回值，返回值说明  
—]]
function ShipMainView:refreshView( tbFreshInfo, fnCallBack )
	-- 删除之前的特效
	local imgShip = _layMain.IMG_SHIP

	local preShipAni = imgShip:getNodeByTag(_SHIP_ANI_TAG)
	local preWaterAni = imgShip:getNodeByTag(_WATER_ANI_TAG)

	if (preShipAni) then
		imgShip:removeNodeByTag(_SHIP_ANI_TAG)
	end
	if (preWaterAni) then
		imgShip:removeNodeByTag(_WATER_ANI_TAG)
	end

	-- 界面上船和浪花的特效
	-- 设置tag为512方便之后删除
	UIHelper.addShipAnimation(imgShip, tonumber(tbFreshInfo.home_graph), ccp(0,0),ccp(0.5,0), nil, _SHIP_ANI_TAG, _WATER_ANI_TAG)

	-- 将激活面板中之前添加的icon删除，之后若仍为激活面板会重新添加，避免重复添加icon和icon出现在不应出现的面板中的情况
	local preIconBtn = _layMain.LAY_ITEM_ICON:getChildByTag(_ICON_BTN_TAG)
	if (preIconBtn) then
		preIconBtn:removeFromParentAndCleanup(true)
	end
	

	performWithDelayFrame(_layMain.BTN_EQUIP, function (  )
				require "script/module/guide/GuideCtrl"
				require "script/module/guide/GuideShipMainView"
				if GuideShipMainView.guideStep == 2 and GuideModel.getGuideClass() == ksGuideMainShip then
					GuideCtrl.createShipMainGuide(3,nil, _layMain.BTN_EQUIP:convertToWorldSpace(ccp(0,0)))
				end
			end,2)

	-- state为1表示正装备的，2表示激活了的，3表示未激活的
	_layMain.BTN_EQUIP:setVisible(tbFreshInfo.state == 2)				-- 装备按钮
	_layMain.BTN_EQUIP:setTouchEnabled(tbFreshInfo.state == 2)
	_layMain.BTN_REBORN:setVisible(tbFreshInfo.state == 2)			-- 重生按钮
	_layMain.BTN_REBORN:setTouchEnabled(tbFreshInfo.state == 2)
	_layMain.img_cost_bg:setVisible(tbFreshInfo.state == 3)			-- 激活面板
	_layMain.img_cost_bg:setTouchEnabled(tbFreshInfo.state == 3)
	_layMain.LAY_ATTR:setVisible(tbFreshInfo.state == 1 or tbFreshInfo.state == 2)				-- 属性面板
	_layMain.BTN_STRENTHEN:setVisible(tbFreshInfo.state == 1 or tbFreshInfo.state == 2)			-- 强化按钮
	-- 将强化按钮延迟两帧置为可点，配合新手引导
	_layMain.BTN_STRENTHEN:setTouchEnabled(false)
	performWithDelayFrame(_layMain.BTN_STRENTHEN, function ( ... )
		_layMain.BTN_STRENTHEN:setTouchEnabled(tbFreshInfo.state == 1 or tbFreshInfo.state == 2)
	end, 3)
	_layMain.BTN_ACTIVATE:setTouchEnabled(tbFreshInfo.state == 3)								-- 激活按钮

	if (tbFreshInfo.state == 1) then
		--装备中时将强化按钮挪到中间
		_layMain.BTN_STRENTHEN:setPositionPercent(ccp(0, -0.26))
	elseif (tbFreshInfo.state == 2) then
		_layMain.BTN_STRENTHEN:setPositionPercent(ccp(0.27, -0.26))
	elseif (tbFreshInfo.state == 3) then
		-- 船的动画设置成灰色
		local nowShipAni = _layMain.IMG_SHIP:getNodeByTag(_SHIP_ANI_TAG)
		nowShipAni:setColor(ccc3(0x77, 0x77, 0x77))
	end

	-- 装备后开启船炮系统
	if (tbFreshInfo.state ~= 3) then
		_layMain.IMG_BTN_SKILL_BG:setEnabled(true)
		local tfdSkillTip = _layMain.IMG_BTN_SKILL_BG.TFD_SKILL_TIP
		local tfdBeforeSize = tfdSkillTip:getContentSize()
		local tfdBeforeSizeHeight = tfdBeforeSize.height
    	tfdSkillTip:setSize(CCSizeMake(tfdBeforeSize.width,0))
		tfdSkillTip:setText(_i18n[7517])
		local tfdAffterSize =  tfdSkillTip:getVirtualRenderer():getContentSize()
    	local lineHeightScale = math.ceil(tfdAffterSize.height/tfdBeforeSizeHeight)
    	local affterSizeHeight = lineHeightScale * tfdBeforeSizeHeight
    	tfdSkillTip:setSize(CCSizeMake(tfdBeforeSize.width,affterSizeHeight))

		_layMain.IMG_SKILL_BG:setEnabled(false)

		local limitLel = DB_Switch.getDataById(ksSwitchCannonAndBall).level
		local btnSkill = _layMain.BTN_SKILL
		UIHelper.titleShadow(btnSkill,_i18n[7518])
		if (SwitchModel.getSwitchOpenState(ksSwitchMainShip,false) and  SwitchModel.getSwitchOpenState( ksSwitchCannonAndBall , false )) then
			btnSkill.BTN_SKILL:setBright(true)
			btnSkill.TFD_OPEN_NUM:setEnabled(false)
		else
			btnSkill.BTN_SKILL:setBright(false)
			btnSkill.TFD_OPEN_NUM:setEnabled(true)
			btnSkill.TFD_OPEN_NUM:setText(limitLel .. _i18n[5027])
		end
	else
		_layMain.IMG_BTN_SKILL_BG:setEnabled(false)
		_layMain.IMG_SKILL_BG:setEnabled(true)
		local shipDB = DB_Super_ship.getDataById(_nowMainShip)
		local cannonBallId = shipDB.shell_id
		local cannonBallDB = DB_Ship_skill.getDataById(cannonBallId)

		local laySkillIcon = _layMain.IMG_SKILL_BG.LAY_SKILL_ICON
		local btnlay = ArmShipData.createCannonAndBallBtnByTid(cannonBallId,btnLayShow,1)
		laySkillIcon:removeAllChildren()
		local laySkillIconSize = laySkillIcon:getContentSize()
		btnlay:setPosition(ccp(laySkillIconSize.width * 0.5,laySkillIconSize.height * 0.5))
		laySkillIcon:addChild(btnlay)

		_layMain.IMG_SKILL_BG.TFD_SKILL_NAME:setText(cannonBallDB.skill_name)
		UIHelper.labelNewStroke(_layMain.IMG_SKILL_BG.TFD_SKILL_NAME,ccc3(0x28,0x00,0x00))
		_layMain.IMG_SKILL_BG.TFD_SKILL_DESC:setText(cannonBallDB.base_desc)

	end

	fnCallBack()
end


function ShipMainView:create( shipId, tbEvent )
	_layMain.img_bg:setScale(g_fScaleX)
	_layMain.img_choose_bg:setScale(g_fScaleX)


	UIHelper.labelAddNewStroke( _layMain.tfd_attr_desc, _i18n[7502], ccc3(0x28, 0x00, 0x00), 2 )

	-- 给几个按钮增加阴影效果
	UIHelper.titleShadow(_layMain.BTN_BACK, _i18n[1019])
	UIHelper.titleShadow(_layMain.BTN_ACTIVATE, _i18n[5302])
	UIHelper.titleShadow(_layMain.BTN_EQUIP, _i18n[1601])
	UIHelper.titleShadow(_layMain.BTN_STRENTHEN, _i18n[1007])

	logger:debug({tbEvent = tbEvent})
	-- 将船的图片隐藏起来
	_layMain.IMG_SHIP:setTouchEnabled(true)
	-- 装备按钮
	_layMain.BTN_EQUIP:addTouchEventListener(tbEvent.equip)
	-- 信息按钮
	_layMain.IMG_SHIP:addTouchEventListener(tbEvent.info)
	-- 强化按钮
	_layMain.BTN_STRENTHEN:addTouchEventListener(tbEvent.strength)
	-- 返回按钮
	_layMain.BTN_BACK:addTouchEventListener(tbEvent.back)
	-- 重生按钮
	_layMain.BTN_REBORN:addTouchEventListener(tbEvent.reborn)
	-- 组装按钮
	_layMain.BTN_SKILL:addTouchEventListener(tbEvent.armShip)

	return _layMain
end

