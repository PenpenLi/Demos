-- FileName: ArmShipView.lua
-- Author: sunyunpeng
-- Date: 2016-02-04
-- Purpose: function description of module
--[[TODO List]]

module("ArmShipView", package.seeall)

-- UI控件引用变量 --
local _UIMain = nil 
local m_i18n = gi18n
local m_i18nString = gi18nString


-- 模块局部变量 --
local stopSchedule
local _lvMain
local _allCannonCacheInfo
local _allCannonId

-- 船的中间部分
local _shipPartRef
-- 所有船中间部分
local _allCannonImgBg = {}


local function init(...)

end

function destroy(...)
	package.loaded["ArmShipView"] = nil
end

function moduleName()
    return "ArmShipView"
end

-- 初始化背景
local function initBG( ... )
	_allCannonImgBg = {}

	_UIMain = g_fnLoadUI("ui/sihp_skill_main.json")

	local btnClose = _UIMain.BTN_CLOSE 
	btnClose:setTitleText(m_i18n[1019])
	UIHelper.titleShadow(btnClose, m_i18n[4202])
	btnClose:addTouchEventListener(function ( sender,eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playBackEffect()
			ArmShipCtrl.onReturn()
		end
	end)

	-- local layMain = _UIMain.LAY_MAIN
	-- layMain:setScaleX(g_fScaleX)
	local imgBG = _UIMain.IMG_BG
	imgBG:setScale(g_fScaleX)

	local imgSeaBG = _UIMain.IMG_SEA_BG
	imgSeaBG:setScale(g_fScaleX)

	local imgShipBG = _UIMain.IMG_SHIP_BG
	imgShipBG:setScale(g_fScaleX)

	local lsvMain = _UIMain.LSV_MAIN
	lsvMain:setScale(g_fScaleX)

	local btnSkillBag = _UIMain.BTN_SKILL_BAG
	UIHelper.titleShadow(btnSkillBag,m_i18n[7512])

	btnSkillBag:addTouchEventListener(function ( sender,eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			ArmShipCtrl.gotoCannonBallBag()
		end
	end)

	-- 注册兑换监听事件
	UIHelper.registExitAndEnterCall(_UIMain, function (  )
        LayerManager.resetPaomadeng()
		--去掉背包推送
        PreRequest.removeBagDataChangedDelete()
        -- 删除所有观察
        ArmShipCtrl.removeAllObserver()
        stopSchedule()
	end, function (  )
        -- 添加所有观察
        ArmShipCtrl.addAllObserver()
	end)
end 

-- 初始化LV列表
function initCannonInfoSV( ... )
	_lvMain = _UIMain.LSV_MAIN
	_lvMain:setBounceEnabled(false)
	local layMain = _UIMain.LAY_MAIN

	_UIMain.IMG_SHIP_BG:setPositionType(0)

	local shipHeadPosX = _UIMain.IMG_SHIP_BG:getPositionX()
	local shipHeadSize = _UIMain.IMG_SHIP_BG:getSize()
	local shipHeadConteSize = _UIMain.IMG_SHIP_BG:getContentSize()

	local img_left = _UIMain.img_left
	local img_right = _UIMain.img_right

	local blinkArray1 = CCArray:create()
    blinkArray1:addObject(CCFadeOut:create(0.8))
    blinkArray1:addObject(CCFadeIn:create(0.8))

    local blinkArray2 = CCArray:create()
    blinkArray2:addObject(CCFadeOut:create(0.8))
    blinkArray2:addObject(CCFadeIn:create(0.8))

	img_left:getVirtualRenderer():runAction(CCRepeatForever:create(CCSequence:create(blinkArray1)))
	img_right:getVirtualRenderer():runAction(CCRepeatForever:create(CCSequence:create(blinkArray2)))

	img_left:setEnabled(false)
	img_right:setEnabled(true)


	local shipBGInitPosX = _UIMain.IMG_SHIP_BG:getPositionX()
	_shipPartRef = _UIMain.IMG_SHIP_BG2
	_shipPartRef:setScale(g_fScaleX)

	_shipPartRef:retain()
	local shipPartRefSize = _shipPartRef:getSize()

	local shipPartRefPosX = shipHeadPosX + shipHeadSize.width  * g_fScaleX 
	local shipPartRefPosY = _shipPartRef:getPositionY()

	_shipPartRef:removeFromParentAndCleanup(true)

	local bugNum = _allCannonId and math.ceil((#_allCannonId)/3) or 0

	table.insert(_allCannonImgBg,{shipPart = _UIMain.IMG_SHIP_BG, shipPartPosX = _UIMain.IMG_SHIP_BG:getPositionX()})
	local shipPartPosX = shipPartRefPosX
	for i = 1,bugNum   do   -- 多加了一节 因为到最后 可能有缝
		local shipPart = _shipPartRef:clone()

		shipPart:setPositionX(shipPartPosX)
		layMain:addChild(shipPart)
		shipPart:setScale(g_fScaleX)

		shipPart:setVisible(false)
		local shipPartInfo = {}
		shipPartInfo.shipPart = shipPart
		shipPartInfo.shipPartPosX = shipPartPosX
		table.insert(_allCannonImgBg,shipPartInfo)
		shipPartPosX = shipPartPosX + shipPartRefSize.width * g_fScaleX 
	end

	logger:debug({shipPartPosX = shipPartPosX})
	logger:debug({g_fScaleX = g_fScaleX})


	-- 开启定时器
	if (stopSchedule) then
		stopSchedule()
		stopSchedule = nil
	end
    stopSchedule = GlobalScheduler.scheduleFunc(function ( ... )
        if (1) then
			for i,shipPartInfo in ipairs(_allCannonImgBg) do
				local shipPart = shipPartInfo.shipPart 
				shipPart:setPositionX(shipPartInfo.shipPartPosX + _lvMain:getHContentOffset() * g_fScaleX)
				
				local shipPartCurPosX = shipPart:getPositionX()
				if (shipPartCurPosX < shipPartRefPosX ) and (shipPartCurPosX > (shipHeadPosX - shipHeadSize.width * g_fScaleX) ) then
					shipPart:setVisible(true)
				else
					shipPart:setVisible(false)
				end

				local getContentXOffSet = _lvMain:getHContentOffset()
				local lsvInnerWidth = _lvMain:getInnerContainerSize().width   --innerSize的size宽度
				local lsvWidth = _lvMain:getSize().width   --innerSize的size宽度

				if (getContentXOffSet == 0) then
					img_left:setEnabled(false)
					if (#_allCannonId > 3 ) then
						img_right:setEnabled(true)
					end
				elseif (getContentXOffSet < 0 and getContentXOffSet > lsvWidth - lsvInnerWidth) then
					img_left:setEnabled(true)
					img_right:setEnabled(true)
				else
					img_left:setEnabled(true)
					img_right:setEnabled(false)
				end
			end
        else
            stopSchedule() -- 取消定时器
        end
    end,1/60)

	UIHelper.initListView(_lvMain)
	_lvMain:removeAllItems()
	local cannonIndex = 0
	for i,cannonId in ipairs(_allCannonId) do
		_lvMain:pushBackDefaultItem() 
    	cannonIndex = cannonIndex + 1
    	local cannonBg = _lvMain:getItem(cannonIndex -  1)  -- cell 索引从 0 开始
    	-- 炮弹信息
		local imgAdd = cannonBg.IMG_ADD
		local blinkArray = CCArray:create()
	    blinkArray:addObject(CCFadeOut:create(0.8))
	    blinkArray:addObject(CCFadeIn:create(0.8))
	    -- blinkArray:addObject(CCDelayTime:create(0.2))
		imgAdd:getVirtualRenderer():runAction(CCRepeatForever:create(CCSequence:create(blinkArray)))
    	setCannonAndBallByIndex(cannonIndex,cannonId)

	end
	local cannonNum = #_allCannonId
	-- 装饰的空炮
	local leftCannonNum = 3 - cannonNum % 3
	for i=1,leftCannonNum do
		_lvMain:pushBackDefaultItem() 
    	cannonIndex = cannonIndex + 1
    	local cannonBg = _lvMain:getItem(cannonIndex -  1)  -- cell 索引从 0 开始
    	cannonBg.LAY_SKILL_ICON:setEnabled(false)
    	cannonBg.TFD_CONNON_OPEN_LV:setEnabled(false)
    	cannonBg.TFD_SKILL_DESC:setEnabled(false)
    	cannonBg.TFD_SKILL_ATTR:setEnabled(false)
    	cannonBg.BTN_SKILL_LVUP:setEnabled(false)
    	cannonBg.TFD_SKILL_ATTR_NOW:setEnabled(false)
    	cannonBg.IMG_CONNON_OPEN:setEnabled(false)
    	cannonBg.TFD_CONNON_LV:setEnabled(false)
	end	

	if (((#_allCannonId) + leftCannonNum) <= 3 ) then
		_lvMain:setTouchEnabled(false)
		img_right:setEnabled(false)
	end
end 


-- 设置单个Cell上数据
function setCannonAndBallByIndex( cannonIndex,cannonId)
    local cannonCacheInfo = _allCannonCacheInfo and _allCannonCacheInfo[cannonId .. ""] --id
    local cannonDB = DB_Ship_cannon.getDataById(cannonId)

    local cannonBg = _lvMain:getItem(cannonIndex -  1)  -- cell 索引从 0 开始
    local cannnonOpneLV = cannonBg.TFD_CONNON_OPEN_LV -- 解锁的等级
    UIHelper.labelNewStroke(cannnonOpneLV,ccc3(0x28,0x00,0x00))
    local imgCannonClose =  cannonBg.IMG_CONNON_CLOSE
	local imgAdd = cannonBg.IMG_ADD
	local btnSkillUp = cannonBg.BTN_SKILL_LVUP
	UIHelper.titleShadow(btnSkillUp,m_i18n[7519])

    local cannnonLV = cannonBg.TFD_CONNON_LV -- 炮的等级
    UIHelper.labelNewStroke(cannnonLV,ccc3(0x28,0x00,0x00))
	local layIncon = cannonBg.LAY_SKILL_ICON
	local tfdAttr = cannonBg.TFD_SKILL_ATTR   -- 属性值
    UIHelper.labelNewStroke(tfdAttr,ccc3(0x28,0x00,0x00))

	local tfdSkillName = cannonBg.TFD_SKILL_NUM
    UIHelper.labelNewStroke(tfdSkillName,ccc3(0x28,0x00,0x00))

	local tfdSkillDesc = cannonBg.TFD_SKILL_DESC  -- 技能描述
    UIHelper.labelNewStroke(tfdSkillDesc,ccc3(0x28,0x00,0x00))

	local tfdSkillNow = cannonBg.TFD_SKILL_ATTR_NOW -- 当前技能描述
    UIHelper.labelNewStroke(tfdSkillNow,ccc3(0x28,0x00,0x00))

    if (UserModel.getHeroLevel() < tonumber(cannonDB.need_lv)) then
    	cannnonOpneLV:setText( m_i18nString(1141,cannonDB.need_lv)) -- need_lv 多少级解锁
    	btnSkillUp:setEnabled(false)
    	tfdAttr:setEnabled(false)
    	tfdSkillDesc:setEnabled(false)
    	layIncon:setEnabled(false)
    	cannnonLV:setEnabled(false)
    	tfdSkillNow:setEnabled(false)
    	return
    else
    	imgAdd:setEnabled(true)
    	btnSkillUp:setEnabled(true)
    	imgCannonClose:setEnabled(false)
    end

    local tfdRounNum = cannonBg.TFD_ROUND_NUM -- 释放回合
    UIHelper.labelNewStroke(tfdRounNum,ccc3(0x28,0x00,0x00))
    
    local roundFeild = cannonDB.round

    local roundTb = lua_string_split(roundFeild,"|")

    tfdRounNum:setText(m_i18nString(7513,roundTb[1]))

    local cannnonLVNum = cannonCacheInfo and cannonCacheInfo[1] or 0
    cannnonLV:setText("LV" .. cannnonLVNum)

	-- 炮强化
	btnSkillUp:addTouchEventListener(function ( sender,eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			if (UserModel.getHeroLevel() < tonumber(cannonDB.need_lv)) then
				ShowNotice.showShellInfo(m_i18n[7514]) 
			else
				ArmShipCtrl.gotoCannonStren(cannonIndex,cannonId)
			end
		end
	end )

	local imgAdd = cannonBg.IMG_ADD
	local imgSkillDi = cannonBg.IMG_SKILL_DI
	imgSkillDi:setTouchEnabled(true)
	local imgSkillFram = cannonBg.IMG_SKILL_FRAME

	if (cannonCacheInfo and tonumber(cannonCacheInfo[2]) ~= 0) then  -- 炮弹
		tfdSkillName:setEnabled(true)
		tfdSkillDesc:setEnabled(true)
    	tfdSkillNow:setEnabled(true)
		tfdAttr:setEnabled(true)
		imgAdd:setVisible(false)
		imgSkillFram:setVisible(false)

		local btnlay = ArmShipData.createCannonAndBallBtnByTid(cannonCacheInfo[2],btnLayShow,1)
		imgSkillDi:removeAllChildren()
		imgSkillDi:addChild(btnlay)

		local cannonBallDB = DB_Ship_skill.getDataById(tonumber(cannonCacheInfo[2]))
		tfdSkillName:setText(cannonBallDB.skill_name)     -- 技能名称
		tfdSkillName:setColor(g_QulityColor2[cannonBallDB.quality])

		local cannonBallAttr = ArmShipData.getCannonBallAttrByLel(tonumber(cannonCacheInfo[2]),tonumber(cannonCacheInfo[1]))
		
		tfdSkillDesc:setText(cannonBallAttr.des)

		local attrStr = ""
		for i,v in ipairs(cannonBallAttr.attr or {}) do
			attrStr = attrStr .. v.name .. ":" .. v.beforValue 
			break
		end
		tfdAttr:setText(attrStr)


		local attrSkillStr = ""
		local periodAttr = cannonBallAttr.periodAttr 

		local beforAttr = periodAttr.beforAttr
		if (beforAttr) then
			tfdSkillNow:setEnabled(true)
			tfdSkillNow:setText(beforAttr.attrText)
		else
			tfdSkillNow:setEnabled(false)
		end

   	else
		imgSkillDi:removeAllChildren()
		imgAdd:setVisible(true)
    	tfdSkillNow:setEnabled(false)
		tfdSkillName:setEnabled(false)
		tfdSkillDesc:setEnabled(false)
		tfdAttr:setEnabled(false)
		imgSkillFram:setVisible(true)
   	end

	imgSkillDi:addTouchEventListener(function ( sender,eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			if (cannonCacheInfo and tonumber(cannonCacheInfo[2]) ~= 0) then
				ArmShipCtrl.creatCannonBallInfo(cannonDB.id,cannonCacheInfo[2],cannonCacheInfo[1],cannonIndex)
			else
				ArmShipCtrl.lcoadCannonBall(cannonIndex,cannonDB.id)
			end
		end
	end)

end

function initCannonData( ... )
	_allCannonCacheInfo = ArmShipCtrl.getAllCannonCacheInfo()
	_allCannonId  = ArmShipCtrl.getAllCannonDBId()
end 

-------------------------------------------------------  通知 ---------------------------------------------
----------------------------------------------------------------------------------------------------------





function create(...)
	-- 背景信息
	initBG()
	-- 炮位信息
	initCannonData()
	-- 炮位信息界面
	initCannonInfoSV()
	return _UIMain
end
