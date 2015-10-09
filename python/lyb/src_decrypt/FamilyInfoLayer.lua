--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

FamilyInfoLayer=class(TouchLayer);

function FamilyInfoLayer:ctor()
  self.class=FamilyInfoLayer;
end

function FamilyInfoLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	FamilyInfoLayer.superclass.dispose(self);

  self.armature4dispose:dispose();
  BitmapCacher:removeUnused();
end

--
function FamilyInfoLayer:initialize(parent_container)
  self:initLayer();
  self.parent_container=parent_container;
  self.skeleton=self.parent_container.skeleton;
  self.familyProxy=self.parent_container.familyProxy;
  self.userProxy=self.parent_container.userProxy;
  self.userCurrencyProxy=self.parent_container.userCurrencyProxy;
  self.effectProxy=self.parent_container.effectProxy;
  self.generalListProxy=self.parent_container.generalListProxy;
  self.countControlProxy=self.parent_container.countControlProxy;
  
  self.const_item_num=6;
  self.const_family_level_max=10;
  
  --骨骼
  local armature=self.skeleton:buildArmature("family_info_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  local text="帮派排名";
  local text_data=armature:getBone("rank").textData;
  self.rank=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.rank);

  text="帮派人数";
  text_data=armature:getBone("population").textData;
  self.population=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.population);

  text="帮派资金";
  text_data=armature:getBone("silver").textData;
  self.silver=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.silver);

  text="我的贡献";
  text_data=armature:getBone("donate").textData;
  self.donate=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.donate);

  text="我的地位";
  text_data=armature:getBone("position").textData;
  self.position=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.position);

  text="";
  text_data=armature:getBone("name_descb").textData;
  self.name_descb=createRichMultiColoredLabelWithTextData(text_data,text);
  self.armature:addChild(self.name_descb);

  text="";
  text_data=armature:getBone("text_progressBar").textData;
  self.text_progressBar=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.text_progressBar);

  text="";
  text_data=armature:getBone("rank_descb").textData;
  self.rank_descb=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.rank_descb);

  text="";
  text_data=armature:getBone("population_descb").textData;
  self.population_descb=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.population_descb);

  text="";
  text_data=armature:getBone("silver_descb").textData;
  self.silver_descb=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.silver_descb);

  text="";
  text_data=armature:getBone("donate_descb").textData;
  self.donate_descb=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.donate_descb);

  text="";
  text_data=armature:getBone("position_descb").textData;
  self.position_descb=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.position_descb);

  -- text="族长超过" .. analysis("Xishuhuizong_Xishubiao",248,"constant") .. "天没没来呢，点击操作权限可以弹劾哦！";
  -- text_data=armature:getBone("impeach_descb").textData;
  -- self.impeach_descb=createTextFieldWithTextData(text_data,text);
  -- self.impeach_descb:setVisible(self.familyProxy:getImpeachable() and not self.userProxy:getIsFamilyLeader());
  -- self.armature:addChild(self.impeach_descb);

  -- self.levelupButton=Button.new(armature:findChildArmature("button_level_up"),false);
  -- self.levelupButton:addEventListener(Events.kStart,self.onLevelupButtonTap,self);
  -- self.levelupButton:addEventListener(Events.kStart,self.onLevelupButtonTap,self);

  local levelupButton =self.armature4dispose.display:getChildByName("button_level_up");
  SingleButton:create(levelupButton);
  levelupButton:addEventListener(DisplayEvents.kTouchTap, self.onLevelupButtonTap, self);
  self.levelupButton = levelupButton;

  --local  self.levelupButton = 
  --common_copy_blueround_button

  local button=Button.new(armature:findChildArmature("authority"),false);
  button.bone:initTextFieldWithString("common_small_orange_button","查看权限");
  button:addEventListener(Events.kStart,self.onAuthorityTap,self);
  self.authority=button;

  text="";
  text_data=armature:getBone("notice_descb").textData;
  self.notice_descb_text_data=text_data;
  self.notice_descb=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.notice_descb);

  self.notice_change_button=Button.new(armature:findChildArmature("notice_change_button"),false);
  self.notice_change_button.bone:initTextFieldWithString("common_small_orange_button","修改公告");
  self.notice_change_button:addEventListener(Events.kStart,self.onChangeNoticeTap,self);
  self.armature:addChild(self.notice_change_button);

  --exp_progress
  local progressBar = armature:findChildArmature("progressBar");
  self.progressBar = ProgressBar.new(progressBar, "pro_up");
  -- self.progressBar:setScaleX(370/405);
  self.progressBar:setProgress(0);

  -- local progressBar = armature:findChildArmature("progressBar");
  -- self.progressBar = ProgressBar.new(progressBar, "pro_up");
  -- self.progressBar:setProgress(0);

  --agoraButton
  -- local agoraButton=self.armature:getChildByName("common_copy_bluelonground_button");
  -- local agoraButton_pos=convertBone2LB4Button(agoraButton);
  -- textData=armature:findChildArmature("common_copy_bluelonground_button"):getBone("common_copy_bluelonground_button").textData;
  -- self.armature:removeChild(agoraButton);

  -- agoraButton=CommonButton.new();
  -- agoraButton:initialize("common_bluelonground_button_normal","common_bluelonground_button_down",CommonButtonTouchable.BUTTON);
  -- agoraButton:initializeText(textData,"家族集会所");
  -- agoraButton:setPosition(agoraButton_pos);
  -- agoraButton:addEventListener(DisplayEvents.kTouchTap,self.onAgoraButtonTap,self);
  -- self.armature:addChild(agoraButton);
  -- self.agoraButton=agoraButton;

  -- self.const_items_page=3.8;
  -- self.const_activity_img_skew_x=107;
  -- self.const_activity_img_skew_y=108;
  -- self.const_activity_item_size=makeSize(526,112);
  -- self.const_activity_layer_pos=self.armature:getChildByName("pos"):getPosition();
  -- self.const_activity_layer_pos.y=-self.const_items_page*self.const_activity_item_size.height+self.const_activity_layer_pos.y;
  --[[local a=1;
  self.items={};
  while analysisHas("Jiazu_Huodong",a) do
    local item=FamilyActivityIcon.new();
    item:initialize(self.skeleton,a,self.parent_container);
    table.insert(self.items,item);
    a=1+a;
  end]]
