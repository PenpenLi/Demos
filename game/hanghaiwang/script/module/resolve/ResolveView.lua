-- FileName: ResolveView.lua
-- Author:zhangjunwu
-- Date: 2014-05-27
-- Purpose: 分解界面view
--[[TODO List]]

module("ResolveView", package.seeall)

-- UI控件引用变量 --
local m_layMain					= nil		--主画布
local m_btnIntroduce			= nil		--说明按钮
local m_btnClean				= nil		--清楚按钮
local m_btnShop					= nil		--神秘商店
local m_btnResolve 				= nil		--分解按钮

local m_btnAddHero				= nil 		--添加武将影子
local m_btnChangeHero			= nil		--换一组武将影子

local m_btnAddParnter			= nil 		--添加伙伴
local m_btnChangeParnter		= nil		--换一组伙伴

local m_btnAddTreas				= nil       --添加宝物
local m_btnChangeTreas			= nil      	--换一组宝物
local img_effect				= nil 		--特效父节点


local m_layItemIcon  = {lay_item1, lay_item2, lay_item3,lay_item4,lay_item5,lay_item6} -- 六个精炼item
local m_btnsItemIcon = {btn_item1,btn_item2,btn_item3,btn_item4,btn_item5,btn_item6} --6个可点击btn
local m_tfdItemName  = {TFD_ITEM_NAME1, TFD_ITEM_NAME2,TFD_ITEM_NAME3,TFD_ITEM_NAME4,TFD_ITEM_NAME5,TFD_ITEM_NAME6} -- 六个精炼item名字
local m_tfdItemNum   = {LABN_ITEM_NUM_1, LABN_ITEM_NUM_2,LABN_ITEM_NUM_3,LABN_ITEM_NUM_4,LABN_ITEM_NUM_5,LABN_ITEM_NUM_6} -- 六个精炼item数量（仅限伙伴碎片）
-- 模块局部变量 --
local m_fnGetWidget 				= g_fnGetWidgetByName
local m_i18nString 					= gi18nString

local m_ResolveHeroFrag 			= 1
local m_ResloveTreas 				= 3
local m_ResolveParnter 				= 2
local TagPlas  						= 100 					--闪烁加号的tag
local TagHeadIcon  					= 111					--icon的tag
local TagheadAnimate 				= 122					--添加到icon上的动画tag
local function init(...)

end

function destroy(...)
	m_layMain =  nil
	package.loaded["ResolveView"] = nil
end

function moduleName()
	return "ResolveView"
end
--itemname：要分解的物品，宝物，装备名字；
-- itemNameColor:名字颜色；
-- i:位置；
-- heroFragNum为影子个数，只有分解影子的时候才有
function setPlusIconName( itemname,itemNameColor , i , heroFragNum)
	--设置影子伙伴个数
	if(heroFragNum) then
		-- m_tfdItemNum[i]:setColor(itemNameColor)
		UIHelper.labelAddNewStroke(m_tfdItemNum[i], "X" .. heroFragNum,ccc3(0x28,0x20,0x20)) -- 名字描边
		m_tfdItemNum[i]:setEnabled(true)
		UIHelper.labelAddNewStroke(m_tfdItemName[i], itemname .. m_i18nString(1002),ccc3(0x28,0x00,0x00)) -- 名字描边
	else
		m_tfdItemNum[i]:setEnabled(false)
	end


	if itemNameColor then
		m_tfdItemName[i]:setEnabled(true)
		m_tfdItemName[i]:setColor(itemNameColor)
		UIHelper.labelAddNewStroke(m_tfdItemName[i], itemname,ccc3(0x28,0x00,0x00)) -- 名字描边
	else
		m_tfdItemName[i]:setEnabled(false)
	end

	local lay_item = m_fnGetWidget(m_layMain,"lay_item" .. i)
	local lay_name_bg = m_fnGetWidget(lay_item,"lay_name_bg")
	lay_name_bg:requestDoLayout()
end

