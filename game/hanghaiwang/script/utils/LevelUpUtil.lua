-- Filename：	LevelUpUtil.lua
-- Author：		zhz
-- Date：		2013-08-15
-- Purpose：		升级的通用方法，level_up.lua
-- 增加经验值方法
module("LevelUpUtil",package.seeall)
local mFontSize = 60



--[[
	@desc	得到当前等级的经验 和 所需的经验
	@para 	id 		 : DB_Level_up_exp中的id，如宠物的id 为 3
			totalExp : 所有的经验
			level 	 : 当前的等级
	@return 当前等级下的经验 curExp 和 升级时所需需要的经验needExp
--]]
function getCurExp(  id ,totalExp,level)
	require "db/DB_Level_up_exp"
	local upExpData = DB_Level_up_exp.getDataById(tonumber(id))
	local lev= level+1
	local lv = "lv_".. lev
	local needExp = upExpData[lv]
	local curExp =0
	if(needExp == nil) then
		needExp =0
	end

	if(tonumber(level) == 0 ) then
		curExp = totalExp
	else
		for i = 1,level do
			local lv = "lv_" .. i
			totalExp= totalExp - upExpData[lv]
		end
		curExp = totalExp 
	end
	return curExp, needExp
end

-- 提供经验得到可以升到的级别
-- id: 升级经验表id
-- offerExp:提供的经验
function getLvByExp( id, offerExp)
	require "db/DB_Level_up_exp"
	local upExpData = DB_Level_up_exp.getDataById(tonumber(id))
	local curLv = 0
	local curExp = offerExp
	local needExp = 0
	while(true)do
		local nextLv = tonumber(curLv)+1
		needExp = upExpData["lv_".. nextLv]
		if(needExp ~= nil)then
			local subExp = tonumber(curExp) - tonumber(needExp)
			if(subExp >= 0)then
				curExp = subExp
				curLv = curLv + 1
			else
				break
			end
		else
			needExp = 0
			break
		end
	end
	return curLv,curExp,needExp
end

-- 解析升级表 add by Chengliang
function getNeedExpByIdAndLv( t_id, curLv )
	require "db/DB_Level_up_exp"
	local upExpData = DB_Level_up_exp.getDataById(tonumber(t_id))
	return upExpData["lv_"..curLv]
end

require "script/module/main/MainScene"

function showFloatText( tipText ,frontName, colors, time )
	local color = colors  or { red = 0xff, green=0xf6 , blue =0x00 }
	local timeInterval = time or 1

	if(frontName == nil) then
		frontName = g_sFontPangWa
	end
	
	local runningScene = CCDirector:sharedDirector():getRunningScene()

	--提示背景
	local tipNode = CCNode:create()
	-- tipNode:setScale(MainScene.elementScale)
	-- tipNode:setContentSize(CCSizeMake(g_winSize.width*0.8,g_winSize.height*0.2))
	-- tipNode:setPosition(ccp(runningScene:getContentSize().width*0.5 , runningScene:getContentSize().height*0.6))
	-- tipNode:setScale(g_fScaleX)
	runningScene:addChild(tipNode,2013)

	-- 描述 --CCLabelTTF:create(tipText, g_sFontPangWa, 34, CCSizeMake(315, 80), kCCTextAlignmentLeft, kCCVerticalTextAlignmentTop)
	local descLabel =  CCLabelTTF:create( tipText , g_sFontPangWa, 45)-- 2, ccc3(0x00, 0x00, 0x00), type_stroke)--, CCSizeMake(315*g_fScaleX,190*g_fScaleX),kCCTextAlignmentCenter,kCCVerticalTextAlignmentTop)
	descLabel:setScale(g_fScaleX)
	descLabel:setColor(ccc3(color.red,color.green,color.blue))
	descLabel:setAnchorPoint(ccp(0.5, 0))
	local width = (runningScene:getContentSize().width)/2 
	descLabel:setPosition(ccp(width, runningScene:getContentSize().height*0.6))
	descLabel:setAnchorPoint(ccp(0.5,0))
	tipNode:addChild(descLabel)

	local actionArr = CCArray:create()
	descLabel:runAction(CCFadeOut:create(1))
	actionArr:addObject(CCFadeOut:create(1))
	actionArr:addObject(CCCallFuncN:create(endCallback))

	tipNode:runAction(CCSequence:create(actionArr))
end

function endCallback( tipNode )

	tipNode:removeFromParentAndCleanup(true)
	tipNode = nil
end 


-- fly 的文字

local function animatedEndAction( tipNode)

	tipNode:removeFromParentAndCleanup(true)
	tipNode = nil
	
end

