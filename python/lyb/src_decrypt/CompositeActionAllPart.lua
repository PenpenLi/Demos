------------------------------------------
--  Class include: CompositeActionAllPart
------------------------------------------

CompositeActionAllPart = class(Layer);
function CompositeActionAllPart:ctor()
    self.class = CompositeActionAllPart;  
    self.index = 0;
    self.name = "CompositeActionAllPart";
    self.bodyIcon = nil;
    self.weaponIcon = nil;
    self.mountsIcon = nil;
    self.bodySourceName = nil;
    self.mountsSourceName = nil;
    self.mountsSourceName = nil;
    self.backFun = nil;
    self.actionId = nil;
    self.effectIcon = nil-- 特效层
    self.backEffectIcon = nil-- 背景特效层			
    self.firstFrameSprite = nil -- 第一帧
    self.layerColor = nil
    self.bodyScheduler = nil;
    self.weaponScheduler = nil;
    self.scaleNum = 1;
    self.sizeH = nil
    self.sizeW = nil
    self.skillEffectArr = {};
end

function CompositeActionAllPart:dispose()
    if self.bodyIcon then
      self.bodyIcon:dispose()
    end
    if self.weaponIcon then
      self.weaponIcon:dispose()
      self.weaponIcon = nil;
    end
    if self.mountsIcon then
      self.mountsIcon:dispose()
      self.mountsIcon = nil;
    end
    self.bodySourceName = nil;
    self.mountsSourceName = nil;
    self.mountsSourceName = nil;
    self.backFun = nil;
    self.actionId = nil;
    self.sizeH = nil
    self.sizeW = nil

    if self.effectIcon then
      self.effectIcon:dispose()
      self.effectIcon = nil;
    end
    if self.backEffectIcon then
      self.backEffectIcon:dispose()
      self.backEffectIcon = nil;
    end
    if self.layerColor then
      self.layerColor:dispose()
      self.layerColor = nil;
    end
    self.roleVO = nil
    self.skillBossAttackArea = nil
    self.heroAttackArea = nil
    self.battleBuffer = nil
    self:removeLoopHandleTimer()
    self:removeDelayDeadTimer()
    self:removeAllEventListeners();
    self:removeTimeOutTimer()
    self:removeHitPaowuxianTimer()
    self:removeJumpTotalTimer()
    self:removeJumpHitTimer()
    self:removeChildren();
    CompositeActionAllPart.superclass.dispose(self);
end

----------------
--合成
----------------
--isHighLight,是否要用高亮
function CompositeActionAllPart:transformPartCompose(partTable,isHighLight)
    local action  = self:everyPartIcon(partTable,isHighLight);
	  self.action = action
    local len = table.getn(partTable);
    if len == 1 then
       self:bodyRepeat(self.bodySourceName .. "_"..action);
    elseif len == 2 then
       self:bodyRepeat(self.bodySourceName .. "_"..action);
       self:weaponRepeat(self.weaponSourceName .. "_"..action);
    end
end

function CompositeActionAllPart:getBackEffectIcon()
    -- 添加背景特效层 zhangke
    if not self.backEffectIcon then
        local backEffectSprite = CCSprite:create();
        self.backEffectIcon = Sprite.new(backEffectSprite);
        self.backEffectIcon:setAnchorPoint(CCPointMake(0.5,0.1));
        self:addChild(self.backEffectIcon);
        self.backEffectIcon.touchEnabled = false;
        self.backEffectIcon.touchChildren = false;
    end
    return self.backEffectIcon
end

function CompositeActionAllPart:getEffectIcon()
  if not self.effectIcon then
      -- 添加特效层 zhangke
      local effectSprite = CCSprite:create();
      self.effectIcon = Sprite.new(effectSprite);
      self.effectIcon:setAnchorPoint(CCPointMake(0.5,0.1));
      self:addChild(self.effectIcon);
      self.effectIcon.touchEnabled = false;
      self.effectIcon.touchChildren = false;
  end
  return self.effectIcon
end

function CompositeActionAllPart:setBodyEffectVisible(bool)
  if self.effectIcon then
    self.effectIcon:setVisible(bool)
  end
end

function CompositeActionAllPart:setRoleVO(roleVO)
  self.roleVO = roleVO
end

function CompositeActionAllPart:setHighLight(bool)
  if not self.bodyIcon then return end
  if not self.bodyIcon.sprite then return end
  self.bodyIcon.sprite:setHighLight(bool);
end

