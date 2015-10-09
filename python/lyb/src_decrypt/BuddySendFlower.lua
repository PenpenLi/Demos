BuddySendFlower=class(Layer);

function BuddySendFlower:ctor()
  self.class=BuddySendFlower;
end

function BuddySendFlower:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  BuddySendFlower.superclass.dispose(self);
  self.armature4dispose:dispose();
end

function BuddySendFlower:initialize(context, buddyItemSlotData)
  self:initLayer();
  self.context=context;
  self.skeleton=self.context.skeleton;
  self.buddyItemSlotData=buddyItemSlotData;
  self.layerItems={};
  self.num_select=0;

  --骨骼
  local armature=self.skeleton:buildArmature("give_flower_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  self.level=1;--self.context.generalListProxy:getLevel();

  local flower_9_count=self.context.countControlProxy:getRemainCountByID(CountControlConfig.FLOWER_SEND,CountControlConfig.Parameter_1);
  local flower_99_count=self.context.countControlProxy:getRemainCountByID(CountControlConfig.FLOWER_SEND,CountControlConfig.Parameter_2);
  
  self.descb=createTextFieldWithTextData(armature:getBone("descb").textData,"可收次数：" .. flower_9_count .. "   可送次数：" .. flower_99_count);
  self.armature:addChild(self.descb);

  local name_1=createTextFieldWithTextData(armature:getBone("flower_img_1").textData,"粉玫瑰");
  self.armature:addChild(name_1);
  local name_2=createTextFieldWithTextData(armature:getBone("flower_img_2").textData,"深红诱惑");
  self.armature:addChild(name_2);
  local name_3=createTextFieldWithTextData(armature:getBone("flower_img_3").textData,"蓝色妖姬");
  self.armature:addChild(name_3);

  local currency_2=createTextFieldWithTextData(armature:getBone("currency_2").textData,analysis("Xishuhuizong_Xishubiao",XiShuConfig.TYPE_1008,"constant"));
  self.armature:addChild(currency_2);
  local currency_3=createTextFieldWithTextData(armature:getBone("currency_3").textData,analysis("Xishuhuizong_Xishubiao",XiShuConfig.TYPE_1009,"constant"));
  self.armature:addChild(currency_3);

  local item_descb_1=createTextFieldWithTextData(armature:getBone("item_descb_1").textData,"获得经验 " .. analysis("Zhujiao_Zhujiaoshengji",self.level,"flower1"));
  self.armature:addChild(item_descb_1);
  local item_descb_2=createTextFieldWithTextData(armature:getBone("item_descb_2").textData,"获得经验 " .. analysis("Zhujiao_Zhujiaoshengji",self.level,"flower9"));
  self.armature:addChild(item_descb_2);
  local item_descb_3=createTextFieldWithTextData(armature:getBone("item_descb_3").textData,"获得经验 " .. analysis("Zhujiao_Zhujiaoshengji",self.level,"flower99"));
  self.armature:addChild(item_descb_3);

  self.button=Button.new(armature:findChildArmature("button"),false);
  self.button.bone:initTextFieldWithString("common_small_blue_button","赠送");
  self.button:addEventListener(Events.kStart,self.onButtonTap,self);

  self.tipBg=LayerColorBackGround:getTransBackGround();
  self.tipBg:addEventListener(DisplayEvents.kTouchTap,self.onSelfTap,self);
  self:addChildAt(self.tipBg,0);

  local size = Director:sharedDirector():getWinSize();
  local self_size = self.armature:getGroupBounds().size;
  self.armature:setPositionXY(size.width/2-self_size.width/2,size.height/2-self_size.height/2);

  local layer_size=self.armature:getChildByName("item_bg_1"):getContentSize();
  local _count = 0;
  while 3>_count do
    _count = 1 + _count;

    local layer = Layer.new();
    layer:initLayer();
    layer:setContentSize(layer_size);
    layer.sprite:setAnchorPoint(transLayerAnchor(0,1));
    layer:setPosition(self.armature:getChildByName("item_bg_" .. _count):getPosition());
    layer:addEventListener(DisplayEvents.kTouchTap,self.onLayerItemTap,self,_count);
    self.armature:addChild(layer);
    table.insert(self.layerItems,layer);
  end
end

function BuddySendFlower:onButtonTap(event)
  if 0 == self.num_select then
    return;
  end
  self.context:onFlowerTap(self.num_select, self.buddyItemSlotData);
  self:onSelfTap();
end

function BuddySendFlower:onSelfTap()
  self.parent:removeChild(self);
end

function BuddySendFlower:onLayerItemTap(event, num)
  self.num_select=num;
  if not self.item_over_img then
    self.item_over_img=self.skeleton:getBoneTexture9DisplayBySize("buddyImages/buddy_flower_scroll_item_over",true,makeSize(380,122));
    self.armature:addChild(self.item_over_img);
  end
  self.item_over_img:setPosition(self.layerItems[num]:getPosition());
end