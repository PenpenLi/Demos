

Handler_9_9 = class(Command);

function Handler_9_9:execute()
    local ItemIdArray = recvTable["ItemIdArray"];
    
    --sharedTextAnimateReward():addRewardToScene();
    sharedTextAnimateReward():animateStartByArray(ItemIdArray);
    --sharedTextAnimateReward():animateStartByString("2222222222222222222222222");
    --sharedTextAnimateReward():animateStartByString("ffffff");
end

Handler_9_9.new():execute();