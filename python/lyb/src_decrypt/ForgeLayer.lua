--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-3-13

	yanchuan.xie@happyelements.com
]]

require "core.events.DisplayEvent";

ForgeLayer=class(Layer);

function ForgeLayer:ctor()
  self.class=ForgeLayer;
end

function ForgeLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	ForgeLayer.superclass.dispose(self);
  self.removeArmature:dispose()
end

function ForgeLayer:initialize(skeleton, context, onForge, userCurrencyProxy, generalListProxy)
  self:initLayer();
  
  self.context=context;
  self.onForge=onForge;
  self.userCurrencyProxy=userCurrencyProxy;
  self.generalListProxy=generalListProxy;
  self:initializeUI(skeleton);
end

function ForgeLayer:initializeUI(skeleton)  
  local armature=skeleton:buildArmature("forge_panel");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.removeArmature = armature;
  self.forge_prop_text_data=armature:getBone("forge_prop").textData;
  self.forge_prop_descb_text_data=armature:getBone("forge_prop_descb").textData;
  self.forge_stuff_text_data=armature:getBone("forge_stuff").textData;
  self.forge_prop_add_text_data=armature:getBone("forge_prop_add").textData;
  self.common_copy_silver_bg_text_data=armature:getBone("common_copy_silver_bg").textData;

  self.button_text_data=armature:findChildArmature("common_copy_blueround_button"):getBone("common_copy_blueround_button").textData;
  
  armature=armature.display;
  self:addChild(armature);
  self.armature=armature;
  self.forge_prop_add_img=armature:getChildByName("forge_prop_add");
  self.const_stuff_img_num=5;
  self.stuff_img_poss={};
  self.stuff_imgs={};

  --common_copy_bigBackground_bg
  armature:removeChild(armature:getChildByName("common_copy_bigBackground_bg"));
  
  --common_copy_blueround_button
  local common_copy_blueround_button=armature:getChildByName("common_copy_blueround_button");
  local common_copy_blueround_button_pos=convertBone2LB4Button(common_copy_blueround_button);--common_copy_blueround_button:getPosition();
  armature:removeChild(common_copy_blueround_button);
  
  
  --forge_prop
  local text="";
  self.forge_prop=createTextFieldWithTextData(self.forge_prop_text_data,text);
  armature:addChild(self.forge_prop);
  
  --forge_prop_descb
  text="";
  self.forge_prop_descb=createTextFieldWithTextData(self.forge_prop_descb_text_data,text);
  armature:addChild(self.forge_prop_descb);

  text="打造消耗 :";
  self.forge_stuff=createTextFieldWithTextData(self.forge_stuff_text_data,text);
  armature:addChild(self.forge_stuff);
  
  --forge_prop_add
  text="";
  self.forge_prop_add=createTextFieldWithTextData(self.forge_prop_add_text_data,text);
  armature:addChild(self.forge_prop_add);

  --common_copy_silver_bg
  text="";
  self.common_copy_silver_bg=createTextFieldWithTextData(self.common_copy_silver_bg_text_data,text);
  armature:addChild(self.common_copy_silver_bg);

  local a=0;
  while self.const_stuff_img_num>a do
    a=1+a;

    local b=armature:getChildByName("common_copy_grid_" .. a);
    local b_pos=convertBone2LB(b);
    armature:removeChild(b);
    table.insert(self.stuff_img_poss,b_pos);
  end
  
  --打造
  common_copy_blueround_button=CommonButton.new();
  common_copy_blueround_button:initialize("common_blueround_button_normal","common_blueround_button_down",CommonButtonTouchable.BUTTON);
  common_copy_blueround_button:initializeText(self.button_text_data,"打造");
  common_copy_blueround_button:setPosition(common_copy_blueround_button_pos);
  common_copy_blueround_button:addEventListener(DisplayEvents.kTouchTap,self.onForgeTouchTap,self);
  self:addChild(common_copy_blueround_button);
  self.common_copy_blueround_button=common_copy_blueround_button;
end

function ForgeLayer:onForgeConfirm()
  self.onForge(self.context);

end

function ForgeLayer:onStuffTap(event)
  local stuffTrackDetail=StuffTrackDetail.new();
  stuffTrackDetail:initialize(self.parent.bagProxy:getSkeleton(),event.target:getItemID(),true,self.parent,self.parent.onStuffTrack);
  self.parent:addChild(stuffTrackDetail);
end

function ForgeLayer:onForgeTouchTap(event)

  if false==self.stuff_enough then
    --[[local b=CommonPopup.new();
    b:initialize("材料不足哦!",self,nil,nil,nil,nil,true);
    self:addChild(b);]]
    sharedTextAnimateReward():animateStartByString("材料不足哦!");
    return;
  elseif false==self.silver_enough then
    -- local function cb()
    --   self.context:dispatchEvent(Event.new("TO_AUTO_GUIDE",{ID=FunctionConfig.FUNCTION_ID_103,TYPE_ID=3},self.context));
    -- end
    -- local c=CommonPopup.new();
    -- c:initialize(StringUtils:getString4Popup(PopupMessageConstConfig.ID_24),self,cb,nil,nil,nil,false,StringUtils:getButtonString4Popup(PopupMessageConstConfig.ID_24));
    -- self:addChild(c);
    sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_24));
    return;
  elseif false==self.level_enough then
    --[[local d=CommonPopup.new();
    d:initialize("注意!你的等级不足~打造后装备会被脱下!确定打造么?",self,self.onForgeConfirm);
    self:addChild(d);]]
    sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_205));
    return;
  elseif false==self.level_enough_1 then
    --[[local e=CommonPopup.new();
    e:initialize("您还未达到该装备可穿戴等级哦!打造后装备会无法穿戴哦!确认打造吗?",self,self.onForgeConfirm);
    self:addChild(e);]]
    sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_205));
    return;
  end
  self:onForgeConfirm();
