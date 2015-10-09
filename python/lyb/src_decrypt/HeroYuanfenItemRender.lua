HeroYuanfenItemRender=class(Layer);

function HeroYuanfenItemRender:ctor()
  self.class=HeroYuanfenItemRender;
end

function HeroYuanfenItemRender:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  HeroYuanfenItemRender.superclass.dispose(self);
  self.armature4dispose:dispose();
end

function HeroYuanfenItemRender:initialize(context, container, generalId, data)
  self:initLayer();
  self.context = context;
  self.container = container;
  self.skeleton = self.context.skeleton;
  self.generalId = generalId;
  self.data = data;
  self.text_fields = {};
  self.right_imgs = {};
  self.isJihuo = self.context.heroHouseProxy:getIsYuanfenJihuo(self.generalId,self.data.id);

  local armature=self.skeleton:buildArmature("heroProRender/heroYuanfenItemRender");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  local bg = CommonPanelSkeleton:getBoneTextureDisplay("commonPanels/common_item_bg_2");
  bg:setScaleX(443/443);
  bg:setScaleY(212/167);
  self.armature:addChildAt(bg,0);

  local yuanfen_data = analysisWithCache("Kapaiyuanfen_Kapaiyuanfen",data.id);--yuanfen_data.yfname="缘分名字";yuanfen_data.require = "1,2,3,4";
  local yuanfen_level = self.context.heroHouseProxy:getYuanfenLevel(self.generalId,data.id);
  local text = yuanfen_data.yfname;
  self.descb_1 = createTextFieldWithTextData(armature:getBone("descb_1").textData,text);
  self.armature:addChild(self.descb_1);

  text = "收集以下英雄,不需上阵";
  self.descb_2 = createTextFieldWithTextData(armature:getBone("descb_2").textData,text);
  self.armature:addChild(self.descb_2);

  
  print("????????????",yuanfen_level);
  local shengji_data = analysis2key("Kapaiyuanfen_Yuanfenshengji","yfId",data.id,"level", yuanfen_level);

  local effect = StringUtils:stuff_string_split(shengji_data.effect);
  text = "";
  for k,v in pairs(effect) do
    --if self.isJihuo then
      text = text .. "<font color='#57290F'>" .. analysis("Shuxing_Shuju",v[1],"name") .. "</font>";
      text = text .. "<font color='#57290F'>  +" .. tonumber(v[2]) .. "</font>";
      text = text .. "<font color='#57290F'> ("  .. "Lv." .. yuanfen_level .. ")</font>";
    -- else
    --   text = text .. "<font color='#353333'>" .. analysis("Shuxing_Shuju",v[1],"name") .. "</font>";
    --   text = text .. "<font color='#353333'>  +" .. v[2] .. "</font>";
    -- end
  end
  text = "<content>" .. text .. "</content>";
  self.descb_3 = createAutosizeMultiColoredLabelWithTextData(armature:getBone("descb_3").textData,text);
  self.armature:addChild(self.descb_3);

  if ""~=yuanfen_data.require then
    req = StringUtils:lua_string_split(yuanfen_data.require,",");
    for k,v in pairs(req) do
      local bg = self.skeleton:getBoneTextureDisplay("touxiang_bg");
      bg:setScale(0.85);
      bg:setPositionXY(100*(-1+k)+32,22);
      self:addChild(bg);

      local img = Image.new();
      print(tonumber(v));
      img:loadByArtID(analysis("Kapai_Kapaiku",tonumber(v),"art3"));
      img:setScale(0.8);
      img:setPositionXY(100*(-1+k)+40,30);
      img:addEventListener(DisplayEvents.kTouchBegin, self.onTouxiangTap, self, self.context.heroHouseProxy:getGeneralDataByConfigID(tonumber(v)));
      self:addChild(img);

      if not self.context.heroHouseProxy:getGeneralDataByConfigID(tonumber(v)) then
        local mask = self.skeleton:getBoneTextureDisplay("touxiang_mask");
        local hunshi_id = analysis("Kapai_Kapaiku",tonumber(v),"soul");
        hunshi_id = StringUtils:lua_string_split(hunshi_id,",");
        hunshi_id = tonumber(hunshi_id[1]);
        mask:addEventListener(DisplayEvents.kTouchBegin, self.onTrack, self, {tonumber(v),hunshi_id});
        mask:setPositionXY(100*(-1+k)+40,30);
        self:addChild(mask);
      end
    end
  end

  local yijihuoImg = self.armature:getChildByName("upgradeBtn");
  SingleButton:create(yijihuoImg);
  self.armature:removeChild(yijihuoImg,false);
  self.armature:addChild(yijihuoImg);
  yijihuoImg:addEventListener(DisplayEvents.kTouchTap,self.onShengjiTap,self);
  self.yijihuoImg = yijihuoImg;

  self:refreshData();
