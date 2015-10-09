require "main.view.createScene.ui.CreateRoleLayer";

CreateRolePopup=class(TouchLayer);

function CreateRolePopup:ctor()
  self.class=CreateRolePopup;
end

function CreateRolePopup:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	CreateRolePopup.superclass.dispose(self);

  BitmapCacher:removeUnused();
end

function CreateRolePopup:initialize()
  
  self.skeleton=nil;
  self.userCurrencyProxy = nil;
end


function CreateRolePopup:intializeHeroCreateUI(skeleton)
  self:initLayer();

  self.createRoleLayer = CreateRoleLayer.new();
  self.createRoleLayer:initialize(skeleton);
  self:addChild(self.createRoleLayer);
  self.skeleton = keleton;
    
end

function CreateRolePopup:initialize()
    self.createRoleLayer:initialize(skeleton);
end

function CreateRolePopup:refreshUserName(userName)
  self.createRoleLayer:refreshUserName(userName);
end


