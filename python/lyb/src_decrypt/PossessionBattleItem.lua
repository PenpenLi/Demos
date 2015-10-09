--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

PossessionBattleItem=class(TouchLayer);

function PossessionBattleItem:ctor()
  self.class=PossessionBattleItem;
end

function PossessionBattleItem:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	PossessionBattleItem.superclass.dispose(self);
  self.armature4dispose:dispose();
  BitmapCacher:removeUnused();
end

--
function PossessionBattleItem:initializeUI(skeleton, parent_container, battle_ui, mapID)
  self:initLayer();
  self.skeleton=skeleton;
  self.parent_container=parent_container;
  self.possessionBattleProxy=self.parent_container.possessionBattleProxy;
  self.userProxy=self.parent_container.userProxy;
  self.battle_ui=battle_ui;
  self.mapID=mapID;
  self.const_color=3997440;
  self.const_color_0=6710886;
  self.const_color_1=15056741;
  self.const_line_num=26;
  self.const_color_4_border_self=26367;
  self.text_frames={};
  self.texts={};
  self.buttons={};
  self.tracks={};
  self.ing_imgs={};
  self.track_ids={{{1,2},{3,4},{5}},{{6,7},{3,4},{5}},{{8,9},{10,11},{5}},{{12,13},{10,11},{5}},
                  {{14,15},{16,17},{18}},{{19,20},{16,17},{18}},{{21,22},{23,24},{18}},{{25,26},{23,24},{18}}};
  self.button_ids={{1,2},{3,4},{5,6},{7,8},{1,2,3,4},{5,6,7,8},{1,2,3,4,5,6,7,8}};
  self.button_phases={{1,2,3,4},{5,6},{7}};
  --骨骼
  local armature=skeleton:buildArmature("battle_item");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  local text_data={x=4,y=-35,size=18,color=16775870,width=119,height=28,alignment=kCCTextAlignmentCenter};
  local a=0;
  while 9>a do
    a=1+a;
    local text_frame=self.armature:getChildByName("pos_" .. a);
    table.insert(self.text_frames,text_frame);
    local data=copyTable(text_data);
    data.x=data.x+text_frame:getPositionX();
    data.y=data.y+text_frame:getPositionY();
    local text=createTextFieldWithTextData(data,9==a and "决赛" or "");
    self.armature:addChild(text);
    table.insert(self.texts,text);
  end

  a=0;
  while 6>a do
    a=1+a;
    local button=Button.new(armature:findChildArmature("view_button_" .. a),false);
    button:getDisplay():setVisible(false);
    button:addEventListener(Events.kStart,self.onViewButtonTap,self,a);
    table.insert(self.buttons,button);
  end
  a=7;
  local text="<content><font color='#00FF00' link='1' ref='1'>查看决赛</font></content>";
  local text_data=armature:getBone("view_button_" .. a).textData;
  local button=createAutosizeMultiColoredLabelWithTextData(text_data,text);
  button:setVisible(false);
  button:addEventListener(DisplayEvents.kTouchTap,self.onViewButtonTap,self,a);
  self.armature:addChild(button);
  table.insert(self.buttons,button);

  a=0;
  while self.const_line_num>a do
    a=1+a;
    local l=self.armature:getChildByName("l_" .. a);
    table.insert(self.tracks,l);
  end

  local text="";
  local text_data=armature:getBone("title_descb").textData;
  self.title_descb=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.title_descb);

  text="";
  text_data=armature:getBone("time_descb").textData;
  self.time_descb=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.time_descb);

  self.button=Button.new(armature:findChildArmature("common_copy_bluelonground_button"),false);
  self.button.bone:initTextFieldWithString("common_copy_bluelonground_button","查看部署");
  self.button:addEventListener(Events.kStart,self.onButtonTap,self);
end

function PossessionBattleItem:onButtonTap(event)
  local stage=self.battle_ui.data.Stage;
  if not self.battle_ui:getHasFamilyByMapID(self.mapID) then
    sharedTextAnimateReward():animateStartByString("您的家族没有报名这场领地战哦~");
    return;
  end
  if PossessionBattleConfig.ID_4==stage or
     PossessionBattleConfig.ID_7==stage or
     PossessionBattleConfig.ID_10==stage then
     sharedTextAnimateReward():animateStartByString("战斗中不能进行部署和查看哦~");
     return;
  end
  if PossessionBattleConfig.ID_5==stage or
     PossessionBattleConfig.ID_8==stage then
     self.parent_container:addDeployUI(self.mapID);
     return;
  end
  if PossessionBattleConfig.ID_3==stage or
     PossessionBattleConfig.ID_6==stage or
     PossessionBattleConfig.ID_9==stage or
     PossessionBattleConfig.ID_11==stage then
     self.parent_container:addDeployUI(self.mapID,true);
     return;
  end
end

function PossessionBattleItem:onViewButtonTap(event, placeID)
  require "main.view.possessionBattle.ui.PossessionViewUI";
  local viewBattleUI = PossessionViewUI.new()
  viewBattleUI:initializeUI(self.skeleton,self.battle_ui,self.parent_container,placeID,self.mapID);
  self.parent_container:addChild(viewBattleUI);
  self.parent_container.viewBattleUI = viewBattleUI;
  self.battle_ui:galleryViewLayerEnabled(false)
end

