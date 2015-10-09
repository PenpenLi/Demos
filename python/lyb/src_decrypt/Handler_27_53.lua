
Handler_27_53 = class(Command);

function Handler_27_53:execute()
  local status = 1 == recvTable["State"];
  if status then
  	sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_160));
  -- else
  -- 	sharedTextAnimateReward():animateStartByString("美女不搭理你呢~");
  end
  local bathFieldMediator = self:retrieveMediator(BathFieldMediator.name);
  bathFieldMediator:setTouchStatus(true);
end

Handler_27_53.new():execute();