-- FileName: CannonStrenView.lua
-- Author: sunyunpeng
-- Date: 2016-02-04
-- Purpose: function description of module
--[[TODO List]]

module("CannonStrenView", package.seeall)

-- UI控件引用变量 --
local _UIMain = nil

-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString = gi18nString

local _cannonTid 
local _cannonItemId 

local _cannonDB 
local _cannonCacheInfo

local _layitemNumRefPosX
local _layitemNumRefPosY

local _imgArrowPosX
local _imgArrowPosY

local _perAttrlayPosX 
local _perAttrlayPosY 

local _btnCannTouch = true

local function init(...)

end

function destroy(...)
	package.loaded["CannonStrenView"] = nil
end

function moduleName()
    return "CannonStrenView"
end

-- UIlable自适应高度
-- return tfdBeforeSizeWidth 之前的宽度 tfdBeforeSizeHeight 高度 affterSizeHeight变化后的高度
function labelScaleChangedWithStr( UIlableWidet,textInfo )
    local tfdBeforeSize = UIlableWidet:getContentSize()
    local tfdBeforeSizeHeight = tfdBeforeSize.height  -- 必须把高度值单独取出来放进变量里 否则值会变
    local tfdBeforeSizeWidth = tfdBeforeSize.width  -- 必须把高度值单独取出来放进变量里 否则值会变

    -- UIlableWidet:ignoreContentAdaptWithSize(false)
    UIlableWidet:setSize(CCSizeMake(tfdBeforeSize.width,0))
    UIlableWidet:setText(textInfo)
    local tfdAffterSize =  UIlableWidet:getVirtualRenderer():getContentSize()
    local lineHeightScale = math.ceil(tfdAffterSize.height/tfdBeforeSizeHeight)
    local affterSizeHeight = lineHeightScale * tfdBeforeSizeHeight
    UIlableWidet:setSize(CCSizeMake(tfdBeforeSizeWidth,affterSizeHeight))
    return tfdBeforeSizeWidth,tfdBeforeSizeHeight,affterSizeHeight

end

function setBtnCanTouch( canTouch )
	_btnCannTouch = canTouch
	logger:debug({_btnCannTouch = _btnCannTouch})
end

