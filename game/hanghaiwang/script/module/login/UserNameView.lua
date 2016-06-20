-- FileName: UserNameView.lua
-- Author: menghao
-- Date: 2014-07-16
-- Purpose: 输入角色名view


module("UserNameView", package.seeall)


require "script/module/public/ShowNotice"


-- UI控件引用变量 --
local m_UIMain
local m_imgType -- 输入框附加到的背景图片


-- 模块局部变量 --
local m_ExpCollect = ExceptionCollect:getInstance()
local m_fnGetWidget = g_fnGetWidgetByName
local mi18n = gi18n

local nameEditBox
local m_tbNames
local m_strName
local m_nCurIndex
local m_tagLabName = 3333 -- 实现昵称居中效果的辅助Label的tag
local m_lastServer  -- zhangqi, 2016-01-20, 临时保存最近登录服务器group


local function init(...)

end


function destroy(...)
	package.loaded["UserNameView"] = nil
end


function moduleName()
	return "UserNameView"
end

-- 创建角色按钮的网络回调函数
local function createuserAction(cbFlag, dictData, bRet)
	-- 创建不成功要移除屏蔽层，成功会跳到其他模块
	if (not bRet) then
		m_ExpCollect:info("user_createUser", "bRet false: dictData.ret = " .. tostring(dictData.ret))
		LayerManager.removeLayout()
		nameEditBox:setTouchEnabled(true)
		return
	end

	if (dictData.ret ~= "ok") then
		m_ExpCollect:info("user_createUser", "dictData.ret ~= ok " .. tostring(dictData.ret))
		LayerManager.removeLayout()
		nameEditBox:setTouchEnabled(true)
	end

	m_ExpCollect:finish("user_createUser")

	if (dictData.ret == "ok") then
		ShowNotice.showShellInfo(mi18n[1912])

		-- zhangqi, 2016-01-20, 创建角色成功把最近登录服务器group写回
		LoginHelper.fnRecentServerGroup(m_lastServer or "")

		performWithDelay(m_UIMain, function ( ... )
			LayerManager.addRegistLoading()

			m_ExpCollect:start("user_getUsers")
			
			RequestCenter.user_getUsers(UserHandler.fnGetUsers)
		end, 1.1) -- 延迟1.1秒是为了在浮动提示"创建角色成功"消失后再显示loading, 避免二者重叠

		return
	elseif (dictData.ret == "invalid_char") then
		ShowNotice.showShellInfo(mi18n[1913])
		return
	elseif (dictData.ret == "sensitive_word") then
		ShowNotice.showShellInfo(mi18n[1913])
		return
	elseif (dictData.ret == "name_used") then
		ShowNotice.showShellInfo(mi18n[1914])
		return
	end
end


-- 汉字的 utf8 转换
local function getStringLength(str)
	local strLen = 0
	local i =1
	while i<= #str do
		if(string.byte(str,i) > 127) then
			-- 汉字
			strLen = strLen + 2
			i= i+ 3
		else
			i =i+1
			strLen = strLen + 1
		end
	end
	return strLen
end


-- 获取随机名字请求返回后回调
local function randomNameAction( cbFlag, dictData, bRet )
	if (not bRet) then
		m_ExpCollect:info("user_getRandomName", "bRet false")
		return
	end

	if (dictData.err ~= "ok") then
		m_ExpCollect:info("user_getRandomName", "randomNameAction err = " .. tostring(dictData.err))
		return
	end

	-- zhangqi, 2015-06-29, 为了昵称居中显示要创建额外的label
	-- 将创建代码从随机名用完的判断条件后前移，避免随机名用完return导致不创建，然后手工输入时导致找不到控件报错
	local labName = m_imgType:getChildByTag(m_tagLabName)
	if (not labName) then
		labName = UIHelper.createUILabel("", g_sFontCuYuan, 28)
		labName:setTag(m_tagLabName)
		labName:setFontSize(28)
		m_imgType:addChild(labName)
	end

	m_tbNames = dictData.ret
	if(table.isEmpty(m_tbNames)) then
		m_ExpCollect:info("user_getRandomName", "randomName table is empty")
		ShowNotice.showShellInfo(mi18n[1917])
		return
	end
	m_strName = m_tbNames[1].name
	m_nCurIndex = 1

	nameEditBox:setText("") -- zhangqi, 2016-01-04, 新的随机名返回后需要清理掉文本输入框的内容
	labName:setText(m_strName)

	m_ExpCollect:finish("user_getRandomName")
