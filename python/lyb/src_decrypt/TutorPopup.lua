require "main.view.tutor.ui.item.PersonItem"
require "core.utils.GuideImageLayer"
TutorPopup=class(TouchLayer);

function TutorPopup:ctor()
  self.class=TutorPopup;
  self.handItem = nil;
  self.layers = {};
  self.handItemX = nil;
  self.handItemY = nil;
  self.personItemX = nil;
  self.personItemY = nil;
end
function TutorPopup:dispose()
  self:remveTickID2()
  self:removeAllEventListeners();
  self:removeChildren();
  TutorPopup.superclass.dispose(self);
  BitmapCacher:removeUnused();
end

function TutorPopup:initializeUI(skeleton, userProxy, data)
  self.skeleton = skeleton;
  self.userProxy = userProxy;

  self.data = data;
  self:initLayer();
  self.touchEnabled=false;
  self.layers = {};
  for i = 1, 4 do
     local layerColor = LayerColor.new();
     layerColor:initLayer();

      layerColor:setColor(ccc3(0,0,0));
      layerColor:setOpacity(0);
      table.insert(self.layers, layerColor)
  end
  local mainSize = Director:sharedDirector():getWinSize();
  self:changeWidthAndHeight(mainSize.width, mainSize.height)
  
  self.realWidth = mainSize.width;
  self.realHeight = mainSize.height;

  self:refreshData(data);

end
--isShowTip是否显示手型提示, isForceTutor是不是强制引导，如果是强制引导其他地方不能点(压黑任务不强制)
function TutorPopup:refreshData(data)

  -- if data.fullScreenTouchable then
  -- else
  -- end

  self.data = data;

  if self.data.delay and self.data.delay > 0 then
     local function tick2(dt)
        self:remveTickID2();
        self:setTutorData();
     end
     if not self.updateTickID2 then
        self.updateTickID2 = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(tick2, self.data.delay, false);  
     end
     
     local topLayer = self.layers[1];
     local mainSize = Director:sharedDirector():getWinSize();
     topLayer:changeWidthAndHeight(mainSize.width, mainSize.height);
     self:hideHand();
     for k, v in pairs(self.layers)do
        v:setOpacity(0)
     end
  else
     self:setTutorData();
  end
end

function TutorPopup:remveTickID2()
  if self.updateTickID2 then
    CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.updateTickID2);
    self.updateTickID2 = nil;
  end
end

function TutorPopup:setTutorData()
  MusicUtils:stopEffect()
  
  if self.alertCartoon then
    self:removeChild(self.alertCartoon);
    self.alertCartoon = nil;
  end

  local x, y, width, height, step  = self.data.x, self.data.y, self.data.width, self.data.height, self.data.step;
  local isForceTutor = true;--默认是true强制引导
  if self.data.isForceTutor ~= nil then
    isForceTutor = self.data.isForceTutor;
  end

  self.showWidth, self.showHeight = width, height
  if not isForceTutor then
    x, y, width, height = 0,0,self.realWidth,self.realHeight;
    self.data.x, self.data.y = 0, 0
    self.showWidth, self.showHeight = self.realWidth, 720
  end

  x = x and x or 0;
  y = y and y or 0;
  width = width and width or 1;
  height = height and height or 1;
  print("x, y, width, height", x, y, width, height)
  print("x+width,  y+height", (2*x+width)/2, (2*y+height)/2)
  -- local alpha = 0-- or 0;--0表示透明
  -- if self.data.alpha == 255 then
  --    alpha = 255;
  -- end
  -- local alpha = self.data.alpha;
  local alpha = 71;
  local mainSize = Director:sharedDirector():getWinSize();
  self.data.alpha = alpha
--topLayer
  local topLayer = self.layers[1];
  if self.data.alpha then
    topLayer:setOpacity(alpha);
  else
    topLayer:setOpacity(0);
  end
  topLayer:setPositionXY(0, 0);
  local topHeight = y > 0 and y or 1
  topLayer:changeWidthAndHeight(self.data.fullScreenTouchable and 1 or mainSize.width, self.data.fullScreenTouchable and 1 or topHeight);
  self:addChild(topLayer);
  topLayer:addEventListener(DisplayEvents.kTouchTap, self.onClickBlack, self);


