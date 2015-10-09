BangpaiRizhiItemLayer=class(ListScrollViewLayerItem);

function BangpaiRizhiItemLayer:ctor()
  self.class=BangpaiRizhiItemLayer;
end

function BangpaiRizhiItemLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	BangpaiRizhiItemLayer.superclass.dispose(self);
  
  if self.armature4dispose then
    self.armature4dispose:dispose();
  end
end

--
function BangpaiRizhiItemLayer:initialize(context, data)
  self:initLayer();
  self.context=context;
  self.data = data;
  self.skeleton=self.context.skeleton;
  self.familyProxy=self.context.familyProxy;
  self.userProxy=self.context.userProxy;
  self.bagProxy=self.context.bagProxy;
  self.userCurrencyProxy=self.context.userCurrencyProxy;
end

function BangpaiRizhiItemLayer:onInitialize()
  --骨骼
  local armature=self.skeleton:buildArmature("rizhi_popup_item_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  --title_1
  local text_data=armature:getBone("player_bg").textData;
  self.player_bg=createMultiColoredLabelWithTextData(text_data,"");
  self.player_bg:setPositionY(30+self.player_bg:getPositionY());
  self.armature:addChild(self.player_bg);

  text_data=armature:getBone("shijian_descb").textData;
  self.shijian_descb=createTextFieldWithTextData(text_data,"");
  self.armature:addChild(self.shijian_descb);

  self:refresh();
end

function BangpaiRizhiItemLayer:refresh()
  local text = analysis("Bangpai_Jiazurizhi",self.data.ID,"txt");
  if 4 == self.data.ID then
    text = string.gsub(text,"@1",analysis("Bangpai_Zhiweidengjibiao",self.data.ParamStr1,"name"));
    text = string.gsub(text,"@2",self.data.ParamStr2);
    text = string.gsub(text,"@3",self.data.ParamStr3);
  elseif 7 == self.data.ID then
    text = string.gsub(text,"@1",self.data.ParamStr1);
    text = string.gsub(text,"@2",analysis("Bangpai_Bangpaijiuyan",self.data.ParamStr2,"name"));
    text = string.gsub(text,"@3",self.data.ParamStr3);
  elseif 12 == self.data.ID then
    text = string.gsub(text,"@1",analysis("Gongnengkaiqi_Gongnengkaiqi",self.data.ParamStr1,"name"));
    text = string.gsub(text,"@2",self.data.ParamStr2);
    text = string.gsub(text,"@3",self.data.ParamStr3);
  else
    text = string.gsub(text,"@1",self.data.ParamStr1);
    text = string.gsub(text,"@2",self.data.ParamStr2);
    text = string.gsub(text,"@3",self.data.ParamStr3);
  end
  self.player_bg:setString(text);
  local time=getTimeServer()-self.data.Time;
  if 3600>time then
    time=math.floor(time/60) .. "分钟前";
  elseif 86400>time then
    time=math.floor(time/3600) .. "小时前";
  else
    time=math.floor(time/86400) .. "天前";
  end
  self.shijian_descb:setString(time);
end