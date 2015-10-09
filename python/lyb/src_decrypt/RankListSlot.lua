require "core.controls.page.CommonSlot";
require "main.common.transform.CompositeActionAllPart";
require "main.view.hero.heroPro.ui.HeroRoundPortrait";

RankListSlot=class(CommonSlot);

function RankListSlot:ctor()
  self.class=RankListSlot;
end

function RankListSlot:dispose()
  self:removeAllEventListeners();
  RankListSlot.superclass.dispose(self);
end

function RankListSlot:initialize(context)
	self.context = context;
	self.skeleton = self.context.skeleton;
  self.itemsLayer = nil;

	self:initLayer();
  -- local layer = LayerColor.new();
  -- layer:initLayer();
  -- layer:setColor(ccc3(125,125,125));
  -- layer:setContentSize(makeSize(1150,600));
  -- self:addChild(layer);
end

function RankListSlot:refresh()
  
end

function RankListSlot:onItemBegin(event)
  self.beginX = event.globalPosition.x;
end

function RankListSlot:onItemEnd(event)
  log(self.id);
  self.endX = event.globalPosition.x;
  if self.beginX and math.abs(self.beginX - self.endX) < 10 then
    self.context.bagLayer:onTouchLayerTap(self, self.bagItem);
  end
end

function RankListSlot:onItemOut(event)
  self:removeEventListener(DisplayEvents.kTouchEnd,self.onItemEnd,self);
  self:removeEventListener(DisplayEvents.kTouchMove,self.onItemMove,self);
  self:removeEventListener(DisplayEvents.kTouchOut,self.onItemOut,self);
end

function RankListSlot:getID()
  return self.id;
end

function RankListSlot:getBagItem()
  return self.bagItem;
end

function RankListSlot:getLock()
  return self.lock;
end

function RankListSlot:addGridOver(grid_over)
  if self.grid_over then
    self:removeChild(self.grid_over);
    self.grid_over = nil;
  end
  self.grid_over = grid_over;
  self:addChild(self.grid_over);
end

function RankListSlot:setSlotData(datas)
  self.datas = datas;
  if self.itemsLayer then
    self:removeChild(self.itemsLayer);
    self.itemsLayer = nil;
  end
  self.itemsLayer = Layer.new();
  self.itemsLayer:initLayer();
  self:addChild(self.itemsLayer);
  for k,v in pairs(self.datas) do
    local skew = 3 < table.getn(datas) and 250 or 375;
    local item = RankListSlotItem.new();
    item:initialize(self.context, v);
    local x,y = -10+skew*(-1+k),10;
    if 1 == v.Ranking then
      -- local size = item:getGroupBounds().size;
      -- x = size.width / 2 + x;
      -- y = size.height / 2 + y;
      -- item:setScale(1.2);
      -- size = item:getGroupBounds().size;
      -- x = - size.width / 2 + x;
      -- y = - size.height / 2 + y;
      item:setFirst();
    end
    item:setPositionXY(x,y);
    self.itemsLayer:addChild(item);
  end
end



RankListSlotItem=class(Layer);

function RankListSlotItem:ctor()
  self.class=RankListSlotItem;
end

function RankListSlotItem:dispose()
  self:removeAllEventListeners();
  RankListSlotItem.superclass.dispose(self);
  self.armature4dispose:dispose();
end

