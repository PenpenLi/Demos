



GemBag=class(TouchLayer);

function GemBag:ctor()
  self.class=GemBag;
end


function GemBag:dispose()
	if self.armature then
		self.armature:dispose();
	end
  self:removeAllEventListeners();
  self:removeChildren();
  GemBag.superclass.dispose(self);
	BitmapCacher:removeUnused();
end

function GemBag:initialize(skeleton, context, onGemTap, tapTargetPos, bagProxy)
  self:initLayer();
  
  self.skeleton=skeleton;
  self.context=context;
	self.onGemTap=onGemTap
	self.tapTargetPos = tapTargetPos;
  self.bagProxy=bagProxy;
  self.page_buttons={};
  self.page_button_select=nil;
  self.page_panels={};
	
	self.normalGems = {};
	self.advancedGems = {};

  self.const_column=4;
  self.const_row=3;
  self.const_num=self.const_column*self.const_row;

  local armature_d=skeleton:buildArmature("gem_bag");
  armature_d.animation:gotoAndPlay("f1");
  armature_d:updateBonesZ();
  armature_d:update();
  self.armature = armature_d;
	-- armature_d:getBone("totem_levelup_bg"):getDisplay():setScaleY(0.85);
  self.armature_d=armature_d.display;
	
  self:addChild(self.armature_d);

  local common_copy_page_button=self.armature_d:getChildByName("common_copy_page_button");
  local common_copy_page_button_1=self.armature_d:getChildByName("common_copy_page_button_1");
  local page_button_skew_x=common_copy_page_button_1:getPositionX()-common_copy_page_button:getPositionX();
  local page_button_y=convertBone2LB4Button(common_copy_page_button).y;
  self.armature_d:removeChild(common_copy_page_button);
  self.armature_d:removeChild(common_copy_page_button_1);
	
	self.showIconPos = self.armature_d:getChildByName("common_copy_grid"):getPosition();
	self.showIconPos.x = self.showIconPos.x + ConstConfig.CONST_GRID_ITEM_SKEW_X;
	self.showIconPos.y = self.showIconPos.y - self.armature_d:getChildByName("common_copy_grid"):getContentSize().height + ConstConfig.CONST_GRID_ITEM_SKEW_Y;

  local common_copy_grid=self.armature_d:getChildByName("common_copy_grid_0");
  local common_copy_grid_pos=convertBone2LB(common_copy_grid);
  self.armature_d:removeChild(common_copy_grid);
  local common_copy_grid_1=self.armature_d:getChildByName("common_copy_grid_1");
  self.grid_skew_x=convertBone2LB(common_copy_grid_1).x-common_copy_grid_pos.x;
  self.armature_d:removeChild(common_copy_grid_1);
  local common_copy_grid_2=self.armature_d:getChildByName("common_copy_grid_2");
  self.grid_skew_y=common_copy_grid_pos.y-convertBone2LB(common_copy_grid_2).y;
  self.armature_d:removeChild(common_copy_grid_2);
	
	local gemTable = {};
	local tbl = analysis("Zhuangbeibaoshi_Baoshi");
	local label = tbl[1];
	for k,v in pairs(tbl)do
		if k == 1 then 
		
		else
			local tmp = {}
			for i,j in pairs(label)do
				tmp[j] = v[i]
			end
			gemTable[tmp["gem"]] = tmp;
		end
	end
	
	for k,v in pairs (self.bagProxy:getData()) do
		if nil ~= gemTable[v.ItemId] then
			if gemTable[v.ItemId].type == 1 then 
				-- local tbl = copyTable(v);
				-- tbl.attribute = gemTable[v.ItemId].attribute;
				table.insert(self.normalGems,copyTable(v));
				-- self.normalGems[v.ItemId] = tbl
			elseif gemTable[v.ItemId].type == 2 then
				-- local tbl = copyTable(v);
				-- tbl.attribute = gemTable[v.ItemId].attribute;
				table.insert(self.advancedGems,copyTable(v))
				-- self.advancedGems[v.ItemId] = tbl
			end
		end
	end
	
	local sortFunc = function(a,b)
		local qualityA = analysis("Daoju_Daojubiao",a.ItemId,"color");
		local qualityB = analysis("Daoju_Daojubiao",b.ItemId,"color");
		return qualityA<qualityB;
	end
	
	if self.tapTargetPos >3 then 
		if 0 == table.getn(self.advancedGems) then 
			-- sharedTextAnimateReward():animateStartByString("没有可用的高级宝石哟!");
			sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_213));
			self.context:onSelfTap();
			return;
		end
		self.page_num = math.ceil(table.getn(self.advancedGems)/self.const_num);
	elseif self.tapTargetPos <4 then
		if 0 == table.getn(self.normalGems) then 
			sharedTextAnimateReward():animateStartByString("没有可用的普通宝石哟!");
			self.context:onSelfTap();
			return;
		end
		self.page_num = math.ceil(table.getn(self.normalGems)/self.const_num);
	end
	
	local tab_button_layer=Layer.new();
  tab_button_layer:initLayer();
  local a=0;
  while self.page_num>a do
  	a=1+a;
  	local pageButton=CommonButton.new();
    pageButton:initialize("common_page_button_normal","common_page_button_select",CommonButtonTouchable.DISABLE);
    pageButton:setPositionXY((-1+a)*page_button_skew_x,0);
    tab_button_layer:addChild(pageButton);
    table.insert(self.page_buttons,pageButton);
  end
  local group_size=tab_button_layer:getGroupBounds().size;
  local panel_size=self.armature_d:getChildAt(1):getContentSize();
  tab_button_layer:setPositionXY((panel_size.width-group_size.width)/2,page_button_y);
  self.armature_d:addChild(tab_button_layer);

  --翻页
  self.scrollView=GalleryViewLayer.new();
  self.scrollView:initLayer();
  self.scrollView:setContainerSize(makeSize(self.grid_skew_x*self.const_column*self.page_num, self.grid_skew_y*self.const_row+5));
  self.scrollView:setViewSize(makeSize(self.grid_skew_x*self.const_column,self.grid_skew_y*self.const_row+5));
  self.scrollView:setMaxPage(self.page_num);
  self.scrollView:setDirection(kCCScrollViewDirectionHorizontal);
  self.scrollView:setPositionXY(common_copy_grid_pos.x, common_copy_grid_pos.y-self.grid_skew_y*(-1+self.const_row));
  self.armature_d:addChild(self.scrollView);

  a=0;
  while self.page_num>a do
  	a=1+a;
    local grid_layer=TouchLayer.new();
    grid_layer:initLayer();
    grid_layer:setContentSize(makeSize(self.grid_skew_x*self.const_column,self.grid_skew_y*self.const_row));
    grid_layer:setPositionXY(self.grid_skew_x*self.const_column*(-1+a),3);
    self.scrollView:addContent(grid_layer);
    table.insert(self.page_panels,grid_layer);
  end
  
	a=0;
  if self.tapTargetPos > 3 and nil ~= self.advancedGems then
		table.sort(self.advancedGems,sortFunc);
  	while table.getn(self.advancedGems)>a do
  		a=1+a;
  		local gemIcon=BagItem.new();
  		gemIcon:initialize(self.advancedGems[a]);
			local propId = analysis("Zhuangbeibaoshi_Baoshi",self.advancedGems[a].ItemId,"attribute");
			-- local propId = StringUtils:lua_string_split(propStr,",");
			-- print("propId:"..propId[1]);
			gemIcon.propId = propId;
			gemIcon.place = self.tapTargetPos;
			-- gemIcon.itemData = self.advancedGems[a];
  		gemIcon:setPositionXY(self:grid2Mouse(a));
  		self:getPanelByPlace(a):addChild(gemIcon);
			-- self:getPanelByPlace(a).gemIcon = gemIcon;
			gemIcon:addEventListener(DisplayEvents.kTouchTap, self.onGemIconTap, self, self.tapTargetPos);
			gemIcon.touchEnabled = true;
			gemIcon.touchChildren = true;
  	end
  elseif self.tapTargetPos <= 3 and nil ~= self.normalGems then
		table.sort(self.normalGems,sortFunc);
  	while table.getn(self.normalGems)>a do
  		a=1+a;
  		local gemIcon=BagItem.new();
  		gemIcon:initialize(self.normalGems[a]);
			local propId = analysis("Zhuangbeibaoshi_Baoshi",self.normalGems[a].ItemId,"attribute");
			-- local propId = StringUtils:lua_string_split(propStr,",");
			-- print("propId:"..propId[1]);
			gemIcon.propId = propId;
			gemIcon.place = self.tapTargetPos;
			-- gemIcon.itemData = self.advancedGems[a];
  		gemIcon:setPositionXY(self:grid2Mouse(a));
  		self:getPanelByPlace(a):addChild(gemIcon);
			-- self:getPanelByPlace(a).gemIcon = gemIcon;
			gemIcon:addEventListener(DisplayEvents.kTouchTap, self.onGemIconTap, self, self.tapTargetPos);
			gemIcon.touchEnabled = true;
			gemIcon.touchChildren = true;
  	end
  end
	
	--宝石名字
	local textData = armature_d:getBone("common_copy_grid").textData;
	self.nameText = createTextFieldWithTextData(textData," ");
	self:addChild(self.nameText);
	
	--描述文字
	local textData = armature_d:getBone("common_copy_small_bg_gray").textData;
	self.detailText = createTextFieldWithTextData(textData,"点击宝石图标查看宝石属性");
	self:addChild(self.detailText);
	
	
	--右边按钮
  self.rightButton=self.armature_d:getChildByName("common_copy_blueround_button");
  local right_pos=convertBone2LB4Button(self.rightButton);
  self.armature_d:removeChild(self.rightButton);
	self.rightButton=CommonButton.new();
	self.rightButton:initialize("common_blueround_button_normal","common_blueround_button_down",CommonButtonTouchable.BUTTON);
  self.rightButton:initializeText(armature_d:findChildArmature("common_copy_blueround_button"):getBone("common_copy_blueround_button").textData,"镶嵌");
	self.rightButton:setPosition(right_pos);
	self:addChild(self.rightButton);
	
	
	--左边按钮
	self.leftButton=self.armature_d:getChildByName("common_copy_blueround_button_1");
	local left_pos=convertBone2LB4Button(self.leftButton);
	self.armature_d:removeChild(self.leftButton);
	self.leftButton=CommonButton.new();
	self.leftButton:initialize("common_blueround_button_normal","common_blueround_button_down",CommonButtonTouchable.BUTTON);
	self.leftButton:initializeText(armature_d:findChildArmature("common_copy_blueround_button_1"):getBone("common_copy_blueround_button").textData,"取消");
	self.leftButton:setPosition(left_pos);
	self.leftButton:addEventListener(DisplayEvents.kTouchTap,self.onSelfRemove,self);
	self:addChild(self.leftButton);
	

  self:flipPage(1);
	
	
	self:addEventListener(DisplayEvents.kTouchTap,self.onSelfTap,self)
