
FirstPayProxy=class(Proxy);

function FirstPayProxy:ctor()
  self.class=FirstPayProxy;
  self.itemData = {};
  self.redDotTab = {};
end

rawset(FirstPayProxy,"name","FirstPayProxy");

--龙骨
function FirstPayProxy:getSkeleton()
  if nil==self.skeleton then
	  self.skeleton = SkeletonFactory.new();
	  self.skeleton:parseDataFromFile("shouchong_ui");
  end
  return self.skeleton;
end
