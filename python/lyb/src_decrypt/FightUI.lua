
FightUI = class(Layer);

function FightUI:ctor()
  self.class = FightUI;
  self.movieClip1 = nil;
  self.movieClip2 = nil;
  -- self.movieClip3 = nil;
  self.movieClip4 = nil;
  self.movieClip5 = nil;
  self.skillItemArray = {}
  self.dropItemArr = {};
  require "core.utils.SpineCartoon"
end

function FightUI:dispose()
	if self.battleProxy.greenHandBattle then
		self.battleProxy.greenHandBattle:dispose()
		self.battleProxy.greenHandBattle = nil
	end
	if self.battleProxy.battleScriptPlayer then
		self.battleProxy.battleScriptPlayer:dispose()
		self.battleProxy.battleScriptPlayer = nil
	end
	if self.refreshTime then
		self.refreshTime:dispose();
		self.refreshTime = nil
	end
    self:removeAllEventListeners();
    self:removeChildren();
    self:removeExitTimer();
    FightUI.superclass.dispose(self);
    self.skillItemArray = nil
	self.movieClip1:dispose();
	self.movieClip1 = nil;
	self.movieClip2:dispose();
	self.movieClip2 = nil;
	-- self.movieClip3:dispose();
	self:removeTutorTimeOut()
	self.movieClip4:dispose();
	self.movieClip4 = nil;
	self.movieClip5:dispose();
	self.movieClip5 = nil;		
	if self.daojuDrop then
		self.daojuDrop:dispose()
		self.daojuDrop = nil
	end
	BitmapCacher:removeUnused() --移除image及其它可以引用为1的纹理	
	self.battleProxy.skillItemArrayTemp = nil
end


function FightUI:onInit(skeleton,battleProxy,userProxy,openFunProxy,operatonProxy,storyLineProxy)
	self.battleProxy = battleProxy;
	self.skeleton = skeleton;
	self.openFunctionProxy = openFunProxy
	self.userProxy=userProxy;
	self.operatonProxy = operatonProxy;
	self.storyLineProxy = storyLineProxy;
    self:initLayer();
	self:initMovieClip()
	self:initMovieClip5Data()
	self:initMovieClip1Data()
	self:initMovieClip2Data()
	-- self:initMovieClip3Data()
	self:initMovieClip4Data()
	if battleProxy.battleType ~= BattleConfig.BATTLE_TYPE_4 then
		self:initSkillCard();
	end
	require "main.view.battleScene.function.ScreenMove"
	ScreenMove:initChildIndex(battleProxy)
end

function FightUI:initMovieClip()
	local winSize = Director:sharedDirector():getWinSize();
    local movieClip1 = MovieClip.new();
    movieClip1:initFromFile("battle_ui", "battleui_1");
    movieClip1:gotoAndPlay("f1");
    movieClip1.layer:setPositionXY(-1 * GameData.uiOffsetX,GameData.uiOffsetY)    
    self:addChild(movieClip1.layer);
    movieClip1:update();
    self.movieClip1 = movieClip1;

    local movieClip2 = MovieClip.new();
    movieClip2:initFromFile("battle_ui", "battleui_2");
    movieClip2:gotoAndPlay("f1");
    movieClip2.layer:setPositionXY(GameData.uiOffsetX,GameData.uiOffsetY)    
    self:addChild(movieClip2.layer);
    movieClip2:update();
    self.movieClip2 = movieClip2;

    -- local movieClip3 = MovieClip.new();
    -- movieClip3:initFromFile("battle_ui", "battleui_3");
    -- movieClip3:gotoAndPlay("f1");
    -- movieClip3.layer:setPositionXY(GameData.uiOffsetX, -1 * GameData.uiOffsetY)    
    -- self:addChild(movieClip3.layer);
    -- movieClip3:update();
    -- self.movieClip3 = movieClip3;

    local movieClip4 = MovieClip.new();
    movieClip4:initFromFile("battle_ui", "battleui_4");
    movieClip4:gotoAndPlay("f1");
    movieClip4.layer:setPositionXY(-1 * GameData.uiOffsetX,-1 * GameData.uiOffsetY)
    self:addChild(movieClip4.layer);
    movieClip4:update();
    self.movieClip4 = movieClip4;

    local movieClip5 = MovieClip.new();
    movieClip5:initFromFile("battle_ui", "battleui_5");
    movieClip5:gotoAndPlay("f1");
    movieClip5.layer:setPositionXY((winSize.width - GameConfig.STAGE_WIDTH) / 2, GameData.uiOffsetY)
    self:addChild(movieClip5.layer);
    movieClip5:update();
    self.movieClip5 = movieClip5;
    self.skillButtonLayer = Layer.new()
    self.skillButtonLayer:initLayer()
    self.skillButtonLayer:setPositionY(-GameData.uiOffsetY*2)
    movieClip5.layer:addChildAt(self.skillButtonLayer,0)
