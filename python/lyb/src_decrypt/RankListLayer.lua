RankListLayer=class(TouchLayer);

function RankListLayer:ctor()
  self.class=RankListLayer;
end

function RankListLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	RankListLayer.superclass.dispose(self);
  self.removeArmature:dispose();
  BitmapCacher:removeUnused();
end

function RankListLayer:initialize(context, data)
  self.context = context;
  self.data = data;

  self:initLayer();
  
  --骨骼
  local armature=skeleton:buildArmature("rank_list_all_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.removeArmature = armature;
  self.armature=armature.display;
  self:addChild(self.armature);


  local item=self.armature:getChildByName("common_copy_button_bg_1");
  local item_over=self.skeleton:getCommonBoneTextureDisplay("common_inner_tab_button_down");
  self.item_size=item_over:getContentSize();
  self.item_size.height=2+self.item_size.height;
  item_over:dispose();
  local item_pos=item:getPosition();

  local scroll_item=self.armature:getChildByName("common_copy_button_bg");
  self.scroll_item_size=self.skeleton:buildArmature("scroll_item");
  self.scroll_item_size.animation:gotoAndPlay("f1");
  self.scroll_item_size:updateBonesZ();
  self.scroll_item_size:update();
  local item4Dispose=self.scroll_item_size;
  self.scroll_item_size=self.scroll_item_size.display:getGroupBounds(false).size;
  self.scroll_item_size=makeSize(5+self.scroll_item_size.width,6+self.scroll_item_size.height);
  self.scroll_item_pos=scroll_item:getPosition();
  item4Dispose:dispose();

  self.name_img=self.armature:getChildByName("name");
  self.name_2_img=self.armature:getChildByName("name_2");

  --level
  local text="";
  local text_data=armature:getBone("level").textData;
  self.level=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.level);

  --level_2
  text="";
  text_data=armature:getBone("level_2").textData;
  self.level_2=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.level_2);

  --text
  text="";
  text_data=armature:getBone("text").textData;
  self.text_new=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.text_new);

  --user_rank_descb
  text="<content><font color='#FFFFFF'>我的排名 </font><font color='#00FF00'>" .. 1 .. "</font><font color='#FFFFFF'> 名</font></content>";
  text_data=armature:getBone("user_rank_descb").textData;
  self.user_rank_descb=createMultiColoredLabelWithTextData(text_data,text);
  self.armature:addChild(self.user_rank_descb);

  --count_descb
  text="";
  text_data=armature:getBone("count_descb").textData;
  self.count_descb=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.count_descb);

  --page_descb
  text="";
  text_data=armature:getBone("page_descb").textData;
  self.page_descb=createTextFieldWithTextData(text_data,text);
  self.page_descb.touchEnabled=false;
  self.armature:addChild(self.page_descb);

  --item
  self.item_layer=ListScrollViewLayer.new();
  self.item_layer:initLayer();
  self.item_layer:setPositionXY(item_pos.x,item_pos.y-self.const_item_num*self.item_size.height);
  self.item_layer:setViewSize(makeSize(self.item_size.width,
                                       self.const_item_num*self.item_size.height));
  self.item_layer:setItemSize(self.item_size);
  self.armature:addChild(self.item_layer);
  self:refreshItemLayer();

  local button=Button.new(armature:findChildArmature("common_copy_left_button"),false);
  button:addEventListener(Events.kStart,self.onLeftButtonTap,self);
  self.leftButton=button;

  button=Button.new(armature:findChildArmature("common_copy_right_button"),false);
  button:addEventListener(Events.kStart,self.onRightButtonTap,self);
  self.rightButton=button;

  --touchLayer  
  self.touchLayer=CommonLayer.new();
  self.touchLayer:initialize(self.scroll_item_size.width,6*self.scroll_item_size.height,self,nil,self.onCommonLayerTap,self.onCommonLayerScroll);
  self.touchLayer:setPositionXY(self.scroll_item_pos.x,self.scroll_item_pos.y-6*self.scroll_item_size.height);
  self.armature:addChild(self.touchLayer);

  self:onItemTap(self.items[1]);
end

function RankListLayer:changeTab(id)
  for k,v in pairs(self.items) do
    if id==v:getTypeID() then
      self:onItemTap(v);
      return;
    end
  end
end

--移除
function RankListLayer:onCloseButtonTap(event)
  if self.parent then
    self.parent:removeChild(self);
  end
end

function RankListLayer:onLeftButtonTap(event)
  self.item_select:getScrollItemLayer():setPage(-1+self.item_select:getScrollItemLayer():getCurrentPage(),true);
  self:refreshButton();
