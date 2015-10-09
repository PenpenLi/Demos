
require "main.view.storyLine.ui.strongPoint.StrongPointItem"
StoryLineItemSlot = class(CommonSlot);

-- creat
function StoryLineItemSlot:ctor()
  self.class = StoryLineItemSlot;
  self.isLayerInitialized = false;
  self.storyLineId = nil
  self.strongPointItems = {};
  self.curStrongPointId = nil;
end
function StoryLineItemSlot:dispose()

  self:removeAllEventListeners();
  self:removeChildren();
  StoryLineItemSlot.superclass.dispose(self);

end

function StoryLineItemSlot:initialize(context)
  self.context = context;
  self:initLayer();
  self.mainSize=Director:sharedDirector():getWinSize();
  self:addEventListener("STRONG_POINT_CLICK", self.onStrongPointClick,self)
end

function StoryLineItemSlot:setSlotData(storyLineId)

  self:cleanSlotData();
  self.storyLineId = storyLineId;
  self.storyLinePo = analysis("Juqing_Juqing",storyLineId)

  local mapID = self.storyLinePo.mapId

  self.strongPoints = analysisByName("Juqing_Guanka","storyId", storyLineId)

  log("StoryLineItemSlot:initMap ++++++storyLineId:" .. storyLineId .. ",mapID:" .. mapID)
  self.mapUIData = analysisMapUI(mapID)
  self.detailTable = self.mapUIData.outersTable
  
  print("self.mapUIData.backartid:", self.mapUIData.backartid)
  ----add背景
  self.backImage = Image.new()
  self.backImage:loadByArtID(self.mapUIData.backartid)
  self.backImage:setAnchorPoint(CCPointMake(0.5, 0.5))
  self.backImage:setPositionXY(self.mainSize.width/2, self.mainSize.height/2)
  self.woldWidth = self.backImage:getContentSize().width
  self:addChild(self.backImage)



  -- self.rightEffectImage:setAnchorPoint(ccp(0.5,0.5))


  self.title_bg = CommonSkeleton:getBoneTextureDisplay("commonImages/common_huaWen2")
  self:addChild(self.title_bg)
  self.title_bg:setPositionXY(435+GameData.uiOffsetX,630+GameData.uiOffsetY)

  local storyName = "第" .. self.storyLinePo.zhangjie;
  storyName = storyName .. "章 " .. self.storyLinePo.name;
  local storyLineNameTxt=TextField.new(CCLabelTTF:create(storyName,GameConfig.DEFAULT_FONT_NAME, 40, CCSizeMake(360,50),kCCVerticalTextAlignmentCenter));
  storyLineNameTxt:setPositionXY(470+GameData.uiOffsetX, 649+GameData.uiOffsetY)
  self:addChild(storyLineNameTxt)


          --   local txtAlign = "left";
          -- local txtAlign2 = kCCVerticalTextAlignmentCenter

  for k,v in pairs(self.detailTable) do
      
      if k < 200 then
        local detailImage = Image.new()
        detailImage.key = k
        detailImage:loadByArtID(v.normal)
        detailImage.touchEnabled = false;
        self:addChild(detailImage) 
        detailImage:setPositionXY(v.xPos+GameData.uiOffsetX, v.yPos+GameData.uiOffsetY-120)
      
      end      
  end

  local isAllStrongPointPass = true;
  ----add 房子
  for k,v in pairs(self.strongPoints) do
        print("strongPointId", v.id)
        local strongPointInEditor = self.detailTable[v.strongPointId]
        local strongPointItem = StrongPointItem.new();

        strongPointItem:initialize(self.context, self, strongPointInEditor, v.id, strongPointInEditor.xPos+GameData.uiOffsetX,strongPointInEditor.yPos+GameData.uiOffsetY-120);
   
        self.strongPointItems[v.id] = strongPointItem
        self:addChild(strongPointItem) 

        local strongPointData = self.context.storyLineProxy.strongPointArray["key_"..v.id];
        if strongPointData then
          print("strongPointId", v.id, strongPointData.State)
          if strongPointData.State == GameConfig.STRONG_POINT_STATE_3 or strongPointData.State == GameConfig.STRONG_POINT_STATE_4 then
            self.curStrongPointId = v.id;
            isAllStrongPointPass = false;
            if not self.context.curStrongPointId then
              strongPointItem:setSelect(true)
            end
          elseif strongPointData.State == GameConfig.STRONG_POINT_STATE_1 then
            if self.context.curStrongPointId and v.id == self.context.curStrongPointId then
              strongPointItem:setSelect(true)
            end
            strongPointItem:setPassEffect(true)
          else
            isAllStrongPointPass = false;
          end
        else

        end
  end

  if isAllStrongPointPass then
    self:runEffectAction();
  end

end

function StoryLineItemSlot:runEffectAction()

  self.leftEffectImage = Image.new()
  self.leftEffectImage:loadByArtID(722)
  self.leftEffectImage:setPositionXY(GameData.uiOffsetX,25+GameData.uiOffsetY);
  self:addChild(self.leftEffectImage)


  self.rightEffectImage = Image.new()
  self.rightEffectImage:loadByArtID(722)
  self.rightEffectImage:setScaleX(-1)
  self.rightEffectImage:setPositionXY(1276+GameData.uiOffsetX,25+GameData.uiOffsetY);
  self:addChild(self.rightEffectImage)

  local fadeOut2 = CCFadeOut:create(1);
  local fadeIn2 = CCFadeIn:create(1);
  self.rightEffectImage:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(fadeOut2, fadeIn2)))
end
function StoryLineItemSlot:stopEffectAction()
  self.rightEffectImage:stopAllActions();
end
function StoryLineItemSlot:checkEndStrongPoint(strongPointId)
  for k, v in pairs(self.strongPoints) do
    if v.parentId == strongPointId then
      return false;
    end
  end
  return true;
end
function StoryLineItemSlot:cleanSlotData()
  print("StoryLineItemSlot:removeSlotData()")
  self.data = nil;
  self:removeChildren();
  self.strongPointItems = {};
end

function StoryLineItemSlot:clean()
  self.strongPointItems = {};
  self:removeAllEventListeners();
end