end

function FightUI:initMovieClip1Data()
	local armature_d1 = self.movieClip1.armature.display;
	self.armature_d1 = armature_d1
	self.stopButton = armature_d1:getChildByName("stop_button");
	SingleButton:create(self.stopButton, nil, 0);

    local text_data = self.movieClip1.armature:getBone("diren_text").textData;
    self.direnText = createTextFieldWithTextData(text_data,"",true);
    self.armature_d1:addChild(self.direnText);
end

function FightUI:initMovieClip2Data()
	self.armature_d2 = self.movieClip2.armature.display;

    local text_data = self.movieClip2.armature:getBone("baoxiang_text").textData;
    self.baoxiangText = createTextFieldWithTextData(text_data,"0");
    self.armature_d2:addChild(self.baoxiangText);

    local text_data = self.movieClip2.armature:getBone("yinliang_text").textData;
    self.yinliangText = createTextFieldWithTextData(text_data,"0");
    self.armature_d2:addChild(self.yinliangText);
    
	local button_orange=self.armature_d2:getChildByName("common_copy_small_orange_button");
	self.button_orange_pos=convertBone2LB4Button(button_orange);
	self.armature_d2:removeChild(button_orange);
end

function FightUI:initTiaoGuoButtion()
	if self.tiaoGuoBtn then return end
	self.tiaoGuoBtn=getImageByArtId(1669)
	self.tiaoGuoBtn:setPositionXY(self.button_orange_pos.x+100,self.button_orange_pos.y+GameData.uiOffsetY+30);
	self.tiaoGuoBtn.touchEnabled = true
	self.tiaoGuoBtn:setAnchorPoint(CCPointMake(0.5,0.5))
	self.tiaoGuoBtn:addEventListener(DisplayEvents.kTouchBegin,self.onTiaoGuoBegin,self);
	sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_TOP):addChild(self.tiaoGuoBtn);
end

function FightUI:initMovieClip4Data()
	local armature_d4 = self.movieClip4.armature.display;
	self.goButton = armature_d4:getChildByName("gogogo")
    self.goButton:setVisible(false)
    self.goButton.touchEnabled = false
    self.goButton.touchChildren = false

	self.handButton = armature_d4:getChildByName("hand_button")
	SingleButton:create(self.handButton, nil, 0);
	self.handButton:addEventListener(DisplayEvents.kTouchTap,self.onHandButtonTap,self);
	-- self.autohButton = armature_d4:getChildByName("autoh_button")
	-- SingleButton:create(self.autohButton, nil, 0);
	-- self.autohButton:addEventListener(DisplayEvents.kTouchTap,self.onHandhButtonTap,self);
	self.autoButton = armature_d4:getChildByName("auto_button")
	SingleButton:create(self.autoButton, nil, 0);
	self.autoButton:addEventListener(DisplayEvents.kTouchTap,self.onAutoButtonTap,self);

	-- 读写文件有延迟
	local autoButton = self.battleProxy.battleFieldId ~= 1 and GameData.local_autoButton or "";
	local autoButtonType = self:getAutoType(autoButton)
	self:switchButton(autoButtonType)
end

function FightUI:guideAutoButton()
	if self.battleProxy.battleFieldId and self.battleProxy.battleFieldId == 10002001 then
		if self.storyLineProxy:getStrongPointState(self.battleProxy.battleFieldId) ~= 1 then
			self:guideOpenTutorUI()
			self.isGuideAuto = true
		end
	end
end

function FightUI:guideClickButton()
	if not self.isGuideAuto then return end
	self.isGuideAuto = nil
	self:removeTutorTimeOut()
	self:setDC()
end

function FightUI:setDC()
	if self.battleProxy.guideHecDCNumber then
		hecDC(5,self.battleProxy.guideHecDCNumber)
	end
end

