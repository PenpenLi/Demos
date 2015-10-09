--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-9-10

	yanchuan.xie@happyelements.com
]]

EffectProxy=class(Proxy);

function EffectProxy:ctor()
  self.class=EffectProxy;
  self.data=nil;
  self.basic_skeleton=nil;
  self.hero_skeleton=nil;
  self.level_up_skeleton=nil;
  self.mark_skeleton=nil;
end

rawset(EffectProxy,"name","EffectProxy");

function EffectProxy:getData()
  return self.data;
end

function EffectProxy:getBasicSkeleton()
  if nil==self.basic_skeleton then
    self.basic_skeleton=SkeletonFactory.new();
    self.basic_skeleton:parseDataFromFile("effect_basic_ui");
  end
  return self.basic_skeleton;
end

function EffectProxy:getHeroSkeleton()
  if nil==self.hero_skeleton then
    self.hero_skeleton=SkeletonFactory.new();
    self.hero_skeleton:parseDataFromFile("effect_hero_ui");
  end
  return self.hero_skeleton;
end

function EffectProxy:getLevelUpSkeleton()
  if nil==self.level_up_skeleton then
    self.level_up_skeleton=SkeletonFactory.new();
    self.level_up_skeleton:parseDataFromFile("effect_level_up_ui");
  end
  return self.level_up_skeleton;
end

function EffectProxy:getBatchUseSkeleton()
  if nil==self.batchUseSkeleton then
    self.batchUseSkeleton = SkeletonFactory.new();
    self.batchUseSkeleton:parseDataFromFile("batchUse_ui");
  end
  return self.batchUseSkeleton;
end

function EffectProxy:getMarkSkeleton()
  if nil==self.mark_skeleton then
    self.mark_skeleton=SkeletonFactory.new();
    self.mark_skeleton:parseDataFromFile("effect_mark_ui");
  end
  return self.mark_skeleton;
end