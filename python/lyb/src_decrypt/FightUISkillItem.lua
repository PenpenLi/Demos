
FightUISkillItem=class(ScaleLayer);

function FightUISkillItem:ctor()
	require("main.controller.command.battleScene.battle.battlefield.config.BattleConstants")
	require "core.display.ClippingNodeMask";
	self.class=FightUISkillItem;
	self.isFirstCd = true
end

function FightUISkillItem:dispose()
	self:removeTipTimer()
	self:removeAllEventListeners();
	self:removeChildren();
	FightUISkillItem.superclass.dispose(self);
	self.fightUI = nil
	self.armature = nil;
	self.heroVO = nil;
	self.skeleton = nil;
	self:removeOneSkillCDTimer()
	self:removeUpEffectTimer()
end

function FightUISkillItem:stopAllAction()
	self:removeTipTimer()
	self:removeOneSkillCDTimer()
end

function FightUISkillItem:startAllAction(oneSkillTime)
	self:startOneSkillCDTimer(oneSkillTime)
	self:addEventListener(DisplayEvents.kTouchEnd,self.onPlaySkillEnd,self);
	self:addEventListener(DisplayEvents.kTouchMove,self.onPlaySkillMove,self);
	self:addEventListener(DisplayEvents.kTouchBegin,self.onPlaySkillBegin,self);
end

function FightUISkillItem:startOneSkillCDTimer(oneSkillTime)
	self.oneSkillTime = self.isFirstCd and self.skillOneVO.FristCD or self.skillOneVO.CD
	if oneSkillTime then
		self.oneSkillTime = oneSkillTime
	end
	self.isFirstCd = nil
	self:removeOneSkillCDTimer()
	local function skillCDTimerFun()
		if self.fightUI.battleProxy:isPauseBattle() then return end
		self.oneSkillTime = self.oneSkillTime-1000
		if self.oneSkillTime <= 0 then
			self:skillCDTimerOver()
		end
	end
	skillCDTimerFun()
	self.oneSkillCDTimer = Director:sharedDirector():getScheduler():scheduleScriptFunc(skillCDTimerFun, 1, false)
end

function FightUISkillItem:skillCDTimerOver()
	self:removeOneSkillCDTimer()
	self:setItemNormal()
	self:removeTipTimer()
	self.tipText:setVisible(false)
	self:initOneTipEffect(true)
end

function FightUISkillItem:refreshSkillCDTime()
	self:setItemDark()
	self:initOneTipEffect(false)
	self:startOneSkillCDTimer()
	if self.isScriptType then
		self:skillCDTimerOver()
	end
end

function FightUISkillItem:setFlagScript(isScriptType)
	self.isScriptType = isScriptType
end

function FightUISkillItem:initialize(skeleton,heroVO,fightUI)
	self:initLayer();
	self.fightUI = fightUI;
	self.heroVO = heroVO;
	self.skeleton = skeleton;
	self.kapaikuPO = analysis("Kapai_Kapaiku",self.heroVO.generalID)
	self:setSkillId()
	self:initializeHero()
	self:initScaleAnimation()
	self:initHeadimge()
    self.tipText = generateText(self,self.armature,"tip_text","",true);
    self.tipText:setVisible(false)

    self.progress1 = ProgressBar.new(self.armature,"xuetiao");
    self.progress1:setProgress(self.heroVO:getCurrHp()/self.heroVO:getMaxHP())
    self.progress2 = ProgressBar.new(self.armature,"nuqitiao");
    self.progress2:setProgress(self.heroVO:getCurrRage()/self.skillTwoVO.xiaoHao)
    self.jiantou = cartoonPlayer(1681,-24,-32,0,nil,1)
    self.jiantou:setAnchorPoint(CCPointMake(0,0))
    self:addChildAt(self.jiantou,0)
    self:initJobIcon()
	self:setItemDark()
	self:twoSkillPause()
end

function FightUISkillItem:initJobIcon()
	self.wuxing_img = CommonSkeleton:getBoneTextureDisplay("commonImages/common_shuxing_"..self.kapaikuPO.job);
	self.wuxing_img:setScale(0.25);
	self.wuxing_img:setPositionXY(10,28);
	self:addChild(self.wuxing_img);
end

function FightUISkillItem:initializeHero()
	local armature=self.skeleton:buildArmature("rolehero");
    armature.animation:gotoAndPlay("f1");
    armature:updateBonesZ();
    armature:update();
    self.armature = armature;
    self.armature_d=armature.display;
    self:addChild(self.armature_d);
    self.headImageArtId = self.kapaikuPO.material_id
	self.headBackground = self.armature_d:getChildByName("headimagebg1")
end

function FightUISkillItem:initHeadimge()
 	if self.clipper then return end
    local tempCCSprite = CCSprite:create();
    local tempSprite = Sprite.new(tempCCSprite);
	self.clipper = ClippingNode.new(tempSprite);
	self.clipper:setAlphaThreshold(0.0);
	self.clipper:setPositionXY(-5,30)
	self.clipper:setContentSize(makeSize(160,250));
	self:addChild(self.clipper);
	self.person = getCompositeRole(self.headImageArtId);
	self.person:setPositionXY(77,-50);
	self.clipper:addChild(self.person);
    self.clipper.touchEnabled = false
    self.clipper.touchChildren = false
