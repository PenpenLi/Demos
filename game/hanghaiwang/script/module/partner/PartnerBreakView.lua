-- FileName: PartnerBreakView.lua
-- Author: sunyunpeng
-- Date: 2016-01-15
-- Purpose: function description of module
--[[TODO List]]

module("PartnerBreakView", package.seeall)

-- UI控件引用变量 --
local m_i18n = gi18n
local m_i18nString = gi18nString
local _mainLayout
local _btnTouchCanTouch = true

-- 模块局部变量 --
local _breakInfo = {}

local function init(...)

end

function destroy(...)
	package.loaded["PartnerBreakView"] = nil
end

function moduleName()
    return "PartnerBreakView"
end

--加通用描边字
function fnlabelNewStroke( widgetName )
    UIHelper.labelNewStroke(widgetName,ccc3(0x45,0x05,0x05))
end

-- 初始化背景
local function initBG( ... )
	_mainLayout = g_fnLoadUI("ui/break_main.json")
	_mainLayout:setSize(g_winSize)

	if(g_winSize.width ~= 640) then
		local layBg = _mainLayout.IMG_BG
		layBg:setScale(g_winSize.width/640)
	end

    local btnBack = _mainLayout.BTN_CLOSE
    btnBack:addTouchEventListener(function ( sender,eventType )
    	if (eventType == TOUCH_EVENT_ENDED) then
    		if (not _btnTouchCanTouch) then
    			return
    		end
            AudioHelper.playBackEffect()
    		PartnerBreakCtrl.onBtnReturn()
    	end
    end)
    UIHelper.titleShadow(btnBack,m_i18n[1019])
end


function setBtnTouchEnable( btnTouchCanTouch )
	_btnTouchCanTouch = btnTouchCanTouch
end


