--=====================================================
-- 图标容器
-- by zhaoxin
-- (c) copyright 2009 - 2013, www.happyelements.com
-- All Rights Reserved. 
--=====================================================
-- filename:  IconContainer.lua
-- descrip:    处理图标容器的显示逻辑
--=====================================================

IconContainer = class(TouchLayer);

-- 构造函数
function IconContainer:ctor()
	self.class = IconContainer;
end

-- 初始化
function IconContainer:initialize(bg)
	self.bg = bg;
	self:addChild(bg);

end
-- 初始化
function IconContainer:setBg(img)
	img:setPositionXY((self.bg:getContentSize().width-img:getContentSize().width)/2, 
			self.bg:getContentSize().height/2 - img:getContentSize().height/2);	
	self:addChild(img);	

end
-- 销毁组件
function IconContainer:dispose()
	self.display = nil;
	TouchLayer.dispose(self);
end

-- 创建实例
function IconContainer:create()
	local bg = CommonSkeleton:getBoneTextureDisplay("commonImages/common_equipe_bg");
	local container = IconContainer.new();
	container:initLayer();
	container:initialize(bg);
	return container;
end

function IconContainer:clone()
  -- local userItem={};
  -- for k,v in pairs(self.userItem) do
  --   userItem[k]=v;
  -- end
  -- local bagItem=BagItem.new();
  -- userItem.Count=1;
  -- bagItem:initialize(userItem);
  -- return bagItem;

  local bagItem=BagItem.new();
  bagItem:initialize({UserItemId = self.UserItemId, ItemId = self.itemId, Count = 1});
  return bagItem;
  -- local iconContainer = IconContainer:create();
  -- local tempSkeleton = getSkeletonByName("hero_ui");
  -- local img = tempSkeleton:getBoneTextureDisplay("heroComponent/装备/tfImg"..self.id);
  -- iconContainer:setBg(img);
  -- iconContainer:setItem(4);
  -- iconContainer:setItemId(6400002);
  -- return iconContainer;
end

-- 设置道具
function IconContainer:setItem(artId)
	if self.itemImg then
		self:removeChild(self.itemImg);
	    self.itemImg = getImageByArtId(artId)
	    self:addChild(self.itemImg);
	else
	    self.itemImg = getImageByArtId(artId)
	    self:addChild(self.itemImg);
	end;
	self.itemImg:setPositionXY((self.bg:getContentSize().width-self.itemImg:getContentSize().width)/2, 
	self.bg:getContentSize().height/2 - self.itemImg:getContentSize().height/2);	
end


function IconContainer:getItemData()
	return {UserItemId = self.UserItemId,ItemId = self.itemId};
end;
-- 移除道具
function IconContainer:removeItem()
	if self.itemImg then
		self:removeChild(self.itemImg);
		self.itemImg = nil;
	end;
end

-- 设置id
function IconContainer:setId(id)
	self.id = id;
end

-- 设置itemId
function IconContainer:setItemId(itemId)
	self.itemId = itemId;
end

-- 设置itemId
function IconContainer:setUserItemId(UserItemId)
	self.UserItemId = UserItemId;
end

-- 返回内容尺寸
function IconContainer:getContentSize()
	return self.bg:getContentSize();
end


-- -- 触摸事件监听
-- local function onTouchTap(event)
-- 	local container = event.context;

-- 	if container.toggle then
-- 		-- 开关模式
-- 		container:setSelected(not container.selected);
-- 	end

-- 	-- 发送事件
-- 	container:dispatchEvent(Event.new(Events.kStart, nil, container, event.globalPosition));
-- end
-- -- 返回内容尺寸
-- function IconContainer:getContentSize()
-- 	return self.enabledBackground:getContentSize();
-- end

-- -- 设置数量或者等级，反正就是一个文本
-- function IconContainer:setCount(count)
-- 	if count then
-- 		local countStr = "";
-- 		if tonumber(count) then
-- 			countStr = thousandsOf(count);
-- 		else
-- 			countStr = count;
-- 		end
-- 		self:setCountLabel(countStr);
-- 	else
-- 		self:setCountLabel(nil);
-- 	end
-- end

-- -- 设置数量标签文字
-- function IconContainer:setCountLabel(value)
-- 	if value then
-- 		if not self.countLabel then
-- 			self.countLabel = BitmapText:create("", "fnts/MSYH_hui_22.fnt");
-- 			local size = self.display:getChildByName("rect"):getContentSize();

-- 			if self.style == 1 then  -- style : 1.背包道具 2.弟子列表 3.技能
-- 				self.countLabel:setAnchorPoint(ccp(1, 0));
-- 				self.countLabel:setPositionXY(size.width - 15 , - size.height + 10);
-- 			elseif self.style == 2 then
-- 				self.countLabel:setAnchorPoint(ccp(0, 0));
-- 				self.countLabel:setPositionXY(15 , -45);
-- 			elseif self.style == 3 then
-- 				self.countLabel:setAnchorPoint(ccp(0.5, 0.5));
-- 				self.countLabel:setPositionXY(size.width/2, - size.height + 30);
-- 			end
-- 			self.countLabel:setColor(ccc3(255,255,255));
-- 			self.display:addChild(self.countLabel);
-- 		end
-- 		self.countLabel:setString(value);
-- 		self.countLabel:setVisible(true);
-- 	else
-- 		if self.countLabel then
-- 			self.countLabel:setVisible(false);
-- 		end
-- 	end
-- end

