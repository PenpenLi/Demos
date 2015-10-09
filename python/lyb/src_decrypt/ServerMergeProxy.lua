--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

ServerMergeProxy=class(Proxy);

function ServerMergeProxy:ctor()
  self.class=ServerMergeProxy;
  self.skeleton=nil;
end

rawset(ServerMergeProxy,"name","ServerMergeProxy");

function ServerMergeProxy:getSkeleton()
  if nil==self.skeleton then
	  self.skeleton=SkeletonFactory.new();
    self.skeleton:parseDataFromFile("server_merge_ui");
  end
  return self.skeleton;
end

function ServerMergeProxy:getOfficialSkeleton()
  if nil==self.skeleton then
    self.skeleton=SkeletonFactory.new();
    self.skeleton:parseDataFromFile("official_server_ui");
  end
  return self.skeleton;
end