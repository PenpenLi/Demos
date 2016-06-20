-- FileName: AwakeUtil.lua
-- Author: 
-- Date: 2015-03-00
-- Purpose: function description of module
--[[TODO List]]

module("AwakeUtil", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --
local _i18n = gi18n




function showFlyText(tParam,callbackFunc, showpoint ,tfdAttr,tipNode,isShowFightValueAnimate)
	AudioHelper.playEffect("audio/effect/texiao_zhandouli_feichu.mp3")
	logger:debug("LevelUpUtil.showFlyText")
	if (#tParam==0) then 
		if (callbackFunc) then 
			callbackFunc(nil,nil,nil,isShowFightValueAnimate)
		end 
		return 
	end 

	local runningScene = CCDirector:sharedDirector():getRunningScene()
    if (not tipNode) then
		tipNode = CCNode:create()
	end
    tipNode:setTag(1111)
    runningScene:addChild(tipNode,999999999)

	local pWorldSize = runningScene:getContentSize()
	-- local pShowPoint = showpoint or ccp(pWorldSize.width*0.5,pWorldSize.height*0.5)
	local fontname 			= g_sFontPangWa
	local fontsize			= 28
	local displayNumType 	= 1 --显示形式  是否除以100/%百分比显示等   add by chengliang
	local colorPlus 		= ccc3(0x00,0xff,0x06) -- { red = 0x76, green=0xfc , blue =0x06 }
	local colorMinus 		= ccc3(0xff,0x0,0x0)  -- red = 0x76, green=0xfc , blue =0x06
	local color
	local sp2Size 			= 9

	local mHangPart = 10  --行间距
	local mTopPart = 17 --label与背景的上下边距

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
	local bgSpW = 350
	local bgSpH = #tParam * fontsize + (#tParam-1) * mHangPart + mTopPart*2 + sp2Size*2 + fontsize
	local bgSize = CCSizeMake(bgSpW,bgSpH)
	bgSp:setContentSize(bgSize)
	bgSp:setPosition(ccp(pWorldSize.width/2,pWorldSize.height/2))
	local starty = bgSize.height - mTopPart-fontsize/2   --label的坐标
	local startx = bgSize.width/2

	local title = UIHelper.createStrokeTTF(_i18n[7411], ccc3(0xff,0xea,0x00), nil, nil, 28, g_sFontCuYuan)
	bgSp:addChild(title)
	title:setPosition(ccp(startx,starty))
	local sp2 = CCSprite:create("images/common/showflytext_bg2.png")
	local oriSize2 = sp2:getContentSize()
	sp2:setPosition(ccp(bgSpW/2,bgSize.height - mTopPart-fontsize - sp2Size  ))
	bgSp:addChild(sp2)

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
		alertContent[1] = UIHelper.createStrokeTTF(tParam[i].txt .. displayNum,g_QulityColor2[3],ccc3(0x00,0x31,0x00),nil,28,g_sFontCuYuan)
		local descNode = alertContent[1]
		bgSp:addChild(descNode)
		descNode:setTag(i)

		if (i==1) then 
			labelSize = descNode:getContentSize()
			descNode:setAnchorPoint(ccp(0.5,0.5))
			descNode:setPosition(ccp(startx,starty-(i-1)*(mHangPart+fontsize)  -(sp2Size*2 + fontsize)  ))
		else 
			descNode:setAnchorPoint(ccp(0,0.5))
			descNode:setPosition(ccp(startx-labelSize.width/2,starty-(i-1)*(mHangPart+fontsize)   -(sp2Size*2 + fontsize)   ))
		end 
	end


	-- 属性飘到对应位置
	local function callback( ... )
        if (tfdAttr) then
        	for i=1, #tParam do
		        local pNode = tfdAttr[i] or nil
				if(pNode) then
					local mNode = bgSp:getChildByTag(i)
					local pos = ccp(node:getPositionX(),node:getPositionY())
					local wpos = node:getParent():convertToWorldSpace(pos)
					mNode:retain()
					mNode:removeFromParentAndCleanup(false)
					tipNode:addChild(mNode)
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
					if (i==#tParam) then 
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















local function init(...)

end

function destroy(...)
	package.loaded["AwakeUtil"] = nil
end

function moduleName()
    return "AwakeUtil"
end

function create(...)

end