-- -- 添加图标
-- function IconContainer:setIcon(icon, bEffect)
-- 	self:removeIcon();
	
-- 	if not bEffect then
-- 		--普通图标
-- 		self.icon = TextureManager:getSpriteByName(icon);
-- 		self.icon.name = "icon";
-- 		self.icon:setAnchorPoint(ccp(0, 1));

-- 		local size = nil;
-- 		if self.style == 1 then
-- 			size = CCSizeMake(85, 85);
-- 		elseif self.style == 2 then
-- 			size = CCSizeMake(120, 120);
-- 		elseif self.style == 3 then
-- 			size = CCSizeMake(95, 95);
-- 		end

-- 		local scales = caculateScales(self.icon, size);
-- 		self.icon:setScaleX(scales.scaleX);
-- 		self.icon:setScaleY(scales.scaleY);

-- 		if self.style == 3 then
-- 			local btnDisplay = TextureManager:getImage("skill_mask.pvr.ccz");
-- 			btnDisplay:setAnchorPoint(ccp(0,1));
-- 			local skillClippingNode = ClippingNode:create(CCRectMake(0, 0, 1, 1), self.icon, btnDisplay);
-- 			skillClippingNode:setAlphaThreshold(0.0);
-- 			self.icon = skillClippingNode;
-- 		end

-- 		self.icon_cell:addChild(self.icon);
-- 	else
-- 		--特技(目前是真气)
-- 		ResourceManager:loadAniGroup(icon, AnimationTypes.kEffect);
-- 		self.icon = AnimationNode:create(icon);
-- 		self.icon_cell:addChild(self.icon);
-- 		self.icon:setPositionXY(43, -44);
-- 		self.icon:playAction("", "");
-- 	end

-- 	self:update();
-- end

-- -- 移除图标
-- function IconContainer:removeIcon()
-- 	if self.icon then
-- 		self:setQuality(0);
-- 		self:setCount();
-- 		self.icon_cell:removeChildren(true);
-- 		self.icon = nil;
-- 		if self.suipianImg then
-- 			self.suipianImg:setVisible(false);
-- 		end;
-- 	end
-- end

-- -- 设置是否可用
-- function IconContainer:setEnabled(value)
-- 	if value ~= self.enabled then
-- 		self.enabled = value;

-- 		if self.disabledBackground then
-- 			if value then
-- 				self.disabledBackground:setVisible(not value);
-- 			else
-- 				if not self.lockPic then
-- 					self.lockPic = TextureManager:getImage(self.disabledOrLockedPic..".pvr.ccz");
-- 					self.lockPic:setAnchorPoint(ccp(0,1));
-- 					self.disabledBackground:addChild(self.lockPic);
-- 				end
-- 				self.disabledBackground:setVisible(not value);
-- 			end
-- 		end
-- 	end
-- end

-- -- 设置是否处于选中状态
-- function IconContainer:setSelected(value)
-- 	if self.selected ~= value then
-- 		self.selected = value;
-- 		self:updateSelect();
-- 	end
-- end

-- -- 设置是否使用开关模式
-- function IconContainer:setToggle(value)
-- 	self.toggle = value;
-- end

-- -- 设置对象品质
-- function IconContainer:setQuality(quality)
-- 	if self.quality ~= quality then
-- 		self.quality = quality;
-- 		self:updateQuality();
-- 	end
-- end

-- -- 更新UI显示
-- function IconContainer:update()
-- 	-- 显示品质边框
-- 	self:updateQuality();
-- 	self:updateSelect();
-- end

-- -- 更新品质颜色框
-- function IconContainer:updateQuality()
-- 	if not self.quality_cell then return end;
	
-- 	if self.quality and self.quality > 0 then
-- 		if self.quality_pic and self.quality_pic.quality == self.quality then
-- 			return
-- 		else
-- 			local name = string.format("%d", self.quality);
-- 			self.quality_pic = TextureManager:getSprite(self.qualityNormalDisplayPrefix, name, ".png");
-- 			self.quality_pic.quality = self.quality;

-- 			self.quality_cell:addSon(self.quality_pic);
-- 		end
		
-- 	else
-- 		if self.quality_pic then
-- 			self.quality_pic.quality = 0;
-- 		end
-- 		self.quality_cell:removeSon();
-- 	end
-- end

-- -- 更新选中状态
-- function IconContainer:updateSelect()
-- 	if not self.select_cell then return end;

-- 	if self.selected then
-- 		if not self.selected_pic then
-- 			self.selected_pic = TextureManager:getSpriteByName(self.qualitySelectedDisplayPrefix..".png");
-- 			self.select_cell:addChild(self.selected_pic);
-- 		end
-- 		self.selected_pic:setVisible(true);
-- 	else
-- 		if self.selected_pic then
-- 			self.selected_pic:setVisible(false);
-- 		end
-- 	end
-- end


