Handler_27_41 = class(Command);

function Handler_27_41:execute()
	uninitializeSmallLoading();
  sharedTextAnimateReward():animateStartByString("召回成功 ~");
end

Handler_27_41.new():execute();