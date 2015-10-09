require "main.view.shadow.ui.heroImage.ShadowZhuanLayer"

ShadowZhuanPopup=class(LayerPopableDirect);

function ShadowZhuanPopup:ctor()
  self.class=ShadowZhuanPopup;
  self.wordVisible = true;
  self.itemTable = {};
  self.currentPage = 1;
end

function ShadowZhuanPopup:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	ShadowZhuanPopup.superclass.dispose(self);
	BitmapCacher:removeUnused();
end
function ShadowZhuanPopup:onDataInit()

  self.shadowProxy=self:retrieveProxy(ShadowProxy.name);
  self.userCurrencyProxy=self:retrieveProxy(UserCurrencyProxy.name);
  self.generalListProxy=self:retrieveProxy(GeneralListProxy.name);
  self.userProxy = self:retrieveProxy(UserProxy.name);
  self.countControlProxy=self:retrieveProxy(CountControlProxy.name);
 
end

function ShadowZhuanPopup:initialize(context, strongPointId)
  self.strongPointId = strongPointId;
  self.context = context
  self:initLayer();


  local layerColor1 = LayerColor.new();
  layerColor1:initLayer();
  layerColor1:changeWidthAndHeight(self.context.mainSize.width, self.context.mainSize.height);
  layerColor1:setColor(ccc3(0,0,0));
  layerColor1:setOpacity(255);
  layerColor1:setPositionXY(-GameData.uiOffsetX, -GameData.uiOffsetY)
  self:addChild(layerColor1)   


  self.mainSize = Director:sharedDirector():getWinSize();
  self.sprite:setContentSize(CCSizeMake(self.mainSize.width, self.mainSize.height));


end

function ShadowZhuanPopup:onUIInit()

  self.scrollView=ListScrollViewLayer.new();
  self.scrollView:initLayer();
  self.scrollView:setPositionXY(0, 0);
  self.scrollView:setViewSize(makeSize(self.mainSize.width, 720));

  self.scrollView:setDirection(kCCScrollViewDirectionHorizontal);

  self.scrollView:setScrollViewScrollOut(false)

  local function onViewScrollStoped()
    print("onViewScrollStoped")
    -- if not self.wordVisible then
    --   self.wordVisible = true;
    --   self:setLayerVisible()
    -- end
  end
  self.scrollView:setScrollOutStopedHandler(onViewScrollStoped);
  self:addChild(self.scrollView);

  self:setLayerVisible()
end
function ShadowZhuanPopup:setLayerVisible()

  if not self.topLayer then
    self.topLayer = TopZhuanLayer.new();
    self.topLayer:initialize();
    self.topLayer:setAnchorPoint(ccp(0.5,0.5));
    self.topLayer:setRotation(-90)
    self.topLayer:setPositionXY(-925-GameData.uiOffsetY,280-GameData.uiOffsetY)---GameData.uiOffsetX
    self:addChild(self.topLayer)

    table.insert(self.itemTable, self.topLayer)

    self.bottomLayer = BottomZhuanLayer.new();
    self.bottomLayer:initialize();
    self.bottomLayer:setAnchorPoint(ccp(0.5,0.5));
    self.bottomLayer:setRotation(-90)
    self.bottomLayer:setPositionXY(280-GameData.uiOffsetY,280-GameData.uiOffsetY)---GameData.uiOffsetX
    self:addChild(self.bottomLayer)
    table.insert(self.itemTable, self.bottomLayer)


    print("GameData.uiOffsetX, GameData.uiOffsetY", GameData.uiOffsetX, GameData.uiOffsetY)

    self.count = self.context.storyLineProxy:getStrongPointTotalCount(self.strongPointId);
    if not self.count then
      self.count = 0;
    end

    local artopen = analysis("Juqing_Yingxiongzhi", self.strongPointId, "artopen")
    self.artopens = StringUtils:lua_string_split(artopen, ",");
    self.bottomLayer:setData(self.count, tonumber(self.artopens[2]));


    self.layerColor1 = LayerColor.new();
    self.layerColor1:initLayer();
    self.layerColor1:changeWidthAndHeight(76, 110);
    self.layerColor1:setColor(ccc3(0,0,0));
    self.layerColor1:setOpacity(0);
    self.layerColor1:setPositionXY(0,610)
    self:addChild(self.layerColor1)   
    self.layerColor1:addEventListener(DisplayEvents.kTouchTap, self.onReturn, self);

    table.insert(self.itemTable, self.layerColor1)

    self.layerColor2 = LayerColor.new();
    self.layerColor2:initLayer();
    self.layerColor2:changeWidthAndHeight(76, 160);
    self.layerColor2:setColor(ccc3(0,0,0));
    self.layerColor2:setOpacity(0);
    self.layerColor2:setPositionXY(0,0)
    self:addChild(self.layerColor2)   
    self.layerColor2:addEventListener(DisplayEvents.kTouchTap, self.onPre, self);

    table.insert(self.itemTable, self.layerColor2)


    self.layerColor3 = LayerColor.new();
    self.layerColor3:initLayer();
    self.layerColor3:changeWidthAndHeight(76, 160);
    self.layerColor3:setColor(ccc3(0,0,0));
    self.layerColor3:setOpacity(0);
    self.layerColor3:setPositionXY(self.mainSize.width - 76,286)
    self:addChild(self.layerColor3)   
    self.layerColor3:addEventListener(DisplayEvents.kTouchTap, self.onNext, self);
    table.insert(self.itemTable, self.layerColor3)
  end

  for k, v in pairs(self.itemTable)do
    v:setVisible(self.wordVisible);
  end

  if self.wordVisible and self.currentPage < 4 then
    self.bottomLayer:setVisible(true)
  else
    self.bottomLayer:setVisible(false)
  end

