--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-2-18

]]

require "core.display.Layer";
require "core.events.DisplayEvent";
require "core.controls.Image";
require "core.utils.CommonUtil";
require "core.utils.LayerColorBackGround";
require "core.display.LayerPopable";
require "main.view.hero.heroHouse.ui.HeroHousePageView"

HeroHousePopup=class(LayerPopableDirect);

function HeroHousePopup:ctor()
  self.class=HeroHousePopup;
end

function HeroHousePopup:dispose()
	HeroHousePopup.superclass.dispose(self);
end

function HeroHousePopup:onDataInit()
  TimeCUtil:star()
  self.skeleton = getSkeletonByName("hero_house_ui");
  self.userProxy = self:retrieveProxy(UserProxy.name);
  self.heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);

  local layerPopableData = LayerPopableData.new();
  layerPopableData:setHasUIBackground(true);
  layerPopableData:setHasUIFrame(true);
  layerPopableData:setPreUIData(StaticArtsConfig.BACKGROUD_HERO_HOUSE, nil, true, 2);
  layerPopableData:setArmatureInitParam(self.skeleton,"heroHouse_ui");
  self:setLayerPopableData(layerPopableData);

  self.slots = {};TimeCUtil:getTime("onDataInit")
end

function HeroHousePopup:initialize()
  
end

function HeroHousePopup:onPrePop()
  -- local image = Image.new();
  -- image:loadByArtID(204);
  -- image:setScale(2);
  -- self:addChildAt(image,0);
TimeCUtil:getTime("onPrePop")
  local size=Director:sharedDirector():getWinSize();
  self:changeWidthAndHeight(size.width,size.height);

  local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
  self:setData();

  local closeButton =self.armature.display:getChildByName("close_button");
  SingleButton:create(closeButton);
  closeButton:addEventListener(DisplayEvents.kTouchTap, self.closeUI, self);
TimeCUtil:getTime("onPrePop")
  -- self.pLabelFont=BitmapTextField.new("英雄库","anniutuzi");
  -- self.pLabelFont:setScale(1.2);
  -- self.pLabelFont:setPositionXY(576,637);
  -- self:addChild(self.pLabelFont);
end

function HeroHousePopup:setData()
  self:setContentSize(makeSize(1280,720));

  self.pageTF = generateText(self,self.armature,"pageTF","10/10",true);
  -- self.rankBtn = generateButton(self.armature,"common_small_blue_button","common_blue_button","排序",self.onRank,self,_,_,true);
  local leftBtn =self.armature.display:getChildByName("common_copy_leftArrow_button");
  local rightBtn =self.armature.display:getChildByName("common_copy_rightArrow_button");
  local function refreshBTN()
    if 1 >= self.pageView:getCurrentPage() then
      leftBtn:setVisible(false);
    else
      leftBtn:setVisible(true);
    end
    if self.pageView:getCurrentPage() >= self.pageView.maxPageNum then
      rightBtn:setVisible(false);
    else
      rightBtn:setVisible(true);
    end
  end
  function onLeftTap(heroId)
    local curPage = self.pageView:getCurrentPage();
    if curPage > 1 then
      self.pageView:setCurrentPage(curPage - 1);
    end;
    refreshBTN();
  end
  function onRightTap(heroId)
    local curPage = self.pageView:getCurrentPage();
    local maxPage = self.pageView:getCurrentPage();
    if curPage < self.pageView.maxPageNum then
      self.pageView:setCurrentPage(curPage + 1);
    end
    refreshBTN();
  end
  self.refreshBTN = refreshBTN;

  -- local leftBtn = SingleButton:create(self.armature.display:getChildByName("common_copy_leftArrow_button"),onLeftTap);
  -- local rightBtn = SingleButton:create(self.armature.display:getChildByName("common_copy_rightArrow_button"),onRightTap);
  
  SingleButton:create(leftBtn);
  leftBtn:addEventListener(DisplayEvents.kTouchTap, onLeftTap);
  
  SingleButton:create(rightBtn);
  rightBtn:addEventListener(DisplayEvents.kTouchTap, onRightTap);

  local layerColor = LayerColor.new();
  layerColor:initLayer();
  layerColor:setOpacity(0);
  layerColor:setContentSize(makeSize(115,725));
  layerColor:setPositionX(0);
  self.armature.display:addChildAt(layerColor,3);

  local layerColor = LayerColor.new();
  layerColor:initLayer();
  layerColor:setOpacity(0);
  layerColor:setContentSize(makeSize(120,725));
  layerColor:setPositionX(1155);
  self.armature.display:addChildAt(layerColor,3);

  -- self.heroNumTF = generateText(self,self.armature,"heroNumTF","已拥有0/200个英雄",true,ccc3(0,0,0),2);  
  self:refreshPageView();
  -- self.cardCon = self.armature.display:getChildByName("menueRender");
  -- self.cardCon:setVisible(false);

  -- self.rankArmature = self.armature:findChildArmature("menueRender");
  -- -- self.rankBtn1 = generateButtonByPrivateFla(self.skeleton,self.rankArmature,"rankBtn1","heroComponent/武将库/rank_button","rank_button","按时间降序",self.onRankFun,self);
  -- self.rankBtn1 = generateButtonByPrivateFla(self.skeleton,self.rankArmature,"rankBtn1","heroComponent/武将库/rank_button","rank_button","按战力降序",self.onRankFun,self);
  -- self.rankBtn2 = generateButtonByPrivateFla(self.skeleton,self.rankArmature,"rankBtn2","heroComponent/武将库/rank_button","rank_button","按星级降序",self.onRankFun,self);
  -- self.rankBtn3 = generateButtonByPrivateFla(self.skeleton,self.rankArmature,"rankBtn3","heroComponent/武将库/rank_button","rank_button","按星级升序",self.onRankFun,self);
