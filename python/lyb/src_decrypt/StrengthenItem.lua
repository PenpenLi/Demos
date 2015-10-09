require "core.events.DisplayEvent";
require "main.view.bag.ui.bagPopup.BagItem";
require "main.view.bag.ui.bagPopup.EquipStar";

StrengthenItem=class(Layer);

local item_selected = nil;

function StrengthenItem:ctor()
  self.class=StrengthenItem;
end

function StrengthenItem:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	StrengthenItem.superclass.dispose(self);
  item_selected = nil;
end

function StrengthenItem:initializeBag(context, id)
  self:initLayer();
  self.context=context;
  self.skeleton=self.context.skeleton;
  self.id=id;
  self.img=self.skeleton:getBoneTexture9DisplayBySize("strengthenImages/strengthen_item_2",nil,makeSize(170,70));
  self.img:setPositionXY(5,5);
  self:addChild(self.img);

  local text=createTextFieldWithTextData({x=0,y=12,width=170,height=50,lineType="single line",size=30,color=3875840,alignment=kCCTextAlignmentCenter,space=0,textType="static"},"");
  text:setString(analysis("Zhuangbei_Zhuangbeibuwei",id,"place"));
  self:addChild(text);

  self:addEventListener(DisplayEvents.kTouchBegin,self.onSelfTap,self);
end

function StrengthenItem:initializeHero(context, data)
  self:initLayer();
  self.context=context;
  self.skeleton=self.context.skeleton;
  self.data=data;

  local bg=self.skeleton:getBoneTexture9DisplayBySize("strengthenImages/strengthen_item_" .. (1 == self.data.IsPlaying and "2" or "1"),nil,makeSize(170,70));
  bg:setPositionXY(5,5);
  self:addChild(bg);

  local text=createTextFieldWithTextData({x=0,y=12,width=170,height=50,lineType="single line",size=30,color=3875840,alignment=kCCTextAlignmentCenter,space=0,textType="static"},"");
  text:setString(1 == self.data.IsMainGeneral and "主角" or analysis("Kapai_Kapaiku",self.data.ConfigId,"name"));
  self:addChild(text);

  if 1 == self.data.IsPlay then
    local img = self.skeleton:getBoneTextureDisplay("strengthenImages/strengthen_item_fight");
    img:setPositionXY(140,40);
    self:addChild(img);
  end

  self:addEventListener(DisplayEvents.kTouchBegin,self.onSelfTap,self);
end

function StrengthenItem:onSelfTap(event)
  if item_selected == self then
    return;
  end
  if item_selected then
    item_selected:select(false);
  end
  item_selected = self;
  item_selected:select(true);
  self.context:onLeftListItemTap(self);
end

function StrengthenItem:select(bool)
  if not self.over_img then
    self.over_img=self.skeleton:getBoneTexture9DisplayBySize("strengthenImages/strengthen_item_over",nil,makeSize(180,80));
    self:addChild(self.over_img);
  end
  self.over_img:setVisible(bool);
end