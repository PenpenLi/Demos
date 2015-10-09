require "main.view.createScene.CreateRolePopup";

CreateRoleMediator=class(Mediator);

function CreateRoleMediator:ctor()
  self.class = CreateRoleMediator;
	self.viewComponent = CreateRolePopup.new();
end

rawset(CreateRoleMediator,"name","CreateRoleMediator");

function CreateRoleMediator:intializeHeroCreateUI(skeleton)
  self:getViewComponent():intializeHeroCreateUI(skeleton);
end

function CreateRoleMediator:refreshUserName(userName)
      self:getViewComponent():refreshUserName(userName);
end

function CreateRoleMediator:initialize()
  self:getViewComponent():initialize();
end

function CreateRoleMediator:onRemove()
    -- if self:getViewComponent().parent then
	   --  self:getViewComponent().parent:removeChild(self:getViewComponent());
    -- end
end
