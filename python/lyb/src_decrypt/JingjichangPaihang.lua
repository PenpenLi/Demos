JingjichangPaihang=class(TouchLayer);

function JingjichangPaihang:ctor()
  self.class=JingjichangPaihang;
end

function JingjichangPaihang:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	JingjichangPaihang.superclass.dispose(self);
end

function JingjichangPaihang:initialize(context)
  self:initLayer();
  self.context=context;
  initializeSmallLoading();
  sendMessage(16,5);
  -- local data={{ConfigId=1,UserId=0,UserName="名字六个吱吱",Level=100,Score=99999,BooleanValue=0},
  --   {ConfigId=1,UserId=0,UserName="名字六个吱吱",Level=100,Score=99999,BooleanValue=1},
  --   {ConfigId=1,UserId=0,UserName="名字六个吱吱",Level=100,Score=99999,BooleanValue=1},
  --   {ConfigId=1,UserId=0,UserName="名字六个吱吱",Level=100,Score=99999,BooleanValue=0},
  --   {ConfigId=1,UserId=0,UserName="名字六个吱吱",Level=100,Score=99999,BooleanValue=0},
  --   {ConfigId=1,UserId=0,UserName="名字六个吱吱",Level=100,Score=99999,BooleanValue=0}};
  -- self:refreshData(data);
end

function JingjichangPaihang:refreshData(data)
  uninitializeSmallLoading();
  
  self.data = data;

  self.item_layer=ListScrollViewLayer.new();
  self.item_layer:initLayer();
  self.item_layer:setPosition(makePoint(628,78));
  self.item_layer:setViewSize(makeSize(482,470));
  self.item_layer:setItemSize(makeSize(470,105));
  self:addChild(self.item_layer);

  for k,v in pairs(self.data) do
    local item=JingjichangPaihangItem.new();
    item:initialize(self.context,v,k);
    self.item_layer:addItem(item);
  end
end


JingjichangPaihangItem=class(ListScrollViewLayerItem);

function JingjichangPaihangItem:ctor()
  self.class=JingjichangPaihangItem;
end

function JingjichangPaihangItem:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  JingjichangPaihangItem.superclass.dispose(self);

  if self.armature4dispose then
    self.armature4dispose:dispose();
  end
end

function JingjichangPaihangItem:initialize(context, data, rank)
  self:initLayer();
  self.context=context;
  self.data = data;
  self.rank = rank;
  self.skeleton=self.context.skeleton;
  self.familyProxy=self.context.familyProxy;
  self.userProxy=self.context.userProxy;
  self.bagProxy=self.context.bagProxy;
  self.userCurrencyProxy=self.context.userCurrencyProxy;
  self.heroHouseProxy=self.context.heroHouseProxy;
end

function JingjichangPaihangItem:onInitialize()  
  --骨骼
  local armature=self.skeleton:buildArmature("tab_item_2");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  local function cbfunc(event)
    print("---===",self.data.UserId,self.data.UserName);
    getUserButtonsSelector(self.data.UserId,self.data.UserName,event.globalPosition,self.context);
  end

  --name_descb
  local text_data=armature:getBone("name_descb").textData;
  self.name_descb=createRichMultiColoredLabelWithTextData(text_data,"<content><font color = '#67190E' ref = " .. (self.data.UserId == self.context.userProxy:getUserID() and "'0'" or "'1'") .. ">" .. self.data.UserName .. " </font><font color = '#67190E'>Lv." .. self.data.Level .. "</font></content>");
  if not (self.data.UserId == self.context.userProxy:getUserID()) then
    self.name_descb:addEventListener(DisplayEvents.kTouchTap,cbfunc);
  end
  self.armature:addChild(self.name_descb);

  text_data=armature:getBone("jinfen_descb").textData;
  self.jinfen_descb=createTextFieldWithTextData(text_data,"积分：" .. self.data.Score);
  self.armature:addChild(self.jinfen_descb);

  local img_bg = CommonSkeleton:getBoneTextureDisplay("commonImages/common_player_bg");
  img_bg:setPositionXY(130,13);
  self.armature:addChild(img_bg);

  local img = Image.new();
  print(self.data.TransforId);
  img:loadByArtID(analysis("Zhujiao_Huanhua",self.data.TransforId,"head"));
  img:setScale(0.76);
  img:setPositionXY(136,18);
  self.armature:addChild(img);

  if self.rank > 3 then
    text_data=armature:getBone("rank_descb").textData;
    self.rank_descb=createTextFieldWithTextData(text_data,self.rank);
    self.armature:addChild(self.rank_descb);
  else
    local rank_img = self.skeleton:getBoneTextureDisplay("rank_" .. self.rank .. "_img");
    rank_img:setPositionXY(15,0);
    self.armature:addChild(rank_img);
  end
end