end

function GemBag:flipPage(num)
	if self.page_button_select then
		self.page_button_select:select(false);
		self.page_button_select=nil;
	end
  if 0==self.page_num then return; end
	self.page_button_select=self.page_buttons[num];
	self.page_button_select:select(true);
end

function GemBag:grid2Mouse(grid_number)
  grid_number=(grid_number-1)%self.const_num;
  return grid_number%self.const_column*self.grid_skew_x+2+5,math.floor((-1+self.const_num-grid_number)/self.const_column)*self.grid_skew_y;
end

function GemBag:getPanelByPlace(place)
  return self.page_panels[1+math.floor((place-1)/self.const_num)];
end

function GemBag:onSelfTap(event)
	self.context.popup_boolean = true;
end

function GemBag:onGemIconTap(event)
	-- if nil ~= self.parent.gemDetailLayer then
		-- self.parent:removeChild(self.parent.gemDetailLayer);
		-- self.parent.gemDetailLayer=nil;
	-- end
	-- self.parent.gemDetailLayer=GemTipLayer.new();
	if self.lastTarget then
		self.lastTarget:removeChild(self.grid_over);
		self.grid_over = nil;
		self.lastTarget = nil;
	end
	self.grid_over=self.skeleton:getCommonBoneTextureDisplay("common_grid_over");
  local size=event.target:getChildAt(0):getContentSize();
  local over_size=self.grid_over:getContentSize();
  self.grid_over:setPositionXY((size.width-over_size.width)/2,(size.height-over_size.height)/2);
  event.target:addChild(self.grid_over);
	self.lastTarget = event.target;
	self.parent.itemListView:setMoveEnabled(false);
	-- self.parent.itemIcon.touchChildren = false;
	-- local leftButtonInfo = {onTap = self.onGemTap, text = "镶嵌"}
	-- local rightButtonInfo = {onTap = self.onGemMerge, text = "合成"}
	if self.showIcon then
		self:removeChild(self.showIcon);
		self.showIcon = nil;
	end
	local cloneTarget = event.target:clone();
	cloneTarget:removeAllEventListeners();
	cloneTarget.propId = event.target.propId;
	cloneTarget.place = self.tapTargetPos;
	cloneTarget.userItem.Count = event.target.userItem.Count;
	cloneTarget:setPosition(self.showIconPos);
	self:addChild(cloneTarget);
	self.showIcon = cloneTarget;
	
	local name=analysis("Daoju_Daojubiao",cloneTarget.userItem.ItemId,"name");
  local quality=analysis("Daoju_Daojubiao",cloneTarget.userItem.ItemId,"color");
	self.nameText:setString(name)
	self.nameText:setColor(CommonUtils:ccc3FromUInt(getColorByQuality(quality)));
	
	local propType = analysis("Wujiang_Wujiangshuxing",analysis("Zhuangbeibaoshi_Baoshi", cloneTarget.userItem.ItemId, "attribute"),"name");
	local propValue;
	if 12070 == math.floor(cloneTarget.userItem.ItemId/100) then
		propValue = analysis("Zhuangbeibaoshi_Baoshi", cloneTarget.userItem.ItemId, "add");
	elseif 12071 == math.floor(cloneTarget.userItem.ItemId/100) then
		propValue = (analysis("Zhuangbeibaoshi_Baoshi", cloneTarget.userItem.ItemId, "percentage") / 1000) .. "% ";
	end
	self.detailText:setString(propType.."+"..propValue);
	
	self.rightButton:removeEventListener(DisplayEvents.kTouchTap,self.context.onGemEquip,self.context);
	self.rightButton:addEventListener(DisplayEvents.kTouchTap,self.context.onGemEquip,self.context,self.showIcon)
	
	
	self.parent.popup_boolean = true;
end

function GemBag:onGemMerge(event,gemTarget)
	local sendTable = {UserItemId = gemTarget.userItem.UserItemId};
	local countNeed = analysis("Zhuangbeibaoshi_Baoshi", gemTarget.userItem.ItemId, "number");
	if countNeed > gemTarget.userItem.Count then 
		sharedTextAnimateReward():animateStartByString("合成材料不足!需要"..countNeed.."个,已有"..gemTarget.userItem.Count.."个");
		return;
	end
	local nextGemLv = analysis("Zhuangbeibaoshi_Baoshi",gemTarget.userItem.ItemId,"stor");
	if nil == nextGemLv then
		sharedTextAnimateReward():animateStartByString("没有更高的品质的宝石能合成了");
		return;
	end
	sendMessage(10,11,sendTable);
end

function GemBag:onSelfTap()
	self.parent.popup_boolean = true;
end

function GemBag:onSelfRemove()
	self.context:removeChild(self.context.gemBag);
	self.context.gemBag=nil;
	self.context.itemListView:setMoveEnabled(true);
end	