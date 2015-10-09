require "main.view.loading.ui.LoadingPopup";

LoadingMediator=class(Mediator);

function LoadingMediator:ctor()
  self.class = LoadingMediator;
	self.viewComponent=LoadingPopup.new();
  getLoadingInstance = self.viewComponent
  self.loadType = nil;
  self.value = nil;
  self.msg = nil;
end

rawset(LoadingMediator,"name","LoadingMediator");

function LoadingMediator:initialize(skeleton)
  --self:getViewComponent():initScene(false);
  self:getViewComponent():initialize(skeleton);
  	-- print("------fuck init---")
end

function LoadingMediator:onRegister()
  self:getViewComponent():addEventListener("ON_LOAD_COMPLETE", self.onLoadComplete, self);
end

function LoadingMediator:onLoadComplete(event)
  local loadingShowLayer = self:getViewComponent().loadingShowLayer;
  --  if loadingShowLayer and loadingShowLayer.onSlotScaleTap then
  --   loadingShowLayer:onSlotScaleTap();
  --   -- loadingShowLayer.onSlotScaleTap = nil;
  -- end
   self:sendNotification(LoadingNotification.new(LoadingNotifications.LOAD_SCENE_COMPLETE, self.msg));
end
--初始化
function LoadingMediator:initLoadData(data)
	self.msg = data.msg;
	self:getViewComponent():initLoadData(data);
end
--重置
function LoadingMediator:resetLoadData(count, msg)
  self.msg = msg;
  self:getViewComponent():resetLoadData(count);
end
function LoadingMediator:removeSelf()
  local parent = self:getViewComponent().parent;
  if parent then
  	parent:removeChild(self:getViewComponent(), false);
  end
end
function LoadingMediator:onRemove()
  if self:getViewComponent().parent then
    self:getViewComponent().parent:removeChild(self:getViewComponent());
  end
end
function LoadingMediator:addLoadImage()
	self:getViewComponent():addLoadImage();
end
