-- Filename：	CheckCodeTip.lua
-- Author：		chengliang
-- Date：		2015-3-12
-- Purpose：		验证码确认框

module("CheckCodeTip", package.seeall)


local _bgLayer
local _bgSprite
local _zOrder 	
local _bgSprite 

local _layerSize 
local _title 
local _check_code
local _callback
local _pid
local _check_file
local temp_index = 0

function init()
	_bgLayer 	= nil
	_priority 	= nil
	_zOrder 	= nil
	_bgSprite 	= nil
	_layerSize	= nil
	_title 		= nil
	_check_code = nil
	_pid 		= nil
	_check_file = nil
	_callback   = nil
end

function getBgSprite()
	return _bgSprite
end

local function onTouchesHandler( eventType, x, y )
	return true
end

 --]]
local function onNodeEvent( event )
	if (event == "enter") then
		_bgLayer:registerScriptTouchHandler(onTouchesHandler, false, _priority, true)
		_bgLayer:setTouchEnabled(true)
	elseif (event == "exit") then
		_bgLayer:unregisterScriptTouchHandler()
        _bgLayer = nil
	end
end

-- 关闭按钮的回调函数
function closeCb()
	_bgLayer:removeFromParentAndCleanup(true)
	_bgLayer = nil
end

-- 确认
function menuAction( ... )
	print("menuAction")
	local checkCodeStr = _check_code:getText()
	if( checkCodeStr == nil or checkCodeStr == "" )then
		CPromptLayer.new("验证码不能为空"):play()
		return
	end
	closeCb()
	_callback(checkCodeStr)
end

