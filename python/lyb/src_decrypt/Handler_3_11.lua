--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-2-19

	yanchuan.xie@happyelements.com
]]

Handler_3_11 = class(Command);

function Handler_3_11:execute()
  uninitializeSmallLoading();
  --Level,Experience,Career,EquipmentZhanli,PetZhanli,SmallSlaveGeneralArray,UnitPropertyArray,UsingEquipmentArray
  --Level,Experience,Career,Zhanli,EquipmentZhanli,PetZhanli,SmallSlaveGeneralArray,UnitPropertyArray,UsingEquipmentArray
  --Level,Experience,Career,Prestige,Zhanli,EquipmentZhanli,PetZhanli,SmallSlaveGeneralArray,UnitPropertyArray,UsingEquipmentArray
  --Level,Experience,Career,Prestige,Zhanli,EquipmentZhanli,PetZhanli,SmallSlaveGeneralArray,UnitPropertyArray,LookUpEquipmentArray
  print(".3.11.","Level",recvTable["Level"]);
  print(".3.11.","Career",recvTable["Career"]);
  print(".3.11.","TransforId",recvTable["TransforId"]);
  print(".3.11.","Zhanli",recvTable["Zhanli"]);
  print(".3.11.","Flower",recvTable["Flower"]);
  print(".3.11.","RankGeneralArray",recvTable["RankGeneralArray"]);

  local data = {};
  data.UserId=recvTable["UserId"];
  data.UserName=recvTable["UserName"];
  data.Level=recvTable["Level"];
  data.Career=recvTable["Career"];
  data.TransforId=recvTable["TransforId"];
  data.Zhanli=recvTable["Zhanli"];
  data.Flower=recvTable["Flower"];
  data.RankGeneralArray=recvTable["RankGeneralArray"];

  require "main.view.buddy.ui.buddyPopup.PlayerInfoPopup";
  local playerInfoPopup = PlayerInfoPopup.new();
  playerInfoPopup:initialize(data);

end

Handler_3_11.new():execute();