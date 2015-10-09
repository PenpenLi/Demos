require "main.model.UserProxy"
FamilyBanquetHeadItem=class(Layer);

function FamilyBanquetHeadItem:ctor()
    self.class=FamilyBanquetHeadItem;

end

function FamilyBanquetHeadItem:dispose()
    self:removeAllEventListeners();
    self:removeChildren();
    FamilyBanquetHeadItem.superclass.dispose(self);
    
end

function FamilyBanquetHeadItem:initializeUI(skeleton, personData, index, holdUserID, selfUserID, banquetID, familyBanquetPopup, userProxy)
    self.familyBanquetPopup = familyBanquetPopup;
    self.UserId = selfUserID;
    self.banquetID = banquetID;
    local armature=skeleton:buildArmature("headItem");
    self.armature = armature;
    armature.animation:gotoAndPlay("f1");
    armature:updateBonesZ();
    armature:update();
    
    local armature_d=armature.display;

    local head_image = armature_d:getChildByName("head_image");
    local upgradeBtn = armature_d:getChildByName("upgradeBtn");
 
    --如果参加的酒宴，则显示头像等，不显示邀请按钮
    if personData.UserId then

        local userName_txt_data = armature:getBone("userName_txt").textData;
        local userLv_txt_data = armature:getBone("userLv_txt").textData;
        
        local userName_txt = createTextFieldWithTextData(userName_txt_data,personData.UserName, true);
        armature_d:addChild(userName_txt);
        local userLv_txt = createTextFieldWithTextData(userLv_txt_data,personData.Level, true);
        armature_d:addChild(userLv_txt);

        local headArtId = analysis("Zhujiao_Huanhua",personData.Career,"head")
        self.imageBg = Image.new();
        self.imageBg:loadByArtID(headArtId);
        self.imageBg:setAnchorPoint(ccp(0.5, 0.5))
        self.imageBg:setPositionXY(head_image:getContentSize().width/2,head_image:getContentSize().height/2)
        head_image:addChild(self.imageBg);
        armature_d:removeChild(upgradeBtn);
        
    else 

        if self.UserId == holdUserID then 
            local userLv_txt = armature_d:getChildByName("userLv_txt");
            local userName_txt = armature_d:getChildByName("userName_txt");
            local name_bg = armature_d:getChildByName("name_bg");
            local head_lv_bg = armature_d:getChildByName("head_lv_bg");
            armature_d:removeChild(userLv_txt);
            armature_d:removeChild(userName_txt);
            armature_d:removeChild(name_bg);
            armature_d:removeChild(head_lv_bg);

            SingleButton:create(upgradeBtn);
            upgradeBtn:addEventListener(DisplayEvents.kTouchTap, self.inviteBtnTouch, self);

            local userName_txt_data = armature:getBone("userName_txt").textData;
            self.inviteButton = BitmapTextField.new("邀请","anniutuzi");
            self.inviteButton.touchEnabled = true;
            self.inviteButton:setAnchorPoint(ccp(0.5, 0))
            self.inviteButton:setPosition(ccp(userName_txt_data.x + userName_txt_data.width/2, userName_txt_data.y));

            self.inviteButton:addEventListener(DisplayEvents.kTouchBegin,self.inviteBtnTouchBegin,self);
            self.inviteButton:addEventListener(DisplayEvents.kTouchEnd,self.inviteBtnTouchEnd,self);

            armature_d:addChild(self.inviteButton);
        else

            local userLv_txt = armature_d:getChildByName("userLv_txt");
            local userName_txt = armature_d:getChildByName("userName_txt");
            local name_bg = armature_d:getChildByName("name_bg");
            local head_lv_bg = armature_d:getChildByName("head_lv_bg");

            armature_d:removeChild(userLv_txt);
            armature_d:removeChild(userName_txt);
            armature_d:removeChild(name_bg);
            armature_d:removeChild(head_lv_bg);
            
            SingleButton:create(upgradeBtn);
            upgradeBtn:addEventListener(DisplayEvents.kTouchTap, self.joinBtnTouch, self);

            local userName_txt_data = armature:getBone("userName_txt").textData;
            self.joinButton = BitmapTextField.new("入宴","anniutuzi");
            self.joinButton.touchEnabled = true;
            self.joinButton.sprite:setAnchorPoint(ccp(0.5, 0))
            local bm_size = self.joinButton:getContentSize();
            self.joinButton:setPosition(ccp(userName_txt_data.x + userName_txt_data.width/2 , userName_txt_data.y));
            self.joinButton:addEventListener(DisplayEvents.kTouchBegin,self.joinBtnTouchBegin,self);
            
            armature_d:addChild(self.joinButton);
        end

    end
    return armature_d;
end

function FamilyBanquetHeadItem:joinBtnTouch()
    
    if #self.familyBanquetPopup.familyProxy.BanquetInfoArray < 1 then
        return;
    end
    for i,v in ipairs(self.familyBanquetPopup.familyProxy.userIdNameArray) do
        print(v.UserId, self.UserId)
        if v.UserId == self.UserId then
            sharedTextAnimateReward():animateStartByString("您已在酒宴中了哦~");
            return;
        end
    end
    
    local id = self.familyBanquetPopup.familyProxy.inBanquetId;
    if id then
        for i,v in ipairs(self.familyBanquetPopup.familyProxy.BanquetInfoArray) do
            
            if v.ID == id then
                sharedTextAnimateReward():animateStartByString("已经参加了另一场酒宴哦~");
            end
        end
    end
        sendMessage(27, 33, {ID = self.banquetID});
end

function FamilyBanquetHeadItem:joinBtnTouchBegin(event)
    self.joinButton:addEventListener(DisplayEvents.kTouchEnd,self.joinBtnTouchEnd,self);
    self.joinButton:setScale(0.9)

    if #self.familyBanquetPopup.familyProxy.BanquetInfoArray < 1 then
        return;
    end
    
    for i,v in ipairs(self.familyBanquetPopup.familyProxy.userIdNameArray) do
        print(v.UserId, self.UserId)
        if v.UserId == self.UserId then
            sharedTextAnimateReward():animateStartByString("您已在酒宴中了哦~");
            return;
        end
    end
    
    local id = self.familyBanquetPopup.familyProxy.inBanquetId;
    if id then
        for i,v in ipairs(self.familyBanquetPopup.familyProxy.BanquetInfoArray) do
            
            if v.ID == id then
                sharedTextAnimateReward():animateStartByString("已经参加了另一场酒宴哦~");
            end
        end
    end

    sendMessage(27, 33, {ID = self.banquetID});
    hecDC(3, 25, 3, {id  = self.banquetID});
end

function FamilyBanquetHeadItem:joinBtnTouchEnd(event)
    self.joinButton:setScale(1)
end
 


function FamilyBanquetHeadItem:inviteBtnTouchBegin(event)
    self.inviteButton:setScale(0.9)
end

function FamilyBanquetHeadItem:inviteBtnTouchEnd(event)
    self.inviteButton:setScale(1)
    self:inviteBtnTouch();
end

function FamilyBanquetHeadItem:inviteBtnTouch()
    sharedTextAnimateReward():animateStartByString("已经向小伙伴们发送邀请啦~");
    sendMessage(27, 37, {ID = self.banquetID})
end