local function fnInitBeforeProperty( ... )
    local DBHeroBreak = _breakInfo.DBHeroBreak 

    local beforeForceValue = _breakInfo.beforeForceValue 
    local affterForceValue = _breakInfo.affterForceValue

	local beforeHeroDb = _breakInfo.breakBeforHeroDB 
    local affterHeroDB = _breakInfo.breakAffterHeroDB
	--突破前英雄数据
	local attrBeforePart = _mainLayout.img_attr_bg

	local ptfds = {}
	for i=1,5 do
		local LAY_ATTR = attrBeforePart["LAY_ATTR"..i]
		local TFD_ATTR_NAME = LAY_ATTR["TFD_ATTR_NAME" .. i]
		fnlabelNewStroke(TFD_ATTR_NAME)
		TFD_ATTR_NAME:setText(m_i18n[1047+i-1])
		local TFD_ATTR_NUM = LAY_ATTR["TFD_ATTR_NUM" .. i]
		fnlabelNewStroke(TFD_ATTR_NUM)

		table.insert(ptfds,TFD_ATTR_NUM)
	end

	ptfds[1]:setText(beforeForceValue.life)
	ptfds[2]:setText(beforeForceValue.physicalAttack)
	ptfds[3]:setText(beforeForceValue.magicAttack)
	ptfds[4]:setText(beforeForceValue.physicalDefend)
	ptfds[5]:setText(beforeForceValue.magicDefend)

	-- 等级和进阶需求面板
	local layNeed = attrBeforePart.LAY_NEED

	-- 等级
	local TFD_STRLV = layNeed.tfd_limit
	fnlabelNewStroke(TFD_STRLV)
	TFD_STRLV:setText(m_i18n[1160]) --wm_todoi18n 需要等级
	local TFD_NOWLV = layNeed.TFD_LV_NOW1  --当前LV todo
	fnlabelNewStroke(TFD_NOWLV)
	TFD_NOWLV:setText(_breakInfo.heroInfo.level)

	local tfd_slant1 = layNeed.tfd_slant1
	fnlabelNewStroke(tfd_slant1)

	if (tonumber(_breakInfo.heroInfo.level) < tonumber(DBHeroBreak.need_strlv)) then
		TFD_NOWLV:setColor(ccc3(0xff,0x36,0x00))
	else
		TFD_NOWLV:setColor(ccc3(0xff,0x8d,0x2c))
	end

	-- 名字和资质
	local layPrePartner = attrBeforePart.LAY_NAME1

	local tfdPreName = attrBeforePart.TFD_PARTNER_NAME
	tfdPreName:setVisible(true)
	local tfdPreAdvanceLv = attrBeforePart.TFD_ADVANCE_LV
	tfdPreAdvanceLv:setVisible(true)
	local pQulity1 = tonumber(beforeHeroDb.star_lv) or 3
	tfdPreName:setText(affterHeroDB.name)  --localInfo
	tfdPreName:setFontSize(26)
	tfdPreName:setColor(g_QulityColor2[pQulity1])
	UIHelper.labelNewStroke(tfdPreName , ccc3( 0x28 , 0x00 , 0x00))

	tfdPreAdvanceLv:setText("+".. _breakInfo.heroInfo.evolve_level)
	tfdPreAdvanceLv:setFontSize(26)
	tfdPreAdvanceLv:setColor(g_QulityColor2[pQulity1])
	UIHelper.labelNewStroke(tfdPreAdvanceLv , ccc3( 0x28 , 0x00 , 0x00))

	local TFD_STRLV = layNeed.TFD_STRLV
	fnlabelNewStroke(TFD_STRLV)
	TFD_STRLV:setText(DBHeroBreak.need_strlv)
	local tfd_desc2 = layNeed.tfd_desc2
	fnlabelNewStroke(tfd_desc2)
	tfd_desc2:setText(m_i18n[1168])--wm_todo[]"需要进阶"
	local TFD_STRLV_2 = layNeed.TFD_STRLV_2
	fnlabelNewStroke(TFD_STRLV_2)
	TFD_STRLV_2:setText(DBHeroBreak.need_advancelv)
	local TFD_LV_NOW2 = layNeed.TFD_LV_NOW2 -- 当前进阶等级 todo
	fnlabelNewStroke(TFD_LV_NOW2)
	TFD_LV_NOW2:setText(_breakInfo.heroInfo.evolve_level)

	local tfd_slant2 = layNeed.tfd_slant2
	fnlabelNewStroke(tfd_slant2)

	if (tonumber(_breakInfo.heroInfo.evolve_level) < tonumber(DBHeroBreak.need_advancelv)) then
		TFD_LV_NOW2:setColor(ccc3(0xff,0x36,0x00))
	else
		TFD_LV_NOW2:setColor(ccc3(0xff,0x8d,0x2c))
	end

end


