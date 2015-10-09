
AddFriendLayer = class(Layer);

function AddFriendLayer:ctor()
  self.class = AddFriendLayer;
end

function AddFriendLayer:dispose()
    self:removeAllEventListeners();
    self:removeChildren(false);
    AddFriendLayer.superclass.dispose(self);
end

function AddFriendLayer:onInitUI(battleProxy)
    self.employVO  = battleProxy.employVO
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

    self.closeButton=Button.new(self.armature:findChildArmature("common_copy_close_button"),false);
    self.closeButton:addEventListener(Events.kStart,self.onCloseTap,self);

    local text_data = self.armature:getBone("name_text").textData;
    self.nameText = createTextFieldWithTextData(text_data,"要不要将                     加为好友呀~有厉害的伙伴路途才长远~");
    self:addChild(self.nameText);

        local text_data = self.armature:getBone("name_value_text").textData;
    self.nameText = createTextFieldWithTextData(text_data,self.employVO.name);
    self:addChild(self.nameText);

    self.addButton=Button.new(self.armature:findChildArmature("common_copy_blue_button"),false);
    self.addButton:addEventListener(Events.kStart,self.onAddTap,self);
    self.addButton.bone:initTextFieldWithString("common_copy_blue_button","加为好友");
end

function AddFriendLayer:onAddTap(event)
    sendMessage(7,39,{UserId = self.employVO.UserId,GeneralId = self.employVO.GeneralId})
end

function AddFriendLayer:refreshEmployArrayData(battleEmployArray)
    require "main.view.battleScene.friendFight.FriendFightItem"
    local upNum = 1;local downNum = 1
    for key,employVO in pairs(battleEmployArray) do
        local friendFightItem = FriendFightItem.new()
        if self.buddyListProxy:getBuddyDataByUserID(employVO.UserId) then
            friendFightItem:onInitUI(employVO,"true")
            friendFightItem;setPositionXY(100 + (upNum%2)*150,(upNum%2)*200)
            self:addChild(friendFightItem)
            upNum = upNum + 1
        else
            friendFightItem:onInitUI(employVO,"false")
            friendFightItem;setPositionXY(100 + upNum*150,400)
            self:addChild(friendFightItem)
            upNum = upNum + 1
        end
    end
end

function AddFriendLayer:onCloseTap(event)
    self.parent:removeChild(self)
end

