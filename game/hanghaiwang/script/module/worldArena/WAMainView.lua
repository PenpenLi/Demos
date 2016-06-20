-- FileName: WAMainView.lua
-- Author: huxiaozhou
-- Date: 2016-02-17
-- Purpose: 战斗主显示UI
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变  
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /


module("WAMainView", package.seeall)

-- UI控件引用变量 --
local _mainWidget = nil
-- 模块局部变量 --

local m_i18n = gi18n
local m_i18nString 	= gi18nString

local _tPlayer = {}
local _armature = nil
local _image = nil
local _nIndex = nil
local _effectId = nil
local json = "ui/peak_main.json"
local function init()
		_tPlayer = {}
		_armature = nil
		_image = nil
		_nIndex = nil
		_effectId = nil
end

function destroy()
	package.loaded["WAMainView"] = nil
end

function moduleName()
    return "WAMainView"
end

function create()
	_mainWidget = g_fnLoadUI(json)
	_mainWidget:setSize(g_winSize)
	_mainWidget.img_bg:setScale(g_fScaleX)
	_tPlayer = {}
	init()
	_mainWidget.BTN_CLOSE:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			WAMainCtrl.onBack()
		end
	end)
	UIHelper.titleShadow(_mainWidget.BTN_CLOSE, m_i18n[1019])
	_mainWidget.BTN_FUNCTION_OPEN:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			WAMainCtrl.onSecMenu()
		end
	end)
		
	_mainWidget.BTN_GOLD_RECOVER:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			WAMainCtrl.resetHp(WAUtil.WA_RESET_HP.GOLD)
		end
	end)

	_mainWidget.BTN_BELLY_RECOVER:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			WAMainCtrl.resetHp(WAUtil.WA_RESET_HP.SILVER)
		end
	end)

	if WorldArenaModel.getMaxResetNumBySilver()- WorldArenaModel.getHaveResetNumBySilver() <= 0 then
		_mainWidget.BTN_BELLY_RECOVER:setGray(true)
		_mainWidget.BTN_BELLY_RECOVER:setTouchEnabled(false)
	end

	_mainWidget.BTN_ADD:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			WAMainCtrl.onBuyAtkTimes()
		end
	end)

	_mainWidget.img_paomadeng_bg:setEnabled(false)

	addBgAnim()
	addFireEffect()
	runBigBoatAction()
	loadAll()
	
	_mainWidget.img_my_ship:setScale(g_fScaleX)
	UIHelper.registExitAndEnterCall(_mainWidget, function (  )
		removePush()
		WAService.leave()
		GlobalScheduler.removeCallback("WAATKTIME")
		GlobalScheduler.removeCallback("WAPROTECTTIME")

		for i=1,3 do
			GlobalScheduler.removeCallback("WASHIPPROTECT" .. i)
		end
		GlobalNotify.removeObserver("WABETREDPOINT", "WABETREDPOINTMAINVIEW")
		GlobalNotify.removeObserver("END_BATTLE", "WAMAIN_END_BATTLE")
		_mainWidget = nil
		AudioHelper.stopEffect(_effectId)
	end, function (  )
		addPush()
		GlobalNotify.addObserver("END_BATTLE",playMusic, false, "WAMAIN_END_BATTLE")
		GlobalNotify.addObserver("WABETREDPOINT",updateBetRedPoint, false, "WABETREDPOINTMAINVIEW")
		WAService.enter()
	end)
	LayerManager.changeModule(_mainWidget, WAMainView.moduleName(), {}, true)
end

-- 增加常住的循环特效
function addBgAnim(  )

	playMusic()
	for i=1,3 do
		local file_Path = "images/effect/worldArena/peak_showdown" .. i ..  ".ExportJson"
		local animation_Name = "peak_showdown" .. i
		local armature = UIHelper.createArmatureNode({
			filePath = file_Path,
			animationName = animation_Name,
		})
		local zOrder = 0
		if i==1 then
			zOrder = 3
		elseif i==2 then
			zOrder = 1
		else
			zOrder = 2
		end
		_mainWidget.img_bg:addNode(armature, zOrder) 
		armature:setScale(g_fScaleX)
	end
end