-- isHighLight,是否要用高亮
function CompositeActionAllPart:everyPartIcon(partTable,isHighLight)
	local action;
	for k,v in ipairs(partTable) do
  	if v["type"] == BattleConfig.TRANSFORM_BODY then
  		local body
      if not isHighLight then
        body = CCSprite:create();
      else
        body = CColorSprite:create();
      end
  		self.bodyIcon = Sprite.new(body);
  		self.bodyIcon.touchEnabled = false;
  		self.bodyIcon.touchChildren = false;
  		self.bodyIcon:setAnchorPoint(CCPointMake(0.5,0.1));

  		self:addChild(self.bodyIcon);
  		local actionArr = StringUtils:lua_string_split(v["sourceName"], "_");
  		self.bodySourceName = actionArr[1];
  		action = actionArr[2];
  	elseif
  	  v["type"] == BattleConfig.TRANSFORM_WEAPON then
  	   local weapon = CCSprite:create();
  	   self.weaponIcon = Sprite.new(weapon);
  	   self.weaponIcon.touchEnabled = false;
  	   self.weaponIcon.touchChildren = false;
  	   self:addChild(self.weaponIcon);
  	   
  	   self.weaponIcon:setAnchorPoint(CCPointMake(0.5,0.1));
  	   self.weaponSourceName = StringUtils:lua_string_split(v["sourceName"], "_")[1];
  	elseif
  	  v["type"] == BattleConfig.TRANSFORM_HORSE then
  	   local mounts = CCSprite:create();
  	   self.mountsIcon = Sprite.new(mounts);
  	   self:addChild(self.mountsIcon);
  	   self.mountsSourceName = StringUtils:lua_string_split(v["sourceName"], "_")[1];
  	end
	end
	return action;
end

-- 取得身体模型ID
function CompositeActionAllPart:getBodySourceID()
	return self.bodySourceName
end

-- 取得武器模型ID
function CompositeActionAllPart:getWeaponSourceID()
	return self.weaponSourceName
end

-----------------------
--partNum：哪个部分,sourceName：该部分的素材ID 236
-----------------------
function CompositeActionAllPart:reloading(partNum,sourceName,flag)
      local poseId = flag and flag or GameConfig.ROLE_STAND_CITY;
      if partNum == BattleConfig.TRANSFORM_BODY then
          self:bodyRepeat(sourceName .. "_"..poseId);
          self:weaponRepeat(self.weaponSourceName .. "_"..poseId);
      elseif partNum == BattleConfig.TRANSFORM_WEAPON then
          self:weaponRepeat(sourceName .. "_"..poseId);
          self:bodyRepeat(self.bodySourceName .. "_"..poseId);
      end
end

----------------------------
--进行缩放,传入缩放值如0.5
----------------------------
function CompositeActionAllPart:setScalingTo(scaleNum)
      if self.weaponIcon then
          self.weaponIcon:setScale(scaleNum);
      end
      self.bodyIcon:setScale(scaleNum);
      if not self.scaleNum then
        self.scaleNum = scaleNum;
      end
end

----------------------------
--取得缩放值
----------------------------
function CompositeActionAllPart:getScaleNum()
  return self.scaleNum
end

-----------
--改变朝向
-----------
function CompositeActionAllPart:changeFaceDirect(changeFace)
			if self.weaponIcon then
			    if not self.weaponIcon.sprite then return;end;
				  self.weaponIcon.sprite:setFlipX(changeFace);
			end
      if self.bodyIcon then
        if not self.bodyIcon.sprite then return;end;
		  	self.bodyIcon.sprite:setFlipX(changeFace);
      end
      self.changeFace = changeFace;
end

function CompositeActionAllPart:getChangeFace()
    return self.changeFace;
end

function CompositeActionAllPart:removeChildParts()
    if self.weaponIcon then
         self.weaponIcon:setVisible(false)
    end
    self.bodyIcon:setVisible(false)
end

------------
--动作循环
-----------
function CompositeActionAllPart:playAndLoop(actionId)
    self.actionId = actionId;
    if self.weaponIcon then
        self:weaponRepeat(self.weaponSourceName .. "_" .. actionId);
    end
    if self.bodySourceName then
       self:bodyRepeat(self.bodySourceName .. "_" .. actionId);
    end
end

function CompositeActionAllPart:playAndStop(actionId,lastId)
    local function callBack()
        self:playAndLoop(lastId)
    end
    self:playAndBack(actionId,callBack)
end

