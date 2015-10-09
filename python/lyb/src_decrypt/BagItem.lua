require "core.controls.Image";
require "main.common.CommonExcel";
require "core.display.DisplayNode";

BagItem=class(Layer);

function BagItem:ctor()
  self.class=BagItem;
  self.bagHasCount = 0;
  self.totalNeedCount = 0;
end

function BagItem:clone()
  local userItem={};
  for k,v in pairs(self.userItem) do
    userItem[k]=v;
  end
  local bagItem=BagItem.new();
  userItem.Count=1;
  bagItem:initialize(userItem);
  return bagItem;
end

function BagItem:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  BagItem.superclass.dispose(self);
end

function BagItem:equal(bagItem)
  local a=bagItem:getItemData();
  local b=self:getItemData();
  if a.UserItemId==b.UserItemId and a.ItemId==b.ItemId then
    return true;
  end
  return false;
end

function BagItem:getCategoryID()
  return math.floor(self.userItem.ItemId/1000);
end

function BagItem:getCategoryPropID()
  return math.floor(self.userItem.ItemId/100000);
end

function BagItem:getItemData()
  return self.userItem;
end

function BagItem:getUserItemID()
  return self.userItem.UserItemId;
end

function BagItem:getItemID()
  return self.userItem.ItemId;
end

function BagItem:getPszFileName(itemID_int)
  local pszFileID=analysis("Daoju_Daojubiao",self.userItem.ItemId,"art");
  print(itemID_int);
  return artData[pszFileID].source;
end

function BagItem:getSellNum()
  return tonumber(analysis("Daoju_Daojubiao",self.userItem.ItemId,"price"));
end

function BagItem:initialize(userItem, isInBag, bagProxy, showCount)
  self:initLayer();

  self.userItem=userItem;
  self.isInBag=isInBag;
  self.showCount=showCount;
  self.bagProxy=bagProxy;
  --self.descb=analysis("Daoju_Daojubiao",self.userItem.ItemId);
  self.const_equipIDs={1100,1101,1102,1103,1104,1105,1106};
	
	--gem
	self.conset_gemIDs={1207};

  self.conset_treasurePIDs={1212,1211,1214};

  if 20 == analysis("Daoju_Daojubiao",self.userItem.ItemId,"functionID") then
    self.clipper = ClippingNodeMask.new(CommonSkeleton:getBoneTextureDisplay("commonImages/linghunshi_mask"));
    self.clipper:setAlphaThreshold(0);
    self:addChild(self.clipper);

    self.image = Image.new();
    self.image:load(self:getPszFileName(self.userItem.ItemId));
    self.clipper:addChild(self.image);
    self.clipper:setContentSize(self.image:getContentSize());

    local mask = CommonSkeleton:getBoneTextureDisplay("commonImages/linghunshi_fg");
    self:addChild(mask);
  else
    self.image = Image.new();
    self.image:load(self:getPszFileName(self.userItem.ItemId));
    self:addChild(self.image);
  end

  -- if 1300==self:getCategoryID() or 1209==self:getCategoryID() then
  --   if 1300==self:getCategoryID() then
  --     --self.image:setScale(70/110);
  --   end
  --   self.puzzle=CommonSkeleton:getBoneTextureDisplay("common_puzzle");
  --   local size=self.image:getContentSize();
  --   size.width=size.width*self.image:getScale();
  --   size.height=size.height*self.image:getScale();
  --   if self.puzzle then
  --     local puzzle_size=self.puzzle:getContentSize();
  --     self.puzzle:setPositionXY((size.width-puzzle_size.width)/2,(size.height-puzzle_size.height)/2);
  --     self:addChild(self.puzzle);
  --   end;
  -- end

  --改 英魂 
  -- local itemId = tonumber(self.userItem.ItemId);
  -- if itemId<1000 and itemId>100 then
  --   --self.image:setScale(70/110);
  -- end

  local categoryImgID=0~=self:getCategoryID() and analysis("Daoju_Daojufenlei",self:getCategoryID(),"artid") or 0;
  if 0~=categoryImgID then
    self.categoryImg=Image.new();
    self.categoryImg:loadByArtID(categoryImgID);
    local size=self.image:getContentSize();
    size.width=size.width*self.image:getScale();
    size.height=size.height*self.image:getScale();
    local category_img_size=self.categoryImg:getContentSize();
    self.categoryImg:setPositionXY(size.width-category_img_size.width,size.height-category_img_size.height);
    self:addChild(self.categoryImg);
  end

  local daoju_data = analysis("Daoju_Daojubiao",self.userItem.ItemId);
  if daoju_data.functionID==4 then
    self.frame_bg=CommonSkeleton:getCommonBoneTextureDisplay("commonGrids/common_grid_" ..getSimpleGrade(daoju_data.color));
  else
    self.frame_bg=CommonSkeleton:getCommonBoneTextureDisplay("commonGrids/common_grid_" ..daoju_data.color);
  end

  local size=self.image:getContentSize();
  size.width=size.width*self.image:getScale();
  size.height=size.height*self.image:getScale();
  local frame_bg_size=self.frame_bg:getContentSize();
  self.frame_bg:setPositionXY((size.width-frame_bg_size.width)/2,(size.height-frame_bg_size.height)/2);
  self:addChild(self.frame_bg);

  local a=self.userItem.Count;
  if not a then
    a="";
  elseif 1==a and not showCount then
    a="";
  end
  local textField=TextField.new(CCLabelTTF:create(a,FontConstConfig.OUR_FONT,22));
  local size=self.image:getContentSize();
  size.width=size.width*self.image:getScale();
  size.height=size.height*self.image:getScale();
  self.img_size = size;
  local sizeText=textField:getContentSize();
  textField:setPositionX(-2+math.floor(size.width-sizeText.width));
  self.textField=textField;
  self:addChild(textField);

  self:refreshBagItemNumBG();
  self:refreshSyntheticable();

  self.grid_over_layer = Layer.new();
  self.grid_over_layer:initLayer();
  self:addChild(self.grid_over_layer);

  if self.isInBag then
    local strengthenLevel = self.userItem.StrengthenLevel;
    if not strengthenLevel then
      local equipData = Facade:getInstance():retrieveProxy(EquipmentInfoProxy.name):getEquipInfoByHeroIDAndItemID(self.userItem.GeneralId,self.userItem.ItemId);
      if equipData then
        strengthenLevel = equipData.StrengthenLevel;
      else
        strengthenLevel = 0;
      end
    end
    
    if 0 < strengthenLevel then
      local bg = CommonSkeleton:getBoneTextureDisplay("commonImages/common_xiaomodi");
      self:addChild(bg);

      local textField=TextField.new(CCLabelTTF:create("+" .. strengthenLevel,FontConstConfig.OUR_FONT,18));
      local size=self.image:getContentSize();
      local sizeText=textField:getContentSize();
      textField:setPositionXY(-10, 10 + math.floor(size.height-sizeText.height));
      bg:setPositionXY(-10, 7 + math.floor(size.height-sizeText.height));
      self:addChild(textField);
      self.strengthenTextField=textField;
    end
  end
  
  self.touchEnabled=false;
  self.touchChildren=false;