function playMusic(  )
	AudioHelper.playMusic("audio/bgm/copy1.mp3", true)
	if _effectId then
		AudioHelper.stopEffect(_effectId)
		_effectId = nil
	end
	_effectId = AudioHelper.playEffect("audio/effect/jizhan_amb.mp3",true)
end

function stopEffect(  )
	if _effectId then
		AudioHelper.stopEffect(_effectId)
		_effectId = nil
	end
end

--加载所有的UI
function loadAll(  )
	logger:debug("loadAllloadAll")
	updateBetRedPoint()
	loadTop()
	updateBottom()
	checkBox()
	updateBellyResetTimes()
	local layAllShip = _mainWidget.LAY_SHIP
	_tPlayer = WorldArenaModel.getPlayer()
	logger:debug({_tPlayer = _tPlayer})
	for i, player in ipairs(_tPlayer) do
		if i<=3 then
			local layShip = layAllShip["LAY_PLAYER" .. i]
			layShip:setEnabled(true)
			addShip(layShip, player, i)
		else
			loadMyShip(player)
		end

	end
end

-- 显示上面的信息
function loadTop(  )
	function updateLoadTime(  )
		local layTop = _mainWidget.LAY_TOP
		local nTime = WorldArenaModel.getAttackEndTime() - WorldArenaModel.getAttackStartTime()
		local curTime = TimeUtil.getSvrTimeByOffset(0)
		local timeAtk = WorldArenaModel.getAttackEndTime() - curTime
		local timeStr = TimeUtil.getTimeString(timeAtk)
		layTop.TFD_COUNTDOWN:setText(timeStr)
		layTop.LOAD_TIME:setPercent(timeAtk/nTime*100)
		if timeStr == "00:00:00" then
			WAEntryCtrl.create()
		end
	end
	updateLoadTime()
	GlobalScheduler.removeCallback("WAATKTIME")
	GlobalScheduler.addCallback("WAATKTIME", updateLoadTime)
	updateTop()
	
	UIHelper.labelNewStroke(_mainWidget.LAY_TOP.TFD_COUNTDOWN, ccc3(0x28, 0x00, 0x00))
end

-- 更新当前的击杀信息
function updateTop(  )
	local layTopKill = _mainWidget.LAY_TOP.LAY_INFO_KILL
	layTopKill.LAY_KILL.tfd_desc:setText("击杀数：")
	layTopKill.LAY_KILL.tfd_num:setText(WorldArenaModel.getMyKillNum())

	layTopKill.LAY_NOW.tfd_desc:setText("当前连杀：")
	layTopKill.LAY_NOW.tfd_num:setText(WorldArenaModel.getMyCurContiNum())

	layTopKill.LAY_HISTORY.tfd_desc:setText("最大连杀：")
	layTopKill.LAY_HISTORY.tfd_num:setText(WorldArenaModel.getMyMaxContiNum())

	UIHelper.labelNewStroke(layTopKill.LAY_KILL.tfd_desc, ccc3(0x28, 0x00, 0x00))
	UIHelper.labelNewStroke(layTopKill.LAY_KILL.tfd_num, ccc3(0x28, 0x00, 0x00))
	UIHelper.labelNewStroke(layTopKill.LAY_NOW.tfd_desc, ccc3(0x28, 0x00, 0x00))
	UIHelper.labelNewStroke(layTopKill.LAY_NOW.tfd_num, ccc3(0x28, 0x00, 0x00))
	UIHelper.labelNewStroke(layTopKill.LAY_HISTORY.tfd_desc, ccc3(0x28, 0x00, 0x00))
	UIHelper.labelNewStroke(layTopKill.LAY_HISTORY.tfd_num, ccc3(0x28, 0x00, 0x00))


end

