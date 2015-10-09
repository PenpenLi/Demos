

TenCountryLayer=class(Layer);

function TenCountryLayer:ctor()
    self.class=TenCountryLayer;
    self.armature = nil;
    self.armature_d = nil;

end

function TenCountryLayer:dispose()
    self:removeAllEventListeners();
    self:removeChildren();
    TenCountryLayer.superclass.dispose(self);
    self.popUp = nil;
    self:removeLoopTimer()
end

function TenCountryLayer:initialize(popUp,tenCountryProxy)
    if self.popUp then return end;
    self.popUp = popUp; 
    self:initLayer()
    self:initListView()
    if self.viewList then
        self.viewList:removeChildren();
        self.jianTou = nil
    end
    self.tenCountryProxy = tenCountryProxy
    -- self:setInitData(tenCountryProxy)
    self:initItemUI()
    self:initJianTou()
end

function TenCountryLayer:refreshTenCountryMapData()
    local num = self.tenCountryProxy.placeState >= 2 and 2 or 1
    self.openState = num;
    -- self:setInitData(self.tenCountryProxy)
    hecDC(3,8,1,{countryID = self.tenCountryProxy.placeId})
    self:refreshItemData()
end

-- function TenCountryLayer:setInitData(tenCountryProxy)
--     self.tenCountryProxy.placeId = tenCountryProxy.placeId
-- end

function TenCountryLayer:initListView()
    self.viewList = Layer.new();
    self.viewList:initLayer();
    self.viewList:setContentSize(makeSize(GameConfig.STAGE_WIDTH*2 , GameConfig.STAGE_HEIGHT));
    self:addChild(self.viewList);
    self.viewList:addEventListener(DisplayEvents.kTouchMove,self.onTouchLayerMove,self);
    self.viewList:addEventListener(DisplayEvents.kTouchEnd,self.onTouchLayerEnd,self);
    self.viewList:addEventListener(DisplayEvents.kTouchBegin,self.onTouchLayerBegin,self);
end

function TenCountryLayer:onTouchLayerBegin(event)
    self.isMove = false;
    self.startPosition = event.globalPosition;
    self:removeLoopTimer()
end
function TenCountryLayer:onTouchLayerMove(event)
    local position = event.globalPosition;
    local dx = self.startPosition.x-position.x;
    local dy = self.startPosition.y-position.y;

    local dis = math.sqrt(math.pow(dx, 2)+math.pow(dy, 2));
    if dis >50 then
        self.speed = position.x - self.lastPositionX;
        local tempPx = self.viewList:getPositionX() + self.speed
        self.stopType = 0
        if tempPx > -5 then
            self.viewList:setPositionX(0)
            self.stopType = 1
        elseif  tempPx < -GameConfig.STAGE_WIDTH then
            self.viewList:setPositionX(-GameConfig.STAGE_WIDTH )
            self.stopType = 2
        else
            self.viewList:setPositionX(self.viewList:getPositionX() + self.speed)
            self.stopType = 3
        end
        self.isMove = true;
    end
    self.lastPositionX = position.x
end

function TenCountryLayer:onTouchLayerEnd(event)
    if self.isMove and self.stopType == 3 then
        -- local flag = self.speed > 0 and 1 or -1
        self.targetPx = self.viewList:getPositionX() + self.speed*(1/GameConfig.Game_FreamRate)*0.5
        self:removeLoopTimer()
        local function loopTimeFun()
            self:reviseMapMove()
        end
        self.loopTime = Director:sharedDirector():getScheduler():scheduleScriptFunc(loopTimeFun, 0, false)
        self:reviseMapMove()
    end
    self.isMove = false;
    self.stopType = 0
end

function TenCountryLayer:reviseMapMove()
      local disX = self.targetPx - self.viewList:getPositionX()
      local stepx = disX/(1/GameConfig.Game_FreamRate)
      self.viewList:setPositionX(self.viewList:getPositionX() + stepx)

      if not self:isCanMove(stepx) then
            self:removeLoopTimer()
      end
end

function TenCountryLayer:isCanMove(stepx)
    local tempPx = self.viewList:getPositionX() + stepx
    if tempPx > 0 then
        return false
    elseif  tempPx < -GameConfig.STAGE_WIDTH  then
        return false
    else
        return true
    end
end

function TenCountryLayer:removeLoopTimer()
    if self.loopTime then
        Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.loopTime);
        self.loopTime = nil
    end
end

function TenCountryLayer:initItemUI()
    require "main.view.tenCountry.ui.TenCountryMapItem";
    self.firstMapItem = TenCountryMapItem.new()
    self.firstMapItem:initLayer()
    self.firstMapItem:initializeItem(self.popUp.skeletonTenCountry,1)
    self.secondMapItem = TenCountryMapItem.new()
    self.secondMapItem:initLayer()
    self.secondMapItem:initializeItem(self.popUp.skeletonTenCountry,2)
    self.secondMapItem:setPositionX(GameConfig.STAGE_WIDTH)
    
    self.viewList:addChild(self.firstMapItem)
    self.viewList:addChild(self.secondMapItem)
    if self.tenCountryProxy.placeId <= 5 then
        self.viewList:setPositionX(0)
    else
        self.viewList:setPositionX(-GameConfig.STAGE_WIDTH)
    end
