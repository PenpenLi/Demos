require "core.display.LayerPopable";
require "main.config.CountControlConfig";
require "main.view.bag.ui.bagPopup.AvatarLayer";
require "main.view.bag.ui.bagPopup.BagLayer";
require "main.view.bag.ui.bagPopup.DetailLayer";
require "main.view.bag.ui.bagPopup.EquipDetailLayer";
require "main.view.bag.ui.bagPopup.CurrencyDetailLayer";
require "main.view.bag.ui.bagPopup.PropDetail";
require "main.view.bag.ui.bagPopup.PeerageLayer";
require "main.view.bag.ui.bagPopup.PeerageItem";
require "main.view.strengthen.ui.strengthenPopup.GemTipLayer";

BagPopup=class(LayerPopableDirect);

function BagPopup:ctor()
  self.class=BagPopup;
end

function BagPopup:dispose()
  BagPopup.superclass.dispose(self);
end

function BagPopup:onDataInit()
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
  self.skeleton = self.bagProxy:getSkeleton();

  local layerPopableData = LayerPopableData.new();
  layerPopableData:setHasUIBackground(false);
  layerPopableData:setHasUIFrame(false);
  layerPopableData:setShowCurrency(true);
  self:setLayerPopableData(layerPopableData);
end

function BagPopup:onPrePop()
  local size=Director:sharedDirector():getWinSize();
  self:changeWidthAndHeight(size.width,size.height);

  self.bagLayer=BagLayer.new();
  self.bagLayer:initialize(self);
  self.bagLayer:setPositionXY(600,-15);
  self:addChild(self.bagLayer);

  self:addEventListener(DisplayEvents.kTouchTap,self.onSelfTap,self);
end

function BagPopup:onUIInit()

  local artId1=getCurrentBgArtId()

  self.bgImage = Image.new();
  self.bgImage:loadByArtID(artId1);

  local yPos = -GameData.uiOffsetY
  local winSize = Director:sharedDirector():getWinSize();
  if GameVar.mapHeight - winSize.height > 30 then
    yPos = -GameData.uiOffsetY - 30
  end
  self.bgImage:setPositionXY(-GameData.uiOffsetX, yPos);
  
  self:addChildAt(self.bgImage,0);

  self.bagLayer:initializeGallery();

  -- local l = LayerColor.new();
  -- l:initLayer();
  -- l:setContentSize(makeSize(300,300));
  -- l:setPositionXY(300,0);
  -- self.parent.parent:addChild(l);
  -- l:addEventListener(DisplayEvents.kTouchTap, onRunGameKeypadCallback);
  -- recvTable["ID"]=21;
  -- recvTable["ParamStr1"]=123;
  -- recvTable["ParamStr2"]=321;
  -- recvTable["ParamStr3"]=456;
  -- recvTable["ParamStr4"]="";
  -- recvTable["Content"]="";
  -- recvMessage(1011,6);
end

function BagPopup:onRequestedData()
  -- self.bagLayer:refreshBagPlace(self.itemUseQueueProxy);
  -- self.bagLayer:refreshBagData(self.bagProxy:getData(),1);
end

function BagPopup:onUIClose()
  self:dispatchEvent(Event.new("bagClose",nil,self));
end

function BagPopup:onPreUIClose()
  self.bagLayer:removeGallery();
end

function BagPopup:locateToGridByItemID(itemID)
  return self.bagLayer:locateToGridByItemID(itemID);
end

--[[function BagPopup:onDetailLayerTap()
  self.popup_boolean=true;
end]]

--道具panel
function BagPopup:onItemTap(tapItem, toAvatar)
  self.popup_boolean=true;
  local function callback()
    self:removeItemTap();
  end
	local itemCount = tapItem.userItem.Count;
  if self.detailLayer then
    if self.propDetailPopup then

    elseif self.peeragePopup then
      
    elseif tapItem:equal(self.detailLayer) then
      self:removeItemTap();
      return;
    end
    self:removeItemTap();
  end
  local pos=ccp(205,20);
  -- local a;
  -- if toAvatar then
  --   a=self.avatarLayer.popup_pos;
  -- else
  --   a=self.avatarLayer.popup_pos_1;
  -- end
  if tapItem:isEquip() then
    self.detailLayer=EquipDetailLayer.new();
    self.detailLayer:initialize(self.skeleton,tapItem,true,nil,nil,callback);
    self.detailLayer:setPosition(pos);
    if self.detailLayer.isSmall then
      self.detailLayer:setPositionY(100+self.detailLayer:getPositionY());
    end
    self:addChild(self.detailLayer);

    if GameVar.tutorStage == TutorConfig.STAGE_2300 then
       self:dispatchEvent(Event.new("TUTOR_USE_ITEM", nil, self));
    end
    return;
  end
	-- if tapItem:isGem() then
	-- 	self.detailLayer=GemTipLayer.new();
	-- 	local leftButtonInfo = {onTap = nil, text = "出售"}
	-- 	local rightButtonInfo = {onTap = nil, text = "合成"}
	-- 	tapItem.userItem.Count = itemCount;
	-- 	self.detailLayer:initialize(self.skeleton,self,tapItem,leftButtonInfo,rightButtonInfo,item,_,self.effectProxy,self.userCurrencyProxy);
	-- 	self.detailLayer:setPosition(pos);
	-- 	self:addChild(self.detailLayer);
	-- 	return;
	-- end

	-- if tapItem:isTreasureP() then
 --    require "main.view.bag.ui.bagPopup.TreasurePTipLayer";
 --    self.detailLayer=TreasurePTipLayer.new();
 --    local leftButtonInfo = {onTap = nil, text = "出售"}
 --    local rightButtonInfo = {onTap = nil, text = "合成"}
 --    tapItem.userItem.Count = itemCount;
 --    self.detailLayer:initialize(self.skeleton,tapItem,item,self.effectProxy,self.itemUseQueueProxy,self.userCurrencyProxy);
 --    self.detailLayer:setPosition(pos);
 --    self:addChild(self.detailLayer);
 --    return;
 --  end

 --  if tapItem:isTreasure() or tapItem:isTreasureH() then
 --    require "main.view.bag.ui.bagPopup.TreasureTipLayer";
 --    self.detailLayer=TreasureTipLayer.new();
 --    tapItem.userItem.Count = itemCount;
 --    self.detailLayer:initialize(self.skeleton,tapItem,item,self.effectProxy);
 --    self.detailLayer:setPosition(pos);
 --    self:addChild(self.detailLayer);
 --    return;
 --  end

  self.detailLayer=DetailLayer.new();
  self.detailLayer:initialize(self.skeleton,tapItem,true,nil,callback);
  self.detailLayer:setPosition(pos);
  self:addChild(self.detailLayer);
end

function BagPopup:onSelfTap(event)
  if self.popup_boolean then
    self.popup_boolean=false;
    return;
  end
  if self.detailLayer then
    self:removeItemTap();
  end
  self.popup_boolean=false;
end

function BagPopup:refreshBagDelete(data)
  self.bagLayer:refreshBagDelete(data);
end

--更新打造道具
function BagPopup:refreshBagDataByForge(userItemId)
  self.bagLayer:refreshBagDataByForge(userItemId);
end

function BagPopup:removeItemTap()
  self:removeChild(self.detailLayer);
  self.detailLayer=nil;
  self.peeragePopup=nil;
  self.propDetailPopup=nil;
end