end

function FightUISkillItem:setItemDark()
	self.progress2:setBarColor(100)
	self.progress1:setBarColor(100)
	self.headBackground:setColor(ccc3(100, 100, 100));
	self.wuxing_img:setColor(ccc3(100, 100, 100));
	self.person:bodyToDark()
end

function FightUISkillItem:setItemNormal()
	self.progress2:setBarColor(255)
	self.progress1:setBarColor(255)
	self.headBackground:setColor(ccc3(255, 255, 255));
	self.wuxing_img:setColor(ccc3(255, 255, 255));
	self.person:removeColor()
end

function FightUISkillItem:twoSkillAnimation()
	if self.headGrayBackground then return end
	if self.jiantou:isVisible() then return end
	self.jiantou:setVisible(true)
	self:initFullPowerEffect(true)
	self:initTwoTipEffect(true)
end

function FightUISkillItem:twoSkillPause()
	self.jiantou:setVisible(false)
	self:initFullPowerEffect(false)
	self:initTwoTipEffect(false)
end

function FightUISkillItem:initFullPowerEffect(bool)
	if not self.poweLineE then
		self.poweLineE = cartoonPlayer(1320,75,15,0,nil,1)
		self.poweLineE:setAnchorPoint(CCPointMake(0, 0));
		self:addChild(self.poweLineE)
	end
	self.poweLineE:setVisible(bool)
end

function FightUISkillItem:initOneTipEffect(bool)
	local id  = self.fightUI.battleProxy.battleFieldId
	if id == 10001002 or id == 10001003 or id == 10001004 then
		if not self.oneTipEffect then
			self.oneTipEffect = cartoonPlayer(397,10,0,0,nil,1)
			self.oneTipEffect:setAnchorPoint(CCPointMake(0, 0));
			self:addChild(self.oneTipEffect)
		end
		self.oneTipEffect:setVisible(bool)
		if self.twoTipEffect and self.twoTipEffect:isVisible() then
			self.oneTipEffect:setVisible(false)
		end
	end
end

function FightUISkillItem:initTwoTipEffect(bool)
	local id  = self.fightUI.battleProxy.battleFieldId
	if id == 10001002 or id == 10001003 or id == 10001004 then
		if not self.twoTipEffect then
			self.twoTipEffect = cartoonPlayer(633,10,0,0,nil,1)
			self.twoTipEffect:setAnchorPoint(CCPointMake(0, 0));
			self:addChild(self.twoTipEffect)
		end
		self.twoTipEffect:setVisible(bool)
		if not bool and self.oneSkillTime and self.oneSkillTime <= 0 then
			if self.oneTipEffect then
				self.oneTipEffect:setVisible(true)
			end
		end
	end
end

function FightUISkillItem:setSkillId()
	self.skillOneId = tonumber(self.kapaikuPO.one)
	self.skillOneVO = analysis("Jineng_Jineng",self.skillOneId)

	self.skillTwoId = tonumber(self.kapaikuPO.two)
	self.skillTwoVO = analysis("Jineng_Jineng",self.skillTwoId)
end

function FightUISkillItem:refreshHpData()
	self.progress1:setProgress(self.heroVO:getCurrHp()/self.heroVO:getMaxHP())
end

function FightUISkillItem:getGeneralID()
	return self.heroVO.generalID
end

function FightUISkillItem:refreshRangeData()
	local num = self.heroVO:getCurrRage()/self.skillTwoVO.xiaoHao
	self.progress2:setProgress(num)
	if num >= 1 then
		self:twoSkillAnimation()
	else
		self:twoSkillPause()
	end
end

function FightUISkillItem:onPlaySkillBegin(event)
	self.startPosition = event.globalPosition
	self:setUpEffectVisible(self.heroVO:getCurrRage() >= self.skillTwoVO.xiaoHao)
end

function FightUISkillItem:onPlaySkillMove(event)
	if not self.startPosition then
		self:setTimeOutUpEffect()
		return
	end
	local clickDistance =  BattleUtils:getDistanceP(event.globalPosition,self.startPosition);
	if clickDistance > 20 then
		self:setTimeOutUpEffect()
	end
end

function FightUISkillItem:setTimeOutUpEffect()
	self:removeUpEffectTimer()
	local function upTimeFun()
		self:removeUpEffectTimer()
		self:setUpEffectVisible(false)
	end
	self.upTimeHandle = Director:sharedDirector():getScheduler():scheduleScriptFunc(upTimeFun, 2, false)
end

function FightUISkillItem:removeUpEffectTimer()
    if self.upTimeHandle then
        Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.upTimeHandle);
        self.upTimeHandle = nil
    end
end

