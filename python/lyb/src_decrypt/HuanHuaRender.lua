
HuanHuaRender = class(Layer)

function HuanHuaRender:ctor()
	self.class = HuanHuaRender
end

function HuanHuaRender:dispose()
  HuanHuaRender.superclass.dispose(self);
end
	
function HuanHuaRender:initData(context, tempTable)
  self:initLayer();
  self.context = context;

  self.rendersTable = {};

  local count = #tempTable;
  local index = math.ceil(count / 4);
  print("count, index",count, index)

  local item = analysis("Zhujiao_Huanhua", tempTable[1].ID)

  local armature2= self.context.skeleton:buildArmature("huanHua_resource" .. index);
  armature2.animation:gotoAndPlay("f1");
  armature2:updateBonesZ();
  armature2:update();
  self:addChild(armature2.display);
  self.armature_d2 = armature2.display;


  local armature= self.context.skeleton:buildArmature("huanHua_render");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature = armature;
  local armature_d=armature.display;
  self.armature_d = armature_d;
  self:addChild(armature_d);

  self.itemTextField3=createTextFieldWithTextData(armature:getBone("title_txt").textData, item.name);--新建文本
  self.itemTextField3.touchEnabled=false;
  self.itemTextField3.touchChildren=false;
  armature_d:addChild(self.itemTextField3);

  self.desc_txt=createTextFieldWithTextData(armature:getBone("desc_txt").textData, item.condition);--新建文本
  self.desc_txt.touchEnabled=false;
  self.desc_txt.touchChildren=false;
  armature_d:addChild(self.desc_txt);

  if index == 1 then
  	armature_d:setPositionY(109)
  elseif index == 2 then
  	armature_d:setPositionY(214)
  else
  	armature_d:setPositionY(313)
  end

  -- self:setContentSize(CCSizeMake());

  self.layers = {};

  print("+++++++++++++++++index", index)

  for k = 1, index do
  	self.layers[k] = Layer.new();
  	self.layers[k]:initLayer();
  	-- self.layers[k]:setColor(ccc3(0,0,0));
	--  self.layers[k]:setOpacity(125);
  	self:addChild(self.layers[k])
  	print("yPos", (index -k) * 100-200)
  	self.layers[k]:setPositionY((index -k) * 100 + 20);

  end
  for k, v in ipairs(tempTable)do
  	local xIndex = (k - 1) % 4;
  	local yIndex = math.ceil(k / 4);
  	print("yIndex", yIndex)
  	local headItem = HuanHuaHeroItem.new();
  	headItem:init(self, v, k)
  	self.layers[yIndex]:addChild(headItem);
  	headItem:setPositionX(xIndex * 117 + 30)
  	table.insert(self.rendersTable, headItem)
  end
end
function HuanHuaRender:refreshRender()
  for k, v in pairs(self.rendersTable)do
  	v:refreshState();
  end
end
function HuanHuaRender:refreshSelectState()
  for k, v in pairs(self.rendersTable)do
    v:refreshSelectState();
  end
end



HuanHuaHeroItem = class(Layer);
function HuanHuaHeroItem:ctor()
  self.class = HuanHuaHeroItem;
end

function HuanHuaHeroItem:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  HuanHuaHeroItem.superclass.dispose(self);
end

function HuanHuaHeroItem:init(context, data, curIndex)
  self:initLayer();
  self.data = data;
  self.context = context;

  local renWuDiTu_bg = context.context.skeleton:getBoneTextureDisplay("renWuDiTu_bg");
  self:addChild(renWuDiTu_bg);
  renWuDiTu_bg:setPositionXY(-12, -8);

  local item = analysis("Zhujiao_Huanhua", data.ID)
  local image = Image.new();
  image:loadByArtID(item.head);

  if data.BooleanValue == 0 then
    image=Sprite.new(getGraySprite(image.sprite));
  	self:addChild(image)
    local weiHuoDe_bg = context.context.skeleton:getBoneTextureDisplay("weiHuoDe_bg");
    self:addChild(weiHuoDe_bg)
    weiHuoDe_bg:setPositionXY(-5, 45)
  else
  	self:addChild(image)
    image:addEventListener(DisplayEvents.kTouchBegin,self.onClickHeadItemBegin,self)

  	if self.context.context.userProxy.transforId == self.data.ID then
  		self.gou_bg = self.context.context.skeleton:getBoneTextureDisplay("gou_bg");
  		self.gou_bg:setPositionXY(9, 10)
  		self.gou_bg.touchEnabled = false;
	  	self:addChild(self.gou_bg);
  	end

  end

  local common_mingzi_bg = CommonSkeleton:getBoneTextureDisplay("commonImages/common_mingzi_bg");
  self:addChild(common_mingzi_bg);
  common_mingzi_bg:setPositionY(-5)

  local userNameText=TextField.new(CCLabelTTF:create(item.name1, GameConfig.DEFAULT_FONT_NAME, 20,  CCSizeMake(120, 30), kCCTextAlignmentCenter), true);
  self:addChild(userNameText)
  userNameText:setPositionXY(-15,-8);
end