-- 显示突破后属性部分
function fnInitAfterProperty( ... )
	local DBHeroBreak = _breakInfo.DBHeroBreak 

    local beforeForceValue = _breakInfo.beforeForceValue 
    local affterForceValue = _breakInfo.affterForceValue

	local beforeHeroDb = _breakInfo.breakBeforHeroDB 
    local affterHeroDB = _breakInfo.breakAffterHeroDB


	if (affterHeroDB) then --可突破new_htid

		local newPropertyPart = _mainLayout.img_attr_bg2
		local IMG_ARROW = newPropertyPart.IMG_ARROW
  --    
		local newInfoLsv = newPropertyPart.LSV_NEW_INFO
		local deleteH = 0
		
		

		--突破后英雄数据

		local ptfdsAfter = {}
		for i=1,5 do
			local LAY_ATTR = newPropertyPart["LAY_ATTR"..i]
			local TFD_ATTR_NAME = LAY_ATTR["TFD_ATTR_NAME" .. i]
			fnlabelNewStroke(TFD_ATTR_NAME)
			TFD_ATTR_NAME:setText(m_i18n[1047+i-1])
			local TFD_ATTR_NUM = LAY_ATTR["TFD_ATTR_NUM" .. i]
			fnlabelNewStroke(TFD_ATTR_NUM)

			local imgTransfer = LAY_ATTR.img_transfer
			imgTransfer:runAction(CCPlace:create(ccp(imgTransfer:getPositionX(),imgTransfer:getPositionY() - 5)))
			local imgTransferPic = imgTransfer:getVirtualRenderer()
			imgTransfer:setOpacity(0)

			local actionArray = CCArray:create()
			-- 控件节点 和节点中得 getVirtualRenderer 运动方向是反的。。。。
			actionArray:addObject(
                           	CCSpawn:createWithTwoActions(
                                                            CCMoveBy:create(0.5, ccp(5, 0)),
                                                            CCFadeIn:create(0.5)
                                                        )
                           )
			actionArray:addObject(
                           	CCSpawn:createWithTwoActions(
                                                            CCMoveBy:create(0.5, ccp(5, 0)),
                                                            CCFadeOut:create(0.5)
                                                        )
                           )
			actionArray:addObject(CCCallFuncN:create(function ( sender )
				sender:setPositionX(sender:getPositionX() - 10)
			end))

			local seq = CCSequence:create(actionArray)
			local repeatAction = CCRepeatForever:create(seq)
			imgTransferPic:runAction(repeatAction)
			table.insert(ptfdsAfter,TFD_ATTR_NUM)
		end

	
		local p1 = tonumber(affterForceValue.life)
		local p2 = tonumber(affterForceValue.physicalAttack) 
		local p3 = tonumber(affterForceValue.magicAttack) 
		local p4 = tonumber(affterForceValue.physicalDefend) 
		local p5 = tonumber(affterForceValue.magicDefend)

		ptfdsAfter[1]:setText(p1)
		ptfdsAfter[2]:setText(p2)
		ptfdsAfter[3]:setText(p3)
		ptfdsAfter[4]:setText(p4)
		ptfdsAfter[5]:setText(p5)

		--进阶后伙伴数据 名字 资质
		local tfdAfterName = newPropertyPart.TFD_PARTNER_NAME
		tfdAfterName:setVisible(true)
		local tfdAfterAdvanceLv = newPropertyPart.TFD_ADVANCE_LV
		tfdAfterAdvanceLv:setVisible(true)

		local pQulity2 = tonumber(affterHeroDB.star_lv) or 3
		tfdAfterName:setColor(g_QulityColor2[pQulity2])
		tfdAfterName:setText(affterHeroDB.name or "")
		tfdAfterName:setColor(g_QulityColor2[pQulity2])
		tfdAfterName:setFontSize(26)
		UIHelper.labelNewStroke(tfdAfterName , ccc3( 0x28 , 0x00 , 0x00))
		local pEvoLv = _breakInfo.heroInfo.evolve_level or 0
		tfdAfterAdvanceLv:setText("+"..pEvoLv)
		tfdAfterAdvanceLv:setColor(g_QulityColor2[pQulity2])
		tfdAfterAdvanceLv:setFontSize(26)
		UIHelper.labelNewStroke(tfdAfterAdvanceLv , ccc3( 0x28 , 0x00 , 0x00))

		------------------------------
		------------------------------
		 -- return tfdBeforeSizeWidth 之前的宽度 tfdBeforeSizeHeight 高度 affterSizeHeight变化后的高度
		local function labelScaleChangedWithStr( UIlableWidet,textInfo )
		    local tfdBeforeSize = UIlableWidet:getSize()
		    local tfdBeforeSizeHeight = tfdBeforeSize.height  -- 必须把高度值单独取出来放进变量里 否则值会变
		    local tfdBeforeSizeWidth = tfdBeforeSize.width  -- 必须把高度值单独取出来放进变量里 否则值会变

		    UIlableWidet:setSize(CCSizeMake(tfdBeforeSize.width,0))
		    UIlableWidet:setText(textInfo)
		    local tfdAffterSize =  UIlableWidet:getVirtualRenderer():getContentSize()
		    local lineHeightScale = math.ceil(tfdAffterSize.height/tfdBeforeSizeHeight)
		    local affterSizeHeight = lineHeightScale * tfdBeforeSizeHeight
		    UIlableWidet:setSize(CCSizeMake(tfdBeforeSizeWidth,affterSizeHeight))

		    return tfdBeforeSizeWidth,tfdBeforeSizeHeight,affterSizeHeight

		end
	-- 	-------------------------------------------------
		local imgAbilityBg = newInfoLsv.img_ability_bg

		local tfdAblityInofo = newInfoLsv.TFD_ABILITY_INFO
		-- 潜能描述
	    local sAttr = _breakInfo.awakeDes 
		if (sAttr) then
		 	labelScaleChangedWithStr(tfdAblityInofo,sAttr)
			fnlabelNewStroke(tfdAblityInofo)
		else
			tfdAblityInofo:removeFromParentAndCleanup(true)
		end
		
		-- 新增潜能
		local TFD_ABILITY_AWAKE = imgAbilityBg.TFD_ABILITY_AWAKE
		fnlabelNewStroke(TFD_ABILITY_AWAKE)
		TFD_ABILITY_AWAKE:setText(m_i18n[1162])

		local TFD_ABILITY_NAME = imgAbilityBg.TFD_ABILITY_NAME
		TFD_ABILITY_NAME:setVisible(true)
		fnlabelNewStroke(TFD_ABILITY_NAME)
		TFD_ABILITY_NAME:setText(_breakInfo.awakeName or m_i18n[1093])

		-- 羁绊 加成
		local imgJibanBg = newInfoLsv.img_jiban_bg
		local TFD_JIBAN = imgJibanBg.TFD_JIBAN
		fnlabelNewStroke(TFD_JIBAN)
		TFD_JIBAN:setText(m_i18n[1165])

		local TFD_JIBAN_UP = imgJibanBg.TFD_JIBAN_UP
		fnlabelNewStroke(TFD_JIBAN_UP)
		TFD_JIBAN_UP:setText(m_i18n[1166])

		-- 技能
		local imgJiNengBg = newInfoLsv.img_jineng_bg
		local TFD_SKILL_UP = imgJiNengBg.TFD_SKILL_UP
		fnlabelNewStroke(TFD_SKILL_UP)
		TFD_SKILL_UP:setText(m_i18n[1167])

		-- 技能描述
		local tfdAngerInfo = newInfoLsv.TFD_ANGER_INFO
		if (DBHeroBreak.anger_skill) then
			labelScaleChangedWithStr( tfdAngerInfo,DBHeroBreak.anger_skill )
		else
			tfdAngerInfo:removeFromParentAndCleanup(true)
		end

		-- 查看详情
		local btnIformation = newInfoLsv.BTN_INFORMATION
		btnIformation:addTouchEventListener(function (sender ,eventType )
			if eventType == TOUCH_EVENT_ENDED then
				if (not _btnTouchCanTouch) then
					return
				end
				AudioHelper.playInfoEffect()
				-- 现实进阶伙伴信息
				require "script/module/partner/PartnerInfoCtrl"
		        local heroInfo = {htid = affterHeroDB.id ,hid = _breakInfo.hid ,strengthenLevel = _breakInfo.heroInfo.level ,transLevel = _breakInfo.heroInfo.evolve_level ,readOnly =  true}
		        local tArgs = {}
		        tArgs.heroInfo = heroInfo
		        logger:debug({tArgs=tArgs})
		        local layer = PartnerInfoCtrl.create(tArgs,4)     --所选择武将信息22
		        LayerManager.addLayoutNoScale(layer)

			end
		end)
	end
