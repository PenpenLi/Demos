require "main.view.bag.ui.bagPopup.BagItem"
require "main.view.quickBattle.ui.MopUpResultUI";
FullStarShow=class(LayerPopableDirect);

function FullStarShow:ctor()
  self.class=FullStarShow;
end

function FullStarShow:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  FullStarShow.superclass.dispose(self);
  self.armature:dispose()

end
function FullStarShow:onDataInit()

  self.bagProxy=self:retrieveProxy(BagProxy.name);
  self.storyLineProxy=self:retrieveProxy(StoryLineProxy.name)

  self.skeleton = self.storyLineProxy:getSkeleton();

  local layerPopableData = LayerPopableData.new();
  layerPopableData:setHasUIBackground(false);
  layerPopableData:setHasUIFrame(true);
  layerPopableData:setVisibleDelegate(false)
  layerPopableData:setArmatureInitParam(self.skeleton,"allStar_ui");
  self:setLayerPopableData(layerPopableData);

end

function FullStarShow:onUIInit()

  local strongPointNameTextDO = self.armature:getBone("strongPointName_txt"):getDisplay();
  
  local passCount_desc_txtData = self.armature:getBone("passCount_desc_txt").textData;
  self.uiDescText = createMultiColoredLabelWithTextData(passCount_desc_txtData, "");
  self.armature.display:addChild(self.uiDescText);

  self.closeButton = Button.new(self.armature:findChildArmature("confirm_button"), false,"确定",true);
  -- self.closeButton:setLable("确定")
  self.closeButton:addEventListener(Events.kStart, self.closeUI, self);

  local tileNameText = BitmapTextField.new("满星宝箱","anniutuzi");--选择好友助战
  tileNameText:setPositionXY(strongPointNameTextDO:getPositionX() + 15,strongPointNameTextDO:getPositionY() - 10)
  self.armature.display:addChild(tileNameText);
end

function FullStarShow:onPrePop()
    
  local mainSize = Director:sharedDirector():getWinSize();

  local armature_dSize =  self.armature.display:getGroupBounds().size
  
  self.armature_d_x = (mainSize.width - armature_dSize.width)/2
  self.armature_d_y = (mainSize.height - armature_dSize.height)/2- GameData.uiOffsetY
  self.armature.display:setPositionXY(self.armature_d_x, self.armature_d_y)
end
function FullStarShow:initialize(starState,storyLineId,context)

  self.starState = starState
  self.storyLineId = storyLineId
  self.context = context

  context.scrollView:setMoveEnabled(false)

  -- self:initLayer();

  local mainSize = Director:sharedDirector():getWinSize();

  local layerColor = LayerColor.new();
  layerColor:initLayer();
  layerColor:changeWidthAndHeight(mainSize.width, mainSize.height);
  layerColor:setColor(ccc3(0,0,0));
  layerColor:setOpacity(150);
  self:addChildAt(layerColor,0)

  local currentStars = self.storyLineProxy:getStorylineStarCount(self.storyLineId)
  local allStars = self.storyLineProxy:getStrongPointCount(self.storyLineId)
  local str1 = "达到".. allStars * 3 .."星时可领取"
  local str2 = "(".. currentStars .. "/" .. allStars * 3 .. ")"
  local textMui = ""
  if starState == 1 then
    textMui = '<content><font color="#67190E">' .. str1 .. '</font><font color="#ff0000">'.. str2 ..'</font>'
  elseif starState == 2 then
    textMui = '<content><font color="#67190E">' .. str1 .. '</font><font color="#000000">'.. str2 ..'</font>'
    self.closeButton:setLable("领取")
  elseif starState == 3 then
    textMui = '<content><font color="#67190E">' .. str1 .. '</font><font color="#000000">'.. str2 ..'</font>'
    self.closeButton:setLable("已领取")
  end


  self.uiDescText:setString(textMui)

  local viewList = ListScrollViewLayer.new();
  viewList:initLayer();
  viewList:setPositionXY(64,110)
  viewList:setDirection(kCCScrollViewDirectionHorizontal);
  viewList:setViewSize(makeSize(400,180));
  viewList:setItemSize(makeSize(120,150));
  self.armature.display:addChild(viewList);

  local itemTable = StringUtils:lua_string_split(analysis("Juqing_Juqing", storyLineId ,"show"),";")
  for k,v in pairs(itemTable) do
    local singalItemTable = StringUtils:lua_string_split(v,",")
  
    local common_grid=CommonSkeleton:getBoneTextureDisplay("commonGrids/common_grid");

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

function FullStarShow:onTap(event)
  self.context:dispatchEvent(Event.new("ON_ITEM_TIP", {item = event.target},self));
end

function FullStarShow:onUIClose()
  if GameVar.tutorStage == TutorConfig.STAGE_1006 then
    openTutorUI({x=1175, y=636, width = 78, height = 75, alpha = 125});
    sendServerTutorMsg({Stage = GameVar.tutorStage, Step = 100603, BooleanValue = 0})
  end
  self.context.scrollView:setMoveEnabled(true)
  if self.starState == 1 then

  elseif self.starState == 2 then
    sendMessage(4,7,{StoryLineId = self.storyLineId})

  elseif self.starState == 3 then
    
  end
  MusicUtils:playEffect(8,false)
  self.parent:removeChild(self)
end