--------------------
--玩家或怪物进行位移
--------------------
function CompositeActionAllPart:tweenLiteAnimation(time, point, _backFun,needStop)
    self.backFun = _backFun;
    local function back()
          if self.actionId ~= BattleConfig.DEAD then
              self:playAndLoop(BattleConfig.HOLD);
          end    
          if self.backFun then
              self.backFun();
          end
    end
    local moveAction = CCMoveTo:create(time, point);
    local array = CCArray:create();
    local callBack = CCCallFunc:create(back);
    array:addObject(moveAction);
    array:addObject(callBack);
    local quence = CCSequence:create(array)
    self:runAction(quence,NULL);
end

------------
--动作进行一次，并返回
------------
function CompositeActionAllPart:playAndBack(actionId, _backFun)
        self.actionId = actionId;
        if self.weaponIcon then
            self:weaponRunOnce(self.weaponSourceName  .. "_" .. actionId);
        end
        self:bodyRunOnce(self.bodySourceName .. "_" .. actionId, _backFun);
end
------------
--头部循环
------------
function CompositeActionAllPart:headRepeat(fileName)
    local animCache = CCAnimationCache:sharedAnimationCache();
	  local standAnimation = animCache:animationByName(fileName);
		local animate=CCAnimate:create(standAnimation);
    self.headIcon:stopAllActions();
    self.headIcon:runAction(CCRepeatForever:create(animate));
end
-----------
--身体循环
-----------
function CompositeActionAllPart:bodyRepeat(fileName)
    if self.isStopTimer then return end
    if self:hasCache(fileName) == false then return;end
    local animCache = CCAnimationCache:sharedAnimationCache();
	  local standAnimation = animCache:animationByName(fileName);
		local animate=CCAnimate:create(standAnimation);
    if self.bodyIcon.sprite then
        self.bodyIcon:stopAllActions();
        self.bodyIcon:runAction(CCRepeatForever:create(animate));
    end
end
-----------
--武器循环
-----------
function CompositeActionAllPart:weaponRepeat(fileName)
    if self:hasCache(fileName) == false then return;end
    local animCache = CCAnimationCache:sharedAnimationCache();
	  local standAnimation = animCache:animationByName(fileName);
		local animate=CCAnimate:create(standAnimation);
    if self.weaponIcon.sprite then
        self.weaponIcon:stopAllActions();
        self.weaponIcon:runAction(CCRepeatForever:create(animate));
    end
end
----------
--坐骑循环
----------
function CompositeActionAllPart:mountsRepeat(fileName)
    if self:hasCache(fileName) == false then return;end
    local animate = BattleData.battleAnimationCache[fileName]
    if self.mountsIcon then
      self.mountsIcon:runAction(CCRepeatForever:create(animate));
    end
end

----------
--头部一次性动作
----------
function CompositeActionAllPart:headRunOnce(fileName,_backFun)
      if self:hasCache(fileName) == false then return;end
      local animCache = CCAnimationCache:sharedAnimationCache();
	    local standAnimation = animCache:animationByName(fileName);
      local animate=CCAnimate:create(standAnimation);
      self.headIcon:stopAllActions();
      local array = CCArray:create();
      local callBack = CCCallFunc:create(_backFun);
      array:addObject(animate);
      array:addObject(callBack);
      self.headIcon:runAction(CCSequence:create(array));
end
----------
--身体一次性动作
----------
function CompositeActionAllPart:bodyRunOnce(fileName,_backFun)
    if self.isStopTimer then return end
    if self:hasCache(fileName) == false then return;end
        local callBackFunction = _backFun;
        
        local function back()
            if callBackFunction then
                callBackFunction();
            end
      end
      
      local animCache = CCAnimationCache:sharedAnimationCache();
	    local standAnimation = animCache:animationByName(fileName);
      local animate=CCAnimate:create(standAnimation);
      if not self.bodyIcon.sprite then return;end;
      self.bodyIcon:stopAllActions();
      local array = CCArray:create();
      local callBack = CCCallFunc:create(back);
      array:addObject(animate);
      array:addObject(callBack);
      self.bodyIcon:runAction(CCSequence:create(array));
end
---------
--武器一次性动作
---------
function CompositeActionAllPart:weaponRunOnce(fileName)
      if self:hasCache(fileName) == false then return;end
      local animCache = CCAnimationCache:sharedAnimationCache();
	    local standAnimation = animCache:animationByName(fileName);
      local animate=CCAnimate:create(standAnimation);
      self.weaponIcon:stopAllActions();
      self.weaponIcon:runAction(animate);
