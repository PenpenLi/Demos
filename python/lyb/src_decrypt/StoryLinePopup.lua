
require "main.view.storyLine.ui.StoryLinePageView"
StoryLinePopup = class(LayerPopableDirect);

local _boxId
local _allStarBox
-- creat
function StoryLinePopup:ctor()
  self.class = StoryLinePopup;
  self.isLayerInitialized = false;
  self.storyLineId = nil
  self.backgroundLayer = nil
  self.generalListProxy = nil;
  self.curStrongPointId = nil;
  self.childLayer = Layer.new();
  self.childLayer:initLayer();

end
function StoryLinePopup:dispose()

  self:removeAllEventListeners();
  self:removeChildren();
  StoryLinePopup.superclass.dispose(self);

end

function StoryLinePopup:initialize()
  self.mainSize=Director:sharedDirector():getWinSize();
  self:initLayer();

end
function StoryLinePopup:onDataInit()
  self.userCurrencyProxy=self:retrieveProxy(UserCurrencyProxy.name);
  self.generalListProxy=self:retrieveProxy(GeneralListProxy.name);
  self.userProxy = self:retrieveProxy(UserProxy.name);
  self.countControlProxy=self:retrieveProxy(CountControlProxy.name);
  self.bagProxy=self:retrieveProxy(BagProxy.name);
  self.itemUseQueueProxy=self:retrieveProxy(ItemUseQueueProxy.name);
  self.storyLineProxy = self:retrieveProxy(StoryLineProxy.name)
  self.openFunctionProxy = self:retrieveProxy(OpenFunctionProxy.name)
  self.skeleton = self.storyLineProxy:getSkeleton();

  local layerPopableData = LayerPopableData.new();
  layerPopableData:setHasUIBackground(true);
  layerPopableData:setHasUIFrame(true);
  layerPopableData:setPreUIData(StaticArtsConfig.BACKGROUD_STORYLINE,nil,true)
  layerPopableData:setArmatureInitParam(self.skeleton,"storyLine_ui");
  self:setLayerPopableData(layerPopableData);

end
function StoryLinePopup:onPrePop()
  
  self.skeleton = self.storyLineProxy:getSkeleton();


  self:changeWidthAndHeight(self.mainSize.width,self.mainSize.height);

end

function StoryLinePopup:onUIInit()

  self:addChildAt(self.childLayer, 1)

  self.armature = self.skeleton:buildArmature("storyLine_ui");
  
  self.scrollView=StoryLinePageView.new(CCPageView:create());
  self.scrollView:initialize(self);
  self.scrollView:setPositionXY(0,-self.mainSize.height);

  local function onPageViewScrollStoped()
    self:onPageViewScrollStoped();
  end

  self.scrollView:registerScrollStopedScriptHandler(onPageViewScrollStoped);
  self.childLayer:addChild(self.scrollView);

  --common_copy_yeqian_bg
  local common_copy_yeqian_bg = self.skeleton:getBoneTextureDisplay("storyLine/yeqian_bg");
  self.childLayer:addChild(common_copy_yeqian_bg);
  common_copy_yeqian_bg:setPositionXY(566,10+GameData.uiOffsetY)

  local str = "1/1";

  self.pageTxt=TextField.new(CCLabelTTF:create(str,GameConfig.DEFAULT_FONT_NAME, 26, CCSizeMake(120,33),kCCVerticalTextAlignmentCenter));
  self.pageTxt:setPositionXY(615,20 + GameData.uiOffsetY);
  self.childLayer:addChild(self.pageTxt);
  self.childLayer:setPositionXY(-GameData.uiOffsetX,-GameData.uiOffsetY)
  
  local currentStars = self.storyLineProxy:getStorylineStarCount(self.storyLineId)
  local allStars = self.storyLineProxy:getStrongPointCount(self.storyLineId)

  local havetakenImageDO = self.armature:getBone("havetakenImage"):getDisplay()
  havetakenImageDO:setVisible(false)

  _allStarBox = Layer.new()
  _allStarBox:initLayer()
  _allStarBox:setPositionXY(120,620)
  _allStarBox:setContentSize(CCSizeMake(211,184))
  _allStarBox:setAnchorPoint(CCPointMake(0.5, 0.5));

  _allStarBox:addEventListener(DisplayEvents.kTouchBegin, self.onBoxClick, self);

  self:addChild(_allStarBox)

  _boxId = 1738
  if currentStars == allStars * 3 then
    if self.storyLineProxy:isGotAward(self.storyLineId) then
      _boxId = 1740

      local havetakenImage = self.skeleton:getBoneTextureDisplay("havetakenImage");
      havetakenImage:setAnchorPoint(CCPointMake(0.4, 0.1))
      _allStarBox:addChild(havetakenImage)
    else
      _boxId = 1739
    end
  end