end

function HeroYuanfenItemRender:refreshRedDot()
  local data = self.context.heroHouseProxy:getHongdianData(self.generalId);
  if data.Yuanfenable then
    for k,v in pairs(data.Yuanfenable) do
      if self.data.id == v then
        self.armature:getChildByName("effect"):setVisible(true);
        return;
      end
    end
  end
  self.armature:getChildByName("effect"):setVisible(false);
end

function HeroYuanfenItemRender:onTouxiangTap(event,data)
  if not data then return;end
  for k,v in pairs(data) do
    print(k,v);
  end
  function onLayerCallBack(event)
    if self.bg_layer then
      self.bg_layer.parent:removeChild(self.bg_layer);
      self.bg_layer = nil;
    end
    if self.scaleSlot then
      self.scaleSlot.parent:removeChild(self.scaleSlot);
      self.scaleSlot = nil;
    end
  end

  self.bg_layer = LayerColorBackGround:getTransBackGround();
  self.bg_layer:setPositionXY(-GameData.uiOffsetX,-GameData.uiOffsetY);
  self.bg_layer:addEventListener(DisplayEvents.kTouchBegin, onLayerCallBack);
  self.context:addChild(self.bg_layer);

  self.scaleSlot = HeroProScaleSlot.new();
  self.scaleSlot:initialize(self.context.skeleton, data, makePoint(288,292));
  self.scaleSlot:setScale(1.2);
  self.scaleSlot:addEventListener(DisplayEvents.kTouchBegin, onLayerCallBack);
  self.context:addChild(self.scaleSlot);
end

function HeroYuanfenItemRender:onTrack(event, data)
  local count = self.context.bagProxy:getItemNum(data[2]);
  local totalCount = analysis("Kapai_Kapaiku",data[1],"soul");
  totalCount = StringUtils:lua_string_split(totalCount,",");
  totalCount = tonumber(totalCount[2]);
  print("====");
  if 0 == analysis("Kapai_Kapaiku",data[1],"jiQi") then
    sharedTextAnimateReward():animateStartByString("此英雄暂未开放,敬请期待哦 ~");
    return;
  end
  self.context:dispatchEvent(Event.new(MainSceneNotifications.TO_TRACK_ITEM_UI_COMMAND,{itemId=data[2], count = count, totalCount = totalCount},self));
end

function HeroYuanfenItemRender:refreshData()
  uninitializeSmallLoading();
  if not self.context.yuanfHecDC then
    self.context.yuanfHecDC = {};
  end
  
  local isJihuo = self.context.heroHouseProxy:getIsYuanfenJihuo(self.generalId,self.data.id);
  local shengji_data = analysis2key("Kapaiyuanfen_Yuanfenshengji","yfId",self.data.id,"level",1+self.context.heroHouseProxy:getYuanfenLevel(self.generalId,self.data.id));
  -- local yijihuoImg = self.armature:getChildByName("yijihuoImg");
  -- yijihuoImg:setVisible(isJihuo);
  -- yijihuoImg.parent:removeChild(yijihuoImg,false);
  -- self.armature:addChild(yijihuoImg);
  if isJihuo then
    if shengji_data then
      self.yijihuoImg:setVisible(true);
      self.armature:getChildByName("yimanji_img"):setVisible(false);
    else
      self.yijihuoImg:setVisible(false);
      self.armature:getChildByName("yimanji_img"):setVisible(true);
    end
  else
    self.yijihuoImg:setVisible(false);
    self.armature:getChildByName("yimanji_img"):setVisible(false);
  end

  local weijihuoImg = self.armature:getChildByName("weijihuoImg");
  weijihuoImg:setVisible(not isJihuo);
  weijihuoImg.parent:removeChild(weijihuoImg,false);
  self.armature:addChild(weijihuoImg);

  if self.container.heroYuanfenShengjiRender then
    self.container.heroYuanfenShengjiRender:refreshData();
  end
  self:refreshRedDot();
