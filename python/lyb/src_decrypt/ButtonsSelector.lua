ButtonsSelector=class(Layer);

function ButtonsSelector:ctor()
  self.class=ButtonsSelector;
end

function ButtonsSelector:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  ButtonsSelector.superclass.dispose(self);
end

function ButtonsSelector:initialize(callFunctions, texts, data)
  self.callFunctions = callFunctions;
  self.data = data;

  self:initLayer();

  local bg=LayerColorBackGround:getOpacityBackGround();
  bg:addEventListener(DisplayEvents.kTouchTap,self.closeTip,self);
  self:addChild(bg);

  self.button_layer=Layer.new();
  self.button_layer:initLayer();
  self:addChild(self.button_layer);

  for k,v in pairs(callFunctions) do
    local button=CommonButton.new();
    button:initialize("commonButtons/common_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
    --button:initializeText({x=14,y=-56, width=150, height=44,lineType="single line",size=30,color=16777215,alignment=kCCTextAlignmentCenter,space=0,textType="static"},texts[k]);
    button:initializeBMText(texts[k],"anniutuzi");
    button:setPositionXY(10, 20+70*(-1+k));
    button:addEventListener(DisplayEvents.kTouchTap,self.onSelect,self,v);
    if "加好友" == texts[k] then
      -- button:setGray(true);
    end
    self.button_layer:addChild(button);
  end

  self.button_layer:addChildAt(CommonSkeleton:getBoneTexture9DisplayBySize("commonBackgroundScalables/common_background_1", false, makeSize(211,40+70*table.getn(callFunctions))),0);
  MusicUtils:playEffect(7,false);
end

function ButtonsSelector:setPos(position)
  self.button_layer:setPosition(getTipPosition(self.button_layer,position));
end

function ButtonsSelector:onSelect(event, data)
  data(self.data);
  self:closeTip(event);
end

function ButtonsSelector:closeTip(event)
  if self.parent then
    self.parent:removeChild(self);
  end
end