end

function TenCountryLayer:initJianTou()
    if self.jianTou then
        self.jianTou.parent:removeChild(self.jianTou)
    end
    -- if not self.jianTou then
    self.jianTou = self.popUp.skeletonTenCountry:getBoneTextureDisplay("jiantou")
    if self.tenCountryProxy.placeId <= 5 then
        self.firstMapItem:addChild(self.jianTou)
    else
        self.secondMapItem:addChild(self.jianTou)
    end
    self.jianTou.touchEnabled = false;
    self.jianTou.touchChildren = false;  
    -- end
end

function TenCountryLayer:refreshItemData()
    self.jianTouPosition = nil;
    if self.tenCountryProxy.placeId <= 5 then 
        self.firstMapItem:refreshBuildingHandler(self.popUp.skeletonTenCountry,self.tenCountryProxy.placeId,self.openState)
        self.jianTouPosition = self.firstMapItem:getBuildingPosition()
    elseif self.tenCountryProxy.placeId > 5 then 
        self.secondMapItem:refreshBuildingHandler(self.popUp.skeletonTenCountry,self.tenCountryProxy.placeId,self.openState)
        self.jianTouPosition = self.secondMapItem:getBuildingPosition()
    end
    self:refreshBaoXiang()
    self:jianTouAction()

  if GameVar.tutorStage == TutorConfig.STAGE_1026 then
    if self.tenCountryProxy.placeId == 1 and  self.tenCountryProxy.placeState == 1 then
      GameVar.tutorSmallStep = 102601
      openTutorUI({x=68, y=392, width = 136, height = 171, alpha = 125});
    elseif self.tenCountryProxy.placeId == 1 and  self.tenCountryProxy.placeState == 2 then
      GameVar.tutorSmallStep = 102604
      openTutorUI({x=154, y=246, width = 73, height = 77, alpha = 125});
    elseif GameVar.tuturReaccess then
      closeTutorUI();
    end
  end

end

function TenCountryLayer:refreshBaoXiang()
    if self.tenCountryProxy.placeState >= 2 then
        self.firstMapItem:refreshPass(self.popUp.skeletonTenCountry,self.tenCountryProxy.placeId)
        self.secondMapItem:refreshPass(self.popUp.skeletonTenCountry,self.tenCountryProxy.placeId)
    end
    if self.tenCountryProxy.placeId ~= 1 then

        local openPlace = self.tenCountryProxy.placeId ~= 10 and self.tenCountryProxy.placeId-1 or self.tenCountryProxy.placeId
        for place=1,openPlace do
            if place <= 5 then 
                self.firstMapItem:refreshPass(self.popUp.skeletonTenCountry,place)
            elseif place > 5 then 
                if place < 10 then 
                    self.secondMapItem:refreshPass(self.popUp.skeletonTenCountry,place)
                end
            end
            if self.tenCountryProxy.placeId == place and self.tenCountryProxy.placeState ~= 3 then
                break
            end
            if place <= 5 then 
                self.firstMapItem:refreshBaoXiang(self.popUp.skeletonTenCountry,place)
                -- self.firstMapItem:refreshPass(self.popUp.skeletonTenCountry,place)
            elseif place > 5 then 
                self.secondMapItem:refreshBaoXiang(self.popUp.skeletonTenCountry,place)
                -- self.secondMapItem:refreshPass(self.popUp.skeletonTenCountry,place)
            end
        end
    end
    local tempPlace = self.openState == 1 and self.tenCountryProxy.placeId or self.tenCountryProxy.placeId + 1
    for place = tempPlace, 10 do
        if place <= 5 then 
            self.firstMapItem:refreshBaoXiangListener(self.popUp.skeletonTenCountry,place)
        elseif place > 5 then
            self.secondMapItem:refreshBaoXiangListener(self.popUp.skeletonTenCountry,place)
        end
    end
    if self.popUp.resertSate then
        self.firstMapItem:resertBaoxingState()
        self.firstMapItem:resertBaoxingState()
    end
end

function TenCountryLayer:jianTouAction()
    if self.tenCountryProxy.placeId == 10 and self.tenCountryProxy.placeState == 3 then
        self.jianTou:setVisible(false)
        return
    end
    local moveTo = CCEaseSineInOut:create(CCMoveBy:create(0.4, ccp(0, 50)))
    local moveBack = CCEaseSineInOut:create(CCMoveBy:create(0.4, ccp(0, -50)))
    self:initJianTou()
    self.jianTou:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(moveTo, moveBack)))
    self.jianTou:setPositionXY(self.jianTouPosition.x,self.jianTouPosition.y,true)
end