--返回 英魂列表
-- require "main.view.hero.heroHouse.HeroHousePopupMediator";
Handler_6_1 = class(Command);

function Handler_6_1:execute()
  local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
  local generalArray = recvTable["GeneralArray"];
  for k,v in pairs(recvTable["GeneralArray"]) do
    table.insert(heroHouseProxy.generalArray, v);
    if v.Level >= 15 then
      GameVar.tutorXiLian = true;
    end
    -- print("Handler_6_1",v.GeneralId,v.ConfigId);
    -- if v.IsPlay == 1 then
  	-- print(v.GeneralId,v.ConfigId,v.UsingEquipmentArray,v.SkillArray,v.Level,v.Grade,v.IsPlay,v.Time,v.IsMainGeneral,v.TalentLevel);
    -- end
  end
  -- GeneralId,ConfigId,UsingEquipmentArray,SkillArray,Level,Grade,IsPlay,Time
  heroHouseProxy:initialize();
  -- heroHouseProxy:refreshEmployGeneralArray(recvTable["EmployGeneralArray"]);
  -- local heroHousePopupMediator=self:retrieveMediator(HeroHousePopupMediator.name);
  
  -- heroHousePopupMediator:setData();
end

Handler_6_1.new():execute();