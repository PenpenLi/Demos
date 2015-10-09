Handler_27_10 = class(Command);

function Handler_27_10:execute()
  print(".27.10.",recvTable["FamilyId"],recvTable["FamilyPositionId"]);
  local userProxy = self:retrieveProxy(UserProxy.name);
  userProxy.familyId=recvTable["FamilyId"];
  userProxy.familyPositionId=recvTable["FamilyPositionId"];
end

Handler_27_10.new():execute();