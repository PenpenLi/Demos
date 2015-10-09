
PossessionViewUI=class(TouchLayer);

function PossessionViewUI:ctor()
  self.class=PossessionViewUI;
  self.buttonHeight = 54;
  self.itemArray = {}
end

function PossessionViewUI:dispose()
  self.parent_container = nil
  self.battle_ui = nil
  self.popUp = nil
  self:removeAllEventListeners();
  self:removeChildren();
	PossessionViewUI.superclass.dispose(self);
  self:removeTimeOut()
  self.movieClip:dispose()
  self.movieClip = nil;
  for k1,v1 in pairs(self.itemArray) do
      v1.itemMovieClip:dispose()
  end
end

--
function PossessionViewUI:initializeUI(skeleton,battle_ui,popUp,placeID,mapID)
  initializeSmallLoading()
  self:initLayer();
  self.skeleton=skeleton;
  self.popUp = popUp;
  self.battle_ui = battle_ui

  local bigBackground = LayerColorBackGround:getTransBackGround()
  self:addChild(bigBackground);
  bigBackground:addEventListener(DisplayEvents.kTouchTap,self.clickHandler,self);

  local movieClip = MovieClip.new();
  movieClip:initFromFile("possession_battle_ui", "view_battle");
  movieClip:gotoAndPlay("f1");
  self:addChild(movieClip.layer);
  movieClip:update();
  self.movieClip = movieClip;

  local text_data=movieClip.armature:getBone("view_p").textData;
  self.itemPx = text_data.x;
  self.itemPy = text_data.y-50;

  for k1=1,3 do
      self:initItem(k1)
  end

  local text_data=movieClip.armature:getBone("view_des_text").textData;
  local viewText=createTextFieldWithTextData(text_data,"缓存可能会较长时间，请耐心等待...");
  self:addChild(viewText);
  sendMessage(27,88,{MapId=mapID,Place=placeID})
end

function PossessionViewUI:initItem(k1)
  local itemLayer = Layer.new()
  itemLayer:initLayer()
  itemLayer:setPositionXY(self.itemPx,self.itemPy-(k1-1)*80)
  self:addChild(itemLayer)
  table.insert(self.itemArray,itemLayer)
  itemLayer.placeID = k1

  local itemMovieClip = MovieClip.new();
  itemMovieClip:initFromFile("possession_battle_ui", "view_item");
  itemMovieClip:gotoAndPlay("f1");
  itemLayer:addChild(itemMovieClip.layer);
  itemMovieClip:update();
  itemLayer.itemMovieClip = itemMovieClip;

  itemMovieClip.armature:initTextFieldWithString("view_team_text", self:getTeamStr(k1).."战斗回放");
  itemLayer.playButton=Button.new(itemMovieClip.armature:findChildArmature("common_copy_blueround_button"),false);
  itemLayer.playButton.bone:initTextFieldWithString("common_copy_blueround_button","播放");
  itemLayer.playButton.bone.display:addEventListener(DisplayEvents.kTouchTap,self.playButtonHandler,self,k1);
end

function PossessionViewUI:getTeamStr(k1)
    local tempStr;
    if k1 == 1 then
        tempStr = "甲队"
    elseif k1 == 2 then
        tempStr = "乙队"
    elseif k1 == 3 then
        tempStr = "丙队"
    end
    return tempStr;
end

function PossessionViewUI:refreshProgress()
    local battleProxy = self.popUp.battleProxy
    for k1,v1 in ipairs(self.battleIDArr) do
        if battleProxy.currentDownBattleID == v1 then
            local itemLayer = self.itemArray[k1]
            itemLayer.progressBar:setProgress(battleProxy:getProgressValue(v1))
        end
    end
end

function PossessionViewUI:playButtonHandler(event,placeID)
    local battleInfoArray = self.popUp.battleProxy.familyViewData.BattleInfoArray
    self.popUp.battleProxy.familyViewData.familyTeamStr = self:getTeamStr(placeID)
    self.popUp:dispatchEvent(Event.new(PossessionBattleNotifications.POSSESSION_BATTLE_VIEW,{battleID = battleInfoArray[placeID].BattleId},self));
    self:setTimeOut()
end

function PossessionViewUI:setGrayPlayButton(itemLayer)
  local tempArmature = itemLayer.itemMovieClip.armature
  tempArmature:findChildArmature("common_copy_blueround_button").animation:gotoAndPlay("disabled");
  itemLayer.playButton.enabled = false ;
  if itemLayer.playButton.bone.display:hasEventListener(DisplayEvents.kTouchTap, self.playButtonHandler) then 
    itemLayer.playButton.bone.display:removeEventListener(DisplayEvents.kTouchTap, self.playButtonHandler)
  end
end

function PossessionViewUI:setNormalPlayButton(itemLayer)
  local tempArmature = itemLayer.itemMovieClip.armature
  tempArmature:findChildArmature("common_copy_blueround_button").animation:gotoAndPlay("normal");
  itemLayer.playButton.enabled = true ;
  itemLayer.playButton.bone.display:addEventListener(DisplayEvents.kTouchTap,self.playButtonHandler,self,itemLayer.placeID);
end

function PossessionViewUI:setGrayDownButton(itemLayer)
  local tempArmature = itemLayer.itemMovieClip.armature
  tempArmature:findChildArmature("common_copy_greenroundbutton").animation:gotoAndPlay("disabled");
  itemLayer.downButton.enabled = false ;
  if itemLayer.downButton.bone.display:hasEventListener(DisplayEvents.kTouchTap, self.downButtonHandler) then 
    itemLayer.downButton.bone.display:removeEventListener(DisplayEvents.kTouchTap, self.downButtonHandler)
  end
end

function PossessionViewUI:setNormalDownButton(itemLayer)
  local tempArmature = itemLayer.itemMovieClip.armature
  tempArmature:findChildArmature("common_copy_greenroundbutton").animation:gotoAndPlay("normal");
  itemLayer.downButton.enabled = true ;
  itemLayer.downButton.bone.display:addEventListener(DisplayEvents.kTouchTap,self.downButtonHandler,self,itemLayer.placeID);
end

function PossessionViewUI:clickHandler(event)
    self.battle_ui:galleryViewLayerEnabled(true)
    if self.parent then
        self.parent:removeChild(self)
    end
end

function PossessionViewUI:setTimeOut()
    local function timeOut()
        self:removeTimeOut();
        self.touchEnabled=true;
        self.touchChildren=true;
    end
    self.touchEnabled=false;
    self.touchChildren=false;
    self.timeOut = Director:sharedDirector():getScheduler():scheduleScriptFunc(timeOut, 0.6, false);
end

function PossessionViewUI:removeTimeOut()
    if self.timeOut then
        Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.timeOut);
        self.timeOut = nil;
    end
end
