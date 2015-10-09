--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

PossessionDeployItem=class(TouchLayer);

function PossessionDeployItem:ctor()
  self.class=PossessionDeployItem;
end

function PossessionDeployItem:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	PossessionDeployItem.superclass.dispose(self);
end

--
function PossessionDeployItem:initializeUI(skeleton, parent_container, deploy, armature ,id)
  self:initLayer();
  self.skeleton=skeleton;
  self.parent_container=parent_container;
  self.deploy=deploy;
  armature=armature:findChildArmature("deploy_item_" .. id);
  self.possessionBattleProxy=self.parent_container.possessionBattleProxy;
  self.userProxy=self.parent_container.userProxy;
  self.id=id;

  self.armature=self.deploy.armature:getChildByName("deploy_item_" .. id);
  self.armature:addEventListener(DisplayEvents.kTouchBegin,self.onButtonTap,self);

  local text="";
  local text_data=armature:getBone("name_descb").textData;
  self.name_descb=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.name_descb);

  text="";
  text_data=armature:getBone("level_descb").textData;
  self.level_descb=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.level_descb);

  self.deploy_button=Button.new(armature:findChildArmature("deploy_button"),false);
  self.deploy_button:getDisplay().touchEnabled=false;
  self.deploy_button:getDisplay().touchChildren=false;
  self.deploy_button:getDisplay():setVisible(false);
  self.deploy_button:addEventListener(Events.kStart,self.onButtonTap,self,1);
  self.replace_button=Button.new(armature:findChildArmature("replace_button"),false);
  self.replace_button:getDisplay().touchEnabled=false;
  self.replace_button:getDisplay().touchChildren=false;
  self.replace_button:getDisplay():setVisible(false);
  self.replace_button:addEventListener(Events.kStart,self.onButtonTap,self,2);
end

function PossessionDeployItem:onButtonTap(event)
  if self.deploy_button:getDisplay():isVisible() and not self.deploy:getDeployable() then
    sharedTextAnimateReward():animateStartByString("超过部署上限了哦~");
    return;
  end
  self.parent_container:addMemberUI(self.deploy.mapID,self.id,self.deploy.data);
end

function PossessionDeployItem:refreshData(data)
  self.data=data;
  if nil==self.data then
    self.name_descb:setString("");
    self.level_descb:setString("");
  else
    self.name_descb:setString(1+(-1+self.data.ID)%5 .. "  " .. self.data.UserName);
    self.level_descb:setString("Lv" .. self.data.Level);
  end
  self.deploy_button:getDisplay():setVisible(not self.deploy.isViewOnly and self.userProxy:getIsFamilyLeader() and (not self.data or self.data and 0==self.data.UserId));
  self.replace_button:getDisplay():setVisible(not self.deploy.isViewOnly and self.userProxy:getIsFamilyLeader() and self.data and 0~=self.data.UserId);
end

function PossessionDeployItem:refreshIsViewOnly(isViewOnly)
  self.deploy_button:getDisplay():setVisible(not isViewOnly);
  self.replace_button:getDisplay():setVisible(not isViewOnly);
  if isViewOnly then
    self.armature:removeEventListener(DisplayEvents.kTouchBegin,self.onButtonTap,self);
  end
end