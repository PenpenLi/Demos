-- FileName: NewLoginView.lua
-- Author: menghao
-- Date: 2014-07-10
-- Purpose: 登陆界面view


module("NewLoginView", package.seeall)


-- UI控件引用变量 --
local m_UIMain

local m_tfdSever
local m_imgHot
local m_imgNew
local m_btnChoose
local m_btnLogin

-- 帐号相关，zhangqi, 2014-11-04
local m_btnAccount -- 显示账户名的按钮, BTN_LOGIN_NAME, BTN_CHOOSE_UP, BTN_CHOOSE_DOWN, BTN_BOUND
local m_imgComBox -- 最近登陆账户的下拉列表背景，用来控制隐藏和显示, IMG_ACCOUNT_BG
local m_lsvAccounts -- 最近登陆账户的下拉列表, LSV_ACCOUNT
local m_layArrow -- 登陆账户按钮上的箭头按钮层
local m_btnUp -- 向上箭头按钮
local m_btnDown -- 向下箭头按钮

local m_imgBG
local m_imgCloud
local m_imgBottom
local m_imgMB

-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_i18n = gi18n

local talkEditBox


local function init(...)

end


function destroy(...)
	package.loaded["NewLoginView"] = nil
end


function moduleName()
	return "NewLoginView"
end


function upServerUI( tbServerData )
	if tbServerData.hot ~= 1 then
		m_imgHot:setEnabled(false)
	else
		m_imgHot:setEnabled(true)
	end
	if (tbServerData.new ~= 1) then
		m_imgNew:setEnabled(false)
	else
		m_imgNew:setEnabled(true)
	end
	-- zhangqi, 2016-01-20, 新增推荐服信息，显示新服图标
	if (tonumber(tbServerData.tj) == 1) then
		m_imgNew:setEnabled(true)
		m_imgHot:setEnabled(false)
	end
	m_tfdSever:setText(tbServerData.name)
end


function getTextPid( ... )
	if (not Platform.isPlatform()) then
		-- zhangqi, 2015-11-04, 暂时从别处获取线下Pid，避免talkEditBox:getText报错的问题
		local text = LoginHelper.debugUID() or "1024"
		if (UIHelper.isGood(talkEditBox)) then
			text = talkEditBox:getText()
		end
		return text
	end
end

-- zhangqi, 2015-12-18
function getPlayerPid( ... )
	return talkEditBox:getText()
end


function setEditBoxEnabled( bValue )
	if (not Platform.isPlatform()) then
		talkEditBox:setTouchEnabled(bValue)
	end
end

-- zhangqi, 2016-02-25, 设置登录按钮的可用性，以便在最近登录信息返回前后禁用和启用登录按钮
-- 保证登录时是用最近登录服务器信息
function setBtnLoginEnabled( bEnabled )
	if (g_debug_mode) then
		bEnabled = true
	end

	if (m_btnLogin) then
		m_btnLogin:setTouchEnabled(bEnabled)
	end
end

