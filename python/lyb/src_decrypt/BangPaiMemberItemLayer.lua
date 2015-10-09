BangPaiMemberItemLayer=class(ListScrollViewLayerItem);

function BangPaiMemberItemLayer:ctor()
  self.class=BangPaiMemberItemLayer;
end

function BangPaiMemberItemLayer:dispose()
  self.context:removeButtonSelector();
  self:removeAllEventListeners();
  self:removeChildren();
	BangPaiMemberItemLayer.superclass.dispose(self);

  if self.armature4dispose then
    self.armature4dispose:dispose();
  end
end

--
function BangPaiMemberItemLayer:initialize(context, data)
  self:initLayer();
  self.context=context;
  self.data = data;
  self.skeleton=self.context.skeleton;
  self.familyProxy=self.context.familyProxy;
  self.userProxy=self.context.userProxy;
  self.bagProxy=self.context.bagProxy;
  self.userCurrencyProxy=self.context.userCurrencyProxy;
end

function BangPaiMemberItemLayer:onInitialize()
  --骨骼
  local armature=self.skeleton:buildArmature("bangpai_member_item");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);
  self.armature:setPositionY(3);


  --title_1
  local text_data=armature:getBone("player_bg").textData;
  self.player_bg=createAutosizeMultiColoredLabelWithTextData(text_data,"");
  self.armature:addChild(self.player_bg);print("BangPaiMemberItemLayer--->",self.data.FamilyPositionId,self.data.UserId);
  self.player_bg:addEventListener(DisplayEvents.kTouchTap,self.onNameTap,self,self.data);

  text_data=armature:getBone("level_descb").textData;
  self.level_descb=createTextFieldWithTextData(text_data,"");
  self.armature:addChild(self.level_descb);

  text_data=armature:getBone("zhiwei_descb").textData;
  self.zhiwei_descb=createTextFieldWithTextData(text_data,"");
  self.armature:addChild(self.zhiwei_descb);

  text_data=armature:getBone("huoyuei_descb").textData;
  self.huoyuei_descb=createTextFieldWithTextData(text_data,"");
  self.armature:addChild(self.huoyuei_descb);

  text_data=armature:getBone("zhanli_descb").textData;
  self.zhanli_descb=createTextFieldWithTextData(text_data,"");
  self.armature:addChild(self.zhanli_descb);

  text_data=armature:getBone("shijian_descb").textData;
  self.shijian_descb=createTextFieldWithTextData(text_data,"");
  self.armature:addChild(self.shijian_descb);

  self:refresh();
end

function BangPaiMemberItemLayer:refresh()
  if not self.isInitialized then
   --  return;
    self.isInitialized = true;
    self:onInitialize();
  end
  local configID = self.data.ConfigId;
  if configID then
    local img = Image.new();
    img:loadByArtID(analysis("Zhujiao_Huanhua",configID,"head"));
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
        print(self.data.Vip);
        local vipLevelIcon = CommonSkeleton:getCommonBoneTextureDisplay("commonNumbers/common_mainui_vip" .. self.data.Vip);
        vipLevelIcon:setScale(0.76);
        vipLevelIcon:setPositionXY(62,61);
        self.armature:addChild(vipLevelIcon);
      end
    end
  end

  self:refreshUserName();
  self.level_descb:setString("Lv." .. self.data.Level);
  self.huoyuei_descb:setString(self.data.Huoyuedu);
  self.zhanli_descb:setString(self.data.Zhanli);
  local time=getTimeServer()-self.data.Time;
  local s = "0分钟前"
  if 3600>time then
    s=math.floor(time/60) .. "分钟前";
  elseif 86400>time then
    s=math.floor(time/3600) .. "小时前";
  else
    s=math.floor(time/86400) .. "天前";
  end
  self.shijian_descb:setString(s);
end

function BangPaiMemberItemLayer:refreshUserName()
  if self.context.userProxy:getUserID() ~= self.data.UserId
     -- and (
     --  (self.context.userProxy:getHasQuanxian(4) and (2<tonumber(self.data.FamilyPositionId)))
     --  or (self.context.userProxy:getHasQuanxian(6) and (1 == tonumber(self.data.FamilyPositionId)))
     --  or ((3 > tonumber(self.data.FamilyPositionId)) and self.context.userProxy:getHasQuanxian(9))
     --  or ((2 < tonumber(self.data.FamilyPositionId)) and self.context.userProxy:getHasQuanxian(7)))
      then
    self.player_bg:setString("<content><font color = '#FFB400' ref = '1'>" .. self.data.UserName .. "</font></content>");
  else
    self.player_bg:setString("<content><font color = '#FFFFFF'>" .. self.data.UserName .. "</font></content>");
  end
  self.zhiwei_descb:setString(analysis("Bangpai_Zhiweidengjibiao",self.data.FamilyPositionId,"name"));
end

function BangPaiMemberItemLayer:refreshFamilyMemeberPositionID(userID, positionID)
  if not self.isInitialized then
    self.isInitialized = true;
    self:onInitialize();
    -- return;
  end
  self.data.FamilyPositionId = positionID;
  self:refreshUserName();