-- 创建九宫格按键
-- return CCMenuSprite
-- sample:create9ScaleMenuItem("images/battle/btn_1.png","images/battle/btn_2.png",CCSizeMake(200,70),GetLocalizeStringBy("key_1331"),ccc3(255,222,0))
function create9ScaleMenuItem(normalFileName,selectedFileName,itemSize,labelString,labelColor,labelSize,font,strokeSize,strokeColor,labelOffset,normalCapInsets,selectedCapInsets)
    
    local selectedScale = 0.93
    
    -- init texture
    local normalTexture = CCTextureCache:sharedTextureCache():addImage(normalFileName)
    --normalTexture:retain()
    
    selectedFileName = selectedFileName==nil and normalTexture or selectedFileName
    local selectedTexture = CCTextureCache:sharedTextureCache():addImage(selectedFileName)
    --selectedTexture:retain()
    
    itemSize = itemSize==nil and normalTexture:getContentSize() or itemSize
    
    -- init capInsets
    normalCapInsets = normalCapInsets==nil and CCRectMake(normalTexture:getContentSize().width*0.4, normalTexture:getContentSize().height*0.4, normalTexture:getContentSize().width*0.1, normalTexture:getContentSize().height*0.1) or normalCapInsets
    selectedCapInsets = selectedCapInsets==nil and CCRectMake(selectedTexture:getContentSize().width*0.4, selectedTexture:getContentSize().height*0.4, selectedTexture:getContentSize().width*0.1, selectedTexture:getContentSize().height*0.1) or selectedCapInsets
    
    -- init nodes
    local normalNode = CCScale9Sprite:create(normalCapInsets,normalFileName)
    normalNode:setContentSize(itemSize);
    normalNode:setPosition(0,0)
    normalNode:setAnchorPoint(ccp(0,0))

    local selectedNode = CCScale9Sprite:create(selectedCapInsets,selectedFileName)
    selectedNode:setContentSize(CCSizeMake(itemSize.width*selectedScale,itemSize.height*selectedScale))
    selectedNode:setPosition(itemSize.width*(1-selectedScale)/2,itemSize.height*(1-selectedScale)/2)
    selectedNode:setAnchorPoint(ccp(0,0))
    
    local disableNode = CCScale9Sprite:create(normalCapInsets,normalFileName)
    disableNode:setColor(ccc3(111,111,111))
    disableNode:setContentSize(itemSize);
    disableNode:setPosition(0,0)
    disableNode:setAnchorPoint(ccp(0,0))
    --disableNode = tolua.cast(disableNode,"CCNodeRGBA")
    --disableNode:setCascadeColorEnabled(true)

    -- init menuItem
    local menuItem = CCMenuItemSprite:create(normalNode,selectedNode,disableNode)
    
    -- init label
    labelSize = labelSize==nil and itemSize.height*0.45 or labelSize
    strokeSize = strokeSize==nil and labelSize*0.05 or strokeSize
    strokeColor = strokeColor==nil and ccc3(0,0,0) or strokeColor
    font = font==nil and CPublicValue.kFontDefault or font
    labelOffset = labelOffset==nil and ccp(0,0) or labelOffset
    
    local normalLabel = CCRenderLabel:create(labelString, font, labelSize, strokeSize, strokeColor)
    normalLabel:setColor(labelColor)
    normalLabel:setPosition((itemSize.width-normalLabel:getContentSize().width)/2 + labelOffset.x,itemSize.height-(itemSize.height-normalLabel:getContentSize().height)/2 + labelOffset.y)
    normalNode:addChild(normalLabel,1)
    
    local selectedLabel = CCRenderLabel:create(labelString, font, labelSize*selectedScale, strokeSize*selectedScale, strokeColor)
    selectedLabel:setColor(labelColor)
    selectedLabel:setPosition((itemSize.width-normalLabel:getContentSize().width)/2 + labelOffset.x,itemSize.height*selectedScale-(itemSize.height*selectedScale-normalLabel:getContentSize().height)/2 + labelOffset.y)
    selectedNode:addChild(selectedLabel,1)
    
    local disableLabel = CCRenderLabel:create(labelString, font, labelSize, strokeSize, strokeColor)
    disableLabel:setColor(ccc3(labelColor.r*111/255,labelColor.g*111/255,labelColor.b*111/255))
    disableLabel:setPosition((itemSize.width-normalLabel:getContentSize().width)/2 + labelOffset.x,itemSize.height-(itemSize.height-normalLabel:getContentSize().height)/2 + labelOffset.y)
    disableNode:addChild(disableLabel,1)
    
    -- release texture
    --normalTexture:release()
    --selectedTexture:release()
    
    return menuItem
end

function createCheckCode()
	local checkLabel = CCLabelTTF:create("验证码：", CPublicValue.kFontDefault, 21)
	checkLabel:setPosition(ccp(80, _bgSprite:getContentSize().height*0.6 ))
	checkLabel:setColor(ccc3(100, 25, 4))
	_bgSprite:addChild(checkLabel)

	_check_code = CCEditBox:create (CCSizeMake(200,45), CCScale9Sprite:create("platform/images/login_text_bg.png"))
	_check_code:setPosition(ccp(139, _bgSprite:getContentSize().height*0.6))
	_check_code:setAnchorPoint(ccp(0, 0.5))
	_check_code:setPlaceHolder("点击输入验证码")
	_check_code:setPlaceholderFontColor(ccc3(177, 177, 177))
	_check_code:setFont(CPublicValue.kFontDefault,24)
	_check_code:setFontColor(ccc3( 0x78, 0x25, 0x00))
	_check_code:setMaxLength(24)
	_check_code:setReturnType(kKeyboardReturnTypeDone)
	_check_code:setInputFlag (kEditBoxInputFlagInitialCapsWord)
	_check_code:setTouchPriority(_priority - 1)
	_bgSprite:addChild(_check_code)

	local checkSprite = CCSprite:create(_check_file)
	checkSprite:setPosition(ccp(139+200+5, _bgSprite:getContentSize().height*0.6))
	checkSprite:setAnchorPoint(ccp(0, 0.5))
	checkSprite:setScale(1.5)
	_bgSprite:addChild(checkSprite)

	-- 按钮
	local menuBar = CCMenu:create()
	menuBar:setPosition(ccp(0,0))
	menuBar:setTouchPriority(-5601)
	_bgSprite:addChild(menuBar)

	-- 确认
	local confirmBtn = create9ScaleMenuItem("platform/images/btn_blue_n.png", "platform/images/btn_blue_h.png",CCSizeMake(160, 70), "确认",ccc3(0xfe, 0xdb, 0x1c),30,CPublicValue.kFontDefault,1, ccc3(0x00, 0x00, 0x00))
	confirmBtn:setAnchorPoint(ccp(0.5, 0.5))
	confirmBtn:setPosition(ccp(_bgSprite:getContentSize().width*0.5, 80))
    confirmBtn:registerScriptTapHandler(menuAction)
	menuBar:addChild(confirmBtn, 1, 10001)


