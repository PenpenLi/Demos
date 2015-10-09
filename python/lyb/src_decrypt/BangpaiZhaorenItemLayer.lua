BangpaiZhaorenItemLayer=class(TouchLayer);

function BangpaiZhaorenItemLayer:ctor()
  self.class=BangpaiZhaorenItemLayer;
end

function BangpaiZhaorenItemLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	BangpaiZhaorenItemLayer.superclass.dispose(self);

  self.armature4dispose:dispose();
end

--
function BangpaiZhaorenItemLayer:initialize(context, container, data)
  self:initLayer();
  self.context=context;
  self.container = container;
  self.data = data;
  self.skeleton=self.context.skeleton;
  self.familyProxy=self.context.familyProxy;
  self.userProxy=self.context.userProxy;
  self.bagProxy=self.context.bagProxy;
  self.userCurrencyProxy=self.context.userCurrencyProxy;
  
  --骨骼
  local armature=self.skeleton:buildArmature("bangpai_zhaoren_item");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);
  self.armature:setPositionY(3);


  --title_1
  local text_data=armature:getBone("player_bg").textData;
  self.player_bg=createTextFieldWithTextData(text_data,"");
  self.armature:addChild(self.player_bg);

  text_data=armature:getBone("level_descb").textData;
  self.level_descb=createTextFieldWithTextData(text_data,"");
  self.armature:addChild(self.level_descb);

  text_data=armature:getBone("paiming_descb").textData;
  self.paiming_descb=createTextFieldWithTextData(text_data,"");
  self.armature:addChild(self.paiming_descb);

  --查找家族
  local button=self.armature:getChildByName("jujue_btn");
  local button_pos=convertBone2LB4Button(button);
  self.armature:removeChild(button);

  button=CommonButton.new();
  button:initialize("commonButtons/common_small_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
  --button:initializeText(trimButtonData,"整理背包");
  button:initializeBMText("忽略","anniutuzi");
  button:setPosition(button_pos);
  button:addEventListener(DisplayEvents.kTouchTap,self.onJujueButtonTap,self);
  self:addChild(button);

  --创建家族
  local button=self.armature:getChildByName("tongyi_btn");
  local button_pos=convertBone2LB4Button(button);
  self.armature:removeChild(button);

  button=CommonButton.new();
  button:initialize("commonButtons/common_small_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
  --button:initializeText(trimButtonData,"整理背包");
  button:initializeBMText("同意","anniutuzi");
  button:setPosition(button_pos);
  button:addEventListener(DisplayEvents.kTouchTap,self.onTongyiButtonTap,self);
  self:addChild(button);

  self:refresh();
end

function BangpaiZhaorenItemLayer:onJujueButtonTap(event)
  sendMessage(27,6,{UserId = self.data.UserId, BooleanValue = 0});
  self.container:deleteItem(self.data.UserId);
end

function BangpaiZhaorenItemLayer:onTongyiButtonTap(event)
  if self.context.bangpaiLayer.familyInfo.Count >= analysis("Bangpai_Jiazushengjibiao",self.context.bangpaiLayer.familyInfo.FamilyLevel,"renshu") then
    sharedTextAnimateReward():animateStartByString("帮派人数已满哦~");
    return;
  end
  sendMessage(27,6,{UserId = self.data.UserId, BooleanValue = 1});
  self.container:deleteItem(self.data.UserId);
end

function BangpaiZhaorenItemLayer:refresh()
  local configID = self.data.ConfigId;
  if configID then
    local img = Image.new();
    img:loadByArtID(analysis("Zhujiao_Zhujiaozhiye",configID,"art3"));
    img:setScale(0.76);
    img:setPositionXY(19,13);
    self.armature:addChild(img);

    if self.data.Vip and 0 < self.data.Vip then
      local vip_img = CommonSkeleton:getBoneTextureDisplay("commonNumbers/common_mainui_vip");
      vip_img:setScale(0.76);
      vip_img:setPositionXY(5,50);
      self.armature:addChild(vip_img);

      if 10 <= self.data.Vip then
        local low = self.data.Vip%10;
        local high = math.floor(self.data.Vip/10);
        local highVipLevelIcon = CommonSkeleton:getCommonBoneTextureDisplay("commonNumbers/common_mainui_vip" .. high);
        highVipLevelIcon:setScale(0.76);
        highVipLevelIcon:setPositionXY(62,61)
        self.armature:addChild(highVipLevelIcon);

        local vipLevelIcon = CommonSkeleton:getCommonBoneTextureDisplay("commonNumbers/common_mainui_vip" .. low);
        vipLevelIcon:setScale(0.76);
        vipLevelIcon:setPositionXY(77,61)
        self.armature:addChild(vipLevelIcon);
      else
        local vipLevelIcon = CommonSkeleton:getCommonBoneTextureDisplay("commonNumbers/common_mainui_vip" .. self.data.Vip);
        vipLevelIcon:setScale(0.76);
        vipLevelIcon:setPositionXY(62,61);
        self.armature:addChild(vipLevelIcon);
      end
    end
  end
  self.player_bg:setString(self.data.UserName);
  self.level_descb:setString("Lv." .. self.data.Level);
  self.paiming_descb:setString(self.data.Ranking);
end