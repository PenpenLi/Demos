--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-2-19

	yanchuan.xie@happyelements.com
]]

Handler_3_13 = class(Command);

function Handler_3_13:execute()
  uninitializeSmallLoading();
  --Level,Experience,Career,EquipmentZhanli,PetZhanli,SmallSlaveGeneralArray,UnitPropertyArray,UsingEquipmentArray
  --Level,Experience,Career,Zhanli,EquipmentZhanli,PetZhanli,SmallSlaveGeneralArray,UnitPropertyArray,UsingEquipmentArray
  --Level,Experience,Career,Prestige,Zhanli,EquipmentZhanli,PetZhanli,SmallSlaveGeneralArray,UnitPropertyArray,UsingEquipmentArray
  --Level,Experience,Career,Prestige,Zhanli,EquipmentZhanli,PetZhanli,SmallSlaveGeneralArray,UnitPropertyArray,LookUpEquipmentArray
  print(".3.13.","RankGeneralArray",recvTable["RankGeneralArray"]);

  local data = recvTable["RankGeneralArray"];
  for k,v in pairs(data) do
    v.GeneralId = 999
  end

  require "main.view.buddy.ui.HaoyouYingxiongkuLayer";
  local haoyouYingxiongkuLayer = HaoyouYingxiongkuLayer.new();
  haoyouYingxiongkuLayer:initialize(data);

end

Handler_3_13.new():execute();