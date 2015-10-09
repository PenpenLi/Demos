require "main.controller.command.guide.AutoGuideCommand";

BagAutoGuideCommand=class(MacroCommand);

function BagAutoGuideCommand:ctor()
    self.class=BagAutoGuideCommand;
end

function BagAutoGuideCommand:execute(notification)
    if notification.data.type == "TreasureTipLayer" then
        local data={eventType=notification.data.eventType,eventValue=notification.data.eventValue,eventParamType=GameConfig.STRONGPOINT_PARAM_TYPE_3};
        local storyLineProxy = self:retrieveProxy(StoryLineProxy.name);
        local tempData9_4={Place=notification.data.Place,ItemId=notification.data.ItemId,Count=notification.data.Count,CurrencyType=notification.data.CurrencyType};
        storyLineProxy.tempData9_4 = tempData9_4;
        storyLineProxy.tempData9_4_userItemId = notification.data.userItemId
        self:functionGuide(data)
    elseif notification.data.type == "MapScene" then
        local storyLineProxy = self:retrieveProxy(StoryLineProxy.name);
        if not storyLineProxy.tempData9_4 then return;end
        sendMessage(9,4,storyLineProxy.tempData9_4);
        local bagProxy=self:retrieveProxy(BagProxy.name);
        bagProxy:setStrongPointIdByUserItemID(storyLineProxy.tempData9_4_userItemId,nil);
        storyLineProxy.storyLineId = nil;
        storyLineProxy.tempData9_4 = nil;
        storyLineProxy.tempData9_4_userItemId = nil
    end
end

function BagAutoGuideCommand:functionGuide(data)
    self:cutDown();
    self:addSubCommand(AutoGuideCommand);
    self:complete(BagPopupNotification.new("",data));
end

--[[function BagAutoGuideCommand:chickStoryLineId(storyLineProxy,strongPointId)
    if not storyLineProxy.storyLineId then return false;end
    local bagProxy=self:retrieveProxy(BagProxy.name);
    if storyLineProxy.storyLineId == strongPointId then
            return true;
    else
            return false
    end
end]]