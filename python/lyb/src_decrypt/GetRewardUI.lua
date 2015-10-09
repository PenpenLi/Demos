
GetRewardUI=class(LayerPopableDirect);

function GetRewardUI:ctor()
  self.class = GetRewardUI;
end

function GetRewardUI:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  GetRewardUI.superclass.dispose(self);
  self.armature:dispose()

end

function GetRewardUI:onDataInit()

  self.taskProxy=self:retrieveProxy(TaskProxy.name)

  self.skeleton = getSkeletonByName("getReward_ui");

  local layerPopableData = LayerPopableData.new();
  layerPopableData:setHasUIBackground(false);
  layerPopableData:setHasUIFrame(false);
  layerPopableData:setVisibleDelegate(false)
  layerPopableData:setShowCurrency(false)
  layerPopableData:setArmatureInitParam(self.skeleton,"getReward_ui");
  self:setLayerPopableData(layerPopableData);

end

function GetRewardUI:onPrePop()

  local mainSize = Director:sharedDirector():getWinSize();

  local armature_dSize =  self.armature.display:getGroupBounds().size
  
  self.armature_d_x = (mainSize.width - armature_dSize.width)/2
  self.armature_d_y = (mainSize.height - armature_dSize.height)/2
  self.armature.display:setPositionXY(self.armature_d_x, self.armature_d_y)

  local layerColor = LayerColor.new();
  layerColor:initLayer();
  layerColor:changeWidthAndHeight(mainSize.width, mainSize.height);
  layerColor:setColor(ccc3(0,0,0));
  layerColor:setOpacity(150);
  self:addChildAt(layerColor,0)  

  layerColor:setPositionXY(-GameData.uiOffsetX, -GameData.uiOffsetY)

  local layerColor1 = LayerColor.new();
  layerColor1:initLayer();
  layerColor1:changeWidthAndHeight(mainSize.width, 240);
  layerColor1:setColor(ccc3(0,0,0));
  layerColor1:setOpacity(150);
  layerColor1:setPositionXY(0,240)
  self:addChildAt(layerColor1,1)   

end

function GetRewardUI:initialize()
  self:initLayer();
end

function GetRewardUI:initializeUI(itemArray)
  
  local shangxian = self.armature.display:getChildByName("common_copy_line_down2")
  shangxian.sprite:setFlipX(true)

  self:addEventListener(DisplayEvents.kTouchEnd, self.closeUI, self);

  local viewList = ListScrollViewLayer.new();
  viewList:initLayer();
  local itemCount = table.getn(itemArray)
  viewList:setPositionXY(640 - itemCount * 60,280)
  viewList:setDirection(kCCScrollViewDirectionHorizontal);
  viewList:setViewSize(makeSize(1280,180));
  viewList:setItemSize(makeSize(120,120));

  self.armature.display:addChild(viewList);

  for k,v in pairs(itemArray) do
 
    local itemImage = BagItem.new();
    itemImage:initialize({ItemId = v.ItemId, Count = v.Count});
    itemImage:setPositionXY(5,5)

    local itemLayer = Layer.new()
    itemLayer:initLayer()
    itemLayer:addChild(itemImage)

    viewList:addItem(itemLayer)
  end

  local textTips = BitmapTextField.new("点击任意位置关闭","anniutuzi")
  textTips:setPositionXY(480,160)
  textTips.touchEnable = false
  self:addChild(textTips)
end

function GetRewardUI:onUIClose()
  if  GameVar.tutorStage == TutorConfig.STAGE_1026  then
    openTutorUI({x=1198, y=641, width = 80, height = 80, alpha = 125});
  end
  self.parent:removeChild(self)
end