function setPlusIcon( head_icon,i )

	local img_border = m_fnGetWidget(m_layItemIcon[i],"img_border" )
	local img_effect = m_fnGetWidget(m_layItemIcon[i],"img_effect" )

	img_border:removeNodeByTag(TagHeadIcon)
	img_effect:removeNodeByTag(TagPlas)

	if(head_icon)then
		head_icon:setPosition(ccp(0,-m_layItemIcon[i]:getSize().height / 2))
		head_icon:setAnchorPoint(ccp(0.5,0.0))
		img_border:addNode(head_icon,0,TagHeadIcon)
	else
		--添加+号
		local plusSprite = MainResolveCtrl.getPlusSprite()
		plusSprite:setAnchorPoint(ccp(0.5,0.5))
		plusSprite:setPosition(ccp(0,20))
		img_effect:addNode(plusSprite,0,TagPlas)
	end
end
--设置按钮的状态
function updateBtnByType( ResolveType )
	--m_btnChangeEquip:setEnabled(false)
	m_btnChangeParnter:setEnabled(false)
	m_btnChangeHero:setEnabled(false)
	m_btnChangeTreas:setEnabled(false)

	m_btnAddHero:setEnabled(true)
	m_btnAddParnter:setEnabled(true)
	m_btnAddTreas:setEnabled(true)

	if(ResolveType == m_ResolveHeroFrag) then
		m_btnAddHero:setEnabled(false)
		m_btnChangeHero:setEnabled(true)
	elseif(ResolveType == m_ResloveTreas) then
		m_btnChangeTreas:setEnabled(true)
		m_btnAddTreas:setEnabled(false)
	elseif(ResolveType == m_ResolveParnter) then
		m_btnChangeParnter:setEnabled(true)
		m_btnAddParnter:setEnabled(false)
	end

	if(ResolveType > 0 ) then
		addResoveBtnAnimate()
	else
		removeResoveBtnAnimate()
	end


end

--给分解按钮添加特效  ：只有在选中了分解的目标后才会有特效
function addResoveBtnAnimate()

	m_btnResolve:removeNodeByTag(100)

	local armature4 = UIHelper.createArmatureNode({
		filePath = "images/effect/resolve/fj4.ExportJson",
		animationName = "fj4",
		loop = -1,
	})

	m_btnResolve:addNode(armature4,0,100)
end

function removeResoveBtnAnimate()

	m_btnResolve:removeNodeByTag(100)

end

--给所有的btn添加按钮事件
local function addTouchEvent( tbBtnEvent )
	m_btnIntroduce = m_fnGetWidget(m_layMain,"BTN_DESC")
	m_btnIntroduce:addTouchEventListener(tbBtnEvent.onIntroduce)

	m_btnResolve = m_fnGetWidget(m_layMain,"BTN_DECOMPOSE")
	local BTN_ADD_EQUIP = m_fnGetWidget(m_layMain,"BTN_ADD_EQUIP")
	local BTN_CHANGE_EQUIP = m_fnGetWidget(m_layMain,"BTN_CHANGE_EQUIP")
	BTN_CHANGE_EQUIP:removeFromParent()
	BTN_ADD_EQUIP:removeFromParent()
	
	m_btnResolve:addTouchEventListener(tbBtnEvent.onResolve)
	UIHelper.titleShadow(m_btnResolve,m_i18nString(2017," "))


	m_btnAddHero = m_fnGetWidget(m_layMain,"BTN_ADD_HERO")
	m_btnAddHero:addTouchEventListener(tbBtnEvent.onAddHero)
	UIHelper.titleShadow(m_btnAddHero,m_i18nString(2018," "))

	m_btnChangeHero = m_fnGetWidget(m_layMain,"BTN_CHANGE_HERO")
	m_btnChangeHero:addTouchEventListener(tbBtnEvent.onChangeHero)
	UIHelper.titleShadow(m_btnChangeHero,m_i18nString(2022," "))

	m_btnAddTreas = m_fnGetWidget(m_layMain,"BTN_ADD_TREASURE")
	m_btnAddTreas:addTouchEventListener(tbBtnEvent.onAddTreas)
	UIHelper.titleShadow(m_btnAddTreas,m_i18nString(2019," "))
	-- m_btnAddTreas:removeFromParent()

	m_btnChangeTreas = m_fnGetWidget(m_layMain,"BTN_CHANGE_TREASURE")
	m_btnChangeTreas:addTouchEventListener(tbBtnEvent.onChangeTreas)
	UIHelper.titleShadow(m_btnChangeTreas,m_i18nString(2022," "))
	-- m_btnChangeTreas:removeFromParent()


	m_btnAddParnter = m_fnGetWidget(m_layMain,"BTN_ADD_PARTNER")
	m_btnAddParnter:addTouchEventListener(tbBtnEvent.onAddParnter)
	UIHelper.titleShadow(m_btnAddParnter,m_i18nString(2023," "))
	--m_btnAddParnter:removeFromParent()

	m_btnChangeParnter = m_fnGetWidget(m_layMain,"BTN_CHANGE_PARTNER")
	m_btnChangeParnter:addTouchEventListener(tbBtnEvent.onChangeParnter)
	UIHelper.titleShadow(m_btnChangeParnter,m_i18nString(2022," "))
	--m_btnChangeParnter:removeFromParent()

