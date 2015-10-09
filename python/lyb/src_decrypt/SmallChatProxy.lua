--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-3-4

	yanchuan.xie@happyelements.com
]]

SmallChatProxy=class(Proxy);

function SmallChatProxy:ctor()
  self.class=SmallChatProxy;
  self.data=nil;
  self.skeleton=nil;
end

rawset(SmallChatProxy,"name","SmallChatProxy");

function SmallChatProxy:setData(data)
  self.data=data;
end

function SmallChatProxy:getData()
  return self.data;
end

function SmallChatProxy:getSkeleton()
  if nil==self.skeleton then
    self.skeleton=SkeletonFactory.new();
    self.skeleton:parseDataFromFile("small_chat_ui");
  end
  return self.skeleton;
end