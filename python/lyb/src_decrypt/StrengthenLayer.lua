--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-3-13

	yanchuan.xie@happyelements.com
]]

require "core.events.DisplayEvent";

StrengthenLayer=class(Layer);

function StrengthenLayer:ctor()
  self.class=StrengthenLayer;
end

function StrengthenLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	StrengthenPopup.superclass.dispose(self);
  self.removeArmature:dispose();
end

function StrengthenLayer:initialize(skeleton, context, onDegrade, onStrengthen, onStrengthenMax, userCurrencyProxy, generalListProxy)
  self:initLayer();
  
  self.skeleton=skeleton;
  self.context=context;
  self.onDegrade=onDegrade;
  self.onStrengthen=onStrengthen;
  self.onStrengthenMax=onStrengthenMax;
  self.userCurrencyProxy=userCurrencyProxy;
  self.generalListProxy=generalListProxy;
  self.userProxy=self.context.userProxy;

  local a=0;
  while 10>a do
    a=1+a;
    if 0<analysis("Huiyuan_Huiyuantequan",22,"vip" .. a) then
      break;
    end
  end
  self.const_strengthen_level_up_max_vip=a;
  self:initializeUI(skeleton);
end

function StrengthenLayer:initializeUI(skeleton)  
  local armature=skeleton:buildArmature("strength_panel");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.removeArmature = armature;
  self.strengthen_level_text_data=armature:getBone("strengthen_level").textData;
  self.strengthen_level_descb_text_data=armature:getBone("strengthen_level_descb").textData;
  self.strengthen_next_level_descb_text_data=armature:getBone("strengthen_level_descb0").textData;

  self.strengthen_prop_name_descb_text_data=armature:getBone("strengthen_prop_name_descb").textData;
  self.strengthen_prop_descb_text_data=armature:getBone("strengthen_prop_descb").textData;
  self.strengthen_prop_descb_1_text_data=armature:getBone("strengthen_prop_descb_1").textData;

  --self.strengthen_add_text_data=armature:getBone("strengthen_add").textData;
  --self.strengthen_add_descb_text_data=armature:getBone("strengthen_add_descb").textData;

  --self.max_prop_text_data=armature:getBone("max_prop").textData;

  self.strengthen_cost_text_data=armature:getBone("strengthen_cost").textData;
  self.strengthen_cost_descb_text_data=armature:getBone("strengthen_cost_descb").textData;

  --self.strengthen_vip_descb_text_data=armature:getBone("strengthen_vip_descb").textData;
  --self.max_level_descb_text_data=armature:getBone("max_level_descb").textData;

  self.vip_descb_text_data=armature:getBone("vip_descb").textData;

  self.button_text_data=armature:findChildArmature("common_copy_blueround_button"):getBone("common_copy_blueround_button").textData;
  self.button_text_data=copyTable(self.button_text_data);
  -- self.button_text_data.y=-3+self.button_text_data.y;
  -- self.button_text_data.size=20;

  armature=armature.display;
  self:addChild(armature);
  self.armature=armature;
  --self.common_up=armature:getChildByName("strengthen_add_descb");

  --common_copy_bigBackground_bg
  -- armature:removeChild(armature:getChildByName("common_copy_bigBackground_bg"));
  
  --common_copy_greenroundbutton
  local common_copy_greenroundbutton=armature:getChildByName("common_copy_blueround_button");
  local common_copy_greenroundbutton_pos=convertBone2LB4Button(common_copy_greenroundbutton);--common_copy_greenroundbutton:getPosition();
  armature:removeChild(common_copy_greenroundbutton);

  --common_copy_greenroundbutton_1
  local common_copy_greenroundbutton_1=armature:getChildByName("common_copy_blueround_button_1");
  local common_copy_greenroundbutton_1_pos=convertBone2LB4Button(common_copy_greenroundbutton_1);--common_copy_greenroundbutton:getPosition();
  armature:removeChild(common_copy_greenroundbutton_1);
  
  --common_copy_blueround_button
  local common_copy_blueround_button=armature:getChildByName("common_copy_blueround_button0");
  local common_copy_blueround_button_pos=convertBone2LB4Button(common_copy_blueround_button);--common_copy_blueround_button:getPosition();
  armature:removeChild(common_copy_blueround_button);
  
  --strengthen_level
  local text="强化等级";
  self.strengthen_level=createTextFieldWithTextData(self.strengthen_level_text_data,text);
  armature:addChild(self.strengthen_level);
  --strengthen_level_descb
  text="";
  self.strengthen_level_descb=createTextFieldWithTextData(self.strengthen_level_descb_text_data,text);
  armature:addChild(self.strengthen_level_descb);
  text="";
  self.strengthen_next_level_descb=createTextFieldWithTextData(self.strengthen_next_level_descb_text_data,text);
  armature:addChild(self.strengthen_next_level_descb);

  --strengthen_prop_name_descb
  text="强化属性";
  self.strengthen_prop_name_descb=createTextFieldWithTextData(self.strengthen_prop_name_descb_text_data,text);
  armature:addChild(self.strengthen_prop_name_descb);
  --strengthen_prop_descb
  text="";
  self.strengthen_prop_descb=createTextFieldWithTextData(self.strengthen_prop_descb_text_data,text);
  armature:addChild(self.strengthen_prop_descb);

  text="";
  self.strengthen_prop_descb_1=createTextFieldWithTextData(self.strengthen_prop_descb_1_text_data,text);
  armature:addChild(self.strengthen_prop_descb_1);
  
  --strengthen_add
  --text="随机效果";
  --self.strengthen_add=createTextFieldWithTextData(self.strengthen_add_text_data,text);
  --armature:addChild(self.strengthen_add);
  --strengthen_add_descb
  --text="";
  --self.strengthen_add_descb=createTextFieldWithTextData(self.strengthen_add_descb_text_data,text);
  --armature:addChild(self.strengthen_add_descb);

  --max_prop
  --text="";
  --self.max_prop=createAutosizeMultiColoredLabelWithTextData(self.max_prop_text_data,text);
  --armature:addChild(self.max_prop);
  
  --strengthen_cost
  text="强化费用";
  self.strengthen_cost=createTextFieldWithTextData(self.strengthen_cost_text_data,text);
  armature:addChild(self.strengthen_cost);
  --strengthen_cost_descb
  text="";
  self.strengthen_cost_descb=createTextFieldWithTextData(self.strengthen_cost_descb_text_data,text);
  armature:addChild(self.strengthen_cost_descb);

  --vip_descb
  text="VIP" .. self.const_strengthen_level_up_max_vip;
  self.vip_descb=createTextFieldWithTextData(self.vip_descb_text_data,text);
  armature:addChild(self.vip_descb);

  --strengthen_vip_descb
  -- if 0<self.userProxy:getVipLevel() then
  --   local viplv=self.context.userProxy:getVipLevel();
  --   vipv=analysis("Huiyuan_Huiyuantequan",5,"vip" .. viplv);
  --   text='<content><font color="#FEDD00">亲是VIP' .. viplv .. ',增加了' .. math.floor(vipv/40*100) .. '%强化效果呢</font></content>';
  -- else
  --   text='<content><font color="#FEDD00">VIP </font><font color="#FFFFFF">最高可增加25%强化效果呢</font></content>';
  -- end
  -- self.strengthen_vip_descb=createMultiColoredLabelWithTextData(self.strengthen_vip_descb_text_data,text);
  -- armature:addChild(self.strengthen_vip_descb);

  --max_level_descb
  --text="";
  --self.max_level_descb=createTextFieldWithTextData(self.max_level_descb_text_data,text);
  --armature:addChild(self.max_level_descb);
  
  --降级
  common_copy_greenroundbutton=CommonButton.new();
  common_copy_greenroundbutton:initialize("common_blueround_button_normal","common_blueround_button_down",CommonButtonTouchable.BUTTON);
  common_copy_greenroundbutton:initializeText(self.button_text_data,"降级");
  common_copy_greenroundbutton:setPosition(common_copy_greenroundbutton_pos);
  common_copy_greenroundbutton:addEventListener(DisplayEvents.kTouchTap,self.onDegradeTouchTap,self);
  self:addChild(common_copy_greenroundbutton);

  --强化
  common_copy_greenroundbutton=CommonButton.new();
  common_copy_greenroundbutton:initialize("common_blueround_button_normal","common_blueround_button_down",CommonButtonTouchable.BUTTON);
  common_copy_greenroundbutton:initializeText(self.button_text_data,"强化");
  common_copy_greenroundbutton:setPosition(common_copy_greenroundbutton_1_pos);
  common_copy_greenroundbutton:addEventListener(DisplayEvents.kTouchTap,self.onLevelupTouchTap,self);
  self:addChild(common_copy_greenroundbutton);
  
  --一键强化
  common_copy_greenroundbutton=CommonButton.new();
  common_copy_greenroundbutton:initialize("common_bluelonground_button_normal","common_bluelonground_button_down",CommonButtonTouchable.BUTTON);
  common_copy_greenroundbutton:setPosition(common_copy_blueround_button_pos);
  common_copy_greenroundbutton:addEventListener(DisplayEvents.kTouchTap,self.onLevelupMaxTouchTap,self);
  self:addChild(common_copy_greenroundbutton);
  local strengthen2max_img=armature:getChildByName("strengthen2max_img");
  strengthen2max_img.touchEnabled=false;
  self:addChild(strengthen2max_img);
