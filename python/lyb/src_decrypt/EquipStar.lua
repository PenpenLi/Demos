require "core.skeleton.SkeletonFactory";
require "core.display.Layer";

EquipStar=class(Layer);

function EquipStar:ctor()
  self.class=EquipStar;
end

function EquipStar:dispose()
  self:removeChildren();
	EquipStar.superclass.dispose(self);
end

function EquipStar:initialize(level)
  self:initLayer();
  if level then
    self:refresh(level);
  end
end

function EquipStar:refresh(level)
  self:removeChildren();
  
  local a=math.floor(level/9);
  local b=math.floor((level-9*a)/3);
  local c=level-9*a-3*b;
  local d=0;
  local x=0;
  local t={};
  while a>d do
    table.insert(t,CommonSkeleton:getBoneTextureDisplay("common_sun"));
    d=d+1;
  end
  d=0;
  while b>d do
    table.insert(t,CommonSkeleton:getBoneTextureDisplay("common_moon"));
    d=d+1;
  end
  d=0;
  while c>d do
    table.insert(t,CommonSkeleton:getBoneTextureDisplay("common_star"));
    d=d+1;
  end
  d=0;
  while table.getn(t)>d do
    d=d+1;
    t[d]:setPositionX(x);
    x=x+t[d]:getContentSize().width;
    self:addChild(t[d]);
  end
end