function FightUI:guideOpenTutorUI()
	BattleUtils:setGuideHecDCNumber(self.battleProxy)
	local position = self.autoButton:getPosition()
	openTutorUI({x=position.x-GameData.uiOffsetX-55, y=position.y-GameData.uiOffsetY-70, width = 120, height = 120, alpha = 125,isBattle = true,step=self.battleProxy.guideHecDCNumber});
	self:removeStopBattleTimer()
	local function stopBattleTimerFun()
		self.battleProxy.AIBattleField:onPauseScript()
		self:removeStopBattleTimer()
	end
	local time = BattleUtils:getGuideStopTime(self.battleProxy)
	self.stopBattleTimer = Director:sharedDirector():getScheduler():scheduleScriptFunc(stopBattleTimerFun, time, false)
end

function FightUI:removeStopBattleTimer()
    if self.stopBattleTimer then
        Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.stopBattleTimer);
        self.stopBattleTimer = nil
    end
end


function FightUI:removeTutorTimeOut()
      if self.tutorTimeOut then
          Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.tutorTimeOut);
          self.tutorTimeOut = nil;
      end
end

function FightUI:getAutoType(autoButton)
	if not autoButton or "" == autoButton then
		return nil
	end

	local serverId,account = self:getAutoData()
	local autoButtonArr = StringUtils:lua_string_split(autoButton,"_");

	if autoButtonArr[1] == serverId and autoButtonArr[2] == account then
		return autoButtonArr[3]
	end
end

function FightUI:initMovieClip5Data()
	local armature_d5 = self.movieClip5.armature.display;
	local mainCard=armature_d5:getChildByName("common_copy_button_bg1");
	armature_d5:removeChild(mainCard);

	local heroCard=armature_d5:getChildByName("common_copy_button_bg2");
	self.heroCardP=convertBone2LB(heroCard);
	armature_d5:removeChild(heroCard);

	local timePic=armature_d5:getChildByName("common_copy_biaoti_new");
	armature_d5:setChildIndex(timePic,0)

	self.exitBackground = LayerColorBackGround:getTransBackGround()
	self.exitBackground:setScale(2)
	self.exitBackground:setPositionY(-GameData.uiOffsetY*2)
	armature_d5:addChildAt(self.exitBackground,2)
	
	self.exitButton = armature_d5:getChildByName("exitbutton");
	SingleButton:create(self.exitButton, nil, 0);
	self.exitButton:addEventListener(DisplayEvents.kTouchEnd,self.onExitEnd,self);
	self.exitButton:addEventListener(DisplayEvents.kTouchBegin,self.onExitBegin,self);
	armature_d5:setChildIndex(self.exitButton,100)

	self.backButton = armature_d5:getChildByName("backbutton");
	SingleButton:create(self.backButton, nil, 0);
	self.backButton:addEventListener(DisplayEvents.kTouchEnd,self.onBackEnd,self);
	self.backButton:addEventListener(DisplayEvents.kTouchBegin,self.onBackBegin,self);
	armature_d5:setChildIndex(self.backButton,100)

    self.forceButton = armature_d5:getChildByName("force_button");
	if GameData.platFormID == GameConfig.PLATFORM_CODE_LAN or GameData.platFormID == GameConfig.PLATFORM_CODE_IOS_BASE then
		SingleButton:create(self.forceButton, nil, 0);
		self.forceButton:addEventListener(DisplayEvents.kTouchBegin,self.onForceBeginTap,self);
		self.forceButton:addEventListener(DisplayEvents.kTouchEnd,self.onForceEndTap,self);
	else
		self.forceButton:setVisible(false)
	end
	armature_d5:setChildIndex(self.forceButton,100)
	self:setExitVisible(false)

	local time = analysis("Zhandoupeizhi_Zhanchangpeizhi",self.battleProxy.battleFieldId,"longestTime");
	local tempTime = RefreshTime.new()
	tempTime:setTotalTime(time,3)

	local text_data = self.movieClip5.armature:getBone("time_text").textData;
	self.timeText = createTextFieldWithTextData(text_data,tempTime:getTimeStr());
	armature_d5:addChildAt(self.timeText,2);
	self.timeTextData = text_data
	self.armature_d5 = armature_d5
end

function FightUI:setTiaoGuoVisible(bool)
	self:initTiaoGuoButtion()
	self.tiaoGuoBtn:setVisible(bool)
end

function FightUI:onTiaoGuoBegin(event)
	self.tiaoGuoBtn:addEventListener(DisplayEvents.kTouchEnd,self.onTiaoGuoTap,self);
	self.tiaoGuoBtn:setScale(1.1)
end

