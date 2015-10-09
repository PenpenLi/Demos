

TenCountryMapItem=class(Layer);

function TenCountryMapItem:ctor()
    self.class=TenCountryMapItem;
end

function TenCountryMapItem:dispose()
    self:removeAllEventListeners();
    self:removeChildren();
    TenCountryMapItem.superclass.dispose(self);
end

function TenCountryMapItem:initializeItem(skeleton,itemNumber)
	if itemNumber == 1 then
		self:firstItem(skeleton)
	elseif itemNumber == 2 then
		self:secondItem(skeleton)
	end
end

function TenCountryMapItem:firstItem(skeleton)
    local imageBg = getImageByArtId(618);
    -- imageBg:setScale(2)
    imageBg:setPositionY((720-960)/2)
    self:addChildAt(imageBg,0)

	local mapcityArmature=skeleton:buildArmature("mapcity1_ui");
    mapcityArmature.animation:gotoAndPlay("f1");
    mapcityArmature:updateBonesZ();
    mapcityArmature:update();
    self.mapcityArmature = mapcityArmature;
    
    local mapcityArmature_d=mapcityArmature.display;
    self.mapcityArmature_d = mapcityArmature_d;
    self:addChild(mapcityArmature_d);
    
end

function TenCountryMapItem:secondItem(skeleton)
    local imageBg = getImageByArtId(619);
    -- imageBg:setScale(2)
    imageBg:setPositionY((720-960)/2)
    self:addChildAt(imageBg,0)

	local mapcityArmature=skeleton:buildArmature("mapcity2_ui");
    mapcityArmature.animation:gotoAndPlay("f1");
    mapcityArmature:updateBonesZ();
    mapcityArmature:update();
    self.mapcityArmature = mapcityArmature;
    
    local mapcityArmature_d=mapcityArmature.display;
    self.mapcityArmature_d = mapcityArmature_d;
    self:addChild(mapcityArmature_d);
end

function TenCountryMapItem:refreshBuildingHandler(skeleton,openPlace,state,contryLayer)
    if state == 1 then
        self.building = self.mapcityArmature_d:getChildByName("bd"..openPlace.."_"..state)
        if not self.building then return end
        self.building:addEventListener(DisplayEvents.kTouchBegin,self.onClickTapBegin,self);
        self.buildingPosition = makePoint(self.building:getPosition().x-30,self.building:getPosition().y)
    else
        if not (self.parent.parent.popUp.tenCountryProxy.placeState == 3) then
            local buildingImg = self.mapcityArmature_d:getChildByName("bd"..openPlace.."_"..state)
            buildingImg:setVisible(false)
            self.buildingPosition = makePoint(buildingImg:getPosition().x+30,buildingImg:getPosition().y)
            local buildingListenerImg = CommonButton.new();
            buildingListenerImg:initialize("baoxiangbutton_normal","baoxiangbutton_down",CommonButtonTouchable.CUSTOM,skeleton);
            buildingListenerImg:setPositionXY(buildingImg:getPosition().x,buildingImg:getPosition().y-95);
            buildingListenerImg:addEventListener(DisplayEvents.kTouchBegin,self.onClickTap,self,"bd"..openPlace.."_"..state);
            self.mapcityArmature_d:addChild(buildingListenerImg)
        end
    end
    self.openPlace = openPlace;
end

function TenCountryMapItem:refreshBaoXiang(skeleton,openPlace)
    local buildingImg = self.mapcityArmature_d:getChildByName("bd"..openPlace.."_2")
    if not buildingImg then return end
    buildingImg:setVisible(false)
    local baoxiangButton = CommonButton.new();
    baoxiangButton:initialize("baoxiangbutton_normal","baoxiangbutton_down",CommonButtonTouchable.CUSTOM,skeleton);
    baoxiangButton:setPositionXY(buildingImg:getPosition().x,buildingImg:getPosition().y-95);
    baoxiangButton:select(true)
    self.mapcityArmature_d:addChild(baoxiangButton)
end

function TenCountryMapItem:refreshPass(skeleton,passPlace)
    local buildingImg = self.mapcityArmature_d:getChildByName("bd"..passPlace.."_1")
    if not buildingImg then return end
    self.hasPass = skeleton:getBoneTextureDisplay("hasPass")
    local position = buildingImg:getPosition()
    self.hasPass:setPositionXY(position.x-70,position.y)
    self:addChild(self.hasPass)
end

function TenCountryMapItem:refreshBaoXiangListener(skeleton,place)
    local buildingImg = self.mapcityArmature_d:getChildByName("bd"..place.."_2")
    if not buildingImg then return end
    buildingImg:setVisible(false)
    local buildingListenerImg = CommonButton.new();
    buildingListenerImg:initialize("baoxiangbutton_normal","baoxiangbutton_down",CommonButtonTouchable.CUSTOM,skeleton);
    buildingListenerImg:setPositionXY(buildingImg:getPosition().x,buildingImg:getPosition().y-95);
    buildingListenerImg:addEventListener(DisplayEvents.kTouchBegin,self.onClickListenerBegin,self,place);
    self.mapcityArmature_d:addChild(buildingListenerImg)
end

function TenCountryMapItem:onClickListenerBegin(event,place)
    MusicUtils:playEffect(7)
    event.target:setScale(1.2)
    event.target:setPositionX(event.target:getPositionX()-10)
    event.target:addEventListener(DisplayEvents.kTouchEnd,self.scaleToListenerNormal,self,place);
end

function TenCountryMapItem:scaleToListenerNormal(event,place)
    event.target:setScale(1)
    event.target:setPositionX(event.target:getPositionX()+10)
    if self.parent.parent.isMove then return end
    local zhengzhanPO = analysis("Shili_Shiguozhengzhan",place);
    local functionStr = analysis("Daoju_Daojubiao",zhengzhanPO.box,"function");
    TipsUtil:showTips(event.target,functionStr,350,0);
end

function TenCountryMapItem:getBuildingPosition()
    return self.buildingPosition
end

function TenCountryMapItem:onClickTapBegin()
    MusicUtils:playEffect(7)
    self.building:setScale(1.2)
    self.building:addEventListener(DisplayEvents.kTouchEnd,self.scaleToNormal,self);
end

function TenCountryMapItem:scaleToNormal()
    self.building:setScale(1)
    if self.parent.parent.isMove then return end
    self:buildingTap()
end

function TenCountryMapItem:buildingTap()
    self.parent.parent.popUp:initBossView(self.openPlace)
    -- setFactionCurrencyVisible(false)
    -- self.parent.parent:setViewListEnable(false)
end

function TenCountryMapItem:onClickTap(event,placeName)
    MusicUtils:playEffect(501,false);
    event.target:addEventListener(DisplayEvents.kTouchEnd,self.tapNormal,self,placeName);
end

function TenCountryMapItem:tapNormal(event,placeName)
    local zhengzhanPO = analysis("Shili_Shiguozhengzhan",self.openPlace);
    local parameter1 = analysis("Daoju_Daojubiao",zhengzhanPO.box,"parameter1");
    if self.parent.parent.popUp.bagProxy:getBagLeftPlaceCount() <= parameter1  then 
        sharedTextAnimateReward():animateStartByString("背包快满了哦 ~");
        return 
    end
    if placeName == "bd5_2" then
        self.parent.parent.popUp.resertSate = true
    end
    event.target:select(true)
    sendMessage(19,7)

    if GameVar.tutorStage == TutorConfig.STAGE_1026 then
     sendServerTutorMsg({Stage = GameVar.tutorStage, Step = 102608, BooleanValue = 0})
    end
    
end