function RankListSlotItem:initialize(context, data)
  self.context = context;
  self.data = data;
  self.skeleton = self.context.skeleton;
  self:initializeRole(self.context.bagProxy,self.skeleton,self.data.ParamStr2,self.data.RankGeneralArray);

  local text=self.data.ParamStr1 .. " Lv " .. self.data.ParamStr4;
  self.name_bg=createTextFieldWithTextData(self.armature4dispose:getBone("name_bg").textData,text,true);
  self.armature:addChild(self.name_bg);

  local rank = self.skeleton:getBoneTextureDisplay("imgs/rank_" .. self.data.Ranking);
  local size = rank:getContentSize();
  rank:setPositionXY(39-size.width/2,335-size.height/2);
  self.armature:addChild(rank);

  if 1 == self.context.selected_type then

    self.zhanli_layer = Layer.new();
    self.zhanli_layer:initLayer();
    self.armature:addChild(self.zhanli_layer);
    local huawen = self.skeleton:getBoneTextureDisplay("zhanli_bg");
    self.zhanli_layer:addChild(huawen);

    local img = self.skeleton:getCommonBoneTextureDisplay("commonImages/common_zhanLi");
    img:setPositionXY(15,10);
    self.zhanli_layer:addChild(img);

    local zhanLi = CartoonNum.new();
    zhanLi:initLayer();
    zhanLi:setData(self.data.ParamStr3,"common_number",40);
    zhanLi:setPositionXY(185,10);
    self.zhanli_layer:addChild(zhanLi);
    self.zhanli_layer:setScale(0.8);
    local size = self.zhanli_layer:getGroupBounds().size;
    self.zhanli_layer:setPositionXY(-size.width/2+175,-50);

  elseif 2 == self.context.selected_type or 3 == self.context.selected_type then
    local text="获得鲜花: " .. self.data.ParamStr3;
    local text_field=createTextFieldWithTextData(self.armature4dispose:getBone("descb").textData,text);
    self.armature:addChild(text_field);
  elseif 4 == self.context.selected_type then

  elseif 5 == self.context.selected_type then
    local huawen = self.skeleton:getBoneTextureDisplay("zhanli_bg");
    huawen:setScale(0.6);
    huawen:setPositionXY(50,-45);
    self.armature:addChild(huawen);

    local layer = Layer.new();
    layer:initLayer();

    local common_gold_bg = self.skeleton:getCommonBoneTextureDisplay("commonCurrencyImages/common_gold_bg");
    common_gold_bg:setScale(0.9);
    common_gold_bg:setPositionX(30);
    layer:addChild(common_gold_bg);

    local text="      消费             " .. self.data.ParamStr3;--
    local textData = copyTable(self.armature4dispose:getBone("descb").textData);
    textData.alignment="left";
    local text_field=createTextFieldWithTextData(textData,text);
    text_field:setPositionX(-65);
    layer:addChild(text_field);

    layer:setPositionXY(-40+layer:getGroupBounds().size.width/2,-45);
    self.armature:addChild(layer);
  end
end

function RankListSlotItem:setFirst()
  local avatar_bg = self.armature:getChildByName("avatar_bg");
  local avatar_bg_size = avatar_bg:getContentSize();
  avatar_bg:setPositionXY(-0.1*avatar_bg_size.width+avatar_bg:getPositionX(),0.1*avatar_bg_size.height+avatar_bg:getPositionY());
  avatar_bg:setScale(1.2);
  self.figure:setScale(1.2);
  self.figure:setPositionY(185);
  if 1 == self.context.selected_type then
    self.zhanli_layer:setScale(1);
    local size = self.zhanli_layer:getGroupBounds().size;
    self.zhanli_layer:setPositionXY(-size.width/2+175,-20);
  end
end

function RankListSlotItem:initializeRole(bagProxy, skeleton, career, rankGeneralArray)
  self:initLayer();
  local armature=skeleton:buildArmature("item");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose = armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  self.figure=CompositeActionAllPart.new();
  self.figure:initLayer();
  self.figure:transformPartCompose(bagProxy:getCompositeRoleTable4Player(nil,nil,career));
  self.figure:setPositionXY(165,200);
  --self.figure:changeFaceDirect(false);
  self.armature:addChild(self.figure);

  local poss = {{{135,60}},{{40,90},{220,80}},{{40,80},{135,60},{220,90}}};
  poss = poss[table.getn(rankGeneralArray)];
  for k,v in pairs(rankGeneralArray) do
    local heroRoundPortrait = HeroRoundPortrait.new();
    heroRoundPortrait:initialize(v,false);
    heroRoundPortrait:showName4RankList();
    heroRoundPortrait:setScale(0.75);
    heroRoundPortrait:setPositionXY(poss[k][1],poss[k][2]);
    self:addChild(heroRoundPortrait);
  end
end