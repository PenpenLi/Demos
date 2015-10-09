ServerProxy=class(Proxy);

function ServerProxy:ctor()
  self.class=ServerProxy;
  self.skeleton = nil
  
end

function ServerProxy:getSkeleton()
    if nil==self.skeleton then
      self.skeleton=SkeletonFactory.new();
      self.skeleton:parseDataFromFile("selectServe_ui");
    end
    return self.skeleton;
end

rawset(ServerProxy,"name","ServerProxy");
