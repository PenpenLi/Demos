--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

require "core.utils.LayerColorBackGround";

ServerMergeAvatarItem=class(TouchLayer);

function ServerMergeAvatarItem:ctor()
  self.class=ServerMergeAvatarItem;
end

function ServerMergeAvatarItem:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	ServerMergeAvatarItem.superclass.dispose(self);
  
  self.armature4dispose:dispose();
end

--
function ServerMergeAvatarItem:initialize(serverMergeProxy, bagProxy, data, context, onConfirm)
  self:initLayer();
  self.skeleton=serverMergeProxy:getSkeleton();
  self.serverMergeProxy=serverMergeProxy;
  self.bagProxy=bagProxy;
  self.data=data;
  self.context=context;
  self.onConfirm=onConfirm;
  
  --骨骼
  local armature=self.skeleton:buildArmature("avatar_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  local text='<content><font color="#FFD800">角色名称   </font><font color="#00FF00">' .. self:getNameS(self.data.UserName) .. '</font></content>';
  local text_data=armature:getBone("name_descb").textData;
  self.name_descb=createAutosizeMultiColoredLabelWithTextData(text_data,text);
  self.armature:addChild(self.name_descb);

  text='<content><font color="#FFD800">角色等级   </font><font color="#00FF00">' .. self.data.Level .. '级</font></content>';
  text_data=armature:getBone("level_descb").textData;
  self.level_descb=createAutosizeMultiColoredLabelWithTextData(text_data,text);
  self.armature:addChild(self.level_descb);

  self.common_copy_blueround_button=Button.new(armature:findChildArmature("common_copy_blueround_button"),false);
  self.common_copy_blueround_button.bone:initTextFieldWithString("common_copy_blueround_button","进入");
  self.common_copy_blueround_button:addEventListener(Events.kStart,self.onTap,self);
  if not self.context then
    self.common_copy_blueround_button:getDisplay():setVisible(false);
  end

  local pos=self.armature:getChildByName("pos"):getPosition();
  self.image=CompositeActionAllPart.new();
  self.image:initLayer();
  self.image:transformPartCompose(self.bagProxy:getCompositeRoleTable(self.data.Career));
  self.image:changeFaceDirect(false);
  self.image:setPosition(pos);
  self:addChild(self.image);
end

function ServerMergeAvatarItem:onTap(event)
  self.onConfirm(self.context,self);
end

function ServerMergeAvatarItem:getNameS(userName)
  return userName;
end