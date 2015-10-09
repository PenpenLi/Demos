HaoyouSonghuaLayer=class(Layer);

function HaoyouSonghuaLayer:ctor()
  self.class=HaoyouSonghuaLayer;
end

function HaoyouSonghuaLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  HaoyouSonghuaLayer.superclass.dispose(self);
  self.armature4dispose:dispose();
end

function HaoyouSonghuaLayer:initialize(context, userID)
  self:initLayer();
  self.context=context;
  self.skeleton=self.context.skeleton;
  self.userID=userID;
  self.layerItems={};
  self.num_select=0;

  --骨骼
  local armature=self.skeleton:buildArmature("songhua_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  self.level=1;--self.context.generalListProxy:getLevel();
  
  self.descb=createTextFieldWithTextData(armature:getBone("bonus_descb").textData,"");
  self.armature:addChild(self.descb);

  local xianhua_data_1 = analysis("Zhujiao_Haoyousonghua",1);
  local xianhua_data_2 = analysis("Zhujiao_Haoyousonghua",2);
  local xianhua_data_3 = analysis("Zhujiao_Haoyousonghua",3);

  local name_1=createTextFieldWithTextData(armature:getBone("name_descb_1").textData,xianhua_data_1.name);
  self.armature:addChild(name_1);
  local name_2=createTextFieldWithTextData(armature:getBone("name_descb_2").textData,xianhua_data_2.name);
  self.armature:addChild(name_2);
  local name_3=createTextFieldWithTextData(armature:getBone("name_descb_3").textData,xianhua_data_3.name);
  self.armature:addChild(name_3);

  self.silver_2 = xianhua_data_2.voice;
  self.silver_2 = StringUtils:lua_string_split(self.silver_2,",");
  self.silver_2 = tonumber(self.silver_2[2]);
  local currency_2=createTextFieldWithTextData(armature:getBone("silver_2").textData,self.silver_2);
  self.armature:addChild(currency_2);

  self.silver_3 = xianhua_data_2.voice;
  self.silver_3 = StringUtils:lua_string_split(self.silver_3,",");
  self.silver_3 = tonumber(self.silver_3[2]);
  local currency_3=createTextFieldWithTextData(armature:getBone("silver_3").textData,silver_3);
  self.armature:addChild(currency_3);

  local item_descb_1=createTextFieldWithTextData(armature:getBone("item_descb_1").textData,"获得主角经验 " .. xianhua_data_1.giveexp);
  self.armature:addChild(item_descb_1);
  local item_descb_2=createTextFieldWithTextData(armature:getBone("item_descb_2").textData,"获得主角经验 " .. xianhua_data_2.giveexp);
  self.armature:addChild(item_descb_2);
  local item_descb_3=createTextFieldWithTextData(armature:getBone("item_descb_3").textData,"获得主角经验 " .. xianhua_data_3.giveexp);
  self.armature:addChild(item_descb_3);

  for i=1,3 do
    self.button=Button.new(armature:findChildArmature("btn_" .. i),false);
    self.button.bone:initTextFieldWithString("common_small_blue_button","赠送");
    self.button:addEventListener(Events.kStart,self.onButtonTap,self,i);
  end

  self.tipBg=LayerColorBackGround:getTransBackGround();
  self.tipBg:addEventListener(DisplayEvents.kTouchTap,self.onSelfTap,self);
  self:addChildAt(self.tipBg,0);

  local size = Director:sharedDirector():getWinSize();
  local self_size = self.armature:getGroupBounds().size;
  self.armature:setPositionXY(size.width/2-self_size.width/2,size.height/2-self_size.height/2);

  -- local layer_size=self.armature:getChildByName("item_bg_1"):getContentSize();
  -- local _count = 0;
  -- while 3>_count do
  --   _count = 1 + _count;

  --   local layer = Layer.new();
  --   layer:initLayer();
  --   layer:setContentSize(layer_size);
  --   layer.sprite:setAnchorPoint(transLayerAnchor(0,1));
  --   layer:setPosition(self.armature:getChildByName("item_bg_" .. _count):getPosition());
  --   layer:addEventListener(DisplayEvents.kTouchTap,self.onLayerItemTap,self,_count);
  --   self.armature:addChild(layer);
  --   table.insert(self.layerItems,layer);
  -- end

  self.closeButton =self.armature4dispose.display:getChildByName("close_btn");
  SingleButton:create(self.closeButton);
  self.closeButton:addEventListener(DisplayEvents.kTouchTap, self.onSelfTap, self);
end

function HaoyouSonghuaLayer:onButtonTap(event, i)
  if 0 == self.num_select then
    return;
  end
  self.context:onFlowerTap(self.num_select, self.buddyItemSlotData);
  self:onSelfTap();
end

function HaoyouSonghuaLayer:onSelfTap()
  self.parent:removeChild(self);
  self.context.haoyouSonghuaLayer = nil;
end

-- function HaoyouSonghuaLayer:onLayerItemTap(event, num)
--   self.num_select=num;
--   if not self.item_over_img then
--     self.item_over_img=self.skeleton:getBoneTexture9DisplayBySize("buddyImages/buddy_flower_scroll_item_over",true,makeSize(380,122));
--     self.armature:addChild(self.item_over_img);
--   end
--   self.item_over_img:setPosition(self.layerItems[num]:getPosition());
-- end

function HaoyouSonghuaLayer:refreshByCurrency()

end

function HaoyouSonghuaLayer:refreshByCountControl()
  local flower_9_count=self.context.countControlProxy:getRemainCountByID(CountControlConfig.FLOWER_SEND,CountControlConfig.Parameter_1);
  local flower_99_count=self.context.countControlProxy:getRemainCountByID(CountControlConfig.FLOWER_SEND,CountControlConfig.Parameter_2);
  self.descb:setString("可收次数：" .. flower_9_count .. "   可送次数：" .. flower_99_count);
end