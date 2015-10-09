require "core.controls.page.CommonSlot";

ShadowItemSlot=class(CommonSlot);

function ShadowItemSlot:ctor()
  self.class=ShadowItemSlot;
end

function ShadowItemSlot:dispose()
  self:removeAllEventListeners();
  ShadowItemSlot.superclass.dispose(self);
end

function ShadowItemSlot:initialize(context)
  print("ShadowItemSlot:initialize")
	self.context = context;
	self:initLayer();

  self.skeleton= self.context.skeleton;
  -- local armature= self.skeleton:getBoneTextureDisplay("renWuDiTu_bg");
  -- armature.animation:gotoAndPlay("f1");
  -- armature:updateBonesZ();
  -- armature:update();
  -- self.armature = armature;
  -- local armature_d=armature.display;
  -- self.armature_d = armature_d;
  -- self:addChild(armature_d);
end

function ShadowItemSlot:setSlotData(yxzPo)
  self.yxzPo = yxzPo;

  self.renWuDiTu_bg = self.skeleton:getBoneTextureDisplay("renWuDiTu_bg");
  self:addChild(self.renWuDiTu_bg); 
  self.renWuDiTu_bg:setAnchorPoint(ccp(0.5,0.5))
  self.renWuDiTu_bg:setPositionXY(100,-20)

  local scenarioName = analysis("Juqing_Guanka", yxzPo.id, "scenarioName")
  self.nameTxt=TextField.new(CCLabelTTF:create(scenarioName,FontConstConfig.OUR_FONT,22));

  self.nameTxt:setColor(CommonUtils:ccc3FromUInt(16757034));
  -- self.nameTxt:setAnchorPoint(ccp(0.5,0.5))
  self.nameTxt:setPositionXY(55,95)

  local heroIds = StringUtils:lua_string_split(yxzPo.heroId, ",")
  local midImage;
  for k,v in pairs(heroIds)do
    local img = Image.new()
    local art3 = analysis("Kapai_Kapaiku", tonumber(v), "art3")
    img:loadByArtID(art3);
    if k == 2 then
      midImage = img;
    else
      self.renWuDiTu_bg:addChild(img);
    end
    img:setPositionXY((k-1) *48+18, 20);
    img:setScale(0.8)
  end

  self.state = self.context.storyLineProxy:getStrongPointState(yxzPo.id);
  if self.state == nil or self.state == 2 then

    self.renWuZheZhao_bg = self.skeleton:getBoneTextureDisplay("renWuZheZhao_bg");
    self.renWuZheZhao_bg.touchEnabled = false;
    self.renWuZheZhao_bg:setAnchorPoint(ccp(0.5,0.5))
    self:addChild(self.renWuZheZhao_bg);
    self.renWuZheZhao_bg:setPositionXY(100,-20)

    self.not_open_word_bg = self.skeleton:getBoneTextureDisplay("not_open_word_bg");
    self.not_open_word_bg.touchEnabled = false;
    self:addChild(self.not_open_word_bg);
    self.not_open_word_bg:setPositionXY(25, -40)

  end
  self.renWuDiTu_bg:addEventListener(DisplayEvents.kTouchTap, self.onTap, self);
  self.renWuDiTu_bg:addChild(midImage);

  self.renWuDiTu_bg:addChild(self.nameTxt)

  local totalCount = self.context.storyLineProxy:getStrongPointTotalCount(self.yxzPo.id);
  print("-=-==-=================------------totalCount", totalCount)
  if totalCount == 0 and self.state == 3 then
    self.redDot1 = CommonSkeleton:getBoneTextureDisplay("commonImages/common_redIcon");
    self.redDot1:setPositionXY(168,82)    
    self.renWuDiTu_bg:addChild(self.redDot1);
  end


  self:setSmallScale();
end

function ShadowItemSlot:setSmallScale()
  self.size = 0.8
  if self.renWuDiTu_bg then
    self.renWuDiTu_bg:setScale(self.size);
  end
  if self.not_open_word_bg then
    self.not_open_word_bg:setScale(self.size);
  end
  if self.boneCartoon then
    self:removeChild(self.boneCartoon);
  end
  -- if self.renWuZheZhao_bg then
  --   self.renWuZheZhao_bg:setScale(self.size);
  -- end
end
function ShadowItemSlot:setNormalScale()
  self.size = 1;
  if self.renWuDiTu_bg then
    self.renWuDiTu_bg:setScale(self.size)

    local callBackFun = nil;
    self.boneCartoon = cartoonPlayer("1168",98,-21,0,nil,nil,nil,true)
    self:addChild(self.boneCartoon)
  end
end
function ShadowItemSlot:onTap(event)
    print("function ShadowItemSlot:onTap(event)")

  if self.context.isChangeEnable then   
    if self.state == nil or self.state == 2 then
      print("function2222222222")
      local curStrongPointPo = analysis("Juqing_Guanka", self.yxzPo.id)
      local parentStrongPointPo = analysis("Juqing_Guanka", curStrongPointPo.parentId)
      local storyLinePo = analysis("Juqing_Juqing", parentStrongPointPo.storyId)
      sharedTextAnimateReward():animateStartByString("通关第" .. storyLinePo.zhangjie .. "章" .. parentStrongPointPo.scenarioName .. "后开启" );
    else
      if self.size ~= 1 then
        MusicUtils:playEffect(7,false);
        self.context:refreshItems(self.yxzPo.id);
      end
    end
  end
end