function FightUI:onTiaoGuoTap()
	self.battleProxy:onTiaoGuoTap()
	self.tiaoGuoBtn:setScale(1)
end

function FightUI:onForceBeginTap()
	if self.directorPause then
		Director:sharedDirector():resume()
		self.directorPause = nil
		if self.refreshTime then
			self.refreshTime:dispose();
			self.refreshTime = nil
		end
	end
end

function FightUI:onForceEndTap()
	sendMessage(100,1,{BattleId = self.battleProxy.battleId})
	self:setExitVisible(false)
end

function FightUI:addExitButtonListener()
	self.stopButton:addEventListener(DisplayEvents.kTouchEnd,self.onStopEnd,self);
end

function FightUI:addYinliang(yinliangCount)
	local count = tonumber(self.yinliangText:getString())
	count = count + yinliangCount
	if count > self.battleProxy.diaoLuoDaoYiLiangNum then 
		count = self.battleProxy.diaoLuoDaoYiLiangNum
	end
	self.yinliangText:setString(math.floor(count))
end

function FightUI:addBaoxiang(baoXiangCount)
	local count = tonumber(self.baoxiangText:getString())
	count = count + baoXiangCount
	if count > self.battleProxy.diaoLuoDaoJuNum then 
		count = self.battleProxy.diaoLuoDaoJuNum
		return 
	end
	self.baoxiangText:setString(count)
end

------------------------退出界面-----------------开始--------
function FightUI:setExitVisible(bool)
	self.backButton:setVisible(bool)
	self.exitButton:setVisible(bool)
	self.exitBackground:setVisible(bool)

	if GameData.platFormID == GameConfig.PLATFORM_CODE_LAN or GameData.platFormID == GameConfig.PLATFORM_CODE_IOS_BASE then
		self.forceButton:setVisible(bool)
	end
end

function FightUI:onExitEnd(event)
	if not self.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_42) then
		return
	end
	self.battleProxy:cleanAIBattle()
	self:removeExitTimer()
	local function exitTimerFun()
		self:removeExitTimer()
		print(GameData.isConnect)
		if GameData.isConnect then
			sendMessage(7,23)
			self:dispatchEvent(Event.new("CLOSE_BATTLE_OVER",{battleType = self.battleProxy.battleType},self));
		end
	end
	self.exitButton:removeEventListener(DisplayEvents.kTouchEnd,self.onExitEnd,self);
	self.exitButton:removeEventListener(DisplayEvents.kTouchBegin,self.onExitBegin,self);
	self.exitTimer = Director:sharedDirector():getScheduler():scheduleScriptFunc(exitTimerFun, 0.1, false)
end

function FightUI:removeExitTimer()
    if self.exitTimer then
        Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.exitTimer);
        self.exitTimer = nil
    end
end

function FightUI:onExitBegin(event)
	if self.directorPause then
		self.directorPause = nil
		Director:sharedDirector():resume()
		if not self.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_42) then
			local tipString = analysis("Gongnengkaiqi_Gongnengkaiqi", FunctionConfig.FUNCTION_ID_42, "generals")
			sharedTextAnimateReward():animateStartByString(tipString.."级之前不能退出!");
			self:setExitVisible(false)
			return
		end
		if self.refreshTime then
			self.refreshTime:dispose();
			self.refreshTime = nil
		end
		MusicUtils:playEffect(7)
		self.battleProxy:cleanAIBattle()
	end
end

function FightUI:onBackBegin(event)
	if self.directorPause then
		Director:sharedDirector():resume()
		self.directorPause = nil
		MusicUtils:playEffect(7)
	end
end

function FightUI:onBackEnd(event)
	self:setExitVisible(false)
end

function FightUI:onStopEnd(event)
	if not self.directorPause then
		Director:sharedDirector():pause()
		self.directorPause  = true
		self:setExitVisible(true)
		MusicUtils:playEffect(7)
		self:removeExitTimer()
	end
