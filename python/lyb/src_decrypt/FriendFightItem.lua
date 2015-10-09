FriendFightItem = class(Layer);

function FriendFightItem:ctor()
  self.class = FriendFightItem;
end

function FriendFightItem:dispose()
    self:removeAllEventListeners();
    self:removeChildren(false);
    FriendFightItem.superclass.dispose(self);
    self.friendFightLayer = nil
end

function FriendFightItem:onInitUI(employVO,isMyFriend,friendFightLayer)
    self.friendFightLayer = friendFightLayer
	local name = isMyFriend and "friendDownItem_ui" or "friendUpItem_ui"
	local armature=friendFightLayer.skeleton:buildArmature(name);
    self.armature = armature;
    armature.animation:gotoAndPlay("f1");
    armature:updateBonesZ();
    armature:update();

    local armature_d=armature.display;
    self:addChild(armature_d);
    self.armature_d = armature_d;
    
    local text_data = self.armature:getBone("name_num_text").textData;
    self.nameText = createTextFieldWithTextData(text_data,employVO.UserName);
    self:addChild(self.nameText);

    local text_data = self.armature:getBone("zhanli_num_text").textData;
    self.zhanliText = createTextFieldWithTextData(text_data,"战力 : "..employVO.Zhanli);
    self:addChild(self.zhanliText);

    local text_data = self.armature:getBone("youqing_num_text").textData;
    local youqing = isMyFriend and 5 or 10
    self.youqingText = createTextFieldWithTextData(text_data,"友情点+"..youqing);
    self:addChild(self.youqingText);

    local text_data = self.armature:getBone("level_num_text").textData;
    self.levelText = createTextFieldWithTextData(text_data,employVO.Level,true);
    self:addChild(self.levelText);

    local grade = CommonSkeleton:getBoneTextureDisplay("commonImages/common_round_grid_"..employVO.Grade);
    if not grade then
        grade = CommonSkeleton:getBoneTextureDisplay("commonImages/common_round_grid_2");
    end
    grade:setPositionXY(15,15)
    self.armature_d:addChildAt(grade,2)

    local artId = analysis("Kapai_Kapaiku", employVO.ConfigId, "art");
    local mask = CommonSkeleton:getBoneTextureDisplay("commonImages/common_round_grid_6")
    local clippingImage = self:getClippingImage(artId,mask)
    clippingImage:setPositionXY(18,15)
    grade:addChild(clippingImage)

    self:addEventListener(DisplayEvents.kTouchTap,self.itemTap,self,employVO);
end

function FriendFightItem:itemTap(event,employVO)
    sendMessage(7,39,{UserId = employVO.UserId,GeneralId = employVO.GeneralId})
    self.friendFightLayer:interBattle()
end

function FriendFightItem:getClippingImage(artId,mask)
    local clipper = ClippingNodeMask.new(mask);
    clipper:setAlphaThreshold(0.0);
    local image = getImageByArtId(artId)
    image:setScale(0.8)
    clipper:addChild(image);
    clipper:setScale(0.65)
    return clipper
end