function PossessionBattleItem:refreshData()
  if not self.battle_ui.data then
    return;
  end
  local stage=self.battle_ui.data.Stage;
  local phase=0;
  if PossessionBattleConfig.ID_4==stage then
    phase=1;
  elseif PossessionBattleConfig.ID_5==stage or PossessionBattleConfig.ID_6==stage or PossessionBattleConfig.ID_7==stage then
    phase=2;
  elseif PossessionBattleConfig.ID_8==stage or PossessionBattleConfig.ID_9==stage or PossessionBattleConfig.ID_10==stage or PossessionBattleConfig.ID_11==stage then
    phase=3;
  end
  local a=0;
  while 8>a do
    a=1+a;
    local data=self.battle_ui:getDataByMapIDAndPromotionPositionId(self.mapID,a);
    if data then
      self.texts[a]:setString(data.FamilyName);
      if 0==data.BooleanValue then
        self.text_frames[a]:setColor(CommonUtils:ccc3FromUInt(self.const_color_0));
        self.texts[a]:setColor(CommonUtils:ccc3FromUInt(self.const_color_0));
      end
      if 0~=self.userProxy:getFamilyID() and self.userProxy:getFamilyID()==data.FamilyId then
        self.text_frames[a]:setColor(CommonUtils:ccc3FromUInt(self.const_color_4_border_self));
      end
    else
      self.texts[a]:setString("无人参赛哦");
      self.text_frames[a]:setColor(CommonUtils:ccc3FromUInt(self.const_color_0));
      self.texts[a]:setColor(CommonUtils:ccc3FromUInt(self.const_color_0));
    end
  end

  a=0;
  while self.const_line_num>a do
    a=1+a;
    self.tracks[a]:setColor(CommonUtils:ccc3FromUInt(self.const_color_1));
  end
  a=0;
  while 8>a do
    a=1+a;
    local data=self.battle_ui:getDataByMapIDAndPromotionPositionId(self.mapID,a);
    if data then
      if 1==data.BooleanValue then
        local b=0;
        while phase>b do
          b=1+b;
          for k,v in pairs(self.track_ids[a][b]) do
            self.tracks[v]:setColor(CommonUtils:ccc3FromUInt(self.const_color));
          end
        end
      end
    end
  end

  phase=0;
  if PossessionBattleConfig.ID_5==stage or PossessionBattleConfig.ID_6==stage or PossessionBattleConfig.ID_7==stage then
    phase=1;
  elseif PossessionBattleConfig.ID_8==stage or PossessionBattleConfig.ID_9==stage or PossessionBattleConfig.ID_10==stage then
    phase=2;
  elseif PossessionBattleConfig.ID_11==stage then
    phase=3;
  end
  if 0<phase then
    local a=phase;
    phase=0;
    while a>phase do
      phase=1+phase;
      for k,v in pairs(self.button_phases[phase]) do
        if 7==v then
          self.buttons[v]:setVisible(self:getViewable(self.button_ids[v]));
        else
          self.buttons[v]:getDisplay():setVisible(self:getViewable(self.button_ids[v]));
        end
      end
    end
  end

  phase=0;
  if PossessionBattleConfig.ID_4==stage then
    phase=1;
  elseif PossessionBattleConfig.ID_7==stage then
    phase=2;
  elseif PossessionBattleConfig.ID_10==stage then
    phase=3;
  end
  if 0<phase then
    for k,v in pairs(self.button_phases[phase]) do
      if self:getViewable(self.button_ids[v]) then
        if not self.ing_imgs[v] then
          self.ing_imgs[v]=cartoonPlayer(EffectConstConfig.TOWER_AVATAR,self.armature:getChildByName("ing_pos_" .. v):getPosition().x,self.armature:getChildByName("ing_pos_" .. v):getPosition().y,0,nil,1);
        end
        self.armature:addChild(self.ing_imgs[v]);
      end
    end
  else
    for k,v in pairs(self.ing_imgs) do
      self.armature:removeChild(v);
      self.ing_imgs[k]=nil;
    end
  end

  self.title_descb:setString(analysis("Jiazu_Lingdizhanliuchengzhuangtai",stage,"text"));
  self.button:getDisplay():setVisible(self.battle_ui:getFamilyIsPromotedByMapID(self.mapID) and self:getButtonVisible());

  if not self.none_bg and not self.battle_ui:getHasFamilyAttendByMapID(self.mapID) then
    self.armature:setVisible(false);
    self.none_bg=createTextFieldWithTextData({x=4,y=230,width=792,height=28,lineType="single line",size=18,color=65280,alignment=kCCTextAlignmentCenter,space=0,textType="static"},"还没有腻害的家族来胃这块富饶的土地战斗!");
    self:addChild(self.none_bg);
  end
end

function PossessionBattleItem:getViewable(t)
  local a=0;
  for k,v in pairs(t) do
    local data=self.battle_ui:getDataByMapIDAndPromotionPositionId(self.mapID,v);
    if data then
      if 1==data.BooleanValue then a=1+a; end
    end
  end
  return self:_getViewable(t,1,#t/2) and self:_getViewable(t,1+#t/2,#t);
end

function PossessionBattleItem:_getViewable(t, a, b)
  for k,v in pairs(t) do
    if a<=k and b>=k then
      if self.battle_ui:getDataByMapIDAndPromotionPositionId(self.mapID,v) then
        return true;
      end
    end
  end
  return false;
end

function PossessionBattleItem:getButtonVisible()
  local stage=self.battle_ui.data.Stage;
  if PossessionBattleConfig.ID_4==stage or
     PossessionBattleConfig.ID_7==stage or
     PossessionBattleConfig.ID_10==stage then
     return false;
  end
  return true;
end