--leftLayer
  local leftLayer = self.layers[2];
  if self.data.alpha then
    leftLayer:setOpacity(alpha);
  else
    leftLayer:setOpacity(0);
  end
  local leftWidth = x > 0 and x or 1
  leftLayer:changeWidthAndHeight(self.data.fullScreenTouchable and 1 or leftWidth, self.data.fullScreenTouchable and 1 or height);
  leftLayer:setPositionXY(0, y);
  self:addChild(leftLayer);
  leftLayer:addEventListener(DisplayEvents.kTouchTap, self.onClickBlack, self);


--bottomLayer
  local bottomLayer = self.layers[3];
  if self.data.alpha then
    bottomLayer:setOpacity(alpha);
  else
    bottomLayer:setOpacity(0);
  end
  bottomLayer:setPositionXY(0, y + height);
  local bottomHeight = mainSize.height - y - height;
  if bottomHeight < 1 then
    bottomHeight = 1;
  end
  bottomLayer:changeWidthAndHeight(self.data.fullScreenTouchable and 1 or mainSize.width, self.data.fullScreenTouchable and 1 or bottomHeight);
  self:addChild(bottomLayer);
  bottomLayer:addEventListener(DisplayEvents.kTouchTap, self.onClickBlack, self);

--rightLayer
  local rightLayer = self.layers[4];
  if self.data.alpha then
    rightLayer:setOpacity(alpha);
  else
    rightLayer:setOpacity(0);
  end
  rightLayer:setPositionXY(x + width, y);
  local rightWidth = mainSize.width - x - width;
  if rightWidth < 1 then
   rightWidth = 1;
  end
  rightLayer:changeWidthAndHeight(self.data.fullScreenTouchable and 1 or rightWidth, self.data.fullScreenTouchable and 1 or height);  
  self:addChild(rightLayer);
  rightLayer:addEventListener(DisplayEvents.kTouchTap, self.onClickBlack, self);

  if self.blackBgLayer then
    self:removeChild(self.blackBgLayer);
    self.blackBgLayer = nil;
  end

  if self.data.blackBg then
    self.blackBgLayer = LayerColor.new();
    self.blackBgLayer:initLayer();
    self.blackBgLayer:changeWidthAndHeight(mainSize.width, mainSize.height);  
    self.blackBgLayer.touchEnabled = false;
    self.blackBgLayer:setColor(ccc3(0,0,0));
    self.blackBgLayer:setOpacity(self.data.alpha);
    self:addChild(self.blackBgLayer)
  end

  if self.data.x2 and self.data.y2 and self.data.x3 and self.data.y3 then
    print("self.data.changeHero=============================")
    self:runHandItem2Action();
    if self.boneLightCartoon then
      self.boneLightCartoon:setVisible(false)
    end
    self:removePersonItem();
  else
    self:removeHandItem2Action();
    self:setEffect((2*x+width)/2+10, (2*y+height)/2+15)
  end

  if self.data.hideTutorHand or self.data.twinkle then
    self.boneLightCartoon:setVisible(false)
  end
--Layer end

  if self.data.isBattle then
    if analysisHas("Xinshouyindao_Xinshou", step)then
      print("++++++++++++++++++++++++++++++da dian step", step)
      hecDC(5, step)
      local xinshouPo = analysis("Xinshouyindao_Xinshou", step)
      if xinshouPo.DialogueType == 1 then
        print("xinshouPo.DialogueType == 1")
        self:setPersonPosition(step)
      end
    end
  else
      GameVar.tutorSmallStep = GameVar.tutorSmallStep % 100
      GameVar.tutorSmallStep = GameVar.tutorSmallStep + 1;
      self:removePersonItem();
      if self.boneLightCartoon and not self.data.twinkle and not self.data.hideTutorHand then
        self.boneLightCartoon:setVisible(true)
      end
      step = GameVar.tutorStage * 100 +  GameVar.tutorSmallStep

      if analysisHas("Xinshouyindao_Xinshou", step)then
        print("++++++++++++++++++++++++++++++da dian step", step)
        hecDC(5, step)
        local xinshouPo = analysis("Xinshouyindao_Xinshou", step)
        if xinshouPo.DialogueType ~= 0 then
          if xinshouPo.DialogueType == 1 then
            print("xinshouPo.DialogueType == 1")
            self:setPersonPosition(step)
            -- self:removeHandItem2Action();
          end
        end
      end
      print("GameVar.tutorSmallStep", GameVar.tutorSmallStep)
  end

  if GameData.platFormID == GameConfig.PLATFORM_CODE_LAN and not self.data.isBattle then--
    self.button=CommonButton.new();
    self.button:initialize("commonButtons/common_small_blue_button_normal",nil,CommonButtonTouchable.BUTTON,nil,nil,true);
    self.button:initializeText({x=15,y=-40,size=24,width=150,height=30,color=16777215,alignment=kCCTextAlignmentLeft},"跳过引导");
    self.button:setPositionXY(0,670)
    self:addChild(self.button)
    self.button:addEventListener(DisplayEvents.kTouchTap,self.onSkipTutor,self);
  end
