

Handler_6_20 = class(MacroCommand);

function Handler_6_20:execute()
  local zhenFaProxy = self:retrieveProxy(ZhenFaProxy.name);
  local formationArray = recvTable["FormationArray"];
 -- print("############  Handler_6_20  1")
  zhenFaProxy:setData(formationArray);
  -- for i,v in ipairs(formationArray) do
  --   print("Handler_6_20##############", v.ID, v.Level)
  -- end
end

Handler_6_20.new():execute();