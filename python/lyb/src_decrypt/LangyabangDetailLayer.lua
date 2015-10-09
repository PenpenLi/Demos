LangyabangDetailLayer=class(Layer);

function LangyabangDetailLayer:ctor()
  self.class=LangyabangDetailLayer;
end

function LangyabangDetailLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  self.armature:dispose();
  self.armature_1:dispose();
	LangyabangDetailLayer.superclass.dispose(self);
end

function LangyabangDetailLayer:initialize(context, type)
  self.context = context;
  self.type = type;

  self:initLayer();
  AddUIBackGround(self, StaticArtsConfig.BACKGROUD_RANK_LIST, nil, true, 1);

  --骨骼
  local armature=self.context.skeleton:buildArmature("rank_list_detail_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose = armature;
  self.armature=armature.display;
  self.armature:setPositionY(15);
  self:addChild(self.armature);

  local askButton =self.armature4dispose.display:getChildByName("ask");
  SingleButton:create(askButton);
  askButton:addEventListener(DisplayEvents.kTouchTap, self.onAskTap, self);
  self.askBtn = askButton;
  self.askBtn:setVisible(false);
  
  local closeButton =self.armature4dispose.display:getChildByName("common_copy_close_button");
  SingleButton:create(closeButton);
  closeButton:addEventListener(DisplayEvents.kTouchTap, self.closeUI, self);

  self:refresh();
end

function LangyabangDetailLayer:onAskTap(event)
  local text=analysis("Tishi_Guizemiaoshu",13,"txt");
  TipsUtil:showTips(self.askBtn,text,600,nil,50);
end

function LangyabangDetailLayer:closeUI(event)
  self.parent:removeChild(self);
end

function LangyabangDetailLayer:refresh()
  if 1 == self.type then
    self:refreshTitleBangpai();
  else
    self:refreshTitle();
  end
  
  self.item_layer=ListScrollViewLayer.new();
  self.item_layer:initLayer();
  self.item_layer:setPosition(makePoint(178,75));
  self.item_layer:setViewSize(makeSize(925,460));
  self.item_layer:setItemSize(makeSize(925,97));
  self.armature:addChild(self.item_layer);

  local data = self.context.services[self.context.selected_type];

  local function sf(data_a, data_b)
    return data_a.Ranking < data_b.Ranking;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
  end
  table.sort(data,sf);
  for k,v in pairs(data) do
    local item=LangyabangDetailLayerItem.new();
    item:initialize(self.context,v,self);
    self.item_layer:addItem(item);
  end
end

function LangyabangDetailLayer:refreshTitle()
  local armature=self.context.skeleton:buildArmature("rank_item_title");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature_1 = armature;
  self.armature_1.display:setPositionXY(5,668);
  self.armature:addChild(self.armature_1.display);

  local text_data=self.armature_1:getBone("title_1").textData;
  self.title_1=createTextFieldWithTextData(text_data,"名次");
  self.armature_1.display:addChild(self.title_1);

  text_data=self.armature_1:getBone("title_2").textData;
  self.title_2=createTextFieldWithTextData(text_data,"玩家信息");
  self.armature_1.display:addChild(self.title_2);

  text_data=self.armature_1:getBone("title_3").textData;
  if 3 == self.type then
    self.title_3=createTextFieldWithTextData(text_data,"战力");
  elseif 2 == self.type then
    self.title_3=createTextFieldWithTextData(text_data,"消费元宝");
  end
  self.armature_1.display:addChild(self.title_3);

  text_data=self.armature_1:getBone("title_4").textData;
  self.title_4=createTextFieldWithTextData(text_data,"战力前三的英雄");
  self.armature_1.display:addChild(self.title_4);
end

function LangyabangDetailLayer:refreshTitleBangpai()
  local armature=self.context.skeleton:buildArmature("rank_item_title_bangpai");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature_1 = armature;
  self.armature_1.display:setPositionXY(5,668);
  self.armature:addChild(self.armature_1.display);

  local text_data=self.armature_1:getBone("title_1").textData;
  self.title_1=createTextFieldWithTextData(text_data,"名次");
  self.armature_1.display:addChild(self.title_1);

  text_data=self.armature_1:getBone("title_2").textData;
  self.title_2=createTextFieldWithTextData(text_data,"帮派信息");
  self.armature_1.display:addChild(self.title_2);

  text_data=self.armature_1:getBone("title_3").textData;
  self.title_3=createTextFieldWithTextData(text_data,"帮主信息");
  self.armature_1.display:addChild(self.title_3);

  text_data=self.armature_1:getBone("title_4").textData;
  self.title_4=createTextFieldWithTextData(text_data,"综合实力");
  self.armature_1.display:addChild(self.title_4);

  text_data=self.armature_1:getBone("title_5").textData;
  self.title_5=createTextFieldWithTextData(text_data,"帮众");
  self.armature_1.display:addChild(self.title_5);
end