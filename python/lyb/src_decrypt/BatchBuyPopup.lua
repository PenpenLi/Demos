
BatchBuyPopup=class(LayerPopableDirect);

function BatchBuyPopup:ctor()
  self.class=BatchBuyPopup;
  self.count = 5;
  self.bg_image = nil;
end
function BatchBuyPopup:dispose()
  BatchBuyPopup.superclass.dispose(self);
end
function BatchBuyPopup:onDataInit()

  self.shopProxy=self:retrieveProxy(ShopProxy.name);
  self.userCurrencyProxy=self:retrieveProxy(UserCurrencyProxy.name);
  self.generalListProxy=self:retrieveProxy(GeneralListProxy.name);
  self.userProxy = self:retrieveProxy(UserProxy.name);
  self.countControlProxy=self:retrieveProxy(CountControlProxy.name);
  self.itemUseQueueProxy=self:retrieveProxy(ItemUseQueueProxy.name);
  self.storyLineProxy=self:retrieveProxy(StoryLineProxy.name)
  self.bagProxy = self:retrieveProxy(BagProxy.name);
  self.skeleton = self.shopProxy:getSkeleton();
  local LayerPopableData=LayerPopableData.new();
  LayerPopableData:setHasUIBackground(true)
  LayerPopableData:setHasUIFrame(true)
  LayerPopableData:setPreUIData(StaticArtsConfig.BACKGROUD_SHOP,nil,true,2)
  LayerPopableData:setArmatureInitParam(self.skeleton,"shop_ui")
  self:setLayerPopableData(LayerPopableData)

end


function BatchBuyPopup:initialize()
  self.context=self
  self:initLayer();
  local mainSize = Director:sharedDirector():getWinSize();
  self.sprite:setContentSize(CCSizeMake(1280, 720));
  self.skeleton=nil;
end

function BatchBuyPopup:onPrePop()

  local armature=self.armature;
  local armature_d=armature.display;
  self.armature_d = armature_d;
  armature_d.touchEnabled=true;

  
  local shop_render1=armature_d:getChildByName("shop_render1");
  local shop_render2=armature_d:getChildByName("shop_render2");
  local shop_render3=armature_d:getChildByName("shop_render3");
  
  self.render_width=shop_render1:getGroupBounds().size.width
  self.render_height=shop_render1:getGroupBounds().size.height
  self.render_space_left2right=shop_render2:getPositionX()-shop_render1:getPositionX()-self.render_width
  self.render_space_top2bottom=shop_render1:getPositionY()-shop_render3:getPositionY()-self.render_height
  armature_d:removeChild(shop_render1);
  armature_d:removeChild(shop_render2);
  armature_d:removeChild(shop_render3);

  local channel1=armature_d:getChildByName("channel_1");
  local channel2=armature_d:getChildByName("channel_2");
  armature_d:removeChild(channel1)
  armature_d:removeChild(channel2)
  
  local refresh=armature_d:getChildByName("refresh")
  armature_d:removeChild(refresh)
  self:addChild(armature_d)
  self.gril_bg = Image.new()
  self.gril_bg:loadByArtID(1167)
  self.gril_bg:setScale(1)
end
function BatchBuyPopup:setShopPageByItemId(itemId)
  self.itemId = itemId;
end
function BatchBuyPopup:onUIInit()
  



  local shopItems = analysisByName("Shangdian_Shangdianwupin", "type", 2)
  self.datas = {};
  for k,v in pairs(shopItems) do
    table.insert(self.datas, v);
  end

  local function sortFun(v1, v2)
    if(v1.sort < v2.sort) then
      return true;
    elseif v1.sort > v2.sort then
      return false
    else
      return false;
    end
  end
  table.sort(self.datas, sortFun)

  local page = nil;
  local itemIndex = nil;
  if self.itemId then
    local index = 1;
    for k, v in pairs(self.datas) do
      if v.itemid == self.itemId then
        break;
      end
      index = index + 1;
    end
    print("index", index)
    page = math.ceil(index / 6);
    itemIndex = index % 6;
    if itemIndex == 0 then
      itemIndex = 6;
    end
  end

  self:refreshData(page, itemIndex);

  self.armature_d:addChildAt(self.gril_bg,2)
  self.gril_bg.touchEnabled = false;
  self.gril_bg:setPositionXY(-50,20) 
 
end



function BatchBuyPopup:refreshData(page, itemIndex)

  if(self.scrollView) then
      self.page=self.scrollView:getCurrentPage()
      self.armature_d:removeChild(self.scrollView);
  end
  self.scrollView=ShopItemPageView.new(CCPageView:create());

  self.scrollView:initialize(self.context);
  
  self.scrollView:setPositionXY(332,145);
  self.armature_d:addChild(self.scrollView);
  
  local function onPageViewScrollStoped()
    self.scrollView:onPageViewScrollStoped();
    if self.boneLightCartoon then
      self:removeChild(self.boneLightCartoon)
      self.boneLightCartoon = nil;
    end
  end
  self.scrollView:registerScrollStopedScriptHandler(onPageViewScrollStoped);
  self.armature_d:addChild(self.scrollView);
  if(self.pageControl) then
      self.armature_d:removeChild(self.pageControl);
  end
  self.pageControl = self.scrollView.pageViewControl;
  self.pageControl.touchEnabled=false
  self.pageControl.touchChildren=false
  self.armature_d:addChild(self.pageControl);
  if #self.datas<=6 then
    self.pageControl:setVisible(false)
  else
    self.pageControl:setVisible(true)
  end 
  if(page) then
    self.scrollView:update(self.datas, page);
    local xIndex = itemIndex % 3
    local yIndex = math.ceil(itemIndex / 3) == 2 and 0 or 1;
    if xIndex == 0 then
      xIndex = 2;
    else
      xIndex = xIndex - 1;
    end
    self.boneLightCartoon = cartoonPlayer("610",46, 45, 0);
    self.boneLightCartoon.touchEnabled = false;
    self:addChild(self.boneLightCartoon);

    -- print("xIndex,yIndex,",xIndex,yIndex, itemIndex)
    self.boneLightCartoon:setPositionXY(320+162 + 265*xIndex-23, 160+113+yIndex*235-10);

  else
    self.scrollView:update(self.datas,self.page)
  end

end
function BatchBuyPopup:shopItemClick(item, callBack)
      self.layer=Layer.new();
      self.layer:initLayer();
      self.layer.touchEnabled=true;
      local mainSize = Director:sharedDirector():getWinSize();
      self.layer:setContentSize(CCSizeMake(mainSize.width, mainSize.height));
      self.layer:addEventListener(DisplayEvents.kTouchTap,self.closeTip,self,a);
      self:addChild(self.layer)
      self:dispatchEvent(Event.new("SHOP_ITEM_CLICK",{item= item, callBack = callBack, showButton = true},self))
end
function BatchBuyPopup:onUIClose()
  -- local tab={daojuID=self.daojuID,daojuname=self.daojuname,daojuIDhenum="7"..self.xiaohaoNum}
  -- hecDC(3,6,2,tab);
  self:dispatchEvent(Event.new("ShopClose",nil,self));
end
function BatchBuyPopup:closeTip()
  self:dispatchEvent(Event.new("CLOSETIP",itemid,self))
  
  self:removeChild(self.layer)
end