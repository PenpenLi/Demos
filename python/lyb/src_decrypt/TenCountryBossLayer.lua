

TenCountryBossLayer=class(ScaleLayer);

function TenCountryBossLayer:ctor()
    self.class=TenCountryBossLayer;
    self.armature = nil;
    self.armature_d = nil;
    self.timerTextArray = {}
end

function TenCountryBossLayer:dispose()
    self:removeAllEventListeners();
    self:removeChildren();
    TenCountryBossLayer.superclass.dispose(self);
    self.popUp = nil
end

function TenCountryBossLayer:initializeUI(popUp,placeId)
    if self.popUp then return end;
    self.popUp = popUp; 

    self:initViewUI()
    self:refreshBossData(placeId)
    self:changeAnchorPoint(GameConfig.STAGE_WIDTH/2,GameConfig.STAGE_HEIGHT/2)
    --self:openAction()
end

-- function TenCountryBossLayer:openAction()
--     --self:setScaleX(0)
--     --self:runAction(CCEaseSineOut:create(CCScaleTo:create(0.2,1)))
-- end

function TenCountryBossLayer:initViewUI()
    local backHalfAlphaLayer =  LayerColorBackGround:getCustomBackGround(GameConfig.STAGE_WIDTH, GameConfig.STAGE_HEIGHT+200, 185)
    backHalfAlphaLayer:setPositionY(-GameData.uiOffsetY)
    self:addChild(backHalfAlphaLayer)

    local armature=self.popUp.skeleton:buildArmature("view_ui");
    armature.animation:gotoAndPlay("f1");
    armature:updateBonesZ();
    armature:update();
    self.armature = armature;
    
    local armature_d=armature.display;
    self.armature_d = armature_d;
    self:addChild(armature_d);

    self.closeButton = Button.new(self.armature:findChildArmature("common_copy_close_button"),false);
    self.closeButton:addEventListener(Events.kStart,self.onCloseButtonTap,self);
    self.fightButton = Button.new(self.armature:findChildArmature("fightbutton"),false);
    self.fightButton:addEventListener(Events.kStart,self.onFightButtonTap,self);
end

function TenCountryBossLayer:refreshBossData(placeId)
    local zhengzhanPO = analysis("Shili_Shiguozhengzhan",placeId);

    local bossImageP = self.armature_d:getChildByName("imagep"):getPosition()
    local imageBg = getImageByArtId(tonumber(zhengzhanPO.bossart));
    imageBg:setPosition(bossImageP)
    imageBg:setAnchorPoint(CCPointMake(0.5,0));
    self:addChildAt(imageBg,1)

    local namep = self.armature_d:getChildByName("namep"):getPosition()
    local nameBg = getImageByArtId(tonumber(zhengzhanPO.nameart));
    nameBg:setPosition(namep)
    nameBg:setAnchorPoint(CCPointMake(0.5,0));
    -- nameBg:setScale(2)
    self:addChild(nameBg)

    -- local text_data = self.armature:getBone("level_text").textData;
    -- self.levelText = createTextFieldWithTextData(text_data,"Lv."..self.popUp.tenCountryProxy.bossLevel);
    -- self:addChild(self.levelText);

    --local battleTable = analysisMonsterConfigs(zhengzhanPO.battlefield,19)--self.popUp.tenCountryProxy.battleModId
    --local totalNum = table.getn(battleTable);

    local text_data = self.armature:getBone("gk5x_text").textData;
    self.gk5xText = createTextFieldWithTextData(text_data,"关卡五行：");
    self:addChild(self.gk5xText);

    local text_data = self.armature:getBone("desl_text").textData;
    self.deslText = createTextFieldWithTextData(text_data,"知己知彼：");
    self:addChild(self.deslText);

    local text_data = self.armature:getBone("tj5x_text").textData;
    self.tj5xText = createTextFieldWithTextData(text_data,"推荐五行：");
    self:addChild(self.tj5xText);

    local text_data = self.armature:getBone("tj5xnum_text").textData;
    self.tj5xNumText = createTextFieldWithTextData(text_data,"");
    self:addChild(self.tj5xNumText);

    local text_data = self.armature:getBone("desr_text").textData;
    self.desrText = createTextFieldWithTextData(text_data,zhengzhanPO.txt);
    self:addChild(self.desrText);
    local bossType = self.popUp.tenCountryProxy.bossType
    self.tuBiao = CommonSkeleton:getBoneTextureDisplay("commonImages/common_shuxing_"..bossType);
    local propertyP = self.armature_d:getChildByName("propertyp"):getPosition()
    self.tuBiao:setPosition(propertyP)
    self.tuBiao:setScale(0.45)
    self:addChild(self.tuBiao)


    local WuxingPO = analysisTotalTable("Shuxing_Wuxing");
    local kezhiID
    for key,value in pairs(WuxingPO) do
        if tonumber(value.keZhi) == bossType then
            kezhiID = value.ID
            break
        end
    end
    if not kezhiID then
        self.tuBiao2 = CommonSkeleton:getBoneTextureDisplay("commonImages/common_shuxing_"..bossType);
    else
        self.tuBiao2 = CommonSkeleton:getBoneTextureDisplay("commonImages/common_shuxing_"..kezhiID);
    end
    if bossType == 1 then
        self.tj5xNumText:setString("任意五行")
    else
        local property2P = self.armature_d:getChildByName("property2p"):getPosition()
        self.tuBiao2:setPosition(property2P)
        self.tuBiao2:setScale(0.45)
        self:addChild(self.tuBiao2)
    end
    self:refreshCheckpoint(placeId)
end

function TenCountryBossLayer:refreshCheckpoint(tempString)
    local guanumP = self.armature_d:getChildByName("guanumP"):getPosition()
    for k,v in pairs(self.timerTextArray) do
         self:removeChild(v);
    end
    if tempString >= 10 then
        for i=1,2 do
            local str = string.sub(tempString, i, i);
            local numberText = self.popUp.skeleton:getBoneTextureDisplay("n"..str);
            numberText:setPositionXY(guanumP.x + 30*(i-2),guanumP.y)
            self:addChild(numberText);
            table.insert(self.timerTextArray,numberText);
        end
    else
        local numberText = self.popUp.skeleton:getBoneTextureDisplay("n"..tempString);
        numberText:setPosition(guanumP)
        self:addChild(numberText);
        table.insert(self.timerTextArray,timerNum);
    end
end

function TenCountryBossLayer:onCloseButtonTap()

    --local function callBackFun()
        self.popUp:disposeBossViewLayer()
        setFactionCurrencyVisible(true)
    --end
    --local callBack = CCCallFunc:create(callBackFun);
    --self:runAction(CCSequence:createWithTwoActions(CCEaseSineOut:create(CCScaleTo:create(0.2,0,1)), callBack));
end

function TenCountryBossLayer:onFightButtonTap()
    self.popUp:dispatchEvent(Event.new("to_TenCountry_Team",{context = self, onEnter = self.onFightTap,funcType = "TenCountry",ZhanChangWuXing = self.popUp.tenCountryProxy.bossType},self));
end

function TenCountryBossLayer:onFightTap()

  sendMessage(19,6)
end