end

function HeroHousePopup:refreshPageView()
  local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
  self.rank_num = 3;
  local itemTb = heroHouseProxy:getGeneralArray4HeroHouse();--serverData
  local num = table.getn(itemTb);
  for k,v in pairs(itemTb) do
    if v.Holder then
      num = -1 + num;
    end
  end
  self.pageViewData = itemTb;
  self.pageView = HeroHousePageView:create(self,itemTb,self.pageTF,self.onCardTap);
  self.pageView:setPositionXY(15, -1145);
  self.armature.display:getChildByName("cardCon"):addChild(self.pageView);
  local function onPageViewScrollStoped()
    self.pageView:onPageViewScrollStoped();
    self.refreshBTN();
    local currentPage = self.pageView:getCurrentPage();
    if self.pageTF then
      self.pageTF:setString(currentPage.."/"..self.pageView.maxPageNum)
    end

  end
  self.pageView:registerScrollStopedScriptHandler(onPageViewScrollStoped);
  -- self.heroNumTF:setString("已拥有"..num.."/200个英雄");
  if self.currentPage then
    if 1 > self.currentPage then self.currentPage = 1; end
    if self.pageView.maxPageNum < self.currentPage then self.currentPage = self.pageView.maxPageNum; end
    self.pageView:setCurrentPage(self.currentPage);
    self.currentPage = nil;
  end
  self.refreshBTN();
end

function HeroHousePopup:onCardTap(items)
  self.currentPage = self.pageView:getCurrentPage();
  self.pageView:setMoveEnabled(false);
  self:dispatchEvent(Event.new("openProNotice",items,self));
end

function HeroHousePopup:onRank()
  self.cardCon:setVisible(not self.cardCon.visible);
end

function HeroHousePopup:onRankFun(event)
  local name = event.target.name;
  local itemTb = {};
  local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
  if name == "rankBtn1" then
    self.rank_num = 2;
    itemTb = heroHouseProxy:getGeneralArrayByType(self.rank_num);--serverData
  elseif name == "rankBtn2" then
    self.rank_num = 3;
    itemTb = heroHouseProxy:getGeneralArrayByType(self.rank_num);--serverData
  elseif name == "rankBtn3" then
    self.rank_num = 4;
    itemTb = heroHouseProxy:getGeneralArrayByType(self.rank_num);--serverData
  elseif name == "rankBtn4" then
    itemTb = heroHouseProxy:getGeneralArrayByType(4);--serverData
  end;
  self.pageView:update(itemTb);
  self.cardCon:setVisible(not self.cardCon.visible);
  hecDC(3,4,2);
end

function HeroHousePopup:refreshOnProClose()
	local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
  local data = heroHouseProxy:getGeneralArray4HeroHouse();
	self.pageView:update(data);
  if self.JihuoCache then
    for k,v in pairs(data) do
      if self.JihuoCache == v.ConfigId then
        self.pageView:setCurrentPage(1+math.floor((-1+k)/6));
        break;
      end
    end
    self.JihuoCache = nil;
  end
  self.pageViewData = data;
end

function HeroHousePopup:onUIInit()

end

function HeroHousePopup:onRequestedData()
  
end

function HeroHousePopup:onPreUIClose()

end

function HeroHousePopup:setCurrentPage(page)
  self.pageView:setCurrentPage(page);
end

function HeroHousePopup:onUIClose()
	self:dispatchEvent(Event.new("closeNotice",nil,self));
end

function HeroHousePopup:refreshRedDot()
  for k,v in pairs(self.slots) do
    v:refreshRedDot();
  end
end

function HeroHousePopup:popCardByJihuo()
  if self.JihuoCachePosID and self.JihuoCacheID then
    local posID;
    local data;
    for k,v in pairs(self.pageViewData) do
      if self.JihuoCacheID == v.ConfigId then
        posID = k;
        data = v;
        break;
      end
    end
    self.JihuoCachePosID = makePoint(85*((-1+self.JihuoCachePosID)%6)+105,360);
    posID = makePoint(85*((-1+posID)%6)+105,360);
    self:popCard(data,self.JihuoCachePosID,posID);
  end
  self.JihuoCachePosID = nil;
  self.JihuoCacheID = nil;
