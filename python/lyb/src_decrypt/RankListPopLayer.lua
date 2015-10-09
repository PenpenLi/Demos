RankListPopLayer=class(Layer);

function RankListPopLayer:ctor()
  self.class=RankListPopLayer;
end

function RankListPopLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	RankListPopLayer.superclass.dispose(self);
end

function RankListPopLayer:initialize(context, data)
  self.context = context;
  self.data = data;

  self:initLayer();
  -- local image = Image.new();
  -- image:loadByArtID(717);
  -- self:addChildAt(image,0);
  AddUIBackGround(self, StaticArtsConfig.BACKGROUD_HERO_HOUSE, nil, true, 1);

  --骨骼
  local armature=self.context.skeleton:buildArmature("rank_pop_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose = armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  self.pageView = RankListPageView.new(CCPageView:create());
  self.pageView:initialize(self.context);
  self.pageView:setPositionXY(85,-500);
  self.armature:addChildAt(self.pageView,0);

  local layerColor = LayerColor.new();
  layerColor:initLayer();
  layerColor:setOpacity(0);
  layerColor:setContentSize(makeSize(115,725));
  layerColor:setPositionX(0);
  self.armature:addChild(layerColor);

  local layerColor = LayerColor.new();
  layerColor:initLayer();
  layerColor:setOpacity(0);
  layerColor:setContentSize(makeSize(120,725));
  layerColor:setPositionX(1155);
  self.armature:addChild(layerColor);

  self.leftButton =self.armature4dispose.display:getChildByName("left_button");
  SingleButton:create(self.leftButton);
  self.leftButton:addEventListener(DisplayEvents.kTouchTap, self.onLeftButtonTap, self);
  self.armature:removeChild(self.leftButton,false);
  self.armature:addChild(self.leftButton);

  self.rightButton =self.armature4dispose.display:getChildByName("right_button");
  SingleButton:create(self.rightButton);
  self.rightButton:addEventListener(DisplayEvents.kTouchTap, self.onRightButtonTap, self);
  self.armature:removeChild(self.rightButton,false);
  self.armature:addChild(self.rightButton);

  self.closeButton =self.armature4dispose.display:getChildByName("common_copy_close_button");
  SingleButton:create(self.closeButton);
  self.closeButton:addEventListener(DisplayEvents.kTouchTap, self.closeUI, self);
  self.armature:removeChild(self.closeButton,false);
  self.armature:addChild(self.closeButton);

  self.context:requestData(self.data);
end

function RankListPopLayer:onLeftButtonTap(event)
  --self.pageView:setCurrentPage(-1+self.pageView:getCurrentPage());
  local curPage = self.pageView:getCurrentPage();
  if curPage > 1 then
    self.pageView:setCurrentPage(curPage - 1);
  end
end

function RankListPopLayer:onRightButtonTap(event)
  --self.pageView:setCurrentPage(1+self.pageView:getCurrentPage());
  local curPage = self.pageView:getCurrentPage();
  if curPage < self.pageView.maxPageNum then
    self.pageView:setCurrentPage(curPage + 1);
  end
end

function RankListPopLayer:closeUI(event)
  self.parent:removeChild(self);
end

function RankListPopLayer:refreshData(type, rankArray)
  local function sortFunc(data_a, data_b)
    return data_a.Ranking < data_b.Ranking;
  end
  table.sort(rankArray, sortFunc);
  if rankArray[2] then
    local temp = table.remove(rankArray,2);
    table.insert(rankArray,1,temp);
  end
  local datas = {};
  local temp;
  for i=1,10 do
    if rankArray[i] then
      if 1 == i or 4 == i or 7 == i or 10 == i then
        temp = {};
        table.insert(datas,temp);
      end
      table.insert(temp,rankArray[i]);
    else
      break;
    end
  end
  self.pageView:update(datas);
end