
Handler_4_5 = class(MacroCommand);

function Handler_4_5:execute()
  print(".4.5.");
  -- uninitializeSmallLoading();
 
  local storyLineProxy = self:retrieveProxy(StoryLineProxy.name);

 
  for k,v in pairs(recvTable["YXZStrongPointArray"]) do
    local key = "key_" .. v.ID;
    local State = 1;
    if v.TotalCount == 0 then
      State = 3
    end
    local strongPointData = {StrongPointId=v.ID, Count=v.Count, TotalCount=v.TotalCount, State=State, StarLevel = v.StarLevel}--State,Count,TotalCount
    storyLineProxy.strongPointArray[key] = strongPointData
    print(".4.5..ID,Count,TotalCount",v.ID, v.Count,v.TotalCount);
  end
  if HButtonGroupMediator then
    local buttonGroupMediator = self:retrieveMediator(HButtonGroupMediator.name)
    if buttonGroupMediator then
      buttonGroupMediator:refreshYingXiongZhi();
    else
      print("buttonGroupMediator is nil....")
    end
  end
  
end

Handler_4_5.new():execute();