end
function ShadowZhuanPopup:onReturn(event)
  if  GameVar.tutorStage == TutorConfig.STAGE_1008  then
    openTutorUI({x=1206, y=652, width = 78, height = 75});
  end
  
  print("onReturn")
  if self.context.scrollView.sprite then
    self.context.scrollView:setMoveEnabled(true);
  end
  self:closeUI()
  -- onRunGameKeypadBackClose()
end
function ShadowZhuanPopup:onPre(event)
  print("onPre, self.currentPage", self.currentPage)
  if self.currentPage > 1 then
    self.currentPage = self.currentPage - 1;
    self.scrollView:removeAllItems(true)
    self:addCurrentImage(self.currentPage);

    self.topLayer:setPageCount(self.currentPage)

    local needCount = tonumber(self.artopens[self.currentPage]);
    self.bottomLayer:setData(self.count, needCount);

    MusicUtils:playEffect(7,false);
  end


  if self.currentPage < 4 then
    self.bottomLayer:setVisible(true)
  else
    self.bottomLayer:setVisible(false)
  end

end

function ShadowZhuanPopup:onNext(event)
  print("onNext")

  if self.currentPage < 4 then

    local needCount = tonumber(self.artopens[self.currentPage + 1]);
    if self.count < needCount then
      print("self.count < needCount", self.count, needCount)
      return;
    end

    self.currentPage = self.currentPage + 1;
    self.scrollView:removeAllItems(true)
    self:addCurrentImage(self.currentPage);


    self.topLayer:setPageCount(self.currentPage)
    self.bottomLayer:setData(self.count, tonumber(self.artopens[self.currentPage + 1]));

    MusicUtils:playEffect(7,false);
  end

  if self.currentPage < 4 then
    self.bottomLayer:setVisible(true)
  else
    self.bottomLayer:setVisible(false)
  end

end
function ShadowZhuanPopup:setData()
  self.yxzPo = analysis("Juqing_Yingxiongzhi", self.strongPointId);

  self.arts = StringUtils:stuff_string_split(self.yxzPo.art);
  self:addCurrentImage(self.currentPage)

end
function ShadowZhuanPopup:addCurrentImage(page)
  local width,height = 0,0;
  local layer = Layer.new();
  layer:initLayer();
  for k, v in pairs(self.arts[page]) do
    print("addCurrentImage", v)
    local item = Image.new();
    item:loadByArtID(tonumber(v));
    layer:addChild(item);
    item:setPositionXY(width, 0);
    width = width + item:getContentSize().width;
    height = item:getContentSize().height;
  end
  layer:setContentSize(CCSizeMake(width,height))
  layer:addEventListener(DisplayEvents.kTouchBegin,self.onTouchImageBegin, self);
  self.scrollView:setItemSize(CCSizeMake(width,height));
  self.scrollView:addItem(layer);
end
function ShadowZhuanPopup:onTouchImageBegin(event)
  self.beginPos=event.globalPosition
  event.target:addEventListener(DisplayEvents.kTouchEnd,self.onTouchImageEnd,self);
end
function ShadowZhuanPopup:onTouchImageEnd(event)
  if math.abs(event.globalPosition.x-self.beginPos.x) < 20 then
    self.wordVisible = not self.wordVisible;
    self:setLayerVisible()
  end
  event.target:removeEventListener(DisplayEvents.kTouchEnd,self.onTouchImageEnd);
end
--@overwrite
function ShadowZhuanPopup:onUIClose()
  MusicUtils:playEffect(8,false);
  self.parent:removeChild(self)
end
