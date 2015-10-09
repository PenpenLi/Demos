--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-2-19

	yanchuan.xie@happyelements.com
]]

require "main.view.bag.ui.bagPopup.BetterEquipLayer";

BetterEquipManager={};

BetterEquipManager.betterEquips={};

BetterEquipManager.layers={};

function BetterEquipManager:addLayers()
  for k,v in pairs(self.layers) do
    sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_ASSIST):addChild(v);
  end
end

function BetterEquipManager:pop(betterEquipLayer)
  for k,v in pairs(self.layers) do
    if betterEquipLayer==v then
      table.remove(self.layers,k);
      break;
    end
  end
end

function BetterEquipManager:push(skeleton, itemData, context, onEquip, equipmentInfoProxy)
  if (GameVar.tutorStage ~= TutorConfig.STAGE_2300)then
      for k,v in pairs(self.layers) do
        local categoryID=math.floor(v:getItemData().ItemId/1000);
        local categoryID_1=math.floor(itemData.ItemId/1000);
        if categoryID==categoryID_1 then
          if equipmentInfoProxy:getEquipmentInfo(v:getItemData().UserItemId).Zhanli<
             equipmentInfoProxy:getEquipmentInfo(itemData.UserItemId).Zhanli then
             v:onCloseButtonTap();
          end
        end
      end
      local a=BetterEquipLayer.new();
      a:initialize(skeleton,itemData,context,onEquip);
      if sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_ASSIST) then
        sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_ASSIST):addChild(a);
      end

      
      table.insert(self.layers,a);
  end
end

function BetterEquipManager:removeLayers()
  for k,v in pairs(self.layers) do
    if v.parent then v.parent:removeChild(v,false); end
  end
end

function BetterEquipManager:cleanAllLayers()
  for k,v in pairs(self.layers) do
    if v.parent then
      v.parent:removeChild(v);
    elseif not v.isDisposed then
      v:dispose();
    end
  end
  BetterEquipManager.betterEquips={};
  BetterEquipManager.layers={};
end