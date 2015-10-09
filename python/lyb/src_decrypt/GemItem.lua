
GemItem=class(Layer);

function GemItem:ctor()
  self.class=GemItem;
end

function GemItem:initialize(gemItemId,showName,bagProxy)
  self:initLayer();

  self.gemItemId=gemItemId;
  self.bagProxy=bagProxy;
  self.descb=analysis("Daoju_Daojubiao",self.gemItemId);
  self.image = Image.new();
  self.image:load(self:getPszFileName(self.gemItemId));
  self:addChild(self.image);

	local categoryImgID = analysis("Daoju_Daojufenlei",1207,"artid") or 0;
  if 0 ~= categoryImgID then
    self.categoryImg=Image.new();
    self.categoryImg:loadByArtID(categoryImgID);
    local size=self.image:getContentSize();
    local category_img_size=self.categoryImg:getContentSize();
    self.categoryImg:setPositionY(size.height-category_img_size.height);
    self:addChild(self.categoryImg);
  end
	
	
  self.frame_bg=CommonSkeleton:getBoneTextureDisplay("common_color_grid_for_item_" .. analysis("Daoju_Daojubiao",self.gemItemId,"color"));
  local size=self.image:getContentSize();
  local frame_bg_size=self.frame_bg:getContentSize();
  self.frame_bg:setPositionXY((size.width-frame_bg_size.width)/2,(size.height-frame_bg_size.height)/2);
  self:addChild(self.frame_bg);
	
	local propStr = analysis("Zhuangbeibaoshi_Baoshi",self.gemItemId,"attribute");
	local propId = StringUtils:lua_string_split(propStr,",");
	-- print("propId:"..propId[1]);
	self.propId = propId;
	-- self:setPositionXY((size.width-frame_bg_size.width)/2,(size.height-frame_bg_size.height)/2)
	
	if showName then
		local name = analysis("Zhuangbeibaoshi_Baoshi",self.gemItemId,"name");
		local color = CommonUtils:ccc3FromUInt(getColorByQuality(analysis("Daoju_Daojubiao",self.gemItemId,"color")));
		local textField = TextField.new(CCLabelTTF:create(name,GameConfig.DEFAULT_FONT_NAME,22),true);
		textField:setColor(color);
		textField:setPositionXY((self.image:getContentSize().width-textField:getContentSize().width)/2, -5-textField:getContentSize().height);
		self:addChild(textField);
	end
end

function GemItem:getItemData()
  return self.userItem;
end

function GemItem:getPszFileName(itemID_int)
  local pszFileID=analysis("Daoju_Daojubiao",itemID_int,"art");
  return artData[pszFileID].source;
end

function GemItem:clone()
  local gemItem=GemItem.new();
  gemItem:initialize(self.gemItemId);
	gemItem.pos = self.pos;
	gemItem.place = self.place;
	gemItem.userItem = copyTable(self.userItem);
  return gemItem;
end

function GemItem:dispose()
	self:removeAllEventListeners();
	self:removeChildren();
	GemItem.superclass.dispose(self);
end

function GemItem:getSyntheticable()
  --return BagConstConfig.USE_ID_8==self:getUseID();
  return 1==analysis("Daoju_Daojugongneng",analysis("Daoju_Daojubiao",self.userItem.ItemId,"functionID"),"synthesis") and 0~=analysis("Daoju_Daojubiao",self.userItem.ItemId,"parameter3");
end

function GemItem:getSyntheticableByCount()
  if self:getSyntheticable() then
    local syntheticItemID=analysis("Daoju_Daojubiao",self.userItem.ItemId,"parameter3");
    local min=analysis("Daoju_Hecheng",syntheticItemID,"need");
    min=StringUtils:stuff_string_split(min);
    min=tonumber(min[1][2]);
    return min<=self.bagProxy:getItemNum(self.userItem.ItemId);
  end
  return false;
end