-- FileName: EquipFixView.lua
-- Author: zhangjunwu
-- Date: 2014-12-08
-- Purpose: function description of module
--[[TODO List]]

module("EquipFixView", package.seeall)
require "script/module/public/AttribEffectManager"
-- UI控件引用变量 --
local jsonEuipFix 					= "ui/equip_enhance.json"
local m_MainUI 						= nil
local m_szRowCell 							-- 行cell的size

local m_IMG_EFFECT 					= nil  --所有特效的父节点 

local LABN_OWN_PROGRESS				= nil 	--现在拥有附魔经验
local LABN_TOTAL_PROGRESS			= nil 	--升级所需要的附魔经验
local mImgSlant						= nil 	--升级所需要的附魔经验

local LOAD_PROGRESS 				= nil 

local m_CUR_ENCHANT_LV 				= nil 	--附魔等级  
local TFD_LV_NUM_BEFORE 			= nil 	--当前的附魔等级  
local TFD_LV_NUM_AFTER 				= nil 	--当前的附魔等级 + 1  
local m_IMG_EQUIP

-- 模块局部变量 --
local m_fnGetWidget 				= g_fnGetWidgetByName
local m_i18n 						= gi18n
local m_i18nString 					= gi18nString
local m_tbEvent 					= {}
local m_tbAllItem					= {} 		--所有材料的空间存放表
local m_EnchantEquipInfo 			= nil 

local _tbStuffInfo						= nil
local _nStuffIndex						= 1
local nAddedItemNum = 0
local mSchedulerId  = nil
local _tipLabel 	= nil
local curEnchantLv  = 0
local maxEnchantLv  = 0 
local m_animationPath = "images/effect/forge"

local FADEINTIME					= 1
 E_TAG_AUTOADD 						= 1
 E_TAG_CACALAUTO 					= 2


local m_tbAttrItemAdded             = {} --附魔会影响到的属性 所对应的UI 方便特效播放的时候调用
local m_levenUPValue             	= 0  --附魔会影响到的属性 所对应的UI 方便特效播放的时候调用
local m_tbAttrValue 				=  {}

local m_nCurMolExp 					= 0  -- 现在所拥有的分子经验
local m_nTotleMolExp 				= 0  -- 现在所拥有的分子经验 + 材料带来的经验
local m_nCurDemExp 				    = 0  --现在的分母经验

local m_bBarAniOvered 				= true
local m_bForceAniOvered 			= true
local m_FinalPos

local _COL_COUNT = 5 -- zhangqi, 2015-06-23, 每行物品的个数（列数）
local m_refColCell = nil -- zhangqi, 2015-06-23, 每个物品layout的对象缓存，删除UI时需要release
local m_tagSelect = 299 -- zhangqi, 2015-06-24, 添加选中对号标志的tag


function isBarAndEffectAniOver()
	return (m_bBarAniOvered  and m_bForceAniOvered )
end

local function init()
	m_tbAttrItemAdded = {}
	_tbStuffInfo	= {}
	_nStuffIndex	= 1
	nAddedItemNum = 0
	m_nCurMolExp = 0
	m_nTotleMolExp = 0
	m_nCurDemExp = 0
	m_tbEvent = nil
	m_tbAllItem = nil
	m_tbAllItem = {} 
	m_bBarAniOvered = true
	m_bForceAniOvered = true
end

function destroy(...)
	-- m_MainUI = nil
	-- m_refColCell:release() -- zhangqi, 2015-06-24, 释放缓存的layout对象
	package.loaded["EquipFixView"] = nil
end

function moduleName()
    return "EquipFixView"
end

local function fnCreateAni( pName )
    local m_arAni1 = UIHelper.createArmatureNode({
        filePath = "images/effect/"..pName.."/"..pName..".ExportJson",
        animationName = pName,
        bRetain = true
    })
    return m_arAni1
end

-- local function setExpLabelVisable( _bVis )
-- 	LABN_OWN_PROGRESS:setVisible(_bVis)
-- 	LABN_TOTAL_PROGRESS:setVisible(_bVis)
-- 	mImgSlant:setVisible(_bVis)
-- end