end

function BagItem:refreshBagItemNumBG()
  local textFieldContentSize = self.textField:getContentSize();
  if self.textField_bg then
    self:removeChild(self.textField_bg);
    self.textField_bg = nil;
  end
  self.textField_bg = CommonSkeleton:getBoneTexture9DisplayBySize("commonImages/common_item_num_bg",nil,makeSize(5+textFieldContentSize.width,textFieldContentSize.height));
  self.textField_bg.touchEnable = false;
  self.textField_bg.touchChildren = false;
  self.textField_bg:setPositionXY(self.img_size.width-self.textField_bg:getContentSize().width,0);
  self:addChild(self.textField_bg);
  self:removeChild(self.textField,false);
  self:addChild(self.textField);
  local s = self.textField:getString();
  self.textField_bg:setVisible("" ~= s and " " ~= s);
end

function BagItem:refreshSyntheticable()
  -- if self.synthetic_img then
  --   self:removeChild(self.synthetic_img);
  --   self.synthetic_img=nil;
  -- end
  -- if self.isInBag and self:getSyntheticableByCount() then
  --   self.synthetic_img=CommonSkeleton:getBoneTextureDisplay("common_he_img");
  --   local size=self.image:getContentSize();
  --   size.width=size.width*self.image:getScale();
  --   size.height=size.height*self.image:getScale();
  --   local synthetic_img_size=self.synthetic_img:getContentSize();
  --   self.synthetic_img:setPositionXY(size.width-synthetic_img_size.width,size.height-synthetic_img_size.height);
  --   self:addChild(self.synthetic_img);
  -- end
end

function BagItem:isArmour()
  return self.const_equipIDs[4]==self:getCategoryID()
end

function BagItem:isBoot()
  return self.const_equipIDs[5]==self:getCategoryID()
end

function BagItem:isEquip()
  -- local a=self:getCategoryID();
  -- for k,v in pairs(self.const_equipIDs) do
  --   if v==a then
  --     return true;
  --   end
  -- end
  -- return false;
  return true == analysisHas("Zhuangbei_Zhuangbeipeizhibiao",self.userItem.ItemId);
end

function BagItem:isHelmet()
  return self.const_equipIDs[3]==self:getCategoryID()
end

function BagItem:isNecklace()
  return self.const_equipIDs[6]==self:getCategoryID()
end