end
-----------
--坐骑一次性动作
-----------
function CompositeActionAllPart:mountsRunOnce(fileName)
      if self:hasCache(fileName) == false then return;end
      local animate = BattleData.battleAnimationCache[fileName]
      self.mountsIcon:runAction(animate,_backFun,NULL);
end
-----------
--停止动作
-----------
function CompositeActionAllPart:stopAndRemoveAllAction()
  if self.weaponIcon and self.weaponIcon.sprite then
      self.weaponIcon:stopAllActions();
  end
  if self.bodyIcon and self.bodyIcon.sprite then
      self.bodyIcon:stopAllActions();
  end
  if self.sprite then
      self:stopAllActions();
  end
end

-----------
--停止动作
-----------
function CompositeActionAllPart:removeTweenlite()
    self:stopAllActions();
    self:removeJumpTotalTimer()
    self:removeJumpHitTimer()
end

function CompositeActionAllPart:removeEffectSprite()
    if self.effectIcon and self.effectIcon.sprite then
      self:removeChild(self.effectIcon)
      self.effectIcon = nil;
    end
    if self.layerColor and self.layerColor.sprite then
      self:removeChild(self.layerColor)
      self.layerColor = nil;
    end
    if self.backEffectIcon and self.backEffectIcon.sprite then
      self:removeChild(self.backEffectIcon)
      self.backEffectIcon = nil;
    end
end

function CompositeActionAllPart:addTouchEventListener(kTouchTap, backFun, object, data, width, height, isScale)
    if self.layerColor and self:contains(self.layerColor) then
        return
    end
    self.layerColor = LayerColor.new();
    self.layerColor:initLayer();
    local w = width or 80;
    local h = height or 135;

    self.layerColor:changeWidthAndHeight(w, h);
    self.layerColor:setColor(ccc3(0,0,0));
    self.layerColor:setPositionX(-w/2);
    self.layerColor:setAlpha(0);
    self:addChild(self.layerColor);
    self.layerColor:addEventListener(DisplayEvents.kTouchTap, backFun, object, data);

    if isScale then
      self.layerColor:addEventListener(DisplayEvents.kTouchBegin, self.onTouchBegin, self);
      self.layerColor:addEventListener(DisplayEvents.kTouchEnd, self.onTouchEnd, self);
    end
end
function CompositeActionAllPart:onTouchBegin(event)
  self.bodyIcon:setScale(0.92)
end
function CompositeActionAllPart:onTouchEnd(event)
  self.bodyIcon:setScale(1)
end
function CompositeActionAllPart:setActionScale(number)
    if not self.bodyIcon or not self.bodyIcon.sprite then return;end
    if self.bodyScheduler then
        self.bodyScheduler:setTimeScale(number);
        if self.weaponIcon then
            self.weaponScheduler:setTimeScale(number);
        end
    else
        local defaultScheduler = Director.sharedDirector():getScheduler();
        local bodyActionManager = createActionManager();
        local bodyScheduler = createScheduler();
        defaultScheduler:scheduleUpdateForTarget(bodyScheduler, 0, false);
        bodyScheduler:scheduleUpdateForTarget(bodyActionManager, 0, false);
        bodyScheduler:setTimeScale(number);
        self.bodyScheduler = bodyScheduler;
        self.bodyIcon:setActionManager(bodyActionManager);
        if self.weaponIcon then
            local weaponActionManager = createActionManager();
            local weaponScheduler = createScheduler();
            defaultScheduler:scheduleUpdateForTarget(weaponScheduler, 0, false);
            weaponScheduler:scheduleUpdateForTarget(weaponActionManager, 0, false);
            weaponScheduler:setTimeScale(number);
            self.weaponScheduler = weaponScheduler;
            self.weaponIcon:setActionManager(weaponActionManager);
        end
    end
end
-----------
--变色
-----------
function CompositeActionAllPart:bodyToRed()
    if self.weaponIcon and self.weaponIcon.sprite then
      self.weaponIcon:setColor(ccc3(255, 0, 0));
    end
    if self.bodyIcon and self.bodyIcon.sprite then
        self.bodyIcon:setColor(ccc3(255, 0, 0));
        return true;
    else
        return false
    end
end 

-----------
--变色
-----------
function CompositeActionAllPart:bodyToGreen()
    if self.weaponIcon and self.weaponIcon.sprite then
      self.weaponIcon:setColor(ccc3(0, 255,0 ));
    end
    if self.bodyIcon and self.bodyIcon.sprite then
      self.bodyIcon:setColor(ccc3(0, 255, 0));
    end
