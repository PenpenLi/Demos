
Handler_27_52 = class(Command);

function Handler_27_52:execute()
  local gain = recvTable["Value"];
  -- if gain >0 then
  -- 	sharedTextAnimateReward():animateStartByString("沐浴结束");
  -- else
  -- 	sharedTextAnimateReward():animateStartByString("沐浴结束今天已经超过制定次数了");
  -- end
  local bathFieldMediator = self:retrieveMediator(BathFieldMediator.name);
  if bathFieldMediator then
    -- bathFieldMediator:onClose();
  	bathFieldMediator:onResault(gain);
  else
    sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_162));
  end
end

Handler_27_52.new():execute();