end

function StrengthenLayer:onDegradeTouchTap(event)
  if nil==self.strengthenItem then
    return;
  end
  
  if 0>=self.strengthenItem:getStrengthLevel() then
    --[[local a=CommonPopup.new();
    a:initialize(StringUtils:getString4Popup(PopupMessageConstConfig.ID_23),self,nil,nil,nil,nil,true);
    self:addChild(a);]]
    sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_23));
    return;
  end
  local degradePopup=DegradePopup.new();
  degradePopup:initialize(self.skeleton,self.strengthenItem,self.context,self.onDegrade);
  self:addChild(degradePopup);
end

function StrengthenLayer:onLevelupTouchTap(event)
  if nil==self.strengthenItem then
    return;
  end
  
  if self.isLevelMax then
    --[[local a=CommonPopup.new();
    a:initialize("这件装备已经满级了哦!",self,nil,nil,nil,nil,true);
    self:addChild(a);]]
    sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_21));
    return;
  elseif not self.silver_enough then

    sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_20));
    return;
  elseif self.generalListProxy:getLevel()<=self.strengthenItem:getStrengthLevel() then
    --[[local c=CommonPopup.new();
    c:initialize("超过角色等级了哦!",self,nil,nil,nil,nil,true);
    self:addChild(c);]]
    sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_22));
    return;
  end
  self.onStrengthen(self.context);