-- 添加 装备附魔动画
function addEnchantAnimation( delegateFunc)
	local tbTempAttr ={}
	 table.hcopy(m_tbAttrValue,tbTempAttr)
	 logger:debug(m_tbAttrValue)
	 logger:debug(tbTempAttr)
	local nUpLevelValue =  m_levenUPValue
	logger:debug("m_levenUPValue")
	logger:debug(m_levenUPValue)
	
	if(nUpLevelValue == 0 )then
		-- initUI()
		return 
	end
	stopAllActions()
	--强化提升特效播完的回掉
	local function aniOverCall(  )
		m_bForceAniOvered = true
		if(m_bForceAniOvered == true) then
			m_tbAttrItemAdded = {}
		end
	end

	local function keyFrameCallBack( bone,frameEventName,originFrameIndex,currentFrameIndex )
		if (frameEventName == "17") then
			-- 在播放到第17 帧 时播放qh3_3 提升xx级 特效
		elseif (frameEventName == "1") then
			 addAttrNumAnimation()

		end
	end

	local m_arAni2
	local  m_arAni1
	local function animationCallBack( armature,movementType,movementID )
		if(movementType == 1) then
			armature:removeFromParentAndCleanup(true)
			local pArr = CCArray:create()
            pArr:addObject(CCDelayTime:create( 10 * 1 / 60 ))

            pArr:addObject(CCCallFuncN:create(function()
            	addSuccAnimation()
            end))
            if(nUpLevelValue > 0) then
	            pArr:addObject(CCDelayTime:create( 17 * 1 / 60 ))
	            pArr:addObject(CCCallFuncN:create(function()
	            	addUpAnimation()
	            end))
	        end

            m_IMG_EQUIP:runAction(CCSequence:create(pArr))
		end
	end

	local function allAnimationCallBack( armature,movementType,movementID )
		if(movementType == 1) then
			logger:debug("动画没播放完啦～～～～～==  提升几级也已经完成 ")
			armature:removeFromParentAndCleanup(true)
			--显示返回贝里面板
			aniOverCall()
			-- initUI()
		end
	end

	AudioHelper.playEffect("audio/effect/texiao01_qianghua.mp3")
	m_arAni2 = UIHelper.createArmatureNode({
		filePath = m_animationPath .. "/UI_15/qh.ExportJson",
		animationName = "qh",
		fnMovementCall = animationCallBack,
		fnFrameCall = keyFrameCallBack,
		bRetain = true
	})

	m_IMG_EQUIP:addNode(m_arAni2)


    -- 属性数值特效
	function addAttrNumAnimation( )
		logger:debug("需要加特效的属性控件为:")
		logger:debug(m_tbAttrItemAdded)
		if(nUpLevelValue > 0) then
		    for i=1,#m_tbAttrItemAdded do
		        local attrLay = m_tbAttrItemAdded[i]
		        if(attrLay) then
		            local pArr = CCArray:create()
		            if(i ~= 1) then
		                pArr:addObject(CCDelayTime:create(0.05*(i-1)))
		            end
		            pArr:addObject(CCCallFuncN:create(function()
		            	local ani = fnCreateAni("jinjie_shuzi")
		            	ani:setPosition(ccp(attrLay:getSize().width / 2 , attrLay:getSize().height / 2))
		                attrLay:addNode(ani)
		            end))
		            attrLay:runAction(CCSequence:create(pArr))
		        end
		    end
		end
		m_tbAttrItemAdded = {}
	end

	-- 当 特效qh播放完 第10帧  开始播放 附魔成功特效（qh3的qh3_fm）
	function addSuccAnimation(  )
		 AudioHelper.playEffect("audio/effect/texiao01_qianghua.mp3")
		local m_arAni1 = g_attribManager:createFixOKEffect({
			fnMovementCall = function (armature,movementType,movementID )
										if(movementType == 1) then
											logger:debug("动画没播放完啦～～～～～== %s" ,nUpLevelValue)
											armature:removeFromParentAndCleanup(true)
								            if(nUpLevelValue <= 0) then
												--显示返回贝里面板
												aniOverCall()
									        end

										end
							end
			}
		)
		m_arAni1:setPosition(ccp(m_IMG_EFFECT:getSize().width / 2 , m_IMG_EFFECT:getSize().height / 2))
		m_IMG_EFFECT:addNode(m_arAni1)
	end

	local tBefore = EquipFixCtrl.getTBBeFore()
	local tAfter = EquipFixCtrl.getTBAfter()
	local runningScene = CCDirector:sharedDirector():getRunningScene()
	
	local function fnMaster( ... )
		local showString = MainEquipMasterCtrl.fnGetMasterChangeStringByHeroInfo(tBefore,tAfter,2)
		local node = MainEquipMasterCtrl.fnGetMasterFlyInfo(showString, nil, function (  )
			-- showAttrChangeAnimation(level_num) -- 如果在伙伴身上则 需要增加判断 强化大师 增加的飘字效果
		end)
		if (node and showString) then
			runningScene:addChild(node, 99999)
		end
	end

	--增加强化大师的特效
	local function addFixMasterEffect()
		-- 如图，默认的属性面板提示消失后 显示战斗力 显示规则同阵容
		MainFormationTools.removeFlyText()
		MainFormationTools.fnShowFightForceChangeAni()
		
		local showString = MainEquipMasterCtrl.fnGetMasterChangeStringByHeroInfo(tBefore,tAfter,2)
		if(showString) then
			local guruAni = g_attribManager:createEquipFixMasterEffect({
									level = tAfter[tonumber(2)],
									fnMovementCall = function (armature,movementType,movementID)
										if movementType == 1 then
											armature:removeFromParentAndCleanup(true)
											fnMaster()
										end
									end
								})

			m_IMG_EFFECT:addNode(guruAni, 99999)
		end
	end


	local function showAttrChangeAnimation()
		require "script/utils/LevelUpUtil"
		local pos = ccp(m_IMG_EFFECT:getPositionX(),m_IMG_EFFECT:getPositionY())
        local ppos = m_IMG_EFFECT:getParent():convertToWorldSpace(pos)
        local pSize = m_IMG_EFFECT:getSize()
        local showpos = ccp(ppos.x+pSize.width*0.5, ppos.y+pSize.height*0.5)

        logger:debug(tbTempAttr)
        LevelUpUtil.showFlyText(tbTempAttr,addFixMasterEffect,showpos)
	end

   --  提升几级
	function addUpAnimation()
		showAttrChangeAnimation()
		AudioHelper.playEffect("audio/effect/texiao_tishengXji.mp3")
		logger:debug({nUpLevelValue = nUpLevelValue})
		local arAni4 =  g_attribManager:createAddLevelEffect({
			fnMovementCall = allAnimationCallBack,
			level = nUpLevelValue
		})
		m_IMG_EFFECT:addNode(arAni4)
		-- arAni4:getAnimation():play(pName, 0, -1, -1)
		arAni4:setPosition(ccp(m_IMG_EFFECT:getSize().width / 2 , m_IMG_EFFECT:getSize().height / 2 - 100))
	end