end


-- 获取随机名字的网络请求
local function getRandomName( ... )
	m_ExpCollect:start("user_getRandomName")
	local args = Network.argsHandlerOfTable({20, 1})
	RequestCenter.user_getRandomName(randomNameAction, args)
end


-- 创建角色按钮事件
local onNext = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playEnter()

		local args = Network.argsHandlerOfTable({1, m_strName})
		-- zhangqi, 2015-12-18, 随机名用完后的后端回调中没有处理m_strName，值是nil
		-- 所以添加m_strName是nil的条件判断，避免用nil调用getStringLength报错
		if (m_strName == nil or m_strName == "") then
			ShowNotice.showShellInfo(mi18n[1915])
			return
		end
		if getStringLength(m_strName) > 12 then
			ShowNotice.showShellInfo(mi18n[1916])
			return
		end

		-- 加屏蔽层
		local layout = Layout:create()
		layout:setName("layForShield")
		LayerManager.addLayout(layout)
		nameEditBox:setTouchEnabled(false)

		m_ExpCollect:start("user_createUser", "nickname = " .. tostring(m_strName))
		RequestCenter.user_createUser(createuserAction, args)
	end
end


-- 随机名字事件
local onRandom = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playBtnEffect("shaizi.mp3")
		if(table.isEmpty(m_tbNames)) then
			ShowNotice.showShellInfo(mi18n[1917])
			return
		end

		m_nCurIndex = m_nCurIndex + 1
		if (m_nCurIndex <= 20 ) then
			-- zhangqi, 2016-01-06, 避免安卓在输入时连点两下系统键返回关闭输入状态，
			-- 但没有触发EditBox的OnEnd事件，导致再点击随机按钮出现EditBox和Label文字重叠的问题
			nameEditBox:setText("")

			m_strName = m_tbNames[m_nCurIndex].name
			-- nameEditBox:setText("" .. m_tbNames[m_nCurIndex].name)
			local labName = m_imgType:getChildByTag(m_tagLabName)
			labName:setText(m_strName)
		else
			getRandomName()
		end
	end
end

-- 路飞动画 动态
local function showArmature11( widget, call )
	local armature11 = UIHelper.createArmatureNode({
		filePath = "images/effect/shop_recruit/zhao1_1.ExportJson",
		fnMovementCall = function ( sender, MovementEventType , frameEventName)
			if (MovementEventType == 1) then
				sender:removeFromParentAndCleanup(true)
				sender = nil
			end
		end
	})
	local bone0101 = armature11:getBone("zhao1_1_01_01")
	local filePath = "images/base/hero/body_img/body_elite_lufeilv.png"

	local ccSkin0101 = CCSkin:create(filePath)
	bone0101:addDisplay(ccSkin0101,0)
	local bone01 = armature11:getBone("zhao1_1_01")
	local ccSkin01 = CCSkin:create(filePath)
	bone01:addDisplay(ccSkin01, 0)

	armature11:getAnimation():play("zhao1_1_1", -1, -1, 0)
	widget:addNode(armature11)
end

-- 星星 循环
local function showArmature2( widget )
	local armature2 = UIHelper.createArmatureNode({
		filePath = "images/effect/shop_recruit/zhao2.ExportJson",
		animationName = "zhao2",
	})
	widget:addNode(armature2)
end


