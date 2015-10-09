--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-3-13

	yanchuan.xie@happyelements.com
]]

require "core.events.DisplayEvent";
require "main.view.bag.ui.bagPopup.BagItem";
require "main.view.bag.ui.bagPopup.EquipStar";

StuffImg=class(Layer);

function StuffImg:ctor()
  self.class=StuffImg;
end

function StuffImg:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	StuffImg.superclass.dispose(self);
end

function StuffImg:initialize(itemID, itemNum, stuffNum)
  self:initLayer();
  
  self.itemID=itemID;
  self.itemNum=itemNum;
  self.stuffNum=stuffNum;
  self.color=65280;
  if self.itemNum<self.stuffNum then
    self.color=16711680;
  end

  local stuff_bg=CommonSkeleton:getBoneTextureDisplay("common_grid");
  self:addChild(stuff_bg);

  local image = Image.new();
  image:load(self:getPszFileName(itemID));
  image:setPositionXY(ConstConfig.CONST_GRID_ITEM_SKEW_X,ConstConfig.CONST_GRID_ITEM_SKEW_Y);
  self:addChild(image);
  self.image=image;

  local categoryImgID=0~=math.floor(self.itemID/1000) and analysis("Daoju_Daojufenlei",math.floor(self.itemID/1000),"artid") or 0;
  if 0~=categoryImgID then
    self.categoryImg=Image.new();
    self.categoryImg:loadByArtID(categoryImgID);
    local size=self.image:getContentSize();
    local category_img_size=self.categoryImg:getContentSize();
    self.categoryImg:setPositionXY(3,3+size.height-category_img_size.height);
    self:addChild(self.categoryImg);
  end

  self.frame_bg=CommonSkeleton:getBoneTextureDisplay("common_color_grid_for_item_" .. analysis("Daoju_Daojubiao",itemID,"color"));
  local size=stuff_bg:getContentSize();
  local frame_bg_size=self.frame_bg:getContentSize();
  self.frame_bg:setPositionXY((size.width-frame_bg_size.width)/2,(size.height-frame_bg_size.height)/2);
  self:addChild(self.frame_bg);

  local textField=TextField.new(CCLabelTTF:create(itemNum .. "/" .. stuffNum,"Helvetica",20));
  local size=self.frame_bg:getContentSize();
  local sizeText=textField:getContentSize();
  textField:setColor(CommonUtils:ccc3FromUInt(self.color));
  textField:setPositionX(size.width-sizeText.width);
  self:addChild(textField);
end

function StuffImg:getItemID()
  return self.itemID;
end

function StuffImg:getPszFileName(itemID_int)
  local pszFileID=analysis("Daoju_Daojubiao",itemID_int,"art");
  return artData[pszFileID].source;
end