end

function StoryLinePopup:onBoxClickEnd(event)
  event.target:removeEventListener(DisplayEvents.kTouchEnd, self.onBoxClickEnd);
  event.target:setScale(1)
  if _boxId == 1740 then
    return
  end
  if math.abs(event.globalPosition.x-self.beginPos.x)<20 and math.abs(event.globalPosition.y-self.beginPos.y)<20 then
    self:popUpFullStar();
    if GameVar.tutorStage == TutorConfig.STAGE_1006 then
      openTutorUI({x=575, y=207, width = 130, height = 50, alpha = 125});
    end
  end
end

function StoryLinePopup:popUpFullStar()
  local starState = 1
  if _boxId == 1738 then
    starState = 1
  elseif _boxId == 1739 then
    starState = 2
  elseif _boxId == 1740 then    
    starState = 3
  end
  if GameData.isMusicOn then
    MusicUtils:playEffect(7,false)
  end
  require "main.view.storyLine.ui.FullStarShow";
  local starBoxUI = FullStarShow.new()
  LayerManager:addLayerPopable(starBoxUI);  
  starBoxUI:initialize(starState,self.storyLineId,self);
end

function StoryLinePopup:onBoxClick(event)

  MusicUtils:playEffect(501,false);
  
  if _boxId == 1740 then
    return
  end

  self.beginPos=event.globalPosition
  event.target:setScale(0.9)
  event.target:addEventListener(DisplayEvents.kTouchEnd, self.onBoxClickEnd, self);

end

function StoryLinePopup:onPageViewScrollStoped()
  local currentPage = self.scrollView:getCurrentPage();
  --处理翻页后数据
  self.scrollView:setPageData(currentPage);
  local str = currentPage .. "/31" --.. self.storyLineProxy:getTotalStoryLineCount();
  self.pageTxt:setString(str);

  self.storyLineId = self.storyLineProxy:getStorylineId(currentPage)
  self:refreshStarBox()
end

function StoryLinePopup:refreshStarBox()
  local currentStars = self.storyLineProxy:getStorylineStarCount(self.storyLineId)
  local allStars = self.storyLineProxy:getStrongPointCount(self.storyLineId)
  
  local havetakenImageDO = self.armature:getBone("havetakenImage"):getDisplay()
  havetakenImageDO:setVisible(false)

  _boxId = 1738
  if currentStars == allStars * 3 then
    if self.storyLineProxy:isGotAward(self.storyLineId) then
      _boxId = 1740
    else
      _boxId = 1739
    end
  end
  _allStarBox:removeChildren()

  local allStarBoxImage = Image.new()
  allStarBoxImage:loadByArtID(_boxId)
  allStarBoxImage.touchEnabled = false
  allStarBoxImage:setAnchorPoint(CCPointMake(0.5, 0.5));
  _allStarBox:addChild(allStarBoxImage)


  local allStarStr = currentStars .. "/" .. allStars * 3
  local textData = self.armature:getBone("allStar_text").textData
  self.allStarStrText = createTextFieldWithTextData(textData,allStarStr)
  self.allStarStrText:setPositionXY(-30,-35);
  _allStarBox:addChild(self.allStarStrText);
  self.allStarStrText.touchEnabled = false

  local allstarImage = self.skeleton:getBoneTextureDisplay("allstarImage");
  allstarImage:setPositionXY(-60,-35)
  allstarImage.touchEnabled = false
  _allStarBox:addChild(allstarImage);

  --能领的时候左右晃一下
  if _boxId == 1739 then
    Tweenlite:leftRightShake(allStarBoxImage)
  elseif _boxId == 1740 then
    local havetakenImage = self.skeleton:getBoneTextureDisplay("havetakenImage");
    havetakenImage:setAnchorPoint(CCPointMake(0.4, 0.1))
    _allStarBox:addChild(havetakenImage)
  end
