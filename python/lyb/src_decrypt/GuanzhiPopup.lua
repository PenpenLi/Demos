require "core.display.LayerPopable";
require "main.view.guanzhi.ui.guanzhiPopup.GuanzhiPageView";

GuanzhiPopup=class(LayerPopableDirect);

function GuanzhiPopup:ctor()
  self.class=GuanzhiPopup;
end

function GuanzhiPopup:dispose()
  GuanzhiPopup.superclass.dispose(self);
  self.armature:dispose();
end

function GuanzhiPopup:onDataInit()
  self.userProxy = self:retrieveProxy(UserProxy.name);
  self.userCurrencyProxy = self:retrieveProxy(UserCurrencyProxy.name);
  self.skeleton = getSkeletonByName("guanzhi_ui");
  self.slots = {};
  self.idCountArray = nil;

  local layerPopableData = LayerPopableData.new();
  layerPopableData:setHasUIBackground(true);
  layerPopableData:setHasUIFrame(true);
  layerPopableData:setPreUIData(StaticArtsConfig.BACKGROUD_HERO_HOUSE, nil, true, 2);
  self:setLayerPopableData(layerPopableData);
-- local image = Image.new();
--   image:loadByArtID(875);
--   -- image:setScale(2);
--   self:addChildAt(image,0);
  setFactionCurrencyVisible(true)
  -- setFactionCurrencyBTNVisible(false)
  hecDC(3,10,1,{position = self.userProxy:getNobility()});
end

function GuanzhiPopup:onPrePop()
  local size=Director:sharedDirector():getWinSize();
  self:changeWidthAndHeight(size.width,size.height);

  -- local size = Director:sharedDirector():getWinSize();
  -- local bg = LayerColorBackGround:getCustomBackGround(size.width, size.height, 190);
  -- bg:setPositionXY(GameData.uiOffsetX,-GameData.uiOffsetY);
  -- self:addChildAt(bg,0);

  
end

function GuanzhiPopup:onUIInit()
  local armature=self.skeleton:buildArmature("guanzhi_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature = armature;
  self:addChild(self.armature.display);

  local img = CommonSkeleton:getBoneTextureDisplay("commonCurrencyImages/common_shengwang_bg");
  img:setPositionXY(230,603);
  self.armature.display:addChild(img);

  local text="    可通过征战、议政获得，官职获得的属性将加在所有英雄身上";
  local descb=createTextFieldWithTextData(armature:getBone("descb").textData,text);
  self.armature.display:addChild(descb);

  local closeButton =self.armature.display:getChildByName("common_copy_close_button");
  SingleButton:create(closeButton);
  closeButton:addEventListener(DisplayEvents.kTouchTap, self.closeUI, self);

  self.askBtn = Button.new(self.armature:findChildArmature("ask"),false,"");
  self.askBtn:addEventListener(Events.kStart,self.onShowTip, self);
end

function GuanzhiPopup:onShowTip()
  -- MusicUtils:playEffect(7,false);
  local text=analysis("Tishi_Guizemiaoshu",10,"txt");
  TipsUtil:showTips(self.askBtn,text,500,nil,50);
end

function GuanzhiPopup:onRequestedData()
  initializeSmallLoading();
  sendMessage(19,13);
end

function GuanzhiPopup:onUIClose()
  -- setFactionCurrencyBTNVisible(true)
  self:dispatchEvent(Event.new(GuanzhiNotifications.GUANZHI_CLOSE,nil,self));
end

function GuanzhiPopup:onPreUIClose()
  self.armature.display:removeChild(self.scrollView);
end

function GuanzhiPopup:refresh(idCountArray)
  self.idCountArray = idCountArray;

  self.scrollView=GuanzhiPageView.new(CCPageView:create());
  self.scrollView:initialize(self);
  self.scrollView:setPositionXY(140,-405);
  self.armature.display:addChild(self.scrollView);

  local pageControl = self.scrollView.pageViewControl;
  if pageControl then
    pageControl:setPositionY(pageControl:getPositionY() - 20);
    self.armature.display:addChild(pageControl);
  end
  
  local page = math.ceil((-1+self.userProxy:getNobility())/5);
  if 0 == (-1+self.userProxy:getNobility())%5 and self.scrollView.maxPageNum > page then
    page = 1 + page;
  end
  self.scrollView:setCurrentPage(page);
end

function GuanzhiPopup:refreshUpdate()
  uninitializeSmallLoading();
  local nobility = self.userProxy:getNobility();
  for k,v in pairs(self.slots) do
    if nobility == v:getID() or nobility == 1 + v:getID() or nobility == -1 + v:getID() then
      v:setSlotData(v.id);
    end
  end
end

function GuanzhiPopup:onItemTap(event, id)
  initializeSmallLoading();
  sendMessage(3,27);
end