end

--设置属性名字和数值以及箭头是否可见
local function setItemEnable( _enable ,index )
	local LAY_1 = m_fnGetWidget(m_MainUI,"img_attrbg1")	
	local LAY_2 = m_fnGetWidget(m_MainUI,"img_attrbg2")	

	local TFD_ATTRName1 = m_fnGetWidget(LAY_1,"TFD_ATTR" .. index)
	local TFD_ATTRName2 = m_fnGetWidget(LAY_2,"TFD_ATTR" .. index)
	local attrValue1 = m_fnGetWidget(LAY_1,"TFD_ATTR_NUM" .. index)
	local attrValue2 = m_fnGetWidget(LAY_2,"TFD_ATTR_EFFECT" .. index)
	local Img_arrow = m_fnGetWidget(LAY_2,"IMG_ARROW" .. (index+1))

	TFD_ATTRName1:setEnabled(_enable)
	TFD_ATTRName2:setEnabled(_enable)
	attrValue1:setEnabled(_enable)
	attrValue2:setEnabled(_enable)
	Img_arrow:setEnabled(_enable)

end

--设置装备的基础的属性
local function setBaseAttrUI()
	m_tbAttrItemAdded = {}
	local baseAttrInfo = EquipFixModel.getEnchatAffixByLevelUp()
	m_tbAttrValue = {}
	local img_attrbg1 = m_fnGetWidget(m_MainUI,"img_attrbg1")	
	local img_attrbg2 = m_fnGetWidget(m_MainUI,"img_attrbg2")
	local img_arrow_lv = m_fnGetWidget(m_MainUI,"IMG_ARROW1")
	table.insert(m_tbAttrItemAdded,img_arrow_lv)

	for i=1,3 do
		setItemEnable(false ,i)
	end

	-- for i=1,2 do
	for i,v in ipairs(baseAttrInfo) do
		-- local v = baseAttrInfo[i]
			local LAY_1 = m_fnGetWidget(m_MainUI,"img_attrbg1")	
			local LAY_2 = m_fnGetWidget(m_MainUI,"img_attrbg2")	

			local TFD_ATTRName1 = m_fnGetWidget(LAY_1,"TFD_ATTR" .. i)
			local TFD_ATTRName2 = m_fnGetWidget(LAY_2,"TFD_ATTR" .. i)
			local attrValue1 = m_fnGetWidget(LAY_1,"TFD_ATTR_NUM" .. i)
			local attrValue2 = m_fnGetWidget(LAY_2,"TFD_ATTR_EFFECT" .. i)
			local Img_arrow = m_fnGetWidget(LAY_2,"IMG_ARROW" .. (i+1))

			setItemEnable(true ,i)
		-- if(v and tonumber(v.baseAffix) > 0) then
			TFD_ATTRName1:setText(v.affixName .. "：" )
			TFD_ATTRName2:setText( v.affixName .."：")

			attrValue1:setText("+" .. v.AttrValue )
			attrValue2:setText("+" .. v.AttrValueNextLv)
			UIHelper.labelNewStroke(TFD_ATTRName1)
			UIHelper.labelNewStroke(TFD_ATTRName2)
			UIHelper.labelNewStroke(attrValue1)
			UIHelper.labelNewStroke(attrValue2)

			-- if( true) then
			table.insert(m_tbAttrItemAdded,Img_arrow)
			local attrInfo = {}
			attrInfo.txt 			= v.affixName
			attrInfo.num  			=v.enchantAffix 
			attrInfo.displayNumType	=v.displayNumType

			table.insert(m_tbAttrValue,attrInfo)
	end


	setAdventLabel()
