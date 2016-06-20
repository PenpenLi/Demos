-- FileName: MainDestinyView.lua
-- Author:  lizy
-- Date: 2014-04-00
-- Purpose: 天命模块的View
--[[TODO List]]

module("MainDestinyView", package.seeall)

require "script/module/destiny/MainDestinyData"
require "script/model/user/UserModel"
require "script/module/public/UIHelper"
require "db/i18n"
require "script/module/config/AudioHelper"
require "script/module/main/PlayerPanel"
require "script/module/main/TopBar"
require "script/module/destiny/MainDestinyShipData"

-- UI控件引用变量 --
local m_layMain
local m_shipImg  --船形象

-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString = gi18nString
local m_fnGetWidget = g_fnGetWidgetByName

local destinyInfo --修炼配置数据
local tbFlayText = {}  --存储飘字特效的属性
local tbTipNode = {}   --保存当前添加的飘字节点
local tbFightValue = {} --保存每次改造的战斗力前后值

local nShipTag = 1122  --船动画tag
local nShuilangTag = 1123  --水浪tag
               
local tbLabelProperty = {}--当前属性
local tbLabelPropertyAdd = {} --下一级增加的属性
local tbBeforeNum = {}  --改造前属性
local tbAfterNum = {}   --改造后属性



local function init(...)
	tbLabelProperty = {}
	tbLabelPropertyAdd = {}
	tbBeforeNum = {}
	tbAfterNum = {}
	tbFlayText = {}
	tbTipNode = {}
	tbFightValue = {}

end

function destroy(...)
	MainFormationTools.removeFlyText()
	package.loaded["MainDestinyView"] = nil
end

function moduleName()
	return "MainDestinyView"
end

function create( tbEvent)
	init()

	m_layMain = g_fnLoadUI("ui/destiny_main.json")
	m_shipImg = m_fnGetWidget(m_layMain, "IMG_PLAYER")  --船形象
	--信息板子缩放
	local lay_need = m_fnGetWidget(m_layMain, "LAY_NEED")  
	lay_need:setScale(g_fScaleX)
	--背景图缩放
	local img_bg = m_fnGetWidget(m_layMain, "img_bg")  
	img_bg:setScaleX(g_fScaleX)

	initPropertyLabel()

	refreashShip()
	
	initButtons(tbEvent)
	
	setPropertys()  --每个突破等级增加的属性
	
	setBaseInfo()   --突破消耗信息
	
	setGrowpPerperty() --修炼属性

	initInternal()

	-- 退出时删除特效资源
	UIHelper.registExitAndEnterCall(m_layMain, function ( ... )
		UIHelper.removeArmatureFileCache()
	end)

	return m_layMain
end

function initPropertyLabel( ... )
	--修炼属性 ＝ 主船本身属性＋改造属性
	local tfdHeroHpCpNum = m_fnGetWidget(m_layMain, "TFD_BLOOD_NUM", "Label") --生命
	local tfdHeroPhyAttackCpNum = m_fnGetWidget(m_layMain, "TFD_WUGONG_NUM", "Label") --物攻 
	local tfdHeroMagicAttackCpNum = m_fnGetWidget(m_layMain, "TFD_MOGONG_NUM", "Label") --魔攻
	local tfdHeroPhyDefendCpNum = m_fnGetWidget(m_layMain, "TFD_WUFANG_NUM", "Label") --物防
	local tfdHeroMagicDefendCpNum = m_fnGetWidget(m_layMain, "TFD_MOFANG_NUM", "Label") --魔防
	tbLabelProperty = {tfdHeroHpCpNum,tfdHeroPhyAttackCpNum,tfdHeroMagicAttackCpNum,tfdHeroPhyDefendCpNum,tfdHeroMagicDefendCpNum}

	local tfdHpNum = m_fnGetWidget(m_layMain, "TFD_BLOOD_NUM_ADD", "Label") --生命
	local tfdPhyAttackNum = m_fnGetWidget(m_layMain, "TFD_WUGONG_NUM_ADD", "Label") --物攻
	local tfdMagicAttackNum = m_fnGetWidget(m_layMain, "TFD_MOGONG_NUM_ADD", "Label") --魔攻
	local tfdPhyDefendNum = m_fnGetWidget(m_layMain, "TFD_WUFANG_NUM_ADD", "Label") --物防
	local tfdMagicDefendNum = m_fnGetWidget(m_layMain, "TFD_MOFANG_NUM_ADD", "Label") --魔防
	tbLabelPropertyAdd = {tfdHpNum,tfdPhyAttackNum,tfdMagicAttackNum,tfdPhyDefendNum,tfdMagicDefendNum}