end

--[[desc:功能简介
    arg1: tbBtnEvent 按钮事件集合
    return: 是否有返回值，返回值说明  
—]]
function create(tbBtnEvent)
	m_layMain= g_fnLoadUI("ui/decompose_room.json")

	UIHelper.registExitAndEnterCall(m_layMain,function ()
		MainResolveView.stopShakeAction()
	end)
	--添加事件点击
	addTouchEvent(tbBtnEvent)
	--设置按钮的状态
	updateBtnByType(0)

	img_effect = m_fnGetWidget(m_layMain,"img_effect")

	for i = 1, 5 do
		local itemIcon = m_fnGetWidget(m_layMain,"lay_item" .. i)
		m_layItemIcon[i] = itemIcon 

		local img_light = m_fnGetWidget(itemIcon,"img_light" )
		img_light:setTouchEnabled(true)
		img_light:addTouchEventListener(tbBtnEvent.onAdd)

		local BTN_ITEM_BG = m_fnGetWidget(itemIcon,"BTN_ITEM_BG")
		BTN_ITEM_BG:removeFromParentAndCleanup(true)

		m_tfdItemName[i] = m_fnGetWidget(itemIcon,"TFD_ITEM_NAME" )
		m_tfdItemName[i]:setText("")

		m_tfdItemNum[i] = m_fnGetWidget(itemIcon,"TFD_ITEM_NUM" )
		m_tfdItemNum[i]:setEnabled(false)
	end

	performWithDelay(m_layMain,
				function(...)
    				fnLoadArmature()
    			end, 0.1)
	
	return m_layMain
end

local m_animationPath = "images/effect/resolve/"

function fnLoadArmature( ... )
	local fj1ni1 = UIHelper.createArmatureNode({
		filePath = m_animationPath  .. "fj1" .. ".ExportJson",
		bRetain = true
		}
	)
	local fj1ni12 = UIHelper.createArmatureNode({
		filePath = m_animationPath  .. "fj1_1" .. ".ExportJson",
		bRetain = true
		}
	)
	local fj1ni13 = UIHelper.createArmatureNode({
		filePath = m_animationPath  .. "fj2" .. ".ExportJson",
		bRetain = true
		}
	)
	local fj1ni14 = UIHelper.createArmatureNode({
		filePath = m_animationPath  .. "fj1_2" .. ".ExportJson",
		bRetain = true
		}
	)	
	local fj1ni15 = UIHelper.createArmatureNode({
		filePath = m_animationPath  .. "fj4" .. ".ExportJson",
		bRetain = true
		}
	)
end

--[[desc:分解的动画特效
    arg1: callback  动画播完之后的回调，显示返回物品框
    return: 是否有返回值，返回值说明  
—]]