end

--设置属性
local function setAttrUI()
	--对于四个解锁属性，TFD_ATTR, TFD_ATTR_NUM,TFD_ATTR_CONDITION未解锁时为#919191,解锁后第一个为#ffea00,后两个为#ffffff.
	--基础属性
	setBaseAttrUI()
end

--[[desc:功能简介
    arg1: equipInfo = {item_template_id,item_id}
    return: 是否有返回值，返回值说明  
—]]

function create(equipInfo,tbEvent)
	init()

	m_MainUI = g_fnLoadUI(jsonEuipFix)
	m_EnchantEquipInfo = equipInfo
	m_tbEvent = tbEvent
	m_IMG_EFFECT = m_fnGetWidget(m_MainUI,"IMG_EFFECT")

	--c常按可连续附魔
	_tipLabel = m_MainUI.tfd_tip
	_tipLabel:setVisible(false)
	--添加装备附魔材料的listview
	--背景适配
	local imgBg = m_fnGetWidget(m_MainUI,"IMG_BG")
	imgBg:setScale(g_fScaleX)

	--装备大图
	local itemDesc =  DB_Item_arm.getDataById(m_EnchantEquipInfo.item_template_id)
	m_IMG_EQUIP = m_fnGetWidget(m_MainUI,"IMG_EQUIP")
	m_IMG_EQUIP:loadTexture("images/base/equip/big/" .. itemDesc.icon_big )
	UIHelper.runFloatAction(m_IMG_EQUIP)

	--按钮控件初始化
	local BTN_CLOSE = m_fnGetWidget(m_MainUI,"BTN_BACK")
	BTN_CLOSE:addTouchEventListener(tbEvent.onBack) 
	UIHelper.titleShadow(BTN_CLOSE, m_i18n[1019])

	--经验进度条
	LOAD_PROGRESS_EFFECT 		= m_fnGetWidget(m_MainUI,"LOAD_PROGRESS_EFFECT")
	local LOAD_PROGRESS_Parent  = m_fnGetWidget(m_MainUI,"LOAD_PROGRESS")
	LOAD_PROGRESS_Parent:setPercent(0)
	LOAD_PROGRESS 				=  UIHelper.fnGetProgress("ui/enhance_exp_load.png")
	LOAD_PROGRESS:setAnchorPoint(ccp(0,0))
	LOAD_PROGRESS:setPosition(-LOAD_PROGRESS_Parent:getSize().width / 2, - LOAD_PROGRESS_Parent:getSize().height / 2)
	LOAD_PROGRESS_Parent:addNode(LOAD_PROGRESS)

	LABN_OWN_PROGRESS 			= m_fnGetWidget(m_MainUI,"TFD_PROGRESS")
	LABN_OWN_PROGRESS:removeFromParentAndCleanup(false)
	LOAD_PROGRESS_Parent:addChild(LABN_OWN_PROGRESS)

	mImgSlant 					= m_fnGetWidget(m_MainUI,"img_slant")

	m_CUR_ENCHANT_LV 			= m_fnGetWidget(m_MainUI,"TFD_LV1") 					--装备附魔等级

	TFD_LV_NUM_BEFORE 			= m_fnGetWidget(m_MainUI,"TFD_LV_NUM_BEFORE") 			
	TFD_LV_NUM_AFTER 			= m_fnGetWidget(m_MainUI,"TFD_LV_NUM_AFTER") 			

	local pBg = m_fnGetWidget(m_MainUI, "IMG_LOADING_BG")
	local pPos = ccp(pBg:getPositionX(),pBg:getPositionY())
	m_FinalPos = pBg:getParent():convertToWorldSpace(pPos)
	 TimeUtil.timeStart("setStuffListView.create")
	initUI()

	 _tbStuffInfo = EquipFixModel.setFixStuff()
	 
	setStuffListView()
	 TimeUtil.timeEnd("setStuffListView.create")

	return m_MainUI