end


local function fnInitModel( ... )
    local beforeHeroDb = _breakInfo.breakBeforHeroDB 
    local affterHeroDB = _breakInfo.breakAffterHeroDB

	local layModel =  _mainLayout.LAY_PARTNER

	local BTN_PREVIEW = layModel.BTN_PREVIEW
	BTN_PREVIEW:addTouchEventListener(function (sender ,eventType )
		if eventType == TOUCH_EVENT_ENDED then
			-- AudioHelper.playInfoEffect()
			if (not _btnTouchCanTouch) then
				return
			end
			AudioHelper.playCommonEffect()
			require "script/module/partner/PartnerBreakPreview"
			local breakPreview = PartnerBreakPreview:new()
			LayerManager.addLayout(breakPreview:create())
		end
	end)

	local BTN_EXPLAIN = layModel.BTN_EXPLAIN
	BTN_EXPLAIN:addTouchEventListener(function (sender ,eventType )
		if eventType == TOUCH_EVENT_ENDED then
			if (not _btnTouchCanTouch) then
				return
			end
			AudioHelper.playCommonEffect()
			local explainLayout = g_fnLoadUI("ui/break_explain.json")

			local tfdDesc = explainLayout.tfd_desc
			tfdDesc:setText(m_i18n[1190])

		    local btnBack = explainLayout.BTN_CLOSE
		    btnBack:addTouchEventListener(function ( sender,eventType )
		    	if (eventType == TOUCH_EVENT_ENDED) then
		            AudioHelper.playCloseEffect()
		            LayerManager.removeLayout()
		    	end
		    end)
		    LayerManager.addLayout(explainLayout)
		end
	end)

	-- 突破钱的英雄信息
	local layBeforeHeroBody = layModel.IMG_BEFORE
	layBeforeHeroBody:loadTexture("images/base/hero/body_img/" .. beforeHeroDb.body_img_id)
	layBeforeHeroBody:setTouchEnabled(true)
	layBeforeHeroBody:addTouchEventListener(function (sender ,eventType )
		if eventType == TOUCH_EVENT_ENDED then
			if (not _btnTouchCanTouch) then
				return
			end
			AudioHelper.playInfoEffect()
			-- 现实进阶伙伴信息
			require "script/module/partner/PartnerInfoCtrl"
	        local heroInfo = {htid = beforeHeroDb.id ,hid = _breakInfo.heroInfo.hid ,strengthenLevel = _breakInfo.heroInfo.level ,transLevel = _breakInfo.heroInfo.evolve_level}
	        local tArgs = {}
	        tArgs.heroInfo = heroInfo
	        local layer = PartnerInfoCtrl.create(tArgs,4)     --所选择武将信息22
	        LayerManager.addLayoutNoScale(layer)

		end
	end)

	local pQulity = tonumber(beforeHeroDb.star_lv) or 3
	local tfdScore = layModel.TFD_BEFORE_SCORE
	tfdScore:setText(m_i18n[1003])
	tfdScore:setColor(ccc3(0xf7,0xd2,0x8e))
	tfdScore:setFontSize(22)


	local pEvoLv = beforeHeroDb.heroQuality or 1
	local tfdPreNum = layModel.TFD_BEFORE_SCORE_NUM
	tfdPreNum:setColor(ccc3(0xf7,0xd2,0x8e))
	tfdPreNum:setFontSize(22)
	tfdPreNum:setText(pEvoLv)


	-- 突破后的英雄信息
	if (affterHeroDB) then
		local layAfterHeroBody = layModel.IMG_AFTER
		layAfterHeroBody:loadTexture("images/base/hero/body_img/" .. affterHeroDB.body_img_id)
		layAfterHeroBody:setOpacity(255 * 0.5)
		layAfterHeroBody:getVirtualRenderer():setScale(0.9)
		layAfterHeroBody:setTouchEnabled(true)
		layAfterHeroBody:addTouchEventListener(function (sender ,eventType )
			if eventType == TOUCH_EVENT_ENDED then
				if (not _btnTouchCanTouch) then
					return
				end
				AudioHelper.playInfoEffect()
				-- 现实进阶伙伴信息
				require "script/module/partner/PartnerInfoCtrl"
		        local heroInfo = {htid = affterHeroDB.id ,hid = _breakInfo.heroInfo.hid,strengthenLevel = _breakInfo.heroInfo.level ,transLevel = _breakInfo.heroInfo.evolve_level,readOnly = true }
		        local tArgs = {}
		        tArgs.heroInfo = heroInfo
		        local layer = PartnerInfoCtrl.create(tArgs,4)     --所选择武将信息22
		        LayerManager.addLayoutNoScale(layer)

			end
		end)


		local tfdScore = layModel.TFD_AFTER_SCORE
		tfdScore:setText(m_i18n[1003])
		tfdScore:setColor(ccc3(0xf7,0xd2,0x8e))
		tfdScore:setFontSize(22)
		local pEvoLv = affterHeroDB.heroQuality or 1
		local tfafterNum = layModel.TFD_AFTER_SCORE_NUM
		tfafterNum:setColor(ccc3(0xf7,0xd2,0x8e))
		tfafterNum:setFontSize(22)
		tfafterNum:setText(pEvoLv)
	else
		layAfterHeroBody:setEnabled(false)
	end

