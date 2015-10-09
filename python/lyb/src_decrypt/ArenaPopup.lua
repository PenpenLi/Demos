
ArenaPopup=class(LayerPopableDirect);

function ArenaPopup:ctor()
  self.class=ArenaPopup;
  self.skeleton=nil;
end

function ArenaPopup:dispose()
  self.arenaProxy:setTimeValue(nil)
  self:removeAllEventListeners();
  self:removeChildren();
  ArenaPopup.superclass.dispose(self);
  BitmapCacher:removeUnused();
end

function ArenaPopup:initialize()
  self.arenaProxy=nil;
end

function ArenaPopup:onDataInit()
  self.arenaProxy=self:retrieveProxy(ArenaProxy.name);
  self.heroHouseProxy=self:retrieveProxy(HeroHouseProxy.name);
  self.countProxy=self:retrieveProxy(CountControlProxy.name);
  self.userProxy=self:retrieveProxy(UserProxy.name);
  self.userCurrencyProxy=self:retrieveProxy(UserCurrencyProxy.name);
  self.battleProxy=self:retrieveProxy(BattleProxy.name);
  self.storyLineProxy=self:retrieveProxy(StoryLineProxy.name)

  self.skeleton = getSkeletonByName("arena_ui");
  local layerPopableData = LayerPopableData.new();
  layerPopableData:setHasUIBackground(true);
  layerPopableData:setHasUIFrame(false);
  layerPopableData:setArmatureInitParam(self.skeleton,"arena_ui");
  layerPopableData:setShowCurrency(true);
  self:setLayerPopableData(layerPopableData);
  sendMessage(16,1)
  -- if GameData.isMusicOn then
  --   MusicUtils:play(4,true)
  -- end
end

function ArenaPopup:onPrePop()
  self:setContentSize(makeSize(GameConfig.STAGE_WIDTH,GameConfig.STAGE_HEIGHT));
  self.imageBg = getImageByArtId(StaticArtsConfig.BACKGROUD_HERO_HOUSE);
  self.imageBg:setPositionY((720-960)/2)
  self:addChildAt(self.imageBg,0)
  -- visible red dot
  -- if not GameData.clickRedDotArr[FunctionConfig.FUNCTION_ID_26] 
  --    and GameData.hasRedDotArr[FunctionConfig.FUNCTION_ID_26] then
  --   GameData.clickRedDotArr[FunctionConfig.FUNCTION_ID_26] = true
  --   self:dispatchEvent(Event.new("TO_REFRESH_REDDOT")); 
  -- end

end

function ArenaPopup:oNclick()

end

function ArenaPopup:onUIInit()

end

function ArenaPopup:onRequestedData()
    self:initArenaLayerData()
end

function ArenaPopup:refreshTimeData()
    if self.arenaLayer then
      self.arenaLayer:refreshTimeData("force")
    end
end

function ArenaPopup:refreshHeroDetailData(userId)
    if self.arenaLayer then
      self.arenaLayer:refreshHeroDetailData(userId)
    end
end

function ArenaPopup:refreshTimesData()
    if self.arenaLayer then
      self.arenaLayer:refreshTimesData()
    end
end

function ArenaPopup:refreshUpdateTimesData()
    if self.arenaLayer then
      -- if self.arenaLayer.buttonState == 2 then
      --   return 
      -- end
      self.arenaLayer:addRefreshButtonState()
    end
end

function ArenaPopup:getTenContrySkeleton()
    return getSkeletonByName("shiguo_ui");
end

function ArenaPopup:toTeamLayer()
    require "main.view.arena.ui.ArenaTeamLayer";
    self.arenaTeamLayer = ArenaTeamLayer.new()
    self.arenaTeamLayer:initLayer()
    self.arenaTeamLayer:initializeUI(self)
    self:addChildAt(self.arenaTeamLayer,1000)
end

function ArenaPopup:disposeTeamLayer()
    if self.arenaTeamLayer then
      self:removeChild(self.arenaTeamLayer)
      self.arenaTeamLayer = nil
    end
end

function ArenaPopup:onUIClose()
  self:dispatchEvent(Event.new("closeNotice",nil,self));
  if GameData.isMusicOn then
    if 1 == self.storyLineProxy:getStrongPointState(10001011) then
      MusicUtils:play(1003,GameData.isMusicOn);
    else
      MusicUtils:play(1002,GameData.isMusicOn);
    end
  end
end

function ArenaPopup:refreshData()
    self:initArenaLayerData()
    self.arenaLayer:refreshArenaLayerData()
end

function ArenaPopup:refreshDefData()
    if self.arenaLayer then
      self.arenaLayer:refreshDefData()
    end
end

function ArenaPopup:refreshUserData()
    self.arenaLayer:refreshUserData()
end

function ArenaPopup:initArenaLayerData()
    if self.arenaLayer then return end
    require "main.view.arena.ui.ArenaLayer";
    self.arenaLayer = ArenaLayer.new()
    self.arenaLayer:initLayer()
    self.arenaLayer:initialize(self)
    self:addChildAt(self.arenaLayer,1)
    -- AddUIFrame(self);
end

function ArenaPopup:onPhbTap()
    require "main.view.arena.ui.ArenaRankingLayer";
    self.arenaRankingLayer=ArenaRankingLayer.new();
    self.arenaRankingLayer:initialize(self);
    self:addChild(self.arenaRankingLayer)
    sendMessage(25,1,{Type = GameConfig.Ranking_Type_6})
end

function ArenaPopup:refreshRankingData()
  self.arenaRankingLayer:refreshRankingData();
  hecDC(3,16,2)
end

function ArenaPopup:closeArenaRankingLayer()
    if self.arenaRankingLayer then
        self:removeChild(self.arenaRankingLayer)
        self.arenaRankingLayer = nil
    end
end