-- 更新保护时间，冷却等
function updateBottom(  )
	local layMineCd = _mainWidget.LAY_INFO_CD
	layMineCd.tfd_protect_time:setText("保护时间：")

	function updateLoadTime(  )
		layMineCd.TFD_TIME1:setText(string.format("%s秒", WorldArenaModel.getProtectCd()))
		layMineCd.TFD_CD1:setText(WorldArenaModel.getAtkCD())
	end
	updateLoadTime()
	GlobalScheduler.removeCallback("WAPROTECTTIME")
	GlobalScheduler.addCallback("WAPROTECTTIME", updateLoadTime)


	layMineCd.tfd_attack_num:setText("进攻次数：")
	layMineCd.TFD_NUM1:setText(WorldArenaModel.getAtkNum())
	layMineCd.tfd_attack_cd:setText("进攻冷却：")

	UIHelper.labelNewStroke(layMineCd.tfd_protect_time, ccc3(0x28, 0x00, 0x00))
	UIHelper.labelNewStroke(layMineCd.TFD_TIME1, ccc3(0x28, 0x00, 0x00))
	UIHelper.labelNewStroke(layMineCd.TFD_CD1, ccc3(0x28, 0x00, 0x00))
	UIHelper.labelNewStroke(layMineCd.tfd_attack_num, ccc3(0x28, 0x00, 0x00))
	UIHelper.labelNewStroke(layMineCd.TFD_NUM1, ccc3(0x28, 0x00, 0x00))
	UIHelper.labelNewStroke(layMineCd.tfd_attack_cd, ccc3(0x28, 0x00, 0x00))

end

-- 添加和初始化船信息
function addShip( layShip, player, index)
	local layProtect = layShip.LAY_PROTECT
	layProtect.tfd_protect:setText("保护时间:")
    		
	local function updateProtect(  )
		local curTime = TimeUtil.getSvrTimeByOffset(-1)
		local protect_time = player.protect_time - curTime
		-- logger:debug({protect_time = protect_time})
		if tonumber(protect_time) > 0 then
			layProtect.TFD_PROTECT_TIME:setText(TimeUtil.getTimeString(protect_time))
			layShip.img_info_bg:setColor(ccc3(111,111,111))
		else
			layShip.img_info_bg:setColor(ccc3(255,255,255))
			layProtect:setEnabled(false)
		end
	end
	updateProtect()
	GlobalScheduler.removeCallback("WASHIPPROTECT" .. index)
	GlobalScheduler.addCallback("WASHIPPROTECT" .. index, updateProtect)
	-- layShip.img_touxiang:removeAllChildren()
	layShip.img_touxiang:removeAllNodes()
	local iconPath = HeroUtil.getHeroIconImgByHTID(player.figure)
	local clipNode = HeroUtil.createCircleAvatar(iconPath, 1) 

	-- local icon = HeroUtil.createHeroIconBtnByHtid(tonumber(player.figure))
	-- icon:setScale(0.6)
	layShip.img_touxiang:addNode(clipNode)

	layShip.LAY_RANKING.LABN_RANK_NUM:setStringValue(player.rank)
	layShip.LAY_RANKING.TFD_SERVER:setText("S." .. player.server_id)
	UIHelper.labelNewStroke(layShip.LAY_RANKING.TFD_SERVER, ccc3(0x6d, 0x00, 0x00))

	local layInfo = layShip.LAY_INFO
	layInfo.tfd_player_name:setText(player.uname)
	layInfo.tfd_player_name:setColor(UserModel.getPotentialColor({htid = player.figure}))
	layInfo.tfd_zhanli:setText("战力:")
	layInfo.tfd_fight_num:setText(player.fight_force)

	layInfo.LOAD_XUELIANG:setPercent(player.hp_percent/100)
	layShip.LAY_RANKING:requestDoLayout()
	local btnShip = layShip.BTN_SHIP
	btnShip:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			WAMainCtrl.onAtk(player, _tPlayer[4], index)
		end
	end)
	btnShip:removeAllNodes()
	UIHelper.addShipAnimation(btnShip,player.ship_figure,ccp(0,0),ccp(0.5,0.5),0.4,99,100 )
end