end


-- 显示LAY_CONSUME部分
function fnInitConsum( costInfo )
	if (costInfo)  then
		_breakInfo.costInfo = costInfo
	end
    local costInfo = _breakInfo.costInfo
    local costCoin = _breakInfo.costCoin 

	--进阶消耗贝里
	local consumeLay = _mainLayout.LAY_CONSUME
	local tfd_consume = consumeLay.tfd_consume

	local btnStart = consumeLay.BTN_BREAK
	btnStart:addTouchEventListener(function ( sender,eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			if (not _btnTouchCanTouch) then
				return
			end
			AudioHelper.playCommonEffect()
			PartnerBreakCtrl.onBtnBreakStart()
		end
	end)
	UIHelper.titleShadow(btnStart,m_i18n[1155])--wm_todo

	for i=1,2 do
		local costItemInfo = costInfo[i]
		logger:debug({costItemInfo = costItemInfo})
		local layitem = consumeLay["LAY_ITEM"..i]

		if (not costItemInfo) then
			layitem:setEnabled(false)
			break
		end

		layitem:setEnabled(true)
		local tdfConsumeName = layitem.TFD_ITEM_NAME
		local itemInfo = ItemUtil.getItemById(costItemInfo.itemTid)
		tdfConsumeName:setText(itemInfo.name)
		tdfConsumeName:setColor(g_QulityColor[itemInfo.quality])

		local function btnLayShow( sender ,eventType )
			if eventType == TOUCH_EVENT_ENDED then
				if (not _btnTouchCanTouch) then
					return
				end

				AudioHelper.playCommonEffect()
				local itemTid = costItemInfo.itemTid
				local itemInfo = ItemUtil.getItemById(itemTid)
				if (itemInfo.isNormal) then
					local dropcallfn = function ( ... )
						logger:debug("m_fnGetNeedItemInfo")
						local newCostInfo = PartnerBreakCtrl.initMaterial()
						_breakInfo.costInfo = newCostInfo
						fnInitConsum()
					end
					PublicInfoCtrl.createItemDropInfoViewByTid(60025,dropcallfn,nil)  -- 突破石头掉落引导界面
				elseif(itemInfo.isHeroFragment) then
					require "script/module/public/FragmentDrop"
					local fragmentDrop = FragmentDrop:new()
					local dropcallfn = function ( ... )
						local newCostInfo = PartnerBreakCtrl.initMaterial()
						_breakInfo.costInfo = newCostInfo
						fnInitConsum()
					end
					
					local fragmentDroplayout = fragmentDrop:create(itemTid,dropcallfn)
					LayerManager.addLayout(fragmentDroplayout)
				end
			end
		end

		local btnlay = ItemUtil.createBtnByItem(itemInfo,btnLayShow)
		local IMG_ITEM = layitem.IMG_ITEM
		IMG_ITEM:removeAllChildren()
		IMG_ITEM:addChild(btnlay)

		local nNeedCount = tonumber(costItemInfo.needNum)
		local nRealCount = tonumber(costItemInfo.haveNum)

		local labnNumLeft = layitem.TFD_NUM_LEFT
		local labnNumRight = layitem.TFD_NUM_RIGHT

		if( nNeedCount > nRealCount) then
            labnNumLeft:setColor(ccc3(0xD8,0x14,0x00))
			-- labnNumLeft:setColor(ccc3(0xff,0x36,0x00))
		else
            labnNumLeft:setColor(ccc3(0x00,0x8A,0x00))
			-- labnNumLeft:setColor(ccc3(0x59,0x1f,0x00))
		end

		labnNumLeft:setText(nRealCount)
		labnNumRight:setText(nNeedCount)
	end

	local TFD_CONSUME_NUM = consumeLay.TFD_CONSUME_NUM
	TFD_CONSUME_NUM:setText(costCoin or 0)

end


local function fnGoSuccess( ... )
	local succedHeroInfo = {}
    local succedHeroInfo = table.hcopy(_breakInfo,succedHeroInfo)
	require "script/module/partner/PartnerBreakSucceed"
	PartnerBreakSucceed.create(succedHeroInfo)
end


function showBreakSuccedAni( ... )
	local layModel =  _mainLayout.LAY_PARTNER
    local layBeforeHeroBody = layModel.IMG_BEFORE

	local tuoPoAni = UIHelper.createArmatureNode({
	filePath = "images/effect/partner_break/break2/break_2.ExportJson",
	animationName = "break_2",
    loop = 0,
    fnMovementCall = function ( ... )
	    if(movementType == EVT_COMPLETE) then
    		tuoPoAni:removeFromParentAndCleanup(true)
    		fnGoSuccess()
		end
    end,
    fnFrameCall = function( bone,frameEventName,originFrameIndex,currentFrameIndex )
            if(frameEventName == "1") then
				local layBeforeHeroBodyImg = layBeforeHeroBody:getVirtualRenderer()
				layBeforeHeroBodyImg:runAction(CCSpawn:createWithTwoActions(
                                                            CCScaleTo:create(5/60, 0.9 ),
                                                            CCFadeTo:create(5/60,255 *0.5)
                                                        ))

            elseif (frameEventName == "2") then
            	local layAfterHeroBody = layModel.IMG_AFTER
				local layAfterHeroBodyImg = layAfterHeroBody:getVirtualRenderer()
				layAfterHeroBodyImg:runAction(CCSpawn:createWithTwoActions(
                                                            CCScaleTo:create(5/60, 1),
                                                            CCFadeTo:create(5/60,255)
                                                        ))
            elseif (frameEventName == "3") then
    			fnGoSuccess()
            end
        end
	})
	tuoPoAni:setAnchorPoint(ccp(0.5,0.5))
	local laySize = layBeforeHeroBody:getParent():getContentSize()
	tuoPoAni:setPosition(ccp(laySize.width * 0.5,laySize.height * 0.5 ))
	layBeforeHeroBody:getParent():addNode(tuoPoAni)
end


-- 初始化各部分lay
function initLay()
	fnInitModel()  -- 显示突破前后伙伴图片信息
	fnInitBeforeProperty()  -- 显示突破前属性值部分
	fnInitAfterProperty()  -- 显示突破后属性值部分
	fnInitConsum()  --  显示最后消费部分
end


function create(  )
	_breakInfo = {}
	_btnTouchCanTouch = true
	local transInfo = PartnerBreakCtrl.getBreakInfo()
    _breakInfo = table.hcopy(transInfo,_breakInfo)
	initBG()
	initLay()

	LayerManager.setPaomadeng(_mainLayout, 0)
	UIHelper.registExitAndEnterCall(_mainLayout, function ( ... )
		LayerManager.resetPaomadeng()
    end,function (  )
        
    end)
	return _mainLayout
end