end

local function setExpValue()

	--附魔装备的所有附魔经验
	local equipEnchatExp =  EquipFixModel.getAllExp()
	logger:debug("次装备的所有附魔经验:%s" , equipEnchatExp)
	--附魔到当前等级所需要的所有附魔经验
	local expNeeded = EquipFixModel.getAllExpToCurLevel()
	logger:debug("附魔到当前等级所需要的所有附魔经验 :%s" , expNeeded)
	
	--附魔到当前等级 + 1所需要的附魔经验
	local expNextLevelNeeded = EquipFixModel.getEnchatExpByNextLevel()
	logger:debug("附魔到当前等级 + 1所需要的附魔经验:%s" , expNextLevelNeeded)

	--现在的附魔等级所拥有的经验
	local nCurExpToLevelUp = equipEnchatExp - expNeeded

	m_nCurDemExp = expNextLevelNeeded
	m_nCurMolExp = nCurExpToLevelUp
end


--停止计时器，并向后端发送请求
function stopSceduler()
	if(mSchedulerId) then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(mSchedulerId)
		mSchedulerId= nil
	end

	if(nAddedItemNum == 0) then
		return 
	end
	logger:debug(nAddedItemNum)
	local propsInfo  = _tbStuffInfo[_nStuffIndex]

	local params = CCArray:create()
	--附魔装备的i_id
	local item_id = CCInteger:create(tonumber(m_EnchantEquipInfo.item_id))
	params:addObject(item_id)
	--材料的i_id
	local stuffIdParams = CCArray:create()
	local stuff_id = CCInteger:create(tonumber(propsInfo.item_id))
	stuffIdParams:addObject(stuff_id)	
	params:addObject(stuffIdParams)	
	--材料的个数
	local stuffNumParams = CCArray:create()
	local stuff_Num = CCInteger:create(tonumber(nAddedItemNum))
	stuffNumParams:addObject(stuff_Num)
	params:addObject(stuffNumParams)
	params:retain()

	PreRequest.setBagDataChangedDelete(function ( ... )
		EquipFixCtrl.enchantFromBagDeleget()
		LayerManager:begainRemoveUILoading()
	end )

	logger:debug(params)
	-- MainFormationTools.removeFlyText()
	LayerManager:addUILoading()
	logger:debug("向后端发送请求吧少年")

	performWithDelayFrame(m_MainUI,function(  )
			RequestCenter.forge_enchant (function (cbFlag, dictData, bRet)
				EquipFixCtrl.doCallbackEnchantforce(cbFlag, dictData, bRet)
			end  , params)
				params:release()
	end,15)



	nAddedItemNum = 0
end

function setLoadProgress( ... )
	logger:debug(m_nCurMolExp)
	logger:debug(m_nCurDemExp)
	local percent = (m_nCurMolExp / m_nCurDemExp) * 100
	LOAD_PROGRESS:setPercentage(percent > 100 and 100 or percent)
end

function updateItemExpFuc(index,sender)
	logger:debug("updateItemExpFuc" .. index)
	local propsInfo  = _tbStuffInfo[index]
	
		-- 1.	该附魔石用完
	if(propsInfo.item_num == 0) then
		nAddedItemNum = nAddedItemNum - 1
		logger:debug({propsInfo =  propsInfo})
		PublicInfoCtrl.createItemDropInfoViewByTid( propsInfo.tid,fnFreshUI)       
		ShowNotice.showShellInfo(m_i18n[1631]) --
		stopSceduler()
		return
	end

	local nExpAdded = propsInfo.base_exp * nAddedItemNum
	local expAllNeeded = EquipFixModel.getAllExpToCurLevel()
	--从当前等级附魔到下一等级需要的经验
	local expNeedFromCurToNextLevel = EquipFixModel.getEnchatExpByNextLevel()
	--当前附魔等级多余出来的经验
	local curExp = EquipFixModel.getAllExp() - expAllNeeded
	--一共的经验  =   以前剩余的 + 材料提供
	logger:debug(curExp)
	logger:debug(nExpAdded)
	local expTotle = curExp + nExpAdded
	-- 减少对应的物品数量
	propsInfo.item_num = propsInfo.item_num - 1
	--更新相应的附魔道具的数量
	setItemLabelNum(propsInfo.itemParent,propsInfo.item_num)
	--更新经验数值
	m_nCurMolExp =  expTotle
	m_nCurDemExp =  expNeedFromCurToNextLevel

	setProGress()
	--更新经验条
	setLoadProgress()
	showFlyAni(sender)

	if(expTotle >= expNeedFromCurToNextLevel) then
		--停止计时器，向后端发送请求
		m_levenUPValue  = 1
		m_bForceAniOvered = false
		logger:debug(m_bForceAniOvered)
		stopSceduler()
		return true
	end
	return false
