require "main.config.BattleConfig"
require "core.display.Scene"


-- singleton
local instance_ = nil;
function sharedBattleLayerManager()
    if instance_ == nil then
        instance_ = BattleLayerManager.new();
    end
    return instance_;
end

BattleLayerManager = class();
function BattleLayerManager:ctor()
	self.layerArr = {};
	self.index = 0;
  self.layer = Layer.new();
  self.layer:initLayer();
end
----------------
--registerLayer
----------------
function BattleLayerManager:addLayers(scene)
  self.scene = scene;
	self:registerLayer(BattleConfig.Battle_LAYER_MAP_BG);
	self:registerLayer(BattleConfig.Battle_LAYER_MAP);
	self:registerLayer(BattleConfig.Battle_LAYER_EFFECTS_BACK);
	self:registerLayer(BattleConfig.Battle_LAYER_PLAYERS);
	self:registerLayer(BattleConfig.Battle_LAYER_EFFECTS);
  self:registerLayer(BattleConfig.Battle_LAYER_STOPSKILL);
	self:registerLayer(BattleConfig.Battle_LAYER_EFFECTS_SCREEN);
  
  scene:addChild(self.layer);
	self:registerUIlayer(BattleConfig.Battle_LAYER_UI);
	self:registerUIlayer(BattleConfig.Battle_LAYER_SHIFT_SCENE);
  self:registerUIlayer(BattleConfig.Battle_LAYER_TOP);
  self:layerScalePosition()
end

function BattleLayerManager:layerScalePosition()
  self.layer:setScale(GameData.gameUIScaleRate);
  self.layer:setPositionXY(GameData.uiOffsetX * GameData.gameUIScaleRate,
                  GameData.uiOffsetY * GameData.gameUIScaleRate)
end
----------------
-- register layer by id
----------------
function BattleLayerManager:registerLayer(index)
  local itemLayer = Layer.new();
  if index == BattleConfig.Battle_LAYER_EFFECTS_BACK then
      itemLayer.touchEnabled = false
      itemLayer:initLayer();
  elseif index == BattleConfig.Battle_LAYER_MAP then
      itemLayer:initLayer();
      itemLayer.mapBatchLayer = Layer.new();
      itemLayer.mapBatchLayer:initLayer();
      itemLayer:addChild(itemLayer.mapBatchLayer)
      itemLayer.shadowBatchLayer = BatchLayer.new();
      itemLayer.shadowBatchLayer:initImageLayer(artData[19].source)
      itemLayer:addChildAt(itemLayer.shadowBatchLayer,100000)
      itemLayer.shadowBatchLayer:setVisible(false)
  else
    itemLayer:initLayer();
  end
  
  itemLayer.name = "bitemLayer" .. index;
  self.layerArr[index] = itemLayer;
   
  self.layer:addChild(itemLayer);
end

--UI直截放在secen上
function BattleLayerManager:registerUIlayer(index)
  local itemLayer = Layer.new();
  itemLayer:initLayer();
  itemLayer.name = "bitemLayer" .. index;
  self.layerArr[index] = itemLayer;

  itemLayer:setScale(GameData.gameUIScaleRate);
  itemLayer:setPositionXY(GameData.uiOffsetX * GameData.gameUIScaleRate,
                  GameData.uiOffsetY * GameData.gameUIScaleRate)

  self.scene:addChild(itemLayer);
end
----------------
--remove
----------------
function BattleLayerManager:removeLayer(index)
    self.layerArr[index] = nil;
end
----------------
--get layer by Id
----------------
function BattleLayerManager:getLayer(index)
    local layer = self.layerArr[index];
    if layer == nil then
    end
    return layer;
end

function BattleLayerManager:layerPause()
    sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_PLAYERS):pause()
    sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_MAP):pause()
    sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_EFFECTS_BACK):pause()
    sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_EFFECTS):pause()
end

function BattleLayerManager:layerResume()
    if not sharedBattleLayerManager() then return end
    if not sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_MAP) then return end
    sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_PLAYERS):resume()
    sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_MAP):resume()
    sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_EFFECTS_BACK):resume()
    sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_EFFECTS):resume()
end
----------------
-- clear all obj 
----------------
function BattleLayerManager:clear()
	if self.layerArr then
	    for k,v in pairs(self.layerArr) do
		    v:removeChildren()
	    end
    end
end

function BattleLayerManager:disposeBattleLayerManager()
  instance_ = nil;
  self.layerArr = {};
  if self.layer and self.layer.parent then
    self.scene:removeChild(self.layer)
  end
  self.layer = nil;
end