end

-- 
local function createBgSprite()
	g_winSize = CCDirector:sharedDirector():getVisibleSize()
    -- 设备可视起始坐标
    g_origin = CCDirector:sharedDirector():getVisibleOrigin()
	local mySize = _layerSize
	-- 背景
	local fullRect = CCRectMake(0, 0, 213, 171)
	local insetRect = CCRectMake(84, 84, 2, 3)
    _bgSprite = CCScale9Sprite:create("platform/images/viewbg1.png",fullRect,insetRect)
    _bgSprite:setContentSize(mySize)
    -- _bgSprite:setScale(g_fScaleX)
    _bgSprite:setPosition(ccp(g_winSize.width*0.5,g_winSize.height*0.5))
    _bgSprite:setAnchorPoint(ccp(0.5,0.5))
    -- PlatformUtil.setAdaptNode(_bgSprite)
    _bgLayer:addChild(_bgSprite)
    
    if( _title ~= nil )then
	    local titleBg= CCSprite:create("platform/images/viewtitle1.png")
		titleBg:setPosition(ccp(_bgSprite:getContentSize().width*0.5, _bgSprite:getContentSize().height-6))
		titleBg:setAnchorPoint(ccp(0.5, 0.5))
		_bgSprite:addChild(titleBg)

		 --标题文本
		local labelTitle = CCLabelTTF:create(_title, CPublicValue.kFontDefault,33)
		labelTitle:setPosition(ccp(titleBg:getContentSize().width/2, (titleBg:getContentSize().height-1)/2))
		labelTitle:setColor(ccc3(0xff,0xe4,0x00))
		labelTitle:setPosition(ccp(titleBg:getContentSize().width*0.5,titleBg:getContentSize().height*0.5))
	    labelTitle:setAnchorPoint(ccp(0.5,0.5))
		titleBg:addChild(labelTitle)
	end

	createCheckCode()
end

function saveFile( file_data )
	if(file_data == nil)then
		return
	end

	local tempPath = CCFileUtils:sharedFileUtils():getWritablePath() .. "hash_check_" .. temp_index .. ".xml"
	file_data = Base64.decode(file_data)
	temp_index = temp_index + 1
	print(tempPath)
	local fileImg = io.open(tempPath, "wb")
	if(fileImg)then
		fileImg:write(file_data)
		fileImg:close()
	end
	return tempPath
end

-- 创建
function showTip( file_data, callback )
	init()
	_pid = pid
	_check_file = saveFile(file_data)
	_callback = callback
	_priority = priority or CPublicValue.TOUCH_CHECK_CODE 
	_zOrder = zOrder or  0
	_layerSize = layerSize or CCSizeMake(550, 300)
	_title = title

	_bgLayer = CCLayerColor:create(ccc4(0,0,0,155))
	_bgLayer:registerScriptHandler(onNodeEvent)

	createBgSprite()

	local runningScene = CCDirector:sharedDirector():getRunningScene()
	runningScene:addChild(_bgLayer, 2002)
end



