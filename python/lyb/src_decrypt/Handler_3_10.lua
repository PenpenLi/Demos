-- 弹框提示获得道具

Handler_3_10 = class(MacroCommand);

function Handler_3_10:execute()
  require "main.view.task.ui.GetRewardUI";
  local getRewardUI = GetRewardUI.new()
  LayerManager:addLayerPopable(getRewardUI);
  getRewardUI:initializeUI(recvTable["ItemIdArray"]);
  if  GameVar.tutorStage == TutorConfig.STAGE_1026  then
    openTutorUI({x=0, y=0, width = 74, height = 113, hideTutorHand = true, fullScreenTouchable = true});
  end
end

Handler_3_10.new():execute();