end

-- 纪录改造前后的属性值
function rememberProperty( type )
	local cell = {}
	-- 生命
	local shipAdd = MainDestinyShipData.getHp()
	local markAdd = MainDestinyData.getHp()
	markAdd = markAdd + shipAdd
	cell[#cell+1] = markAdd

	--物攻
	local shipAdd = MainDestinyShipData.getPhyAttack()
	local markAdd = MainDestinyData.getPhyAttack()
	markAdd = markAdd + shipAdd
	cell[#cell+1] = markAdd

	--魔攻
	local shipAdd = MainDestinyShipData.getMagAttack()
	local markAdd = MainDestinyData.getMagAttack()
	markAdd = markAdd + shipAdd
	cell[#cell+1] = markAdd

	--物防
	local shipAdd = MainDestinyShipData.getPhyDefend()
	local markAdd = MainDestinyData.getPhyDefend()
	markAdd = markAdd + shipAdd
	cell[#cell+1] = markAdd

	--魔防
	local shipAdd = MainDestinyShipData.getMagDefend()
	local markAdd = MainDestinyData.getMagDefend()
	markAdd = markAdd + shipAdd
	cell[#cell+1] = markAdd


	if(type==1)then 
		table.insert(tbBeforeNum,cell)
	else 
		table.insert(tbAfterNum,cell)
	end 
end

--船形象和船名字更新
function refreashShip( ... )
	local tbShipInfo = MainDestinyShipData.getShipInfo()
	m_shipImg:setVisible(false)

	local lay_main = m_fnGetWidget(m_layMain, "LAY_MAIN")
	local ship_grah = 0
	if MainDestinyShipData.getShipGraph() > 1 then 
		ship_grah = MainDestinyShipData.getShipGraph()
	end 

	local tbShipPos = ccp(m_shipImg:getPositionX(),m_shipImg:getPositionY())
	local tbShipAnchor = ccp(m_shipImg:getAnchorPoint().x,m_shipImg:getAnchorPoint().y)
	UIHelper.addShipAnimation(lay_main,ship_grah,tbShipPos,tbShipAnchor,0.9,nShipTag,nShuilangTag)

	--名字
	local imgShipName = m_fnGetWidget(m_layMain, "IMG_SHIP_NAME")
	imgShipName:loadTexture("images/ship/ship_name/ship" .. MainDestinyShipData.getShipGraph() .. "_name.png")

end

--初始化按钮
function initButtons( tbEvent )
	local btnBack = m_fnGetWidget(m_layMain,"BTN_BACK","Button")   --返回按钮
	UIHelper.titleShadow(btnBack, m_i18n[1019])
	btnBack:addTouchEventListener(tbEvent.onBacks)   
	btnBack:setTag(1)

	local btnTrain = m_fnGetWidget(m_layMain,"BTN_TRAIN","Button")  --修炼按钮
	btnTrain:addTouchEventListener(tbEvent.onTrain)  
	btnTrain:setTag(2)
end

-- 增加国际化和描边 
function initInternal( ... )
	local tfdBloodName = m_fnGetWidget(m_layMain, "TFD_BLOOD_NAME")  --生命
	UIHelper.labelAddStroke(tfdBloodName,m_i18n[1047] )
	tfdBloodName:setFontSize(22)

	local tfdWugongName = m_fnGetWidget(m_layMain, "TFD_WUGONG_NAME")   --物攻
	UIHelper.labelAddStroke(tfdWugongName,m_i18n[1048] )
	tfdWugongName:setFontSize(22)
	
	local tfdMogongName = m_fnGetWidget(m_layMain,"TFD_MOGONG_NAME")  --魔攻
	UIHelper.labelAddStroke(tfdMogongName,m_i18n[1049] )
	tfdMogongName:setFontSize(22)
	
	local tfdWufangName = m_fnGetWidget(m_layMain,"TFD_WUFANG_NAME")  --物防
	UIHelper.labelAddStroke(tfdWufangName,m_i18n[1050] )
	tfdWufangName:setFontSize(22)
	
	local tfdMofangName = m_fnGetWidget(m_layMain,"TFD_MOFANG_NAME")  --魔防
	UIHelper.labelAddStroke(tfdMofangName,m_i18n[1051] )
	tfdMofangName:setFontSize(22)

end

--初始化 突破消耗
function setBaseInfo()
	destinyInfo = MainDestinyData.getDestinyById(MainDestinyData.getNextDestinyId())  --下一突破等级信息
	
	local costCopystar = m_fnGetWidget(m_layMain, "TFD_NEED_STAR", "Label")--修炼需要消耗副本星
	costCopystar:setText("×"..destinyInfo.costCopystar) --设置消耗副本星星数
	UIHelper.labelAddStroke(costCopystar,"×"..destinyInfo.costCopystar )

	local silverCost = m_fnGetWidget(m_layMain, "TFD_NEED_MONEY", "Label")--修炼消耗money
	silverCost:setText(destinyInfo.silverCost)  --设置消耗多少money
	UIHelper.labelAddStroke(silverCost,destinyInfo.silverCost,nil, nil) 
	
	local curDestinyInfo = MainDestinyData.getDestinyInfo() --当前突破等级主船信息
	local itemCopyStar = m_fnGetWidget(m_layMain, "TFD_STAR_OWN", "Label")  --当前拥有副本星数目
	itemCopyStar:setText("×" .. curDestinyInfo.left_score)
	UIHelper.labelAddStroke(itemCopyStar,"×" .. curDestinyInfo.left_score,nil, nil)
	UIHelper.labelNewStroke(itemCopyStar) --描边

	local level = m_fnGetWidget(m_layMain, "TFD_LV_NOW")  --当前改造等级
	UIHelper.labelAddStroke(level,(MainDestinyData.getNextDestinyId()-1),nil, nil)
	UIHelper.labelNewStroke(level) --描边

	if (MainDestinyData.getIsBreak() == true) then 
		refreashShip()
	end 

	local time = MainDestinyData.getTimeForBreak()   --还有多少次可突破
	if tonumber(time) == -1 then
		local lay_tupo = m_fnGetWidget(m_layMain, "lay_tupo_fit")
		lay_tupo:setVisible(false)
	else
		local itemDesc_ = m_fnGetWidget(m_layMain, "TFD_RENEW_TIMES", "Label") 
		itemDesc_:setText(tostring(time))
		UIHelper.labelStroke(itemDesc_)

		local newShipName = m_fnGetWidget(m_layMain, "TFD_GAIN_SHIP", "Label")  --突破后新船名称
		newShipName:setText(MainDestinyShipData.getNextShipName())
		UIHelper.labelStroke(newShipName)
	end
end

-- 设置当前增加属性是否可见
function setAddPropertysVisible( isRet )
	for i=1,5 do 
		tbLabelPropertyAdd[i]:setVisible(isRet)
	end 
end

--当前改造属性加成，绿字
function setPropertys( ... )
	local tbName = { m_i18n[1068],m_i18n[1069],m_i18n[1070],m_i18n[1071],m_i18n[1072]}  --"生命","物攻","魔攻","物防","魔防"
	local function getIndex( name )
		local index = nil
		for i=1,#tbName do 
			if (name==tbName[i]) then 
				index = i
				break
			end 
 		end 

 		return index
	end

	destinyInfo = MainDestinyData.getDestinyById(MainDestinyData.getNextDestinyId())

	for i=1,5 do 
		tbLabelPropertyAdd[i]:setVisible(false)
		tbLabelPropertyAdd[i]:setFontSize(22)
	end 

	if not destinyInfo.attArr then 
		return
	end 	
	
	local attArr = string.split(destinyInfo.attArr, ",")
	local tableLength = table.getn(attArr)

	local cell = {}
	for i=1,tableLength do 
		local attArrs = string.split(attArr[i], "|")
		local name = MainDestinyData.getAffix(attArrs[1])

		local markAdd = attArrs[2]
		if tonumber(name.type) == 2 then
			markAdd = markAdd / 100
		end

		local index = getIndex(name.sigleName)
		tbLabelPropertyAdd[index]:setVisible(true)
		tbLabelPropertyAdd[index]:setText("+" .. markAdd)
		UIHelper.labelAddStroke(tbLabelPropertyAdd[index],"+"..markAdd,nil, nil)
		tbLabelPropertyAdd[index]:setFontSize(22)

		-- 飘字效果
		local o_text = {}
		o_text.txt = name.sigleName
		o_text.num = markAdd
		o_text.key = index
		table.insert(cell, o_text)
	end

	if(table.getn(cell)>0)then 
		table.insert(tbFlayText,cell) 
	end 
end


--修炼属性
function setGrowpPerperty()
	-- 修炼属性 ＝ 主船本身属性＋改造属性

	--生命
	local shipAdd = MainDestinyShipData.getHp()
	local markAdd = MainDestinyData.getHp()
	markAdd = markAdd + shipAdd
	tbLabelProperty[1]:setText(markAdd)
	UIHelper.labelAddStroke(tbLabelProperty[1],markAdd,nil, nil)
	tbLabelProperty[1]:setFontSize(22)
	--物攻
	local shipAdd = MainDestinyShipData.getPhyAttack()
	local markAdd = MainDestinyData.getPhyAttack()
	markAdd = markAdd + shipAdd
	tbLabelProperty[2]:setText(markAdd )
	UIHelper.labelAddStroke(tbLabelProperty[2],markAdd,nil, nil)
	tbLabelProperty[2]:setFontSize(22)

	--魔攻
	local shipAdd = MainDestinyShipData.getMagAttack()
	local markAdd = MainDestinyData.getMagAttack()
	markAdd = markAdd + shipAdd
	tbLabelProperty[3]:setText(markAdd)
	UIHelper.labelAddStroke(tbLabelProperty[3],markAdd,nil, nil)
	tbLabelProperty[3]:setFontSize(22)

	--物防
	local shipAdd = MainDestinyShipData.getPhyDefend()
	local markAdd = MainDestinyData.getPhyDefend()
	markAdd = markAdd + shipAdd
	tbLabelProperty[4]:setText(markAdd)
	UIHelper.labelAddStroke(tbLabelProperty[4],markAdd,nil, nil)
	tbLabelProperty[4]:setFontSize(22)

	--魔防
	local shipAdd = MainDestinyShipData.getMagDefend()
	local markAdd = MainDestinyData.getMagDefend()
	markAdd = markAdd + shipAdd
	tbLabelProperty[5]:setText(markAdd)
	UIHelper.labelAddStroke(tbLabelProperty[5],markAdd,nil, nil)
	tbLabelProperty[5]:setFontSize(22)
end
 
-- 属性增加 数字滚动特效
local function fnPlayOneNumChangeAni( pLabel , pSNum , pFNum)

	if(not pLabel or not pSNum or not pFNum) then
		return
	end
	if(tonumber(pSNum) == tonumber(pFNum)) then
		return
	end

	local totleCount = 20
	local pTime = 0.02
	local play_count = 0
	local ptb =  MainFormationTools.getNumber(pFNum)
	local pRunAction = nil

	local function changeLabel()
		local pStr = ""
		for i=1,#ptb do
			local pY = math.random(0,tonumber(ptb[i]))
			if(i == #ptb and pY == 0) then
				pY = 1
			end 
			pStr =  pY .. pStr
		end

		play_count = play_count + 1
		if(play_count >= totleCount) then
			if(pLabel.setText) then
				pLabel:setText(tostring(pFNum))
			elseif(pLabel.setStringValue) then
				pLabel:setStringValue(tostring(pFNum))
			end
			return
		end
		if(pLabel.setText) then
			pLabel:setText(pStr)
		elseif(pLabel.setStringValue) then
			pLabel:setStringValue(pStr)
		end
	end

	local arrSQ = CCArray:create()
	for i=1,totleCount do
		arrSQ:addObject( CCDelayTime:create(pTime) )
		arrSQ:addObject( CCCallFunc:create(changeLabel))
	end
	local fnSq1 = CCSequence:create(arrSQ)

	local pTT = totleCount*pTime+0.01

	local arrSQ2 = CCArray:create()
	arrSQ2:addObject( CCScaleTo:create(pTT*0.5, 1.5) )
	arrSQ2:addObject( CCScaleTo:create(pTT*0.5, 1.0) )
	local fnSq2 = CCSequence:create(arrSQ2)

	pRunAction = CCSpawn:createWithTwoActions(fnSq1,fnSq2)
	pLabel:runAction(pRunAction)
end


local function fnPlayLabelAni( key ,tbValueBefore,tbValueAfter)
	local label = tbLabelProperty[key]
	local beforeNum = tbValueBefore[key]
	local afterNum = tbValueAfter[key]
	fnPlayOneNumChangeAni(label,beforeNum,afterNum)
end 


local function flyEndCallback( ttfNode )
	if(not ttfNode)then
		return 
	end 

	ttfNode:removeFromParentAndCleanup(true)
	ttfNode = nil
end


function fnRemoveTipNode( ... )
	if(#tbTipNode==0)then 
		return
	end 

	if(not tbTipNode[1]) then
		return
	end
	tbTipNode[1]:removeFromParentAndCleanup(true)
	table.remove(tbTipNode,1)
	-- rememberProperty(1)
end


-- 改造完属性飘字动画
-- tParam:上飘的信息table，
-- callbackFunc回调方法
-- tbValueBefore 改造前属性
-- tbValueAfter 改造后属性
local  function showFlyText( tParam,callbackFunc,tbValueBefore,tbValueAfter)
	if(#tParam==0)then 
		return
	end 

	local runningScene = CCDirector:sharedDirector():getRunningScene()
	local tipLabelNode = CCNode:create()
	runningScene:addChild(tipLabelNode,999999999)
	table.insert(tbTipNode,tipLabelNode)

	local pWorldSize = runningScene:getContentSize()
	local pShowPoint = showpoint or ccp(pWorldSize.width*0.5,pWorldSize.height*0.4) --飘字起始位置
	local fontname 			= g_sFontCuYuan
	local fontsize			= 32
	local displayNumType 	= 1 --显示形式  是否除以100/%百分比显示等   add by chengliang
	local colorPlus 		= ccc3(0x00,0xff,0x06) -- { red = 0x76, green=0xfc , blue =0x06 }
	local colorMinus 		= ccc3(0xff,0x0,0x0)  -- red = 0x76, green=0xfc , blue =0x06
	local color
	local delayTime = 0.3
	local moveTime1 = 0.5
	local moveTime2 = 0.6
	for i=1, #tParam do
		fontname 		= tParam[i].fontname or fontname
		fontsize 		= tParam[i].fontsize or fontsize
		displayNumType 	= tParam[i].displayNumType or 1
		if(tonumber(tParam[i].num)>=0 ) then
			color=tParam[i].color or colorPlus
			tParam[i].txt= tParam[i].txt .. "+"
		else
			color=tParam[i].color or colorMinus
		end

		local displayNum = tParam[i].num
		if(tonumber(displayNumType) == 1)then
	    	displayNum = tParam[i].num
	    elseif(tonumber(displayNumType) == 2)then
			displayNum = tParam[i].num / 100
		elseif(tonumber(displayNumType) == 3)then
			displayNum = tParam[i].num / 100 .. "%"
	    end
		-- 文字  
		local alertContent = {}
		alertContent[1] = UIHelper.createStrokeTTF(tParam[i].txt .. displayNum,color,ccc3(0x00,0x31,0x00),nil,fontsize,fontname)
		alertContent[1]:setColor(color)
		
		local descNode = alertContent[1] 
		descNode:setAnchorPoint(ccp(0.5,0.5))
		descNode:setPosition(pShowPoint)
		descNode:setVisible(false)
		tipLabelNode:addChild(descNode)

		local nextMoveToP = ccp(pShowPoint.x, pShowPoint.y + pWorldSize.height*0.18)  --向上飘的位置
		-- 文字从下往上飘
		local actionArr = CCArray:create()
		actionArr:addObject(CCDelayTime:create(delayTime))
		actionArr:addObject(CCCallFuncN:create(function ( ... )
			descNode:setVisible(true)
		end))
		actionArr:addObject(CCEaseOut:create(CCMoveTo:create(moveTime1, nextMoveToP),2))
		-- actionArr:addObject(CCFadeOut:create(0.2))

		--文字飞到属性label的位置
		local pNode = tbLabelProperty[tParam[i].key] 
		local pTTime = 0.3 + (#tParam - i)*(0.3)
		actionArr:addObject( CCDelayTime:create(pTTime) )
		local pPoint = ccp(pNode:getPositionX(),pNode:getPositionY())
		local finalMoveToP = pNode:getParent():convertToWorldSpace(pPoint)

		local pM1 = ccp((finalMoveToP.x - nextMoveToP.x)*1/3 + nextMoveToP.x , nextMoveToP.y + ( finalMoveToP.y-nextMoveToP.y)*1/3)
		local pM2 = ccp((finalMoveToP.x - nextMoveToP.x)*2/3 + nextMoveToP.x , nextMoveToP.y + ( finalMoveToP.y-nextMoveToP.y)*2/3)

		local parray = CCArray:create()
		parray:addObject(CCMoveTo:create(moveTime2*0.5 , pM1))
		parray:addObject(CCMoveTo:create(moveTime2*0.3 , pM2))
		parray:addObject(CCMoveTo:create(moveTime2*0.2 , finalMoveToP))
		local pswq = CCSequence:create(parray)
		local ppAc = CCSpawn:createWithTwoActions(pswq , CCScaleTo:create(moveTime2 , 0.75))
		actionArr:addObject(ppAc)

		local function playAni( ... )
			fnPlayLabelAni(tParam[i].key,tbValueBefore,tbValueAfter)
			if(i == 1) then
				AudioHelper.playEffect("audio/effect/texiao_zhandouli.mp3")
			end
		end

		actionArr:addObject(CCCallFuncN:create(playAni))
		actionArr:addObject(CCCallFuncN:create(flyEndCallback)) ---- todo

		if(i==#tParam)then 
			actionArr:addObject(CCCallFuncN:create(fnRemoveTipNode))
		end

		if(i==#tParam and callbackFunc ) then -----todo
			actionArr:addObject(CCCallFuncN:create(function ( ... )
				callbackFunc()
			end))
		end
		descNode:runAction(CCSequence:create(actionArr))

		delayTime = delayTime + 0.3
	end
end 


function updateData(  )
	local pNumFinal , pNumNow = UserModel.getFightForceValueNewAndOld()
	local data ={pNumFinal,pNumNow}
	table.insert(tbFightValue,data)

	local tbValue1 = {}
	tbValue1 = table.hcopy(tbBeforeNum[1],tbValue1)  
	local tbValue2 = {}
	tbValue2 = table.hcopy(tbAfterNum[1],tbValue2) 
	table.remove(tbBeforeNum,1)
	table.remove(tbAfterNum,1)


	if(#tbFlayText>0)then 
		setPropertys()	 --下一等级增加属性
		setBaseInfo()	
		MainDestinyData.setIsBreak(false)

		local data = {}
		data = table.hcopy(tbFlayText[1],data)
		table.remove(tbFlayText,1)
		
		showFlyText(data, function ( )
			-- setGrowpPerperty() --修炼属性 
			MainFormationTools.removeFlyText() --删除战斗力节点
			local tbData = {}
			table.hcopy(tbFightValue[1],tbData)
			table.remove(tbFightValue,1)
			MainFormationTools.fnShowFightForceChangeAni(nil,nil,tbData)
		end , tbValue1,tbValue2 ) 
	else 
		setPropertys()	 --下一等级增加属性
		setBaseInfo()	 
		setGrowpPerperty() --修炼属性
		MainDestinyData.setIsBreak(false)
 
		MainFormationTools.removeFlyText() --删除战斗力节点
		local tbData = {}
		table.hcopy(tbFightValue[1],tbData)
		table.remove(tbFightValue,1)
		MainFormationTools.fnShowFightForceChangeAni(nil,nil,tbData)
	end 
end

--打造动画
function showEffect( )

	local animation1 = nil 
	local animation2 = nil
	local animation3 = nil
	local function fnMovementCallBack( armature,movementType,movementID )
		if(movementType == 1) then
			if (armature == animation2) then 
				local btnTrain = m_fnGetWidget(m_layMain, "BTN_TRAIN")
				local btnBack = m_fnGetWidget(m_layMain, "BTN_BACK")
				btnTrain:setTouchEnabled(true) 
				btnBack:setTouchEnabled(true)
				updateData()
			end 

			if (armature ==  animation3) then 
				local btnTrain = m_fnGetWidget(m_layMain, "BTN_TRAIN")
				local btnBack = m_fnGetWidget(m_layMain, "BTN_BACK")
				btnTrain:setTouchEnabled(true) 
				btnBack:setTouchEnabled(true)
				MainDestinyCtrl.transferAnimation()	
			end 

			armature:removeFromParentAndCleanup(true)
			armature = nil
		end
	end

	local function fnFrameMnetCallBack( bone,frameEventName,originFrameIndex,currentFrameIndex )
		if (frameEventName == "qh4_21") then
			addAnimation2()
		end 

		if(frameEventName== "1") then   --主船突破乱砸特效关键帧
			updateData()
		end 
	end

	--锤子动画
	local function addAnimation1( ... )
		AudioHelper.playEffect("audio/effect/texiao02_chuizi.mp3")
		animation1 = UIHelper.createArmatureNode({
			filePath = "images/effect/forge/UI_20_hammer/qh4.ExportJson",
			animationName = "qh4",
			loop = 0,
			fnMovementCall = fnMovementCallBack,
			fnFrameCall = fnFrameMnetCallBack,
			bRetain = true,
		})

		local lay_main = m_fnGetWidget(m_layMain, "LAY_MAIN")
		lay_main:addNode(animation1)
		animation1:setZOrder(1000)
		animation1:setPosition(ccp(m_shipImg:getPositionX(), m_shipImg:getPositionY()))
		animation1:setAnchorPoint(ccp(m_shipImg:getAnchorPoint().x,m_shipImg:getAnchorPoint().y))
	end

	--锤子砸下的火花动画
    function addAnimation2( ... )
		AudioHelper.playEffect("audio/effect/texiao01_qianghua.mp3")
		animation2 = UIHelper.createArmatureNode({
			filePath = "images/effect/forge/UI_15/qh.ExportJson",
			animationName = "qh",
			loop = 0,
			fnFrameCall = nil,
			fnMovementCall = fnMovementCallBack,
			bRetain = true,
		})

		local lay_main = m_fnGetWidget(m_layMain, "LAY_MAIN")
		lay_main:addNode(animation2)
		animation2:setZOrder(1000)
		animation2:setPosition(ccp(m_shipImg:getPositionX(), m_shipImg:getPositionY()))
		animation2:setAnchorPoint(ccp(m_shipImg:getAnchorPoint().x,m_shipImg:getAnchorPoint().y))
		animation2:setTag(1012)
	end

	--主船突破锤子乱砸特效
    function addShipBreakAnimation( ... )
		AudioHelper.playEffect("audio/effect/texiao_jinjie1.mp3")
		animation3 = UIHelper.createArmatureNode({
			filePath = "images/effect/guild/lmbuild.ExportJson",
			animationName = "lmbuild_2",
			loop = 0,
			fnFrameCall = fnFrameMnetCallBack,
			fnMovementCall = fnMovementCallBack,
		})
		
		local lay_main = m_fnGetWidget(m_layMain, "LAY_MAIN")
		lay_main:addNode(animation3)
		animation3:setZOrder(1000)
		animation3:setPosition(ccp(m_shipImg:getPositionX(), m_shipImg:getPositionY()))
		animation3:setAnchorPoint(ccp(m_shipImg:getAnchorPoint().x,m_shipImg:getAnchorPoint().y))
	end
	
	if (MainDestinyData.getIsBreak() == true) then
		addShipBreakAnimation()
	else
		addAnimation1()
	end 
end

--打造成功刷新
function updateInfo()
	local btnTrain = m_fnGetWidget(m_layMain, "BTN_TRAIN")
	local btnBack = m_fnGetWidget(m_layMain, "BTN_BACK")
	btnTrain:setTouchEnabled(false)
	btnBack:setTouchEnabled(false)
	setAddPropertysVisible(false) 
	showEffect()
end

function stopAllAction( ... )
	-- 删除属性飘字动画
	for k,v in pairs(tbTipNode) do 
		v:stopAllActions()
		v:removeFromParentAndCleanup(true)
		v = nil
	end 
	tbTipNode = {}  
	--删除战斗力动画
	MainFormationTools.removeFlyText()  

end

