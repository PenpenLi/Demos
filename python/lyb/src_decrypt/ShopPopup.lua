require "core.display.LayerPopable";
require "core.controls.CommonLayer";
require "core.controls.ScrollSelectButton";
require "main.view.shop.ui.ShopItemPageView";
ShopPopup=class(LayerPopableDirect);

function ShopPopup:ctor()
  self.class=ShopPopup;
  self.count = 5;
  self.bg_image = nil;
end
function ShopPopup:dispose()
  ShopPopup.superclass.dispose(self);
end
function ShopPopup:onDataInit()

  self.shopProxy=self:retrieveProxy(ShopProxy.name);
  self.userCurrencyProxy=self:retrieveProxy(UserCurrencyProxy.name);
  self.generalListProxy=self:retrieveProxy(GeneralListProxy.name);
  self.userProxy = self:retrieveProxy(UserProxy.name);
  self.familyProxy = self:retrieveProxy(FamilyProxy.name);
  self.countControlProxy=self:retrieveProxy(CountControlProxy.name);
  self.itemUseQueueProxy=self:retrieveProxy(ItemUseQueueProxy.name);
  self.storyLineProxy=self:retrieveProxy(StoryLineProxy.name)
  self.bagProxy = self:retrieveProxy(BagProxy.name);
  self.skeleton = self.shopProxy:getSkeleton();

  self.layerPopableData=LayerPopableData.new();
  self.layerPopableData:setHasUIBackground(true)
  self.layerPopableData:setHasUIFrame(true)
  self.layerPopableData:setPreUIData(StaticArtsConfig.BACKGROUD_SHOP,nil,true,2)
  self.layerPopableData:setArmatureInitParam(self.skeleton,"shop_ui")
  self:enterHandleShowCurrency();
  self:setLayerPopableData(self.layerPopableData)

end

function ShopPopup:enterHandleShowCurrency()
  self.facMed = Facade.getInstance():retrieveMediator(FactionMediator.name);
  --朝堂商店
  if self.type == 1 then
    if self.facMed then
      setCurrencyGroupVisible(false)
      setFactionCurrencyVisible(true)
    else 
      setCurrencyGroupVisible(false)
      setFactionCurrencyVisible(true)
    end
  --帮派商店
  elseif self.type == 2 then
    self.layerPopableData:setShowCurrency(true);
    if self.userProxy.sceneType == GameConfig.SCENE_TYPE_1 then
      --刷成帮贡条
      self:refreshFamilyContribute(false)
    elseif self.userProxy.sceneType == GameConfig.SCENE_TYPE_4 then
      --刷成帮贡条
      self:refreshFamilyContribute(false)
    end
  end
end

function ShopPopup:exitHandleShowCurrency()
  if self.type == 1 then
    if self.facMed then
      setCurrencyGroupVisible(false);
      setFactionCurrencyVisible(true)
    else
      setCurrencyGroupVisible(true)
      setFactionCurrencyVisible(false)
    end
  --帮派商店
  elseif self.type == 2 then
    if self.userProxy.sceneType == GameConfig.SCENE_TYPE_1 then
      --刷成体力条
      self:refreshFamilyContribute(true)
    elseif self.userProxy.sceneType == GameConfig.SCENE_TYPE_4 then
      --刷成帮贡条
      self:refreshFamilyContribute(false)
    end
  end
end


function ShopPopup:refreshFamilyContribute(bool)
    local currencyGroupMediator=Facade.getInstance():retrieveMediator(CurrencyGroupMediator.name);
    if currencyGroupMediator then
      currencyGroupMediator:refreshFamilyContribute(bool)
    end
end


function ShopPopup:initialize()
  self.context=self
  self:initLayer();
  local mainSize = Director:sharedDirector():getWinSize();
  self.sprite:setContentSize(CCSizeMake(1280, 720));
  self.skeleton=nil;
end

function ShopPopup:onPrePop()

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
function ShopPopup:setShopPageAndType(itemId, type)
  self.itemId = itemId;
  self.type = type;
end
function ShopPopup:onUIInit()




  if 2 == self.type then
    
  end
  local id = 1;
  if self.type == 1 then
    id = 2;
  else
    id = 5;
  end
  local shopItems = analysisByName("Shangdian_Shangdianwupin", "type", id)
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
    self.itemId = tonumber(self.itemId);
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



function ShopPopup:refreshData(page, itemIndex)
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
    self.boneLightCartoon:setPositionXY(320+162 + 265*xIndex-23, 160+110+yIndex*238-10);

  else
    self.scrollView:update(self.datas,self.page)
  end

end
function ShopPopup:shopItemClick(item, callBack)
      self.layer=Layer.new();
      self.layer:initLayer();
      self.layer.touchEnabled=true;
      local mainSize = Director:sharedDirector():getWinSize();
      self.layer:setContentSize(CCSizeMake(mainSize.width, mainSize.height));
      self.layer:addEventListener(DisplayEvents.kTouchTap,self.closeTip,self,a);
      self:addChild(self.layer)
      self:dispatchEvent(Event.new("SHOP_ITEM_CLICK",{item= item, callBack = callBack, showButton = true},self))
end
function ShopPopup:onUIClose()
  -- local tab={daojuID=self.daojuID,daojuname=self.daojuname,daojuIDhenum="7"..self.xiaohaoNum}
  -- hecDC(3,6,2,tab);
  self:exitHandleShowCurrency()
  self:dispatchEvent(Event.new("ShopClose",nil,self));
end
function ShopPopup:closeTip()
  self:dispatchEvent(Event.new("CLOSETIP",itemid,self))
  
  self:removeChild(self.layer)
end