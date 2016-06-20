
-- FileName: UIHelper.lua
-- Author: zhangqi
-- Date: 2014-04-18
-- Purpose: 定义 UI 控件相关的方法，比如简化创建等
--[[TODO List]]

module("UIHelper", package.seeall)


require "script/GlobalVars"
require "script/module/public/ItemUtil"
require "script/utils/ItemDropUtil"

-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_i18n = gi18n
local m_i18nString = gi18nString

local m_ebHolderColor = ccc3(0xc3, 0xc3, 0xc3) -- editBox默认显示文字的颜色

local function init(...)

end

function destroy(...)
	package.loaded["UIHelper"] = nil
end

function moduleName()
	return "UIHelper"
end

-- 2015-05-07, 从PartnerTransfer中提取出来，添加参数layMain:通常是当前模块的主画布Layout对象
function changepPaomao( layMain, fnCallback )
    LayerManager.setPaomadeng(layMain, 0)
    registExitAndEnterCall(layMain, function ( ... )
		local changModuleType = LayerManager.getChangModuleType()
		if (changModuleType and changModuleType == 1) then
			return
		end
    	-- recallPMD(layMain,0)
        LayerManager.resetPaomadeng()
        if (fnCallback and type(fnCallback) == "function") then
        	fnCallback()
        end
    end)
end

-- 2015-10-28, 引导返回功能处理 在引导到其他界面时 设置返回时设置跑马灯的回调
-- layMain 跑马灯的父节点
-- PMDPos 跑马灯所在层级
function recallPMD( PMDParent,ArgPMDPos )
	local PMDPos = ArgPMDPos or 0
	local curModuleName = LayerManager.curModuleName()
	local retainLayer = DropUtil.checkLayoutIsRetain( curModuleName,PMDParent)
	if (retainLayer) then
		DropUtil.insertCallFn(curModuleName,function ( ... )
			LayerManager.setPaomadeng(retainLayer, PMDPos)
		end)
		return true
	end
	return false
end


-- 2015-04-15, zhangqi, 创建一个被遮罩的节点
-- image_path: 需要被遮罩的图片路径
-- mask_path: 用作遮罩的图片路径
-- scale_factor: 需要被遮罩的图片的缩放比例，例如1.2，默认nil时比例为1
function addMaskForImage( image_path, mask_path, scale_factor )
	local stencilNode = CCNode:create()
	local node = CCSprite:create(mask_path) -- 表示裁剪区域图片，需要是纯黑色图形
	if (scale_factor) then
		node:setScale(scale_factor)
	end
	node:getTexture():setAntiAliasTexParameters()
	local stencilSize = node:getContentSize()
	stencilNode:addChild(node)

	local imgBg = CCSprite:create(image_path)

	if (scale_factor) then
		imgBg:setScale(scale_factor)
	end

	local clipper = CCClippingNode:create()
	-- clipper:setInverted(true)
	clipper:setAlphaThreshold(0.1)
	clipper:setAnchorPoint(ccp(0.5, 0.5))
	clipper:setPosition(ccp(0, 0))

	clipper:addChild(imgBg, 0, 100)

	clipper:setStencil(stencilNode)

	return clipper, CCSizeMake(stencilSize.width*g_fScaleX, stencilSize.height)
end

--[[desc: zhangqi, 20140614, 删除当前场景上所有节点，并清理所有未使用纹理资源
		  如果不存在当前场景，创建新场景加入当前并返回这个新场景
    arg1: 参数说明
    return: CCScene, 当前运行的scene对象
—]]
function resetScene( ... )
	local scene = CCDirector:sharedDirector():getRunningScene()
	if scene then
		scene:removeAllChildrenWithCleanup(true)	-- 删除当前场景的所有子节点
		CCTextureCache:sharedTextureCache():removeUnusedTextures()	-- 清除所有不用的纹理资源
	else
		scene = CCScene:create()
		CCDirector:sharedDirector():runWithScene(scene)
	end
	return scene
end

--[[desc: zhangqi, 指定属性创建一个UIListView对象
-- tbCfg = {dir = SCROLLVIEW_DIR_VERTICAL, 
			sizeType = SIZE_PERCENT, sizePercent = ccp(1, 1), size = CCSize,
			posType = ccp(1, 1), posPercent = ccp(0, 0), pos = ccp(0, 0),
			bClipping = true, bBounce = true}
]]

function createListView(tbCfg)
	local list = ListView:create()
	list:setDirection(tbCfg.dir or SCROLLVIEW_DIR_VERTICAL) -- 垂直滑动
	list:setSizeType(tbCfg.sizeType or SIZE_PERCENT) -- 尺寸模式
	list:setPositionType(tbCfg.posType or POSITION_PERCENT) -- 位置模式
	list:setClippingEnabled(tbCfg.bClipping or true) -- 是否裁切
	list:setBounceEnabled(tbCfg.bBounce or true) -- 是否回弹
	list:ignoreContentAdaptWithSize(false)

	if (list:getSizeType() == SIZE_PERCENT) then
		list:setSizePercent(tbCfg.sizePercent or ccp(1, 1))
	else
		list:setSize(tbCfg.size)
	end

	if (list:getPositionType() == POSITION_PERCENT) then
		list:setPositionPercent(tbCfg.posPercent or ccp(0, 0))
	else
		list:setPosition(tbCfg.pos or ccp(0, 0))
	end

	return list
end

--[[desc: zhangqi, 指定属性创建一个Label对象
    strText, 文本内容；strFontName, 字体名称；nFontSize, 字体大小；ccc3Color，文本颜色，ccc3(r, g, b)
    sizeArea, 文本区域大小，CCSize; 
    alignHorizontal, 水平对齐模式，[kCCTextAlignmentLeft, kCCTextAlignmentCenter, kCCTextAlignmentRight]
    alginVertical, 垂直对齐模式，[kCCVerticalTextAlignmentTop, kCCVerticalTextAlignmentCenter, kCCVerticalTextAlignmentBottom]
    return: 是否有返回值，返回值说明
—]]
function createUILabel( strText, strFontName, nFontSize, ccc3Color, sizeArea, alignHorizontal, alginVertical)
	local labText = Label:create()
	if strText then
		labText:setText(strText)
	end

	labText:setFontName(strFontName or g_sFontName)
	labText:setFontSize(nFontSize or g_tbFontSize.normal)
	labText:setColor(ccc3Color or g_FontInfo.color)

	if (sizeArea) then
		labText:setTextAreaSize(sizeArea)
	end

	labText:setTextHorizontalAlignment(alignHorizontal or kCCTextAlignmentLeft)
	labText:setTextVerticalAlignment(alginVertical or kCCVerticalTextAlignmentCenter)

	return labText
end

--[[desc: zhangqi, 创建一个描边效果的CCLabelTTF对象
    strText: 指定文本
    c3FontColor: 字体颜色，nil的话默认黑色
    c3StrokeColor: 描边颜色，nil的话默认黑色
    bShadow: 是否带阴影
    nFontSize: 字号，nil的话默认18
    strFontName: 必须是带后缀名的字体文件名，如果是nil则默认方正简黑
    nStrokeSize: 描边宽度，nil的话默认2px
    return: CCLabelTTF对象
—]]
function createStrokeTTF( strText, c3FontColor, c3StrokeColor, bShadow, nFontSize, strFontName, nStrokeSize )
	local ttf = CCLabelTTF:create(strText or "", strFontName or g_FontInfo.name, nFontSize or g_tbFontSize.normal) -- 默认方正简黑
	ttf:setFontFillColor(c3FontColor or ccc3(0,0,0)) -- 默认黑色
	ttf:enableStroke(c3StrokeColor or ccc3(0,0,0), nStrokeSize or 2);
	if (bShadow) then
		ttf:enableShadow(CCSizeMake(2, -2), 255, 0);
	end
	return ttf
end


--[[desc: menghao 为label添加描边并设置text
	label : Label对象
	strText : 指定文本
	c3StrokeColor : 描边颜色，缺省时为黑色
	nStrokeSize : 描边宽度，缺省时为2 
    return: 无
    modified: zhangqi, 2014-07-03, 把设置描边的代码单独抽出来一个新方法
—]]
function labelAddStroke( label, strText, c3StrokeColor, nStrokeSize )
	if (label.setText) then
		label:setText(strText or "")
	else
		label:setStringValue(strText or "")
	end
	labelStroke(label, c3StrokeColor, nStrokeSize)
end

-- 给Label添加描边效果，方便不需要重新setText的情况，例如 "/"。zhangqi, 2014-07-03
function labelStroke( label, c3StrokeColor, nStrokeSize )
-- local render = tolua.cast(label:getVirtualRenderer(), "CCLabelTTF")
-- local color = c3StrokeColor or ccc3(0, 0, 0)
-- local size = nStrokeSize or 2
-- render:enableStroke(color, size)
end


-- 新描边效果，目前正在使用
function labelNewStroke( label, c3StrokeColor, nStrokeSize )
	local render = tolua.cast(label:getVirtualRenderer(), "CCLabelTTF")
	local color = c3StrokeColor or ccc3(0, 0, 0)
	local size = nStrokeSize or 2
	render:enableStroke(color, size)
end


-- 基于新描边的封装，同时指定文本内容
function labelAddNewStroke( label, strText, c3StrokeColor, nStrokeSize )
	label:setText(strText)
	labelNewStroke( label, c3StrokeColor, nStrokeSize )
end


-- 给Label取消描边效果。xianghuiZhang, 2014-08-07
function labelUnStroke( label )
	local render = tolua.cast(label:getVirtualRenderer(), "CCLabelTTF")
	render:disableStroke(true)
end

-- 给Label同时添加描边和默认的阴影效果，zhangqi, 2014-07-03
function labelEffect( label, strText )
	if (strText) then
		labelAddStroke(label, strText)
	else
		labelStroke(label)
	end
	--labelShadow(label)
end

-- zhangqi, 同时指定label控件的文本，颜色，字体名称和size属性，减少代码
function setLabel( label, tbArgs )
	label:setText(tbArgs.text)
	if (tbArgs.color) then
		label:setColor(tbArgs.color)
	end
	if (tbArgs.font) then
		label:setFontName(tbArgs.font)
	end
	if (tbArgs.size) then
		label:setFontSize(tbArgs.size)
	end
end

-- 给按钮的标题添加阴影效果，只有btn参数时添加默认设置，zhangqi, 2014-07-03
function titleShadow( btn, sTitle, szOffset, nOpcity, nBlur )
	if (btn) then
		if sTitle then
			btn:setTitleText(sTitle)
		end
		local ttf = tolua.cast(btn:getTitleTTF(), "CCLabelTTF")
		local offset = szOffset or CCSizeMake(1, -2) -- 按钮标题的阴影size一般是2
		ttfShadow(ttf, offset, nOpcity, nBlur)
	end
end

-- 给Label添加阴影效果，只有label参数时添加默认设置，zhangqi, 2014-07-03
function labelShadow( label, szOffset, nOpcity, nBlur )
	if (label) then
		local ttf = tolua.cast(label:getVirtualRenderer(), "CCLabelTTF")
		local offset = szOffset or CCSizeMake(1, -2) -- 普通文本的阴影size一般是3
		ttfShadow(ttf, offset, nOpcity, nBlur)
	end
end

-- 给Label添加阴影效果，同时指定文本和阴影size，zhangqi, 2014-07-29
function labelShadowWithText( label, sText, szOffset )
	if (label) then
		label:setText(sText or "")
		labelShadow(label, szOffset)
	end
end

--[[desc: 给一个 CCLabelTTF 对象 设置阴影效果，zhangqi, 2014-07-03
	ttf: CCLabelTTF 对象
    szOffset, nOpcity, nBlur: 第二个参数为阴影相对于标签的坐标，第三个参数设置透明度，第四个参数与模糊有关
    return:
—]]
function ttfShadow(ttf, szOffset, nOpcity, nBlur )
	ttf:enableShadow(szOffset, nOpcity or 1, nBlur or 1)
end

-- 默认的关闭按钮回调方法
function closeCallback(  )
	AudioHelper.playCloseEffect()
	LayerManager.removeLayout()
end

-- 默认的关闭按钮事件
function onClose( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		closeCallback()
	end
end

-- 默认的返回按钮事件
function onBack( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playBackEffect()
		LayerManager.removeLayout()
	end
end


--[[desc: zhangjunwu, 根据 createCommonDlg创建的公用对话框里的文本的高度来更新对话框的高度
    layDlg: 对话框
—]]
function updateCommonDlgSize( layDlg ,heightTotle)

	local IMG_PROMPT_BG = m_fnGetWidget(layDlg,"IMG_PROMPT_BG")
	--S所有子节点的父容器
	local lay_main = m_fnGetWidget(layDlg,"lay_main")
	--背景图
	local PROMPT_Layout = m_fnGetWidget(layDlg,"TFD_PROMPT_TXT")
	--文本高度
	local textLayHeight = PROMPT_Layout:getSize().height

	local excessHeight = heightTotle - textLayHeight
	logger:debug(excessHeight)


	PROMPT_Layout:setTextHorizontalAlignment(kCCTextAlignmentLeft)
	PROMPT_Layout:ignoreContentAdaptWithSize(false)
	PROMPT_Layout:setSize(CCSizeMake(PROMPT_Layout:getSize().width,heightTotle))

	--超出的比例
	local ratio = heightTotle / textLayHeight

	if(excessHeight > 0)then

		local sizePercentY = IMG_PROMPT_BG:getSize().height  * ratio
		logger:debug(ratio .. " ddd" .. sizePercentY)
		lay_main:setSize(CCSizeMake(lay_main:getSize().width, sizePercentY + 0) )
		IMG_PROMPT_BG:setSize(CCSizeMake(IMG_PROMPT_BG:getSize().width, sizePercentY + 0) )

	end

end

-- 网络断开后的专用提示框，zhangqi，2014-09-03
function showNetworkDlg( fnLoginAgainCallback, fnReconnectCallback, bOtherLogin, sTips )
	-- zhangqi, 2016-02-14, 网络断开第一时间重置事件分发队列，避免意外地触发回调导致自动重连
	BTEventDispatcher:getInstance():removeAll()
	
	if (LayerManager.curModuleName() == "NewLoginView") then
		require "script/module/public/ShowNotice"
		ShowNotice.showShellInfo(m_i18n[4774]) -- 如果在登录界面自动连接失败后不弹提示框，显示浮动提示超时重新进游戏
		return
	end

	local layPrompt = g_fnLoadUI("ui/public_prompt.json")

	local btnClose = m_fnGetWidget(layPrompt, "BTN_CLOSE")
	btnClose:setEnabled(false)

	local labText = m_fnGetWidget(layPrompt, "TFD_PROMPT_TXT")

	local function eventLoginAgain ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			if (fnLoginAgainCallback) then
				fnLoginAgainCallback()
			end
			LoginHelper.loginAgain()
		end
	end

	local btnSingleAgain = m_fnGetWidget(layPrompt, "BTN_CONFIRM_SURE") -- 返回登陆
	local btnReconn = m_fnGetWidget(layPrompt, "BTN_CONFIRM") -- 重新连接
	local btnAgain = m_fnGetWidget(layPrompt, "BTN_CANCEL") -- 返回登陆

	-- zhangqi, 2015-01-05, 如果帐号别处登陆导致的断线只显示返回登陆
	-- zhangqi, 2015-03-17, 或者最近一次的rpc请求没收到返回只显示返回登陆
	if (bOtherLogin or (not Network.lastRpcBack()) ) then
		btnReconn:setEnabled(false)
		btnAgain:setEnabled(false)

		btnSingleAgain:setEnabled(true)
		titleShadow(btnSingleAgain, m_i18n[1927])
		btnSingleAgain:addTouchEventListener(eventLoginAgain)
		if (bOtherLogin) then
			logger:debug("showNetworkDlg_OtherLogin")
			labText:setText(sTips or m_i18n[4755]) -- 账号别处登陆的提示
		else
			logger:debug("showNetworkDlg_last Rpc not Back")
			labText:setText(sTips or m_i18n[4210]) -- 后端请求没返回的异常提示
		end
		LayerManager.addNetworkDlg(layPrompt)
		return
	else
		logger:debug("showNetworkDlg_normal failed")
		labText:setText(sTips or m_i18n[4210]) -- 一般网络异常的提示
		btnSingleAgain:setEnabled(false)
	end


	titleShadow(btnReconn, m_i18n[1926])
	btnReconn:addTouchEventListener(onClose)
	btnReconn:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			if (fnReconnectCallback) then
				fnReconnectCallback()
			end
			LayerManager.addLoginLoading() -- zhangqi, 2015-03-26, 原地重连先显示登陆的loading
			LoginHelper.reconnect()
		end
	end)


	titleShadow(btnAgain, m_i18n[1927])
	btnAgain:addTouchEventListener(eventLoginAgain)

	LayerManager.addNetworkDlg(layPrompt)
end
--liweidong 返回红点特效
function createRedTipAnimination()
	-- local anim = UIHelper.createArmatureNode({
	-- 	filePath = "images/effect/sign/sign.ExportJson",
	-- 	animationName = "sign",
	-- 	loop = -1,
	-- })
	-- return anim
	local redImg =  CCSprite:create("images/common/tip_1.png")
	return redImg

end

-- zhangqi, 2015-03-26, 进入游戏拉取版本信息错误（网络不可用）提示面板
function createVersionCheckFailed( sText, sBtnTitle, fnBtnCallback )
	local layPrompt = g_fnLoadUI("ui/public_prompt.json")

	local btnClose = m_fnGetWidget(layPrompt, "BTN_CLOSE")
	btnClose:removeFromParentAndCleanup(true)

	local btnCancel = m_fnGetWidget(layPrompt, "BTN_CANCEL")
	local btnOK = m_fnGetWidget(layPrompt, "BTN_CONFIRM")
	btnCancel:removeFromParentAndCleanup(true)
	btnOK:removeFromParentAndCleanup(true)

	local btnSingleOK = m_fnGetWidget(layPrompt, "BTN_CONFIRM_SURE")
	titleShadow(btnSingleOK, sBtnTitle)
	btnSingleOK:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			if (fnBtnCallback) then
				fnBtnCallback()
			end
		end
	end)

	local labText = m_fnGetWidget(layPrompt, "TFD_PROMPT_TXT")
	labText:setText(sText)

	return layPrompt
end

-- zhangqi, 2014-11-04
-- tbArgs = {strText, richText, fnConfirmEvent, nBtn, fnCloseCallback, sCancelTitle, sOkTitle}
function createCommonDlgNew(tbArgs)
	return createCommonDlg(tbArgs.strText, tbArgs.richText, tbArgs.fnConfirmEvent, tbArgs.nBtn, tbArgs.fnCloseCallback, tbArgs.sCancelTitle, tbArgs.sOkTitle)
