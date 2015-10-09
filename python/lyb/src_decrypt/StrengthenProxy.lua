--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-3-15

	yanchuan.xie@happyelements.com
]]

StrengthenProxy=class(Proxy);

function StrengthenProxy:ctor()
  self.class=StrengthenProxy;
  self.data=nil;
  self.skeleton=nil;

  self.Qianghua_Bool = nil;
  self.Dazao_Bool = nil;
  self.Qianghua_ALL_Bool = nil;

  self.Xi_Lian = nil;
end

rawset(StrengthenProxy,"name","StrengthenProxy");

function StrengthenProxy:getSkeleton()
  if nil==self.skeleton then
	  self.skeleton=SkeletonFactory.new();
    self.skeleton:parseDataFromFile("strengthen_ui");
  end
  return self.skeleton;
end