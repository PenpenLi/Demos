Handler_3_12 = class(MacroCommand);

function Handler_3_12:execute()
    local mainType = recvTable["MainType"];
    local subType = recvTable["SubType"];
    local content = recvTable["Content"];
    

  local userProxy = self:retrieveProxy(UserProxy.name)
  userProxy.weekDay = os.date("%w",tonumber(recvTable["ServerTime"]));
  userProxy.month = tonumber(os.date("%m",tonumber(recvTable["ServerTime"]-5*60*60)));

  
  -- local operationBonusProxy=self:retrieveProxy(OperationBonusProxy.name);
  -- operationBonusProxy:refreshTime(recvTable["BeginTime"]);
  require "core.utils.CommonUtil";
  setTimeServer(recvTable["ServerTime"]);
end

Handler_3_12.new():execute();