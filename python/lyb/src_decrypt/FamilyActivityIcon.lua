--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

FamilyActivityIcon=class(TouchLayer);

function FamilyActivityIcon:ctor()
  self.class=FamilyActivityIcon;
end

function FamilyActivityIcon:dispose()
  if self.refreshTime then
    self.refreshTime:dispose();
    self.refreshTime=nil;
  end
  self:removeAllEventListeners();
  self:removeChildren();
	FamilyActivityIcon.superclass.dispose(self);
  self.armature4dispose:dispose();
  BitmapCacher:removeUnused();
end

--
function FamilyActivityIcon:initialize(skeleton, id, parent_container)
  self:initLayer();
  self.skeleton=skeleton;
  self.id=id;
  self.parent_container=parent_container;
  self.userProxy=self.parent_container.userProxy;
  self.familyProxy=self.parent_container.familyProxy;
  self.challengeProxy=self.parent_container.challengeProxy;
  self.countControlProxy=self.parent_container.countControlProxy;
  -- self.const_family_boss_time=analysis("Xishuhuizong_Xishubiao",XiShuConfig.TYPE_90,"constant");
  self.name=analysis("Jiazu_Huodong",self.id,"name");
  
  --骨骼
  local armature=skeleton:buildArmature("activity_item");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  -- self.img_pos=convertBone2LB(self.armature:getChildByName("pos"));
  -- self.image=Image.new();
  -- self.image:loadByArtID(analysis("Jiazu_Huodong",self.id,"artid"));
  -- self.image:setPosition(self.img_pos);
  -- self.armature:addChild(self.image);

  self.image = self.skeleton:getBoneTextureDisplay("family_imgs/huodong_img_1");
  self.image:setPositionXY(0,18);
  self.armature:addChild(self.image);

  local text=analysis("Jiazu_Huodong",self.id,"txt");
  local text_data=armature:getBone("descb").textData;
  self.descb=createAutosizeMultiColoredLabelWithTextData(text_data,text);
  self.armature:addChild(self.descb);

  -- text=analysis("Jiazu_Huodong",self.id,"txt");
  -- text_data=armature:getBone("descb").textData;
  -- self.descb=createTextFieldWithTextData(text_data,text);
  -- self.armature:addChild(self.descb);

  -- text="";
  -- text_data=armature:getBone("close_descb").textData;
  -- self.close_descb=createTextFieldWithTextData(text_data,text);
  -- self.armature:addChild(self.close_descb);

  -- self.go_fight_button=Button.new(armature:findChildArmature("go_fight_button"),false);
  -- self.go_fight_button:addEventListener(Events.kStart,self.onIconTap,self);

  -- self.open_button=Button.new(armature:findChildArmature("open_button"),false);
  -- self.open_button:addEventListener(Events.kStart,self.onActivateTap,self);

  -- self.to_activity_button=Button.new(armature:findChildArmature("to_activity_button"),false);
  -- self.to_activity_button:addEventListener(Events.kStart,self.onIconTap,self);

  -- self.get_bonus_button=Button.new(armature:findChildArmature("get_bonus_button"),false);
  -- self.get_bonus_button:addEventListener(Events.kStart,self.onIconTap,self);

  -- self.rank_view_button=Button.new(armature:findChildArmature("rank_view"),false);
  -- self.rank_view_button:addEventListener(Events.kStart,self.onRankViewTap,self);
  -- self.rank_view_button:getDisplay():setVisible(false);
  -- self.rank_view_left_pos=self.rank_view_button:getDisplay():getPosition();
  -- self.rank_view_right_pos=self.get_bonus_button:getDisplay():getPosition();

  local button=self.armature:getChildByName("button");
  local button_pos=convertBone2LB4Button(button);
  self.armature:removeChild(button);

  button=CommonButton.new();
  button:initialize("commonButtons/common_blue_button_normal","commonButtons/common_blue_button_down",CommonButtonTouchable.BUTTON);
  --button:initializeText(trimButtonData,"整理背包");
  button:initializeBMText("领薪水","anniutuzi");
  button:setPosition(button_pos);
  button:addEventListener(DisplayEvents.kTouchTap,self.onButtonTap,self);
  self.armature:addChild(button);
  self.button=button;

  self:refreshActivitys();