-- 加载自己的船炮
function loadMyShip(tSelfInfo)
	local imgSelfInfoBg = _mainWidget.img_self_info_bg
	imgSelfInfoBg.LABN_RANK_NUM:setStringValue(tSelfInfo.rank)
	imgSelfInfoBg.TFD_SERVER:setText("S." .. tSelfInfo.server_id)
	UIHelper.labelNewStroke(imgSelfInfoBg.TFD_SERVER, ccc3(0x6d, 0x00, 0x00))

	imgSelfInfoBg.tfd_player_name:setText(tSelfInfo.uname)
	imgSelfInfoBg.tfd_player_name:setColor(UserModel.getPotentialColor({htid = tSelfInfo.figure}))
	imgSelfInfoBg.tfd_zhanli:setText("战力:")
	imgSelfInfoBg.tfd_fight_num:setText(tSelfInfo.fight_force)

	local imgSelfBloodBg = _mainWidget.img_self_blood_bg
	imgSelfBloodBg.LOAD_XUELIANG:setPercent(tSelfInfo.hp_percent/100)

	imgSelfInfoBg.img_touxiang:removeAllNodes()
	local iconPath = HeroUtil.getHeroIconImgByHTID(tSelfInfo.figure)
	local clipNode = HeroUtil.createCircleAvatar(iconPath, 1) 
	imgSelfInfoBg.img_touxiang:addNode(clipNode)

	imgSelfInfoBg.LAY_RANKING:requestDoLayout()
end

-- 自己船信息
function resetMyShip( tbData )
	if WorldArenaModel.getMaxResetNumBySilver()- WorldArenaModel.getHaveResetNumBySilver() <= 0 then
		_mainWidget.BTN_BELLY_RECOVER:setGray(true)
		_mainWidget.BTN_BELLY_RECOVER:setTouchEnabled(false)
	end
	updateBellyResetTimes()
	local tSelfInfo = _tPlayer[4]
	tSelfInfo.hp_percent = 10000
	retSetMyShipInfo(tbData)
	loadMyShip(tSelfInfo)
end

function retSetMyShipInfo( tbData )
	local tSelfInfo = _tPlayer[4]
	tSelfInfo.uname = tbData.uname
	tSelfInfo.level = tbData.level
	tSelfInfo.vip = tbData.vip
	tSelfInfo.fight_force = tbData.fight_force
	tSelfInfo.figure = tbData.figure
	tSelfInfo.ship_figure = tbData.ship_figure
end


-- 是否可以回血
function getCanRestHp(  )
	local tSelfInfo = _tPlayer[4]
	local bReset = true
	if tonumber(tSelfInfo.hp_percent) == 10000 then
		bReset = false
	end
	return bReset
end


-- 回血次数UI
function updateBellyResetTimes(  )
	_mainWidget.BTN_GOLD_RECOVER.TFD_COST_NUM:setText(WorldArenaModel.getNextResetCostByGold())
	_mainWidget.BTN_BELLY_RECOVER.TFD_COST_NUM:setText(WorldArenaModel.getNextResetCostBySilver()/10000)

	UIHelper.labelNewStroke(_mainWidget.BTN_GOLD_RECOVER.TFD_COST_NUM, ccc3(0x33, 0x0e, 0x05))
	UIHelper.labelNewStroke(_mainWidget.BTN_BELLY_RECOVER.TFD_COST_NUM, ccc3(0x33, 0x0e, 0x05))

	local layTimes = _mainWidget.BTN_BELLY_RECOVER.LAY_TIMES
	layTimes.tfd_shengyu:setText("剩余:")
	layTimes.TFD_TIMES:setText(string.format("%s次", WorldArenaModel.getMaxResetNumBySilver()- WorldArenaModel.getHaveResetNumBySilver()))
	UIHelper.labelNewStroke(layTimes.TFD_TIMES, ccc3(0x28, 0x00, 0x00))
	UIHelper.labelNewStroke(layTimes.tfd_shengyu, ccc3(0x28, 0x00, 0x00))
end

-- 选择框
function checkBox(  )
	local checkBox = _mainWidget.LAY_SKIP.CBX_TICK
	checkBox:setSelectedState(WorldArenaModel.getSkipData())
	checkBox:addEventListenerCheckBox(function ( sender, eventType )
				if (eventType == CHECKBOX_STATE_EVENT_SELECTED) then
					AudioHelper.playCommonEffect()
					WorldArenaModel.setSkipData(true)
				else
					AudioHelper.playCommonEffect()
					WorldArenaModel.setSkipData(false)
				end
			end)
end

-- 船头上下浮动的效果
function runBigBoatAction( )
	_mainWidget.img_my_ship:stopAllActions()
	local arrActions = CCArray:create()
	arrActions:addObject(CCMoveBy:create(1.0,ccp(0,18)))
	arrActions:addObject(CCMoveBy:create(1.0,ccp(0,-18)))
	local sequence = CCSequence:create(arrActions)
	local repeatSequence = CCRepeatForever:create(sequence)
	_mainWidget.img_my_ship:runAction(repeatSequence)