end

function ForgeLayer:refreshTapItem(strengthenItem)
  if nil==strengthenItem then
    return;
  end

  for k,v in pairs(self.stuff_imgs) do
    self.armature:removeChild(v);
  end
  --[[local name=analysis("Daoju_Daojubiao",strengthenItem:getBagItemData().ItemId,"name");
  self.forge_name_descb:setString(name);]]

  local equip_level=analysis("Zhuangbei_Zhuangbeibiao",strengthenItem:getBagItemData().ItemId,"lv");
  local level_max=analysis("Xishuhuizong_Xishubiao",21,"constant");

  local silver=analysis("Zhuangbei_Zhuangbeidazao",strengthenItem:getBagItemData().ItemId,"money");
  self.silver_enough=self.userCurrencyProxy:getSilver()>=silver;
  self.common_copy_silver_bg:setString(silver);
  self.common_copy_silver_bg:setColor(CommonUtils:ccc3FromUInt(self.silver_enough and 65280 or 16711680));

  local forgeID=analysis("Zhuangbei_Zhuangbeidazao",strengthenItem:getBagItemData().ItemId,"afterForgeId");
  local prop_id=analysis("Zhuangbei_Zhuangbeibiao",strengthenItem:getBagItemData().ItemId,"attribute");
  local prop_name=analysis("Wujiang_Wujiangshuxing",prop_id,"name");
  local prop_value=analysis("Zhuangbei_Zhuangbeibiao",strengthenItem:getBagItemData().ItemId,"amount");
  local prop_add_value=analysis("Zhuangbei_Zhuangbeibiao",forgeID,"amount")-prop_value;
  local afterForgeLevel=analysis("Zhuangbei_Zhuangbeibiao",forgeID,"lv");
  self.level_enough=true;
  self.level_enough_1=true;
  if self.generalListProxy:getLevel()<afterForgeLevel then
    if 1==strengthenItem:getBagItemData().IsUsing then
      self.level_enough=false;
    else
      self.level_enough_1=false;
    end
  end
  --self.forge_prop_descb:setString(prop_name .. "+" .. prop_add_value);
  self.forge_prop:setString(prop_name .. " :");
  self.forge_prop_descb:setString(strengthenItem:getEquipmentInfoProxy():getPropertyValue(strengthenItem:getBagItemData().UserItemId,prop_id));
  self.forge_prop_add:setString("+ " .. prop_add_value);
  
  self.stuff_enough=false;
  local scroll_stuff_ID=analysis("Zhuangbei_Zhuangbeidazao",strengthenItem:getBagItemData().ItemId,"scrollId");
  --local scroll_stuff_str=analysis("Daoju_Daojubiao",scroll_stuff_ID,"name");
  local scroll_stuff_num=strengthenItem:getBagProxy():getItemNum(scroll_stuff_ID);
  --scroll_stuff_str=scroll_stuff_str .. "\n";
  local stuff_data_table={};
  if 0==scroll_stuff_ID then
    self.stuff_enough=true;
  else
    table.insert(stuff_data_table,{scroll_stuff_ID,scroll_stuff_num,1});
  end

  if 1<=scroll_stuff_num then
    self.stuff_enough=true;
  end
    
  local stuff_table=StringUtils:stuff_string_split(analysis("Zhuangbei_Zhuangbeidazao",strengthenItem:getBagItemData().ItemId,"stuff"));
  for k,v in pairs(stuff_table) do
    local user_stuff_num=strengthenItem:getBagProxy():getItemNum(tonumber(v[1]));
    --scroll_stuff_str=scroll_stuff_str .. analysis("Daoju_Daojubiao",v[1],"name") .. user_stuff_num .. "/" .. v[2] .. "\n";
    table.insert(stuff_data_table,{tonumber(v[1]),user_stuff_num,tonumber(v[2])});
    if user_stuff_num<tonumber(v[2]) then
      self.stuff_enough=false;
    end
  end
  --self.star_add_stuff_descb:setString(scroll_stuff_str);
  
  local stuff_pos_skew=self.stuff_img_poss[2].x-self.stuff_img_poss[1].x;
  local stuff_pos_min=stuff_pos_skew*(table.getn(self.stuff_img_poss)-table.getn(stuff_data_table))/2;
  for k,v in pairs(stuff_data_table) do
    local stuff_img=StuffImg.new();
    stuff_img:initialize(v[1],v[2],v[3]);
    stuff_img:setPositionXY(stuff_pos_min+self.stuff_img_poss[k].x,self.stuff_img_poss[k].y);
    stuff_img:addEventListener(DisplayEvents.kTouchTap,self.onStuffTap,self);
    self.armature:addChild(stuff_img);
    table.insert(self.stuff_imgs,stuff_img);
  end

  self:refreshButton();

end

function ForgeLayer:refreshButton()
  if self.stuff_enough and self.silver_enough then
    self.common_copy_blueround_button:setGray(false, true);
    return;
  end
  self.common_copy_blueround_button:setGray(true, true);
end