function create( tbEvent, selectServer )
	m_UIMain = g_fnLoadUI("ui/regist_main.json")

	if (g_debug_mode) then
		local button = Button:create() -- 新手引导开关按钮
		button:setPosition(ccp(450, 400))
		button:setTitleText("新手引导")
		button:setTitleFontSize(g_FontInfo.size)
		button:setTitleColor(ccc3(255, 0, 0))
		button:loadTextureNormal("images/arena/king_photo_bg_1.png")
		m_UIMain:addChild(button, 9999)

		local consolBtn = Button:create() -- 控制台开关按钮
		consolBtn:setPosition(ccp(150, 400))
		consolBtn:setTitleText("控制台")
		consolBtn:setTitleFontSize(g_FontInfo.size)
		consolBtn:setTitleColor(ccc3(255, 0, 0))
		consolBtn:loadTextureNormal("images/arena/king_photo_bg_1.png")
		m_UIMain:addChild(consolBtn, 9998)		

		function testButon( ... )
			local gray = ccc3(128,138,135)
			if g_tGuideState.g_closeGuide then
				button:setTitleColor(gray)
			else
				button:setTitleColor(ccc3(255,0,0))
			end

			if (g_tConsolStat.show) then
				consolBtn:setTitleColor(ccc3(255,0,0))
			else
				consolBtn:setTitleColor(gray)
			end
		end

		testButon()
		button:addTouchEventListener(function( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				if g_tGuideState.g_closeGuide then
					g_tGuideState.g_closeGuide = false
				else
					g_tGuideState.g_closeGuide = true
				end
				testButon()
			end
		end)

		consolBtn:addTouchEventListener(function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				g_tConsolStat.show = not g_tConsolStat.show
				testButon()
			end
		end)
	end

	
	-- 版署提示
	local layBanShu = m_fnGetWidget(m_UIMain, "LAY_BANSHU")
	layBanShu:setEnabled(false)

	m_imgHot = m_fnGetWidget(m_UIMain, "IMG_HOT")
	m_imgNew = m_fnGetWidget(m_UIMain, "IMG_NEW")
	m_tfdSever = m_fnGetWidget(m_UIMain, "TFD_SERVER")
	m_btnLogin = m_fnGetWidget(m_UIMain, "BTN_LOGIN")
	-- zhangqi, 2016-03-09, 解决了getHash和实际登录游戏服的信息不一致问题，去掉登录按钮的限制
	-- setBtnLoginEnabled(false) -- 2016-02-25, 默认先禁用登录按钮
	m_btnChoose = m_fnGetWidget(m_UIMain, "BTN_CHOOSE")

	m_imgBG = m_fnGetWidget(m_UIMain, "img_bg")
	m_imgCloud = m_fnGetWidget(m_UIMain, "img_cloud")
	m_imgBottom = m_fnGetWidget(m_UIMain, "IMG_BOTTOM")
	m_imgMB = m_fnGetWidget(m_UIMain, "IMG_MENGBAN")

	local layTest = m_fnGetWidget(m_UIMain, "LAY_TEST")
	local size = layTest:getSize()
	layTest:setSize(CCSizeMake(size.width * g_fScaleX, size.height * g_fScaleX))

	m_imgBG:setScale(g_fScaleX)
	m_imgCloud:setScale(g_fScaleX)
	m_imgBottom:setScale(g_fScaleX)
	m_imgMB:setScale(g_fScaleX)
	m_btnLogin:setScale(g_fScaleX)

	if (g_debug_mode) then                                                                             
	    local layVer = Layout:create()                                                                 
	    layVer:setTouchEnabled(false)                                                                  
	    -- 显示资源更新的UI和检查中的提示, zhangqi                                                     
	    local pkgVer, resVer = Helper.getVersion()                                                     
	    local strVersion = string.format("底包版本:%s  资源版本:%s", pkgVer, resVer)                   
	    local labVer = UIHelper.createUILabel(strVersion, nil, g_FontInfo.size, ccc3(0xff, 0xff, 0xff))
	    labVer:setAnchorPoint(ccp(0, 1))                                                               
	    layVer:addChild(labVer)                                                                        
	    labVer:setPosition(ccp(10, g_winSize.height - 10))                                             
	    m_UIMain:addChild(layVer)                                                                      
	end                                                                                                

	-- 最近登陆帐号下拉列表背景, 默认不显示
	m_imgComBox = m_fnGetWidget(m_UIMain, "IMG_ACCOUNT_BG")
	m_imgComBox:setEnabled(false)

	selectServer = selectServer or {} -- zhangqi, 2015-12-29, 避免未开服时获取的selectServer为nil报错
	if selectServer.hot ~= 1 then
		m_imgHot:setEnabled(false)
	end
	if (selectServer.new ~= 1) then
		m_imgNew:setEnabled(false)
	end

	m_tfdSever:setText(selectServer.name or "") -- zhangqi, 2015-12-29
	
	m_btnLogin:addTouchEventListener(tbEvent.onLogin)
	m_btnChoose:addTouchEventListener(tbEvent.onChoose)
	local btnSeverList = m_fnGetWidget(m_UIMain, "BTN_SERVER_NAME")
	btnSeverList:addTouchEventListener(tbEvent.onChoose)

	-- zhangqi, 2015-12-18, 加入非玩家登陆的判断
	if (Platform.isPlatform() and (not g_DEBUG_env.player)) then
		-- 隐藏账户的按钮
		m_btnAccount = m_fnGetWidget(m_UIMain, "BTN_LOGIN_NAME")
		m_btnAccount:setEnabled(false)
		m_btnAccount:setTouchEnabled(false)

		m_layArrow = m_fnGetWidget(m_btnAccount, "LAY_ARROW")
		m_layArrow:setEnabled(false)	-- 隐藏箭头按钮
		m_btnUp = m_fnGetWidget(m_layArrow, "BTN_CHOOSE_UP")
		m_btnUp:setTouchEnabled(false)
		m_btnDown = m_fnGetWidget(m_layArrow, "BTN_CHOOSE_DOWN")
		m_btnDown:setTouchEnabled(false)

		m_lsvAccounts = m_fnGetWidget(m_imgComBox, "LSV_ACCOUNT")
	else
		local btnLogin = m_fnGetWidget(m_UIMain, "BTN_LOGIN_NAME")

		talkEditBox = UIHelper.createEditBox(CCSizeMake(180 * g_fScaleX, 50 * g_fScaleY), "images/base/potential/input_name_bg1.png", false)
		talkEditBox:setPlaceHolder("Name:")
		talkEditBox:setPlaceholderFontColor(ccc3(0xc3, 0xc3, 0xc3))
		talkEditBox:setMaxLength(40)
		talkEditBox:setReturnType(kKeyboardReturnTypeDone)
		talkEditBox:setInputFlag (kEditBoxInputFlagInitialCapsWord)

		local strUid = LoginHelper.debugUID() or "1024"
		logger:debug("strUid = %s", strUid)
		talkEditBox:setText(strUid)

		btnLogin:addNode(talkEditBox)
	end

	return m_UIMain
end

