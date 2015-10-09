--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-2-25

	yanchuan.xie@happyelements.com
]]

require "core.events.DisplayEvent";
--require "core.controls.CommonButton";
require "main.common.CommonExcel";
require "core.utils.CommonUtil";

ItemTip=class(LayerPopable);

function ItemTip:dispose()
  if not self.isDisposed then
    self:removeAllEventListeners();
    self:removeChildren();
  	ItemTip.superclass.dispose(self);
    self.armature:dispose()
    BitmapCacher:removeUnused();
  end
end

function ItemTip:getItemData()
  return self.itemData;
end

--intialize UI
function ItemTip:initialize(skeleton, userProxy, generalListProxy)
  self:initLayer();
  
  local armature=skeleton:buildArmature("detail_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature = armature;
  local armature_d=armature.display;
  self:addChild(armature_d);

  local Button1=armature_d:getChildByName("common_blue_button");
  local pos1=convertBone2LB4Button(Button1);--equipButton:getPosition();
  armature_d:removeChild(Button1);

  local Button2=armature_d:getChildByName("common_blue_button_1");
  local pos2=convertBone2LB4Button(Button2);--equipButton:getPosition();
  armature_d:removeChild(Button2);

  local pos3=pos1
  pos3.x=(pos1.x+pos2.x)/2
  closeButton=CommonButton.new();
  closeButton:initialize("commonButtons/common_small_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
  --sellButton:initializeText(armature:findChildArmature("common_blue_button"):getBone("common_small_blue_button").textData,text);
  closeButton:initializeBMText("购买","anniutuzi");
  closeButton:setPosition(pos3);
  closeButton:addEventListener(DisplayEvents.kTouchTap,self.onCloseButtonTap,self);
  self:addChild(closeButton);
  self.closeButton = closeButton
  
 
  --item
  local grid=armature_d:getChildByName("common_copy_grid");
  self.imagePos=convertBone2LB(grid);--;grid:getPosition();
  self.imagePos.x = self.imagePos.x+ConstConfig.CONST_GRID_ITEM_SKEW_X;
  self.imagePos.y = self.imagePos.y+ConstConfig.CONST_GRID_ITEM_SKEW_Y;
  


  
  --bag_item_name
  self.bag_item_nametext_data=armature:getBone("bag_item_name").textData;

  
  --bag_item_category_name
  text_data=armature:getBone("bag_item_category_name").textData;
  local bag_item_category_name=createTextFieldWithTextData(text_data,"类型");
  self:addChild(bag_item_category_name);
  
  --bag_item_category_descb
  text_data=armature:getBone("bag_item_category_descb").textData;
  text = '类型';
  self.bag_item_category_descb=createTextFieldWithTextData(text_data,text);
  self:addChild(self.bag_item_category_descb);
  
  --bag_item_overlay
  text_data=armature:getBone("bag_item_overlay").textData;
  local bag_item_overlay=createTextFieldWithTextData(text_data,"叠加");
  self:addChild(bag_item_overlay);
  
  --bag_item_overlay_descrb
  text_data=armature:getBone("bag_item_overlay_descrb").textData;
  text="不可叠加";

  self.bag_item_overlay_descrb = createTextFieldWithTextData(text_data,text);
  self:addChild(self.bag_item_overlay_descrb);
  
  --bag_item_output
  text_data=armature:getBone("bag_item_output").textData;
  local bag_item_output=createTextFieldWithTextData(text_data,"产出");
  self:addChild(bag_item_output);
  
  --bag_item_output_descb
  text_data=armature:getBone("bag_item_output_descb").textData;
  text = "产出"
  self.bag_item_output_descb=createTextFieldWithTextData(text_data,text);
  self:addChild(self.bag_item_output_descb);
  
  --bag_item_specification
  text_data=armature:getBone("bag_item_specification").textData;
  self.bag_item_specification=createTextFieldWithTextData(text_data,"说明：");
  self:addChild(self.bag_item_specification);
  
  self:addEventListener(DisplayEvents.kTouchTap,self.onSelfTap,self);
  
 
  local panel_size =  armature_d:getGroupBounds(false).size--skeleton:getBoneTextureDisplay("strongPointInfo_bg"):getContentSize();
  self.sprite:setContentSize(CCSizeMake(panel_size.width, panel_size.height));
end
--移除
function ItemTip:setItemTip(item,callBack, showButton,count)
  if count==nil then
    count=1
  end
  if not self.sprite then return end;
  self.item=item
  self.callBack=callBack
  local itemId=self.item.userItem.ItemId
  local itemPo = analysis("Daoju_Daojubiao", itemId);
  if self.bag_item_name and self:contains(self.bag_item_name) then
     self:removeChild(self.bag_item_name)
  end 
  local daoju_data = analysis("Daoju_Daojubiao",itemId);
  if daoju_data.functionID==4 then
    color=getSimpleGrade(daoju_data.color)
  else
    color=daoju_data.color
  end

  self.bag_item_name=createTextFieldWithQualityID(color, self.bag_item_nametext_data, itemPo.name);
  self:addChild(self.bag_item_name);
  
  local categoryName = analysisHas("Daoju_Daojufenlei",self.item:getCategoryID()) and analysis("Daoju_Daojufenlei",self.item:getCategoryID(),"function") or ""

  self.bag_item_category_descb:setString(categoryName);
  local overlap = "不可叠加";
  if 0 ~= itemPo.overlap then
    overlap = count.."/"..tostring(itemPo.overlap);
  end

  self.bag_item_overlay_descrb:setString(overlap);

  self.bag_item_output_descb:setString(itemPo.origin);

  self.bag_item_specification:setString("说明：" .. itemPo["function"]);
   


    self.itemImage = BagItem.new(); 
  self.itemImage:initialize({ItemId = itemId, Count = count});

  self.itemImage:setPositionXY(self.imagePos.x , self.imagePos.y);

  self.itemImage.touchEnabled = false;
  self.itemImage.touchChildren = false;
  self:addChild(self.itemImage);

  print("showButton", showButton)
  if showButton then
    self.closeButton:setVisible(true)
  else
    self.closeButton:setVisible(false)
    self.touchLayer = TouchLayer.new();
    self.touchLayer:initLayer();
    self:addChildAt(self.touchLayer, 0)
    local mainSize = Director:sharedDirector():getWinSize();
    self.touchLayer.sprite:setContentSize(CCSizeMake(mainSize.width, mainSize.height));

    local xPos = self:getPositionX();
    local yPos = self:getPositionY();

        print("xPos, yPos", xPos, yPos)
    self.touchLayer:setPositionXY(-xPos, -yPos)

    self.touchLayer:addEventListener(DisplayEvents.kTouchTap,self.onTouchLayerTap,self);
  end
 
end
function ItemTip:onTouchLayerTap(event)
  self:dispatchEvent(Event.new("REMOVE_ITEM_TIP", nil, self))
end
function ItemTip:getCategoryID(itemPo)
  return math.floor(itemPo.id/1000);
end

--移除
function ItemTip:onCloseButtonTap(event)
  if self.callBack then
    self.callBack();
  end
end

function ItemTip:closeUI(event)
  self:onTouchLayerTap(event);
end