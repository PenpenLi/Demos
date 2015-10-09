
-- require "main.view.loginLottery.LoginLotteryMediator";

Handler_29_5 = class(Command);

function Handler_29_5:execute()
  print(".29.5.",recvTable["ID"]);
  uninitializeSmallLoading();
  local firstChargeProxy=self:retrieveProxy(FirstChargeProxy.name);
  firstChargeProxy:refreshItem(recvTable["ID"]);

  local firstChargeMediator = self:retrieveMediator(FirstChargeMediator.name);
  if firstChargeMediator then
     firstChargeMediator:refreshDataToNextPage(recvTable["ID"]);
  end

  if MainSceneMediator then
    local mainMediator = self:retrieveMediator(MainSceneMediator.name)
    if mainMediator and mainMediator.viewComponent and mainMediator.viewComponent.mainUI then
       mainMediator:refreshFirstChargeEffect();
    end
  end
end

Handler_29_5.new():execute();