end

function HeroYuanfenItemRender:onShengjiTap(event)
  self.container.heroYuanfenShengjiRender = HeroYuanfenShengjiRender.new();
  self.container.heroYuanfenShengjiRender:initialize(self.context,self,self.generalId,self.data.id);
  self.context:addChild(self.container.heroYuanfenShengjiRender);
  self.container.heroYuanfenShengjiRender:refreshData();
end



HeroYuanfenShengjiRender=class(Layer);

function HeroYuanfenShengjiRender:ctor()
  self.class = HeroYuanfenShengjiRender;
end

function HeroYuanfenShengjiRender:dispose()
  if self.bg.parent then
    self.bg.parent:removeChild(self.bg);
  end
  self.context.pageView:setMoveEnabled(true);
  self:removeAllEventListeners();
  self:removeChildren();
  HeroYuanfenShengjiRender.superclass.dispose(self);
end

function HeroYuanfenShengjiRender:initialize(context, container, generalId, id)
  self:initLayer();
  self.context = context;
  self.container = container;
  self.generalId = generalId;
  self.id = id;
  self.imgs = {};

  self.skeleton = self.context.skeleton;
  self:initLayer();

  self.bg = LayerColorBackGround:getTransBackGround();
  self.bg:setPositionXY(-GameData.uiOffsetX,-GameData.uiOffsetY);
  self.bg:addEventListener(DisplayEvents.kTouchTap,self.onClose,self);
  self.context:addChild(self.bg);

  --骨骼
  local armature=self.skeleton:buildArmature("yuanfen_render");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature=armature;
  self.armature.display:setPositionXY(350,150);
  self:addChild(self.armature.display);

  self.armature.display:getChildByName("huafei_descb"):setScale(0.7);
  self.titleTF = BitmapTextField.new("缘分升级","anniutuzi");--选择好友助战
  self.titleTF:setPositionXY(202,357);
  self.armature.display:addChild(self.titleTF);

  self.descb=createTextFieldWithTextData(armature:getBone("descb").textData,"消耗:");
  self.armature.display:addChild(self.descb);

  self.huafei_descb=createTextFieldWithTextData(armature:getBone("huafei_descb").textData,"");
  self.armature.display:addChild(self.huafei_descb);

  local button=self.armature.display:getChildByName("btn");
  local button_pos=convertBone2LB4Button(button);
  self.armature.display:removeChild(button);

  button=CommonButton.new();
  button:initialize("commonButtons/common_small_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
  button:initializeText(self.armature:findChildArmature("btn"):getBone("common_small_blue_button").textData,"升 级");
  --button:initializeBMText("进阶","anniutuzi");
  button:setPosition(button_pos);
  button:addEventListener(DisplayEvents.kTouchTap,self.onShengjiButtonTap,self);
  self.armature.display:addChild(button);
  self.context.pageView:setMoveEnabled(false);
end

function HeroYuanfenShengjiRender:onClose(event)
  self.parent:removeChild(self);
  self.container.container.heroYuanfenShengjiRender = nil;
end

function HeroYuanfenShengjiRender:refreshData()
  local yuanfen_level = self.context.heroHouseProxy:getYuanfenLevel(self.generalId,self.id);
  local name = analysis("Kapai_Kapaiku",self.context.heroHouseProxy:getGeneralData(self.generalId).ConfigId,"name");
  self.shengji_data = analysis2key("Kapaiyuanfen_Yuanfenshengji","yfId",self.id,"level", yuanfen_level);
  self.xiaoguo_data = analysis2key("Kapaiyuanfen_Yuanfenshengji","yfId",self.id,"level", 1 + yuanfen_level);
  if not self.xiaoguo_data then
    self:onClose();
    return;
  end
  local req_level = self.xiaoguo_data.HeroLevel;
  if req_level and "" == req_level then
    req_level = {};
  else
    req_level = StringUtils:stuff_string_split(req_level);
  end
  local req_star = self.xiaoguo_data.HeroStar;
  if req_star and "" == req_star then
    req_star = {};
  else
    req_star = StringUtils:stuff_string_split(req_star);
  end
  
  local req_color = self.xiaoguo_data.HeroColor;
  if req_color and "" == req_color then
    req_color = {};
  else
    req_color = StringUtils:stuff_string_split(req_color);
  end

  if self.content_layer then
    self.armature.display:removeChild(self.content_layer);
    self.content_layer = nil;
    self.imgs = {};
  end
  self.content_layer = Layer.new();
  self.content_layer:initLayer();
  self.armature.display:addChild(self.content_layer);

  -- local yuanfen_data = analysis("Kapaiyuanfen_Kapaiyuanfen",self.id);StringUtils:lua_string_split(yuanfen_data.require,",");
  local req = {};
  if req_level then
    for k,v in pairs(req_level) do
      if 0 ~= tonumber(v[1]) then
        table.insert(req,tonumber(v[1]));
      end
    end
  end
  if req_star then
    for k,v in pairs(req_star) do
      if 0 ~= tonumber(v[1]) then
        table.insert(req,tonumber(v[1]));
      end
    end
  end
  if req_color then
    for k,v in pairs(req_color) do
      if 0 ~= tonumber(v[1]) then
        table.insert(req,tonumber(v[1]));
      end
    end
  end

  for k,v in pairs(req) do
    local bg = self.skeleton:getBoneTextureDisplay("touxiang_bg");
    bg:setScale(0.85);
    bg:setPositionXY(123*(-1+k)+52,220);
    self.content_layer:addChild(bg);

    local img = Image.new();
    img:loadByArtID(analysis("Kapai_Kapaiku",tonumber(v),"art3"));
    img:setScale(0.8);
    img:setPositionXY(123*(-1+k)+60,228);
    -- img:addEventListener(DisplayEvents.kTouchBegin, self.onTouxiangTap, self, self.context.heroHouseProxy:getGeneralDataByConfigID(tonumber(v)));
    self.content_layer:addChild(img);

    table.insert(self.imgs,img);

    local textField=TextField.new(CCLabelTTF:create(analysis("Kapai_Kapaiku",tonumber(v),"name"),FontConstConfig.OUR_FONT,20));
    local sizeText=textField:getContentSize();
    textField:setColor(CommonUtils:ccc3FromUInt(2230529));
    textField:setPositionXY(-10+bg:getContentSize().width/2+bg:getPositionX()-sizeText.width/2,195);
    self.content_layer:addChild(textField);
  end

  
  self.condit_enough = true;

  local effect = StringUtils:lua_string_split(self.shengji_data.effect,",");
  local pre_name = analysis("Shuxing_Shuju",effect[1],"name");
  local textField=TextField.new(CCLabelTTF:create(name .. " " .. pre_name .. " +" .. tonumber(effect[2]),FontConstConfig.OUR_FONT,20));
  local pre_value = tonumber(effect[2]);
  local sizeText=textField:getContentSize();
  textField:setColor(CommonUtils:ccc3FromUInt(2230529));
  textField:setPositionXY(33,313);
  self.content_layer:addChild(textField);

  local levelUpArrow = self.armature.display:getChildByName("levelUpArrow");
  levelUpArrow:setPositionX(33+sizeText.width+10);

  effect = StringUtils:lua_string_split(self.xiaoguo_data.effect,",");
  local textField_1=TextField.new(CCLabelTTF:create("+" .. tonumber(effect[2]),FontConstConfig.OUR_FONT,20));
  self.value_increase_s = pre_name .. "增加" .. (tonumber(effect[2])-pre_value);
  textField_1:setColor(CommonUtils:ccc3FromUInt(2230529));
  textField_1:setPositionXY(levelUpArrow:getPositionX()+levelUpArrow:getContentSize().width+10,313);
  self.content_layer:addChild(textField_1);

  for k,v in pairs(self.imgs) do
    local pos_x = -10+v:getPositionX()+v:getContentSize().width/2;
    if req_level and k <= table.getn(req_level) then
      for k_,v_ in pairs(req_level) do
        if req[k] == tonumber(v_[1]) then
          local textField=TextField.new(CCLabelTTF:create("Lv." .. v_[2],FontConstConfig.OUR_FONT,20));
          local sizeText=textField:getContentSize();
          textField:setColor(CommonUtils:ccc3FromUInt(2230529));
          textField:setPositionXY(pos_x-sizeText.width/2,170);
          self.content_layer:addChild(textField);

          local bool = self.context.heroHouseProxy:getGeneralDataByConfigID(tonumber(v_[1])).Level >= tonumber(v_[2]);
          self.condit_enough = self.condit_enough and bool;
          if bool then
            local yuanfen_duihao = self.skeleton:getBoneTextureDisplay("yuanfen_duihao");
            yuanfen_duihao:setPositionXY(pos_x-50,210);
            self.content_layer:addChild(yuanfen_duihao);
          else
            local mask = self.skeleton:getBoneTextureDisplay("touxiang_mask");
            mask:setPositionXY(pos_x-35,225);
            self.content_layer:addChild(mask);
          end
          break;
        end
      end    

    elseif req_star and k <= (table.getn(req_star) + table.getn(req_level)) then
      for k_,v_ in pairs(req_star) do
        if req[k] == tonumber(v_[1]) then
          local star_layer = Layer.new();
          star_layer:initLayer();
          self.content_layer:addChild(star_layer);
          for i=1,tonumber(v_[2]) do
            local star = CommonSkeleton:getBoneTextureDisplay("commonImages/common_hero_star");
            star:setScale(0.3);
            star:setPositionX((-1+i)*22);
            star_layer:addChild(star);
          end
          local sizeText=star_layer:getGroupBounds().size;
          star_layer:setPositionXY(pos_x-sizeText.width/2,172);

          local bool = self.context.heroHouseProxy:getGeneralDataByConfigID(tonumber(v_[1])).StarLevel >= tonumber(v_[2]);
          self.condit_enough = self.condit_enough and bool;
          if bool then
            local yuanfen_duihao = self.skeleton:getBoneTextureDisplay("yuanfen_duihao");
            yuanfen_duihao:setPositionXY(pos_x-50,210);
            self.content_layer:addChild(yuanfen_duihao);
          else
            local mask = self.skeleton:getBoneTextureDisplay("touxiang_mask");
            mask:setPositionXY(pos_x-35,225);
            self.content_layer:addChild(mask);
          end
          break;
        end
      end

    elseif req_color and k <= (table.getn(req_star) + table.getn(req_level) + table.getn(req_color)) then
      for k_,v_ in pairs(req_color) do
        if req[k] == tonumber(v_[1]) then
          local textField=TextField.new(CCLabelTTFStroke:create(getColorStringByDaojuGrade(getSimpleGrade(tonumber(v_[2]))) .. getGradeName(tonumber(v_[2])),FontConstConfig.OUR_FONT,20,2,ccc3(0,0,0),CCSizeMake(35,20)));
          local sizeText=textField:getContentSize();
          textField:setColor(CommonUtils:ccc3FromUInt(getColorByQuality(getSimpleGrade(tonumber(v_[2])))));
          textField:setPositionXY(pos_x-sizeText.width/2,170);
          self.content_layer:addChild(textField);

          local bool = self.context.heroHouseProxy:getGeneralDataByConfigID(tonumber(v_[1])).Grade >= tonumber(v_[2]);
          self.condit_enough = self.condit_enough and bool;
          if bool then
            local yuanfen_duihao = self.skeleton:getBoneTextureDisplay("yuanfen_duihao");
            yuanfen_duihao:setPositionXY(pos_x-50,210);
            self.content_layer:addChild(yuanfen_duihao);
          else
            local mask = self.skeleton:getBoneTextureDisplay("touxiang_mask");
            mask:setPositionXY(pos_x-35,225);
            self.content_layer:addChild(mask);
          end
          break;
        end
      end
    end
  end

  self.stuff_is_enough = true;
  local costs = self.xiaoguo_data.cost;
  if costs and "" ~= costs then
    costs = StringUtils:stuff_string_split(costs);
    local costs_tmp = {};
    for k,v in pairs(costs) do
      if 0 ~= tonumber(v[2]) then
        table.insert(costs_tmp,v);
      end
    end
    costs = costs_tmp;
    for k,v in pairs(costs) do
      local bagCount = self.context.bagProxy:getItemNum(tonumber(v[1]));

      local bagItem = BagItem.new();
      bagItem:initialize({ItemId = tonumber(v[1]),Count = 1});
      bagItem:setBackgroundVisible(true);
      bagItem.touchEnable = true;
      bagItem.touchChildren = true;
      if 3 <= table.getn(costs) then
        bagItem:setPositionXY((-1+k)*95+105,52);
        bagItem:setScale(0.8);
      else
        bagItem:setPositionXY((-1+k)*125+105,42);
      end
      bagItem.bagHasCount = bagCount;
      bagItem.totalNeedCount = tonumber(v[2]);
      bagItem:addEventListener(DisplayEvents.kTouchTap,self.onBagItemTap,self,bagItem);

      self.content_layer:addChild(bagItem);

      local bagItemSize = bagItem:getGroupBounds().size;

      self.stuff_is_enough = self.stuff_is_enough and bagCount >= tonumber(v[2]);
      bagItem:setTextString(bagCount .. "/" .. v[2],CommonUtils:ccc3FromUInt(bagCount >= tonumber(v[2]) and 16710121 or 16711680));
    end
  else
    self.stuff_is_enough = false;
  end

  self:refreshBySilver();
end

function HeroYuanfenShengjiRender:refreshBySilver()
  self.huafei_descb:setString(convertMoney(self.xiaoguo_data.money));
  self.silver_is_enough = self.context.userCurrencyProxy:getSilver()>=self.xiaoguo_data.money;
  self.huafei_descb:setColor(CommonUtils:ccc3FromUInt(self.silver_is_enough and 6756622 or 16711680));
end

function HeroYuanfenShengjiRender:onShengjiButtonTap(event)
  if self.context.heroHouseProxy.Yuanfen_Jinjie_Bool then
    return;
  end
  if not self.silver_is_enough then
    sharedTextAnimateReward():animateStartByString("银两不足哦 ~");
    Facade:getInstance():sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_OPEN_HAND_OF_MIDAS_UI));
    return;
  end
  if not self.stuff_is_enough then
    sharedTextAnimateReward():animateStartByString("材料不足哦 ~");
    return;
  end
  if not self.condit_enough then
    sharedTextAnimateReward():animateStartByString("英雄条件不足哦 ~");
    return;
  end


  -- initializeSmallLoading();
  print(self.generalId,self.id);
  sendMessage(6,22,{GeneralId = self.generalId, ID = self.id});
  self.context.heroHouseProxy.Yuanfen_Jinjie_Bool = true;
  sharedTextAnimateReward():animateStartByString(self.value_increase_s);