end

function CompositeActionAllPart:bodyToDark()
    if self.bodyIcon and self.bodyIcon.sprite then
      self.bodyIcon:setColor(ccc3(100, 100, 100));
    end
end

function CompositeActionAllPart:bodyToColor(roleVO)
  for k,effectID in pairs(roleVO.effectArray) do
    local color = analysis("Jineng_Jinengxiaoguo",effectID,"color");
    if color == 0 then return;end
    if self.weaponIcon and self.weaponIcon.sprite then
      self.weaponIcon:setColor(CommonUtils:ccc3FromUInt(color));
    end
    if self.bodyIcon and self.bodyIcon.sprite then
      self.bodyIcon:setColor(CommonUtils:ccc3FromUInt(color));
    end
    break
  end
end

-----------
--去色
-----------
function CompositeActionAllPart:removeColor()
    if self.weaponIcon and self.weaponIcon.sprite then
        self.weaponIcon:setColor(ccc3(255, 255, 255));
    end
    if self.bodyIcon and self.bodyIcon.sprite then
        self.bodyIcon:setColor(ccc3(255, 255, 255));
    end
end

function CompositeActionAllPart:addSkillEffect(roleVO)
  if roleVO:isDie() then return end;
  for k,effectID in pairs(roleVO.effectArray) do
    local effectId = analysis("Jineng_Jinengxiaoguo",effectID,"effectId");
    local eY = self:getNameTextHeight();
    if effectId>0 and not self.skillEffectArr[effectId] then
      local effect = cartoonPlayer(effectId,20,110,0);
      self:addChild(effect);
      self.skillEffectArr[effectId] = effect;
    end
  end
  -- for k,effectID in pairs(roleVO.effectArray) do
  --   local effectId = analysis("Jineng_Jinengxiaoguo",effectID,"effectId");
  --   local eY = self:getNameTextHeight();
  --   if effectId>0 and not self.skillEffectArr[effectId] then
  --     local effect = getImageByArtId(effectId)--cartoonPlayer(effectId,0,eY,0);
  --     effect:setPositionXY(0,eY)
  --     effect:setAnchorPoint(CCPointMake(0.5, 0.5))
  --     self:addChild(effect);
  --     self.skillEffectArr[effectId] = effect;
  --   end
  -- end
  -- local count = #self.skillEffectArr*0.5+1;
  -- for i,v in ipairs(self.skillEffectArr) do
  --   v:setPositionX((i-count)*45);
  -- end
end

function CompositeActionAllPart:removeSkillEffect()
  for k,effect in pairs(self.skillEffectArr) do
     self:removeChild(effect);
  end
   self.skillEffectArr = {};
end

function CompositeActionAllPart:refreshBuffer(roleVO)
    if not self.battleBuffer then
        require "main.view.battleScene.function.BattleBuffer"
        self.battleBuffer = BattleBuffer.new()
        self.battleBuffer:initLayer()
        if not self.nameTextHeight then
            self.nameTextHeight = self:getFrameHeight()
        end
        self.battleBuffer:setPositionY(self.nameTextHeight)
        self:addChild(self.battleBuffer)
    end
    self.battleBuffer:refreshBuffer(roleVO.effectArray)
end

function CompositeActionAllPart:onFrozen()
  self:playAndBack(BattleConfig.HOLD);
end

function CompositeActionAllPart:initHpProgressBar(skeleton,proNum)
    require "main.view.battleScene.function.BloodProgressBar"
    local bloodProgressBar = BloodProgressBar.new()
    bloodProgressBar:initLayer()
    bloodProgressBar:initUI(skeleton)
    if not self.nameTextHeight then
        self.nameTextHeight = self:getFrameHeight()*self.scaleNum
    end
    bloodProgressBar:setPositionY(self.nameTextHeight-5)
    bloodProgressBar:setScale(0.8)
    self:addChild(bloodProgressBar)
    self.bloodProgressBar = bloodProgressBar;
    bloodProgressBar.touchChildren = false;
    bloodProgressBar.touchEnabled = false;
    self.bloodProgressBar:refreshBarData(proNum)
end

