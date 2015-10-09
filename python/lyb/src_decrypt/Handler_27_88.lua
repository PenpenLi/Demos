
Handler_27_88 = class(Command);

function Handler_27_88:execute()
  local battleProxy = self:retrieveProxy(BattleProxy.name)
  --PartAFamilyId,PartAFamilyName,PartAFamilyLevel,PartBFamilyId,PartBFamilyName,PartBFamilyLevel,BattleInfoArray
  battleProxy.familyViewData = {}
  battleProxy.familyViewData.PartAFamilyId = recvTable["PartAFamilyId"]
  battleProxy.familyViewData.PartAFamilyName = recvTable["PartAFamilyName"]
  battleProxy.familyViewData.PartAFamilyLevel = recvTable["PartAFamilyLevel"]
  battleProxy.familyViewData.PartBFamilyId = recvTable["PartBFamilyId"]
  battleProxy.familyViewData.PartBFamilyName = recvTable["PartBFamilyName"]
  battleProxy.familyViewData.PartBFamilyLevel = recvTable["PartBFamilyLevel"]
  battleProxy.familyViewData.BattleInfoArray = recvTable["BattleInfoArray"]
  uninitializeSmallLoading();
  --[[uninitializeSmallLoading();
  local data={};
  data.Stage=recvTable["Stage"];
  data.RemainSeconds=recvTable["RemainSeconds"];
  data.FamilyPromotionArray=recvTable["FamilyPromotionArray"];
  local possessionBattleMediator=self:retrieveMediator(PossessionBattleMediator.name);
  if nil~=possessionBattleMediator then
  	possessionBattleMediator:refreshStage(data);
  end]]
end

Handler_27_88.new():execute();