require "main.view.storyLine.ui.StoryLinePopup";

StoryLineMediator=class(Mediator);

function StoryLineMediator:ctor()
  self.class = StoryLineMediator;
	self.viewComponent=StoryLinePopup.new();
end
 
rawset(StoryLineMediator,"name","StoryLineMediator");

function StoryLineMediator:setData(strongPointId)
 	self:getViewComponent():setData(strongPointId)
end

function StoryLineMediator:refreshData(storyLineId)
  self:getViewComponent():refreshData(storyLineId)
end

function StoryLineMediator:onRegister()
  self:getViewComponent():initialize();
  self:getViewComponent():addEventListener("CLOSE_JUANZHOU_PARENT", self.onStoryLineClose, self);
  self:getViewComponent():addEventListener("ON_ENTER_BATTLE", self.onEnterBattle, self)
  self:getViewComponent():addEventListener("ON_MOPUP", self.onMopUp, self)
  self:getViewComponent():addEventListener("ON_ITEM_TIP", self.onItemTip, self)
end
function StoryLineMediator:onItemTip(event)
  self:sendNotification(TipNotification.new(TipNotifications.OPEN_TIP_COMMOND, event.data));
end
function StoryLineMediator:onRemove()

  if self:getViewComponent().parent then
  	self:getViewComponent().parent:removeChild(self:getViewComponent());
  end
end
function StoryLineMediator:onEnterBattle(event)
  self:sendNotification(ShadowNotification.new(ShadowNotifications.OPEN_STRONGPOINT_INFO_UI_COMMAND, event.data));
end
function StoryLineMediator:onMopUp(event)
  self:sendNotification(StrongPointInfoNotification.new(StrongPointInfoNotifications.OPEN_QUICK_BATTLE_UI_COMMOND, event.data));
end
function StoryLineMediator:onStoryLineClose(event)
  --setButtonGroupVisible(true)
  self:sendNotification(StrongPointInfoNotification.new(StrongPointInfoNotifications.CLOSE_STORYLINE_UI_COMMOND));
end
function StoryLineMediator:setMoveEnabled(b)
  self:getViewComponent():setMoveEnabled(b)
end

function StoryLineMediator:refreshStarBox()
  self:getViewComponent():refreshStarBox()
end
