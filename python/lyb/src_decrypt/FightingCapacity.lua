FightingCapacity=class(Layer);

function FightingCapacity:ctor()
  self.class=FightingCapacity;
end

function FightingCapacity:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  FightingCapacity.superclass.dispose(self);
end

function FightingCapacity:initialize(num, pos)
  self:initLayer();
  self.pos=pos;
  self:setNum(num);
end

function FightingCapacity:setNum(num)
  self.num=num;
  self:removeChildren();
  local n=0;
  local w=0;
  local s=tostring(self.num);
  local t={CommonSkeleton:getBoneTextureDisplay("common_zhangdouli_img")};
  while n<string.len(s) do
    n=1+n;
    local sprite=CommonSkeleton:getBoneTextureDisplay("common_number_" .. string.sub(s,n,n));
    sprite:setPositionY(5);
    table.insert(t,sprite);
  end
  for k,v in pairs(t) do
    v:setPositionX(w);
    w=v:getContentSize().width+w;
    self:addChild(v);
  end
  local gb=self:getGroupBounds().size;
  self:setPositionXY(self.pos.x-gb.width/2,self.pos.y-gb.height/2);
end