end

function FamilyActivityIcon:refreshActivitys()

end

function FamilyActivityIcon:onButtonTap(event)
  if 1 == self.id then
    self.parent_container:dispatchEvent(Event.new("GET_FAMILY_SALARY",nil,self));
  end
end

-- function FamilyActivityIcon:onActivateTap(event)
--   if not self.userProxy:getIsFamilyLeader() and not self.userProxy:getIsDeputyLeader() then
--     sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_155));
--     return;
--   end
--   if not self.open_button:getDisplay():isVisible() then
--     sharedTextAnimateReward():animateStartByString(analysis("Jiazu_Huodong",self.id,"name") .. "已经激活了哦~");
--     return;
--   end
--   local a=CommonPopup.new();
--   a:initialize("确认激活" .. analysis("Jiazu_Huodong",self.id,"name") .. "吗?",self,self.activate);
--   self.parent_container:addChild(a);
-- end

-- function FamilyActivityIcon:activate()
--   self.parent_container:dispatchEvent(Event.new(FamilyNotifications.FAMILY_ACTIVITY_ACTIVATE,{ID=self.id},self));
-- end

-- function FamilyActivityIcon:onIconTap(event)
--   if self.effect then
--     self.armature:removeChild(self.effect);
--     self.effect=nil;
--   end

--   local config_id;
--   local pop_id;
--   if 2==self.id then
--     config_id=CountControlConfig.FAMILY_BOSS;
--     pop_id=PopupMessageConstConfig.ID_242;
--   elseif 4==self.id then
--     --config_id=CountControlConfig.FAMILY_TASK;
--     --pop_id=PopupMessageConstConfig.ID_243;
--   elseif 8==self.id then
--     config_id=CountControlConfig.FAMILY_XUAN_NV;
--     pop_id=PopupMessageConstConfig.ID_244;
--   end
--   if config_id then
--     if self.countControlProxy:getJibencishu(config_id)<=self.countControlProxy:getCurrentCountByID(config_id) then
--       sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(pop_id));
--       return;
--     end
--   end

--   if 8==self.id then--祭祀天官
  
--   elseif 7==self.id then
--     self.parent_container.panels[1]:onAgoraButtonTap();
--   elseif 4==self.id then
--     self.parent_container:dispatchEvent(Event.new(MainSceneNotifications.MAIN_SCENE_TO_FAMILY_TASK,nil,self));
--   elseif 3 == self.id then 
--     if GameConfig.STATE_TYPE_1 ~= self.parent_container.userProxy.state then --排除挂机状态
--       self.parent_container:dispatchEvent(Event.new("TO_HANG_UP",nil,self));
--     end
--     self.parent_container:dispatchEvent(Event.new(BathFieldNotifications.TO_BATH_FIELD,nil,self));
--   elseif 2 == self.id then
--     if GameConfig.STATE_TYPE_1 ~= self.parent_container.userProxy.state then --排除挂机状态
--       self.parent_container:dispatchEvent(Event.new("TO_HANG_UP",nil,self));
--     end
--     if self.userProxy.state == GameConfig.STATE_TYPE_3 then
--       sendMessage(3, 26, {Type = 1});
--     end
--     if self.refreshTime then
--       self.refreshTime:dispose();
--       self.refreshTime=nil;
--     end
--     -- self.refreshTime=RefreshTime.new();
--     -- self.refreshTime:initTime(self.const_family_boss_time,self.onToFamilyBoss,self,4);
--     -- self.close_descb:setString("0" .. self.const_family_boss_time .. "秒后进入");
--     self.go_fight_button:getDisplay():setVisible(false);
--     self.to_activity_button:getDisplay():setVisible(false);
--     initializeSmallLoading();
--     self.parent_container:dispatchEvent(Event.new("TO_FAMILY_BOSS",nil,self));
--   elseif 1 == self.id then
--     self.parent_container:dispatchEvent(Event.new("GET_FAMILY_SALARY",nil,self));
--   end
-- end

