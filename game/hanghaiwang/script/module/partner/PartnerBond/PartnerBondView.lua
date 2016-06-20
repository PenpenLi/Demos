-- FileName: PartnerBondView.lua
-- Author: lvnanchun
-- Date: 2015-07-22
-- Purpose: 羁绊界面
--[[TODO List]]

PartnerBondView = class("PartnerBondView")
require "script/module/partner/MainPartner"
require "script/module/partner/PartnerBond/PartnerBondModel"

-- UI variable --
local _layMain
local _listView
local _pageView
local _tipNode
local _pLeft
local _pRight
local _tbSetFalseBtn = {}

-- module local variable --
local _i18n = gi18n
local _fnGetWidget = g_fnGetWidgetByName
local _nPageNum
local _layPreType
local _tbWidget = {}
local _tbPreNum = {}
local _tbCurNum = {}
local _bInThisPage
-- 用于点击激活按钮的按钮回调与激活羁绊的网络回调之间的通信，htid的table
local _activateHtids
-- 存储图标动作的数据
-- 有两个图标的
local _tbAction1Data = {
	{point1 = ccp(-193, 114), point2 = ccp(-193, 136), point3 = ccp(-98, 136), point4 = ccp(-8, 136)},
	{point1 = ccp(183, 115), point2 = ccp(183, 139), point3 = ccp(88, 139), point4 = ccp(-8, 139)},
	-- 图片消失的帧
	disappear = 80
}
-- 有三个图标的
local _tbAction2Data = {
	{point1 = ccp(-179, 72), point2 = ccp(-179, 91), point3 = ccp(-103, 121), point4 = ccp(-62, 168)},
	{point1 = ccp(185, 74), point2 = ccp(185, 93), point3 = ccp(103, 123), point4 = ccp(54, 167)},
	{point1 = ccp(-6, 262), point2 = ccp(-6, 275), point3 = ccp(-6, 221), point4 = ccp(-6, 169)},
	-- 图片消失的帧
	disappear = 76
}
-- 有四个图标的
local _tbAction3Data = {
	{point1 = ccp(-143, 259), point2 = ccp(-143, 275), point3 = ccp(-79, 219), point4 = ccp(-15, 163)},
	{point1 = ccp(-185, 44), point2 = ccp(-185, 64), point3 = ccp(-103, 98), point4 = ccp(-55, 142)},
	{point1 = ccp(143, 259), point2 = ccp(143, 275), point3 = ccp(79, 219), point4 = ccp(15, 163)},
	{point1 = ccp(185, 44), point2 = ccp(185, 64), point3 = ccp(103, 98), point4 = ccp(55, 142)},
	-- 图片消失的帧
	disappear = 76
}
-- 图片背景上的光线的tag
local _LIGHT_TAG = 999
-- 特效要在属性面板上面
-- 特效的zorder
local _ANI_ORDER = 999
-- 特效的tag
local _ANI_TAG = 999
-- 属性面板的zorder
local _BOARD_ORDER = 998
-- 属性面板的tag
local _BOARD_TAG = 998
-- 灰色遮罩的zorder
local _LAYER_ORDER = 997
-- 灰色遮罩的tag
local _LAYER_TAG = 997
-- 存储图标的table用于之后删除
local _tbPreIcon = {}
-- 特效音乐的id
local _musicId

function PartnerBondView:moduleName()
    return "PartnerBondView"
end

function PartnerBondView:ctor(...)
	_layMain = g_fnLoadUI("ui/jiban_main.json")
end

function PartnerBondView:setBtnEnabled( bEnabled )
	if (_bInThisPage) then
		_listView:setTouchEnabled(bEnabled)
		for k,v in pairs(_tbSetFalseBtn) do 
			if (v:isVisible()) then
				v:setTouchEnabled(bEnabled)
			end
		end
		_pageView:setTouchEnabled(bEnabled)
		_pLeft:setTouchEnabled(bEnabled)
		_pRight:setTouchEnabled(bEnabled)
		_layMain.BTN_EXPLAIN:setTouchEnabled(bEnabled)
	end
end

function PartnerBondView:fnPlayOneNumChangeAni( pLabel , pSNum , pFNum)
	if(not pLabel or not pSNum or not pFNum) then
		return
	end
	if(tonumber(pSNum) == tonumber(pFNum)) then
		return
	end

	local function getNumber( _num )
		local pN = math.abs(tonumber(_num))
		local pTb = {}
		-- math.modf(x/y)
		local sw = math.modf(pN/100000)
		local w = math.modf(pN/10000) - sw*10
		local q = math.modf(pN/1000) - w*10 - sw*100
		local b = math.modf(pN/100) - q*10 - w*100 - sw*1000
		local s = math.modf(pN/10) - b*10 - q*100 - w*1000 - sw*10000
		local g = pN - s*10 - b*100 - q*1000 - w*10000 - sw*100000
	
		if(pN > 0) then
			table.insert(pTb , g)
		end
		if(pN > 10) then
			table.insert(pTb , s)
		end
		if(pN > 100) then
			table.insert(pTb , b)
		end
		if(pN > 1000) then
			table.insert(pTb , q)
		end
		if(pN > 10000) then
			table.insert(pTb , w)
		end
	
		if(pN > 100000) then
			table.insert(pTb , sw)
		end
	
		return pTb
	end

	local totleCount = 20
	local pTime = 0.02
	local play_count = 0
	local ptb = getNumber(pFNum)
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

function PartnerBondView:fnRemoveTipNode(  )
	if(not _tipNode) then
		return
	end
--	_listView:setTouchEnabled(true)
--	_pageView:setTouchEnabled(true)
--	_pLeft:setTouchEnabled(true)
--	_pRight:setTouchEnabled(true)
	-- 终止音效
	AudioHelper.stopEffect(_musicId)
	_tipNode:removeFromParentAndCleanup(true)
	_tipNode = nil
end