end

--添加船炮特效资源
function addFireEffect( )
	local file_Path = "images/effect/worldArena/peak_showdown6.ExportJson"
	_armature = UIHelper.createArmatureNode({
			filePath = file_Path,
		})
	_image = ImageView:create()
	_image:loadTexture("ui/transfer_arrow_right.png")
	_mainWidget.img_my_ship.img_gun_bottom1:addChild(_image)
	_image:addNode(_armature)
end

-- 播放攻击动作
function playFireEffect(index)
	LayerManager.addUILayer()
	_nIndex = index
	local fnFrameCall = function ( bone, frameEventName, originFrameIndex, currentFrameIndex )
				if frameEventName == "1" then
					playBoomFireEffect() -- 播放开炮炮光
				elseif frameEventName == "2" then
					shakeScreen() -- 播放震屏
				end
			end
	_armature:getAnimation():setFrameEventCallFunc(fnFrameCall)

	local fRotate = 0
	if _nIndex == 1 then
		fRotate = -30
	elseif _nIndex == 3 then
		fRotate = 30
	else
		fRotate = 0
	end
	function runRoatateAction(  )
		local rotate = CCRotateTo:create(30/60, fRotate)
		local callback = CCCallFunc:create(function ( ... )
				_armature:getAnimation():play("peak_showdown6", -1, -1)
		end)
		local array = CCArray:create()
		array:addObject(rotate)
		array:addObject(callback)
		local seq = CCSequence:create(array)
		_image:runAction(seq)
		AudioHelper.playEffect("audio/effect/peak_showdown6.mp3")
	end
	runRoatateAction()
end

-- 震屏
function shakeScreen(  )
	local runningScene = CCDirector:sharedDirector():getRunningScene()
	local arr = CCArray:create()
	arr:addObject(CCMoveBy:create(1/60, ccp(0, -20)))
	arr:addObject(CCMoveBy:create(8/60, ccp(0, 20)))
	local seq = CCSequence:create(arr)
    runningScene:runAction(seq)
end


-- 播放开炮炮光
function playBoomFireEffect()
	local file_Path = "images/effect/worldArena/peak_showdown5.ExportJson"
	local armature = UIHelper.createArmatureNode({
			filePath = file_Path,
			animationName = "peak_showdown5",
			fnMovementCall = function ( armature, MovementEventType , frameEventName)
				if (MovementEventType == 1) then
					armature:removeFromParentAndCleanup(true)
				end
			end,
			fnFrameCall = function ( bone, frameEventName, originFrameIndex, currentFrameIndex )
				if frameEventName == "2" then
					playBoatBoomEffect()
				end
			end,
		})
	_image:addNode(armature)
	armature:setPosition(ccp(0,200))
	AudioHelper.playEffect("audio/effect/peak_showdown5.mp3")
end

-- 播放敌方小船爆炸动画
function playBoatBoomEffect()
	local file_Path = "images/effect/worldArena/peak_showdown4.ExportJson"
	local armature = UIHelper.createArmatureNode({
			filePath = file_Path,
			animationName = "peak_showdown4",
			fnMovementCall = function ( armature, MovementEventType , frameEventName)
				if (MovementEventType == 1) then
					armature:removeFromParentAndCleanup(true)
					loadAll()
					LayerManager.removeUILayer()
				end
			end,
			fnFrameCall = function ( bone, frameEventName, originFrameIndex, currentFrameIndex )
				if frameEventName == "1" then
					_mainWidget.LAY_SHIP["LAY_PLAYER" .. _nIndex]:setEnabled(false)
				end
			end,
		})
	_mainWidget.LAY_SHIP["IMG_BOOM" .. _nIndex]:addNode(armature)
	
	AudioHelper.playEffect("audio/effect/peak_showdown4.mp3")
end

