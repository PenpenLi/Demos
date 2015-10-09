--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

PossessionMemberUI=class(TouchLayer);

function PossessionMemberUI:ctor()
  self.class=PossessionMemberUI;
end

function PossessionMemberUI:dispose()
  self.parent_container.memberUI=nil;
  self:removeAllEventListeners();
  self:removeChildren();
	PossessionMemberUI.superclass.dispose(self);
  self.armature4dispose:dispose();
  BitmapCacher:removeUnused();
end

--
function PossessionMemberUI:initializeUI(skeleton, parent_container, mapID, id, data)
  self:initLayer();
  self.skeleton=skeleton;
  self.parent_container=parent_container;
  self.possessionBattleProxy=self.parent_container.possessionBattleProxy;
  self.const_item_num=5;
  self.mapID=mapID;
  self.id=id;
  self.data=data;
  self.layers={};
  self.items={};
  local function sf(a, b)
    if 0==a.MapId and 0~=b.MapId then
      return true;
    elseif 0~=a.MapId and 0==b.MapId then
      return false;
    end
    return a.Level>b.Level;
  end
  table.sort(self.data,sf);

  local bg=LayerColorBackGround:getBackGround();
  bg:addEventListener(DisplayEvents.kTouchBegin,self.onCloseButtonTap,self);
  bg:setPositionXY(-1 * GameData.uiOffsetX,-1 * GameData.uiOffsetY);
  self:addChild(bg);
  --骨骼
  local armature=skeleton:buildArmature("member_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  local text="成员名称";
  local text_data=armature:getBone("name_descb").textData;
  self.name_descb=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.name_descb);

  text="等级";
  text_data=armature:getBone("level_descb").textData;
  self.level_descb=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.level_descb);

  text="战力";
  text_data=armature:getBone("zhanli_descb").textData;
  self.zhanli_descb=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.zhanli_descb);

  text="操作";
  text_data=armature:getBone("operation_descb").textData;
  self.operation_descb=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.operation_descb);

  self.left_button=Button.new(armature:findChildArmature("common_copy_left_button"),false);
  self.left_button:addEventListener(Events.kStart,self.onLeftButtonTap,self);
  self.right_button=Button.new(armature:findChildArmature("common_copy_right_button"),false);
  self.right_button:addEventListener(Events.kStart,self.onRightButtonTap,self);

  local size=Director:sharedDirector():getWinSize();
  self:changeWidthAndHeight(size.width,size.height);
  size=makeSize(GameConfig.STAGE_WIDTH,GameConfig.STAGE_HEIGHT);
  local popupSize=self.armature:getChildByName("common_copy_bigl_bg"):getContentSize();
  self.armature:setPositionXY(math.floor((size.width-popupSize.width)/2),math.floor((size.height-popupSize.height)/2));
  self:refreshGalleryViewLayer();
end

--移除
function PossessionMemberUI:onCloseButtonTap(event)
  self.parent_container:removeChild(self);
end

function PossessionMemberUI:onLeftButtonTap(event)
  self.item_layer:setPage(-1+self.item_layer:getCurrentPage(),true);
end

function PossessionMemberUI:onRightButtonTap(event)
  self.item_layer:setPage(1+self.item_layer:getCurrentPage(),true);
end

function PossessionMemberUI:refreshButton()
  self.left_button:getDisplay():setVisible(1<self.item_layer:getCurrentPage());
  self.right_button:getDisplay():setVisible(self.const_page>self.item_layer:getCurrentPage());
  if self.const_item_num*self.item_layer:getCurrentPage()>table.getn(self.items) then
    local a=self.const_item_num*(-1+self.item_layer:getCurrentPage());
    local b=0;
    while self.const_item_num>b do
      b=1+b;
      local member_data=self.data[a+b];
      if member_data then
        local member=PossessionMemberItem.new();
        member:initializeUI(self.skeleton,self.parent_container,self,a+b,self.mapID,self.id,member_data);
        member:setPositionY(self.member_item_bg_size.height*(self.const_item_num-b));
        self.layers[self.item_layer:getCurrentPage()]:addChild(member);
        table.insert(self.items,member);
      end
    end
  end
end

function PossessionMemberUI:refreshGalleryViewLayer()
  local member_item_bg=self.skeleton:getBoneTextureDisplay("member_item_bg_4_possession");
  local size=member_item_bg:getContentSize();
  self.member_item_bg_size=size;
  member_item_bg:dispose();
  self.const_page=math.ceil(table.getn(self.data)/self.const_item_num);
  self.item_layer=GalleryViewLayer.new();
  self.item_layer:initLayer();
  self.item_layer:setViewSize(makeSize(size.width,self.const_item_num*size.height));
  self.item_layer:setContainerSize(makeSize(self.const_page*size.width,self.const_item_num*size.height));
  self.item_layer:setPositionXY(66,44);
  self.item_layer:setMaxPage(self.const_page);
  local function refreshButton()
    self:refreshButton();
  end
  self.item_layer:addFlipPageCompleteHandler(refreshButton);
  self.armature:addChildAt(self.item_layer,3);
  local a=0;
  while self.const_page>a do
    a=1+a;
    local layer=Layer.new();
    layer:initLayer();
    layer:setPositionX((-1+a)*size.width);
    self.item_layer:addContent(layer);
    table.insert(self.layers,layer);
  end
  self:refreshButton();
end