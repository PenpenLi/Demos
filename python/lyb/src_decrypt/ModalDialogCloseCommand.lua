ModalDialogCloseCommand=class(MacroCommand);

function ModalDialogCloseCommand:ctor()
	self.class=ModalDialogCloseCommand;
end

function ModalDialogCloseCommand:execute(notification)
  -- if GameVar.tutorStage == TutorConfig.STAGE_1012 then

  -- 		local storyLineProxy = self:retrieveProxy(StoryLineProxy.name)
  --       local storyLinePo = analysis("Juqing_Juqing",storyLineProxy.storyLineId)

  --       local strongPoints = analysisByName("Juqing_Guanka","storyId", storyLineProxy.storyLineId)
  --       local mapUIData = analysisMapUI(storyLinePo.mapId)
  --       local detailTable = mapUIData.outersTable

  --       ----add 房子
  --       for k,v in pairs(strongPoints) do
  --         print("strongPointId", v.id)
  --         local strongPointInEditor = detailTable[v.strongPointId]
  --         local strongPointData = storyLineProxy.strongPointArray["key_"..v.id];
  --         if strongPointData then
  --           if strongPointData.State == GameConfig.STRONG_POINT_STATE_3 or strongPointData.State == GameConfig.STRONG_POINT_STATE_4 then

  --              if GameVar.tutorStage == TutorConfig.STAGE_1006 and GameVar.tutorSmallStep < 5 then
  --              else
  --                 openTutorUI({x=strongPointInEditor.xPos+6, y=strongPointInEditor.yPos-122, width = 95, height = 94, alpha = 125});
  --              end
  --              break;
  --           end
  --         end
  --       end
  -- end
  self:removeMediator(ModalDialogMediator.name);
  self:unobserve(ModalDialogCloseCommand);
end