end
--[[desc: zhangqi, 指定文本和确认回调事件创建一个公用对话框
    strText: 提示文本，可以是nil
    richText: 富文本对象，可以是nil
    fnConfirmEvent: 确认按钮回调事件，是nil时默认关闭对话框
    nBtn: 1, 显示一个确定按钮; nil 或 2, 默认显示确定和取消按钮
    fnCloseCallback: 关闭按钮的回调
    sCancelTitle: 取消按钮的自定义标题
    sOkTitle: 确定按钮的自定义标题
    return: Layout
—]]
function createCommonDlg( strText, richText, fnConfirmEvent, nBtn, fnCloseCallback, sCancelTitle, sOkTitle )
	local layPrompt = g_fnLoadUI("ui/public_prompt.json")

	local function CloseEvent( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			closeCallback()
			if (fnCloseCallback and type(fnCloseCallback) == "function") then
				fnCloseCallback()
			end
		end
	end

	local btnClose = m_fnGetWidget(layPrompt, "BTN_CLOSE")
	btnClose:addTouchEventListener(CloseEvent)

	local btnCancel = m_fnGetWidget(layPrompt, "BTN_CANCEL")
	titleShadow(btnCancel, sCancelTitle or m_i18n[1325])

	local btnOK = m_fnGetWidget(layPrompt, "BTN_CONFIRM")
	titleShadow(btnOK, sOkTitle or m_i18n[1324])

	local btnSingleOK = m_fnGetWidget(layPrompt, "BTN_CONFIRM_SURE")
	if (nBtn == 1) then
		btnCancel:removeFromParentAndCleanup(true)
		btnOK:removeFromParentAndCleanup(true)
		btnSingleOK = m_fnGetWidget(layPrompt, "BTN_CONFIRM_SURE")
		titleShadow(btnSingleOK, sOkTitle or m_i18n[1324])
		btnSingleOK:addTouchEventListener(fnConfirmEvent or CloseEvent)
	else
		btnSingleOK:removeFromParentAndCleanup(true)
		btnCancel:addTouchEventListener(CloseEvent)
		btnOK:addTouchEventListener(fnConfirmEvent or CloseEvent)
	end

	local labText = m_fnGetWidget(layPrompt, "TFD_PROMPT_TXT")
	if (strText) then
		labText:setText(strText)
	elseif (richText) then
		local labText1 = m_fnGetWidget(layPrompt, "TFD_PROMPT_TXT_1")
		richText:setAnchorPoint(ccp(0.5, 0.5))
		labText1:addChild(richText,100,100)
		labText:setVisible(false)
	end

	--layPrompt:setAnchorPoint(ccp(0.5,0.5))
	return layPrompt
end

function logDlg( data )
	createDebugDlg(data)
end

--创建debug的输出框
function createDebugDlg( strText)
	local layPrompt = g_fnLoadUI("ui/wrong.json")

	local btnClose = m_fnGetWidget(layPrompt, "BTN_CLOSE")
	btnClose:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			closeCallback()
			CCDirector:sharedDirector():resume()
		end
	end)

	local labText = m_fnGetWidget(layPrompt, "tfd_wrong")
	labText:setText(strText)
	labText:setTextVerticalAlignment(kCCVerticalTextAlignmentTop)
	labText:ignoreContentAdaptWithSize(false)

	LayerManager.addLayoutNoScale(layPrompt, nil, g_tbTouchPriority.ShieldLayout, 99999999)

	performWithDelay(layPrompt, function ( ... )
		CCDirector:sharedDirector():pause()
	end, 0.2)
end

