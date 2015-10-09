--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-3-13

	yanchuan.xie@happyelements.com
]]

require "core.events.DisplayEvent";

StarAddLayer=class(Layer);

function StarAddLayer:ctor()
  self.class=StarAddLayer;
end

function StarAddLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	StarAddLayer.superclass.dispose(self);
  self.removeArmature:dispose()
end

function StarAddLayer:initialize(skeleton, context, onStarAdd, userCurrencyProxy)
  self:initLayer();
  
  self.context=context;
  self.onStarAdd=onStarAdd;
  self.userCurrencyProxy=userCurrencyProxy;
  self:initializeUI(skeleton);
end

function StarAddLayer:initializeUI(skeleton)  
  local armature=skeleton:buildArmature("star_add_panel");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.removeArmature = armature;
  self.star_add_prop_name_text_data={armature:getBone("star_add_prop_1").textData,
                                     armature:getBone("star_add_prop_2").textData,
                                     armature:getBone("star_add_prop_3").textData};
  self.prop_text_data={armature:getBone("prop_1").textData,
                       armature:getBone("prop_2").textData,
                       armature:getBone("prop_3").textData};
  self.common_copy_up_text_data={armature:getBone("common_copy_up_1").textData,
                                 armature:getBone("common_copy_up_2").textData,
                                 armature:getBone("common_copy_up_3").textData};
  self.button_text_data=armature:findChildArmature("common_copy_blueround_button"):getBone("common_copy_blueround_button").textData;
  self.silver_text_data=armature:getBone("common_copy_silver_bg").textData;
  self.max_level_descb_text_data=armature:getBone("max_level_descb").textData;
  
  armature=armature.display;
  self:addChild(armature);
  self.armature=armature;
  self.star_add_prop_names={};
  self.props={};
  self.common_copy_ups={};
  self.common_up_imgs={};
  self.stuff_img_pos=nil;
  self.stuff_img=nil;

  --common_copy_bigBackground_bg
  armature:removeChild(armature:getChildByName("common_copy_bigBackground_bg"));
  
  local common_copy_grid=armature:getChildByName("common_copy_grid");
  self.common_copy_grid_pos=convertBone2LB(common_copy_grid);
  armature:removeChild(common_copy_grid);

  local a=0;
  while table.getn(self.star_add_prop_name_text_data)>a do
    a=1+a;

    local text="";
    self.star_add_prop_names[a]=createTextFieldWithTextData(self.star_add_prop_name_text_data[a],text);
    armature:addChild(self.star_add_prop_names[a]);
  end
  
  a=0;
  while table.getn(self.prop_text_data)>a do
    a=1+a;

    local text="";
    self.props[a]=createTextFieldWithTextData(self.prop_text_data[a],text);
    armature:addChild(self.props[a]);
  end

  a=0;
  while table.getn(self.common_copy_up_text_data)>a do
    a=1+a;

    local text="";
    self.common_copy_ups[a]=createTextFieldWithTextData(self.common_copy_up_text_data[a],text);
    armature:addChild(self.common_copy_ups[a]);
  end

  a=0;
  while table.getn(self.common_copy_up_text_data)>a do
    a=1+a;

    local common_up_img=armature:getChildByName("common_copy_up_" .. a);
    self.common_up_imgs[a]=common_up_img;
  end

  self.common_copy_silver_bg=createTextFieldWithTextData(self.silver_text_data,"");
  armature:addChild(self.common_copy_silver_bg);

  self.max_level_descb=createTextFieldWithTextData(self.max_level_descb_text_data,"");
  armature:addChild(self.max_level_descb);
  
  --common_copy_blueround_button
  local common_copy_blueround_button=armature:getChildByName("common_copy_blueround_button");
  local common_copy_blueround_button_pos=convertBone2LB4Button(common_copy_blueround_button);--common_copy_blueround_button:getPosition();
  armature:removeChild(common_copy_blueround_button);
  
  common_copy_blueround_button=CommonButton.new();
  common_copy_blueround_button:initialize("common_blueround_button_normal","common_blueround_button_down",CommonButtonTouchable.BUTTON);
  common_copy_blueround_button:initializeText(self.button_text_data,"精炼");
  common_copy_blueround_button:setPosition(common_copy_blueround_button_pos);
  common_copy_blueround_button:addEventListener(DisplayEvents.kTouchTap,self.onTouchTap,self);
  self:addChild(common_copy_blueround_button);
  self.common_copy_blueround_button=common_copy_blueround_button;
end

function StarAddLayer:onToShop()
  self.context:dispatchEvent(Event.new(OpenFunctionNotifications.OPEN_UI_BY_FUNCTION_ID,{ID=FunctionConfig.FUNCTION_ID_8,FLIP_ITEM_ID=self.stuff_item_id},self));
end

function StarAddLayer:onStuffTap(event)
  local stuffTrackDetail=StuffTrackDetail.new();
  stuffTrackDetail:initialize(self.parent.bagProxy:getSkeleton(),event.target:getItemID(),false,self.parent,self.parent.onStuffTrack);
  self.parent:addChild(stuffTrackDetail);
end

