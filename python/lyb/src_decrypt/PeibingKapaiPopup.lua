require "main.view.hero.heroTeam.PeibingKapaiPopupCardItem";
require "main.view.hero.heroTeam.PeibingKapaiPopupChosenItem";
-- require "main.view.skillCard.ui.SkillCardUI";
-- require "main.view.skillCard.ui.DetailSkillCardUI";

PeibingKapaiPopup=class(TouchLayer);

function PeibingKapaiPopup:ctor()
  self.class=PeibingKapaiPopup;
end

function PeibingKapaiPopup:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  PeibingKapaiPopup.superclass.dispose(self);

  self.armature4dispose:dispose();
end

--
function PeibingKapaiPopup:initialize(context)
  self:initLayer();
  self.context=context;
  self.skeleton=self.context.skeleton;
  self.familyProxy=self.context.familyProxy;
  self.userProxy=self.context.userProxy;
  self.bagProxy=self.context.bagProxy;
  self.userCurrencyProxy=self.context.userCurrencyProxy;
  self.items = {};
  self.chosen_items = {};
  self.generalIDs_idArray = self.context.generalIDs_idArray;

  local bg = Image.new();
  bg:loadByArtID(875);
  bg:setScale(2);
  self:addChild(bg);
  
  --骨骼
  local armature=self.skeleton:buildArmature("peibing_kapai_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  self.closeButton =self.armature4dispose.display:getChildByName("close_btn");
  SingleButton:create(self.closeButton);
  self.closeButton:addEventListener(DisplayEvents.kTouchTap, self.closeUI, self);

  self.askBtn =self.armature4dispose.display:getChildByName("ask");
  SingleButton:create(self.askBtn);
  self.askBtn:addEventListener(DisplayEvents.kTouchTap, self.onShowTip, self);

  local titleText = BitmapTextField.new("技能卡组","anniutuzi");
  titleText:setPositionXY(557,620);
  self.armature4dispose.display:addChild(titleText);

  self.title_bg=createTextFieldWithTextData(self.armature4dispose:getBone("title_bg").textData,"已选卡牌");
  self.armature4dispose.display:addChild(self.title_bg);

  self.item_layer=ListScrollViewLayer.new();
  self.item_layer:initLayer();
  self.item_layer:setPosition(makePoint(135,100));
  self.item_layer:setViewSize(makeSize(700,475));
  self.item_layer:setItemSize(makeSize(700,225));
  self:addChild(self.item_layer);

  local level = self.userProxy:getLevel();
  self.kapais=analysisTotalTable("Jinengkapai_Jinengkapai");
  table.remove(self.kapais,1);
  local temp = {};
  for k,v in pairs(self.kapais) do
    if level >= v.CardOpenTJ then
      table.insert(temp,v);
    end
  end
  local function sortfunc(data_a, data_b)
    return data_a.id < data_b.id;
  end
  table.sort(temp,sortfunc);

  local ids_table = {};
  local ids;
  for k,v in pairs(temp) do
    if 1 == k%4 then
      ids = {};
      table.insert(ids_table,ids);
    end
    table.insert(ids,v.id);
  end

  for k,v in pairs(ids_table) do
    local layer = PeibingKapaiPopupCardLayer.new();
    layer:initialize(self.context,self,v);
    self.item_layer:addItem(layer);
  end

  self:refresh();
end

function PeibingKapaiPopup:closeUI(event)
  self.parent:removeChild(self);
end

function PeibingKapaiPopup:onShowTip(event)
  local text=analysis("Tishi_Guizemiaoshu",5,"txt");
  TipsUtil:showTips(self.askBtn,text,500,nil,50);
end

function PeibingKapaiPopup:refresh()
  for k,v in pairs(self.chosen_items) do
    self:removeChild(v);
  end
  self.chosen_items={};
  for k,v in pairs(self.generalIDs_idArray) do
    local item = PeibingKapaiPopupChosenItem.new();
    item:initialize(self,v);
    item:setPositionXY(911,450-(-1+k)*90);
    item:addEventListener(DisplayEvents.kTouchTap, self.onCardTap, self, v);
    self:addChild(item);
    table.insert(self.chosen_items,item);
  end
  for k,v in pairs(self.items) do
    local bool;
    for k_,v_ in pairs(self.generalIDs_idArray) do
      if v.skillId == v_ then
        bool = true;
        break;
      end
    end
    if bool then
      if v.select_img then
        v:setVisible(true);
      else
        v.select_img = self.context.skeleton:getBoneTextureDisplay("selected_img");
        v:addChild(v.select_img);
      end
    else
      if v.select_img then
        v.select_img:setVisible(false);
      end
    end
  end
end

function PeibingKapaiPopup:onCardTap(event, id)
  -- local detail = DetailSkillCardUI.new();
  -- detail:initialize(nil,id,true);
  -- self.context:addChild(detail);
  -- self.detail = detail;

  -- local bool = false;
  -- for k,v in pairs(self.context.generalIDs_idArray) do
  --   if id == v then
  --     bool = true;
  --     break;
  --   end
  -- end
  -- detail:setButtonConfig4Peibing(self,bool);
end

function PeibingKapaiPopup:onClickTap()
  local id = self.detail.skillId;
  self.detail.parent:removeChild(self.detail);
  self.detail = nil;

  local bool = false;
  local idx = nil;
  for k,v in pairs(self.context.generalIDs_idArray) do
    if id == v then
      bool = true;
      idx = k;
      break;
    end
  end

  if bool then
    table.remove(self.context.generalIDs_idArray,idx);
  else
    if 4 < table.getn(self.context.generalIDs_idArray) then
      sharedTextAnimateReward():animateStartByString("技能卡牌不能超过五个哦 ~");
      return;
    end
    table.insert(self.context.generalIDs_idArray,id);
  end
  self:refresh();
end


PeibingKapaiPopupCardLayer=class(ListScrollViewLayerItem);

function PeibingKapaiPopupCardLayer:ctor()
  self.class=PeibingKapaiPopupCardLayer;
end

function PeibingKapaiPopupCardLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  PeibingKapaiPopupCardLayer.superclass.dispose(self);
end

--
function PeibingKapaiPopupCardLayer:initialize(context, container, ids)
  self:initLayer();
  self.context = context;
  self.container = container;
  self.ids = ids;
end

function PeibingKapaiPopupCardLayer:onInitialize()
  -- for k,v in pairs(self.ids) do
  --   local card = SkillCardUI.new();
  --   card:initialize(v);
  --   card:setScale(0.45);
  --   card:setPositionX((-1+k)%4*180);
  --   card:addEventListener(DisplayEvents.kTouchTap, self.container.onCardTap, self.container, v);
  --   self:addChild(card);
  --   table.insert(self.container.items,card);

  --   for k_,v_ in pairs(self.container.generalIDs_idArray) do
  --     if v == v_ then
  --       card.select_img = self.context.skeleton:getBoneTextureDisplay("selected_img");
  --       card:addChild(card.select_img);
  --       break;
  --     end
  --   end
  -- end
end