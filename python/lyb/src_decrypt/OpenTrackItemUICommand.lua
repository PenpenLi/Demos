OpenTrackItemUICommand=class(Command);

function OpenTrackItemUICommand:ctor()
	self.class=OpenTrackItemUICommand;
end

function OpenTrackItemUICommand:execute(notification)
  print("OpenTrackItemUICommand:execute()")
	require "main.view.trackItem.TrackItemMediator";
	require "main.controller.command.trackItem.TrackItemCloseCommand";

  local data
  if notification and notification.data then
    data = notification.data;
  else
    error("notification is nil")
  end
  self.trackItemMed=self:retrieveMediator(TrackItemMediator.name);  
  if nil==self.trackItemMed then
    self.trackItemMed=TrackItemMediator.new();

    self:registerMediator(self.trackItemMed:getMediatorName(),self.trackItemMed);

    self:registerTrackItemMedCommands();
  end

  self:observe(TrackItemCloseCommand);
  if data.display then
    LayerManager:addTwoLayerPopable(data.display, self.trackItemMed:getViewComponent());
    self.trackItemMed:getViewComponent():setParallelDisplay(data.display);
  else
    -- self.trackItemMed:getViewComponent().childLayer:setOpacity(125);
    LayerManager:addLayerPopable(self.trackItemMed:getViewComponent());
  end

  self.trackItemMed:refreshData(notification.data)

  self:setMoveEnabled();
end

function OpenTrackItemUICommand:registerTrackItemMedCommands()
  self:registerCommand(MainSceneNotifications.CLOSE_TRACK_ITEM_UI_COMMAND, TrackItemCloseCommand);

end

function OpenTrackItemUICommand:setMoveEnabled()
  if HeroHousePopupMediator then
    local mediator = self:retrieveMediator(HeroHousePopupMediator.name);
    if mediator then
      mediator:getViewComponent().pageView:setMoveEnabled(false);
    end
  end

  if HeroProPopupMediator then
    local mediator = self:retrieveMediator(HeroProPopupMediator.name);
    if mediator then
      mediator:getViewComponent().pageView:setMoveEnabled(false);
    end
  end
end
