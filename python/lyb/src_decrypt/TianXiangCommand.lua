
TianXiangCommand=class(Command);

function TianXiangCommand:ctor()
  self.class=TianXiangCommand;
end

function TianXiangCommand:execute(notification)

  require "main.view.tianXiang.TianXiangMediator";
  require "main.model.UserProxy";
   require "main.controller.command.tianXiang.TianXiangCloseCommand";
  local tianXiangMed=self:retrieveMediator(TianXiangMediator.name);


  if nil == tianXiangMed then
    tianXiangMed=TianXiangMediator.new();
    self:registerMediator(tianXiangMed:getMediatorName(),tianXiangMed);
  end

  LayerManager:addLayerPopable(tianXiangMed:getViewComponent());

  self:registerTianXiangCommands();

  if GameVar.tutorStage == TutorConfig.STAGE_1023 then
    openTutorUI({x=221 + GameData.uiOffsetX + 45, y=174, width = 70, height = 70});
  end

  hecDC(3,28,1)
end

function TianXiangCommand:registerTianXiangCommands()
  self:registerCommand(MainSceneNotifications.CLOSE_TIANXIANG_UI_COMMAND, TianXiangCloseCommand);
  self:observe(TianXiangCloseCommand);
end