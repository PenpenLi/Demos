
MonthCardProxy=class(Proxy);

function MonthCardProxy:ctor()
  self.class=MonthCardProxy;
  self.itemData = {};
  self.redDotTab = {};
end

rawset(MonthCardProxy,"name","MonthCardProxy");

--龙骨
function MonthCardProxy:getSkeleton()
  if nil==self.skeleton then
	  self.skeleton = SkeletonFactory.new();
	  self.skeleton:parseDataFromFile("yueka_ui");
  end
  return self.skeleton;
end