-- function FamilyActivityIcon:onToFamilyBoss()
--   if 0>=self.refreshTime:getTotalTime() then
--     self.refreshTime:dispose();
--     self.refreshTime=nil;
--     self.close_descb:setString("等待进入");
--   else
--     self.close_descb:setString(self.refreshTime:getTimeStr() .. "秒后进入");
--   end
-- end

-- function FamilyActivityIcon:onRankViewTap(event)
--   initializeSmallLoading();
--   self.parent_container:dispatchEvent(Event.new(FamilyNotifications.REQUEST_FAMILY_BOSS_RANK_DATA,nil,self));
-- end

-- function FamilyActivityIcon:refreshActivitys()
--   if self.refreshTime then
--     self.refreshTime:dispose();
--     self.refreshTime=nil;
--     uninitializeSmallLoading();
--   end
--   local a=self.familyProxy:getActivityIsOpen(self.id);
--   --[[if self.unactivate_img then
--     self.armature:removeChild(self.unactivate_img);
--     self.unactivate_img=nil;
--   end
--   if self.effect then
--     self.armature:removeChild(self.effect);
--     self.effect=nil;
--   end]]
  
--   if self.parent_container.isLookInto then

--     self.name_descb:setString('<content><font color="#E1D2A0">' .. self.name .. '</font></content>');
--     self.close_descb:setString("");
--     self.go_fight_button:getDisplay():setVisible(false);
--     self.open_button:getDisplay():setVisible(false);
--     self.to_activity_button:getDisplay():setVisible(false);
--     self.get_bonus_button:getDisplay():setVisible(false);

--   elseif analysis("Jiazu_Huodong",self.id,"kaiqi")>self.familyProxy:getFamilyLevel() then

--     self.name_descb:setString('<content><font color="#E1D2A0">' .. self.name .. '</font><font color="#00FF00"> (家族' .. analysis("Jiazu_Huodong",self.id,"kaiqi") .. '级开启)</font></content>');
--     self.close_descb:setString("");
--     self.go_fight_button:getDisplay():setVisible(false);
--     self.open_button:getDisplay():setVisible(false);
--     self.to_activity_button:getDisplay():setVisible(false);
--     self.get_bonus_button:getDisplay():setVisible(false);

--   elseif not a and 0==analysis("Jiazu_Huodong",self.id,"begin") then

--     if 1==self.id then
--       self.name_descb:setString('<content><font color="#E1D2A0">' .. self.name .. '</font><font color="#00FF00"> (已领取)</font></content>');
--     elseif 2==self.id then
--       self.name_descb:setString('<content><font color="#E1D2A0">' .. self.name .. '</font><font color="#00FF00"> (BOSS死翘翘了)</font></content>');
--       self.rank_view_button:getDisplay():setPosition(self.rank_view_right_pos);
--       self.rank_view_button:getDisplay():setVisible(true);
--     else
--       self.name_descb:setString('<content><font color="#E1D2A0">' .. self.name .. '</font></content>');
--     end
--     self.close_descb:setString("");
--     self.go_fight_button:getDisplay():setVisible(false);
--     self.open_button:getDisplay():setVisible(false);
--     if 7==self.id and self.challengeProxy:getDateByID(ActivityConstConfig.ID_8) then
--       self.to_activity_button:getDisplay():setVisible(true);
--     elseif 4==self.id then
--       self.to_activity_button:getDisplay():setVisible(true);
--     else
--       self.to_activity_button:getDisplay():setVisible(false);
--     end
--     self.get_bonus_button:getDisplay():setVisible(false);