end

function HeroHousePopup:refreshOnPopCard()
  print("refreshOnPopCard",self.JihuoCacheID);
  local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
  local data = heroHouseProxy:getGeneralArray4HeroHouse();
  self.pageView:update(data);
  if self.JihuoCacheID then
    for k,v in pairs(data) do
      print(v.ConfigId);
      if self.JihuoCacheID == v.ConfigId then
        self.pageView:setCurrentPage(1+math.floor((-1+k)/6));
        break;
      end
    end
  end
  self.pageViewData = data;
end

function HeroHousePopup:popCard(data, pos1, pos2)
  self.pageView:setMoveEnabled(false);

  local bg_layer = LayerColorBackGround:getTransBackGround();
  bg_layer:setPositionXY(-GameData.uiOffsetX,-GameData.uiOffsetY);
  self:addChild(bg_layer);

  local layer = Layer.new();
  layer:initLayer();
  self:addChild(layer);

  local actionArr1 = CCArray.create()
  local actionArr2 = CCArray.create()

  local _boneCartoon3 = BoneCartoon.new()
  _boneCartoon3:create(StaticArtsConfig.BONE_EFFECT_373,0);
  _boneCartoon3:setMyBlendFunc()
  _boneCartoon3:setPositionXY(GameConfig.STAGE_WIDTH / 2,GameConfig.STAGE_HEIGHT / 2)
  layer:addChild(_boneCartoon3);

  -- local scaleSlot = HeroProScaleSlot.new();
  -- scaleSlot:initialize(_heroSkeleton, data, makePoint(0,0));
  -- scaleSlot:getCard():setScale(0.3)

  local _cardUI = HeroProScaleSlot.new();
  _cardUI:initialize(nil, data, makePoint(0,0));
  -- _cardUI:setScale(0.25)
  -- layer:addChild(_cardUI);

  local card = DisplayNode:create();
  card:setAnchorPoint(makePoint(0.5, 0.5));
  card:setPosition(pos1);
  card:addChild(_cardUI);
  card:setScale(0.25);
  layer:addChild(card);

  local function _callBackFunc()
    local _touchLayer = Layer.new()
    _touchLayer:initLayer()
    _touchLayer:setContentSize(Director:sharedDirector():getWinSize())
    layer:addChild(_touchLayer)

    local function _onclickTouchLayer()
      layer:removeChild(_boneCartoon3)
      _touchLayer:removeEventListener(DisplayEvents.kTouchTap,_onclickTouchLayer,self)
      layer:removeChild(_touchLayer)

      local function _callBackFunc1()
        self:removeChild(bg_layer);
        self:removeChild(layer);
        self.pageView:setMoveEnabled(true);
        self:checkTutor();
      end

      local actionArr3 = CCArray.create()
      local actionArr4 = CCArray.create()
      actionArr3:addObject(CCScaleTo:create(0.1,0.15,0.15))
      actionArr3:addObject(CCRotateBy:create(0.1 , 360))
      actionArr3:addObject(CCMoveTo:create(0.1, pos2))
      actionArr4:addObject(CCSpawn:create(actionArr3))
      actionArr4:addObject(CCCallFunc:create(_callBackFunc1))
      card:runAction(CCSequence:create(actionArr4))

    end

    _touchLayer:addEventListener(DisplayEvents.kTouchTap,_onclickTouchLayer,self)

  end

  actionArr2:addObject(CCScaleTo:create(0.15,1.15,1.15))
  actionArr2:addObject(CCRotateBy:create(0.15 , 360))
  actionArr2:addObject(CCMoveTo:create(0.15, ccp(GameConfig.STAGE_WIDTH/2, GameConfig.STAGE_HEIGHT/2)))
  actionArr1:addObject(CCSpawn:create(actionArr2))
  actionArr1:addObject(CCCallFunc:create(_callBackFunc))
  card:runAction(CCSequence:create(actionArr1))
end

function HeroHousePopup:checkTutor()
    if GameVar.tutorStage == TutorConfig.STAGE_1006 then
      -- local xPos, page = self:getXPosByConfigId(77);--36是秦般若,44宫羽,飞流40,16是萧景睿,77晏大夫
      -- if page > 1 then
      --   self:setCurrentPage(page)
      -- end
      -- openTutorUI({x=xPos , y=109, width = 151, height = 476, alpha = 125});
      openTutorUI({x=1178 , y=636, width = 78, height = 75, alpha = 125});
    end
end
function HeroHousePopup:getXPosByConfigId(configId)
    local generalArr = self.heroHouseProxy:getGeneralArray4HeroHouse();
    local index = 0;
    local isPlay = 1;
    for k, v in ipairs(generalArr) do
      index = index + 1;
      if v.ConfigId == configId then--宫羽
        isPlay = v.IsPlay;
        break;
      end
    end

    local page = math.ceil(index/6);
    local pageFix = (index - 1)%6;

    return 116 + 181 * pageFix, page
end