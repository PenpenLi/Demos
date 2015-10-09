
BangDingProxy=class(Proxy);

function BangDingProxy:ctor()
  self.class=BangDingProxy;
  self.itemData = {};
  self.redDotTab = {};
end

rawset(BangDingProxy,"name","BangDingProxy");

--龙骨
function BangDingProxy:getSkeleton()
  if nil==self.skeleton then
	  self.skeleton = SkeletonFactory.new();
	  self.skeleton:parseDataFromFile("huodong_ui");
  end
  return self.skeleton;
end
