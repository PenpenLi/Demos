require "core.display.Layer";
require "core.events.DisplayEvent";
require "core.utils.Scheduler";
require "core.utils.Global";
require "core.display.ClippingNodeMask";

LoadingShowLayer=class(Layer);

function LoadingShowLayer:ctor()
  self.class=LoadingShowLayer;
end

function LoadingShowLayer:dispose()

  removeSchedule(self,self.onSche);
  self:removeAllEventListeners();
  self:removeChildren();
  self.armature:dispose();
  LoadingShowLayer.superclass.dispose(self);
end

function LoadingShowLayer:initialize(context, callFunc)
  self.context = context;
  self.callFunc = callFunc;
  self.skeleton = CommonSkeleton;
  self.data = 0;
  self:initLayer();

  local data = analysisTotalTable("Kapai_Kapaiku");
  local tbs = {};
  for k,v in pairs(data) do
    if 5==v.star and 1==v.jiQi then
      table.insert(tbs, v);
    end
  end
  self.random_tbs = tbs;

  local img = Image.new();
  img:loadByArtID(StaticArtsConfig.LOADING_UI);
  img:setPositionY((GameConfig.STAGE_HEIGHT-960)/2)
  self:addChild(img);
  
  local armature=self.skeleton:buildArmature("loading_show_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature=armature;
  self:addChild(self.armature.display);

  local progressBar = self.armature:getBone("progress");
  self.progressBarDO = progressBar.displayBridge.display

  text="0 %";
  text_data=armature:getBone("progress_descb").textData;
  self.progress_descb=createTextFieldWithTextData(text_data,text,true);
  self.armature.display:addChild(self.progress_descb);

end

function LoadingShowLayer:getLoadingEffect()
  local mask = self.skeleton:getBoneTextureDisplay("commonImages/common_round_mask")
  self.clipper = ClippingNodeMask.new(mask);
  self.clipper:setAlphaThreshold(0.0);
  local loadingEffect = cartoonPlayer("1649",0,0,0,nil,1,nil,nil)
  loadingEffect:setAnchorPoint(CCPointMake(0,0.2))
  self.clipper:addChild(loadingEffect);
  self.progressBarDO:addChild(self.clipper)
  return mask
end

function LoadingShowLayer:onSlotScaleTap()
  if self.card_layer then
    self.armature.display:removeChild(self.card_layer);
    self.card_layer = nil;
  end
end
function LoadingShowLayer:cleanOldArts()
  if self.card_layer then
    self.armature.display:removeChild(self.card_layer);
    self.card_layer = nil;
  end

  if self.circle then
    self.armature.display:removeChild(self.circle);
    self.circle = nil
  end
  
  if self.progressBar then
    self.progressBarDO:removeChild(self.clipper);
    self.clipper = nil
  end
end

function LoadingShowLayer:onRefreshCard()
  self:cleanOldArts()

  self.circle = cartoonPlayer("1650",0,0,0,nil,1,nil,nil)
  self.circle:setAnchorPoint(transLayerAnchor(0.7, 0));
  self.circle:setPositionXY(0,30);
  self.armature.display:addChild(self.circle);
  self.circle:setVisible(false);

  self.progressBar = self:getLoadingEffect()

  local randomIndex = math.floor(getRadomValue() * table.getn(self.random_tbs)) + 1

  self.configID = self.random_tbs[randomIndex].id;

  self.card_layer = Layer.new();
  self.card_layer:initLayer();
  self.armature.display:addChildAt(self.card_layer,3);
  
  local card = getImageByArtId(analysis("Kapai_Kapaiku", self.configID, "art1"));
  --card:setScale(0.95);
  card:setPositionXY(30,37);
  self.card_layer:addChild(card);
  self.hero_card = card;

  local text_layer = Layer.new();
  text_layer:initLayer();
  self.card_layer:addChild(text_layer);

  local text=analysis("Kapai_Kapaiku",self.configID,"name");
  local _count = 0;
  local str = "";
  _count = -1;
  while (-1-string.len(text)) < _count do
    str = str .. string.sub(text, -2 + _count, _count) .. "\n";
    _count = -3 + _count;
  end

  local name_descb=BitmapTextField.new(str, "loadingjieshao");
  name_descb.sprite:setAnchorPoint(transLayerAnchor(0, 1));
  name_descb:setPositionXY(1175,610);
  text_layer:addChild(name_descb);

  local line = self.skeleton:getBoneTextureDisplay("loadingImages/img_5");
  line:setPositionXY(8+name_descb:getPositionX(),name_descb:getPositionY());
  text_layer:addChild(line);

  line = self.skeleton:getBoneTextureDisplay("loadingImages/img_6");
  line:setPositionXY(8+name_descb:getPositionX(),-23-name_descb:getContentSize().height+name_descb:getPositionY());
  text_layer:addChild(line);

  local text=analysis("Kapai_Kapaiku",self.configID,"poem");
  text = StringUtils:lua_string_split(text,"\n");
  for k,v in pairs(text) do
    local name_descb=BitmapTextField.new(v, "loadingjieshao",80);
    name_descb.sprite:setAnchorPoint(transLayerAnchor(0, 1));
    name_descb.sprite:setLineBreakWithoutSpace(true);
    name_descb:setPositionXY(1070-100*(-1+k),0==k%2 and 530 or 630);
    text_layer:addChild(name_descb);

  end

  text_layer:setPositionX(-100*(4-table.getn(text))+text_layer:getPositionX());
end

function LoadingShowLayer:getData()
  return self.data;
end 

function LoadingShowLayer:setProgress(data)
  -- log("LoadingShowLayer:setProgress->" .. data);
  if 0==data then--and 0~=self.data
    self:onRefreshCard();
  end
  
  self.data = 100 * data;

  self.progressBar:setScaleX(self.data/100);
  self.progress_descb:setString(math.floor(self.data) .. " %");

  self.circle:setPositionX(1190*data+self.armature.display:getChildByName("progress"):getPositionX());
  self.circle:setVisible(self.data > 5 and self.data < 95);
end

function LoadingShowLayer:static_create(context, callFunc)
  local loadingShowLayer = LoadingShowLayer.new();
  loadingShowLayer:initialize(context, callFunc);
  return loadingShowLayer;
end