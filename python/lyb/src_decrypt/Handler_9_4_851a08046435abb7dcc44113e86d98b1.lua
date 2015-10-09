Handler_9_4 = class(Command);

function Handler_9_4:execute()
	sharedTextAnimateReward():animateStartByString("使用成功了哟~");
end

Handler_9_4.new():execute();