-- 路飞静态动画
local function showArmature4( widget )
	local armature4 = UIHelper.createArmatureNode({
		filePath = "images/effect/shop_recruit/zhao4.ExportJson",
	})
	local bone = armature4:getBone("zhao4_1")
	local ccSkin = CCSkin:create("images/base/hero/body_img/body_elite_lufeilv.png")
	bone:addDisplay(ccSkin, 0)
	armature4:getAnimation():play("zhao4_1", -1, -1, 0)
	widget:addNode(armature4)
end

-- 背景光特效 循环
local function showArmature3( widget )
	local armature3 = UIHelper.createArmatureNode({
		filePath = "images/effect/shop_recruit/zhao3.ExportJson",
		animationName = "zhao3",
	})
	widget:addNode(armature3)
end

-- 光
local function showArmature1( widget, call )
	local armature1 = UIHelper.createArmatureNode({
		filePath = "images/effect/shop_recruit/zhao1.ExportJson",
		animationName = "zhao1",
		fnFrameCall = function ( bone, frameEventName, originFrameIndex, currentFrameIndex )
			if (frameEventName == "2") then
				showArmature3(widget)
				showArmature4(widget)
				showArmature2(widget)  
			elseif (frameEventName == "1") then
				showArmature11(widget) 
			elseif (frameEventName == "6") then
				call()
			end 
		end,

		fnMovementCall = function ( armature,movementType,movementID )
				if (movementType == 1) then 
					armature:removeFromParentAndCleanup(true)
					armature = nil
				end 
		end

	})
	armature1:getAnimation():gotoAndPlay(148)
	local fScale = g_fScaleX > g_fScaleY and g_fScaleX or g_fScaleY
	armature1:setScale(fScale)
	widget:addNode(armature1)
end


-- 木桶
function playEstablish( widget, call )
	performWithDelay(m_UIMain,function ( ... )
		local tbParams = {
		filePath = "images/effect/create_user/establish.ExportJson",
		animationName = "establish",
		fnMovementCall = function ( sender, MovementEventType , frameEventName)
				if (MovementEventType == 0) then
				elseif (MovementEventType == 1) then
					showArmature1(widget, call)
					sender:removeFromParentAndCleanup(true)
					sender = nil
					
				elseif (MovementEventType == 2) then
				end
			end,
		}
		local armature = UIHelper.createArmatureNode(tbParams)
		widget:addNode(armature)
		AudioHelper.playSpecialEffect("mutongbaokai.mp3")
	end,0.1)
end


function playEstablishTalk( widget, call )
	local tbParams = {
		filePath = "images/effect/create_user/establish_talk.ExportJson",
		animationName = "establish_talk",
	}
	local armature = UIHelper.createArmatureNode(tbParams)
	widget:addNode(armature)
end