end
local function sortOnItem(a, b) return a.standPosition > b.standPosition end
------------------------退出界面-----------------结束--------
function FightUI:initSkillCard(isScript)
	local len = 0
	local gap = 170
	local wave = self.battleProxy:getCurWave()
	local curArray = {}
	for key,unit in pairs(self.battleProxy.myHeroRoleArray) do
		if unit.wave <= wave then
			table.insert(curArray,unit)
		end
	end
	table.sort(curArray,sortOnItem)
	local px = self:getCardPositionX(curArray,gap)
	require "main.view.battleScene.ui.FightUISkillItem"
	for k1,v1 in pairs(curArray) do
		local skillItem;
		if self.skillItemArray[v1.battleUnitID] then
			skillItem = self.skillItemArray[v1.battleUnitID]
		else
			skillItem = FightUISkillItem.new()
			skillItem:initialize(self.skeleton,v1,self)
			self.skillItemArray[v1.battleUnitID] = skillItem
			self.skillButtonLayer:addChildAt(skillItem,0)
			skillItem.scriptPlaceTemp = k1--脚本使用
		end
		if isScript then
			skillItem:setItemDark()
			skillItem:startAllAction(90000)
		end
		skillItem:setPositionXY(px + gap*len,self.heroCardP.y)
		len = len + 1;
	end
	self.battleProxy.skillItemArrayScriptTemp = self.skillItemArray--脚本使用
end

function FightUI:getCardPositionX(myHeroRoleArray,gap)
	local totalHeroNum = #myHeroRoleArray
	local allCardWidth = totalHeroNum*gap
	local halfX = (GameConfig.STAGE_WIDTH - allCardWidth)/2
	return halfX+10
end

------------------------界面数据初始化-----------------结束--------EEE

------------------------自动与手动切换-----------------开始--------


function FightUI:switchButton(buttonType)
	self.handButton:setVisible(false)
	-- self.autohButton:setVisible(false)
	self.autoButton:setVisible(false)

	if buttonType == nil or buttonType == "1" or buttonType == "" then
		self.handButton:setVisible(true)
	-- elseif buttonType == "2" then
		-- self.autohButton:setVisible(true)
	elseif buttonType == "3" or buttonType == "2" then
		self.autoButton:setVisible(true)
	end
	self.handButton:setScale(1)
	-- self.autohButton:setScale(1)
	self.autoButton:setScale(1)
	self.battleProxy:setSelectSkillTag(tonumber(buttonType))
	self.buttonType = buttonType
	require "main.controller.command.tutor.TutorCloseCommand";
	closeTutorUI()
	if not self.battleProxy.AIBattleField then return end
	self.battleProxy.AIBattleField:onContinueScript()
	self:guideClickButton()
end

function FightUI:onHandButtonTap(event)
	if self.storyLineProxy:getStrongPointState(10001004) ~= 1 then
		sharedTextAnimateReward():animateStartByString("自动战斗会在主线《金陵偶遇》关卡中开启");
		return
	end
	local serverId,account = self:getAutoData()
	saveLocalInfo("autoButton",serverId.."_"..account.."_".."3")
	self:switchButton("3")
end

-- function FightUI:onHandhButtonTap(event)
-- 	local serverId,account = self:getAutoData()
-- 	saveLocalInfo("autoButton",serverId.."_"..account.."_".."3")
-- 	self:switchButton("3")
-- end

function FightUI:onAutoButtonTap(event)
	local serverId,account = self:getAutoData()
	saveLocalInfo("autoButton",serverId.."_"..account.."_".."1")
	self:switchButton("1")
end

function FightUI:getAutoData()
	return GameData.ServerId,tostring(self.userProxy.userId)
end

function FightUI:canNotPlayAllSkill()
	return self.buttonType == "3"
end

function FightUI:canNotPlayOneSkill()
	return self.buttonType == "2"
end

------------------------自动与手动切换-----------------结束--------

------------------------战斗倒计时-----------------------开始--------
function FightUI:cdTimeFun()
	local totalTime = self.refreshTime.totalTime
    if totalTime <= 0 then
        self.refreshTime:dispose();
        self:addLastTimeText(0)
    elseif totalTime > 9 then
		self.timeText:setString(self.refreshTime:getTimeStr())
    else
    	self.timeText:setVisible(false)
    	self:addLastTimeText(totalTime)
    end
    self.battleProxy.battleOverUseTime = self.battleOverTotalTime - totalTime
end

function FightUI:addLastTimeText(timeNum)
	if self.lastTimeText then
		self.armature_d5:removeChild(self.lastTimeText)
	end
	if self.stopTimeText then
		self.armature_d5:removeChild(self.stopTimeText)
	end
	self.lastTimeText = self.skeleton:getBoneTextureDisplay("lianji_"..timeNum)
	self.lastTimeText:setAnchorPoint(CCPointMake(0.5,0.5))
	self.lastTimeText:setPositionXY(self.timeTextData.x+87,self.timeTextData.y+25)
	self.lastTimeText:setScale(0.8)
	self.armature_d5:addChild(self.lastTimeText)
	if timeNum == 0 then return end
	self.lastTimeText:setAlpha(0)
	self:lastTimeTextAction()
