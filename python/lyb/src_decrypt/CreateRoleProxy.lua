CreateRoleProxy=class(Proxy);

function CreateRoleProxy:ctor()
  self.class=CreateRoleProxy;
  self.skeleton = nil;
end

function CreateRoleProxy:getSkeleton()
	if nil==self.skeleton then
	    self.skeleton=SkeletonFactory.new();
	    self.skeleton:parseDataFromFile("create_ui");
	end
  	return self.skeleton;
end

rawset(CreateRoleProxy,"name","CreateRoleProxy");
