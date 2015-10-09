VipProxy=class(Proxy);

function VipProxy:ctor()
  self.class=VipProxy;
  self.skeleton = nil;
  
	self.notice = false;
	self.giftNum = 0;
end

function VipProxy:getSkeleton()
    if nil==self.skeleton then
      self.skeleton=SkeletonFactory.new();
      self.skeleton:parseDataFromFile("vip_ui");
    end
    return self.skeleton;
end

rawset(VipProxy,"name","VipProxy");