end

function FightUI:add_Time_Text()
	if not self.refreshTime then return end
	local totalTime = self.refreshTime.totalTime
	if totalTime > 9 then return end
	self.stopTimeText = self.skeleton:getBoneTextureDisplay("lianji_"..totalTime)
	self.stopTimeText:setAnchorPoint(CCPointMake(0.5,0.5))
	self.stopTimeText:setPositionXY(self.timeTextData.x+87,self.timeTextData.y+25)
	self.stopTimeText:setScale(0.8)
	self.armature_d1:addChild(self.stopTimeText)
end

function FightUI:lastTimeTextAction()
	local upArray = CCArray:create();
	local array = CCArray:create();
	local delay = CCDelayTime:create(0.4)
	local scale1 = CCScaleTo:create(0.4,1.2);
	local fadeTo = CCFadeTo:create(0.4, 0);
	local fadeTo1 = CCFadeTo:create(0.2, 255);
	upArray:addObject(scale1);
	upArray:addObject(fadeTo);
	local upSpawn = CCEaseSineInOut:create(CCSpawn:create(upArray),0.4);
	array:addObject(fadeTo1)
	array:addObject(delay)
	array:addObject(upSpawn)
	self.lastTimeText:runAction(CCSequence:create(array))
end

function FightUI:fightUIActivite()
	if not self.refreshTime then 
		self.battleOverTotalTime = analysis("Zhandoupeizhi_Zhanchangpeizhi",self.battleProxy.battleFieldId,"longestTime");
	    self.refreshTime = RefreshTime.new();
	    self.refreshTime:initStopBattleTime(self.battleOverTotalTime , self.cdTimeFun,self,3);
    end
 --    self:initClickBattleLayer()
    self:addExitButtonListener()
    -- self.fightUIPower:startAddPowerTimer()
    for key,item in pairs(self.skillItemArray) do
		item:startAllAction()
	end
	self:guideAutoButton()
	self:refreshDirenText()
end

function FightUI:stopTimer()
	if self.refreshTime then
		self.refreshTime:dispose();
	end
	if self.exitButton then
		self.exitButton.touchEnabled=false
	    self.exitButton.touchChildren=false;
    end
end

function FightUI:setTimerNumber()
	if self.refreshTime then
		self.refreshTime:setTotalTime(0,3)
	end
	if self.exitButton then
		self.exitButton.touchEnabled=false
	    self.exitButton.touchChildren=false;
    end
end

------------------------战斗倒计时-----------------------结束--------

function FightUI:playBeginAttackEffect(battleUnitID,attackSkillId)
	local skillVO = analysis("Jineng_Jineng",attackSkillId)
	if skillVO.typyP ~= 3 and skillVO.typyP ~= 2 then
		self.battleProxy:onSkillContinue(self.battleProxy.battleGeneralArray[battleUnitID]);
	else
		if not self.attackBigEffect then
			require "main.view.battleScene.function.AttackBigEffect"
			self.attackBigEffect = AttackBigEffect.new()
		end
		local generalVO = self.battleProxy.battleGeneralArray[battleUnitID]
		self.attackBigEffect:playEffectData(generalVO,skillVO,self.battleProxy)
	end
end

function FightUI:onActionUI()
	self:refreshDirenText()
end

function FightUI:refreshDirenText()
	if self.battleProxy.AIBattleField then
		self.direnText:setString("第 "..self.battleProxy.AIBattleField:getCurWave().."/"..self.battleProxy.AIBattleField:getMaxRound().." 波")
	end
end

------------------------刷新所有单位血量-----------------------开始--------
function FightUI:refreshHpData(roleVO)
	if not roleVO  then return;end
	if self.skillItemArray[roleVO.battleUnitID] then
		self.skillItemArray[roleVO.battleUnitID]:refreshHpData()
	end
end

function FightUI:refreshRangeData(roleVO)
	if self.skillItemArray[roleVO.battleUnitID] then
		self.skillItemArray[roleVO.battleUnitID]:refreshRangeData()
	end
end

------------------------刷新所有单位血量-----------------------结束--------