function CompositeActionAllPart:initNameText(role)
    if not self.nameTextHeight then
        self.nameTextHeight = self:getFrameHeight()*self.scaleNum
    end
    local text_data={x=0,y=self.nameTextHeight+17,width=170,height=38,size=24,alignment=1,color=0xffffff};
    local textField =  createTextFieldWithTextData(text_data, role.name,true);
    self:addChild(textField)
    self.nameTextField = textField
    textField:setAnchorPoint(CCPointMake(0.5,0.5));
    textField.touchChildren = false;
    textField.touchEnabled = false;
end

function CompositeActionAllPart:getNameTextHeight()
    if not self.nameTextHeight then
        self.nameTextHeight = self:getFrameHeight()*self.scaleNum
    end
    return self.nameTextHeight
end

function CompositeActionAllPart:setNameTextColor(color)
  self.nameTextField:setColor(color);
end

function CompositeActionAllPart:getFrameHeight()
    local fileName = self.bodySourceName .. "_"..self.action
    if self:hasCache(fileName) == false then return 0;end
    local height = getFrameContentSize(fileName).height
    return height > 240 and 240 or height
end

function CompositeActionAllPart:setBeadVisible(bool)
  if self.nameTextField then
      self.nameTextField:setVisible(bool)
  end
  if self.bloodProgressBar then
      self.bloodProgressBar:setVisible(bool)
  end
  if self.battleBuffer then
      self.battleBuffer:setVisible(bool)
  end
  self:setAttackEffectVisible(bool)
end

function CompositeActionAllPart:initMonsterDropItem(role)
    if role.dropItem then
        local daojuPO = analysis("Daoju_Daojubiao", role.dropItem);
        self.dropItemPO = daojuPO; 
    end
end

function CompositeActionAllPart:initMonsterDropDaoju(role)
  if role.dropDaoju then
    self.dropDaojuArray = role.dropDaoju; 
  end
end

function CompositeActionAllPart:addDropProperty()
    if self.dropItemEffect then
        self:removeChild(self.dropItemEffect)
        self.dropItemEffect = nil
    end
    local function callBack()
        self:removeChild(self.dropItemEffect)
        self.dropItemEffect = nil
    end
    self.dropItemEffect = cartoonPlayer("29",0,150,1,callBack,2);
    self:addChild(self.dropItemEffect)
end


function CompositeActionAllPart:setAlphaByValue(number)
    if self.weaponIcon then
        self.weaponIcon:setAlpha(number);
    end
    self.bodyIcon:setAlpha(number);
end

function CompositeActionAllPart:refreshBossAttackArea(roleVO,faceDirect,realKey,guildeTime)
    if not self.skillBossAttackArea  then
        self:initBossAttackArea()
    end
    self.skillBossAttackArea:setPosition(self:getPosition())
    self.skillBossAttackArea:refreshArea(faceDirect,realKey,guildeTime)
end

function CompositeActionAllPart:initBossAttackArea()
    require "main.view.battleScene.function.BattleBossAttackArea"
    self.skillBossAttackArea = BattleBossAttackArea.new()
    self.skillBossAttackArea:initLayer()
    self.skillBossAttackArea.touchEnabled = false
    self.skillBossAttackArea.touchChildren = false
    sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_MAP):addChild(self.skillBossAttackArea);
end

function CompositeActionAllPart:initHeroAttackArea(roleVO,skillId)
  if not self.heroAttackArea then
    require "main.view.battleScene.function.BattleHeroAttackArea"
    self.heroAttackArea = BattleHeroAttackArea.new()
    self.heroAttackArea:initLayer()
    self.heroAttackArea:setPosition(self:getPosition())
    sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_MAP):addChild(self.heroAttackArea);
  end
  self.heroAttackArea:initArea(roleVO,skillId)
end

function CompositeActionAllPart:setHeroAttackEffect2Visible(bool)
  if not self.bodySkillEffect2 then
    self.bodySkillEffect2 = cartoonPlayer("633",0,0,0,nil,1.5);
    self.bodySkillEffect2:setAnchorPoint(CCPointMake(0.5,0.1));
    self:addChild(self.bodySkillEffect2)
  end
  self.bodySkillEffect2:setVisible(bool)
end

function CompositeActionAllPart:setAttackEffectVisible(bool)
    if self.bodySkillEffect2 then
      self.bodySkillEffect2:setVisible(bool)
    end
end

function CompositeActionAllPart:setHeroAreaVisible(bool,faceDirect)
    if self.heroAttackArea then
        self.heroAttackArea:setAreaVisible(bool,faceDirect)
    end
end

