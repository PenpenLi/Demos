--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

PossessionSignUI=class(TouchLayer);

function PossessionSignUI:ctor()
  self.class=PossessionSignUI;
end

function PossessionSignUI:dispose()
  self:disposeRefreshTime();
  self:removeAllEventListeners();
  self:removeChildren();
	PossessionSignUI.superclass.dispose(self);
  self.armature4dispose:dispose();
end

function PossessionSignUI:disposeRefreshTime()
  if self.refreshTime then
    self.refreshTime:dispose();
    self.refreshTime=nil;
  end
end

--
function PossessionSignUI:initializeUI(skeleton, parent_container)
  self:initLayer();
  self.skeleton=skeleton;
  self.parent_container=parent_container;
  self.possessionBattleProxy=self.parent_container.possessionBattleProxy;
  self.familyProxy=self.parent_container.familyProxy;
  self.userProxy=self.parent_container.userProxy;
  self.const_max_sign_in=8;
  self.imgs={};
  self.img_fgs={};
  self.signed_imgs={};
  self.selected=nil;
  self.data=nil;
  self.refreshTime=nil;

  self:addChild(LayerColorBackGround:getBackGround());

  --骨骼
  local armature=skeleton:buildArmature("sign_in_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  local button=Button.new(armature:findChildArmature("common_copy_close_button"),false);
  button:addEventListener(Events.kStart,self.onCloseButtonTap,self);
  
  local a=0;
  while 5>a do
    a=1+a;
    local img=self.armature:getChildByName("img_" .. a);
    img:addEventListener(DisplayEvents.kTouchBegin,self.onImageBegin,self);
    table.insert(self.imgs,img);
    local img_fg=self.armature:getChildByName("img_fg_" .. a);
    img_fg.touchEnabled=false;
    img_fg:setVisible(false);
    table.insert(self.img_fgs,img_fg);

    local title=Image.new();
    title.touchEnabled=false;
    title:loadByArtID(analysis("Jiazu_Lingdizhanbaoming",a,"artid"));
    title:setPosition(self.armature:getChildByName("pos_" .. a):getPosition());
    self.armature:addChild(title);
  end

  local data=self.skeleton.textureAtlasData:getSubTextureData("img_5");
  local i=1+self.armature:getChildIndex(self.imgs[5]);
  local pos=self.imgs[5]:getPosition();
  local disp=Sprite.new(getGraySprite(self.imgs[5].sprite,data.x,data.y,true));
  disp.sprite:setAnchorPoint(CCPointMake(0,1));
  disp.touchEnabled=false;
  disp:setPosition(pos);
  self.imgs[5]=disp;
  self.armature:addChildAt(disp,i);

  local text="";
  local text_data=armature:getBone("sign_in_tip_fg").textData;
  self.sign_in_tip_fg=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.sign_in_tip_fg);

  text="";
  text_data=armature:getBone("winner_descb").textData;
  self.winner_descb=createAutosizeMultiColoredLabelWithTextData(text_data,text);
  self.armature:addChild(self.winner_descb);

  text="";
  text_data=armature:getBone("level_descb").textData;
  self.level_descb=createAutosizeMultiColoredLabelWithTextData(text_data,text);
  self.armature:addChild(self.level_descb);

  text="";
  text_data=armature:getBone("cost_descb").textData;
  self.cost_descb=createAutosizeMultiColoredLabelWithTextData(text_data,text);
  self.armature:addChild(self.cost_descb);

  text="";
  text_data=armature:getBone("number_descb").textData;
  self.number_descb=createAutosizeMultiColoredLabelWithTextData(text_data,text);
  self.armature:addChild(self.number_descb);

  text="<content><font color='#E1D2A0'>领主奖励</font></content>";
  text_data=armature:getBone("bonus").textData;
  self.bonus=createAutosizeMultiColoredLabelWithTextData(text_data,text);
  self.armature:addChild(self.bonus);

  text="";
  text_data=armature:getBone("bonus_descb").textData;
  self.bonus_descb=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.bonus_descb);

  text="";
  text_data=armature:getBone("time_bg").textData;
  self.time_bg=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.time_bg);

  text="<content><font color='#00FF00' ling='1' ref='1'>查看比赛规则</font></content>";
  text_data=armature:getBone("number_descb0").textData;
  self.number_descb0=createAutosizeMultiColoredLabelWithTextData(text_data,text);
  self.number_descb0:addEventListener(DisplayEvents.kTouchTap,self.onRuleButtonTap,self);
  self.armature:addChild(self.number_descb0);

  self.deploy_button=Button.new(armature:findChildArmature("common_copy_greenroundbutton"),false);
  self.deploy_button.bone:initTextFieldWithString("common_copy_greenroundbutton","部署");
  self.deploy_button:addEventListener(Events.kStart,self.onDeployButtonTap,self);

  self.look_in_button=Button.new(armature:findChildArmature("common_copy_blueround_button"),false);
  self.look_in_button.bone:initTextFieldWithString("common_copy_blueround_button","查看");
  self.look_in_button:addEventListener(Events.kStart,self.onLookInButtonTap,self);

  self.sign_in_button=Button.new(armature:findChildArmature("green_button"),false);
  self.sign_in_button.bone:initTextFieldWithString("green_button","报名");
  self.sign_in_button:addEventListener(Events.kStart,self.onSignInButtonTap,self);
