AutoGuideCommand=class(Command);

function AutoGuideCommand:ctor()
	self.class=AutoGuideCommand;
end

function AutoGuideCommand:execute(notification)
  local  data = notification.data;
  --local mainSceneMediator=self:retrieveMediator(MainSceneMediator.name);
  if data.eventType == GameConfig.TASK_EVENT_TYPE_1 then--关卡
      gameSceneIns:searchByStrongPoint(data.eventValue,data.eventParamType);
  elseif data.eventType == GameConfig.TASK_EVENT_TYPE_2 then --npc
      gameSceneIns:searchNpc(data.eventValue);
  end
  
end

