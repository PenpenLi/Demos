Handler_21_11 = class(Command);

function Handler_21_11:execute()
  -- if 1 == recvTable["BooleanValue"] then
  	sharedTextAnimateReward():animateStartByString("好友添加请求发送成功哦 ~");
  -- else
  -- 	sharedTextAnimateReward():animateStartByString("玩家不存在哦 ~");
  -- end
end

Handler_21_11.new():execute();