--[[desc: zhangqi, 2014-07-01，根据指定信息显示对应的背包已满提示框
    tbInfo: table, {text = "", btn = {{title = "", callback = func}, ...} }
    备注: 如果只有一个按钮时，需要传递的tbInfo的btn字段也必须包含3个table，第一个和第三个为空表即可，btn = {{}, {title = "", callback = func}, {}}
    return:
—]]
function showFullDlg( tbInfo )
	local layPrompt = g_fnLoadUI("ui/public_bag_full_info.json")
	local labText = m_fnGetWidget(layPrompt, "TFD_PARTNER_BAG_FULL_INFO")
	labText:setText(tbInfo.text or "")

	local btnClose = m_fnGetWidget(layPrompt, "BTN_PARTNER_BAG_FULL_CLOSE") -- 默认关闭
	btnClose:addTouchEventListener(onClose)

	local count = #tbInfo.btn
	if (count == 2) then
		local layThree = m_fnGetWidget(layPrompt, "lay_btn_three")
		layThree:removeFromParentAndCleanup(true)
	elseif (count == 3 or count == 1) then
		local layTwo = m_fnGetWidget(layPrompt, "lay_btn_two")
		layTwo:removeFromParentAndCleanup(true)
	end

	for i, info in ipairs(tbInfo.btn) do
		local btn = m_fnGetWidget(layPrompt, "BTN_" .. i)
		if (table.isEmpty(info)) then
			btn:setEnabled(false)
		else
			titleShadow(btn, info.title)
			btn:addTouchEventListener(function ( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					closeCallback()
					info.callback()
				end
			end)
		end
	end

	LayerManager.addLayout(layPrompt)
end


--[[--
menghao
创建一个armature对象并返回，可以通过addNode加到widget上

@param table params 参数表格对象

可用参数：
-	imagePath		图片路径
-	plistPath		plist文件路径
-	filePath 		json文件路径
-	animationName 	要播放的动画名字	可缺省
-	loop			循环次数，和引擎的用法一致，缺省无限循环
-	fnMovementCall	动画事件回调，START,COMPLETE,LOOP_COMPLETE三种类型
-	fnFrameCall 	关键帧事件回调
--  bRetain         是否自动释放json文件缓冲
@return  CCArmature对象

示例
local tbParams = {
	imagePath = "",
	plistPath = "",
	filePath = "",
	animationName = "",
	loop = 0,
	fnMovementCall = function ( sender, MovementEventType , frameEventName)
		if (MovementEventType == START) then
		elseif (MovementEventType == COMPLETE) then
		elseif (MovementEventType == LOOP_COMPLETE) then
		end
	end,
	fnFrameCall = function ( bone, frameEventName, originFrameIndex, currentFrameIndex )
	end
}

]]
-- 增加一个要释放的json 文件缓冲
local _tJsonCache = {}

--释放 json 资源缓冲 一般存得是重用的动画json
function removeArmatureFileCache(  )
	for i,filePath in ipairs(_tJsonCache or {}) do
		logger:debug("removeFileCache:%s", filePath)
		CCArmatureDataManager:sharedArmatureDataManager():removeArmatureFileInfo(filePath)
	end
	_tJsonCache = {}
end


local function bHasInCache(filePath)
	local bHas = false
	for i,v in ipairs(_tJsonCache) do
		if filePath == v then
			bHas = true
			break
		end
	end
	return bHas
end

function createArmatureNode( tbParams )
	local imagePath = tbParams.imagePath
	local plistPath = tbParams.plistPath
	local filePath = tbParams.filePath
	local animationName = tbParams.animationName
	local loop = tbParams.loop or -1
	local fnMovementCall = tbParams.fnMovementCall
	local fnFrameCall = tbParams.fnFrameCall
	local bRetain = tbParams.bRetain

	-- 截取文件名
	local function stripextension(filename)
		local idx = filename:match(".+()%.%w+$")
		if(idx) then
			return filename:sub(1, idx-1)
		else
			return filename
		end
	end
	local fileName = string.match(filePath, ".+/([^/]*%.%w+)$")
	logger:debug("fileName == " .. fileName)

	fileName = stripextension(fileName)

	logger:debug("fileName == " .. fileName)

	if (plistPath and imagePath and filePath) then
		CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(imagePath, plistPath, filePath)
	else
		CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(filePath)
	end

	local armature = CCArmature:create(fileName)
	if (animationName) then
		armature:getAnimation():play(animationName, -1, -1, loop)
	end
	if (fnMovementCall) then
		armature:getAnimation():setMovementEventCallFunc(fnMovementCall)
	end
	if (fnFrameCall) then
		armature:getAnimation():setFrameEventCallFunc(fnFrameCall)
	end

	if bRetain and not bHasInCache(filePath) then -- 2015-07-30 是否自动释放json cache， 一个重复使用的动画，不自动释放 如果已经添加过就不再添加了
		table.insert(_tJsonCache, filePath)
	else
		CCArmatureDataManager:sharedArmatureDataManager():removeArmatureFileInfo(filePath)
	end
	return armature
end


-- 初始化一个自带默认cell的listView, 把默认cell设置为可以push的默认cell，然后清空列表
function initListView( lsvWidget )
	local refCell = assert(lsvWidget:getItem(0), "refCell of " .. lsvWidget:getName() .. " is nil") -- 获取编辑器中的默认cell
	logger:debug("refCell name = %s", refCell:getName())
	lsvWidget:setItemModel(refCell) -- 设置默认的cell
	lsvWidget:removeAllItems() -- 初始化清空列表
end

-- 初始化一个不带cell的listView, 把带模板cell设置为可以push的默认cell，然后清空列表
function initListViewByRefLsv( lsvWidget,refLsvWidget )
	local refCell = assert(refLsvWidget:getItem(0), "refCell of " .. lsvWidget:getName() .. " is nil") -- 获取编辑器中的默认cell
	logger:debug("refCell name = %s", refCell:getName())
	lsvWidget:setItemModel(refCell) -- 设置默认的cell
	lsvWidget:removeAllItems() -- 初始化清空列表
end

--[[desc:根据数量来增减list的cell 保证列表位置不变 liweidong
    arg1: list:ListView列表 num:列表数量
    return: nil  
—]]
function initListWithNumAndCell( list,num )

	local arr = list:getItems()
	local listCount = arr:count()
	if num>listCount then
		for i=1,num-listCount do
			--list:pushBackCustomItem(cell:clone())
			list:pushBackDefaultItem()
		end
	end
	if num<listCount then
		for i=1,listCount-num do
			list:removeLastItem()
		end
	end
end
--自动定位水平滑动列表的位置 liweidong --list:ListView cell:当前选中的cell
function autoSetListOffset( list,cell )
	if (-list:getJumpOffset().x>cell:getPositionX()) then --如果选中cell在list可视区域之外的左边或压在左边框上
		list:setJumpOffset(ccp(-cell:getPositionX()+list:getItemsMargin(),list:getJumpOffset().y))
	elseif (-list:getJumpOffset().x+list:getSize().width<cell:getPositionX()+cell:getSize().width) then --如果选中cell在list可视区域之外的右边或压在右边框上
		list:setJumpOffset(ccp(-cell:getPositionX()+list:getSize().width-cell:getSize().width-list:getItemsMargin(),list:getJumpOffset().y))
	end
end
-- 初始化一个自带默认cell的listView, 把默认cell设置为可以push的默认cell，然后清空列表。参数list必须保存为模块变量 defaultCell为空时列表中必须有一个cell
--customCellCount 自定义复用cell个数，不传入会自动计算，一般不用传入，cell大小不一样的自己传入保存多少个复用cell
--collisionMulriple 碰撞区域倍数，默认上下或左右各一个cell的高或宽的碰撞区域，如果此参数为2，则各留两个
function initListViewCell( list,defaultCell,customCellCount,collisionMulriple)
	revmoeFrameNode(list)
	list:getActionManager():removeAllActionsFromTarget(list)
	local refCell
	if (defaultCell) then
		refCell = defaultCell
	else
		refCell = assert(list:getItem(0), "refCell of " .. list:getName() .. " is nil") -- 获取编辑器中的默认cell
	end
	refCell:setPositionType(POSITION_ABSOLUTE)
	refCell:setPosition(ccp(0,0))
	refCell:setSizeType(SIZE_ABSOLUTE)

	local cellCount = 0
	if (customCellCount) then
		cellCount = tonumber(customCellCount)
	else
		if (list:getDirection()==SCROLLVIEW_DIR_HORIZONTAL) then
			cellCount = math.modf(list:getContentSize().width/(refCell:getContentSize().width+list:getItemsMargin()))+3
		else
			cellCount = math.modf(list:getContentSize().height/(refCell:getContentSize().height+list:getItemsMargin()))+3 --计算需要复用cell的个数
		end
	end
	if (list.cellArr) then
		list.cellArr:release()
	end
	local cellArr=CCArray:create() --存放复用cell
	cellArr:retain()
	list.cellArr=cellArr
	list.collisionMulriple = collisionMulriple==nil and 1 or collisionMulriple
	list.cellWidth=refCell:getContentSize().width --cell宽
	list.cellHeight=refCell:getContentSize().height --cell高
	logger:debug("list size:"..list.cellWidth .."  ".. list.cellHeight .." cout:"..cellCount)
	for i=1,cellCount do
		local cell=refCell:clone()
		cellArr:addObject(cell)
	end
	list:removeAllItems() -- 初始化清空列表
end
--[[desc:根据数量来增减list的cell 保证列表位置不变 liweidong
    arg1: list:ListView列表 num:列表数量
    return: nil  
—]]
function setListViewCount( list,num )
	if (list.itembgArr==nil) then
		list.itembgArr={}
	end
	list.collideBeginIdx=0
	list.collideEndIdx=num-1

	local arr = list:getItems()
	local listCount = arr:count()
	if num>listCount then
		for i=1,num-listCount do
			--list:pushBackCustomItem(cell:clone())
			local cellLayout=Layout:create()
			cellLayout:setSize(CCSizeMake(list.cellWidth,list.cellHeight))
			list:pushBackCustomItem(cellLayout)
			cellLayout.refreshstatus=0
			list.itembgArr[#list.itembgArr+1]=cellLayout --需要为cellLayout添加lua值，需要保存
			--list:pushBackDefaultItem()
		end
	end
	if num<listCount then
		for i=1,listCount-num do
			list:removeLastItem()
		end
	end
end
--[[desc:优化listview实现tableview功能，不在显示范围内的自动隐藏，并且不加载。减少渲染数量和加快加载速度 liweidong
     	list:ListView对象, （必填）
    	listCount:list cell总数量  （必填）
    	updateCell 更新某一行cell的回调函数 （必填）
    	offset list定位功能。参数可以是CCPoint对象或是cellIdex(number)第几个cell从0开始，指定listView定位到那里，或是定位到第几个cell.为空侧不定位
    	FrameDelayEffect 是否一帧一帧加载 true --延迟加载 false 不延迟  1 延迟并从右边划入 
    return: nil
—]]
function reloadListView(list,listCount,updateCell,offset,FrameDelayEffect)
	revmoeFrameNode(list)
	list:getActionManager():removeAllActionsFromTarget(list)
	setListViewCount(list,listCount)
	local listPos=nil
	local listRect=nil
	if (list:getDirection()==SCROLLVIEW_DIR_HORIZONTAL) then
		listPos=list:convertToWorldSpace(ccp((-list.cellWidth-list:getItemsMargin())*0.8*list.collisionMulriple, 0))
		listRect=CCRectMake(listPos.x,listPos.y,list:getContentSize().width+(list.cellWidth+list:getItemsMargin())*1.6*list.collisionMulriple,list:getContentSize().height)
	else
		listPos=list:convertToWorldSpace(ccp(0,(-list.cellHeight-list:getItemsMargin())*0.8*list.collisionMulriple))
		listRect=CCRectMake(listPos.x,listPos.y,list:getContentSize().width,list:getContentSize().height+(list.cellHeight+list:getItemsMargin())*1.6*list.collisionMulriple)
	end
	
	local function graceful(force)
		local cell = tolua.cast(list:getItem(list.collideBeginIdx),"Widget")
		local cellPos=cell:convertToWorldSpace(ccp(0,0))
		local cellRect=CCRectMake(cellPos.x,cellPos.y,cell:getContentSize().width,cell:getContentSize().height)
		if not (listRect:intersectsRect(cellRect)) then
			cell.refreshstatus=0
			cell:removeAllChildrenWithCleanup(true)
			for i=list.collideBeginIdx+1,listCount-1,1 do
				local cell = tolua.cast(list:getItem(i),"Widget")
				local cellPos=cell:convertToWorldSpace(ccp(0,0))
				local cellRect=CCRectMake(cellPos.x,cellPos.y,cell:getContentSize().width,cell:getContentSize().height)
				if (listRect:intersectsRect(cellRect)) then
					list.collideBeginIdx=i
					break
				else
					cell.refreshstatus=0
					cell:removeAllChildrenWithCleanup(true)
				end
			end
		else
			for i=list.collideBeginIdx-1,0,-1 do
				local cell = tolua.cast(list:getItem(i),"Widget")
				local cellPos=cell:convertToWorldSpace(ccp(0,0))
				local cellRect=CCRectMake(cellPos.x,cellPos.y,cell:getContentSize().width,cell:getContentSize().height)
				if (listRect:intersectsRect(cellRect)) then
					list.collideBeginIdx=i
				else
					cell.refreshstatus=0
					cell:removeAllChildrenWithCleanup(true)
					break
				end
			end
		end
		
		local cell = tolua.cast(list:getItem(list.collideEndIdx),"Widget")
		local cellPos=cell:convertToWorldSpace(ccp(0,0))
		local cellRect=CCRectMake(cellPos.x,cellPos.y,cell:getContentSize().width,cell:getContentSize().height)
		if not (listRect:intersectsRect(cellRect)) then
			cell.refreshstatus=0
			cell:removeAllChildrenWithCleanup(true)
			for i=list.collideEndIdx-1,0,-1 do
				local cell = tolua.cast(list:getItem(i),"Widget")
				local cellPos=cell:convertToWorldSpace(ccp(0,0))
				local cellRect=CCRectMake(cellPos.x,cellPos.y,cell:getContentSize().width,cell:getContentSize().height)
				if (listRect:intersectsRect(cellRect)) then
					list.collideEndIdx=i
					break
				else
					cell.refreshstatus=0
					cell:removeAllChildrenWithCleanup(true)
				end
			end
		else
			for i=list.collideEndIdx+1,listCount-1,1 do
				local cell = tolua.cast(list:getItem(i),"Widget")
				local cellPos=cell:convertToWorldSpace(ccp(0,0))
				local cellRect=CCRectMake(cellPos.x,cellPos.y,cell:getContentSize().width,cell:getContentSize().height)
				if (listRect:intersectsRect(cellRect)) then
					list.collideEndIdx=i
				else
					cell.refreshstatus=0
					cell:removeAllChildrenWithCleanup(true)
					break
				end
			end
		end
		-- if force then
		-- 	for i=1,list.cellArr:count() do
		-- 		local item = tolua.cast(list.cellArr:objectAtIndex(i-1),"Widget")
		-- 		item:removeFromParentAndCleanup(true)
		-- 	end
		-- end
		local cellIdx=0
		local updateIdx = 0
		for i=list.collideBeginIdx,list.collideEndIdx do
			local cell = tolua.cast(list:getItem(i),"Widget")
			if (cellIdx>=list.cellArr:count()) then
				cell.refreshstatus=0
				cell:removeAllChildrenWithCleanup(true)
			else
				if (cell.refreshstatus==0 or force) then
					cell.refreshstatus=0
					cell:removeAllChildrenWithCleanup(true)
					local freeitem=nil
					for i=1,list.cellArr:count() do
						local item = tolua.cast(list.cellArr:objectAtIndex(i-1),"Widget")
						if item:getParent()==nil then
							freeitem=item
							break
						end
					end
					if freeitem then
						cell:setSize(CCSizeMake(list.cellWidth,list.cellHeight))
						cell:addChild(freeitem,1,999) --添加复用cell
						cell.item = freeitem
						if force then
							if (FrameDelayEffect) then
								cell:setVisible(false)
								performWithDelayFrame(list,function()
										cell:setVisible(true)
										if (cell:getChildByTag(999)) then
											updateCell(list,i)
											cell:updateSizeAndPosition()
											if (FrameDelayEffect==1) then
												local cellItems = cell:getChildren()
												if (cellItems:count()>0) then
													local item = cellItems:objectAtIndex(0)
													item:setPosition(ccp(list.cellWidth, 0))
													item:runAction(CCMoveTo:create(0.07, ccp(0,0)))
												end
											end
											if (FrameDelayEffect==2) then
												local cellItems = cell:getChildren()
												if (cellItems:count()>0) then
													local item = cellItems:objectAtIndex(0)
													item:setScale(0.99)
													local array = CCArray:create()
						                            array:addObject(CCScaleTo:create(0.05, 1.03))
						                            -- array:addObject(CCScaleTo:create(0.04, 0.98))
						                            array:addObject(CCScaleTo:create(0.04, 1))
						                            local action = CCSequence:create(array)
						                            item:runAction(action)
												end
											end
										end
									end,
									updateIdx)
							else
								updateCell(list,i)
								cell:updateSizeAndPosition()
							end
						else
							performWithDelayFrame(list,function()
									if (cell:getChildByTag(999)) then
										updateCell(list,i)
										cell:updateSizeAndPosition()
									end
								end,
								1
								)
						end
						cell.refreshstatus=1
						updateIdx = updateIdx+1
					end
				end
			end
			cellIdx=cellIdx+1
		end
		if force then
			list.collideBeginIdx=0
			list.collideEndIdx=listCount-1
		end
	end
	-- list:getActionManager():removeAllActionsFromTarget(list)
	if (listCount>0) then
		local lastPosx,lastPosy=-100,-100
		local updateOffset = function()
			if (listCount>0) then
				local lastCell = tolua.cast(list:getItem(listCount-1),"Widget")
				local cellPos=lastCell:convertToWorldSpace(ccp(0,0))
				if (cellPos.x~=lastPosx or cellPos.y~=lastPosy) then
					lastPosx,lastPosy=cellPos.x,cellPos.y
					graceful(false)
				end
			end
		end
		performWithDelay(list,function()
					if (offset) then
						if (type(offset)=="number") then
							offset = tonumber(offset)
							if (offset>=0 and offset<listCount) then
								local cell = tolua.cast(list:getItem(offset),"Widget")
								if (list:getDirection()==SCROLLVIEW_DIR_HORIZONTAL) then
									local posx = -cell:getPositionX()-list:getItemsMargin()
									if (posx>0) then
										posx=0
									end
									list:setJumpOffset(ccp(posx,list:getJumpOffset().y))
								else
									local posy = -cell:getPositionY()+list:getSize().height-cell:getSize().height-list:getItemsMargin()
									if (posy > 0 ) then
										posy =0
									end
									list:setJumpOffset(ccp(list:getJumpOffset().x,posy))
								end
							end
						else
							list:setJumpOffset(offset)
						end
					end
					graceful(true)
					schedule(list,updateOffset,0.01)
				end,
				0.00
				)

		-- list:scheduleUpdateWithPriorityLua(function()
		-- 		if (listCount>0) then
		-- 			local lastCell = tolua.cast(list:getItem(listCount-1),"Widget")
		-- 			local cellPos=lastCell:convertToWorldSpace(ccp(0,0))
		-- 			if (cellPos.x~=lastPosx or cellPos.y~=lastPosy) then
		-- 				lastPosx,lastPosy=cellPos.x,cellPos.y
		-- 				graceful(false)
		-- 			end
		-- 		end
		-- 	end,0.01)
		
	end
	UIHelper.registExitAndEnterCall(list,
		function()
			list.cellArr:release()
			-- UIHelper.registExitAndEnterCall(list,function() end) --防止上一行代码执行两次 因为listView被remove后有可能还会被再次添加现次删除
		end,
		function()
		end,
		function()
		end
	)
end
-- 把动态创建的 Button 控件 add 到一个 layout 的中心，zhangqi, 2014-07-17
function addBtnToLayout( btn, layout )
	local szLayout = layout:getSize()
	btn:setPosition(ccp(szLayout.width/2, szLayout.height/2))
	layout:addChild(btn)
end

--[[desc: zhangqi, 根据掉落物品创建公用的掉落面板
    tbDrop: 后端返回的drop表
    sTitle: 面板标题文本
    return:
    modified: zhangqi, 20140626, createDropItemDlg 修改为 showDropItemDlg
    		  不再返回layout, 直接调用LayerManger.addLayout来显示
    		  zhangqi, 2014-08-14, 增加参数 bUpdateCache，true 表示将直接获得贝里，金币，经验石等同步更新本地缓存，默认 nil 表示不更新(兼容修改前的调用)
—]]
function showDropItemDlg( tbDrop, sTitle, bUpdateCache )
	logger:debug("createDropItemDlg")
	logger:debug(tbDrop)

	local tbGifts =  ItemDropUtil.getDropItem(tbDrop)
	logger:debug(tbGifts)
	if(table.isEmpty(tbGifts)) then
		return
	end

	if (bUpdateCache) then
		ItemDropUtil.refreshUserInfo(tbGifts)
	end

	-- 从tbGifts中过滤出英雄和物品
	-- local tbItems = {}
	-- for i, v in ipairs(tbGifts) do
	-- 	if (v.type == "hero") then
	-- 		table.insert(tbItems, v)
	-- 	end
	-- end
	-- for i, v in ipairs(tbGifts) do
	-- 	if (v.type == "item") then
	-- 		table.insert(tbItems, v)
	-- 	end
	-- end


	local layMain = g_fnLoadUI("ui/bag_open_gift.json")

	local i18nTitle2 = m_fnGetWidget(layMain, "TFD_COMMON_TITLE") -- 恭喜您获得
	labelEffect(i18nTitle2, m_i18n[1901])

	local btnClose = m_fnGetWidget(layMain, "BTN_CLOSE")
	btnClose:addTouchEventListener(onClose)

	local btnOK = m_fnGetWidget(layMain, "BTN_CERTAIN")
	titleShadow(btnOK, m_i18n[1029])
	btnOK:addTouchEventListener(onClose)

	local lsvGift = m_fnGetWidget(layMain, "LSV_OPEN_GIFT")
	initListView(lsvGift)

	-- v {type, num, name, tid}
	local cell
	for i, v in ipairs(tbGifts) do
		lsvGift:pushBackDefaultItem()
		cell = lsvGift:getItem(i - 1)  -- cell 索引从 0 开始

		local dropInfo = ItemUtil.getGiftData(v)
		local tbItem = dropInfo.item

		local labSeal = m_fnGetWidget(cell, "TFD_ITEM_TYPE") -- 印章
		labSeal:setText(dropInfo.sign) -- zhangqi, 2015-09-16

		local layIcon = m_fnGetWidget(cell, "LAY_ITEM_ICON")
		addBtnToLayout(dropInfo.icon, layIcon)

		local labNumTitle = m_fnGetWidget(cell, "TFD_ITEM_NUM_WORD") -- 数量标题
		labelEffect(labNumTitle, m_i18n[1332])

		local labNum = m_fnGetWidget(cell, "TFD_ITEM_NUM") -- 数量
		labNum:setText(v.num)

		local labName = m_fnGetWidget(cell, "TFD_ITEM_NAME") -- 名称
		labName:setColor(g_QulityColor[tonumber(v.quality)])
		labelEffect(labName, v.name)

		local labInfo = m_fnGetWidget(cell, "TFD_ITEM_DESC") -- 介绍
		labInfo:setText(tbItem.desc)
	end

	LayerManager.addLayout(layMain, nil, g_tbTouchPriority.popDlg)
end

--[[desc: liweidong, 根据天降宝物的掉落面板
    tbDrop: 后端返回的drop表
    sTitle: 面板标题文本
    return:
—]]
function showTreasureDropItemDlg( tbDrop, sTitle ,callback,subTitle)
	logger:debug("createDropItemDlg＝＝＝＝＝＝＝＝")
	logger:debug(tbDrop)

	local tbGifts =  ItemDropUtil.getDropTreasureItem(tbDrop)
	logger:debug("item＝＝＝＝＝＝＝＝")
	logger:debug(tbGifts)
	if(table.isEmpty(tbGifts)) then
		return
	end

	local layMain = g_fnLoadUI("ui/bag_open_gift.json")

	local i18nTitle2 = m_fnGetWidget(layMain, "TFD_COMMON_TITLE") -- 恭喜您获得
	labelEffect(i18nTitle2, subTitle and subTitle or m_i18n[1901])

	local btnClose = m_fnGetWidget(layMain, "BTN_CLOSE")
	btnClose:addTouchEventListener(callback)

	local btnOK = m_fnGetWidget(layMain, "BTN_CERTAIN")
	titleShadow(btnOK, m_i18n[1029])
	btnOK:addTouchEventListener(callback)

	local lsvGift = m_fnGetWidget(layMain, "LSV_OPEN_GIFT")
	initListView(lsvGift)

	local img_bg = m_fnGetWidget(layMain, "lay_bg")
	local img_reward_bg = m_fnGetWidget(layMain, "img_open_gift_bg")

	local ncount = table.getn(tbGifts) -- 统计cell 个数
	if(ncount>2) then  -- 对多于两行对处理
		img_reward_bg:setSize(CCSizeMake(img_reward_bg:getSize().width,img_reward_bg:getSize().height*2.3)) --2.3
		img_bg:setSize(CCSizeMake(img_bg:getSize().width,img_bg:getSize().height*1.58)) --1.58
	elseif(ncount==2)  then
		-- for i,cellTemp in ipairs(tbCell) do
		-- 	cellTemp:setSize(CCSizeMake(cellTemp:getSize().width,cellTemp:getSize().height*.25))
		-- end
		img_reward_bg:setSize(CCSizeMake(img_reward_bg:getSize().width,img_reward_bg:getSize().height*1.86))
		img_bg:setSize(CCSizeMake(img_bg:getSize().width,img_bg:getSize().height*1.38))
		-- LSV_DROP:setSize(CCSizeMake(LSV_DROP:getSize().width,LSV_DROP:getSize().height*2))
	end

	-- v {type, num, name, tid}
	local cell
	for i, v in ipairs(tbGifts) do
		lsvGift:pushBackDefaultItem()
		cell = lsvGift:getItem(i - 1)  -- cell 索引从 0 开始

		local dropInfo = ItemUtil.getGiftData(v)
		local tbItem = dropInfo.item

		local labSeal = m_fnGetWidget(cell, "TFD_ITEM_TYPE") -- 印章
		labSeal:setText(dropInfo.sign) -- zhangqi, 2015-09-16

		local layIcon = m_fnGetWidget(cell, "LAY_ITEM_ICON")
		addBtnToLayout(v.icon, layIcon)

		local labNumTitle = m_fnGetWidget(cell, "TFD_ITEM_NUM_WORD") -- 数量标题
		labelEffect(labNumTitle, m_i18n[1332])

		local labNum = m_fnGetWidget(cell, "TFD_ITEM_NUM") -- 数量
		labNum:setText(v.num)


		local labName = m_fnGetWidget(cell, "TFD_ITEM_NAME") -- 名称
		labName:setColor(g_QulityColor[tonumber(v.quality)])
		labelEffect(labName, v.name)

		local labInfo = m_fnGetWidget(cell, "TFD_ITEM_DESC") -- 介绍
		labInfo:setText(tbItem.desc)
	end

	LayerManager.addLayout(layMain, nil, g_tbTouchPriority.popDlg)
	return layMain
end
--[[desc: liweidong, 探索进度奖励预览
    tbDrop: 后端返回的drop表
    sTitle: 面板标题文本
    return:
—]]
function showExploreProgressItemDlg( tbDrop, sTitle,rewardNum,callback)
	local tbGifts =  ItemDropUtil.getDropTreasureItem(tbDrop)
	logger:debug("item＝＝＝＝＝＝＝＝")
	logger:debug(tbGifts)
	if(table.isEmpty(tbGifts)) then
		return
	end

	local layMain = g_fnLoadUI("ui/supar_reward.json")

	local BTN_SURE = m_fnGetWidget(layMain, "BTN_SURE") -- 确定按钮
	BTN_SURE:addTouchEventListener(callback==nil and closeCallback or callback)
	UIHelper.titleShadow(BTN_SURE,sTitle)

	local lbRewardNum = m_fnGetWidget(layMain, "TFD_TIMES")
	lbRewardNum:setText(rewardNum)
	local lbRewardNum = m_fnGetWidget(layMain, "tfd_now")
	lbRewardNum:setText(gi18n[4307])
	local lbRewardNum = m_fnGetWidget(layMain, "tfd_huode")
	lbRewardNum:setText(gi18n[4308])

	local btnClose = m_fnGetWidget(layMain, "BTN_CLOSE")
	btnClose:addTouchEventListener(onClose)

	-- v {type, num, name, tid}
	local cell
	for i, v in ipairs(tbGifts) do
		cell = layMain

		local dropInfo = ItemUtil.getGiftData(v)
		local tbItem = dropInfo.item

		local imgSeal = m_fnGetWidget(cell, "TFD_ITEM_TYPE") -- 印章
		-- imgSeal:loadTexture(dropInfo.sign)
		imgSeal:setText(ItemUtil.getSignTextByItem(v))

		local layIcon = m_fnGetWidget(cell, "IMG_ITEM_ICON")
		layIcon:addChild(dropInfo.icon)
		--addBtnToLayout(dropInfo.icon, layIcon)

		local labNumTitle = m_fnGetWidget(cell, "TFD_ITEM_NUM_WORD") -- 数量标题
		labelEffect(labNumTitle, m_i18n[1332])

		local labnNum = m_fnGetWidget(cell, "TFD_ITEM_NUM") -- 数量
		labnNum:setText(v.num)

		local labName = m_fnGetWidget(cell, "TFD_ITEM_NAME") -- 名称
		labName:setColor(g_QulityColor[tonumber(v.quality)])
		labelEffect(labName, v.name)

		local labInfo = m_fnGetWidget(cell, "TFD_ITEM_DESC") -- 介绍
		labInfo:setText(tbItem.desc)
	end

	LayerManager.addLayout(layMain, nil, g_tbTouchPriority.popDlg)
	return layMain
end
--[[desc: liweidong, 探索获得item显示面板。点击任意位置关闭，特殊处理
    tbDrop: 后端返回的drop表
    sTitle: 面板标题文本
    return:
—]]
function showExplorDropItemDlg( tbDrop, sTitle ,callback)
	logger:debug("createDropItemDlg＝＝＝＝＝＝＝＝")
	logger:debug(tbDrop)

	local tbGifts =  ItemDropUtil.getDropTreasureItem(tbDrop)
	logger:debug({showExplorDropItemDlg_tbGifts = tbGifts})
	if(table.isEmpty(tbGifts)) then
		return
	end

	local layMain = g_fnLoadUI("ui/bag_open_gift.json")

	local i18nTitle2 = m_fnGetWidget(layMain, "TFD_COMMON_TITLE") -- 恭喜您获得
	labelEffect(i18nTitle2, m_i18n[1901])

	local btnClose = m_fnGetWidget(layMain, "BTN_CLOSE")
	btnClose:addTouchEventListener(callback)

	local btnOK = m_fnGetWidget(layMain, "BTN_CERTAIN")
	titleShadow(btnOK, m_i18n[1029])
	btnOK:addTouchEventListener(callback)

	local lsvGift = m_fnGetWidget(layMain, "LSV_OPEN_GIFT")
	initListView(lsvGift)

	local img_bg=m_fnGetWidget(layMain, "lay_bg")
	local img_reward_bg=m_fnGetWidget(layMain, "img_open_gift_bg")

	local ncount = table.getn(tbGifts) -- 统计cell 个数
	if(ncount>2) then  -- 对多于两行对处理
		img_reward_bg:setSize(CCSizeMake(img_reward_bg:getSize().width,img_reward_bg:getSize().height*2.3)) --2.3
		img_bg:setSize(CCSizeMake(img_bg:getSize().width,img_bg:getSize().height*1.58)) --1.58
	elseif(ncount==2)  then
		img_reward_bg:setSize(CCSizeMake(img_reward_bg:getSize().width,img_reward_bg:getSize().height*1.86))
		img_bg:setSize(CCSizeMake(img_bg:getSize().width,img_bg:getSize().height*1.38))
		-- LSV_DROP:setSize(CCSizeMake(LSV_DROP:getSize().width,LSV_DROP:getSize().height*2))
	end

	-- v {type, num, name, tid}
	local cell
	for i, v in ipairs(tbGifts) do
		lsvGift:pushBackDefaultItem()
		cell = lsvGift:getItem(i - 1)  -- cell 索引从 0 开始

		local dropInfo = ItemUtil.getGiftData(v)
		local tbItem = dropInfo.item

		local labSeal = m_fnGetWidget(cell, "TFD_ITEM_TYPE") -- 印章
		labSeal:setText(dropInfo.sign) -- zhangqi, 2015-09-16

		local layIcon = m_fnGetWidget(cell, "LAY_ITEM_ICON")
		addBtnToLayout(dropInfo.icon, layIcon)

		local labNumTitle = m_fnGetWidget(cell, "TFD_ITEM_NUM_WORD") -- 数量标题
		labelEffect(labNumTitle, m_i18n[1332])

		local labNum = m_fnGetWidget(cell, "TFD_ITEM_NUM") -- 数量
		labNum:setText(v.num)

		local labName = m_fnGetWidget(cell, "TFD_ITEM_NAME") -- 名称
		labName:setColor(g_QulityColor[tonumber(v.quality)])
		labelEffect(labName, v.name)

		local labInfo = m_fnGetWidget(cell, "TFD_ITEM_DESC") -- 介绍
		labInfo:setText(tbItem.desc)
	end

	LayerManager.addLayout(layMain, nil, g_tbTouchPriority.popDlg)

	--点击对话况之外任意地方关闭
	img_bg:setTouchEnabled(true)
	layMain:setTouchEnabled(true)
	layMain:addTouchEventListener(function(sender, eventType)
		if (eventType ~= TOUCH_EVENT_ENDED) then
			return
		end
		LayerManager.removeLayout()
	end
	)
	return layMain
end
--[[desc:创建item的信息框
    arg1: item的DB信息 ，数量
    return: 返回信息面板
    add by huxiaozhou 2014-05-22
—]]
function createItemInfoDlg( _tbItem ,_number)
	local layMain = g_fnLoadUI("ui/public_item_info.json")

	local layIcon = m_fnGetWidget(layMain, "LAY_ITEM_ICON")

	local btnClose = m_fnGetWidget(layMain, "BTN_CLOSE") --关闭按钮
	btnClose:addTouchEventListener(onClose)

	local BTN_SURE = m_fnGetWidget(layMain, "BTN_SURE") -- 确定按钮
	BTN_SURE:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect() -- 2016-01-08
			LayerManager.removeLayout()
		end
	end)
	UIHelper.titleShadow(BTN_SURE, m_i18n[1029])

	local labType = m_fnGetWidget(layMain, "TFD_ITEM_TYPE") -- 类型
	labType:setText(ItemUtil.getSignTextByItem(_tbItem))

	local labName = m_fnGetWidget(layMain, "TFD_ITEM_NAME") -- 名称
	UIHelper.labelEffect(labName, _tbItem.name)
	assert(_tbItem.quality, "quality is " .. _tbItem.quality or type(_tbItem.quality ))
	labName:setColor(g_QulityColor[tonumber(_tbItem.quality)])

	local labNumI18n = m_fnGetWidget(layMain, "TFD_ITEM_NUM_WORD") -- 文字 “数量” 以后国际化用
	UIHelper.labelEffect(labNumI18n, m_i18n[1332])
	local labNum = m_fnGetWidget(layMain, "TFD_ITEM_NUM") -- 数量
	labNum:setText(_number or 1)

	if not _number then
		labNumI18n:setEnabled(false)
		labNum:setEnabled(false)
	end

	local labInfo = m_fnGetWidget(layMain, "TFD_ITEM_DESC") -- 介绍
	labInfo:setText(_tbItem.desc)

	local btnIcon = ItemUtil.createBtnByItem(_tbItem)
	addBtnToLayout(btnIcon, layIcon) -- zhangqi, 2014-07-16

	return layMain
end


function getRewardInfoDlg( stitle, _tbItems, fnCallBack, subTitle, fnClose)   ---modife zhangjunwu 返回奖励狂的画布，方便外面获取空间
	return createRewardDlg(_tbItems, fnCallBack)
end

--[[desc:创建获取到的奖励提示框
    stitle:  提示框 名称
    _tbItem:  奖励物品信息 { {icon = btn, name = name, quality = number}, ...}
    return: 返回信息面板
    add by huxiaozhou 2014-05-28 
—]]
function createGetRewardInfoDlg( stitle, _tbItems, fnCallBack, subTitle, fnClose)   ---fnClose  指定 关闭按钮的事件 add by lizy
	local dlg = createRewardDlg(_tbItems, fnCallBack)
	LayerManager.addLayoutNoScale(dlg)
end

-- 原来的奖励面板，现在探索的奖励预览要用
function createRewardPreviewDlg( stitle, _tbItems, fnCallBack, subTitle, fnClose )
	local layMain = g_fnLoadUI("ui/copy_get_reward.json")

	local img_bg = m_fnGetWidget(layMain,"img_bg")-- 主背景

	-- local tfd_title = m_fnGetWidget(layMain,"tfd_title") -- 奖励提示框名称
	-- tfd_title:setText(stitle)
	-- labelEffect(tfd_title,stitle)
	layMain.img_title_daytask:setVisible(false)
	if subTitle then
		logger:debug("subtitle====".. subTitle)
		local tfd_info = m_fnGetWidget(layMain,"tfd_info") -- 奖励提示框名称
		tfd_info:setText(subTitle)
	else
		local i18ntfd_info = m_fnGetWidget(layMain,"tfd_info") -- 奖励介绍 -- 需要本地化的文字 信息 "恭喜船长获得如下奖励："
		labelEffect(i18ntfd_info,m_i18n[1322])
	end


	local LSV_DROP = m_fnGetWidget(layMain,"LSV_DROP") -- listview

	initListView(LSV_DROP)

	logger:debug(_tbItems)

	local tbSortData = {}

	local tbSub = {}
	for i,v in ipairs(_tbItems) do
		table.insert(tbSub,v)
		if(table.maxn(tbSub)>=4) then
			table.insert(tbSortData,tbSub)
			tbSub = {}
		elseif(i==table.maxn(_tbItems)) then
			table.insert(tbSortData,tbSub)
			tbSub = {}
		end
	end
	local cell

	local tbCell = {}
	for i, itemInfo in ipairs(tbSortData) do
		LSV_DROP:pushBackDefaultItem()

		cell = LSV_DROP:getItem(i-1)  -- cell 索引从 0 开始
		table.insert(tbCell,cell)
		for index,item in ipairs(itemInfo) do
			local imgKey = "IMG_" .. index
			local img = m_fnGetWidget(cell, imgKey)
			img:addChild(item.icon)
			local nameKey = "TFD_NAME_" .. index
			local labName = m_fnGetWidget(cell, nameKey) -- 名称
			labName:setText(item.name)
			labelEffect(labName,item.name)

			if (item.quality ~= nil) then
				local color =  g_QulityColor[tonumber(item.quality)]
				if(color ~= nil) then
					labName:setColor(color)
				end
			end

			if (index == table.maxn(itemInfo) and index < 4) then --移除剩余的
				for j=index+1,4 do
					imgKey = "IMG_" .. j
					nameKey = "TFD_NAME_" .. j
					local img = m_fnGetWidget(cell, imgKey)
					local labName = m_fnGetWidget(cell, nameKey) -- 名称
					img:removeFromParent()
					labName:removeFromParent()
			end
			end
		end
	end

	local bgSize = img_bg:getVirtualRenderer():getContentSize()
	local img_reward_bg = m_fnGetWidget(layMain,"img_reward_bg")
	local rewBgSize = img_reward_bg:getSize()

	logger:debug(tbSortData)

	local ncount = table.count(tbSortData)  -- table.maxn(tbSortData) -- 统计cell 个数
	logger:debug("ncount == %s", ncount)

	logger:debug("ncount/4 = %s" ,ncount/4)

	-- if (ncount > 2) then  -- 对多于两行对处理, 一行4个
	-- 	img_reward_bg:setSize(CCSizeMake(rewBgSize.width, rewBgSize.height*2.5))
	-- 	img_bg:setSize(CCSizeMake(bgSize.width, bgSize.height*1.4))
	-- elseif (ncount == 2) then -- zhangqi, 由 == 2 修改为 <= 2,  20141229 huxiaozhou 由 <= 修改为 ==
	-- 	img_reward_bg:setSize(CCSizeMake(rewBgSize.width, rewBgSize.height*2))
	-- 	img_bg:setSize(CCSizeMake(bgSize.width, bgSize.height*1.25))
	-- end
	if (ncount==2) then
		layMain.img_reward_bg:setSize(CCSizeMake(layMain.img_reward_bg:getSize().width,layMain.img_reward_bg:getSize().height*2))
		layMain.img_bg:setSize(CCSizeMake(layMain.img_bg:getSize().width,layMain.img_bg:getSize().height+140))
	elseif (ncount>=3) then
		layMain.img_reward_bg:setSize(CCSizeMake(layMain.img_reward_bg:getSize().width,layMain.img_reward_bg:getSize().height*2.5))
		layMain.img_bg:setSize(CCSizeMake(layMain.img_bg:getSize().width,layMain.img_bg:getSize().height+210))
	end

	--绑定按钮事件
	local btnGet = m_fnGetWidget(layMain,"BTN_GET") --确定按钮
	titleShadow(btnGet,m_i18n[1029])
	btnGet:addTouchEventListener( 	function (sender ,eventType )  ---为 按钮加入时间，如果回调空默认为关闭  add by lizy
		if (eventType == TOUCH_EVENT_ENDED) then
			local func = fnCallBack or closeCallback
			func()
	end
	end)

	local btnClose = m_fnGetWidget(layMain,"BTN_CLOSE") --关闭按钮
	btnClose:addTouchEventListener( function ( sender ,eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			local func = fnClose or closeCallback
			func()
		end
	end)

	return layMain
end




--[[desc:通用奖励面板 modify by yangna 2016.1.20
    tbItems:奖励数据 table
    callBack 		确认按钮回调
	isAfterEnd 		true:旧方案是最后一个奖励翻牌结束后允许关闭，现在已经没用了
    return: 是否有返回值，返回值说明  
—]]
function createRewardDlg( tbItems, callback, isAfterEnd )
	AudioHelper.playSpecialEffect("huodejiangli.mp3")
	local tbNames = {"win_drop_black/white", "win_drop_black/white", "win_drop_green", "win_drop_blue", "win_drop_purple", "win_drop_orange"}

	local layout = g_fnLoadUI("ui/public_get_reward.json")
	LayerManager.lockOpacity(layout)
	registExitAndEnterCall(layout, function ( ... )
		removeArmatureFileCache()
		for i=1,#tbItems do
			tbItems[i].icon:release()
		end
	end)

	for i=1,#tbItems do
		tbItems[i].icon:retain()
	end

	local nMaxCount = 3  --最大显示行数
	local imgArrowUp = m_fnGetWidget(layout, "IMG_ARROW_UP")
	local imgArrowBottom = m_fnGetWidget(layout, "IMG_ARROW_BOTTOM")
	imgArrowUp:setEnabled(false)
	imgArrowBottom:setEnabled(false)

	layout.img_title:setVisible(false)
	local btnSure = m_fnGetWidget(layout, "BTN_SURE")
	local layTouch = m_fnGetWidget(layout, "lay_touch")
	local eventBtn = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()

			if (callback and type(callback) == "function") then
				callback()
			else
				LayerManager.removeLayout()
			end
		end
	end
	btnSure:addTouchEventListener(eventBtn)
	layTouch:addTouchEventListener(eventBtn)

	titleShadow(btnSure, gi18n[1029])

	local layOpen = m_fnGetWidget(layout,"lay_open")
	local btnAgain1  = m_fnGetWidget(layOpen,"BTN_1")
	local btnAgain10 = m_fnGetWidget(layOpen,"BTN_10")
	local btnClose = m_fnGetWidget(layOpen,"BTN_CLOSE")

	titleShadow(btnClose , gi18n[2821])
	local function setBtnTouchEnabled( bValue )
		layTouch:setTouchEnabled(bValue)
		btnSure:setTouchEnabled(bValue)

		if (bValue and not (layOpen:isVisible() and layOpen:isEnabled())) then
			bValue = false
		end

		layOpen:setTouchEnabled(bValue)
		btnAgain1:setTouchEnabled(bValue)
		btnAgain10:setTouchEnabled(bValue)
		btnClose:setTouchEnabled(bValue)
	end

	setBtnTouchEnabled(false)

	local lsvDrop = m_fnGetWidget(layout, "LSV_DROP")
	local defaultItem = lsvDrop:getItem(0)
	lsvDrop:setItemModel(defaultItem)
	lsvDrop:removeAllItems()
	lsvDrop:setTouchEnabled(false)

	local imgForFill1 = ImageView:create()
	imgForFill1:loadTexture("ui/arrow_public.png")
	imgForFill1:setEnabled(false)
	imgForFill1:setScale9Enabled(true)
	imgForFill1:setSize(CCSizeMake(100, 35))
	lsvDrop:pushBackCustomItem(imgForFill1)

	local originSize = lsvDrop:getSize()
	local cellHeight = defaultItem:getSize().height
	local rowCount = math.ceil(#tbItems / 4)
	local lsvDropHeight =  cellHeight * rowCount + 45
	lsvDropHeight = lsvDropHeight > originSize.height and originSize.height or lsvDropHeight
	lsvDrop:setSize(CCSizeMake(originSize.width, lsvDropHeight))

	for i = 1, rowCount do
		lsvDrop:pushBackDefaultItem()
		local item = lsvDrop:getItem(i)
		for j=1,4 do
			local layDrop = m_fnGetWidget(item, "LAY_DROP" .. j)
			layDrop:setEnabled(false)
			if (rowCount == 1) then
				local pos = layDrop:getPositionPercent()
				local offX = (4 - #tbItems) * 0.5 * layDrop:getSize().width / item:getSize().width
				layDrop:setPositionPercent(ccp(pos.x + offX, pos.y))
			end
		end
	end

	local imgForFill2 = ImageView:create()
	imgForFill2:loadTexture("ui/arrow_public.png")
	imgForFill2:setEnabled(false)
	imgForFill2:setScale9Enabled(true)
	imgForFill2:setSize(CCSizeMake(100, 10))
	lsvDrop:pushBackCustomItem(imgForFill2)

	function playAnimation( index )
		local row = math.ceil(index / 4)
		local col = index - row * 4 + 4

		if (index > #tbItems) then
			setBtnTouchEnabled(true)	
			return 
		end 

		-- 超过nMaxCount行，翻牌到nmaxCount行的最后一个时，显示箭头，继续其余翻牌
		if ((rowCount>=nMaxCount and index == nMaxCount*4)) then 
			setBtnTouchEnabled(true)
			lsvDrop:setTouchEnabled(true)
			-- 上下剪头
			local arrowUp = UIHelper.fadeInAndOutImage("ui/arrow_public.png")
			local arrowBottom = UIHelper.fadeInAndOutImage("ui/arrow_public.png")
			arrowUp:setRotation(180)
			arrowUp:setPosition(ccp(imgArrowUp:getPositionX(), imgArrowUp:getPositionY()))
			arrowBottom:setPosition(ccp(imgArrowBottom:getPositionX(), imgArrowBottom:getPositionY()))
			imgArrowUp:getParent():addNode(arrowUp)
			imgArrowBottom:getParent():addNode(arrowBottom)
			arrowBottom:setVisible(false)

			lsvDrop:addEventListenerScrollView(function (sender, ScrollviewEventType)
				local offset = lsvDrop:getContentOffset()
				local lisvSizeH = lsvDrop:getSize().height
				local lisvContainerH = lsvDrop:getInnerContainerSize().height
				if (offset - lisvSizeH < 1) then
					arrowUp:setVisible(false)
				else
					arrowUp:setVisible(true)
				end

				if (offset- lisvContainerH < 0) then
					arrowBottom:setVisible(true)
				else
					arrowBottom:setVisible(false)
				end
			end)
		end 

		local itemInfo = tbItems[index]
		local item = lsvDrop:getItem(row)
		local layDrop = m_fnGetWidget(item, "LAY_DROP" .. col)
		local imgIcon = m_fnGetWidget(item, "IMG_" .. col)
		local tfdName = m_fnGetWidget(item, "TFD_NAME_" .. col)

		local x, y = imgIcon:getPosition()
		local callfunc1 = CCCallFunc:create(function ( ... )

		end)

		local callfunc2 = CCCallFunc:create(function ( ... )
			local armature = createArmatureNode({
				filePath = "images/effect/battle_result/win_drop.ExportJson",
				fnFrameCall = function ( bone, frameEventName, originFrameIndex, currentFrameIndex )
					if (frameEventName == "1") then
						tfdName:setEnabled(true)

						if (itemInfo.quality) then
							local armatureLight = createArmatureNode({
								filePath = "images/effect/battle_result/win_drop.ExportJson",
								animationName = tbNames[tonumber(itemInfo.quality)],
								bRetain = true,
							})
							armatureLight:setPosition(ccp(x, y))
							layDrop:addNode(armatureLight, -1, -1)
						end

						if (rowCount > nMaxCount and index >= nMaxCount * 4) then 
							setBtnTouchEnabled(true)
						end 

						playAnimation( index + 1 )
					end
				end,

				fnMovementCall = function ( sender, MovementEventType, frameEventName)
					if (MovementEventType == 1) then
						sender:removeFromParentAndCleanup(true)
						imgIcon:setEnabled(true)
						imgIcon:addChild(itemInfo.icon)
					end
				end,
				bRetain = true,
			})

			tfdName:setText(itemInfo.name)
			if (itemInfo.quality) then
				tfdName:setColor(g_QulityColor2[tonumber(itemInfo.quality)])
			end
			labelNewStroke( tfdName, ccc3(0x28,0,0) )

			armature:getBone("win_drop_3"):addDisplay(itemInfo.icon, 0)
			armature:setPosition(ccp(x, y))
			layDrop:addNode(armature)
			layDrop:setEnabled(true)
			imgIcon:setEnabled(false)

			AudioHelper.playSpecialEffect("texiao_fanpai.mp3")
			armature:getAnimation():play("win_drop", -1, -1, 0)
			armature:getAnimation():setSpeedScale(math.ceil(rowCount / 32))
		end)
		local sequence = CCSequence:createWithTwoActions(callfunc1, callfunc2)
		layout:runAction(sequence)
	end

	-- 标题特效
	local function addTitleLightAni( node )
		local movementCall = function ( sender, MovementEventType, frameEventName )
			if (MovementEventType == 1) then
				sender:removeFromParentAndCleanup(true)
				sender = nil
			end
		end

		local armature = createArmatureNode({
			filePath = "images/effect/normal_reward/normal_reward_title.ExportJson",
			animationName = "normal_reward_title",
			fnMovementCall = movementCall,
		})
		node:addNode(armature) 
		armature:setZOrder(1)
	end


	local function titleAction( ... )
		local img_title = layout.img_title
		img_title:setVisible(true)
		local array = CCArray:create()
		array:addObject(CCDelayTime:create(FRAME_TIME))
		array:addObject(CCScaleTo:create(FRAME_TIME*4,5))
		array:addObject(CCScaleTo:create(FRAME_TIME*2,0.9))
		array:addObject(CCScaleTo:create(FRAME_TIME,1))
		array:addObject(CCCallFuncN:create(function (sender)
			addTitleLightAni(sender)
		end))
		local seq = CCSequence:create(array)
		img_title:runAction(seq)
	end

	-- 背景特效
	local function addBackAniation( ... )
		local movementCall = function ( sender, MovementEventType, frameEventName )
			if (MovementEventType == 1) then
				sender:removeFromParentAndCleanup(true)
				sender = nil
			end
		end

		local framementCall = function ( bone, frameEventName, originFrameIndex, currentFrameIndex )
			if (frameEventName == "1") then
				playAnimation(1)
			end

			if (frameEventName == "2") then 
				titleAction()
			end  
		end

		local armature = createArmatureNode({
			filePath = "images/effect/normal_reward/normal_reward_light.ExportJson",
			animationName = "normal_reward_light",
			fnFrameCall = framementCall,
			fnMovementCall = movementCall,
		})
		layout:addNode(armature) 
		armature:setPosition(ccp(g_winSize.width/2,g_winSize.height/2))
	end


	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("images/effect/normal_reward/normal_reward_title.ExportJson")
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("images/effect/battle_result/win_drop.ExportJson")
	performWithDelay(layout, function ( ... )
		addBackAniation()
	end, 0.3)


	return layout
end


--[[desc:创建金币不足提示框
    arg1: 无
    return: 金币不足提示框 
    add by huxiaozhou 2014-05-22
—]]
function createNoGoldAlertDlg( )
	local noGoldAlert
	local vip_gift_ids = nil
	logger:debug(table.count(DB_Vip.Vip))
	if(UserModel.getVipLevel() < table.count(DB_Vip.Vip)) then
		vip_gift_ids = DB_Vip.getDataById(UserModel.getVipLevel()+1).vip_gift_ids
	end
	if(UserModel.getVipLevel() >= table.count(DB_Vip.Vip) or vip_gift_ids == nil) then -- 判断是否达到最大vip等级
		noGoldAlert = createNoGoldForMaxVip()
	else
		noGoldAlert = createNoGoldForCommon()
	end
	return noGoldAlert
end

-- tbParams = {sTitle = "您得购买次数不足",sUnit = "次" 或者 "个",sName = "竞技场次数",nNowBuyNum=1 (现在vip 能购买的次（个）数),nNextBuyNum=2（下一个vip能购买的次（个）数）,}
function createVipBoxDlg( tbParams)
	local vipLv, vipMaxLv = UserModel.getVipLevel(), table.count(DB_Vip.Vip)
	logger:debug({vipLv = vipLv, vipMaxLv = vipMaxLv})

	if (vipLv >= vipMaxLv) then
		require "script/module/public/ShowNotice"
		ShowNotice.showShellInfo(m_i18n[2267])
	else
		local vip_gift_ids = DB_Vip.getDataById(vipLv + 1).vip_gift_ids
		local noGoldAlert = (vip_gift_ids == nil) and createNoGiftDlg(tbParams) or createNoGoldForCommon(tbParams)
		return noGoldAlert
	end

	return nil
end

-- tbParams = {sTitle = "您得购买次数不足",sUnit = "次" 或者 "个",sName = "竞技场次数",nNowBuyNum=1 (现在vip 能购买的次（个）数),nNextBuyNum=2（下一个vip能购买的次（个）数）,}
-- 没有vip礼包 但是有购买次数
function createNoGiftDlg( tbParams )
	local layMain = g_fnLoadUI("ui/public_vip_privilege_nogift.json")
	local i18ntfd_now_vip_level = m_fnGetWidget(layMain,"tfd_now_vip_level") -- 您当前的VIP等级：
	i18ntfd_now_vip_level:setText(m_i18n[1411])
	local LABN_NOW_VIP = m_fnGetWidget(layMain,"LABN_NOW_VIP")
	LABN_NOW_VIP:setStringValue(UserModel.getVipLevel())

	--宝箱名字
	local i18nTFD_TITLE = m_fnGetWidget(layMain,"TFD_TITLE") -- 对话框名字 “您的金币不足”

	labelEffect(i18nTFD_TITLE,tbParams.sTitle)

	--宝箱名字
	local TFD_ITEM_NAME1 = m_fnGetWidget(layMain,"TFD_ITEM_NAME1")
	TFD_ITEM_NAME1:setText(tbParams.sName)
	local TFD_ITEM_NAME2 = m_fnGetWidget(layMain,"TFD_ITEM_NAME2")
	TFD_ITEM_NAME2:setText(tbParams.sName)

	local TFD_NOW_TIMES = m_fnGetWidget(layMain,"TFD_NOW_TIMES")
	TFD_NOW_TIMES:setText(tbParams.nNowBuyNum)
	local TFD_NEXT_TIMES = m_fnGetWidget(layMain,"TFD_NEXT_TIMES")
	TFD_NEXT_TIMES:setText(tbParams.nNextBuyNum)

	--下一级的vip等级
	local LABN_NEXT_VIP = m_fnGetWidget(layMain,"LABN_NEXT_VIP")
	LABN_NEXT_VIP:setStringValue(UserModel.getVipLevel() + 1)

	local TFD_RECHARGE_GOLD = m_fnGetWidget(layMain,"TFD_RECHARGE_GOLD") --还需要充值多少钱

	local db_vip = DB_Vip.getDataById(UserModel.getVipLevel()+1)
	local needGold = db_vip.rechargeValue - DataCache.getChargeGoldNum()
	TFD_RECHARGE_GOLD:setText(tostring(needGold)) --还差多少金币

	local BTN_RECHARGE = m_fnGetWidget(layMain,"BTN_RECHARGE") -- 充值按钮
	titleShadow(BTN_RECHARGE,m_i18n[2116])
	local BTN_CLOSE = m_fnGetWidget(layMain,"BTN_CLOSE") -- 关闭按钮
	BTN_CLOSE:addTouchEventListener(onClose)

	return layMain

end

-- add by huxiaozhou 给已经达到最大vip等级的人物提示金币不足 去充值
function createNoGoldForMaxVip( )
	local layMain = g_fnLoadUI("ui/public_top_vip_gold_not_enough.json")
	local i18nTFD_TITLE = m_fnGetWidget(layMain,"TFD_TITLE") -- 对话框名字 “您的金币不足”
	labelEffect(i18nTFD_TITLE,m_i18n[1410])
	local i18ntfd_now_vip_level = m_fnGetWidget(layMain,"tfd_now_vip_level") -- 您当前的VIP等级：
	i18ntfd_now_vip_level:setText(m_i18n[1411])
	local LABN_NOW_VIP = m_fnGetWidget(layMain,"LABN_NOW_VIP")
	LABN_NOW_VIP:setStringValue(UserModel.getVipLevel())

	local BTN_RECHARGE = m_fnGetWidget(layMain,"BTN_RECHARGE") -- 充值按钮
	titleShadow(BTN_RECHARGE,m_i18n[2116])
	BTN_RECHARGE:addTouchEventListener(function ( sender, eventType ) -- 封测包临时给充值按钮添加未开启提示
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			LayerManager.removeLayout()
			require "script/module/IAP/IAPCtrl"
			LayerManager.addLayout(IAPCtrl.create())
	end
	end)

	local BTN_CLOSE = m_fnGetWidget(layMain,"BTN_CLOSE") -- 关闭按钮
	BTN_CLOSE:addTouchEventListener(onClose)

	return layMain
end

-- tbParams = {sTitle = "您得购买次数不足",sUnit = "次" 或者 "个",sName = "竞技场次数",nNowBuyNum=1,nNextBuyNum=2,}
-- add by huxiaozhou 给尚未达到最大vip等级的玩家 提示金币不足 充值
function createNoGoldForCommon( tbParams)
	local layMain = nil
	if tbParams==nil then
		layMain = g_fnLoadUI("ui/public_nor_vip_gold_not_enough.json")

		local i18nTFD_TITLE = m_fnGetWidget(layMain,"TFD_TITLE") -- 对话框名字 “您的金币不足”
		labelEffect(i18nTFD_TITLE,m_i18n[1410])

	else
		layMain = g_fnLoadUI("ui/public_vip_privilege.json")

		local i18nTFD_TITLE = m_fnGetWidget(layMain,"TFD_TITLE") -- 对话框名字 “您的金币不足”

		labelEffect(i18nTFD_TITLE,tbParams.sTitle)

		--宝箱名字
		local TFD_ITEM_NAME1 = m_fnGetWidget(layMain,"TFD_ITEM_NAME1")
		TFD_ITEM_NAME1:setText(tbParams.sName)
		local TFD_ITEM_NAME2 = m_fnGetWidget(layMain,"TFD_ITEM_NAME2")
		TFD_ITEM_NAME2:setText(tbParams.sName)

		local TFD_NOW_TIMES = m_fnGetWidget(layMain,"TFD_NOW_TIMES")
		TFD_NOW_TIMES:setText(tbParams.nNowBuyNum)
		local TFD_NEXT_TIMES = m_fnGetWidget(layMain,"TFD_NEXT_TIMES")
		TFD_NEXT_TIMES:setText(tbParams.nNextBuyNum)

		--[[
		TFD_ITEM_NAME1:setText(boxName)

		local maxLimitNum = ShopUtil.getAddBuyTimeBy(UserModel.getVipLevel(), tbParams.boxTid)
		logger:debug(maxLimitNum)
		--宝箱可以购买的次数
		local TFD_NOW_TIMES = m_fnGetWidget(layMain,"TFD_NOW_TIMES")
		TFD_NOW_TIMES:setText(tostring(maxLimitNum))


		--下一级的vip等级

		--宝箱名字
		local TFD_ITEM_NAME2 = m_fnGetWidget(layMain,"TFD_ITEM_NAME2")
		TFD_ITEM_NAME2:setText(boxName)

		local nextMaxLimitNum = ShopUtil.getAddBuyTimeBy(UserModel.getVipLevel() + 1, tbParams.boxTid)
		logger:debug(nextMaxLimitNum)
		--宝箱可以购买的次数
		local TFD_NEXT_TIMES = m_fnGetWidget(layMain,"TFD_NEXT_TIMES")
		TFD_NEXT_TIMES:setText(tostring(nextMaxLimitNum))
--]]
	end



	local i18ntfd_now_vip_level = m_fnGetWidget(layMain,"tfd_now_vip_level") -- 您当前的VIP等级：
	i18ntfd_now_vip_level:setText(m_i18n[1411])

	local LABN_NOW_VIP = m_fnGetWidget(layMain,"LABN_NOW_VIP")

	LABN_NOW_VIP:setStringValue(UserModel.getVipLevel())

	local i18ntfd_recharge_again = m_fnGetWidget(layMain,"tfd_recharge_again")  -- "再充值"
	i18ntfd_recharge_again:setText(m_i18n[1413])

	local i18nTFD_RECHARGE_GOLD = m_fnGetWidget(layMain,"TFD_RECHARGE_GOLD") --20000金币，
	i18nTFD_RECHARGE_GOLD:setText(m_i18n[1414])

	local db_vip = DB_Vip.getDataById(UserModel.getVipLevel()+1)


	i18nTFD_RECHARGE_GOLD:setText(string.format("%d",db_vip.rechargeValue-DataCache.getChargeGoldNum())) --还差多少金币

	local i18ntfd_will_be = m_fnGetWidget(layMain,"tfd_will_be") -- 您将成为
	local LABN_NEXT_VIP = m_fnGetWidget(layMain,"LABN_NEXT_VIP")
	LABN_NEXT_VIP:setStringValue(UserModel.getVipLevel()+1)



	local LABN_VIP_LEVEL_TILTE = m_fnGetWidget(layMain,"LABN_VIP_LEVEL_TILTE")
	LABN_VIP_LEVEL_TILTE:setStringValue(UserModel.getVipLevel()+1)

	local vipData = DB_Vip.getDataById(UserModel.getVipLevel()+1)
	require "script/module/shop/ShopGiftData"
	require "script/module/public/PublicInfoCtrl"
	local tbShowItems = RewardUtil.parseRewards(vipData.vip_gift_ids)
	local LSV_ITEM_LIST = m_fnGetWidget(layMain,"LSV_ITEM_LIST")
	local LAY_ITEM_BG = m_fnGetWidget(LSV_ITEM_LIST, "LAY_ITEM_BG")

	initListView(LSV_ITEM_LIST)
	local cell, nIdx

	for i,tempIcon in ipairs(tbShowItems) do
		LSV_ITEM_LIST:pushBackDefaultItem()
		nIdx = i - 1
		cell = LSV_ITEM_LIST:getItem(nIdx)  -- cell 索引从 0 开始

		local IMG_ICON = m_fnGetWidget(cell,"IMG_ICON")
		IMG_ICON:addChild(tempIcon.icon)
		local TFD_ITEM_NAME = m_fnGetWidget(cell, "TFD_ITEM_NAME")
		labelAddStroke(TFD_ITEM_NAME)
		TFD_ITEM_NAME:setText(tempIcon.name)
		local color =  g_QulityColor[tonumber(tempIcon.quality)]
		if(color ~= nil) then
			TFD_ITEM_NAME:setColor(color)
		end

	end


	local BTN_RECHARGE = m_fnGetWidget(layMain,"BTN_RECHARGE") -- 充值按钮
	titleShadow(BTN_RECHARGE,m_i18n[2116])
	BTN_RECHARGE:addTouchEventListener(function ( sender, eventType ) -- 封测包临时给充值按钮添加未开启提示
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()

			LayerManager.removeLayout()
			require "script/module/IAP/IAPCtrl"
			LayerManager.addLayout(IAPCtrl.create())
	end
	end)


	local BTN_CLOSE = m_fnGetWidget(layMain,"BTN_CLOSE") -- 关闭按钮
	BTN_CLOSE:addTouchEventListener(onClose)

	logger:debug(DataCache.getChargeGoldNum())
	layMain:setSize(g_winSize)
	return layMain
end




-- 只限版署版
function createEditionCheckNotice( ... )
	local info = "健康游戏忠告\n抵制不良游戏 拒绝盗版游戏；\n注意自我保护 谨防受骗上当；\n适度游戏益脑 沉迷游戏伤身；\n合理安排时间 享受健康生活。"
	local dlg = createCommonDlg(info, nil)
	dlg:setSize(g_winSize)
	return dlg
end

--[[desc: zhangqi, 2014-05-05, 创建一个HZTableView
 szViewSize: CCSize,
 szCellSize: CCSize,
 nCellNumber: cell 个数
 fnCellAtIndex: 创建和刷新cell的方法，原型: function fun(view, idx)
 fnCellTouched: cell被点击的事件回调，nil的话默认显示事件类型名
 fnDidScroll: 滑动的事件回调，nil的话默认显示事件类型名
 fnDidZoom: 缩放事件回调，nil的话默认显示事件类型名
 return: CCTableView 对象
 —]]
function createHZTableView( szViewSize, szCellSize, nCellNumber, fnCellAtIndex, fnCellTouched, fnDidScroll, fnDidZoom )
	local tableView = HZTableView:create(szViewSize)
	tableView:setDirection(kCCScrollViewDirectionVertical) -- 默认垂直滑动
	tableView:setVerticalFillOrder(kCCTableViewFillTopDown) -- 默认从上至下放置
	tableView:setPosition(ccp(0, 0))

	--registerScriptHandler functions must be before the reloadData function
	tableView:registerScriptHandler(fnDidScroll or function ( view )
		logger:debug("CCTableView.kTableViewScroll")
	end, CCTableView.kTableViewScroll)

	tableView:registerScriptHandler(fnDidZoom or function ( view )
		logger:debug("CCTableView.kTableViewZoom")
	end, CCTableView.kTableViewZoom)

	tableView:registerScriptHandler(fnCellTouched or function ( view, cell )
		logger:debug("CCTableView.kTableCellTouched")
	end, CCTableView.kTableCellTouched)

	tableView:registerScriptHandler(function ( view, idx )
		logger:debug("szCellSize.w = ", szCellSize.width, "szCellSize.h = ", szCellSize.height)
		return szCellSize.height, szCellSize.width
	end, CCTableView.kTableCellSizeForIndex)

	tableView:registerScriptHandler(fnCellAtIndex, CCTableView.kTableCellSizeAtIndex)

	tableView:registerScriptHandler(function ( view )
		return nCellNumber or 0
	end, CCTableView.kNumberOfCellsInTableView)

	-- tableView:reloadData()

	return tableView
end


--[[desc:为一个node的enter和exit方法绑定回调-- zhangjunwu,  modified by huxiaozhou
    arg1: node需要绑定的node,onExitCall,onEnterCall是exit和enter的回调
    return: 是否有返回值，返回值说明  
—]]
function registExitAndEnterCall( node,onExitCall,onEnterCall,onEnterFinish)
	-- if (node.m_status_scriptHandler) then
	-- 	print(debug.traceback())
	-- 	error("have regist ExitAndEnterCall")
	-- end
	node.m_status_scriptHandler=true
	local function onNodeEvent( eventType )
		logger:debug(eventType)
		if (eventType == "enter") then
			if (onEnterCall) then
				onEnterCall()
			end
		elseif (eventType == "exit") then
			local layoutType = tonumber(LayerManager.getChangModuleType())
			if (layoutType==1) then
				return
			end
			revmoeFrameNode(node)
			if (onExitCall) then
				onExitCall()
			end
		elseif (eventType =="enterTransitionFinish" ) then
			if (onEnterFinish) then
				onEnterFinish()
			end
		elseif (eventType=="exitTransitionStart") then
			return
		elseif (eventType=="cleanup") then
			return
		end
	end
	node:registerScriptHandler(onNodeEvent)
end

function clearTouchStat( ... )
	local oneTouch = LayerManager.getCurrentPopLayer()
	if (oneTouch) then
		oneTouch:clearTouchStat()
	end
end
-- zhangqi, 2014-09-17, 文本输入框通用事件处理
-- 清理一下当前弹出层的触摸状态，解决点击按钮同时点击editbox再放开导致的所有按钮无响应问题
local function editboxCommonHandler(eventType, sender)
	if eventType == "began" then
		local x,y = sender:getPosition()
		sender:setPosition(ccp(x,y))
		-- triggered when an edit box gains focus after keyboard is shown
	elseif eventType == "ended" then
	-- triggered when an edit box loses focus after keyboard is hidden.
	elseif eventType == "changed" then
	-- triggered when the edit box text was changed.
	elseif eventType == "return" then
		-- triggered when the return button was pressed or the outside area of keyboard was touched.
		logger:debug("return, text = %s", sender:getText())
		clearTouchStat()
	end
end
-- 文本框,boxSize:文本框尺寸,boxBg:文本框背景,cellWrap:是否换行，换行为true,verAlignment:垂直布局参数
function createEditBox(boxSize,boxBg,cellWrap,verAlignment, eventHandler)
	local img=CCScale9Sprite:create(boxBg or "images/base/potential/input_name_bg1.png")
	-- img:setOpacity(0)
	local msg_input = CCEditBox:create(boxSize, img)
	msg_input:setInputFlag(kEditBoxInputFlagInitialCapsWord)

	local touchPriority = g_tbTouchPriority.editbox
	local popLayer = LayerManager.getCurrentPopLayer()
	if (popLayer) then
		local tp = popLayer:getTouchPriority()
		-- 如果当前弹出层优先级为0，表示还没有创建弹出层，第一个弹出层优先级必为-1，所以文本框应该为-2
		touchPriority = tp == 0 and -2 or (tp - 1)
	end
	msg_input:setTouchPriority(touchPriority)
	if (not eventHandler) then
		msg_input:registerScriptEditBoxHandler(editboxCommonHandler)
	end

	-- menghao 统一字体和字号
	msg_input:setFont(g_FontInfo.name, g_FontInfo.size)
	msg_input:setPlaceholderFont(g_FontInfo.name, g_FontInfo.size)

	-- 单行输入多行显示
	if(msg_input:getChildByTag(1001))then
		local labelTTF = tolua.cast(msg_input:getChildByTag(1001),"CCLabelTTF")
		labelTTF:setHorizontalAlignment(kCCTextAlignmentLeft)
		if (cellWrap) then
			labelTTF:setDimensions(boxSize)
		end
		if (verAlignment) then
			labelTTF:setVerticalAlignment(verAlignment)
		else
			labelTTF:setVerticalAlignment(kCCVerticalTextAlignmentTop)
		end
	end
	return msg_input
end

--[[desc: 创建一个文本输入框, zhangqi, 2014-11-04
    tbArgs: {size, bg, cellWrap, verAlignment, eventHandler, 
				content, holder, holderColor = ccc3(), maxLen = 20,
				FontName, FontSize, FontColor = ccc3(),
				RetrunType, InputFlag, InputMode}
			size,bg, cellWrap, verAlignment, eventHandler 同createEditBox
			content: 文本框要显示的文字内容；holder:文本框默认显示文字；holderColor:默认文字的颜色，ccc3格式；maxLen:最大长度
			RetrunType:回车类型；InputFlag, InputMode, 文本框类型和限制，详见CCEditBox.h定义
    return: 创建好的CCEditBox对象
—]]
function createEditBoxNew(tbArgs)
	local eb = createEditBox(tbArgs.size, tbArgs.bg, tbArgs.cellWrap, tbArgs.verAlignment, tbArgs.eventHandler)
	if (tbArgs.holder) then
		eb:setPlaceHolder(tbArgs.holder)
	end
	if (tbArgs.holderColor) then
		eb:setPlaceholderFontColor(tbArgs.holderColor)
	end
	if (tbArgs.maxLen) then
		eb:setMaxLength(tbArgs.maxLen)
	end

	if (tbArgs.RetrunType) then
		eb:setReturnType(tbArgs.RetrunType)
	end

	if (tbArgs.InputFlag) then
		eb:setInputFlag(tbArgs.InputFlag)
	end

	if (tbArgs.InputMode) then
		eb:setInputMode(tbArgs.InputMode)
	end
	if (tbArgs.content) then
		eb:setText(tbArgs.content)
	end
	if (tbArgs.FontName) then
		eb:setFontName(tbArgs.FontName)
	end
	if (tbArgs.FontSize) then
		eb:setFontSize(tbArgs.FontSize)
	end
	if (tbArgs.FontColor) then
		eb:setFontColor(tbArgs.FontColor)
	end
	return eb
end

function bindEventToEditBox( tbArgs )
	local function editboxEventHandler(eventType, sender)
		if eventType == "began" then
			local x,y = sender:getPosition()
			sender:setPosition(ccp(x,y))
			-- triggered when an edit box gains focus after keyboard is shown
			logger:debug("began, text = " .. sender:getText())
			if (tbArgs.onBegan and type(tbArgs.onBegan) == "function") then
				tbArgs.onBegan(sender:getText())
			end
		elseif eventType == "ended" then
			-- triggered when an edit box loses focus after keyboard is hidden.
			logger:debug("ended, text = " .. sender:getText())
			if (tbArgs.onEnded and type(tbArgs.onEnded) == "function") then
				tbArgs.onEnded(sender:getText())
			end
		elseif eventType == "changed" then
			-- triggered when the edit box text was changed.
			logger:debug("changed, text = " .. sender:getText())
			if (tbArgs.onChanged and type(tbArgs.onChanged) == "function") then
				tbArgs.onChanged(sender:getText())
			end
		elseif eventType == "return" then
			-- triggered when the return button was pressed or the outside area of keyboard was touched.
			logger:debug("return, text = " .. sender:getText())
			if (tbArgs.onReturn and type(tbArgs.onReturn) == "function") then
				tbArgs.onReturn(sender:getText())
			end
			clearTouchStat()
		end
	end
	tbArgs.inputBox:registerScriptEditBoxHandler(editboxEventHandler)
end

-- zhangqi, 创建一个 EidtBox 并附加到参数指定的背景上，并返回EidtBox对象
-- tbArgs = {layRoot = layout, bgName = "", sHolder = "", holderColor = ccc3(), maxLen = 20, contentText = "",
--			  FontName = "", FontSize = 22, FontColor = ccc3(),
--			  event = {onBegan = function, onEnded = function, onChanged = function, onReturn = function}
--		 	 }
function addEditBoxWithBackgroud( tbArgs )
	local imgBg = m_fnGetWidget(tbArgs.layRoot, tbArgs.bgName)
	local bgSize = imgBg:getSize()
	local tbEbCfg = { size = CCSizeMake(bgSize.width, bgSize.height), bg = m_ebBg,
		content = tbArgs.contentText, holder = tbArgs.sHolder,
		holderColor = tbArgs.holderColor or m_ebHolderColor, FontColor = tbArgs.FontColor or m_ebHolderColor, 
		maxLen = tbArgs.maxLen or 20,
		RetrunType = kKeyboardReturnTypeDone, InputMode = kEditBoxInputModeSingleLine,
	}
	local editbox = UIHelper.createEditBoxNew(tbEbCfg)
	editbox:setInputFlag(kEditBoxInputFlagSensitive)
	imgBg:addNode(editbox)

	local ebArgs = {inputBox = editbox, event = tbArgs.event}
	bindEventToEditBox(ebArgs)

	return editbox
end


-- add by huxiaozhou 2014-06-09
--创建一个吃touch的半透明layer
--priority : touch 权限级别,默认为-1024  还会修改的
--touchRect: 在touchRect 区域会放行touch事件 若touchRect = nil 则全屏吃touch
--touchCallback: 屏蔽层touch 回调
function createMaskLayer( priority,touchRect ,touchCallback, layerOpacity,highRect, maskRect)
	local layer = CCLayer:create()
	layer:setPosition(ccp(0, 0))
	layer:setAnchorPoint(ccp(0, 0))
	layer:setTouchEnabled(true)
	layer:setTouchPriority(priority or -1024)
	layer:registerScriptTouchHandler(function ( eventType,x,y )
		if(eventType == "began") then
			if(touchRect == nil) then
				if(touchCallback ~= nil) then
					touchCallback()
				end
				return true
			else
				if(touchRect:containsPoint(ccp(x,y))) then
					if(touchCallback ~= nil) then
						touchCallback()
					end
					return false
				else
					if(touchCallback ~= nil) then
						touchCallback()
					end
					return true
				end
			end
		end
	end,false, priority or -1024, true)

	local gw,gh = g_winSize.width, g_winSize.height
	if(touchRect == nil) then
		local layerColor = CCLayerColor:create(ccc4(0,0,0,0),gw,gh)
		layerColor:setAnchorPoint(ccp(0,0))
		layer:addChild(layerColor)
		return layer
	else

		local maskRectTemp = maskRect or touchRect

		local ox,oy,ow,oh = maskRectTemp.origin.x, maskRectTemp.origin.y, maskRectTemp.size.width, maskRectTemp.size.height
		require "script/module/public/EffectHelper"
		local guideEff = EffGuide:new()
		guideEff:Armature():setPosition(ccp(ox+ow/2, oy+oh/2))
		logger:debug("ox+ow/2 = " .. ox+ow/2)

		logger:debug("oy+oh/2 = " .. oy+oh/2)

		local rotation = 0
		if oy+oh/2 < 150 and  g_winSize.width - (ox+ow/2) < 150 then
			rotation = 180
		else
			if oy+oh/2 < 150 then
				rotation = -100
			end

			if g_winSize.width - (ox+ow/2) < 150 then
				rotation = 80
			end
		end
		guideEff:Armature():setRotation(rotation)

		layer:addChild(guideEff:Armature(),9999)


		-- -- 添加编辑器做得蒙版
		-- local jsonMask = "ui/new_mask.json"
		-- local layoutMask = g_fnLoadUI(jsonMask)
		-- layoutMask:setSize(g_winSize)
		-- layer:addChild(layoutMask, -1)
		-- layoutMask:setPosition(ccp(ox+ow/2, oy+oh/2))

		-- local layerColor = CCLayerColor:create(ccc4(0, 0, 0, layerOpacity or 150 ), gw, gh)
		local layerColor = CCLayerColor:create(ccc4(0,0,0,0),gw,gh)
		local clipNode = CCClippingNode:create();
		clipNode:setInverted(true)
		clipNode:addChild(layerColor)

		local stencilNode = CCNode:create()
		-- stencilNode:retain()

		local node = CCScale9Sprite:create("images/common/rect.png")
		node:setContentSize(CCSizeMake(ow, oh))
		node:setAnchorPoint(ccp(0, 0))
		node:setPosition(ccp(ox, oy))
		stencilNode:addChild(node)

		if(highRect ~= nil) then
			local highNode = CCScale9Sprite:create("images/common/rect.png")
			highNode:setContentSize(CCSizeMake(highRect.size.width, highRect.size.height))
			highNode:setAnchorPoint(ccp(0, 0))
			highNode:setPosition(ccp(highRect.origin.x, highRect.origin.y))
			stencilNode:addChild(highNode)
		end

		clipNode:setStencil(stencilNode)
		clipNode:setAlphaThreshold(0.5)
		layer:addChild(clipNode)
	end
	return layer
end

--[[desc: zhangqi, 20140624, 返回一个注册到全局Scheduler的schedulId
    node: CCNode, onExit事件时会 unschedule 已注册的全局 schedulId，确保schedule事件随UI界面关闭而被注销
    fnCallback: schedule 的回调方法
    nInterval: schedule 的间隔，单位秒。If 'interval' is 0, it will be called every frame，默认是1秒
    bPaused: If bPaused is true, then it won't be called until it is resumed, 默认是 false
    return: number
—]]
function getAutoReleaseScheduler( node, fnCallback, nInterval, bPaused )
	local scID = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(fnCallback, nInterval or 1, false)
	logger:debug("scID = %d", scID)
	
	-- node:registerScriptHandler(function ( eventType,node )
	-- 	if(eventType == "exit") then
	-- 		logger:debug("getAutoReleaseScheduler onExit")
	-- 		if(scID ~= nil)then
	-- 			CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(scID)
	-- 			logger:debug("getAutoReleaseScheduler unschedule ok")
	-- 			scID = nil
	-- 		end
	-- 	end
	-- end)
	--liweidong 改成UIHelper调用
	registExitAndEnterCall(node,function()
			logger:debug("getAutoReleaseScheduler onExit")
			if(scID ~= nil)then
				CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(scID)
				logger:debug("getAutoReleaseScheduler unschedule ok")
				scID = nil
			end
		end)

	return scID
end

-- 绑定一个回调方法到指定node的onExit事件，可以做一些模块全局变量的重置清理工作
-- 避免UI删除后引用并没有真正置为nil, 其他模块仍然在调用刷新UI方法导致找不到引用的错误
function addCallbackOnExit( node, fnCallback )
	if (node) then
		-- node:registerScriptHandler(function ( eventType,node )
		-- 	if(eventType == "exit") then
		-- 		logger:debug("addCallbackOnExit onExit")
		-- 		if (fnCallback) then
		-- 			fnCallback()
		-- 		end
		-- 	end
		-- end)
		--liweidong 改成UIHelper调用
		registExitAndEnterCall(node,function()
			logger:debug("addCallbackOnExit onExit")
			if (fnCallback) then
				fnCallback()
			end
		end)
	end
end

--[[desc:返回一个用|或者不可见的字符 分割的 富文本字符串
    arg1: tbData,:由不同的字符串组成的表；
    	  bState:是否需要用不可见字符分割，默认为nil
    return: 返回富文本所需要的字符串
—]]

function concatString( tbData ,bState)
	if(bState) then
		local str = table.concat(tbData, string.char(17))
		return str
	else
		local str = table.concat(tbData, "|")
		logger:debug(str)
		return str
	end
	return ""
end


--[[
menghao
创建一个渐隐渐现的CCLabelAtlas

可用参数：
-	str1 		原先的字符串值
-	str2 		
-	nInTime 	淡入时间
-	nOutTime 	淡出时间

@return  CCLabelAtlas对象

zhangqi, 2015-11-30, 没有被调用暂时注释，数字标签图片置为空字符串
--]]
-- function createfadeIOLabelAtlas( str1, str2, nInTime, nOutTime)
-- 	local labelAtlas = CCLabelAtlas:create(str1, "", 27, 28, 48)
-- 	local nTime = 1

-- 	local actionArr = CCArray:create()
-- 	actionArr:addObject(CCFadeIn:create(nInTime or 0.8))
-- 	actionArr:addObject(CCFadeOut:create(nOutTime or 0.8))
-- 	actionArr:addObject(CCCallFunc:create(function ( ... )
-- 		if nTime == 1 then
-- 			labelAtlas:setString(str2)
-- 			nTime = 0
-- 		else
-- 			labelAtlas:setString(str1)
-- 			nTime = 1
-- 		end
-- 	end))

-- 	labelAtlas:runAction(CCRepeatForever:create(CCSequence:create(actionArr)))
-- 	return labelAtlas
-- end


--[[--
menghao 20150122
创建一个渐隐渐现的label对象并返回，可以通过addNode加到widget上

@param table params 参数表格对象
text1 为必须传的字段
如果传text2则为两个不同 字符串 切换渐隐渐现
如果要描边，strokeColor必须传
其他参数都有默认值

@return  LabelFT对象

示例
label = UIHelper.createBlinkLabel({
	fontName = "", fontSize = 18, strokeColor = ccc3(32,0,0), strokeSize = 2,
	text1 = curPercent .. "%", color1 = ccc3(255,255,0),
	text2 = "100%", color2 = ccc3(255,255,0)
}, 1, 1)
]]
function createBlinkLabel(tbInfo, nInTime, nOutTime)
	local blinkLabel = LabelFT:create(tbInfo.text1, tbInfo.fontName or g_sFontName, tbInfo.fontSize or 20)
	blinkLabel:setColor(tbInfo.color1 or ccc3(255,255,255))
	if (tbInfo.strokeColor) then
		blinkLabel:enableStroke(tbInfo.strokeColor, tbInfo.strokeSize or 2)
	end
	local nFlag = 1

	local actionArr = CCArray:create()
	actionArr:addObject(CCFadeIn:create(nInTime or 1))
	actionArr:addObject(CCFadeOut:create(nOutTime or 1))
	if (tbInfo.text2) then
		actionArr:addObject(CCCallFunc:create(function ( ... )
			if nFlag == 1 then
				blinkLabel:setString(tbInfo.text2)
				blinkLabel:setColor(tbInfo.color2 or ccc3(255,255,255))
				nFlag = 2
			else
				blinkLabel:setString(tbInfo.text1)
				blinkLabel:setColor(tbInfo.color1 or ccc3(255,255,255))
				nFlag = 1
			end
		end))
	end

	blinkLabel:runAction(CCRepeatForever:create(CCSequence:create(actionArr)))
	return blinkLabel
end


-- widget 灰度化 子控件也会变灰
--参数：
--	widget 		控件对象
-- 	bGray 		true or false
function setWidgetGray( widget , bGray)
	widget:setGray(bGray)
	local tbChildren = getTbChildren(widget)
	for _,v in ipairs(tbChildren or {}) do
		--logger:debug(tolua.type(v))
			v:setGray(bGray)
	end
end



--[[--
menghao
获取一个widget所有的子控件（不包括node类型）组成的table

参数：
-	widget 		控件对象

@return 	table
]]
function getTbChildren( widget )
	tolua.cast(widget, "Widget")
	local tbChildren = {}

	local arrChildren = widget:getChildren()
	for i=1,widget:getChildrenCount() do
		local widgetChild = arrChildren:objectAtIndex(i - 1)
		table.insert(tbChildren, widgetChild)
		for k, v in pairs(getTbChildren(widgetChild)) do
			table.insert(tbChildren, v)
		end
	end

	g_fnCastWidget(widget)

	return tbChildren
end



--[[--
menghao
让widget和其所有的子控件（不包括node类型）执行渐变透明度动作

参数：
-	widget 		控件对象
-	nInterval 	执行动作的时间
-	opacity 	目标透明度

@return

modified by huxiaozhou 
if (call)
to
if (call and widget == v)

]]
function widgetFadeTo( widget, nInterval, opacity, call )
	local tb = getTbChildren(widget)
	table.insert(tb, widget)

	for k, v in pairs(tb) do
		local actionArr = CCArray:create()
		actionArr:addObject(CCFadeTo:create(nInterval, opacity))
		if (call and widget == v) then
			actionArr:addObject(CCCallFunc:create(call))
			call = nil
		end
		local render = v:getVirtualRenderer()
		if render then
			local sp = tolua.cast(render, "CCSprite")
			sp:runAction(CCSequence:create(actionArr))
		end
	end
end


--[[--
menghao
让widget和其所有的子控件（不包括node类型）执行渐隐渐现

@param table params 参数表格对象
参数：
-	widget 			控件对象
-	nIntervalIn 	in的时间
-	nIntervalOut 	out的时间
- 	callAfterIn 	in之后回调
- 	callAfterOut 	out之后回调

参数示例
local tbArgs = {
	widget = hahaha,
	nIntervalIn = 1,
	nIntervalOut = 1,
	callAfterIn = function() end,
	callAfterOut = function() end,
}

@return
]]
function widgetFadeInOut( tbArgs )
	local tb = getTbChildren(tbArgs.widget)
	table.insert(tb, tbArgs.widget)

	for k, v in pairs(tb) do
		local actionArr = CCArray:create()
		actionArr:addObject(CCFadeTo:create(tbArgs.nIntervalIn or 1, 255))
		if (tbArgs.callAfterIn) then
			actionArr:addObject(CCCallFunc:create(tbArgs.callAfterIn))
			tbArgs.callAfterIn = nil
		end
		actionArr:addObject(CCFadeTo:create(tbArgs.nIntervalOut or 1, 0))
		if (tbArgs.callAfterOut) then
			actionArr:addObject(CCCallFunc:create(tbArgs.callAfterOut))
			tbArgs.callAfterOut = nil
		end
		local render = v:getVirtualRenderer()
		if render then
			local sp = tolua.cast(render, "CCSprite")
			sp:runAction(CCRepeatForever:create(CCSequence:create(actionArr)))
		end

	end
end


-- 获取一个控件和其子控件上的所有以addNodes方式添加的节点（非UI控件）
function getTbNodes( widget )
	local tbNode = {}

	local function getNodes( node )
		local array = node:getNodes()
		for i=1,array:count() do
			table.insert(tbNode,array:objectAtIndex(i-1))

		end
	end

	getNodes(widget)

	local tbChildren = getTbChildren(widget)
	for k,v in pairs(tbChildren) do
		getNodes(v)
	end
	logger:debug(tbNode)

	return tbNode
end


--add by yangna
-- 一组节点执行延时和CCFadeTo动作
-- tbnode:table
-- type 节点类型：1 widget控件 2 非widget控件
-- delaytime  延时时间
-- fadetime  执行CCFadeTo的时间
-- oirginaOpa起始透明度
-- finalOpa结束透明度
-- callfunc回调方法，可为nil
function nodeFadeTo( tbnode,type,delaytime,fadetime,oirginaOpa,finalOpa,callfunc)
	for k,v in pairs(tbnode) do
		v:setOpacity(oirginaOpa)
		local array = CCArray:create()
		array:addObject(CCDelayTime:create(delaytime))   --1-4
		array:addObject(CCFadeTo:create(fadetime,finalOpa))   --5-17
		if(callfunc)then
			array:addObject(CCCallFuncN:create(function ( ... )
				callfunc()
			end))
		end
		local seq = CCSequence:create(array)
		if(tonumber(type)==1)then
			local imgRender = v:getVirtualRenderer()
			if imgRender then
				imgRender:runAction(seq)
			end
		end
		if( tonumber(type)==2)then
			v:runAction(seq)
		end
	end
end


-- add by lizy 2014-07-14
--创建一个CCLabelTTF,可实现渐入渐出
--firstText : 要显示的文字 ，变换前
--secondText 要显示的文字 ，变换后
--fontSize    字体大小
--c3FirstText  firstText 字体颜色
--c3SecondText	secondText 字体颜色
--fadeInTime: 变没得效果时间
--fadeOutTime: 出现的时间
--渐变的停止时间
function fadeInAndOut( strFirstText ,strSecondText,nFontSize,c3FirstText,c3SecondText,nFadeInTime,nFadeOutTime,nDelay)
	local   nTime = 1
	local   sprite  =  CCLabelTTF:create(strFirstText ,g_sFontCuYuan,nFontSize or 22)
	local   fuCallfunc = function ( ... )
		if (nTime == 1) then
			-- sprite:setColor(ccc3(255,0,0))
			sprite:setColor( c3SecondText or ccc3(26,134,5))
			sprite:setString(strSecondText)
			nTime = 0
		else
			nTime = 1
			sprite:setString(strFirstText)
			--sprite:setColor(ccc3(0,0,0))
			sprite:setColor( c3FirstText or ccc3(255,255,255))
		end
	end

	local   blinkArray = CCArray:create()
	blinkArray:addObject(CCFadeIn:create(nFadeInTime or 0.8))
	blinkArray:addObject(CCFadeOut:create(nFadeOutTime or 0.8))

	--   blinkArray:addObject(CCDelayTime:create(nDelay or 0.5))
	if (strSecondText ~= nil) then
		blinkArray:addObject(CCCallFunc:create(fuCallfunc))
	end


	local   actionIn = CCSequence:create(blinkArray)
	sprite:runAction(CCRepeatForever:create(actionIn))
	return  sprite
end

-- add by lizy 2014-07-14
-- 创建一个CCSprite的t图片,可实现渐入渐出
--imagePath:  sprite上显示的图片
--fadeInTime: 变没得效果时间
--fadeOutTime: 出现的时间
--渐变的停止时间
function fadeInAndOutImage(imagePath ,fadeInTime,fadeOutTime,delay,notNeddScale)
	local sprite  =  CCSprite:create(imagePath)
	local blinkArray = CCArray:create()
	blinkArray:addObject(CCFadeIn:create(fadeInTime or 0.8))
	blinkArray:addObject(CCFadeOut:create(fadeOutTime or 0.8))
	blinkArray:addObject(CCDelayTime:create(delay or 0))
	local actionIn = CCSequence:create(blinkArray)
	if(not notNeddScale) then
		sprite:setScale(0.85)
	end
	sprite:runAction(CCRepeatForever:create(actionIn))

	return  sprite
end

-- add by lizy 2014-07-14
-- 创建一个CCSprite的进度条,可实现渐入渐出
--nGreenBarWidth:  需要闪烁的进度条的值 范围 0 - 100
--fadeInTime: 变没得效果时间
--fadeOutTime: 出现的时间
--渐变的停止时间
function fadeInAndOutBar(nGreenBarWidth,fadeInTime,fadeOutTime,delay , imageFile)
	local  nMaxWidth = 120

	-- local insetRect = CCRectMake(20, 8, 5, 1)
	local  preferredSize = CCSizeMake(nMaxWidth, 10)

	if  (nGreenBarWidth > nMaxWidth) then
		nGreenBarWidth = nMaxWidth
	end

	local pImage = imageFile or "images/common/short_progress_green.png"

	local  progressSprite = CCSprite:create(pImage)

	local  progress1=CCProgressTimer:create(progressSprite)

	progress1:setType(kCCProgressTimerTypeBar)

	progress1:setMidpoint(ccp(0, 0))

	progress1:setBarChangeRate(ccp(1, 0))

	progress1:setPercentage(nGreenBarWidth)


	local   arrActions = CCArray:create()
	local   fadeIn = CCFadeIn:create( fadeInTime or 0.8)
	local   fadeOut = CCFadeOut:create(fadeOutTime or 0.8)

	arrActions:addObject(fadeIn)
	arrActions:addObject(fadeOut)

	--arrActions:addObject(CCDelayTime:create(delay or 0))
	local   sequence = CCSequence:create(arrActions)
	local   action = CCRepeatForever:create(sequence)
	--progress1:setScale(1.1);
	progress1:runAction(action)
	-- progress1:setPosition(ccp(nPos,0))
	return  progress1
end
--渐入渐出node liweidong
function fadeInAndOutUI(node,fadeInTime,fadeOutTime,delay)
	local   arrActions = CCArray:create()
	local   fadeIn = CCFadeIn:create( fadeInTime or 0.8)
	local   fadeOut = CCFadeOut:create(fadeOutTime or 0.8)

	arrActions:addObject(fadeIn)
	arrActions:addObject(fadeOut)
	arrActions:addObject(CCDelayTime:create(delay or 0.01))

	local   sequence = CCSequence:create(arrActions)
	local   action = CCRepeatForever:create(sequence)
	node:runAction(action)
end
--  背包cell 出来效果
-- add by huxiaozhou
-- modified by huxiaozhou Tuesday,January 27 2015
-- _cell： 要播放 action 的 cell
-- animatedIndex: 第几个cell
-- fnCallback: 播放完成一个cell的action 后的回调
-- posType 坐标类型 0 绝对坐标， 1 百分比坐标
function startCellAnimation( _cell, animatedIndex ,fnCallback, posType)
	if (_cell == nil) then
		return
	end

	local layCell = _cell
	local posType = posType or 0
	if posType == 0 then
		layCell:setPosition(ccp(layCell:getSize().width, 0))
	else
		layCell:setPositionPercent(ccp(1, 0))
	end
	local scene = CCDirector:sharedDirector():getRunningScene()
	performWithDelay(scene, function(...)
				-- local delay = CCDelayTime:create(0.01)
				local moveto = CCMoveTo:create(g_cellAnimateDuration * (animatedIndex), ccp(0,0))
				local func = CCCallFunc:create(fnCallback)
				local actionArray = CCArray:create()
				-- actionArray:addObject(delay)
				actionArray:addObject(moveto)
				actionArray:addObject(func)
				local seq = CCSequence:create(actionArray)

				layCell:runAction(seq)
			end,0)
end


-- layout 弹出通用action 效果
function layOutScaleAction( tParams )
		-- 放大提示框scale==nil或false显示放大效果
	local oriagelayout = tParams.wigLayout
	local scalelayout=Layout:create()
	scalelayout:setSize(g_winSize)
	scalelayout:setAnchorPoint(ccp(0.5,0.5))
	scalelayout:setPositionType(POSITION_ABSOLUTE)
	scalelayout:setPosition(ccp(g_winSize.width/2,g_winSize.height/2))
	scalelayout:setScale(0.5)
	scalelayout:addChild(oriagelayout)

	local array = CCArray:create()
	local wait1=CCDelayTime:create(0.01)
	local scale1 = CCScaleTo:create(0.08,1.2)
	local fade = CCFadeIn:create(0.06)
	local spawn = CCSpawn:createWithTwoActions(scale1,fade)
	local scale2 = CCScaleTo:create(0.07,0.9)
	local scale3 = CCScaleTo:create(0.07,1)
	array:addObject(wait1)
	array:addObject(scale1)
	array:addObject(scale2)
	array:addObject(scale3)
	local seq = CCSequence:create(array)
	scalelayout:runAction(seq)

	tParams.wigLayout=Layout:create()
	tParams.wigLayout:setSize(g_winSize)
	tParams.wigLayout:addChild(scalelayout)
end

-- Widget 设置透明度
--[[
	tParams = {
		action = 是否有action 没有action 直接设置 opcitity
		nInterval = 渐变时间
		opacity = 要设置的透明度
		call =  执行玩action 后得回调
	}
]]
function widgetSetOpcitity(tParams)
	local tb = getTbChildren(tParams.widget)
	table.insert(tb, tParams.widget)

	for k, v in pairs(tb) do
		if tolua.type(v) ~= "Widget" then
			local render = v:getVirtualRenderer()
			if tParams.action and render then
				local actionArr = CCArray:create()
				actionArr:addObject(CCFadeTo:create(tParams.nInterval, tParams.opacity))
				if (tParams.call) then
					actionArr:addObject(CCCallFunc:create(tParams.call))
					tParams.call = nil
				end
				sp = tolua.cast(render, "CCSprite")
				sp:runAction(CCSequence:create(actionArr))
			else
				if render then
			 		local sp  = tolua.cast(render, "CCSprite")
			 		sp:setOpacity(tParams.opacity)
				end
			end
		end
	end
end


--[[	
	点击商店  弹出 二级菜单

	第1 帧   位置-66、273    比例 9:9       透明度 50 度

	第3 帧   位置-66、273    比例 9:9       透明度 67 度

	第12 帧  位置 0、0       比例 100:100   透明度 100 度
	
--]]

function openAnimation(tParams)
	local oriagelayout = tParams.wigLayout
	local scalelayout=Layout:create()
	scalelayout:setSize(g_winSize)
	scalelayout:setAnchorPoint(ccp(0.5,0.5))
	scalelayout:setPositionType(POSITION_ABSOLUTE)
	scalelayout:addChild(oriagelayout)
	if tParams.startPos then
		scalelayout:setPosition(tParams.startPos)
		scalelayout:setScale(0.09)
		
		local endPos = ccp(g_winSize.width/2,g_winSize.height/2)
		logger:debug("tParams.startPos.x = %s tParams.startPos.y = %s", tParams.startPos.x, tParams.startPos.y)
		widgetSetOpcitity({widget = scalelayout, opacity = 0}) 
		
		widgetSetOpcitity({widget = scalelayout, action = true, opacity = 255*0.5, nInterval = 1/60, call = function (  )
			widgetSetOpcitity({widget = scalelayout, action = true, opacity = 255*0.67, nInterval = 2/60, call = function (  )
				local array = CCArray:create()
				local scale = CCScaleTo:create(9/60, 1.0)
				local moveTo = CCMoveTo:create(9/60, endPos)
				local spawn = CCSpawn:createWithTwoActions(scale,moveTo)
				scalelayout:runAction(spawn)
				widgetSetOpcitity({widget = scalelayout, action = true, opacity = 255, nInterval = 9/60, call = function( ) 
					end})
			end})
		end})
	else
		scalelayout:setPosition(ccp(g_winSize.width/2,g_winSize.height/2))
	end


	tParams.wigLayout=Layout:create()
	tParams.wigLayout:setSize(g_winSize)
	tParams.wigLayout:addChild(scalelayout, 0, 1)
end


--[[
	再点击商店  收回  二级菜单

	第1 帧   位置0、0        比例 100:100       透明度 100 度

	第3 帧   位置0、0        比例 105:105      透明度 100 度

	第12 帧  位置-66、273    比例 9:9           透明度 0 度
--]]
function closeAnimation(tParams)

	local popLayout = tParams.widget:getWidgetByTag(666666)
	local widget = popLayout:getChildByTag(1)
	widgetSetOpcitity({widget = widget, action = true, opacity = 255, nInterval = 1/60, call = function (  )
		local scale = CCScaleTo:create(2/60, 1.05)
		widgetSetOpcitity({widget = widget, action = true, opacity = 255, nInterval = 2/60, call = function (  )
			local array = CCArray:create()
			local scale = CCScaleTo:create(9/60, 0.05)
			local moveTo = CCMoveTo:create(9/60, tParams.endPos)
			local spawn = CCSpawn:createWithTwoActions(scale,moveTo)
			widget:runAction(spawn)
			widgetSetOpcitity({widget = widget, action = true, opacity = 255*0.5, nInterval = 9/60, call = tParams.callback})
		end})
	end})
end


--[[
menghao
创建一个button对象并返回，用于创建奖励物品的图标
如果是物品和英雄会有点击事件

参数：
-	reward_type 		奖励类型
-	reward_values		奖励相关数值（表里字段直接传进来）

return button对象
]]
-- 奖励类型 1、贝里,2、将魂,3、金币,4、体力,5、耐力,6、物品,7、多个物品,8、等级*贝里,9、等级*将魂
-- zhangqi, 2015-04-25, 增加海魂类型的处理，将类型判断改为table索引；另外给其他类型加上参数判断
local fnIcon = {}
fnIcon[1] = ItemUtil.getSiliverIconByNum
fnIcon[3] = ItemUtil.getGoldIconByNum
fnIcon[11] = ItemUtil.getJewelIconByNum
function getItemIcon(reward_type, reward_values)
	reward_type = tonumber(reward_type)
	local itemIcon

	local fnCreate = fnIcon[reward_type]
	if (fnCreate) then
		itemIcon = fnCreate(reward_values)
	else
		local values = string.split(reward_values, "|")

		local tid = values[1]
		local num = values[2]
	    -- add by sunyunpeng  英雄类型13  2016。1.11
		if (tonumber(reward_type) == 13) then
			itemIcon = ItemUtil.getHeroIcon(tid,function (  sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					require "script/module/partner/PartnerInfoCtrl"
		        local tbherosInfo = {}
		        local heroInfo = {htid = tid ,hid = 0,strengthenLevel = 0 ,transLevel = 0,showOnly = true }
		        local tArgs = {}
		        tArgs.heroInfo = heroInfo
		        local layer = PartnerInfoCtrl.create(tArgs,4)     --所选择武将信息22
		        LayerManager.addLayoutNoScale(layer)
				end
			end)
		else
			itemIcon = ItemUtil.createBtnByTemplateIdAndNumber(tid, num, function ( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					require "script/module/public/PublicInfoCtrl"
					PublicInfoCtrl.createItemInfoViewByTid(tid, num)
				end
			end)
		end
	end

	return itemIcon
end

-- menghao 同上，增加获取icon的同时更新数据（金币银币之类）
function getItemIconAndUpdate(reward_type, reward_values)
	reward_type = tonumber(reward_type)
	local itemIcon
	if(reward_type == 1) then
		itemIcon = ItemUtil.getSiliverIconByNum(reward_values)
		UserModel.addSilverNumber(tonumber(reward_values))
		-- elseif(reward_type == 2) then -- zhangqi, 2015-01-09, 已经去经验石，此判断暂无意义
		-- 	itemIcon = ItemUtil.getSoulIconByNum(reward_values)
		-- 	UserModel.addSoulNum(tonumber(reward_values))
	elseif(reward_type == 3) then
		itemIcon = ItemUtil.getGoldIconByNum(reward_values)
		UserModel.addGoldNumber(tonumber(reward_values))
		-- elseif(reward_type == 10) then -- zhangqi, 2015-01-09, 已经去经验石，此判断暂无意义
		-- 	itemIcon = HeroUtil.createHeroIconBtnByHtid(reward_values, nil, function ( sender, eventType )
		-- 		if (eventType == TOUCH_EVENT_ENDED) then
		-- 			AudioHelper.playInfoEffect()
		-- 			PublicInfoCtrl.createHeroInfoView(reward_values)
		-- 		end
		-- 	end)
	-- add by sunyunpeng  英雄类型13  2016。1.11
	elseif(reward_type == 13) then
		local tid = (string.split(reward_values, "|"))[1]
		local hid = HeroModel.getHidByHtid(tonumber(tid))
		if (tonumber(hid) == 0) then
			itemIcon = ItemUtil.getHeroIcon(tid,function ( sender, eventType  )
				if (eventType == TOUCH_EVENT_ENDED) then
					require "script/module/partner/PartnerInfoCtrl"
			        local tbherosInfo = {}
			        local heroInfo = {htid = tid ,hid = 0,strengthenLevel = 0 ,transLevel = 0,showOnly = true }
			        local tArgs = {}
			        tArgs.heroInfo = heroInfo
			        local layer = PartnerInfoCtrl.create(tArgs,4)     --所选择武将信息22
			        LayerManager.addLayoutNoScale(layer)
			     end
			end)
		else  -- 如果英雄已经拥有，怎转化成碎片
			local HeroDB = DB_Heroes.getDataById(tid)
			tid = HeroDB.fragment
			local HeroFragDB = DB_Item_hero_fragment.getDataById(tid)
			local num = HeroFragDB.need_part_num
			itemIcon = ItemUtil.createBtnByTemplateIdAndNumber(tid, num, function ( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					AudioHelper.playInfoEffect()
					PublicInfoCtrl.createItemInfoViewByTid(tid, num)
				end
			end)
		end
	else
		local tid = (string.split(reward_values, "|"))[1]
		local num = (string.split(reward_values, "|"))[2]
		itemIcon = ItemUtil.createBtnByTemplateIdAndNumber(tid, num, function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playInfoEffect()
				PublicInfoCtrl.createItemInfoViewByTid(tid, num)
			end
		end)
	end

	return itemIcon
end

-- 玩家名字的颜色 -- 常用较qian的配色
function getHeroNameColor1By( utid )
	local name_color = nil
	local stroke_color = nil
	if(tonumber(utid) == 1)then
		-- 女性玩家
		name_color = ccc3(0xf9,0x59,0xff)
		stroke_color = ccc3(0x00,0x00,0x00)
	elseif(tonumber(utid) == 2)then
		-- 男性玩家
		name_color = ccc3(0x00,0xe4,0xff)
		stroke_color = ccc3(0x00,0x00,0x00)
	end
	return name_color, stroke_color
end

-- 玩家名字的颜色 -- 常用较暗的配色
function getHeroNameColor2By( utid )
	local name_color = nil
	local stroke_color = nil
	if(tonumber(utid) == 1)then
		-- 女性玩家
		name_color = ccc3(0xa1,0x15,0xb6)
		stroke_color = ccc3(0x00,0x00,0x00)
	elseif(tonumber(utid) == 2)then
		-- 男性玩家
		name_color = ccc3(0x00,0x3d,0xc7)
		stroke_color = ccc3(0x00,0x00,0x00)
	end
	return name_color, stroke_color
end

--by wangming 20150206 对象播放呼吸特效 2秒标准，1.02倍缩放，
function fnPlayHuxiAni( pBody , pScale , pTime)
	if(not pBody) then
		return
	end
	local nScale = pBody:getScale()
	local m_time = pTime or 1
	local m_scale = pScale or (nScale+0.02)
	local arr = CCArray:create()
	arr:addObject(CCScaleTo:create(m_time, m_scale))
	arr:addObject(CCScaleTo:create(m_time, nScale))
	local pAction = CCRepeatForever:create(CCSequence:create(arr))
	pBody:runAction(pAction)
	return pAction
end

-- add by huxiaozhou 2015-02-06 对象播放 上下浮动动画 应用于装备、宝物 信息装备强化， etc
function runFloatAction( pTarget)
	if pTarget then
		local arrActions = CCArray:create()
		arrActions:addObject(CCMoveBy:create(1.5,ccp(0,20)))
		arrActions:addObject(CCMoveBy:create(1.5,ccp(0,-20)))
		local sequence = CCSequence:create(arrActions)
		local repeatSequence = CCRepeatForever:create(sequence)
		pTarget:runAction(repeatSequence)
	end
end

-- add by wangming 20150227 根据type类型返回宝物或空岛贝对应的类型图片路径
function fnGetConchTypeFilePath( pType )
	local pids = {8,8,6,6,4,1,3,7,7,5,5,5,5,0}
	local n = pids[tonumber(pType)] or 0
	logger:debug("wm----pids ： " .. pType .. n)
	local pString = "images/item/equipinfo/card/trea_type_" .. n .. ".png"
	return pString
end





--[[desc:获取主页面的主船id
    主船改造功能没开启之前，默认id＝ 1，开启之后进入游戏时，从服务器拉取的主船信息在DataCache中。根据DataCache中的数据读DB_Ship表。
    return: 主船id
—]]
function getHomeShipID()
	require "db/DB_Ship"
	local ship_figure = tonumber(UserModel.getShipFigure())
	if (ship_figure < 1) then
		ship_figure = 1
	end
	-- ship_figure字段其实是ship的id字段，利用ship模块的方法转换成ship的形象id
	require "script/module/ship/ShipData"
	return ShipData.getShipFigureIdByShipId(ship_figure)
end

-- 下面这个方法已经不用了
--[[desc:获取探索页面主船id
    主船改造功能没开启之前，默认id＝ 1，开启之后进入游戏时，从服务器拉取的主船信息在DataCache中。根据DataCache中的数据读DB_Ship表。
    return: 主船id
—]]
function getExploreShipID( ... )
	require "db/DB_Ship"
	local ship_figure =  tonumber(UserModel.getShipFigure())
	if (ship_figure < 1) then
		ship_figure = 1
	end
	local data = DB_Ship.getDataById(ship_figure)
	return data.explore_graph
end

--[[desc:添加船和浪花特效
    layout:船和浪花要添加的目标层
    ship_id:当前船形象id ，(id=0,1 小木船，id＝2 黄金梅里号)
    tbShipPos:船坐标
    tbShipAnchor:船锚点
    nScale:船和浪花的缩放,传空值默认没有缩放
    nShipTag:船的tag
    nLangHuaTag：浪花的tag
    return: 船动画（返回值 为了兼容mainShip中添加主船后 zOrder调整问题）
—]]
-- 2015-11-30 lvnanchun 去掉创建特效的时候的bRetain，避免主船界面误加载错误的特效
function addShipAnimation( layout,ship_id,tbShipPos,tbShipAnchor,nScale,nShipTag,nLangHuaTag )

	if nShipTag then
		local oldShip = layout:getNodeByTag(nShipTag)
		if (oldShip) then
			oldShip:removeFromParentAndCleanup(true)
		end
	end

	if nLangHuaTag then
		local oldShuiLang = layout:getNodeByTag(nLangHuaTag)
		if (oldShuiLang) then
			oldShuiLang:removeFromParentAndCleanup(true)
		end
	end

	--船动画
	local file_Path = "images/effect/home/zhujiemian_ship.ExportJson"
	local animation_Name = "zhujiemian_ship"

	if tonumber(ship_id) > 1 then
		file_Path = "images/effect/home/zhujiemian_ship" .. tonumber(ship_id) ..".ExportJson"
	end

	local aniShip = UIHelper.createArmatureNode({
		filePath = file_Path,
--		bRetain = true,
	})

	aniShip:getAnimation():playWithIndex(0, -1, -1, -1)
	aniShip:setPosition(tbShipPos)
	aniShip:setAnchorPoint(tbShipAnchor)
	layout:addNode(aniShip,0)
	if nShipTag then
		aniShip:setTag(nShipTag)
	end


	local aniShuiLang = UIHelper.createArmatureNode({
		filePath = "images/effect/home/zhujiemian_shuiliang.ExportJson",
		animationName =  "zhujiemian_shuiliang",
--		bRetain = true,
	})

	local binder = CCBattleBoneBinder:create()  --用于添加骨骼的容器
	binder:setAnchorPoint(ccp(0.5,0.5))
	binder:setCascadeOpacityEnabled(true)

	local animationBone = aniShip:getBone("ship")
	binder:bindBone(animationBone)
	layout:addNode(binder,1)
	binder:addChild(aniShuiLang)
	if nLangHuaTag then
		binder:setTag(nLangHuaTag)
	end

	nScale = nScale or 1
	aniShip:setScale(nScale)
	aniShuiLang:setScale(nScale)
	aniShuiLang:setPositionY(3)


	return aniShip

end

--获取一个progresstimer对象
function fnGetProgress( imageFile )
	local pImage = imageFile or "ui/conch_progress_blue.png"
	local progressSprite = CCSprite:create(pImage)
	local progress1=CCProgressTimer:create(progressSprite)
	progress1:setType(kCCProgressTimerTypeBar)
	progress1:setMidpoint(ccp(0, 0))
	progress1:setBarChangeRate(ccp(1, 0))
	return progress1
end

--播放获取一个progresstimer对象的升级动画
-- changeTimes 升级次数，
-- stratPercent 起始百分比，
-- finalPercent 最终百分比，
-- callBack 完成的回调
function fnPlayExpChangeAni( progress, changeTimes, stratPercent, finalPercent, callBack ,delaytime)
	local pProgress = progress or nil
	if(not pProgress or not pProgress.setPercentage) then
		if(callBack) then
			callBack()
		end
		return
	end
	local pChangeTimes = tonumber(changeTimes) or 0
	local pStratPercent = tonumber(stratPercent) or 0
	local pFinalPercent = tonumber(finalPercent) or 0

	pProgress:setPercentage(pStratPercent)

	local time1 = 0.05
	local time2 = 0.3
	local time3 = 0.5

	local arr = CCArray:create()
	if(pChangeTimes > 0) then
		for i=1,pChangeTimes do
			arr:addObject(CCProgressTo:create(2*time1 , 100))
			arr:addObject(CCDelayTime:create(time1))
			arr:addObject(CCCallFunc:create(function( ... )
				pProgress:setPercentage(0)
			end))
		end
		arr:addObject(CCProgressTo:create(time2 , pFinalPercent))
	else
		arr:addObject(CCProgressTo:create(time3 , pFinalPercent))
	end
	arr:addObject(CCDelayTime:create(delaytime or 0))
	arr:addObject(CCCallFunc:create(function( ... )
		pProgress:setPercentage(pFinalPercent)
		if(callBack) then
			callBack()
		end
	end))

	pProgress:runAction(CCSequence:create(arr))
end

function fnPlayLR_FlyEff( flyNode, callBack, notRemove )
	local pNode = flyNode or nil
	if(not pNode) then
		if(callBack) then
			callBack()
		end
		return
	end

	local delayTime1 = 0.3
	local delayTime2 = 1.5
	local moveTime = 0.5
	local runningScene = CCDirector:sharedDirector():getRunningScene()
	local pSize = runningScene:getContentSize()

	pNode:setVisible(false)
	pNode:setPositionX(pNode:getPositionX() - pSize.width*0.2)
	local actionArr = CCArray:create()
	actionArr:addObject(CCDelayTime:create(delayTime1))
	actionArr:addObject(CCCallFuncN:create(function ( ... )
		pNode:setVisible(true)
	end))
	local nextPoint = ccp(pNode:getPositionX() + pSize.width*0.2 , pNode:getPositionY())
	actionArr:addObject(CCEaseOut:create(CCMoveTo:create(moveTime, nextPoint),2))
	actionArr:addObject(CCDelayTime:create(delayTime2))
	if(not notRemove) then
		actionArr:addObject(CCCallFuncN:create(function ( ... )
			pNode:setVisible(false)
		end))
		actionArr:addObject(CCCallFuncN:create(function ( ... )
			if(pNode) then
				pNode:removeFromParentAndCleanup(true)
				pNode = nil
			end
		end))
	end
	if(callBack ) then
		actionArr:addObject(CCCallFuncN:create(function ( ... )
			callBack()
		end))
	end

	pNode:runAction(CCSequence:create(actionArr))
end

-- 2015-04-20, zhangqi, 返回贝里数大于等于100万时需要显示的字符串，小于100万以下返回原数字的字符串
-- 例如：参数为 1234567，返回 "123万"；参数为 123456，返回 "123456"
function getBellyStringAndUnit( bellyNum )
	local nBelly = tonumber(bellyNum)
	if (nBelly < 1000000) then
		return tostring(bellyNum)
	end

	return math.floor(bellyNum/10000) .. m_i18n[3227]
end

-- zhangqi, 2015-12-24, 根据 maxNum 判定 num 是否需要处理成xx万的显示形式
function longToShortNum( num, maxNum )
	local nNum = tonumber(num)
	if (nNum < 10^(maxNum - 1)) then
		return num
	end
	return math.floor(nNum/10000) .. m_i18n[3227]
end

-- zhangqi, 2015-12-24, 如果 num 超过6位数，则转换成 XX万 输出
function longToSixNum( num )
	return longToShortNum(num, 6)
end

--[[desc:lizy 20141021 主界面大王menu的光环和放大效果
    return: nil
    modified: zhangqi, 2015-05-28, 从MainScene中移来
—]]
function buttonCircle( sender )
	if not sender then
		return 
	end
	local  nFlag = 0
	local  funCallfunc = function ( ... )
		if nFlag == 0 then
			local   blinkArray = CCArray:create()
			blinkArray:addObject(CCScaleTo:create(0.1 ,1))
			local   actionSmall = CCSequence:create(blinkArray)
			sender:runAction(actionSmall)

			nFlag = 1
		end
	end

	local   blinkArray = CCArray:create()
	blinkArray:addObject(CCScaleTo:create(0.1 ,1.1))
	blinkArray:addObject(CCCallFunc:create(funCallfunc))
	local   actionBig = CCSequence:create(blinkArray)

	-- 线上报错runAction为nil，暂时找不到原因，先做容错处理by yn 2016.1.22
	if (sender.runAction) then 
		sender:runAction(actionBig)
	end 
end

   
--[[
    @des:       截取当前屏幕图片
    @ret:       截取的图片路径
]]
function getScreenshots( ... )                                                                         
    local size = CCDirector:sharedDirector():getWinSize()
    local in_texture = CCRenderTexture:create(size.width, size.height,kCCTexture2DPixelFormat_RGBA8888)
    in_texture:getSprite():setAnchorPoint( ccp(0.5,0.5) )
    in_texture:setPosition( ccp(size.width/2, size.height/2) )
    in_texture:setAnchorPoint( ccp(0.5,0.5) )

    local runingScene = CCDirector:sharedDirector():getRunningScene()
    in_texture:begin()
    runingScene:visit()
    in_texture:endToLua()

    local picPath = CCFileUtils:sharedFileUtils():getWritablePath() .. "shareTempScreenshots.jpg"
    in_texture:saveToFile(picPath)
    return picPath
end

-- zhangqi, 2015-07-15, 显示应用宝要求的QQ和微信登录选择界面
function showYingyongbaoLogin( fnQQLogin, fnWeiXinLogin )
	local layRoot = g_fnLoadUI("ui/regist_qq.json")

	local function addEvent(btn, fnCallback)
		btn:addTouchEventListener(function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				if (fnCallback and type(fnCallback) == "function") then
					AudioHelper.playCommonEffect()
					LayerManager.removeLayout()

					fnCallback()
				end
			end
		end)
	end

	local btnQQ = m_fnGetWidget(layRoot, "BTN_QQ")
	addEvent(btnQQ, fnQQLogin)

	local btnWeiXin = m_fnGetWidget(layRoot, "BTN_WECHAT")
	addEvent(btnWeiXin, fnWeiXinLogin)

	LayerManager.addLayoutNoScale(layRoot)
end


-- 返回值 splitStringTb -- 分隔后的单个字符集合table 
function splitUTFString( str)
	local lenInByte = #str
  	local splitStringTb = {}

	for i=1,lenInByte do
	    local curByte = string.byte(str, i)
	    local byteCount = 0
	    if curByte>0 and curByte<=127 then
	        byteCount = 1
	    elseif curByte>=192 and curByte<223 then
	        byteCount = 2
	    elseif curByte>=224 and curByte<239 then
	        byteCount = 3
	    elseif curByte>=240 and curByte<=247 then
	        byteCount = 4
	    end

	    if (byteCount ~= 0) then
		    local char = string.sub(str, i, i+byteCount-1)
		    i = i + byteCount -1
	    	table.insert(splitStringTb,char)

		end
	end
	return splitStringTb
end


-- 模拟打字机特效
-- lableWidge -- 需要显示打字效果的lable控件
-- typeing    -- 显示的字符串
-- typeType   -- 显示方式 1 左对齐  2  居中对齐  3 右对齐
-- ttfArg     -- 字体格式  {fontName = ,fontSize= ,strokeColor = ,strokeSize = ,tintColor = }
-- callfunc   -- 打印完毕后的回调
function typingEffect( lableWidge,typingStr,typeType ,ttfArg,callfunc)
	-- 屏幕信息
	local screen = lableWidge
	screen:setAnchorPoint(ccp(0.5,0.5))
	local screenSize = screen:getContentSize()  
	local screenWidth = screenSize.width
	local screenHeight = screenSize.height

	-- 字体信息
	local sfontName = ttfArg.fontName or g_sFontName
	local nfontSize = ttfArg.fontSize or 22
	local c3strokeColor = ttfArg.strokeColor or ccc3(0,0,0)
	local nstrokeSize = ttfArg.strokeSize or 2
	local c3fontColor = ttfArg.fontColor or ccc3(0,0,0)
	local bShadow = ttfArg.shadow 

	local ttfCharTb,ttfCharSpaceTb,ttfCharSpaceNums = splitUTFString( typingStr)
	local ttfcharNums = #ttfCharTb
	--local perLinsSHowStrTb = {}
	-- 一行显示固定个数字
	local typingColums = math.floor(screenWidth / nfontSize) 
	local typingrows = math.ceil(ttfcharNums / typingColums)

	local typingCharsTb = {}  -- 所有显示的字 按行分隔后 集合 table = {{a,b,c},{d,e}}
	local typingRowSizeTb = {}  -- 所有显示的字 按行分隔后 每行的宽带和高度
	local typingTTFTb = {}  -- tff自定义控件

	for i=1,typingrows do
		local typingRowStr = ""        -- "abc"
		local typingRowCharsTb = {}    -- {a,b,c}

		for j=1,typingColums do
			local tempTtfChar = ttfCharTb[(i - 1) * typingColums + j]
			if (not tempTtfChar) then
				break
			end
			typingRowStr = typingRowStr .. tempTtfChar
			table.insert(typingRowCharsTb,tempTtfChar)
		end
		local refLableTTf = LabelFT:create(typingRowStr, sfontName, nfontSize )
		refLableTTf:enableStroke(c3strokeColor or ccc3(0,0,0), nstrokeSize or 2)
		local refLableTTfSize = refLableTTf:getContentSize() 
		local lableAreaSize = CCSize(refLableTTfSize.width ,refLableTTfSize.height )
		--local lableTTf = LabelFT:create("", sfontName, nfontSize,lableAreaSize,kCCTextAlignmentLeft)
		local lableTTf = LabelFT:create()
		lableTTf:setString("")
		lableTTf:setFontName(sfontName)
		lableTTf:setFontSize(nfontSize)
		lableTTf:setDimensions(lableAreaSize)
		lableTTf:setHorizontalAlignment(kCCTextAlignmentLeft)

		lableTTf:setColor(c3fontColor or ccc3(0,0,0)) -- 默认黑色
		lableTTf:enableStroke(c3strokeColor or ccc3(0,0,0), nstrokeSize or 2)
		if (bShadow) then
			lableTTf:enableShadow(CCSizeMake(2, -2), 255, 0)
		end

		table.insert(typingRowSizeTb,refLableTTfSize)
		table.insert(typingCharsTb,typingRowCharsTb)
		table.insert(typingTTFTb,lableTTf)

	end

    -- 把自定义的ttflable加到控件上
    for i,v in ipairs(typingTTFTb) do
    	local rowTTF = v
    	local refLableTTfSize = rowTTF:getDimensions() 
    	logger:debug("refLableTTfSize")
    	logger:debug(refLableTTfSize.height)

    	local lablePosY = screenHeight * 0.5 - refLableTTfSize.height * 0.5

    	if (typeType == 1) then
   		 	rowTTF:setPositionX( -screenWidth *0.5 + refLableTTfSize.width * 0.5)
        elseif (typeType == 3) then
   		 	rowTTF:setPositionX(screenWidth *0.5 -  refLableTTfSize.width * 0.5)
        end
	 	rowTTF:setPositionY(lablePosY - (i-1)* refLableTTfSize.height*1.1 )
        screen:addNode(rowTTF)
    end


    local rowIndex = 1
    local charIndex = 1
    local showString = ""
    -- 开启定时器打印
    stopSchedule = GlobalScheduler.scheduleFunc(function ( ... )
        if (typingCharsTb[rowIndex]) then

            local rowChars = typingCharsTb[rowIndex]
            local rowSize = typingRowSizeTb[rowIndex]
            local lableTTf = typingTTFTb[rowIndex]

            if (rowChars[charIndex]) then
                local currentChar = rowChars[charIndex]     -- 当前字符
                showString = showString .. currentChar 
                lableTTf:setString(showString)
                charIndex = charIndex + 1
            else
                rowIndex = rowIndex + 1
                charIndex = 1
                showString = ""
            end

        else
            stopSchedule() -- 取消定时器
            callfunc() 
            showString = nil
        end
    end,4/60)

end

-- 计算listview偏移量
-- listView: 
-- aimPos: 索引
function calc_lsvOffset( listView, aimPos )
	logger:debug("calc_lsvOffset")
	local cell = listView:getItem(aimPos - 1)
	local listPos=listView:getWorldPosition()
	local listRect=CCRectMake(listPos.x,listPos.y,listView:getViewSize().width,listView:getViewSize().height)
	local leftBorder = listRect.origin.x
	local rightBorder = listRect.origin.x + listView:getViewSize().width
	if cell then
		local cellPos=cell:getWorldPosition()

		local cellRight = cellPos.x+cell:getSize().width
		local cellLeft = cellPos.x

		-- 如果在cell 在 listview 外部 右边外部 左边外部不用处理
		if cellLeft >= rightBorder then
			local offset = listView:getContentOffset()
			return ccp(offset-cellRight+rightBorder,0)
		end
		if cellRight <= leftBorder then
			local offset = listView:getContentOffset()
			return ccp(offset-cellLeft+leftBorder*2,0)
		end

		if listRect:containsPoint(cellPos) and listRect:containsPoint(ccp(cellPos.x+cell:getSize().width, cellPos.y))then
			return ccp(listView:getContentOffset(), 0)
		end
		
		if listRect:containsPoint(cellPos) and not listRect:containsPoint(ccp(cellPos.x+cell:getSize().width, cellPos.y)) then
			local offset = listView:getContentOffset()
			return ccp(offset-cellRight+rightBorder,0)
		end

		if not listRect:containsPoint(cellPos) and listRect:containsPoint(ccp(cellPos.x+cell:getSize().width, cellPos.y)) then
			local offset = listView:getContentOffset()
			return ccp(offset+leftBorder-cellLeft,0)
		end
	end
	return ccp(listView:getContentOffset(), 0)
end

-- 判断当前界面是否可以显示获取途径,并把按钮设置为确定
function chagneGuildTOOk( btn ,notSetTitle)
	local changed = false
	local curModuleName = LayerManager.curModuleName()
    local isPlaying = BattleState.isPlaying()
    logger:debug({exileModule=curModuleName})
    if (isPlaying) then                     -- 战斗场景没退出
        changed =  true
    elseif (curModuleName == "ArenaCtrl" and ArenaCtrl.getCurType() == 2) then              -- 竞技场商店
        changed =  true
    elseif (curModuleName == "MysteryCastleCtrl") then  -- 神秘商店
        changed =  true
    elseif (curModuleName == "MainGuildCtrl") then      -- 公会商店
        changed = true
    elseif (curModuleName == "ImpelShopCtrl") then      -- 装备商店
        changed =  true
    elseif (curModuleName == "TreaShopCtrl") then       -- 宝物商店
        changed =  true
    elseif (curModuleName == "SkyPieaShopCtrl") then   
        changed =  true
    elseif (curModuleName == "MainCopy" ) then            -- 副本
         changed =  true
    elseif (curModuleName == "GuildCopyMapView" ) then    -- 公会副本
        changed = true
    elseif (curModuleName == "MainWonderfulActCtrl") then   -- 活动
        changed = true
    elseif (curModuleName == "AdventureMainCtrl") then   -- 奇遇
        changed = true
    elseif (curModuleName == "GuildCopyMapCtrl") then   -- 觉醒副本
        changed = true
    elseif (curModuleName == "WAMainView") then   -- 海盗激斗
    	changed = true
    elseif (curModuleName == "WAEntryView") then   -- 海盗激斗
    	changed = true
    end

    if (changed and not notSetTitle) then
    	UIHelper.titleShadow(btn,m_i18n[1029])
    	btn:addTouchEventListener(function ( sender,eventType )
    		if (eventType == TOUCH_EVENT_ENDED)  then
				AudioHelper.playCommonEffect()
    			LayerManager.removeLayout()
    		end
    	end)
    end

    return changed
end


-- 判断指定显示对象是否完好(对象是否有效,是否在显示列表中)
function isGood( target )
	 
    if(target ~= nil and not tolua.isnull(target) and
       target.getParent ~= nil and target:getParent() ~= nil and
       target.retainCount ~= nil and target:retainCount() > 0) then
        return true
    end
    return false
 
end

local recomImgPath = "images/recommend/" 
local reComTb = {tips = recomImgPath.."bag_cell_tips1.png", --荐
				 limit = recomImgPath.."icon_shop_limit.png", --限时
				 need = recomImgPath.."icon_shop_need.png", -- 需要
				 own = recomImgPath.."icon_shop_own.png",  -- 已上阵
				 profit = recomImgPath.."icon_shop_profit.png", -- 加成
				 stronger = recomImgPath.."icon_shop_stronger.png", -- 更强
				 unique = recomImgPath.."icon_shop_unique.png",   -- 专属
				}

--神秘商店标签
function getMysteryShopRecommendType(tGoods)
	local bRecommend = tonumber(tGoods.recommended) == 1
	if bRecommend and not tGoods.tid then
		return reComTb.tips
	end
	if not bRecommend and not tGoods.tid then
		return false
	end
	if tGoods.isHeroFragment then
		local bAc = BondManager.isHtidCanActiveFormation(tGoods.tid) -- 是否激活羁绊
		local isBusy = HeroPublicUtil.isBusyWithHtid(tGoods.tid)
		if bAc and not isBusy then
			return reComTb.profit
		elseif isBusy then
			return reComTb.own
		end
	elseif tGoods.isTreasureFragment then
		local bAcT = BondManager.isTreaCanActiveFormation(tGoods.tid) -- 饰品是否激活羁绊
		if bAcT then
			return reComTb.profit
		end
	end

	if bRecommend then
		return reComTb.tips
	end

	return false
end

-- 返回限时标签
function getGuildShopRecommendType( )
	return reComTb.limit
end

-- 宝物商店标签 
function getSpecialShopRecommendType(tGoods)
	local bRecommend = tonumber(tGoods.recommended) == 1
	if bRecommend and not tGoods.tid then
		return reComTb.tips
	end

	if not bRecommend and not tGoods.tid then
		return false
	end

	local bUnique = FormationSpecialModel.isExclusiceUsedInFormation(tGoods.tid)
	logger:debug({tGoods = tGoods})
	logger:debug("bUnique = %s", bUnique)
	if bRecommend and not bUnique then
		return reComTb.tips
	end
	if bUnique then
		return reComTb.unique
	end
	return false
end

-- 觉醒商店标签
function getAwakeShopRecommendType( tGoods )
	local bRecommend = tonumber(tGoods.recommended) == 1
	if bRecommend and not tGoods.tid then
		return reComTb.tips
	end
	if not bRecommend and not tGoods.tid then
		return false
	end
	local bNeed = MainAwakeModel.isNeedThisItem(tGoods.tid)
	if bNeed then
		return reComTb.need
	end

	if bRecommend then
		return reComTb.tips
	end

	return false
end

-- 装备商店返回更强标签
function getImpelShopRecommendType(  )
	return reComTb.stronger
end

-- 设置listview滑动性 cell数量没填满则不能滑动
-- @param listView
-- @param isCenter 是否需要居中
-- 使用：UIHelper.setSliding(listView)
function setSliding( listView, isCenter )
	TimeUtil.timeStart("setSliding")
	local dataNum = listView:getItems():count()
	local dir = listView:getDirection()
	local allCellSize = CCSizeMake(0, 0)
	for i = 1, dataNum do
		local cell = listView:getItem(i - 1)
		if (cell) then
			allCellSize = CCSizeMake(allCellSize.width + cell:getSize().width, allCellSize.height + cell:getSize().height)
		end
	end
	local lsvSize = listView:getViewSize()
	-- 水平
	if (dir == SCROLLVIEW_DIR_HORIZONTAL) then
		if (allCellSize.width <= lsvSize.width) then
			listView:setBounceEnabled(false)
			listView:setClippingEnabled(false)
			if (isCenter) then
				if (not listView.originPos) then
					listView.originPos = ccp(listView:getPositionX(), listView:getPositionY())
				end
				local delta = lsvSize.width - allCellSize.width
				listView:setPositionType(0)
				listView:setPositionX(listView.originPos.x + delta / 2)
			end
		else
			listView:setBounceEnabled(true)
			listView:setClippingEnabled(true)
		end
	-- 垂直
	elseif (dir == SCROLLVIEW_DIR_VERTICAL) then
		if (allCellSize.height <= lsvSize.height) then
			listView:setBounceEnabled(false)
		else
			listView:setBounceEnabled(true)
		end
	end
	TimeUtil.timeEnd("setSliding")
end



--[[desc:分享战报
	brid: 战报id  已经修改，传来的此参数不再使用。
	batttleName：模块名称（普通副本－副本名；深海监狱－深海监狱层名； 激战海王类－激战海王类；精英副本－精英副本；公会副本－公会副本名；日常副本－日常副本）
    playername:对手name (普通副本－据点名；深海监狱－关卡名；激战海王类－世界boss名；精英副本－怪物名；公会副本－据点名；日常副本－副本名；)
    return: 是否有返回值，返回值说明  

    RequestCenter.chat_sendWorld，后端添加第三个参数为类型，文字聊天/语音聊天为1，发送战报为2  2016.2.24
—]]
local m_brid  = 0
function sendBattleReport( brid,batttleName,playerName)
	local recordData = BattleState.getRecordData() 
	local tbData = lua_string_split(recordData,'|')

	if (tonumber(m_brid)==tonumber(tbData[1])) then 
		ShowNotice.showShellInfo(m_i18n[7806]) 
		return 
	end 

	m_brid = tbData[1]

	local fnSendReportCallback = function ( cbFlag, dictData, bRet )
		if(bRet) then
			ShowNotice.showShellInfo(m_i18n[7806])   
		end
	end

	local userName = UserModel.getUserName()
	local text = ""

	if (batttleName) then 
		text = "<table>" .. userName.. "," .. playerName .. "," .. recordData .. "," .. ChatCellType.battleReport .. "," .. batttleName .. "<table/>"
	else   --兼容竞技场，抢矿 
		text = "<table>" .. userName.. "," .. playerName .. "," .. recordData .. "," .. ChatCellType.playerReport .. "<table/>"
	end 

	RequestCenter.chat_sendWorld(fnSendReportCallback, Network.argsHandler(text, 2,2))
end



