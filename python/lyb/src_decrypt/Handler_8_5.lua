


Handler_8_5 = class(MacroCommand)

function Handler_8_5:execute()

  local doneTaskCount = recvTable["Count"];
  local itemTable = recvTable["ItemIdArray"]
  local itemCount = 0

  if itemTable then
    for k,v in pairs(itemTable) do
      if v.ItemId == 1 then
        itemCount = itemCount + v.Count
      end
    end
  end
 
  local taskMediator = self:retrieveMediator(TaskMediator.name)
  if taskMediator then
    taskMediator:refreshNoTaskData(doneTaskCount,itemCount)
  end
end

Handler_8_5.new():execute();