--[[desc:播放飞属性的动画
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
-- function PartnerBondView:showFlyText1(tParam , callbackFunc )
-- --	local layout = Layout:create()
-- --	layout:setName("layForShield")
-- --	LayerManager.addLayout(layout)
-- 	self:fnRemoveTipNode()
-- 	local runningScene = CCDirector:sharedDirector():getRunningScene()
-- 	_tipNode = CCNode:create()
-- 	runningScene:addChild(_tipNode,999999999)
	
-- 	local colorPlus 		= ccc3(0x00, 0xff, 0x06) -- { red = 0x76, green=0xfc , blue =0x06 }
-- 	local colorMinus 		= ccc3(0xff,0x0,0x0)  -- red = 0x76, green=0xfc , blue =0x06
-- 	local color
-- 	local delayTime = 0.3
-- 	local partTime = 0.3
-- 	local moveTime1 = 0.5
-- 	local moveTime2 = 0.6
-- 	local pSize = runningScene:getContentSize()
-- 	for i=1, #tParam do
-- 		if(tonumber(tParam[i].num)>=0 ) then
-- 			color = colorPlus
-- 			tParam[i].txt= tParam[i].txt .. "+"
-- 		else
-- 			color = colorMinus
-- 		end

-- 		-- add by chengliang
-- 		local displayNum = tParam[i].num or 0
-- 		-- 文字 
-- 		local descNode = UIHelper.createStrokeTTF(tParam[i].txt .. displayNum,color,ccc3(0x00, 0x31, 0x00),false,32,g_sFontCuYuan)
-- 		descNode:setAnchorPoint(ccp(0.5,0.5))
-- 		descNode:setPosition(ccp(pSize.width*0.5,pSize.height*0.4))
-- 		descNode:setVisible(false)
-- 		_tipNode:addChild(descNode)

-- 		local nextMoveToP = ccp(pSize.width*0.5, pSize.height*0.7 - (i-1)*(36+32*0.5))
		

-- 		local actionArr = CCArray:create()
-- 		actionArr:addObject(CCDelayTime:create(delayTime))
-- 		actionArr:addObject(CCCallFuncN:create(function ( ... )
-- 			descNode:setVisible(true)
-- 		end))
-- 		actionArr:addObject(CCEaseOut:create(CCMoveTo:create(moveTime1, nextMoveToP),2))
-- 		local pKey = tParam[i].key or ""
-- 		local pNode = _tbWidget[i]
-- 		if(pNode) then
-- 			local pTTime = partTime + (#tParam - i)* (partTime)
-- 			actionArr:addObject( CCDelayTime:create(pTTime) )
-- 			local pPoint = ccp(pNode:getPositionX(),pNode:getPositionY())
-- 			local finalMoveToP = pNode:getParent():convertToWorldSpace(pPoint)
-- 			local pM1 = ccp((finalMoveToP.x - nextMoveToP.x)*1/3 + nextMoveToP.x , nextMoveToP.y - (nextMoveToP.y - finalMoveToP.y)*1/3)
-- 			local pM2 = ccp((finalMoveToP.x - nextMoveToP.x)*2/3 + nextMoveToP.x , nextMoveToP.y - (nextMoveToP.y - finalMoveToP.y)*2/3)
			
-- 			local parray = CCArray:create()
-- 			parray:addObject(CCMoveTo:create(moveTime2*0.5 , pM1))
-- 			parray:addObject(CCMoveTo:create(moveTime2*0.3 , pM2))
-- 			parray:addObject(CCMoveTo:create(moveTime2*0.2 , finalMoveToP))
-- 			local pswq = CCSequence:create(parray)

-- 			local ppAc = CCSpawn:createWithTwoActions(pswq , CCScaleTo:create(moveTime2 , 0.75))
-- 			actionArr:addObject(ppAc)
-- 		end

-- 		function fnPlayLabelAni(_key)
-- 			if(not _key) then
-- 				return
-- 			end
-- 			local pLabel = _tbWidget[_key]
-- 			local pSNum = _tbPreNum[_key]
-- 			local pFNum = _tbCurNum[_key]
		
-- 			self:fnPlayOneNumChangeAni(pLabel,pSNum,pFNum)
-- 		end

-- 		local function playAni( ... )
-- 			fnPlayLabelAni(tParam[i].key)
-- 			if(i == 1) then
-- 				AudioHelper.playEffect("audio/effect/texiao_zhandouli.mp3")
-- 			end
-- 		end

-- 		local function flyEndCallback( ttfNode )
-- 			if(not ttfNode) then
-- 				return
-- 			end
-- 			ttfNode:removeFromParentAndCleanup(true)
-- 			ttfNode = nil
-- 		end

-- 		actionArr:addObject(CCCallFuncN:create(playAni))
-- 		actionArr:addObject(CCCallFuncN:create(flyEndCallback))

-- 		actionArr:addObject(CCCallFuncN:create(function ( ... )
-- 					self:reloadHeroInfo()
-- 				end))

-- 		if(i==#tParam) then
-- 			actionArr:addObject(CCCallFuncN:create(function( ... )
-- 				self:fnRemoveTipNode()
-- 			end))
-- 			if(callbackFunc) then
-- 				actionArr:addObject(CCCallFuncN:create(function ( ... )
-- 					callbackFunc()
-- 				end))
-- 			end
-- 		end

-- 		local textAction = CCSequence:create(actionArr)
-- 		descNode:runAction(textAction)
-- 		delayTime = delayTime + partTime
-- 	end
-- end

--[[desc:播放飞属性的动画  新版本
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function PartnerBondView:showFlyText(tParam , callbackFunc )
	local runningScene = CCDirector:sharedDirector():getRunningScene()

	local colorPlus 		= ccc3(0x00, 0xff, 0x06) -- { red = 0x76, green=0xfc , blue =0x06 }
	local colorMinus 		= ccc3(0xff,0x0,0x0)  -- red = 0x76, green=0xfc , blue =0x06
	local color
	local pSize = runningScene:getContentSize()

	local mHangPart = 10 --行间距
	local mTopPart = 17  --背景上下边距
	local movetime = 0.33  --字体向下飘的时间
	local mFontSize = 28

	local sp1 = CCSprite:create("images/common/showflytext_bg1.png")	
	local oriSize = sp1:getContentSize()
	-- 背景上的字
	local bgWord = CCSprite:create("images/jiban/jiacheng_success.png")
	local wordSize = bgWord:getContentSize()

	local rect = CCRect(oriSize.width/2-80,oriSize.height/2-15,160,30)
	local bgSp = CCScale9Sprite:create(rect,"images/common/showflytext_bg1.png")	
	_tipNode:addChild(bgSp, _BOARD_ORDER, _BOARD_TAG)
	local bgSpW = oriSize.width
	-- 根据宽度计算需要空余多少高度来放艺术字
	local wordScale = bgSpW / wordSize.width
	local wordHeight = wordScale * wordSize.height
	local bgSpH = #tParam * mFontSize + (#tParam-1) * mHangPart + mTopPart*2 + wordHeight 
	local bgSize = CCSizeMake(bgSpW,bgSpH)
	-- 将字放在背景上
	bgSp:addChild(bgWord)
	bgWord:setScale(wordScale)
	bgWord:setPosition(ccp(bgSize.width/2, bgSize.height - mTopPart - wordHeight / 3))
	
--	bgSp:setScale(0)
	bgSp:setOpacity(0)

	bgSp:setContentSize(bgSize)
	bgSp:setPosition(ccp(pSize.width/2,pSize.height/2 + wordHeight / 2))

	local starty = bgSize.height - mTopPart-mFontSize/2 - wordHeight   --label的坐标
	local startx = bgSize.width/2

	local labelSize
	for i=1,#tParam do
		tParam[i].txt= tParam[i].txt .. " "
		if(tonumber(tParam[i].num)>=0 ) then
			color = colorPlus
			tParam[i].txt= tParam[i].txt .. "+"
		else
			color = colorMinus
		end

		-- add by chengliang
		local displayNum = tParam[i].num or 0
		-- 文字 
		local descNode = UIHelper.createStrokeTTF(tParam[i].txt .. displayNum,color,ccc3(0x00, 0x31, 0x00),false,32,g_sFontCuYuan)
		bgSp:addChild(descNode)
		descNode:setTag(i)

		if (i==1) then 
			labelSize = descNode:getContentSize()
			descNode:setAnchorPoint(ccp(0.5,0.5))
			descNode:setPosition(ccp(startx,starty-(i-1)*(mHangPart+mFontSize)))
		else 
			descNode:setAnchorPoint(ccp(0,0.5))
			descNode:setPosition(ccp(startx-labelSize.width/2,starty-(i-1)*(mHangPart+mFontSize)))
		end 
	end

	-- 属性字飘到对应位置
	local function callback( ... )
		for i=1,#tParam do
			-- 属性从背景上移到_tipNode. 
			local node = bgSp:getChildByTag(i)
			local pos = ccp(node:getPositionX(),node:getPositionY())
			local wpos = node:getParent():convertToWorldSpace(pos)
			node:retain()
			node:removeFromParentAndCleanup(false)
			_tipNode:addChild(node, _BOARD_ORDER)
			node:release()
			node:setPosition(wpos)

			local mArray = CCArray:create()
			local pKey = tParam[i].key or ""
			local pNode = _tbWidget[i]
			if(pNode) then
				local pPoint = ccp(pNode:getPositionX(),pNode:getPositionY())
				local finalMoveToP = pNode:getParent():convertToWorldSpace(pPoint)
				mArray:addObject(CCMoveTo:create(movetime , finalMoveToP))
			end

			function fnPlayLabelAni(_key)
				if(not _key) then
					return
				end
				local pLabel = _tbWidget[_key]
				local pSNum = _tbPreNum[_key]
				local pFNum = _tbCurNum[_key]
			
				self:fnPlayOneNumChangeAni(pLabel,pSNum,pFNum)
			end

			local function playAni( ... )
				fnPlayLabelAni(tParam[i].key)
				if(i == 1) then
					AudioHelper.playEffect("audio/effect/texiao_shuzhibianhua.mp3")
				end
			end

			local function flyEndCallback( ttfNode )
				if(not ttfNode) then
					return
				end
				ttfNode:removeFromParentAndCleanup(true)
				ttfNode = nil
			end

			mArray:addObject(CCCallFuncN:create(playAni))
			mArray:addObject(CCCallFuncN:create(flyEndCallback))  --单个属性节点删除
			mArray:addObject(CCCallFuncN:create(function ( ... )
						self:reloadHeroInfo()
					end))

			if(i==#tParam) then
				mArray:addObject(CCCallFuncN:create(function( ... )
					self:fnRemoveTipNode()                       -- _tipNode删除
				end))
				if(callbackFunc) then
					mArray:addObject(CCCallFuncN:create(function ( ... )
						callbackFunc()
					end))
				end
			end

			local textAction = CCSequence:create(mArray)
			node:runAction(textAction)
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
		
--		array:addObject(spawn0)
		array:addObject(fadeto0)
		array:addObject(fadeto1)
--		array:addObject(spawn)
		array:addObject(fadeto2)
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

function PartnerBondView:setAllGray( parentNode , bGray )
	parentNode:setGray(bGray)

	local iconArray = UIHelper.getTbNodes(parentNode)

	for k,v in pairs(iconArray) do
		v:setGray(bGray)
	end

	local iconChildren = parentNode:getChildren()

	for i = 1, iconChildren:count() do
		local childNode = tolua.cast(iconChildren:objectAtIndex(i-1),"CCNode")
		childNode:setGray(bGray)
	end
end

function PartnerBondView:setArrowState( isLeft , isRight )
	_pLeft = _layMain.BTN_LEFT
    _pLeft:setEnabled(isLeft)
    _pLeft:addTouchEventListener(function ( sender ,eventType)
        if (eventType == TOUCH_EVENT_ENDED) then
            AudioHelper.playCommonEffect()
            _pageView:scrollToPage(_nPageNum-2)
--            _nPageNum = _nPageNum - 1
            self:heroPageViewEventListener()
            self:reloadArrowState()
        end
    end)
    _pRight = _layMain.BTN_RIGHT
    _pRight:setEnabled(isRight)
    _pRight:addTouchEventListener(function ( sender ,eventType)
        if (eventType == TOUCH_EVENT_ENDED) then
            AudioHelper.playCommonEffect()
            _pageView:scrollToPage(_nPageNum)
--            _nPageNum = _nPageNum + 1
            self:heroPageViewEventListener()
            self:reloadArrowState()
        end
    end)
end

function PartnerBondView:reloadHeroInfo( )
	local heroInfo = _layMain.IMG_HEROINFO

	local heroName = heroInfo.LAY_NAME.TFD_PARTNER_NAME
	local heroLevel = heroInfo.LAY_NAME.TFD_ADVANCE_LV

	heroName:setText(PartnerBondModel.getHeroName())
	heroLevel:setText(PartnerBondModel.getEnevolveLevel())
	heroLevel:setPositionX( heroName:getPositionX() + heroName:getSize().width / 2 + heroLevel:getSize().width / 2)
	UIHelper.labelNewStroke(heroName , ccc3(0x28,0x00,0x00) , 2)
	UIHelper.labelNewStroke(heroLevel , ccc3(0x28,0x00,0x00) , 2)
	local nameColor = g_QulityColor2[tonumber(PartnerBondModel.getNameColorByHtid(PartnerBondModel.getHtid()))]
	heroName:setColor(nameColor)
	heroLevel:setColor(nameColor)

	local tbHeroInfo = PartnerBondModel.getHeroFightInfo()
	
	for k,v in pairs(tbHeroInfo) do 
		local widgetName = "LAY_ATTR" .. tostring(k)
		local layAttr = _fnGetWidget( heroInfo , widgetName )
		layAttr.tfd_life:setText(tbHeroInfo[k].name)
		layAttr.TFD_NUM:setText(tbHeroInfo[k].value)
		layAttr.TFD_NUM:setPositionX(layAttr.tfd_life:getPositionX() + layAttr.tfd_life:getSize().width / 2)
		UIHelper.labelNewStroke(layAttr.tfd_life , ccc3(0x45,0x05,0x05) , 2)
		UIHelper.labelNewStroke(layAttr.TFD_NUM , ccc3(0x45,0x05,0x05) , 2)
	end

	self:reloadArrowState()
end

function PartnerBondView:reloadArrowState()
	if (PartnerBondModel.getBondPageNum() == 1) then
		self:setArrowState(false, false)
	elseif (_nPageNum == 1) then
		self:setArrowState(false, true)
	elseif (_nPageNum == PartnerBondModel.getBondPageNum()) then
		self:setArrowState(true, false)
	else
		self:setArrowState(true, true)
	end
end

--[[desc:刷新人物图像信息界面
    arg1: 无
    return: 无
—]]
function PartnerBondView:initPageView()
	local pageClone = _pageView.lay_herolist:clone()
	_pageView.lay_herolist:removeFromParentAndCleanup(true)
	_pageView:removeAllPages()

	for i = 1,PartnerBondModel.getBondPageNum() do
		local pagePer = pageClone:clone()
	
		local imgHero = pagePer.img_hero
		
		imgHero:loadTexture(PartnerBondModel.getHeroImage(i))
		
		_pageView:addWidgetToPage(pagePer, i, true)
	end
	
	local pageNum = _pageView:getPages():count()
	
	_pageView:initToPage( _nPageNum - 1 )
end

--[[desc: 点击激活按钮刷新激活的那一行
    arg1: 行号从0开始
    return: 无
—]]
function PartnerBondView:reloadOneCell( nIdx )
	if (nIdx) then
		local cell = _listView:getItem(nIdx)
	
		local btnActivite = cell.BTN_JIHUO
	
		btnActivite:setTouchEnabled(false)
		btnActivite:setVisible(false)
		cell.img_done:setVisible(true)
		cell.img_belly:setVisible(false)
		cell.TFD_BELLY:setVisible(false)
	end
end

--[[desc:向一个icon控件添加背景光效,根据quality
    arg1: icon控件，quality
    return: 无
—]]
function PartnerBondView:addBgLightToIcon( icon, quality )
-- 这段特效不用了，自行添加图片
--	-- 不同颜色背景光效的特效名
--	local tbNames = {"win_drop_black/white", "win_drop_black/white", "win_drop_green", "win_drop_blue", "win_drop_purple", "win_drop_orange"}
--	-- 构造背景特效需要的参数
--	local tbParams = {}
--	tbParams.filePath = "images/effect/battle_result/win_drop.ExportJson"
--	tbParams.animationName = tbNames[tonumber(quality)]
--	-- 创建特效
--	local animation = UIHelper.createArmatureNode(tbParams)
--	-- 向按钮上添加特效，添加在下面
--	icon:addNode(animation, -1, -1)
	-- 添加图片
	local path1 = "images/jiban/"
	local tbGlowName = {"white_glow.png", "white_glow.png", "green_glow.png", "blue_glow.png", "purple_glow.png", "orange_glow.png", "red_glow.png"}
	local tbLineName = {"white_line.png", "white_line.png", "green_line.png", "blue_line.png", "purple_line.png", "orange_line.png", "red_line.png"}

	local bgGlow = CCSprite:create(path1 .. tbGlowName[quality])
	local bgLight = CCSprite:create(path1 .. tbLineName[quality])

	icon:addNode(bgGlow, -1)
	icon:addNode(bgLight, -2, _LIGHT_TAG)
end

--[[desc:使图标进行对应的动作
    arg1: icon控件的table, 完成动作后的回调
    return: 无  
—]]
function PartnerBondView:createActionToWidget( tbIcon, callFun )
	-- 计算有几个图标判断用哪个动画的数据
	local tbActionData
	if (#tbIcon == 2) then
		tbActionData = _tbAction1Data
	elseif (#tbIcon == 3) then
		tbActionData = _tbAction2Data
	elseif (#tbIcon == 4) then
		tbActionData = _tbAction3Data
	end

	-- 初始化三段动作的时间长度
	-- point1到point2和光线转动的时间长度
	local time1 = (tbActionData.disappear - 5 - 8) / 60
	-- point2到point3和point3到point4
	local time2 = 2 / 60
	-- point1到point2减少5帧
	local time3 = (tbActionData.disappear - 5 - 8 - 5) / 60
	-- 停留5帧
	local time4 = 5 / 60

	-- 
	local eventArray = CCArray:create()
	local function iconAction()
		for k,v in pairs(tbIcon) do
			-- 将图标放到起始位置
			v.icon:setVisible(true)
			v.icon:setPosition(tbActionData[k].point1)
			-- 设置动作
			local actionArray = CCArray:create()
			-- 1移动到2
--			actionArray:addObject(CCMoveTo:create(time1, tbActionData[k].point2))
			actionArray:addObject(CCMoveTo:create(time3, tbActionData[k].point2))
			-- 2到3
			actionArray:addObject(CCMoveTo:create(time2, tbActionData[k].point3))
			-- 3到4
			actionArray:addObject(CCMoveTo:create(time2, tbActionData[k].point4))
			-- 停留5帧
			actionArray:addObject(CCDelayTime:create(time4))
			-- 图标消失
			actionArray:addObject(CCCallFuncN:create(function ( ... )
				v.icon:setVisible(false)
			end))
			local actionSequence = CCSequence:create(actionArray)
			v.icon:runAction(actionSequence)

			-- 添加背景上光线的动画
			local bgLight = v.icon:getNodeByTag(_LIGHT_TAG)

			local scaleAction = CCRotateTo:create(time1, 180)
			bgLight:runAction(scaleAction)
		end
	end
	eventArray:addObject(CCCallFuncN:create(iconAction))
	eventArray:addObject(CCCallFuncN:create(function ( ... )
		if (callFun) then
			callFun()
		end
	end))

	_layMain:runAction(CCSequence:create(eventArray))
end

--[[desc:刷新羁绊信息界面
    arg1: 无
    return: 无
—]]
function PartnerBondView:reloadListView( ... )
	local tbBondInfo = PartnerBondModel.getBond()
	local cell
	local tbBondState = {}

	-- 将cell上的控件设置隐藏或显示
	local function setCellChildrenVisibled( cellWidget, bVisibled )
		local arrayCellChildren = cellWidget:getChildren()
		for i = 0, arrayCellChildren:count() - 1 do
			local childWidget = tolua.cast(arrayCellChildren:objectAtIndex(i), "CCNode")
			childWidget:setVisible(bVisibled)
		end
		cellWidget.IMG_NAME_BG:setVisible(true)
		cellWidget.IMG_NAME_BG.TFD_NAME:setVisible(bVisibled)
		cellWidget.IMG_BG:setVisible(true)
		cellWidget.IMG_BG.img_partner1:setVisible(bVisibled)
		cellWidget.IMG_BG.img_partner2:setVisible(bVisibled)
		cellWidget.IMG_BG.img_partner3:setVisible(bVisibled)
	end

	UIHelper.initListWithNumAndCell( _listView, #tbBondInfo )
	_listView:jumpToTop()
	_tbSetFalseBtn = {}
	-- 删除之前添加的icon
	for k,v in pairs(_tbPreIcon) do
		if (UIHelper.isGood(v)) then
			v:removeFromParentAndCleanup(true)
		end
	end
	_tbPreIcon = {}

	for k,v in pairs(tbBondInfo) do
		cell = _listView:getItem( k - 1 )

		-- 将除了底板之外的控件隐藏
		setCellChildrenVisibled(cell.IMG_JIBAN1, false)

		local function setCellByInfo( listViewCell, listViewIndex, cellInfo )
			if (g_fScaleX > g_fScaleY) then
				listViewCell.IMG_JIBAN1:setScaleX(g_fScaleY)
				listViewCell.IMG_JIBAN1:setScaleY(g_fScaleY)
			else
				listViewCell.IMG_JIBAN1:setScaleX(g_fScaleX)
				listViewCell.IMG_JIBAN1:setScaleY(g_fScaleX)
			end

			-- 将除了底板之外的控件显示出来
			setCellChildrenVisibled(listViewCell.IMG_JIBAN1, true)

			tbBondState = BondManager.getBond( cellInfo.bondId , PartnerBondModel.getHid())
			logger:debug({tbBondState = tbBondState})

			local partnerUndo = listViewCell.tfd_huoban_check1
			partnerUndo:setText(_i18n[6101])           
			local treasureUndo = listViewCell.tfd_baowu_check
			treasureUndo:setText(_i18n[6102]) 
			local bondUndo = listViewCell.tfd_huoban_check2
			bondUndo:setText(_i18n[6103]) 
			local btnActivite = listViewCell.BTN_JIHUO
			UIHelper.titleShadow(btnActivite)
			local btnNotEquip = listViewCell.BTN_NOTEQUIP
			UIHelper.titleShadow(btnNotEquip)
			btnNotEquip:setTouchEnabled(false)
			local imgDone = listViewCell.img_done  
			listViewCell.TFD_BELLY:setText(cellInfo.bellyPrize)   

			imgDone:setVisible(false)
			btnActivite:setVisible(false)
			btnActivite:setTouchEnabled(false)
			treasureUndo:setVisible(false)
			partnerUndo:setVisible(false)
			bondUndo:setVisible(false)
			btnNotEquip:setVisible(false)
			-- 初始化一下激活按钮的状态
			btnActivite:setBright(true)

			listViewCell.TFD_NAME:setText(cellInfo.name)
			local left,right
			left,right = string.find(tbBondState.attrDes , '+')
			left = left - 6
			right = right
			local attrDes1 = string.sub(tbBondState.attrDes , left , right)
			local attrDes2 = string.sub(tbBondState.attrDes,string.find(tbBondState.attrDes , "%d+%%"))
			local attrDes = attrDes1 .. attrDes2
	
			listViewCell.TFD_BUFF:setText(attrDes)

			-- 激活特效中的人物htid,将本人加进去,并将本人存在self字段中方便之后设置叠放顺序
			local tbHtid = { PartnerBondModel.getHtid() }
	
			if (tbBondState.type == 1) then 
				for i = 1,3 do
					local strWidget = "img_partner" .. tostring(i)
					local imgWidget = _fnGetWidget( listViewCell , strWidget )
					if i > #tbBondState.models then
						imgWidget:setVisible(false)
					else
						imgWidget:setVisible(true)
						local nHtid = HeroModel.fnGetHaveHtidByModelID(tbBondState.models[i][1])
						imgWidget.TFD_NAME:setText(PartnerBondModel.getHeroName(nHtid))
						assert(g_QulityColor[tonumber(PartnerBondModel.getNameColorByHtid(nHtid))] , "g_QulityColor not found.")
						imgWidget.TFD_NAME:setColor(g_QulityColor[tonumber(PartnerBondModel.getNameColorByHtid(nHtid))])
						local btnIcon = HeroUtil.createHeroIconBtnByHtid(nHtid , nil , function ( sender, eventType )
							if (eventType == TOUCH_EVENT_ENDED) then
								AudioHelper.playInfoEffect()
								require "script/module/public/FragmentDrop"
								local tbFragInfo = PartnerBondModel.getFragInfo( nHtid )
								local nFragId = tbFragInfo.id
								local Args = { id = nFragId}
								local fragmentDrop = FragmentDrop:new()
								local fragmentDroplayout = fragmentDrop:create(nFragId,dropCallfn)
								
								LayerManager.addLayout(fragmentDroplayout)
							end
						end)
						-- 向人物htid的table中添加一个htid
						tbHtid[#tbHtid + 1] = nHtid
						
	
						if not (tbBondState.state == BondManager.BOND_OPEN) then
							if (not ( tbBondState.models[i][2] ) and not HeroModel.isBuddy(nHtid)) then
								self:setAllGray( btnIcon , true )
							end
						end
				
						imgWidget:addChild(btnIcon)
						_tbPreIcon[#_tbPreIcon + 1] = btnIcon
	
						-- 将按钮加入屏蔽列表
						_tbSetFalseBtn[#_tbSetFalseBtn + 1] = btnIcon
					end
				end
			elseif (tbBondState.type == 2 or tbBondState.type == 3) then
				for i = 1,3 do
					local strWidget = "img_partner" .. tostring(i)
					local imgWidget = _fnGetWidget( listViewCell , strWidget )
					if i > 1 then
						imgWidget:setVisible(false)
					else
						imgWidget:setVisible(true)
						local nTreaId = tbBondState.treaId
						local tbTreaInfo
						local treaFrag
						if (tbBondState.type == 2) then
							tbTreaInfo = PartnerBondModel.getTreasureInfoById(nTreaId)
							local itemInfo = ItemUtil.getItemById(nTreaId)
							local fragStr = itemInfo.fragment_ids
							treaFrag = tonumber(string.split(fragStr, "|")[1])
						elseif (tbBondState.type == 3) then
							tbTreaInfo = PartnerBondModel.getEquipInfoById(nTreaId)
							local itemInfo = ItemUtil.getItemById(nTreaId)
							local fragStr = itemInfo.fragmentId
							treaFrag = tonumber(fragStr)
						end
						imgWidget.TFD_NAME:setText(tbTreaInfo.name)
						imgWidget.TFD_NAME:setColor(g_QulityColor[tonumber(PartnerBondModel.getNameColorById(nTreaId , tbBondState.type))])
						
						local btnIcon = ItemUtil.createBtnByTemplateId(nTreaId , function ( sender, eventType )
							if (eventType == TOUCH_EVENT_ENDED) then
								AudioHelper.playInfoEffect()
								PublicInfoCtrl.createItemDropInfoViewByTid(treaFrag or nTreaId)
							end
						end , {true , true})
	
						if not (tbBondState.state == BondManager.BOND_OPEN) then
							if (tbBondState.state == BondManager.BOND_NOT_REACHED) then
								self:setAllGray( btnIcon , true )
							end
						end
				
						imgWidget:addChild(btnIcon)
						_tbPreIcon[#_tbPreIcon + 1] = btnIcon
	
						-- 将按钮加入屏蔽列表
						_tbSetFalseBtn[#_tbSetFalseBtn + 1] = btnIcon
					end
				end
			end
	
			btnActivite:addTouchEventListener(function ( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					AudioHelper.playCommonEffect()
					
					if (cellInfo.bellyPrize > UserModel.getSilverNumber()) then
						ShowNotice.showShellInfo(_i18n[1617])
						PublicInfoCtrl.createItemDropInfoViewByTid(60406,nil,true)  -- 贝里不足引导界面
					else   
						if (not _pageView:isAutoScrolling()) then 
							BondRequst.activate( HeroModel.getHeroModelId( cellInfo.htid ), cellInfo.bondId , function ( ... )
								PartnerBondModel.setBtnIndex(listViewIndex - 1 , cellInfo.htid)
							end)
							UserModel.addSilverNumber(-cellInfo.bellyPrize)
 							-- 将htid的table存起来用于在网络回调里播放动画
 							_activateHtids = tbHtid
						end
					end
	
						-- 测试播放碰撞特效
					-- self:createBumpAnimature(tbHtid, function ( ... )
					-- 	tbShowText = {
					-- 			{txt = "aaaaa" , key = 1 , num = 222},
					-- 			{txt = "aaaaa" , key = 2 , num = 222},
					-- 			{txt = "aaaaa" , key = 3 , num = 222}
	
					-- }
						
					-- 	self:showFlyText(tbShowText)
					-- end)
	
				end
			end)

			
	
			if (tbBondState.state == BondManager.BOND_OPEN) then
				imgDone:setVisible(true)
				listViewCell.img_belly:setVisible(false)
				listViewCell.TFD_BELLY:setVisible(false)
			elseif (tbBondState.state == BondManager.BOND_REACHED) then
				if (tbBondState.type == 1) then
					btnActivite:setVisible(true)
					btnActivite:setTouchEnabled(true)
				end
			elseif (tbBondState.state == BondManager.BOND_NOT_REACHED) then
				listViewCell.img_belly:setVisible(false)
				listViewCell.TFD_BELLY:setVisible(false)
				if (tbBondState.type == 1) then
					partnerUndo:setVisible(true)
					bondUndo:setVisible(true)
					btnActivite:setVisible(true)
					btnActivite:setBright(false)
				elseif (tbBondState.type == 2 or tbBondState.type == 3) then
					treasureUndo:setVisible(true)
					bondUndo:setVisible(true)
					btnNotEquip:setVisible(true)
				end
			end
	
			if (btnActivite:isTouchEnabled()) then
				table.insert(_tbSetFalseBtn , btnActivite)
			end
		end

		
--		if (k > 3) then
			performWithDelayFrame(_layMain, function ( ... )
				setCellByInfo(_listView:getItem( k - 1 ), k, tbBondInfo[k])
			end, (k))
--		else
--			setCellByInfo(cell, k, v)
--		end
	end
--	LayerManager.removeLayoutByName("layForShield")
--	_listView:setTouchEnabled(true)
--	_pageView:setTouchEnabled(true)
end

function PartnerBondView:heroPageViewEventListener( sender, eventType )
--    local pageView = tolua.cast(sender, "PageView")
	local page = _pageView:getCurPageIndex()

    if (_nPageNum ~= page + 1) then
     	_nPageNum = page + 1
     	logger:debug("_nPageNum" .. tostring(_nPageNum))
     	self:fnRemoveTipNode()	
		PartnerBondModel.setPageNum(_nPageNum)
--		performWithDelay(_layMain, function ( ... )
		revmoeFrameNode(_layMain)
		self:reloadListView()
--		end, 1/60)
		self:reloadHeroInfo()
	end
end

--[[desc:创建碰撞的特效
    arg1: 传入htid的table, 属性面板出现的关键帧的回调，播放结束的回调
    return: 无  
—]]
function PartnerBondView:createBumpAnimature( tbHtid, attrCallFun, callFun )
	-- 添加一个用于加动画的节点
	self:fnRemoveTipNode()
	local runningScene = CCDirector:sharedDirector():getRunningScene()
	if (not _tipNode) then
		_tipNode = CCNode:create()
		runningScene:addChild(_tipNode,999999999)
	end

	-- 播放动画时添加一个遮罩，放在最下面
	local blackLayer =  CCLayerColor:create(ccc4(0, 0, 0, 190))
	_tipNode:addChild(blackLayer, _LAYER_ORDER, _LAYER_TAG)

	-- 将htid转化为icon
	local tbIcon = {}
	for k,v in pairs(tbHtid) do
		local tmpIcon = HeroUtil.createHeroIconBtnByHtid(v)
		if (v == PartnerBondModel.getHtid()) then
			tbIcon[#tbIcon + 1] = {icon = tmpIcon, 
									quality = PartnerBondModel.getNameColorByHtid(v),
									isSelf = true
			}
		else
			tbIcon[#tbIcon + 1] = {icon = tmpIcon, 
									quality = PartnerBondModel.getNameColorByHtid(v),
			}
		end
	end

	-- 构造特效需要的参数
	local tbParams = {}
	if (#tbIcon == 2) then
		tbParams.filePath = "images/effect/jiban/jiban_success.ExportJson"
		tbParams.animationName = "jiban_success"
	elseif (#tbIcon == 3) then
		tbParams.filePath = "images/effect/jiban/jiban_success_1.ExportJson"
		tbParams.animationName = "jiban_success_1"
	elseif (#tbIcon == 4) then
		tbParams.filePath = "images/effect/jiban/jiban_success_2.ExportJson"
		tbParams.animationName = "jiban_success_2"
	end

	tbParams.fnMovementCall = function ( armature,movementType,movementID )
		if (movementType == 1) then
			armature:removeFromParentAndCleanup(true)
		end
	end

	local function screenMove( )
		local screenMoveSub = 9 * g_fScaleY
		local screenArray = CCArray:create()
		screenArray:addObject(CCDelayTime:create(2/60))
		screenArray:addObject(CCCallFuncN:create(function ( ... )
			_layMain:setPositionY(screenMoveSub)
		end))
		screenArray:addObject(CCDelayTime:create(2/60))
		screenArray:addObject(CCCallFuncN:create(function ( ... )
			_layMain:setPositionY(0)
		end))
		screenArray:addObject(CCDelayTime:create(2/60))
		screenArray:addObject(CCCallFuncN:create(function ( ... )
			_layMain:setPositionY(screenMoveSub)
		end))
		screenArray:addObject(CCDelayTime:create(2/60))
		screenArray:addObject(CCCallFuncN:create(function ( ... )
			_layMain:setPositionY(0)
		end))
		screenArray:addObject(CCDelayTime:create(2/60))
		screenArray:addObject(CCCallFuncN:create(function ( ... )
			_layMain:setPositionY(screenMoveSub)
		end))
		screenArray:addObject(CCDelayTime:create(2/60))
		screenArray:addObject(CCCallFuncN:create(function ( ... )
			_layMain:setPositionY(0)
		end))
		local screenSeq = CCSequence:create(screenArray)
		_layMain:runAction(screenSeq)
	end

	tbParams.fnFrameCall = function ( bone, frameEventName, originFrameIndex, currentFrameIndex )
		if (frameEventName == "1") then
			self:createActionToWidget(tbIcon, function ( ... )
				if (callFun) then
					callFun()
				end
			end)
		elseif (frameEventName == "2") then
			-- 属性面板
			if (attrCallFun) then
				attrCallFun()
			end
		elseif (frameEventName == "3") then
			-- 震屏操作
			screenMove()
		end
	end

	local animation = UIHelper.createArmatureNode(tbParams)

	-- 播放背景音乐
	_musicId = AudioHelper.playEffect("audio/btn/texiao_jiban_success.mp3")

	-- 将人物头像table中的icon全部加上背景特效,并加到大特效上
	for k,v in pairs(tbIcon) do
		self:addBgLightToIcon( tbIcon[k].icon, v.quality )
		-- 如果是这个英雄本人，图标要在最上面
		if (v.isSelf) then
			animation:addChild(v.icon, 2)
		else
			animation:addChild(v.icon, 1)
		end
		v.icon:setVisible(false)
	end

	_tipNode:addChild(animation, _ANI_ORDER, _ANI_TAG)
	animation:setScale(g_fScaleX > g_fScaleY and g_fScaleX or g_fScaleY)

	animation:setPosition(ccp(g_winSize.width/2, g_winSize.height/2))
end

function PartnerBondView:notifyObserver( )
	self:setBtnEnabled(false)
	self:reloadOneCell( PartnerBondModel.getBtnIndex() )
	for k,v in pairs(PartnerBondModel.getHeroFightInfo()) do
		_tbPreNum[k] = v.value
	end
	UserModel.setInfoChanged(true)
	logger:debug({bondViewHtid = PartnerBondModel.getHtid()})
	logger:debug({bondViewHid = PartnerBondModel.getHid()})
	UserModel.updateFightValue({[PartnerBondModel.getHid()] = {1,2}})
	updateInfoBar()
	PartnerBondModel.setFightInfo()
	

	-- 播放碰撞特效
	self:createBumpAnimature(_activateHtids, function ( ... )
		local tbFightInfo = PartnerBondModel.getHeroFightInfo()
		local tbShowText = {}
		for k,v in pairs(tbFightInfo) do
			_tbCurNum[k] = v.value
			if (_tbPreNum[k] ~= v.value) then
				table.insert(tbShowText , {txt = v.name , key = k , num = v.value - _tbPreNum[k]})
			end
		end
		
		self:showFlyText(tbShowText)
	end)

	if (_layPreType == 2) then
		performWithDelay(_layMain , function ( ... )
			MainFormationTools.removeFlyText()
			MainFormationTools.fnShowFightForceChangeAni( nil , function ( ... )
				--LayerManager.removeLayoutByName("layForShield")
				self:setBtnEnabled(true)
			end)
		end , 3)
	else
		performWithDelay(_layMain , function ( ... )
			self:setBtnEnabled(true)
		end , 3)
	end
end

function PartnerBondView:create( layPreType , heroId )
	_tbPreIcon = {}
	_layPreType = layPreType
	PartnerBondModel.setHid( heroId , _layPreType )
	_nPageNum = PartnerBondModel.getBondPage()
	_tbWidget = {_layMain.IMG_HEROINFO.LAY_ATTR1.TFD_NUM,
				_layMain.IMG_HEROINFO.LAY_ATTR2.TFD_NUM,
				_layMain.IMG_HEROINFO.LAY_ATTR3.TFD_NUM,
				_layMain.IMG_HEROINFO.LAY_ATTR4.TFD_NUM,
				_layMain.IMG_HEROINFO.LAY_ATTR5.TFD_NUM,
	}
	_listView = _layMain.LAY_JIBAN.LSV_JIBAN_LIST
	UIHelper.initListView(_listView)

	_pageView = _layMain.PGV_HEROLIST
	self:initPageView()

	self:reloadListView()
	self:reloadHeroInfo()
	
	-- 说明按钮
	_layMain.BTN_EXPLAIN:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			require "script/module/partner/PartnerBond/PartnerBondExplainView"
			local explainViewInstance = PartnerBondExplainView:new() 
			LayerManager.addLayout(explainViewInstance:create())
		end
	end)

	_layMain.BTN_CLOSE:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			--值为2表示阵容进入的
			AudioHelper.playCloseEffect()
			if (_layPreType == 2) then
				LayerManager.changeModule(MainFormation.create( tonumber(PartnerBondModel.getFormationPage()) ), MainFormation.moduleName(),{1,3},true)
			else
				LayerManager.changeModule(MainPartner.create(), MainPartner.moduleName(),{1,3},true)
				PlayerPanel.addForPartnerStrength()
			end
		end
	end)

	if (_layPreType ~= 2) then
		_pageView:setTouchEnabled(false)
	end

	_pageView:addEventListenerPageView(function ( sender, eventType )
		if (eventType == PAGEVIEW_EVENT_TURNING) then
			self:heroPageViewEventListener( sender, eventType )
		end
	end)

	

	UIHelper.registExitAndEnterCall(_layMain, function ( )	
		_bInThisPage = false	
		self:fnRemoveTipNode()
--		MainFormationTools.removeFlyText()
		GlobalNotify.removeObserver(BondManager.BOND_MSG.CB_BOND_OPEN, BondManager.BOND_MSG.CB_BOND_OPEN)
    end , function ( ... )
    	_bInThisPage = true
    	GlobalNotify.addObserver(BondManager.BOND_MSG.CB_BOND_OPEN , function ( ... )
			self:notifyObserver()
		end , false , BondManager.BOND_MSG.CB_BOND_OPEN )
    end)

	return _layMain
end
