require "main.model.HeroMapsProxy"

Handler_19_2 = class(Command);

function Handler_19_2:execute()
  local proxy = HeroMapsProxy.new();
  self:registerProxy(proxy:getProxyName(),proxy);
  local tmp = recvTable["AllEverGeneralArray"];
  if nil~=tmp then
	proxy.generalId = tmp;
  end;
  for k,v in pairs(tmp) do
	print("..Handler_19_2.."..v["ConfigId"])
  end
end

Handler_19_2.new():execute();