end

function setProGress()
	if(m_MainUI == nil) then
		return 
	end
	LABN_OWN_PROGRESS:setText(m_nCurMolExp .. "/" .. m_nCurDemExp)
	local txt = m_nCurMolExp .. "/" .. m_nCurDemExp
	logger:debug(txt)
	-- UIHelper:labelNewStroke(LABN_OWN_PROGRESS)
	UIHelper.labelNewStroke(LABN_OWN_PROGRESS, ccc3(0x28,0x00,0x00), 2 )
end

--播放显示提示，该提示2s后渐隐。
local function playTipAction()
	logger:debug("playTipAction")
	_tipLabel:stopAllActions()
	_tipLabel:setVisible(true)
	_tipLabel:setOpacity(255)
	local render = _tipLabel:getVirtualRenderer()
	render:stopAllActions()
	local actionArr = CCArray:create()
	actionArr:addObject(CCFadeTo:create(2.0, 0))
	actionArr:addObject(CCCallFunc:create(function (  )
		_tipLabel:setVisible(false)
    	_tipLabel:setOpacity(255)
	end))
	if render then
		local sp = tolua.cast(render, "CCSprite")
		sp:runAction(CCSequence:create(actionArr))
	end


    -- UIHelper.widgetFadeTo(_tipLabel,2.0,0,function ()
    -- 	_tipLabel:setVisible(false)
    -- 	_tipLabel:setOpacity(255)
    -- end)
end

function setItemLabelNum( item_parent,itemNum )

	local labText = item_parent.TFD_STONE_NUM
	local IMG_NO_STONE = item_parent.IMG_NO_STONE
	IMG_NO_STONE:setEnabled(false)

	labText:setText("" .. itemNum or 0)
	UIHelper.labelNewStroke(labText,ccc3(0x28, 0x00, 0x00))
	labText:setColor(g_QulityColor2[2])

	if(itemNum == 0) then
		labText:setColor(g_QulityColor2[7])
		IMG_NO_STONE:setEnabled(true)
	end
end

