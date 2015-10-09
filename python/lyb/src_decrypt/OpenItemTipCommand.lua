
OpenItemTipCommand=class(Command);

function OpenItemTipCommand:ctor()
	self.class=OpenItemTipCommand;
end

function OpenItemTipCommand:execute(notification)
  require "main.model.BagProxy";
  require "main.view.tip.TipMediator";
  require "main.controller.command.tip.RemoveTipCommand"

  local bagProxy=self:retrieveProxy(BagProxy.name);
  local userProxy = self:retrieveProxy(UserProxy.name)
  local generalListProxy = self:retrieveProxy(GeneralListProxy.name)
  local tipMed=self:retrieveMediator(TipMediator.name);  
  if nil == tipMed then
    tipMed=TipMediator.new();
    self:registerMediator(tipMed:getMediatorName(), tipMed);
    tipMed:initialize(bagProxy:getSkeleton(), userProxy, generalListProxy);
  end

  if not notification.data.item:isEquip() then
    tipMed:setItemTip(notification.data.item,notification.data.callBack, notification.data.showButton,notification.data.count);
    if tipMed.equipTip then
      tipMed.equipTip:setVisible(false)
    end 
    if tipMed.itemTip then
      tipMed.itemTip:setVisible(true)
    end
    if notification.data.parent then
      notification.data.parent:addChild(tipMed.itemTip);
    else
      sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_CURRENCY):addChild(tipMed.itemTip); 
    end
  else
    tipMed:setEquipTip(notification.data.item,notification.data.callBack, notification.data.showButton,notification.data.count);
    if tipMed.itemTip then
      tipMed.itemTip:setVisible(false)
    end
    if tipMed.equipTip then
      tipMed.equipTip:setVisible(true)
    end
    if notification.data.parent then
      notification.data.parent:addChild(tipMed.equipTip);
    else
      sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_CURRENCY):addChild(tipMed.equipTip); 
    end
  end
  self:observe(RemoveTipCommand);
end