end

--移除
function PossessionSignUI:onCloseButtonTap(event)
  self.parent_container:onCloseButtonTap(event);
end

function PossessionSignUI:onRefreshTime()
  self.time_bg:setString("剩余报名时间 " .. self.refreshTime:getTimeStr());
  if self.parent_container.deployUI then
    self.parent_container.deployUI:setTimeString(self.refreshTime:getTimeStr());
  end
end

function PossessionSignUI:onImageBegin(event)
  local s;
  for k,v in pairs(self.imgs) do
    if checkTouched(v,event.globalPosition) then
      s=k;
      break;
    end
  end
  if s then
    self:onImageSelected(s);
  end
end

function PossessionSignUI:onImageSelected(s)
  if 5==s then
    return;
  end
  if self.selected then
    self.img_fgs[self.selected]:setVisible(false);
  end
  self.selected=s;
  self.img_fgs[self.selected]:setVisible(true);

  local mapInfo=self:getMapInfo(self.selected);
  local normal_data=self.familyProxy:getNormalData();
  self.sign_in_tip_fg:setString(analysis("Jiazu_Lingdizhanbaoming",mapInfo.MapId,"name"));
  self.winner_descb:setString("<content><font color='#FF7E00'>上周领主   </font><font color='#FFFFFF'>" .. (""==mapInfo.FamilyName and "无" or mapInfo.FamilyName) .. "</font></content>");
  local lv=analysis("Jiazu_Lingdizhanbaoming",mapInfo.MapId,"lv");
  self.family_level_not_enough=normal_data.FamilyLevel<lv;
  self.level_descb:setString("<content><font color='#E1D2A0'>报名权限   </font><font color='#FFFFFF'>家族</font><font color='#" .. (self.family_level_not_enough and "FF0000" or "00FF00") .. "'>" .. lv .. "</font><font color='#FFFFFF'>级</font></content>");
  local cost=analysis("Jiazu_Lingdizhanbaoming",mapInfo.MapId,"cost");
  self.family_cost_not_enough=normal_data.Silver<cost;
  self.cost_descb:setString("<content><font color='#E1D2A0'>报名费用   </font><font color='#FFFFFF'>家族资金</font><font color='#" .. (self.family_cost_not_enough and "FF0000" or "00FF00") .. "'>" .. cost .. "</font></content>");
  self.number_descb:setString("<content><font color='#E1D2A0'>已报家族   </font><font color='#FFFFFF'>" .. mapInfo.Count .. "/" .. self.const_max_sign_in .. "</font></content>");
  self.bonus_descb:setString(analysis("Jiazu_Lingdizhanbaoming",mapInfo.MapId,"describe"));

  self.sign_in_button:getDisplay():setVisible(0==mapInfo.BooleanValue);
end

function PossessionSignUI:onDeployButtonTap(event)
  if 1==self:getMapInfo(self.selected).BooleanValue then

  elseif self.family_level_not_enough or self.family_cost_not_enough then
    sharedTextAnimateReward():animateStartByString("不符合报名条件哦~");
    return;
  end
  self.parent_container:addDeployUI(self:getMapInfo(self.selected).MapId,not self.userProxy:getIsFamilyLeader());