--初始化材料列表
function setStuffListView()
	local lsv = m_MainUI.LSV_MAIN
	UIHelper.initListView(lsv)
	lsv:setItemsMargin(1)
	lsv:setTouchEnabled(false)
	local cellWidth = lsv:getSize().width / (#_tbStuffInfo - 1)
	-- logger:debug(_tbStuffInfo)
	for i=1,#_tbStuffInfo do
		lsv:pushBackDefaultItem()
		local propsInfo  = _tbStuffInfo[i]
		local item = lsv:getItem(i - 1)
		local num = propsInfo.item_num
		propsInfo.itemParent = item

		setItemLabelNum(propsInfo.itemParent,num)
 		local itemBgImage = m_fnGetWidget(item,"IMG_QUALITY")
 		itemBgImage:loadTexture("images/common/enchant_stone/enhance_stone_" .. propsInfo.quality .. ".png")

 		local itemImage = m_fnGetWidget(item,"IMG_ICON")
 		itemImage:loadTexture(propsInfo.picPath)
 		itemImage:setTouchEnabled(true)
 		itemImage:setTag(i)
 		itemImage:addTouchEventListener(function( sender, eventType )
						local itemNum = propsInfo.item_num
						_nStuffIndex = i
						if (eventType == TOUCH_EVENT_ENDED) then
							AudioHelper.playCommonEffect()
							logger:debug("TOUCH_EVENT_ENDED")
							logger:debug("nAddedItemNum")
							logger:debug(nAddedItemNum)
							if(nAddedItemNum > 0 and nAddedItemNum < 2) then
								playTipAction()	
							end
							stopSceduler()
						elseif (eventType == TOUCH_EVENT_BEGAN) then
							m_levenUPValue = 0
							local isMax = EquipFixModel.isEnchantLvLimited()
							local maxEnchantLv = EquipFixModel.getMaxEnchatLevel()
							if (maxEnchantLv == 0) then
								ShowNotice.showShellInfo(m_i18n[5220])
								return 
							elseif(isMax == true) then
								ShowNotice.showShellInfo(m_i18n[5218])
								return
							elseif(itemNum <= 0) then
								logger:debug({createItemDropInfoViewByTid = propsInfo})
								PublicInfoCtrl.createItemDropInfoViewByTid( propsInfo.tid,fnFreshUI) 
								ShowNotice.showShellInfo(m_i18n[1631]) --附魔石不足，无法附魔
								local reBuildFn = m_tbEvent.reBuildModule
								reBuildFn()
								return 
							else
								logger:debug("TOUCH_EVENT_BEGAN")
								nAddedItemNum = 1
								local bUpLevel = updateItemExpFuc(i,sender)
								if(bUpLevel == false)then
									mSchedulerId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(function()
									nAddedItemNum = nAddedItemNum + 1
									updateItemExpFuc(i,sender)
										end, 1/5, false)
								end
							end
						elseif(eventType == TOUCH_EVENT_MOVED) then
							local bFocus = sender:isFocused()
							if(bFocus) then
							else
								logger:debug(mSchedulerId)
								stopSceduler()
							end
						elseif (eventType == TOUCH_EVENT_CANCELED) then 
							logger:debug(mSchedulerId)
							logger:debug("TOUCH_EVENT_CANCELED")
							stopSceduler()
						
						end
			end
			)
		item.tfd_exp_num:setText("+" .. propsInfo.base_exp)
	end
end

function fnFreshUI()
	 _tbStuffInfo = EquipFixModel.setFixStuff()
	setStuffListView()
end

function initUI(bRefresh)
	if(m_MainUI == nil) then
		return 
	end
	m_tbAllItem = nil 
	m_tbAllItem = {}

	curEnchantLv = EquipFixModel.getEquipEnchatLevel()
	maxEnchantLv = EquipFixModel.getMaxEnchatLevel()

	--设置经验数值
	setExpValue()
	setProGress()
	local percent = (m_nCurMolExp / m_nCurDemExp) * 100

	LOAD_PROGRESS:setPercentage(percent > 100 and 100 or percent)

	--初始化装备的基本信息
	setEquipEnchantLV()
	--初始化装备的属性加成
	setAttrUI()

	local name = EquipFixModel.getEquipNameByTid()
	local img_attrbg1 = m_fnGetWidget(m_MainUI,"img_attrbg1")	
	local img_attrbg2 = m_fnGetWidget(m_MainUI,"img_attrbg2")

	local itemDesc 				= DB_Item_arm.getDataById(m_EnchantEquipInfo.item_template_id)
	local nQuality   			= itemDesc.quality 
	img_attrbg2.TFD_EQUIP_NAME:setColor(g_QulityColor2[tonumber(nQuality)])
	img_attrbg1.TFD_EQUIP_NAME:setColor(g_QulityColor2[tonumber(nQuality)])

	UIHelper.labelAddNewStroke(img_attrbg1.TFD_EQUIP_NAME,name)
	UIHelper.labelAddNewStroke(img_attrbg2.TFD_EQUIP_NAME,name)

	UIHelper.labelAddNewStroke(img_attrbg1.TFD_LV,m_i18n[1067])
	UIHelper.labelAddNewStroke(img_attrbg2.TFD_LV,m_i18n[1067])

	UIHelper.labelAddNewStroke(img_attrbg1.TFD_LV_NUM_BEFORE,"" .. curEnchantLv)

	local dbMaxEnchantLv =EquipFixModel.getDBMacEnchantLevel()
	local nNextLv = (curEnchantLv + 1) > dbMaxEnchantLv and dbMaxEnchantLv or (curEnchantLv + 1)
	UIHelper.labelAddNewStroke(img_attrbg2.TFD_LV_NUM_AFTER , "" .. nNextLv)

	--若附魔等级达到了maxEnchantLV的最终上限，则隐藏中间的箭头和右侧的背景图和属性的所有内容。
	if(curEnchantLv >= dbMaxEnchantLv) then
		m_MainUI.IMG_ARROW_MAIN:setEnabled(false)
		m_MainUI.img_attrbg2:setEnabled(false)
	end
end 

function setAdventLabel(  )
	UIHelper.labelNewStroke(m_MainUI.TFD_INFO,ccc3(0x28,0x00,0x00), 2 )
	local tbUnlockInfo = EquipFixModel.getEquipLockEnchantAffix()
	logger:debug(tbUnlockInfo)
	if(table.count(tbUnlockInfo) == 0)then
		m_MainUI.IMG_ABILITY:setEnabled(false)
		m_MainUI.TFD_INFO:setEnabled(false)
	else
		local strUnlock = ""
		local nNextLv = 0
		for i,v in ipairs(tbUnlockInfo) do
			strUnlock = strUnlock .. v.descName ..v.descString
			if(i<#tbUnlockInfo) then
				strUnlock = strUnlock .. ","
			end 
			nNextLv = v.openLv

			--加入到升级的时候飘字效果里
			if(nNextLv - curEnchantLv == 1) then
				local attrInfo = {}
				attrInfo.txt 			= v.descName 
				attrInfo.num  			= tonumber(v.realNum )
				attrInfo.displayNumType	= v.affixType
				table.insert(m_tbAttrValue,attrInfo)
				logger:debug(m_tbAttrValue)
			end

		end
		strUnlock = strUnlock .. "(" .. nNextLv .. "级解锁)"
		m_MainUI.TFD_INFO:setText(strUnlock)
	end
end

--更新经验条
function updateAddExpBar(addExp)
	logger:debug(addExp)
	if(addExp > 0) then
		local percent = ((m_nCurMolExp ) / m_nCurDemExp) * 100
		percent = percent > 100 and 100 or percent

	else
	end
end

--设置装备的当前附魔等级和最大附魔等级
function setEquipEnchantLV( ... )
	local  TFD_LV1 = m_fnGetWidget(m_MainUI,"TFD_LV1")
	TFD_LV1:setText(curEnchantLv .. "/" .. maxEnchantLv)

	UIHelper.labelNewStroke(TFD_LV1)	

	TFD_LV_NUM_BEFORE:setText(tostring(curEnchantLv))
	local nNextLv = (curEnchantLv + 1) > maxEnchantLv and maxEnchantLv or (curEnchantLv + 1)
	TFD_LV_NUM_AFTER:setText(tostring(nNextLv))
end


--设置添加按钮的状态
function setAddBTNState(b_autoAdd)
	if(b_autoAdd) then
		m_btnAutoAdd:setTag(E_TAG_AUTOADD)  --1为自动添加状态，2为取消自动加添状态 
		UIHelper.titleShadow(m_btnAutoAdd,m_i18n[1055])
	else
		m_btnAutoAdd:setTag(E_TAG_CACALAUTO)  --1为自动添加状态，2为取消自动加添状态 
		UIHelper.titleShadow(m_btnAutoAdd,m_i18n[5205])
	end
end

function showFlyAni( sender  ,flyCall)
	-- addSelectFlag(sender) -- zhangqi, 2015-06-26, 显示选中标记
	local pPosSender = ccp(sender:getPositionX(),sender:getPositionY())
	local pStartPos = sender:getParent():convertToWorldSpace(pPosSender)
	local pSize = sender:getSize()
	local pTag = sender:getTag()
	local equipInfo = EquipFixModel.getItemInfoByIndex(tonumber(pTag) )
	local item_tid = equipInfo.tid
	local pSprite = ItemUtil.createBtnByTemplateId(item_tid)

	pSprite:setPositionX(pStartPos.x + pSize.width*0.5)
	pSprite:setPositionY(pStartPos.y + pSize.height*0.5)
	pSprite:setScale(0.8)
	m_MainUI:addChild(pSprite,11111111)

	local pArr = CCArray:create()
	local pTime = 22/60
	local pmove = CCMoveTo:create(pTime,m_FinalPos)
	local pscale = CCScaleTo:create(pTime,0.3)
	local pSpawn = CCSpawn:createWithTwoActions(pmove,pscale)
	pArr:addObject(pSpawn)
	pArr:addObject(CCCallFuncN:create(
		function( ... )
			pSprite:removeFromParentAndCleanup(true)
			if(flyCall) then
				flyCall()
			end
		end))
	pSprite:runAction(CCSequence:create(pArr))
end


function stopAllActions(  )
	m_CUR_ENCHANT_LV:removeAllNodes()
	m_IMG_EFFECT:removeAllNodes()
	m_IMG_EQUIP:removeAllNodes()
	MainFormationTools.removeFlyText()
	local runningScene = CCDirector:sharedDirector():getRunningScene()
	runningScene:removeChildByTag(1111, true)
end