function HuanHuaHeroItem:refreshState()
  if self.data.BooleanValue == 1 then
  	if self.context.context.userProxy.transforId == self.data.ID then
      self.gou_bg = self.context.context.skeleton:getBoneTextureDisplay("gou_bg");
      self.gou_bg:setPositionXY(9, 10)
      self.gou_bg.touchEnabled = false;
      self:addChild(self.gou_bg);
    elseif self.gou_bg then
  		self:removeChild(self.gou_bg);
  		self.gou_bg = nil;
  	end
  end
end


function HuanHuaHeroItem:refreshSelectState()
  if self.context.context.selectedId == self.data.ID then
    if not self.renWuXuanZhong_bg then
      self.renWuXuanZhong_bg = self.context.context.skeleton:getBoneTextureDisplay("renWuXuanZhong_bg");
      self.renWuXuanZhong_bg:setPositionXY(-13, -10)
      self.renWuXuanZhong_bg.touchEnabled = false;
      self:addChild(self.renWuXuanZhong_bg);
    end
  elseif self.renWuXuanZhong_bg then
    self:removeChild(self.renWuXuanZhong_bg);
    self.renWuXuanZhong_bg = nil;
  end
end
function HuanHuaHeroItem:onClickHeadItemBegin(event)
  -- event.target:setScale(0.88)
  self.beginPos=event.globalPosition
  event.target:addEventListener(DisplayEvents.kTouchEnd,self.onClickHeadItemEnd,self)
  print("onClickHeroHeadItem")
  
end

function HuanHuaHeroItem:onClickHeadItemEnd(event)
  -- event.target:setScale(1)
   print("onClickHeadItemEnd")
  if math.abs(event.globalPosition.y-self.beginPos.y) < 20 then
  	self.context.context.popup_boolean=true;
  	if not self.context.context.huanHuaHeroPanel then
	  	local huanHuaHeroPanel = HuanHuaHeroPanel.new();
	  	huanHuaHeroPanel:init(self.context, self.data);
	  	self.context.context:addChild(huanHuaHeroPanel);
	  	huanHuaHeroPanel:setPositionXY(85,220)

	  	self.context.context.huanHuaHeroPanel = huanHuaHeroPanel;
  	else
  		self.context.context.huanHuaHeroPanel:refreshHero(self.data);
  	end
    self.context.context.selectedId = self.data.ID;
    self.context.context:refreshSelectState();
	-- self.huanHuaHeroPanel
  	print("onClickHeadItemEnd < 20")
  else
  	print("onClickHeadItemEnd > 20")
  end
end



HuanHuaHeroPanel = class(Layer);
function HuanHuaHeroPanel:ctor()
  self.class = HuanHuaHeroPanel;
end

function HuanHuaHeroPanel:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  HuanHuaHeroPanel.superclass.dispose(self);
end

function HuanHuaHeroPanel:init(context, data)
  self.data = data;
  self.context = context;
  self:initLayer();
  --context 是HuanHuaRender
  local armature= self.context.context.skeleton:buildArmature("huanHua_panel");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();

  local armature_d=armature.display;
  self.armature_d = armature_d;
  self:addChild(armature_d);

  local item = analysis("Zhujiao_Huanhua", data.ID)
  self.composite = getCompositeRole(item.body)
  self:addRoleShadow(self.composite)
  self.composite:setPositionXY(120,115)
  self:addChild(self.composite)

  self.button=self.armature_d:getChildByName("blue_button")
  self.button_pos=convertBone2LB4Button(self.button)
  self.armature_d:removeChild(self.button)

  self.button=CommonButton.new();
  self.button:initialize("commonButtons/common_small_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
  self.button:initializeBMText("幻化","anniutuzi");
  self.button:addEventListener(DisplayEvents.kTouchEnd,self.onHuanHua,self)
  self.button:setPositionXY(self.button_pos.x,self.button_pos.y);
  self.button.touchEnabled=true
  self:addChild(self.button);


end

function HuanHuaHeroPanel:onHuanHua(event)

  local extensionTable = {}
  extensionTable["huanhuaID"] = self.data.ID
  hecDC(3,29,2,extensionTable)

  
	sendMessage(3, 44, {ID = self.data.ID});
	self.context.context.userProxy.transforId = self.data.ID;
	self.context.context:refreshState();
end
function HuanHuaHeroPanel:refreshHero(data)
	self.data = data;
	self:removeChild(self.composite)
	self.composite = nil

	local item = analysis("Zhujiao_Huanhua", data.ID)
	self.composite = getCompositeRole(item.body)
  self:addRoleShadow(self.composite)
	self.composite:setPositionXY(120,115)
	self:addChild(self.composite)
end
function HuanHuaHeroPanel:addRoleShadow(role)
  local roleShadow = Image.new()
  roleShadow:loadByArtID(StaticArtsConfig.IMAGE_HERO_SHADOW)
  roleShadow:setAnchorPoint(CCPointMake(0.5,0.5));
  -- roleShadow:setPositionXY(role:getPositionX(),role:getPositionY());
  role.roleShadow = roleShadow
  role:addChildAt(roleShadow, 0);
  roleShadow.touchChildren = false;
  roleShadow.touchEnabled = false;
end