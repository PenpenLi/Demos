
SecondPayProxy=class(Proxy);

function SecondPayProxy:ctor()
  self.class=SecondPayProxy;
  self.itemData = {};
  self.redDotTab = {};
end

rawset(SecondPayProxy,"name","SecondPayProxy");

--龙骨
function SecondPayProxy:getSkeleton()
  if nil==self.skeleton then
	  self.skeleton = SkeletonFactory.new();
	  self.skeleton:parseDataFromFile("leichong_ui");
  end
  return self.skeleton;
end