function BagItem:isRing()
  return self.const_equipIDs[7]==self:getCategoryID()
end

function BagItem:isUsable()
  return BagConstConfig.USE_ID_0~=self:getUseID();
end

function BagItem:isWeapon()
  return self.const_equipIDs[2]==self:getCategoryID()
end

function BagItem:isGem()
	return self.conset_gemIDs[1]==self:getCategoryID();
end

function BagItem:isTreasureP()
  return self.conset_treasurePIDs[1]==self:getCategoryID();
end

function BagItem:isTreasure()
  return self.conset_treasurePIDs[2]==self:getCategoryID();
end

function BagItem:isTreasureH()
  return self.conset_treasurePIDs[3]==self:getCategoryID();
end

function BagItem:refreshData()
  local a=self.userItem.Count;
  if 1==a then
    a=" ";
  end

  self:removeChild(self.image);
  self.image = Image.new();
  self.image:load(self:getPszFileName(self.userItem.ItemId));
  self:addChildAt(self.image,0);

  self.textField:setString(a);
  local size=self.image:getContentSize();
  size.width=size.width*self.image:getScale();
  size.height=size.height*self.image:getScale();
  local sizeText=self.textField:getContentSize();
  self.textField:setPositionX(math.floor(size.width-sizeText.width));
  self:refreshBagItemNumBG();
  self:refreshSyntheticable();
end

function BagItem:getUseID()
  return analysis("Daoju_Daojugongneng",analysis("Daoju_Daojubiao",self.userItem.ItemId,"functionID"),"use");
end

function BagItem:getSyntheticable()
  --return BagConstConfig.USE_ID_8==self:getUseID();
  --return 1==analysis("Daoju_Daojugongneng",analysis("Daoju_Daojubiao",self.userItem.ItemId,"functionID"),"synthesis") and 0~=analysis("Daoju_Daojubiao",self.userItem.ItemId,"parameter3");
  return 4==analysis("Daoju_Daojugongneng",analysis("Daoju_Daojubiao",self.userItem.ItemId,"functionID"),"use") and 0~=analysis("Daoju_Daojubiao",self.userItem.ItemId,"parameter3");
end

function BagItem:getSyntheticableByCount()
  if self:getSyntheticable() then
    local syntheticItemID=analysis("Daoju_Daojubiao",self.userItem.ItemId,"parameter3");
    local min=analysis("Daoju_Hecheng",syntheticItemID,"need");
    min=StringUtils:stuff_string_split(min);
    min=tonumber(min[1][2]);
    return min<=self.bagProxy:getItemNum(self.userItem.ItemId);
  end
  return false;
end

function BagItem:getBatchUsable()
  return 1==analysis("Daoju_Daojugongneng",analysis("Daoju_Daojubiao",self.userItem.ItemId,"functionID"),"batch");
end

function BagItem:getIsConfirm4Sell()
  return 1==analysis("Daoju_Daojugongneng",analysis("Daoju_Daojubiao",self.userItem.ItemId,"functionID"),"sale");
end

function BagItem:getBatchSynthesisble()
  return 1==analysis("Daoju_Daojugongneng",analysis("Daoju_Daojubiao",self.userItem.ItemId,"functionID"),"batchsynthesis");
end

function BagItem:setBorderVisible(boo)
  self.frame_bg:setVisible(boo);
end

function BagItem:setImageGray(boo)
  self:removeChild(self.image);
  self.image = Sprite.new(getGrayTexture(self:getPszFileName(self.userItem.ItemId)))
  self:addChildAt(self.image,self.common_grid and 1 or 0);
end

function BagItem:setBackgroundVisible(boo)
  if boo then
    self.common_grid=CommonSkeleton:getBoneTextureDisplay("commonGrids/common_grid");


    local size=self.image:getContentSize();
    size.width=size.width*self.image:getScale();
    size.height=size.height*self.image:getScale();

    local gridSize = self.common_grid:getContentSize();

    local xPos = (size.width - gridSize.width)/2
    local yPos = (size.height - gridSize.height)/2
    self:addChildAt(self.common_grid,0);
    self.common_grid:setPositionXY(xPos, yPos);
  end
end

function BagItem:setFrameVisible(bool)
  if self.frame_bg then
    self.frame_bg:setVisible(bool);
  end
end

function BagItem:setTextString(s, color)
  self.textField:setString(s);
  local size=self.image:getContentSize();
  size.width=size.width*self.image:getScale();
  size.height=size.height*self.image:getScale();
  local sizeText=self.textField:getContentSize();
  self.textField:setPositionX(math.floor(size.width-sizeText.width));
  if color then
    self.textField:setColor(color);
  end
  self:refreshBagItemNumBG();
end
function BagItem:getItemSize()
  return self.frame_bg:getContentSize();
end