end

function StoryLinePopup:setData(strongPointId)
  self.curStrongPointId = strongPointId
  local storyLineId = analysis("Juqing_Guanka",strongPointId, "storyId")
  self.storyLineId = storyLineId;
  local storylines = self.storyLineProxy.openedStorylineIds;
  local index = 0;
  for k, v in ipairs(storylines) do
    index = index + 1;
    if v == storyLineId then
      break;
    end
  end
  print("storyLineId, index",storyLineId, index)
  self.scrollView:update(storylines, index);
end


function StoryLinePopup:refreshData(storyLineId)
  self.storyLineId = storyLineId;
  local storylines = self.storyLineProxy.openedStorylineIds;
  local index = 0;
  for k, v in ipairs(storylines) do
    index = index + 1;
    if v == storyLineId then
      break;
    end
  end
  print("storyLineId, index",storyLineId, index)
  self.scrollView:update(storylines, index);
end

function StoryLinePopup:isStoryLineOpen(storyLineId)
  for k, v in pairs(self.openedStoryLines) do
    if (v == storyLineId) then
      return true;
    end
  end
  return false;
end

-- function StoryLinePopup:getOpenedStoryLines()
--   local returnValue = {};
--   local currentStoryLineId = self.storyLineId;

--   while (currentStoryLineId ~= 0 and currentStoryLineId) do
--     table.insert(returnValue, 1, currentStoryLineId)

--     if analysisHas("Juqing_Juqing", currentStoryLineId) then
--       currentStoryLineId = analysis("Juqing_Juqing", currentStoryLineId, "parent")

--       local strongPoints = analysisByName("Juqing_Guanka", "storyId", currentStoryLineId)
--       for k, v in pairs(strongPoints)do
--         local strongPointData = {StrongPointId = v.id, State= 1};
--         local key = "key_" .. v.id;
--         print("++++++++++++++++++++++++++++++key", key)
--         self.storyLineProxy.strongPointArray[key] = strongPointData;
--       end
--     else
--       break;
--     end
--   end
--   return returnValue;
-- end


function StoryLinePopup:onStrongPointCallBack(strongPointId)
  self:dispatchEvent(Event.new("ON_ENTER_BATTLE",{strongPointId = strongPointId},self));
  self:setMoveEnabled(false)
end
function StoryLinePopup:onPreUIClose()

end
function StoryLinePopup:clean()
  self:removeAllEventListeners();
end

--@overwrite
function StoryLinePopup:onUIClose()
  self:dispatchEvent(Event.new("CLOSE_JUANZHOU_PARENT",nil,self));
  if GameData.isMusicOn then
    if 1 == self.storyLineProxy:getStrongPointState(10001011) then
      MusicUtils:play(1003,GameData.isMusicOn);
    else
      MusicUtils:play(1002,GameData.isMusicOn);
    end

  end
end
function StoryLinePopup:setMoveEnabled(b)
  self.scrollView:setMoveEnabled(b)
end

