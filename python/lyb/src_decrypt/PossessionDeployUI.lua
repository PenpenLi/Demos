--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

PossessionDeployUI=class(TouchLayer);

function PossessionDeployUI:ctor()
  self.class=PossessionDeployUI;
end

function PossessionDeployUI:dispose()
  self.parent_container.deployUI=nil;
  self:removeAllEventListeners();
  self:removeChildren();
	PossessionDeployUI.superclass.dispose(self);
  self.armature4dispose:dispose();
  BitmapCacher:removeUnused();
end

--
function PossessionDeployUI:initializeUI(skeleton, parent_container, mapID, isViewOnly)
  self:initLayer();
  self.skeleton=skeleton;
  self.parent_container=parent_container;
  self.possessionBattleProxy=self.parent_container.possessionBattleProxy;
  self.mapID=mapID;
  self.isViewOnly=isViewOnly;
  self.const_max_deploy_num=10;
  self.deployCount=0;
  self.items={};

  self:addChild(LayerColorBackGround:getBackGround());
  --骨骼
  local armature=skeleton:buildArmature("deploy_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  local button=Button.new(armature:findChildArmature("common_copy_close_button"),false);
  button:addEventListener(Events.kStart,self.onCloseButtonTap,self);

  local text="部署剩余时间:";
  local text_data=armature:getBone("time").textData;
  self.time=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.time);

  text="";
  text_data=armature:getBone("time_descb").textData;
  self.time_descb=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.time_descb);

  text="可部署总人数:";
  text_data=armature:getBone("count").textData;
  self.count=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.count);

  text=self.const_max_deploy_num;
  text_data=armature:getBone("count_descb").textData;
  self.count_descb=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.count_descb);

  text="开战前可以免费部署1次哟";
  text_data=armature:getBone("deploy_descb_1").textData;
  self.deploy_descb_1=createTextFieldWithTextData(text_data,text);
  self.deploy_descb_1:setVisible(self.isViewOnly);
  self.armature:addChild(self.deploy_descb_1);
  
  text="开战前可以免费部署1次哟";
  text_data=armature:getBone("deploy_descb").textData;
  self.deploy_descb=createTextFieldWithTextData(text_data,text);
  self.deploy_descb:setVisible(not self.isViewOnly);
  self.armature:addChild(self.deploy_descb);

  self.deploy_button=Button.new(armature:findChildArmature("common_copy_bluelonground_button"),false);
  self.deploy_button.bone:initTextFieldWithString("common_copy_bluelonground_button","完成部署");
  self.deploy_button:getDisplay():setVisible(not self.isViewOnly);
  self.deploy_button:addEventListener(Events.kStart,self.onDeployButtonTap,self);

  local a=0;
  while 15>a do
    a=1+a;
    local item=PossessionDeployItem.new();
    item:initializeUI(self.skeleton,self.parent_container,self,armature,a);
    table.insert(self.items,item);
  end
  self.parent_container:dispatchEvent(Event.new(PossessionBattleNotifications.POSSESSION_BATTLE_REQUEST_DEPLOY_DATA,{MapId=self.mapID},self));
end

--移除
function PossessionDeployUI:onCloseButtonTap(event)
  self.parent_container:removeChild(self);
end

function PossessionDeployUI:onDeployButtonTap(event)
  local data={};
  local a=false;
  local b=false;
  local c=false;
  for k,v in pairs(self.data) do
    if 0~=v.ID then
      if 1<=v.ID and 5>=v.ID then a=true; end
      if 6<=v.ID and 10>=v.ID then b=true; end
      if 11<=v.ID and 15>=v.ID then c=true; end
      table.insert(data,v);
    end 
  end
  if not a or not b or not c then
    sharedTextAnimateReward():animateStartByString("每个队伍都要有部署哦~");
    return;
  end
  if self.parent_container.signInUI and self.parent_container.signInUI.toDeployBySignIn then
    self.parent_container.signInUI.toDeployBySignIn=nil;
    self.parent_container.signInUI.toSignInByDeploy=true;
  end
  sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_257));
  self.parent_container:dispatchEvent(Event.new(PossessionBattleNotifications.POSSESSION_BATTLE_DEPLOY_CONFIRM,{ArmyTeamArray=data},self));
  self:onCloseButtonTap(event);
end

function PossessionDeployUI:refreshDeploy(data)
  if self.data then
    return;
  end
  self.data={};
  self.deployCount=data.Count;
  for k,v in pairs(data.ArmyTeamArray) do
    if self.mapID==v.MapId or (0==v.MapId and 0==v.ID) then
      table.insert(self.data,v);
    end
  end
  self:refreshItems();
  self:refreshIsViewOnly();
end

function PossessionDeployUI:refreshItems()
  local zhanli_zong=0;
  for k,v in pairs(self.items) do
    v:refreshData(self:getItemData(v.id));
    if v.data then
      zhanli_zong=v.data.Zhanli+zhanli_zong;
    end
  end
  if self.effectFigure then
    self.armature:removeChild(self.effectFigure);
    self.effectFigure=nil;
  end
  self.effectFigure=EffectFigure.new();
  self.effectFigure:initialize(self.parent_container.effectProxy,2,zhanli_zong,nil,nil,false,true);
  self.effectFigure:setPositionXY(150,419);
  self.effectFigure:setScale(0.6);
  self.effectFigure:start();
  self.armature:addChild(self.effectFigure);
end

function PossessionDeployUI:refreshIsViewOnly()
  local isViewOnly;
  if self.isViewOnly then
    isViewOnly=self.isViewOnly;
  elseif self.data and 0>=self.deployCount then
    isViewOnly=true;
  end
  if isViewOnly then
    self.deploy_descb_1:setVisible(isViewOnly);
    self.deploy_descb:setVisible(not isViewOnly);
    self.deploy_button:getDisplay():setVisible(not isViewOnly);
    for k,v in pairs(self.items) do
      v:refreshIsViewOnly(isViewOnly);
    end
  end
end

function PossessionDeployUI:getItemData(id)
  for k,v in pairs(self.data) do
    if id==v.ID then
      return v;
    end
  end
end

function PossessionDeployUI:setTimeString(s)
  if self.isViewOnly then
    self.time_descb:setString("无");
    return;
  end
  self.time_descb:setString(s);
end

function PossessionDeployUI:getDeployable()
  local a=0;
  for k,v in pairs(self.data) do
    if 0~=v.MapId and 0~=ID then
      a=1+a;
    end
  end
  return self.const_max_deploy_num>a;
end