function create(...)
	m_ExpCollect:start("UserNameView")

	m_UIMain = g_fnLoadUI("ui/regist_name.json")

	local layMain = m_fnGetWidget(m_UIMain, "LAY_MAIN")

	local btnNext = m_fnGetWidget(m_UIMain, "BTN_NEXT")
	m_imgType = m_fnGetWidget(m_UIMain, "IMG_TYPE")
	local btnRandom = m_fnGetWidget(m_UIMain, "BTN_RANDOM")
	local imgPlz = m_fnGetWidget(m_UIMain, "img_plz_type")

	btnNext:setEnabled(false)
	m_imgType:setEnabled(false)
	imgPlz:setEnabled(false)

	btnNext:addTouchEventListener(onNext)
	btnRandom:addTouchEventListener(onRandom)

	nameEditBox = UIHelper.createEditBox(CCSizeMake(180, 56), "images/base/potential/input_name_bg1.png", false)
	nameEditBox:setFontSize(28)
	nameEditBox:setPlaceholderFontColor(ccc3(0xc3, 0xc3, 0xc3))
	nameEditBox:setMaxLength(12)
	nameEditBox:setReturnType(kKeyboardReturnTypeDone)
	nameEditBox:setInputFlag (kEditBoxInputFlagInitialCapsWord)
	m_imgType:addNode(nameEditBox)

	-- zhangqi, 2015-03-24, 为了实现昵称居中显示，创建一个Label来代替editBox的显示
	UIHelper.bindEventToEditBox({inputBox = nameEditBox, onEnded = function ( ... )
		m_strName = nameEditBox:getText()
		local labName = m_imgType:getChildByTag(m_tagLabName)
		labName:setText(m_strName)
		nameEditBox:setText("")
	end, onBegan = function ( ... )
		local labName = m_imgType:getChildByTag(m_tagLabName)
		nameEditBox:setText(labName:getStringValue())
		labName:setText("")
	end})

	local imgLeader = m_fnGetWidget(m_UIMain, "IMG_LEADER")
	local imgChatBG = m_fnGetWidget(m_UIMain, "img_chat_bg")
	local tfdContent = m_fnGetWidget(m_UIMain, "TFD_CHAT_CONTENT")

	imgChatBG:setEnabled(false)
	tfdContent:setEnabled(false)

	tfdContent:setText(gi18n[4756])

	local tbWidgets = {imgChatBG, m_imgType, imgPlz}

	btnNext:setTouchEnabled(false)
	btnRandom:setTouchEnabled(false)
	nameEditBox:setTouchEnabled(false)

	-------------------------2016.01.11 yn 优化木桶和zhao1动画切换时卡顿问题
 	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("images/effect/shop_recruit/zhao1.ExportJson")

	playEstablish(imgLeader, function ( ... )
		local function play( i )
			if (i > #tbWidgets) then
				btnNext:setTouchEnabled(true)
				btnRandom:setTouchEnabled(true)
				nameEditBox:setTouchEnabled(true)

				performWithDelay(m_UIMain, function ( ... )
					playEstablishTalk(btnNext, function ( ... )
						end)
				end, 40 / 60)
				return
			end

			local n = i == 1 and 0.63 or 1

			tbWidgets[i]:setScaleY(0.2)
			tbWidgets[i]:setEnabled(true)
			local actionArr1 = CCArray:create()
			actionArr1:addObject(CCScaleTo:create(6 / 60, 1 * n, 1.2 * n))
			actionArr1:addObject(CCScaleTo:create(6 / 60, 1 * n, 0.8 * n))
			actionArr1:addObject(CCScaleTo:create(6 / 60, 1 * n, 1 * n))
			actionArr1:addObject(CCDelayTime:create(6 / 60))
			actionArr1:addObject(CCCallFunc:create(function ( ... )
				if (i > 1) then
					play(i + 1)
					return
				end
				btnNext:setEnabled(true)
				btnNext:setScaleY(0.2)
				btnNext:setScaleY(0)
				local x, y = btnNext:getPosition()
				local actionArr2 = CCArray:create()
				actionArr2:addObject(CCPlace:create(ccp(x + 428, y)))
				actionArr2:addObject(
					CCSpawn:createWithTwoActions(
						CCScaleTo:create(10 / 60, 1, 1.2),
						CCMoveTo:create(10 / 60, ccp(x - 31, y))
					)
				)
				actionArr2:addObject(
					CCSpawn:createWithTwoActions(
						CCScaleTo:create(2 / 60, 1, 1),
						CCMoveTo:create(2 / 60, ccp(x, y))
					)
				)
				actionArr2:addObject(CCCallFunc:create(function ( ... )
					play(i + 1)
				end))

				-- zhangqi, 2015-06-29, 将获取随机名的请求放在动画最后，避免播放动画过程中弹出随机名用完的提示
				actionArr2:addObject(CCCallFunc:create(function ( ... )
					getRandomName()
				end))

				btnNext:runAction(CCSequence:create(actionArr2))
			end))
			tbWidgets[i]:runAction(CCSequence:create(actionArr1))
		end

		play(1)
	end)

	AudioHelper.playSceneMusic("denglu.mp3")

	-- zhangqi, 2016-01-20, 创建角色前先删除本地缓存的最近登录服务器信息
	m_lastServer = LoginHelper.fnRecentServerGroup()
	LoginHelper.fnRecentServerGroup("")

	m_ExpCollect:finish("UserNameView")

	return m_UIMain
end

