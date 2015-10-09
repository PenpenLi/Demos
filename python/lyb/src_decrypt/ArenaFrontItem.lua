
ArenaFrontItem=class(Layer);

function ArenaFrontItem:ctor()
    self.class=ArenaFrontItem;
end

function ArenaFrontItem:dispose()
    self:removeAllEventListeners();
    self:removeChildren();
    ArenaFrontItem.superclass.dispose(self);
    self.arenaLayer = nil
end

function ArenaFrontItem:initializeItem(arenaLayer,skeleton,place)
    self:initLayer();
    self:initializeUI(skeleton)
    self.arenaLayer = arenaLayer
    self.place = place
end

function ArenaFrontItem:initializeUI(skeleton)
    local armature=skeleton:buildArmature("item_ui");
    self.armature = armature;
    armature.animation:gotoAndPlay("f1");
    armature:updateBonesZ();
    armature:update();
    
    local armature_d=armature.display;
    self:addChild(armature_d);
    self.armature_d = armature_d;
    
    self.siteP = armature_d:getChildByName("siteP"):getPosition()
    -- local moveTo = CCEaseSineInOut:create(CCFadeTo:create(1, 132))
    -- local moveBack = CCEaseSineInOut:create(CCFadeTo:create(1, 255))
    -- self.guangbg:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(moveTo, moveBack)))

    local text_data = self.armature:getBone("name_num_text").textData;
    self.nameNumText = createTextFieldWithTextData(text_data,"");
    self:addChild(self.nameNumText);
    self.nameNumText.touchEnabled = false;

    -- local text_data = self.armature:getBone("ming_text").textData;
    -- self.mingText = createTextFieldWithTextData(text_data,"排名 :");
    -- self:addChild(self.mingText);
    -- self.mingText.touchEnabled = false;

    -- local text_data = self.armature:getBone("zl_text").textData;
    -- self.zlText = createTextFieldWithTextData(text_data,"战力 :");
    -- self:addChild(self.zlText);
    -- self.zlText.touchEnabled = false;

    local text_data = self.armature:getBone("ming_num_text").textData;
    self.mingNumText = createTextFieldWithTextData(text_data,"");
    self:addChild(self.mingNumText);
    self.mingNumText.touchEnabled = false;

    -- local text_data = self.armature:getBone("level_num_text").textData;
    -- self.levelNumText = createTextFieldWithTextData(text_data,"");
    -- self:addChild(self.levelNumText);
    -- self.levelNumText.touchEnabled = false;

    local text_data = self.armature:getBone("zl_num_text").textData;
    self.zlNumText = createTextFieldWithTextData(text_data,"");
    self:addChild(self.zlNumText);
    self.zlNumText.touchEnabled = false;

    self.tzButton=Button.new(self.armature:findChildArmature("common_copy_small_orange_button"),false);
    self.tzButton:addEventListener(Events.kStart,self.ontiaozhanTap,self);
    self.tzButton.bone:initTextFieldWithString("common_small_orange_button","挑战");

    -- self:setContentSize(CCSizeMake(295,393))
    -- self:setAnchorPoint(CCPointMake(0.5, 0))
    local size = self:getGroupBounds().size
    self:changeAnchorPoint(size.width/2,size.height/2)
    armature_d:getChildByName("guangbg"):addEventListener(DisplayEvents.kTouchTap, self.onClickFrontTap, self);
end

function ArenaFrontItem:onClickFrontTap()
    self.arenaLayer:onClickFrontTap(self.place,self.userVO.UserId)
end

function ArenaFrontItem:refreshItemData(userVO)
    self.userVO = userVO
    self:removeItemData()
    self:compositeRole(userVO.Career)
    self.nameNumText:setString("Lv."..userVO.Level..userVO.UserName)
    self.mingNumText:setString("排名 : "..userVO.Ranking)
    self.zlNumText:setString("战力 : "..userVO.Zhanli)
    -- self.levelNumText:setString("Lv."..userVO.Level)
    --self:refreshHeadImage(userVO)
end

-- function ArenaFrontItem:refreshHeadImage(userVO)
--     for i=1,3 do
--         -- local generalVO = userVO.GeneralIdTableArray[i]
--         -- if generalVO and generalVO.ConfigId ~= 0 then
--         --     local artId = analysis("Kapai_Kapaiku", generalVO.ConfigId, "art");
--         --     local mask = self.parent.popUp.skeleton:getBoneTextureDisplay("bighong")
--         --     local clippingImage = self:getClippingImage(artId,mask)
--         --     clippingImage:setPositionXY(17,17)
--         --     self.armature_d:getChildByName("headIcon"..i):addChild(clippingImage)
--         -- end
--         -- self.armature_d:getChildByName("headIcon"..i):setScale(0.8)
--     end
-- end

-- function ArenaFrontItem:getClippingImage(artId,mask)
--     -- local clipper = ClippingNodeMask.new(mask);
--     -- clipper:setAlphaThreshold(0.0);
--     -- local image = getImageByArtId(artId)
--     -- image:setScale(0.8)
--     -- clipper:addChild(image);
--     -- clipper:setScale(0.55)
--     -- return clipper
-- end

--Career,UserId,UserName,Level,Ranking,Zhanli,GeneralIdTableArray
function ArenaFrontItem:compositeRole(career)
    local po = analysis("Zhujiao_Zhujiaozhiye",career);
    
    local key = "key_"..po.shenti.."_"..BattleConfig.HOLD;
    local url = plistData[key]["source"];
    BitmapCacher:animationCache(url);
    
    local compositeArr = {
          [1] = {["type"] = BattleConfig.TRANSFORM_BODY, ["sourceName"] = po.shenti .. "_" .. BattleConfig.HOLD}
            };

    local roleComposite = CompositeActionAllPart.new();
    roleComposite:initLayer();
    roleComposite:transformPartCompose(compositeArr);
    roleComposite:setPositionXY(self.siteP.x+15,self.siteP.y);
    self:addChild(roleComposite);
    self.roleComposite = roleComposite
    self.roleComposite.touchEnabled = false;
    self.roleComposite.touchChildren = false;
end

function ArenaFrontItem:ontiaozhanTap(event)
    -- if self.userVO.Ranking >= self.parent.myRanking then
    --     sharedTextAnimateReward():animateStartByString("不能挑战比自己级别低的玩家！");
    --     return
    -- end
    local cdTimeListener = self.arenaLayer.cdTimeListener
    if cdTimeListener then
        sharedTextAnimateReward():animateStartByString("挑战冷却中！");
        return 
    end
    local string = self.parent.popUp.countProxy:getRemainCountByID(CountControlConfig.ARENA_COUNT,CountControlConfig.Parameter_1)
    if string <= 0 then
        sharedTextAnimateReward():animateStartByString("亲~没有次数了哦！");
        return 
    end
    self.parent.popUp:dispatchEvent(Event.new("to_Attack_Team",{context = self, onEnter = self.enterBattle,funcType = "ArenaAttack",ZhanChangWuXing = nil},self));
end

function ArenaFrontItem:enterBattle()
    sendMessage(16,2,{UserId=self.userVO.UserId,Ranking=self.userVO.Ranking})
end

function ArenaFrontItem:removeItemData()
    self:removeChild(self.roleComposite)
    self.roleComposite = nil
end