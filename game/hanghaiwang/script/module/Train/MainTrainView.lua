-- FileName: MainTrainView.lua
-- Author: yangna
-- Date: 2015-10-25
-- Purpose: 修炼系统
--[[TODO List]]

module("MainTrainView", package.seeall)

require "script/module/Train/MainTrainModel"
require "db/DB_Train"

-- UI控件引用变量 --



local _layMain = nil

local _pageLayer_1 = nil
local _pageLayer_2 = nil


-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString = gi18nString
local m_fnGetWidget = g_fnGetWidgetByName

local m_c3Color = ccc3(0x28,0x00,0x00) -- zhangqi, 2015-11-30
local m_signPlus = "+" -- zhangqi, 2015-11-30

local tbBeforeNum = {}  --改造前属性
local tbAfterNum = {}   --改造后属性
local tbFlayText = {}  --存储飘字的内容
local tbTipNode = {}   --保存当前添加的飘字节点
local tbFightValue = {} --保存每次改造的战斗力前后值
local tbLabelProperty = {} 



local m_light_tag = 115664  --train_lighting  当前要修炼的icon上发光特效
local m_explosion_tag = 115665  --train_explosion 修炼时第一个曝光特效
local m_chainNormal_tag = 112230   --普通状态链子特效
local m_chainSelect_tag = 113330   --震动状态链子特效
local m_trainLighted_Tag = 10086   --已经修炼过的特效 train_lighted
local m_btnEff_tag = 10020  --图标震动特效

local m_box_open_tag = 103054  --宝箱打开特效
local m_box_light_tag = 103055  --宝箱光特效

local tbArgs 

local function init(...)
	tbBeforeNum = {}
	tbAfterNum = {}
	tbFlayText = {}
	tbTipNode = {}
	tbFightValue = {}
	tbLabelProperty = {}
end

function destroy(...)
	package.loaded["MainTrainView"] = nil
end

function moduleName()
    return "MainTrainView"
end


-------------------------------飘字动画 start-----------------------------
-- 退出之前停止飘字特效  属性文字滚动特效 战斗力动画
function stopAllAction( ... )
	for k,v in pairs(tbLabelProperty) do 
		v:stopAllActions()
	end 

	for k,v in pairs(tbTipNode) do 
		logger:debug({v=v})
		v:stopAllActions()
		v:removeFromParentAndCleanup(true)
	end 
	tbTipNode = nil

	MainFormationTools.removeFlyText()  
end


function initPropertyLabel( ... )
	tbLabelProperty = { 
		_layMain.TFD_BLOOD_NUM,
		_layMain.TFD_WUGONG_NUM,
		_layMain.TFD_MOGONG_NUM,
		_layMain.TFD_WUFANG_NUM,
		_layMain.TFD_MOFANG_NUM
	}
end