------------------------如果是Boss设置数据-----------------开始--------
function FightUI:progressBarAnimationElite(roleVO,secondPro)
	local moveBy = CCMoveTo:create(0.5, ccp(secondPro:getPositionX(), self.scoreProgressRightDOY))
	local action = CCEaseSineOut:create(moveBy,0.5)
	secondPro:runAction(action);
	self.hpProgressRight:init(1,-0.0071111,nil,nil,nil,nil,true)
	self.hpProgressRightDown:init(1,-0.0031111,nil,nil,nil,nil,true)

	local guaiwuPO = analysis("Guaiwu_Guaiwubiao",roleVO.generalID);
	local headId = guaiwuPO.headId ~= 0 and guaiwuPO.headId or 1003
	if self.eliteHeadImage then
		self.scoreProgressRightDO:removeChild(self.eliteHeadImage)
	end
	self.eliteHeadImage = getImageByArtId(headId)
	self.eliteHeadImage:setPositionXY(448,-122)
	self.eliteHeadImage:setScale(1.15)
	self.scoreProgressRightDO:addChild(self.eliteHeadImage)

	self.eliteNameText:setString(roleVO.name)
	self.elitelevelText:setString("Lv "..roleVO.level)
end

function FightUI:progressBarAnimationBoss(roleVO,secondPro,proNum)
	local moveBy = CCMoveTo:create(0.5, ccp(secondPro:getPositionX(), self.scoreProgressRightDOY))
		local action = CCEaseSineOut:create(moveBy,0.5)
	secondPro:runAction(action);
end

function FightUI:refreshDropDaoju(dropDaojuArray,position)
	require "main.view.battleScene.function.DaojuDrop"
	if not self.daojuDrop then
		self.daojuDrop = DaojuDrop.new()
	end
	self.daojuDrop:initDropDaoju(dropDaojuArray,position,self)
end

function FightUI:getIndexYItemArray()
	if self.daojuDrop then
		return self.daojuDrop.iconArray
	end
	return {}
end

------------------------释放区域显示-----------------开始--------
function FightUI:setCurrentSkill(battleUnitID,skillId)
	self.currentPlaySkillId = skillId
	self.currentBattleUnitID = battleUnitID
end

function FightUI:refreshSkillCDTime(battleUnitID)
	if not self.skillItemArray[battleUnitID] then return end
	self.skillItemArray[battleUnitID]:refreshSkillCDTime()
end

function FightUI:getCurrentPlaySkillId()
	return self.currentPlaySkillId
end

function FightUI:waitingBackgroundVisible(bool,battleUnitID)
	if not self.waitingBackground or not self.waitingBackground.sprite then
		self.waitingBackground = LayerColorBackGround:getBackGround()
		self.waitingBackground:setScaleX(4)
		self.waitingBackground:setScaleY(2)
		self.waitingBackground:setOpacity(200);
	end
	self.waitingBackground:setVisible(bool)
	-- self.skillItem = self.skillItemArray[battleUnitID]
	if self.waitingBackground.parent then
		self.waitingBackground.parent:removeChild(self.waitingBackground,false)
	end
	local generalVO = self.battleProxy.battleGeneralArray[battleUnitID];
	sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_EFFECTS):addChild(self.waitingBackground)
	self.waitingBackground:setPositionXY(generalVO.battleIcon:getPositionX()-GameConfig.STAGE_WIDTH*1.3,-GameConfig.STAGE_HEIGHT/2)
end

function FightUI:waitingBtnHandler(event)
	if self.battleProxy.lastAttackData_7_6 then
		self:stopAllNodeAction()
		sharedTextAnimateReward():animateStartByString("战斗已经结束！");
		return
	end
	local clickPosition = self:getClickAreaPosition(event.globalPosition)
	self:sendUseSkillMessage(self.currentBattleUnitID,self.currentPlaySkillId,clickPosition)
end
--直截释放
function FightUI:directPlaySkill(battleUnitID,skillId)
	self:sendUseSkillMessage(battleUnitID,skillId)
end

function FightUI:playSkillSuccess(battleUnitID,attackSkillId,faceDirect)
	if not self.currentBattleUnitID then return end
	if battleUnitID == self.currentBattleUnitID and attackSkillId == self.currentPlaySkillId then
		self.skillItemArray[battleUnitID]:playSkillSuccess(faceDirect)
		self.currentPlaySkillId = nil
		self.currentBattleUnitID = nil
		
		if self.guideSkillimg then
			closeTutorUI()
			self:setGuideLayerVisible(false)
		end
	end
end

function FightUI:refreshDeadHeadImgGray(battleUnitID)
	local skillItem = self.skillItemArray[battleUnitID]
	if skillItem then
		skillItem:refreshDeadHeadImgGray()
	end