end

function PossessionSignUI:onLookInButtonTap(event)
  self:onSignInButtonTap(event);
end

function PossessionSignUI:onSignInButtonTap(event)
  if not self.userProxy:getIsFamilyLeader() then
    sharedTextAnimateReward():animateStartByString("只有族长才有操作权限哦~");
    return;
  end
  if 0==self:getMapInfo(self.selected).BooleanValue then
    if not self.userProxy:getIsFamilyLeader() then
      sharedTextAnimateReward():animateStartByString("只有族长才有报名权限哦~");
      return;
    end
    if self.family_level_not_enough then
      sharedTextAnimateReward():animateStartByString("家族等级不足哦~");
      return;
    elseif self.family_cost_not_enough then
      sharedTextAnimateReward():animateStartByString("家族资金不足哦~");
      return;
    end
  end
  if 1==self:getMapInfo(self.selected).BooleanValue2 then
    self.parent_container:addPosUI(self:getMapInfo(self.selected).MapId);
    return;
  end
  self.toDeployBySignIn=true;
  self:onDeployButtonTap(event);
  sharedTextAnimateReward():animateStartByString("还没有部署军队哦~");
end

function PossessionSignUI:onRuleButtonTap(event)
  local possessionRuleUI=PossessionRuleUI.new();
  possessionRuleUI:initialize(self.skeleton);
  self:addChild(possessionRuleUI);
end

function PossessionSignUI:refreshStage(data)
  self.data=data;

  self:disposeRefreshTime();
  self.refreshTime=RefreshTime.new();
  self.refreshTime:initTime(self.data.RemainSeconds,self.onRefreshTime,self);
  self:onRefreshTime();

  self:onImageSelected(self.selected and self.selected or 1);
  self:refreshSignedImg();
end

function PossessionSignUI:refreshSignedImg()
  for k,v in pairs(self.data.MapInfoArray) do
    if 1==v.BooleanValue then
      if not self.signed_imgs[v.MapId] then
        self.signed_imgs[v.MapId]=self.skeleton:getBoneTextureDisplay("signed_img");
        self.signed_imgs[v.MapId].touchEnabled=false;
        self.signed_imgs[v.MapId]:setPosition(self.armature:getChildByName("sign_pos_" .. v.MapId):getPosition());
      end
      self.armature:addChild(self.signed_imgs[v.MapId]);
    else
      if self.signed_imgs[v.MapId] then
        self.armature:removeChild(self.signed_imgs[v.MapId]);
        self.signed_imgs[v.MapId]=nil;
      end
    end
  end
end

function PossessionSignUI:refreshDeployConfirmed(mapID)
  local a;
  if 0==self:getMapInfo(mapID).BooleanValue2 and self.toSignInByDeploy then
    a=true;
  end
  self:getMapInfo(mapID).BooleanValue2=1;
  self.toSignInByDeploy=nil;
  if a then
    self:onSignInButtonTap();
  end
end

function PossessionSignUI:refreshSetPosConfirmed(data)
  --MapId,ApplyFamilyWarInfoArray
  for k,v in pairs(data.ApplyFamilyWarInfoArray) do
    if 0~=self.userProxy:getFamilyID() and self.userProxy:getFamilyID()==v.FamilyId then
      local mapInfoData=self:getMapInfo(data.MapId);
      if 0~=self.userProxy:getFamilyID() and self.userProxy:getFamilyID()==v.FamilyId then
        mapInfoData.BooleanValue=1;
      end
      self:onImageSelected(self.selected and self.selected or 1);
      self:refreshSignedImg();
      return;
    end
  end
end

function PossessionSignUI:refreshFamilyNewInfo()
  self:onImageSelected(self.selected and self.selected or 1);
end

function PossessionSignUI:refreshSignCount(data)
  self:getMapInfo(data.MapId).Count=data.Count;
  self:onImageSelected(self.selected and self.selected or 1);
end

function PossessionSignUI:getMapInfo(id)
  if self.data then
    for k,v in pairs(self.data.MapInfoArray) do
      if id==v.MapId then
        return v;
      end
    end
  end
end