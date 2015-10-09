require "core.display.LayerPopable";
require "main.view.family.bangPai.BangPaiLayer";
require "main.view.family.bangPai.NoneBangPaiLayer";

BangpaiPopup=class(LayerPopableDirect);

function BangpaiPopup:ctor()
  self.class=BangpaiPopup;
end

function BangpaiPopup:dispose()
  if self.bangpaiLayer and self.bangpaiLayer.bangpaiHuoyueduLayer then
    self.bangpaiLayer.bangpaiHuoyueduLayer.parent:removeChild(self.bangpaiLayer.bangpaiHuoyueduLayer);
  end
  if self.bangpaiLayer and self.bangpaiLayer.bangpaiRizhiLayer then
    self.bangpaiLayer.bangpaiRizhiLayer.parent:removeChild(self.bangpaiLayer.bangpaiRizhiLayer);
  end
  self:removeAllEventListeners();
  self:removeChildren();
  BangpaiPopup.superclass.dispose(self);
  BitmapCacher:removeUnused();
end

function BangpaiPopup:onDataInit()
  self.familyProxy=self:retrieveProxy(FamilyProxy.name);
  self.bagProxy = self:retrieveProxy(BagProxy.name);
  self.effectProxy = self:retrieveProxy(EffectProxy.name);
  self.countControlProxy = self:retrieveProxy(CountControlProxy.name);
  self.itemUseQueueProxy = self:retrieveProxy(ItemUseQueueProxy.name);
  self.openFunctionProxy = self:retrieveProxy(OpenFunctionProxy.name);
  self.userDataAccumulateProxy = self:retrieveProxy(UserDataAccumulateProxy.name);
  self.generalListProxy = self:retrieveProxy(GeneralListProxy.name);
  self.userProxy = self:retrieveProxy(UserProxy.name);
  self.equipmentInfo = self:retrieveProxy(EquipmentInfoProxy.name);
  self.userCurrencyProxy = self:retrieveProxy(UserCurrencyProxy.name);
  self.mailProxy = self:retrieveProxy(MailProxy.name);
  self.shopProxy = self:retrieveProxy(ShopProxy.name);
  self.heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
  self.buddyListProxy = self:retrieveProxy(BuddyListProxy.name);
  self.skeleton = self.familyProxy:getSkeleton();

  local layerPopableData = LayerPopableData.new();
  layerPopableData:setHasUIBackground(true);
  layerPopableData:setHasUIFrame(true);
  layerPopableData:setShowCurrency(true);--self.userProxy:getHasFamily()
  layerPopableData:setPreUIData(StaticArtsConfig.BACKGROUD_HERO_PRO, nil, true, 2);
  self:setLayerPopableData(layerPopableData);
end

function BangpaiPopup:onPrePop()
  self:changeWidthAndHeight(1280,720);

  self.hasFamily = self.userProxy:getHasFamily();
  if self.hasFamily then
    self.bangpaiLayer = BangPaiLayer.new();
  else
    self.bangpaiLayer = NoneBangPaiLayer.new();
  end
  self.bangpaiLayer:initialize(self);
  self:addChild(self.bangpaiLayer);
  self:refreshRedDot();
end

function BangpaiPopup:onUIInit()
  
end

function BangpaiPopup:onRequestedData()
  
end

function BangpaiPopup:onUIClose()
  self:dispatchEvent(Event.new(FamilyNotifications.FAMILY_CLOSE,nil,self));
end

function BangpaiPopup:onPreUIClose()
  
end

function BangpaiPopup:refreshFamilyList(familyInfoArray)
  self.bangpaiLayer:refreshFamilyList(familyInfoArray);
end

function BangpaiPopup:refreshFamilyApply(familyId, booleanValue)
  self.bangpaiLayer:refreshFamilyApply(familyId, booleanValue);
end

function BangpaiPopup:refreshByFoundSuccess()
  print("----------------BangpaiPopup:refreshByFoundSuccess");
  self:closeUI();
end

function BangpaiPopup:refreshFamilyInfo(familyInfo)
  self.bangpaiLayer:refreshFamilyInfo(familyInfo);
end

function BangpaiPopup:refreshFamilyApplierArray(applierArray)
  self.bangpaiLayer:refreshFamilyApplierArray(applierArray);
end

function BangpaiPopup:refreshFamilyLogArray(familyLogArray)
  self.bangpaiLayer:refreshFamilyLogArray(familyLogArray);
end

function BangpaiPopup:refreshHuoyuedujiangli(huoyuedu, idArray)
  self.bangpaiLayer:refreshHuoyuedujiangli(huoyuedu,idArray);
end

function BangpaiPopup:refreshFamilyMemberKaichu(userID)
  self.bangpaiLayer:refreshFamilyMemberKaichu(userID);
end

function BangpaiPopup:refreshFamilyMemeberPositionID(userID, positionID)
  self.bangpaiLayer:refreshFamilyMemeberPositionID(userID,positionID);
  self:removeButtonSelector();
end

function BangpaiPopup:refreshFamilyMemeberPositionIDs(changeMemberArray)
  self.bangpaiLayer:refreshFamilyMemeberPositionIDs(changeMemberArray);
  self:removeButtonSelector();
end

function BangpaiPopup:refreshFamilyMemberIncrease(data)
  self.bangpaiLayer:refreshFamilyMemberIncrease(data);
end

function BangpaiPopup:refreshHuoyuedulingjiang(id)
  self.bangpaiLayer:refreshHuoyuedulingjiang(id);
end

function BangpaiPopup:refreshRedDot()
  if self.bangpaiLayer and self.bangpaiLayer.refreshRedDot then
    self.bangpaiLayer:refreshRedDot();
  end
end

function BangpaiPopup:onTuichu()
  self:closeUI();
end

function BangpaiPopup:removeButtonSelector()
  if self.buttonsSelector and not self.buttonsSelector.isDisposed then
    self.buttonsSelector.parent:removeChild(self.buttonsSelector);
    self.buttonsSelector = nil;
  end
end