end

function FamilyInfoLayer:refreshActivityIcon()
  if self.item_layer then
    for k,v in pairs(self.items) do
      v:refreshActivitys();
    end
    return;
    --self.armature:removeChild(self.item_layer);
    --self.item_layer=nil;
  end
  self.items={};
  local activityTable=analysisTotalTable("Bangpai_Huodong");

  for k,v in pairs(activityTable) do
     print("k,v ",k,v)
     print(analysis("Bangpai_Huodong",v.id,"kaiqi"),self.familyProxy:getFamilyLevel());
     --if analysis("Jiazu_Huodong",v.id,"kaiqi")<=self.familyProxy:getFamilyLevel() then
      local item=FamilyActivityIcon.new();
      item:initialize(self.skeleton, v.id, self.parent_container);
      table.insert(self.items,item);
     --end
  end

  local function sf(a, b)
    return analysis("Bangpai_Huodong",a.id,"type")<analysis("Bangpai_Huodong",b.id,"type");
  end
  table.sort(self.items,sf);

  self.item_layer=ListScrollViewLayer.new();
  self.item_layer:initLayer();
  self.item_layer:setPosition(makePoint(550,85));
  self.item_layer:setViewSize(makeSize(645,375));
  self.item_layer:setItemSize(makeSize(645,125));
  self.armature:addChild(self.item_layer);
  for k,v in pairs(self.items) do
    self.item_layer:addItem(v);
  end
end

function FamilyInfoLayer:onAgoraButtonTap(event)

  if self.userProxy.state == GameConfig.STATE_TYPE_3 then
     sendMessage(3, 26, {Type = 1});
  end
  self.parent_container:dispatchEvent(Event.new(FamilyNotifications.FAMILY_TO_AGORA,nil,self));
  self.parent_container:onCloseButtonTap();
  
end

function FamilyInfoLayer:onAuthorityTap(event)
  local familyAuthorityLayer=FamilyAuthorityLayer.new();
  familyAuthorityLayer:initialize(self.skeleton,self.familyProxy,self.userProxy,self.parent_container);
  sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(familyAuthorityLayer);
  if self.item_layer then
    self.item_layer:setMoveEnabled(false);
  end
end

function FamilyInfoLayer:onDonateTap(event)
  if 10000>self.userCurrencyProxy:getSilver() then
    --sharedTextAnimateReward():animateStartByString("银两不足哦~");
    -- local a=CommonPopup.new();
    -- a:initialize(StringUtils:getString4Popup(PopupMessageConstConfig.ID_20),self,self.onToGetSilver,nil,nil,nil,false,StringUtils:getButtonString4Popup(PopupMessageConstConfig.ID_20));
    -- self:addChild(a);

    sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_20));
    return;
  elseif 20000>self.userCurrencyProxy:getSilver() then
    local a=CommonPopup.new();
    a:initialize("确认捐献" .. 10000 .. "银两吗!",self,self.onDonate,{Count=1});
    self.parent_container:addChild(a);
    return;
  end
  local batchUseUI=BatchUseUI.new();
  batchUseUI:initialize(self.effectProxy:getBatchUseSkeleton(),self,{ItemId=2,MaxCount=math.min(math.floor(self.userCurrencyProxy:getSilver()/10000),50)},{"捐献","取消"},self.onDonate,nil,4,self.userCurrencyProxy);
  self.parent_container:addChild(batchUseUI);