function showAnimation( callback )

	local function keyFrameFJ1_2CallBack( bone,frameEventName,originFrameIndex,currentFrameIndex )
		logger:debug(frameEventName)
		if (frameEventName == "1") then
			TimeUtil.timeStart("keyFrameFJ1_2CallBack")

			addfj1Ani()
			TimeUtil.timeEnd("keyFrameFJ1_2CallBack")
		end
	end

	local function keyFrameFJ1CallBack( bone,frameEventName,originFrameIndex,currentFrameIndex )
		logger:debug(frameEventName)
		if (frameEventName == "2") then
			addfj1_1Ani()
			MainResolveView.doScaleShake()
		end
	end

	local function keyFrameFJ1_1CallBack( bone,frameEventName,originFrameIndex,currentFrameIndex )
		logger:debug(frameEventName)
		if (frameEventName == "3") then
			addfj2Ani()
		elseif(frameEventName == "4") then

			performWithDelay(img_effect, function ( ... )

					ResolveCtrl.m_bIsAnimationg = false
					if(m_layMain) then
						callback()
					end
			end, 0.1)
		end

	end
	
	local runningScene = CCDirector:sharedDirector():getRunningScene()
	function addfj1Ani()


		local fj1ni1 = UIHelper.createArmatureNode({
			filePath = m_animationPath  .. "fj1" .. ".ExportJson",
			fnFrameCall = keyFrameFJ1CallBack
			}
		)
		--开始震屏
		MainResolveView.startShake(runningScene,0.09,400)

		fj1ni1:setAnchorPoint(ccp(0.5,0.5))
		fj1ni1:setPosition(ccp(0,img_effect:getSize().height / 2))
		-- fj1ni1:setScaleX(g_fScaleX)
		-- fj1ni1:setScaleY(g_fScaleX)
		local fScale = g_fScaleX > g_fScaleY and g_fScaleX or g_fScaleY
		-- fj1ni1:setScale(fScale)
		img_effect:addNode(fj1ni1)
		fj1ni1:getAnimation():playWithIndex(0,-1,-1,0)
	end

	function addfj1_1Ani()
		local fj1ni1 = UIHelper.createArmatureNode({
			filePath = m_animationPath  .. "fj1_1" .. ".ExportJson",
			fnFrameCall = keyFrameFJ1_1CallBack
			}
		)
		AudioHelper.playSpecialEffect("texiao_fj1_1.mp3")
		fj1ni1:setAnchorPoint(ccp(0.5,0.5))
		fj1ni1:setPosition(ccp(0,img_effect:getSize().height / 2 + 60 ))
		fj1ni1:setScale(g_fScaleX)
		local fScale = g_fScaleX > g_fScaleY and g_fScaleX or g_fScaleY
		-- fj1ni1:setScale(fScale)
		img_effect:addNode(fj1ni1)

		fj1ni1:getAnimation():playWithIndex(0,-1,-1,0)
	end

	function addfj2Ani()
		local fj1ni1 = UIHelper.createArmatureNode({
			filePath = m_animationPath  .. "fj2" .. ".ExportJson",
		}
		)
		fj1ni1:setAnchorPoint(ccp(0.5,0.5))
		fj1ni1:setPosition(ccp(m_layMain:getSize().width / 2,m_layMain:getSize().height / 2))
		m_layMain:addNode(fj1ni1)
		fj1ni1:getAnimation():playWithIndex(0,-1,-1,0)

	end

	local armature1 = UIHelper.createArmatureNode({
		filePath = m_animationPath .. "fj1_2.ExportJson",
		animationName = "fj1_2",
		loop = 0,
		fnFrameCall = keyFrameFJ1_2CallBack,
		fnMovementCall = function ( sender, MovementEventType , frameEventName)
			if (MovementEventType == 1) then
				sender:removeFromParentAndCleanup(true)
				--删除震屏动画
				MainResolveView.stopShakeAction()

			end
		end,
	}
	)

	armature1:setAnchorPoint(ccp(0.5,0.5))
	armature1:setPosition(ccp(0,img_effect:getSize().height / 2 + 60 ))
	armature1:setScale(g_fScaleX)
	local fScale = g_fScaleX > g_fScaleY and g_fScaleX or g_fScaleY
	logger:debug(g_fScaleY)
	logger:debug(g_fScaleX)
	AudioHelper.playSpecialEffect("texiao_fj1_2.mp3")

	img_effect:addNode(armature1)
end

 
