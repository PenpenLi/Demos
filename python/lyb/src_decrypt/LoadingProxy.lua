--
require "core.skeleton.SkeletonFactory"

LoadingProxy=class(Proxy);

function LoadingProxy:ctor()
  self.class=LoadingProxy;
  -- self.skeleton = SkeletonFactory.new();
  -- self.skeleton:parseDataFromFile("loading_ui");
end

rawset(LoadingProxy,"name","LoadingProxy");

function LoadingProxy:getCareer()
  return self.career;
end

