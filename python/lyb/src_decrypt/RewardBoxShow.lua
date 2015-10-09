
RewardBoxShow=class(LayerPopableDirect);

function RewardBoxShow:ctor()
  self.class=RewardBoxShow;
end

function RewardBoxShow:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  RewardBoxShow.superclass.dispose(self);
  self.armature:dispose()

end
function RewardBoxShow:onDataInit()

  self.userProxy = self:retrieveProxy(UserProxy.name);
  self.storyLineProxy=self:retrieveProxy(StoryLineProxy.name)
  self.bagProxy = self:retrieveProxy(BagProxy.name);
  self.skeleton = self.storyLineProxy:getSkeleton();

  local layerPopableData = LayerPopableData.new();
  layerPopableData:setHasUIBackground(false);
  layerPopableData:setHasUIFrame(true);
  layerPopableData:setVisibleDelegate(false)
  layerPopableData:setArmatureInitParam(self.skeleton,"allStar_ui");
  self:setLayerPopableData(layerPopableData);

end

function RewardBoxShow:onUIInit()

  local strongPointNameTextDO = self.armature:getBone("strongPointName_txt"):getDisplay();
  
  local passCount_desc_txtData = self.armature:getBone("passCount_desc_txt").textData;
  self.uiDescText = createTextFieldWithTextData(passCount_desc_txtData, "寻宝大宝箱奉上");
  self.armature.display:addChild(self.uiDescText);

  self.closeButton = Button.new(self.armature:findChildArmature("confirm_button"), false,"确定",true);
  self.closeButton:addEventListener(Events.kStart, self.closeUI, self);

  local tileNameText = BitmapTextField.new("寻宝宝箱","anniutuzi");
  tileNameText:setPositionXY(strongPointNameTextDO:getPositionX() + 15,strongPointNameTextDO:getPositionY() - 10)
  self.armature.display:addChild(tileNameText);


end

function RewardBoxShow:onPrePop()
    
  local mainSize = Director:sharedDirector():getWinSize();

  local armature_dSize =  self.armature.display:getGroupBounds().size
  
  self.armature_d_x = (mainSize.width - armature_dSize.width)/2
  self.armature_d_y = (mainSize.height - armature_dSize.height)/2- GameData.uiOffsetY
  self.armature.display:setPositionXY(self.armature_d_x, self.armature_d_y)
end
function RewardBoxShow:initialize(context)

  self.context = context

  local mainSize = Director:sharedDirector():getWinSize();

  local layerColor = LayerColor.new();
  layerColor:initLayer();
  layerColor:changeWidthAndHeight(mainSize.width, mainSize.height);
  layerColor:setColor(ccc3(0,0,0));
  layerColor:setOpacity(150);
  self:addChildAt(layerColor,0)
  layerColor:setPositionXY(0,-1 * GameData.uiOffsetY)
  
  self.closeButton:setLable("领取")

  local viewList = ListScrollViewLayer.new();
  viewList:initLayer();
  viewList:setPositionXY(64,110)
  viewList:setDirection(kCCScrollViewDirectionHorizontal);
  viewList:setViewSize(makeSize(400,180));
  viewList:setItemSize(makeSize(120,150));
  self.armature.display:addChild(viewList);

  local giftId = 1
  if self.userProxy.level < 21 then
    giftId = 1
  elseif self.userProxy.level < 61 then
    giftId = 2
  else
    giftId = 3
  end

  local itemStr = analysis("Xunbao_Baoxiang", giftId ,"gift")
  local itemTable = StringUtils:lua_string_split(itemStr,";")
  for k,v in pairs(itemTable) do
    local singalItemTable = StringUtils:lua_string_split(v,",")
  
    local common_grid=CommonSkeleton:getBoneTextureDisplay("commonGrids/common_grid");
    require "main.view.bag.ui.bagPopup.BagItem"
    local itemImage = BagItem.new(); 
    itemImage:initialize({ItemId = singalItemTable[1], Count = singalItemTable[2]});
    itemImage:setPositionXY(6.8,7.8)

    local itemLayer = Layer.new()
    itemLayer:initLayer()
    itemLayer:addChild(common_grid)
    itemLayer:addChild(itemImage)
    itemImage.touchEnabled=true;
    itemImage.touchChildren=true;
    itemImage:addEventListener(DisplayEvents.kTouchTap,self.onTap,self);
    viewList:addItem(itemLayer)
  end
end

function RewardBoxShow:onTap(event)
  self.context:dispatchEvent(Event.new("ON_ITEM_TIP", {item = event.target},self));
end

function RewardBoxShow:onUIClose()
  
  MusicUtils:playEffect(8,false)

  local isBagFull = self.bagProxy:getBagIsFull()
  if isBagFull then
    sharedTextAnimateReward():animateStartByString("背包已满,请清理后再领");
  else
    hecDC(3,27,3)
    sendMessage(8,11)
    self.parent:removeChild(self)
  end
  
end