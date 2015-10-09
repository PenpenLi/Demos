--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-2-25

	yanchuan.xie@happyelements.com
]]

require "core.events.DisplayEvent";
--require "core.controls.CommonButton";
require "main.common.CommonExcel";
require "core.utils.CommonUtil";

PetSkillTip=class(Layer);

--todo 写的不好，待改
function PetSkillTip:ctor()
  self.class = PetSkillTip;
  self.skillId = 0;
  self.commandType = 0;
end

function PetSkillTip:dispose()
  if not self.isDisposed then
    self:removeAllEventListeners();
    self:removeChildren();
  	PetSkillTip.superclass.dispose(self);
    self.armature:dispose()
    BitmapCacher:removeUnused();
  end
end

function PetSkillTip:getItemData()
  return self.itemData;
end

--intialize UI
function PetSkillTip:initialize(skeleton,context,callbackPetSkillTip)
  self:initLayer();
  self.context = context;
  self.callbackPetSkillTip = callbackPetSkillTip;
  
  local armature=skeleton:buildArmature("detail_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature = armature;
  local armature_d=armature.display;
  self:addChild(armature_d);

  --item
  local grid=armature_d:getChildByName("common_copy_grid");
  self.imagePos=convertBone2LB(grid);--;grid:getPosition();
  self.imagePos.x = self.imagePos.x+ConstConfig.CONST_GRID_ITEM_SKEW_X;
  self.imagePos.y = self.imagePos.y+ConstConfig.CONST_GRID_ITEM_SKEW_Y;
  
  --bag_item_name
  local text_data
  text_data=armature:getBone("bag_item_name").textData;
  self.bag_item_name=createTextFieldWithTextData(text_data,"XXX");
  self:addChild(self.bag_item_name);
  
  --bag_item_category_name
  text_data=armature:getBone("bag_item_category_name").textData;
  local bag_item_category_name=createTextFieldWithTextData(text_data,"类型");
  self:addChild(bag_item_category_name);
  
  --bag_item_category_descb
  text_data=armature:getBone("bag_item_category_descb").textData;
  text = '主动技能';
  self.bag_item_category_descb=createTextFieldWithTextData(text_data,text);
  self:addChild(self.bag_item_category_descb);
  
  --bag_item_overlay
  text_data=armature:getBone("bag_item_overlay").textData;
  local bag_item_overlay=createTextFieldWithTextData(text_data,"等级");
  self:addChild(bag_item_overlay);
  
  --bag_item_overlay_descrb
  text_data=armature:getBone("bag_item_overlay_descrb").textData;
  text="9级";

  self.bag_item_overlay_descrb = createTextFieldWithTextData(text_data,text);
  self:addChild(self.bag_item_overlay_descrb);
  
  --bag_item_output
  text_data=armature:getBone("bag_item_output").textData;
  local bag_item_output=createTextFieldWithTextData(text_data,"");
  self:addChild(bag_item_output);
  
  --bag_item_output_descb
  text_data=armature:getBone("bag_item_output_descb").textData;
  text = "xx-xx"
  self.bag_item_output_descb=createTextFieldWithTextData(text_data,text);
  self:addChild(self.bag_item_output_descb);
  
  --bag_item_specification
  text_data=armature:getBone("bag_item_specification").textData;
  self.bag_item_specification=createAutosizeMultiColoredLabelWithTextData(text_data,"说明：");

  self:addChild(self.bag_item_specification);
  self.bag_item_specification:setPositionY(self.bag_item_specification:getPosition().y + 70);
  
  self:addEventListener(DisplayEvents.kTouchTap,self.onSelfTap,self);
  
  --升级
  local button_levelUp=armature_d:getChildByName("common_copy_blueround_button_1");
  local sell_pos=convertBone2LB4Button(button_levelUp);--button_del:getPosition();
  armature_d:removeChild(button_levelUp);

  --遗忘
  local button_del=armature_d:getChildByName("common_copy_blueround_button");
  local equip_pos=convertBone2LB4Button(button_del);--button_del:getPosition();
  armature_d:removeChild(button_del);

  button_levelUp=CommonButton.new();
  button_levelUp:initialize("common_blueround_button_normal","common_blueround_button_down",CommonButtonTouchable.BUTTON);
  button_levelUp:initializeText(armature:findChildArmature("common_copy_blueround_button"):getBone("common_copy_blueround_button").textData,"升级");
  button_levelUp:setPosition(sell_pos);
  button_levelUp:addEventListener(DisplayEvents.kTouchTap,self.onLevelUp,self);
  self:addChild(button_levelUp);

  button_del=CommonButton.new();
  button_del:initialize("common_blueround_button_normal","common_blueround_button_down",CommonButtonTouchable.BUTTON);
  button_del:initializeText(armature:findChildArmature("common_copy_blueround_button"):getBone("common_copy_blueround_button").textData,"遗忘");
  button_del:setPosition(equip_pos);
  button_del:addEventListener(DisplayEvents.kTouchTap,self.onDel,self);
  self:addChild(button_del);

  local panel_size =  armature_d:getGroupBounds(false).size--skeleton:getBoneTextureDisplay("strongPointInfo_bg"):getContentSize();
  self.sprite:setContentSize(CCSizeMake(panel_size.width, panel_size.height));
end
--移除
function PetSkillTip:setData(petData,skillId,skillLevel)
  if petData==nil or skillId<=0 or skillLevel<=0 then return end;
  self.petData = petData;
  self.skillId = skillId;
  self.skillLevel = skillLevel;
  --skillId>30000为主动技能，有读表知道，写的时候策划是这个逻辑，以后不一定
  self.isActiveSkill = self.skillId>30000;

  self.bag_item_category_descb:setString((self.isActiveSkill and "主动技能") or "被动技能");
  self.bag_item_overlay_descrb:setString(skillLevel);

  self.bag_item_output_descb:setString("");

  local des
  local name
  local effectAmount
  if self.isActiveSkill then
    vo =  analysis2key("Jineng_Chongwuzhudongjineng","id",self.skillId,"lv",self.skillLevel)
  else
    vo =  analysis2key("Jineng_Beidongjineng","id",self.skillId,"lv",self.skillLevel)
  end

  print("PetSkillTip:setData:",petData,skillId,skillLevel,vo,self.isActiveSkill)

  des = vo.describe;
  name = vo.name;
  effectAmount = vo.effectAmount;

  --todo 宠物公式去掉，这个替换方法不好，要重构
  local temp = StringUtils:lua_string_split(effectAmount,",")
  if #temp==1 then
    self.bag_item_specification:setString(StringUtils:stuff_string_replace(des,"@",temp[1]));
  elseif #temp==2 then
    des = string.gsub(des,"@1",temp[1])
    des = string.gsub(des,"@2",temp[2])
    self.bag_item_specification:setString(des);
  elseif #temp==3 then

  end
  
  self.bag_item_name:setString(name)

  local artId = vo.icon;
    
  if self.itemImage and self:contains(self.itemImage) then
     self:removeChild(self.itemImage)
  end 
  self.itemImage = Image.new();
  self.itemImage:loadByArtID(artId);
  self.itemImage:setPositionXY(self.imagePos.x , self.imagePos.y);
  self:addChild(self.itemImage)
  
  --颜色框
  -- self.frame_bg=CommonSkeleton:getBoneTextureDisplay("common_rect_color_frame_" .. analysis("Daoju_Daojubiao",skillId,"color"));
  -- local size=self.itemImage:getContentSize();
  -- local frame_bg_size=self.frame_bg:getContentSize();
  -- self.frame_bg:setPositionXY((size.width-frame_bg_size.width)/2,(size.height-frame_bg_size.height)/2);
  -- self.itemImage:addChild(self.frame_bg);
end
--移除
function PetSkillTip:onCloseButtonTap(event)
  self.parent:removeItemTap();
end

function PetSkillTip:onLevelUp(event)
  --<!-- Type(1:学习 2:升级) -->
  --<param main="13" sub="10" desc="请求 学习或升级技能">ID,UserItemId,Type</param>

  self.commandType = 1310
  self.callbackPetSkillTip(self.context,self)

end

function PetSkillTip:onDel(event)
  --<param main="13" sub="9" desc="请求 遗忘技能">ID,SkillId</param>
  self.commandType = 139
  self.callbackPetSkillTip(self.context,self)
end


--出售
function PetSkillTip:onSellButtonTap(event)
  if 3<analysis("Daoju_Daojubiao",self.itemData.ItemId,"color") then
    if self.item:getIsConfirm4Sell() then
      local a=CommonPopup.new();
      a:initialize(StringUtils:getString4Popup(PopupMessageConstConfig.ID_196),self,self.sell,nil,nil,nil,false,StringUtils:getButtonString4Popup(PopupMessageConstConfig.ID_196));
      self.parent.parent:addChild(a);
      return;
    end
    self:sell();
    return;
  end
  local a=CommonPopup.new();
  a:initialize(StringUtils:getString4Popup(PopupMessageConstConfig.ID_16),self,self.sell,nil,nil,nil,false,StringUtils:getButtonString4Popup(PopupMessageConstConfig.ID_16));
  self.parent.parent:addChild(a);
end


function PetSkillTip:sell()
  if 1==self.bag_item:getItemData().Count then
    self:sellConfirm({Count=1});
    self:onCloseButtonTap();
  else
    local batchUseUI=BatchUseUI.new();
    batchUseUI:initialize(self.effectProxy:getBatchUseSkeleton(),self,{ItemId=self.itemData.ItemId,MaxCount=self.bag_item:getItemData().Count},{"出售","取消"},self.sellConfirm,nil,2);
    self.parent.parent:addChild(batchUseUI);
  end
end