function flyText( tipText ,frontName, colors, time,size)
	local color = colors or { red = 0x76, green=0xfc , blue =0x06 }

	local timeInterval = time or 0.8
	frontName = frontName or g_sFontPangWa
	size= size or 45

	local runningScene = CCDirector:sharedDirector():getRunningScene()
	local tipNode = CCNode:create()
	runningScene:addChild(tipNode,2013)

	local delayTime = 0.7

	for i=1,#tipText do
		
		local descLabel = CCLabelTTF:create(tipText[i]  , g_sFontPangWa, 45)--, 1,ccc3(0x00,0x00,0x00), type_stroke)
		descLabel:setColor(ccc3(color.red,color.green,color.blue))
		descLabel:setScale(g_fScaleX)
		descLabel:setAnchorPoint(ccp(0.5, 1))
		local width = (runningScene:getContentSize().width )/2 -- +20
		descLabel:setPosition(ccp(width, runningScene:getContentSize().height*0.5))
		descLabel:setVisible(false)
		tipNode:addChild(descLabel)

		local nextMoveToP = ccp(width, runningScene:getContentSize().height*0.7)

		local actionArr = CCArray:create()
		
		actionArr:addObject(CCDelayTime:create(delayTime)) 
		actionArr:addObject(CCCallFuncN:create(function ( ... )
			descLabel:setVisible(true)
		end))
		-- CCEaseOut:create(CCMoveTo:create(1.3, nextMoveToP),2)
		-- CCMoveTo:create(timeInterval, nextMoveToP
		actionArr:addObject(CCEaseOut:create(CCMoveTo:create(1.3,nextMoveToP),2))
		actionArr:addObject(CCFadeOut:create(0.2))
		actionArr:addObject(CCCallFuncN:create(animatedEndAction))
		descLabel:runAction(CCSequence:create(actionArr))
		delayTime = delayTime + 0.3
	end

end


-- 改自animation 的效果图
local function fnEndCallback( tipSprite )
	tipSprite:removeFromParentAndCleanup(true)
	tipSprite = nil
end 

function showTip(tipText)
	local fullRect = CCRectMake(0,0,58,58)
	local insetRect = CCRectMake(20,20,18,18)

	local hSpace=30
	local vSpace=40
	local nWidth=510

	-- 描述
	local tLabel = {
		text=tipText, fontsize=28, color=ccc3(255, 255, 255), width=nWidth-hSpace, alignment=kCCTextAlignmentCenter, 
	}
	require "script/libs/LuaCCLabel"
	local descLabel = LuaCCLabel.createMultiLineLabels(tLabel)
	local runningScene = CCDirector:sharedDirector():getRunningScene()

	--提示背景
	local tipSprite = CCScale9Sprite:create("images/tip/animate_tip_bg.png", fullRect, insetRect)

	local nHeight=descLabel:getContentSize().height + vSpace
	descLabel:setPosition(hSpace/2, nHeight-vSpace/2)

	tipSprite:setPreferredSize(CCSizeMake(nWidth, nHeight))
	tipSprite:setAnchorPoint(ccp(0.5, 0.5))
	tipSprite:setPosition(ccp(runningScene:getContentSize().width/2 , runningScene:getContentSize().height/2))
	-- btnFrameSp:setScale(bgLayer:getBgScale()/bgLayer:getElementScale())
	runningScene:addChild(tipSprite,2000)
	-- tipSprite:setCascadeOpacityEnabled(true)
	tipSprite:setScale(g_fScaleX)	
	tipSprite:addChild(descLabel)

	local nextMoveToP = ccp(runningScene:getContentSize().width/2, runningScene:getContentSize().height*0.75)

	local actionArr = CCArray:create()
	descLabel:runAction(CCFadeOut:create(4.0))
	actionArr:addObject(CCMoveTo:create(2, nextMoveToP))
	actionArr:addObject(CCFadeOut:create(2.0))
	
	actionArr:addObject(CCCallFuncN:create(fnEndCallback))

	tipSprite:runAction(CCSequence:create(actionArr))
end

local function NodeEndCallback( nodeContent)
	
	nodeContent:removeFromParentAndCleanup(true)
	nodeContent = nil
end


-- 主要是为了宠物升级文字使用, 多列文字
function showScaleTxt(node_table)
	
	local runningScene = CCDirector:sharedDirector():getRunningScene()
	local width = 0 
	local height =0 
	for k,v in pairs(node_table) do
		width = v:getContentSize().width
		height = height -  v:getContentSize().height
	end

	local nodeContent = CCNode:create()
	nodeContent:setContentSize(CCSizeMake(width, height))
	setAdaptNode(nodeContent)

	local tempHeight = 0
	for k,v in pairs(node_table) do
        v:setAnchorPoint(ccp(0.5, 0))
        v:setPosition(0.5*width,tempHeight)
        nodeContent:addChild(v)
        tempHeight = tempHeight - v:getContentSize().height
    end
    runningScene:addChild(nodeContent)
    -- return nodeContent
    local actionArr = CCArray:create()
	--descLabel:runAction(CCFadeOut:create(1))
	actionArr:addObject(CCScaleBy:create(0.1,0.5))
	actionArr:addObject(CCFadeOut:create(1))
	actionArr:addObject(CCCallFuncN:create(NodeEndCallback))
	nodeContent:runAction(CCSequence:create(actionArr))

    nodeContent:setPosition(ccp(runningScene:getContentSize().width/2 , runningScene:getContentSize().height/2))
    nodeContent:setAnchorPoint(ccp(0.5,0.5))
end


function createVerticalNode( node_table)
    local width = 0 
	local height =0 
	for k,v in pairs(node_table) do
		width = v:getContentSize().width
		height = height -  v:getContentSize().height
	end

	local nodeContent = CCNode:create()
	nodeContent:setContentSize(CCSizeMake(width, height))

	local tempHeight = 0
	for k,v in pairs(node_table) do
        v:setAnchorPoint(ccp(0.5, 0))
        v:setPosition(0.5*width,tempHeight)
        nodeContent:addChild(v)
        tempHeight = tempHeight - v:getContentSize().height
    end
   return nodeContent
end


function flyEndCallback( tipNode )

	tipNode:removeFromParentAndCleanup(true)
	tipNode = nil
end

--pLabel 为变化的属性控件 changTimes 为改控件改变的次数
-- callbackFunc 动画完成后的回调
function fnPlayOneNumNoRandomChangeAni( pLabel ,startNum,changTimes ,callbackFunc)
	if(not pLabel or not changTimes) then
		return
	end
	if(tonumber(changTimes) == tonumber(0)) then
		return
	end
	local totleCount = changTimes
	local pTime = 0.1
	local play_count = 0
	local initNum = startNum
	local pRunAction = nil
	local function changeLabel()
		local pStr = ""
		-- for i=1,#changTimes do
		-- 	local pY = startNum
		-- 	if(i == #ptb and pY == 0) then
		-- 		pY = 1
		-- 	end 
		-- 	pStr =  pY .. pStr
		-- end
		play_count = play_count + 1 
		
		pStr = (initNum + play_count) .. pStr
		if(play_count >= totleCount) then
			if(pLabel.setText) then
				pLabel:setText(tostring(pStr))
			elseif(pLabel.setStringValue) then
				pLabel:setStringValue(tostring(pStr))
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
	if (callbackFunc) then
		logger:debug("callbackFunc")
		local ppCall = CCCallFuncN:create( function ( ... )
				callbackFunc()
		end )

		arrSQ2:addObject( ppCall )
	end
	local fnSq2 = CCSequence:create(arrSQ2)

	pRunAction = CCSpawn:createWithTwoActions(fnSq1,fnSq2)
	pLabel:runAction(pRunAction)

end


--pLabel 为变化的属性控件 endNum 为改控件的最终值
function fnPlayOneNumChangeAni( pLabel ,endNum)
	if(not pLabel or not endNum) then
		return
	end
	if(tonumber(endNum) == tonumber(0)) then
		return
	end

	local totleCount = 20
	local pTime = 0.02
	local play_count = 0
    require "script/module/formation/MainFormationTools"
	local ptb = MainFormationTools.getNumber(endNum)
	local pRunAction = nil

	local function changeLabel()
		if (not UIHelper.isGood(pLabel)) then
			return
		end
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
				pLabel:setText(tostring(endNum))
			elseif(pLabel.setStringValue) then
				pLabel:setStringValue(tostring(endNum))
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



function fnPlayLabelAni(attrItem,endNum)
	if(not attrItem and not endNum) then
		return
	end
	local pLabel = attrItem or nil
	local pEndNum = endNum or nil
	fnPlayOneNumChangeAni(pLabel,pEndNum)
end

-- function: showFlyText, 
-- example: 
-- tParam ={ 
	-- {txt="xx", num="", displayNumType=4, color=ccc3(0x23,0x24,0x34), fontsize= 45 }, 
	-- {txt="xx", num=-2, displayNumType=1, color=ccc3(0x24,0x45,0x53)},
-- -- }
-- function showFlyText1(tParam,callbackFunc, showpoint ,tfdAttr,tipNode,isShowFightValueAnimate)
-- 	local runningScene = CCDirector:sharedDirector():getRunningScene()
-- 	logger:debug("LevelUpUtil.showFlyText")
--     if (not tipNode) then
-- 		tipNode = CCNode:create()
-- 	    tipNode:setTag(1111)
-- 	    runningScene:addChild(tipNode,999999999)
-- 	end

-- 	local pWorldSize = runningScene:getContentSize()
-- 	local pShowPoint = showpoint or ccp(pWorldSize.width*0.5,pWorldSize.height*0.5)
-- 	local fontname 			= g_sFontPangWa
-- 	local fontsize			= 32
-- 	local displayNumType 	= 1 --显示形式  是否除以100/%百分比显示等   add by chengliang
-- 	local colorPlus 		= ccc3(0x00,0xff,0x06) -- { red = 0x76, green=0xfc , blue =0x06 }
-- 	local colorMinus 		= ccc3(0xff,0x0,0x0)  -- red = 0x76, green=0xfc , blue =0x06
-- 	local color
-- 	local delayTime = 0.3
-- 	for i=1, #tParam do
-- 		fontname 		= tParam[i].fontname or fontname
-- 		fontsize 		= tParam[i].fontsize or fontsize
-- 		displayNumType 	= tParam[i].displayNumType or 1
-- 		if(tonumber(tParam[i].num)>=0 ) then
-- 			color=tParam[i].color or colorPlus
-- 			tParam[i].txt= tParam[i].txt .. "+"
-- 		else
-- 			color=tParam[i].color or colorMinus
-- 		end

-- 		-- add by chengliang
-- 		local displayNum = tParam[i].num
-- 		local endNum = tParam[i].endNum

-- 		if(tonumber(displayNumType) == 1)then
-- 	    	displayNum = tParam[i].num
-- 	    elseif(tonumber(displayNumType) == 2)then
-- 			displayNum = tParam[i].num / 100
-- 		elseif(tonumber(displayNumType) == 3)then
-- 			displayNum = tParam[i].num / 100 .. "%"
-- 	    end
-- 		-- 文字 
-- 		local alertContent = {}
-- 		-- alertContent[1] = CCLabelTTF:create(tParam[i].txt .. displayNum , fontname, fontsize)--, 2, ccc3(0,0,0), type_stroke)
-- 		alertContent[1] = UIHelper.createStrokeTTF(tParam[i].txt .. displayNum,color,ccc3(0x00,0x31,0x00),nil,32,g_sFontCuYuan)
-- 		-- alertContent[1]:setColor(color)
		
-- 		local descNode = alertContent[1]
-- 		descNode:setAnchorPoint(ccp(0.5,0.5))
-- 		descNode:setPosition(pShowPoint)
-- 		descNode:setVisible(false)
-- 		tipNode:addChild(descNode)

-- 		local nextMoveToP = ccp(pShowPoint.x, pShowPoint.y + pWorldSize.height*0.28 - i * mFontSize)

-- 		local actionArr = CCArray:create()
-- 		actionArr:addObject(CCDelayTime:create(delayTime))
-- 		--actionArr:addObject(CCFadeIn()) 
-- 		actionArr:addObject(CCCallFuncN:create(function ( ... )
-- 			descNode:setVisible(true)
-- 		end))
-- 		--actionArr:addObject(CCEaseOut:create(CCMoveTo:create(1.3, nextMoveToP),2))
-- 		actionArr:addObject(CCMoveTo:create(1, nextMoveToP))

-- 		--actionArr:addObject(CCDelayTime:create(0.2))
-- 		-- actionArr:addObject(CCFadeOut:create(0.2))
-- 		-- actionArr:addObject(CCCallFuncN:create(flyEndCallback))

-- -----------------------------
--         if (tfdAttr) then
-- 	        local pNode = tfdAttr[i] or nil
-- 	        local partTime = 0.3
-- 	    	local moveTime2 = 0.6
-- 			if(pNode) then
-- 				local pTTime = partTime + (#tParam - i)* (partTime)
-- 				actionArr:addObject( CCDelayTime:create(pTTime) )
-- 				local pPoint = ccp(pNode:getPositionX(),pNode:getPositionY())
-- 				local finalMoveToP = pNode:getParent():convertToWorldSpace(pPoint)
-- 				local pM1 = ccp((finalMoveToP.x - nextMoveToP.x)*1/3 + nextMoveToP.x , nextMoveToP.y - (nextMoveToP.y - finalMoveToP.y)*1/3)
-- 				local pM2 = ccp((finalMoveToP.x - nextMoveToP.x)*2/3 + nextMoveToP.x , nextMoveToP.y - (nextMoveToP.y - finalMoveToP.y)*2/3)
				
-- 				local parray = CCArray:create()
-- 				parray:addObject(CCMoveTo:create(moveTime2*0.5 , pM1))
-- 				parray:addObject(CCMoveTo:create(moveTime2*0.3 , pM2))
-- 				parray:addObject(CCMoveTo:create(moveTime2*0.2 , finalMoveToP))
-- 				local pswq = CCSequence:create(parray)

-- 				local ppAc = CCSpawn:createWithTwoActions(pswq , CCScaleTo:create(moveTime2 , 0.55))
-- 				actionArr:addObject(ppAc)
-- 			end

-- 	        local function playAni( ... )
-- 				fnPlayLabelAni(tfdAttr[i],endNum)
-- 				if(i == 1) then
-- 				AudioHelper.playEffect("audio/effect/texiao_zhandouli.mp3")
-- 				end
-- 			end

-- 			actionArr:addObject(CCCallFuncN:create(playAni))
-- 		end
-- ------------------------------

-- 		actionArr:addObject(CCCallFuncN:create(flyEndCallback))

-- 		if(i==#tParam and callbackFunc ) then
-- 			actionArr:addObject(CCCallFuncN:create(function ( ... )
-- 				callbackFunc(nil,nil,nil,isShowFightValueAnimate)
-- 			end))
-- 		end
-- 		descNode:runAction(CCSequence:create(actionArr))

-- 		delayTime = delayTime + 0.3
-- 	end

-- end





--[[desc:功能简介
    tParamOrig: 格式
    tParam ={ 
	{txt="xx", num=2, displayNumType=2, color=ccc3(0x23,0x24,0x34), fontsize= 45 }, 
	{txt="xx", num=-2, displayNumType=1, color=ccc3(0x24,0x45,0x53)},
-- }
	showpoint:兼容老接口，目前没有调用,直接传nil
	tfdAttr:属性飘到上方后需要飘到对应位置时，该参数传table，把对应位置的label加入table
	tipNode :特效需要添加的节点，为nil时添加到runningScene上
	isShowFightValueAnimate：
	tParamTitle： table，背景图需要showflytext_bg2.png 的情况，传在showflytext_bg2.png之上的的label
    return: 是否有返回值，返回值说明  
—]]
function showFlyText(tParamOrig,callbackFunc, showpoint ,tfdAttr,tipNode,isShowFightValueAnimate,tParamTitle)
	logger:debug("LevelUpUtil.showFlyText")
	if (#tParamOrig==0) then 
		if (callbackFunc) then 
			callbackFunc(nil,nil,nil,isShowFightValueAnimate)
		end 
		return 
	end 


	local tParam = {}
	table.hcopy(tParamOrig,tParam)
	tParamTitle = tParamTitle or {}

	local runningScene = CCDirector:sharedDirector():getRunningScene()
    if (not tipNode) then
		tipNode = CCNode:create()
	end
    tipNode:setTag(1111)
    runningScene:addChild(tipNode,999999999)

	local pWorldSize = runningScene:getContentSize()
	-- local pShowPoint = showpoint or ccp(pWorldSize.width*0.5,pWorldSize.height*0.5)
	local fontname 			= g_sFontPangWa
	local fontsize			= 32
	local displayNumType 	= 1 --显示形式  是否除以100/%百分比显示等   add by chengliang
	local colorPlus 		= ccc3(0x00,0xff,0x06) -- { red = 0x76, green=0xfc , blue =0x06 }
	local colorMinus 		= ccc3(0xff,0x0,0x0)  -- red = 0x76, green=0xfc , blue =0x06
	local color
	local fontTitleSize = 32   --用于showflytext_bg2.png 之上的文字

	local mHangPart = 10  --行间距
	local mTopPart = 10 --label与背景的上下边距

	-- 弹出面板＋属性飘字
	local movetime = 0.33  --字体向下飘的时间
	local staytime1 = 1.4 
	local fadetime1 = 0.18

	-- 只有弹出面板
	local staytime2 = 1.6
	local fadetime2 = 0.5

	local sp1 = CCSprite:create("images/common/showflytext_bg1.png")	
	local oriSize = sp1:getContentSize()
	local rect = CCRect(oriSize.width/2-80,oriSize.height/2-15,160,30)
	local bgSp = CCScale9Sprite:create(rect,"images/common/showflytext_bg1.png")	
	tipNode:addChild(bgSp)
	bgSp:setScale(0)
	bgSp:setOpacity(0)
	local bgSpW = oriSize.width

	local bgSpH = #tParam * fontsize + (#tParam-1) * mHangPart + mTopPart*2
	if (#tParamTitle>0) then 
		bgSpH  = bgSpH + fontTitleSize * #tParamTitle + 35
	end 

	local bgSize = CCSizeMake(bgSpW,bgSpH)
	bgSp:setContentSize(bgSize)
	bgSp:setPosition(ccp(pWorldSize.width/2,pWorldSize.height/2))


	local titleContent = {}
	local starty = bgSize.height - mTopPart-fontsize/2  
	if (#tParamTitle>0) then 
		local sp_line  = CCSprite:create("images/common/showflytext_bg2.png")
		bgSp:addChild(sp_line)
		local sp_size = sp_line:getContentSize()
		sp_line:setPosition(ccp(bgSize.width/2, bgSpH - fontTitleSize * #tParamTitle - (#tParamTitle-1)*mHangPart - sp_size.height/2 - mTopPart))

		for k=1,#tParamTitle do
			local color = tParamTitle[k].color or colorPlus
			local label = UIHelper.createStrokeTTF(tParamTitle[k].txt,color,ccc3(0x00,0x31,0x00),nil,32,g_sFontCuYuan)
			bgSp:addChild(label)
			titleContent[#titleContent + 1] = label
			label:setPosition(ccp(bgSize.width/2,starty))
			label:setAnchorPoint(ccp(0.5,0.5))
			starty = starty - fontTitleSize - mHangPart
		end

		starty = starty - sp_size.height / 2
	end 


	local startx = bgSize.width/2

	local labelSize = nil
	for i=1, #tParam do
		fontname = tParam[i].fontname or fontname
		fontsize = tParam[i].fontsize or fontsize
		displayNumType = tParam[i].displayNumType or 1
		tParam[i].txt= tParam[i].txt .. " "
		if(tonumber(tParam[i].num)>=0 ) then
			color=tParam[i].color or colorPlus
			tParam[i].txt= tParam[i].txt .. "+"
		else
			color=tParam[i].color or colorMinus
		end


		if(tonumber(displayNumType) == 4)then
			color=tParam[i].color or colorPlus
		end

		-- add by chengliang
		local displayNum = tParam[i].num
		local endNum = tParam[i].endNum



		if(tonumber(displayNumType) == 1)then
	    	displayNum = tParam[i].num
	    elseif(tonumber(displayNumType) == 2)then
			displayNum = tParam[i].num / 100
		elseif(tonumber(displayNumType) == 3)then
			displayNum = tParam[i].num / 100 .. "%"
		else
			displayNum = ""
	    end
		-- 文字 
		local alertContent = {}
		alertContent[1] = UIHelper.createStrokeTTF(tParam[i].txt .. displayNum,color,ccc3(0x00,0x31,0x00),nil,32,g_sFontCuYuan)
		local descNode = alertContent[1]
		bgSp:addChild(descNode)
		descNode:setTag(i)

		if (#titleContent > 0) then 
			labelSize = titleContent[1]:getContentSize()
			descNode:setAnchorPoint(ccp(0,0.5))
			descNode:setPosition(ccp(startx-labelSize.width/2,starty-(i-1)*(mHangPart+fontsize)))
		else
			if (i==1) then 
				labelSize = descNode:getContentSize()
				descNode:setAnchorPoint(ccp(0.5,0.5))
				descNode:setPosition(ccp(startx,starty-(i-1)*(mHangPart+fontsize)))
			else 
				descNode:setAnchorPoint(ccp(0,0.5))
				descNode:setPosition(ccp(startx-labelSize.width/2,starty-(i-1)*(mHangPart+fontsize)))
			end 
		end  
	end

	-- 属性飘到对应位置
	local function callback( ... )
        if (tfdAttr) then
        	for i=1, #tParam do
		        local pNode = tfdAttr[i] or nil
				if(pNode) then
					local mNode = bgSp:getChildByTag(i)
					local pos = ccp(mNode:getPositionX(),mNode:getPositionY())
					local wpos = mNode:getParent():convertToWorldSpace(pos)
					mNode:retain()
					mNode:removeFromParentAndCleanup(false)
					tipNode:addChild(mNode)
					mNode:release()
					mNode:setPosition(wpos)

					local mArray = CCArray:create()
					local pPoint = ccp(pNode:getPositionX(),pNode:getPositionY())
					local finalMoveToP = pNode:getParent():convertToWorldSpace(pPoint)
					mArray:addObject(CCMoveTo:create(movetime,finalMoveToP))

			        local function playAni( ... )
						fnPlayLabelAni(tfdAttr[i],endNum)
						if(i == 1) then
							AudioHelper.playEffect("audio/effect/texiao_zhandouli.mp3")
						end
					end
					mArray:addObject(CCCallFuncN:create(playAni))
					mArray:addObject(CCCallFuncN:create(flyEndCallback))
					if (i==#tParam or 1) then 
						mArray:addObject(CCCallFunc:create(function ( ... )
							if (tipNode) then 
								tipNode:removeFromParentAndCleanup(true)
								tipNode = nil
							end 
						end))
					end 
					local seq = CCSequence:create(mArray)
					mNode:runAction(seq)
				end
        	end 
		end
	end

	-- 背景的运动
	local function getAction( ... ) 
		local fadeto0 = CCFadeTo:create(FRAME_TIME,128)
		local scale0 = CCScaleTo:create(FRAME_TIME,0.09)
		local spawn0 = CCSpawn:createWithTwoActions(fadeto0,scale0)
		local fadeto1 = CCFadeTo:create(FRAME_TIME*4,170)
		local fadeto2 = CCFadeTo:create(FRAME_TIME*8,255)
		local scale = CCScaleTo:create(FRAME_TIME*8,1.0)
		local spawn = CCSpawn:createWithTwoActions(scale,fadeto2)

		local staytime = staytime1
		local fadetime = fadetime1
		if (not tfdAttr) then 
			stayitme = staytime2
			fadetime = fadetime2			
		end 

		local delay = CCDelayTime:create(staytime)
		local func = CCCallFunc:create(callback)
		local fadeto3 = CCFadeTo:create(fadetime,0)
		local func2 = CCCallFunc:create(function ( ... )
			if (tipNode and not tfdAttr) then 
				tipNode:removeFromParentAndCleanup(true)
				tipNode = nil
			end 
			if (bgSp) then 
				bgSp:removeFromParentAndCleanup(true)
				bgSp = nil
			end 
			if (callbackFunc) then 
				callbackFunc(nil,nil,nil,isShowFightValueAnimate)
			end 
		end)
		local array = CCArray:create()
		array:addObject(spawn0)
		array:addObject(fadeto1)
		array:addObject(spawn)
		array:addObject(delay)
		array:addObject(func)
		array:addObject(fadeto3)
		array:addObject(func2)
		
		local seq = CCSequence:create(array)
		return seq
	end

	bgSp:runAction(getAction())
end



--战斗力数字改变
local function changeNumber( _label , _old , _final , callBack )
	local pLabel = _label or nil
	if(not _label) then
		if(not callBack == false) then
			callBack()
		end
		return
	end
	local old = tonumber(_old) or 0
	local final = tonumber(_final) or 0
	if(old == final) then
		if(not callBack == false) then
			callBack()
		end
	end
	local pRes = final-old
	local pRRes = math.abs(pRes)
	local pTotleTime = pRRes < 10 and pRRes or 10
	local pChange = pRRes < 10 and pRes or math.modf(pRes/10)
	local pTime = 0
	local pPart = 0.05

	local function fnChangeNum( ... )
		pTime = pTime + 1
		if(pTime < pTotleTime) then
			local pNum = old + pTime*pChange
			pLabel:setString(pNum.."")
		else
			pLabel:setString(final.."")
		end
	end

	local pArray = CCArray:create()
	for i=1,pTotleTime do
		local pDelay = CCDelayTime:create(pPart)
		pArray:addObject(pDelay)
		local pChange = CCCallFuncN:create(fnChangeNum)
		pArray:addObject(pChange)
	end
	if(not callBack == false) then
		local pCall = CCCallFuncN:create(callBack)
		pArray:addObject(pCall)
	end
	pLabel:runAction(CCSequence:create(pArray))
end

--战斗里动画结束后有回调
local function fnRemoveTipNodeWithCallBack(callBack )
	if(not tipNode)then 
		return 
	end 
	tipNode:removeFromParentAndCleanup(true)
	tipNode = nil

	if(callBack)then 
		callBack()
	end 
end


--战斗力滑出屏幕，node移除
local function pMoveOut( callBack )
	if(not tipNode) then
		return
	end
	local accArr = CCArray:create()
	local ppFadeOut = CCFadeOut:create(14/60)
	accArr:addObject(ppFadeOut)
	local ppCall = CCCallFuncN:create( function ( ... )
		-- fnRemoveTipNode(callBack)
		 fnRemoveTipNodeWithCallBack(callBack)
	end )
	accArr:addObject(ppCall)
	tipNode:runAction(CCSequence:create(accArr))
end

function fnShowFightForceChangeAni( ph,fnCallBack,tbFight,isShowFightAnimte)
    if (not isShowFightAnimte) then
		return
    end

	local pNumFinal , pNumNow = UserModel.getFightForceValueNewAndOld()

	logger:debug({pNumFinal=pNumFinal})
	logger:debug({pNumNow=pNumNow})
	

	if(tbFight)then 
		pNumFinal = tbFight[1]
		pNumNow = tbFight[2]
	end 
    

	if(tonumber(pNumFinal) == tonumber(pNumNow)) then
		return
	end
    
	local runningScene = CCDirector:sharedDirector():getRunningScene()


	local pWSize = runningScene:getContentSize()

	local m_height = tonumber(ph) or (280/1136)*pWSize.height

	local pfilePath = "images/formation/fightForce/"
	tipNode = CCNode:create()
	tipNode:setTag(2222)
	runningScene:addChild(tipNode,999999999)

	local middlePos = ccp(pWSize.width*0.5 , m_height)
	local pDelayWaitTime = 8/60

	--红底
	local pRed = CCSprite:create(pfilePath .. "red.png")
	if(pRed) then
		pRed:setAnchorPoint(0.5,0.5)
		pRed:setPosition(ccp(middlePos.x, middlePos.y))
		tipNode:addChild(pRed)

		pRed:runAction(CCFadeIn:create(pDelayWaitTime))
	end

	--战斗力
	local pZhandou = CCSprite:create(pfilePath .. "fightnumber.png")
	if(pZhandou) then

		pZhandou:setAnchorPoint(0.5,0.5)
		local pWidth = pZhandou:getContentSize().width
		tipNode:addChild(pZhandou)
		pZhandou:setVisible(false)
		pZhandou:setScaleY(0.2)
		
		local labelAtlas = CCLabelAtlas:create(pNumNow, pfilePath .. "number.png", 20, 27, 48)
		labelAtlas:setAnchorPoint(0,0)
		local pLabelX = pZhandou:getContentSize().width + 5
		labelAtlas:setPosition(ccp(pLabelX, 0))
		pZhandou:addChild(labelAtlas)

		pWidth = pWidth + 5 + labelAtlas:getContentSize().width
		local pStartx = middlePos.x - pWidth*0.5 + pZhandou:getContentSize().width*0.5
		pZhandou:setPosition(ccp(pStartx , middlePos.y))

		local actionArr = CCArray:create()
		actionArr:addObject(CCDelayTime:create(pDelayWaitTime)) -- 0
		actionArr:addObject(CCCallFuncN:create(function( ... )
			pZhandou:setVisible(true)
		end))
		
			local actArr1 = CCArray:create()
			actArr1:addObject(CCFadeIn:create(6/60))
			actArr1:addObject(CCScaleTo:create(6/60,1,1.5))
			actArr1:addObject(CCMoveTo:create(6/60,ccp(pStartx,middlePos.y+29)))
			local pSpawn1 = CCSpawn:create(actArr1)
		actionArr:addObject(pSpawn1) -- 1

			local actArr2 = CCArray:create()
			actArr2:addObject(CCScaleTo:create(4/60,1,0.9))
			actArr2:addObject(CCMoveTo:create(4/60,ccp(pStartx,middlePos.y-3)))
			local pSpawn2 = CCSpawn:create(actArr2)
		actionArr:addObject(pSpawn2) -- 2

			local actArr3 = CCArray:create()
			actArr3:addObject(CCScaleTo:create(4/60,1,1))
			actArr3:addObject(CCMoveTo:create(4/60,ccp(pStartx,middlePos.y)))
			local pSpawn3 = CCSpawn:create(actArr3)
		actionArr:addObject(pSpawn3) -- 3

		local pCallback = CCCallFuncN:create(function ( ... )
				local pChange = tonumber(pNumFinal) - tonumber(pNumNow)
				local pName = pChange > 0 and "up.png" or "down.png"
				local pStateImgX = pLabelX + labelAtlas:getContentSize().width + 5
				local pStateImg = CCSprite:create(pfilePath .. pName)
				pStateImg:setAnchorPoint(0,0)
				local pStartY = pChange > 0 and 0 or 27
				pStateImg:setPosition(ccp(pStateImgX, pStartY))
				pZhandou:addChild(pStateImg)

				local function stateImgUpAni( ... )
					local height1 = 16
					local height2 = 27
					if(pChange < 0) then
						height1 = 11
						height2 = 0
						AudioHelper.playEffect("audio/effect/texiao_zhandouli_down.mp3")	
					else
						AudioHelper.playEffect("audio/effect/texiao_zhandouli_jiantou.mp3")
					end
					local pAccArr = CCArray:create()
					local ppMove1 = CCMoveTo:create(14/60 , ccp(pStateImgX , height1))
					pAccArr:addObject(ppMove1)--1
					local ppMove2 = CCMoveTo:create(42/60 , ccp(pStateImgX , height2))
					pAccArr:addObject(ppMove2)--2
					local ppFadeOut = CCFadeOut:create(32/60)
					pAccArr:addObject(ppFadeOut)--3

					local ppCall = CCCallFuncN:create(function ( ... )
						pMoveOut(fnCallBack)
					end)
					pAccArr:addObject(ppCall)--4
					pStateImg:runAction(CCSequence:create(pAccArr))
				end

				AudioHelper.playEffect("audio/effect/texiao_zhandouli.mp3")
				changeNumber(labelAtlas, pNumNow , pNumFinal , stateImgUpAni)
			end)
		actionArr:addObject(pCallback)--4
		pZhandou:runAction(CCSequence:create(actionArr))
	end
end


-- 伙伴强化飘字功能
-- tipCardNode  加载layout上的数字动画
-- callbackFunc 所有飘字完后的回调
-- showpoint 飘字位置
-- curLayer 当前界面
-- isShowFightValueAnimate 当前英雄是否在阵容上 在的话 飘字
-- tfdAttr 增加的属性跳动
-- changeAutoAddedFn 为战斗力飘字回调
-- function showFlyPartnerCardStrengthText1( tipCardNode,tParam,callbackFunc, showpoint ,tfdAttr,curLayer,isShowFightValueAnimate ,changeAutoAddedFn)
-- 	local runningScene = CCDirector:sharedDirector():getRunningScene()
--     curLayer:addNode(tipCardNode,999999999)
--     logger:debug({tParam=tParam})
-- 	local pWorldSize = runningScene:getContentSize()
-- 	local pShowPoint = showpoint or ccp(pWorldSize.width*0.5,pWorldSize.height*0.5)
-- 	local fontname 			= g_sFontCuYuan
-- 	local fontsize			= 32
-- 	local displayNumType 	= 1 --显示形式  是否除以100/%百分比显示等   add by chengliang
-- 	local colorPlus 		= ccc3(0x00,0xff,0x06) -- { red = 0x76, green=0xfc , blue =0x06 }
-- 	local colorMinus 		= ccc3(0xff,0x0,0x0)  -- red = 0x76, green=0xfc , blue =0x06
-- 	local color
-- 	local delayTime = 0.3
-- 	for i=1, #tParam do
-- 		fontname 		= tParam[i].fontname or fontname
-- 		fontsize 		= tParam[i].fontsize or fontsize
-- 		displayNumType 	= tParam[i].displayNumType or 1
-- 		if(tonumber(tParam[i].num)>=0 ) then
-- 			color=tParam[i].color or colorPlus
-- 			tParam[i].txt= tParam[i].txt .. "+"
-- 		else
-- 			color=tParam[i].color or colorMinus
-- 		end

-- 		-- add by chengliang
-- 		local displayNum = tParam[i].num
-- 		local endNum = tParam[i].endNum

-- 		if(tonumber(displayNumType) == 1)then
-- 	    	displayNum = tParam[i].num
-- 	    elseif(tonumber(displayNumType) == 2)then
-- 			displayNum = tParam[i].num / 100
-- 		elseif(tonumber(displayNumType) == 3)then
-- 			displayNum = tParam[i].num / 100 .. "%"
-- 	    end
-- 		-- 文字 
-- 		local alertContent = {}
-- 		-- alertContent[1] = CCLabelTTF:create(tParam[i].txt .. displayNum , fontname, fontsize)--, 2, ccc3(0,0,0), type_stroke)
-- 		alertContent[1] = UIHelper.createStrokeTTF(tParam[i].txt .. displayNum,color,ccc3(0x00,0x31,0x00),nil,32,g_sFontCuYuan)
-- 		alertContent[1]:setColor(color)
		
-- 		local descNode = alertContent[1]
-- 		descNode:setAnchorPoint(ccp(0.5,0.5))
-- 		descNode:setPosition(pShowPoint)
-- 		descNode:setVisible(false)
-- 		tipCardNode:addChild(descNode)

-- 		local nextMoveToP = ccp(pShowPoint.x, pShowPoint.y + pWorldSize.height*0.28 - i * mFontSize)

-- 		local actionArr = CCArray:create()
-- 		actionArr:addObject(CCDelayTime:create(delayTime))
-- 		--actionArr:addObject(CCFadeIn()) 
-- 		actionArr:addObject(CCCallFuncN:create(function ( ... )
-- 			descNode:setVisible(true)
-- 		end))
-- 		--actionArr:addObject(CCEaseOut:create(CCMoveTo:create(1.3, nextMoveToP),2))
-- 		actionArr:addObject(CCMoveTo:create(1, nextMoveToP))

-- 		--actionArr:addObject(CCDelayTime:create(0.2))
-- 		-- actionArr:addObject(CCFadeOut:create(0.2))
-- 		-- actionArr:addObject(CCCallFuncN:create(flyEndCallback))

-- -----------------------------
--         if (tfdAttr) then
-- 	        local pNode = tfdAttr[i] or nil
-- 	        local partTime = 0.3
-- 	    	local moveTime2 = 0.6
-- 			if(pNode) then
-- 				local pTTime = partTime + (#tParam - i)* (partTime)
-- 				actionArr:addObject( CCDelayTime:create(pTTime) )
-- 				local pPoint = ccp(pNode:getPositionX(),pNode:getPositionY())
-- 				local finalMoveToP = pNode:getParent():convertToWorldSpace(pPoint)
-- 				local pM1 = ccp((finalMoveToP.x - nextMoveToP.x)*1/3 + nextMoveToP.x , nextMoveToP.y - (nextMoveToP.y - finalMoveToP.y)*1/3)
-- 				local pM2 = ccp((finalMoveToP.x - nextMoveToP.x)*2/3 + nextMoveToP.x , nextMoveToP.y - (nextMoveToP.y - finalMoveToP.y)*2/3)
				
-- 				local parray = CCArray:create()
-- 				parray:addObject(CCMoveTo:create(moveTime2*0.5 , pM1))
-- 				parray:addObject(CCMoveTo:create(moveTime2*0.3 , pM2))
-- 				parray:addObject(CCMoveTo:create(moveTime2*0.2 , finalMoveToP))
-- 				local pswq = CCSequence:create(parray)

-- 				local ppAc = CCSpawn:createWithTwoActions(pswq , CCScaleTo:create(moveTime2 , 0.55))
-- 				actionArr:addObject(ppAc)
-- 			end
-- 	        local function playAni( ... )
-- 				fnPlayLabelAni(tfdAttr[i],endNum)
-- 				if(i == 1) then
-- 				AudioHelper.playEffect("audio/effect/texiao_zhandouli.mp3")
-- 				end
-- 			end

-- 			actionArr:addObject(CCCallFuncN:create(playAni))
-- 		end
-- ------------------------------


--         actionArr:addObject(CCFadeOut:create(0.2))
-- 		-- actionArr:addObject(CCCallFuncN:create(function ( ... )
-- 		-- 	curLayer:removeNodeByTag(4444)
-- 		-- end))

-- 		if(i==#tParam and callbackFunc ) then
-- 			--actionArr:addObject(CCDelayTime:create(0.5))
-- 			actionArr:addObject(CCCallFuncN:create(function ( ... )
-- 				callbackFunc(tipCardNode,changeAutoAddedFn,curLayer,isShowFightValueAnimate,isAutoAdded)
-- 			end))
-- 		end
-- 		descNode:runAction(CCSequence:create(actionArr))

-- 		delayTime = delayTime + 0.3
-- 	end

-- end


-- 伙伴强化飘字功能   新版本 modify by yangna
-- tipCardNode  加载layout上的数字动画
-- callbackFunc 所有飘字完后的回调
-- showpoint 飘字位置
-- curLayer 当前界面
-- isShowFightValueAnimate 当前英雄是否在阵容上 在的话 飘字
-- tfdAttr 增加的属性跳动
-- changeAutoAddedFn 为战斗力飘字回调
function showFlyPartnerCardStrengthText( tipCardNode,tParam,callbackFunc, showpoint ,tfdAttr,isShowFightValueAnimate ,changeAutoAddedFn)
	local runningScene = CCDirector:sharedDirector():getRunningScene()
    logger:debug({tParam=tParam})
	local pWorldSize = runningScene:getContentSize()
	local pShowPoint = showpoint or ccp(pWorldSize.width*0.5,pWorldSize.height*0.5)
	local fontname 			= g_sFontCuYuan
	local fontsize			= 28
	local displayNumType 	= 1 --显示形式  是否除以100/%百分比显示等   add by chengliang
	local colorPlus 		= ccc3(0x00,0xff,0x06) -- { red = 0x76, green=0xfc , blue =0x06 }
	local colorMinus 		= ccc3(0xff,0x0,0x0)  -- red = 0x76, green=0xfc , blue =0x06
	local color

	local mHangPart = 10 --行间距
	local mTopPart = 17  --上下边距
	local movetime = 0.33  --字体向下飘的时间

	local sp1 = CCSprite:create("images/common/showflytext_bg1.png")	
	local oriSize = sp1:getContentSize()
	local rect = CCRect(oriSize.width/2-80,oriSize.height/2-15,160,30)
	local bgSp = CCScale9Sprite:create(rect,"images/common/showflytext_bg1.png")	
	tipCardNode:addChild(bgSp)
	bgSp:setScale(0)
	bgSp:setOpacity(0)
	local bgSpW = oriSize.width
	local bgSpH = #tParam * fontsize + (#tParam-1) * mHangPart + mTopPart*2
	local bgSize = CCSizeMake(bgSpW,bgSpH)
	bgSp:setContentSize(bgSize)
	bgSp:setPosition(ccp(pWorldSize.width/2,pWorldSize.height/2))

	local starty = bgSize.height - mTopPart-fontsize/2   --label的坐标
	local startx = bgSize.width/2

	local labelSize
	for i=1, #tParam do
		fontname = tParam[i].fontname or fontname
		fontsize = tParam[i].fontsize or fontsize
		displayNumType = tParam[i].displayNumType or 1
		tParam[i].txt= tParam[i].txt .. " "
		if(tonumber(tParam[i].num)>=0 ) then
			color=tParam[i].color or colorPlus
			tParam[i].txt= tParam[i].txt .. "+"
		else
			color=tParam[i].color or colorMinus
		end

		-- add by chengliang
		local displayNum = tParam[i].num
		local endNum = tParam[i].endNum

		if(tonumber(displayNumType) == 1)then
	    	displayNum = tParam[i].num
	    elseif(tonumber(displayNumType) == 2)then
			displayNum = tParam[i].num / 100
		elseif(tonumber(displayNumType) == 3)then
			displayNum = tParam[i].num / 100 .. "%"
	    end
		-- 文字 
		local alertContent = {}
		-- alertContent[1] = CCLabelTTF:create(tParam[i].txt .. displayNum , fontname, fontsize)--, 2, ccc3(0,0,0), type_stroke)
		alertContent[1] = UIHelper.createStrokeTTF(tParam[i].txt .. displayNum,color,ccc3(0x00,0x31,0x00),nil,32,g_sFontCuYuan)
		alertContent[1]:setColor(color)
		
		local descNode = alertContent[1]

		bgSp:addChild(descNode)
		descNode:setTag(i)

		if (i==1) then 
			labelSize = descNode:getContentSize()
			descNode:setAnchorPoint(ccp(0.5,0.5))
			descNode:setPosition(ccp(startx,starty-(i-1)*(mHangPart+fontsize)))
		else 
			descNode:setAnchorPoint(ccp(0,0.5))
			descNode:setPosition(ccp(startx-labelSize.width/2,starty-(i-1)*(mHangPart+fontsize)))
		end 
	end 


	local function callback( ... )
		for i=1, #tParam do
			local endNum = tParam[i].endNum
	        if (tfdAttr) then
		        local pNode = tfdAttr[i] or nil
				if(pNode) then
					-- 属性从背景上移到tipLabelNode. 
					local node = bgSp:getChildByTag(i)
					local pos = ccp(node:getPositionX(),node:getPositionY())
					local wpos = node:getParent():convertToWorldSpace(pos)
					node:retain()
					node:removeFromParentAndCleanup(false)
					tipCardNode:addChild(node)
					node:release()
					node:setPosition(wpos)

					local pPoint = ccp(pNode:getPositionX(),pNode:getPositionY())
					local finalMoveToP = pNode:getParent():convertToWorldSpace(pPoint)
					local parray = CCArray:create()
					parray:addObject(CCMoveTo:create(movetime , finalMoveToP))

			        local function playAni( ... )
						fnPlayLabelAni(tfdAttr[i],endNum)
						if(i == 1) then
							AudioHelper.playEffect("audio/effect/texiao_zhandouli.mp3")
						end 
					end
					parray:addObject(CCCallFuncN:create(playAni))
					parray:addObject(CCCallFuncN:create(function ( ... )
						if (node) then 
							node:removeFromParentAndCleanup(true)
							node = nil
						end 
					end))


					if(i==#tParam and callbackFunc ) then
						parray:addObject(CCCallFuncN:create(function ( ... )
							tipCardNode:removeFromParentAndCleanup(true)
						    tipCardNode = nil
							if (not isShowFightValueAnimate) then
						    	changeAutoAddedFn()
								return
						    else
								callbackFunc()
								changeAutoAddedFn()
							end
						end))
					end 

					local seq = CCSequence:create(parray)
					node:runAction(seq)
				end
			end
		end 	
	end


	-- 背景的运动
	local function getAction( ... ) 
		local fadeto0 = CCFadeTo:create(FRAME_TIME,128)
		local scale0 = CCScaleTo:create(FRAME_TIME,0.09)
		local spawn0 = CCSpawn:createWithTwoActions(fadeto0,scale0)
		local fadeto1 = CCFadeTo:create(FRAME_TIME*4,170)
		local fadeto2 = CCFadeTo:create(FRAME_TIME*8,255)
		local scale = CCScaleTo:create(FRAME_TIME*8,1.0)
		local spawn = CCSpawn:createWithTwoActions(scale,fadeto2)
		local delay = CCDelayTime:create(1.4)
		local func = CCCallFunc:create(callback)
		local fadeto3 = CCFadeTo:create(0.18,0)
		local array = CCArray:create()
		
		array:addObject(spawn0)
		array:addObject(fadeto1)
		array:addObject(spawn)
		array:addObject(delay)
		array:addObject(func)
		array:addObject(fadeto3)
		array:addObject(CCCallFunc:create(function ( ... )--背景删除
			if (bgSp) then 
				bgSp:removeFromParentAndCleanup(true)
				bgSp = nil
			end 
		end))   

		local seq = CCSequence:create(array)
		return seq
	end

	bgSp:runAction(getAction())

	return function ( ... )
		if (tipCardNode) then
			tipCardNode:removeFromParentAndCleanup(true)
			tipCardNode = nil
		end
	end
end




-- 伙伴强化战斗力飘字
function fnCardStrenthFightForceChangeAni(tipCardNode,fnCallBack,isShowFightAnimte,isAutoAdded)
    if (not isShowFightAnimte) then
    	fnCallBack()
		tipCardNode:removeFromParentAndCleanup(true)
    	tipCardNode = nil
		return
    end

	local pNumFinal , pNumNow = UserModel.getFightForceValueNewAndOld()


	if(tonumber(pNumFinal) == tonumber(pNumNow)) then
		fnCallBack()
		isAutoAdded = false
		return
	end
    
	local runningScene = CCDirector:sharedDirector():getRunningScene()


	local pWSize = runningScene:getContentSize()

	local m_height = tonumber(ph) or (280/1136)*pWSize.height

	local pfilePath = "images/formation/fightForce/"
	-- local tipCardNode = curLayer:getNodeByTag(4444)
	-- if (not tipCardNode) then
	-- 	tipCardNode = CCNode:create()
	-- 	tipCardNode:setTag(4444)
	-- 	curLayer:addNode(tipCardNode,999999999)
	-- end

	local middlePos = ccp(pWSize.width*0.5 , m_height)
	local pDelayWaitTime = 8/60

	--红底
	local pRed = CCSprite:create(pfilePath .. "red.png")
	if(pRed) then
		pRed:setAnchorPoint(0.5,0.5)
		pRed:setPosition(ccp(middlePos.x, middlePos.y))
		tipCardNode:addChild(pRed)

		pRed:runAction(CCFadeIn:create(pDelayWaitTime))
	end

	--战斗力滑出屏幕，node移除
	local function pMoveOutNode( tipCardNode,callBack )

		local accArr = CCArray:create()
		local ppFadeOut = CCFadeOut:create(14/60)
		accArr:addObject(ppFadeOut)
		local ppCall = CCCallFuncN:create( function ( ... )
			tipCardNode:removeFromParentAndCleanup(true)
    		tipCardNode = nil
			if(callBack)then 
				callBack()
			end 
		end )
		accArr:addObject(ppCall)
		tipCardNode:runAction(CCSequence:create(accArr))
	end


	--战斗力
	local pZhandou = CCSprite:create(pfilePath .. "fightnumber.png")
	if(pZhandou) then

		pZhandou:setAnchorPoint(0.5,0.5)
		local pWidth = pZhandou:getContentSize().width
		tipCardNode:addChild(pZhandou)
		pZhandou:setVisible(false)
		pZhandou:setScaleY(0.2)
		
		local labelAtlas = CCLabelAtlas:create(pNumNow, pfilePath .. "number.png", 20, 27, 48)
		labelAtlas:setAnchorPoint(0,0)
		local pLabelX = pZhandou:getContentSize().width + 5
		labelAtlas:setPosition(ccp(pLabelX, 0))
		pZhandou:addChild(labelAtlas)

		pWidth = pWidth + 5 + labelAtlas:getContentSize().width
		local pStartx = middlePos.x - pWidth*0.5 + pZhandou:getContentSize().width*0.5
		pZhandou:setPosition(ccp(pStartx , middlePos.y))

		local actionArr = CCArray:create()
		actionArr:addObject(CCDelayTime:create(pDelayWaitTime)) -- 0
		actionArr:addObject(CCCallFuncN:create(function( ... )
			pZhandou:setVisible(true)
		end))
		
			local actArr1 = CCArray:create()
			actArr1:addObject(CCFadeIn:create(6/60))
			actArr1:addObject(CCScaleTo:create(6/60,1,1.5))
			actArr1:addObject(CCMoveTo:create(6/60,ccp(pStartx,middlePos.y+29)))
			local pSpawn1 = CCSpawn:create(actArr1)
		actionArr:addObject(pSpawn1) -- 1

			local actArr2 = CCArray:create()
			actArr2:addObject(CCScaleTo:create(4/60,1,0.9))
			actArr2:addObject(CCMoveTo:create(4/60,ccp(pStartx,middlePos.y-3)))
			local pSpawn2 = CCSpawn:create(actArr2)
		actionArr:addObject(pSpawn2) -- 2

			local actArr3 = CCArray:create()
			actArr3:addObject(CCScaleTo:create(4/60,1,1))
			actArr3:addObject(CCMoveTo:create(4/60,ccp(pStartx,middlePos.y)))
			local pSpawn3 = CCSpawn:create(actArr3)
		actionArr:addObject(pSpawn3) -- 3

		local pCallback = CCCallFuncN:create(function ( ... )
				local pChange = tonumber(pNumFinal) - tonumber(pNumNow)
				local pName = pChange > 0 and "up.png" or "down.png"
				local pStateImgX = pLabelX + labelAtlas:getContentSize().width + 5
				local pStateImg = CCSprite:create(pfilePath .. pName)
				pStateImg:setAnchorPoint(0,0)
				local pStartY = pChange > 0 and 0 or 27
				pStateImg:setPosition(ccp(pStateImgX, pStartY))
				pZhandou:addChild(pStateImg)

				local function stateImgUpAni( ... )
					local height1 = 16
					local height2 = 27
					if(pChange < 0) then
						height1 = 11
						height2 = 0
						AudioHelper.playEffect("audio/effect/texiao_zhandouli_down.mp3")	
					else
						AudioHelper.playEffect("audio/effect/texiao_zhandouli_jiantou.mp3")
					end
					local pAccArr = CCArray:create()
					local ppMove1 = CCMoveTo:create(14/60 , ccp(pStateImgX , height1))
					pAccArr:addObject(ppMove1)--1
					local ppMove2 = CCMoveTo:create(42/60 , ccp(pStateImgX , height2))
					pAccArr:addObject(ppMove2)--2
					local ppFadeOut = CCFadeOut:create(32/60)
					pAccArr:addObject(ppFadeOut)--3
	
					local ppCall = CCCallFuncN:create( function ( ... )
						pMoveOutNode(tipCardNode,fnCallBack)
					end )
					
					-- local ppCall = CCCallFuncN:create(function ( ... )
					-- 	pMoveOut(fnCallBack)
					-- end)
					

					pAccArr:addObject(ppCall)--4
					pStateImg:runAction(CCSequence:create(pAccArr))
				end

				AudioHelper.playEffect("audio/effect/texiao_zhandouli.mp3")
				changeNumber(labelAtlas, pNumNow , pNumFinal , stateImgUpAni)
			end)
		actionArr:addObject(pCallback)--4
		pZhandou:runAction(CCSequence:create(actionArr))
	end
end