--   elseif a or 0==analysis("Jiazu_Huodong",self.id,"begin") then
--     --[[if 1==analysis("Jiazu_Huodong",self.id,"begin") then
--       self.effect=cartoonPlayer(EffectConstConfig.FAMILY_ACTIVITY,makePoint(35+self.img_pos.x,35+self.img_pos.y),0);
--       self.effect.touchChildren=false;
--       self.effect.touchEnabled=false;
--       self.armature:addChild(self.effect);
--     end
--     self.image:addEventListener(DisplayEvents.kTouchTap,self.onIconTap,self);]]
--     local joined=0==self.countControlProxy:getRemainCountByID(CountControlConfig.FAMILY_BOSS);

--     if 1==self.id then
--       self.name_descb:setString('<content><font color="#E1D2A0">' .. self.name .. '</font><font color="#00FF00"> (可领取)</font></content>');
--     elseif 2==self.id then
--       self.name_descb:setString('<content><font color="#E1D2A0">' .. self.name .. '</font><font color="#00FF00">  ' .. (joined and '(参加过了啦)' or ' ') .. '</font></content>');
--       --self:setIconEffect(true);
--       self.rank_view_button:getDisplay():setPosition(joined and self.rank_view_right_pos or self.rank_view_left_pos);
--       self.rank_view_button:getDisplay():setVisible(true);
--     else
--       self.name_descb:setString('<content><font color="#E1D2A0">' .. self.name .. '</font></content>');
--     end
--     self.close_descb:setString("");
--     self.go_fight_button:getDisplay():setVisible(not joined and 2==self.id);
--     self.open_button:getDisplay():setVisible(false);
--     self.to_activity_button:getDisplay():setVisible(1~=self.id and 2~=self.id);
--     self.get_bonus_button:getDisplay():setVisible(1==self.id);

--   else
--     --[[self.unactivate_img=self.skeleton:getBoneTextureDisplay("unactivate_img");
--     self.unactivate_img.touchEnabled=false;
--     self.unactivate_img:setPositionXY(0,50);
--     self.armature:addChild(self.unactivate_img);]]
--     if 2==self.id and 0~=self.familyProxy:getActivityTime(2) then
--       self.name_descb:setString('<content><font color="#E1D2A0">' .. self.name .. '</font><font color="#00FF00"> (今日活动结束啦)</font></content>');
--       self.close_descb:setString("");
--       self.open_button:getDisplay():setVisible(false);
--       --self:setIconEffect(false);
--     else
--       self.name_descb:setString('<content><font color="#E1D2A0">' .. self.name .. '</font><font color="#00FF00"> (族长未开启)</font></content>');
--       self.close_descb:setString("");
--       self.open_button:getDisplay():setVisible((self.userProxy:getIsFamilyLeader() or self.userProxy:getIsDeputyLeader()) and 1==analysis("Jiazu_Huodong",self.id,"begin"));
--     end
--     self.go_fight_button:getDisplay():setVisible(false);
--     self.to_activity_button:getDisplay():setVisible(false);
--     self.get_bonus_button:getDisplay():setVisible(false);
--   end
-- end

-- function FamilyActivityIcon:getBossOpenTime()
--   local a=os.date("*t",self.familyProxy:getActivityTime(2));
--   local h=a.hour;
--   if 10>tonumber(h) then
--     h="0" .. h;
--   end
--   local m=a.min;
--   if 10>tonumber(m) then
--     m="0" .. m;
--   end
--   return "今日" .. h .. ":" .. m .. "被开启";
-- end

function FamilyActivityIcon:setIconEffect(isOpen)
  -- if not self.activityEffect and 2==self.id then
  --   self.activityEffect = cartoonPlayer("2498_1001",ccp(self.image:getContentSize().width/2,self.image:getContentSize().width/2),0);
  --   self.image:addChild(self.activityEffect);
  -- end
  -- if 2==self.id then
  --   self.activityEffect:setVisible(isOpen);
  -- end
end

function FamilyActivityIcon:getActivityID()
  return self.id;
end