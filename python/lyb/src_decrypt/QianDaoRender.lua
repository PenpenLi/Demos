
QianDaoRender=class(TouchLayer);

function QianDaoRender:ctor()
  self.class=QianDaoRender;
end

function QianDaoRender:dispose()
  self:removeAllEventListeners();
  QianDaoRender.superclass.dispose(self);
end

function QianDaoRender:initialize(context,tab,num,yijingqiandao)
  self.context=context
  self:initLayer();
  self.skeleton = context.skeleton
  local armature= self.skeleton:buildArmature("render");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature = armature;
  local armature_d=armature.display;
  self.armature_d = armature_d;
  self:addChild(armature_d);

  for i,v in ipairs(tab) do

    local huodongDO = analysis("Huodong_Leijiqiandao", v.id)

    self.itemImage = BagItem.new(); 
    self.itemImage:initialize({ItemId = v.itemId ,Count = tonumber(v.count)});
    self.itemImage:setPositionXY(40+145*(i-1),7)
    self.itemImage.touchEnabled=true;
    self.itemImage.touchChildren=true
    -- vip 相关
    local armatureVip
    if huodongDO and huodongDO.viplv ~= 0 then
      armatureVip= self.skeleton:buildArmature("vipRender");
      armatureVip.animation:gotoAndPlay("f1");
      armatureVip:updateBonesZ();
      armatureVip:update();
      self:addChild(armatureVip.display);

      local vipNumberDO1
      if huodongDO.viplv < 10 then
        vipNumberDO1 = self.skeleton:getBoneTextureDisplay("number_"..huodongDO.viplv)
        vipNumberDO1:setPositionXY(15,32)
      else
        vipNumberDO1 = self.skeleton:getBoneTextureDisplay("number_1")
        local vipNumberDO2 = self.skeleton:getBoneTextureDisplay("number_"..huodongDO.viplv % 10)
        vipNumberDO2:setPositionXY(8,7)
        vipNumberDO1:addChild(vipNumberDO2)
        vipNumberDO1:setPositionXY(11,27)
      end

      armatureVip.display:addChild(vipNumberDO1)
      armatureVip.display.touchEnabled = false
      armatureVip.display:setPositionXY(-15,15)
    end

    if armatureVip and armatureVip.display then
      self.itemImage:addChild(armatureVip.display)   
    end

    if(i==num) and yijingqiandao==0 then

      self.itemEffect = cartoonPlayer("1387",46, 45, 0);
      self.itemEffect.touchEnabled = false;
      self.itemImage:addChild(self.itemEffect);

      -- self.itemImage:addEventListener(DisplayEvents.kTouchBegin, self.onItemTip, self);  
      -- self.itemImage:addEventListener(DisplayEvents.kTouchEnd, self.onItemTipEnd, self);
      self.itemImage:addEventListener(DisplayEvents.kTouchTap, self.onSign, self);
      self.itemImage:setBackgroundVisible(true)
    else
      -- local effect = huodongDO.effect  --analysis("Huodong_Leijiqiandao", v.id, "effect")
      -- print("+++++++++++++++++v.effect", effect)
      -- if effect == 1 then
      --     self.specialEffect = BoneCartoon.new()
      --     self.specialEffect:create(1555,0);
      --     self.specialEffect:setMyBlendFunc()
      --     self:addChild(self.specialEffect);
      --     self.specialEffect.touchEnabled = false;
      --     self.specialEffect:setPositionXY(84+145*(i-1), 51);
      -- end
      if(i<num) then
        local yilingqu_bg = context.skeleton:getBoneTextureDisplay("yilingqu_bg")
        yilingqu_bg:setPositionXY(-15,-5)
        yilingqu_bg.touchEnabled = false;
        self.itemImage:addChild(yilingqu_bg)
      end
      print("i,num",i,num)
      self.itemImage:addEventListener(DisplayEvents.kTouchBegin, self.onItemTip, self);  
      self.itemImage:addEventListener(DisplayEvents.kTouchEnd, self.onItemTipEnd, self);
      self.itembg = CommonSkeleton:getBoneTextureDisplay("commonGrids/common_grid")
      self.itembg:setPositionXY(-7,-9)
      self.itemImage:addChildAt(self.itembg,0)
    end
 
    self:addChild(self.itemImage)

  end
end
-- function QianDaoRender:onItemTip(event)
--   self.context:onItemTip(event)
-- end


function QianDaoRender:onItemTip(event)
  self.tapitembegin=event.globalPosition
end
function QianDaoRender:onItemTipEnd(event)
  if self.tapitembegin and (math.abs(event.globalPosition.y-self.tapitembegin.y)<20) and (math.abs(event.globalPosition.x-self.tapitembegin.x)<20) then
    -- if self.context.yijingqiandao == 0 then
    --   -- 表示已经签到
      
    --   return;
    -- end
    self.context:dispatchEvent(Event.new("ON_ITEM_TIP", {item = event.target,nil,nil,count=event.target.userItem.Count},self))
  end
end

function QianDaoRender:onSign()
  -- body
  self.context:onSign();
end