function StarAddLayer:onTouchTap(event)
  if nil==self.strengthenItem then
    return;
  end
  
  if self.isStarMax then
    --[[local a=CommonPopup.new();
    a:initialize("已经最高星级哦!",self,nil,nil,nil,nil,true);
    self:addChild(a);]]
    sharedTextAnimateReward():animateStartByString("已经最高星级哦!");
    return;
  elseif false==self.silver_enough then
    local function cb()
      self.context:dispatchEvent(Event.new("TO_AUTO_GUIDE",{ID=FunctionConfig.FUNCTION_ID_103,TYPE_ID=3},self.context));
    end
    local c=CommonPopup.new();
    c:initialize(StringUtils:getString4Popup(PopupMessageConstConfig.ID_26),self,cb,nil,nil,nil,false,StringUtils:getButtonString4Popup(PopupMessageConstConfig.ID_26));
    self:addChild(c);
    --sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_26));
    return;
  elseif false==self.stuff_enough then
    local b=CommonPopup.new();
    b:initialize(StringUtils:getString4Popup(PopupMessageConstConfig.ID_200),self,self.onToShop,nil,nil,nil,false,StringUtils:getButtonString4Popup(PopupMessageConstConfig.ID_200));
    self:addChild(b);
    --sharedTextAnimateReward():animateStartByString("材料不足哦!");
    return;
  end
  self.onStarAdd(self.context);
end

function StarAddLayer:refreshTapItem(strengthenItem)
  if nil==strengthenItem then
    return;
  end
  
  local star_max=analysis("Zhuangbei_Zhuangbeibiao",strengthenItem:getBagItemData().ItemId,"quality");
  star_max=analysis("Zhuangbei_Zhuangbeipinzhi",star_max,"starUpperLimit");
  local star_level=strengthenItem:getEquipmentInfo().StarLevel;
  self.isStarMax=star_max==star_level;
  --[[self.star_add_level_descb:setString(star_level .. "/" .. star_max .. "星");
  self.star_add_prop_descb:setString(star_max==star_level and "已经最高星级哦" or self:getStarAddBound(strengthenItem));]]

  local starAddBoundConverted=self:getStarAddBoundConverted(strengthenItem);
  local starAddBound=self:getStarAddBound(strengthenItem);
  
  for k,v in pairs(starAddBound) do
    self.star_add_prop_names[k]:setString(v[1] .. " :");
    self.props[k]:setString(v[2]);
    if nil==v[3] then
      self.armature:removeChild(self.common_up_imgs[k],false);
      self.common_copy_ups[k]:setString("");
    else
      self.armature:addChild(self.common_up_imgs[k]);
      self.common_copy_ups[k]:setString("+ " .. (tonumber(v[3])-tonumber(v[2])));
    end
  end

  if self.isStarMax then
    self.common_copy_silver_bg:setString("无");
    self.common_copy_silver_bg:setColor(CommonUtils:ccc3FromUInt(16711680));
  else
    local silver=StrengthenFormula:getStarAddSilver(strengthenItem);
    self.silver_enough=self.userCurrencyProxy:getSilver()>=silver;
    self.common_copy_silver_bg:setString(silver);
    self.common_copy_silver_bg:setColor(CommonUtils:ccc3FromUInt(self.silver_enough and 65280 or 16711680));
  end

  if self.stuff_img then
    self.armature:removeChild(self.stuff_img);
  end
  if not self.isStarMax then
    local stuff_table=StringUtils:lua_string_split(analysis("Zhuangbei_Zhuangbeixingji",1+star_level,"stuffId"),",");
    local stuff_num_table=StringUtils:lua_string_split(analysis("Zhuangbei_Zhuangbeixingji",1+star_level,"stuffNumber"),",");
    local user_stuff_num_arr={};
    self.stuff_enough=true;
    self.stuff_item_id=nil;
    for k,v in pairs(stuff_table) do
      local user_stuff_num=strengthenItem:getBagProxy():getItemNum(tonumber(v));
      self.stuff_enough=tonumber(stuff_num_table[k])<=user_stuff_num and self.stuff_enough;
      table.insert(user_stuff_num_arr,user_stuff_num);
      if not self.stuff_item_id then
        self.stuff_item_id=tonumber(v);
      end
    end

    self.stuff_img=StuffImg.new();
    self.stuff_img:initialize(stuff_table[1],user_stuff_num_arr[1],tonumber(stuff_num_table[1]));
    self.stuff_img:setPosition(self.common_copy_grid_pos);
    self.stuff_img:addEventListener(DisplayEvents.kTouchTap,self.onStuffTap,self);
    self.armature:addChild(self.stuff_img);
  end

  --[[local s="";
  if star_max==star_level then
    s=s .. "无";
  else
    for k,v in pairs(stuff_table) do
      local stuff_name=analysis("Daoju_Daojubiao",v,"name");
      s=s .. stuff_name .. " " .. user_stuff_num_arr[k] .. "/" .. stuff_num_table[k] .. "\n";
    end
  end
  self.star_add_stuff_descb:setString(s);]]
  self.max_level_descb:setString(self.isStarMax and "装备精炼已达到最高" or "");
  self.strengthenItem=strengthenItem;

  self:refreshButton();
end

function StarAddLayer:getStarAddBound(strengthenItem)
  return StrengthenFormula:getStarAddBoundString(strengthenItem,self.isStarMax);
end

function StarAddLayer:getStarAddBoundConverted(strengthenItem)
  return StrengthenFormula:getStarAddBoundStringConverted(strengthenItem,self.isStarMax);
end

function StarAddLayer:refreshButton()
  if (not self.isStarMax) and self.stuff_enough and self.silver_enough then
    --self.common_copy_blueround_button:setGray(false);
    return;
  end
  --self.common_copy_blueround_button:setGray(true);
end

function StarAddLayer:refreshStuffByBags()
  self:refreshTapItem(self.strengthenItem);
end