local function initBG( ... )
	_UIMain = g_fnLoadUI("ui/ship_skill_lvup.json")
	local btnClose = _UIMain.BTN_CLOSE 
	btnClose:addTouchEventListener(function ( sender,eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCloseEffect()
			CannonStrenCtrl.onColse()
		end
	end)

	-- 注册兑换监听事件
	UIHelper.registExitAndEnterCall(_UIMain, function (  )
		CannonStrenCtrl.removeAllObserver()
	end, function (  )
		CannonStrenCtrl.addAllObserver()
	end)
end 



-- 初始化炮的信息
-- 延迟刷新跑的等级信息
local function initCannonInfo( delayShow )
	_cannonCacheInfo = CannonStrenCtrl.getDataByTag(2)

	-- 炮的图标
	local layCannonIcon = _UIMain.LAY_CANNON_ICON
	local imgCannonBg = layCannonIcon.img_cannon_bg
	local imgCannonFrame = layCannonIcon.img_cannon_frame
	local imgCannon = layCannonIcon.img_cannon

	local function btnLayShow( sender ,eventType )

	end
	-- local btnlay = ArmShipData.createCannonAndBallBtnByTid(_cannonTid,btnLayShow,2)
	-- layCannonIcon:removeAllChildren()
	-- local layCannonIconSize = layCannonIcon:getContentSize()
	-- btnlay:setPosition(ccp(layCannonIconSize.width * 0.5,layCannonIconSize.height * 0.5))
	-- layCannonIcon:addChild(btnlay)

	-- 炮的名字TFD_CANNON_NAME
	local tfdCannonName = layCannonIcon.TFD_CANNON_NAME
	tfdCannonName:setText(_cannonDB.name)
	-- 炮的属性
	local imgCannonInfoBg = _UIMain.img_cannon_info_bg
	local tfdCannonLv = imgCannonInfoBg.TFD_CANNON_LV                -- 等级
	tfdCannonLv:setText(m_i18n[1067])
	local tfdCannonLvNum =  imgCannonInfoBg.TFD_CANNON_LV_NUM        -- 等级数字
	if (not delayShow) then
		tfdCannonLvNum:setText(_cannonCacheInfo[1])
	end

	local tfdCannonEffct = imgCannonInfoBg.TFD_CANNON_EFFECT         -- 效果
	tfdCannonEffct:setText(m_i18n[7510])  -- todo
	local tfdCannonEffctDes = imgCannonInfoBg.TFD_CANNON_EFFECT_DESC -- 效果描述
	-- tfdCannonEffctDes:setText()  -- todo

	

end

-- 初始化炮弹信息
-- delayShow 延迟显示炮弹的属性信息
local function initCannonBallInfo( delayShow )
	local layShell = _UIMain.LAY_SHELL
	local cannonBallAttr= CannonStrenCtrl.getDataByTag(3)
	local cannonBallDB= CannonStrenCtrl.getDataByTag(5)

	if (not cannonBallAttr or not cannonBallDB) then
		layShell:setEnabled(false)	
		return
	end

	--炮弹图标
	local laySkillIcon = _UIMain.LAY_SKILL_ICON
	local function btnLayShow( sender ,eventType )

	end
	local btnlay = ArmShipData.createCannonAndBallBtnByTid(cannonBallDB.id,btnLayShow,1)
	laySkillIcon:removeAllChildren()
	local laySkillIconSize = laySkillIcon:getContentSize()
	btnlay:setPosition(ccp(laySkillIconSize.width * 0.5,laySkillIconSize.height * 0.5))
	laySkillIcon:addChild(btnlay)

	local tfdName = _UIMain.TFD_NAME
	tfdName:setText(cannonBallDB.skill_name)
	tfdName:setColor(g_QulityColor[cannonBallDB.quality])
	
	-- 炮弹描述
	local imgInfoBg = _UIMain.img_info_bg
	local tfdSkillDesc = imgInfoBg.TFD_SKILL_DESC  -- 描述
	tfdSkillDesc:setText(cannonBallAttr.des)
	-- 属性
	local  attr = cannonBallAttr.attr

	logger:debug({initCannonBallInfo = attr})

	-- for i,v in ipairs(attr) do
		local tempattr = attr[1]

		if (not delayShow) then
			local perAttrlayRef = MReleaseUtil.getRetainNOReleaseObj(moduleName(),"layClone","perAttrlay")
			local perAttrlay = perAttrlayRef:clone()
			perAttrlay:setPosition(ccp(_perAttrlayPosX,_perAttrlayPosY))
			perAttrlay:setTag(3333)
			imgInfoBg:removeChildByTag(3333,true)
			imgInfoBg:addChild(perAttrlay)
			-- local perAttrlay = layShell["LAY_ATTR" .. i]
			local tfdSkillDesc = perAttrlay.TFD_ATTR_NAME  -- 名称
			tfdSkillDesc:setText(tempattr.name)
			local tfdAttrNum1 = perAttrlay.TFD_ATTR_NUM1  -- 强化前
			local tfdAttrNum2 = perAttrlay.TFD_ATTR_NUM2  -- 强化后

			tfdAttrNum1:setText(tempattr.beforValue)
			tfdAttrNum2:setText(tempattr.affterValue)

			local actionArray = CCArray:create()
	    	actionArray:addObject(CCMoveBy:create(0.4, ccp(5,0)))
	    	actionArray:addObject(CCMoveBy:create(0.4, ccp(-5,0)))

	    	perAttrlay.IMG_ARROW:runAction(CCRepeatForever:create(CCSequence:create(actionArray)))
		end


	-- end

	local cannnonLVNum = tonumber(_cannonCacheInfo[1])
	-- 当前
	local layNow = layShell.LAY_NOW
	local layNowSize = layNow:getContentSize()
	local layNowSizeHeight = layNowSize.height
	local tfdNow = layNow.TFD_NOW -- 当前效果
	tfdNow:setText(m_i18n[7507]) --todo
	local tfdNowAttr = layNow.TFD_NOW_ATTR

	local nowAttr = ""
	local periodAttr = cannonBallAttr.periodAttr 

	local beforAttr = periodAttr.beforAttr
	local beforeAddH = 0
	if (beforAttr) then
		layNow:setEnabled(true)
		nowAttr =  beforAttr.attrText
		-- tfdNowAttr:setText(tfdNowAttr)
		local  tfdBeforeSizeWidth,tfdBeforeSizeHeight,affterSizeHeight = labelScaleChangedWithStr(tfdNowAttr,nowAttr)
		beforeAddH = beforeAddH + affterSizeHeight - tfdBeforeSizeHeight

	else 
		layNow:setEnabled(false)
	end

	layNow:setSize(CCSizeMake(layNowSize.width,layNowSizeHeight + beforeAddH))

	-- 下一个
	local layNext = layShell.LAY_NEXT
	local tfdNext = layNext.TFD_NOW -- 下一级效果
	local tfdNextAttr = layNext.TFD_NOW_ATTR

	local nextAttr = ""
	local affterAddH = 0
	local aftterAttr = periodAttr.aftterAttr
	if (aftterAttr) then
		layNext:setEnabled(true)
		nextAttr =  aftterAttr.attrText
		local nextClassLel = (math.floor(cannnonLVNum / 5) + 1) * 5
		tfdNextAttr:setText(nextAttr)
		tfdNext:setText(m_i18nString(7508,nextClassLel))
		local  tfdBeforeSizeWidth,tfdBeforeSizeHeight,affterSizeHeight = labelScaleChangedWithStr(tfdNextAttr,nextAttr)
		affterAddH = affterAddH + affterSizeHeight - tfdBeforeSizeHeight
	else
		layNext:setEnabled(false)
	end


end

-- 消耗材料
local function refrshConsumInfo( ... )
	local costInfo = CannonStrenCtrl.getDataByTag(4)
	local imgConsumeBg = _UIMain.img_consume_bg

	-- 强化按钮
	local tfdLvUp = _UIMain.TFD_LVUP
	tfdLvUp:setText(m_i18n[7519])
	UIHelper.labelShadow(tfdLvUp, CCSizeMake(2,-2))

	tfdBeili = _UIMain.TFD_BELLY_NUM
	tfdBeili:setText(costInfo.costBeili)

	local btnLvUp = _UIMain.BTN_LVUP
	btnLvUp:addTouchEventListener(function ( sender,eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug({_btnCannTouch = _btnCannTouch})

			if (not _btnCannTouch) then
				return
			end
    		AudioHelper.playCommonEffect()
			CannonStrenCtrl.onBtnStren()
		end
	end)

	if (not costInfo.costNormal) then
		imgConsumeBg:setEnabled(false)
		return 
	end

	local tfdConsum = _UIMain.TFD_CONSUME
	tfdConsum:setText(m_i18n[7511])
	for i=1,2 do
		local layItem = imgConsumeBg["LAY_ITEM" .. i]
		layItem:setEnabled(false)
	end

	for i=1,2 do
		local costNormal = costInfo.costNormal[i]
		if (not costNormal or tonumber(costNormal.needNum) == 0) then
			break
		end

		local layItem = imgConsumeBg["LAY_ITEM" .. i]
		layItem:setEnabled(true)

		local tfdName = layItem.TFD_ITEM_NAME
		local costNormalTid = costNormal.tid
		local costnormalDB = DB_Item_normal.getDataById(costNormalTid)
		tfdName:setText(costnormalDB.name)

		local layitemNumRef = MReleaseUtil.getRetainNOReleaseObj(moduleName(),"layClone","layitemNum")

		local layitemNum = layitemNumRef:clone()
		layitemNum:setPosition(ccp(_layitemNumRefPosX,_layitemNumRefPosY))
		layitemNum:setTag(111)
		layItem:removeChildByTag(111,true)
		layItem:addChild(layitemNum)

		local tfdOwnNum = layitemNum.TFD_NUM_OWN
		local tfdNeedNum = layitemNum.TFD_NUM_NEED
		tfdOwnNum:setText(costNormal.haveNum)
		tfdNeedNum:setText(costNormal.needNum)

		if (tonumber(costNormal.needNum) > tonumber(costNormal.haveNum)) then
			tfdOwnNum:setColor(ccc3(0xd8, 0x14, 0x00))
		else
			tfdOwnNum:setColor(ccc3(0x00, 0x89, 0x00))
		end


		local layCosume = layItem.LAY_CONSUME_ITEM
		local itemTid = costNormal.tid
		local itemInfo = ItemUtil.getItemById(itemTid)

		local function btnLayShow( sender ,eventType )
			if eventType == TOUCH_EVENT_ENDED then
				if (not _btnCannTouch) then
					return
				end
				-- AudioHelper.playCommonEffect()
				local dropcallfn = function ( ... )
					logger:debug(" CannonStrenCtrl refrshConsumInfo")
					CannonStrenCtrl.initCannonData()
					refrshConsumInfo()
				end
				PublicInfoCtrl.createItemDropInfoViewByTid(costNormalTid,dropcallfn,nil)  -- cailiao掉落引导界面
			end
		end

		local btnlay = ItemUtil.createBtnByItem(itemInfo,btnLayShow)
		layCosume:removeAllChildren()
		local layCosumeSize = layCosume:getContentSize()
		btnlay:setPosition(ccp(layCosumeSize.width * 0.5,layCosumeSize.height * 0.5))
		layCosume:addChild(btnlay)

	end

end

-- 重置强化界面
function resetView( ... )
	initCannonInfo(true)
	initCannonBallInfo(true)
	refrshConsumInfo()
end


-- 缓存拥有和没有的数量信息
function retainNumLay( ... )
	logger:debug("retainNumLay")
	local layShell = _UIMain.LAY_SHELL
	local perAttrlayRef = layShell.LAY_ATTR1
	_perAttrlayPosX = perAttrlayRef:getPositionX()
	_perAttrlayPosY = perAttrlayRef:getPositionY()
	MReleaseUtil.insertRetainNOReleaseObj(moduleName(),"layClone",perAttrlayRef,"perAttrlay")
	perAttrlayRef:removeFromParentAndCleanup(true)

	for i=1,2 do
		local imgConsumBG = _UIMain.img_consume_bg
		local layItem = imgConsumBG["LAY_ITEM" .. i]
		local layitemNumRef = layItem.LAY_CONSUME_ITEM_NUM
		if (i == 1) then
			_layitemNumRefPosX = layitemNumRef:getPositionX()
			_layitemNumRefPosY = layitemNumRef:getPositionY()
			MReleaseUtil.insertRetainNOReleaseObj(moduleName(),"layClone",layitemNumRef,"layitemNum")
		end
		layitemNumRef:removeFromParentAndCleanup(true)
	end

end

function StrenOkAnimateFrameCallBack( bone,frameEventName,originFrameIndex,currentFrameIndex  )
	local imgInfoBg = _UIMain.img_info_bg

	local layShell = _UIMain.LAY_SHELL
	local laySkillIcon = _UIMain.LAY_SKILL_ICON
	local imgCannonInfoBg = _UIMain.img_cannon_info_bg
	local tfdCannonLvNum =  imgCannonInfoBg.TFD_CANNON_LV_NUM        -- 等级数字

    if(frameEventName == "1") then


	    local particleEffect = g_attribManager:createJinJieShuZi2({
				fnMovementCall = function ( sender, MovementEventType, frameEventName )
					if (MovementEventType == 1) then
						sender:removeFromParentAndCleanup(true)
					end
				end,
			})
		local pSize = tfdCannonLvNum:getSize()
    	local pPos = ccp(pSize.width*0.5,pSize.height*0.5)
		particleEffect:setAnchorPoint(ccp(0.5, 0.5))
    	particleEffect:setPosition(pPos)
		tfdCannonLvNum:addNode(particleEffect)
		-- 显示炮的等级
		tfdCannonLvNum:setText(_cannonCacheInfo[1])

    elseif (frameEventName == "2") then
    	local aniEquip = UIHelper.createArmatureNode({
			filePath = "images/effect/juexing/awakeEquip/awake_equip.ExportJson",
			animationName = "awake_equip",
			fnMovementCall = function ( sender, MovementEventType , frameEventName)
			end
		})
		local pSize = laySkillIcon:getSize()
    	local pPos = ccp(pSize.width*0.5,pSize.height*0.5)
		aniEquip:setAnchorPoint(ccp(0.5, 0.5))
    	aniEquip:setPosition(pPos)
		laySkillIcon:addNode(aniEquip)

    elseif (frameEventName == "3") then
    	-- for i=1,2 do

		-- end
		-- 显示炮单的属性
		local cannonBallAttr= CannonStrenCtrl.getDataByTag(3)
		local  attr = cannonBallAttr.attr
		if (not attr) then
			setBtnCanTouch(true)
			return
		end

		local tempattr = attr[1]
		local perAttrlayRef = MReleaseUtil.getRetainNOReleaseObj(moduleName(),"layClone","perAttrlay")
		local perAttrlay = perAttrlayRef:clone()
		perAttrlay:setPosition(ccp(_perAttrlayPosX,_perAttrlayPosY))
		perAttrlay:setTag(3333)
		imgInfoBg:removeChildByTag(3333,true)
		imgInfoBg:addChild(perAttrlay)
		local tfdSkillDesc = perAttrlay.TFD_ATTR_NAME  -- 名称
		tfdSkillDesc:setText(tempattr.name)
		local tfdAttrNum1 = perAttrlay.TFD_ATTR_NUM1  -- 强化前
		local tfdAttrNum2 = perAttrlay.TFD_ATTR_NUM2  -- 强化后

		tfdAttrNum1:setText(tempattr.beforValue)
		tfdAttrNum2:setText(tempattr.affterValue)

		local actionArray = CCArray:create()
    	actionArray:addObject(CCMoveBy:create(0.4, ccp(5,0)))
    	actionArray:addObject(CCMoveBy:create(0.4, ccp(-5,0)))

    	perAttrlay.IMG_ARROW:runAction(CCRepeatForever:create(CCSequence:create(actionArray)))

    	--特效
    	local layItem = imgInfoBg:getChildByTag(3333)
		if (not layItem) then
			return
		end
	    local particleEffect = g_attribManager:createJinJieShuZi2({
				fnMovementCall = function ( sender, MovementEventType, frameEventName )
					if (MovementEventType == 1) then
						sender:removeFromParentAndCleanup(true)
						setBtnCanTouch(true)
					end
				end,
			})
	    local pSize = layItem:getSize()
		local pPos = ccp(pSize.width*0.5,pSize.height)
		particleEffect:setPosition(pPos)
		particleEffect:setAnchorPoint(ccp(0.5, 0.5))
		layItem:addNode(particleEffect)

    end
end


function creatStrenOkAnimate( ... )
	--  升级音效
    AudioHelper.playEffect("audio/effect/zhuchuan_skill_lvup.mp3")
    local m_arAni1 = UIHelper.createArmatureNode({
        filePath = "images/effect/skill_lvup/skill_lvup.ExportJson",
        animationName = "skill_lvup",
        loop = 0,
        bRetain =  true,
        fnFrameCall = StrenOkAnimateFrameCallBack,
        fnMovementCall = function ( sender, MovementEventType, movementID )
            if(MovementEventType == 1) then
                sender:removeFromParentAndCleanup(true)
                -- 动画播放完毕
            end
        end,
    })
    m_arAni1:setAnchorPoint(ccp(0.5,0.5))
	local layCannonIcon = _UIMain.LAY_CANNON_ICON

    local pSize = layCannonIcon:getSize()
    local pPos = ccp(pSize.width*0.5,pSize.height*0.5)
    m_arAni1:setPosition(pPos)
    m_arAni1:setTag(2222)
    layCannonIcon:removeNodeByTag(2222)
    m_arAni1:setZOrder(100)
    layCannonIcon:addNode(m_arAni1)
end


function create(cannonTid)
	_btnCannTouch = true
	_cannonTid = cannonTid or 10001
	_cannonDB = CannonStrenCtrl.getDataByTag(1)

	initBG()
	retainNumLay()
	initCannonInfo()
	initCannonBallInfo()
	refrshConsumInfo()
	return _UIMain
end