-- 纪录改造前后的属性值 
function rememberProperty( type )
	local cell = {}
	-- 生命
	local markAdd = MainTrainModel.getHp()
	cell[#cell+1] = markAdd

	--物攻
	local markAdd = MainTrainModel.getPhyAttack()
	cell[#cell+1] = markAdd

	--魔攻
	local markAdd = MainTrainModel.getMagAttack()
	cell[#cell+1] = markAdd

	--物防
	local markAdd = MainTrainModel.getPhyDefend()
	cell[#cell+1] = markAdd

	--魔防
	local markAdd = MainTrainModel.getMagDefend()
	cell[#cell+1] = markAdd

	if(type==1)then 
		table.insert(tbBeforeNum,cell)
	else 
		table.insert(tbAfterNum,cell)
	end 
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



--[[desc:移除飘字节点
    arg1: isRemoveAll: 是否移除table的所有节点 ； 默认为false，移除动画结束的一个节点
    return: 是否有返回值，返回值说明  
—]]
function fnRemoveTipNode( )
	logger:debug({isRemoveAll=isRemoveAll})
	if(#tbTipNode==0)then 
		return
	end 

	tbTipNode[1]:removeFromParentAndCleanup(true)
	table.remove(tbTipNode,1)
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
	tipLabelNode:addChild(bgSp)
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
	for i=1,#tParam do
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
		alertContent[1] = UIHelper.createStrokeTTF(tParam[i].txt .. displayNum,color,ccc3(0x00, 0x31, 0x00),ccc3(0x00, 0x31, 0x00),fontsize,fontname)
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

	-- 属性飘到对应位置
	local function callback( ... )
		for i=1, #tParam do
			-- 属性从背景上移到tipLabelNode. 
			local node = bgSp:getChildByTag(i)
			local pos = ccp(node:getPositionX(),node:getPositionY())
			local wpos = node:getParent():convertToWorldSpace(pos)
			node:retain()
			node:removeFromParentAndCleanup(false)
			tipLabelNode:addChild(node)
			node:release()
			node:setPosition(wpos)

			local mArray = CCArray:create()

			--文字飞到属性label的位置
			local pNode = tbLabelProperty[tParam[i].key] 
			local pPoint = ccp(pNode:getPositionX(),pNode:getPositionY())
			local finalMoveToP = pNode:getParent():convertToWorldSpace(pPoint)
			mArray:addObject(CCMoveTo:create(movetime , finalMoveToP))

			local function playAni( ... )
				fnPlayLabelAni(tParam[i].key,tbValueBefore,tbValueAfter)
				if(i == 1) then
					AudioHelper.playEffect("audio/effect/texiao_shuzhibianhua.mp3")
				end
			end

			mArray:addObject(CCCallFuncN:create(playAni))
			mArray:addObject(CCCallFuncN:create(flyEndCallback))   --移除单个属性节点

			if(i==#tParam)then 
				mArray:addObject(CCCallFunc:create(fnRemoveTipNode))   --移除tipLabelNode
			end

			if(i==#tParam and callbackFunc ) then 
				mArray:addObject(CCCallFuncN:create(function ( ... )
					callbackFunc()
				end))
			end

			local seq = CCSequence:create(mArray)
			node:runAction(seq)
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
	AudioHelper.playSpecialEffect("texiao_zhandouli_feichu.mp3")
end 


--  准备属性飘字数据  飘战斗力数据
function addFlyText( ... )
	local tbName = { m_i18n[1068],m_i18n[1069],m_i18n[1070],m_i18n[1071],m_i18n[1072]}  --"生命","物攻","魔攻","物防","魔防"
	local function getIndex( name )
		local index = nil
		for i=1,#tbName do 
			-- if (name==tbName[i]) then 
			if (string.find(name,tbName[i])) then 
				index = i
				break
			end 
 		end 
 		return index
	end

	local tbData = DB_Train.getDataById(MainTrainModel.getCurTrainId())
	local attArr = string.split(tbData.attArr, ",") --取到属性值
	local len = table.getn(attArr)

	local cell = {}
	for i=1,len do 
		local attArrs = string.split(attArr[i], "|")
		local name = MainTrainModel.getAffix(attArrs[1])

		local markAdd = attArrs[2]
		if tonumber(name.type) == 2 then
			markAdd = markAdd / 100
		end

		local index = getIndex(name.sigleName)

		-- 飘字效果
		local o_text = {}
		o_text.txt = m_i18n[2711] .. name.sigleName
		o_text.num = markAdd
		o_text.key = index
		table.insert(cell, o_text)
	end

	if(table.getn(cell)>0)then 
		table.insert(tbFlayText,cell) 
	end 

	local pNumFinal , pNumNow = UserModel.getFightForceValueNewAndOld()
	local data ={pNumFinal,pNumNow}
	table.insert(tbFightValue,data)
end


function showFlyTextEffect( ... )
	-- local pNumFinal , pNumNow = UserModel.getFightForceValueNewAndOld()
	-- local data ={pNumFinal,pNumNow}
	-- table.insert(tbFightValue,data)

	local tbValue1 = {}
	tbValue1 = table.hcopy(tbBeforeNum[1],tbValue1)  
	local tbValue2 = {}
	tbValue2 = table.hcopy(tbAfterNum[1],tbValue2) 
	table.remove(tbBeforeNum,1)
	table.remove(tbAfterNum,1)

	if(#tbFlayText>0)then 
		local data = {}
		data = table.hcopy(tbFlayText[1],data)
		table.remove(tbFlayText,1)
		
		showFlyText(data, function ( )
			MainFormationTools.removeFlyText() --删除战斗力节点
			local tbData = {}
			table.hcopy(tbFightValue[1],tbData)
			table.remove(tbFightValue,1)
			MainFormationTools.fnShowFightForceChangeAni(nil,nil,tbData)
		end , tbValue1,tbValue2 ) 
	else 
		refreashLabel() --直接刷新下级属性
		MainFormationTools.removeFlyText() --删除战斗力节点
		local tbData = {}
		table.hcopy(tbFightValue[1],tbData)
		table.remove(tbFightValue,1)
		MainFormationTools.fnShowFightForceChangeAni(nil,nil,tbData)
	end 
end

-----------------------------飘字动画 end---------------------------------




-----------------------------新特效---------------------------------




--[[desc:创建动画
    filename：json文件名
    aniname：动画名
    movementCall：播放结束回调、
    frameCall：关键帧回调
    frameName：关键帧名字
    return: 是否有返回值，返回值说明  
—]]
local function getAnimationByName( filename,aniname ,movementCall,frameCall,frameName)
	local function fnFrameMnetCallBack( bone,frameEventName,originFrameIndex,currentFrameIndex )
		if (frameName and frameCall and frameEventName==frameName) then 
			frameCall()
		end 
	end

	local animation = UIHelper.createArmatureNode({
		filePath = "images/effect/train/" .. filename .. "/" .. filename .. ".ExportJson",
		animationName = aniname,
		fnMovementCall = movementCall,
		fnFrameCall = fnFrameMnetCallBack,
		bRetain = true,
	})

	return animation
end



-- 播放修炼成功特效: train_explosion播放，其关键帧停止train_lighting并播放train_chain的动态锁链，和图标震动
function showTrainSucEffect( callback )
	local pageid = MainTrainModel.getLastPageId()
	local page = _layMain.PGV_MAIN:getPage(pageid) 
	local trainid = MainTrainModel.getLastTrainId()
	local icon_id = trainid-pageid*5
	local icon = page["IMG_ICON" .. icon_id]
	local pageSize = page:getSize()
	local icon_left = icon_id > 1 and page["IMG_ICON" .. (icon_id-1)] or nil
	local icon_right = icon_id < 5 and page["IMG_ICON" .. (icon_id+1)] or nil 
	local icon_left2 = icon_id > 2 and page["IMG_ICON" .. (icon_id-2)] or nil
	local icon_right2 = icon_id < 4 and page["IMG_ICON" .. (icon_id+2)] or nil
	icon:setTouchEnabled(false)

	-- 链子震动特效
	local function addChainSelAni( ... )
		if(pageid%2==1)then 
			icon_id = 6-icon_id
		end 
		local chainleft = page:getNodeByTag(m_chainNormal_tag+icon_id)
		local chainright = page:getNodeByTag(m_chainNormal_tag+icon_id+1)

		-- 链子震动特效播放时，屏蔽链子普通特效
		chainleft:setVisible(false)
		chainright:setVisible(false)
		
		local function fnMoveCallback( ... )
			chainleft:setVisible(true)
			chainright:setVisible(true)
			page:removeNodeByTag(m_chainSelect_tag)
		end

		local node = CCNode:create()  --用于特效适配（UIWidget setScale不会处理addNode添加的节点）
		local chain = getAnimationByName("train_chain","train_chain_0" .. icon_id,fnMoveCallback,nil,nil)
		node:addChild(chain)
		node:setScale(g_fScaleX)
		node:setTag(m_chainSelect_tag)

		if(pageid%2==1)then 
			chain:setScaleX(-1)
		end 	
		page:addNode(node)
		node:setZOrder(-1)
		node:setPosition(ccp(pageSize.width/2,(pageSize.height/3-10)-(g_fScaleX-1)*(pageSize.height/3-10)))
	end


	-- 图标震动特效,图标震动特效结束后回调
	local function addIconAni( ... )
		local moveCallBack = function ( ... )
			icon:removeNodeByTag(m_btnEff_tag)
			if (callback) then 
				callback()
			end 
		end

		local chain_btn = getAnimationByName("train_chain","train_chain_anniu",moveCallBack)
		icon:addNode(chain_btn)
		chain_btn:setTag(m_btnEff_tag)
		local data = DB_Train.getDataById(trainid)
		local sp = CCSprite:create("images/train/" .. data.icon .. ".png")
		chain_btn:getBone("Layer68_Copy70"):addDisplay(sp,0)
		chain_btn:setZOrder(0)
	end

	-- 左右两个icon的震动
	local function addTwoIconAction( ... )
		local tbData = {
			{{"delay",1} ,{"moveto",1,ccp(4,0)},{"delay",1},{"moveto",3,ccp(6,-4)},{"delay",1},{"moveto",3,ccp(0,3)},{"delay",1},{"moveto",3,ccp(0,0)}},
			{{"delay",5} ,{"moveto",1,ccp(2,0)},{"delay",1},{"moveto",3,ccp(3,-3)},{"delay",1},{"moveto",3,ccp(0,3)},{"delay",1},{"moveto",3,ccp(0,0)}},
			{{"delay",1} ,{"moveto",1,ccp(-4,0)},{"delay",1},{"moveto",3,ccp(-6,-4)},{"delay",1},{"moveto",3,ccp(0,3)},{"delay",1},{"moveto",3,ccp(0,0)}},
			{{"delay",5} ,{"moveto",1,ccp(-2,0)},{"delay",1},{"moveto",3,ccp(-3,-3)},{"delay",1},{"moveto",3,ccp(0,3)},{"delay",1},{"moveto",3,ccp(0,0)}},
		}

		local function getActionByIndex( index,x,y )
			local data = tbData[index]
			local array = CCArray:create()
			for i=1,#data do
				local cell = data[i]
				if (cell[1]=="delay") then 
					array:addObject(CCDelayTime:create(FRAME_TIME*cell[2]))
				elseif (cell[1]=="moveto") then  
					array:addObject(CCMoveTo:create(FRAME_TIME*cell[2],ccp(x+cell[3].x,y+cell[3].y)))
				end 
			end
			local seq = CCSequence:create(array)
			return seq
		end

		local tbNode = {icon_left,icon_left2,icon_right,icon_right2}
		for i=1,4 do
			if(tbNode[i]) then 
				local x,y = tbNode[i]:getPosition()
				tbNode[i]:runAction(getActionByIndex(i,x,y))
			end 
		end
	end

	-- 添加train_explosion特效
	local function addTrainExplosionAni( ... )
		local moveCall = function ( ... )
			icon:removeNodeByTag(m_explosion_tag)
		end

		local frameCall = function ( ... )
			-- train_explosion特效的关键帧，停止train_lighting
			icon:removeNodeByTag(m_light_tag)
			addChainSelAni()
			addIconAni()
			addTwoIconAction()
			showFlyTextEffect()
			runShakeSenceEff(_layMain.PGV_MAIN)
			runShakeSenceEff(_layMain.img_bg)
		end

		local ani = getAnimationByName("train_explosion","train_explosion",moveCall,frameCall,"1")
		icon:addNode(ani)
		ani:setZOrder(1)
		ani:setTag(m_explosion_tag)
	end

	addTrainExplosionAni()
	AudioHelper.playSpecialEffect("texiao_xiulianbao.mp3")
end

-- 连击处理 停止上一个icon上的特效
function stopLastEffect( ... )
	if (tonumber(MainTrainModel.getCurTrainId())==0) then 
		return 
	end 
	ShakeSenceEff:stopShakeAction()

	local trainid = MainTrainModel.getLastTrainId()
	local pageid = MainTrainModel.getLastPageId()
	local page = _layMain.PGV_MAIN:getPage(pageid) 
	local icon_id = trainid-pageid*5

	if (icon_id <=0 ) then 
		return 
	end 

	local icon = page["IMG_ICON" .. icon_id]
	local pageSize = page:getSize()
	local chainleft = page:getNodeByTag(m_chainNormal_tag+icon_id)  --普通链子特效
	local chainright = page:getNodeByTag(m_chainNormal_tag+icon_id+1)
	chainleft:setVisible(true)
	chainright:setVisible(true)

	local btnEff = icon:getNodeByTag(m_btnEff_tag)  -- 图标震动特效
	local explosionNode = icon:getNodeByTag(m_explosion_tag)   --爆炸特效

	local function refreashIcon( )
		MainTrainModel.resetPageId()   
		local newpage = MainTrainModel.getPageId()
		local curpage = _layMain.PGV_MAIN:getCurPageIndex()
		if (curpage ~= newpage) then  --每页的最后一个修炼完，自动翻页
			resetPageView() 
			refreashPageByIndex(newpage-1)
			refreashPageByIndex(newpage)
			refreashPageByIndex(newpage+1)
			setPageVisible()
			return 
		end 

		icon:removeNodeByTag(m_light_tag)
		local data = DB_Train.getDataById(trainid)
		local iconname = icon["TFD_NAME" .. icon_id]
		iconname:setText(data.name)
		local iconfile = "images/train/" .. data.icon .. ".png"
		icon["IMG_ICON_SKILL" .. icon_id]:loadTexture(iconfile)
		icon["IMG_ICON_SKILL" .. icon_id]:setGray(false)
		local aninode = icon:getNodeByTag(m_trainLighted_Tag)
		if (not aninode) then 
			local ani = getAnimationByName("train_lighted","train_lighted")
			icon:addNode(ani)
			ani:setZOrder(-1)
			ani:setTag(m_trainLighted_Tag)
		end 
	end

	if (btnEff) then 
		page:removeNodeByTag(m_chainSelect_tag)  --链子震动
		icon:removeNodeByTag(m_btnEff_tag)	--图标震动特效
		refreashIcon()
	elseif (explosionNode) then 
		icon:removeNodeByTag(m_explosion_tag)
		explosionNode = nil
		logger:debug( { tbFlayText=tbFlayText, tbFightValue=tbFightValue, tbBeforeNum=tbBeforeNum,tbAfterNum=tbAfterNum})
		if (#tbBeforeNum>0) then 
			showFlyTextEffect()
		end 
		refreashIcon()
	else 
		logger:debug("all effect play over")
	end 
end

-- 宝箱奖励
function showBoxSucEffect( callback )
	local trainid = MainTrainModel.getLastTrainId()
	local pageid = MainTrainModel.getLastPageId()
	local page = _layMain.PGV_MAIN:getPage(pageid)
	local icon_id = trainid-pageid*5
	local data = DB_Train.getDataById(trainid)
	local icon = page["IMG_ICON" .. icon_id]
	icon:setTouchEnabled(false)

	local function addBoxLightAni( ... )
		local boxLightAni = getAnimationByName("train_box_light","train_box_light")
		icon:addNode(boxLightAni)
		boxLightAni:setTag(m_box_light_tag)
	end  

	local function addOpenBoxAni( ... )
		local function onClose( ... )
			LayerManager.removeLayout()
			icon:removeNodeByTag(m_box_light_tag)
			icon["IMG_ICON_SKILL" .. icon_id]:loadTexture("ui/explore_box_empty_n.png")
			icon["IMG_ICON_SKILL" .. icon_id]:setScale(0.44)
			icon["IMG_ICON_SKILL" .. icon_id]:setVisible(true)

			if (callback) then 
				callback()
			end 
		end

		local function moveCall( ... )
			icon:removeNodeByTag(m_box_open_tag)
			-- LayerManager:begainRemoveUILoading() --删除屏蔽层
			LayerManager:removeUILayer() --联网错误直接删除屏蔽层
			if (data.reward) then 
			-- 通用奖励界面
		  		local tbInfos = RewardUtil.parseRewards(data.reward , true)
		  		local rewardlayer = UIHelper.createRewardDlg(tbInfos,onClose)
				LayerManager.addLayoutNoScale(rewardlayer)
			end 
		end

		local function frameCall( ... )
			icon["IMG_ICON_SKILL" .. icon_id]:loadTexture("ui/explore_box_open_n.png")
			icon["IMG_ICON_SKILL" .. icon_id]:setScale(0.44)
			icon["IMG_ICON_SKILL" .. icon_id]:setVisible(true)
			addBoxLightAni()
		end

		local openBoxAni = getAnimationByName("train_box_open","train_box_open",moveCall,frameCall,"1")
		icon:addNode(openBoxAni)
		openBoxAni:setPosition(ccp(0,0))
		openBoxAni:setTag(m_box_open_tag)
		icon["IMG_ICON_SKILL" .. icon_id]:setVisible(false)
	end

	addOpenBoxAni()
	AudioHelper.playSpecialEffect("dianji_fubenbaoxiang.mp3")
end


function refreashUI( isBox )
	addFlyText()

	local function callback( ... )
		MainTrainModel.resetPageId()   
		local newpage = MainTrainModel.getPageId()
		local curpage = _layMain.PGV_MAIN:getCurPageIndex()
		if (curpage ~= newpage) then  --每页的最后一个修炼完，自动翻页
			resetPageView() 
		end 
		refreashPageByIndex(newpage-1)
		refreashPageByIndex(newpage)
		refreashPageByIndex(newpage+1)
		setPageVisible()
	end 

	if (isBox) then 
		showBoxSucEffect(callback)
	else 
		showTrainSucEffect(callback)
	end 

	refreashNeedLay()
	refreashArrow()
end

function initLabelWithStroke( ... )
	for i=1,5 do
		UIHelper.labelNewStroke(_layMain["TFD_NAME" .. i],m_c3Color)
	end

	UIHelper.labelNewStroke(_layMain.tfd_attr_desc,m_c3Color)
	UIHelper.labelNewStroke(_layMain.TFD_CONSUME,m_c3Color)
	UIHelper.labelNewStroke(_layMain.TFD_NEED_STAR,m_c3Color)
	UIHelper.labelNewStroke(_layMain.TFD_NEED_MONEY,m_c3Color)
	UIHelper.labelNewStroke(_layMain.TFD_TRAIN1,m_c3Color)
	UIHelper.labelNewStroke(_layMain.TFD_ATTR_ADD1_NUM,m_c3Color)
	UIHelper.labelNewStroke(_layMain.TFD_ATTR_ADD1,m_c3Color)
	UIHelper.labelNewStroke(_layMain.TFD_ATTR_ADD2,m_c3Color)
	UIHelper.labelNewStroke(_layMain.TFD_ATTR_ADD2_NUM,m_c3Color)
	UIHelper.labelNewStroke(_layMain.TFD_TRAIN2,m_c3Color)
	UIHelper.labelNewStroke(_layMain.TFD_ATTR_ADD3,m_c3Color)
	UIHelper.labelNewStroke(_layMain.TFD_ATTR_ADD3_NUM,m_c3Color)
	UIHelper.labelNewStroke(_layMain.TFD_ITEM,m_c3Color)
	UIHelper.labelNewStroke(_layMain.tfd_reward,m_c3Color)
	UIHelper.labelNewStroke(_layMain.TFD_TRAIN_ATTR,ccc3(0x92,0x53,0x1b))
	UIHelper.labelNewStroke(_layMain.TFD_STAR_OWN,m_c3Color)

	performWithDelayFrame(_layMain,function ( ... )
		_layMain.TFD_ATTR_ADD1:setPositionX(_layMain.TFD_ATTR_ADD1:getPositionX()+50)
		_layMain.TFD_ATTR_ADD1_NUM:setPositionX(_layMain.TFD_ATTR_ADD1_NUM:getPositionX()+50)
		_layMain.TFD_TRAIN2:setPositionX(_layMain.TFD_TRAIN2:getPositionX()-40)
		_layMain.TFD_ATTR_ADD2:setPositionX(_layMain.TFD_ATTR_ADD2:getPositionX()+10)
		_layMain.TFD_ATTR_ADD2_NUM:setPositionX(_layMain.TFD_ATTR_ADD2_NUM:getPositionX()+10)
		_layMain.TFD_ATTR_ADD3:setPositionX(_layMain.TFD_ATTR_ADD3:getPositionX()+40)
		_layMain.TFD_ATTR_ADD3_NUM:setPositionX(_layMain.TFD_ATTR_ADD3_NUM:getPositionX()+40)
	end,1)

end


-- 刷新修炼需求材料层
function refreashNeedLay( ... )
	_layMain.TFD_STAR_OWN:setText(MainTrainModel.getLeftScore())

	if ( MainTrainModel.getNextTrainId() > table.count(DB_Train.Train) )then 
		_layMain.LAY_NEED:setVisible(false)
		return 
	end 
	
	local lay_need = _layMain.LAY_NEED
	lay_need:setVisible(true)
	local id = MainTrainModel.getNextTrainId() > table.count(DB_Train.Train) and table.count(DB_Train.Train) or MainTrainModel.getNextTrainId()
	local curTrainData = DB_Train.getDataById(id)


	if (curTrainData.attArr) then 
		lay_need.LAY_ITEM:setVisible(false)
		local attArr = lua_string_split(curTrainData.attArr,",")
		local attArrData = {}
		for i=1,#attArr do 
			local cell = lua_string_split(attArr[i],"|")
			table.insert(attArrData,cell)
		end 

		if (#attArrData==1) then 
			_layMain.LAY_ATTR1:setVisible(true)
			_layMain.LAY_ATTR2:setVisible(false)
			local lay_att = _layMain.LAY_ATTR1
			lay_att.TFD_ATTR_ADD1:setText( m_i18n[2711] .. MainTrainModel.getAffix(attArrData[1][1]).sigleName)	
			lay_att.TFD_ATTR_ADD1_NUM:setText(m_signPlus .. attArrData[1][2])

			-- local x = lay_att.TFD_ATTR_ADD1:getPositionX()
			-- lay_att.TFD_ATTR_ADD1:setPositionX(x+55)

			-- local x = lay_att.TFD_ATTR_ADD1_NUM:getPositionX()
			-- lay_att.TFD_ATTR_ADD1_NUM:setPositionX(x+55)
		else
			_layMain.LAY_ATTR1:setVisible(false)
			_layMain.LAY_ATTR2:setVisible(true)
			local lay_att = _layMain.LAY_ATTR2
			lay_att.TFD_ATTR_ADD2:setText(m_i18n[2711] .. MainTrainModel.getAffix(attArrData[1][1]).sigleName)	
			lay_att.TFD_ATTR_ADD2_NUM:setText(m_signPlus .. attArrData[1][2])
			lay_att.TFD_ATTR_ADD3:setText(m_i18n[2711] .. MainTrainModel.getAffix(attArrData[2][1]).sigleName)	
			lay_att.TFD_ATTR_ADD3_NUM:setText(m_signPlus .. attArrData[2][2])

			-- lay_att.TFD_ATTR_ADD2:setPositionX(lay_att.TFD_ATTR_ADD2:getPositionX()+55)
			-- lay_att.TFD_ATTR_ADD2_NUM:setPositionX(lay_att.TFD_ATTR_ADD2_NUM:getPositionX()+55)
			-- lay_att.TFD_ATTR_ADD3:setPositionX(lay_att.TFD_ATTR_ADD3:getPositionX()+55)
			-- lay_att.TFD_ATTR_ADD3_NUM:setPositionX(lay_att.TFD_ATTR_ADD3_NUM:getPositionX()+55)


		end 
	elseif(curTrainData.reward) then
		lay_need.LAY_ITEM:setVisible(true)
		_layMain.LAY_ATTR1:setVisible(false)
		_layMain.LAY_ATTR2:setVisible(false)
		local rewardData = RewardUtil.getItemsDataByStr(curTrainData.reward)
		lay_need.LAY_ITEM.TFD_ITEM:setText(string.format("%s*%s",rewardData[1].name,rewardData[1].num))
		
		local rewardData = RewardUtil.parseRewards(curTrainData.reward)
		lay_need.LAY_ITEM.TFD_ITEM:setColor(g_QulityColor2[rewardData[1].quality])
	end 

	_layMain.TFD_NEED_STAR:setText(curTrainData.costCopystar)
	_layMain.TFD_NEED_MONEY:setText(curTrainData.silverCost)
end


-- 刷新属性层
function refreashLabel( )
	_layMain.TFD_BLOOD_NUM:setText(MainTrainModel.getHp())
	_layMain.TFD_WUGONG_NUM:setText(MainTrainModel.getPhyAttack())
	_layMain.TFD_MOGONG_NUM:setText(MainTrainModel.getMagAttack())
	_layMain.TFD_WUFANG_NUM:setText(MainTrainModel.getPhyDefend())
	_layMain.TFD_MOFANG_NUM:setText(MainTrainModel.getMagDefend())
end


-- 初始化pageview，只刷新前中后三页
function initPageView( ... )
	_pageLayer_1 = _layMain.LAY_PAGE:clone()
	_pageLayer_2 = _layMain.LAY_PAGE2:clone()
	_layMain.PGV_MAIN:removeAllPages()

	local totalPage = MainTrainModel.getTotalPage()

	for i=1,totalPage do 
		local page = math.floor(i%2)==1 and _pageLayer_1 or _pageLayer_2
		local pageAdd = page:clone()
		pageAdd:setPosition(ccp(0,0))
		pageAdd.IMG_CHAIN:setScale(g_fScaleX)
		_layMain.PGV_MAIN:addWidgetToPage(pageAdd,i,true)
	end 

	_layMain.PGV_MAIN:initToPage(MainTrainModel.getPageId())

	_layMain.PGV_MAIN:addEventListenerPageView(function ( sender, eventType )
		if (eventType == PAGEVIEW_EVENT_TURNING) then
			local nextPage = sender:getCurPageIndex()
			local curPage = MainTrainModel.getPageId()

			MainTrainModel.setPageId(nextPage)
			if (nextPage<curPage) then 
				refreashPageByIndex(nextPage-1)
			elseif (nextPage>curPage) then 
				refreashPageByIndex(nextPage+1)
			end 

			setPageVisible()
			refreashArrow()
		end
	end)

---------------------------------------

	setPageVisible()

	local pageid = MainTrainModel.getPageId()
	local tbPage = { pageid,pageid-1,pageid+1 }
	for i=1,3 do
		performWithDelayFrame(_layMain,function ( ... )
			_layMain.PGV_MAIN:setVisible(true)
			refreashPageByIndex(tbPage[i])
		end,i)
	end
end


function refreashPageByIndex(index )
	if (index<0 or index >=_layMain.PGV_MAIN:getPages():count()) then 
		logger:debug("refreashPageByIndex error index=" .. index)
		return 
	end 

	local page = _layMain.PGV_MAIN:getPage(index)   --pageView 页码从0开始 
	logger:debug("refreashPageByIndex index=" .. index)

--------------------------------------------------------------------
	
	local msize = _layMain.PGV_MAIN:getSize()
	for i=1,6 do
		local chain = page:getNodeByTag(m_chainNormal_tag+i)
		if (not chain) then 
			local chain = getAnimationByName("train_chain","train_chain_00" .. i)
			local node = CCNode:create()
			node:addChild(chain)
			page:addNode(node)
			node:setZOrder(-1)
			node:setScale(g_fScaleX)  --解决pad适配
			node:setTag(m_chainNormal_tag+i)
			node:setPosition(ccp(msize.width/2,(msize.height/3-10)-(g_fScaleX-1)*(msize.height/3-10) ))
			if (index%2==1) then 
				chain:setScaleX(-1)   --解决链子翻转
			end 
		else 
			chain:setVisible(true)
		end 
	end

--------------------------------------------------------------------- 

	local start = index*5
	local length = table.count(DB_Train.Train)

	for i=1,5 do
		local icon = page["IMG_ICON" .. i]
		if (start+i>length) then 
			icon:setVisible(false)
		else
			icon:setVisible(true)
			local data = DB_Train.getDataById(start+i)
			local iconname = icon["TFD_NAME" .. i]
			iconname:setText(data.name or "")

			if (data.name) then 
				UIHelper.labelNewStroke(iconname,ccc3(0x28,0,0))
			end 

			local iconfile = "images/train/" .. data.icon .. ".png"
			icon["IMG_ICON_SKILL" .. i]:loadTexture(iconfile)
			icon["IMG_ICON_SKILL" .. i]:setGray(false)
			icon["IMG_ICON_SKILL" .. i]:setVisible(true)

			if (start+i>=MainTrainModel.getNextTrainId()) then
				icon["IMG_ICON_SKILL" .. i]:setGray(true) 
				icon:removeNodeByTag(m_trainLighted_Tag)
			else 
				local node = icon:getNodeByTag(m_trainLighted_Tag)
				if (not node) then 
					local ani = getAnimationByName("train_lighted","train_lighted")
					ani:setZOrder(-1)
					ani:setTag(m_trainLighted_Tag)
					icon:addNode(ani)
				end 
				if (data.reward) then 
					icon["IMG_ICON_SKILL" .. i]:loadTexture("ui/explore_box_empty_n.png")
					icon["IMG_ICON_SKILL" .. i]:setScale(0.44)
				end 
			end 

			icon:removeNodeByTag(m_light_tag)
			icon:setTouchEnabled(false)

			if(start+i == MainTrainModel.getNextTrainId()) then 
				if (not data.reward) then 
					local ani = getAnimationByName("train_lighting","train_lighting")   --当前要修炼的icon上的发光特效
					icon:addNode(ani)
					ani:setTag(m_light_tag)
				else
					icon["IMG_ICON_SKILL" .. i]:loadTexture("ui/explore_box_close_n.png")
					icon["IMG_ICON_SKILL" .. i]:setScale(0.44)
					icon["IMG_ICON_SKILL" .. i]:setGray(true)
				end 
				icon:setTouchEnabled(true)
				icon:addTouchEventListener(tbArgs.onTrain)
			end

			if ((i==5 and not data.reward) or (start+i < MainTrainModel.getNextTrainId() and data.reward)) then
				icon.IMG_BUBBLE:setVisible(false)
			end  
			-- 奖励气泡
			if (start+i >= MainTrainModel.getNextTrainId() and data.reward) then 
				icon.IMG_BUBBLE:setVisible(true)
			
				local tbInfos =	RewardUtil.getItemsDataByStr(data.reward)
				local num = tbInfos[1].num
				local img_bubble = icon.IMG_BUBBLE
				img_bubble.TFD_ITEM_NUM:setText("x" .. num)

				local rewardImage = nil  --奖励图标
				if (tbInfos[1].type=="item") then 
					local itemTableInfo = ItemUtil.getItemById(tonumber(tbInfos[1].tid))
					rewardImage = ItemUtil.createBtnByTemplateId(itemTableInfo.id)
				else 
					local tbData = RewardUtil.parseRewardsByTb(tbInfos)
					rewardImage = tbData[1].icon
				end 					

				img_bubble.LAY_ITEM:addChild(rewardImage)
				local size = img_bubble.LAY_ITEM:getSize()
				rewardImage:setPosition(ccp(size.width/2,size.height/2))
				UIHelper.labelNewStroke(img_bubble.TFD_ITEM_NUM,ccc3(0x28,0,0))
			end 
		end 
	end
end



-- 当前页，前一页，后一页 显示，其余页隐藏
function setPageVisible( ... )
	local array = _layMain.PGV_MAIN:getPages()
	local count = array:count()
	for i=0,count-1 do
		local page = _layMain.PGV_MAIN:getPage(i)
		if (i<MainTrainModel.getPageId()-1 or i>MainTrainModel.getPageId()+1) then 
			page:setVisible(false)
		else
			page:setVisible(true)
		end 
	end
end

-- 页面重置
function resetPageView( pageid )
	local delay = CCDelayTime:create(0.1)
	local callbackFunc = CCCallFunc:create(function ( ... )
		local id  = pageid or MainTrainModel.getPageId()
		_layMain.PGV_MAIN:scrollToPage(id)
		setPageVisible()
	end)

	local array = CCArray:create()
	array:addObject(delay)
	array:addObject(callbackFunc)
	local seq = CCSequence:create(array)
	_layMain:runAction(seq)
end

-- 左右箭头刷新
function refreashArrow( ... )
	local left = MainTrainModel.getPageId() > 0 and true or false
	_layMain.IMG_ARROW_LEFT:setVisible(left)
	_layMain.IMG_ARROW_LEFT:setEnabled(left)
	right = MainTrainModel.getPageId() < MainTrainModel.getTotalPage()-1 and true or false
	_layMain.IMG_ARROW_RIGHT:setVisible(right)
	_layMain.IMG_ARROW_RIGHT:setEnabled(right)
end


-- 背景流星特效
local function addBackAni( ... )
	local size = _layMain:getSize()
	local ani_bg = getAnimationByName("train_bg","train_bg")
	_layMain:addNode(ani_bg)
	ani_bg:setPosition(ccp(size.width/2,size.height/2))
end 

-- 链子震动特效先添加到背景 但不播放



function runShakeSenceEff( node )
	local x,y = node:getPosition()
	local array = CCArray:create()
	array:addObject(CCDelayTime:create(FRAME_TIME))
	array:addObject(CCMoveTo:create(FRAME_TIME,ccp(x,y+14)))
	array:addObject(CCDelayTime:create(FRAME_TIME))
	array:addObject(CCMoveTo:create(FRAME_TIME*3,ccp(x,y-4)))
	array:addObject(CCDelayTime:create(FRAME_TIME))
	array:addObject(CCMoveTo:create(FRAME_TIME*3,ccp(x,y)))
	local seq = CCSequence:create(array)
	node:runAction(seq)
end





function create(tbBtnEvent)
	tbArgs = tbBtnEvent
	init()
	_layMain = g_fnLoadUI("ui/destiny_main.json")

	local onExitFunc = function ( ... )
		LayerManager:removeUILayer() --去掉每次修炼的屏蔽层 防止中途刷服 
		stopAllAction()
		UIHelper.removeArmatureFileCache() --释放动画纹理
	end

	UIHelper.registExitAndEnterCall(_layMain,onExitFunc)

 	_layMain.BTN_BACK:addTouchEventListener(tbBtnEvent.onBacks) 
	_layMain.BTN_TRAIN:addTouchEventListener(tbBtnEvent.onTrain)
	UIHelper.titleShadow(_layMain.BTN_TRAIN)

	_layMain.IMG_CHAIN:setScaleX(g_fScaleX)
	_layMain.img_bg:setScale(g_fScaleX)

	initPropertyLabel()
	initLabelWithStroke()
	refreashLabel()
	refreashNeedLay()

	_layMain.PGV_MAIN:setVisible(false)

	initPageView()

	refreashArrow()
	addBackAni()

	return _layMain

end


