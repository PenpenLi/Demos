HeroXiangxiLayer=class(LayerColor);

function HeroXiangxiLayer:ctor()
  self.class=HeroXiangxiLayer;
end

function HeroXiangxiLayer:dispose()
  self.armature:dispose();
	HeroXiangxiLayer.superclass.dispose(self);
end

function HeroXiangxiLayer:initialize(context, generalId)
  self.context = context;
  self.skeleton = self.context.skeleton;

  self:initLayer();
  --骨骼
  local armature=self.skeleton:buildArmature("prop_detail_layer");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature=armature;
  self:addChild(self.armature.display);

  -- local pLabelFont=BitmapTextField.new("详细属性","anniutuzi");
  -- pLabelFont:setPositionXY(37,490);
  -- self.armature.display:addChild(pLabelFont);

  local title_1=createTextFieldWithTextData(armature:getBone("title_1").textData,"基础属性");
  self.armature.display:addChild(title_1);

  local title_2=createTextFieldWithTextData(armature:getBone("title_2").textData,"附加属性");
  self.armature.display:addChild(title_2);

  local data = self.context.heroHouseProxy:getGeneralData(generalId);
  local titles={(0 == analysis("Kapai_Kapaiku",data.ConfigId,"attackWai") and "内攻" or "外攻"),"外防","内防","生命","会心","破防","疗伤","闪避","御劲","招架","吸血"};
  for i=1,11 do
    self["prop_".. i]=createTextFieldWithTextData(armature:getBone("prop_" .. i).textData,"");
    self.armature.display:addChild(self["prop_".. i]);
  end

  local prop = 0 == analysis("Kapai_Kapaiku",data.ConfigId,"attackWai") and HeroPropConstConfig.NEI_GONG_JI or HeroPropConstConfig.GONG_JI;
  local descbs={math.ceil(self.context.heroHouseProxy:getZongPropValue(generalId,prop)),
                math.ceil(self.context.heroHouseProxy:getZongPropValue(generalId,HeroPropConstConfig.FANG_YU)),
                math.ceil(self.context.heroHouseProxy:getZongPropValue(generalId,HeroPropConstConfig.NEI_FANG_YU)),
                math.ceil(self.context.heroHouseProxy:getZongPropValue(generalId,HeroPropConstConfig.SHENG_MING)),

                math.ceil(self.context.heroHouseProxy:getZongPropValue(generalId,HeroPropConstConfig.HUI_XIN)),
                math.ceil(self.context.heroHouseProxy:getZongPropValue(generalId,HeroPropConstConfig.PO_FANG)),
                math.ceil(self.context.heroHouseProxy:getZongPropValue(generalId,HeroPropConstConfig.LIAO_SHANG)),
                math.ceil(self.context.heroHouseProxy:getZongPropValue(generalId,HeroPropConstConfig.SHAN_BI)),
                math.ceil(self.context.heroHouseProxy:getZongPropValue(generalId,HeroPropConstConfig.YU_JIN)),
                math.ceil(self.context.heroHouseProxy:getZongPropValue(generalId,HeroPropConstConfig.ZHAO_JIA)),
                math.ceil(self.context.heroHouseProxy:getZongPropValue(generalId,HeroPropConstConfig.XI_XUE))};

  for i=1,11 do
    self["prop_".. i]:setString(titles[i] .. " : " .. descbs[i]);
  end

  local popupSize = self.armature.display:getGroupBounds().size;
  self.armature.display:setPositionXY(-110+math.floor((GameConfig.STAGE_WIDTH-popupSize.width)/2), math.floor((GameConfig.STAGE_HEIGHT-popupSize.height)/2));
  self.armature.display:getChildByName("common_copy_image_separator"):setScale(0.92);
  local size=Director:sharedDirector():getWinSize();
  self:changeWidthAndHeight(size.width,size.height);
  self:setColor(ccc3(0,0,0));
  self:setOpacity(0);

  self:addEventListener(DisplayEvents.kTouchBegin, self.onSelfTap, self);
end

function HeroXiangxiLayer:onSelfTap(event)
  self.parent:removeChild(self);
end