end

------------------------释放区域显示-----------------结束--------
--战斗结束时调用
function FightUI:stopAllNodeAction()
	for key,item in pairs(self.skillItemArray) do
		item:stopAllAction()
	end
	if self.currentBattleUnitID then
		local item = self.skillItemArray[self.currentBattleUnitID]
		item.heroVO.battleIcon:setHeroAreaVisible(false)
		item.heroVO.battleIcon:setAttackEffectVisible(false)
	end
	-- ScreenMove:setLighterVisible(false)
	if self.daojuDrop then
		self.daojuDrop:forceToMove()
		self:removeNextWaveTimer()
		local function nextWaveTimerFun()
			self:removeNextWaveTimer()
			self.daojuDrop:forceToMove()
			self.yinliangText:setString(self.battleProxy.diaoLuoDaoYiLiangNum)
			self.baoxiangText:setString(self.battleProxy.diaoLuoDaoJuNum)
		end
		self.nextWaveTimer = Director:sharedDirector():getScheduler():scheduleScriptFunc(nextWaveTimerFun, 0.8, false)
	end
	local clickLayer = sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_MAP)
	clickLayer:removeEventListener(DisplayEvents.kTouchTap,self.clickLayerHandler)
	local clickLayerBg = sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_MAP_BG)
	clickLayerBg:removeEventListener(DisplayEvents.kTouchTap,self.clickLayerHandler)
	sharedBattleLayerManager():layerResume()
	closeTutorUI()
	self:removeTutorTimeOut()
end

function FightUI:refreshGoBotton()
	local blink = CCBlink:create(1, 1); 
	local repeatForever = CCRepeatForever:create(blink);
	self.goButton:runAction(repeatForever)
	self.goButton:setVisible(true)
	ScreenMove:setScreenPage(self.battleProxy.waveNumber)
	self:layerTouchEnabled(false)
	self:type4Hide()
	self.dropItemArr={};
	self:add_Time_Text()
	if not self.isHiden then 
		self.isHiden = true;
		Tweenlite:to(self.skillButtonLayer,0.3,0,-250,255,nil,true);
	end
	if self.guideSkillimg then
		self.guideSkillimg = nil
		self:setGuideLayerVisible(false)
		closeTutorUI()
	end
end

function FightUI:type4Hide()
	--新手战斗
	if self.battleProxy.battleType == BattleConfig.BATTLE_TYPE_4 then
		if self.battleProxy.greenHandBattle:isNeedHide() then
			self.goButton:stopAllActions()
			self.goButton:setVisible(false)
			self:refreshLeftCount("100")
		end
	end
end

function FightUI:setGoButtonVisible(bool)
	self.goButton:stopAllActions()
	self.goButton:setVisible(bool)
	self:testShowBossEffect();
	self:setNextWaveActive()
end

function FightUI:setNextWaveActive()
	self:removeNextWaveTimer()
	local function nextWaveTimerFun()
		self:removeNextWaveTimer()
		if self.isHiden then 
			self.isHiden = false;
			Tweenlite:to(self.skillButtonLayer,0.3,0,250,255,function ()
				self:layerTouchEnabled(true)
				ScreenMove:setIsNextWave(nil,self.battleProxy:isNeedPlayScript())
			end,true,nil,1.5);
		end
		if self.battleProxy.battleType ~= BattleConfig.BATTLE_TYPE_4 then
			self.battleProxy:isNeedDialogue(true)
		else
			self.battleProxy.greenHandBattle:stepDialog()
		end
	end
	self.nextWaveTimer = Director:sharedDirector():getScheduler():scheduleScriptFunc(nextWaveTimerFun, 0, false)
	
end

function FightUI:removeNextWaveTimer()
    if self.nextWaveTimer then
        Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.nextWaveTimer);
        self.nextWaveTimer = nil
    end
end

function FightUI:testShowBossEffect()
	if self.haveBoss then
		require "main.view.battleScene.function.BossEffect";
		BossEffect:playBossEffect();
	end
end

function FightUI:sendUseSkillMessage(battleUnitID,skillId)
	if self.battleProxy.battleStatus ~= BattleConfig.Battle_Status_3 then
		sendMessage(7,9,{SkillId = tonumber(skillId)});
	else
		self.battleProxy:useSkill(battleUnitID,skillId)
		-- self:playBeginAttackEffect(battleUnitID,skillId)
	end
end