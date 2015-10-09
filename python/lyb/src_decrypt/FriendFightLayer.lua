
FriendFightLayer = class(Layer);

function FriendFightLayer:ctor()
  self.class = FriendFightLayer;
end

function FriendFightLayer:dispose()
    self:removeAllEventListeners();
    self:removeChildren(false);
    FriendFightLayer.superclass.dispose(self);
    self.backLayer = nil
end

function FriendFightLayer:onInitUI(buddyListProxy,backLayer)
    sendMessage(7,38)
    self.backLayer = backLayer
    self.buddyListProxy = buddyListProxy
	self.skeleton = getSkeletonByName("friendFight_ui");
	local armature=self.skeleton:buildArmature("friendFight_ui");
    self.armature = armature;
    armature.animation:gotoAndPlay("f1");
    armature:updateBonesZ();
    armature:update();

    local layerColor = LayerColorBackGround:getBackGround()
    self:addChild(layerColor);

    local armature_d=armature.display;
    self:addChild(armature_d);
    self.armature_d = armature_d;

    local titleText = BitmapTextField.new("选择好友助战","anniutuzi");--选择好友助战
    titleText:setPositionXY(545,609)
    self:addChild(titleText)

    self.closeButton=Button.new(self.armature:findChildArmature("common_copy_close_button"),false);
    self.closeButton:addEventListener(Events.kStart,self.onCloseTap,self);

    local text_data = self.armature:getBone("youqing_num_text").textData;
    self.youqingText = createTextFieldWithTextData(text_data,"选择好友助战可以获得友情点");
    self:addChild(self.youqingText);
end

function FriendFightLayer:refreshEmployArrayData(battleEmployArray)
    require "main.view.battleScene.friendFight.FriendFightItem"
    local upNum = 1;local downNum = 1
    for key,employVO in pairs(battleEmployArray) do
        local friendFightItem = FriendFightItem.new()
        friendFightItem:initLayer()
        self:addChild(friendFightItem)
        if self.buddyListProxy:getBuddyDataByUserID(employVO.UserId) then
            friendFightItem:onInitUI(employVO,"true",self)
            friendFightItem:setPositionXY(300 + (downNum%2)*350,280-(math.floor(downNum/3))*145)
            downNum = downNum + 1
        else
            friendFightItem:onInitUI(employVO,"false",self)
            friendFightItem:setPositionXY(300 + (upNum-1)*350,445)
            upNum = upNum + 1
        end
    end
end

function FriendFightLayer:interBattle()
    self.backLayer:interBattle()
    self.backLayer:closeFriendLayer()
end

function FriendFightLayer:onCloseTap(event)
    self.backLayer:closeFriendLayer()
end