end

function BangPaiMemberItemLayer:onNameTap(event, data)
  local function onTisheng()
    if 2 == -1 + data.FamilyPositionId then
      local count = analysis("Bangpai_Jiazushengjibiao",self.context.bangpaiLayer.familyInfo.FamilyLevel,"number");
      local i = 0;
      for k,v in pairs(self.context.bangpaiLayer.familyInfo.MemberArray) do
        if 2 == v.FamilyPositionId then
          i = 1 + i;
        end
      end
      if count <= i then
        sharedTextAnimateReward():animateStartByString("副帮主人数超出了哦~");
        return;
      end
    end
    -- initializeSmallLoading();
    sendMessage(27,9,{UserId = data.UserId, FamilyPositionId = -1 + data.FamilyPositionId});
    sharedTextAnimateReward():animateStartByString("提升职位成功~");
  end
  local function onJiangdi()
    -- initializeSmallLoading();
    sendMessage(27,9,{UserId = data.UserId, FamilyPositionId = 1 + data.FamilyPositionId});
    sharedTextAnimateReward():animateStartByString("你给他降职了哦~");
  end
  local function onTanhe()
    self.context.bangpaiLayer:onTanhe();
    -- initializeSmallLoading();
    -- sendMessage(27,17);
  end
  local function onKaichuConfirm()
    initializeSmallLoading();
    print(data.UserId);
    sendMessage(27,15,{UserId = data.UserId});
  end
  local function onKaichu()
    if 2 == data.FamilyPositionId then
      sharedTextAnimateReward():animateStartByString("不可以直接开除副帮主,需要先降职~");
      return;
    end
    
    local pop = CommonPopup.new();
    pop:initialize("真的要开除Ta吗?",nil,onKaichuConfirm);
    self.context:addChild(pop);
  end
  local function onShanweiConfirm()
    initializeSmallLoading();
    print(data.UserId);
    sendMessage(27,42,{UserId = data.UserId});
  end
  local function onShanwei()
    local pop = CommonPopup.new();
    pop:initialize("真的要禅位给Ta吗?",nil,onShanweiConfirm);
    self.context:addChild(pop);
  end

  if self.context.userProxy:getUserID() == data.UserId then
    return;
  end

  local function onLookIntoUser()
    initializeSmallLoading();
    sendMessage(3,11,{UserId=data.UserId,UserName=data.UserName});
  end
  local function onAddBuddy()
    if getBuddyValid(data.UserId, data.UserName) then
      sendMessage(21,4,{UserId=data.UserId,UserName=data.UserName});
      -- sharedTextAnimateReward():animateStartByString("加为好友请求已发出 ~");
    end
  end
  local function onDeleteBuddyConfirm()
    initializeSmallLoading();
    sendMessage(21,3,{UserId=data.UserId,UserName=data.UserName});
  end
  local function onDeleteBuddy()
    local tips=CommonPopup.new();
    tips:initialize("确定删除好友吗?",nil,onDeleteBuddyConfirm,nil,nil,nil,nil,nil,nil,true);
    commonAddToScene(tips, true)
  end

  local texts = {};
  local funcs = {};
  --提升 降低 弹劾 开除
  if self.context.userProxy:getHasQuanxian(4) and 2<data.FamilyPositionId then
    table.insert(texts,"开 除");
    table.insert(funcs,onKaichu);
  end
  if self.context.userProxy:getHasQuanxian(6) and 1 == data.FamilyPositionId then
    table.insert(texts,"弹 劾");
    table.insert(funcs,onTanhe);
  end
  if 3 > data.FamilyPositionId and self.context.userProxy:getHasQuanxian(9) then
    table.insert(texts,"降 职");
    table.insert(funcs,onJiangdi);
  end
  if 2 < data.FamilyPositionId and self.context.userProxy:getHasQuanxian(7) then
    table.insert(texts,"提 升");
    table.insert(funcs,onTisheng);
  end
  if self.context.userProxy:getHasQuanxian(10) then
    table.insert(texts,"禅 位");
    table.insert(funcs,onShanwei);
  end

  if self.context.buddyListProxy:getIsHaoyou(data.UserId) then
    table.insert(texts,"删好友");
    table.insert(funcs,onDeleteBuddy);
  else
    table.insert(texts,"加好友");
    table.insert(funcs,onAddBuddy);
  end
  table.insert(texts,"查 看");
  table.insert(funcs,onLookIntoUser);

  if 0 == table.getn(texts) then
    return;
  end
  local texts_temp = {};
  local funcs_temp = {};
  for k,v in pairs(texts) do
    table.insert(texts_temp,1,v);
    table.insert(funcs_temp,1,funcs[k]);
  end
  texts = texts_temp;
  funcs = funcs_temp;
  for k,v in pairs(texts) do
    log(v);
  end
  local buttonsSelector=ButtonsSelector.new();
  buttonsSelector:initialize(funcs,texts);
  buttonsSelector:setPos(event.globalPosition);
  self.context:addChild(buttonsSelector);
  self.context.buttonsSelector = buttonsSelector;
end