end

function StrengthenLayer:onLevelupMaxTouchTap(event)
  if self.const_strengthen_level_up_max_vip>self.userProxy:getVipLevel() then
    sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_80));
    self.context:dispatchEvent(Event.new("vip_recharge",nil,self.context));
    return;
  elseif self.isLevelMax then
    sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_21));
    return;
  elseif self.generalListProxy:getLevel()<=self.strengthenItem:getStrengthLevel() then
    sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_22));
    return;
  end
  local level,silver=StrengthenFormula:getStrengthMaxLevelAndSilver(self.strengthenItem,self.context.userProxy:getVipLevel(),self.userCurrencyProxy:getSilver(),self.generalListProxy:getLevel());
  if 0==silver then
    sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_20));
    return;
  end
  local function cb()
    self.context:dispatchEvent(Event.new("TO_AUTO_GUIDE",{ID=FunctionConfig.FUNCTION_ID_103,TYPE_ID=3},self.context));
  end
  local function cb_levelup_max()
    if self.userCurrencyProxy:getSilver()<silver then

      sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_20));

      return;
    end
    self.onStrengthenMax(self.context);
  end
  local c=CommonPopup.new();
  c:initialize(StringUtils:getString4Popup(PopupMessageConstConfig.ID_247,{silver,level}),self,cb_levelup_max,nil,nil,nil,false,StringUtils:getButtonString4Popup(PopupMessageConstConfig.ID_247),nil,true);
  sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_EFFECTS):addChild(c);
end