end

function FamilyInfoLayer:onDonate(data)
  self.parent_container:dispatchEvent(Event.new(FamilyNotifications.FAMILY_DONATE,{Count=data.Count},self));
end

function FamilyInfoLayer:onChangeNoticeTap(event)
  local familyNoticeLayer=FamilyNoticeLayer.new();
  familyNoticeLayer:initialize(self.skeleton,self.familyProxy,self.parent_container);
  self.parent_container:addChild(familyNoticeLayer);
end

function FamilyInfoLayer:onOtherButtonTap(event)
  self.parent_container:onOtherFamilyButtonTap();
end

function FamilyInfoLayer:onDismissButtonTap(event)
  local id=self.userProxy:getIsFamilyLeader() and PopupMessageConstConfig.ID_138 or PopupMessageConstConfig.ID_139;
  -- if self.userProxy:getIsFamilyLeader() and 1<self.data.Count then
  --   sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_181));
  --   return;
  -- end
  local commonPopup=CommonPopup.new();
  commonPopup:initialize(StringUtils:getString4Popup(id),self,self.onDismissConfirm,nil,nil,nil,false,StringUtils:getButtonString4Popup(id));
  self:addChild(commonPopup);
end

function FamilyInfoLayer:onDismissConfirm()
  self.parent_container:dispatchEvent(Event.new(FamilyNotifications.FAMILY_DISMISS,nil,self));
end

function FamilyInfoLayer:onLevelupButtonTap(event)
  print("look3====>")
  if not self.data then
    return;
  end
  print("look4====>")
  local exp_max=self:getExp4Levelup();
  local a=analysis("Jiazu_Jiazushengjibiao",1+self.data.FamilyLevel,"yinpiao");
  if self.data.Experience<exp_max then
    sharedTextAnimateReward():animateStartByString("经验不足哦~");
    return;
  else
    --sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_233,{a}));
    print("look5====>")
    local commonPopup=CommonPopup.new();
    commonPopup:initialize(StringUtils:getString4Popup(PopupMessageConstConfig.ID_233,{a}),self,self.onFamilyLevelUpConfirm,nil,nil,nil,false,StringUtils:getButtonString4Popup(PopupMessageConstConfig.ID_233));
    self:addChild(commonPopup);
  end
end

function FamilyInfoLayer:onFamilyLevelUpConfirm()
  local a=analysis("Jiazu_Jiazushengjibiao",1+self.data.FamilyLevel,"yinpiao");
  if self.data.Silver<a then

    sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_234));
  else
    self.parent_container:dispatchEvent(Event.new(FamilyNotifications.FAMILY_LEVEL_UP,nil,self));
  end
end

function FamilyInfoLayer:onToGetSilver()
  self.parent_container:dispatchEvent(Event.new("TO_AUTO_GUIDE",{ID=FunctionConfig.FUNCTION_ID_103,TYPE_ID=3},self));
end

function FamilyInfoLayer:refresh(data)
  if data then
    self.data=data;
  else
    self.data=self.familyProxy:getData();
  end

  self:refreshFamilyInfo();
  self:refreshStand();
  self:refreshLevel();
  self:refreshIsUser();
  self:refreshActivityIcon();
  if self.changeToActivityID then
    self:scrollToActivity(self.changeToActivityID);
  end
end

function FamilyInfoLayer:refreshFamilyInfo()
  local str = "<content><font color='#00FFFF'>" .. self.data.FamilyName .. "</font>";
  str = str .. "<font color='#FFFFFF'>   Lv" .. self.data.FamilyLevel .. "</font></content>"
  self.name_descb:setString(str);
  if self.parent_container.isLookInto then
    self.position:setString("0");
    self.donate:setString("0");
    self.authority:getDisplay():setVisible(false);
    self.to_donate:getDisplay():setVisible(false);
    self.notice_change_button:getDisplay():setVisible(false);
  else
    self.position_descb:setString(analysis("Jiazu_Zhiweidengjibiao",self.userProxy:getFamilyPositionID(),"name"));
    self.donate_descb:setString(self.userCurrencyProxy:getFamilyContribute());
    if 2<self.userProxy:getFamilyPositionID() then
      self.notice_change_button:getDisplay():setVisible(false);
    end
  end
  
  self.rank_descb:setString(0==self.data.Ranking and "未上榜" or self.data.Ranking);
  self.population_descb:setString(self.data.Count .. "/" .. analysis("Jiazu_Jiazushengjibiao",self.data.FamilyLevel,"renshu"));
  self.silver_descb:setString(self.data.Silver);
  self:refreshNotice();
