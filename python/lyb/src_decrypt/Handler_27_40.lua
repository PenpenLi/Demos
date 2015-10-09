Handler_27_40 = class(Command);

function Handler_27_40:execute()
	uninitializeSmallLoading();
  sharedTextAnimateReward():animateStartByString("派遣成功 ~");
end

Handler_27_40.new():execute();