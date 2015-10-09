
ArenaRankingLayer=class(Layer);

function ArenaRankingLayer:ctor()
  self.class=ArenaRankingLayer;
  require "main.view.arena.ui.ArenaRankingItem";
end

function ArenaRankingLayer:dispose()
	self:removeAllEventListeners();
	self:removeChildren();
	ArenaRankingLayer.superclass.dispose(self);
    self.popUp = nil
end

--intialize UI
function ArenaRankingLayer:initialize(popUp)
    if self.popUp then return end;
    self.popUp = popUp;
    self:initLayer();

    local layerColor = LayerColorBackGround:getBackGround()
    self:addChild(layerColor);

    local armature=self.popUp.skeleton:buildArmature("phb_ui");
    self.armature = armature;
    armature.animation:gotoAndPlay("f1");
    armature:updateBonesZ();
    armature:update();

    local armature_d=armature.display;
    self:addChild(armature_d);
    self.armature_d = armature_d;

    self.closeButton =armature_d:getChildByName("common_copy_close_button");
    SingleButton:create(self.closeButton);
    self.closeButton:addEventListener(DisplayEvents.kTouchTap, self.onCloseButtonTap, self);

    local headTitleP = armature_d:getChildByName("headTitle"):getPosition()
    local titleBg = CommonSkeleton:getBoneTextureDisplay("commonImages/common_huaWen2");
    titleBg:setScale(0.8)
    titleBg:setPosition(headTitleP)
    self:addChild(titleBg)
    
    self.headTitleText=BitmapTextField.new("论剑排行", "anniutuzi");
    self.headTitleText:setPositionXY(headTitleP.x+93,headTitleP.y+8)
    self:addChild(self.headTitleText)

    self:initListView()
end

function ArenaRankingLayer:initListView()
    self.viewList = ListScrollViewLayer.new();
    self.viewList:initLayer();
    self.viewList:setPositionXY(362,55)
    self.viewList:setViewSize(makeSize(595,545));
    self.viewList:setItemSize(makeSize(595,135));
    self:addChild(self.viewList);
end

--移除
function ArenaRankingLayer:onCloseButtonTap(event)
      self.popUp:closeArenaRankingLayer()
end

function ArenaRankingLayer:refreshRankingData()
    self.viewList:removeAllItems()
    for key,rankVO in pairs(self.popUp.arenaProxy.rankArray) do
        local rankingItem = ArenaRankingItem.new()
        rankingItem:initLayer()
        rankingItem:initializeItem(self.popUp.skeleton,rankVO)
        self.viewList:addItem(rankingItem)
    end
end