end

function FamilyInfoLayer:refreshFamilyContribute()
  self.donate_descb:setString(self.userCurrencyProxy:getFamilyContribute());
end

function FamilyInfoLayer:refreshNewInfo()
  self:refresh();
  self.impeach_descb:setVisible(self.familyProxy:getImpeachable() and not self.userProxy:getIsFamilyLeader());
end

function FamilyInfoLayer:refreshNotice()
  self.notice_descb:setString(self.data.Notice);
end

--todo 待改
function FamilyInfoLayer:refreshStand()
  -- if self.stand_img then
  --   self.armature:removeChild(self.stand_img);
  --   self.stand_img=nil;
  -- end
  -- local stand_pos=self.armature:getChildByName("common_copy_button_bg"):getPosition();
  -- self.stand_img=self.skeleton:getBoneTextureDisplay("stand_" .. self.data.StandID);
  -- self.stand_img:setAnchorPoint(makePoint(0.5,0.5));
  -- self.stand_img:setPosition(stand_pos);
  -- self.armature:addChild(self.stand_img);
end

function FamilyInfoLayer:refreshLevel()
  --[[local text='<content><font color="#E1D2A0">家族等级 </font><font color="#FFE400">' .. self.data.FamilyLevel .. '级</font></content>';
  self.level_descb:setString(text);

  if self.const_family_level_max==self.data.FamilyLevel then
    text='<content><font color="#E1D2A0">已满级</font></content>';
  else
    text='<content><font color="#E1D2A0">升级需家族资金 </font><font color="#00FF00">' .. analysis("Jiazu_Jiazushengjibiao",1+self.data.FamilyLevel,"yinpiao") .. '</font></content>';
  end
  self.level_up_silver_descb:setString(text);]]

  local exp_max=self:getExp4Levelup();
  text="经验：" .. self.data.Experience .. "/" .. exp_max;
  --self.exp_normal:setString(text);
  self.text_progressBar:setString(text);

  --print("chhy wrong:",self.data.Experience,exp_max)

  self.progressBar:setProgress(self.data.Experience>exp_max and 1 or self.data.Experience/exp_max,"left");

  --print("look1====>",self.const_family_level_max,self.data.FamilyLevel,self.userProxy:getIsFamilyLeader(),self.userProxy:getIsDeputyLeader())

  self.levelupButton:setVisible(self.const_family_level_max~=self.data.FamilyLevel and (self.userProxy:getIsFamilyLeader() or self.userProxy:getIsDeputyLeader()));
end

function FamilyInfoLayer:refreshIsUser()
  print("look2====>")
  if self.parent_container.isLookInto then
    self.parent_container.tab_buttons[3]:setVisible(false);
    self.parent_container.tab_buttons[4]:setVisible(false);
    self.agoraButton:setVisible(false);
    self.levelupButton:setVisible(false);
  else
    self.parent_container:refreshAuthorityByPosition();
    self.notice_change_button:getDisplay():setVisible(2>self.userProxy:getFamilyPositionID());
  end
end

function FamilyInfoLayer:refreshActivitys()
  for k,v in pairs(self.items) do
    v:refreshActivitys();
  end
end

function FamilyInfoLayer:getExp4Levelup()
  local l=self.const_family_level_max==self.data.FamilyLevel and self.data.FamilyLevel or 1+self.data.FamilyLevel;
  return analysis("Jiazu_Jiazushengjibiao",l,"jingyan1");
end

function FamilyInfoLayer:refreshFamilyPosition()
  self.position_descb:setString(analysis("Jiazu_Zhiweidengjibiao",self.userProxy:getFamilyPositionID(),"name"));
end

function FamilyInfoLayer:changeToActivity(id)
  if self.item_layer then
    self:scrollToActivity(id);
  else
    self.changeToActivityID=id;
  end
end

function FamilyInfoLayer:scrollToActivity(id)
  if self.item_layer then
    for k,v in pairs(self.items) do
      if id==v:getActivityID() then
        self.item_layer:scrollToItemByIndex(-1+k);
        break;
      end
    end
  end
  self.changeToActivityID=nil;
end

function FamilyInfoLayer:refreshActivity4FamilyBoss()
  for k,v in pairs(self.items) do
    if 2==v:getActivityID() then
      v:refreshActivitys();
      break;
    end
  end
end