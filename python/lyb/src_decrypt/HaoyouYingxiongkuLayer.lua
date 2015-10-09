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

HaoyouYingxiongkuLayer=class(LayerPopableDirect);

HaoyouYingxiongkuLayer.inited = nil;
function HaoyouYingxiongkuLayer:clean()
  local bool = false;
  if HaoyouYingxiongkuLayer.inited and not HaoyouYingxiongkuLayer.inited.isDisposed then
    HaoyouYingxiongkuLayer.inited.parent:removeChild(HaoyouYingxiongkuLayer.inited);
    bool = true;
  end
  HaoyouYingxiongkuLayer.inited = nil;
  return bool;
end

function HaoyouYingxiongkuLayer:ctor()
  self.class=HaoyouYingxiongkuLayer;
  HaoyouYingxiongkuLayer:clean();
  HaoyouYingxiongkuLayer.inited = self;
end

function HaoyouYingxiongkuLayer:dispose()
	HaoyouYingxiongkuLayer.superclass.dispose(self);
end

function HaoyouYingxiongkuLayer:initialize(data)
  self.rankGeneralArray = data;

  self:initLayer();
  local size=Director:sharedDirector():getWinSize();
  self:changeWidthAndHeight(size.width,size.height);

  self.skeleton = getSkeletonByName("hero_house_ui");
  -- local img = Image.new();
  -- img:loadByArtID(StaticArtsConfig.BACKGROUD_HERO_HOUSE);
  -- img:setScale(2);
  -- self:addChild(img);

  --骨骼
  local armature=self.skeleton:buildArmature("heroHouse_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature;
  self:addChild(self.armature.display);

  AddUIBackGround(self,StaticArtsConfig.BACKGROUD_HERO_HOUSE, nil, true, 2);

  local closeButton =self.armature.display:getChildByName("close_button");
  SingleButton:create(closeButton);
  closeButton:addEventListener(DisplayEvents.kTouchTap, self.onClose, self);

  self.slots = {};
  self:setData();
  sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_EFFECTS):addChild(self);
end

function HaoyouYingxiongkuLayer:setData()
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

function HaoyouYingxiongkuLayer:refreshPageView()
  local itemTb = self.rankGeneralArray;--serverData
  local num = table.getn(itemTb);
  for k,v in pairs(itemTb) do
    if v.Holder then
      num = -1 + num;
    end
  end
  self.pageViewData = itemTb;
  self.pageView = HeroHousePageView:create(self,itemTb,self.pageTF,self.onCardTap,true);
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

function HaoyouYingxiongkuLayer:onClose()
  self.parent:removeChild(self);
end