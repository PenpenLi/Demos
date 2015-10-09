LangyabangPopLayer=class(Layer);

function LangyabangPopLayer:ctor()
  self.class=LangyabangPopLayer;
end

function LangyabangPopLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	LangyabangPopLayer.superclass.dispose(self);
end

function LangyabangPopLayer:initialize(context, type)
  self.context = context;
  self.type = type;

  self:initLayer();
  AddUIBackGround(self, StaticArtsConfig.BACKGROUD_RANK_LIST, nil, true, 1);

  --骨骼
  local armature=self.context.skeleton:buildArmature("rank_pop_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose = armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  local askButton =self.armature4dispose.display:getChildByName("ask");
  SingleButton:create(askButton);
  askButton:addEventListener(DisplayEvents.kTouchTap, self.onAskTap, self);
  self.askBtn = askButton;
  self.askBtn:setVisible(false);
  
  local closeButton =self.armature4dispose.display:getChildByName("common_copy_close_button");
  SingleButton:create(closeButton);
  closeButton:addEventListener(DisplayEvents.kTouchTap, self.closeUI, self);

  local bangdan_img =self.armature4dispose.display:getChildByName("bangdan_img");
  SingleButton:create(bangdan_img);
  bangdan_img:addEventListener(DisplayEvents.kTouchTap, self.onBandanTap, self);

  -- self.context:requestData(self.type);
  if self.context.services[self.type] then
    self:refreshData(self.type, self.context.services[self.type]);
  end
end

function LangyabangPopLayer:onAskTap(event)
  local text=analysis("Tishi_Guizemiaoshu",13,"txt");
  TipsUtil:showTips(self.askBtn,text,600,nil,50);
end

function LangyabangPopLayer:closeUI(event)
  self.parent:removeChild(self);
end

function LangyabangPopLayer:onBandanTap(event)
  local layer = LangyabangDetailLayer.new();
  layer:initialize(self.context, self.type);
  self:addChild(layer);
end

function LangyabangPopLayer:refreshData(type, rankArray)
  local function sortFunc(data_a, data_b)
    return data_a.Ranking < data_b.Ranking;
  end
  table.sort(rankArray, sortFunc);
  
  for i=1,3 do
    if not rankArray[i] then
      break;
    end
    local poss = {{652,135},{300,155},{988,155}};
    local scales = {1.1,1,1};
    local avatar_bg = self.context.skeleton:getBoneTextureDisplay("renwu_bg");
    avatar_bg.sprite:setAnchorPoint(CCPointMake(0.5,0.5));
    avatar_bg:setScale(scales[i]);
    avatar_bg:setPositionXY(poss[i][1],poss[i][2]);
    self.armature:addChild(avatar_bg);

    local avatar = CompositeActionAllPart.new();
    avatar:initLayer();
    avatar:transformPartCompose(self.context.bagProxy:getCompositeRoleTable4Player(nil,nil,1 == type and rankArray[i].ParamStr3 or rankArray[i].ParamStr2));
    avatar:setScale(scales[i]);
    avatar:setPositionXY(-7+poss[i][1],(1==i and -65 or -60)+poss[i][2]);
    --self.figure:changeFaceDirect(false);
    self.armature:addChild(avatar);

    poss = {{495,260},{162,280},{847,280}};
    scales = {0.95,0.85,0.85};
    local item = LangyabangPopLayerItem.new();
    item:initialize(self.context, i);
    item:setScale(scales[i]);
    item:setPositionXY(poss[i][1],poss[i][2]);
    self.armature:addChild(item);
  end
end