function StrengthenLayer:refreshTapItem(strengthenItem)
  if nil==strengthenItem then
    return;
  end
  local vipLV=self.context.userProxy:getVipLevel();
  local propID=tonumber(analysis("Zhuangbei_Zhuangbeibiao",strengthenItem:getBagItemData().ItemId,"attribute"));
  local prop=analysis("Wujiang_Wujiangshuxing",propID,"name");
  self.propID=propID;

  local strengthenLVMax=analysis("Xishuhuizong_Xishubiao",17,"constant");
  local strengthenLV=strengthenItem:getStrengthLevel();
  self.isLevelMax=strengthenLVMax==strengthenLV;
  
  --佩带等级
  --self.strengthen_level_descb:setString(analysis("Zhuangbei_Zhuangbeibiao",strengthenItem:getBagItemData().ItemId,"lv") .. "级");
  self.strengthen_level_descb:setString("Lv." .. strengthenItem:getStrengthLevel());
  self.strengthen_next_level_descb:setString(self.isLevelMax and "" or ("Lv." .. (1+strengthenItem:getStrengthLevel())));
  self.armature:getChildByName("common_copy_right_arrow_1"):setVisible(not self.isLevelMax);

  local text="";
  local prop_value=strengthenItem:getEquipmentInfoProxy():getPropertyValueWithStrengthened(strengthenItem:getBagItemData().UserItemId,propID);
  text=text .. "+" .. prop_value;
  self.strengthen_prop_name_descb:setString(prop .. "增加");
  if self.isLevelMax then
    --self.armature:removeChild(self.common_up,false);
    --self.strengthen_add_descb:setString("");
    self.minValue=nil;
  else
    --self.armature:addChild(self.common_up);
    --self.strengthen_add_descb:setString(self:getStrengthenBound(strengthenItem,vipLV));
    self.minValue=StrengthenFormula:getStrengthenBound(strengthenItem,vipLV);
    -- text=text .. "<font color='#00FF00'>" .. " +" .. self.minValue .. "</font>";
    self.strengthen_prop_descb_1:setString(" +" .. (prop_value+self.minValue) .. "(暴击双倍)");
  end
  self.strengthen_prop_descb:setString(text);
  self.armature:getChildByName("common_copy_right_arrow_2"):setVisible(not self.isLevelMax);

  local prop_v=analysis("Zhuangbei_Zhuangbeibiao",strengthenItem:getBagItemData().ItemId,"amount");
  local a=-1;
  while -1+strengthenLV>a do
    a=1+a;
    local min,max=StrengthenFormula:getStrengthenBoundMinAndMax(strengthenItem:getBagItemData().ItemId,a,vipLV);
    prop_v=max+prop_v;
  end
  --self.max_prop:setString('<content><font color="#E1D2A0">' .. strengthenLV .. '级最大强化属性 : </font><font color="#00FF00">' .. prop_v .. '</font></content>');

  self.silver_enough=self.userCurrencyProxy:getSilver()>=StrengthenFormula:getStrengthenSilver(strengthenItem,vipLV);
  self.strengthen_cost_descb:setString(strengthenLVMax==strengthenLV and "无" or (StrengthenFormula:getStrengthenSilver(strengthenItem,vipLV)));
  self.strengthen_cost_descb:setColor(CommonUtils:ccc3FromUInt(self.silver_enough and 65280 or 16711680));
  --self.max_level_descb:setString(self.isLevelMax and "厉害~这件装备已经满级了 !" or "");
  self.strengthenItem=strengthenItem;
end

function StrengthenLayer:getStrengthenBound(strengthenItem, vipLV)
  return StrengthenFormula:getStrengthenBoundString(strengthenItem,vipLV);
end

function StrengthenLayer:onEffectCB(effect)
  if effect then
    self:removeChild(effect);
  end
end

function StrengthenLayer:refreshStrengthenOnDouble(preStrengthenValue)
  -- if self.minValue and self.minValue<preStrengthenValue then
    require "main.common.effectdisplay.TextureScaleEffect";
    local effect=TextureScaleEffect.new();
    -- effect:initialize(self.skeleton:getBoneTextureDisplay("strengthen_effect"),1);
    effect:initialize(self:getBaojiLayer(preStrengthenValue),1);
    local gb=effect:getGroupBounds().size;
    effect:setPositionXY(GameConfig.STAGE_WIDTH/2-gb.width/2,GameConfig.STAGE_HEIGHT/2-gb.height/2);
    self:addChild(effect);
    effect:start(0.3,3,0.5,self,self.onEffectCB);
  -- end
end

function StrengthenLayer:getBaojiLayer(preStrengthenValue)
  local layer=StrengthenCapacity.new();
  layer:initialize(self.propID,preStrengthenValue,self.minValue<preStrengthenValue);
  return layer;
end

StrengthenCapacity=class(Layer);

function StrengthenCapacity:ctor()
  self.class=StrengthenCapacity;
end

function StrengthenCapacity:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  StrengthenCapacity.superclass.dispose(self);
end

function StrengthenCapacity:initialize(prop_id, num, isBaoji)
  self:initLayer();
  self:setNum(prop_id,num,isBaoji);
end

function StrengthenCapacity:setNum(prop_id, num, isBaoji)
  self.num=num;
  self:removeChildren();
  local img_name={"common_red_shengming","common_red_gongji","common_red_fangyu"};
  local n=0;
  local w=0;
  local s=tostring(self.num);
  local t={};
  if isBaoji then
    table.insert(t,CommonSkeleton:getBoneTextureDisplay("common_red_baoji"));
  end
  local prop_name=CommonSkeleton:getBoneTextureDisplay(img_name[prop_id]);
  prop_name:setPositionY(10);
  table.insert(t,prop_name);
  local plus=CommonSkeleton:getBoneTextureDisplay("common_red_plus");
  plus:setPositionY(13);
  table.insert(t,plus);
  while n<string.len(s) do
    n=1+n;
    local sprite=CommonSkeleton:getBoneTextureDisplay("common_red_number_" .. string.sub(s,n,n));
    print("common_red_number_" .. string.sub(s,n,n));
    sprite:setPositionY(13);
    table.insert(t,sprite);
  end
  for k,v in pairs(t) do
    v:setPositionX(w);
    w=v:getContentSize().width+w;
    self:addChild(v);
  end
end