end
function TutorPopup:onSkipTutor(event)
  GameVar.skipTutor = true;
  sendServerTutorMsg({});
  closeTutorUI();
end
function TutorPopup:onClickBlack(event)

  if not self.alertCartoon then
    local xPos = (2*self.data.x + self.data.width)/2;
    local yPos = (2*self.data.y + self.data.height)/2;
    local function callBack()
      if self.alertCartoon then
        self:removeChild(self.alertCartoon);
        self.alertCartoon = nil;
      end
    end
    self.alertCartoon = cartoonPlayer("1549",xPos, yPos, 1, callBack)
    self:addChild(self.alertCartoon);
  end
  -- sharedTextAnimateReward():animateStartByString("请点击手指所指的位置");
end

function TutorPopup:runHandItem2Action()
   
  local moveTo = CCMoveTo:create(1, ccp(self.data.x3, self.data.y3))
  local moveTo2 = CCMoveTo:create(0, ccp(self.data.x2, self.data.y2))

  if not self.handItem2 then
    self.handItem2 = BoneCartoon.new()
    self.handItem2:create(StaticArtsConfig.BONE_EFFECT_TUTOR,0);
    self.handItem2:setMyBlendFunc()
    self:addChild(self.handItem2);
    self.handItem2.touchEnabled = false;
    self.handItem2:setPositionXY(self.data.x2, self.data.y2);
  else
    self.handItem2:stopAllActions();
    self.handItem2:setPositionXY(self.data.x2, self.data.y2);
  end
  self.handItem2:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(moveTo, moveTo2)))

end
function TutorPopup:removeHandItem2Action()
        
  if self.handItem2 then
    self:removeChild(self.handItem2)
    self.handItem2 = nil;
  end

end
function TutorPopup:setPersonPosition(step)
  self.personItem = PersonItem.new();
  self.personItem:initializeUI(step, self);
  self:addChild(self.personItem);

  -- self.personItem = GuideImageLayer.new()
  -- self.personItem:initLayerData2(step)
  -- self:addChild(self.personItem)
  -- self.personItem:startAnimation()

end

function TutorPopup:removePersonItem()
  if self.personItem then
    self:removeChild(self.personItem)
    self.personItem = nil;
  end
end
function TutorPopup:setEffect(xPos, yPos)
  if self.data.twinkle then
    if not self.twinkleCartoon then
      self.twinkleCartoon = cartoonPlayer("1165",xPos, yPos, 0)
      self:addChild(self.twinkleCartoon);
    else
      self.twinkleCartoon:setPositionXY(xPos, yPos)
    end
    self.boneLightCartoon:setVisible(false);
  else   
    if not self.boneLightCartoon then
      self.boneLightCartoon = BoneCartoon.new()
      self.boneLightCartoon:create(StaticArtsConfig.BONE_EFFECT_TUTOR,0);
      self.boneLightCartoon:setMyBlendFunc()
      self:addChild(self.boneLightCartoon);
    end
    self.boneLightCartoon:setVisible(true);
    self.boneLightCartoon:setPositionXY(xPos, yPos)
    print("xPos, yPos", xPos, yPos)

    if self.twinkleCartoon then
      self:removeChild(self.twinkleCartoon);
      self.twinkleCartoon = nil;
    end
  end
end

function TutorPopup:hideHand()
  if self.boneLightCartoon ~= nil then
     self.boneLightCartoon:setVisible(false);
     self.boneLightCartoon.sprite:stopAllActions(); 
  end
end