end

function HeroYuanfenShengjiRender:onBagItemTap(event, bagItem)
  local tipBg=LayerColorBackGround:getOpacityBackGround();
  local layer=DetailLayer.new();
  local function closeTip(event)
    if tipBg.parent then
      tipBg.parent:removeChild(tipBg);
    end
    if layer.parent then
      layer.parent:removeChild(layer);
    end
  end
  tipBg:setPositionXY(-1 * GameData.uiOffsetX,-1 * GameData.uiOffsetY);
  tipBg:addEventListener(DisplayEvents.kTouchTap,closeTip);
  self.context.parent:addChild(tipBg);
  layer:initialize(self.context.bagProxy:getSkeleton(),bagItem,true,DetailLayerType.KUAI_SU_SUO_YIN,closeTip);
  local size=self.context:getContentSize();
  local popupSize=layer.armature.display:getChildByName("common_background_1"):getContentSize();
  layer:setPositionXY(math.floor((size.width-popupSize.width)/2),math.floor((size.height-popupSize.height)/2)-20);
  self.context.parent:addChild(layer);
end



HeroYuanfenRender=class(Layer);

function HeroYuanfenRender:ctor()
  self.class = HeroYuanfenRender;
end

function HeroYuanfenRender:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	HeroYuanfenRender.superclass.dispose(self);
end

function HeroYuanfenRender:initialize(context)
  self:initLayer();
  self.context = context;
  self.items = {};

  self:setPositionXY(676,26);
end

function HeroYuanfenRender:refreshData(generalId)
  self.generalId = generalId;

  if self.content then
    self.items = {};
    self:removeChild(self.content);
    self.content = nil;
  end
  self.content = Layer.new();
  self.content:initLayer();
  self:addChild(self.content);

  self.item_layer=ListScrollViewLayer.new();
  self.item_layer:initLayer();
  self.item_layer:setPosition(makePoint(0,0));
  self.item_layer:setViewSize(makeSize(443,530));
  self.item_layer:setItemSize(makeSize(443,217));
  self.content:addChild(self.item_layer);

  local datas = self.context.heroHouseProxy:getYuanfenData(self.generalId);
  for k,v in pairs(datas) do
    local item = HeroYuanfenItemRender.new();
    item:initialize(self.context,self,self.generalId,v);
    self.item_layer:addItem(item);
    table.insert(self.items, item);
  end
end

function HeroYuanfenRender:refreshRedDot()
  for k,v in pairs(self.items) do
    v:refreshRedDot();
  end
end