function CompositeActionAllPart:removeDelayDeadTimer()
    if self.delayDeadTimer then
        Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.delayDeadTimer);
        self.delayDeadTimer = nil
    end
end

function CompositeActionAllPart:playDeadAnimation(aiEngin,faceDirect,deadBack)
  if self.hasPlayDead then return end
  self.hasPlayDead = true
  if self.bloodProgressBar then
    self.bloodProgressBar:setVisible(false)
  end
  self:removeTweenlite()
  self:removeDelayDeadTimer()
  self:removeHitPaowuxianTimer()
  self:removeLoopHandleTimer();
  if not self.sprite then return;end;
  if self.layerColor then
    self.layerColor:setVisible(false)
  end
  self:setAttackEffectVisible(false);
  -- local function playBack()
    self:PlayDeadFadeOut(faceDirect,deadBack)
    self:removeChild(self.bodyIcon);
    if aiEngin then
      aiEngin.roleVO.roleShadow:setVisible(false)
    end
  -- end
  -- self:playAndBack(3,playBack)
  if aiEngin then
    self:refreshDropDaoju(aiEngin)
  end
end

function CompositeActionAllPart:PlayDeadFadeOut(faceDirect,deadBack)
    local face = faceDirect and 1 or -1
    local cartoon2
    local function waitF2()
        self:getEffectIcon():removeChildren(cartoon2)
        self.parent:removeChild(self);
        if deadBack then
          deadBack()
        end
    end
    cartoon2 = cartoonPlayer("1548",0,0,1,waitF2,1,face);
    cartoon2:setAnchorPoint(CCPointMake(0.5,0.2));
    self:getEffectIcon():addChild(cartoon2)
end

function CompositeActionAllPart:setSlowNum(slowNum)
    self.slowNum = slowNum
end

function CompositeActionAllPart:jumpShiftIconXY(totalTime,hitTime,playSkill,roleVO)
        self:removeJumpTotalTimer()
        self:removeJumpHitTimer()
    local function totalTimerFun()
        self:removeJumpTotalTimer()
        self:removeJumpHitTimer()
        self.bodyIcon:setPositionXY(0,0)
    end
    self.jumpTotalTimer = Director:sharedDirector():getScheduler():scheduleScriptFunc(totalTimerFun, totalTime, false)
    local function hitTimerFun()
        if self.bodyIcon:getPositionX() == 0 then
            self.bodyIcon:setPositionX(20,12)
        else
            self.bodyIcon:setPositionX(0,0)
        end
    end
    self.jumpHitTimer = Director:sharedDirector():getScheduler():scheduleScriptFunc(hitTimerFun, hitTime, false)
end

function CompositeActionAllPart:removeJumpTotalTimer()
    if self.jumpTotalTimer then
        Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.jumpTotalTimer);
        self.jumpTotalTimer = nil
    end
end

function CompositeActionAllPart:removeJumpHitTimer()
    if self.jumpHitTimer then
        Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.jumpHitTimer);
        self.jumpHitTimer = nil
    end
end

function CompositeActionAllPart:refreshDropDaoju(aiEngin)
    if aiEngin.roleVO.needDropDaojuTable then
        aiEngin:refreshDropDaoju(aiEngin.roleVO.needDropDaojuTable,self:getPosition())
    end
end

function CompositeActionAllPart:removeLoopHandleTimer()
    if self.loopHandle then
        Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.loopHandle);
        self.loopHandle = nil
    end
end

function CompositeActionAllPart:removeTimeOutTimer(threeAttack)
    if self.timeOut then
        if threeAttack then
            self.hasPlayDead = nil
        end
        Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.timeOut);
        self.timeOut = nil
    end
end

-----------
--检查素材是否存在
-----------
function CompositeActionAllPart:hasCache(frameName)
    local frame = GameData.bitmapFrameArr[frameName];
    if frame then
      return true;
    elseif GameData.isCheckRoleSource then
      log("check resource"..frameName.."not exit");
      return false;
    else
      error("check resource"..frameName.."not exit");
      return true
    end
end

function CompositeActionAllPart:setStopTimer(bool)
    self.isStopTimer = bool
end

function CompositeActionAllPart:playStopSkillEffect()
    local itemEffect;
    local function callBack()
      sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_STOPSKILL):removeChild(itemEffect)
    end
    itemEffect = cartoonPlayer("1647",0, 0, 1, callBack, 4);
    sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_STOPSKILL):addChild(itemEffect)
    itemEffect:setPositionXY(self:getPositionX(),self:getPositionY()+100)
end