--[[desc: 功能按钮动画
    arg1: type=1 执行打开动画。type＝0 关闭动画
    return: 是否有返回值，返回值说明  
—]]
function updateSecMenuBtnByType( type )
	if (not _mainWidget) then return end

	AudioHelper.playBtnEffect("anniu_gongneng_zhankai.mp3")

	if (type==1) then 
		_mainWidget.BTN_FUNCTION_OPEN:setTouchEnabled(false)
		local delay = CCDelayTime:create(1*FRAME_TIME)
		local rotate1 = CCRotateTo:create(15*FRAME_TIME*18/19,180)
		local rotate11 = CCRotateTo:create(15*FRAME_TIME*1/19,190)
		local rotate2 = CCRotateTo:create(10*FRAME_TIME,180)
		local callback = CCCallFunc:create(function ( ... )
			_mainWidget.BTN_FUNCTION_OPEN:setTouchEnabled(true)
		end)
		local array = CCArray:create()
		array:addObject(delay)
		array:addObject(rotate1)
		array:addObject(rotate11)
		array:addObject(rotate2)
		array:addObject(callback)
		local seq = CCSequence:create(array)
		_mainWidget.BTN_FUNCTION_OPEN:runAction(seq)
	else
		_mainWidget.BTN_FUNCTION_OPEN:setTouchEnabled(false)
		local delay = CCDelayTime:create(3*FRAME_TIME)
		local rotate1 = CCRotateTo:create(16*FRAME_TIME*18/19,0)
		local rotate11 = CCRotateTo:create(16*FRAME_TIME*1/19,-10)
		local rotate2 = CCRotateTo:create(10*FRAME_TIME,0)
		local callback = CCCallFunc:create(function ( ... )
			_mainWidget.BTN_FUNCTION_OPEN:setTouchEnabled(true)
		end)
		local array = CCArray:create()
		array:addObject(delay)
		array:addObject(rotate1)
		array:addObject(rotate11)
		array:addObject(rotate2)
		array:addObject(callback)
		local seq = CCSequence:create(array)
		_mainWidget.BTN_FUNCTION_OPEN:runAction(seq)
	end 
end


function updateBetRedPoint(  )
	if _mainWidget and _mainWidget.IMG_POINT then
		_mainWidget.IMG_POINT:setEnabled(WABetModel.getIsShowRedPoint())
	end
end

-- 接收跑马灯的推送
function reBroadcast(cbFlag, dictData, bRet )
	logger:debug({broadcast = dictData})
	local bEnabled = _mainWidget.img_paomadeng_bg:isEnabled()
	if not bEnabled then
		showBroadcast(dictData.ret)
	end
end

-- 显示跑马灯
function showBroadcast( tData )
	-- local tData = {
	--  		 kill_num = "5",
 --              conti_num = "5",
 --              attacker_name = "101",
 --              attacker_figure ="10173",
 --              defender_name = "mbg20843",
 --              defender_figure = "10173",
	-- }
	local tRichText = WAUtil.getBroardcastContent(tData)
	local imgBg = _mainWidget.img_paomadeng_bg
	imgBg.LAY_INFO:setClippingEnabled(true)
	imgBg:setEnabled(true)

	UIHelper.registExitAndEnterCall(imgBg, function (  )
		local function release(  )
			local removeRichText = table.remove(tRichText)
			removeRichText:release()
			if next(tRichText) then
				release()
			end
		end
	end)
	local function playBroadcast ( ... )
		local richText = table.remove(tRichText)
		richText:setPosition(ccp(imgBg:getSize().width,16))
		imgBg.LAY_INFO:addChild(richText)
		-- 移动动作
	 	local actionArray = CCArray:create()
	  	actionArray:addObject(CCMoveBy:create(15*g_fScaleX, ccp(-richText:getSize().width - imgBg:getSize().width, 0)))
	  	actionArray:addObject(CCCallFunc:create(function ( ... )
	  		if next(tRichText) then
				imgBg:setEnabled(true)
				playBroadcast()
			else
				imgBg:setEnabled(false)
	  		end
	  		richText:release()
	  		richText:removeFromParentAndCleanup(true)
	  	end))
	  	richText:runAction(CCSequence:create(actionArray))
	end
	playBroadcast()
end

-- 增加接收推送回调
function addPush(  )
	Network.re_rpc(reBroadcast, "push.worldarena.broadcast", "push.worldarena.broadcast")
end

-- 移除
function removePush(  )
	Network.remove_re_rpc("push.worldarena.broadcast")
end

