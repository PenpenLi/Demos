require "core.display.LayerPopable";
require "main.view.mail.ui.mailPopup.MailLayer";

MailPopup=class(LayerPopableDirect);

function MailPopup:ctor()
  self.class=MailPopup;
end

function MailPopup:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  MailPopup.superclass.dispose(self);
end

function MailPopup:onDataInit()
  self.bagProxy = self:retrieveProxy(BagProxy.name);
  self.effectProxy = self:retrieveProxy(EffectProxy.name);
  -- self.petBankProxy = self:retrieveProxy(PetBankProxy.name);
  self.countControlProxy = self:retrieveProxy(CountControlProxy.name);
  self.itemUseQueueProxy = self:retrieveProxy(ItemUseQueueProxy.name);
  self.openFunctionProxy = self:retrieveProxy(OpenFunctionProxy.name);
  self.userDataAccumulateProxy = self:retrieveProxy(UserDataAccumulateProxy.name);
  self.generalListProxy = self:retrieveProxy(GeneralListProxy.name);
  self.userProxy = self:retrieveProxy(UserProxy.name);
  self.equipmentInfo = self:retrieveProxy(EquipmentInfoProxy.name);
  self.userCurrencyProxy = self:retrieveProxy(UserCurrencyProxy.name);
  self.mailProxy = self:retrieveProxy(MailProxy.name);
  self.skeleton = self.mailProxy:getSkeleton();

  local layerPopableData = LayerPopableData.new();
  layerPopableData:setHasUIBackground(false);
  layerPopableData:setHasUIFrame(false);
  layerPopableData:setShowCurrency(true);
  self:setLayerPopableData(layerPopableData);

  GameData.clickRedDotArr[FunctionConfig.FUNCTION_ID_5] = true
end

function MailPopup:onPrePop()
  self:changeWidthAndHeight(1280,720);

  self.mailLayer=MailLayer.new();
  self.mailLayer:initialize(self);
  self.mailLayer:setPositionXY(600,-15);
  self:addChild(self.mailLayer);
end

function MailPopup:onUIInit()

  local winSize = Director:sharedDirector():getWinSize()

  local artId1 = getCurrentBgArtId()

  self.bgImage = Image.new();
  self.bgImage:loadByArtID(artId1);

  self:addChildAt(self.bgImage,0)
  local yPos = -GameData.uiOffsetY
  local winSize = Director:sharedDirector():getWinSize();
  if GameVar.mapHeight - winSize.height > 30 then
    yPos = -GameData.uiOffsetY - 30
  end
  self.bgImage:setPositionXY(-GameData.uiOffsetX, yPos);
  
  self.mailLayer:initializeGallery();
end

function MailPopup:onRequestedData()
  self:dispatchEvent(Event.new(MailNotifications.MAIL_CHECK,nil,self));
end

function MailPopup:onUIClose()
  self:dispatchEvent(Event.new(MailNotifications.MAIL_CLOSE,nil,self));
end

function MailPopup:onPreUIClose()
  self.mailLayer:removeGallery();
end

function MailPopup:refreshMail()
  if not self:getIsUIPopped() then
    return;
  end
  self.mailLayer:refreshMail();

  local data = self.mailProxy:getData();
  local mailArray = data.MailArray;
  local idArray = data.IDArray;
  local hecDCData = {};
  for k,v in pairs(mailArray) do
    for k_,v_ in pairs(idArray) do
      if v.MailId == v_.ID then
        break;
      end
    end
    table.insert(hecDCData,v);
  end
  if self.hecDCBool then
    return;
  end
  local temp = {};
  for k,v in pairs(hecDCData) do
    temp["mailID" .. k] = v.MailId;
    temp["state" .. k] = v.ByteState;
  end
  hecDC(3,12,1,temp);
  self.hecDCBool = true;
end

function MailPopup:onMailItemTap(mailItem)
  self:closeMailItemDetail();
  if 0 == table.getn(mailItem.itemData.ItemIdArray) then
    self.mailItemTaped = MailDetail.new();
  else
    self.mailItemTaped = MailDetailWithBonus.new();
  end
  self.mailItemTaped:initialize(self, mailItem);
  self.mailItemTaped:setPositionXY(90, 30);
  self:addChild(self.mailItemTaped);

  self.mailItemSelected = mailItem;
end

function MailPopup:closeMailItemDetail()
  if self.mailItemTaped then
    self:removeChild(self.mailItemTaped);
    self.mailItemTaped = nil;
  end
end

function MailPopup:removeMailItem(mailItem)
  self.mailLayer:removeMailItem(mailItem);
end

function MailPopup:onRead(data)
  self:dispatchEvent(Event.new(MailNotifications.MAIL_READ,data,self));
end

function MailPopup:onGetBonus(data)
  self:dispatchEvent(Event.new(MailNotifications.MAIL_GET_BONUS,data,self));
end

function MailPopup:refreshMailDelete(idArray)
  for k,v in pairs(idArray) do
    for k_,v_ in pairs(self.mailLayer.items) do
      if v.ID == v_.itemData.MailId then
        self:removeMailItem(v_);
        break;
      end
    end
  end
end