function CompositeActionAllPart:hitPaowuxianAnimation(roleVO,faceParam,width,height,zl,backFun,typeT,oldPy,playSkill)
    if self.hasPlayDead then return end
    if roleVO.currentHP <= 0 then
      self.hasPlayDead = true
    end
    self:removeTweenlite()
    self:removeHitPaowuxianTimer()
    self:removeLoopHandleTimer();
    local zl = -2
    local num = 2 
    if typeT == 1 then
        self:playAndStop(BattleConfig.BEATTACKED,BattleConfig.HIT_FLY)
    elseif typeT == 2 then
        self:playAndLoop(BattleConfig.HIT_FLY)
    end
    local vy = math.sqrt(2*(-zl)*height) 
    local leftFrame = vy/(-zl)--t=v/g
    local rightFrame = math.sqrt(2*(-zl)*oldPy)/(-zl)
    local oneH = 45;local oneW = 15
    local oneVy = math.sqrt(2*(-zl)*oneH)
    local oneUpFrame = oneVy/(-zl)
    local oneVx = oneW/oneUpFrame

    local twoH = 35;local twoW = 10
    local twoVy = math.sqrt(2*(-zl)*twoH)
    local twoUpFrame = twoVy/(-zl)
    local twoVx = twoW/twoUpFrame
    local vx = math.floor((width-oneW-twoW)/(leftFrame + rightFrame/num))
    vx = faceParam*vx
    local firstDown = true
    local maxHeight = 0
    local jumpTimes = 1
    local function loopHandleF()
      if self.isStopTimer then return end
      vy = vy + zl;
      self:setPositionX(self:getPositionX() + vx);
      self:setPositionY(self:getPositionY() + vy);
      if oldPy - self:getPositionY() >= maxHeight and firstDown then
        firstDown = false
        vx = vx/num
      end
      maxHeight = oldPy - self:getPositionY()
      if self:getPositionY() <= oldPy  then
          if (jumpTimes == 1) then
            vy = oneVy
            vx = math.floor(faceParam*oneVx)
            self:playAndBack(4)
            if roleVO.currentHP <= 0 then
                self:setAttackEffectVisible(false)
                self:refreshDropDaoju(playSkill.aiEngin,faceParam)
            end
          end
          if (jumpTimes == 2) then
            vy = twoVy
            vx = math.floor(faceParam*twoVx)
            self:playAndBack(4)
          end
          if (jumpTimes >= 3) then
            self:setPositionY(oldPy);
            self:removeHitPaowuxianTimer()
            if roleVO.currentHP <= 0 then
                self:playAndBack(4)
                if playSkill.aiEngin then

                  playSkill.aiEngin:deadAction()
                end
            else
                if backFun then
                  backFun()
                end
            end
            return
          end
          jumpTimes = jumpTimes + 1
      end
    end
    self.hitPaowuxianTimer = Director:sharedDirector():getScheduler():scheduleScriptFunc(loopHandleF, 0, false)
end

function CompositeActionAllPart:addDustEffect()
    -- if self.dustEffect then
    --     self:removeChild(self.dustEffect)
    --     self.dustEffect = nil
    -- end
    -- local function callBack()
    --     self:removeChild(self.dustEffect)
    --     self.dustEffect = nil
    -- end
    -- self.dustEffect = cartoonPlayer("82",0,0,1,callBack,1,nil,nil);
    -- self.dustEffect.touchChildren = false
    -- self.dustEffect.touchEnabled = false
    -- self:addChildAt(self.dustEffect,0)
end

function CompositeActionAllPart:removeHitPaowuxianTimer()
    if self.hitPaowuxianTimer then
        Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.hitPaowuxianTimer);
        self.hitPaowuxianTimer = nil
    end
end

function CompositeActionAllPart:hitHalfPaowuxianAnimation(roleVO,faceParam,px,py,zl,backFun,speed,playSkill)
    local function animationComplete()
      if backFun then
        backFun()
      end
    end
    local upArray = CCArray:create();
    local moveUp = CCMoveBy:create(math.abs(px/speed), ccp(px,py));
    local upCallBack = CCCallFunc:create(animationComplete);
    upArray:addObject(moveUp);
    upArray:addObject(upCallBack);
    self:runAction(CCSequence:create(upArray))
    self:jumpShiftIconXY(math.abs(px/speed),0.1,playSkill,roleVO)
    self:playAndStop(BattleConfig.BEATTACKED,BattleConfig.HIT_FLY)
end