function FightUISkillItem:setUpEffectVisible(bool)
	if not self.jiantouUpEffect then
		self.jiantouUpEffect = cartoonPlayer(1319,80,0,0,nil,1)
		self.jiantouUpEffect:setAnchorPoint(CCPointMake(0.5, 0));
		self:addChild(self.jiantouUpEffect)
		self.upEffectBg = cartoonPlayer(1318,80,0,0,nil,1)
		self.upEffectBg:setAnchorPoint(CCPointMake(0.5, 0));
		self:addChildAt(self.upEffectBg,0)
	end
	if self.headGrayBackground then 
		bool = false
	end
	self.jiantouUpEffect:setVisible(bool)
	self.upEffectBg:setVisible(bool)
end

function FightUISkillItem:onPlaySkillEnd(event)
	self:removeUpEffectTimer()
	self:setUpEffectVisible(false)
	if not self.startPosition then return end
	if self.fightUI.battleProxy:isAutoByType() then
		self.tipText:setVisible(true)
		self.tipText:setString("不支持放技能!")
		self:tipAction()
	 	return 
	end
	if self.fightUI.battleProxy.lastAttackData_7_6 then
		sharedTextAnimateReward():animateStartByString("战斗已经结束！");
		return
	end
	if self.heroVO:getCurrHp() <= 0 then 
		self.tipText:setVisible(true)
		self.tipText:setString("已经阵亡!")
		self:tipAction()
		return 
	end
	local clickDistance =  BattleUtils:getDistanceP(event.globalPosition,self.startPosition);
	local skillId = nil
	if clickDistance < 30 then
		if self.oneSkillTime > 0 and self.isScriptType ~= 1 then
			self.tipText:setVisible(true)
			self.tipText:setString("冷却中")
			self:tipAction()
			return
		end
		skillId = self.skillOneId
	else
		if self.heroVO:getCurrRage() < self.skillTwoVO.xiaoHao then
			self.tipText:setVisible(true)
			self.tipText:setString("怒气不够")
			self:tipAction()
			return
		end
		skillId = self.skillTwoId
		-- print("ppppppppppppppppppppppppppppppppppppppppppppppppppp1111",skillId,CommonUtils:getOSTime())
	end
	if not self.fightUI.battleProxy.AIBattleField then return end
	self.fightUI.battleProxy.AIBattleField:onContinueScript()
	self.fightUI:directPlaySkill(self.heroVO.battleUnitID,skillId)
	self.jiantou:setVisible(false)
	self:toTutorAction()
end

function FightUISkillItem:toTutorAction()
	if self.isScriptType then
		if self.isScriptType == 2 then
			self.oneSkillTime = 0
		end
		self.isScriptType = nil
		self:setItemDark()
	end
	closeTutorUI()
	self.fightUI.battleProxy:toTutorAction()
end

function FightUISkillItem:getSkillOneTime()
	return self.heroVO:getSkill(self.skillOneId):getActionConfig():getCaskSkillTime(self.heroVO)
end

function FightUISkillItem:getSkillTwoTime()
	return self.heroVO:getSkill(self.skillTwoId):getActionConfig():getCaskSkillTime(self.heroVO)
end

function FightUISkillItem:tipAction()
	self:removeTipTimer()
	local function tipHandleFun()
		self:removeTipTimer()
		self.tipText:setVisible(false)
	end
	self.tipHandle = Director:sharedDirector():getScheduler():scheduleScriptFunc(tipHandleFun, 2, false)
end

function FightUISkillItem:setSkillWaitingEffectVisible(bool)
	if not self.cdCompleteEffect then return end
	self.cdCompleteEffect:setVisible(not bool)
end

function FightUISkillItem:refreshDeadHeadImgGray()
	if self.headGrayBackground then return end
	self:initGrayImage()
end

function FightUISkillItem:initGrayImage()
	self.clipper:setVisible(false)
	local zhenwang = self.skeleton:getBoneTextureDisplay("zhenwang");
	zhenwang:setScale(0.8)
	zhenwang:setPositionXY(42,18)
	self:addChild(zhenwang)

    local textureName = "headimagebg1h"
    self.headGrayBackground = self.skeleton:getBoneTextureDisplay(textureName);
    self.headGrayBackground:setPositionXY(self.headBackground:getPositionX(),0)
    self.armature_d:addChildAt(self.headGrayBackground,0)

	self.person:setVisible(false)
	self.headBackground:setVisible(false)
	self.progress1.progressBone:getDisplay():setVisible(false)
	self.progress2.progressBone:getDisplay():setVisible(false)
	self.jiantou:setVisible(false)
	if self.poweLineE then
		self.poweLineE:setVisible(false)
	end
	if self.jiantouUpEffect then
		self.jiantouUpEffect:setVisible(false)
	end
	if self.upEffectBg then
		self.upEffectBg:setVisible(false)
	end
	self.wuxing_img:setVisible(false)
end

function FightUISkillItem:removeOneSkillCDTimer()
    if self.oneSkillCDTimer then
        Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.oneSkillCDTimer);
        self.oneSkillCDTimer = nil
    end
end

function FightUISkillItem:removeTipTimer()
    if self.tipHandle then
        Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.tipHandle);
        self.tipHandle = nil
    end
end