end

function RankListLayer:onRightButtonTap(event)
  self.item_select:getScrollItemLayer():setPage(1+self.item_select:getScrollItemLayer():getCurrentPage(),true);
  self:refreshButton();
end

function RankListLayer:refreshButton()
  self.leftButton:getDisplay():setVisible(1~=self.item_select:getScrollItemLayer():getCurrentPage());
  self.rightButton:getDisplay():setVisible(self.item_select.max_page~=self.item_select:getScrollItemLayer():getCurrentPage());
  if self.item_select.max_page then
    local page=0==self.item_select.max_page and 0 or self.item_select:getScrollItemLayer():getCurrentPage();
    self.page_descb:setString("页数:" .. page .. "/" .. self.item_select.max_page);
  end
end

function RankListLayer:onItemTap(rankListItem)
  if self.item_select then
    self.armature:removeChild(self.item_select:getScrollItemLayer(),false);
    self.item_select:select(false);
    self.item_select=nil;
  end
  self.item_select=rankListItem;
  self.armature:addChildAt(rankListItem:getScrollItemLayer(),3);
  self.item_select:select(true);
  self:refreshButton();
  
  local a=rankListItem:getTypeID();
  if self.parent_container.const_type_5==a or self.parent_container.const_type_8==a then
    self.name_img:setVisible(false);
    self.name_2_img:setVisible(true);
    self.level_2:setString(self.parent_container.const_type_5==a and "宠物名字" or "英魂名字");
    self.text_new:setString("");
  elseif self.parent_container.const_type_9==a then
    self.name_img:setVisible(false);
    self.name_2_img:setVisible(false);
    self.level_2:setString("家族人数");
    self.text_new:setString("家族名字");
  else
    self.name_img:setVisible(true);
    self.name_2_img:setVisible(false);
    self.level_2:setString("");
    self.text_new:setString("");
  end
  if self.parent_container.const_type_1==a then
    a="等级";
  elseif self.parent_container.const_type_7==a then
    a="名次";
  elseif self.parent_container.const_type_9==a then
    a="等级";
  elseif self.parent_container.const_type_10==a then
    a="银两";
  else
    a="战力";
  end
  self.level:setString(a);
  self.count_descb:setString(analysis("Paixing_Paixingbang",rankListItem:getTypeID(),"txt"));

  self.parent_container:requestData({Type=rankListItem:getTypeID()});
  self:refreshUserText();
end

function RankListLayer:onCommonLayerTap(x, y)
  local pos=ccp(x,y);
  y=self.touchLayer:getPositionY()-y+6*self.scroll_item_size.height;
  y=math.ceil(y/self.scroll_item_size.height);
  if self.item_select then
    self.item_select:onCommonLayerTap(y,{globalPosition=pos});
  end
end

function RankListLayer:onCommonLayerScroll(a)
  if 0>a then
    self:onLeftButtonTap();
  else
    self:onRightButtonTap();
  end
end

function RankListLayer:refresh(type, rankArray)
  for k,v in pairs(self.items) do
    if type==v:getTypeID() then
      v:refresh(rankArray);
      break;
    end
  end
  self:refreshUserText();
  self:refreshButton();
end

function RankListLayer:refreshUserText()
  local rankListItem=self.item_select;
  local a=rankListItem:getUserRank();
  local s=analysis("Paixing_Paixingbang",rankListItem:getTypeID(),"whether");
  s=StringUtils:lua_string_split(s,"#");
  if 0==a then
    self.user_rank_descb:setString("<content><font color='#FFFFFF'>" .. s[1] .. "</font></content>");
  else
    s=s[2];
    s=string.gsub(s,"@1",a);
    self.user_rank_descb:setString("<content><font color='#00FF00'>" .. s .. "</font></content>");
  end
end

function RankListLayer:refreshItemLayer()
  local temptable=analysisTotalTable("Paixing_Paixingbang");
  table.remove(temptable,1);
  local tab={};
  function sf(a, b)
    return analysis("Paixing_Paixingbang",a.id,"sort")<analysis("Paixing_Paixingbang",b.id,"sort");
  end
  for k,v in pairs(temptable) do
    if 1==analysis("Paixing_Paixingbang",v.id,"do") then
      table.insert(tab,v);
    end
  end
  table.sort(tab,sf);
  temptable=tab;
  local a;
  for k,v in pairs(temptable) do
    a=v.id;
    local item=RankListItem.new();
    item:initialize(self.skeleton,self.rankListProxy,a,self,self.onItemTap,self.parent_container,self);
    table.insert(self.items,item);
    self.item_layer:addItem(item);
  end
end